<?php
/* For license terms, see /license.txt */

use Chamilo\PluginBundle\Zoom\MeetingEntity;

if (!isset($returnURL)) {
    exit;
}

$course_plugin = 'zoom'; // needed in order to load the plugin lang variables

$logInfo = [
    'tool' => 'Videoconference Zoom',
];

Event::registerLog($logInfo);

$interbreadcrumb[] = [ // used in templates
    'url' => $returnURL,
    'name' => get_lang('ZoomVideoConferences'),
];

if (!array_key_exists('meetingId', $_REQUEST)) {
    throw new Exception('MeetingNotFound');
}
$plugin = ZoomPlugin::create();

/** @var MeetingEntity $meeting */
$meeting = $plugin->getMeetingRepository()->find($_REQUEST['meetingId']);
if (is_null($meeting)) {
    throw new Exception('MeetingNotFound');
}

$tpl = new Template($meeting->getId());

if ($plugin->userIsConferenceManager($meeting)) {
    // user can edit, start and delete meeting
    $tpl->assign('isConferenceManager', true);
    $tpl->assign('editMeetingForm', $plugin->getEditMeetingForm($meeting)->returnForm());
    $tpl->assign('deleteMeetingForm', $plugin->getDeleteMeetingForm($meeting, $returnURL)->returnForm());
    if ($plugin->get('enableParticipantRegistration') && $meeting->requiresRegistration()) {
        $tpl->assign('registerParticipantForm', $plugin->getRegisterParticipantForm($meeting)->returnForm());
        $tpl->assign('registrants', $meeting->getRegistrants());
    }
    if ($plugin->get('enableCloudRecording')
        && $meeting->hasCloudAutoRecordingEnabled()
        // && 'finished' === $meeting->status
    ) {
        $tpl->assign('fileForm', $plugin->getFileForm($meeting)->returnForm());
        $tpl->assign('recordings', $meeting->getRecordings());
    }
} elseif ($meeting->requiresRegistration()) {
    $userId = api_get_user_id();
    try {
        foreach ($meeting->getRegistrants() as $registrant) {
            if ($registrant->userId == $userId) {
                $tpl->assign('currentUserJoinURL', $registrant->join_url);
                break;
            }
        }
    } catch (Exception $exception) {
        Display::addFlash(
            Display::return_message($exception->getMessage(), 'error')
        );
    }
}
$tpl->assign('meeting', $meeting);
$tpl->assign('content', $tpl->fetch('zoom/view/meeting.tpl'));
$tpl->display_one_col_template();