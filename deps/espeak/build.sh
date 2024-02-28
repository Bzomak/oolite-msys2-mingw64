#! /usr/bin/bash -x

###############################
#
# Configure and build eSpeak
#
# The script expects to be run from the root of the oolite-msys2 repository.
# It expects eSpeak to be downloaded.
#
###############################

# Copy edited files from Oolite
cp ./deps/espeak/gettimeofday.c ./espeak-1.43.03-source/src/
cp ./deps/espeak/Makefile ./espeak-1.43.03-source/src/
cp ./deps/espeak/speak_lib.cpp ./espeak-1.43.03-source/src/
cp ./deps/espeak/speech.h ./espeak-1.43.03-source/src/

# Rename the file <espeakSourceFolder>/src/portaudio19.h to portaudio.h.
mv ./espeak-1.43.03-source/src/portaudio19.h ./espeak-1.43.03-source/src/portaudio.h

# Copy the file speak_lib.h from <espeakSourceFolder>/platforms/windows/windows_dll/src to <espeakSourceFolder>/src.
cp ./espeak-1.43.03-source/platforms/windows/windows_dll/src/speak_lib.h ./espeak-1.43.03-source/src/

###############################

# Fix compile errors

# dictionary.cpp: In function 'void InitGroups(Translator*)':
# dictionary.cpp:163:48: error: cast from 'char*' to 'long int' loses precision [-fpermissive]
#   163 |                         pw = (unsigned int *)(((long)p+4) & ~3);  // advance to next word boundary
#       |                                                ^~~~~~~
sed -i '163 s/long/uintptr_t/' ./espeak-1.43.03-source/src/dictionary.cpp

