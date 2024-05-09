1 // SPDX-License-Identifier: MIT
2 
3 /**
4  ________  ___       ________  ________  ___  __    ________      
5 |\   __  \|\  \     |\   __  \|\   ____\|\  \|\  \ |\   ____\     
6 \ \  \|\ /\ \  \    \ \  \|\  \ \  \___|\ \  \/  /|\ \  \___|_    
7  \ \   __  \ \  \    \ \  \\\  \ \  \    \ \   ___  \ \_____  \   
8   \ \  \|\  \ \  \____\ \  \\\  \ \  \____\ \  \\ \  \|____|\  \  
9    \ \_______\ \_______\ \_______\ \_______\ \__\\ \__\____\_\  \ 
10     \|_______|\|_______|\|_______|\|_______|\|__| \|__|\_________\
11                                                       \|_________|
12 https://blocks.io/
13 */
14 
15 pragma solidity >= 0.4.22 <0.9.0;
16 
17 library console {
18 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
19 
20 	function _sendLogPayload(bytes memory payload) private view {
21 		uint256 payloadLength = payload.length;
22 		address consoleAddress = CONSOLE_ADDRESS;
23 		assembly {
24 			let payloadStart := add(payload, 32)
25 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
26 		}
27 	}
28 
29 	function log() internal view {
30 		_sendLogPayload(abi.encodeWithSignature("log()"));
31 	}
32 
33 	function logInt(int p0) internal view {
34 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
35 	}
36 
37 	function logUint(uint p0) internal view {
38 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
39 	}
40 
41 	function logString(string memory p0) internal view {
42 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
43 	}
44 
45 	function logBool(bool p0) internal view {
46 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
47 	}
48 
49 	function logAddress(address p0) internal view {
50 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
51 	}
52 
53 	function logBytes(bytes memory p0) internal view {
54 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
55 	}
56 
57 	function logBytes1(bytes1 p0) internal view {
58 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
59 	}
60 
61 	function logBytes2(bytes2 p0) internal view {
62 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
63 	}
64 
65 	function logBytes3(bytes3 p0) internal view {
66 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
67 	}
68 
69 	function logBytes4(bytes4 p0) internal view {
70 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
71 	}
72 
73 	function logBytes5(bytes5 p0) internal view {
74 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
75 	}
76 
77 	function logBytes6(bytes6 p0) internal view {
78 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
79 	}
80 
81 	function logBytes7(bytes7 p0) internal view {
82 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
83 	}
84 
85 	function logBytes8(bytes8 p0) internal view {
86 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
87 	}
88 
89 	function logBytes9(bytes9 p0) internal view {
90 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
91 	}
92 
93 	function logBytes10(bytes10 p0) internal view {
94 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
95 	}
96 
97 	function logBytes11(bytes11 p0) internal view {
98 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
99 	}
100 
101 	function logBytes12(bytes12 p0) internal view {
102 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
103 	}
104 
105 	function logBytes13(bytes13 p0) internal view {
106 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
107 	}
108 
109 	function logBytes14(bytes14 p0) internal view {
110 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
111 	}
112 
113 	function logBytes15(bytes15 p0) internal view {
114 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
115 	}
116 
117 	function logBytes16(bytes16 p0) internal view {
118 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
119 	}
120 
121 	function logBytes17(bytes17 p0) internal view {
122 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
123 	}
124 
125 	function logBytes18(bytes18 p0) internal view {
126 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
127 	}
128 
129 	function logBytes19(bytes19 p0) internal view {
130 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
131 	}
132 
133 	function logBytes20(bytes20 p0) internal view {
134 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
135 	}
136 
137 	function logBytes21(bytes21 p0) internal view {
138 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
139 	}
140 
141 	function logBytes22(bytes22 p0) internal view {
142 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
143 	}
144 
145 	function logBytes23(bytes23 p0) internal view {
146 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
147 	}
148 
149 	function logBytes24(bytes24 p0) internal view {
150 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
151 	}
152 
153 	function logBytes25(bytes25 p0) internal view {
154 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
155 	}
156 
157 	function logBytes26(bytes26 p0) internal view {
158 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
159 	}
160 
161 	function logBytes27(bytes27 p0) internal view {
162 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
163 	}
164 
165 	function logBytes28(bytes28 p0) internal view {
166 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
167 	}
168 
169 	function logBytes29(bytes29 p0) internal view {
170 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
171 	}
172 
173 	function logBytes30(bytes30 p0) internal view {
174 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
175 	}
176 
177 	function logBytes31(bytes31 p0) internal view {
178 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
179 	}
180 
181 	function logBytes32(bytes32 p0) internal view {
182 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
183 	}
184 
185 	function log(uint p0) internal view {
186 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
187 	}
188 
189 	function log(string memory p0) internal view {
190 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
191 	}
192 
193 	function log(bool p0) internal view {
194 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
195 	}
196 
197 	function log(address p0) internal view {
198 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
199 	}
200 
201 	function log(uint p0, uint p1) internal view {
202 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
203 	}
204 
205 	function log(uint p0, string memory p1) internal view {
206 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
207 	}
208 
209 	function log(uint p0, bool p1) internal view {
210 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
211 	}
212 
213 	function log(uint p0, address p1) internal view {
214 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
215 	}
216 
217 	function log(string memory p0, uint p1) internal view {
218 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
219 	}
220 
221 	function log(string memory p0, string memory p1) internal view {
222 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
223 	}
224 
225 	function log(string memory p0, bool p1) internal view {
226 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
227 	}
228 
229 	function log(string memory p0, address p1) internal view {
230 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
231 	}
232 
233 	function log(bool p0, uint p1) internal view {
234 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
235 	}
236 
237 	function log(bool p0, string memory p1) internal view {
238 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
239 	}
240 
241 	function log(bool p0, bool p1) internal view {
242 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
243 	}
244 
245 	function log(bool p0, address p1) internal view {
246 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
247 	}
248 
249 	function log(address p0, uint p1) internal view {
250 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
251 	}
252 
253 	function log(address p0, string memory p1) internal view {
254 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
255 	}
256 
257 	function log(address p0, bool p1) internal view {
258 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
259 	}
260 
261 	function log(address p0, address p1) internal view {
262 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
263 	}
264 
265 	function log(uint p0, uint p1, uint p2) internal view {
266 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
267 	}
268 
269 	function log(uint p0, uint p1, string memory p2) internal view {
270 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
271 	}
272 
273 	function log(uint p0, uint p1, bool p2) internal view {
274 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
275 	}
276 
277 	function log(uint p0, uint p1, address p2) internal view {
278 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
279 	}
280 
281 	function log(uint p0, string memory p1, uint p2) internal view {
282 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
283 	}
284 
285 	function log(uint p0, string memory p1, string memory p2) internal view {
286 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
287 	}
288 
289 	function log(uint p0, string memory p1, bool p2) internal view {
290 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
291 	}
292 
293 	function log(uint p0, string memory p1, address p2) internal view {
294 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
295 	}
296 
297 	function log(uint p0, bool p1, uint p2) internal view {
298 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
299 	}
300 
301 	function log(uint p0, bool p1, string memory p2) internal view {
302 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
303 	}
304 
305 	function log(uint p0, bool p1, bool p2) internal view {
306 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
307 	}
308 
309 	function log(uint p0, bool p1, address p2) internal view {
310 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
311 	}
312 
313 	function log(uint p0, address p1, uint p2) internal view {
314 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
315 	}
316 
317 	function log(uint p0, address p1, string memory p2) internal view {
318 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
319 	}
320 
321 	function log(uint p0, address p1, bool p2) internal view {
322 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
323 	}
324 
325 	function log(uint p0, address p1, address p2) internal view {
326 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
327 	}
328 
329 	function log(string memory p0, uint p1, uint p2) internal view {
330 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
331 	}
332 
333 	function log(string memory p0, uint p1, string memory p2) internal view {
334 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
335 	}
336 
337 	function log(string memory p0, uint p1, bool p2) internal view {
338 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
339 	}
340 
341 	function log(string memory p0, uint p1, address p2) internal view {
342 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
343 	}
344 
345 	function log(string memory p0, string memory p1, uint p2) internal view {
346 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
347 	}
348 
349 	function log(string memory p0, string memory p1, string memory p2) internal view {
350 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
351 	}
352 
353 	function log(string memory p0, string memory p1, bool p2) internal view {
354 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
355 	}
356 
357 	function log(string memory p0, string memory p1, address p2) internal view {
358 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
359 	}
360 
361 	function log(string memory p0, bool p1, uint p2) internal view {
362 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
363 	}
364 
365 	function log(string memory p0, bool p1, string memory p2) internal view {
366 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
367 	}
368 
369 	function log(string memory p0, bool p1, bool p2) internal view {
370 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
371 	}
372 
373 	function log(string memory p0, bool p1, address p2) internal view {
374 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
375 	}
376 
377 	function log(string memory p0, address p1, uint p2) internal view {
378 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
379 	}
380 
381 	function log(string memory p0, address p1, string memory p2) internal view {
382 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
383 	}
384 
385 	function log(string memory p0, address p1, bool p2) internal view {
386 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
387 	}
388 
389 	function log(string memory p0, address p1, address p2) internal view {
390 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
391 	}
392 
393 	function log(bool p0, uint p1, uint p2) internal view {
394 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
395 	}
396 
397 	function log(bool p0, uint p1, string memory p2) internal view {
398 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
399 	}
400 
401 	function log(bool p0, uint p1, bool p2) internal view {
402 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
403 	}
404 
405 	function log(bool p0, uint p1, address p2) internal view {
406 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
407 	}
408 
409 	function log(bool p0, string memory p1, uint p2) internal view {
410 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
411 	}
412 
413 	function log(bool p0, string memory p1, string memory p2) internal view {
414 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
415 	}
416 
417 	function log(bool p0, string memory p1, bool p2) internal view {
418 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
419 	}
420 
421 	function log(bool p0, string memory p1, address p2) internal view {
422 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
423 	}
424 
425 	function log(bool p0, bool p1, uint p2) internal view {
426 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
427 	}
428 
429 	function log(bool p0, bool p1, string memory p2) internal view {
430 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
431 	}
432 
433 	function log(bool p0, bool p1, bool p2) internal view {
434 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
435 	}
436 
437 	function log(bool p0, bool p1, address p2) internal view {
438 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
439 	}
440 
441 	function log(bool p0, address p1, uint p2) internal view {
442 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
443 	}
444 
445 	function log(bool p0, address p1, string memory p2) internal view {
446 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
447 	}
448 
449 	function log(bool p0, address p1, bool p2) internal view {
450 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
451 	}
452 
453 	function log(bool p0, address p1, address p2) internal view {
454 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
455 	}
456 
457 	function log(address p0, uint p1, uint p2) internal view {
458 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
459 	}
460 
461 	function log(address p0, uint p1, string memory p2) internal view {
462 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
463 	}
464 
465 	function log(address p0, uint p1, bool p2) internal view {
466 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
467 	}
468 
469 	function log(address p0, uint p1, address p2) internal view {
470 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
471 	}
472 
473 	function log(address p0, string memory p1, uint p2) internal view {
474 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
475 	}
476 
477 	function log(address p0, string memory p1, string memory p2) internal view {
478 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
479 	}
480 
481 	function log(address p0, string memory p1, bool p2) internal view {
482 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
483 	}
484 
485 	function log(address p0, string memory p1, address p2) internal view {
486 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
487 	}
488 
489 	function log(address p0, bool p1, uint p2) internal view {
490 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
491 	}
492 
493 	function log(address p0, bool p1, string memory p2) internal view {
494 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
495 	}
496 
497 	function log(address p0, bool p1, bool p2) internal view {
498 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
499 	}
500 
501 	function log(address p0, bool p1, address p2) internal view {
502 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
503 	}
504 
505 	function log(address p0, address p1, uint p2) internal view {
506 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
507 	}
508 
509 	function log(address p0, address p1, string memory p2) internal view {
510 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
511 	}
512 
513 	function log(address p0, address p1, bool p2) internal view {
514 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
515 	}
516 
517 	function log(address p0, address p1, address p2) internal view {
518 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
519 	}
520 
521 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
522 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
523 	}
524 
525 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
526 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
527 	}
528 
529 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
530 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
531 	}
532 
533 	function log(uint p0, uint p1, uint p2, address p3) internal view {
534 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
535 	}
536 
537 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
538 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
539 	}
540 
541 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
542 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
543 	}
544 
545 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
546 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
547 	}
548 
549 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
550 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
551 	}
552 
553 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
554 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
555 	}
556 
557 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
558 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
559 	}
560 
561 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
562 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
563 	}
564 
565 	function log(uint p0, uint p1, bool p2, address p3) internal view {
566 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
567 	}
568 
569 	function log(uint p0, uint p1, address p2, uint p3) internal view {
570 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
571 	}
572 
573 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
574 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
575 	}
576 
577 	function log(uint p0, uint p1, address p2, bool p3) internal view {
578 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
579 	}
580 
581 	function log(uint p0, uint p1, address p2, address p3) internal view {
582 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
583 	}
584 
585 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
586 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
587 	}
588 
589 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
590 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
591 	}
592 
593 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
594 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
595 	}
596 
597 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
598 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
599 	}
600 
601 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
602 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
603 	}
604 
605 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
606 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
607 	}
608 
609 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
610 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
611 	}
612 
613 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
614 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
615 	}
616 
617 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
618 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
619 	}
620 
621 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
622 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
623 	}
624 
625 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
626 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
627 	}
628 
629 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
630 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
631 	}
632 
633 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
634 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
635 	}
636 
637 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
638 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
639 	}
640 
641 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
642 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
643 	}
644 
645 	function log(uint p0, string memory p1, address p2, address p3) internal view {
646 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
647 	}
648 
649 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
650 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
651 	}
652 
653 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
654 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
655 	}
656 
657 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
658 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
659 	}
660 
661 	function log(uint p0, bool p1, uint p2, address p3) internal view {
662 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
663 	}
664 
665 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
666 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
667 	}
668 
669 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
670 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
671 	}
672 
673 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
674 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
675 	}
676 
677 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
678 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
679 	}
680 
681 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
682 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
683 	}
684 
685 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
686 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
687 	}
688 
689 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
690 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
691 	}
692 
693 	function log(uint p0, bool p1, bool p2, address p3) internal view {
694 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
695 	}
696 
697 	function log(uint p0, bool p1, address p2, uint p3) internal view {
698 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
699 	}
700 
701 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
702 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
703 	}
704 
705 	function log(uint p0, bool p1, address p2, bool p3) internal view {
706 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
707 	}
708 
709 	function log(uint p0, bool p1, address p2, address p3) internal view {
710 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
711 	}
712 
713 	function log(uint p0, address p1, uint p2, uint p3) internal view {
714 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
715 	}
716 
717 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
718 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
719 	}
720 
721 	function log(uint p0, address p1, uint p2, bool p3) internal view {
722 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
723 	}
724 
725 	function log(uint p0, address p1, uint p2, address p3) internal view {
726 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
727 	}
728 
729 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
730 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
731 	}
732 
733 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
734 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
735 	}
736 
737 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
738 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
739 	}
740 
741 	function log(uint p0, address p1, string memory p2, address p3) internal view {
742 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
743 	}
744 
745 	function log(uint p0, address p1, bool p2, uint p3) internal view {
746 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
747 	}
748 
749 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
750 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
751 	}
752 
753 	function log(uint p0, address p1, bool p2, bool p3) internal view {
754 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
755 	}
756 
757 	function log(uint p0, address p1, bool p2, address p3) internal view {
758 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
759 	}
760 
761 	function log(uint p0, address p1, address p2, uint p3) internal view {
762 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
763 	}
764 
765 	function log(uint p0, address p1, address p2, string memory p3) internal view {
766 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
767 	}
768 
769 	function log(uint p0, address p1, address p2, bool p3) internal view {
770 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
771 	}
772 
773 	function log(uint p0, address p1, address p2, address p3) internal view {
774 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
775 	}
776 
777 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
778 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
779 	}
780 
781 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
782 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
783 	}
784 
785 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
786 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
787 	}
788 
789 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
790 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
791 	}
792 
793 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
794 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
795 	}
796 
797 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
798 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
799 	}
800 
801 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
802 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
803 	}
804 
805 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
806 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
807 	}
808 
809 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
810 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
811 	}
812 
813 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
814 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
815 	}
816 
817 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
818 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
819 	}
820 
821 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
822 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
823 	}
824 
825 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
826 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
827 	}
828 
829 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
830 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
831 	}
832 
833 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
834 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
835 	}
836 
837 	function log(string memory p0, uint p1, address p2, address p3) internal view {
838 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
839 	}
840 
841 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
842 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
843 	}
844 
845 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
846 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
847 	}
848 
849 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
850 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
851 	}
852 
853 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
854 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
855 	}
856 
857 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
858 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
859 	}
860 
861 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
862 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
863 	}
864 
865 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
866 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
867 	}
868 
869 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
870 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
871 	}
872 
873 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
874 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
875 	}
876 
877 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
878 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
879 	}
880 
881 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
882 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
883 	}
884 
885 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
886 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
887 	}
888 
889 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
890 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
891 	}
892 
893 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
894 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
895 	}
896 
897 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
898 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
899 	}
900 
901 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
902 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
903 	}
904 
905 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
906 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
907 	}
908 
909 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
910 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
911 	}
912 
913 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
914 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
915 	}
916 
917 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
918 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
919 	}
920 
921 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
922 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
923 	}
924 
925 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
926 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
927 	}
928 
929 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
930 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
931 	}
932 
933 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
934 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
935 	}
936 
937 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
938 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
939 	}
940 
941 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
942 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
943 	}
944 
945 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
946 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
947 	}
948 
949 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
950 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
951 	}
952 
953 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
954 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
955 	}
956 
957 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
958 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
959 	}
960 
961 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
962 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
963 	}
964 
965 	function log(string memory p0, bool p1, address p2, address p3) internal view {
966 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
967 	}
968 
969 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
970 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
971 	}
972 
973 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
974 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
975 	}
976 
977 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
978 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
979 	}
980 
981 	function log(string memory p0, address p1, uint p2, address p3) internal view {
982 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
983 	}
984 
985 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
986 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
987 	}
988 
989 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
990 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
991 	}
992 
993 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
994 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
995 	}
996 
997 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
998 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
999 	}
1000 
1001 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
1002 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
1003 	}
1004 
1005 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
1006 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
1007 	}
1008 
1009 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
1010 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
1011 	}
1012 
1013 	function log(string memory p0, address p1, bool p2, address p3) internal view {
1014 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
1015 	}
1016 
1017 	function log(string memory p0, address p1, address p2, uint p3) internal view {
1018 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
1019 	}
1020 
1021 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
1022 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
1023 	}
1024 
1025 	function log(string memory p0, address p1, address p2, bool p3) internal view {
1026 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
1027 	}
1028 
1029 	function log(string memory p0, address p1, address p2, address p3) internal view {
1030 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
1031 	}
1032 
1033 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
1034 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
1035 	}
1036 
1037 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
1038 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
1039 	}
1040 
1041 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
1042 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
1043 	}
1044 
1045 	function log(bool p0, uint p1, uint p2, address p3) internal view {
1046 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
1047 	}
1048 
1049 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
1050 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
1051 	}
1052 
1053 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
1054 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
1055 	}
1056 
1057 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
1058 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
1059 	}
1060 
1061 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
1062 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
1063 	}
1064 
1065 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
1066 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
1067 	}
1068 
1069 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
1070 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
1071 	}
1072 
1073 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
1074 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
1075 	}
1076 
1077 	function log(bool p0, uint p1, bool p2, address p3) internal view {
1078 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
1079 	}
1080 
1081 	function log(bool p0, uint p1, address p2, uint p3) internal view {
1082 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
1083 	}
1084 
1085 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
1086 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
1087 	}
1088 
1089 	function log(bool p0, uint p1, address p2, bool p3) internal view {
1090 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
1091 	}
1092 
1093 	function log(bool p0, uint p1, address p2, address p3) internal view {
1094 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
1095 	}
1096 
1097 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
1098 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
1099 	}
1100 
1101 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
1102 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
1103 	}
1104 
1105 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
1106 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
1107 	}
1108 
1109 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
1110 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
1111 	}
1112 
1113 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
1114 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
1115 	}
1116 
1117 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
1118 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
1119 	}
1120 
1121 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
1122 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
1123 	}
1124 
1125 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
1126 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
1127 	}
1128 
1129 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
1130 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
1131 	}
1132 
1133 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
1134 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
1135 	}
1136 
1137 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
1138 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
1139 	}
1140 
1141 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
1142 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
1143 	}
1144 
1145 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
1146 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
1147 	}
1148 
1149 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
1150 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
1151 	}
1152 
1153 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
1154 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
1155 	}
1156 
1157 	function log(bool p0, string memory p1, address p2, address p3) internal view {
1158 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
1159 	}
1160 
1161 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
1162 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
1163 	}
1164 
1165 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
1166 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
1167 	}
1168 
1169 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
1170 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
1171 	}
1172 
1173 	function log(bool p0, bool p1, uint p2, address p3) internal view {
1174 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
1175 	}
1176 
1177 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
1178 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
1179 	}
1180 
1181 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
1182 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
1183 	}
1184 
1185 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
1186 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
1187 	}
1188 
1189 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
1190 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
1191 	}
1192 
1193 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
1194 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
1195 	}
1196 
1197 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
1198 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
1199 	}
1200 
1201 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
1202 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
1203 	}
1204 
1205 	function log(bool p0, bool p1, bool p2, address p3) internal view {
1206 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
1207 	}
1208 
1209 	function log(bool p0, bool p1, address p2, uint p3) internal view {
1210 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
1211 	}
1212 
1213 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
1214 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
1215 	}
1216 
1217 	function log(bool p0, bool p1, address p2, bool p3) internal view {
1218 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
1219 	}
1220 
1221 	function log(bool p0, bool p1, address p2, address p3) internal view {
1222 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
1223 	}
1224 
1225 	function log(bool p0, address p1, uint p2, uint p3) internal view {
1226 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
1227 	}
1228 
1229 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
1230 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
1231 	}
1232 
1233 	function log(bool p0, address p1, uint p2, bool p3) internal view {
1234 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
1235 	}
1236 
1237 	function log(bool p0, address p1, uint p2, address p3) internal view {
1238 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
1239 	}
1240 
1241 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
1242 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
1243 	}
1244 
1245 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
1246 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
1247 	}
1248 
1249 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
1250 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
1251 	}
1252 
1253 	function log(bool p0, address p1, string memory p2, address p3) internal view {
1254 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
1255 	}
1256 
1257 	function log(bool p0, address p1, bool p2, uint p3) internal view {
1258 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
1259 	}
1260 
1261 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
1262 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
1263 	}
1264 
1265 	function log(bool p0, address p1, bool p2, bool p3) internal view {
1266 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
1267 	}
1268 
1269 	function log(bool p0, address p1, bool p2, address p3) internal view {
1270 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
1271 	}
1272 
1273 	function log(bool p0, address p1, address p2, uint p3) internal view {
1274 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
1275 	}
1276 
1277 	function log(bool p0, address p1, address p2, string memory p3) internal view {
1278 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
1279 	}
1280 
1281 	function log(bool p0, address p1, address p2, bool p3) internal view {
1282 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
1283 	}
1284 
1285 	function log(bool p0, address p1, address p2, address p3) internal view {
1286 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
1287 	}
1288 
1289 	function log(address p0, uint p1, uint p2, uint p3) internal view {
1290 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
1291 	}
1292 
1293 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
1294 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
1295 	}
1296 
1297 	function log(address p0, uint p1, uint p2, bool p3) internal view {
1298 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
1299 	}
1300 
1301 	function log(address p0, uint p1, uint p2, address p3) internal view {
1302 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
1303 	}
1304 
1305 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
1306 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
1307 	}
1308 
1309 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
1310 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
1311 	}
1312 
1313 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
1314 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
1315 	}
1316 
1317 	function log(address p0, uint p1, string memory p2, address p3) internal view {
1318 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
1319 	}
1320 
1321 	function log(address p0, uint p1, bool p2, uint p3) internal view {
1322 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
1323 	}
1324 
1325 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
1326 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
1327 	}
1328 
1329 	function log(address p0, uint p1, bool p2, bool p3) internal view {
1330 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
1331 	}
1332 
1333 	function log(address p0, uint p1, bool p2, address p3) internal view {
1334 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
1335 	}
1336 
1337 	function log(address p0, uint p1, address p2, uint p3) internal view {
1338 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
1339 	}
1340 
1341 	function log(address p0, uint p1, address p2, string memory p3) internal view {
1342 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
1343 	}
1344 
1345 	function log(address p0, uint p1, address p2, bool p3) internal view {
1346 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
1347 	}
1348 
1349 	function log(address p0, uint p1, address p2, address p3) internal view {
1350 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
1351 	}
1352 
1353 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
1354 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
1355 	}
1356 
1357 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
1358 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
1359 	}
1360 
1361 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
1362 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
1363 	}
1364 
1365 	function log(address p0, string memory p1, uint p2, address p3) internal view {
1366 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
1367 	}
1368 
1369 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
1370 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
1371 	}
1372 
1373 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
1374 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
1375 	}
1376 
1377 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
1378 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
1379 	}
1380 
1381 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
1382 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
1383 	}
1384 
1385 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
1386 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
1387 	}
1388 
1389 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
1390 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
1391 	}
1392 
1393 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
1394 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
1395 	}
1396 
1397 	function log(address p0, string memory p1, bool p2, address p3) internal view {
1398 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
1399 	}
1400 
1401 	function log(address p0, string memory p1, address p2, uint p3) internal view {
1402 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
1403 	}
1404 
1405 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
1406 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
1407 	}
1408 
1409 	function log(address p0, string memory p1, address p2, bool p3) internal view {
1410 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
1411 	}
1412 
1413 	function log(address p0, string memory p1, address p2, address p3) internal view {
1414 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
1415 	}
1416 
1417 	function log(address p0, bool p1, uint p2, uint p3) internal view {
1418 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
1419 	}
1420 
1421 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
1422 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
1423 	}
1424 
1425 	function log(address p0, bool p1, uint p2, bool p3) internal view {
1426 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
1427 	}
1428 
1429 	function log(address p0, bool p1, uint p2, address p3) internal view {
1430 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
1431 	}
1432 
1433 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
1434 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
1435 	}
1436 
1437 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
1438 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
1439 	}
1440 
1441 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
1442 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
1443 	}
1444 
1445 	function log(address p0, bool p1, string memory p2, address p3) internal view {
1446 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
1447 	}
1448 
1449 	function log(address p0, bool p1, bool p2, uint p3) internal view {
1450 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
1451 	}
1452 
1453 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
1454 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
1455 	}
1456 
1457 	function log(address p0, bool p1, bool p2, bool p3) internal view {
1458 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
1459 	}
1460 
1461 	function log(address p0, bool p1, bool p2, address p3) internal view {
1462 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
1463 	}
1464 
1465 	function log(address p0, bool p1, address p2, uint p3) internal view {
1466 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
1467 	}
1468 
1469 	function log(address p0, bool p1, address p2, string memory p3) internal view {
1470 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
1471 	}
1472 
1473 	function log(address p0, bool p1, address p2, bool p3) internal view {
1474 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
1475 	}
1476 
1477 	function log(address p0, bool p1, address p2, address p3) internal view {
1478 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
1479 	}
1480 
1481 	function log(address p0, address p1, uint p2, uint p3) internal view {
1482 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
1483 	}
1484 
1485 	function log(address p0, address p1, uint p2, string memory p3) internal view {
1486 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
1487 	}
1488 
1489 	function log(address p0, address p1, uint p2, bool p3) internal view {
1490 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
1491 	}
1492 
1493 	function log(address p0, address p1, uint p2, address p3) internal view {
1494 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
1495 	}
1496 
1497 	function log(address p0, address p1, string memory p2, uint p3) internal view {
1498 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
1499 	}
1500 
1501 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
1502 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
1503 	}
1504 
1505 	function log(address p0, address p1, string memory p2, bool p3) internal view {
1506 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
1507 	}
1508 
1509 	function log(address p0, address p1, string memory p2, address p3) internal view {
1510 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
1511 	}
1512 
1513 	function log(address p0, address p1, bool p2, uint p3) internal view {
1514 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
1515 	}
1516 
1517 	function log(address p0, address p1, bool p2, string memory p3) internal view {
1518 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
1519 	}
1520 
1521 	function log(address p0, address p1, bool p2, bool p3) internal view {
1522 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
1523 	}
1524 
1525 	function log(address p0, address p1, bool p2, address p3) internal view {
1526 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
1527 	}
1528 
1529 	function log(address p0, address p1, address p2, uint p3) internal view {
1530 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
1531 	}
1532 
1533 	function log(address p0, address p1, address p2, string memory p3) internal view {
1534 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
1535 	}
1536 
1537 	function log(address p0, address p1, address p2, bool p3) internal view {
1538 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
1539 	}
1540 
1541 	function log(address p0, address p1, address p2, address p3) internal view {
1542 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
1543 	}
1544 
1545 }
1546 
1547 pragma solidity ^0.8.0;
1548 
1549 /**
1550  * @dev Interface of the ERC777Token standard as defined in the EIP.
1551  *
1552  * This contract uses the
1553  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 registry standard] to let
1554  * token holders and recipients react to token movements by using setting implementers
1555  * for the associated interfaces in said registry. See {IERC1820Registry} and
1556  * {ERC1820Implementer}.
1557  */
1558 interface IERC777 {
1559     /**
1560      * @dev Returns the name of the token.
1561      */
1562     function name() external view returns (string memory);
1563 
1564     /**
1565      * @dev Returns the symbol of the token, usually a shorter version of the
1566      * name.
1567      */
1568     function symbol() external view returns (string memory);
1569 
1570     /**
1571      * @dev Returns the smallest part of the token that is not divisible. This
1572      * means all token operations (creation, movement and destruction) must have
1573      * amounts that are a multiple of this number.
1574      *
1575      * For most token contracts, this value will equal 1.
1576      */
1577     function granularity() external view returns (uint256);
1578 
1579     /**
1580      * @dev Returns the amount of tokens in existence.
1581      */
1582     function totalSupply() external view returns (uint256);
1583 
1584     /**
1585      * @dev Returns the amount of tokens owned by an account (`owner`).
1586      */
1587     function balanceOf(address owner) external view returns (uint256);
1588 
1589     /**
1590      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1591      *
1592      * If send or receive hooks are registered for the caller and `recipient`,
1593      * the corresponding functions will be called with `data` and empty
1594      * `operatorData`. See {IERC777Sender} and {IERC777Recipient}.
1595      *
1596      * Emits a {Sent} event.
1597      *
1598      * Requirements
1599      *
1600      * - the caller must have at least `amount` tokens.
1601      * - `recipient` cannot be the zero address.
1602      * - if `recipient` is a contract, it must implement the {IERC777Recipient}
1603      * interface.
1604      */
1605     function send(address recipient, uint256 amount, bytes calldata data) external;
1606 
1607     /**
1608      * @dev Destroys `amount` tokens from the caller's account, reducing the
1609      * total supply.
1610      *
1611      * If a send hook is registered for the caller, the corresponding function
1612      * will be called with `data` and empty `operatorData`. See {IERC777Sender}.
1613      *
1614      * Emits a {Burned} event.
1615      *
1616      * Requirements
1617      *
1618      * - the caller must have at least `amount` tokens.
1619      */
1620     function burn(uint256 amount, bytes calldata data) external;
1621 
1622     /**
1623      * @dev Returns true if an account is an operator of `tokenHolder`.
1624      * Operators can send and burn tokens on behalf of their owners. All
1625      * accounts are their own operator.
1626      *
1627      * See {operatorSend} and {operatorBurn}.
1628      */
1629     function isOperatorFor(address operator, address tokenHolder) external view returns (bool);
1630 
1631     /**
1632      * @dev Make an account an operator of the caller.
1633      *
1634      * See {isOperatorFor}.
1635      *
1636      * Emits an {AuthorizedOperator} event.
1637      *
1638      * Requirements
1639      *
1640      * - `operator` cannot be calling address.
1641      */
1642     function authorizeOperator(address operator) external;
1643 
1644     /**
1645      * @dev Revoke an account's operator status for the caller.
1646      *
1647      * See {isOperatorFor} and {defaultOperators}.
1648      *
1649      * Emits a {RevokedOperator} event.
1650      *
1651      * Requirements
1652      *
1653      * - `operator` cannot be calling address.
1654      */
1655     function revokeOperator(address operator) external;
1656 
1657     /**
1658      * @dev Returns the list of default operators. These accounts are operators
1659      * for all token holders, even if {authorizeOperator} was never called on
1660      * them.
1661      *
1662      * This list is immutable, but individual holders may revoke these via
1663      * {revokeOperator}, in which case {isOperatorFor} will return false.
1664      */
1665     function defaultOperators() external view returns (address[] memory);
1666 
1667     /**
1668      * @dev Moves `amount` tokens from `sender` to `recipient`. The caller must
1669      * be an operator of `sender`.
1670      *
1671      * If send or receive hooks are registered for `sender` and `recipient`,
1672      * the corresponding functions will be called with `data` and
1673      * `operatorData`. See {IERC777Sender} and {IERC777Recipient}.
1674      *
1675      * Emits a {Sent} event.
1676      *
1677      * Requirements
1678      *
1679      * - `sender` cannot be the zero address.
1680      * - `sender` must have at least `amount` tokens.
1681      * - the caller must be an operator for `sender`.
1682      * - `recipient` cannot be the zero address.
1683      * - if `recipient` is a contract, it must implement the {IERC777Recipient}
1684      * interface.
1685      */
1686     function operatorSend(
1687         address sender,
1688         address recipient,
1689         uint256 amount,
1690         bytes calldata data,
1691         bytes calldata operatorData
1692     ) external;
1693 
1694     /**
1695      * @dev Destroys `amount` tokens from `account`, reducing the total supply.
1696      * The caller must be an operator of `account`.
1697      *
1698      * If a send hook is registered for `account`, the corresponding function
1699      * will be called with `data` and `operatorData`. See {IERC777Sender}.
1700      *
1701      * Emits a {Burned} event.
1702      *
1703      * Requirements
1704      *
1705      * - `account` cannot be the zero address.
1706      * - `account` must have at least `amount` tokens.
1707      * - the caller must be an operator for `account`.
1708      */
1709     function operatorBurn(
1710         address account,
1711         uint256 amount,
1712         bytes calldata data,
1713         bytes calldata operatorData
1714     ) external;
1715 
1716     event Sent(
1717         address indexed operator,
1718         address indexed from,
1719         address indexed to,
1720         uint256 amount,
1721         bytes data,
1722         bytes operatorData
1723     );
1724 
1725     event Minted(address indexed operator, address indexed to, uint256 amount, bytes data, bytes operatorData);
1726 
1727     event Burned(address indexed operator, address indexed from, uint256 amount, bytes data, bytes operatorData);
1728 
1729     event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
1730 
1731     event RevokedOperator(address indexed operator, address indexed tokenHolder);
1732 }
1733 
1734 pragma solidity ^0.8.0;
1735 
1736 /**
1737  * @dev Interface of the ERC777TokensRecipient standard as defined in the EIP.
1738  *
1739  * Accounts can be notified of {IERC777} tokens being sent to them by having a
1740  * contract implement this interface (contract holders can be their own
1741  * implementer) and registering it on the
1742  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 global registry].
1743  *
1744  * See {IERC1820Registry} and {ERC1820Implementer}.
1745  */
1746 interface IERC777Recipient {
1747     /**
1748      * @dev Called by an {IERC777} token contract whenever tokens are being
1749      * moved or created into a registered account (`to`). The type of operation
1750      * is conveyed by `from` being the zero address or not.
1751      *
1752      * This call occurs _after_ the token contract's state is updated, so
1753      * {IERC777-balanceOf}, etc., can be used to query the post-operation state.
1754      *
1755      * This function may revert to prevent the operation from being executed.
1756      */
1757     function tokensReceived(
1758         address operator,
1759         address from,
1760         address to,
1761         uint256 amount,
1762         bytes calldata userData,
1763         bytes calldata operatorData
1764     ) external;
1765 }
1766 
1767 pragma solidity ^0.8.0;
1768 
1769 /**
1770  * @dev Interface of the ERC777TokensSender standard as defined in the EIP.
1771  *
1772  * {IERC777} Token holders can be notified of operations performed on their
1773  * tokens by having a contract implement this interface (contract holders can be
1774  *  their own implementer) and registering it on the
1775  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 global registry].
1776  *
1777  * See {IERC1820Registry} and {ERC1820Implementer}.
1778  */
1779 interface IERC777Sender {
1780     /**
1781      * @dev Called by an {IERC777} token contract whenever a registered holder's
1782      * (`from`) tokens are about to be moved or destroyed. The type of operation
1783      * is conveyed by `to` being the zero address or not.
1784      *
1785      * This call occurs _before_ the token contract's state is updated, so
1786      * {IERC777-balanceOf}, etc., can be used to query the pre-operation state.
1787      *
1788      * This function may revert to prevent the operation from being executed.
1789      */
1790     function tokensToSend(
1791         address operator,
1792         address from,
1793         address to,
1794         uint256 amount,
1795         bytes calldata userData,
1796         bytes calldata operatorData
1797     ) external;
1798 }
1799 
1800 pragma solidity ^0.8.0;
1801 
1802 /**
1803  * @dev Interface of the ERC20 standard as defined in the EIP.
1804  */
1805 interface IERC20 {
1806     /**
1807      * @dev Returns the amount of tokens in existence.
1808      */
1809     function totalSupply() external view returns (uint256);
1810 
1811     /**
1812      * @dev Returns the amount of tokens owned by `account`.
1813      */
1814     function balanceOf(address account) external view returns (uint256);
1815 
1816     /**
1817      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1818      *
1819      * Returns a boolean value indicating whether the operation succeeded.
1820      *
1821      * Emits a {Transfer} event.
1822      */
1823     function transfer(address recipient, uint256 amount) external returns (bool);
1824 
1825     /**
1826      * @dev Returns the remaining number of tokens that `spender` will be
1827      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1828      * zero by default.
1829      *
1830      * This value changes when {approve} or {transferFrom} are called.
1831      */
1832     function allowance(address owner, address spender) external view returns (uint256);
1833 
1834     /**
1835      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1836      *
1837      * Returns a boolean value indicating whether the operation succeeded.
1838      *
1839      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1840      * that someone may use both the old and the new allowance by unfortunate
1841      * transaction ordering. One possible solution to mitigate this race
1842      * condition is to first reduce the spender's allowance to 0 and set the
1843      * desired value afterwards:
1844      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1845      *
1846      * Emits an {Approval} event.
1847      */
1848     function approve(address spender, uint256 amount) external returns (bool);
1849 
1850     /**
1851      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1852      * allowance mechanism. `amount` is then deducted from the caller's
1853      * allowance.
1854      *
1855      * Returns a boolean value indicating whether the operation succeeded.
1856      *
1857      * Emits a {Transfer} event.
1858      */
1859     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1860 
1861     /**
1862      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1863      * another (`to`).
1864      *
1865      * Note that `value` may be zero.
1866      */
1867     event Transfer(address indexed from, address indexed to, uint256 value);
1868 
1869     /**
1870      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1871      * a call to {approve}. `value` is the new allowance.
1872      */
1873     event Approval(address indexed owner, address indexed spender, uint256 value);
1874 }
1875 
1876 pragma solidity ^0.8.0;
1877 
1878 /**
1879  * @dev Collection of functions related to the address type
1880  */
1881 library Address {
1882     /**
1883      * @dev Returns true if `account` is a contract.
1884      *
1885      * [IMPORTANT]
1886      * ====
1887      * It is unsafe to assume that an address for which this function returns
1888      * false is an externally-owned account (EOA) and not a contract.
1889      *
1890      * Among others, `isContract` will return false for the following
1891      * types of addresses:
1892      *
1893      *  - an externally-owned account
1894      *  - a contract in construction
1895      *  - an address where a contract will be created
1896      *  - an address where a contract lived, but was destroyed
1897      * ====
1898      */
1899     function isContract(address account) internal view returns (bool) {
1900         // This method relies on extcodesize, which returns 0 for contracts in
1901         // construction, since the code is only stored at the end of the
1902         // constructor execution.
1903 
1904         uint256 size;
1905         // solhint-disable-next-line no-inline-assembly
1906         assembly { size := extcodesize(account) }
1907         return size > 0;
1908     }
1909 
1910     /**
1911      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1912      * `recipient`, forwarding all available gas and reverting on errors.
1913      *
1914      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1915      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1916      * imposed by `transfer`, making them unable to receive funds via
1917      * `transfer`. {sendValue} removes this limitation.
1918      *
1919      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1920      *
1921      * IMPORTANT: because control is transferred to `recipient`, care must be
1922      * taken to not create reentrancy vulnerabilities. Consider using
1923      * {ReentrancyGuard} or the
1924      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1925      */
1926     function sendValue(address payable recipient, uint256 amount) internal {
1927         require(address(this).balance >= amount, "Address: insufficient balance");
1928 
1929         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
1930         (bool success, ) = recipient.call{ value: amount }("");
1931         require(success, "Address: unable to send value, recipient may have reverted");
1932     }
1933 
1934     /**
1935      * @dev Performs a Solidity function call using a low level `call`. A
1936      * plain`call` is an unsafe replacement for a function call: use this
1937      * function instead.
1938      *
1939      * If `target` reverts with a revert reason, it is bubbled up by this
1940      * function (like regular Solidity function calls).
1941      *
1942      * Returns the raw returned data. To convert to the expected return value,
1943      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1944      *
1945      * Requirements:
1946      *
1947      * - `target` must be a contract.
1948      * - calling `target` with `data` must not revert.
1949      *
1950      * _Available since v3.1._
1951      */
1952     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1953       return functionCall(target, data, "Address: low-level call failed");
1954     }
1955 
1956     /**
1957      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1958      * `errorMessage` as a fallback revert reason when `target` reverts.
1959      *
1960      * _Available since v3.1._
1961      */
1962     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1963         return functionCallWithValue(target, data, 0, errorMessage);
1964     }
1965 
1966     /**
1967      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1968      * but also transferring `value` wei to `target`.
1969      *
1970      * Requirements:
1971      *
1972      * - the calling contract must have an ETH balance of at least `value`.
1973      * - the called Solidity function must be `payable`.
1974      *
1975      * _Available since v3.1._
1976      */
1977     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
1978         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1979     }
1980 
1981     /**
1982      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1983      * with `errorMessage` as a fallback revert reason when `target` reverts.
1984      *
1985      * _Available since v3.1._
1986      */
1987     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
1988         require(address(this).balance >= value, "Address: insufficient balance for call");
1989         require(isContract(target), "Address: call to non-contract");
1990 
1991         // solhint-disable-next-line avoid-low-level-calls
1992         (bool success, bytes memory returndata) = target.call{ value: value }(data);
1993         return _verifyCallResult(success, returndata, errorMessage);
1994     }
1995 
1996     /**
1997      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1998      * but performing a static call.
1999      *
2000      * _Available since v3.3._
2001      */
2002     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
2003         return functionStaticCall(target, data, "Address: low-level static call failed");
2004     }
2005 
2006     /**
2007      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2008      * but performing a static call.
2009      *
2010      * _Available since v3.3._
2011      */
2012     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
2013         require(isContract(target), "Address: static call to non-contract");
2014 
2015         // solhint-disable-next-line avoid-low-level-calls
2016         (bool success, bytes memory returndata) = target.staticcall(data);
2017         return _verifyCallResult(success, returndata, errorMessage);
2018     }
2019 
2020     /**
2021      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2022      * but performing a delegate call.
2023      *
2024      * _Available since v3.4._
2025      */
2026     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
2027         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
2028     }
2029 
2030     /**
2031      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2032      * but performing a delegate call.
2033      *
2034      * _Available since v3.4._
2035      */
2036     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
2037         require(isContract(target), "Address: delegate call to non-contract");
2038 
2039         // solhint-disable-next-line avoid-low-level-calls
2040         (bool success, bytes memory returndata) = target.delegatecall(data);
2041         return _verifyCallResult(success, returndata, errorMessage);
2042     }
2043 
2044     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
2045         if (success) {
2046             return returndata;
2047         } else {
2048             // Look for revert reason and bubble it up if present
2049             if (returndata.length > 0) {
2050                 // The easiest way to bubble the revert reason is using memory via assembly
2051 
2052                 // solhint-disable-next-line no-inline-assembly
2053                 assembly {
2054                     let returndata_size := mload(returndata)
2055                     revert(add(32, returndata), returndata_size)
2056                 }
2057             } else {
2058                 revert(errorMessage);
2059             }
2060         }
2061     }
2062 }
2063 
2064 pragma solidity ^0.8.0;
2065 
2066 /*
2067  * @dev Provides information about the current execution context, including the
2068  * sender of the transaction and its data. While these are generally available
2069  * via msg.sender and msg.data, they should not be accessed in such a direct
2070  * manner, since when dealing with meta-transactions the account sending and
2071  * paying for execution may not be the actual sender (as far as an application
2072  * is concerned).
2073  *
2074  * This contract is only required for intermediate, library-like contracts.
2075  */
2076 abstract contract Context {
2077     function _msgSender() internal view virtual returns (address) {
2078         return msg.sender;
2079     }
2080 
2081     function _msgData() internal view virtual returns (bytes calldata) {
2082         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
2083         return msg.data;
2084     }
2085 }
2086 
2087 pragma solidity ^0.8.0;
2088 
2089 /**
2090  * @dev Interface of the global ERC1820 Registry, as defined in the
2091  * https://eips.ethereum.org/EIPS/eip-1820[EIP]. Accounts may register
2092  * implementers for interfaces in this registry, as well as query support.
2093  *
2094  * Implementers may be shared by multiple accounts, and can also implement more
2095  * than a single interface for each account. Contracts can implement interfaces
2096  * for themselves, but externally-owned accounts (EOA) must delegate this to a
2097  * contract.
2098  *
2099  * {IERC165} interfaces can also be queried via the registry.
2100  *
2101  * For an in-depth explanation and source code analysis, see the EIP text.
2102  */
2103 interface IERC1820Registry {
2104     /**
2105      * @dev Sets `newManager` as the manager for `account`. A manager of an
2106      * account is able to set interface implementers for it.
2107      *
2108      * By default, each account is its own manager. Passing a value of `0x0` in
2109      * `newManager` will reset the manager to this initial state.
2110      *
2111      * Emits a {ManagerChanged} event.
2112      *
2113      * Requirements:
2114      *
2115      * - the caller must be the current manager for `account`.
2116      */
2117     function setManager(address account, address newManager) external;
2118 
2119     /**
2120      * @dev Returns the manager for `account`.
2121      *
2122      * See {setManager}.
2123      */
2124     function getManager(address account) external view returns (address);
2125 
2126     /**
2127      * @dev Sets the `implementer` contract as ``account``'s implementer for
2128      * `interfaceHash`.
2129      *
2130      * `account` being the zero address is an alias for the caller's address.
2131      * The zero address can also be used in `implementer` to remove an old one.
2132      *
2133      * See {interfaceHash} to learn how these are created.
2134      *
2135      * Emits an {InterfaceImplementerSet} event.
2136      *
2137      * Requirements:
2138      *
2139      * - the caller must be the current manager for `account`.
2140      * - `interfaceHash` must not be an {IERC165} interface id (i.e. it must not
2141      * end in 28 zeroes).
2142      * - `implementer` must implement {IERC1820Implementer} and return true when
2143      * queried for support, unless `implementer` is the caller. See
2144      * {IERC1820Implementer-canImplementInterfaceForAddress}.
2145      */
2146     function setInterfaceImplementer(address account, bytes32 _interfaceHash, address implementer) external;
2147 
2148     /**
2149      * @dev Returns the implementer of `interfaceHash` for `account`. If no such
2150      * implementer is registered, returns the zero address.
2151      *
2152      * If `interfaceHash` is an {IERC165} interface id (i.e. it ends with 28
2153      * zeroes), `account` will be queried for support of it.
2154      *
2155      * `account` being the zero address is an alias for the caller's address.
2156      */
2157     function getInterfaceImplementer(address account, bytes32 _interfaceHash) external view returns (address);
2158 
2159     /**
2160      * @dev Returns the interface hash for an `interfaceName`, as defined in the
2161      * corresponding
2162      * https://eips.ethereum.org/EIPS/eip-1820#interface-name[section of the EIP].
2163      */
2164     function interfaceHash(string calldata interfaceName) external pure returns (bytes32);
2165 
2166     /**
2167      * @notice Updates the cache with whether the contract implements an ERC165 interface or not.
2168      * @param account Address of the contract for which to update the cache.
2169      * @param interfaceId ERC165 interface for which to update the cache.
2170      */
2171     function updateERC165Cache(address account, bytes4 interfaceId) external;
2172 
2173     /**
2174      * @notice Checks whether a contract implements an ERC165 interface or not.
2175      * If the result is not cached a direct lookup on the contract address is performed.
2176      * If the result is not cached or the cached value is out-of-date, the cache MUST be updated manually by calling
2177      * {updateERC165Cache} with the contract address.
2178      * @param account Address of the contract to check.
2179      * @param interfaceId ERC165 interface to check.
2180      * @return True if `account` implements `interfaceId`, false otherwise.
2181      */
2182     function implementsERC165Interface(address account, bytes4 interfaceId) external view returns (bool);
2183 
2184     /**
2185      * @notice Checks whether a contract implements an ERC165 interface or not without using nor updating the cache.
2186      * @param account Address of the contract to check.
2187      * @param interfaceId ERC165 interface to check.
2188      * @return True if `account` implements `interfaceId`, false otherwise.
2189      */
2190     function implementsERC165InterfaceNoCache(address account, bytes4 interfaceId) external view returns (bool);
2191 
2192     event InterfaceImplementerSet(address indexed account, bytes32 indexed interfaceHash, address indexed implementer);
2193 
2194     event ManagerChanged(address indexed account, address indexed newManager);
2195 }
2196 
2197 pragma solidity ^0.8.0;
2198 
2199 /**
2200  * @dev Contract module that helps prevent reentrant calls to a function.
2201  *
2202  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2203  * available, which can be applied to functions to make sure there are no nested
2204  * (reentrant) calls to them.
2205  *
2206  * Note that because there is a single `nonReentrant` guard, functions marked as
2207  * `nonReentrant` may not call one another. This can be worked around by making
2208  * those functions `private`, and then adding `external` `nonReentrant` entry
2209  * points to them.
2210  *
2211  * TIP: If you would like to learn more about reentrancy and alternative ways
2212  * to protect against it, check out our blog post
2213  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2214  */
2215 abstract contract ReentrancyGuard {
2216     // Booleans are more expensive than uint256 or any type that takes up a full
2217     // word because each write operation emits an extra SLOAD to first read the
2218     // slot's contents, replace the bits taken up by the boolean, and then write
2219     // back. This is the compiler's defense against contract upgrades and
2220     // pointer aliasing, and it cannot be disabled.
2221 
2222     // The values being non-zero value makes deployment a bit more expensive,
2223     // but in exchange the refund on every call to nonReentrant will be lower in
2224     // amount. Since refunds are capped to a percentage of the total
2225     // transaction's gas, it is best to keep them low in cases like this one, to
2226     // increase the likelihood of the full refund coming into effect.
2227     uint256 private constant _NOT_ENTERED = 1;
2228     uint256 private constant _ENTERED = 2;
2229 
2230     uint256 private _status;
2231 
2232     constructor () {
2233         _status = _NOT_ENTERED;
2234     }
2235 
2236     /**
2237      * @dev Prevents a contract from calling itself, directly or indirectly.
2238      * Calling a `nonReentrant` function from another `nonReentrant`
2239      * function is not supported. It is possible to prevent this from happening
2240      * by making the `nonReentrant` function external, and make it call a
2241      * `private` function that does the actual work.
2242      */
2243     modifier nonReentrant() {
2244         // On the first call to nonReentrant, _notEntered will be true
2245         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2246 
2247         // Any calls to nonReentrant after this point will fail
2248         _status = _ENTERED;
2249 
2250         _;
2251 
2252         // By storing the original value once again, a refund is triggered (see
2253         // https://eips.ethereum.org/EIPS/eip-2200)
2254         _status = _NOT_ENTERED;
2255     }
2256 }
2257 
2258 pragma solidity ^0.8.0;
2259 
2260 /**
2261  * @dev Implementation of the {IERC777} interface.
2262  *
2263  * This implementation is agnostic to the way tokens are created. This means
2264  * that a supply mechanism has to be added in a derived contract using {_mint}.
2265  *
2266  * Support for ERC20 is included in this contract, as specified by the EIP: both
2267  * the ERC777 and ERC20 interfaces can be safely used when interacting with it.
2268  * Both {IERC777-Sent} and {IERC20-Transfer} events are emitted on token
2269  * movements.
2270  *
2271  * Additionally, the {IERC777-granularity} value is hard-coded to `1`, meaning that there
2272  * are no special restrictions in the amount of tokens that created, moved, or
2273  * destroyed. This makes integration with ERC20 applications seamless.
2274  */
2275 contract ERC777 is Context, IERC777, IERC20, ReentrancyGuard {
2276     using Address for address;
2277 
2278     IERC1820Registry constant internal _ERC1820_REGISTRY = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
2279 
2280     mapping(address => uint256) private _balances;
2281 
2282     uint256 private _totalSupply;
2283 
2284     string private _name;
2285     string private _symbol;
2286 
2287     bytes32 private constant _TOKENS_SENDER_INTERFACE_HASH = keccak256("ERC777TokensSender");
2288     bytes32 private constant _TOKENS_RECIPIENT_INTERFACE_HASH = keccak256("ERC777TokensRecipient");
2289 
2290     // This isn't ever read from - it's only used to respond to the defaultOperators query.
2291     address[] private _defaultOperatorsArray;
2292 
2293     // Immutable, but accounts may revoke them (tracked in __revokedDefaultOperators).
2294     mapping(address => bool) private _defaultOperators;
2295 
2296     // For each account, a mapping of its operators and revoked default operators.
2297     mapping(address => mapping(address => bool)) private _operators;
2298     mapping(address => mapping(address => bool)) private _revokedDefaultOperators;
2299 
2300     // ERC20-allowances
2301     mapping (address => mapping (address => uint256)) private _allowances;
2302 
2303     /**
2304      * @dev `defaultOperators` may be an empty array.
2305      */
2306     constructor(
2307         string memory name_,
2308         string memory symbol_,
2309         address[] memory defaultOperators_
2310     ) {
2311         _name = name_;
2312         _symbol = symbol_;
2313 
2314         _defaultOperatorsArray = defaultOperators_;
2315         for (uint256 i = 0; i < defaultOperators_.length; i++) {
2316             _defaultOperators[defaultOperators_[i]] = true;
2317         }
2318 
2319         // register interfaces
2320         _ERC1820_REGISTRY.setInterfaceImplementer(address(this), keccak256("ERC777Token"), address(this));
2321         _ERC1820_REGISTRY.setInterfaceImplementer(address(this), keccak256("ERC20Token"), address(this));
2322     }
2323 
2324     /**
2325      * @dev See {IERC777-name}.
2326      */
2327     function name() public view virtual override returns (string memory) {
2328         return _name;
2329     }
2330 
2331     /**
2332      * @dev See {IERC777-symbol}.
2333      */
2334     function symbol() public view virtual override returns (string memory) {
2335         return _symbol;
2336     }
2337 
2338     /**
2339      * @dev See {ERC20-decimals}.
2340      *
2341      * Always returns 18, as per the
2342      * [ERC777 EIP](https://eips.ethereum.org/EIPS/eip-777#backward-compatibility).
2343      */
2344     function decimals() public pure virtual returns (uint8) {
2345         return 18;
2346     }
2347 
2348     /**
2349      * @dev See {IERC777-granularity}.
2350      *
2351      * This implementation always returns `1`.
2352      */
2353     function granularity() public view virtual override returns (uint256) {
2354         return 1;
2355     }
2356 
2357     /**
2358      * @dev See {IERC777-totalSupply}.
2359      */
2360     function totalSupply() public view virtual override(IERC20, IERC777) returns (uint256) {
2361         return _totalSupply;
2362     }
2363 
2364     /**
2365      * @dev Returns the amount of tokens owned by an account (`tokenHolder`).
2366      */
2367     function balanceOf(address tokenHolder) public view virtual override(IERC20, IERC777) returns (uint256) {
2368         return _balances[tokenHolder];
2369     }
2370 
2371     /**
2372      * @dev See {IERC777-send}.
2373      *
2374      * Also emits a {IERC20-Transfer} event for ERC20 compatibility.
2375      */
2376     function send(address recipient, uint256 amount, bytes memory data) public virtual override  {
2377         _send(_msgSender(), recipient, amount, data, "", true);
2378     }
2379 
2380     /**
2381      * @dev See {IERC20-transfer}.
2382      *
2383      * Unlike `send`, `recipient` is _not_ required to implement the {IERC777Recipient}
2384      * interface if it is a contract.
2385      *
2386      * Also emits a {Sent} event.
2387      */
2388     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
2389         require(recipient != address(0), "ERC777: transfer to the zero address");
2390 
2391         address from = _msgSender();
2392 
2393         _callTokensToSend(from, from, recipient, amount, "", "");
2394 
2395         _move(from, from, recipient, amount, "", "");
2396 
2397         _callTokensReceived(from, from, recipient, amount, "", "", false);
2398 
2399         return true;
2400     }
2401 
2402     /**
2403      * @dev See {IERC777-burn}.
2404      *
2405      * Also emits a {IERC20-Transfer} event for ERC20 compatibility.
2406      */
2407     function burn(uint256 amount, bytes memory data) public virtual override  {
2408         _burn(_msgSender(), amount, data, "");
2409     }
2410 
2411     /**
2412      * @dev See {IERC777-isOperatorFor}.
2413      */
2414     function isOperatorFor(address operator, address tokenHolder) public view virtual override returns (bool) {
2415         return operator == tokenHolder ||
2416             (_defaultOperators[operator] && !_revokedDefaultOperators[tokenHolder][operator]) ||
2417             _operators[tokenHolder][operator];
2418     }
2419 
2420     /**
2421      * @dev See {IERC777-authorizeOperator}.
2422      */
2423     function authorizeOperator(address operator) public virtual override  {
2424         require(_msgSender() != operator, "ERC777: authorizing self as operator");
2425 
2426         if (_defaultOperators[operator]) {
2427             delete _revokedDefaultOperators[_msgSender()][operator];
2428         } else {
2429             _operators[_msgSender()][operator] = true;
2430         }
2431 
2432         emit AuthorizedOperator(operator, _msgSender());
2433     }
2434 
2435     /**
2436      * @dev See {IERC777-revokeOperator}.
2437      */
2438     function revokeOperator(address operator) public virtual override  {
2439         require(operator != _msgSender(), "ERC777: revoking self as operator");
2440 
2441         if (_defaultOperators[operator]) {
2442             _revokedDefaultOperators[_msgSender()][operator] = true;
2443         } else {
2444             delete _operators[_msgSender()][operator];
2445         }
2446 
2447         emit RevokedOperator(operator, _msgSender());
2448     }
2449 
2450     /**
2451      * @dev See {IERC777-defaultOperators}.
2452      */
2453     function defaultOperators() public view virtual override returns (address[] memory) {
2454         return _defaultOperatorsArray;
2455     }
2456 
2457     /**
2458      * @dev See {IERC777-operatorSend}.
2459      *
2460      * Emits {Sent} and {IERC20-Transfer} events.
2461      */
2462     function operatorSend(
2463         address sender,
2464         address recipient,
2465         uint256 amount,
2466         bytes memory data,
2467         bytes memory operatorData
2468     )
2469         public
2470         virtual
2471         override
2472     {
2473         require(isOperatorFor(_msgSender(), sender), "ERC777: caller is not an operator for holder");
2474         _send(sender, recipient, amount, data, operatorData, true);
2475     }
2476 
2477     /**
2478      * @dev See {IERC777-operatorBurn}.
2479      *
2480      * Emits {Burned} and {IERC20-Transfer} events.
2481      */
2482     function operatorBurn(address account, uint256 amount, bytes memory data, bytes memory operatorData) public virtual override {
2483         require(isOperatorFor(_msgSender(), account), "ERC777: caller is not an operator for holder");
2484         _burn(account, amount, data, operatorData);
2485     }
2486 
2487     /**
2488      * @dev See {IERC20-allowance}.
2489      *
2490      * Note that operator and allowance concepts are orthogonal: operators may
2491      * not have allowance, and accounts with allowance may not be operators
2492      * themselves.
2493      */
2494     function allowance(address holder, address spender) public view virtual override returns (uint256) {
2495         return _allowances[holder][spender];
2496     }
2497 
2498     /**
2499      * @dev See {IERC20-approve}.
2500      *
2501      * Note that accounts cannot have allowance issued by their operators.
2502      */
2503     function approve(address spender, uint256 value) public virtual override returns (bool) {
2504         address holder = _msgSender();
2505         _approve(holder, spender, value);
2506         return true;
2507     }
2508 
2509    /**
2510     * @dev See {IERC20-transferFrom}.
2511     *
2512     * Note that operator and allowance concepts are orthogonal: operators cannot
2513     * call `transferFrom` (unless they have allowance), and accounts with
2514     * allowance cannot call `operatorSend` (unless they are operators).
2515     *
2516     * Emits {Sent}, {IERC20-Transfer} and {IERC20-Approval} events.
2517     */
2518     function transferFrom(address holder, address recipient, uint256 amount) public virtual override returns (bool) {
2519         require(recipient != address(0), "ERC777: transfer to the zero address");
2520         require(holder != address(0), "ERC777: transfer from the zero address");
2521 
2522         address spender = _msgSender();
2523 
2524         _callTokensToSend(spender, holder, recipient, amount, "", "");
2525 
2526         _move(spender, holder, recipient, amount, "", "");
2527 
2528         uint256 currentAllowance = _allowances[holder][spender];
2529         require(currentAllowance >= amount, "ERC777: transfer amount exceeds allowance");
2530         _approve(holder, spender, currentAllowance - amount);
2531 
2532         _callTokensReceived(spender, holder, recipient, amount, "", "", false);
2533 
2534         return true;
2535     }
2536 
2537     /**
2538      * @dev Creates `amount` tokens and assigns them to `account`, increasing
2539      * the total supply.
2540      *
2541      * If a send hook is registered for `account`, the corresponding function
2542      * will be called with `operator`, `data` and `operatorData`.
2543      *
2544      * See {IERC777Sender} and {IERC777Recipient}.
2545      *
2546      * Emits {Minted} and {IERC20-Transfer} events.
2547      *
2548      * Requirements
2549      *
2550      * - `account` cannot be the zero address.
2551      * - if `account` is a contract, it must implement the {IERC777Recipient}
2552      * interface.
2553      */
2554     function _mint(
2555         address account,
2556         uint256 amount,
2557         bytes memory userData,
2558         bytes memory operatorData
2559     )
2560         internal
2561         virtual
2562     {
2563         _mint(account, amount, userData, operatorData, true);
2564     }
2565 
2566     /**
2567      * @dev Creates `amount` tokens and assigns them to `account`, increasing
2568      * the total supply.
2569      *
2570      * If `requireReceptionAck` is set to true, and if a send hook is
2571      * registered for `account`, the corresponding function will be called with
2572      * `operator`, `data` and `operatorData`.
2573      *
2574      * See {IERC777Sender} and {IERC777Recipient}.
2575      *
2576      * Emits {Minted} and {IERC20-Transfer} events.
2577      *
2578      * Requirements
2579      *
2580      * - `account` cannot be the zero address.
2581      * - if `account` is a contract, it must implement the {IERC777Recipient}
2582      * interface.
2583      */
2584     function _mint(
2585         address account,
2586         uint256 amount,
2587         bytes memory userData,
2588         bytes memory operatorData,
2589         bool requireReceptionAck
2590     )
2591         internal
2592         virtual
2593     {
2594         require(account != address(0), "ERC777: mint to the zero address");
2595 
2596         address operator = _msgSender();
2597 
2598         _beforeTokenTransfer(operator, address(0), account, amount);
2599 
2600         // Update state variables
2601         _totalSupply += amount;
2602         _balances[account] += amount;
2603 
2604         _callTokensReceived(operator, address(0), account, amount, userData, operatorData, requireReceptionAck);
2605 
2606         emit Minted(operator, account, amount, userData, operatorData);
2607         emit Transfer(address(0), account, amount);
2608     }
2609 
2610     /**
2611      * @dev Send tokens
2612      * @param from address token holder address
2613      * @param to address recipient address
2614      * @param amount uint256 amount of tokens to transfer
2615      * @param userData bytes extra information provided by the token holder (if any)
2616      * @param operatorData bytes extra information provided by the operator (if any)
2617      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
2618      */
2619     function _send(
2620         address from,
2621         address to,
2622         uint256 amount,
2623         bytes memory userData,
2624         bytes memory operatorData,
2625         bool requireReceptionAck
2626     )
2627         internal
2628         virtual
2629     {
2630         require(from != address(0), "ERC777: send from the zero address");
2631         require(to != address(0), "ERC777: send to the zero address");
2632 
2633         address operator = _msgSender();
2634 
2635         _callTokensToSend(operator, from, to, amount, userData, operatorData);
2636 
2637         _move(operator, from, to, amount, userData, operatorData);
2638 
2639         _callTokensReceived(operator, from, to, amount, userData, operatorData, requireReceptionAck);
2640     }
2641 
2642     /**
2643      * @dev Burn tokens
2644      * @param from address token holder address
2645      * @param amount uint256 amount of tokens to burn
2646      * @param data bytes extra information provided by the token holder
2647      * @param operatorData bytes extra information provided by the operator (if any)
2648      */
2649     function _burn(
2650         address from,
2651         uint256 amount,
2652         bytes memory data,
2653         bytes memory operatorData
2654     )
2655         internal
2656         virtual
2657     {
2658         require(from != address(0), "ERC777: burn from the zero address");
2659 
2660         address operator = _msgSender();
2661 
2662         _callTokensToSend(operator, from, address(0), amount, data, operatorData);
2663 
2664         _beforeTokenTransfer(operator, from, address(0), amount);
2665 
2666         // Update state variables
2667         uint256 fromBalance = _balances[from];
2668         require(fromBalance >= amount, "ERC777: burn amount exceeds balance");
2669         _balances[from] = fromBalance - amount;
2670         _totalSupply -= amount;
2671 
2672         emit Burned(operator, from, amount, data, operatorData);
2673         emit Transfer(from, address(0), amount);
2674     }
2675 
2676     function _move(
2677         address operator,
2678         address from,
2679         address to,
2680         uint256 amount,
2681         bytes memory userData,
2682         bytes memory operatorData
2683     )
2684         private
2685     {
2686         _beforeTokenTransfer(operator, from, to, amount);
2687 
2688         uint256 fromBalance = _balances[from];
2689         require(fromBalance >= amount, "ERC777: transfer amount exceeds balance");
2690         _balances[from] = fromBalance - amount;
2691         _balances[to] += amount;
2692 
2693         emit Sent(operator, from, to, amount, userData, operatorData);
2694         emit Transfer(from, to, amount);
2695     }
2696 
2697     /**
2698      * @dev See {ERC20-_approve}.
2699      *
2700      * Note that accounts cannot have allowance issued by their operators.
2701      */
2702     function _approve(address holder, address spender, uint256 value) internal {
2703         require(holder != address(0), "ERC777: approve from the zero address");
2704         require(spender != address(0), "ERC777: approve to the zero address");
2705 
2706         _allowances[holder][spender] = value;
2707         emit Approval(holder, spender, value);
2708     }
2709 
2710     /**
2711      * @dev Call from.tokensToSend() if the interface is registered
2712      * @param operator address operator requesting the transfer
2713      * @param from address token holder address
2714      * @param to address recipient address
2715      * @param amount uint256 amount of tokens to transfer
2716      * @param userData bytes extra information provided by the token holder (if any)
2717      * @param operatorData bytes extra information provided by the operator (if any)
2718      */
2719     function _callTokensToSend(
2720         address operator,
2721         address from,
2722         address to,
2723         uint256 amount,
2724         bytes memory userData,
2725         bytes memory operatorData
2726     )
2727         private nonReentrant
2728     {
2729         address implementer = _ERC1820_REGISTRY.getInterfaceImplementer(from, _TOKENS_SENDER_INTERFACE_HASH);
2730         if (implementer != address(0)) {
2731             IERC777Sender(implementer).tokensToSend(operator, from, to, amount, userData, operatorData);
2732         }
2733     }
2734 
2735     /**
2736      * @dev Call to.tokensReceived() if the interface is registered. Reverts if the recipient is a contract but
2737      * tokensReceived() was not registered for the recipient
2738      * @param operator address operator requesting the transfer
2739      * @param from address token holder address
2740      * @param to address recipient address
2741      * @param amount uint256 amount of tokens to transfer
2742      * @param userData bytes extra information provided by the token holder (if any)
2743      * @param operatorData bytes extra information provided by the operator (if any)
2744      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
2745      */
2746     function _callTokensReceived(
2747         address operator,
2748         address from,
2749         address to,
2750         uint256 amount,
2751         bytes memory userData,
2752         bytes memory operatorData,
2753         bool requireReceptionAck
2754     )
2755         private
2756     {
2757         address implementer = _ERC1820_REGISTRY.getInterfaceImplementer(to, _TOKENS_RECIPIENT_INTERFACE_HASH);
2758         if (implementer != address(0)) {
2759             IERC777Recipient(implementer).tokensReceived(operator, from, to, amount, userData, operatorData);
2760         } else if (requireReceptionAck) {
2761             require(!to.isContract(), "ERC777: token recipient contract has no implementer for ERC777TokensRecipient");
2762         }
2763     }
2764 
2765     /**
2766      * @dev Hook that is called before any token transfer. This includes
2767      * calls to {send}, {transfer}, {operatorSend}, minting and burning.
2768      *
2769      * Calling conditions:
2770      *
2771      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2772      * will be to transferred to `to`.
2773      * - when `from` is zero, `amount` tokens will be minted for `to`.
2774      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
2775      * - `from` and `to` are never both zero.
2776      *
2777      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2778      */
2779     function _beforeTokenTransfer(address operator, address from, address to, uint256 amount) internal virtual { }
2780 }
2781 
2782 pragma solidity ^0.8.0;
2783 
2784 /**
2785  * @dev Contract module which provides a basic access control mechanism, where
2786  * there is an account (an owner) that can be granted exclusive access to
2787  * specific functions.
2788  *
2789  * By default, the owner account will be the one that deploys the contract. This
2790  * can later be changed with {transferOwnership}.
2791  *
2792  * This module is used through inheritance. It will make available the modifier
2793  * `onlyOwner`, which can be applied to your functions to restrict their use to
2794  * the owner.
2795  */
2796 abstract contract Ownable is Context {
2797     address private _owner;
2798 
2799     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2800 
2801     /**
2802      * @dev Initializes the contract setting the deployer as the initial owner.
2803      */
2804     constructor () {
2805         address msgSender = _msgSender();
2806         _owner = msgSender;
2807         emit OwnershipTransferred(address(0), msgSender);
2808     }
2809 
2810     /**
2811      * @dev Returns the address of the current owner.
2812      */
2813     function owner() public view virtual returns (address) {
2814         return _owner;
2815     }
2816 
2817     /**
2818      * @dev Throws if called by any account other than the owner.
2819      */
2820     modifier onlyOwner() {
2821         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2822         _;
2823     }
2824 
2825     /**
2826      * @dev Leaves the contract without owner. It will not be possible to call
2827      * `onlyOwner` functions anymore. Can only be called by the current owner.
2828      *
2829      * NOTE: Renouncing ownership will leave the contract without an owner,
2830      * thereby removing any functionality that is only available to the owner.
2831      */
2832     function renounceOwnership() public virtual onlyOwner {
2833         emit OwnershipTransferred(_owner, address(0));
2834         _owner = address(0);
2835     }
2836 
2837     /**
2838      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2839      * Can only be called by the current owner.
2840      */
2841     function transferOwnership(address newOwner) public virtual onlyOwner {
2842         require(newOwner != address(0), "Ownable: new owner is the zero address");
2843         emit OwnershipTransferred(_owner, newOwner);
2844         _owner = newOwner;
2845     }
2846 }
2847 
2848 pragma solidity >=0.4.22 <0.9.0;
2849 
2850 
2851 contract BLOCKS is ERC777, Ownable {
2852 
2853     constructor(
2854         string memory name,
2855         string memory symbol,
2856         address[] memory defaultOperators,
2857         uint256 initialSupply,
2858         address treasury
2859     ) ERC777(name, symbol, defaultOperators) Ownable(){
2860         _mint(treasury, initialSupply, "", "");
2861     }
2862 
2863     function release(address payable to, uint256 amount) public {
2864          require(msg.sender == owner());
2865          this.transfer(to, amount);
2866     }
2867 }