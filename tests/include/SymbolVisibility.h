/* Copyright (c) 2017,2018 Felix Kutzner (github.com/fkutzner)

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.

 Except as contained in this notice, the name(s) of the above copyright holders
 shall not be used in advertising or otherwise to promote the sale, use or
 other dealings in this Software without prior written authorization.
*/

#pragma once

/* clang-format off */
#if defined(NM_SHARED_LIB)
    #if defined(_WIN32) || defined(__CYGWIN__)
        #if defined(BUILDING_NM_SHARED_LIB)
            #if defined(__GNUC__)
                #define NM_PUBLIC_API __attribute__((dllexport))
            #elif defined(_MSC_VER)
                #define NM_PUBLIC_API __declspec(dllexport)
            #endif
        #else
            #if defined(__GNUC__)
                #define NM_PUBLIC_API __attribute__((dllimport))
            #elif defined(_MSC_VER)
                #define NM_PUBLIC_API __declspec(dllimport)
            #endif
        #endif
    #elif defined(__GNUC__)
        #define NM_PUBLIC_API __attribute__((visibility("default")))
    #endif

    #if !defined(NM_PUBLIC_API)
        #warning "Unknown compiler. Not adding visibility information to exported symbols."
    #endif
#else
    #define NM_PUBLIC_API
#endif
/* clang-format on */
