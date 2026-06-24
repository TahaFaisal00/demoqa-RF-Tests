*** Variables ***
${BASE_URL}             https://demoqa.com/
${ALIAS}                demoqa
${CREATE_ACCOUNT_API}           /Account/v1/User
${GENERATE_TOKEN_API}           /Account/v1/GenerateToken
${DELETE_ACCOUNT_API}           /Account/v1/User/{}
${CHECK_ACCOUNT_AUTHORIZATION_API}           /Account/v1/Authorized
${GET_ACCOUNT_DETAILS_API}                  /Account/v1/User/{}

${INVALID_TOKEN}                            xxx
${INVALID_ACCOUNT_ID}                       11111

${OK_CODE}                                  200
${BAD_REQUEST_CODE}                         400
${NOT_AUTHORIZED_CODE}                      401
${NOT_FOUND_CODE}                           404
${CREATED_CODE}                             201
${NOT_ACCEPTABLE_CODE}                      406
${NO_CONTENT_CODE}                          204
${INTERNAL_SERVER_ERROR_CODE}               500

${MISSING_CREDENTIALS_MESSAGE}              UserName and Password required.
${USER_NOT_FOUND_MESSAGE}                   User not found!
${INCORRECT_USER_ID_MESSAGE}                User Id not correct!
${USER_EXIST_MESSAGE}                       User exists!
${NOT_AUTHORIZED_MESSAGE}                   User not authorized!
${BOOK_ISBN_NOT_AVAILABLE_IN_BOOK_COLLECTION_MESSAGE}          ISBN supplied is not available in Books Collection!
${BOOK_ISBN_NOT_AVAILABLE_IN_USER_COLLECTION_MESSAGE}          ISBN supplied is not available in User's Collection!

${AUTHORIZATION_FIELD_RESULT}               User authorization failed.

${RESPONSE_FIELD_TOKEN}                     token
${RESPONSE_FIELD_USER_ID}                   userID
${RESPONSE_FIELD_USERNAME}                  username
${RESPONSE_FIELD_BOOKS}                     books
${RESPONSE_FIELD_ISBN}                      isbn
${RESPONSE_FIELD_TITLE}                     title
${RESPONSE_FIELD_COLLECTION_OF_ISBNS}       collectionOfIsbns

${BOOKSTORE_BOOKS_API}                      /BookStore/v1/Books
${BOOKSTORE_BOOK_API}                       /BookStore/v1/Book
${UPDATE_BOOK_BY_ANOTHER_API}               /BookStore/v1/Books/{}

${GIT_POCKET_GUIDE_ISBN}                    9781449325862
${LEARNING_JAVASCRIPT_DESGIN_PATTERNS_ISBN}      9781449331818
${SPEAKING_JAVA_SCRIPT_ISBN}                     9781449365035
${INVALID_ISBN}                                  1111111111111
${INVALID_USER_ID}                               xxxxxxxxxxxxx

${CONTENT_TYPE_TEXT_HTML}                       text/html















