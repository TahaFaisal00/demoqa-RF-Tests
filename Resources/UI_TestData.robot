*** Variables ***
${MAIN_FIRST_NAME}                                taha
${MAIN_LAST_NAME}                                 moe
${MAIN_USERNAME}                                  taha001q22
${MAIN_PASSWORD}                                  Taha2001!!
${DELETE_ME_FIRST_NAME}                           Delete
${DELETE_ME_LAST_NAME}                            Me
${INVALID_USER_NAME}                             DeleteMe
${INVALID_PASSWORD}                              Taha2001!!

&{VALID_ACCOUNT}                                  USERNAME=${MAIN_USERNAME}         PASSWORD=${MAIN_PASSWORD}         TEXT=${MAIN_USERNAME}

&{INVALID_ACCOUNT}                                user_name=${INVALID_USER_NAME}     password=${INVALID_PASSWORD}
&{EMPTY_USER_NAME}                                user_name=${EMPTY}                 password=${MAIN_PASSWORD}
&{EMPTY_PASSWORD}                                 user_name=${MAIN_USERNAME}         password=${EMPTY}
&{EMPTY_CREDENTIALS}                              user_name=${EMPTY}                 password=${EMPTY}

&{SEARCH}                                         EMPTY=${EMPTY}    INVALID=xxxxxxxxxx     BOOKNAME=Git Pocket Guide    AUTHOR=Glenn Block et al.   Publisher=No Starch Press
