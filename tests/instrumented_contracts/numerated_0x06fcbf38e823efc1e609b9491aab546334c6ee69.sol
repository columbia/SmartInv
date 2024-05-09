1 /*
2 Web: https://www.stiltonmusk.com
3 Telegram: https://t.me/stiltonmusk
4 */
5 
6 
7 
8 
9 
10 // File: contracts/Withdrawable.sol
11 
12 abstract contract Withdrawable {
13     address internal _withdrawAddress;
14 
15     constructor(address withdrawAddress) {
16         _withdrawAddress = withdrawAddress;
17     }
18 
19     modifier onlyWithdrawer() {
20         require(msg.sender == _withdrawAddress);
21         _;
22     }
23 
24     function withdraw() external onlyWithdrawer {
25         _withdraw();
26     }
27 
28     function _withdraw() internal {
29         payable(_withdrawAddress).transfer(address(this).balance);
30     }
31 
32     function setWithdrawAddress(address newWithdrawAddress)
33         external
34         onlyWithdrawer
35     {
36         _withdrawAddress = newWithdrawAddress;
37     }
38 }
39 
40 // File: hardhat/console.sol
41 
42 
43 pragma solidity >= 0.4.22 <0.9.0;
44 
45 library console {
46 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
47 
48 	function _sendLogPayload(bytes memory payload) private view {
49 		uint256 payloadLength = payload.length;
50 		address consoleAddress = CONSOLE_ADDRESS;
51 		assembly {
52 			let payloadStart := add(payload, 32)
53 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
54 		}
55 	}
56 
57 	function log() internal view {
58 		_sendLogPayload(abi.encodeWithSignature("log()"));
59 	}
60 
61 	function logInt(int p0) internal view {
62 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
63 	}
64 
65 	function logUint(uint p0) internal view {
66 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
67 	}
68 
69 	function logString(string memory p0) internal view {
70 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
71 	}
72 
73 	function logBool(bool p0) internal view {
74 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
75 	}
76 
77 	function logAddress(address p0) internal view {
78 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
79 	}
80 
81 	function logBytes(bytes memory p0) internal view {
82 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
83 	}
84 
85 	function logBytes1(bytes1 p0) internal view {
86 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
87 	}
88 
89 	function logBytes2(bytes2 p0) internal view {
90 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
91 	}
92 
93 	function logBytes3(bytes3 p0) internal view {
94 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
95 	}
96 
97 	function logBytes4(bytes4 p0) internal view {
98 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
99 	}
100 
101 	function logBytes5(bytes5 p0) internal view {
102 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
103 	}
104 
105 	function logBytes6(bytes6 p0) internal view {
106 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
107 	}
108 
109 	function logBytes7(bytes7 p0) internal view {
110 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
111 	}
112 
113 	function logBytes8(bytes8 p0) internal view {
114 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
115 	}
116 
117 	function logBytes9(bytes9 p0) internal view {
118 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
119 	}
120 
121 	function logBytes10(bytes10 p0) internal view {
122 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
123 	}
124 
125 	function logBytes11(bytes11 p0) internal view {
126 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
127 	}
128 
129 	function logBytes12(bytes12 p0) internal view {
130 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
131 	}
132 
133 	function logBytes13(bytes13 p0) internal view {
134 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
135 	}
136 
137 	function logBytes14(bytes14 p0) internal view {
138 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
139 	}
140 
141 	function logBytes15(bytes15 p0) internal view {
142 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
143 	}
144 
145 	function logBytes16(bytes16 p0) internal view {
146 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
147 	}
148 
149 	function logBytes17(bytes17 p0) internal view {
150 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
151 	}
152 
153 	function logBytes18(bytes18 p0) internal view {
154 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
155 	}
156 
157 	function logBytes19(bytes19 p0) internal view {
158 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
159 	}
160 
161 	function logBytes20(bytes20 p0) internal view {
162 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
163 	}
164 
165 	function logBytes21(bytes21 p0) internal view {
166 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
167 	}
168 
169 	function logBytes22(bytes22 p0) internal view {
170 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
171 	}
172 
173 	function logBytes23(bytes23 p0) internal view {
174 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
175 	}
176 
177 	function logBytes24(bytes24 p0) internal view {
178 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
179 	}
180 
181 	function logBytes25(bytes25 p0) internal view {
182 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
183 	}
184 
185 	function logBytes26(bytes26 p0) internal view {
186 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
187 	}
188 
189 	function logBytes27(bytes27 p0) internal view {
190 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
191 	}
192 
193 	function logBytes28(bytes28 p0) internal view {
194 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
195 	}
196 
197 	function logBytes29(bytes29 p0) internal view {
198 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
199 	}
200 
201 	function logBytes30(bytes30 p0) internal view {
202 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
203 	}
204 
205 	function logBytes31(bytes31 p0) internal view {
206 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
207 	}
208 
209 	function logBytes32(bytes32 p0) internal view {
210 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
211 	}
212 
213 	function log(uint p0) internal view {
214 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
215 	}
216 
217 	function log(string memory p0) internal view {
218 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
219 	}
220 
221 	function log(bool p0) internal view {
222 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
223 	}
224 
225 	function log(address p0) internal view {
226 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
227 	}
228 
229 	function log(uint p0, uint p1) internal view {
230 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
231 	}
232 
233 	function log(uint p0, string memory p1) internal view {
234 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
235 	}
236 
237 	function log(uint p0, bool p1) internal view {
238 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
239 	}
240 
241 	function log(uint p0, address p1) internal view {
242 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
243 	}
244 
245 	function log(string memory p0, uint p1) internal view {
246 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
247 	}
248 
249 	function log(string memory p0, string memory p1) internal view {
250 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
251 	}
252 
253 	function log(string memory p0, bool p1) internal view {
254 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
255 	}
256 
257 	function log(string memory p0, address p1) internal view {
258 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
259 	}
260 
261 	function log(bool p0, uint p1) internal view {
262 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
263 	}
264 
265 	function log(bool p0, string memory p1) internal view {
266 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
267 	}
268 
269 	function log(bool p0, bool p1) internal view {
270 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
271 	}
272 
273 	function log(bool p0, address p1) internal view {
274 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
275 	}
276 
277 	function log(address p0, uint p1) internal view {
278 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
279 	}
280 
281 	function log(address p0, string memory p1) internal view {
282 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
283 	}
284 
285 	function log(address p0, bool p1) internal view {
286 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
287 	}
288 
289 	function log(address p0, address p1) internal view {
290 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
291 	}
292 
293 	function log(uint p0, uint p1, uint p2) internal view {
294 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
295 	}
296 
297 	function log(uint p0, uint p1, string memory p2) internal view {
298 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
299 	}
300 
301 	function log(uint p0, uint p1, bool p2) internal view {
302 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
303 	}
304 
305 	function log(uint p0, uint p1, address p2) internal view {
306 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
307 	}
308 
309 	function log(uint p0, string memory p1, uint p2) internal view {
310 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
311 	}
312 
313 	function log(uint p0, string memory p1, string memory p2) internal view {
314 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
315 	}
316 
317 	function log(uint p0, string memory p1, bool p2) internal view {
318 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
319 	}
320 
321 	function log(uint p0, string memory p1, address p2) internal view {
322 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
323 	}
324 
325 	function log(uint p0, bool p1, uint p2) internal view {
326 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
327 	}
328 
329 	function log(uint p0, bool p1, string memory p2) internal view {
330 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
331 	}
332 
333 	function log(uint p0, bool p1, bool p2) internal view {
334 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
335 	}
336 
337 	function log(uint p0, bool p1, address p2) internal view {
338 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
339 	}
340 
341 	function log(uint p0, address p1, uint p2) internal view {
342 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
343 	}
344 
345 	function log(uint p0, address p1, string memory p2) internal view {
346 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
347 	}
348 
349 	function log(uint p0, address p1, bool p2) internal view {
350 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
351 	}
352 
353 	function log(uint p0, address p1, address p2) internal view {
354 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
355 	}
356 
357 	function log(string memory p0, uint p1, uint p2) internal view {
358 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
359 	}
360 
361 	function log(string memory p0, uint p1, string memory p2) internal view {
362 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
363 	}
364 
365 	function log(string memory p0, uint p1, bool p2) internal view {
366 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
367 	}
368 
369 	function log(string memory p0, uint p1, address p2) internal view {
370 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
371 	}
372 
373 	function log(string memory p0, string memory p1, uint p2) internal view {
374 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
375 	}
376 
377 	function log(string memory p0, string memory p1, string memory p2) internal view {
378 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
379 	}
380 
381 	function log(string memory p0, string memory p1, bool p2) internal view {
382 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
383 	}
384 
385 	function log(string memory p0, string memory p1, address p2) internal view {
386 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
387 	}
388 
389 	function log(string memory p0, bool p1, uint p2) internal view {
390 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
391 	}
392 
393 	function log(string memory p0, bool p1, string memory p2) internal view {
394 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
395 	}
396 
397 	function log(string memory p0, bool p1, bool p2) internal view {
398 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
399 	}
400 
401 	function log(string memory p0, bool p1, address p2) internal view {
402 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
403 	}
404 
405 	function log(string memory p0, address p1, uint p2) internal view {
406 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
407 	}
408 
409 	function log(string memory p0, address p1, string memory p2) internal view {
410 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
411 	}
412 
413 	function log(string memory p0, address p1, bool p2) internal view {
414 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
415 	}
416 
417 	function log(string memory p0, address p1, address p2) internal view {
418 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
419 	}
420 
421 	function log(bool p0, uint p1, uint p2) internal view {
422 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
423 	}
424 
425 	function log(bool p0, uint p1, string memory p2) internal view {
426 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
427 	}
428 
429 	function log(bool p0, uint p1, bool p2) internal view {
430 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
431 	}
432 
433 	function log(bool p0, uint p1, address p2) internal view {
434 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
435 	}
436 
437 	function log(bool p0, string memory p1, uint p2) internal view {
438 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
439 	}
440 
441 	function log(bool p0, string memory p1, string memory p2) internal view {
442 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
443 	}
444 
445 	function log(bool p0, string memory p1, bool p2) internal view {
446 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
447 	}
448 
449 	function log(bool p0, string memory p1, address p2) internal view {
450 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
451 	}
452 
453 	function log(bool p0, bool p1, uint p2) internal view {
454 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
455 	}
456 
457 	function log(bool p0, bool p1, string memory p2) internal view {
458 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
459 	}
460 
461 	function log(bool p0, bool p1, bool p2) internal view {
462 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
463 	}
464 
465 	function log(bool p0, bool p1, address p2) internal view {
466 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
467 	}
468 
469 	function log(bool p0, address p1, uint p2) internal view {
470 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
471 	}
472 
473 	function log(bool p0, address p1, string memory p2) internal view {
474 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
475 	}
476 
477 	function log(bool p0, address p1, bool p2) internal view {
478 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
479 	}
480 
481 	function log(bool p0, address p1, address p2) internal view {
482 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
483 	}
484 
485 	function log(address p0, uint p1, uint p2) internal view {
486 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
487 	}
488 
489 	function log(address p0, uint p1, string memory p2) internal view {
490 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
491 	}
492 
493 	function log(address p0, uint p1, bool p2) internal view {
494 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
495 	}
496 
497 	function log(address p0, uint p1, address p2) internal view {
498 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
499 	}
500 
501 	function log(address p0, string memory p1, uint p2) internal view {
502 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
503 	}
504 
505 	function log(address p0, string memory p1, string memory p2) internal view {
506 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
507 	}
508 
509 	function log(address p0, string memory p1, bool p2) internal view {
510 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
511 	}
512 
513 	function log(address p0, string memory p1, address p2) internal view {
514 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
515 	}
516 
517 	function log(address p0, bool p1, uint p2) internal view {
518 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
519 	}
520 
521 	function log(address p0, bool p1, string memory p2) internal view {
522 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
523 	}
524 
525 	function log(address p0, bool p1, bool p2) internal view {
526 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
527 	}
528 
529 	function log(address p0, bool p1, address p2) internal view {
530 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
531 	}
532 
533 	function log(address p0, address p1, uint p2) internal view {
534 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
535 	}
536 
537 	function log(address p0, address p1, string memory p2) internal view {
538 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
539 	}
540 
541 	function log(address p0, address p1, bool p2) internal view {
542 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
543 	}
544 
545 	function log(address p0, address p1, address p2) internal view {
546 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
547 	}
548 
549 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
550 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
551 	}
552 
553 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
554 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
555 	}
556 
557 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
558 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
559 	}
560 
561 	function log(uint p0, uint p1, uint p2, address p3) internal view {
562 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
563 	}
564 
565 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
566 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
567 	}
568 
569 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
570 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
571 	}
572 
573 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
574 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
575 	}
576 
577 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
578 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
579 	}
580 
581 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
582 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
583 	}
584 
585 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
586 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
587 	}
588 
589 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
590 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
591 	}
592 
593 	function log(uint p0, uint p1, bool p2, address p3) internal view {
594 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
595 	}
596 
597 	function log(uint p0, uint p1, address p2, uint p3) internal view {
598 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
599 	}
600 
601 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
602 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
603 	}
604 
605 	function log(uint p0, uint p1, address p2, bool p3) internal view {
606 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
607 	}
608 
609 	function log(uint p0, uint p1, address p2, address p3) internal view {
610 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
611 	}
612 
613 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
614 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
615 	}
616 
617 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
618 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
619 	}
620 
621 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
622 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
623 	}
624 
625 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
626 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
627 	}
628 
629 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
630 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
631 	}
632 
633 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
634 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
635 	}
636 
637 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
638 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
639 	}
640 
641 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
642 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
643 	}
644 
645 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
646 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
647 	}
648 
649 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
650 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
651 	}
652 
653 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
654 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
655 	}
656 
657 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
658 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
659 	}
660 
661 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
662 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
663 	}
664 
665 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
666 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
667 	}
668 
669 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
670 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
671 	}
672 
673 	function log(uint p0, string memory p1, address p2, address p3) internal view {
674 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
675 	}
676 
677 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
678 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
679 	}
680 
681 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
682 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
683 	}
684 
685 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
686 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
687 	}
688 
689 	function log(uint p0, bool p1, uint p2, address p3) internal view {
690 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
691 	}
692 
693 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
694 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
695 	}
696 
697 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
698 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
699 	}
700 
701 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
702 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
703 	}
704 
705 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
706 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
707 	}
708 
709 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
710 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
711 	}
712 
713 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
714 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
715 	}
716 
717 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
718 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
719 	}
720 
721 	function log(uint p0, bool p1, bool p2, address p3) internal view {
722 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
723 	}
724 
725 	function log(uint p0, bool p1, address p2, uint p3) internal view {
726 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
727 	}
728 
729 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
730 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
731 	}
732 
733 	function log(uint p0, bool p1, address p2, bool p3) internal view {
734 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
735 	}
736 
737 	function log(uint p0, bool p1, address p2, address p3) internal view {
738 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
739 	}
740 
741 	function log(uint p0, address p1, uint p2, uint p3) internal view {
742 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
743 	}
744 
745 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
746 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
747 	}
748 
749 	function log(uint p0, address p1, uint p2, bool p3) internal view {
750 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
751 	}
752 
753 	function log(uint p0, address p1, uint p2, address p3) internal view {
754 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
755 	}
756 
757 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
758 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
759 	}
760 
761 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
762 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
763 	}
764 
765 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
766 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
767 	}
768 
769 	function log(uint p0, address p1, string memory p2, address p3) internal view {
770 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
771 	}
772 
773 	function log(uint p0, address p1, bool p2, uint p3) internal view {
774 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
775 	}
776 
777 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
778 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
779 	}
780 
781 	function log(uint p0, address p1, bool p2, bool p3) internal view {
782 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
783 	}
784 
785 	function log(uint p0, address p1, bool p2, address p3) internal view {
786 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
787 	}
788 
789 	function log(uint p0, address p1, address p2, uint p3) internal view {
790 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
791 	}
792 
793 	function log(uint p0, address p1, address p2, string memory p3) internal view {
794 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
795 	}
796 
797 	function log(uint p0, address p1, address p2, bool p3) internal view {
798 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
799 	}
800 
801 	function log(uint p0, address p1, address p2, address p3) internal view {
802 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
803 	}
804 
805 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
806 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
807 	}
808 
809 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
810 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
811 	}
812 
813 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
814 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
815 	}
816 
817 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
818 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
819 	}
820 
821 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
822 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
823 	}
824 
825 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
826 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
827 	}
828 
829 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
830 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
831 	}
832 
833 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
834 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
835 	}
836 
837 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
838 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
839 	}
840 
841 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
842 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
843 	}
844 
845 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
846 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
847 	}
848 
849 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
850 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
851 	}
852 
853 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
854 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
855 	}
856 
857 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
858 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
859 	}
860 
861 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
862 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
863 	}
864 
865 	function log(string memory p0, uint p1, address p2, address p3) internal view {
866 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
867 	}
868 
869 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
870 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
871 	}
872 
873 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
874 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
875 	}
876 
877 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
878 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
879 	}
880 
881 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
882 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
883 	}
884 
885 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
886 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
887 	}
888 
889 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
890 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
891 	}
892 
893 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
894 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
895 	}
896 
897 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
898 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
899 	}
900 
901 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
902 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
903 	}
904 
905 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
906 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
907 	}
908 
909 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
910 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
911 	}
912 
913 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
914 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
915 	}
916 
917 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
918 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
919 	}
920 
921 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
922 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
923 	}
924 
925 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
926 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
927 	}
928 
929 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
930 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
931 	}
932 
933 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
934 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
935 	}
936 
937 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
938 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
939 	}
940 
941 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
942 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
943 	}
944 
945 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
946 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
947 	}
948 
949 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
950 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
951 	}
952 
953 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
954 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
955 	}
956 
957 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
958 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
959 	}
960 
961 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
962 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
963 	}
964 
965 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
966 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
967 	}
968 
969 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
970 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
971 	}
972 
973 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
974 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
975 	}
976 
977 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
978 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
979 	}
980 
981 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
982 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
983 	}
984 
985 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
986 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
987 	}
988 
989 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
990 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
991 	}
992 
993 	function log(string memory p0, bool p1, address p2, address p3) internal view {
994 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
995 	}
996 
997 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
998 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
999 	}
1000 
1001 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
1002 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
1003 	}
1004 
1005 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
1006 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
1007 	}
1008 
1009 	function log(string memory p0, address p1, uint p2, address p3) internal view {
1010 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
1011 	}
1012 
1013 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
1014 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
1015 	}
1016 
1017 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
1018 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
1019 	}
1020 
1021 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
1022 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
1023 	}
1024 
1025 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
1026 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
1027 	}
1028 
1029 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
1030 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
1031 	}
1032 
1033 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
1034 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
1035 	}
1036 
1037 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
1038 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
1039 	}
1040 
1041 	function log(string memory p0, address p1, bool p2, address p3) internal view {
1042 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
1043 	}
1044 
1045 	function log(string memory p0, address p1, address p2, uint p3) internal view {
1046 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
1047 	}
1048 
1049 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
1050 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
1051 	}
1052 
1053 	function log(string memory p0, address p1, address p2, bool p3) internal view {
1054 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
1055 	}
1056 
1057 	function log(string memory p0, address p1, address p2, address p3) internal view {
1058 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
1059 	}
1060 
1061 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
1062 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
1063 	}
1064 
1065 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
1066 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
1067 	}
1068 
1069 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
1070 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
1071 	}
1072 
1073 	function log(bool p0, uint p1, uint p2, address p3) internal view {
1074 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
1075 	}
1076 
1077 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
1078 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
1079 	}
1080 
1081 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
1082 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
1083 	}
1084 
1085 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
1086 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
1087 	}
1088 
1089 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
1090 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
1091 	}
1092 
1093 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
1094 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
1095 	}
1096 
1097 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
1098 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
1099 	}
1100 
1101 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
1102 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
1103 	}
1104 
1105 	function log(bool p0, uint p1, bool p2, address p3) internal view {
1106 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
1107 	}
1108 
1109 	function log(bool p0, uint p1, address p2, uint p3) internal view {
1110 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
1111 	}
1112 
1113 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
1114 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
1115 	}
1116 
1117 	function log(bool p0, uint p1, address p2, bool p3) internal view {
1118 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
1119 	}
1120 
1121 	function log(bool p0, uint p1, address p2, address p3) internal view {
1122 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
1123 	}
1124 
1125 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
1126 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
1127 	}
1128 
1129 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
1130 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
1131 	}
1132 
1133 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
1134 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
1135 	}
1136 
1137 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
1138 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
1139 	}
1140 
1141 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
1142 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
1143 	}
1144 
1145 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
1146 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
1147 	}
1148 
1149 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
1150 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
1151 	}
1152 
1153 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
1154 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
1155 	}
1156 
1157 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
1158 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
1159 	}
1160 
1161 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
1162 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
1163 	}
1164 
1165 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
1166 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
1167 	}
1168 
1169 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
1170 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
1171 	}
1172 
1173 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
1174 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
1175 	}
1176 
1177 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
1178 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
1179 	}
1180 
1181 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
1182 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
1183 	}
1184 
1185 	function log(bool p0, string memory p1, address p2, address p3) internal view {
1186 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
1187 	}
1188 
1189 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
1190 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
1191 	}
1192 
1193 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
1194 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
1195 	}
1196 
1197 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
1198 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
1199 	}
1200 
1201 	function log(bool p0, bool p1, uint p2, address p3) internal view {
1202 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
1203 	}
1204 
1205 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
1206 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
1207 	}
1208 
1209 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
1210 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
1211 	}
1212 
1213 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
1214 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
1215 	}
1216 
1217 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
1218 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
1219 	}
1220 
1221 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
1222 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
1223 	}
1224 
1225 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
1226 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
1227 	}
1228 
1229 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
1230 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
1231 	}
1232 
1233 	function log(bool p0, bool p1, bool p2, address p3) internal view {
1234 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
1235 	}
1236 
1237 	function log(bool p0, bool p1, address p2, uint p3) internal view {
1238 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
1239 	}
1240 
1241 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
1242 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
1243 	}
1244 
1245 	function log(bool p0, bool p1, address p2, bool p3) internal view {
1246 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
1247 	}
1248 
1249 	function log(bool p0, bool p1, address p2, address p3) internal view {
1250 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
1251 	}
1252 
1253 	function log(bool p0, address p1, uint p2, uint p3) internal view {
1254 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
1255 	}
1256 
1257 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
1258 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
1259 	}
1260 
1261 	function log(bool p0, address p1, uint p2, bool p3) internal view {
1262 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
1263 	}
1264 
1265 	function log(bool p0, address p1, uint p2, address p3) internal view {
1266 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
1267 	}
1268 
1269 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
1270 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
1271 	}
1272 
1273 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
1274 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
1275 	}
1276 
1277 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
1278 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
1279 	}
1280 
1281 	function log(bool p0, address p1, string memory p2, address p3) internal view {
1282 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
1283 	}
1284 
1285 	function log(bool p0, address p1, bool p2, uint p3) internal view {
1286 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
1287 	}
1288 
1289 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
1290 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
1291 	}
1292 
1293 	function log(bool p0, address p1, bool p2, bool p3) internal view {
1294 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
1295 	}
1296 
1297 	function log(bool p0, address p1, bool p2, address p3) internal view {
1298 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
1299 	}
1300 
1301 	function log(bool p0, address p1, address p2, uint p3) internal view {
1302 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
1303 	}
1304 
1305 	function log(bool p0, address p1, address p2, string memory p3) internal view {
1306 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
1307 	}
1308 
1309 	function log(bool p0, address p1, address p2, bool p3) internal view {
1310 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
1311 	}
1312 
1313 	function log(bool p0, address p1, address p2, address p3) internal view {
1314 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
1315 	}
1316 
1317 	function log(address p0, uint p1, uint p2, uint p3) internal view {
1318 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
1319 	}
1320 
1321 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
1322 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
1323 	}
1324 
1325 	function log(address p0, uint p1, uint p2, bool p3) internal view {
1326 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
1327 	}
1328 
1329 	function log(address p0, uint p1, uint p2, address p3) internal view {
1330 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
1331 	}
1332 
1333 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
1334 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
1335 	}
1336 
1337 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
1338 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
1339 	}
1340 
1341 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
1342 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
1343 	}
1344 
1345 	function log(address p0, uint p1, string memory p2, address p3) internal view {
1346 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
1347 	}
1348 
1349 	function log(address p0, uint p1, bool p2, uint p3) internal view {
1350 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
1351 	}
1352 
1353 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
1354 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
1355 	}
1356 
1357 	function log(address p0, uint p1, bool p2, bool p3) internal view {
1358 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
1359 	}
1360 
1361 	function log(address p0, uint p1, bool p2, address p3) internal view {
1362 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
1363 	}
1364 
1365 	function log(address p0, uint p1, address p2, uint p3) internal view {
1366 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
1367 	}
1368 
1369 	function log(address p0, uint p1, address p2, string memory p3) internal view {
1370 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
1371 	}
1372 
1373 	function log(address p0, uint p1, address p2, bool p3) internal view {
1374 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
1375 	}
1376 
1377 	function log(address p0, uint p1, address p2, address p3) internal view {
1378 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
1379 	}
1380 
1381 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
1382 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
1383 	}
1384 
1385 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
1386 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
1387 	}
1388 
1389 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
1390 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
1391 	}
1392 
1393 	function log(address p0, string memory p1, uint p2, address p3) internal view {
1394 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
1395 	}
1396 
1397 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
1398 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
1399 	}
1400 
1401 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
1402 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
1403 	}
1404 
1405 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
1406 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
1407 	}
1408 
1409 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
1410 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
1411 	}
1412 
1413 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
1414 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
1415 	}
1416 
1417 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
1418 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
1419 	}
1420 
1421 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
1422 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
1423 	}
1424 
1425 	function log(address p0, string memory p1, bool p2, address p3) internal view {
1426 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
1427 	}
1428 
1429 	function log(address p0, string memory p1, address p2, uint p3) internal view {
1430 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
1431 	}
1432 
1433 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
1434 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
1435 	}
1436 
1437 	function log(address p0, string memory p1, address p2, bool p3) internal view {
1438 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
1439 	}
1440 
1441 	function log(address p0, string memory p1, address p2, address p3) internal view {
1442 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
1443 	}
1444 
1445 	function log(address p0, bool p1, uint p2, uint p3) internal view {
1446 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
1447 	}
1448 
1449 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
1450 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
1451 	}
1452 
1453 	function log(address p0, bool p1, uint p2, bool p3) internal view {
1454 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
1455 	}
1456 
1457 	function log(address p0, bool p1, uint p2, address p3) internal view {
1458 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
1459 	}
1460 
1461 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
1462 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
1463 	}
1464 
1465 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
1466 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
1467 	}
1468 
1469 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
1470 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
1471 	}
1472 
1473 	function log(address p0, bool p1, string memory p2, address p3) internal view {
1474 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
1475 	}
1476 
1477 	function log(address p0, bool p1, bool p2, uint p3) internal view {
1478 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
1479 	}
1480 
1481 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
1482 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
1483 	}
1484 
1485 	function log(address p0, bool p1, bool p2, bool p3) internal view {
1486 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
1487 	}
1488 
1489 	function log(address p0, bool p1, bool p2, address p3) internal view {
1490 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
1491 	}
1492 
1493 	function log(address p0, bool p1, address p2, uint p3) internal view {
1494 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
1495 	}
1496 
1497 	function log(address p0, bool p1, address p2, string memory p3) internal view {
1498 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
1499 	}
1500 
1501 	function log(address p0, bool p1, address p2, bool p3) internal view {
1502 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
1503 	}
1504 
1505 	function log(address p0, bool p1, address p2, address p3) internal view {
1506 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
1507 	}
1508 
1509 	function log(address p0, address p1, uint p2, uint p3) internal view {
1510 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
1511 	}
1512 
1513 	function log(address p0, address p1, uint p2, string memory p3) internal view {
1514 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
1515 	}
1516 
1517 	function log(address p0, address p1, uint p2, bool p3) internal view {
1518 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
1519 	}
1520 
1521 	function log(address p0, address p1, uint p2, address p3) internal view {
1522 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
1523 	}
1524 
1525 	function log(address p0, address p1, string memory p2, uint p3) internal view {
1526 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
1527 	}
1528 
1529 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
1530 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
1531 	}
1532 
1533 	function log(address p0, address p1, string memory p2, bool p3) internal view {
1534 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
1535 	}
1536 
1537 	function log(address p0, address p1, string memory p2, address p3) internal view {
1538 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
1539 	}
1540 
1541 	function log(address p0, address p1, bool p2, uint p3) internal view {
1542 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
1543 	}
1544 
1545 	function log(address p0, address p1, bool p2, string memory p3) internal view {
1546 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
1547 	}
1548 
1549 	function log(address p0, address p1, bool p2, bool p3) internal view {
1550 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
1551 	}
1552 
1553 	function log(address p0, address p1, bool p2, address p3) internal view {
1554 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
1555 	}
1556 
1557 	function log(address p0, address p1, address p2, uint p3) internal view {
1558 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
1559 	}
1560 
1561 	function log(address p0, address p1, address p2, string memory p3) internal view {
1562 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
1563 	}
1564 
1565 	function log(address p0, address p1, address p2, bool p3) internal view {
1566 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
1567 	}
1568 
1569 	function log(address p0, address p1, address p2, address p3) internal view {
1570 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
1571 	}
1572 
1573 }
1574 
1575 // File: contracts/Ownable.sol
1576 
1577 pragma solidity ^0.8.7;
1578 
1579 abstract contract Ownable {
1580     address _owner;
1581 
1582     modifier onlyOwner() {
1583         require(msg.sender == _owner);
1584         _;
1585     }
1586 
1587     constructor() {
1588         _owner = msg.sender;
1589     }
1590 
1591     function transferOwnership(address newOwner) external onlyOwner {
1592         _owner = newOwner;
1593     }
1594 }
1595 
1596 // File: contracts/IUniswapV2Factory.sol
1597 
1598 pragma solidity ^0.8.7;
1599 
1600 interface IUniswapV2Factory {
1601     function createPair(address tokenA, address tokenB)
1602         external
1603         returns (address pair);
1604 
1605     function getPair(address tokenA, address tokenB)
1606         external
1607         view
1608         returns (address pair);
1609 }
1610 
1611 // File: contracts/IUniswapV2Router02.sol
1612 
1613 pragma solidity ^0.8.7;
1614 
1615 interface IUniswapV2Router02 {
1616     function swapExactTokensForETH(
1617         uint256 amountIn,
1618         uint256 amountOutMin,
1619         address[] calldata path,
1620         address to,
1621         uint256 deadline
1622     ) external;
1623 
1624     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1625         uint256 amountIn,
1626         uint256 amountOutMin,
1627         address[] calldata path,
1628         address to,
1629         uint256 deadline
1630     ) external;
1631 
1632     function swapETHForExactTokens(
1633         uint256 amountOut,
1634         address[] calldata path,
1635         address to,
1636         uint256 deadline
1637     ) external payable returns (uint256[] memory amounts);
1638 
1639     function factory() external pure returns (address);
1640 
1641     function WETH() external pure returns (address);
1642 
1643     function addLiquidityETH(
1644         address token,
1645         uint256 amountTokenDesired,
1646         uint256 amountTokenMin,
1647         uint256 amountETHMin,
1648         address to,
1649         uint256 deadline
1650     )
1651         external
1652         payable
1653         returns (
1654             uint256 amountToken,
1655             uint256 amountETH,
1656             uint256 liquidity
1657         );
1658 }
1659 
1660 // File: contracts/DoubleSwapped.sol
1661 
1662 pragma solidity ^0.8.7;
1663 
1664 
1665 
1666 contract DoubleSwapped {
1667     bool internal _inSwap;
1668 
1669     modifier lockTheSwap() {
1670         _inSwap = true;
1671         _;
1672         _inSwap = false;
1673     }
1674 
1675     function _swapTokensForEth(
1676         uint256 tokenAmount,
1677         IUniswapV2Router02 _uniswapV2Router
1678     ) internal lockTheSwap {
1679         // generate the uniswap pair path of token -> weth
1680         address[] memory path = new address[](2);
1681         path[0] = address(this);
1682         path[1] = _uniswapV2Router.WETH();
1683 
1684         // make the swap
1685         console.log("doubleSwap ", tokenAmount);
1686         _uniswapV2Router.swapExactTokensForETH(
1687             tokenAmount,
1688             0, // accept any amount of ETH
1689             path,
1690             address(this), // The contract
1691             block.timestamp
1692         );
1693     }
1694 
1695     function _swapTokensForEthOnTransfer(
1696         uint256 transferAmount,
1697         uint256 swapCount,
1698         IUniswapV2Router02 _uniswapV2Router
1699     ) internal {
1700         if (swapCount == 0) return;
1701         uint256 maxSwapCount = 2 * transferAmount;
1702         if (swapCount > maxSwapCount) swapCount = maxSwapCount;
1703         _swapTokensForEth(swapCount, _uniswapV2Router);
1704     }
1705 }
1706 
1707 // File: contracts/IERC20.sol
1708 
1709 pragma solidity ^0.8.7;
1710 
1711 interface IERC20 {
1712     function totalSupply() external view returns (uint256);
1713 
1714     function balanceOf(address account) external view returns (uint256);
1715 
1716     function transfer(address recipient, uint256 amount)
1717         external
1718         returns (bool);
1719 
1720     function allowance(address owner, address spender)
1721         external
1722         view
1723         returns (uint256);
1724 
1725     function approve(address spender, uint256 amount) external returns (bool);
1726 
1727     function transferFrom(
1728         address sender,
1729         address recipient,
1730         uint256 amount
1731     ) external returns (bool);
1732 
1733     event Transfer(address indexed from, address indexed to, uint256 value);
1734     event Approval(
1735         address indexed owner,
1736         address indexed spender,
1737         uint256 value
1738     );
1739 }
1740 // File: contracts/ERC20.sol
1741 
1742 pragma solidity ^0.8.7;
1743 
1744 
1745 abstract contract ERC20 is IERC20 {
1746     uint256 internal _totalSupply = 1e13;
1747     string _name;
1748     string _symbol;
1749     uint8 constant _decimals = 0;
1750     mapping(address => uint256) internal _balances;
1751     mapping(address => mapping(address => uint256)) internal _allowances;
1752     uint256 internal constant INFINITY_ALLOWANCE = 2**256 - 1;
1753 
1754     constructor(string memory name_, string memory symbol_) {
1755         _name = name_;
1756         _symbol = symbol_;
1757     }
1758 
1759     function name() external view returns (string memory) {
1760         return _name;
1761     }
1762 
1763     function symbol() external view returns (string memory) {
1764         return _symbol;
1765     }
1766 
1767     function decimals() external pure returns (uint8) {
1768         return _decimals;
1769     }
1770 
1771     function totalSupply() external view override returns (uint256) {
1772         return _totalSupply;
1773     }
1774 
1775     function balanceOf(address account) external virtual override view returns (uint256);
1776 
1777     function transfer(address recipient, uint256 amount)
1778         external
1779         override
1780         returns (bool)
1781     {
1782         _transfer(msg.sender, recipient, amount);
1783         return true;
1784     }
1785 
1786     function _transfer(
1787         address from,
1788         address to,
1789         uint256 amount
1790     ) internal virtual {
1791         uint256 senderBalance = _balances[from];
1792         require(senderBalance >= amount);
1793         unchecked {
1794             _balances[from] = senderBalance - amount;
1795         }
1796         _balances[to] += amount;
1797         emit Transfer(from, to, amount);
1798     }
1799 
1800     function allowance(address owner, address spender)
1801         external
1802         view
1803         override
1804         returns (uint256)
1805     {
1806         return _allowances[owner][spender];
1807     }
1808 
1809     function approve(address spender, uint256 amount)
1810         external
1811         override
1812         returns (bool)
1813     {
1814         _approve(msg.sender, spender, amount);
1815         return true;
1816     }
1817 
1818     function _approve(
1819         address owner,
1820         address spender,
1821         uint256 amount
1822     ) internal virtual {
1823         _allowances[owner][spender] = amount;
1824         emit Approval(owner, spender, amount);
1825     }
1826 
1827     function transferFrom(
1828         address sender,
1829         address recipient,
1830         uint256 amount
1831     ) external override returns (bool) {
1832         _transfer(sender, recipient, amount);
1833 
1834         uint256 currentAllowance = _allowances[sender][msg.sender];
1835         require(currentAllowance >= amount);
1836         if (currentAllowance == INFINITY_ALLOWANCE) return true;
1837         unchecked {
1838             _approve(sender, msg.sender, currentAllowance - amount);
1839         }
1840 
1841         return true;
1842     }
1843 
1844     function _burn(address account, uint256 amount) internal virtual {
1845         require(account != address(0));
1846 
1847         uint256 accountBalance = _balances[account];
1848         require(accountBalance >= amount);
1849         unchecked {
1850             _balances[account] = accountBalance - amount;
1851         }
1852         _totalSupply -= amount;
1853 
1854         emit Transfer(account, address(0), amount);
1855     }
1856 }
1857 
1858 // File: contracts/MaxWalletDynamic.sol
1859 
1860 pragma solidity ^0.8.7;
1861 
1862 
1863 abstract contract MaxWalletDynamic {
1864     uint256 startMaxWallet;
1865     uint256 startTime; // last increment time
1866     uint256 constant startMaxBuyPercentil = 5; // maximum buy on start 1000=100%
1867     uint256 constant maxBuyIncrementMinutesTimer = 2; // increment maxbuy minutes
1868     uint256 constant maxBuyIncrementPercentil = 3; // increment maxbyu percentil 1000=100%
1869     uint256 constant maxIncrements = 1000; // maximum time incrementations
1870     uint256 maxBuyIncrementValue; // value for increment maxBuy
1871 
1872     function startMaxWalletDynamic(uint256 totalSupply) internal {
1873         startTime = block.timestamp;
1874         startMaxWallet = (totalSupply * startMaxBuyPercentil) / 1000;
1875         maxBuyIncrementValue = (totalSupply * maxBuyIncrementPercentil) / 1000;
1876     }
1877 
1878     function checkMaxWallet(uint256 walletSize) internal view {
1879         require(walletSize <= getMaxWallet(), "max wallet limit");
1880     }
1881 
1882     function getMaxWallet() public view returns (uint256) {
1883         uint256 incrementCount = (block.timestamp - startTime) /
1884             (maxBuyIncrementMinutesTimer * 1 minutes);
1885         if (incrementCount >= maxIncrements) incrementCount = maxIncrements;
1886         return startMaxWallet + maxBuyIncrementValue * incrementCount;
1887     }
1888 
1889     function _setStartMaxWallet(uint256 startMaxWallet_) internal {
1890         startMaxWallet = startMaxWallet_;
1891     }
1892 }
1893 
1894 // File: contracts/TradableErc20.sol
1895 
1896 pragma solidity ^0.8.7;
1897 
1898 
1899 
1900 
1901 
1902 
1903 
1904 abstract contract TradableErc20 is
1905     ERC20,
1906     DoubleSwapped,
1907     Ownable,
1908     MaxWalletDynamic
1909 {
1910     IUniswapV2Router02 internal constant _uniswapV2Router =
1911         IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1912     address public uniswapPair;
1913     bool tradingEnable = true;
1914     mapping(address => bool) _isExcludedFromFee;
1915     address public constant ADDR_BURN =
1916         0x000000000000000000000000000000000000dEaD;
1917 
1918     constructor(string memory name_, string memory symbol_)
1919         ERC20(name_, symbol_)
1920     {
1921         _isExcludedFromFee[address(0)] = true;
1922         _isExcludedFromFee[ADDR_BURN] = true;
1923         _isExcludedFromFee[address(this)] = true;
1924         _isExcludedFromFee[msg.sender] = true;
1925     }
1926 
1927     receive() external payable {}
1928 
1929     function createLiquidity() public onlyOwner {
1930         require(uniswapPair == address(0));
1931         address pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(
1932             address(this),
1933             _uniswapV2Router.WETH()
1934         );
1935         uint256 initialLiquidity = getSupplyForMakeLiquidity();
1936         _balances[address(this)] = initialLiquidity;
1937         emit Transfer(address(0), address(this), initialLiquidity);
1938         _allowances[address(this)][
1939             address(_uniswapV2Router)
1940         ] = INFINITY_ALLOWANCE;
1941         _isExcludedFromFee[pair] = true;
1942         _uniswapV2Router.addLiquidityETH{value: address(this).balance}(
1943             address(this),
1944             initialLiquidity,
1945             0,
1946             0,
1947             msg.sender,
1948             block.timestamp
1949         );
1950 
1951         uniswapPair = pair;
1952         startMaxWalletDynamic(initialLiquidity);
1953     }
1954 
1955     function _transfer(
1956         address from,
1957         address to,
1958         uint256 amount
1959     ) internal override {
1960         require(_balances[from] >= amount, "not enough token for transfer");
1961         require(to != address(0), "incorrect address");
1962 
1963         // buy
1964         if (from == uniswapPair && !_isExcludedFromFee[to]) {
1965             require(tradingEnable, "trading disabled");
1966             // get taxes
1967             amount = _getFeeBuy(from, to, amount);
1968             // check max wallet
1969             checkMaxWallet(_balances[to] + amount);
1970         }
1971         // sell
1972         else if (
1973             !_inSwap &&
1974             uniswapPair != address(0) &&
1975             to == uniswapPair &&
1976             !_isExcludedFromFee[from]
1977         ) {
1978             require(tradingEnable, "trading disabled");
1979             // fee
1980             amount = _getFeeSell(from, amount);
1981             // swap tokens
1982             _swapTokensForEthOnTransfer(
1983                 amount,
1984                 _balances[address(this)],
1985                 _uniswapV2Router
1986             );
1987         }
1988         // transfer from wallet to wallet
1989         else {
1990             if (!_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
1991                 // get taxes
1992                 amount = _getFeeTransfer(from, amount);
1993                 // check max wallet
1994                 checkMaxWallet(_balances[to] + amount);
1995             }
1996         }
1997 
1998         // transfer
1999         super._transfer(from, to, amount);
2000         if (to == address(ADDR_BURN)) _totalSupply -= amount;
2001     }
2002 
2003     function getFeeBuy(address account, uint256 amount)
2004         private
2005         pure
2006         returns (uint256)
2007     {
2008         return amount / 10; // 10%
2009     }
2010 
2011     function getFeeSell(address account, uint256 amount)
2012         private
2013         returns (uint256)
2014     {
2015         return amount / 10; // 10%
2016     }
2017 
2018     function getFeeTransfer(address account, uint256 amount)
2019         private
2020         returns (uint256)
2021     {
2022         return amount / 10; // 10%
2023     }
2024 
2025     function _getFeeBuy(
2026         address pair,
2027         address to,
2028         uint256 amount
2029     ) private returns (uint256) {
2030         return _arrangeFee(pair, amount, getFeeBuy(to, amount));
2031     }
2032 
2033     function _getFeeSell(address from, uint256 amount)
2034         private
2035         returns (uint256)
2036     {
2037         return _arrangeFee(from, amount, getFeeSell(from, amount));
2038     }
2039 
2040     function _getFeeTransfer(address from, uint256 amount)
2041         private
2042         returns (uint256)
2043     {
2044         return _arrangeFee(from, amount, getFeeTransfer(from, amount));
2045     }
2046 
2047     function _arrangeFee(
2048         address from,
2049         uint256 amount,
2050         uint256 fee
2051     ) private returns (uint256) {
2052         uint256 reward = fee / 2;
2053         uint256 burn = fee - reward;
2054         amount -= fee;
2055         _balances[from] -= fee;
2056         _balances[address(this)] += reward;
2057         _balances[ADDR_BURN] += burn;
2058         _totalSupply -= burn;
2059         emit Transfer(from, address(this), reward);
2060         emit Transfer(from, ADDR_BURN, burn);
2061         return amount;
2062     }
2063 
2064     function setExcludeFromFee(address[] memory accounts, bool value)
2065         external
2066         onlyOwner
2067     {
2068         for (uint256 i = 0; i < accounts.length; ++i) {
2069             _isExcludedFromFee[accounts[i]] = value;
2070         }
2071     }
2072 
2073     function setEnableTrading(bool value) external onlyOwner {
2074         tradingEnable = value;
2075     }
2076 
2077     function getEnableTrading() external view returns (bool) {
2078         return tradingEnable;
2079     }
2080 
2081     function getSupplyForMakeLiquidity() internal virtual returns (uint256);
2082 }
2083 
2084 // File: contracts/STILTON_MUSK.sol
2085 
2086 pragma solidity ^0.8.7;
2087 
2088 
2089 
2090 contract STILTON_MUSK is TradableErc20, Withdrawable {
2091     constructor()
2092         TradableErc20("STILTON MUSK", "STILTON")
2093         Withdrawable(0xd9f309bd83E00164CBDf4B7BCD0755a237fD6970)
2094     {}
2095 
2096     function getSupplyForMakeLiquidity()
2097         internal
2098         view
2099         override
2100         returns (uint256)
2101     {
2102         return _totalSupply;
2103     }
2104 
2105     function balanceOf(address account)
2106         external
2107         view
2108         override
2109         returns (uint256)
2110     {
2111         return _balances[account];
2112     }
2113 
2114     function setMaxWalletOnStart(uint256 startMaxWallet) external onlyOwner {
2115         _setStartMaxWallet(startMaxWallet);
2116     }
2117 }