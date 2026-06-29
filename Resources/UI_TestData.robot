*** Variables ***
${MAIN_USERNAME}                                 taha001q22
${MAIN_PASSWORD}                                 Taha2001!!
${INVALID_USER_NAME}                             DeleteMe
${INVALID_PASSWORD}                              Taha2001!!

&{INVALID_ACCOUNT}                                user_name=${INVALID_USER_NAME}     password=${INVALID_PASSWORD}
&{EMPTY_USER_NAME}                                user_name=${EMPTY}                 password=${MAIN_PASSWORD}
&{EMPTY_PASSWORD}                                 user_name=${MAIN_USERNAME}         password=${EMPTY}
&{EMPTY_CREDENTIALS}                              user_name=${EMPTY}                 password=${EMPTY}

${NONEXISTENT_BOOK_SEARCH}                        xxxxxxxxxx
