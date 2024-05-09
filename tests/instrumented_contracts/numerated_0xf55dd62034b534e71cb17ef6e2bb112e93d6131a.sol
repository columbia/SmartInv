1 // Sources flattened with hardhat v2.6.2 https://hardhat.org
2 
3 // File hardhat/console.sol@v2.6.2
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity >= 0.4.22 <0.9.0;
7 
8 library console {
9 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
10 
11 	function _sendLogPayload(bytes memory payload) private view {
12 		uint256 payloadLength = payload.length;
13 		address consoleAddress = CONSOLE_ADDRESS;
14 		assembly {
15 			let payloadStart := add(payload, 32)
16 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
17 		}
18 	}
19 
20 	function log() internal view {
21 		_sendLogPayload(abi.encodeWithSignature("log()"));
22 	}
23 
24 	function logInt(int p0) internal view {
25 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
26 	}
27 
28 	function logUint(uint p0) internal view {
29 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
30 	}
31 
32 	function logString(string memory p0) internal view {
33 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
34 	}
35 
36 	function logBool(bool p0) internal view {
37 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
38 	}
39 
40 	function logAddress(address p0) internal view {
41 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
42 	}
43 
44 	function logBytes(bytes memory p0) internal view {
45 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
46 	}
47 
48 	function logBytes1(bytes1 p0) internal view {
49 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
50 	}
51 
52 	function logBytes2(bytes2 p0) internal view {
53 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
54 	}
55 
56 	function logBytes3(bytes3 p0) internal view {
57 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
58 	}
59 
60 	function logBytes4(bytes4 p0) internal view {
61 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
62 	}
63 
64 	function logBytes5(bytes5 p0) internal view {
65 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
66 	}
67 
68 	function logBytes6(bytes6 p0) internal view {
69 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
70 	}
71 
72 	function logBytes7(bytes7 p0) internal view {
73 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
74 	}
75 
76 	function logBytes8(bytes8 p0) internal view {
77 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
78 	}
79 
80 	function logBytes9(bytes9 p0) internal view {
81 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
82 	}
83 
84 	function logBytes10(bytes10 p0) internal view {
85 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
86 	}
87 
88 	function logBytes11(bytes11 p0) internal view {
89 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
90 	}
91 
92 	function logBytes12(bytes12 p0) internal view {
93 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
94 	}
95 
96 	function logBytes13(bytes13 p0) internal view {
97 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
98 	}
99 
100 	function logBytes14(bytes14 p0) internal view {
101 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
102 	}
103 
104 	function logBytes15(bytes15 p0) internal view {
105 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
106 	}
107 
108 	function logBytes16(bytes16 p0) internal view {
109 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
110 	}
111 
112 	function logBytes17(bytes17 p0) internal view {
113 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
114 	}
115 
116 	function logBytes18(bytes18 p0) internal view {
117 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
118 	}
119 
120 	function logBytes19(bytes19 p0) internal view {
121 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
122 	}
123 
124 	function logBytes20(bytes20 p0) internal view {
125 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
126 	}
127 
128 	function logBytes21(bytes21 p0) internal view {
129 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
130 	}
131 
132 	function logBytes22(bytes22 p0) internal view {
133 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
134 	}
135 
136 	function logBytes23(bytes23 p0) internal view {
137 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
138 	}
139 
140 	function logBytes24(bytes24 p0) internal view {
141 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
142 	}
143 
144 	function logBytes25(bytes25 p0) internal view {
145 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
146 	}
147 
148 	function logBytes26(bytes26 p0) internal view {
149 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
150 	}
151 
152 	function logBytes27(bytes27 p0) internal view {
153 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
154 	}
155 
156 	function logBytes28(bytes28 p0) internal view {
157 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
158 	}
159 
160 	function logBytes29(bytes29 p0) internal view {
161 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
162 	}
163 
164 	function logBytes30(bytes30 p0) internal view {
165 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
166 	}
167 
168 	function logBytes31(bytes31 p0) internal view {
169 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
170 	}
171 
172 	function logBytes32(bytes32 p0) internal view {
173 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
174 	}
175 
176 	function log(uint p0) internal view {
177 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
178 	}
179 
180 	function log(string memory p0) internal view {
181 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
182 	}
183 
184 	function log(bool p0) internal view {
185 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
186 	}
187 
188 	function log(address p0) internal view {
189 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
190 	}
191 
192 	function log(uint p0, uint p1) internal view {
193 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
194 	}
195 
196 	function log(uint p0, string memory p1) internal view {
197 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
198 	}
199 
200 	function log(uint p0, bool p1) internal view {
201 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
202 	}
203 
204 	function log(uint p0, address p1) internal view {
205 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
206 	}
207 
208 	function log(string memory p0, uint p1) internal view {
209 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
210 	}
211 
212 	function log(string memory p0, string memory p1) internal view {
213 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
214 	}
215 
216 	function log(string memory p0, bool p1) internal view {
217 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
218 	}
219 
220 	function log(string memory p0, address p1) internal view {
221 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
222 	}
223 
224 	function log(bool p0, uint p1) internal view {
225 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
226 	}
227 
228 	function log(bool p0, string memory p1) internal view {
229 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
230 	}
231 
232 	function log(bool p0, bool p1) internal view {
233 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
234 	}
235 
236 	function log(bool p0, address p1) internal view {
237 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
238 	}
239 
240 	function log(address p0, uint p1) internal view {
241 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
242 	}
243 
244 	function log(address p0, string memory p1) internal view {
245 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
246 	}
247 
248 	function log(address p0, bool p1) internal view {
249 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
250 	}
251 
252 	function log(address p0, address p1) internal view {
253 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
254 	}
255 
256 	function log(uint p0, uint p1, uint p2) internal view {
257 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
258 	}
259 
260 	function log(uint p0, uint p1, string memory p2) internal view {
261 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
262 	}
263 
264 	function log(uint p0, uint p1, bool p2) internal view {
265 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
266 	}
267 
268 	function log(uint p0, uint p1, address p2) internal view {
269 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
270 	}
271 
272 	function log(uint p0, string memory p1, uint p2) internal view {
273 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
274 	}
275 
276 	function log(uint p0, string memory p1, string memory p2) internal view {
277 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
278 	}
279 
280 	function log(uint p0, string memory p1, bool p2) internal view {
281 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
282 	}
283 
284 	function log(uint p0, string memory p1, address p2) internal view {
285 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
286 	}
287 
288 	function log(uint p0, bool p1, uint p2) internal view {
289 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
290 	}
291 
292 	function log(uint p0, bool p1, string memory p2) internal view {
293 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
294 	}
295 
296 	function log(uint p0, bool p1, bool p2) internal view {
297 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
298 	}
299 
300 	function log(uint p0, bool p1, address p2) internal view {
301 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
302 	}
303 
304 	function log(uint p0, address p1, uint p2) internal view {
305 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
306 	}
307 
308 	function log(uint p0, address p1, string memory p2) internal view {
309 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
310 	}
311 
312 	function log(uint p0, address p1, bool p2) internal view {
313 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
314 	}
315 
316 	function log(uint p0, address p1, address p2) internal view {
317 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
318 	}
319 
320 	function log(string memory p0, uint p1, uint p2) internal view {
321 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
322 	}
323 
324 	function log(string memory p0, uint p1, string memory p2) internal view {
325 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
326 	}
327 
328 	function log(string memory p0, uint p1, bool p2) internal view {
329 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
330 	}
331 
332 	function log(string memory p0, uint p1, address p2) internal view {
333 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
334 	}
335 
336 	function log(string memory p0, string memory p1, uint p2) internal view {
337 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
338 	}
339 
340 	function log(string memory p0, string memory p1, string memory p2) internal view {
341 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
342 	}
343 
344 	function log(string memory p0, string memory p1, bool p2) internal view {
345 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
346 	}
347 
348 	function log(string memory p0, string memory p1, address p2) internal view {
349 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
350 	}
351 
352 	function log(string memory p0, bool p1, uint p2) internal view {
353 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
354 	}
355 
356 	function log(string memory p0, bool p1, string memory p2) internal view {
357 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
358 	}
359 
360 	function log(string memory p0, bool p1, bool p2) internal view {
361 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
362 	}
363 
364 	function log(string memory p0, bool p1, address p2) internal view {
365 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
366 	}
367 
368 	function log(string memory p0, address p1, uint p2) internal view {
369 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
370 	}
371 
372 	function log(string memory p0, address p1, string memory p2) internal view {
373 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
374 	}
375 
376 	function log(string memory p0, address p1, bool p2) internal view {
377 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
378 	}
379 
380 	function log(string memory p0, address p1, address p2) internal view {
381 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
382 	}
383 
384 	function log(bool p0, uint p1, uint p2) internal view {
385 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
386 	}
387 
388 	function log(bool p0, uint p1, string memory p2) internal view {
389 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
390 	}
391 
392 	function log(bool p0, uint p1, bool p2) internal view {
393 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
394 	}
395 
396 	function log(bool p0, uint p1, address p2) internal view {
397 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
398 	}
399 
400 	function log(bool p0, string memory p1, uint p2) internal view {
401 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
402 	}
403 
404 	function log(bool p0, string memory p1, string memory p2) internal view {
405 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
406 	}
407 
408 	function log(bool p0, string memory p1, bool p2) internal view {
409 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
410 	}
411 
412 	function log(bool p0, string memory p1, address p2) internal view {
413 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
414 	}
415 
416 	function log(bool p0, bool p1, uint p2) internal view {
417 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
418 	}
419 
420 	function log(bool p0, bool p1, string memory p2) internal view {
421 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
422 	}
423 
424 	function log(bool p0, bool p1, bool p2) internal view {
425 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
426 	}
427 
428 	function log(bool p0, bool p1, address p2) internal view {
429 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
430 	}
431 
432 	function log(bool p0, address p1, uint p2) internal view {
433 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
434 	}
435 
436 	function log(bool p0, address p1, string memory p2) internal view {
437 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
438 	}
439 
440 	function log(bool p0, address p1, bool p2) internal view {
441 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
442 	}
443 
444 	function log(bool p0, address p1, address p2) internal view {
445 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
446 	}
447 
448 	function log(address p0, uint p1, uint p2) internal view {
449 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
450 	}
451 
452 	function log(address p0, uint p1, string memory p2) internal view {
453 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
454 	}
455 
456 	function log(address p0, uint p1, bool p2) internal view {
457 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
458 	}
459 
460 	function log(address p0, uint p1, address p2) internal view {
461 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
462 	}
463 
464 	function log(address p0, string memory p1, uint p2) internal view {
465 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
466 	}
467 
468 	function log(address p0, string memory p1, string memory p2) internal view {
469 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
470 	}
471 
472 	function log(address p0, string memory p1, bool p2) internal view {
473 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
474 	}
475 
476 	function log(address p0, string memory p1, address p2) internal view {
477 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
478 	}
479 
480 	function log(address p0, bool p1, uint p2) internal view {
481 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
482 	}
483 
484 	function log(address p0, bool p1, string memory p2) internal view {
485 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
486 	}
487 
488 	function log(address p0, bool p1, bool p2) internal view {
489 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
490 	}
491 
492 	function log(address p0, bool p1, address p2) internal view {
493 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
494 	}
495 
496 	function log(address p0, address p1, uint p2) internal view {
497 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
498 	}
499 
500 	function log(address p0, address p1, string memory p2) internal view {
501 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
502 	}
503 
504 	function log(address p0, address p1, bool p2) internal view {
505 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
506 	}
507 
508 	function log(address p0, address p1, address p2) internal view {
509 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
510 	}
511 
512 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
513 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
514 	}
515 
516 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
517 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
518 	}
519 
520 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
521 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
522 	}
523 
524 	function log(uint p0, uint p1, uint p2, address p3) internal view {
525 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
526 	}
527 
528 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
529 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
530 	}
531 
532 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
533 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
534 	}
535 
536 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
537 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
538 	}
539 
540 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
541 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
542 	}
543 
544 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
545 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
546 	}
547 
548 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
549 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
550 	}
551 
552 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
553 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
554 	}
555 
556 	function log(uint p0, uint p1, bool p2, address p3) internal view {
557 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
558 	}
559 
560 	function log(uint p0, uint p1, address p2, uint p3) internal view {
561 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
562 	}
563 
564 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
565 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
566 	}
567 
568 	function log(uint p0, uint p1, address p2, bool p3) internal view {
569 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
570 	}
571 
572 	function log(uint p0, uint p1, address p2, address p3) internal view {
573 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
574 	}
575 
576 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
577 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
578 	}
579 
580 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
581 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
582 	}
583 
584 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
585 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
586 	}
587 
588 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
589 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
590 	}
591 
592 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
593 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
594 	}
595 
596 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
597 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
598 	}
599 
600 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
601 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
602 	}
603 
604 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
605 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
606 	}
607 
608 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
609 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
610 	}
611 
612 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
613 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
614 	}
615 
616 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
617 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
618 	}
619 
620 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
621 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
622 	}
623 
624 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
625 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
626 	}
627 
628 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
629 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
630 	}
631 
632 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
633 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
634 	}
635 
636 	function log(uint p0, string memory p1, address p2, address p3) internal view {
637 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
638 	}
639 
640 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
641 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
642 	}
643 
644 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
645 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
646 	}
647 
648 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
649 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
650 	}
651 
652 	function log(uint p0, bool p1, uint p2, address p3) internal view {
653 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
654 	}
655 
656 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
657 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
658 	}
659 
660 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
661 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
662 	}
663 
664 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
665 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
666 	}
667 
668 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
669 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
670 	}
671 
672 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
673 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
674 	}
675 
676 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
677 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
678 	}
679 
680 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
681 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
682 	}
683 
684 	function log(uint p0, bool p1, bool p2, address p3) internal view {
685 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
686 	}
687 
688 	function log(uint p0, bool p1, address p2, uint p3) internal view {
689 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
690 	}
691 
692 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
693 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
694 	}
695 
696 	function log(uint p0, bool p1, address p2, bool p3) internal view {
697 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
698 	}
699 
700 	function log(uint p0, bool p1, address p2, address p3) internal view {
701 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
702 	}
703 
704 	function log(uint p0, address p1, uint p2, uint p3) internal view {
705 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
706 	}
707 
708 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
709 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
710 	}
711 
712 	function log(uint p0, address p1, uint p2, bool p3) internal view {
713 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
714 	}
715 
716 	function log(uint p0, address p1, uint p2, address p3) internal view {
717 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
718 	}
719 
720 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
721 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
722 	}
723 
724 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
725 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
726 	}
727 
728 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
729 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
730 	}
731 
732 	function log(uint p0, address p1, string memory p2, address p3) internal view {
733 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
734 	}
735 
736 	function log(uint p0, address p1, bool p2, uint p3) internal view {
737 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
738 	}
739 
740 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
741 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
742 	}
743 
744 	function log(uint p0, address p1, bool p2, bool p3) internal view {
745 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
746 	}
747 
748 	function log(uint p0, address p1, bool p2, address p3) internal view {
749 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
750 	}
751 
752 	function log(uint p0, address p1, address p2, uint p3) internal view {
753 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
754 	}
755 
756 	function log(uint p0, address p1, address p2, string memory p3) internal view {
757 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
758 	}
759 
760 	function log(uint p0, address p1, address p2, bool p3) internal view {
761 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
762 	}
763 
764 	function log(uint p0, address p1, address p2, address p3) internal view {
765 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
766 	}
767 
768 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
769 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
770 	}
771 
772 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
773 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
774 	}
775 
776 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
777 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
778 	}
779 
780 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
781 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
782 	}
783 
784 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
785 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
786 	}
787 
788 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
789 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
790 	}
791 
792 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
793 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
794 	}
795 
796 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
797 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
798 	}
799 
800 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
801 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
802 	}
803 
804 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
805 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
806 	}
807 
808 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
809 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
810 	}
811 
812 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
813 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
814 	}
815 
816 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
817 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
818 	}
819 
820 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
821 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
822 	}
823 
824 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
825 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
826 	}
827 
828 	function log(string memory p0, uint p1, address p2, address p3) internal view {
829 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
830 	}
831 
832 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
833 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
834 	}
835 
836 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
837 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
838 	}
839 
840 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
841 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
842 	}
843 
844 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
845 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
846 	}
847 
848 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
849 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
850 	}
851 
852 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
853 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
854 	}
855 
856 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
857 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
858 	}
859 
860 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
861 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
862 	}
863 
864 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
865 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
866 	}
867 
868 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
869 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
870 	}
871 
872 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
873 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
874 	}
875 
876 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
877 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
878 	}
879 
880 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
881 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
882 	}
883 
884 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
885 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
886 	}
887 
888 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
889 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
890 	}
891 
892 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
893 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
894 	}
895 
896 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
897 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
898 	}
899 
900 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
901 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
902 	}
903 
904 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
905 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
906 	}
907 
908 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
909 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
910 	}
911 
912 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
913 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
914 	}
915 
916 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
917 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
918 	}
919 
920 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
921 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
922 	}
923 
924 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
925 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
926 	}
927 
928 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
929 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
930 	}
931 
932 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
933 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
934 	}
935 
936 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
937 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
938 	}
939 
940 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
941 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
942 	}
943 
944 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
945 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
946 	}
947 
948 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
949 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
950 	}
951 
952 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
953 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
954 	}
955 
956 	function log(string memory p0, bool p1, address p2, address p3) internal view {
957 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
958 	}
959 
960 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
961 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
962 	}
963 
964 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
965 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
966 	}
967 
968 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
969 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
970 	}
971 
972 	function log(string memory p0, address p1, uint p2, address p3) internal view {
973 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
974 	}
975 
976 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
977 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
978 	}
979 
980 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
981 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
982 	}
983 
984 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
985 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
986 	}
987 
988 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
989 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
990 	}
991 
992 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
993 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
994 	}
995 
996 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
997 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
998 	}
999 
1000 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
1001 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
1002 	}
1003 
1004 	function log(string memory p0, address p1, bool p2, address p3) internal view {
1005 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
1006 	}
1007 
1008 	function log(string memory p0, address p1, address p2, uint p3) internal view {
1009 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
1010 	}
1011 
1012 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
1013 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
1014 	}
1015 
1016 	function log(string memory p0, address p1, address p2, bool p3) internal view {
1017 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
1018 	}
1019 
1020 	function log(string memory p0, address p1, address p2, address p3) internal view {
1021 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
1022 	}
1023 
1024 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
1025 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
1026 	}
1027 
1028 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
1029 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
1030 	}
1031 
1032 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
1033 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
1034 	}
1035 
1036 	function log(bool p0, uint p1, uint p2, address p3) internal view {
1037 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
1038 	}
1039 
1040 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
1041 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
1042 	}
1043 
1044 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
1045 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
1046 	}
1047 
1048 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
1049 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
1050 	}
1051 
1052 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
1053 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
1054 	}
1055 
1056 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
1057 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
1058 	}
1059 
1060 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
1061 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
1062 	}
1063 
1064 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
1065 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
1066 	}
1067 
1068 	function log(bool p0, uint p1, bool p2, address p3) internal view {
1069 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
1070 	}
1071 
1072 	function log(bool p0, uint p1, address p2, uint p3) internal view {
1073 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
1074 	}
1075 
1076 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
1077 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
1078 	}
1079 
1080 	function log(bool p0, uint p1, address p2, bool p3) internal view {
1081 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
1082 	}
1083 
1084 	function log(bool p0, uint p1, address p2, address p3) internal view {
1085 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
1086 	}
1087 
1088 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
1089 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
1090 	}
1091 
1092 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
1093 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
1094 	}
1095 
1096 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
1097 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
1098 	}
1099 
1100 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
1101 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
1102 	}
1103 
1104 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
1105 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
1106 	}
1107 
1108 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
1109 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
1110 	}
1111 
1112 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
1113 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
1114 	}
1115 
1116 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
1117 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
1118 	}
1119 
1120 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
1121 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
1122 	}
1123 
1124 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
1125 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
1126 	}
1127 
1128 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
1129 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
1130 	}
1131 
1132 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
1133 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
1134 	}
1135 
1136 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
1137 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
1138 	}
1139 
1140 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
1141 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
1142 	}
1143 
1144 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
1145 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
1146 	}
1147 
1148 	function log(bool p0, string memory p1, address p2, address p3) internal view {
1149 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
1150 	}
1151 
1152 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
1153 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
1154 	}
1155 
1156 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
1157 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
1158 	}
1159 
1160 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
1161 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
1162 	}
1163 
1164 	function log(bool p0, bool p1, uint p2, address p3) internal view {
1165 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
1166 	}
1167 
1168 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
1169 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
1170 	}
1171 
1172 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
1173 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
1174 	}
1175 
1176 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
1177 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
1178 	}
1179 
1180 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
1181 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
1182 	}
1183 
1184 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
1185 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
1186 	}
1187 
1188 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
1189 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
1190 	}
1191 
1192 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
1193 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
1194 	}
1195 
1196 	function log(bool p0, bool p1, bool p2, address p3) internal view {
1197 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
1198 	}
1199 
1200 	function log(bool p0, bool p1, address p2, uint p3) internal view {
1201 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
1202 	}
1203 
1204 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
1205 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
1206 	}
1207 
1208 	function log(bool p0, bool p1, address p2, bool p3) internal view {
1209 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
1210 	}
1211 
1212 	function log(bool p0, bool p1, address p2, address p3) internal view {
1213 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
1214 	}
1215 
1216 	function log(bool p0, address p1, uint p2, uint p3) internal view {
1217 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
1218 	}
1219 
1220 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
1221 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
1222 	}
1223 
1224 	function log(bool p0, address p1, uint p2, bool p3) internal view {
1225 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
1226 	}
1227 
1228 	function log(bool p0, address p1, uint p2, address p3) internal view {
1229 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
1230 	}
1231 
1232 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
1233 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
1234 	}
1235 
1236 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
1237 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
1238 	}
1239 
1240 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
1241 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
1242 	}
1243 
1244 	function log(bool p0, address p1, string memory p2, address p3) internal view {
1245 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
1246 	}
1247 
1248 	function log(bool p0, address p1, bool p2, uint p3) internal view {
1249 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
1250 	}
1251 
1252 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
1253 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
1254 	}
1255 
1256 	function log(bool p0, address p1, bool p2, bool p3) internal view {
1257 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
1258 	}
1259 
1260 	function log(bool p0, address p1, bool p2, address p3) internal view {
1261 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
1262 	}
1263 
1264 	function log(bool p0, address p1, address p2, uint p3) internal view {
1265 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
1266 	}
1267 
1268 	function log(bool p0, address p1, address p2, string memory p3) internal view {
1269 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
1270 	}
1271 
1272 	function log(bool p0, address p1, address p2, bool p3) internal view {
1273 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
1274 	}
1275 
1276 	function log(bool p0, address p1, address p2, address p3) internal view {
1277 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
1278 	}
1279 
1280 	function log(address p0, uint p1, uint p2, uint p3) internal view {
1281 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
1282 	}
1283 
1284 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
1285 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
1286 	}
1287 
1288 	function log(address p0, uint p1, uint p2, bool p3) internal view {
1289 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
1290 	}
1291 
1292 	function log(address p0, uint p1, uint p2, address p3) internal view {
1293 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
1294 	}
1295 
1296 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
1297 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
1298 	}
1299 
1300 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
1301 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
1302 	}
1303 
1304 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
1305 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
1306 	}
1307 
1308 	function log(address p0, uint p1, string memory p2, address p3) internal view {
1309 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
1310 	}
1311 
1312 	function log(address p0, uint p1, bool p2, uint p3) internal view {
1313 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
1314 	}
1315 
1316 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
1317 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
1318 	}
1319 
1320 	function log(address p0, uint p1, bool p2, bool p3) internal view {
1321 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
1322 	}
1323 
1324 	function log(address p0, uint p1, bool p2, address p3) internal view {
1325 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
1326 	}
1327 
1328 	function log(address p0, uint p1, address p2, uint p3) internal view {
1329 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
1330 	}
1331 
1332 	function log(address p0, uint p1, address p2, string memory p3) internal view {
1333 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
1334 	}
1335 
1336 	function log(address p0, uint p1, address p2, bool p3) internal view {
1337 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
1338 	}
1339 
1340 	function log(address p0, uint p1, address p2, address p3) internal view {
1341 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
1342 	}
1343 
1344 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
1345 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
1346 	}
1347 
1348 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
1349 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
1350 	}
1351 
1352 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
1353 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
1354 	}
1355 
1356 	function log(address p0, string memory p1, uint p2, address p3) internal view {
1357 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
1358 	}
1359 
1360 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
1361 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
1362 	}
1363 
1364 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
1365 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
1366 	}
1367 
1368 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
1369 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
1370 	}
1371 
1372 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
1373 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
1374 	}
1375 
1376 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
1377 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
1378 	}
1379 
1380 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
1381 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
1382 	}
1383 
1384 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
1385 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
1386 	}
1387 
1388 	function log(address p0, string memory p1, bool p2, address p3) internal view {
1389 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
1390 	}
1391 
1392 	function log(address p0, string memory p1, address p2, uint p3) internal view {
1393 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
1394 	}
1395 
1396 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
1397 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
1398 	}
1399 
1400 	function log(address p0, string memory p1, address p2, bool p3) internal view {
1401 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
1402 	}
1403 
1404 	function log(address p0, string memory p1, address p2, address p3) internal view {
1405 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
1406 	}
1407 
1408 	function log(address p0, bool p1, uint p2, uint p3) internal view {
1409 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
1410 	}
1411 
1412 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
1413 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
1414 	}
1415 
1416 	function log(address p0, bool p1, uint p2, bool p3) internal view {
1417 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
1418 	}
1419 
1420 	function log(address p0, bool p1, uint p2, address p3) internal view {
1421 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
1422 	}
1423 
1424 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
1425 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
1426 	}
1427 
1428 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
1429 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
1430 	}
1431 
1432 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
1433 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
1434 	}
1435 
1436 	function log(address p0, bool p1, string memory p2, address p3) internal view {
1437 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
1438 	}
1439 
1440 	function log(address p0, bool p1, bool p2, uint p3) internal view {
1441 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
1442 	}
1443 
1444 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
1445 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
1446 	}
1447 
1448 	function log(address p0, bool p1, bool p2, bool p3) internal view {
1449 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
1450 	}
1451 
1452 	function log(address p0, bool p1, bool p2, address p3) internal view {
1453 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
1454 	}
1455 
1456 	function log(address p0, bool p1, address p2, uint p3) internal view {
1457 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
1458 	}
1459 
1460 	function log(address p0, bool p1, address p2, string memory p3) internal view {
1461 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
1462 	}
1463 
1464 	function log(address p0, bool p1, address p2, bool p3) internal view {
1465 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
1466 	}
1467 
1468 	function log(address p0, bool p1, address p2, address p3) internal view {
1469 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
1470 	}
1471 
1472 	function log(address p0, address p1, uint p2, uint p3) internal view {
1473 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
1474 	}
1475 
1476 	function log(address p0, address p1, uint p2, string memory p3) internal view {
1477 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
1478 	}
1479 
1480 	function log(address p0, address p1, uint p2, bool p3) internal view {
1481 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
1482 	}
1483 
1484 	function log(address p0, address p1, uint p2, address p3) internal view {
1485 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
1486 	}
1487 
1488 	function log(address p0, address p1, string memory p2, uint p3) internal view {
1489 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
1490 	}
1491 
1492 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
1493 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
1494 	}
1495 
1496 	function log(address p0, address p1, string memory p2, bool p3) internal view {
1497 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
1498 	}
1499 
1500 	function log(address p0, address p1, string memory p2, address p3) internal view {
1501 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
1502 	}
1503 
1504 	function log(address p0, address p1, bool p2, uint p3) internal view {
1505 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
1506 	}
1507 
1508 	function log(address p0, address p1, bool p2, string memory p3) internal view {
1509 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
1510 	}
1511 
1512 	function log(address p0, address p1, bool p2, bool p3) internal view {
1513 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
1514 	}
1515 
1516 	function log(address p0, address p1, bool p2, address p3) internal view {
1517 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
1518 	}
1519 
1520 	function log(address p0, address p1, address p2, uint p3) internal view {
1521 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
1522 	}
1523 
1524 	function log(address p0, address p1, address p2, string memory p3) internal view {
1525 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
1526 	}
1527 
1528 	function log(address p0, address p1, address p2, bool p3) internal view {
1529 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
1530 	}
1531 
1532 	function log(address p0, address p1, address p2, address p3) internal view {
1533 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
1534 	}
1535 
1536 }
1537 
1538 
1539 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.1
1540 
1541 
1542 pragma solidity ^0.8.0;
1543 
1544 /**
1545  * @dev Interface of the ERC165 standard, as defined in the
1546  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1547  *
1548  * Implementers can declare support of contract interfaces, which can then be
1549  * queried by others ({ERC165Checker}).
1550  *
1551  * For an implementation, see {ERC165}.
1552  */
1553 interface IERC165 {
1554     /**
1555      * @dev Returns true if this contract implements the interface defined by
1556      * `interfaceId`. See the corresponding
1557      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1558      * to learn more about how these ids are created.
1559      *
1560      * This function call must use less than 30 000 gas.
1561      */
1562     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1563 }
1564 
1565 
1566 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.1
1567 
1568 
1569 pragma solidity ^0.8.0;
1570 
1571 /**
1572  * @dev Required interface of an ERC721 compliant contract.
1573  */
1574 interface IERC721 is IERC165 {
1575     /**
1576      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1577      */
1578     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1579 
1580     /**
1581      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1582      */
1583     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1584 
1585     /**
1586      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1587      */
1588     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1589 
1590     /**
1591      * @dev Returns the number of tokens in ``owner``'s account.
1592      */
1593     function balanceOf(address owner) external view returns (uint256 balance);
1594 
1595     /**
1596      * @dev Returns the owner of the `tokenId` token.
1597      *
1598      * Requirements:
1599      *
1600      * - `tokenId` must exist.
1601      */
1602     function ownerOf(uint256 tokenId) external view returns (address owner);
1603 
1604     /**
1605      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1606      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1607      *
1608      * Requirements:
1609      *
1610      * - `from` cannot be the zero address.
1611      * - `to` cannot be the zero address.
1612      * - `tokenId` token must exist and be owned by `from`.
1613      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1614      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1615      *
1616      * Emits a {Transfer} event.
1617      */
1618     function safeTransferFrom(
1619         address from,
1620         address to,
1621         uint256 tokenId
1622     ) external;
1623 
1624     /**
1625      * @dev Transfers `tokenId` token from `from` to `to`.
1626      *
1627      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1628      *
1629      * Requirements:
1630      *
1631      * - `from` cannot be the zero address.
1632      * - `to` cannot be the zero address.
1633      * - `tokenId` token must be owned by `from`.
1634      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1635      *
1636      * Emits a {Transfer} event.
1637      */
1638     function transferFrom(
1639         address from,
1640         address to,
1641         uint256 tokenId
1642     ) external;
1643 
1644     /**
1645      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1646      * The approval is cleared when the token is transferred.
1647      *
1648      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1649      *
1650      * Requirements:
1651      *
1652      * - The caller must own the token or be an approved operator.
1653      * - `tokenId` must exist.
1654      *
1655      * Emits an {Approval} event.
1656      */
1657     function approve(address to, uint256 tokenId) external;
1658 
1659     /**
1660      * @dev Returns the account approved for `tokenId` token.
1661      *
1662      * Requirements:
1663      *
1664      * - `tokenId` must exist.
1665      */
1666     function getApproved(uint256 tokenId) external view returns (address operator);
1667 
1668     /**
1669      * @dev Approve or remove `operator` as an operator for the caller.
1670      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1671      *
1672      * Requirements:
1673      *
1674      * - The `operator` cannot be the caller.
1675      *
1676      * Emits an {ApprovalForAll} event.
1677      */
1678     function setApprovalForAll(address operator, bool _approved) external;
1679 
1680     /**
1681      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1682      *
1683      * See {setApprovalForAll}
1684      */
1685     function isApprovedForAll(address owner, address operator) external view returns (bool);
1686 
1687     /**
1688      * @dev Safely transfers `tokenId` token from `from` to `to`.
1689      *
1690      * Requirements:
1691      *
1692      * - `from` cannot be the zero address.
1693      * - `to` cannot be the zero address.
1694      * - `tokenId` token must exist and be owned by `from`.
1695      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1696      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1697      *
1698      * Emits a {Transfer} event.
1699      */
1700     function safeTransferFrom(
1701         address from,
1702         address to,
1703         uint256 tokenId,
1704         bytes calldata data
1705     ) external;
1706 }
1707 
1708 
1709 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.1
1710 
1711 
1712 pragma solidity ^0.8.0;
1713 
1714 /**
1715  * @title ERC721 token receiver interface
1716  * @dev Interface for any contract that wants to support safeTransfers
1717  * from ERC721 asset contracts.
1718  */
1719 interface IERC721Receiver {
1720     /**
1721      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1722      * by `operator` from `from`, this function is called.
1723      *
1724      * It must return its Solidity selector to confirm the token transfer.
1725      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1726      *
1727      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1728      */
1729     function onERC721Received(
1730         address operator,
1731         address from,
1732         uint256 tokenId,
1733         bytes calldata data
1734     ) external returns (bytes4);
1735 }
1736 
1737 
1738 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.1
1739 
1740 
1741 pragma solidity ^0.8.0;
1742 
1743 /**
1744  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1745  * @dev See https://eips.ethereum.org/EIPS/eip-721
1746  */
1747 interface IERC721Metadata is IERC721 {
1748     /**
1749      * @dev Returns the token collection name.
1750      */
1751     function name() external view returns (string memory);
1752 
1753     /**
1754      * @dev Returns the token collection symbol.
1755      */
1756     function symbol() external view returns (string memory);
1757 
1758     /**
1759      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1760      */
1761     function tokenURI(uint256 tokenId) external view returns (string memory);
1762 }
1763 
1764 
1765 // File @openzeppelin/contracts/utils/Address.sol@v4.3.1
1766 
1767 
1768 pragma solidity ^0.8.0;
1769 
1770 /**
1771  * @dev Collection of functions related to the address type
1772  */
1773 library Address {
1774     /**
1775      * @dev Returns true if `account` is a contract.
1776      *
1777      * [IMPORTANT]
1778      * ====
1779      * It is unsafe to assume that an address for which this function returns
1780      * false is an externally-owned account (EOA) and not a contract.
1781      *
1782      * Among others, `isContract` will return false for the following
1783      * types of addresses:
1784      *
1785      *  - an externally-owned account
1786      *  - a contract in construction
1787      *  - an address where a contract will be created
1788      *  - an address where a contract lived, but was destroyed
1789      * ====
1790      */
1791     function isContract(address account) internal view returns (bool) {
1792         // This method relies on extcodesize, which returns 0 for contracts in
1793         // construction, since the code is only stored at the end of the
1794         // constructor execution.
1795 
1796         uint256 size;
1797         assembly {
1798             size := extcodesize(account)
1799         }
1800         return size > 0;
1801     }
1802 
1803     /**
1804      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1805      * `recipient`, forwarding all available gas and reverting on errors.
1806      *
1807      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1808      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1809      * imposed by `transfer`, making them unable to receive funds via
1810      * `transfer`. {sendValue} removes this limitation.
1811      *
1812      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1813      *
1814      * IMPORTANT: because control is transferred to `recipient`, care must be
1815      * taken to not create reentrancy vulnerabilities. Consider using
1816      * {ReentrancyGuard} or the
1817      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1818      */
1819     function sendValue(address payable recipient, uint256 amount) internal {
1820         require(address(this).balance >= amount, "Address: insufficient balance");
1821 
1822         (bool success, ) = recipient.call{value: amount}("");
1823         require(success, "Address: unable to send value, recipient may have reverted");
1824     }
1825 
1826     /**
1827      * @dev Performs a Solidity function call using a low level `call`. A
1828      * plain `call` is an unsafe replacement for a function call: use this
1829      * function instead.
1830      *
1831      * If `target` reverts with a revert reason, it is bubbled up by this
1832      * function (like regular Solidity function calls).
1833      *
1834      * Returns the raw returned data. To convert to the expected return value,
1835      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1836      *
1837      * Requirements:
1838      *
1839      * - `target` must be a contract.
1840      * - calling `target` with `data` must not revert.
1841      *
1842      * _Available since v3.1._
1843      */
1844     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1845         return functionCall(target, data, "Address: low-level call failed");
1846     }
1847 
1848     /**
1849      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1850      * `errorMessage` as a fallback revert reason when `target` reverts.
1851      *
1852      * _Available since v3.1._
1853      */
1854     function functionCall(
1855         address target,
1856         bytes memory data,
1857         string memory errorMessage
1858     ) internal returns (bytes memory) {
1859         return functionCallWithValue(target, data, 0, errorMessage);
1860     }
1861 
1862     /**
1863      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1864      * but also transferring `value` wei to `target`.
1865      *
1866      * Requirements:
1867      *
1868      * - the calling contract must have an ETH balance of at least `value`.
1869      * - the called Solidity function must be `payable`.
1870      *
1871      * _Available since v3.1._
1872      */
1873     function functionCallWithValue(
1874         address target,
1875         bytes memory data,
1876         uint256 value
1877     ) internal returns (bytes memory) {
1878         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1879     }
1880 
1881     /**
1882      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1883      * with `errorMessage` as a fallback revert reason when `target` reverts.
1884      *
1885      * _Available since v3.1._
1886      */
1887     function functionCallWithValue(
1888         address target,
1889         bytes memory data,
1890         uint256 value,
1891         string memory errorMessage
1892     ) internal returns (bytes memory) {
1893         require(address(this).balance >= value, "Address: insufficient balance for call");
1894         require(isContract(target), "Address: call to non-contract");
1895 
1896         (bool success, bytes memory returndata) = target.call{value: value}(data);
1897         return verifyCallResult(success, returndata, errorMessage);
1898     }
1899 
1900     /**
1901      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1902      * but performing a static call.
1903      *
1904      * _Available since v3.3._
1905      */
1906     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1907         return functionStaticCall(target, data, "Address: low-level static call failed");
1908     }
1909 
1910     /**
1911      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1912      * but performing a static call.
1913      *
1914      * _Available since v3.3._
1915      */
1916     function functionStaticCall(
1917         address target,
1918         bytes memory data,
1919         string memory errorMessage
1920     ) internal view returns (bytes memory) {
1921         require(isContract(target), "Address: static call to non-contract");
1922 
1923         (bool success, bytes memory returndata) = target.staticcall(data);
1924         return verifyCallResult(success, returndata, errorMessage);
1925     }
1926 
1927     /**
1928      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1929      * but performing a delegate call.
1930      *
1931      * _Available since v3.4._
1932      */
1933     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1934         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1935     }
1936 
1937     /**
1938      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1939      * but performing a delegate call.
1940      *
1941      * _Available since v3.4._
1942      */
1943     function functionDelegateCall(
1944         address target,
1945         bytes memory data,
1946         string memory errorMessage
1947     ) internal returns (bytes memory) {
1948         require(isContract(target), "Address: delegate call to non-contract");
1949 
1950         (bool success, bytes memory returndata) = target.delegatecall(data);
1951         return verifyCallResult(success, returndata, errorMessage);
1952     }
1953 
1954     /**
1955      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1956      * revert reason using the provided one.
1957      *
1958      * _Available since v4.3._
1959      */
1960     function verifyCallResult(
1961         bool success,
1962         bytes memory returndata,
1963         string memory errorMessage
1964     ) internal pure returns (bytes memory) {
1965         if (success) {
1966             return returndata;
1967         } else {
1968             // Look for revert reason and bubble it up if present
1969             if (returndata.length > 0) {
1970                 // The easiest way to bubble the revert reason is using memory via assembly
1971 
1972                 assembly {
1973                     let returndata_size := mload(returndata)
1974                     revert(add(32, returndata), returndata_size)
1975                 }
1976             } else {
1977                 revert(errorMessage);
1978             }
1979         }
1980     }
1981 }
1982 
1983 
1984 // File @openzeppelin/contracts/utils/Context.sol@v4.3.1
1985 
1986 
1987 pragma solidity ^0.8.0;
1988 
1989 /**
1990  * @dev Provides information about the current execution context, including the
1991  * sender of the transaction and its data. While these are generally available
1992  * via msg.sender and msg.data, they should not be accessed in such a direct
1993  * manner, since when dealing with meta-transactions the account sending and
1994  * paying for execution may not be the actual sender (as far as an application
1995  * is concerned).
1996  *
1997  * This contract is only required for intermediate, library-like contracts.
1998  */
1999 abstract contract Context {
2000     function _msgSender() internal view virtual returns (address) {
2001         return msg.sender;
2002     }
2003 
2004     function _msgData() internal view virtual returns (bytes calldata) {
2005         return msg.data;
2006     }
2007 }
2008 
2009 
2010 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.1
2011 
2012 
2013 pragma solidity ^0.8.0;
2014 
2015 /**
2016  * @dev String operations.
2017  */
2018 library Strings {
2019     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
2020 
2021     /**
2022      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2023      */
2024     function toString(uint256 value) internal pure returns (string memory) {
2025         // Inspired by OraclizeAPI's implementation - MIT licence
2026         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
2027 
2028         if (value == 0) {
2029             return "0";
2030         }
2031         uint256 temp = value;
2032         uint256 digits;
2033         while (temp != 0) {
2034             digits++;
2035             temp /= 10;
2036         }
2037         bytes memory buffer = new bytes(digits);
2038         while (value != 0) {
2039             digits -= 1;
2040             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
2041             value /= 10;
2042         }
2043         return string(buffer);
2044     }
2045 
2046     /**
2047      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2048      */
2049     function toHexString(uint256 value) internal pure returns (string memory) {
2050         if (value == 0) {
2051             return "0x00";
2052         }
2053         uint256 temp = value;
2054         uint256 length = 0;
2055         while (temp != 0) {
2056             length++;
2057             temp >>= 8;
2058         }
2059         return toHexString(value, length);
2060     }
2061 
2062     /**
2063      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2064      */
2065     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2066         bytes memory buffer = new bytes(2 * length + 2);
2067         buffer[0] = "0";
2068         buffer[1] = "x";
2069         for (uint256 i = 2 * length + 1; i > 1; --i) {
2070             buffer[i] = _HEX_SYMBOLS[value & 0xf];
2071             value >>= 4;
2072         }
2073         require(value == 0, "Strings: hex length insufficient");
2074         return string(buffer);
2075     }
2076 }
2077 
2078 
2079 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.1
2080 
2081 
2082 pragma solidity ^0.8.0;
2083 
2084 /**
2085  * @dev Implementation of the {IERC165} interface.
2086  *
2087  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
2088  * for the additional interface id that will be supported. For example:
2089  *
2090  * ```solidity
2091  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2092  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
2093  * }
2094  * ```
2095  *
2096  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
2097  */
2098 abstract contract ERC165 is IERC165 {
2099     /**
2100      * @dev See {IERC165-supportsInterface}.
2101      */
2102     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2103         return interfaceId == type(IERC165).interfaceId;
2104     }
2105 }
2106 
2107 
2108 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.1
2109 
2110 
2111 pragma solidity ^0.8.0;
2112 
2113 
2114 
2115 
2116 
2117 
2118 
2119 /**
2120  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2121  * the Metadata extension, but not including the Enumerable extension, which is available separately as
2122  * {ERC721Enumerable}.
2123  */
2124 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
2125     using Address for address;
2126     using Strings for uint256;
2127 
2128     // Token name
2129     string private _name;
2130 
2131     // Token symbol
2132     string private _symbol;
2133 
2134     // Mapping from token ID to owner address
2135     mapping(uint256 => address) private _owners;
2136 
2137     // Mapping owner address to token count
2138     mapping(address => uint256) private _balances;
2139 
2140     // Mapping from token ID to approved address
2141     mapping(uint256 => address) private _tokenApprovals;
2142 
2143     // Mapping from owner to operator approvals
2144     mapping(address => mapping(address => bool)) private _operatorApprovals;
2145 
2146     /**
2147      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2148      */
2149     constructor(string memory name_, string memory symbol_) {
2150         _name = name_;
2151         _symbol = symbol_;
2152     }
2153 
2154     /**
2155      * @dev See {IERC165-supportsInterface}.
2156      */
2157     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2158         return
2159             interfaceId == type(IERC721).interfaceId ||
2160             interfaceId == type(IERC721Metadata).interfaceId ||
2161             super.supportsInterface(interfaceId);
2162     }
2163 
2164     /**
2165      * @dev See {IERC721-balanceOf}.
2166      */
2167     function balanceOf(address owner) public view virtual override returns (uint256) {
2168         require(owner != address(0), "ERC721: balance query for the zero address");
2169         return _balances[owner];
2170     }
2171 
2172     /**
2173      * @dev See {IERC721-ownerOf}.
2174      */
2175     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2176         address owner = _owners[tokenId];
2177         require(owner != address(0), "ERC721: owner query for nonexistent token");
2178         return owner;
2179     }
2180 
2181     /**
2182      * @dev See {IERC721Metadata-name}.
2183      */
2184     function name() public view virtual override returns (string memory) {
2185         return _name;
2186     }
2187 
2188     /**
2189      * @dev See {IERC721Metadata-symbol}.
2190      */
2191     function symbol() public view virtual override returns (string memory) {
2192         return _symbol;
2193     }
2194 
2195     /**
2196      * @dev See {IERC721Metadata-tokenURI}.
2197      */
2198     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2199         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2200 
2201         string memory baseURI = _baseURI();
2202         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2203     }
2204 
2205     /**
2206      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2207      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2208      * by default, can be overriden in child contracts.
2209      */
2210     function _baseURI() internal view virtual returns (string memory) {
2211         return "";
2212     }
2213 
2214     /**
2215      * @dev See {IERC721-approve}.
2216      */
2217     function approve(address to, uint256 tokenId) public virtual override {
2218         address owner = ERC721.ownerOf(tokenId);
2219         require(to != owner, "ERC721: approval to current owner");
2220 
2221         require(
2222             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2223             "ERC721: approve caller is not owner nor approved for all"
2224         );
2225 
2226         _approve(to, tokenId);
2227     }
2228 
2229     /**
2230      * @dev See {IERC721-getApproved}.
2231      */
2232     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2233         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
2234 
2235         return _tokenApprovals[tokenId];
2236     }
2237 
2238     /**
2239      * @dev See {IERC721-setApprovalForAll}.
2240      */
2241     function setApprovalForAll(address operator, bool approved) public virtual override {
2242         require(operator != _msgSender(), "ERC721: approve to caller");
2243 
2244         _operatorApprovals[_msgSender()][operator] = approved;
2245         emit ApprovalForAll(_msgSender(), operator, approved);
2246     }
2247 
2248     /**
2249      * @dev See {IERC721-isApprovedForAll}.
2250      */
2251     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2252         return _operatorApprovals[owner][operator];
2253     }
2254 
2255     /**
2256      * @dev See {IERC721-transferFrom}.
2257      */
2258     function transferFrom(
2259         address from,
2260         address to,
2261         uint256 tokenId
2262     ) public virtual override {
2263         //solhint-disable-next-line max-line-length
2264         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2265 
2266         _transfer(from, to, tokenId);
2267     }
2268 
2269     /**
2270      * @dev See {IERC721-safeTransferFrom}.
2271      */
2272     function safeTransferFrom(
2273         address from,
2274         address to,
2275         uint256 tokenId
2276     ) public virtual override {
2277         safeTransferFrom(from, to, tokenId, "");
2278     }
2279 
2280     /**
2281      * @dev See {IERC721-safeTransferFrom}.
2282      */
2283     function safeTransferFrom(
2284         address from,
2285         address to,
2286         uint256 tokenId,
2287         bytes memory _data
2288     ) public virtual override {
2289         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2290         _safeTransfer(from, to, tokenId, _data);
2291     }
2292 
2293     /**
2294      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2295      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2296      *
2297      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
2298      *
2299      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2300      * implement alternative mechanisms to perform token transfer, such as signature-based.
2301      *
2302      * Requirements:
2303      *
2304      * - `from` cannot be the zero address.
2305      * - `to` cannot be the zero address.
2306      * - `tokenId` token must exist and be owned by `from`.
2307      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2308      *
2309      * Emits a {Transfer} event.
2310      */
2311     function _safeTransfer(
2312         address from,
2313         address to,
2314         uint256 tokenId,
2315         bytes memory _data
2316     ) internal virtual {
2317         _transfer(from, to, tokenId);
2318         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
2319     }
2320 
2321     /**
2322      * @dev Returns whether `tokenId` exists.
2323      *
2324      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2325      *
2326      * Tokens start existing when they are minted (`_mint`),
2327      * and stop existing when they are burned (`_burn`).
2328      */
2329     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2330         return _owners[tokenId] != address(0);
2331     }
2332 
2333     /**
2334      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2335      *
2336      * Requirements:
2337      *
2338      * - `tokenId` must exist.
2339      */
2340     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2341         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
2342         address owner = ERC721.ownerOf(tokenId);
2343         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
2344     }
2345 
2346     /**
2347      * @dev Safely mints `tokenId` and transfers it to `to`.
2348      *
2349      * Requirements:
2350      *
2351      * - `tokenId` must not exist.
2352      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2353      *
2354      * Emits a {Transfer} event.
2355      */
2356     function _safeMint(address to, uint256 tokenId) internal virtual {
2357         _safeMint(to, tokenId, "");
2358     }
2359 
2360     /**
2361      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2362      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2363      */
2364     function _safeMint(
2365         address to,
2366         uint256 tokenId,
2367         bytes memory _data
2368     ) internal virtual {
2369         _mint(to, tokenId);
2370         require(
2371             _checkOnERC721Received(address(0), to, tokenId, _data),
2372             "ERC721: transfer to non ERC721Receiver implementer"
2373         );
2374     }
2375 
2376     /**
2377      * @dev Mints `tokenId` and transfers it to `to`.
2378      *
2379      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2380      *
2381      * Requirements:
2382      *
2383      * - `tokenId` must not exist.
2384      * - `to` cannot be the zero address.
2385      *
2386      * Emits a {Transfer} event.
2387      */
2388     function _mint(address to, uint256 tokenId) internal virtual {
2389         require(to != address(0), "ERC721: mint to the zero address");
2390         require(!_exists(tokenId), "ERC721: token already minted");
2391 
2392         _beforeTokenTransfer(address(0), to, tokenId);
2393 
2394         _balances[to] += 1;
2395         _owners[tokenId] = to;
2396 
2397         emit Transfer(address(0), to, tokenId);
2398     }
2399 
2400     /**
2401      * @dev Destroys `tokenId`.
2402      * The approval is cleared when the token is burned.
2403      *
2404      * Requirements:
2405      *
2406      * - `tokenId` must exist.
2407      *
2408      * Emits a {Transfer} event.
2409      */
2410     function _burn(uint256 tokenId) internal virtual {
2411         address owner = ERC721.ownerOf(tokenId);
2412 
2413         _beforeTokenTransfer(owner, address(0), tokenId);
2414 
2415         // Clear approvals
2416         _approve(address(0), tokenId);
2417 
2418         _balances[owner] -= 1;
2419         delete _owners[tokenId];
2420 
2421         emit Transfer(owner, address(0), tokenId);
2422     }
2423 
2424     /**
2425      * @dev Transfers `tokenId` from `from` to `to`.
2426      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2427      *
2428      * Requirements:
2429      *
2430      * - `to` cannot be the zero address.
2431      * - `tokenId` token must be owned by `from`.
2432      *
2433      * Emits a {Transfer} event.
2434      */
2435     function _transfer(
2436         address from,
2437         address to,
2438         uint256 tokenId
2439     ) internal virtual {
2440         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
2441         require(to != address(0), "ERC721: transfer to the zero address");
2442 
2443         _beforeTokenTransfer(from, to, tokenId);
2444 
2445         // Clear approvals from the previous owner
2446         _approve(address(0), tokenId);
2447 
2448         _balances[from] -= 1;
2449         _balances[to] += 1;
2450         _owners[tokenId] = to;
2451 
2452         emit Transfer(from, to, tokenId);
2453     }
2454 
2455     /**
2456      * @dev Approve `to` to operate on `tokenId`
2457      *
2458      * Emits a {Approval} event.
2459      */
2460     function _approve(address to, uint256 tokenId) internal virtual {
2461         _tokenApprovals[tokenId] = to;
2462         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2463     }
2464 
2465     /**
2466      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2467      * The call is not executed if the target address is not a contract.
2468      *
2469      * @param from address representing the previous owner of the given token ID
2470      * @param to target address that will receive the tokens
2471      * @param tokenId uint256 ID of the token to be transferred
2472      * @param _data bytes optional data to send along with the call
2473      * @return bool whether the call correctly returned the expected magic value
2474      */
2475     function _checkOnERC721Received(
2476         address from,
2477         address to,
2478         uint256 tokenId,
2479         bytes memory _data
2480     ) private returns (bool) {
2481         if (to.isContract()) {
2482             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2483                 return retval == IERC721Receiver.onERC721Received.selector;
2484             } catch (bytes memory reason) {
2485                 if (reason.length == 0) {
2486                     revert("ERC721: transfer to non ERC721Receiver implementer");
2487                 } else {
2488                     assembly {
2489                         revert(add(32, reason), mload(reason))
2490                     }
2491                 }
2492             }
2493         } else {
2494             return true;
2495         }
2496     }
2497 
2498     /**
2499      * @dev Hook that is called before any token transfer. This includes minting
2500      * and burning.
2501      *
2502      * Calling conditions:
2503      *
2504      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2505      * transferred to `to`.
2506      * - When `from` is zero, `tokenId` will be minted for `to`.
2507      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2508      * - `from` and `to` are never both zero.
2509      *
2510      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2511      */
2512     function _beforeTokenTransfer(
2513         address from,
2514         address to,
2515         uint256 tokenId
2516     ) internal virtual {}
2517 }
2518 
2519 
2520 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.1
2521 
2522 
2523 pragma solidity ^0.8.0;
2524 
2525 /**
2526  * @dev Contract module which provides a basic access control mechanism, where
2527  * there is an account (an owner) that can be granted exclusive access to
2528  * specific functions.
2529  *
2530  * By default, the owner account will be the one that deploys the contract. This
2531  * can later be changed with {transferOwnership}.
2532  *
2533  * This module is used through inheritance. It will make available the modifier
2534  * `onlyOwner`, which can be applied to your functions to restrict their use to
2535  * the owner.
2536  */
2537 abstract contract Ownable is Context {
2538     address private _owner;
2539 
2540     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2541 
2542     /**
2543      * @dev Initializes the contract setting the deployer as the initial owner.
2544      */
2545     constructor() {
2546         _setOwner(_msgSender());
2547     }
2548 
2549     /**
2550      * @dev Returns the address of the current owner.
2551      */
2552     function owner() public view virtual returns (address) {
2553         return _owner;
2554     }
2555 
2556     /**
2557      * @dev Throws if called by any account other than the owner.
2558      */
2559     modifier onlyOwner() {
2560         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2561         _;
2562     }
2563 
2564     /**
2565      * @dev Leaves the contract without owner. It will not be possible to call
2566      * `onlyOwner` functions anymore. Can only be called by the current owner.
2567      *
2568      * NOTE: Renouncing ownership will leave the contract without an owner,
2569      * thereby removing any functionality that is only available to the owner.
2570      */
2571     function renounceOwnership() public virtual onlyOwner {
2572         _setOwner(address(0));
2573     }
2574 
2575     /**
2576      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2577      * Can only be called by the current owner.
2578      */
2579     function transferOwnership(address newOwner) public virtual onlyOwner {
2580         require(newOwner != address(0), "Ownable: new owner is the zero address");
2581         _setOwner(newOwner);
2582     }
2583 
2584     function _setOwner(address newOwner) private {
2585         address oldOwner = _owner;
2586         _owner = newOwner;
2587         emit OwnershipTransferred(oldOwner, newOwner);
2588     }
2589 }
2590 
2591 
2592 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.3.1
2593 
2594 
2595 pragma solidity ^0.8.0;
2596 
2597 /**
2598  * @dev Contract module that helps prevent reentrant calls to a function.
2599  *
2600  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2601  * available, which can be applied to functions to make sure there are no nested
2602  * (reentrant) calls to them.
2603  *
2604  * Note that because there is a single `nonReentrant` guard, functions marked as
2605  * `nonReentrant` may not call one another. This can be worked around by making
2606  * those functions `private`, and then adding `external` `nonReentrant` entry
2607  * points to them.
2608  *
2609  * TIP: If you would like to learn more about reentrancy and alternative ways
2610  * to protect against it, check out our blog post
2611  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2612  */
2613 abstract contract ReentrancyGuard {
2614     // Booleans are more expensive than uint256 or any type that takes up a full
2615     // word because each write operation emits an extra SLOAD to first read the
2616     // slot's contents, replace the bits taken up by the boolean, and then write
2617     // back. This is the compiler's defense against contract upgrades and
2618     // pointer aliasing, and it cannot be disabled.
2619 
2620     // The values being non-zero value makes deployment a bit more expensive,
2621     // but in exchange the refund on every call to nonReentrant will be lower in
2622     // amount. Since refunds are capped to a percentage of the total
2623     // transaction's gas, it is best to keep them low in cases like this one, to
2624     // increase the likelihood of the full refund coming into effect.
2625     uint256 private constant _NOT_ENTERED = 1;
2626     uint256 private constant _ENTERED = 2;
2627 
2628     uint256 private _status;
2629 
2630     constructor() {
2631         _status = _NOT_ENTERED;
2632     }
2633 
2634     /**
2635      * @dev Prevents a contract from calling itself, directly or indirectly.
2636      * Calling a `nonReentrant` function from another `nonReentrant`
2637      * function is not supported. It is possible to prevent this from happening
2638      * by making the `nonReentrant` function external, and make it call a
2639      * `private` function that does the actual work.
2640      */
2641     modifier nonReentrant() {
2642         // On the first call to nonReentrant, _notEntered will be true
2643         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2644 
2645         // Any calls to nonReentrant after this point will fail
2646         _status = _ENTERED;
2647 
2648         _;
2649 
2650         // By storing the original value once again, a refund is triggered (see
2651         // https://eips.ethereum.org/EIPS/eip-2200)
2652         _status = _NOT_ENTERED;
2653     }
2654 }
2655 
2656 
2657 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.1
2658 
2659 
2660 pragma solidity ^0.8.0;
2661 
2662 /**
2663  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
2664  * @dev See https://eips.ethereum.org/EIPS/eip-721
2665  */
2666 interface IERC721Enumerable is IERC721 {
2667     /**
2668      * @dev Returns the total amount of tokens stored by the contract.
2669      */
2670     function totalSupply() external view returns (uint256);
2671 
2672     /**
2673      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
2674      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
2675      */
2676     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
2677 
2678     /**
2679      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
2680      * Use along with {totalSupply} to enumerate all tokens.
2681      */
2682     function tokenByIndex(uint256 index) external view returns (uint256);
2683 }
2684 
2685 
2686 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.1
2687 
2688 
2689 pragma solidity ^0.8.0;
2690 
2691 
2692 /**
2693  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
2694  * enumerability of all the token ids in the contract as well as all token ids owned by each
2695  * account.
2696  */
2697 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
2698     // Mapping from owner to list of owned token IDs
2699     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
2700 
2701     // Mapping from token ID to index of the owner tokens list
2702     mapping(uint256 => uint256) private _ownedTokensIndex;
2703 
2704     // Array with all token ids, used for enumeration
2705     uint256[] private _allTokens;
2706 
2707     // Mapping from token id to position in the allTokens array
2708     mapping(uint256 => uint256) private _allTokensIndex;
2709 
2710     /**
2711      * @dev See {IERC165-supportsInterface}.
2712      */
2713     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
2714         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
2715     }
2716 
2717     /**
2718      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
2719      */
2720     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
2721         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
2722         return _ownedTokens[owner][index];
2723     }
2724 
2725     /**
2726      * @dev See {IERC721Enumerable-totalSupply}.
2727      */
2728     function totalSupply() public view virtual override returns (uint256) {
2729         return _allTokens.length;
2730     }
2731 
2732     /**
2733      * @dev See {IERC721Enumerable-tokenByIndex}.
2734      */
2735     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
2736         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
2737         return _allTokens[index];
2738     }
2739 
2740     /**
2741      * @dev Hook that is called before any token transfer. This includes minting
2742      * and burning.
2743      *
2744      * Calling conditions:
2745      *
2746      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2747      * transferred to `to`.
2748      * - When `from` is zero, `tokenId` will be minted for `to`.
2749      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2750      * - `from` cannot be the zero address.
2751      * - `to` cannot be the zero address.
2752      *
2753      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2754      */
2755     function _beforeTokenTransfer(
2756         address from,
2757         address to,
2758         uint256 tokenId
2759     ) internal virtual override {
2760         super._beforeTokenTransfer(from, to, tokenId);
2761 
2762         if (from == address(0)) {
2763             _addTokenToAllTokensEnumeration(tokenId);
2764         } else if (from != to) {
2765             _removeTokenFromOwnerEnumeration(from, tokenId);
2766         }
2767         if (to == address(0)) {
2768             _removeTokenFromAllTokensEnumeration(tokenId);
2769         } else if (to != from) {
2770             _addTokenToOwnerEnumeration(to, tokenId);
2771         }
2772     }
2773 
2774     /**
2775      * @dev Private function to add a token to this extension's ownership-tracking data structures.
2776      * @param to address representing the new owner of the given token ID
2777      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
2778      */
2779     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
2780         uint256 length = ERC721.balanceOf(to);
2781         _ownedTokens[to][length] = tokenId;
2782         _ownedTokensIndex[tokenId] = length;
2783     }
2784 
2785     /**
2786      * @dev Private function to add a token to this extension's token tracking data structures.
2787      * @param tokenId uint256 ID of the token to be added to the tokens list
2788      */
2789     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
2790         _allTokensIndex[tokenId] = _allTokens.length;
2791         _allTokens.push(tokenId);
2792     }
2793 
2794     /**
2795      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
2796      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
2797      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
2798      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
2799      * @param from address representing the previous owner of the given token ID
2800      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
2801      */
2802     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
2803         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
2804         // then delete the last slot (swap and pop).
2805 
2806         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
2807         uint256 tokenIndex = _ownedTokensIndex[tokenId];
2808 
2809         // When the token to delete is the last token, the swap operation is unnecessary
2810         if (tokenIndex != lastTokenIndex) {
2811             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
2812 
2813             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2814             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2815         }
2816 
2817         // This also deletes the contents at the last position of the array
2818         delete _ownedTokensIndex[tokenId];
2819         delete _ownedTokens[from][lastTokenIndex];
2820     }
2821 
2822     /**
2823      * @dev Private function to remove a token from this extension's token tracking data structures.
2824      * This has O(1) time complexity, but alters the order of the _allTokens array.
2825      * @param tokenId uint256 ID of the token to be removed from the tokens list
2826      */
2827     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2828         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
2829         // then delete the last slot (swap and pop).
2830 
2831         uint256 lastTokenIndex = _allTokens.length - 1;
2832         uint256 tokenIndex = _allTokensIndex[tokenId];
2833 
2834         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2835         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2836         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2837         uint256 lastTokenId = _allTokens[lastTokenIndex];
2838 
2839         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2840         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2841 
2842         // This also deletes the contents at the last position of the array
2843         delete _allTokensIndex[tokenId];
2844         _allTokens.pop();
2845     }
2846 }
2847 
2848 
2849 // File contracts/HiddenInNoise.sol
2850 
2851 
2852 pragma solidity ^0.8.4;
2853 
2854 
2855 
2856 
2857 
2858 contract HiddenInNoise is ERC721, Ownable, ERC721Enumerable, ReentrancyGuard {
2859     uint256 public constant MAX_AMOUNT = 1024;
2860     uint256 public constant PRICE = 0.404 ether;
2861     string private _tokenBaseUri = "";
2862     bool public saleIsActive = false;
2863 
2864     bool public whiteListSaleIsActive = false;
2865     mapping(address => bool) public whitelist;
2866 
2867     constructor(string memory tokenName, string memory symbol) ERC721(tokenName, symbol) {
2868     }
2869 
2870     function withdraw() public onlyOwner {
2871         uint balance = address(this).balance;
2872         payable(msg.sender).transfer(balance);
2873     }
2874 
2875     function startSale() public onlyOwner {
2876         saleIsActive = true;
2877     }
2878 
2879     function stopSale() public onlyOwner {
2880         saleIsActive = false;
2881     }
2882 
2883     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override(ERC721, ERC721Enumerable) {
2884         super._beforeTokenTransfer(from, to, tokenId);
2885     }
2886 
2887     function _burn(uint256 tokenId) internal  override(ERC721)
2888     {
2889         super._burn(tokenId);
2890     }
2891 
2892     function supportsInterface(bytes4 interfaceId) public   view    override(ERC721, ERC721Enumerable)  returns (bool)
2893     {
2894         return super.supportsInterface(interfaceId);
2895     }
2896 
2897     function setBaseURI(string memory baseURI) public onlyOwner {
2898         _tokenBaseUri = baseURI;
2899     }
2900 
2901     function _baseURI() internal view override returns (string memory) {
2902         return _tokenBaseUri;
2903     }
2904 
2905     function addToWhitelist(address account) external onlyOwner {
2906         whitelist[account] = true;
2907     }
2908 
2909     function removeFromWhitelist(address account) public onlyOwner {
2910         whitelist[account] = false;
2911     }
2912 
2913     function startWhiteListSale() public onlyOwner {
2914         whiteListSaleIsActive = true;
2915     }
2916 
2917     function stopWhiteListSale() public onlyOwner {
2918         whiteListSaleIsActive = false;
2919     }
2920 
2921     function mintToken() public payable nonReentrant
2922     {
2923         if(whiteListSaleIsActive){
2924             require(whitelist[msg.sender], "Only whitelist address can mint");
2925             whitelist[msg.sender] = false;
2926         }else
2927             require(saleIsActive, "Sale must be active to mint");
2928         require(totalSupply() + 1 <= MAX_AMOUNT, "Purchase would exceed max supply");
2929         require(PRICE <= msg.value, "Ether value is too small");
2930 
2931         uint mintIndex = totalSupply();
2932         _safeMint(msg.sender, mintIndex);
2933     }
2934 }