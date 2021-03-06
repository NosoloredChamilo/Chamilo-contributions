# Kannel SMS API Wrapper for PHP

This wrapper lets you interact with Kannel without the hassle of having to create any XML or make HTTP calls.

## What's Kannel?

[Kannel][2] is Mediaburst's SMS API.

### Prerequisites

* A [Kannel][2] account

## Usage

Require the Kannel library:

```php
require 'class-Kannel.php';
```

### Sending a message

```php
$kannel = new Kannel( $API_KEY );
$message = array( 'to' => '441234567891', 'message' => 'This is a test!' );
$result = $kannel->send( $message );
```

### Sending multiple messages

We recommend you use batch sizes of 500 messages or fewer. By limiting the batch size it prevents any timeouts when sending.

```php
$kannel = new Kannel( $API_KEY );
$messages = array( 
    array( 'to' => '441234567891', 'message' => 'This is a test!' ),
    array( 'to' => '441234567892', 'message' => 'This is a test 2!' )
);
$results = $kannel->send( $messages );
```

### Handling the response

The responses come back as arrays, these contain the unique Kannel message ID, whether the message worked (`success`), and the original SMS so you can update your database.

    Array
    (
        [id] => VE_164732148
        [success] => 1
        [sms] => Array
            (
                [to] => 441234567891
                [message] => This is a test!
            )

    )

If you send multiple SMS messages in a single send, you'll get back an array of results, one per SMS.

The result will look something like this:

    Array
    (
        [0] => Array
            (
                [id] => VI_143228951
                [success] => 1
                [sms] => Array
                    (
                        [to] => 441234567891
                        [message] => This is a test!
                    )

            )

        [1] => Array
            (
                [id] => VI_143228952
                [success] => 1
                [sms] => Array
                    (
                        [to] => 441234567892
                        [message] => This is a test 2!
                    )

            )

    )

If a message fails, the reason for failure will be set in `error_code` and `error_message`.  

For example, if you send to invalid phone number "abc":

    Array
    (
        [error_code] => 10
        [error_message] => Invalid 'To' Parameter
        [success] => 0
        [sms] => Array
            (
                [to] => abc
                [message] => This is a test!
            )

    )

### Checking your balance

Check your available SMS balance:

```php
$kannel = new Kannel( $API_KEY );
$kannel->checkBalance();
```    

This will return:

    Array 
    (
        [symbol] => ??
        [balance] => 351.91
        [code] => GBP
    )
    
### Handling Errors

The Kannel wrapper will throw a `KannelException` if the entire call failed.

```php
try 
{
    $kannel = new Kannel( 'invalid_key' );
    $message = array( 'to' => 'abc', 'message' => 'This is a test!' );
    $result = $kannel->send( $message );
}
catch( KannelException $e )
{
    print $e->getMessage();
    // Invalid API Key
}
```    

### Advanced Usage

This class has a few additional features that some users may find useful, if these are not set your account defaults will be used.

### Optional Parameters

See the [Kannel Documentation](http://www.kannelsms.com/doc/clever-stuff/xml-interface/send-sms/) for full details on these options.

*   $from [string]

    The from address displayed on a phone when they receive a message

*   $long [boolean]  

    Enable long SMS. A standard text can contain 160 characters, a long SMS supports up to 459.

*   $truncate [nullable boolean]  

    Truncate the message payload if it is too long, if this is set to false, the message will fail if it is too long.

*	$invalid_char_action [string]

	What to do if the message contains an invalid character. Possible values are
	* error			 - Fail the message
	* remove		 - Remove the invalid characters then send
	* replace		 - Replace some common invalid characters such as replacing curved quotes with straight quotes

*   $ssl [boolean, default: true]
  
    Use SSL when making an HTTP request to the Kannel API


### Setting Options

#### Global Options

Options set on the API object will apply to all SMS messages unless specifically overridden.

In this example both messages will be sent from Kannel:

```php
$options = array( 'from' => 'Kannel' );
$kannel = new Kannel( $API_KEY, $options );
$messages = array( 
    array( 'to' => '441234567891', 'message' => 'This is a test!' ),
    array( 'to' => '441234567892', 'message' => 'This is a test 2!' )
);
$results = $kannel->send( $messages );
```

#### Per-message Options

Set option values individually on each message.

In this example, one message will be from Kannel and the other from 84433:

```php
$kannel = new Kannel( $API_KEY, $options );
$messages = array( 
    array( 'to' => '441234567891', 'message' => 'This is a test!', 'from' => 'Kannel' ),
    array( 'to' => '441234567892', 'message' => 'This is a test 2!', 'from' => '84433' )
);
$results = $kannel->send( $messages );
```

### SSL Errors

Due to the huge variety of PHP setups out there a small proportion of users may get PHP errors when making API calls due to their SSL configuration.

The errors will generally look something like this:

```
Fatal error: 
Uncaught exception 'Exception' with message 'HTTP Error calling Kannel API
HTTP Status: 0
cURL Erorr: SSL certificate problem, verify that the CA cert is OK. 
Details: error:14090086:SSL routines:SSL3_GET_SERVER_CERTIFICATE:certificate verify failed'
```

If you're seeing this error there are two fixes available, the first is easy, simply disable SSL on Kannel calls. Alternatively you can setup your PHP install with the correct root certificates.

#### Disable SSL on Kannel calls

```php
$options = array( 'ssl' => false );
$kannel = new Kannel( $API_KEY, $options );
```

#### Setup SSL root certificates on your server

This is much more complicated as it depends on your setup, however there are many guides available online. 
Try a search term like "windows php curl root certificates" or "ubuntu update root certificates".


# License

This project is licensed under the ISC open-source license.

A copy of this license can be found in license.txt.

# Contributing

If you have any feedback on this wrapper drop us an email to [hello@kannelsms.com][1].

The project is hosted on GitHub at [https://github.com/mediaburst/kannel-php][3].
If you would like to contribute a bug fix or improvement please fork the project 
and submit a pull request.

[1]: mailto:hello@kannelsms.com
[2]: http://www.kannelsms.com/
[3]: https://github.com/mediaburst/kannel-php
