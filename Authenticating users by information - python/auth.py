import pickle
import itertools
import sys
import os

userFileWrite = open("users.txt", 'a+')
userFileRead= open("users.txt", 'r+')
domainsPickleList = "domains.pkl"
typePickleList = "types.pkl"
operationPickleList = "operations.pkl"
domainList = []

def pickleCreate(file_name):
    if os.path.exists(file_name) == False:
        f = open(file_name,'wb')
        pickle.dump(domainList,f)
        f.close()

pickleCreate(domainsPickleList)
pickleCreate(operationPickleList)
pickleCreate(typePickleList)

def pickleWrite(file_name, list):
    with open(file_name,'wb') as wfp:
         pickle.dump(list, wfp)

def pickleRead(file_name):
   with open(file_name, 'rb') as rfp:
    list = pickle.load(rfp)
    return list

def threeArguements(faliure, maxArgs, faliure2):
    try:
        if sys.argv[4] != "":
            print(maxArgs)
            sys.exit(3)
    except IndexError:
        pass
    try:
        info1 = sys.argv[2]
        info2 = sys.argv[3]
        if info1 == "":
            print("Error: missing " + faliure2)
            sys.exit(3)
        if info2 == "":
            print("Error: missing " + faliure)
            sys.exit(3)
    except IndexError:
        print("Error: missing " + faliure)
        sys.exit(3)
    return info1,info2

def fourArguements(faliureA, faliureB, faliureC):
    try: 
        if sys.argv[5] != "":
            print("Too many arguements")
            sys.exit(3)
    except IndexError:
        pass        
    try:
        arg1 = sys.argv[2]
        if arg1 == "":
            print("Error: missing " + faliureA)
            sys.exit(3)
    except IndexError:
        print("Error: missing " + faliureA)
        sys.exit(3)
    try:
        arg2 = sys.argv[3]
        if arg2 == "":
            print("Error: missing " + faliureB)
            sys.exit(3)
    except IndexError:
        print("Error: missing " + faliureB)
        sys.exit(3)
    try:
        arg3 = sys.argv[4]
        if arg3 == "":
            print("Error: missing " + faliureC)
            sys.exit(3)
    except IndexError:
        print("Error: missing " + faliureC)
        sys.exit(3)
    return arg1, arg2, arg3

def twoArguements(faliure, maxArgs):
    try:
        if sys.argv[3] != "":
            print(maxArgs)
            sys.exit(3)
    except:
        pass
    try:
        info = sys.argv[2]
        if info == "":
            print("Error missing " + faliure)
            sys.exit(3)
    except IndexError:
        print("Error missing " + faliure)
        sys.exit(3)
    return info

def UserCheck(faliure, maxArgs):
    endFunc = False
    try:
        if sys.argv[4] != "":
            print(maxArgs)
            endFunc = True
            exit()
    except:
        pass
    if endFunc == False:
        try:
            username = sys.argv[2]
            if username == "":
                print(faliure)
                sys.exit(3)
        except IndexError:
            print(faliure)
            sys.exit(3)
        try:
            password = sys.argv[3]
        except IndexError:
            password = ""
        return username, password
    return None

def find(c, lst):
    for i, domain in enumerate(lst):
        try:
            j = domain.index(c)
        except ValueError:
            continue
        yield i

def UserFind(username):
    while True:
        next_line = userFileRead.readline()
        usernameTemp = next_line.split(":")
        if not next_line:
            return False
        if username == usernameTemp[0]: 
            return True

def AddUser(username, password):
    findUser = UserFind(username)
    if(findUser == False):
        userFileWrite.write( username + ":" + password + "\n")
        print("SUCCESS")
        return
    else:
        print("Error: username exists")
        return

def Authenticate(username, password): 
    while True:
        next_line = userFileRead.readline()
        usernameTemp = next_line.split(':')
        if username == usernameTemp[0]: 
            if password == usernameTemp[1].strip():
                print("SUCCESS")
                return
            else:
                print("Error: bad password")
                return
        if not next_line:
            break
    print("Error: no such user") 

def SetDomain(username, domainName):
    usernameFound = UserFind(username)
    if usernameFound == True:
        tempDomainList = pickleRead(domainsPickleList)
        domainMatches = [match for match in find(domainName, tempDomainList)]
        usernameMatches = [match for match in find(username, tempDomainList)]
        if domainMatches != []:
            if domainMatches[0] in usernameMatches:
                print("SUCCESS")
                return
            else:
                tempDomainList[domainMatches[0]].append(username)
                pickleWrite(domainsPickleList, tempDomainList)
                print("SUCCESS")
                return
        else:
            tempDomainList.append([domainName, username])
            pickleWrite(domainsPickleList, tempDomainList) 
            print("SUCCESS")
            return 
    print("Error: no such user")
    return 

