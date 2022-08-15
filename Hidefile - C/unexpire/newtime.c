#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <dlfcn.h>
#include <dirent.h>

// Name: Sajan Thornhill
// netID: sst76
// RUID: 185008328
// your code for time() goes here
static int first_time = 0;
time_t (*unmodifiedTime)(time_t *);
time_t time(time_t *seconds) {
    long int newtime = 1609625287;
    unmodifiedTime = dlsym(RTLD_NEXT, "time");
    time_t modifiedTime = (time_t) newtime;
    time_t result;
    if(first_time == 0){
        if(seconds){
        *seconds = modifiedTime;
        }
        first_time = 1;
        result = modifiedTime;
    }
    else{
        *seconds = unmodifiedTime(NULL);
        result = unmodifiedTime(NULL);
    }
    return result;
}

