Project 1
Sajan Thornhill

My project is based around a TV subscription service.
General rules - 
if a whitespace is used for a word put the word in quotations eg. "monkey brains"
Words are case sensitive

To start program enter valid command such as -
python3 auth.py Adduser Sajan Thornhill
All files needed will be created in the directory that holds auth.py

General case
python3 auth.py Hello - Error: bad input - Not a function
python3 auth.py - Error: bad input - No arguements

AddUser - 
python3 auth.py Adduser Sajan Thornhill - SUCCESS -  base case
python3 auth.py Adduser Saylor “monkey brains” - SUCCESS - Password with whitespaces have quotations around them
python3 auth.py Adduser Sajan T - Error: username exists - Adding user that already exists
python3 auth.py Adduser John - SUCCESS - User with no password
python3 auth.py Adduser John J - Error: username exists - Checking if this no password is possible
python3 auth.py Adduser - Error: username missing - Missing arguements
python3 auth.py Adduser Sajan Thornhill hello - Too many arguements for AddUser - Too many arguements

Authenticate
python3 auth.py Authenticate Sajan Thornhill - SUCCESS - Successful authentication
python3 auth.py Authenticate Sajan Math - Error: bad password - Bad password
python3 auth.py Authenticate John Doe - Error: bad password - Bad password for no password
python3 auth.py Authenticate John - SUCCESS - Success for no password
python3 auth.py Authenticate John password - Error: no such user - User does not exist
python3 auth.py Authenticate - Error: missing info - missing arguements
python3 auth.py Adduser Sajan Thornhill hello - Too many arguements for Authenticate - Too many arguements

SetDomain
Domains are the viewing capabilties for each user:
premium_user, normal_user, free_user
python3 auth.py SetDomain Sajan premium_user - SUCCESS - adding user to domain 
python3 auth.py SetDomain Sajan premium_user - user already exists in the domain, the command will succeed but take no action. 
python3 auth.py SetDomain Saylor normal_user - SUCCESS - adding user to domain
python3 auth.py SetDomain John free_user - SUCCESS - adding user to domain
python3 auth.py SetDomain Joe normal_user - Error: no such User - adding user that does not exist
python3 auth.py SetDomain Saylor - Error: missing domain - domain name is not specified
python3 auth.py SetDomain - Error: missing domain - not enough arguements
python3 auth.py SetDomain Sajan premium_user hello - Too many arguements for SetDomain - too many arguements, faliure 

DomainInfo
View users in domain 
python3 auth.py DomainInfo premium_user - successful case
python3 auth.py DomainInfo hello_user - Nothing - domain does not exist or is empty
python3 auth.py DomainInfo - Error: missing domain -  if the domain name is an empty string

SetType
Types are the groups in which channels(objects) can be viewed
premium_content, normal_content, free_content
python3 auth.py SetType HBOMax premium_content - SUCCESS - adding object to type
python3 auth.py SetType HBOMax premium_content - SUCCESS - object already exists in the domain, the command will succeed but take no action. 
python3 auth.py SetType Netflix normal_content - SUCCESS - adding object to type
python3 auth.py SetType ABC free_content - SUCCESS - adding object to type
python3 auth.py SetType ABC - Error: - Failure if the object or the type names are empty strings
python3 auth.py SetType - Error: - Failure if the object or the type names are empty strings
python3 auth.py SetType ABC premium_content hello - Too many arguements for SetType - too many arguements, faliure

TypeInfo
View users in domain 
python3 auth.py TypeInfo premium_content - successful case
python3 auth.py TypeInfo hello_content - Nothing - type does not exist or is empty
python3 auth.py TypeInfo - Error: -  if the type name is an empty string

AddAccess
python3 auth.py AddAccess operation domain_name type_name
This function is to add access for users in certain domains for object in certain Types
view, unsubsribe, record 
python3 auth.py AddAccess view premium_user premium_content - SUCCESS - operation was added to the access control matrix
python3 auth.py AddAccess view premium_user premium_content -  not be added a second time but it will not be treated as an error.
python3 auth.py AddAccess view new_user new_content - SUCCESS - If the domain name or type names do not exist then they will be created.
python3 auth.py AddAccess - Error: missing operation - if the operation is null
python3 auth.py AddAccess view - Error: missing domain - if the domain is null
python3 auth.py AddAccess view normal_content - Error: missing type - if the type is null
python3 auth.py AddAccess view normal_user normal_content hello - Too many Arguements - too many arguements, faliure

CanAccess
Test whether a user can perform a specified operation on an object.
python3 auth.py CanAccess view user object
python3 auth.py CanAccess view Sajan HBOMax  - SUCCESS - access is permitted
python3 auth.py CanAccess view Sajan Netflix - Error: access denied - access is not permitted
python3 auth.py CanAccess view Sajan Syfy - Error: access denied - object does not exist
python3 auth.py CanAccess view Johnny HBOMax - Error: access denied - user does not exist
python3 auth.py CanAccess - Error: missing operation 
python3 auth.py CanAccess view - Error: missing user
python3 auth.py CanAccess view Sajan - missing object