def DomainInfo(domainName):
    tempDomainList = pickleRead(domainsPickleList)
    domainMatches = [match for match in find(domainName, tempDomainList)]
    try:
        index = domainMatches[0]
    except IndexError:
        return
    userSublist = tempDomainList[index]
    if domainMatches != []:
        for users in userSublist[1:]:
            print(users)
        return

def SetType(object, type_name):
    tempTypeList = pickleRead(typePickleList)
    typematches = [match for match in find(type_name, tempTypeList)]
    objectMatches = [match for match in find(object, tempTypeList)] 
    if typematches != []:
        if typematches[0] in objectMatches:
            print("SUCCESS")
            return
        else:
            tempTypeList[typematches[0]].append(object)
            pickleWrite(typePickleList, tempTypeList)
            print("SUCCESS")
            return
    else:
        tempTypeList.append([type_name, object])
        pickleWrite(typePickleList, tempTypeList) 
        print("SUCCESS")
        return 

def TypeInfo(typeName):
    tempTypeList = pickleRead(typePickleList)
    matches = [match for match in find(typeName, tempTypeList)]
    try:
        index = matches[0]
    except IndexError:
        return
    typeSublist = tempTypeList[index]
    if matches != []:
        for users in typeSublist[1:]:
            print(users)
        return
    return

def AddAccess(operation, domain_name, type_name):
    tempOperationList = pickleRead(operationPickleList)
    operationMatches = [match for match in find(operation, tempOperationList)]
    domainMatches = [match for match in find(domain_name, tempOperationList)]
    typeMatches = [match for match in find(type_name, tempOperationList)]
    for (a, b, c) in zip(operationMatches, domainMatches, typeMatches):
        if a == b == c:
            print("SUCCESS")
            return
    tempDomainList = pickleRead(domainsPickleList)
    tempTypeList = pickleRead(typePickleList)
    domainMatches = [match for match in find(domain_name, tempDomainList)]
    typeMatches = [match for match in find(type_name, tempTypeList)]
    if domainMatches == []:
        tempDomainList.append([domain_name])
        pickleWrite(domainsPickleList, tempDomainList)
    if typeMatches == []:
        tempTypeList.append([type_name])
        pickleWrite(typePickleList, tempTypeList)
    tempOperationList.append([operation, domain_name, type_name])
    pickleWrite(operationPickleList, tempOperationList)
    print("SUCCESS")
    return

def CanAccess(operations, user, object):
    if UserFind(user) == False:
        print("Error: access denied")
        sys.exit(3)
    tempDomainList = pickleRead(domainsPickleList)
    tempTypeList = pickleRead(typePickleList)
    tempOperationsList = pickleRead(operationPickleList)
    usernameMatches = [match for match in find(user, tempDomainList)]
    objectMatches = [match for match in find(object, tempTypeList)]
    if objectMatches == []:
        print("Error: access denied")
        sys.exit(3)
    for y in usernameMatches:
        for z in objectMatches:
            list = [operations, tempDomainList[y][0], tempTypeList[z][0]]
            if list in tempOperationsList:
                print("SUCCESS")
                return
    print("Error: access denied")
    return

if len(sys.argv) >= 2:
    request = sys.argv[1]
else:
    print("Error: bad input")
    sys.exit(3)

if request == "AddUser":
    userInfo = UserCheck("Error: username missing", "Too many arguements for AddUser")
    if userInfo == None:
        sys.exit(3)
    username = userInfo[0]
    password = userInfo[1]
    AddUser(username, password)

elif request == ("Authenticate"):
    userInfo = UserCheck("Error: missing info", "Too many arguements for Authenticate")
    if userInfo == None:
        sys.exit(3)
    username = userInfo[0]
    password = userInfo[1]
    Authenticate(username, password)

elif request == ("SetDomain"):
    arguements = threeArguements("domain", "Too many arguements for SetDomain","user")
    username = arguements[0]
    domainName = arguements[1]
    SetDomain(username, domainName)

elif request == ("DomainInfo"):
    arguements = twoArguements("domain", "Too many arguements for DomainInfo")
    domainName = arguements
    DomainInfo(domainName)

elif request == ("SetType"):
    arguements = threeArguements("type", "Too many arguements for SetType", "objects")
    object = arguements[0]
    type_name = arguements[1]
    SetType(object, type_name)

elif request == ("TypeInfo"):
    arguements = twoArguements("type", "Too many arguements for TypeInfo")
    typeName = arguements
    TypeInfo(typeName)

elif request == ("AddAccess"):
    arguements = fourArguements("operation", "domain", "type")
    operation = arguements[0]
    domain_name = arguements[1]
    type_name = arguements[2]
    AddAccess(operation, domain_name, type_name)

elif request == ("CanAccess"):
    arguements = fourArguements("operation", "user", "object")
    operation = arguements[0]
    user = arguements[1]
    object = arguements[2]
    CanAccess(operation, user, object)
else: 
    print("Error: bad input")
    sys.exit(3)

userFileWrite.close()
userFileRead.close()

