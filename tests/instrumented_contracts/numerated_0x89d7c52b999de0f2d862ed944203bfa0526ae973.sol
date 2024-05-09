1 // Sources flattened with hardhat v2.6.8 https://hardhat.org
2 
3 // File hardhat/console.sol@v2.6.8
4 
5 
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
1539 // File @openzeppelin/contracts/utils/Context.sol@v4.4.0-rc.0
1540 
1541 
1542 // OpenZeppelin Contracts v4.4.0-rc.0 (utils/Context.sol)
1543 
1544 pragma solidity ^0.8.0;
1545 
1546 /**
1547  * @dev Provides information about the current execution context, including the
1548  * sender of the transaction and its data. While these are generally available
1549  * via msg.sender and msg.data, they should not be accessed in such a direct
1550  * manner, since when dealing with meta-transactions the account sending and
1551  * paying for execution may not be the actual sender (as far as an application
1552  * is concerned).
1553  *
1554  * This contract is only required for intermediate, library-like contracts.
1555  */
1556 abstract contract Context {
1557     function _msgSender() internal view virtual returns (address) {
1558         return msg.sender;
1559     }
1560 
1561     function _msgData() internal view virtual returns (bytes calldata) {
1562         return msg.data;
1563     }
1564 }
1565 
1566 
1567 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.0-rc.0
1568 
1569 
1570 // OpenZeppelin Contracts v4.4.0-rc.0 (access/Ownable.sol)
1571 
1572 pragma solidity ^0.8.0;
1573 
1574 /**
1575  * @dev Contract module which provides a basic access control mechanism, where
1576  * there is an account (an owner) that can be granted exclusive access to
1577  * specific functions.
1578  *
1579  * By default, the owner account will be the one that deploys the contract. This
1580  * can later be changed with {transferOwnership}.
1581  *
1582  * This module is used through inheritance. It will make available the modifier
1583  * `onlyOwner`, which can be applied to your functions to restrict their use to
1584  * the owner.
1585  */
1586 abstract contract Ownable is Context {
1587     address private _owner;
1588 
1589     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1590 
1591     /**
1592      * @dev Initializes the contract setting the deployer as the initial owner.
1593      */
1594     constructor() {
1595         _transferOwnership(_msgSender());
1596     }
1597 
1598     /**
1599      * @dev Returns the address of the current owner.
1600      */
1601     function owner() public view virtual returns (address) {
1602         return _owner;
1603     }
1604 
1605     /**
1606      * @dev Throws if called by any account other than the owner.
1607      */
1608     modifier onlyOwner() {
1609         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1610         _;
1611     }
1612 
1613     /**
1614      * @dev Leaves the contract without owner. It will not be possible to call
1615      * `onlyOwner` functions anymore. Can only be called by the current owner.
1616      *
1617      * NOTE: Renouncing ownership will leave the contract without an owner,
1618      * thereby removing any functionality that is only available to the owner.
1619      */
1620     function renounceOwnership() public virtual onlyOwner {
1621         _transferOwnership(address(0));
1622     }
1623 
1624     /**
1625      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1626      * Can only be called by the current owner.
1627      */
1628     function transferOwnership(address newOwner) public virtual onlyOwner {
1629         require(newOwner != address(0), "Ownable: new owner is the zero address");
1630         _transferOwnership(newOwner);
1631     }
1632 
1633     /**
1634      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1635      * Internal function without access restriction.
1636      */
1637     function _transferOwnership(address newOwner) internal virtual {
1638         address oldOwner = _owner;
1639         _owner = newOwner;
1640         emit OwnershipTransferred(oldOwner, newOwner);
1641     }
1642 }
1643 
1644 
1645 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.4.0-rc.0
1646 
1647 
1648 // OpenZeppelin Contracts v4.4.0-rc.0 (utils/math/SafeMath.sol)
1649 
1650 pragma solidity ^0.8.0;
1651 
1652 // CAUTION
1653 // This version of SafeMath should only be used with Solidity 0.8 or later,
1654 // because it relies on the compiler's built in overflow checks.
1655 
1656 /**
1657  * @dev Wrappers over Solidity's arithmetic operations.
1658  *
1659  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1660  * now has built in overflow checking.
1661  */
1662 library SafeMath {
1663     /**
1664      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1665      *
1666      * _Available since v3.4._
1667      */
1668     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1669         unchecked {
1670             uint256 c = a + b;
1671             if (c < a) return (false, 0);
1672             return (true, c);
1673         }
1674     }
1675 
1676     /**
1677      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1678      *
1679      * _Available since v3.4._
1680      */
1681     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1682         unchecked {
1683             if (b > a) return (false, 0);
1684             return (true, a - b);
1685         }
1686     }
1687 
1688     /**
1689      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1690      *
1691      * _Available since v3.4._
1692      */
1693     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1694         unchecked {
1695             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1696             // benefit is lost if 'b' is also tested.
1697             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1698             if (a == 0) return (true, 0);
1699             uint256 c = a * b;
1700             if (c / a != b) return (false, 0);
1701             return (true, c);
1702         }
1703     }
1704 
1705     /**
1706      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1707      *
1708      * _Available since v3.4._
1709      */
1710     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1711         unchecked {
1712             if (b == 0) return (false, 0);
1713             return (true, a / b);
1714         }
1715     }
1716 
1717     /**
1718      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1719      *
1720      * _Available since v3.4._
1721      */
1722     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1723         unchecked {
1724             if (b == 0) return (false, 0);
1725             return (true, a % b);
1726         }
1727     }
1728 
1729     /**
1730      * @dev Returns the addition of two unsigned integers, reverting on
1731      * overflow.
1732      *
1733      * Counterpart to Solidity's `+` operator.
1734      *
1735      * Requirements:
1736      *
1737      * - Addition cannot overflow.
1738      */
1739     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1740         return a + b;
1741     }
1742 
1743     /**
1744      * @dev Returns the subtraction of two unsigned integers, reverting on
1745      * overflow (when the result is negative).
1746      *
1747      * Counterpart to Solidity's `-` operator.
1748      *
1749      * Requirements:
1750      *
1751      * - Subtraction cannot overflow.
1752      */
1753     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1754         return a - b;
1755     }
1756 
1757     /**
1758      * @dev Returns the multiplication of two unsigned integers, reverting on
1759      * overflow.
1760      *
1761      * Counterpart to Solidity's `*` operator.
1762      *
1763      * Requirements:
1764      *
1765      * - Multiplication cannot overflow.
1766      */
1767     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1768         return a * b;
1769     }
1770 
1771     /**
1772      * @dev Returns the integer division of two unsigned integers, reverting on
1773      * division by zero. The result is rounded towards zero.
1774      *
1775      * Counterpart to Solidity's `/` operator.
1776      *
1777      * Requirements:
1778      *
1779      * - The divisor cannot be zero.
1780      */
1781     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1782         return a / b;
1783     }
1784 
1785     /**
1786      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1787      * reverting when dividing by zero.
1788      *
1789      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1790      * opcode (which leaves remaining gas untouched) while Solidity uses an
1791      * invalid opcode to revert (consuming all remaining gas).
1792      *
1793      * Requirements:
1794      *
1795      * - The divisor cannot be zero.
1796      */
1797     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1798         return a % b;
1799     }
1800 
1801     /**
1802      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1803      * overflow (when the result is negative).
1804      *
1805      * CAUTION: This function is deprecated because it requires allocating memory for the error
1806      * message unnecessarily. For custom revert reasons use {trySub}.
1807      *
1808      * Counterpart to Solidity's `-` operator.
1809      *
1810      * Requirements:
1811      *
1812      * - Subtraction cannot overflow.
1813      */
1814     function sub(
1815         uint256 a,
1816         uint256 b,
1817         string memory errorMessage
1818     ) internal pure returns (uint256) {
1819         unchecked {
1820             require(b <= a, errorMessage);
1821             return a - b;
1822         }
1823     }
1824 
1825     /**
1826      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1827      * division by zero. The result is rounded towards zero.
1828      *
1829      * Counterpart to Solidity's `/` operator. Note: this function uses a
1830      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1831      * uses an invalid opcode to revert (consuming all remaining gas).
1832      *
1833      * Requirements:
1834      *
1835      * - The divisor cannot be zero.
1836      */
1837     function div(
1838         uint256 a,
1839         uint256 b,
1840         string memory errorMessage
1841     ) internal pure returns (uint256) {
1842         unchecked {
1843             require(b > 0, errorMessage);
1844             return a / b;
1845         }
1846     }
1847 
1848     /**
1849      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1850      * reverting with custom message when dividing by zero.
1851      *
1852      * CAUTION: This function is deprecated because it requires allocating memory for the error
1853      * message unnecessarily. For custom revert reasons use {tryMod}.
1854      *
1855      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1856      * opcode (which leaves remaining gas untouched) while Solidity uses an
1857      * invalid opcode to revert (consuming all remaining gas).
1858      *
1859      * Requirements:
1860      *
1861      * - The divisor cannot be zero.
1862      */
1863     function mod(
1864         uint256 a,
1865         uint256 b,
1866         string memory errorMessage
1867     ) internal pure returns (uint256) {
1868         unchecked {
1869             require(b > 0, errorMessage);
1870             return a % b;
1871         }
1872     }
1873 }
1874 
1875 
1876 // File contracts/interfaces/IERC20.sol
1877 
1878 interface IERC20 {
1879     event Approval(address indexed owner, address indexed spender, uint value);
1880     event Transfer(address indexed from, address indexed to, uint value);
1881 
1882     function name() external view returns (string memory);
1883     function symbol() external view returns (string memory);
1884     function decimals() external view returns (uint8);
1885     function totalSupply() external view returns (uint);
1886     function balanceOf(address owner) external view returns (uint);
1887     function allowance(address owner, address spender) external view returns (uint);
1888 
1889     function approve(address spender, uint value) external returns (bool);
1890     function transfer(address to, uint value) external returns (bool);
1891     function transferFrom(address from, address to, uint value) external returns (bool);
1892 }
1893 
1894 
1895 // File contracts/interfaces/IWETH.sol
1896 
1897 interface IWETH {
1898     function deposit() external payable;
1899     function transfer(address to, uint value) external returns (bool);
1900     function withdraw(uint) external;
1901     function balanceOf(address) external returns (uint);
1902     function transferFrom(address src, address dst, uint wad) external returns (bool);
1903     function approve(address guy, uint wad) external returns (bool);
1904 }
1905 
1906 
1907 // File contracts/interfaces/IRouter.sol
1908 
1909 interface IRouter {
1910     function buy(address _token, address[] calldata _recipients, uint256[] calldata _amountIns, uint256[] calldata _maxOuts)  external returns (uint256 amountSpent);
1911     function sell(address _token, address[] calldata _sellers, uint256[] calldata _amountIns, bool _isPercent)  external returns (uint256 amountReceived);
1912 }
1913 
1914 
1915 // File contracts/libraries/TransferHelper.sol
1916 
1917 library TransferHelper {
1918     function safeApprove(address token, address to, uint value) internal {
1919         // bytes4(keccak256(bytes('approve(address,uint256)')));
1920         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
1921         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
1922     }
1923 
1924     function safeTransfer(address token, address to, uint value) internal {
1925         // bytes4(keccak256(bytes('transfer(address,uint256)')));
1926         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
1927         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
1928     }
1929 
1930     function safeTransferFrom(address token, address from, address to, uint value) internal {
1931         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
1932         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
1933         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
1934     }
1935 
1936     function safeTransferETH(address to, uint value) internal {
1937         (bool success,) = to.call{value:value}(new bytes(0));
1938         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
1939     }
1940 }
1941 
1942 
1943 // File contracts/Escrow.sol
1944 
1945 //SPDX-License-Identifier: Unlicense
1946 pragma solidity ^0.8.0;
1947 
1948 
1949 
1950 
1951 
1952 
1953 
1954 contract Escrow is Ownable {
1955   using SafeMath for uint256;
1956   address public immutable WETH;
1957 
1958   mapping(address => uint256) private _balances;
1959 
1960   mapping(address => address) public spenderToOwner;
1961 
1962   mapping(address => address) public ownerToSpender;
1963 
1964   address public router;
1965 
1966   event RouterChanged(address _router);
1967 
1968   event SpenderUpdated(address _spender);
1969 
1970   event Deposit(address _from, uint256 _amount);
1971 
1972   event Withdraw(address _from, address _to, uint256 _amount);
1973 
1974   event WithdrawDustToken(address _token, address _to, uint256 _amount);
1975 
1976   event WithdrawDustETH(address _to, uint256 _amount);
1977 
1978   constructor(address _WETH) {
1979     WETH = _WETH;
1980   }
1981 
1982   function setSpender(address _spender) external {
1983     address owner = msg.sender;
1984     address previousSpender = ownerToSpender[owner];
1985     require(previousSpender != _spender);
1986     spenderToOwner[previousSpender] = address(0);
1987 
1988     ownerToSpender[owner] = _spender;
1989     spenderToOwner[_spender] = owner;
1990 
1991     emit SpenderUpdated(_spender);
1992   }
1993 
1994   function setRouter(address _router) external onlyOwner {
1995     router = _router;
1996     emit RouterChanged(_router);
1997   }
1998 
1999   function buy(address _token, address[] calldata _recipients, uint256[] calldata _amountIns, uint256[] calldata _maxOuts) external{
2000     require(_recipients.length == _amountIns.length && _maxOuts.length == _amountIns.length, "Invalid parameters");
2001 
2002     address spender = msg.sender;
2003     address owner = spenderToOwner[spender];
2004 
2005     uint256 totalAmount;
2006     for (uint256 i; i < _amountIns.length; ++i) {
2007       totalAmount = totalAmount.add(_amountIns[i]);
2008     }
2009 
2010     require(_balances[owner] >= totalAmount, "Insufficient amount");
2011     
2012     IWETH(WETH).approve(router, totalAmount);
2013     uint256 amountSpent = IRouter(router).buy(_token, _recipients, _amountIns, _maxOuts);
2014 
2015     _balances[owner] = _balances[owner].sub(amountSpent);
2016   }
2017 
2018   function sell(address _token, address[] calldata _sellers, uint256[] calldata _amountIns, bool _isPercent) external {
2019     require(_sellers.length == _amountIns.length, "Invalid parameters");
2020     
2021     address spender = msg.sender;
2022     address owner = spenderToOwner[spender];
2023 
2024     uint256 amountReceived = IRouter(router).sell(_token, _sellers, _amountIns, _isPercent);
2025     _balances[owner] = _balances[owner].add(amountReceived);
2026   }
2027 
2028   function balanceOf(address _owner) external view returns (uint256) {
2029     return _balances[_owner];
2030   }
2031 
2032   function deposit() external payable {
2033     uint256 amount = msg.value;
2034     address sender = msg.sender;
2035     IWETH(WETH).deposit{value: amount}();
2036     _balances[sender] = _balances[sender].add(amount);
2037     emit Deposit(sender, amount);
2038   }
2039 
2040   function withdraw(address _to, uint256 _amount) external {
2041     address sender = msg.sender;
2042     require(_amount <= _balances[sender], "Insufficient withdraw amount");
2043     IWETH(WETH).withdraw(_amount);
2044     _balances[sender] = _balances[sender].sub(_amount);
2045     TransferHelper.safeTransferETH(_to, _amount);
2046     emit Withdraw(sender, _to, _amount);
2047   }
2048 
2049   function multiWithdrawETH(address[] calldata _recipients, uint256[] calldata _amounts, uint256 _totalAmount) external {
2050     address sender = msg.sender;
2051     require(_recipients.length == _amounts.length, "Invalid parameters");
2052 
2053     IWETH(WETH).withdraw(_totalAmount);
2054 
2055     uint256 totalAmount;
2056     for (uint256 i; i < _recipients.length; ++i) {
2057       (bool success, ) = _recipients[i].call{ value: _amounts[i]}("");
2058       require(success, "Address: unable to send value, recipient may have reverted");
2059       totalAmount = totalAmount.add(_amounts[i]);
2060     }
2061 
2062     require(totalAmount == _totalAmount, 'Invalid parameters');
2063     require(totalAmount <= _balances[sender], 'Insufficient amount');
2064     
2065     _balances[sender] = _balances[sender].sub(totalAmount);
2066   }
2067 
2068   function multiSendETH(address[] calldata _recipients, uint256[] calldata _amounts) external payable {
2069     require(_recipients.length == _amounts.length, "Invalid parameters");
2070 
2071     uint256 totalAmount;
2072     for (uint256 i; i < _recipients.length; ++i) {
2073       (bool success, ) = _recipients[i].call{ value: _amounts[i]}("");
2074       require(success, "Address: unable to send value, recipient may have reverted");
2075       totalAmount = totalAmount.add(_amounts[i]);
2076     }
2077 
2078     require(totalAmount <= msg.value, 'Insufficient amount');
2079   }
2080 
2081   // To receive ETH from uniswapV2Router when swapping
2082   receive() external payable {}
2083 
2084   // Withdraw dust tokens
2085   function withdrawDustToken(address _token, address _to)
2086     external
2087     onlyOwner
2088     returns (bool _sent)
2089   {
2090       require(_token != WETH, "Can't withdraw WETH");
2091       uint256 _amount = IERC20(_token).balanceOf(address(this));
2092       _sent = IERC20(_token).transfer(_to, _amount);
2093       emit WithdrawDustToken(_token, _to, _amount);
2094   }
2095 
2096   // Withdraw Dust ETH
2097   function withdrawDustETH(address _to) external onlyOwner {
2098     uint256 _amount = address(this).balance;
2099     (bool success, ) = _to.call{ value: _amount}("");
2100     require(success, "Address: unable to send value, recipient may have reverted");
2101     emit WithdrawDustETH(_to, _amount);
2102   }
2103 }