1 // SPDX-License-Identifier: MIT
2 // File: hardhat/console.sol
3 
4 
5 pragma solidity >= 0.4.22 <0.9.0;
6 
7 library console {
8 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
9 
10 	function _sendLogPayload(bytes memory payload) private view {
11 		uint256 payloadLength = payload.length;
12 		address consoleAddress = CONSOLE_ADDRESS;
13 		assembly {
14 			let payloadStart := add(payload, 32)
15 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
16 		}
17 	}
18 
19 	function log() internal view {
20 		_sendLogPayload(abi.encodeWithSignature("log()"));
21 	}
22 
23 	function logInt(int p0) internal view {
24 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
25 	}
26 
27 	function logUint(uint p0) internal view {
28 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
29 	}
30 
31 	function logString(string memory p0) internal view {
32 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
33 	}
34 
35 	function logBool(bool p0) internal view {
36 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
37 	}
38 
39 	function logAddress(address p0) internal view {
40 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
41 	}
42 
43 	function logBytes(bytes memory p0) internal view {
44 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
45 	}
46 
47 	function logBytes1(bytes1 p0) internal view {
48 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
49 	}
50 
51 	function logBytes2(bytes2 p0) internal view {
52 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
53 	}
54 
55 	function logBytes3(bytes3 p0) internal view {
56 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
57 	}
58 
59 	function logBytes4(bytes4 p0) internal view {
60 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
61 	}
62 
63 	function logBytes5(bytes5 p0) internal view {
64 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
65 	}
66 
67 	function logBytes6(bytes6 p0) internal view {
68 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
69 	}
70 
71 	function logBytes7(bytes7 p0) internal view {
72 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
73 	}
74 
75 	function logBytes8(bytes8 p0) internal view {
76 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
77 	}
78 
79 	function logBytes9(bytes9 p0) internal view {
80 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
81 	}
82 
83 	function logBytes10(bytes10 p0) internal view {
84 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
85 	}
86 
87 	function logBytes11(bytes11 p0) internal view {
88 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
89 	}
90 
91 	function logBytes12(bytes12 p0) internal view {
92 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
93 	}
94 
95 	function logBytes13(bytes13 p0) internal view {
96 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
97 	}
98 
99 	function logBytes14(bytes14 p0) internal view {
100 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
101 	}
102 
103 	function logBytes15(bytes15 p0) internal view {
104 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
105 	}
106 
107 	function logBytes16(bytes16 p0) internal view {
108 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
109 	}
110 
111 	function logBytes17(bytes17 p0) internal view {
112 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
113 	}
114 
115 	function logBytes18(bytes18 p0) internal view {
116 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
117 	}
118 
119 	function logBytes19(bytes19 p0) internal view {
120 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
121 	}
122 
123 	function logBytes20(bytes20 p0) internal view {
124 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
125 	}
126 
127 	function logBytes21(bytes21 p0) internal view {
128 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
129 	}
130 
131 	function logBytes22(bytes22 p0) internal view {
132 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
133 	}
134 
135 	function logBytes23(bytes23 p0) internal view {
136 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
137 	}
138 
139 	function logBytes24(bytes24 p0) internal view {
140 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
141 	}
142 
143 	function logBytes25(bytes25 p0) internal view {
144 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
145 	}
146 
147 	function logBytes26(bytes26 p0) internal view {
148 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
149 	}
150 
151 	function logBytes27(bytes27 p0) internal view {
152 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
153 	}
154 
155 	function logBytes28(bytes28 p0) internal view {
156 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
157 	}
158 
159 	function logBytes29(bytes29 p0) internal view {
160 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
161 	}
162 
163 	function logBytes30(bytes30 p0) internal view {
164 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
165 	}
166 
167 	function logBytes31(bytes31 p0) internal view {
168 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
169 	}
170 
171 	function logBytes32(bytes32 p0) internal view {
172 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
173 	}
174 
175 	function log(uint p0) internal view {
176 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
177 	}
178 
179 	function log(string memory p0) internal view {
180 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
181 	}
182 
183 	function log(bool p0) internal view {
184 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
185 	}
186 
187 	function log(address p0) internal view {
188 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
189 	}
190 
191 	function log(uint p0, uint p1) internal view {
192 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
193 	}
194 
195 	function log(uint p0, string memory p1) internal view {
196 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
197 	}
198 
199 	function log(uint p0, bool p1) internal view {
200 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
201 	}
202 
203 	function log(uint p0, address p1) internal view {
204 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
205 	}
206 
207 	function log(string memory p0, uint p1) internal view {
208 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
209 	}
210 
211 	function log(string memory p0, string memory p1) internal view {
212 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
213 	}
214 
215 	function log(string memory p0, bool p1) internal view {
216 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
217 	}
218 
219 	function log(string memory p0, address p1) internal view {
220 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
221 	}
222 
223 	function log(bool p0, uint p1) internal view {
224 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
225 	}
226 
227 	function log(bool p0, string memory p1) internal view {
228 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
229 	}
230 
231 	function log(bool p0, bool p1) internal view {
232 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
233 	}
234 
235 	function log(bool p0, address p1) internal view {
236 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
237 	}
238 
239 	function log(address p0, uint p1) internal view {
240 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
241 	}
242 
243 	function log(address p0, string memory p1) internal view {
244 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
245 	}
246 
247 	function log(address p0, bool p1) internal view {
248 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
249 	}
250 
251 	function log(address p0, address p1) internal view {
252 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
253 	}
254 
255 	function log(uint p0, uint p1, uint p2) internal view {
256 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
257 	}
258 
259 	function log(uint p0, uint p1, string memory p2) internal view {
260 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
261 	}
262 
263 	function log(uint p0, uint p1, bool p2) internal view {
264 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
265 	}
266 
267 	function log(uint p0, uint p1, address p2) internal view {
268 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
269 	}
270 
271 	function log(uint p0, string memory p1, uint p2) internal view {
272 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
273 	}
274 
275 	function log(uint p0, string memory p1, string memory p2) internal view {
276 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
277 	}
278 
279 	function log(uint p0, string memory p1, bool p2) internal view {
280 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
281 	}
282 
283 	function log(uint p0, string memory p1, address p2) internal view {
284 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
285 	}
286 
287 	function log(uint p0, bool p1, uint p2) internal view {
288 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
289 	}
290 
291 	function log(uint p0, bool p1, string memory p2) internal view {
292 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
293 	}
294 
295 	function log(uint p0, bool p1, bool p2) internal view {
296 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
297 	}
298 
299 	function log(uint p0, bool p1, address p2) internal view {
300 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
301 	}
302 
303 	function log(uint p0, address p1, uint p2) internal view {
304 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
305 	}
306 
307 	function log(uint p0, address p1, string memory p2) internal view {
308 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
309 	}
310 
311 	function log(uint p0, address p1, bool p2) internal view {
312 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
313 	}
314 
315 	function log(uint p0, address p1, address p2) internal view {
316 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
317 	}
318 
319 	function log(string memory p0, uint p1, uint p2) internal view {
320 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
321 	}
322 
323 	function log(string memory p0, uint p1, string memory p2) internal view {
324 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
325 	}
326 
327 	function log(string memory p0, uint p1, bool p2) internal view {
328 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
329 	}
330 
331 	function log(string memory p0, uint p1, address p2) internal view {
332 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
333 	}
334 
335 	function log(string memory p0, string memory p1, uint p2) internal view {
336 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
337 	}
338 
339 	function log(string memory p0, string memory p1, string memory p2) internal view {
340 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
341 	}
342 
343 	function log(string memory p0, string memory p1, bool p2) internal view {
344 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
345 	}
346 
347 	function log(string memory p0, string memory p1, address p2) internal view {
348 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
349 	}
350 
351 	function log(string memory p0, bool p1, uint p2) internal view {
352 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
353 	}
354 
355 	function log(string memory p0, bool p1, string memory p2) internal view {
356 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
357 	}
358 
359 	function log(string memory p0, bool p1, bool p2) internal view {
360 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
361 	}
362 
363 	function log(string memory p0, bool p1, address p2) internal view {
364 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
365 	}
366 
367 	function log(string memory p0, address p1, uint p2) internal view {
368 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
369 	}
370 
371 	function log(string memory p0, address p1, string memory p2) internal view {
372 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
373 	}
374 
375 	function log(string memory p0, address p1, bool p2) internal view {
376 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
377 	}
378 
379 	function log(string memory p0, address p1, address p2) internal view {
380 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
381 	}
382 
383 	function log(bool p0, uint p1, uint p2) internal view {
384 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
385 	}
386 
387 	function log(bool p0, uint p1, string memory p2) internal view {
388 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
389 	}
390 
391 	function log(bool p0, uint p1, bool p2) internal view {
392 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
393 	}
394 
395 	function log(bool p0, uint p1, address p2) internal view {
396 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
397 	}
398 
399 	function log(bool p0, string memory p1, uint p2) internal view {
400 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
401 	}
402 
403 	function log(bool p0, string memory p1, string memory p2) internal view {
404 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
405 	}
406 
407 	function log(bool p0, string memory p1, bool p2) internal view {
408 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
409 	}
410 
411 	function log(bool p0, string memory p1, address p2) internal view {
412 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
413 	}
414 
415 	function log(bool p0, bool p1, uint p2) internal view {
416 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
417 	}
418 
419 	function log(bool p0, bool p1, string memory p2) internal view {
420 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
421 	}
422 
423 	function log(bool p0, bool p1, bool p2) internal view {
424 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
425 	}
426 
427 	function log(bool p0, bool p1, address p2) internal view {
428 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
429 	}
430 
431 	function log(bool p0, address p1, uint p2) internal view {
432 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
433 	}
434 
435 	function log(bool p0, address p1, string memory p2) internal view {
436 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
437 	}
438 
439 	function log(bool p0, address p1, bool p2) internal view {
440 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
441 	}
442 
443 	function log(bool p0, address p1, address p2) internal view {
444 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
445 	}
446 
447 	function log(address p0, uint p1, uint p2) internal view {
448 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
449 	}
450 
451 	function log(address p0, uint p1, string memory p2) internal view {
452 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
453 	}
454 
455 	function log(address p0, uint p1, bool p2) internal view {
456 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
457 	}
458 
459 	function log(address p0, uint p1, address p2) internal view {
460 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
461 	}
462 
463 	function log(address p0, string memory p1, uint p2) internal view {
464 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
465 	}
466 
467 	function log(address p0, string memory p1, string memory p2) internal view {
468 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
469 	}
470 
471 	function log(address p0, string memory p1, bool p2) internal view {
472 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
473 	}
474 
475 	function log(address p0, string memory p1, address p2) internal view {
476 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
477 	}
478 
479 	function log(address p0, bool p1, uint p2) internal view {
480 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
481 	}
482 
483 	function log(address p0, bool p1, string memory p2) internal view {
484 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
485 	}
486 
487 	function log(address p0, bool p1, bool p2) internal view {
488 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
489 	}
490 
491 	function log(address p0, bool p1, address p2) internal view {
492 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
493 	}
494 
495 	function log(address p0, address p1, uint p2) internal view {
496 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
497 	}
498 
499 	function log(address p0, address p1, string memory p2) internal view {
500 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
501 	}
502 
503 	function log(address p0, address p1, bool p2) internal view {
504 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
505 	}
506 
507 	function log(address p0, address p1, address p2) internal view {
508 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
509 	}
510 
511 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
512 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
513 	}
514 
515 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
516 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
517 	}
518 
519 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
520 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
521 	}
522 
523 	function log(uint p0, uint p1, uint p2, address p3) internal view {
524 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
525 	}
526 
527 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
528 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
529 	}
530 
531 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
532 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
533 	}
534 
535 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
536 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
537 	}
538 
539 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
540 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
541 	}
542 
543 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
544 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
545 	}
546 
547 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
548 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
549 	}
550 
551 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
552 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
553 	}
554 
555 	function log(uint p0, uint p1, bool p2, address p3) internal view {
556 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
557 	}
558 
559 	function log(uint p0, uint p1, address p2, uint p3) internal view {
560 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
561 	}
562 
563 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
564 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
565 	}
566 
567 	function log(uint p0, uint p1, address p2, bool p3) internal view {
568 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
569 	}
570 
571 	function log(uint p0, uint p1, address p2, address p3) internal view {
572 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
573 	}
574 
575 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
576 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
577 	}
578 
579 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
580 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
581 	}
582 
583 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
584 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
585 	}
586 
587 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
588 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
589 	}
590 
591 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
592 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
593 	}
594 
595 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
596 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
597 	}
598 
599 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
600 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
601 	}
602 
603 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
604 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
605 	}
606 
607 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
608 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
609 	}
610 
611 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
612 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
613 	}
614 
615 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
616 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
617 	}
618 
619 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
620 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
621 	}
622 
623 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
624 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
625 	}
626 
627 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
628 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
629 	}
630 
631 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
632 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
633 	}
634 
635 	function log(uint p0, string memory p1, address p2, address p3) internal view {
636 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
637 	}
638 
639 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
640 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
641 	}
642 
643 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
644 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
645 	}
646 
647 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
648 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
649 	}
650 
651 	function log(uint p0, bool p1, uint p2, address p3) internal view {
652 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
653 	}
654 
655 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
656 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
657 	}
658 
659 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
660 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
661 	}
662 
663 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
664 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
665 	}
666 
667 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
668 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
669 	}
670 
671 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
672 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
673 	}
674 
675 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
676 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
677 	}
678 
679 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
680 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
681 	}
682 
683 	function log(uint p0, bool p1, bool p2, address p3) internal view {
684 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
685 	}
686 
687 	function log(uint p0, bool p1, address p2, uint p3) internal view {
688 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
689 	}
690 
691 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
692 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
693 	}
694 
695 	function log(uint p0, bool p1, address p2, bool p3) internal view {
696 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
697 	}
698 
699 	function log(uint p0, bool p1, address p2, address p3) internal view {
700 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
701 	}
702 
703 	function log(uint p0, address p1, uint p2, uint p3) internal view {
704 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
705 	}
706 
707 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
708 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
709 	}
710 
711 	function log(uint p0, address p1, uint p2, bool p3) internal view {
712 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
713 	}
714 
715 	function log(uint p0, address p1, uint p2, address p3) internal view {
716 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
717 	}
718 
719 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
720 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
721 	}
722 
723 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
724 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
725 	}
726 
727 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
728 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
729 	}
730 
731 	function log(uint p0, address p1, string memory p2, address p3) internal view {
732 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
733 	}
734 
735 	function log(uint p0, address p1, bool p2, uint p3) internal view {
736 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
737 	}
738 
739 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
740 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
741 	}
742 
743 	function log(uint p0, address p1, bool p2, bool p3) internal view {
744 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
745 	}
746 
747 	function log(uint p0, address p1, bool p2, address p3) internal view {
748 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
749 	}
750 
751 	function log(uint p0, address p1, address p2, uint p3) internal view {
752 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
753 	}
754 
755 	function log(uint p0, address p1, address p2, string memory p3) internal view {
756 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
757 	}
758 
759 	function log(uint p0, address p1, address p2, bool p3) internal view {
760 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
761 	}
762 
763 	function log(uint p0, address p1, address p2, address p3) internal view {
764 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
765 	}
766 
767 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
768 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
769 	}
770 
771 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
772 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
773 	}
774 
775 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
776 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
777 	}
778 
779 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
780 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
781 	}
782 
783 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
784 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
785 	}
786 
787 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
788 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
789 	}
790 
791 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
792 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
793 	}
794 
795 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
796 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
797 	}
798 
799 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
800 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
801 	}
802 
803 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
804 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
805 	}
806 
807 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
808 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
809 	}
810 
811 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
812 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
813 	}
814 
815 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
816 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
817 	}
818 
819 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
820 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
821 	}
822 
823 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
824 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
825 	}
826 
827 	function log(string memory p0, uint p1, address p2, address p3) internal view {
828 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
829 	}
830 
831 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
832 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
833 	}
834 
835 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
836 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
837 	}
838 
839 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
840 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
841 	}
842 
843 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
844 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
845 	}
846 
847 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
848 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
849 	}
850 
851 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
852 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
853 	}
854 
855 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
856 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
857 	}
858 
859 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
860 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
861 	}
862 
863 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
864 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
865 	}
866 
867 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
868 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
869 	}
870 
871 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
872 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
873 	}
874 
875 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
876 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
877 	}
878 
879 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
880 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
881 	}
882 
883 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
884 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
885 	}
886 
887 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
888 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
889 	}
890 
891 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
892 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
893 	}
894 
895 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
896 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
897 	}
898 
899 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
900 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
901 	}
902 
903 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
904 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
905 	}
906 
907 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
908 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
909 	}
910 
911 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
912 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
913 	}
914 
915 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
916 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
917 	}
918 
919 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
920 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
921 	}
922 
923 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
924 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
925 	}
926 
927 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
928 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
929 	}
930 
931 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
932 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
933 	}
934 
935 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
936 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
937 	}
938 
939 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
940 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
941 	}
942 
943 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
944 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
945 	}
946 
947 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
948 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
949 	}
950 
951 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
952 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
953 	}
954 
955 	function log(string memory p0, bool p1, address p2, address p3) internal view {
956 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
957 	}
958 
959 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
960 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
961 	}
962 
963 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
964 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
965 	}
966 
967 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
968 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
969 	}
970 
971 	function log(string memory p0, address p1, uint p2, address p3) internal view {
972 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
973 	}
974 
975 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
976 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
977 	}
978 
979 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
980 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
981 	}
982 
983 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
984 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
985 	}
986 
987 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
988 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
989 	}
990 
991 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
992 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
993 	}
994 
995 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
996 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
997 	}
998 
999 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
1000 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
1001 	}
1002 
1003 	function log(string memory p0, address p1, bool p2, address p3) internal view {
1004 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
1005 	}
1006 
1007 	function log(string memory p0, address p1, address p2, uint p3) internal view {
1008 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
1009 	}
1010 
1011 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
1012 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
1013 	}
1014 
1015 	function log(string memory p0, address p1, address p2, bool p3) internal view {
1016 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
1017 	}
1018 
1019 	function log(string memory p0, address p1, address p2, address p3) internal view {
1020 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
1021 	}
1022 
1023 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
1024 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
1025 	}
1026 
1027 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
1028 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
1029 	}
1030 
1031 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
1032 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
1033 	}
1034 
1035 	function log(bool p0, uint p1, uint p2, address p3) internal view {
1036 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
1037 	}
1038 
1039 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
1040 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
1041 	}
1042 
1043 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
1044 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
1045 	}
1046 
1047 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
1048 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
1049 	}
1050 
1051 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
1052 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
1053 	}
1054 
1055 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
1056 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
1057 	}
1058 
1059 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
1060 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
1061 	}
1062 
1063 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
1064 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
1065 	}
1066 
1067 	function log(bool p0, uint p1, bool p2, address p3) internal view {
1068 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
1069 	}
1070 
1071 	function log(bool p0, uint p1, address p2, uint p3) internal view {
1072 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
1073 	}
1074 
1075 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
1076 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
1077 	}
1078 
1079 	function log(bool p0, uint p1, address p2, bool p3) internal view {
1080 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
1081 	}
1082 
1083 	function log(bool p0, uint p1, address p2, address p3) internal view {
1084 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
1085 	}
1086 
1087 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
1088 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
1089 	}
1090 
1091 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
1092 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
1093 	}
1094 
1095 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
1096 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
1097 	}
1098 
1099 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
1100 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
1101 	}
1102 
1103 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
1104 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
1105 	}
1106 
1107 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
1108 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
1109 	}
1110 
1111 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
1112 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
1113 	}
1114 
1115 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
1116 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
1117 	}
1118 
1119 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
1120 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
1121 	}
1122 
1123 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
1124 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
1125 	}
1126 
1127 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
1128 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
1129 	}
1130 
1131 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
1132 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
1133 	}
1134 
1135 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
1136 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
1137 	}
1138 
1139 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
1140 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
1141 	}
1142 
1143 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
1144 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
1145 	}
1146 
1147 	function log(bool p0, string memory p1, address p2, address p3) internal view {
1148 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
1149 	}
1150 
1151 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
1152 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
1153 	}
1154 
1155 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
1156 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
1157 	}
1158 
1159 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
1160 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
1161 	}
1162 
1163 	function log(bool p0, bool p1, uint p2, address p3) internal view {
1164 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
1165 	}
1166 
1167 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
1168 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
1169 	}
1170 
1171 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
1172 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
1173 	}
1174 
1175 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
1176 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
1177 	}
1178 
1179 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
1180 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
1181 	}
1182 
1183 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
1184 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
1185 	}
1186 
1187 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
1188 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
1189 	}
1190 
1191 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
1192 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
1193 	}
1194 
1195 	function log(bool p0, bool p1, bool p2, address p3) internal view {
1196 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
1197 	}
1198 
1199 	function log(bool p0, bool p1, address p2, uint p3) internal view {
1200 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
1201 	}
1202 
1203 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
1204 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
1205 	}
1206 
1207 	function log(bool p0, bool p1, address p2, bool p3) internal view {
1208 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
1209 	}
1210 
1211 	function log(bool p0, bool p1, address p2, address p3) internal view {
1212 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
1213 	}
1214 
1215 	function log(bool p0, address p1, uint p2, uint p3) internal view {
1216 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
1217 	}
1218 
1219 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
1220 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
1221 	}
1222 
1223 	function log(bool p0, address p1, uint p2, bool p3) internal view {
1224 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
1225 	}
1226 
1227 	function log(bool p0, address p1, uint p2, address p3) internal view {
1228 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
1229 	}
1230 
1231 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
1232 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
1233 	}
1234 
1235 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
1236 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
1237 	}
1238 
1239 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
1240 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
1241 	}
1242 
1243 	function log(bool p0, address p1, string memory p2, address p3) internal view {
1244 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
1245 	}
1246 
1247 	function log(bool p0, address p1, bool p2, uint p3) internal view {
1248 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
1249 	}
1250 
1251 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
1252 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
1253 	}
1254 
1255 	function log(bool p0, address p1, bool p2, bool p3) internal view {
1256 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
1257 	}
1258 
1259 	function log(bool p0, address p1, bool p2, address p3) internal view {
1260 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
1261 	}
1262 
1263 	function log(bool p0, address p1, address p2, uint p3) internal view {
1264 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
1265 	}
1266 
1267 	function log(bool p0, address p1, address p2, string memory p3) internal view {
1268 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
1269 	}
1270 
1271 	function log(bool p0, address p1, address p2, bool p3) internal view {
1272 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
1273 	}
1274 
1275 	function log(bool p0, address p1, address p2, address p3) internal view {
1276 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
1277 	}
1278 
1279 	function log(address p0, uint p1, uint p2, uint p3) internal view {
1280 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
1281 	}
1282 
1283 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
1284 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
1285 	}
1286 
1287 	function log(address p0, uint p1, uint p2, bool p3) internal view {
1288 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
1289 	}
1290 
1291 	function log(address p0, uint p1, uint p2, address p3) internal view {
1292 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
1293 	}
1294 
1295 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
1296 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
1297 	}
1298 
1299 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
1300 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
1301 	}
1302 
1303 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
1304 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
1305 	}
1306 
1307 	function log(address p0, uint p1, string memory p2, address p3) internal view {
1308 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
1309 	}
1310 
1311 	function log(address p0, uint p1, bool p2, uint p3) internal view {
1312 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
1313 	}
1314 
1315 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
1316 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
1317 	}
1318 
1319 	function log(address p0, uint p1, bool p2, bool p3) internal view {
1320 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
1321 	}
1322 
1323 	function log(address p0, uint p1, bool p2, address p3) internal view {
1324 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
1325 	}
1326 
1327 	function log(address p0, uint p1, address p2, uint p3) internal view {
1328 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
1329 	}
1330 
1331 	function log(address p0, uint p1, address p2, string memory p3) internal view {
1332 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
1333 	}
1334 
1335 	function log(address p0, uint p1, address p2, bool p3) internal view {
1336 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
1337 	}
1338 
1339 	function log(address p0, uint p1, address p2, address p3) internal view {
1340 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
1341 	}
1342 
1343 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
1344 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
1345 	}
1346 
1347 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
1348 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
1349 	}
1350 
1351 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
1352 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
1353 	}
1354 
1355 	function log(address p0, string memory p1, uint p2, address p3) internal view {
1356 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
1357 	}
1358 
1359 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
1360 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
1361 	}
1362 
1363 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
1364 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
1365 	}
1366 
1367 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
1368 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
1369 	}
1370 
1371 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
1372 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
1373 	}
1374 
1375 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
1376 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
1377 	}
1378 
1379 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
1380 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
1381 	}
1382 
1383 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
1384 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
1385 	}
1386 
1387 	function log(address p0, string memory p1, bool p2, address p3) internal view {
1388 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
1389 	}
1390 
1391 	function log(address p0, string memory p1, address p2, uint p3) internal view {
1392 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
1393 	}
1394 
1395 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
1396 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
1397 	}
1398 
1399 	function log(address p0, string memory p1, address p2, bool p3) internal view {
1400 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
1401 	}
1402 
1403 	function log(address p0, string memory p1, address p2, address p3) internal view {
1404 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
1405 	}
1406 
1407 	function log(address p0, bool p1, uint p2, uint p3) internal view {
1408 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
1409 	}
1410 
1411 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
1412 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
1413 	}
1414 
1415 	function log(address p0, bool p1, uint p2, bool p3) internal view {
1416 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
1417 	}
1418 
1419 	function log(address p0, bool p1, uint p2, address p3) internal view {
1420 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
1421 	}
1422 
1423 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
1424 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
1425 	}
1426 
1427 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
1428 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
1429 	}
1430 
1431 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
1432 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
1433 	}
1434 
1435 	function log(address p0, bool p1, string memory p2, address p3) internal view {
1436 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
1437 	}
1438 
1439 	function log(address p0, bool p1, bool p2, uint p3) internal view {
1440 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
1441 	}
1442 
1443 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
1444 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
1445 	}
1446 
1447 	function log(address p0, bool p1, bool p2, bool p3) internal view {
1448 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
1449 	}
1450 
1451 	function log(address p0, bool p1, bool p2, address p3) internal view {
1452 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
1453 	}
1454 
1455 	function log(address p0, bool p1, address p2, uint p3) internal view {
1456 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
1457 	}
1458 
1459 	function log(address p0, bool p1, address p2, string memory p3) internal view {
1460 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
1461 	}
1462 
1463 	function log(address p0, bool p1, address p2, bool p3) internal view {
1464 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
1465 	}
1466 
1467 	function log(address p0, bool p1, address p2, address p3) internal view {
1468 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
1469 	}
1470 
1471 	function log(address p0, address p1, uint p2, uint p3) internal view {
1472 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
1473 	}
1474 
1475 	function log(address p0, address p1, uint p2, string memory p3) internal view {
1476 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
1477 	}
1478 
1479 	function log(address p0, address p1, uint p2, bool p3) internal view {
1480 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
1481 	}
1482 
1483 	function log(address p0, address p1, uint p2, address p3) internal view {
1484 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
1485 	}
1486 
1487 	function log(address p0, address p1, string memory p2, uint p3) internal view {
1488 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
1489 	}
1490 
1491 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
1492 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
1493 	}
1494 
1495 	function log(address p0, address p1, string memory p2, bool p3) internal view {
1496 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
1497 	}
1498 
1499 	function log(address p0, address p1, string memory p2, address p3) internal view {
1500 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
1501 	}
1502 
1503 	function log(address p0, address p1, bool p2, uint p3) internal view {
1504 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
1505 	}
1506 
1507 	function log(address p0, address p1, bool p2, string memory p3) internal view {
1508 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
1509 	}
1510 
1511 	function log(address p0, address p1, bool p2, bool p3) internal view {
1512 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
1513 	}
1514 
1515 	function log(address p0, address p1, bool p2, address p3) internal view {
1516 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
1517 	}
1518 
1519 	function log(address p0, address p1, address p2, uint p3) internal view {
1520 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
1521 	}
1522 
1523 	function log(address p0, address p1, address p2, string memory p3) internal view {
1524 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
1525 	}
1526 
1527 	function log(address p0, address p1, address p2, bool p3) internal view {
1528 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
1529 	}
1530 
1531 	function log(address p0, address p1, address p2, address p3) internal view {
1532 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
1533 	}
1534 
1535 }
1536 
1537 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
1538 
1539 
1540 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
1541 
1542 pragma solidity ^0.8.0;
1543 
1544 // CAUTION
1545 // This version of SafeMath should only be used with Solidity 0.8 or later,
1546 // because it relies on the compiler's built in overflow checks.
1547 
1548 /**
1549  * @dev Wrappers over Solidity's arithmetic operations.
1550  *
1551  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1552  * now has built in overflow checking.
1553  */
1554 library SafeMath {
1555     /**
1556      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1557      *
1558      * _Available since v3.4._
1559      */
1560     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1561         unchecked {
1562             uint256 c = a + b;
1563             if (c < a) return (false, 0);
1564             return (true, c);
1565         }
1566     }
1567 
1568     /**
1569      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1570      *
1571      * _Available since v3.4._
1572      */
1573     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1574         unchecked {
1575             if (b > a) return (false, 0);
1576             return (true, a - b);
1577         }
1578     }
1579 
1580     /**
1581      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1582      *
1583      * _Available since v3.4._
1584      */
1585     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1586         unchecked {
1587             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1588             // benefit is lost if 'b' is also tested.
1589             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1590             if (a == 0) return (true, 0);
1591             uint256 c = a * b;
1592             if (c / a != b) return (false, 0);
1593             return (true, c);
1594         }
1595     }
1596 
1597     /**
1598      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1599      *
1600      * _Available since v3.4._
1601      */
1602     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1603         unchecked {
1604             if (b == 0) return (false, 0);
1605             return (true, a / b);
1606         }
1607     }
1608 
1609     /**
1610      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1611      *
1612      * _Available since v3.4._
1613      */
1614     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1615         unchecked {
1616             if (b == 0) return (false, 0);
1617             return (true, a % b);
1618         }
1619     }
1620 
1621     /**
1622      * @dev Returns the addition of two unsigned integers, reverting on
1623      * overflow.
1624      *
1625      * Counterpart to Solidity's `+` operator.
1626      *
1627      * Requirements:
1628      *
1629      * - Addition cannot overflow.
1630      */
1631     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1632         return a + b;
1633     }
1634 
1635     /**
1636      * @dev Returns the subtraction of two unsigned integers, reverting on
1637      * overflow (when the result is negative).
1638      *
1639      * Counterpart to Solidity's `-` operator.
1640      *
1641      * Requirements:
1642      *
1643      * - Subtraction cannot overflow.
1644      */
1645     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1646         return a - b;
1647     }
1648 
1649     /**
1650      * @dev Returns the multiplication of two unsigned integers, reverting on
1651      * overflow.
1652      *
1653      * Counterpart to Solidity's `*` operator.
1654      *
1655      * Requirements:
1656      *
1657      * - Multiplication cannot overflow.
1658      */
1659     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1660         return a * b;
1661     }
1662 
1663     /**
1664      * @dev Returns the integer division of two unsigned integers, reverting on
1665      * division by zero. The result is rounded towards zero.
1666      *
1667      * Counterpart to Solidity's `/` operator.
1668      *
1669      * Requirements:
1670      *
1671      * - The divisor cannot be zero.
1672      */
1673     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1674         return a / b;
1675     }
1676 
1677     /**
1678      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1679      * reverting when dividing by zero.
1680      *
1681      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1682      * opcode (which leaves remaining gas untouched) while Solidity uses an
1683      * invalid opcode to revert (consuming all remaining gas).
1684      *
1685      * Requirements:
1686      *
1687      * - The divisor cannot be zero.
1688      */
1689     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1690         return a % b;
1691     }
1692 
1693     /**
1694      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1695      * overflow (when the result is negative).
1696      *
1697      * CAUTION: This function is deprecated because it requires allocating memory for the error
1698      * message unnecessarily. For custom revert reasons use {trySub}.
1699      *
1700      * Counterpart to Solidity's `-` operator.
1701      *
1702      * Requirements:
1703      *
1704      * - Subtraction cannot overflow.
1705      */
1706     function sub(
1707         uint256 a,
1708         uint256 b,
1709         string memory errorMessage
1710     ) internal pure returns (uint256) {
1711         unchecked {
1712             require(b <= a, errorMessage);
1713             return a - b;
1714         }
1715     }
1716 
1717     /**
1718      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1719      * division by zero. The result is rounded towards zero.
1720      *
1721      * Counterpart to Solidity's `/` operator. Note: this function uses a
1722      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1723      * uses an invalid opcode to revert (consuming all remaining gas).
1724      *
1725      * Requirements:
1726      *
1727      * - The divisor cannot be zero.
1728      */
1729     function div(
1730         uint256 a,
1731         uint256 b,
1732         string memory errorMessage
1733     ) internal pure returns (uint256) {
1734         unchecked {
1735             require(b > 0, errorMessage);
1736             return a / b;
1737         }
1738     }
1739 
1740     /**
1741      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1742      * reverting with custom message when dividing by zero.
1743      *
1744      * CAUTION: This function is deprecated because it requires allocating memory for the error
1745      * message unnecessarily. For custom revert reasons use {tryMod}.
1746      *
1747      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1748      * opcode (which leaves remaining gas untouched) while Solidity uses an
1749      * invalid opcode to revert (consuming all remaining gas).
1750      *
1751      * Requirements:
1752      *
1753      * - The divisor cannot be zero.
1754      */
1755     function mod(
1756         uint256 a,
1757         uint256 b,
1758         string memory errorMessage
1759     ) internal pure returns (uint256) {
1760         unchecked {
1761             require(b > 0, errorMessage);
1762             return a % b;
1763         }
1764     }
1765 }
1766 
1767 // File: @openzeppelin/contracts/utils/Strings.sol
1768 
1769 
1770 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1771 
1772 pragma solidity ^0.8.0;
1773 
1774 /**
1775  * @dev String operations.
1776  */
1777 library Strings {
1778     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1779 
1780     /**
1781      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1782      */
1783     function toString(uint256 value) internal pure returns (string memory) {
1784         // Inspired by OraclizeAPI's implementation - MIT licence
1785         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1786 
1787         if (value == 0) {
1788             return "0";
1789         }
1790         uint256 temp = value;
1791         uint256 digits;
1792         while (temp != 0) {
1793             digits++;
1794             temp /= 10;
1795         }
1796         bytes memory buffer = new bytes(digits);
1797         while (value != 0) {
1798             digits -= 1;
1799             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1800             value /= 10;
1801         }
1802         return string(buffer);
1803     }
1804 
1805     /**
1806      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1807      */
1808     function toHexString(uint256 value) internal pure returns (string memory) {
1809         if (value == 0) {
1810             return "0x00";
1811         }
1812         uint256 temp = value;
1813         uint256 length = 0;
1814         while (temp != 0) {
1815             length++;
1816             temp >>= 8;
1817         }
1818         return toHexString(value, length);
1819     }
1820 
1821     /**
1822      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1823      */
1824     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1825         bytes memory buffer = new bytes(2 * length + 2);
1826         buffer[0] = "0";
1827         buffer[1] = "x";
1828         for (uint256 i = 2 * length + 1; i > 1; --i) {
1829             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1830             value >>= 4;
1831         }
1832         require(value == 0, "Strings: hex length insufficient");
1833         return string(buffer);
1834     }
1835 }
1836 
1837 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
1838 
1839 
1840 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
1841 
1842 pragma solidity ^0.8.0;
1843 
1844 
1845 /**
1846  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1847  *
1848  * These functions can be used to verify that a message was signed by the holder
1849  * of the private keys of a given address.
1850  */
1851 library ECDSA {
1852     enum RecoverError {
1853         NoError,
1854         InvalidSignature,
1855         InvalidSignatureLength,
1856         InvalidSignatureS,
1857         InvalidSignatureV
1858     }
1859 
1860     function _throwError(RecoverError error) private pure {
1861         if (error == RecoverError.NoError) {
1862             return; // no error: do nothing
1863         } else if (error == RecoverError.InvalidSignature) {
1864             revert("ECDSA: invalid signature");
1865         } else if (error == RecoverError.InvalidSignatureLength) {
1866             revert("ECDSA: invalid signature length");
1867         } else if (error == RecoverError.InvalidSignatureS) {
1868             revert("ECDSA: invalid signature 's' value");
1869         } else if (error == RecoverError.InvalidSignatureV) {
1870             revert("ECDSA: invalid signature 'v' value");
1871         }
1872     }
1873 
1874     /**
1875      * @dev Returns the address that signed a hashed message (`hash`) with
1876      * `signature` or error string. This address can then be used for verification purposes.
1877      *
1878      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1879      * this function rejects them by requiring the `s` value to be in the lower
1880      * half order, and the `v` value to be either 27 or 28.
1881      *
1882      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1883      * verification to be secure: it is possible to craft signatures that
1884      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1885      * this is by receiving a hash of the original message (which may otherwise
1886      * be too long), and then calling {toEthSignedMessageHash} on it.
1887      *
1888      * Documentation for signature generation:
1889      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1890      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1891      *
1892      * _Available since v4.3._
1893      */
1894     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1895         // Check the signature length
1896         // - case 65: r,s,v signature (standard)
1897         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1898         if (signature.length == 65) {
1899             bytes32 r;
1900             bytes32 s;
1901             uint8 v;
1902             // ecrecover takes the signature parameters, and the only way to get them
1903             // currently is to use assembly.
1904             assembly {
1905                 r := mload(add(signature, 0x20))
1906                 s := mload(add(signature, 0x40))
1907                 v := byte(0, mload(add(signature, 0x60)))
1908             }
1909             return tryRecover(hash, v, r, s);
1910         } else if (signature.length == 64) {
1911             bytes32 r;
1912             bytes32 vs;
1913             // ecrecover takes the signature parameters, and the only way to get them
1914             // currently is to use assembly.
1915             assembly {
1916                 r := mload(add(signature, 0x20))
1917                 vs := mload(add(signature, 0x40))
1918             }
1919             return tryRecover(hash, r, vs);
1920         } else {
1921             return (address(0), RecoverError.InvalidSignatureLength);
1922         }
1923     }
1924 
1925     /**
1926      * @dev Returns the address that signed a hashed message (`hash`) with
1927      * `signature`. This address can then be used for verification purposes.
1928      *
1929      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1930      * this function rejects them by requiring the `s` value to be in the lower
1931      * half order, and the `v` value to be either 27 or 28.
1932      *
1933      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1934      * verification to be secure: it is possible to craft signatures that
1935      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1936      * this is by receiving a hash of the original message (which may otherwise
1937      * be too long), and then calling {toEthSignedMessageHash} on it.
1938      */
1939     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1940         (address recovered, RecoverError error) = tryRecover(hash, signature);
1941         _throwError(error);
1942         return recovered;
1943     }
1944 
1945     /**
1946      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1947      *
1948      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1949      *
1950      * _Available since v4.3._
1951      */
1952     function tryRecover(
1953         bytes32 hash,
1954         bytes32 r,
1955         bytes32 vs
1956     ) internal pure returns (address, RecoverError) {
1957         bytes32 s;
1958         uint8 v;
1959         assembly {
1960             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1961             v := add(shr(255, vs), 27)
1962         }
1963         return tryRecover(hash, v, r, s);
1964     }
1965 
1966     /**
1967      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1968      *
1969      * _Available since v4.2._
1970      */
1971     function recover(
1972         bytes32 hash,
1973         bytes32 r,
1974         bytes32 vs
1975     ) internal pure returns (address) {
1976         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1977         _throwError(error);
1978         return recovered;
1979     }
1980 
1981     /**
1982      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1983      * `r` and `s` signature fields separately.
1984      *
1985      * _Available since v4.3._
1986      */
1987     function tryRecover(
1988         bytes32 hash,
1989         uint8 v,
1990         bytes32 r,
1991         bytes32 s
1992     ) internal pure returns (address, RecoverError) {
1993         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1994         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1995         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1996         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1997         //
1998         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1999         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
2000         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
2001         // these malleable signatures as well.
2002         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
2003             return (address(0), RecoverError.InvalidSignatureS);
2004         }
2005         if (v != 27 && v != 28) {
2006             return (address(0), RecoverError.InvalidSignatureV);
2007         }
2008 
2009         // If the signature is valid (and not malleable), return the signer address
2010         address signer = ecrecover(hash, v, r, s);
2011         if (signer == address(0)) {
2012             return (address(0), RecoverError.InvalidSignature);
2013         }
2014 
2015         return (signer, RecoverError.NoError);
2016     }
2017 
2018     /**
2019      * @dev Overload of {ECDSA-recover} that receives the `v`,
2020      * `r` and `s` signature fields separately.
2021      */
2022     function recover(
2023         bytes32 hash,
2024         uint8 v,
2025         bytes32 r,
2026         bytes32 s
2027     ) internal pure returns (address) {
2028         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
2029         _throwError(error);
2030         return recovered;
2031     }
2032 
2033     /**
2034      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
2035      * produces hash corresponding to the one signed with the
2036      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
2037      * JSON-RPC method as part of EIP-191.
2038      *
2039      * See {recover}.
2040      */
2041     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
2042         // 32 is the length in bytes of hash,
2043         // enforced by the type signature above
2044         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
2045     }
2046 
2047     /**
2048      * @dev Returns an Ethereum Signed Message, created from `s`. This
2049      * produces hash corresponding to the one signed with the
2050      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
2051      * JSON-RPC method as part of EIP-191.
2052      *
2053      * See {recover}.
2054      */
2055     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
2056         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
2057     }
2058 
2059     /**
2060      * @dev Returns an Ethereum Signed Typed Data, created from a
2061      * `domainSeparator` and a `structHash`. This produces hash corresponding
2062      * to the one signed with the
2063      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
2064      * JSON-RPC method as part of EIP-712.
2065      *
2066      * See {recover}.
2067      */
2068     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
2069         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
2070     }
2071 }
2072 
2073 // File: @openzeppelin/contracts/utils/Context.sol
2074 
2075 
2076 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2077 
2078 pragma solidity ^0.8.0;
2079 
2080 /**
2081  * @dev Provides information about the current execution context, including the
2082  * sender of the transaction and its data. While these are generally available
2083  * via msg.sender and msg.data, they should not be accessed in such a direct
2084  * manner, since when dealing with meta-transactions the account sending and
2085  * paying for execution may not be the actual sender (as far as an application
2086  * is concerned).
2087  *
2088  * This contract is only required for intermediate, library-like contracts.
2089  */
2090 abstract contract Context {
2091     function _msgSender() internal view virtual returns (address) {
2092         return msg.sender;
2093     }
2094 
2095     function _msgData() internal view virtual returns (bytes calldata) {
2096         return msg.data;
2097     }
2098 }
2099 
2100 // File: @openzeppelin/contracts/access/Ownable.sol
2101 
2102 
2103 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
2104 
2105 pragma solidity ^0.8.0;
2106 
2107 
2108 /**
2109  * @dev Contract module which provides a basic access control mechanism, where
2110  * there is an account (an owner) that can be granted exclusive access to
2111  * specific functions.
2112  *
2113  * By default, the owner account will be the one that deploys the contract. This
2114  * can later be changed with {transferOwnership}.
2115  *
2116  * This module is used through inheritance. It will make available the modifier
2117  * `onlyOwner`, which can be applied to your functions to restrict their use to
2118  * the owner.
2119  */
2120 abstract contract Ownable is Context {
2121     address private _owner;
2122 
2123     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2124 
2125     /**
2126      * @dev Initializes the contract setting the deployer as the initial owner.
2127      */
2128     constructor() {
2129         _transferOwnership(_msgSender());
2130     }
2131 
2132     /**
2133      * @dev Returns the address of the current owner.
2134      */
2135     function owner() public view virtual returns (address) {
2136         return _owner;
2137     }
2138 
2139     /**
2140      * @dev Throws if called by any account other than the owner.
2141      */
2142     modifier onlyOwner() {
2143         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2144         _;
2145     }
2146 
2147     /**
2148      * @dev Leaves the contract without owner. It will not be possible to call
2149      * `onlyOwner` functions anymore. Can only be called by the current owner.
2150      *
2151      * NOTE: Renouncing ownership will leave the contract without an owner,
2152      * thereby removing any functionality that is only available to the owner.
2153      */
2154     function renounceOwnership() public virtual onlyOwner {
2155         _transferOwnership(address(0));
2156     }
2157 
2158     /**
2159      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2160      * Can only be called by the current owner.
2161      */
2162     function transferOwnership(address newOwner) public virtual onlyOwner {
2163         require(newOwner != address(0), "Ownable: new owner is the zero address");
2164         _transferOwnership(newOwner);
2165     }
2166 
2167     /**
2168      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2169      * Internal function without access restriction.
2170      */
2171     function _transferOwnership(address newOwner) internal virtual {
2172         address oldOwner = _owner;
2173         _owner = newOwner;
2174         emit OwnershipTransferred(oldOwner, newOwner);
2175     }
2176 }
2177 
2178 // File: @openzeppelin/contracts/utils/Address.sol
2179 
2180 
2181 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
2182 
2183 pragma solidity ^0.8.0;
2184 
2185 /**
2186  * @dev Collection of functions related to the address type
2187  */
2188 library Address {
2189     /**
2190      * @dev Returns true if `account` is a contract.
2191      *
2192      * [IMPORTANT]
2193      * ====
2194      * It is unsafe to assume that an address for which this function returns
2195      * false is an externally-owned account (EOA) and not a contract.
2196      *
2197      * Among others, `isContract` will return false for the following
2198      * types of addresses:
2199      *
2200      *  - an externally-owned account
2201      *  - a contract in construction
2202      *  - an address where a contract will be created
2203      *  - an address where a contract lived, but was destroyed
2204      * ====
2205      */
2206     function isContract(address account) internal view returns (bool) {
2207         // This method relies on extcodesize, which returns 0 for contracts in
2208         // construction, since the code is only stored at the end of the
2209         // constructor execution.
2210 
2211         uint256 size;
2212         assembly {
2213             size := extcodesize(account)
2214         }
2215         return size > 0;
2216     }
2217 
2218     /**
2219      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
2220      * `recipient`, forwarding all available gas and reverting on errors.
2221      *
2222      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
2223      * of certain opcodes, possibly making contracts go over the 2300 gas limit
2224      * imposed by `transfer`, making them unable to receive funds via
2225      * `transfer`. {sendValue} removes this limitation.
2226      *
2227      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
2228      *
2229      * IMPORTANT: because control is transferred to `recipient`, care must be
2230      * taken to not create reentrancy vulnerabilities. Consider using
2231      * {ReentrancyGuard} or the
2232      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
2233      */
2234     function sendValue(address payable recipient, uint256 amount) internal {
2235         require(address(this).balance >= amount, "Address: insufficient balance");
2236 
2237         (bool success, ) = recipient.call{value: amount}("");
2238         require(success, "Address: unable to send value, recipient may have reverted");
2239     }
2240 
2241     /**
2242      * @dev Performs a Solidity function call using a low level `call`. A
2243      * plain `call` is an unsafe replacement for a function call: use this
2244      * function instead.
2245      *
2246      * If `target` reverts with a revert reason, it is bubbled up by this
2247      * function (like regular Solidity function calls).
2248      *
2249      * Returns the raw returned data. To convert to the expected return value,
2250      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
2251      *
2252      * Requirements:
2253      *
2254      * - `target` must be a contract.
2255      * - calling `target` with `data` must not revert.
2256      *
2257      * _Available since v3.1._
2258      */
2259     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
2260         return functionCall(target, data, "Address: low-level call failed");
2261     }
2262 
2263     /**
2264      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
2265      * `errorMessage` as a fallback revert reason when `target` reverts.
2266      *
2267      * _Available since v3.1._
2268      */
2269     function functionCall(
2270         address target,
2271         bytes memory data,
2272         string memory errorMessage
2273     ) internal returns (bytes memory) {
2274         return functionCallWithValue(target, data, 0, errorMessage);
2275     }
2276 
2277     /**
2278      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2279      * but also transferring `value` wei to `target`.
2280      *
2281      * Requirements:
2282      *
2283      * - the calling contract must have an ETH balance of at least `value`.
2284      * - the called Solidity function must be `payable`.
2285      *
2286      * _Available since v3.1._
2287      */
2288     function functionCallWithValue(
2289         address target,
2290         bytes memory data,
2291         uint256 value
2292     ) internal returns (bytes memory) {
2293         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
2294     }
2295 
2296     /**
2297      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
2298      * with `errorMessage` as a fallback revert reason when `target` reverts.
2299      *
2300      * _Available since v3.1._
2301      */
2302     function functionCallWithValue(
2303         address target,
2304         bytes memory data,
2305         uint256 value,
2306         string memory errorMessage
2307     ) internal returns (bytes memory) {
2308         require(address(this).balance >= value, "Address: insufficient balance for call");
2309         require(isContract(target), "Address: call to non-contract");
2310 
2311         (bool success, bytes memory returndata) = target.call{value: value}(data);
2312         return verifyCallResult(success, returndata, errorMessage);
2313     }
2314 
2315     /**
2316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2317      * but performing a static call.
2318      *
2319      * _Available since v3.3._
2320      */
2321     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
2322         return functionStaticCall(target, data, "Address: low-level static call failed");
2323     }
2324 
2325     /**
2326      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2327      * but performing a static call.
2328      *
2329      * _Available since v3.3._
2330      */
2331     function functionStaticCall(
2332         address target,
2333         bytes memory data,
2334         string memory errorMessage
2335     ) internal view returns (bytes memory) {
2336         require(isContract(target), "Address: static call to non-contract");
2337 
2338         (bool success, bytes memory returndata) = target.staticcall(data);
2339         return verifyCallResult(success, returndata, errorMessage);
2340     }
2341 
2342     /**
2343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2344      * but performing a delegate call.
2345      *
2346      * _Available since v3.4._
2347      */
2348     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
2349         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
2350     }
2351 
2352     /**
2353      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2354      * but performing a delegate call.
2355      *
2356      * _Available since v3.4._
2357      */
2358     function functionDelegateCall(
2359         address target,
2360         bytes memory data,
2361         string memory errorMessage
2362     ) internal returns (bytes memory) {
2363         require(isContract(target), "Address: delegate call to non-contract");
2364 
2365         (bool success, bytes memory returndata) = target.delegatecall(data);
2366         return verifyCallResult(success, returndata, errorMessage);
2367     }
2368 
2369     /**
2370      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
2371      * revert reason using the provided one.
2372      *
2373      * _Available since v4.3._
2374      */
2375     function verifyCallResult(
2376         bool success,
2377         bytes memory returndata,
2378         string memory errorMessage
2379     ) internal pure returns (bytes memory) {
2380         if (success) {
2381             return returndata;
2382         } else {
2383             // Look for revert reason and bubble it up if present
2384             if (returndata.length > 0) {
2385                 // The easiest way to bubble the revert reason is using memory via assembly
2386 
2387                 assembly {
2388                     let returndata_size := mload(returndata)
2389                     revert(add(32, returndata), returndata_size)
2390                 }
2391             } else {
2392                 revert(errorMessage);
2393             }
2394         }
2395     }
2396 }
2397 
2398 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
2399 
2400 
2401 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
2402 
2403 pragma solidity ^0.8.0;
2404 
2405 /**
2406  * @title ERC721 token receiver interface
2407  * @dev Interface for any contract that wants to support safeTransfers
2408  * from ERC721 asset contracts.
2409  */
2410 interface IERC721Receiver {
2411     /**
2412      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
2413      * by `operator` from `from`, this function is called.
2414      *
2415      * It must return its Solidity selector to confirm the token transfer.
2416      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
2417      *
2418      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
2419      */
2420     function onERC721Received(
2421         address operator,
2422         address from,
2423         uint256 tokenId,
2424         bytes calldata data
2425     ) external returns (bytes4);
2426 }
2427 
2428 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2429 
2430 
2431 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
2432 
2433 pragma solidity ^0.8.0;
2434 
2435 /**
2436  * @dev Interface of the ERC165 standard, as defined in the
2437  * https://eips.ethereum.org/EIPS/eip-165[EIP].
2438  *
2439  * Implementers can declare support of contract interfaces, which can then be
2440  * queried by others ({ERC165Checker}).
2441  *
2442  * For an implementation, see {ERC165}.
2443  */
2444 interface IERC165 {
2445     /**
2446      * @dev Returns true if this contract implements the interface defined by
2447      * `interfaceId`. See the corresponding
2448      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
2449      * to learn more about how these ids are created.
2450      *
2451      * This function call must use less than 30 000 gas.
2452      */
2453     function supportsInterface(bytes4 interfaceId) external view returns (bool);
2454 }
2455 
2456 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
2457 
2458 
2459 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
2460 
2461 pragma solidity ^0.8.0;
2462 
2463 
2464 /**
2465  * @dev Implementation of the {IERC165} interface.
2466  *
2467  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
2468  * for the additional interface id that will be supported. For example:
2469  *
2470  * ```solidity
2471  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2472  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
2473  * }
2474  * ```
2475  *
2476  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
2477  */
2478 abstract contract ERC165 is IERC165 {
2479     /**
2480      * @dev See {IERC165-supportsInterface}.
2481      */
2482     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2483         return interfaceId == type(IERC165).interfaceId;
2484     }
2485 }
2486 
2487 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
2488 
2489 
2490 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
2491 
2492 pragma solidity ^0.8.0;
2493 
2494 
2495 /**
2496  * @dev Required interface of an ERC721 compliant contract.
2497  */
2498 interface IERC721 is IERC165 {
2499     /**
2500      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
2501      */
2502     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
2503 
2504     /**
2505      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
2506      */
2507     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
2508 
2509     /**
2510      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
2511      */
2512     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
2513 
2514     /**
2515      * @dev Returns the number of tokens in ``owner``'s account.
2516      */
2517     function balanceOf(address owner) external view returns (uint256 balance);
2518 
2519     /**
2520      * @dev Returns the owner of the `tokenId` token.
2521      *
2522      * Requirements:
2523      *
2524      * - `tokenId` must exist.
2525      */
2526     function ownerOf(uint256 tokenId) external view returns (address owner);
2527 
2528     /**
2529      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2530      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2531      *
2532      * Requirements:
2533      *
2534      * - `from` cannot be the zero address.
2535      * - `to` cannot be the zero address.
2536      * - `tokenId` token must exist and be owned by `from`.
2537      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
2538      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2539      *
2540      * Emits a {Transfer} event.
2541      */
2542     function safeTransferFrom(
2543         address from,
2544         address to,
2545         uint256 tokenId
2546     ) external;
2547 
2548     /**
2549      * @dev Transfers `tokenId` token from `from` to `to`.
2550      *
2551      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
2552      *
2553      * Requirements:
2554      *
2555      * - `from` cannot be the zero address.
2556      * - `to` cannot be the zero address.
2557      * - `tokenId` token must be owned by `from`.
2558      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2559      *
2560      * Emits a {Transfer} event.
2561      */
2562     function transferFrom(
2563         address from,
2564         address to,
2565         uint256 tokenId
2566     ) external;
2567 
2568     /**
2569      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2570      * The approval is cleared when the token is transferred.
2571      *
2572      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
2573      *
2574      * Requirements:
2575      *
2576      * - The caller must own the token or be an approved operator.
2577      * - `tokenId` must exist.
2578      *
2579      * Emits an {Approval} event.
2580      */
2581     function approve(address to, uint256 tokenId) external;
2582 
2583     /**
2584      * @dev Returns the account approved for `tokenId` token.
2585      *
2586      * Requirements:
2587      *
2588      * - `tokenId` must exist.
2589      */
2590     function getApproved(uint256 tokenId) external view returns (address operator);
2591 
2592     /**
2593      * @dev Approve or remove `operator` as an operator for the caller.
2594      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
2595      *
2596      * Requirements:
2597      *
2598      * - The `operator` cannot be the caller.
2599      *
2600      * Emits an {ApprovalForAll} event.
2601      */
2602     function setApprovalForAll(address operator, bool _approved) external;
2603 
2604     /**
2605      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2606      *
2607      * See {setApprovalForAll}
2608      */
2609     function isApprovedForAll(address owner, address operator) external view returns (bool);
2610 
2611     /**
2612      * @dev Safely transfers `tokenId` token from `from` to `to`.
2613      *
2614      * Requirements:
2615      *
2616      * - `from` cannot be the zero address.
2617      * - `to` cannot be the zero address.
2618      * - `tokenId` token must exist and be owned by `from`.
2619      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2620      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2621      *
2622      * Emits a {Transfer} event.
2623      */
2624     function safeTransferFrom(
2625         address from,
2626         address to,
2627         uint256 tokenId,
2628         bytes calldata data
2629     ) external;
2630 }
2631 
2632 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
2633 
2634 
2635 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
2636 
2637 pragma solidity ^0.8.0;
2638 
2639 
2640 /**
2641  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
2642  * @dev See https://eips.ethereum.org/EIPS/eip-721
2643  */
2644 interface IERC721Enumerable is IERC721 {
2645     /**
2646      * @dev Returns the total amount of tokens stored by the contract.
2647      */
2648     function totalSupply() external view returns (uint256);
2649 
2650     /**
2651      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
2652      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
2653      */
2654     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
2655 
2656     /**
2657      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
2658      * Use along with {totalSupply} to enumerate all tokens.
2659      */
2660     function tokenByIndex(uint256 index) external view returns (uint256);
2661 }
2662 
2663 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
2664 
2665 
2666 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
2667 
2668 pragma solidity ^0.8.0;
2669 
2670 
2671 /**
2672  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
2673  * @dev See https://eips.ethereum.org/EIPS/eip-721
2674  */
2675 interface IERC721Metadata is IERC721 {
2676     /**
2677      * @dev Returns the token collection name.
2678      */
2679     function name() external view returns (string memory);
2680 
2681     /**
2682      * @dev Returns the token collection symbol.
2683      */
2684     function symbol() external view returns (string memory);
2685 
2686     /**
2687      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2688      */
2689     function tokenURI(uint256 tokenId) external view returns (string memory);
2690 }
2691 
2692 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
2693 
2694 
2695 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
2696 
2697 pragma solidity ^0.8.0;
2698 
2699 
2700 
2701 
2702 
2703 
2704 
2705 
2706 /**
2707  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2708  * the Metadata extension, but not including the Enumerable extension, which is available separately as
2709  * {ERC721Enumerable}.
2710  */
2711 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
2712     using Address for address;
2713     using Strings for uint256;
2714 
2715     // Token name
2716     string private _name;
2717 
2718     // Token symbol
2719     string private _symbol;
2720 
2721     // Mapping from token ID to owner address
2722     mapping(uint256 => address) private _owners;
2723 
2724     // Mapping owner address to token count
2725     mapping(address => uint256) private _balances;
2726 
2727     // Mapping from token ID to approved address
2728     mapping(uint256 => address) private _tokenApprovals;
2729 
2730     // Mapping from owner to operator approvals
2731     mapping(address => mapping(address => bool)) private _operatorApprovals;
2732 
2733     /**
2734      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2735      */
2736     constructor(string memory name_, string memory symbol_) {
2737         _name = name_;
2738         _symbol = symbol_;
2739     }
2740 
2741     /**
2742      * @dev See {IERC165-supportsInterface}.
2743      */
2744     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2745         return
2746             interfaceId == type(IERC721).interfaceId ||
2747             interfaceId == type(IERC721Metadata).interfaceId ||
2748             super.supportsInterface(interfaceId);
2749     }
2750 
2751     /**
2752      * @dev See {IERC721-balanceOf}.
2753      */
2754     function balanceOf(address owner) public view virtual override returns (uint256) {
2755         require(owner != address(0), "ERC721: balance query for the zero address");
2756         return _balances[owner];
2757     }
2758 
2759     /**
2760      * @dev See {IERC721-ownerOf}.
2761      */
2762     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2763         address owner = _owners[tokenId];
2764         require(owner != address(0), "ERC721: owner query for nonexistent token");
2765         return owner;
2766     }
2767 
2768     /**
2769      * @dev See {IERC721Metadata-name}.
2770      */
2771     function name() public view virtual override returns (string memory) {
2772         return _name;
2773     }
2774 
2775     /**
2776      * @dev See {IERC721Metadata-symbol}.
2777      */
2778     function symbol() public view virtual override returns (string memory) {
2779         return _symbol;
2780     }
2781 
2782     /**
2783      * @dev See {IERC721Metadata-tokenURI}.
2784      */
2785     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2786         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2787 
2788         string memory baseURI = _baseURI();
2789         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2790     }
2791 
2792     /**
2793      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2794      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2795      * by default, can be overriden in child contracts.
2796      */
2797     function _baseURI() internal view virtual returns (string memory) {
2798         return "";
2799     }
2800 
2801     /**
2802      * @dev See {IERC721-approve}.
2803      */
2804     function approve(address to, uint256 tokenId) public virtual override {
2805         address owner = ERC721.ownerOf(tokenId);
2806         require(to != owner, "ERC721: approval to current owner");
2807 
2808         require(
2809             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2810             "ERC721: approve caller is not owner nor approved for all"
2811         );
2812 
2813         _approve(to, tokenId);
2814     }
2815 
2816     /**
2817      * @dev See {IERC721-getApproved}.
2818      */
2819     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2820         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
2821 
2822         return _tokenApprovals[tokenId];
2823     }
2824 
2825     /**
2826      * @dev See {IERC721-setApprovalForAll}.
2827      */
2828     function setApprovalForAll(address operator, bool approved) public virtual override {
2829         _setApprovalForAll(_msgSender(), operator, approved);
2830     }
2831 
2832     /**
2833      * @dev See {IERC721-isApprovedForAll}.
2834      */
2835     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2836         return _operatorApprovals[owner][operator];
2837     }
2838 
2839     /**
2840      * @dev See {IERC721-transferFrom}.
2841      */
2842     function transferFrom(
2843         address from,
2844         address to,
2845         uint256 tokenId
2846     ) public virtual override {
2847         //solhint-disable-next-line max-line-length
2848         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2849 
2850         _transfer(from, to, tokenId);
2851     }
2852 
2853     /**
2854      * @dev See {IERC721-safeTransferFrom}.
2855      */
2856     function safeTransferFrom(
2857         address from,
2858         address to,
2859         uint256 tokenId
2860     ) public virtual override {
2861         safeTransferFrom(from, to, tokenId, "");
2862     }
2863 
2864     /**
2865      * @dev See {IERC721-safeTransferFrom}.
2866      */
2867     function safeTransferFrom(
2868         address from,
2869         address to,
2870         uint256 tokenId,
2871         bytes memory _data
2872     ) public virtual override {
2873         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2874         _safeTransfer(from, to, tokenId, _data);
2875     }
2876 
2877     /**
2878      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2879      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2880      *
2881      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
2882      *
2883      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2884      * implement alternative mechanisms to perform token transfer, such as signature-based.
2885      *
2886      * Requirements:
2887      *
2888      * - `from` cannot be the zero address.
2889      * - `to` cannot be the zero address.
2890      * - `tokenId` token must exist and be owned by `from`.
2891      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2892      *
2893      * Emits a {Transfer} event.
2894      */
2895     function _safeTransfer(
2896         address from,
2897         address to,
2898         uint256 tokenId,
2899         bytes memory _data
2900     ) internal virtual {
2901         _transfer(from, to, tokenId);
2902         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
2903     }
2904 
2905     /**
2906      * @dev Returns whether `tokenId` exists.
2907      *
2908      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2909      *
2910      * Tokens start existing when they are minted (`_mint`),
2911      * and stop existing when they are burned (`_burn`).
2912      */
2913     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2914         return _owners[tokenId] != address(0);
2915     }
2916 
2917     /**
2918      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2919      *
2920      * Requirements:
2921      *
2922      * - `tokenId` must exist.
2923      */
2924     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2925         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
2926         address owner = ERC721.ownerOf(tokenId);
2927         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
2928     }
2929 
2930     /**
2931      * @dev Safely mints `tokenId` and transfers it to `to`.
2932      *
2933      * Requirements:
2934      *
2935      * - `tokenId` must not exist.
2936      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2937      *
2938      * Emits a {Transfer} event.
2939      */
2940     function _safeMint(address to, uint256 tokenId) internal virtual {
2941         _safeMint(to, tokenId, "");
2942     }
2943 
2944     /**
2945      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2946      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2947      */
2948     function _safeMint(
2949         address to,
2950         uint256 tokenId,
2951         bytes memory _data
2952     ) internal virtual {
2953         _mint(to, tokenId);
2954         require(
2955             _checkOnERC721Received(address(0), to, tokenId, _data),
2956             "ERC721: transfer to non ERC721Receiver implementer"
2957         );
2958     }
2959 
2960     /**
2961      * @dev Mints `tokenId` and transfers it to `to`.
2962      *
2963      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2964      *
2965      * Requirements:
2966      *
2967      * - `tokenId` must not exist.
2968      * - `to` cannot be the zero address.
2969      *
2970      * Emits a {Transfer} event.
2971      */
2972     function _mint(address to, uint256 tokenId) internal virtual {
2973         require(to != address(0), "ERC721: mint to the zero address");
2974         require(!_exists(tokenId), "ERC721: token already minted");
2975 
2976         _beforeTokenTransfer(address(0), to, tokenId);
2977 
2978         _balances[to] += 1;
2979         _owners[tokenId] = to;
2980 
2981         emit Transfer(address(0), to, tokenId);
2982     }
2983 
2984     /**
2985      * @dev Destroys `tokenId`.
2986      * The approval is cleared when the token is burned.
2987      *
2988      * Requirements:
2989      *
2990      * - `tokenId` must exist.
2991      *
2992      * Emits a {Transfer} event.
2993      */
2994     function _burn(uint256 tokenId) internal virtual {
2995         address owner = ERC721.ownerOf(tokenId);
2996 
2997         _beforeTokenTransfer(owner, address(0), tokenId);
2998 
2999         // Clear approvals
3000         _approve(address(0), tokenId);
3001 
3002         _balances[owner] -= 1;
3003         delete _owners[tokenId];
3004 
3005         emit Transfer(owner, address(0), tokenId);
3006     }
3007 
3008     /**
3009      * @dev Transfers `tokenId` from `from` to `to`.
3010      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
3011      *
3012      * Requirements:
3013      *
3014      * - `to` cannot be the zero address.
3015      * - `tokenId` token must be owned by `from`.
3016      *
3017      * Emits a {Transfer} event.
3018      */
3019     function _transfer(
3020         address from,
3021         address to,
3022         uint256 tokenId
3023     ) internal virtual {
3024         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
3025         require(to != address(0), "ERC721: transfer to the zero address");
3026 
3027         _beforeTokenTransfer(from, to, tokenId);
3028 
3029         // Clear approvals from the previous owner
3030         _approve(address(0), tokenId);
3031 
3032         _balances[from] -= 1;
3033         _balances[to] += 1;
3034         _owners[tokenId] = to;
3035 
3036         emit Transfer(from, to, tokenId);
3037     }
3038 
3039     /**
3040      * @dev Approve `to` to operate on `tokenId`
3041      *
3042      * Emits a {Approval} event.
3043      */
3044     function _approve(address to, uint256 tokenId) internal virtual {
3045         _tokenApprovals[tokenId] = to;
3046         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
3047     }
3048 
3049     /**
3050      * @dev Approve `operator` to operate on all of `owner` tokens
3051      *
3052      * Emits a {ApprovalForAll} event.
3053      */
3054     function _setApprovalForAll(
3055         address owner,
3056         address operator,
3057         bool approved
3058     ) internal virtual {
3059         require(owner != operator, "ERC721: approve to caller");
3060         _operatorApprovals[owner][operator] = approved;
3061         emit ApprovalForAll(owner, operator, approved);
3062     }
3063 
3064     /**
3065      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
3066      * The call is not executed if the target address is not a contract.
3067      *
3068      * @param from address representing the previous owner of the given token ID
3069      * @param to target address that will receive the tokens
3070      * @param tokenId uint256 ID of the token to be transferred
3071      * @param _data bytes optional data to send along with the call
3072      * @return bool whether the call correctly returned the expected magic value
3073      */
3074     function _checkOnERC721Received(
3075         address from,
3076         address to,
3077         uint256 tokenId,
3078         bytes memory _data
3079     ) private returns (bool) {
3080         if (to.isContract()) {
3081             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
3082                 return retval == IERC721Receiver.onERC721Received.selector;
3083             } catch (bytes memory reason) {
3084                 if (reason.length == 0) {
3085                     revert("ERC721: transfer to non ERC721Receiver implementer");
3086                 } else {
3087                     assembly {
3088                         revert(add(32, reason), mload(reason))
3089                     }
3090                 }
3091             }
3092         } else {
3093             return true;
3094         }
3095     }
3096 
3097     /**
3098      * @dev Hook that is called before any token transfer. This includes minting
3099      * and burning.
3100      *
3101      * Calling conditions:
3102      *
3103      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
3104      * transferred to `to`.
3105      * - When `from` is zero, `tokenId` will be minted for `to`.
3106      * - When `to` is zero, ``from``'s `tokenId` will be burned.
3107      * - `from` and `to` are never both zero.
3108      *
3109      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3110      */
3111     function _beforeTokenTransfer(
3112         address from,
3113         address to,
3114         uint256 tokenId
3115     ) internal virtual {}
3116 }
3117 
3118 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
3119 
3120 
3121 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
3122 
3123 pragma solidity ^0.8.0;
3124 
3125 
3126 
3127 /**
3128  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
3129  * enumerability of all the token ids in the contract as well as all token ids owned by each
3130  * account.
3131  */
3132 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
3133     // Mapping from owner to list of owned token IDs
3134     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
3135 
3136     // Mapping from token ID to index of the owner tokens list
3137     mapping(uint256 => uint256) private _ownedTokensIndex;
3138 
3139     // Array with all token ids, used for enumeration
3140     uint256[] private _allTokens;
3141 
3142     // Mapping from token id to position in the allTokens array
3143     mapping(uint256 => uint256) private _allTokensIndex;
3144 
3145     /**
3146      * @dev See {IERC165-supportsInterface}.
3147      */
3148     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
3149         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
3150     }
3151 
3152     /**
3153      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
3154      */
3155     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
3156         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
3157         return _ownedTokens[owner][index];
3158     }
3159 
3160     /**
3161      * @dev See {IERC721Enumerable-totalSupply}.
3162      */
3163     function totalSupply() public view virtual override returns (uint256) {
3164         return _allTokens.length;
3165     }
3166 
3167     /**
3168      * @dev See {IERC721Enumerable-tokenByIndex}.
3169      */
3170     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
3171         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
3172         return _allTokens[index];
3173     }
3174 
3175     /**
3176      * @dev Hook that is called before any token transfer. This includes minting
3177      * and burning.
3178      *
3179      * Calling conditions:
3180      *
3181      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
3182      * transferred to `to`.
3183      * - When `from` is zero, `tokenId` will be minted for `to`.
3184      * - When `to` is zero, ``from``'s `tokenId` will be burned.
3185      * - `from` cannot be the zero address.
3186      * - `to` cannot be the zero address.
3187      *
3188      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3189      */
3190     function _beforeTokenTransfer(
3191         address from,
3192         address to,
3193         uint256 tokenId
3194     ) internal virtual override {
3195         super._beforeTokenTransfer(from, to, tokenId);
3196 
3197         if (from == address(0)) {
3198             _addTokenToAllTokensEnumeration(tokenId);
3199         } else if (from != to) {
3200             _removeTokenFromOwnerEnumeration(from, tokenId);
3201         }
3202         if (to == address(0)) {
3203             _removeTokenFromAllTokensEnumeration(tokenId);
3204         } else if (to != from) {
3205             _addTokenToOwnerEnumeration(to, tokenId);
3206         }
3207     }
3208 
3209     /**
3210      * @dev Private function to add a token to this extension's ownership-tracking data structures.
3211      * @param to address representing the new owner of the given token ID
3212      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
3213      */
3214     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
3215         uint256 length = ERC721.balanceOf(to);
3216         _ownedTokens[to][length] = tokenId;
3217         _ownedTokensIndex[tokenId] = length;
3218     }
3219 
3220     /**
3221      * @dev Private function to add a token to this extension's token tracking data structures.
3222      * @param tokenId uint256 ID of the token to be added to the tokens list
3223      */
3224     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
3225         _allTokensIndex[tokenId] = _allTokens.length;
3226         _allTokens.push(tokenId);
3227     }
3228 
3229     /**
3230      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
3231      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
3232      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
3233      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
3234      * @param from address representing the previous owner of the given token ID
3235      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
3236      */
3237     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
3238         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
3239         // then delete the last slot (swap and pop).
3240 
3241         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
3242         uint256 tokenIndex = _ownedTokensIndex[tokenId];
3243 
3244         // When the token to delete is the last token, the swap operation is unnecessary
3245         if (tokenIndex != lastTokenIndex) {
3246             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
3247 
3248             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
3249             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
3250         }
3251 
3252         // This also deletes the contents at the last position of the array
3253         delete _ownedTokensIndex[tokenId];
3254         delete _ownedTokens[from][lastTokenIndex];
3255     }
3256 
3257     /**
3258      * @dev Private function to remove a token from this extension's token tracking data structures.
3259      * This has O(1) time complexity, but alters the order of the _allTokens array.
3260      * @param tokenId uint256 ID of the token to be removed from the tokens list
3261      */
3262     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
3263         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
3264         // then delete the last slot (swap and pop).
3265 
3266         uint256 lastTokenIndex = _allTokens.length - 1;
3267         uint256 tokenIndex = _allTokensIndex[tokenId];
3268 
3269         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
3270         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
3271         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
3272         uint256 lastTokenId = _allTokens[lastTokenIndex];
3273 
3274         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
3275         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
3276 
3277         // This also deletes the contents at the last position of the array
3278         delete _allTokensIndex[tokenId];
3279         _allTokens.pop();
3280     }
3281 }
3282 
3283 // File: contracts/Acrocalypse.sol
3284 
3285 
3286 pragma solidity >=0.7.0 <0.9.0;
3287 
3288 
3289 
3290 
3291 
3292 
3293 contract Acrocalypse is ERC721Enumerable, Ownable {
3294   using SafeMath for uint256;
3295 
3296   string baseURI;
3297   string public baseExtension = ".json";
3298   uint256 public mintCost = 0.08 ether;
3299   uint256 public maxSupply = 10420;
3300   uint256 private _currentTokenId = 0;
3301   uint256 public ownerMaxSupply = 420;
3302   uint256 public ownerTokenId = 10000;
3303   address public signerAddress;
3304 
3305   // Max number of NFTs that can be minted at one time
3306   uint256 public maxMintAmount = 3;
3307 
3308   // max number of NFTs a wallet can mint/hold
3309   uint256 public nftPerAddressLimit = 3;
3310   
3311   bool public pausedMint = true;
3312 
3313   mapping(address => uint256) public addressMintedBalance;
3314 
3315   constructor(
3316     string memory _name,
3317     string memory _symbol,
3318     string memory _initBaseURI
3319   ) ERC721(_name, _symbol) {
3320     setBaseURI(_initBaseURI);
3321     signerAddress = msg.sender;
3322   }
3323 
3324   // internal
3325   function _baseURI() internal view virtual override returns (string memory) {
3326     return baseURI;
3327   }
3328 
3329 // mint by owner
3330   function mintOwner(uint256 _amount, address _to) public onlyOwner {
3331     require(_amount > 0, "need to mint at least 1 NFT");    
3332     uint256 newIncrementalTokenId = _getNextOwnerTokenId();
3333     require(newIncrementalTokenId <= maxSupply, "amount is exceeding the maxSupply");
3334 
3335 
3336     for (uint256 i = 1; i <= _amount; i++) {
3337         addressMintedBalance[msg.sender]++;
3338 
3339         uint256 newTokenId = _getNextOwnerTokenId();
3340         _safeMint(_to, newTokenId);
3341         _incrementOwnerTokenId();
3342     } 
3343   }
3344 
3345   function verifySender(bytes memory signature) public view returns (bool) {
3346     bytes32 hash = ECDSA.toEthSignedMessageHash(keccak256(abi.encodePacked(msg.sender)));
3347     return ECDSA.recover(hash, signature) == signerAddress;
3348   }
3349 
3350   
3351   // public
3352   function mint(uint256 _mintAmount, bytes memory signature) public payable {
3353     require(!pausedMint, "the contract is paused");
3354     require(_mintAmount > 0, "need to mint at least 1 NFT");    
3355     require((_currentTokenId + _mintAmount) < (maxSupply - ownerMaxSupply), "Not allowed to mint from owners pool");
3356     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
3357     require(verifySender(signature), "invalid access");
3358 
3359     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
3360     require((ownerMintedCount + _mintAmount) <= nftPerAddressLimit, "max NFT per address exceeded");
3361     
3362     require(msg.value >= mintCost * _mintAmount);
3363     
3364     for (uint256 i = 1; i <= _mintAmount; i++) {
3365       
3366       addressMintedBalance[msg.sender]++;
3367 
3368       uint256 newTokenId = _getNextTokenId();
3369       _safeMint(msg.sender, newTokenId);
3370       _incrementTokenId();
3371     }
3372   }
3373 
3374   function _getNextOwnerTokenId() private view returns (uint256) {
3375     return ownerTokenId.add(1);
3376   }
3377 
3378   function _incrementOwnerTokenId() private {
3379     ownerTokenId++;
3380   }
3381 
3382   function _getNextTokenId() private view returns (uint256) {
3383     return _currentTokenId.add(1);
3384   }
3385 
3386   function _incrementTokenId() private {
3387     _currentTokenId++;
3388   }
3389 
3390   function walletOfOwner(address _owner)
3391     public
3392     view
3393     returns (uint256[] memory)
3394   {
3395     uint256 ownerTokenCount = balanceOf(_owner);
3396     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
3397     for (uint256 i; i < ownerTokenCount; i++) {
3398       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
3399     }
3400     return tokenIds;
3401   }
3402 
3403   function tokenURI(uint256 tokenId)
3404     public
3405     view
3406     virtual
3407     override
3408     returns (string memory)
3409   {
3410     require(
3411       _exists(tokenId),
3412       "ERC721Metadata: URI query for nonexistent token"
3413     );
3414     
3415     string memory currentBaseURI = _baseURI();
3416     return bytes(currentBaseURI).length > 0
3417         ? string(abi.encodePacked(currentBaseURI, Strings.toString(tokenId), baseExtension))
3418         : "";
3419   }
3420 
3421   function setMintCost(uint256 _newCost) public onlyOwner {
3422     mintCost = _newCost;
3423   }
3424 
3425   function setMaxMintAmount(uint256 _newMaxMintAmount) public onlyOwner {
3426     maxMintAmount = _newMaxMintAmount;
3427   }
3428 
3429   function setMaxAddressNftLimit(uint256 _newMaxLimit) public onlyOwner {
3430     nftPerAddressLimit = _newMaxLimit;
3431   }
3432 
3433   function setBaseURI(string memory _newBaseURI) public onlyOwner {
3434     baseURI = _newBaseURI;
3435   }
3436 
3437   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
3438     baseExtension = _newBaseExtension;
3439   }
3440 
3441   function setSignerAddress(address _newSignerAddress) public onlyOwner {
3442     signerAddress = _newSignerAddress;
3443   }
3444 
3445   function pauseMint(bool _state) public onlyOwner {
3446     pausedMint = _state;
3447   }
3448 
3449   function withdraw() public payable onlyOwner {
3450     // This will payout the owner 100% of the contract balance.
3451     // Do not remove this otherwise you will not be able to withdraw the funds.
3452     // =============================================================================
3453     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
3454     require(os);
3455     // =============================================================================
3456   }
3457 }