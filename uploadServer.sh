#bin/bash

./4zip.sh

#upload to api6 server
scp zeroner_blesdk_iOS.zip scow@api6.iwown.com:/usr/local/nginx_ssl/html/
echo 'Finished upload to api6'
 
