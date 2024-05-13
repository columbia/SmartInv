1 // SPDX-License-Identifier: Apache
2 
3 /*
4     Copyright 2019 dYdX Trading Inc.
5     Licensed under the Apache License, Version 2.0 (the "License");
6     you may not use this file except in compliance with the License.
7     You may obtain a copy of the License at
8     http://www.apache.org/licenses/LICENSE-2.0
9     Unless required by applicable law or agreed to in writing, software
10     distributed under the License is distributed on an "AS IS" BASIS,
11     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
12     See the License for the specific language governing permissions and
13     limitations under the License.
14 */
15 
16 pragma solidity ^0.7.3;
17 
18 /**
19  * @title Require
20  * @author dYdX
21  *
22  * Stringifies parameters to pretty-print revert messages. Costs more gas than regular require()
23  */
24 library Require {
25     // ============ Constants ============
26 
27     uint256 private constant ASCII_ZERO = 48; // '0'
28     uint256 private constant ASCII_RELATIVE_ZERO = 87; // 'a' - 10
29     uint256 private constant ASCII_LOWER_EX = 120; // 'x'
30     bytes2 private constant COLON = 0x3a20; // ': '
31     bytes2 private constant COMMA = 0x2c20; // ', '
32     bytes2 private constant LPAREN = 0x203c; // ' <'
33     byte private constant RPAREN = 0x3e; // '>'
34     uint256 private constant FOUR_BIT_MASK = 0xf;
35 
36     // ============ Library Functions ============
37 
38     function that(
39         bool must,
40         bytes32 file,
41         bytes32 reason
42     )
43     internal
44     pure
45     {
46         if (!must) {
47             revert(
48                 string(
49                     abi.encodePacked(
50                         stringifyTruncated(file),
51                         COLON,
52                         stringifyTruncated(reason)
53                     )
54                 )
55             );
56         }
57     }
58 
59     function that(
60         bool must,
61         bytes32 file,
62         bytes32 reason,
63         uint256 payloadA
64     )
65     internal
66     pure
67     {
68         if (!must) {
69             revert(
70                 string(
71                     abi.encodePacked(
72                         stringifyTruncated(file),
73                         COLON,
74                         stringifyTruncated(reason),
75                         LPAREN,
76                         stringify(payloadA),
77                         RPAREN
78                     )
79                 )
80             );
81         }
82     }
83 
84     function that(
85         bool must,
86         bytes32 file,
87         bytes32 reason,
88         uint256 payloadA,
89         uint256 payloadB
90     )
91     internal
92     pure
93     {
94         if (!must) {
95             revert(
96                 string(
97                     abi.encodePacked(
98                         stringifyTruncated(file),
99                         COLON,
100                         stringifyTruncated(reason),
101                         LPAREN,
102                         stringify(payloadA),
103                         COMMA,
104                         stringify(payloadB),
105                         RPAREN
106                     )
107                 )
108             );
109         }
110     }
111 
112     function that(
113         bool must,
114         bytes32 file,
115         bytes32 reason,
116         address payloadA
117     )
118     internal
119     pure
120     {
121         if (!must) {
122             revert(
123                 string(
124                     abi.encodePacked(
125                         stringifyTruncated(file),
126                         COLON,
127                         stringifyTruncated(reason),
128                         LPAREN,
129                         stringify(payloadA),
130                         RPAREN
131                     )
132                 )
133             );
134         }
135     }
136 
137     function that(
138         bool must,
139         bytes32 file,
140         bytes32 reason,
141         address payloadA,
142         uint256 payloadB
143     )
144     internal
145     pure
146     {
147         if (!must) {
148             revert(
149                 string(
150                     abi.encodePacked(
151                         stringifyTruncated(file),
152                         COLON,
153                         stringifyTruncated(reason),
154                         LPAREN,
155                         stringify(payloadA),
156                         COMMA,
157                         stringify(payloadB),
158                         RPAREN
159                     )
160                 )
161             );
162         }
163     }
164 
165     function that(
166         bool must,
167         bytes32 file,
168         bytes32 reason,
169         address payloadA,
170         uint256 payloadB,
171         uint256 payloadC
172     )
173     internal
174     pure
175     {
176         if (!must) {
177             revert(
178                 string(
179                     abi.encodePacked(
180                         stringifyTruncated(file),
181                         COLON,
182                         stringifyTruncated(reason),
183                         LPAREN,
184                         stringify(payloadA),
185                         COMMA,
186                         stringify(payloadB),
187                         COMMA,
188                         stringify(payloadC),
189                         RPAREN
190                     )
191                 )
192             );
193         }
194     }
195 
196     function that(
197         bool must,
198         bytes32 file,
199         bytes32 reason,
200         bytes32 payloadA
201     )
202     internal
203     pure
204     {
205         if (!must) {
206             revert(
207                 string(
208                     abi.encodePacked(
209                         stringifyTruncated(file),
210                         COLON,
211                         stringifyTruncated(reason),
212                         LPAREN,
213                         stringify(payloadA),
214                         RPAREN
215                     )
216                 )
217             );
218         }
219     }
220 
221     function that(
222         bool must,
223         bytes32 file,
224         bytes32 reason,
225         bytes32 payloadA,
226         uint256 payloadB,
227         uint256 payloadC
228     )
229     internal
230     pure
231     {
232         if (!must) {
233             revert(
234                 string(
235                     abi.encodePacked(
236                         stringifyTruncated(file),
237                         COLON,
238                         stringifyTruncated(reason),
239                         LPAREN,
240                         stringify(payloadA),
241                         COMMA,
242                         stringify(payloadB),
243                         COMMA,
244                         stringify(payloadC),
245                         RPAREN
246                     )
247                 )
248             );
249         }
250     }
251 
252     // ============ Private Functions ============
253 
254     function stringifyTruncated(
255         bytes32 input
256     )
257     private
258     pure
259     returns (bytes memory)
260     {
261         // put the input bytes into the result
262         bytes memory result = abi.encodePacked(input);
263 
264         // determine the length of the input by finding the location of the last non-zero byte
265         for (uint256 i = 32; i > 0; ) {
266             // reverse-for-loops with unsigned integer
267             /* solium-disable-next-line security/no-modify-for-iter-var */
268             i--;
269 
270             // find the last non-zero byte in order to determine the length
271             if (result[i] != 0) {
272                 uint256 length = i + 1;
273 
274                 /* solium-disable-next-line security/no-inline-assembly */
275                 assembly {
276                     mstore(result, length) // r.length = length;
277                 }
278 
279                 return result;
280             }
281         }
282 
283         // all bytes are zero
284         return new bytes(0);
285     }
286 
287     function stringify(
288         uint256 input
289     )
290     private
291     pure
292     returns (bytes memory)
293     {
294         if (input == 0) {
295             return "0";
296         }
297 
298         // get the final string length
299         uint256 j = input;
300         uint256 length;
301         while (j != 0) {
302             length++;
303             j /= 10;
304         }
305 
306         // allocate the string
307         bytes memory bstr = new bytes(length);
308 
309         // populate the string starting with the least-significant character
310         j = input;
311         for (uint256 i = length; i > 0; ) {
312             // reverse-for-loops with unsigned integer
313             /* solium-disable-next-line security/no-modify-for-iter-var */
314             i--;
315 
316             // take last decimal digit
317             bstr[i] = byte(uint8(ASCII_ZERO + (j % 10)));
318 
319             // remove the last decimal digit
320             j /= 10;
321         }
322 
323         return bstr;
324     }
325 
326     function stringify(
327         address input
328     )
329     private
330     pure
331     returns (bytes memory)
332     {
333         uint256 z = uint256(input);
334 
335         // addresses are "0x" followed by 20 bytes of data which take up 2 characters each
336         bytes memory result = new bytes(42);
337 
338         // populate the result with "0x"
339         result[0] = byte(uint8(ASCII_ZERO));
340         result[1] = byte(uint8(ASCII_LOWER_EX));
341 
342         // for each byte (starting from the lowest byte), populate the result with two characters
343         for (uint256 i = 0; i < 20; i++) {
344             // each byte takes two characters
345             uint256 shift = i * 2;
346 
347             // populate the least-significant character
348             result[41 - shift] = char(z & FOUR_BIT_MASK);
349             z = z >> 4;
350 
351             // populate the most-significant character
352             result[40 - shift] = char(z & FOUR_BIT_MASK);
353             z = z >> 4;
354         }
355 
356         return result;
357     }
358 
359     function stringify(
360         bytes32 input
361     )
362     private
363     pure
364     returns (bytes memory)
365     {
366         uint256 z = uint256(input);
367 
368         // bytes32 are "0x" followed by 32 bytes of data which take up 2 characters each
369         bytes memory result = new bytes(66);
370 
371         // populate the result with "0x"
372         result[0] = byte(uint8(ASCII_ZERO));
373         result[1] = byte(uint8(ASCII_LOWER_EX));
374 
375         // for each byte (starting from the lowest byte), populate the result with two characters
376         for (uint256 i = 0; i < 32; i++) {
377             // each byte takes two characters
378             uint256 shift = i * 2;
379 
380             // populate the least-significant character
381             result[65 - shift] = char(z & FOUR_BIT_MASK);
382             z = z >> 4;
383 
384             // populate the most-significant character
385             result[64 - shift] = char(z & FOUR_BIT_MASK);
386             z = z >> 4;
387         }
388 
389         return result;
390     }
391 
392     function char(
393         uint256 input
394     )
395     private
396     pure
397     returns (byte)
398     {
399         // return ASCII digit (0-9)
400         if (input < 10) {
401             return byte(uint8(input + ASCII_ZERO));
402         }
403 
404         // return ASCII letter (a-f)
405         return byte(uint8(input + ASCII_RELATIVE_ZERO));
406     }
407 }