# synthesize.cpp: In function 'void DoAmplitude(int, unsigned char*)':
# synthesize.cpp:152:16: error: cast from 'unsigned char*' to 'long int' loses precision [-fpermissive]
#   152 |         q[2] = (long)amp_env;
#       |                ^~~~~~~~~~~~~
# synthesize.cpp: In function 'void DoPitch(unsigned char*, int, int)':
# synthesize.cpp:181:16: error: cast from 'unsigned char*' to 'long int' loses precision [-fpermissive]
#   181 |         q[2] = (long)env;
#       |                ^~~~~~~~~
# synthesize.cpp: In function 'int DoSample2(int, int, int, int, int, int)':
# synthesize.cpp:307:24: error: cast from 'unsigned char*' to 'long int' loses precision [-fpermissive]
#   307 |                 q[2] = long(&wavefile_data[index]);
#       |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~
# synthesize.cpp:328:16: error: cast from 'unsigned char*' to 'long int' loses precision [-fpermissive]
# g++ -O2 -DUSE_PORTAUDIO -D PATH_ESPEAK_DATA=\"Resources\" -Id:/msys_x/1.0/mingw/include/pthreads -Wall -pedantic \
#   328 |         q[2] = long(&wavefile_data[index]);
# -I. -D LIBRARY -c -fno-exceptions  voices.cpp  -o x_voices.o
#       |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~
# synthesize.cpp:343:24: error: cast from 'unsigned char*' to 'long int' loses precision [-fpermissive]
#   343 |                 q[2] = long(&wavefile_data[index+x]);
#       |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# synthesize.cpp:359:24: error: cast from 'unsigned char*' to 'long int' loses precision [-fpermissive]
#   359 |                 q[2] = long(&wavefile_data[index+x]);
#       |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# synthesize.cpp: In function 'void SmoothSpect()':
# synthesize.cpp:814:40: error: cast from 'frame_t*' to 'long int' loses precision [-fpermissive]
#   814 |                                 q[3] = (long)frame2;
#       |                                        ^~~~~~~~~~~~
# synthesize.cpp:862:48: error: cast from 'frame_t*' to 'long int' loses precision [-fpermissive]
#   862 |                                         q[2] = (long)frame2;
#       |                                                ^~~~~~~~~~~~
# synthesize.cpp:873:48: error: cast from 'frame_t*' to 'long int' loses precision [-fpermissive]
#   873 |                                         q[2] = (long)frame2;
#       |                                                ^~~~~~~~~~~~
# synthesize.cpp:904:48: error: cast from 'frame_t*' to 'long int' loses precision [-fpermissive]
#   904 |                                         q[2] = (long)frame2;
#       |                                                ^~~~~~~~~~~~
# synthesize.cpp:946:48: error: cast from 'frame_t*' to 'long int' loses precision [-fpermissive]
#   946 |                                         q[3] = (long)frame2;
#       |                                                ^~~~~~~~~~~~
# synthesize.cpp:957:48: error: cast from 'frame_t*' to 'long int' loses precision [-fpermissive]
#   957 |                                         q[3] = (long)frame2;
#       |                                                ^~~~~~~~~~~~
# synthesize.cpp: In function 'int DoSpect2(PHONEME_TAB*, int, FMT_PARAMS*, PHONEME_LIST*, int)':
# synthesize.cpp:1061:48: error: cast from 'frame_t*' to 'long int' loses precision [-fpermissive]
#  1061 |                         wcmdq[last_wcmdq][3] = (long)frame1;
#       |                                                ^~~~~~~~~~~~
# synthesize.cpp:1073:56: error: cast from 'frame_t*' to 'long int' loses precision [-fpermissive]
#  1073 |                                 wcmdq[last_wcmdq][3] = (long)fr;
#       |                                                        ^~~~~~~~
# synthesize.cpp:1138:40: error: cast from 'frame_t*' to 'long int' loses precision [-fpermissive]
#  1138 |                                 q[2] = long(frame1);
#       |                                        ^~~~~~~~~~~~
# synthesize.cpp:1139:40: error: cast from 'frame_t*' to 'long int' loses precision [-fpermissive]
#  1139 |                                 q[3] = long(frame2);
#       |                                        ^~~~~~~~~~~~ 
# synthesize.cpp: In function 'void DoVoiceChange(voice_t*)':
# synthesize.cpp:1175:32: error: cast from 'voice_t*' to 'long int' loses precision [-fpermissive]
#  1175 |         wcmdq[wcmdq_tail][1] = (long)(v2);
#       |                                ^~~~~~~~~~
# synthesize.cpp: In function 'void DoEmbedded(int&, int)':
# synthesize.cpp:1207:64: error: cast from 'char*' to 'long int' loses precision [-fpermissive]
#  1207 |                                         wcmdq[wcmdq_tail][2] = (long)soundicon_tab[value].data + 44;  // skip WAV header
#       |                                                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sed -i '152 s/long/uintptr_t/' ./espeak-1.43.03-source/src/synthesize.cpp
sed -i '181 s/long/uintptr_t/' ./espeak-1.43.03-source/src/synthesize.cpp
sed -i '307 s/long/uintptr_t/' ./espeak-1.43.03-source/src/synthesize.cpp
sed -i '328 s/long/uintptr_t/' ./espeak-1.43.03-source/src/synthesize.cpp
sed -i '343 s/long/uintptr_t/' ./espeak-1.43.03-source/src/synthesize.cpp
sed -i '359 s/long/uintptr_t/' ./espeak-1.43.03-source/src/synthesize.cpp
sed -i '814 s/long/uintptr_t/' ./espeak-1.43.03-source/src/synthesize.cpp
sed -i '862 s/long/uintptr_t/' ./espeak-1.43.03-source/src/synthesize.cpp
sed -i '873 s/long/uintptr_t/' ./espeak-1.43.03-source/src/synthesize.cpp
sed -i '904 s/long/uintptr_t/' ./espeak-1.43.03-source/src/synthesize.cpp
sed -i '946 s/long/uintptr_t/' ./espeak-1.43.03-source/src/synthesize.cpp
sed -i '957 s/long/uintptr_t/' ./espeak-1.43.03-source/src/synthesize.cpp
sed -i '1061 s/long/uintptr_t/' ./espeak-1.43.03-source/src/synthesize.cpp
sed -i '1073 s/long/uintptr_t/' ./espeak-1.43.03-source/src/synthesize.cpp
sed -i '1138 s/long/uintptr_t/' ./espeak-1.43.03-source/src/synthesize.cpp
sed -i '1139 s/long/uintptr_t/' ./espeak-1.43.03-source/src/synthesize.cpp
sed -i '1175 s/long/uintptr_t/' ./espeak-1.43.03-source/src/synthesize.cpp
sed -i '1207 s/long/uintptr_t/' ./espeak-1.43.03-source/src/synthesize.cpp

# In file included from event.cpp:20:
# speech.h:29:30: warning: 'cdecl' attribute only applies to function types [-Wattributes]
#    29 | #define usleep(x)       Sleep((x)/1000)
#       |                              ^
# speech.h:29:30: warning: 'nothrow' attribute ignored [-Wattributes]
# speech.h:29:30: error: 'int Sleep' redeclared as different kind of entity
# In file included from D:/a/_temp/msys64/mingw64/include/winbase.h:35,
#                  from D:/a/_temp/msys64/mingw64/include/windows.h:70,
#                  from speech.h:27:
# D:/a/_temp/msys64/mingw64/include/synchapi.h:127:26: note: previous declaration 'void Sleep(DWORD)'
#   127 |   WINBASEAPI VOID WINAPI Sleep (DWORD dwMilliseconds);
#       |                          ^~~~~
# speech.h:29:33: error: expected primary-expression before ')' token
#    29 | #define usleep(x)       Sleep((x)/1000)
#       |                                 ^
# 

sed -i '29 s/Sleep((x)/Sleep((DWORD)(x)/' ./espeak-1.43.03-source/src/speech.h

###############################

# Build eSpeak
cd espeak-1.43.03-source/src || exit
make -j "$(nproc)" libespeak.dll
