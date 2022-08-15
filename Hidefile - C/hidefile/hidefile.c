#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <dirent.h>
#include <string.h>

// Name: Sajan Thornhill 
// netID: sst76
// RUID: 185008328
// your code for readdir goes here

struct dirent *(*original_readdir)(DIR *);
struct dirent *readdir(DIR *dirp)
{
    struct dirent *ret;
    original_readdir = dlsym (RTLD_NEXT, "readdir");
    while((ret = original_readdir(dirp)))
    {
        if(strstr(ret->d_name, getenv("HIDDEN")) == 0 ) 
            break;
    }
    return ret;
}
