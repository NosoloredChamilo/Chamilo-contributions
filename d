[1mdiff --git a/plugin/buycourses/src/buy_course_plugin.class.php b/plugin/buycourses/src/buy_course_plugin.class.php[m
[1mindex 62cdf04f54..1476f7fa85 100644[m
[1m--- a/plugin/buycourses/src/buy_course_plugin.class.php[m
[1m+++ b/plugin/buycourses/src/buy_course_plugin.class.php[m
[36m@@ -41,6 +41,7 @@[m [mclass BuyCoursesPlugin extends Plugin[m
     const TABLE_COUPON_SERVICE_SALE = 'plugin_buycourses_coupon_rel_service_sale';    [m
     const PRODUCT_TYPE_COURSE = 1;[m
     const PRODUCT_TYPE_SESSION = 2;[m
[32m+[m[32m    const PRODUCT_TYPE_SERVICE = 3;[m
     const PAYMENT_TYPE_PAYPAL = 1;[m
     const PAYMENT_TYPE_TRANSFER = 2;[m
     const PAYMENT_TYPE_CULQI = 3;[m
[36m@@ -3404,4 +3405,94 @@[m [mclass BuyCoursesPlugin extends Plugin[m
             ['id = ?' => (int) $serviceSaleId][m
         );[m
     }[m
[32m+[m
[32m+[m[32m        /**[m
[32m+[m[32m     * Get data of the coupon code.[m
[32m+[m[32m     *[m
[32m+[m[32m     * @param string $couponCode The coupon code code[m
[32m+[m[32m     * @param int $productId The product id[m
[32m+[m[32m     * @param int $productType The product type[m
[32m+[m[32m     *[m
[32m+[m[32m     * @return array The coupon data[m
[32m+[m[32m     */[m
[32m+[m[32m    public function getCoupon($couponCode, $productType, $productId)[m
[32m+[m[32m    {[m
[32m+[m[32m        switch ($productType) {[m
[32m+[m[32m            case self::PRODUCT_TYPE_COURSE || self::PRODUCT_TYPE_SESSION:[m
[32m+[m[32m                $coupon = $this->getDataCoupon($couponCode, $productType, $productId);[m
[32m+[m[32m                break;[m
[32m+[m[32m            case self::PRODUCT_TYPE_SERVICE:[m
[32m+[m[32m                $coupon = $this->getDataCouponService($couponCode, $productId);[m
[32m+[m[32m                break;[m
[32m+[m[32m        }[m
[32m+[m
[32m+[m[32m        return $coupon;[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    /**[m
[32m+[m[32m     * Get data of coupon.[m
[32m+[m[32m     *[m
[32m+[m[32m     * @param string $couponCode The coupon code code[m
[32m+[m[32m     * @param int $productId The product id[m
[32m+[m[32m     * @param int $productType The product type[m
[32m+[m[32m     *[m
[32m+[m[32m     * @return array The coupon data[m
[32m+[m[32m     */[m
[32m+[m[32m    public function getDataCoupon($couponCode, $productType, $productId)[m
[32m+[m[32m    {[m
[32m+[m[32m        $couponTable = Database::get_main_table(self::TABLE_COUPON);[m
[32m+[m[32m        $couponItemTable = Database::get_main_table(self::TABLE_COUPON_ITEM);[m
[32m+[m
[32m+[m[32m        $couponFrom = "[m
[32m+[m[32m            $couponTable c[m
[32m+[m[32m            INNER JOIN $couponItemTable ci[m
[32m+[m[32m                on ci.coupon_id = c.id[m
[32m+[m[32m        ";[m
[32m+[m
[32m+[m[32m        return Database::select([m
[32m+[m[32m            ['c.*'],[m
[32m+[m[32m            $couponFrom,[m
[32m+[m[32m            [[m
[32m+[m[32m                'where' => [[m
[32m+[m[32m                    'c.code = ? AND ' => (string) $couponCode,[m
[32m+[m[32m                    'ci.product_type = ? AND ' => (int) $productType,[m
[32m+[m[32m                    'ci.product_id = ?' => (int) $productId,[m
[32m+[m[32m                ],[m
[32m+[m[32m            ],[m
[32m+[m[32m            'first'[m
[32m+[m[32m        );[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    /**[m
[32m+[m[32m     * Get data of coupon.[m
[32m+[m[32m     *[m
[32m+[m[32m     * @param string $couponCode The coupon code code[m
[32m+[m[32m     * @param int $productId The product id[m
[32m+[m[32m     * @param int $productType The product type[m
[32m+[m[32m     *[m
[32m+[m[32m     * @return array The coupon data[m
[32m+[m[32m     */[m
[32m+[m[32m    public function getDataCouponService($couponCode, $productId)[m
[32m+[m[32m    {[m
[32m+[m[32m        $couponTable = Database::get_main_table(self::TABLE_COUPON);[m
[32m+[m[32m        $couponServiceTable = Database::get_main_table(self::TABLE_COUPON_SERVICE);[m
[32m+[m
[32m+[m[32m        $couponFrom = "[m
[32m+[m[32m            $couponTable c[m
[32m+[m[32m            INNER JOIN $couponServiceTable cs[m
[32m+[m[32m                on cs.coupon_id = c.id[m
[32m+[m[32m        ";[m
[32m+[m
[32m+[m[32m        return Database::select([m
[32m+[m[32m            ['c.*'],[m
[32m+[m[32m            $couponFrom,[m
[32m+[m[32m            [[m
[32m+[m[32m                'where' => [[m
[32m+[m[32m                    'c.code = ? AND ' => (string) $couponCode,[m
[32m+[m[32m                    'cs.service_id = ?' => (int) $productId,[m
[32m+[m[32m                ],[m
[32m+[m[32m            ],[m
[32m+[m[32m            'first'[m
[32m+[m[32m        );[m
[32m+[m[32m    }[m
 }[m
[1mdiff --git a/plugin/buycourses/src/process.php b/plugin/buycourses/src/process.php[m
[1mindex 5ff28cdf73..a5b4c4cb00 100644[m
[1m--- a/plugin/buycourses/src/process.php[m
[1m+++ b/plugin/buycourses/src/process.php[m
[36m@@ -34,6 +34,16 @@[m [m$buyingCourse = intval($_REQUEST['t']) === BuyCoursesPlugin::PRODUCT_TYPE_COURSE[m
 $buyingSession = intval($_REQUEST['t']) === BuyCoursesPlugin::PRODUCT_TYPE_SESSION;[m
 $queryString = 'i='.intval($_REQUEST['i']).'&t='.intval($_REQUEST['t']);[m
 [m
[32m+[m[32mif (isset($_REQUEST['c'])) {[m
[32m+[m[32m    $couponCode = $_REQUEST['c'];[m
[32m+[m[32m    if ($buyingCourse) {[m
[32m+[m[32m        $coupon = $plugin->getCoupon($couponCode, BuyCoursesPlugin::PRODUCT_TYPE_COURSE, $_REQUEST['i']);[m
[32m+[m[32m    }[m
[32m+[m[32m    else {[m
[32m+[m[32m        $coupon = $plugin->getCoupon($couponCode, BuyCoursesPlugin::PRODUCT_TYPE_SESSION, $_REQUEST['i']);[m
[32m+[m[32m    }[m
[32m+[m[32m}[m
[32m+[m
 if (empty($currentUserId)) {[m
     Session::write('buy_course_redirect', api_get_self().'?'.$queryString);[m
     header('Location: '.api_get_path(WEB_CODE_PATH).'auth/inscription.php');[m
