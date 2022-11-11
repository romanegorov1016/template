# Use on Jenkins to start selenium server and trash the verbose error messages from webdriver
java -Dwebdriver.chrome.webdriver="/data/app/thirdparty-bin/chromedriver" -jar /opt/selenium/selenium-server-standalone.jar &
# Wait for port 4444 to be listening connections
chmod +x wait-for-it.sh && ./wait-for-it.sh -t 60 127.0.0.1:4444 -- echo "driver is up"

