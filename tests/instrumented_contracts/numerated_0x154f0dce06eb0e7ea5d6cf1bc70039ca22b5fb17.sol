1 pragma solidity 0.6.12;
2 
3 
4 abstract contract ERC677Receiver {
5     function onTokenTransfer(address _sender, uint _value, bytes memory _data) virtual public;
6 }
7 
8 abstract contract ERC677 {
9     function transfer(address to, uint256 value) public virtual returns (bool);
10     function transferAndCall(address to, uint value, bytes memory data) public virtual returns (bool success);
11 
12     // event Transfer(address indexed from, address indexed to, uint value, bytes data);
13 }
14 // SPDX-License-Identifier: MIT
15 
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
57 	function logByte(byte p0) internal view {
58 		_sendLogPayload(abi.encodeWithSignature("log(byte)", p0));
59 	}
60 
61 	function logBytes1(bytes1 p0) internal view {
62 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
63 	}
64 
65 	function logBytes2(bytes2 p0) internal view {
66 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
67 	}
68 
69 	function logBytes3(bytes3 p0) internal view {
70 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
71 	}
72 
73 	function logBytes4(bytes4 p0) internal view {
74 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
75 	}
76 
77 	function logBytes5(bytes5 p0) internal view {
78 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
79 	}
80 
81 	function logBytes6(bytes6 p0) internal view {
82 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
83 	}
84 
85 	function logBytes7(bytes7 p0) internal view {
86 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
87 	}
88 
89 	function logBytes8(bytes8 p0) internal view {
90 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
91 	}
92 
93 	function logBytes9(bytes9 p0) internal view {
94 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
95 	}
96 
97 	function logBytes10(bytes10 p0) internal view {
98 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
99 	}
100 
101 	function logBytes11(bytes11 p0) internal view {
102 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
103 	}
104 
105 	function logBytes12(bytes12 p0) internal view {
106 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
107 	}
108 
109 	function logBytes13(bytes13 p0) internal view {
110 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
111 	}
112 
113 	function logBytes14(bytes14 p0) internal view {
114 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
115 	}
116 
117 	function logBytes15(bytes15 p0) internal view {
118 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
119 	}
120 
121 	function logBytes16(bytes16 p0) internal view {
122 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
123 	}
124 
125 	function logBytes17(bytes17 p0) internal view {
126 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
127 	}
128 
129 	function logBytes18(bytes18 p0) internal view {
130 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
131 	}
132 
133 	function logBytes19(bytes19 p0) internal view {
134 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
135 	}
136 
137 	function logBytes20(bytes20 p0) internal view {
138 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
139 	}
140 
141 	function logBytes21(bytes21 p0) internal view {
142 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
143 	}
144 
145 	function logBytes22(bytes22 p0) internal view {
146 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
147 	}
148 
149 	function logBytes23(bytes23 p0) internal view {
150 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
151 	}
152 
153 	function logBytes24(bytes24 p0) internal view {
154 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
155 	}
156 
157 	function logBytes25(bytes25 p0) internal view {
158 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
159 	}
160 
161 	function logBytes26(bytes26 p0) internal view {
162 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
163 	}
164 
165 	function logBytes27(bytes27 p0) internal view {
166 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
167 	}
168 
169 	function logBytes28(bytes28 p0) internal view {
170 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
171 	}
172 
173 	function logBytes29(bytes29 p0) internal view {
174 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
175 	}
176 
177 	function logBytes30(bytes30 p0) internal view {
178 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
179 	}
180 
181 	function logBytes31(bytes31 p0) internal view {
182 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
183 	}
184 
185 	function logBytes32(bytes32 p0) internal view {
186 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
187 	}
188 
189 	function log(uint p0) internal view {
190 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
191 	}
192 
193 	function log(string memory p0) internal view {
194 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
195 	}
196 
197 	function log(bool p0) internal view {
198 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
199 	}
200 
201 	function log(address p0) internal view {
202 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
203 	}
204 
205 	function log(uint p0, uint p1) internal view {
206 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
207 	}
208 
209 	function log(uint p0, string memory p1) internal view {
210 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
211 	}
212 
213 	function log(uint p0, bool p1) internal view {
214 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
215 	}
216 
217 	function log(uint p0, address p1) internal view {
218 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
219 	}
220 
221 	function log(string memory p0, uint p1) internal view {
222 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
223 	}
224 
225 	function log(string memory p0, string memory p1) internal view {
226 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
227 	}
228 
229 	function log(string memory p0, bool p1) internal view {
230 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
231 	}
232 
233 	function log(string memory p0, address p1) internal view {
234 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
235 	}
236 
237 	function log(bool p0, uint p1) internal view {
238 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
239 	}
240 
241 	function log(bool p0, string memory p1) internal view {
242 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
243 	}
244 
245 	function log(bool p0, bool p1) internal view {
246 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
247 	}
248 
249 	function log(bool p0, address p1) internal view {
250 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
251 	}
252 
253 	function log(address p0, uint p1) internal view {
254 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
255 	}
256 
257 	function log(address p0, string memory p1) internal view {
258 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
259 	}
260 
261 	function log(address p0, bool p1) internal view {
262 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
263 	}
264 
265 	function log(address p0, address p1) internal view {
266 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
267 	}
268 
269 	function log(uint p0, uint p1, uint p2) internal view {
270 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
271 	}
272 
273 	function log(uint p0, uint p1, string memory p2) internal view {
274 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
275 	}
276 
277 	function log(uint p0, uint p1, bool p2) internal view {
278 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
279 	}
280 
281 	function log(uint p0, uint p1, address p2) internal view {
282 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
283 	}
284 
285 	function log(uint p0, string memory p1, uint p2) internal view {
286 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
287 	}
288 
289 	function log(uint p0, string memory p1, string memory p2) internal view {
290 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
291 	}
292 
293 	function log(uint p0, string memory p1, bool p2) internal view {
294 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
295 	}
296 
297 	function log(uint p0, string memory p1, address p2) internal view {
298 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
299 	}
300 
301 	function log(uint p0, bool p1, uint p2) internal view {
302 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
303 	}
304 
305 	function log(uint p0, bool p1, string memory p2) internal view {
306 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
307 	}
308 
309 	function log(uint p0, bool p1, bool p2) internal view {
310 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
311 	}
312 
313 	function log(uint p0, bool p1, address p2) internal view {
314 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
315 	}
316 
317 	function log(uint p0, address p1, uint p2) internal view {
318 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
319 	}
320 
321 	function log(uint p0, address p1, string memory p2) internal view {
322 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
323 	}
324 
325 	function log(uint p0, address p1, bool p2) internal view {
326 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
327 	}
328 
329 	function log(uint p0, address p1, address p2) internal view {
330 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
331 	}
332 
333 	function log(string memory p0, uint p1, uint p2) internal view {
334 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
335 	}
336 
337 	function log(string memory p0, uint p1, string memory p2) internal view {
338 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
339 	}
340 
341 	function log(string memory p0, uint p1, bool p2) internal view {
342 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
343 	}
344 
345 	function log(string memory p0, uint p1, address p2) internal view {
346 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
347 	}
348 
349 	function log(string memory p0, string memory p1, uint p2) internal view {
350 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
351 	}
352 
353 	function log(string memory p0, string memory p1, string memory p2) internal view {
354 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
355 	}
356 
357 	function log(string memory p0, string memory p1, bool p2) internal view {
358 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
359 	}
360 
361 	function log(string memory p0, string memory p1, address p2) internal view {
362 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
363 	}
364 
365 	function log(string memory p0, bool p1, uint p2) internal view {
366 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
367 	}
368 
369 	function log(string memory p0, bool p1, string memory p2) internal view {
370 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
371 	}
372 
373 	function log(string memory p0, bool p1, bool p2) internal view {
374 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
375 	}
376 
377 	function log(string memory p0, bool p1, address p2) internal view {
378 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
379 	}
380 
381 	function log(string memory p0, address p1, uint p2) internal view {
382 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
383 	}
384 
385 	function log(string memory p0, address p1, string memory p2) internal view {
386 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
387 	}
388 
389 	function log(string memory p0, address p1, bool p2) internal view {
390 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
391 	}
392 
393 	function log(string memory p0, address p1, address p2) internal view {
394 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
395 	}
396 
397 	function log(bool p0, uint p1, uint p2) internal view {
398 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
399 	}
400 
401 	function log(bool p0, uint p1, string memory p2) internal view {
402 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
403 	}
404 
405 	function log(bool p0, uint p1, bool p2) internal view {
406 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
407 	}
408 
409 	function log(bool p0, uint p1, address p2) internal view {
410 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
411 	}
412 
413 	function log(bool p0, string memory p1, uint p2) internal view {
414 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
415 	}
416 
417 	function log(bool p0, string memory p1, string memory p2) internal view {
418 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
419 	}
420 
421 	function log(bool p0, string memory p1, bool p2) internal view {
422 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
423 	}
424 
425 	function log(bool p0, string memory p1, address p2) internal view {
426 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
427 	}
428 
429 	function log(bool p0, bool p1, uint p2) internal view {
430 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
431 	}
432 
433 	function log(bool p0, bool p1, string memory p2) internal view {
434 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
435 	}
436 
437 	function log(bool p0, bool p1, bool p2) internal view {
438 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
439 	}
440 
441 	function log(bool p0, bool p1, address p2) internal view {
442 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
443 	}
444 
445 	function log(bool p0, address p1, uint p2) internal view {
446 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
447 	}
448 
449 	function log(bool p0, address p1, string memory p2) internal view {
450 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
451 	}
452 
453 	function log(bool p0, address p1, bool p2) internal view {
454 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
455 	}
456 
457 	function log(bool p0, address p1, address p2) internal view {
458 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
459 	}
460 
461 	function log(address p0, uint p1, uint p2) internal view {
462 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
463 	}
464 
465 	function log(address p0, uint p1, string memory p2) internal view {
466 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
467 	}
468 
469 	function log(address p0, uint p1, bool p2) internal view {
470 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
471 	}
472 
473 	function log(address p0, uint p1, address p2) internal view {
474 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
475 	}
476 
477 	function log(address p0, string memory p1, uint p2) internal view {
478 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
479 	}
480 
481 	function log(address p0, string memory p1, string memory p2) internal view {
482 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
483 	}
484 
485 	function log(address p0, string memory p1, bool p2) internal view {
486 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
487 	}
488 
489 	function log(address p0, string memory p1, address p2) internal view {
490 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
491 	}
492 
493 	function log(address p0, bool p1, uint p2) internal view {
494 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
495 	}
496 
497 	function log(address p0, bool p1, string memory p2) internal view {
498 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
499 	}
500 
501 	function log(address p0, bool p1, bool p2) internal view {
502 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
503 	}
504 
505 	function log(address p0, bool p1, address p2) internal view {
506 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
507 	}
508 
509 	function log(address p0, address p1, uint p2) internal view {
510 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
511 	}
512 
513 	function log(address p0, address p1, string memory p2) internal view {
514 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
515 	}
516 
517 	function log(address p0, address p1, bool p2) internal view {
518 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
519 	}
520 
521 	function log(address p0, address p1, address p2) internal view {
522 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
523 	}
524 
525 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
526 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
527 	}
528 
529 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
530 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
531 	}
532 
533 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
534 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
535 	}
536 
537 	function log(uint p0, uint p1, uint p2, address p3) internal view {
538 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
539 	}
540 
541 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
542 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
543 	}
544 
545 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
546 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
547 	}
548 
549 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
550 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
551 	}
552 
553 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
554 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
555 	}
556 
557 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
558 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
559 	}
560 
561 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
562 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
563 	}
564 
565 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
566 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
567 	}
568 
569 	function log(uint p0, uint p1, bool p2, address p3) internal view {
570 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
571 	}
572 
573 	function log(uint p0, uint p1, address p2, uint p3) internal view {
574 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
575 	}
576 
577 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
578 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
579 	}
580 
581 	function log(uint p0, uint p1, address p2, bool p3) internal view {
582 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
583 	}
584 
585 	function log(uint p0, uint p1, address p2, address p3) internal view {
586 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
587 	}
588 
589 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
590 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
591 	}
592 
593 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
594 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
595 	}
596 
597 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
598 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
599 	}
600 
601 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
602 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
603 	}
604 
605 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
606 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
607 	}
608 
609 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
610 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
611 	}
612 
613 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
614 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
615 	}
616 
617 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
618 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
619 	}
620 
621 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
622 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
623 	}
624 
625 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
626 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
627 	}
628 
629 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
630 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
631 	}
632 
633 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
634 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
635 	}
636 
637 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
638 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
639 	}
640 
641 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
642 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
643 	}
644 
645 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
646 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
647 	}
648 
649 	function log(uint p0, string memory p1, address p2, address p3) internal view {
650 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
651 	}
652 
653 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
654 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
655 	}
656 
657 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
658 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
659 	}
660 
661 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
662 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
663 	}
664 
665 	function log(uint p0, bool p1, uint p2, address p3) internal view {
666 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
667 	}
668 
669 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
670 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
671 	}
672 
673 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
674 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
675 	}
676 
677 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
678 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
679 	}
680 
681 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
682 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
683 	}
684 
685 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
686 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
687 	}
688 
689 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
690 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
691 	}
692 
693 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
694 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
695 	}
696 
697 	function log(uint p0, bool p1, bool p2, address p3) internal view {
698 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
699 	}
700 
701 	function log(uint p0, bool p1, address p2, uint p3) internal view {
702 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
703 	}
704 
705 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
706 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
707 	}
708 
709 	function log(uint p0, bool p1, address p2, bool p3) internal view {
710 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
711 	}
712 
713 	function log(uint p0, bool p1, address p2, address p3) internal view {
714 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
715 	}
716 
717 	function log(uint p0, address p1, uint p2, uint p3) internal view {
718 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
719 	}
720 
721 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
722 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
723 	}
724 
725 	function log(uint p0, address p1, uint p2, bool p3) internal view {
726 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
727 	}
728 
729 	function log(uint p0, address p1, uint p2, address p3) internal view {
730 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
731 	}
732 
733 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
734 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
735 	}
736 
737 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
738 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
739 	}
740 
741 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
742 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
743 	}
744 
745 	function log(uint p0, address p1, string memory p2, address p3) internal view {
746 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
747 	}
748 
749 	function log(uint p0, address p1, bool p2, uint p3) internal view {
750 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
751 	}
752 
753 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
754 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
755 	}
756 
757 	function log(uint p0, address p1, bool p2, bool p3) internal view {
758 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
759 	}
760 
761 	function log(uint p0, address p1, bool p2, address p3) internal view {
762 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
763 	}
764 
765 	function log(uint p0, address p1, address p2, uint p3) internal view {
766 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
767 	}
768 
769 	function log(uint p0, address p1, address p2, string memory p3) internal view {
770 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
771 	}
772 
773 	function log(uint p0, address p1, address p2, bool p3) internal view {
774 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
775 	}
776 
777 	function log(uint p0, address p1, address p2, address p3) internal view {
778 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
779 	}
780 
781 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
782 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
783 	}
784 
785 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
786 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
787 	}
788 
789 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
790 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
791 	}
792 
793 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
794 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
795 	}
796 
797 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
798 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
799 	}
800 
801 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
802 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
803 	}
804 
805 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
806 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
807 	}
808 
809 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
810 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
811 	}
812 
813 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
814 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
815 	}
816 
817 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
818 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
819 	}
820 
821 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
822 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
823 	}
824 
825 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
826 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
827 	}
828 
829 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
830 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
831 	}
832 
833 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
834 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
835 	}
836 
837 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
838 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
839 	}
840 
841 	function log(string memory p0, uint p1, address p2, address p3) internal view {
842 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
843 	}
844 
845 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
846 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
847 	}
848 
849 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
850 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
851 	}
852 
853 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
854 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
855 	}
856 
857 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
858 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
859 	}
860 
861 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
862 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
863 	}
864 
865 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
866 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
867 	}
868 
869 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
870 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
871 	}
872 
873 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
874 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
875 	}
876 
877 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
878 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
879 	}
880 
881 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
882 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
883 	}
884 
885 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
886 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
887 	}
888 
889 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
890 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
891 	}
892 
893 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
894 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
895 	}
896 
897 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
898 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
899 	}
900 
901 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
902 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
903 	}
904 
905 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
906 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
907 	}
908 
909 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
910 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
911 	}
912 
913 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
914 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
915 	}
916 
917 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
918 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
919 	}
920 
921 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
922 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
923 	}
924 
925 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
926 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
927 	}
928 
929 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
930 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
931 	}
932 
933 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
934 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
935 	}
936 
937 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
938 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
939 	}
940 
941 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
942 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
943 	}
944 
945 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
946 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
947 	}
948 
949 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
950 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
951 	}
952 
953 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
954 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
955 	}
956 
957 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
958 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
959 	}
960 
961 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
962 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
963 	}
964 
965 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
966 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
967 	}
968 
969 	function log(string memory p0, bool p1, address p2, address p3) internal view {
970 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
971 	}
972 
973 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
974 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
975 	}
976 
977 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
978 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
979 	}
980 
981 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
982 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
983 	}
984 
985 	function log(string memory p0, address p1, uint p2, address p3) internal view {
986 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
987 	}
988 
989 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
990 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
991 	}
992 
993 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
994 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
995 	}
996 
997 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
998 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
999 	}
1000 
1001 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
1002 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
1003 	}
1004 
1005 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
1006 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
1007 	}
1008 
1009 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
1010 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
1011 	}
1012 
1013 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
1014 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
1015 	}
1016 
1017 	function log(string memory p0, address p1, bool p2, address p3) internal view {
1018 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
1019 	}
1020 
1021 	function log(string memory p0, address p1, address p2, uint p3) internal view {
1022 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
1023 	}
1024 
1025 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
1026 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
1027 	}
1028 
1029 	function log(string memory p0, address p1, address p2, bool p3) internal view {
1030 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
1031 	}
1032 
1033 	function log(string memory p0, address p1, address p2, address p3) internal view {
1034 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
1035 	}
1036 
1037 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
1038 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
1039 	}
1040 
1041 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
1042 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
1043 	}
1044 
1045 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
1046 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
1047 	}
1048 
1049 	function log(bool p0, uint p1, uint p2, address p3) internal view {
1050 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
1051 	}
1052 
1053 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
1054 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
1055 	}
1056 
1057 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
1058 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
1059 	}
1060 
1061 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
1062 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
1063 	}
1064 
1065 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
1066 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
1067 	}
1068 
1069 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
1070 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
1071 	}
1072 
1073 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
1074 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
1075 	}
1076 
1077 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
1078 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
1079 	}
1080 
1081 	function log(bool p0, uint p1, bool p2, address p3) internal view {
1082 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
1083 	}
1084 
1085 	function log(bool p0, uint p1, address p2, uint p3) internal view {
1086 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
1087 	}
1088 
1089 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
1090 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
1091 	}
1092 
1093 	function log(bool p0, uint p1, address p2, bool p3) internal view {
1094 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
1095 	}
1096 
1097 	function log(bool p0, uint p1, address p2, address p3) internal view {
1098 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
1099 	}
1100 
1101 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
1102 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
1103 	}
1104 
1105 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
1106 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
1107 	}
1108 
1109 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
1110 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
1111 	}
1112 
1113 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
1114 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
1115 	}
1116 
1117 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
1118 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
1119 	}
1120 
1121 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
1122 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
1123 	}
1124 
1125 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
1126 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
1127 	}
1128 
1129 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
1130 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
1131 	}
1132 
1133 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
1134 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
1135 	}
1136 
1137 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
1138 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
1139 	}
1140 
1141 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
1142 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
1143 	}
1144 
1145 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
1146 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
1147 	}
1148 
1149 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
1150 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
1151 	}
1152 
1153 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
1154 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
1155 	}
1156 
1157 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
1158 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
1159 	}
1160 
1161 	function log(bool p0, string memory p1, address p2, address p3) internal view {
1162 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
1163 	}
1164 
1165 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
1166 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
1167 	}
1168 
1169 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
1170 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
1171 	}
1172 
1173 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
1174 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
1175 	}
1176 
1177 	function log(bool p0, bool p1, uint p2, address p3) internal view {
1178 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
1179 	}
1180 
1181 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
1182 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
1183 	}
1184 
1185 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
1186 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
1187 	}
1188 
1189 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
1190 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
1191 	}
1192 
1193 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
1194 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
1195 	}
1196 
1197 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
1198 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
1199 	}
1200 
1201 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
1202 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
1203 	}
1204 
1205 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
1206 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
1207 	}
1208 
1209 	function log(bool p0, bool p1, bool p2, address p3) internal view {
1210 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
1211 	}
1212 
1213 	function log(bool p0, bool p1, address p2, uint p3) internal view {
1214 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
1215 	}
1216 
1217 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
1218 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
1219 	}
1220 
1221 	function log(bool p0, bool p1, address p2, bool p3) internal view {
1222 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
1223 	}
1224 
1225 	function log(bool p0, bool p1, address p2, address p3) internal view {
1226 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
1227 	}
1228 
1229 	function log(bool p0, address p1, uint p2, uint p3) internal view {
1230 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
1231 	}
1232 
1233 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
1234 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
1235 	}
1236 
1237 	function log(bool p0, address p1, uint p2, bool p3) internal view {
1238 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
1239 	}
1240 
1241 	function log(bool p0, address p1, uint p2, address p3) internal view {
1242 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
1243 	}
1244 
1245 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
1246 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
1247 	}
1248 
1249 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
1250 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
1251 	}
1252 
1253 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
1254 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
1255 	}
1256 
1257 	function log(bool p0, address p1, string memory p2, address p3) internal view {
1258 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
1259 	}
1260 
1261 	function log(bool p0, address p1, bool p2, uint p3) internal view {
1262 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
1263 	}
1264 
1265 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
1266 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
1267 	}
1268 
1269 	function log(bool p0, address p1, bool p2, bool p3) internal view {
1270 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
1271 	}
1272 
1273 	function log(bool p0, address p1, bool p2, address p3) internal view {
1274 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
1275 	}
1276 
1277 	function log(bool p0, address p1, address p2, uint p3) internal view {
1278 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
1279 	}
1280 
1281 	function log(bool p0, address p1, address p2, string memory p3) internal view {
1282 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
1283 	}
1284 
1285 	function log(bool p0, address p1, address p2, bool p3) internal view {
1286 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
1287 	}
1288 
1289 	function log(bool p0, address p1, address p2, address p3) internal view {
1290 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
1291 	}
1292 
1293 	function log(address p0, uint p1, uint p2, uint p3) internal view {
1294 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
1295 	}
1296 
1297 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
1298 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
1299 	}
1300 
1301 	function log(address p0, uint p1, uint p2, bool p3) internal view {
1302 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
1303 	}
1304 
1305 	function log(address p0, uint p1, uint p2, address p3) internal view {
1306 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
1307 	}
1308 
1309 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
1310 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
1311 	}
1312 
1313 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
1314 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
1315 	}
1316 
1317 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
1318 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
1319 	}
1320 
1321 	function log(address p0, uint p1, string memory p2, address p3) internal view {
1322 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
1323 	}
1324 
1325 	function log(address p0, uint p1, bool p2, uint p3) internal view {
1326 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
1327 	}
1328 
1329 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
1330 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
1331 	}
1332 
1333 	function log(address p0, uint p1, bool p2, bool p3) internal view {
1334 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
1335 	}
1336 
1337 	function log(address p0, uint p1, bool p2, address p3) internal view {
1338 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
1339 	}
1340 
1341 	function log(address p0, uint p1, address p2, uint p3) internal view {
1342 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
1343 	}
1344 
1345 	function log(address p0, uint p1, address p2, string memory p3) internal view {
1346 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
1347 	}
1348 
1349 	function log(address p0, uint p1, address p2, bool p3) internal view {
1350 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
1351 	}
1352 
1353 	function log(address p0, uint p1, address p2, address p3) internal view {
1354 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
1355 	}
1356 
1357 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
1358 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
1359 	}
1360 
1361 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
1362 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
1363 	}
1364 
1365 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
1366 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
1367 	}
1368 
1369 	function log(address p0, string memory p1, uint p2, address p3) internal view {
1370 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
1371 	}
1372 
1373 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
1374 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
1375 	}
1376 
1377 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
1378 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
1379 	}
1380 
1381 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
1382 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
1383 	}
1384 
1385 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
1386 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
1387 	}
1388 
1389 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
1390 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
1391 	}
1392 
1393 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
1394 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
1395 	}
1396 
1397 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
1398 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
1399 	}
1400 
1401 	function log(address p0, string memory p1, bool p2, address p3) internal view {
1402 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
1403 	}
1404 
1405 	function log(address p0, string memory p1, address p2, uint p3) internal view {
1406 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
1407 	}
1408 
1409 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
1410 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
1411 	}
1412 
1413 	function log(address p0, string memory p1, address p2, bool p3) internal view {
1414 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
1415 	}
1416 
1417 	function log(address p0, string memory p1, address p2, address p3) internal view {
1418 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
1419 	}
1420 
1421 	function log(address p0, bool p1, uint p2, uint p3) internal view {
1422 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
1423 	}
1424 
1425 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
1426 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
1427 	}
1428 
1429 	function log(address p0, bool p1, uint p2, bool p3) internal view {
1430 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
1431 	}
1432 
1433 	function log(address p0, bool p1, uint p2, address p3) internal view {
1434 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
1435 	}
1436 
1437 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
1438 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
1439 	}
1440 
1441 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
1442 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
1443 	}
1444 
1445 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
1446 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
1447 	}
1448 
1449 	function log(address p0, bool p1, string memory p2, address p3) internal view {
1450 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
1451 	}
1452 
1453 	function log(address p0, bool p1, bool p2, uint p3) internal view {
1454 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
1455 	}
1456 
1457 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
1458 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
1459 	}
1460 
1461 	function log(address p0, bool p1, bool p2, bool p3) internal view {
1462 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
1463 	}
1464 
1465 	function log(address p0, bool p1, bool p2, address p3) internal view {
1466 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
1467 	}
1468 
1469 	function log(address p0, bool p1, address p2, uint p3) internal view {
1470 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
1471 	}
1472 
1473 	function log(address p0, bool p1, address p2, string memory p3) internal view {
1474 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
1475 	}
1476 
1477 	function log(address p0, bool p1, address p2, bool p3) internal view {
1478 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
1479 	}
1480 
1481 	function log(address p0, bool p1, address p2, address p3) internal view {
1482 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
1483 	}
1484 
1485 	function log(address p0, address p1, uint p2, uint p3) internal view {
1486 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
1487 	}
1488 
1489 	function log(address p0, address p1, uint p2, string memory p3) internal view {
1490 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
1491 	}
1492 
1493 	function log(address p0, address p1, uint p2, bool p3) internal view {
1494 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
1495 	}
1496 
1497 	function log(address p0, address p1, uint p2, address p3) internal view {
1498 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
1499 	}
1500 
1501 	function log(address p0, address p1, string memory p2, uint p3) internal view {
1502 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
1503 	}
1504 
1505 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
1506 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
1507 	}
1508 
1509 	function log(address p0, address p1, string memory p2, bool p3) internal view {
1510 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
1511 	}
1512 
1513 	function log(address p0, address p1, string memory p2, address p3) internal view {
1514 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
1515 	}
1516 
1517 	function log(address p0, address p1, bool p2, uint p3) internal view {
1518 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
1519 	}
1520 
1521 	function log(address p0, address p1, bool p2, string memory p3) internal view {
1522 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
1523 	}
1524 
1525 	function log(address p0, address p1, bool p2, bool p3) internal view {
1526 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
1527 	}
1528 
1529 	function log(address p0, address p1, bool p2, address p3) internal view {
1530 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
1531 	}
1532 
1533 	function log(address p0, address p1, address p2, uint p3) internal view {
1534 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
1535 	}
1536 
1537 	function log(address p0, address p1, address p2, string memory p3) internal view {
1538 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
1539 	}
1540 
1541 	function log(address p0, address p1, address p2, bool p3) internal view {
1542 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
1543 	}
1544 
1545 	function log(address p0, address p1, address p2, address p3) internal view {
1546 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
1547 	}
1548 
1549 }
1550 
1551 /**
1552  * @title Initializable
1553  *
1554  * @dev Helper contract to support initializer functions. To use it, replace
1555  * the constructor with a function that has the `initializer` modifier.
1556  * WARNING: Unlike constructors, initializer functions must be manually
1557  * invoked. This applies both to deploying an Initializable contract, as well
1558  * as extending an Initializable contract via inheritance.
1559  * WARNING: When used with inheritance, manual care must be taken to not invoke
1560  * a parent initializer twice, or ensure that all initializers are idempotent,
1561  * because this is not dealt with automatically as with constructors.
1562  */
1563 contract Initializable {
1564 
1565   /**
1566    * @dev Indicates that the contract has been initialized.
1567    */
1568   bool private initialized;
1569 
1570   /**
1571    * @dev Indicates that the contract is in the process of being initialized.
1572    */
1573   bool private initializing;
1574 
1575   /**
1576    * @dev Modifier to use in the initializer function of a contract.
1577    */
1578   modifier initializer() {
1579     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
1580 
1581     bool isTopLevelCall = !initializing;
1582     if (isTopLevelCall) {
1583       initializing = true;
1584       initialized = true;
1585     }
1586 
1587     _;
1588 
1589     if (isTopLevelCall) {
1590       initializing = false;
1591     }
1592   }
1593 
1594   /// @dev Returns true if and only if the function is running in the constructor
1595   function isConstructor() private view returns (bool) {
1596     // extcodesize checks the size of the code stored in an address, and
1597     // address returns the current address. Since the code is still not
1598     // deployed when running a constructor, any checks on its code size will
1599     // yield zero, making it an effective way to detect if a contract is
1600     // under construction or not.
1601     address self = address(this);
1602     uint256 cs;
1603     assembly { cs := extcodesize(self) }
1604     return cs == 0;
1605   }
1606 
1607   // Reserved storage space to allow for layout changes in the future.
1608   uint256[50] private ______gap;
1609 }
1610 
1611 
1612 /*
1613  * @dev Provides information about the current execution context, including the
1614  * sender of the transaction and its data. While these are generally available
1615  * via msg.sender and msg.data, they should not be accessed in such a direct
1616  * manner, since when dealing with GSN meta-transactions the account sending and
1617  * paying for execution may not be the actual sender (as far as an application
1618  * is concerned).
1619  *
1620  * This contract is only required for intermediate, library-like contracts.
1621  */
1622 contract ContextUpgradeSafe is Initializable {
1623     // Empty internal constructor, to prevent people from mistakenly deploying
1624     // an instance of this contract, which should be used via inheritance.
1625 
1626     function __Context_init() internal initializer {
1627         __Context_init_unchained();
1628     }
1629 
1630     function __Context_init_unchained() internal initializer {
1631 
1632 
1633     }
1634 
1635 
1636     function _msgSender() internal view virtual returns (address payable) {
1637         return msg.sender;
1638     }
1639 
1640     function _msgData() internal view virtual returns (bytes memory) {
1641         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1642         return msg.data;
1643     }
1644 
1645     uint256[50] private __gap;
1646 }
1647 
1648 
1649 /**
1650  * @dev Contract module which provides a basic access control mechanism, where
1651  * there is an account (an owner) that can be granted exclusive access to
1652  * specific functions.
1653  *
1654  * By default, the owner account will be the one that deploys the contract. This
1655  * can later be changed with {transferOwnership}.
1656  *
1657  * This module is used through inheritance. It will make available the modifier
1658  * `onlyOwner`, which can be applied to your functions to restrict their use to
1659  * the owner.
1660  */
1661 contract OwnableUpgradeSafe is Initializable, ContextUpgradeSafe {
1662     address private _owner;
1663 
1664     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1665 
1666     /**
1667      * @dev Initializes the contract setting the deployer as the initial owner.
1668      */
1669 
1670     function __Ownable_init() internal initializer {
1671         __Context_init_unchained();
1672         __Ownable_init_unchained();
1673     }
1674 
1675     function __Ownable_init_unchained() internal initializer {
1676 
1677 
1678         address msgSender = _msgSender();
1679         _owner = msgSender;
1680         emit OwnershipTransferred(address(0), msgSender);
1681 
1682     }
1683 
1684 
1685     /**
1686      * @dev Returns the address of the current owner.
1687      */
1688     function owner() public view returns (address) {
1689         return _owner;
1690     }
1691 
1692     /**
1693      * @dev Throws if called by any account other than the owner.
1694      */
1695     modifier onlyOwner() {
1696         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1697         _;
1698     }
1699 
1700     /**
1701      * @dev Leaves the contract without owner. It will not be possible to call
1702      * `onlyOwner` functions anymore. Can only be called by the current owner.
1703      *
1704      * NOTE: Renouncing ownership will leave the contract without an owner,
1705      * thereby removing any functionality that is only available to the owner.
1706      */
1707     function renounceOwnership() public virtual onlyOwner {
1708         emit OwnershipTransferred(_owner, address(0));
1709         _owner = address(0);
1710     }
1711 
1712     /**
1713      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1714      * Can only be called by the current owner.
1715      */
1716     function transferOwnership(address newOwner) public virtual onlyOwner {
1717         require(newOwner != address(0), "Ownable: new owner is the zero address");
1718         emit OwnershipTransferred(_owner, newOwner);
1719         _owner = newOwner;
1720     }
1721 
1722     uint256[49] private __gap;
1723 }
1724 
1725 
1726 /**
1727  * @title SafeMathInt
1728  * @dev Math operations for int256 with overflow safety checks.
1729  */
1730 library SafeMathInt {
1731     int256 private constant MIN_INT256 = int256(1) << 255;
1732     int256 private constant MAX_INT256 = ~(int256(1) << 255);
1733 
1734     /**
1735      * @dev Multiplies two int256 variables and fails on overflow.
1736      */
1737     function mul(int256 a, int256 b)
1738         internal
1739         pure
1740         returns (int256)
1741     {
1742         int256 c = a * b;
1743 
1744         // Detect overflow when multiplying MIN_INT256 with -1
1745         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
1746         require((b == 0) || (c / b == a));
1747         return c;
1748     }
1749 
1750     /**
1751      * @dev Division of two int256 variables and fails on overflow.
1752      */
1753     function div(int256 a, int256 b)
1754         internal
1755         pure
1756         returns (int256)
1757     {
1758         // Prevent overflow when dividing MIN_INT256 by -1
1759         require(b != -1 || a != MIN_INT256);
1760 
1761         // Solidity already throws when dividing by 0.
1762         return a / b;
1763     }
1764 
1765     /**
1766      * @dev Subtracts two int256 variables and fails on overflow.
1767      */
1768     function sub(int256 a, int256 b)
1769         internal
1770         pure
1771         returns (int256)
1772     {
1773         int256 c = a - b;
1774         require((b >= 0 && c <= a) || (b < 0 && c > a));
1775         return c;
1776     }
1777 
1778     /**
1779      * @dev Adds two int256 variables and fails on overflow.
1780      */
1781     function add(int256 a, int256 b)
1782         internal
1783         pure
1784         returns (int256)
1785     {
1786         int256 c = a + b;
1787         require((b >= 0 && c >= a) || (b < 0 && c < a));
1788         return c;
1789     }
1790 
1791     /**
1792      * @dev Converts to absolute value, and fails on overflow.
1793      */
1794     function abs(int256 a)
1795         internal
1796         pure
1797         returns (int256)
1798     {
1799         require(a != MIN_INT256);
1800         return a < 0 ? -a : a;
1801     }
1802 }
1803 
1804 
1805 /**
1806  * @dev Interface of the ERC20 standard as defined in the EIP.
1807  */
1808 interface IERC20 {
1809     /**
1810      * @dev Returns the amount of tokens in existence.
1811      */
1812     function totalSupply() external view returns (uint256);
1813 
1814     /**
1815      * @dev Returns the amount of tokens owned by `account`.
1816      */
1817     function balanceOf(address account) external view returns (uint256);
1818 
1819     /**
1820      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1821      *
1822      * Returns a boolean value indicating whether the operation succeeded.
1823      *
1824      * Emits a {Transfer} event.
1825      */
1826     function transfer(address recipient, uint256 amount) external returns (bool);
1827 
1828     /**
1829      * @dev Returns the remaining number of tokens that `spender` will be
1830      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1831      * zero by default.
1832      *
1833      * This value changes when {approve} or {transferFrom} are called.
1834      */
1835     function allowance(address owner, address spender) external view returns (uint256);
1836 
1837     /**
1838      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1839      *
1840      * Returns a boolean value indicating whether the operation succeeded.
1841      *
1842      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1843      * that someone may use both the old and the new allowance by unfortunate
1844      * transaction ordering. One possible solution to mitigate this race
1845      * condition is to first reduce the spender's allowance to 0 and set the
1846      * desired value afterwards:
1847      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1848      *
1849      * Emits an {Approval} event.
1850      */
1851     function approve(address spender, uint256 amount) external returns (bool);
1852 
1853     /**
1854      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1855      * allowance mechanism. `amount` is then deducted from the caller's
1856      * allowance.
1857      *
1858      * Returns a boolean value indicating whether the operation succeeded.
1859      *
1860      * Emits a {Transfer} event.
1861      */
1862     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1863 
1864     /**
1865      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1866      * another (`to`).
1867      *
1868      * Note that `value` may be zero.
1869      */
1870     event Transfer(address indexed from, address indexed to, uint256 value);
1871 
1872     /**
1873      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1874      * a call to {approve}. `value` is the new allowance.
1875      */
1876     event Approval(address indexed owner, address indexed spender, uint256 value);
1877 }
1878 
1879 
1880 
1881 /**
1882  * @dev Wrappers over Solidity's arithmetic operations with added overflow
1883  * checks.
1884  *
1885  * Arithmetic operations in Solidity wrap on overflow. This can easily result
1886  * in bugs, because programmers usually assume that an overflow raises an
1887  * error, which is the standard behavior in high level programming languages.
1888  * `SafeMath` restores this intuition by reverting the transaction when an
1889  * operation overflows.
1890  *
1891  * Using this library instead of the unchecked operations eliminates an entire
1892  * class of bugs, so it's recommended to use it always.
1893  */
1894 library SafeMath {
1895     /**
1896      * @dev Returns the addition of two unsigned integers, reverting on
1897      * overflow.
1898      *
1899      * Counterpart to Solidity's `+` operator.
1900      *
1901      * Requirements:
1902      * - Addition cannot overflow.
1903      */
1904     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1905         uint256 c = a + b;
1906         require(c >= a, "SafeMath: addition overflow");
1907 
1908         return c;
1909     }
1910 
1911     /**
1912      * @dev Returns the subtraction of two unsigned integers, reverting on
1913      * overflow (when the result is negative).
1914      *
1915      * Counterpart to Solidity's `-` operator.
1916      *
1917      * Requirements:
1918      * - Subtraction cannot overflow.
1919      */
1920     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1921         return sub(a, b, "SafeMath: subtraction overflow");
1922     }
1923 
1924     /**
1925      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1926      * overflow (when the result is negative).
1927      *
1928      * Counterpart to Solidity's `-` operator.
1929      *
1930      * Requirements:
1931      * - Subtraction cannot overflow.
1932      */
1933     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1934         require(b <= a, errorMessage);
1935         uint256 c = a - b;
1936 
1937         return c;
1938     }
1939 
1940     /**
1941      * @dev Returns the multiplication of two unsigned integers, reverting on
1942      * overflow.
1943      *
1944      * Counterpart to Solidity's `*` operator.
1945      *
1946      * Requirements:
1947      * - Multiplication cannot overflow.
1948      */
1949     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1950         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1951         // benefit is lost if 'b' is also tested.
1952         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1953         if (a == 0) {
1954             return 0;
1955         }
1956 
1957         uint256 c = a * b;
1958         require(c / a == b, "SafeMath: multiplication overflow");
1959 
1960         return c;
1961     }
1962 
1963     /**
1964      * @dev Returns the integer division of two unsigned integers. Reverts on
1965      * division by zero. The result is rounded towards zero.
1966      *
1967      * Counterpart to Solidity's `/` operator. Note: this function uses a
1968      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1969      * uses an invalid opcode to revert (consuming all remaining gas).
1970      *
1971      * Requirements:
1972      * - The divisor cannot be zero.
1973      */
1974     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1975         return div(a, b, "SafeMath: division by zero");
1976     }
1977 
1978     /**
1979      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
1980      * division by zero. The result is rounded towards zero.
1981      *
1982      * Counterpart to Solidity's `/` operator. Note: this function uses a
1983      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1984      * uses an invalid opcode to revert (consuming all remaining gas).
1985      *
1986      * Requirements:
1987      * - The divisor cannot be zero.
1988      */
1989     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1990         // Solidity only automatically asserts when dividing by 0
1991         require(b > 0, errorMessage);
1992         uint256 c = a / b;
1993         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1994 
1995         return c;
1996     }
1997 
1998     /**
1999      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
2000      * Reverts when dividing by zero.
2001      *
2002      * Counterpart to Solidity's `%` operator. This function uses a `revert`
2003      * opcode (which leaves remaining gas untouched) while Solidity uses an
2004      * invalid opcode to revert (consuming all remaining gas).
2005      *
2006      * Requirements:
2007      * - The divisor cannot be zero.
2008      */
2009     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
2010         return mod(a, b, "SafeMath: modulo by zero");
2011     }
2012 
2013     /**
2014      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
2015      * Reverts with custom message when dividing by zero.
2016      *
2017      * Counterpart to Solidity's `%` operator. This function uses a `revert`
2018      * opcode (which leaves remaining gas untouched) while Solidity uses an
2019      * invalid opcode to revert (consuming all remaining gas).
2020      *
2021      * Requirements:
2022      * - The divisor cannot be zero.
2023      */
2024     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
2025         require(b != 0, errorMessage);
2026         return a % b;
2027     }
2028 }
2029 
2030 
2031 
2032 /**
2033  * @dev Collection of functions related to the address type
2034  */
2035 library Address {
2036     /**
2037      * @dev Returns true if `account` is a contract.
2038      *
2039      * [IMPORTANT]
2040      * ====
2041      * It is unsafe to assume that an address for which this function returns
2042      * false is an externally-owned account (EOA) and not a contract.
2043      *
2044      * Among others, `isContract` will return false for the following
2045      * types of addresses:
2046      *
2047      *  - an externally-owned account
2048      *  - a contract in construction
2049      *  - an address where a contract will be created
2050      *  - an address where a contract lived, but was destroyed
2051      * ====
2052      */
2053     function isContract(address account) internal view returns (bool) {
2054         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
2055         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
2056         // for accounts without code, i.e. `keccak256('')`
2057         bytes32 codehash;
2058         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
2059         // solhint-disable-next-line no-inline-assembly
2060         assembly { codehash := extcodehash(account) }
2061         return (codehash != accountHash && codehash != 0x0);
2062     }
2063 
2064     /**
2065      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
2066      * `recipient`, forwarding all available gas and reverting on errors.
2067      *
2068      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
2069      * of certain opcodes, possibly making contracts go over the 2300 gas limit
2070      * imposed by `transfer`, making them unable to receive funds via
2071      * `transfer`. {sendValue} removes this limitation.
2072      *
2073      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
2074      *
2075      * IMPORTANT: because control is transferred to `recipient`, care must be
2076      * taken to not create reentrancy vulnerabilities. Consider using
2077      * {ReentrancyGuard} or the
2078      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
2079      */
2080     function sendValue(address payable recipient, uint256 amount) internal {
2081         require(address(this).balance >= amount, "Address: insufficient balance");
2082 
2083         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
2084         (bool success, ) = recipient.call{ value: amount }("");
2085         require(success, "Address: unable to send value, recipient may have reverted");
2086     }
2087 }
2088 
2089 
2090 
2091 /**
2092  * @dev Implementation of the {IERC20} interface.
2093  *
2094  * This implementation is agnostic to the way tokens are created. This means
2095  * that a supply mechanism has to be added in a derived contract using {_mint}.
2096  * For a generic mechanism see {ERC20MinterPauser}.
2097  *
2098  * TIP: For a detailed writeup see our guide
2099  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
2100  * to implement supply mechanisms].
2101  *
2102  * We have followed general OpenZeppelin guidelines: functions revert instead
2103  * of returning `false` on failure. This behavior is nonetheless conventional
2104  * and does not conflict with the expectations of ERC20 applications.
2105  *
2106  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
2107  * This allows applications to reconstruct the allowance for all accounts just
2108  * by listening to said events. Other implementations of the EIP may not emit
2109  * these events, as it isn't required by the specification.
2110  *
2111  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
2112  * functions have been added to mitigate the well-known issues around setting
2113  * allowances. See {IERC20-approve}.
2114  */
2115 contract ERC20UpgradeSafe is Initializable, ContextUpgradeSafe, IERC20 {
2116     using SafeMath for uint256;
2117     using Address for address;
2118 
2119     mapping (address => uint256) private _balances;
2120 
2121     mapping (address => mapping (address => uint256)) private _allowances;
2122 
2123     uint256 private _totalSupply;
2124 
2125     string private _name;
2126     string private _symbol;
2127     uint8 private _decimals;
2128 
2129     /**
2130      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
2131      * a default value of 18.
2132      *
2133      * To select a different value for {decimals}, use {_setupDecimals}.
2134      *
2135      * All three of these values are immutable: they can only be set once during
2136      * construction.
2137      */
2138 
2139     function __ERC20_init(string memory name, string memory symbol) internal initializer {
2140         __Context_init_unchained();
2141         __ERC20_init_unchained(name, symbol);
2142     }
2143 
2144     function __ERC20_init_unchained(string memory name, string memory symbol) internal initializer {
2145 
2146 
2147         _name = name;
2148         _symbol = symbol;
2149         _decimals = 18;
2150 
2151     }
2152 
2153 
2154     /**
2155      * @dev Returns the name of the token.
2156      */
2157     function name() public view returns (string memory) {
2158         return _name;
2159     }
2160 
2161     /**
2162      * @dev Returns the symbol of the token, usually a shorter version of the
2163      * name.
2164      */
2165     function symbol() public view returns (string memory) {
2166         return _symbol;
2167     }
2168 
2169     /**
2170      * @dev Returns the number of decimals used to get its user representation.
2171      * For example, if `decimals` equals `2`, a balance of `505` tokens should
2172      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
2173      *
2174      * Tokens usually opt for a value of 18, imitating the relationship between
2175      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
2176      * called.
2177      *
2178      * NOTE: This information is only used for _display_ purposes: it in
2179      * no way affects any of the arithmetic of the contract, including
2180      * {IERC20-balanceOf} and {IERC20-transfer}.
2181      */
2182     function decimals() public view returns (uint8) {
2183         return _decimals;
2184     }
2185 
2186     /**
2187      * @dev See {IERC20-totalSupply}.
2188      */
2189     function totalSupply() public view virtual override returns (uint256) {
2190         return _totalSupply;
2191     }
2192 
2193     /**
2194      * @dev See {IERC20-balanceOf}.
2195      */
2196     function balanceOf(address account) public view virtual override returns (uint256) {
2197         return _balances[account];
2198     }
2199 
2200     /**
2201      * @dev See {IERC20-transfer}.
2202      *
2203      * Requirements:
2204      *
2205      * - `recipient` cannot be the zero address.
2206      * - the caller must have a balance of at least `amount`.
2207      */
2208     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
2209         _transfer(_msgSender(), recipient, amount);
2210         return true;
2211     }
2212 
2213     /**
2214      * @dev See {IERC20-allowance}.
2215      */
2216     function allowance(address owner, address spender) public view virtual override returns (uint256) {
2217         return _allowances[owner][spender];
2218     }
2219 
2220     /**
2221      * @dev See {IERC20-approve}.
2222      *
2223      * Requirements:
2224      *
2225      * - `spender` cannot be the zero address.
2226      */
2227     function approve(address spender, uint256 amount) public virtual override returns (bool) {
2228         _approve(_msgSender(), spender, amount);
2229         return true;
2230     }
2231 
2232     /**
2233      * @dev See {IERC20-transferFrom}.
2234      *
2235      * Emits an {Approval} event indicating the updated allowance. This is not
2236      * required by the EIP. See the note at the beginning of {ERC20};
2237      *
2238      * Requirements:
2239      * - `sender` and `recipient` cannot be the zero address.
2240      * - `sender` must have a balance of at least `amount`.
2241      * - the caller must have allowance for ``sender``'s tokens of at least
2242      * `amount`.
2243      */
2244     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
2245         _transfer(sender, recipient, amount);
2246         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
2247         return true;
2248     }
2249 
2250     /**
2251      * @dev Atomically increases the allowance granted to `spender` by the caller.
2252      *
2253      * This is an alternative to {approve} that can be used as a mitigation for
2254      * problems described in {IERC20-approve}.
2255      *
2256      * Emits an {Approval} event indicating the updated allowance.
2257      *
2258      * Requirements:
2259      *
2260      * - `spender` cannot be the zero address.
2261      */
2262     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
2263         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
2264         return true;
2265     }
2266 
2267     /**
2268      * @dev Atomically decreases the allowance granted to `spender` by the caller.
2269      *
2270      * This is an alternative to {approve} that can be used as a mitigation for
2271      * problems described in {IERC20-approve}.
2272      *
2273      * Emits an {Approval} event indicating the updated allowance.
2274      *
2275      * Requirements:
2276      *
2277      * - `spender` cannot be the zero address.
2278      * - `spender` must have allowance for the caller of at least
2279      * `subtractedValue`.
2280      */
2281     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
2282         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
2283         return true;
2284     }
2285 
2286     /**
2287      * @dev Moves tokens `amount` from `sender` to `recipient`.
2288      *
2289      * This is internal function is equivalent to {transfer}, and can be used to
2290      * e.g. implement automatic token fees, slashing mechanisms, etc.
2291      *
2292      * Emits a {Transfer} event.
2293      *
2294      * Requirements:
2295      *
2296      * - `sender` cannot be the zero address.
2297      * - `recipient` cannot be the zero address.
2298      * - `sender` must have a balance of at least `amount`.
2299      */
2300     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
2301         require(sender != address(0), "ERC20: transfer from the zero address");
2302 
2303         _beforeTokenTransfer(sender, recipient, amount);
2304 
2305         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
2306         _balances[recipient] = _balances[recipient].add(amount);
2307         emit Transfer(sender, recipient, amount);
2308     }
2309 
2310     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
2311      * the total supply.
2312      *
2313      * Emits a {Transfer} event with `from` set to the zero address.
2314      *
2315      * Requirements
2316      *
2317      * - `to` cannot be the zero address.
2318      */
2319     function _mint(address account, uint256 amount) internal virtual {
2320         require(account != address(0), "ERC20: mint to the zero address");
2321 
2322         _beforeTokenTransfer(address(0), account, amount);
2323 
2324         _totalSupply = _totalSupply.add(amount);
2325         _balances[account] = _balances[account].add(amount);
2326         emit Transfer(address(0), account, amount);
2327     }
2328 
2329     /**
2330      * @dev Destroys `amount` tokens from `account`, reducing the
2331      * total supply.
2332      *
2333      * Emits a {Transfer} event with `to` set to the zero address.
2334      *
2335      * Requirements
2336      *
2337      * - `account` cannot be the zero address.
2338      * - `account` must have at least `amount` tokens.
2339      */
2340     function _burn(address account, uint256 amount) internal virtual {
2341         require(account != address(0), "ERC20: burn from the zero address");
2342 
2343         _beforeTokenTransfer(account, address(0), amount);
2344 
2345         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
2346         _totalSupply = _totalSupply.sub(amount);
2347         emit Transfer(account, address(0), amount);
2348     }
2349 
2350     /**
2351      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
2352      *
2353      * This is internal function is equivalent to `approve`, and can be used to
2354      * e.g. set automatic allowances for certain subsystems, etc.
2355      *
2356      * Emits an {Approval} event.
2357      *
2358      * Requirements:
2359      *
2360      * - `owner` cannot be the zero address.
2361      * - `spender` cannot be the zero address.
2362      */
2363     function _approve(address owner, address spender, uint256 amount) internal virtual {
2364         require(owner != address(0), "ERC20: approve from the zero address");
2365         require(spender != address(0), "ERC20: approve to the zero address");
2366 
2367         _allowances[owner][spender] = amount;
2368         emit Approval(owner, spender, amount);
2369     }
2370 
2371     /**
2372      * @dev Sets {decimals} to a value other than the default one of 18.
2373      *
2374      * WARNING: This function should only be called from the constructor. Most
2375      * applications that interact with token contracts will not expect
2376      * {decimals} to ever change, and may work incorrectly if it does.
2377      */
2378     function _setupDecimals(uint8 decimals_) internal {
2379         _decimals = decimals_;
2380     }
2381 
2382     /**
2383      * @dev Hook that is called before any transfer of tokens. This includes
2384      * minting and burning.
2385      *
2386      * Calling conditions:
2387      *
2388      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2389      * will be to transferred to `to`.
2390      * - when `from` is zero, `amount` tokens will be minted for `to`.
2391      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
2392      * - `from` and `to` are never both zero.
2393      *
2394      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2395      */
2396     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
2397 
2398     uint256[44] private __gap;
2399 }
2400 
2401 
2402 abstract contract ERC677Token is ERC677 {
2403     /**
2404     * @dev transfer token to a contract address with additional data if the recipient is a contact.
2405     * @param _to The address to transfer to.
2406     * @param _value The amount to be transferred.
2407     * @param _data The extra data to be passed to the receiving contract.
2408     */
2409     function transferAndCall(address _to, uint _value, bytes memory _data)
2410         public
2411         override
2412         returns (bool success)
2413     {
2414         transfer(_to, _value);
2415         // emit Transfer(msg.sender, _to, _value, _data);
2416         if (isContract(_to)) {
2417             contractFallback(_to, _value, _data);
2418         }
2419         return true;
2420     }
2421 
2422     function contractFallback(address _to, uint _value, bytes memory _data)
2423         private
2424     {
2425         ERC677Receiver receiver = ERC677Receiver(_to);
2426         receiver.onTokenTransfer(msg.sender, _value, _data);
2427     }
2428 
2429     function isContract(address _addr)
2430         private
2431         view
2432         returns (bool hasCode)
2433     {
2434         uint length;
2435         // solhint-disable-next-line no-inline-assembly
2436         assembly { length := extcodesize(_addr) }
2437         return length > 0;
2438     }
2439 }
2440 
2441 /**
2442  * @title DEFIBASE ERC20 token
2443  * @dev This is part of an implementation of the DEFIBASE Index Fund protocol.
2444  *      DEFIBASE is a normal ERC20 token, but its supply can be adjusted by splitting and
2445  *      combining tokens proportionally across all wallets.
2446  *
2447  *      DEFIBASE balances are internally represented with a hidden denomination, 'shares'.
2448  *      We support splitting the currency in expansion and combining the currency on contraction by
2449  *      changing the exchange rate between the hidden 'shares' and the public 'BASE'.
2450  */
2451 contract DEFIBaseToken is ERC20UpgradeSafe, ERC677Token, OwnableUpgradeSafe {
2452     // PLEASE READ BEFORE CHANGING ANY ACCOUNTING OR MATH
2453     // Anytime there is division, there is a risk of numerical instability from rounding errors. In
2454     // order to minimize this risk, we adhere to the following guidelines:
2455     // 1) The conversion rate adopted is the number of shares that equals 1 DEFIBASE.
2456     //    The inverse rate must not be used--totalShares is always the numerator and _totalSupply is
2457     //    always the denominator. (i.e. If you want to convert shares to DEFIBASE instead of
2458     //    multiplying by the inverse rate, you should divide by the normal rate)
2459     // 2) Share balances converted into DEFIBaseToken are always rounded down (truncated).
2460     //
2461     // We make the following guarantees:
2462     // - If address 'A' transfers x DEFIBaseToken to address 'B'. A's resulting external balance will
2463     //   be decreased by precisely x DEFIBaseToken, and B's external balance will be precisely
2464     //   increased by x DEFIBaseToken.
2465     //
2466     // We do not guarantee that the sum of all balances equals the result of calling totalSupply().
2467     // This is because, for any conversion function 'f()' that has non-zero rounding error,
2468     // f(x0) + f(x1) + ... + f(xn) is not always equal to f(x0 + x1 + ... xn).
2469     using SafeMath for uint256;
2470     using SafeMathInt for int256;
2471 
2472     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
2473     event LogMonetaryPolicyUpdated(address monetaryPolicy);
2474 
2475     // Used for authentication
2476     address public monetaryPolicy;
2477 
2478     modifier validRecipient(address to) {
2479         require(to != address(0x0));
2480         require(to != address(this));
2481         _;
2482     }
2483 
2484     uint256 private constant DECIMALS = 9;
2485     uint256 private constant MAX_UINT256 = ~uint256(0);
2486     uint256 private constant INITIAL_SUPPLY = 5000000 * 10**DECIMALS;
2487     uint256 private constant INITIAL_SHARES = (MAX_UINT256 / (10 ** 36)) - ((MAX_UINT256 / (10 ** 36)) % INITIAL_SUPPLY);
2488     uint256 private constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1
2489 
2490     uint256 private _totalShares;
2491     uint256 private _totalSupply;
2492     uint256 private _sharesPerDEFIBASE;
2493     mapping(address => uint256) private _shareBalances;
2494 
2495 
2496     // This is denominated in DEFIBaseToken, because the shares-DEFIBASE conversion might change before
2497     // it's fully paid.
2498     mapping (address => mapping (address => uint256)) private _allowedDEFIBASE;
2499 
2500     bool public transfersPaused;
2501     bool public rebasesPaused;
2502 
2503     mapping(address => bool) public transferPauseExemptList;
2504 
2505     function setTransfersPaused(bool _transfersPaused)
2506         public
2507         onlyOwner
2508     {
2509         transfersPaused = _transfersPaused;
2510     }
2511 
2512     function setTransferPauseExempt(address user, bool exempt)
2513         public
2514         onlyOwner
2515     {
2516         if (exempt) {
2517             transferPauseExemptList[user] = true;
2518         } else {
2519             delete transferPauseExemptList[user];
2520         }
2521     }
2522 
2523     function setRebasesPaused(bool _rebasesPaused)
2524         public
2525         onlyOwner
2526     {
2527         rebasesPaused = _rebasesPaused;
2528     }
2529 
2530 	function setMonetaryPolicy(address monetaryPolicy_)
2531         external
2532         onlyOwner
2533     {
2534         monetaryPolicy = monetaryPolicy_;
2535         emit LogMonetaryPolicyUpdated(monetaryPolicy_);
2536     }
2537 
2538     /**
2539      * @dev Notifies DEFIBaseToken contract about a new rebase cycle.
2540      * @param supplyDelta The number of new DEFIBASE tokens to add into circulation via expansion.
2541      * @return The total number of DEFIBASE after the supply adjustment.
2542      */
2543     function rebase(uint256 epoch, int256 supplyDelta)
2544         external
2545         returns (uint256)
2546     {
2547         require(msg.sender == monetaryPolicy, "only monetary policy");
2548         require(!rebasesPaused, "rebases paused");
2549 
2550         if (supplyDelta == 0) {
2551             emit LogRebase(epoch, _totalSupply);
2552             return _totalSupply;
2553         }
2554 
2555         if (supplyDelta < 0) {
2556             _totalSupply = _totalSupply.sub(uint256(supplyDelta.abs()));
2557         } else {
2558             _totalSupply = _totalSupply.add(uint256(supplyDelta));
2559         }
2560 
2561         if (_totalSupply > MAX_SUPPLY) {
2562             _totalSupply = MAX_SUPPLY;
2563         }
2564 
2565         _sharesPerDEFIBASE = _totalShares.div(_totalSupply);
2566 
2567         // From this point forward, _sharesPerDEFIBASE is taken as the source of truth.
2568         // We recalculate a new _totalSupply to be in agreement with the _sharesPerDEFIBASE
2569         // conversion rate.
2570         // This means our applied supplyDelta can deviate from the requested supplyDelta,
2571         // but this deviation is guaranteed to be < (_totalSupply^2)/(totalShares - _totalSupply).
2572         //
2573         // In the case of _totalSupply <= MAX_UINT128 (our current supply cap), this
2574         // deviation is guaranteed to be < 1, so we can omit this step. If the supply cap is
2575         // ever increased, it must be re-included.
2576 
2577         emit LogRebase(epoch, _totalSupply);
2578         return _totalSupply;
2579     }
2580 
2581     function totalShares()
2582         public
2583         view
2584         returns (uint256)
2585     {
2586         return _totalShares;
2587     }
2588 
2589     function sharesOf(address user)
2590         public
2591         view
2592         returns (uint256)
2593     {
2594         return _shareBalances[user];
2595     }
2596 
2597     function mintShares(address recipient, uint256 amount)
2598         public
2599     {
2600         require(msg.sender == monetaryPolicy, "forbidden");
2601         _shareBalances[recipient] = _shareBalances[recipient].add(amount);
2602         _totalShares = _totalShares.add(amount);
2603     }
2604 
2605     function burnShares(address recipient, uint256 amount)
2606         public
2607     {
2608         require(msg.sender == monetaryPolicy, "forbidden");
2609         require(_shareBalances[recipient] >= amount, "amount");
2610         _shareBalances[recipient] = _shareBalances[recipient].sub(amount);
2611         _totalShares = _totalShares.sub(amount);
2612     }
2613 
2614     function initialize()
2615         public
2616         initializer
2617     {
2618         __ERC20_init("DEFIBase", "DEFIB");
2619         _setupDecimals(uint8(DECIMALS));
2620         __Ownable_init();
2621 
2622         _totalShares = INITIAL_SHARES;
2623         _totalSupply = INITIAL_SUPPLY;
2624         _shareBalances[owner()] = _totalShares;
2625         _sharesPerDEFIBASE = _totalShares.div(_totalSupply);
2626 		transfersPaused = true;
2627 		transferPauseExemptList[owner()] = true;
2628         emit Transfer(address(0x0), owner(), _totalSupply);
2629     }
2630 
2631     /**
2632      * @return The total number of DEFIBASE.
2633      */
2634     function totalSupply()
2635         public
2636         override
2637         view
2638         returns (uint256)
2639     {
2640         return _totalSupply;
2641     }
2642 
2643     /**
2644      * @param who The address to query.
2645      * @return The balance of the specified address.
2646      */
2647     function balanceOf(address who)
2648         public
2649         override
2650         view
2651         returns (uint256)
2652     {
2653         return _shareBalances[who].div(_sharesPerDEFIBASE);
2654     }
2655 
2656     /**
2657      * @dev Transfer tokens to a specified address.
2658      * @param to The address to transfer to.
2659      * @param value The amount to be transferred.
2660      * @return True on success, false otherwise.
2661      */
2662     function transfer(address to, uint256 value)
2663         public
2664         override(ERC20UpgradeSafe, ERC677)
2665         validRecipient(to)
2666         returns (bool)
2667     {
2668         require(!transfersPaused || transferPauseExemptList[msg.sender], "paused");
2669 
2670         uint256 shareValue = value.mul(_sharesPerDEFIBASE);
2671         _shareBalances[msg.sender] = _shareBalances[msg.sender].sub(shareValue);
2672         _shareBalances[to] = _shareBalances[to].add(shareValue);
2673         emit Transfer(msg.sender, to, value);
2674         return true;
2675     }
2676 
2677     /**
2678      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
2679      * @param owner_ The address which owns the funds.
2680      * @param spender The address which will spend the funds.
2681      * @return The number of tokens still available for the spender.
2682      */
2683     function allowance(address owner_, address spender)
2684         public
2685         override
2686         view
2687         returns (uint256)
2688     {
2689         return _allowedDEFIBASE[owner_][spender];
2690     }
2691 
2692     /**
2693      * @dev Transfer tokens from one address to another.
2694      * @param from The address you want to send tokens from.
2695      * @param to The address you want to transfer to.
2696      * @param value The amount of tokens to be transferred.
2697      */
2698     function transferFrom(address from, address to, uint256 value)
2699         public
2700         override
2701         validRecipient(to)
2702         returns (bool)
2703     {
2704         require(!transfersPaused || transferPauseExemptList[msg.sender], "paused");
2705 
2706         _allowedDEFIBASE[from][msg.sender] = _allowedDEFIBASE[from][msg.sender].sub(value);
2707 
2708         uint256 shareValue = value.mul(_sharesPerDEFIBASE);
2709         _shareBalances[from] = _shareBalances[from].sub(shareValue);
2710         _shareBalances[to] = _shareBalances[to].add(shareValue);
2711         emit Transfer(from, to, value);
2712 
2713         return true;
2714     }
2715 
2716     /**
2717      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
2718      * msg.sender. This method is included for ERC20 compatibility.
2719      * increaseAllowance and decreaseAllowance should be used instead.
2720      * Changing an allowance with this method brings the risk that someone may transfer both
2721      * the old and the new allowance - if they are both greater than zero - if a transfer
2722      * transaction is mined before the later approve() call is mined.
2723      *
2724      * @param spender The address which will spend the funds.
2725      * @param value The amount of tokens to be spent.
2726      */
2727     function approve(address spender, uint256 value)
2728         public
2729         override
2730         returns (bool)
2731     {
2732         require(!transfersPaused || transferPauseExemptList[msg.sender], "paused");
2733 
2734         _allowedDEFIBASE[msg.sender][spender] = value;
2735         emit Approval(msg.sender, spender, value);
2736         return true;
2737     }
2738 
2739     /**
2740      * @dev Increase the amount of tokens that an owner has allowed to a spender.
2741      * This method should be used instead of approve() to avoid the double approval vulnerability
2742      * described above.
2743      * @param spender The address which will spend the funds.
2744      * @param addedValue The amount of tokens to increase the allowance by.
2745      */
2746     function increaseAllowance(address spender, uint256 addedValue)
2747         public
2748         override
2749         returns (bool)
2750     {
2751         require(!transfersPaused || transferPauseExemptList[msg.sender], "paused");
2752 
2753         _allowedDEFIBASE[msg.sender][spender] = _allowedDEFIBASE[msg.sender][spender].add(addedValue);
2754         emit Approval(msg.sender, spender, _allowedDEFIBASE[msg.sender][spender]);
2755         return true;
2756     }
2757 
2758     /**
2759      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
2760      *
2761      * @param spender The address which will spend the funds.
2762      * @param subtractedValue The amount of tokens to decrease the allowance by.
2763      */
2764     function decreaseAllowance(address spender, uint256 subtractedValue)
2765         public
2766         override
2767         returns (bool)
2768     {
2769         require(!transfersPaused || transferPauseExemptList[msg.sender], "paused");
2770 
2771         uint256 oldValue = _allowedDEFIBASE[msg.sender][spender];
2772         if (subtractedValue >= oldValue) {
2773             _allowedDEFIBASE[msg.sender][spender] = 0;
2774         } else {
2775             _allowedDEFIBASE[msg.sender][spender] = oldValue.sub(subtractedValue);
2776         }
2777         emit Approval(msg.sender, spender, _allowedDEFIBASE[msg.sender][spender]);
2778         return true;
2779     }
2780 }