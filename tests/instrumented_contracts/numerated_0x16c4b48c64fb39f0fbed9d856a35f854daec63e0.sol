1 // File: hardhat/console.sol
2 
3 
4 pragma solidity >= 0.4.22 <0.9.0;
5 
6 library console {
7 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
8 
9 	function _sendLogPayload(bytes memory payload) private view {
10 		uint256 payloadLength = payload.length;
11 		address consoleAddress = CONSOLE_ADDRESS;
12 		assembly {
13 			let payloadStart := add(payload, 32)
14 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
15 		}
16 	}
17 
18 	function log() internal view {
19 		_sendLogPayload(abi.encodeWithSignature("log()"));
20 	}
21 
22 	function logInt(int p0) internal view {
23 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
24 	}
25 
26 	function logUint(uint p0) internal view {
27 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
28 	}
29 
30 	function logString(string memory p0) internal view {
31 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
32 	}
33 
34 	function logBool(bool p0) internal view {
35 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
36 	}
37 
38 	function logAddress(address p0) internal view {
39 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
40 	}
41 
42 	function logBytes(bytes memory p0) internal view {
43 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
44 	}
45 
46 	function logBytes1(bytes1 p0) internal view {
47 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
48 	}
49 
50 	function logBytes2(bytes2 p0) internal view {
51 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
52 	}
53 
54 	function logBytes3(bytes3 p0) internal view {
55 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
56 	}
57 
58 	function logBytes4(bytes4 p0) internal view {
59 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
60 	}
61 
62 	function logBytes5(bytes5 p0) internal view {
63 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
64 	}
65 
66 	function logBytes6(bytes6 p0) internal view {
67 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
68 	}
69 
70 	function logBytes7(bytes7 p0) internal view {
71 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
72 	}
73 
74 	function logBytes8(bytes8 p0) internal view {
75 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
76 	}
77 
78 	function logBytes9(bytes9 p0) internal view {
79 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
80 	}
81 
82 	function logBytes10(bytes10 p0) internal view {
83 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
84 	}
85 
86 	function logBytes11(bytes11 p0) internal view {
87 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
88 	}
89 
90 	function logBytes12(bytes12 p0) internal view {
91 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
92 	}
93 
94 	function logBytes13(bytes13 p0) internal view {
95 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
96 	}
97 
98 	function logBytes14(bytes14 p0) internal view {
99 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
100 	}
101 
102 	function logBytes15(bytes15 p0) internal view {
103 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
104 	}
105 
106 	function logBytes16(bytes16 p0) internal view {
107 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
108 	}
109 
110 	function logBytes17(bytes17 p0) internal view {
111 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
112 	}
113 
114 	function logBytes18(bytes18 p0) internal view {
115 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
116 	}
117 
118 	function logBytes19(bytes19 p0) internal view {
119 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
120 	}
121 
122 	function logBytes20(bytes20 p0) internal view {
123 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
124 	}
125 
126 	function logBytes21(bytes21 p0) internal view {
127 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
128 	}
129 
130 	function logBytes22(bytes22 p0) internal view {
131 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
132 	}
133 
134 	function logBytes23(bytes23 p0) internal view {
135 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
136 	}
137 
138 	function logBytes24(bytes24 p0) internal view {
139 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
140 	}
141 
142 	function logBytes25(bytes25 p0) internal view {
143 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
144 	}
145 
146 	function logBytes26(bytes26 p0) internal view {
147 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
148 	}
149 
150 	function logBytes27(bytes27 p0) internal view {
151 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
152 	}
153 
154 	function logBytes28(bytes28 p0) internal view {
155 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
156 	}
157 
158 	function logBytes29(bytes29 p0) internal view {
159 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
160 	}
161 
162 	function logBytes30(bytes30 p0) internal view {
163 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
164 	}
165 
166 	function logBytes31(bytes31 p0) internal view {
167 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
168 	}
169 
170 	function logBytes32(bytes32 p0) internal view {
171 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
172 	}
173 
174 	function log(uint p0) internal view {
175 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
176 	}
177 
178 	function log(string memory p0) internal view {
179 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
180 	}
181 
182 	function log(bool p0) internal view {
183 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
184 	}
185 
186 	function log(address p0) internal view {
187 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
188 	}
189 
190 	function log(uint p0, uint p1) internal view {
191 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
192 	}
193 
194 	function log(uint p0, string memory p1) internal view {
195 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
196 	}
197 
198 	function log(uint p0, bool p1) internal view {
199 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
200 	}
201 
202 	function log(uint p0, address p1) internal view {
203 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
204 	}
205 
206 	function log(string memory p0, uint p1) internal view {
207 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
208 	}
209 
210 	function log(string memory p0, string memory p1) internal view {
211 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
212 	}
213 
214 	function log(string memory p0, bool p1) internal view {
215 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
216 	}
217 
218 	function log(string memory p0, address p1) internal view {
219 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
220 	}
221 
222 	function log(bool p0, uint p1) internal view {
223 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
224 	}
225 
226 	function log(bool p0, string memory p1) internal view {
227 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
228 	}
229 
230 	function log(bool p0, bool p1) internal view {
231 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
232 	}
233 
234 	function log(bool p0, address p1) internal view {
235 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
236 	}
237 
238 	function log(address p0, uint p1) internal view {
239 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
240 	}
241 
242 	function log(address p0, string memory p1) internal view {
243 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
244 	}
245 
246 	function log(address p0, bool p1) internal view {
247 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
248 	}
249 
250 	function log(address p0, address p1) internal view {
251 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
252 	}
253 
254 	function log(uint p0, uint p1, uint p2) internal view {
255 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
256 	}
257 
258 	function log(uint p0, uint p1, string memory p2) internal view {
259 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
260 	}
261 
262 	function log(uint p0, uint p1, bool p2) internal view {
263 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
264 	}
265 
266 	function log(uint p0, uint p1, address p2) internal view {
267 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
268 	}
269 
270 	function log(uint p0, string memory p1, uint p2) internal view {
271 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
272 	}
273 
274 	function log(uint p0, string memory p1, string memory p2) internal view {
275 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
276 	}
277 
278 	function log(uint p0, string memory p1, bool p2) internal view {
279 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
280 	}
281 
282 	function log(uint p0, string memory p1, address p2) internal view {
283 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
284 	}
285 
286 	function log(uint p0, bool p1, uint p2) internal view {
287 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
288 	}
289 
290 	function log(uint p0, bool p1, string memory p2) internal view {
291 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
292 	}
293 
294 	function log(uint p0, bool p1, bool p2) internal view {
295 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
296 	}
297 
298 	function log(uint p0, bool p1, address p2) internal view {
299 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
300 	}
301 
302 	function log(uint p0, address p1, uint p2) internal view {
303 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
304 	}
305 
306 	function log(uint p0, address p1, string memory p2) internal view {
307 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
308 	}
309 
310 	function log(uint p0, address p1, bool p2) internal view {
311 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
312 	}
313 
314 	function log(uint p0, address p1, address p2) internal view {
315 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
316 	}
317 
318 	function log(string memory p0, uint p1, uint p2) internal view {
319 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
320 	}
321 
322 	function log(string memory p0, uint p1, string memory p2) internal view {
323 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
324 	}
325 
326 	function log(string memory p0, uint p1, bool p2) internal view {
327 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
328 	}
329 
330 	function log(string memory p0, uint p1, address p2) internal view {
331 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
332 	}
333 
334 	function log(string memory p0, string memory p1, uint p2) internal view {
335 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
336 	}
337 
338 	function log(string memory p0, string memory p1, string memory p2) internal view {
339 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
340 	}
341 
342 	function log(string memory p0, string memory p1, bool p2) internal view {
343 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
344 	}
345 
346 	function log(string memory p0, string memory p1, address p2) internal view {
347 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
348 	}
349 
350 	function log(string memory p0, bool p1, uint p2) internal view {
351 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
352 	}
353 
354 	function log(string memory p0, bool p1, string memory p2) internal view {
355 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
356 	}
357 
358 	function log(string memory p0, bool p1, bool p2) internal view {
359 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
360 	}
361 
362 	function log(string memory p0, bool p1, address p2) internal view {
363 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
364 	}
365 
366 	function log(string memory p0, address p1, uint p2) internal view {
367 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
368 	}
369 
370 	function log(string memory p0, address p1, string memory p2) internal view {
371 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
372 	}
373 
374 	function log(string memory p0, address p1, bool p2) internal view {
375 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
376 	}
377 
378 	function log(string memory p0, address p1, address p2) internal view {
379 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
380 	}
381 
382 	function log(bool p0, uint p1, uint p2) internal view {
383 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
384 	}
385 
386 	function log(bool p0, uint p1, string memory p2) internal view {
387 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
388 	}
389 
390 	function log(bool p0, uint p1, bool p2) internal view {
391 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
392 	}
393 
394 	function log(bool p0, uint p1, address p2) internal view {
395 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
396 	}
397 
398 	function log(bool p0, string memory p1, uint p2) internal view {
399 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
400 	}
401 
402 	function log(bool p0, string memory p1, string memory p2) internal view {
403 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
404 	}
405 
406 	function log(bool p0, string memory p1, bool p2) internal view {
407 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
408 	}
409 
410 	function log(bool p0, string memory p1, address p2) internal view {
411 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
412 	}
413 
414 	function log(bool p0, bool p1, uint p2) internal view {
415 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
416 	}
417 
418 	function log(bool p0, bool p1, string memory p2) internal view {
419 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
420 	}
421 
422 	function log(bool p0, bool p1, bool p2) internal view {
423 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
424 	}
425 
426 	function log(bool p0, bool p1, address p2) internal view {
427 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
428 	}
429 
430 	function log(bool p0, address p1, uint p2) internal view {
431 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
432 	}
433 
434 	function log(bool p0, address p1, string memory p2) internal view {
435 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
436 	}
437 
438 	function log(bool p0, address p1, bool p2) internal view {
439 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
440 	}
441 
442 	function log(bool p0, address p1, address p2) internal view {
443 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
444 	}
445 
446 	function log(address p0, uint p1, uint p2) internal view {
447 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
448 	}
449 
450 	function log(address p0, uint p1, string memory p2) internal view {
451 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
452 	}
453 
454 	function log(address p0, uint p1, bool p2) internal view {
455 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
456 	}
457 
458 	function log(address p0, uint p1, address p2) internal view {
459 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
460 	}
461 
462 	function log(address p0, string memory p1, uint p2) internal view {
463 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
464 	}
465 
466 	function log(address p0, string memory p1, string memory p2) internal view {
467 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
468 	}
469 
470 	function log(address p0, string memory p1, bool p2) internal view {
471 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
472 	}
473 
474 	function log(address p0, string memory p1, address p2) internal view {
475 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
476 	}
477 
478 	function log(address p0, bool p1, uint p2) internal view {
479 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
480 	}
481 
482 	function log(address p0, bool p1, string memory p2) internal view {
483 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
484 	}
485 
486 	function log(address p0, bool p1, bool p2) internal view {
487 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
488 	}
489 
490 	function log(address p0, bool p1, address p2) internal view {
491 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
492 	}
493 
494 	function log(address p0, address p1, uint p2) internal view {
495 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
496 	}
497 
498 	function log(address p0, address p1, string memory p2) internal view {
499 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
500 	}
501 
502 	function log(address p0, address p1, bool p2) internal view {
503 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
504 	}
505 
506 	function log(address p0, address p1, address p2) internal view {
507 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
508 	}
509 
510 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
511 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
512 	}
513 
514 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
515 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
516 	}
517 
518 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
519 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
520 	}
521 
522 	function log(uint p0, uint p1, uint p2, address p3) internal view {
523 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
524 	}
525 
526 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
527 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
528 	}
529 
530 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
531 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
532 	}
533 
534 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
535 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
536 	}
537 
538 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
539 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
540 	}
541 
542 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
543 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
544 	}
545 
546 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
547 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
548 	}
549 
550 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
551 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
552 	}
553 
554 	function log(uint p0, uint p1, bool p2, address p3) internal view {
555 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
556 	}
557 
558 	function log(uint p0, uint p1, address p2, uint p3) internal view {
559 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
560 	}
561 
562 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
563 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
564 	}
565 
566 	function log(uint p0, uint p1, address p2, bool p3) internal view {
567 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
568 	}
569 
570 	function log(uint p0, uint p1, address p2, address p3) internal view {
571 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
572 	}
573 
574 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
575 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
576 	}
577 
578 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
579 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
580 	}
581 
582 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
583 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
584 	}
585 
586 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
587 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
588 	}
589 
590 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
591 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
592 	}
593 
594 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
595 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
596 	}
597 
598 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
599 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
600 	}
601 
602 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
603 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
604 	}
605 
606 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
607 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
608 	}
609 
610 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
611 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
612 	}
613 
614 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
615 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
616 	}
617 
618 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
619 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
620 	}
621 
622 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
623 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
624 	}
625 
626 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
627 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
628 	}
629 
630 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
631 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
632 	}
633 
634 	function log(uint p0, string memory p1, address p2, address p3) internal view {
635 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
636 	}
637 
638 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
639 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
640 	}
641 
642 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
643 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
644 	}
645 
646 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
647 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
648 	}
649 
650 	function log(uint p0, bool p1, uint p2, address p3) internal view {
651 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
652 	}
653 
654 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
655 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
656 	}
657 
658 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
659 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
660 	}
661 
662 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
663 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
664 	}
665 
666 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
667 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
668 	}
669 
670 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
671 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
672 	}
673 
674 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
675 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
676 	}
677 
678 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
679 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
680 	}
681 
682 	function log(uint p0, bool p1, bool p2, address p3) internal view {
683 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
684 	}
685 
686 	function log(uint p0, bool p1, address p2, uint p3) internal view {
687 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
688 	}
689 
690 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
691 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
692 	}
693 
694 	function log(uint p0, bool p1, address p2, bool p3) internal view {
695 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
696 	}
697 
698 	function log(uint p0, bool p1, address p2, address p3) internal view {
699 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
700 	}
701 
702 	function log(uint p0, address p1, uint p2, uint p3) internal view {
703 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
704 	}
705 
706 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
707 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
708 	}
709 
710 	function log(uint p0, address p1, uint p2, bool p3) internal view {
711 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
712 	}
713 
714 	function log(uint p0, address p1, uint p2, address p3) internal view {
715 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
716 	}
717 
718 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
719 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
720 	}
721 
722 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
723 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
724 	}
725 
726 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
727 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
728 	}
729 
730 	function log(uint p0, address p1, string memory p2, address p3) internal view {
731 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
732 	}
733 
734 	function log(uint p0, address p1, bool p2, uint p3) internal view {
735 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
736 	}
737 
738 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
739 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
740 	}
741 
742 	function log(uint p0, address p1, bool p2, bool p3) internal view {
743 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
744 	}
745 
746 	function log(uint p0, address p1, bool p2, address p3) internal view {
747 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
748 	}
749 
750 	function log(uint p0, address p1, address p2, uint p3) internal view {
751 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
752 	}
753 
754 	function log(uint p0, address p1, address p2, string memory p3) internal view {
755 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
756 	}
757 
758 	function log(uint p0, address p1, address p2, bool p3) internal view {
759 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
760 	}
761 
762 	function log(uint p0, address p1, address p2, address p3) internal view {
763 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
764 	}
765 
766 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
767 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
768 	}
769 
770 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
771 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
772 	}
773 
774 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
775 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
776 	}
777 
778 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
779 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
780 	}
781 
782 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
783 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
784 	}
785 
786 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
787 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
788 	}
789 
790 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
791 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
792 	}
793 
794 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
795 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
796 	}
797 
798 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
799 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
800 	}
801 
802 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
803 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
804 	}
805 
806 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
807 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
808 	}
809 
810 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
811 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
812 	}
813 
814 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
815 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
816 	}
817 
818 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
819 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
820 	}
821 
822 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
823 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
824 	}
825 
826 	function log(string memory p0, uint p1, address p2, address p3) internal view {
827 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
828 	}
829 
830 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
831 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
832 	}
833 
834 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
835 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
836 	}
837 
838 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
839 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
840 	}
841 
842 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
843 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
844 	}
845 
846 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
847 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
848 	}
849 
850 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
851 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
852 	}
853 
854 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
855 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
856 	}
857 
858 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
859 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
860 	}
861 
862 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
863 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
864 	}
865 
866 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
867 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
868 	}
869 
870 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
871 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
872 	}
873 
874 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
875 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
876 	}
877 
878 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
879 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
880 	}
881 
882 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
883 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
884 	}
885 
886 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
887 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
888 	}
889 
890 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
891 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
892 	}
893 
894 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
895 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
896 	}
897 
898 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
899 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
900 	}
901 
902 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
903 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
904 	}
905 
906 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
907 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
908 	}
909 
910 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
911 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
912 	}
913 
914 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
915 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
916 	}
917 
918 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
919 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
920 	}
921 
922 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
923 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
924 	}
925 
926 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
927 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
928 	}
929 
930 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
931 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
932 	}
933 
934 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
935 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
936 	}
937 
938 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
939 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
940 	}
941 
942 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
943 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
944 	}
945 
946 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
947 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
948 	}
949 
950 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
951 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
952 	}
953 
954 	function log(string memory p0, bool p1, address p2, address p3) internal view {
955 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
956 	}
957 
958 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
959 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
960 	}
961 
962 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
963 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
964 	}
965 
966 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
967 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
968 	}
969 
970 	function log(string memory p0, address p1, uint p2, address p3) internal view {
971 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
972 	}
973 
974 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
975 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
976 	}
977 
978 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
979 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
980 	}
981 
982 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
983 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
984 	}
985 
986 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
987 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
988 	}
989 
990 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
991 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
992 	}
993 
994 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
995 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
996 	}
997 
998 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
999 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
1000 	}
1001 
1002 	function log(string memory p0, address p1, bool p2, address p3) internal view {
1003 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
1004 	}
1005 
1006 	function log(string memory p0, address p1, address p2, uint p3) internal view {
1007 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
1008 	}
1009 
1010 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
1011 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
1012 	}
1013 
1014 	function log(string memory p0, address p1, address p2, bool p3) internal view {
1015 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
1016 	}
1017 
1018 	function log(string memory p0, address p1, address p2, address p3) internal view {
1019 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
1020 	}
1021 
1022 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
1023 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
1024 	}
1025 
1026 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
1027 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
1028 	}
1029 
1030 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
1031 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
1032 	}
1033 
1034 	function log(bool p0, uint p1, uint p2, address p3) internal view {
1035 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
1036 	}
1037 
1038 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
1039 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
1040 	}
1041 
1042 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
1043 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
1044 	}
1045 
1046 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
1047 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
1048 	}
1049 
1050 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
1051 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
1052 	}
1053 
1054 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
1055 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
1056 	}
1057 
1058 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
1059 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
1060 	}
1061 
1062 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
1063 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
1064 	}
1065 
1066 	function log(bool p0, uint p1, bool p2, address p3) internal view {
1067 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
1068 	}
1069 
1070 	function log(bool p0, uint p1, address p2, uint p3) internal view {
1071 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
1072 	}
1073 
1074 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
1075 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
1076 	}
1077 
1078 	function log(bool p0, uint p1, address p2, bool p3) internal view {
1079 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
1080 	}
1081 
1082 	function log(bool p0, uint p1, address p2, address p3) internal view {
1083 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
1084 	}
1085 
1086 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
1087 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
1088 	}
1089 
1090 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
1091 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
1092 	}
1093 
1094 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
1095 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
1096 	}
1097 
1098 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
1099 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
1100 	}
1101 
1102 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
1103 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
1104 	}
1105 
1106 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
1107 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
1108 	}
1109 
1110 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
1111 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
1112 	}
1113 
1114 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
1115 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
1116 	}
1117 
1118 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
1119 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
1120 	}
1121 
1122 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
1123 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
1124 	}
1125 
1126 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
1127 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
1128 	}
1129 
1130 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
1131 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
1132 	}
1133 
1134 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
1135 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
1136 	}
1137 
1138 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
1139 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
1140 	}
1141 
1142 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
1143 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
1144 	}
1145 
1146 	function log(bool p0, string memory p1, address p2, address p3) internal view {
1147 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
1148 	}
1149 
1150 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
1151 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
1152 	}
1153 
1154 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
1155 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
1156 	}
1157 
1158 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
1159 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
1160 	}
1161 
1162 	function log(bool p0, bool p1, uint p2, address p3) internal view {
1163 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
1164 	}
1165 
1166 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
1167 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
1168 	}
1169 
1170 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
1171 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
1172 	}
1173 
1174 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
1175 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
1176 	}
1177 
1178 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
1179 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
1180 	}
1181 
1182 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
1183 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
1184 	}
1185 
1186 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
1187 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
1188 	}
1189 
1190 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
1191 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
1192 	}
1193 
1194 	function log(bool p0, bool p1, bool p2, address p3) internal view {
1195 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
1196 	}
1197 
1198 	function log(bool p0, bool p1, address p2, uint p3) internal view {
1199 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
1200 	}
1201 
1202 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
1203 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
1204 	}
1205 
1206 	function log(bool p0, bool p1, address p2, bool p3) internal view {
1207 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
1208 	}
1209 
1210 	function log(bool p0, bool p1, address p2, address p3) internal view {
1211 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
1212 	}
1213 
1214 	function log(bool p0, address p1, uint p2, uint p3) internal view {
1215 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
1216 	}
1217 
1218 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
1219 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
1220 	}
1221 
1222 	function log(bool p0, address p1, uint p2, bool p3) internal view {
1223 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
1224 	}
1225 
1226 	function log(bool p0, address p1, uint p2, address p3) internal view {
1227 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
1228 	}
1229 
1230 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
1231 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
1232 	}
1233 
1234 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
1235 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
1236 	}
1237 
1238 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
1239 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
1240 	}
1241 
1242 	function log(bool p0, address p1, string memory p2, address p3) internal view {
1243 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
1244 	}
1245 
1246 	function log(bool p0, address p1, bool p2, uint p3) internal view {
1247 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
1248 	}
1249 
1250 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
1251 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
1252 	}
1253 
1254 	function log(bool p0, address p1, bool p2, bool p3) internal view {
1255 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
1256 	}
1257 
1258 	function log(bool p0, address p1, bool p2, address p3) internal view {
1259 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
1260 	}
1261 
1262 	function log(bool p0, address p1, address p2, uint p3) internal view {
1263 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
1264 	}
1265 
1266 	function log(bool p0, address p1, address p2, string memory p3) internal view {
1267 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
1268 	}
1269 
1270 	function log(bool p0, address p1, address p2, bool p3) internal view {
1271 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
1272 	}
1273 
1274 	function log(bool p0, address p1, address p2, address p3) internal view {
1275 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
1276 	}
1277 
1278 	function log(address p0, uint p1, uint p2, uint p3) internal view {
1279 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
1280 	}
1281 
1282 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
1283 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
1284 	}
1285 
1286 	function log(address p0, uint p1, uint p2, bool p3) internal view {
1287 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
1288 	}
1289 
1290 	function log(address p0, uint p1, uint p2, address p3) internal view {
1291 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
1292 	}
1293 
1294 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
1295 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
1296 	}
1297 
1298 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
1299 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
1300 	}
1301 
1302 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
1303 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
1304 	}
1305 
1306 	function log(address p0, uint p1, string memory p2, address p3) internal view {
1307 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
1308 	}
1309 
1310 	function log(address p0, uint p1, bool p2, uint p3) internal view {
1311 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
1312 	}
1313 
1314 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
1315 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
1316 	}
1317 
1318 	function log(address p0, uint p1, bool p2, bool p3) internal view {
1319 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
1320 	}
1321 
1322 	function log(address p0, uint p1, bool p2, address p3) internal view {
1323 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
1324 	}
1325 
1326 	function log(address p0, uint p1, address p2, uint p3) internal view {
1327 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
1328 	}
1329 
1330 	function log(address p0, uint p1, address p2, string memory p3) internal view {
1331 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
1332 	}
1333 
1334 	function log(address p0, uint p1, address p2, bool p3) internal view {
1335 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
1336 	}
1337 
1338 	function log(address p0, uint p1, address p2, address p3) internal view {
1339 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
1340 	}
1341 
1342 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
1343 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
1344 	}
1345 
1346 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
1347 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
1348 	}
1349 
1350 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
1351 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
1352 	}
1353 
1354 	function log(address p0, string memory p1, uint p2, address p3) internal view {
1355 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
1356 	}
1357 
1358 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
1359 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
1360 	}
1361 
1362 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
1363 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
1364 	}
1365 
1366 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
1367 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
1368 	}
1369 
1370 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
1371 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
1372 	}
1373 
1374 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
1375 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
1376 	}
1377 
1378 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
1379 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
1380 	}
1381 
1382 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
1383 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
1384 	}
1385 
1386 	function log(address p0, string memory p1, bool p2, address p3) internal view {
1387 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
1388 	}
1389 
1390 	function log(address p0, string memory p1, address p2, uint p3) internal view {
1391 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
1392 	}
1393 
1394 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
1395 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
1396 	}
1397 
1398 	function log(address p0, string memory p1, address p2, bool p3) internal view {
1399 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
1400 	}
1401 
1402 	function log(address p0, string memory p1, address p2, address p3) internal view {
1403 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
1404 	}
1405 
1406 	function log(address p0, bool p1, uint p2, uint p3) internal view {
1407 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
1408 	}
1409 
1410 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
1411 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
1412 	}
1413 
1414 	function log(address p0, bool p1, uint p2, bool p3) internal view {
1415 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
1416 	}
1417 
1418 	function log(address p0, bool p1, uint p2, address p3) internal view {
1419 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
1420 	}
1421 
1422 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
1423 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
1424 	}
1425 
1426 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
1427 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
1428 	}
1429 
1430 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
1431 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
1432 	}
1433 
1434 	function log(address p0, bool p1, string memory p2, address p3) internal view {
1435 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
1436 	}
1437 
1438 	function log(address p0, bool p1, bool p2, uint p3) internal view {
1439 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
1440 	}
1441 
1442 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
1443 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
1444 	}
1445 
1446 	function log(address p0, bool p1, bool p2, bool p3) internal view {
1447 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
1448 	}
1449 
1450 	function log(address p0, bool p1, bool p2, address p3) internal view {
1451 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
1452 	}
1453 
1454 	function log(address p0, bool p1, address p2, uint p3) internal view {
1455 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
1456 	}
1457 
1458 	function log(address p0, bool p1, address p2, string memory p3) internal view {
1459 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
1460 	}
1461 
1462 	function log(address p0, bool p1, address p2, bool p3) internal view {
1463 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
1464 	}
1465 
1466 	function log(address p0, bool p1, address p2, address p3) internal view {
1467 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
1468 	}
1469 
1470 	function log(address p0, address p1, uint p2, uint p3) internal view {
1471 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
1472 	}
1473 
1474 	function log(address p0, address p1, uint p2, string memory p3) internal view {
1475 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
1476 	}
1477 
1478 	function log(address p0, address p1, uint p2, bool p3) internal view {
1479 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
1480 	}
1481 
1482 	function log(address p0, address p1, uint p2, address p3) internal view {
1483 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
1484 	}
1485 
1486 	function log(address p0, address p1, string memory p2, uint p3) internal view {
1487 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
1488 	}
1489 
1490 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
1491 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
1492 	}
1493 
1494 	function log(address p0, address p1, string memory p2, bool p3) internal view {
1495 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
1496 	}
1497 
1498 	function log(address p0, address p1, string memory p2, address p3) internal view {
1499 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
1500 	}
1501 
1502 	function log(address p0, address p1, bool p2, uint p3) internal view {
1503 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
1504 	}
1505 
1506 	function log(address p0, address p1, bool p2, string memory p3) internal view {
1507 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
1508 	}
1509 
1510 	function log(address p0, address p1, bool p2, bool p3) internal view {
1511 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
1512 	}
1513 
1514 	function log(address p0, address p1, bool p2, address p3) internal view {
1515 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
1516 	}
1517 
1518 	function log(address p0, address p1, address p2, uint p3) internal view {
1519 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
1520 	}
1521 
1522 	function log(address p0, address p1, address p2, string memory p3) internal view {
1523 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
1524 	}
1525 
1526 	function log(address p0, address p1, address p2, bool p3) internal view {
1527 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
1528 	}
1529 
1530 	function log(address p0, address p1, address p2, address p3) internal view {
1531 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
1532 	}
1533 
1534 }
1535 
1536 // File: contracts/mainnetTesting/IERC20.sol
1537 
1538 pragma solidity ^0.8.0;
1539 
1540 /**
1541  * @dev Interface of the ERC20 standard as defined in the EIP.
1542  */
1543 interface IERC20 {
1544     /**
1545      * @dev Returns the amount of tokens in existence.
1546      */
1547     function totalSupply() external view returns (uint256);
1548 
1549     /**
1550      * @dev Returns the amount of tokens owned by `account`.
1551      */
1552     function balanceOf(address account) external view returns (uint256);
1553 
1554     /**
1555      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1556      *
1557      * Returns a boolean value indicating whether the operation succeeded.
1558      *
1559      * Emits a {Transfer} event.
1560      */
1561     function transfer(address recipient, uint256 amount) external returns (bool);
1562 
1563     /**
1564      * @dev Returns the remaining number of tokens that `spender` will be
1565      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1566      * zero by default.
1567      *
1568      * This value changes when {approve} or {transferFrom} are called.
1569      */
1570     function allowance(address owner, address spender) external view returns (uint256);
1571 
1572     /**
1573      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1574      *
1575      * Returns a boolean value indicating whether the operation succeeded.
1576      *
1577      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1578      * that someone may use both the old and the new allowance by unfortunate
1579      * transaction ordering. One possible solution to mitigate this race
1580      * condition is to first reduce the spender's allowance to 0 and set the
1581      * desired value afterwards:
1582      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1583      *
1584      * Emits an {Approval} event.
1585      */
1586     function approve(address spender, uint256 amount) external returns (bool);
1587 
1588     /**
1589      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1590      * allowance mechanism. `amount` is then deducted from the caller's
1591      * allowance.
1592      *
1593      * Returns a boolean value indicating whether the operation succeeded.
1594      *
1595      * Emits a {Transfer} event.
1596      */
1597     function transferFrom(
1598         address sender,
1599         address recipient,
1600         uint256 amount
1601     ) external returns (bool);
1602 
1603     /**
1604      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1605      * another (`to`).
1606      *
1607      * Note that `value` may be zero.
1608      */
1609     event Transfer(address indexed from, address indexed to, uint256 value);
1610 
1611     /**
1612      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1613      * a call to {approve}. `value` is the new allowance.
1614      */
1615     event Approval(address indexed owner, address indexed spender, uint256 value);
1616 }
1617 // File: contracts/mainnetTesting/IERC20Metadata.sol
1618 
1619 pragma solidity ^0.8.0;
1620 
1621 
1622 
1623 interface IERC20Metadata is IERC20 {
1624     /**
1625      * @dev Returns the name of the token.
1626      */
1627     function name() external view returns (string memory);
1628 
1629     /**
1630      * @dev Returns the symbol of the token.
1631      */
1632     function symbol() external view returns (string memory);
1633 
1634     /**
1635      * @dev Returns the decimals places of the token.
1636      */
1637     function decimals() external view returns (uint8);
1638 }
1639 // File: contracts/mainnetTesting/Context.sol
1640 
1641 pragma solidity ^0.8.0;
1642 
1643 /**
1644  * @dev Provides information about the current execution context, including the
1645  * sender of the transaction and its data. While these are generally available
1646  * via msg.sender and msg.data, they should not be accessed in such a direct
1647  * manner, since when dealing with meta-transactions the account sending and
1648  * paying for execution may not be the actual sender (as far as an application
1649  * is concerned).
1650  *
1651  * This contract is only required for intermediate, library-like contracts.
1652  */
1653 abstract contract Context {
1654     function _msgSender() internal view virtual returns (address) {
1655         return msg.sender;
1656     }
1657 
1658     function _msgData() internal view virtual returns (bytes calldata) {
1659         return msg.data;
1660     }
1661 }
1662 // File: contracts/mainnetTesting/Ownable.sol
1663 
1664 pragma solidity ^0.8.0;
1665 
1666 
1667 /**
1668  * @dev Contract module which provides a basic access control mechanism, where
1669  * there is an account (an owner) that can be granted exclusive access to
1670  * specific functions.
1671  *
1672  * By default, the owner account will be the one that deploys the contract. This
1673  * can later be changed with {transferOwnership}.
1674  *
1675  * This module is used through inheritance. It will make available the modifier
1676  * `onlyOwner`, which can be applied to your functions to restrict their use to
1677  * the owner.
1678  */
1679 abstract contract Ownable is Context {
1680     address private _owner;
1681     event OwnershipTransferred(
1682         address indexed previousOwner,
1683         address indexed newOwner
1684     );
1685 
1686     /**
1687      * @dev Initializes the contract setting the deployer as the initial owner.
1688      */
1689     constructor() {
1690         _setOwner(_msgSender());
1691     }
1692 
1693     function initialize() public virtual {
1694         address msgSender = _msgSender();
1695         _setOwner(msgSender);
1696         emit OwnershipTransferred(address(0), msgSender);
1697     }
1698 
1699     /**
1700      * @dev Returns the address of the current owner.
1701      */
1702     function owner() public view virtual returns (address) {
1703         return _owner;
1704     }
1705 
1706     /**
1707      * @dev Throws if called by any account other than the owner.
1708      */
1709     modifier onlyOwner() {
1710         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1711         _;
1712     }
1713 
1714     /**
1715      * @dev Leaves the contract without owner. It will not be possible to call
1716      * `onlyOwner` functions anymore. Can only be called by the current owner.
1717      *
1718      * NOTE: Renouncing ownership will leave the contract without an owner,
1719      * thereby removing any functionality that is only available to the owner.
1720      */
1721     function renounceOwnership() public virtual onlyOwner {
1722         _setOwner(address(0));
1723     }
1724 
1725     /**
1726      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1727      * Can only be called by the current owner.
1728      */
1729     function transferOwnership(address newOwner) public virtual onlyOwner {
1730         require(
1731             newOwner != address(0),
1732             "Ownable: new owner is the zero address"
1733         );
1734         _setOwner(newOwner);
1735     }
1736 
1737     function _setOwner(address newOwner) private {
1738         address oldOwner = _owner;
1739         _owner = newOwner;
1740         emit OwnershipTransferred(oldOwner, newOwner);
1741     }
1742 }
1743 // File: contracts/mainnetTesting/ERC20.sol
1744 
1745 pragma solidity ^0.8.0;
1746 
1747 
1748 
1749 
1750 
1751 contract ERC20 is Context, IERC20, IERC20Metadata {
1752     mapping(address => uint256) private _balances;
1753 
1754     mapping(address => mapping(address => uint256)) private _allowances;
1755 
1756     uint256 private _totalSupply;
1757 
1758     string private _name;
1759     string private _symbol;
1760 
1761     /**
1762      * @dev Sets the values for {name} and {symbol}.
1763      *
1764      * The default value of {decimals} is 18. To select a different value for
1765      * {decimals} you should overload it.
1766      *
1767      * All two of these values are immutable: they can only be set once during
1768      * construction.
1769      */
1770     constructor(string memory name_, string memory symbol_) {
1771         _name = name_;
1772         _symbol = symbol_;
1773     }
1774 
1775     /**
1776      * @dev Returns the name of the token.
1777      */
1778     function name() public view virtual override returns (string memory) {
1779         return _name;
1780     }
1781 
1782     /**
1783      * @dev Returns the symbol of the token, usually a shorter version of the
1784      * name.
1785      */
1786     function symbol() public view virtual override returns (string memory) {
1787         return _symbol;
1788     }
1789 
1790     /**
1791      * @dev Returns the number of decimals used to get its user representation.
1792      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1793      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1794      *
1795      * Tokens usually opt for a value of 18, imitating the relationship between
1796      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1797      * overridden;
1798      *
1799      * NOTE: This information is only used for _display_ purposes: it in
1800      * no way affects any of the arithmetic of the contract, including
1801      * {IERC20-balanceOf} and {IERC20-transfer}.
1802      */
1803     function decimals() public view virtual override returns (uint8) {
1804         return 18;
1805     }
1806 
1807     /**
1808      * @dev See {IERC20-totalSupply}.
1809      */
1810     function totalSupply() public view virtual override returns (uint256) {
1811         return _totalSupply;
1812     }
1813 
1814     /**
1815      * @dev See {IERC20-balanceOf}.
1816      */
1817     function balanceOf(address account) public view virtual override returns (uint256) {
1818         return _balances[account];
1819     }
1820 
1821     /**
1822      * @dev See {IERC20-transfer}.
1823      *
1824      * Requirements:
1825      *
1826      * - `recipient` cannot be the zero address.
1827      * - the caller must have a balance of at least `amount`.
1828      */
1829     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1830         _transfer(_msgSender(), recipient, amount);
1831         return true;
1832     }
1833 
1834     /**
1835      * @dev See {IERC20-allowance}.
1836      */
1837     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1838         return _allowances[owner][spender];
1839     }
1840 
1841     /**
1842      * @dev See {IERC20-approve}.
1843      *
1844      * Requirements:
1845      *
1846      * - `spender` cannot be the zero address.
1847      */
1848     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1849         _approve(_msgSender(), spender, amount);
1850         return true;
1851     }
1852 
1853     /**
1854      * @dev See {IERC20-transferFrom}.
1855      *
1856      * Emits an {Approval} event indicating the updated allowance. This is not
1857      * required by the EIP. See the note at the beginning of {ERC20}.
1858      *
1859      * Requirements:
1860      *
1861      * - `sender` and `recipient` cannot be the zero address.
1862      * - `sender` must have a balance of at least `amount`.
1863      * - the caller must have allowance for ``sender``'s tokens of at least
1864      * `amount`.
1865      */
1866     function transferFrom(
1867         address sender,
1868         address recipient,
1869         uint256 amount
1870     ) public virtual override returns (bool) {
1871         _transfer(sender, recipient, amount);
1872 
1873         uint256 currentAllowance = _allowances[sender][_msgSender()];
1874         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
1875         unchecked {
1876             _approve(sender, _msgSender(), currentAllowance - amount);
1877         }
1878 
1879         return true;
1880     }
1881 
1882     /**
1883      * @dev Atomically increases the allowance granted to `spender` by the caller.
1884      *
1885      * This is an alternative to {approve} that can be used as a mitigation for
1886      * problems described in {IERC20-approve}.
1887      *
1888      * Emits an {Approval} event indicating the updated allowance.
1889      *
1890      * Requirements:
1891      *
1892      * - `spender` cannot be the zero address.
1893      */
1894     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1895         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
1896         return true;
1897     }
1898 
1899     /**
1900      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1901      *
1902      * This is an alternative to {approve} that can be used as a mitigation for
1903      * problems described in {IERC20-approve}.
1904      *
1905      * Emits an {Approval} event indicating the updated allowance.
1906      *
1907      * Requirements:
1908      *
1909      * - `spender` cannot be the zero address.
1910      * - `spender` must have allowance for the caller of at least
1911      * `subtractedValue`.
1912      */
1913     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1914         uint256 currentAllowance = _allowances[_msgSender()][spender];
1915         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1916         unchecked {
1917             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1918         }
1919 
1920         return true;
1921     }
1922 
1923     /**
1924      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1925      *
1926      * This internal function is equivalent to {transfer}, and can be used to
1927      * e.g. implement automatic token fees, slashing mechanisms, etc.
1928      *
1929      * Emits a {Transfer} event.
1930      *
1931      * Requirements:
1932      *
1933      * - `sender` cannot be the zero address.
1934      * - `recipient` cannot be the zero address.
1935      * - `sender` must have a balance of at least `amount`.
1936      */
1937     function _transfer(
1938         address sender,
1939         address recipient,
1940         uint256 amount
1941     ) internal virtual {
1942         require(sender != address(0), "ERC20: transfer from the zero address");
1943         require(recipient != address(0), "ERC20: transfer to the zero address");
1944 
1945         _beforeTokenTransfer(sender, recipient, amount);
1946 
1947         uint256 senderBalance = _balances[sender];
1948         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
1949         unchecked {
1950             _balances[sender] = senderBalance - amount;
1951         }
1952         _balances[recipient] += amount;
1953 
1954         emit Transfer(sender, recipient, amount);
1955 
1956         _afterTokenTransfer(sender, recipient, amount);
1957     }
1958 
1959     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1960      * the total supply.
1961      *
1962      * Emits a {Transfer} event with `from` set to the zero address.
1963      *
1964      * Requirements:
1965      *
1966      * - `account` cannot be the zero address.
1967      */
1968     function _mint(address account, uint256 amount) internal virtual {
1969         require(account != address(0), "ERC20: mint to the zero address");
1970 
1971         _beforeTokenTransfer(address(0), account, amount);
1972 
1973         _totalSupply += amount;
1974         _balances[account] += amount;
1975         emit Transfer(address(0), account, amount);
1976 
1977         _afterTokenTransfer(address(0), account, amount);
1978     }
1979 
1980     /**
1981      * @dev Destroys `amount` tokens from `account`, reducing the
1982      * total supply.
1983      *
1984      * Emits a {Transfer} event with `to` set to the zero address.
1985      *
1986      * Requirements:
1987      *
1988      * - `account` cannot be the zero address.
1989      * - `account` must have at least `amount` tokens.
1990      */
1991     function _burn(address account, uint256 amount) internal virtual {
1992         require(account != address(0), "ERC20: burn from the zero address");
1993 
1994         _beforeTokenTransfer(account, address(0), amount);
1995 
1996         uint256 accountBalance = _balances[account];
1997         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1998         unchecked {
1999             _balances[account] = accountBalance - amount;
2000         }
2001         _totalSupply -= amount;
2002 
2003         emit Transfer(account, address(0), amount);
2004 
2005         _afterTokenTransfer(account, address(0), amount);
2006     }
2007 
2008     /**
2009      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
2010      *
2011      * This internal function is equivalent to `approve`, and can be used to
2012      * e.g. set automatic allowances for certain subsystems, etc.
2013      *
2014      * Emits an {Approval} event.
2015      *
2016      * Requirements:
2017      *
2018      * - `owner` cannot be the zero address.
2019      * - `spender` cannot be the zero address.
2020      */
2021     function _approve(
2022         address owner,
2023         address spender,
2024         uint256 amount
2025     ) internal virtual {
2026         require(owner != address(0), "ERC20: approve from the zero address");
2027         require(spender != address(0), "ERC20: approve to the zero address");
2028 
2029         _allowances[owner][spender] = amount;
2030         emit Approval(owner, spender, amount);
2031     }
2032 
2033     /**
2034      * @dev Hook that is called before any transfer of tokens. This includes
2035      * minting and burning.
2036      *
2037      * Calling conditions:
2038      *
2039      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2040      * will be transferred to `to`.
2041      * - when `from` is zero, `amount` tokens will be minted for `to`.
2042      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
2043      * - `from` and `to` are never both zero.
2044      *
2045      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2046      */
2047     function _beforeTokenTransfer(
2048         address from,
2049         address to,
2050         uint256 amount
2051     ) internal virtual {}
2052 
2053     /**
2054      * @dev Hook that is called after any transfer of tokens. This includes
2055      * minting and burning.
2056      *
2057      * Calling conditions:
2058      *
2059      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2060      * has been transferred to `to`.
2061      * - when `from` is zero, `amount` tokens have been minted for `to`.
2062      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
2063      * - `from` and `to` are never both zero.
2064      *
2065      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2066      */
2067     function _afterTokenTransfer(
2068         address from,
2069         address to,
2070         uint256 amount
2071     ) internal virtual {}
2072 }
2073 // File: contracts/mainnetTesting/FRXST.sol
2074 
2075 pragma solidity ^0.8.0;
2076 
2077 
2078 
2079 
2080 contract FRXST is ERC20, Ownable {
2081 
2082   // a mapping from an address to whether or not it can mint / burn
2083   mapping(address => bool) controllers;
2084   
2085   constructor() ERC20("FRXST", "FRXST") {
2086 
2087       console.log("Hey from FRXST");
2088    }
2089 
2090   /**
2091    * mints $FRXST to a recipient
2092    * @param to the recipient of the $FRXST
2093    * @param amount the amount of $FRXST to mint
2094    */
2095   function mint(address to, uint256 amount) external {
2096     require(controllers[msg.sender], "Only controllers can mint");
2097     _mint(to, amount);
2098   }
2099 
2100   /**
2101    * burns $FRXST from a holder
2102    * @param from the holder of the $FRXST
2103    * @param amount the amount of $FRXST to burn
2104    */
2105   function burn(address from, uint256 amount) external {
2106     require(controllers[msg.sender], "Only controllers can burn");
2107     _burn(from, amount);
2108   }
2109 
2110   /**
2111    * enables an address to mint / burn
2112    * @param controller the address to enable
2113    */
2114   function addController(address controller) external onlyOwner {
2115     controllers[controller] = true;
2116   }
2117 
2118   /**
2119    * disables an address from minting / burning
2120    * @param controller the address to disbale
2121    */
2122   function removeController(address controller) external onlyOwner {
2123     controllers[controller] = false;
2124   }
2125 }