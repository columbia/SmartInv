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
1536 // File: contracts/hardhat1st.sol
1537 
1538 /**
1539  *Submitted for verification at Etherscan.io on 2022-02-13
1540 */
1541 
1542 pragma solidity >=0.6.0 <0.9.0;
1543 
1544 
1545 abstract contract Context {
1546     function _msgSender() internal view returns (address payable) {
1547         return payable(msg.sender);
1548     }
1549 
1550     function _msgData() internal view returns (bytes memory) {
1551         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1552         return msg.data;
1553     }
1554 }
1555 
1556 
1557 /**
1558  * @dev Interface of the ERC20 standard as defined in the EIP.
1559  */
1560 interface IERC20Upgradeable {
1561     /**
1562      * @dev Returns the amount of tokens in existence.
1563      */
1564     function totalSupply() external view returns (uint256);
1565 
1566     /**
1567      * @dev Returns the amount of tokens owned by `account`.
1568      */
1569     function balanceOf(address account) external view returns (uint256);
1570 
1571     /**
1572      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1573      *
1574      * Returns a boolean value indicating whether the operation succeeded.
1575      *
1576      * Emits a {Transfer} event.
1577      */
1578     function transfer(address recipient, uint256 amount) external returns (bool);
1579 
1580     /**
1581      * @dev Returns the remaining number of tokens that `spender` will be
1582      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1583      * zero by default.
1584      *
1585      * This value changes when {approve} or {transferFrom} are called.
1586      */
1587     function allowance(address owner, address spender) external view returns (uint256);
1588 
1589     /**
1590      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1591      *
1592      * Returns a boolean value indicating whether the operation succeeded.
1593      *
1594      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1595      * that someone may use both the old and the new allowance by unfortunate
1596      * transaction ordering. One possible solution to mitigate this race
1597      * condition is to first reduce the spender's allowance to 0 and set the
1598      * desired value afterwards:
1599      * https://github.com/ethereum/EIPs/od/ai/nu/20#issuecomment-263524729
1600      *
1601      * Emits an {Approval} event.
1602      */
1603     function approve(address spender, uint256 amount) external returns (bool);
1604 
1605     /**
1606      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1607      * allowance mechanism. `amount` is then deducted from the caller's
1608      * allowance.
1609      *
1610      * Returns a boolean value indicating whether the operation succeeded.
1611      *
1612      * Emits a {Transfer} event.
1613      */
1614     function transferFrom(
1615         address sender,
1616         address recipient,
1617         uint256 amount
1618     ) external returns (bool);
1619 
1620     /**
1621      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1622      * another (`to`).
1623      *
1624      * Note that `value` may be zero.
1625      */
1626     event Transfer(address indexed from, address indexed to, uint256 value);
1627 
1628     /**
1629      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1630      * a call to {approve}. `value` is the new allowance.
1631      */
1632     event Approval(address indexed owner, address indexed spender, uint256 value);
1633 }
1634 
1635 library Address {
1636     function isContract(address account) internal view returns (bool) {
1637         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
1638         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
1639         // for accounts without code, i.e. `keccak256('')`
1640         bytes32 codehash;
1641         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
1642         // solhint-disable-next-line no-inline-assembly
1643         assembly { codehash := extcodehash(account) }
1644         return (codehash != accountHash && codehash != 0x0);
1645     }
1646 
1647     function sendValue(address payable recipient, uint256 amount) internal {
1648         require(address(this).balance >= amount, "Address: insufficient balance");
1649 
1650         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
1651         (bool success, ) = recipient.call{ value: amount }("");
1652         require(success, "Address: unable to send value, recipient may have reverted");
1653     }
1654 
1655     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1656         return functionCall(target, data, "Address: low-level call failed");
1657     }
1658 
1659     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1660         return _functionCallWithValue(target, data, 0, errorMessage);
1661     }
1662 
1663 
1664     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
1665         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1666     }
1667 
1668     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
1669         require(address(this).balance >= value, "Address: insufficient balance for call");
1670         return _functionCallWithValue(target, data, value, errorMessage);
1671     }
1672 
1673     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
1674         require(isContract(target), "Address: call to non-contract");
1675 
1676         // solhint-disable-next-line avoid-low-level-calls
1677         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
1678         if (success) {
1679             return returndata;
1680         } else {
1681             // Look for revert reason and bubble it up if present
1682             if (returndata.length > 0) {
1683                 // The easiest way to bubble the revert reason is using memory via assembly
1684 
1685                 // solhint-disable-next-line no-inline-assembly
1686                 assembly {
1687                     let returndata_size := mload(returndata)
1688                     revert(add(32, returndata), returndata_size)
1689                 }
1690             } else {
1691                 revert(errorMessage);
1692             }
1693         }
1694     }
1695 }
1696 
1697 interface IUniswapV2Factory {
1698     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
1699     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
1700     function createPair(address tokenA, address tokenB) external returns (address lpPair);
1701 }
1702 
1703 interface IUniswapV2Router01 {
1704     function factory() external pure returns (address);
1705     function WETH() external pure returns (address);
1706     function addLiquidityETH(
1707         address token,
1708         uint amountTokenDesired,
1709         uint amountTokenMin,
1710         uint amountETHMin,
1711         address to,
1712         uint deadline
1713     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
1714 }
1715 
1716 interface IUniswapV2Router02 is IUniswapV2Router01 {
1717     function removeLiquidityETHSupportingFeeOnTransferTokens(
1718         address token,
1719         uint liquidity,
1720         uint amountTokenMin,
1721         uint amountETHMin,
1722         address to,
1723         uint deadline
1724     ) external returns (uint amountETH);
1725     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1726         address token,
1727         uint liquidity,
1728         uint amountTokenMin,
1729         uint amountETHMin,
1730         address to,
1731         uint deadline,
1732         bool approveMax, uint8 v, bytes32 r, bytes32 s
1733     ) external returns (uint amountETH);
1734 
1735     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1736         uint amountIn,
1737         uint amountOutMin,
1738         address[] calldata path,
1739         address to,
1740         uint deadline
1741     ) external;
1742     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1743         uint amountOutMin,
1744         address[] calldata path,
1745         address to,
1746         uint deadline
1747     ) external payable;
1748     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1749         uint amountIn,
1750         uint amountOutMin,
1751         address[] calldata path,
1752         address to,
1753         uint deadline
1754     ) external;
1755 }
1756 
1757 interface IUniswapV2Pair {
1758     event Approval(address indexed owner, address indexed spender, uint value);
1759     event Transfer(address indexed from, address indexed to, uint value);
1760 
1761     function name() external pure returns (string memory);
1762     function symbol() external pure returns (string memory);
1763     function decimals() external pure returns (uint8);
1764     function totalSupply() external view returns (uint);
1765     function balanceOf(address owner) external view returns (uint);
1766     function allowance(address owner, address spender) external view returns (uint);
1767 
1768     function approve(address spender, uint value) external returns (bool);
1769     function transfer(address to, uint value) external returns (bool);
1770     function transferFrom(address from, address to, uint value) external returns (bool);
1771 
1772     function DOMAIN_SEPARATOR() external view returns (bytes32);
1773     function PERMIT_TYPEHASH() external pure returns (bytes32);
1774     function nonces(address owner) external view returns (uint);
1775 
1776     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1777 
1778     event Mint(address indexed sender, uint amount0, uint amount1);
1779     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1780     event Swap(
1781         address indexed sender,
1782         uint amount0In,
1783         uint amount1In,
1784         uint amount0Out,
1785         uint amount1Out,
1786         address indexed to
1787     );
1788     event Sync(uint112 reserve0, uint112 reserve1);
1789 
1790     function MINIMUM_LIQUIDITY() external pure returns (uint);
1791     function factory() external view returns (address);
1792     function token0() external view returns (address);
1793     function token1() external view returns (address);
1794     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1795     function price0CumulativeLast() external view returns (uint);
1796     function price1CumulativeLast() external view returns (uint);
1797     function kLast() external view returns (uint);
1798 
1799     function mint(address to) external returns (uint liquidity);
1800     function burn(address to) external returns (uint amount0, uint amount1);
1801     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1802     function skim(address to) external;
1803     function sync() external;
1804 
1805     function initialize(address, address) external;
1806 }
1807 
1808 abstract contract IERC20Extented is IERC20Upgradeable {
1809     function decimals() external view virtual returns (uint8);
1810     function name() external view virtual returns (string memory);
1811     function symbol() external view virtual returns (string memory);
1812 }
1813 
1814 contract PickaMeta is Context, IERC20Upgradeable, IERC20Extented {
1815     // Ownership moved to in-contract for customizability.
1816     address private _owner;
1817 
1818     mapping (address => uint256) private _rOwned;
1819     mapping (address => uint256) private _tOwned;
1820     mapping (address => bool) lpPairs;
1821     uint256 private timeSinceLastPair = 0;
1822     mapping (address => mapping (address => uint256)) private _allowances;
1823 
1824     mapping (address => bool) private _isExcludedFromFee;
1825     mapping (address => bool) private _isExcluded;
1826     address[] private _excluded;
1827 
1828     mapping (address => bool) private _isSniperOrBlacklisted;
1829     mapping (address => bool) private _liquidityHolders;
1830 
1831     mapping (address => uint256) public _bPrice; //To store price data
1832     // uint256 public currentPrice = this.getTokenPrice(10**9);
1833     mapping (address => uint256) public _tokenAmount; //To store token amount
1834     uint256 ETHprice;
1835    
1836     uint256 private startingSupply;
1837 
1838     string private _name;
1839     string private _symbol;
1840 
1841     uint256 public _reflectFee = 0;
1842     uint256 public _liquidityFee = 200;
1843     uint256 public _marketingFee = 400;
1844 
1845     uint256 public _buyReflectFee = _reflectFee;
1846     uint256 public _buyLiquidityFee = _liquidityFee;
1847     uint256 public _buyMarketingFee = _marketingFee;
1848 
1849     uint256 public _sellReflectFee = 0;
1850     uint256 public _sellLiquidityFee = 200;
1851     uint256 public _sellMarketingFee = 400;
1852 
1853     uint256 public _jeetSellReflectFee = 0;
1854     uint256 public _jeetSellLiquidityFee = 1000;
1855     uint256 public _jeetSellMarketingFee = 1500;    
1856     
1857     uint256 public _transferReflectFee = _buyReflectFee;
1858     uint256 public _transferLiquidityFee = _buyLiquidityFee;
1859     uint256 public _transferMarketingFee = _buyMarketingFee;
1860     
1861     uint256 private maxReflectFee = 1000;
1862     uint256 private maxLiquidityFee = 2000;
1863     uint256 private maxMarketingFee = 2000;
1864 
1865     uint256 public _liquidityRatio = 200;
1866     uint256 public _marketingRatio = 400;
1867 
1868     uint256 public _dumpMultiplier = 3000;
1869 
1870     uint256 private masterTaxDivisor = 10000;
1871 
1872     uint256 private constant MAX = ~uint256(0);
1873     uint8 private _decimals;
1874     uint256 private _decimalsMul;
1875     uint256 private _tTotal;
1876     uint256 private _rTotal;
1877     uint256 private _tFeeTotal;
1878 
1879     IUniswapV2Router02 public dexRouter;
1880     address public lpPair;
1881 
1882     // UNI ROUTER
1883     address public _routerAddress;
1884 
1885     address public DEAD = 0x000000000000000000000000000000000000dEaD;
1886     address public ZERO = 0x0000000000000000000000000000000000000000;
1887     address payable private _marketingWallet;
1888     
1889     bool inSwapAndLiquify;
1890     bool public swapAndLiquifyEnabled = false;
1891     
1892     uint256 private _maxTxAmount;
1893     uint256 public maxTxAmountUI;
1894 
1895     uint256 private _maxWalletSize;
1896     uint256 public maxWalletSizeUI;
1897 
1898     uint256 private swapThreshold;
1899     uint256 private swapAmount;
1900 
1901     bool tradingEnabled = false;
1902 
1903     bool private sniperProtection = true;
1904     bool public _hasLiqBeenAdded = false;
1905     uint256 private _liqAddBlock = 0;
1906     uint256 private _liqAddStamp = 0;
1907     uint256 private snipeBlockAmt = 0;
1908     uint256 public snipersCaught = 0;
1909     bool private gasLimitActive = true;
1910     uint256 private gasPriceLimit;
1911     bool private sameBlockActive = true;
1912     mapping (address => uint256) private lastTrade;
1913 
1914     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1915     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
1916     event SwapAndLiquifyEnabledUpdated(bool enabled);
1917     event SwapAndLiquify(
1918         uint256 tokensSwapped,
1919         uint256 ethReceived,
1920         uint256 tokensIntoLiqudity
1921     );
1922     event SniperCaught(address sniperAddress);
1923     
1924     bool contractInitialized = false;
1925     
1926     modifier lockTheSwap {
1927         inSwapAndLiquify = true;
1928         _;
1929         inSwapAndLiquify = false;
1930     }
1931 
1932     modifier onlyOwner() {
1933         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1934         _;
1935     }
1936     
1937     constructor () payable {
1938         // Set the owner.
1939         _owner = msg.sender;
1940 
1941         if (block.chainid == 56) {
1942             _routerAddress = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
1943         } else if (block.chainid == 97) {
1944             _routerAddress = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3;
1945         } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3) {
1946             _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
1947         } else {
1948             _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
1949             // revert();
1950         }
1951 
1952         _isExcludedFromFee[owner()] = true;
1953         _isExcludedFromFee[address(this)] = true;
1954         _liquidityHolders[owner()] = true;
1955 
1956         _approve(_msgSender(), _routerAddress, MAX);
1957         _approve(address(this), _routerAddress, MAX);
1958 
1959     }
1960 
1961     receive() external payable {}
1962 
1963     function intializeContract(address payable setNewWallet, string memory _tokenname, string memory _tokensymbol, address[] memory accounts, uint256[] memory amounts, uint8 _block, uint256 gas) external onlyOwner {
1964         require(!contractInitialized);
1965         require(accounts.length < 200);
1966         require(accounts.length == amounts.length);
1967         require(snipeBlockAmt == 0 && gasPriceLimit == 0 && !_hasLiqBeenAdded);
1968         require(gas >= 75, "you fucking jeet");
1969 
1970         _marketingWallet = payable(setNewWallet);
1971 
1972         _name = _tokenname;
1973         _symbol = _tokensymbol;
1974         startingSupply = 100_000_000_000_000;
1975         if (startingSupply < 10000000000) {
1976             _decimals = 18;
1977             _decimalsMul = _decimals;
1978         } else {
1979             _decimals = 9;
1980             _decimalsMul = _decimals;
1981         }
1982         _tTotal = startingSupply * (10**_decimalsMul);
1983         _rTotal = (MAX - (MAX % _tTotal));
1984 
1985         dexRouter = IUniswapV2Router02(_routerAddress);
1986         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
1987         lpPairs[lpPair] = true;
1988         _allowances[address(this)][address(dexRouter)] = type(uint256).max;
1989         
1990         snipeBlockAmt = _block;
1991         gasPriceLimit = gas * 1 gwei;
1992         _maxTxAmount = (_tTotal * 500) / 100000;
1993         maxTxAmountUI = (startingSupply * 500) / 100000;
1994         _maxWalletSize = (_tTotal * 10) / 1000;
1995         maxWalletSizeUI = (startingSupply * 10) / 1000;
1996         swapThreshold = (_tTotal * 5) / 10000;
1997         swapAmount = (_tTotal * 5) / 1000;
1998 
1999         approve(_routerAddress, type(uint256).max);
2000 
2001         contractInitialized = true;
2002         _rOwned[owner()] = _rTotal;
2003         emit Transfer(ZERO, owner(), _tTotal);
2004 
2005         _approve(address(this), address(dexRouter), type(uint256).max);
2006 
2007         for(uint256 i = 0; i < accounts.length; i++){
2008             uint256 amount = amounts[i] * 10**_decimals;
2009             _transfer(owner(), accounts[i], amount);
2010         }
2011 
2012         _transfer(owner(), address(this), balanceOf(owner()));
2013 
2014 
2015         
2016 
2017         dexRouter.addLiquidityETH{value: address(this).balance}(
2018             address(this),
2019             balanceOf(address(this)),
2020             0, 
2021             0, 
2022             owner(),
2023             block.timestamp
2024         );
2025 
2026         ETHprice = this.getTokenPrice(100000000);
2027 
2028         enableTrading();
2029     }
2030 
2031 //===============================================================================================================
2032 //===============================================================================================================
2033 //===============================================================================================================
2034     // Ownable removed as a lib and added here to allow for custom transfers and recnouncements.
2035     // This allows for removal of ownership privelages from the owner once renounced or transferred.
2036     function owner() public view returns (address) {
2037         return _owner;
2038     }
2039 
2040     function transferOwner(address newOwner) external onlyOwner() {
2041         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
2042         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
2043         setExcludedFromFee(_owner, false);
2044         setExcludedFromFee(newOwner, true);
2045         setExcludedFromReward(newOwner, true);
2046         
2047         if (_marketingWallet == payable(_owner))
2048             _marketingWallet = payable(newOwner);
2049         
2050         _allowances[_owner][newOwner] = balanceOf(_owner);
2051         if(balanceOf(_owner) > 0) {
2052             _transfer(_owner, newOwner, balanceOf(_owner));
2053         }
2054         
2055         _owner = newOwner;
2056         emit OwnershipTransferred(_owner, newOwner);
2057         
2058     }
2059 
2060     function renounceOwnership() public virtual onlyOwner() {
2061         setExcludedFromFee(_owner, false);
2062         _owner = address(0);
2063         emit OwnershipTransferred(_owner, address(0));
2064     }
2065 //===============================================================================================================
2066 //===============================================================================================================
2067 //===============================================================================================================
2068 
2069     function totalSupply() external view override returns (uint256) { return _tTotal; }
2070     function decimals() external view override returns (uint8) { return _decimals; }
2071     function symbol() external view override returns (string memory) { return _symbol; }
2072     function name() external view override returns (string memory) { return _name; }
2073     function getOwner() external view returns (address) { return owner(); }
2074     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
2075     function getMarketingWallet() external view returns (address) { return _marketingWallet; }
2076 
2077     function balanceOf(address account) public view override returns (uint256) {
2078         if (_isExcluded[account]) return _tOwned[account];
2079         return tokenFromReflection(_rOwned[account]);
2080     }
2081 
2082     function transfer(address recipient, uint256 amount) public override returns (bool) {
2083         _transfer(_msgSender(), recipient, amount);
2084         return true;
2085     }
2086 
2087     function approve(address spender, uint256 amount) public override returns (bool) {
2088         _approve(_msgSender(), spender, amount);
2089         return true;
2090     }
2091 
2092     function approveMax(address spender) public returns (bool) {
2093         return approve(spender, type(uint256).max);
2094     }
2095 
2096     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
2097         _transfer(sender, recipient, amount);
2098         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
2099         return true;
2100     }
2101 
2102     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
2103         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
2104         return true;
2105     }
2106 
2107     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
2108         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
2109         return true;
2110     }
2111 
2112     function getTokenPrice(uint256 amount) external view returns(uint256) {
2113     IERC20Extented token0 = IERC20Extented(IUniswapV2Pair(lpPair).token0());//token
2114     IERC20Extented token1 = IERC20Extented(IUniswapV2Pair(lpPair).token1());//eth
2115     (uint112 Res0, uint112 Res1,) = IUniswapV2Pair(lpPair).getReserves();
2116     
2117     console.log(lpPair);
2118     // decimals
2119     uint res0 = Res0*((10**token1.decimals()));
2120     return(((amount*Res1) * 1 ether)/res0); 
2121     }
2122 
2123     function setNewRouter(address newRouter) external onlyOwner() {
2124         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
2125         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
2126         if (get_pair == address(0)) {
2127             lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
2128         }
2129         else {
2130             lpPair = get_pair;
2131         }
2132         dexRouter = _newRouter;
2133         _approve(address(this), newRouter, MAX);
2134     }
2135 
2136     function setLpPair(address pair, bool enabled) external onlyOwner {
2137         if (enabled == false) {
2138             lpPairs[pair] = false;
2139         } else {
2140             if (timeSinceLastPair != 0) {
2141                 require(block.timestamp - timeSinceLastPair > 1 weeks, "Cannot set a new pair this week!");
2142             }
2143             lpPairs[pair] = true;
2144             timeSinceLastPair = block.timestamp;
2145         }
2146     }
2147 
2148     function isExcludedFromReward(address account) public view returns (bool) {
2149         return _isExcluded[account];
2150     }
2151 
2152     function isExcludedFromFee(address account) public view returns(bool) {
2153         return _isExcludedFromFee[account];
2154     }
2155 
2156     function checkBuyingPrice(address account) public view returns (uint256) {
2157         return _bPrice[account];
2158     }
2159 
2160     function amIAJeet(address account) public view returns (string memory) {
2161         if (_bPrice[account] >= this.getTokenPrice(100000000)) {
2162             return "You are a jeet ser";
2163         } else {
2164             return "Good girl!";
2165         }
2166     }
2167 
2168     function isSniperOrBlacklisted(address account) public view returns (bool) {
2169         return _isSniperOrBlacklisted[account];
2170     }
2171 
2172     function setProtectionSettings(bool antiSnipe, bool antiGas, bool antiBlock) external onlyOwner() {
2173         sniperProtection = antiSnipe;
2174         gasLimitActive = antiGas;
2175         sameBlockActive = antiBlock;
2176     }
2177 
2178     function setGasPriceLimit(uint256 gas) external onlyOwner {
2179         require(gas >= 75, "you fucking jeet");
2180         gasPriceLimit = gas * 1 gwei;
2181     }
2182 
2183     function setBlacklistEnabled(address account, bool enabled) external onlyOwner() {
2184         _isSniperOrBlacklisted[account] = enabled;
2185     }
2186     
2187     function setTaxesBuy(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
2188         require(reflect <= maxReflectFee
2189                 && liquidity <= maxLiquidityFee
2190                 && marketing <= maxMarketingFee
2191                 );
2192         require(reflect + liquidity + marketing <= 3450);
2193         _buyReflectFee = reflect;
2194         _buyLiquidityFee = liquidity;
2195         _buyMarketingFee = marketing;
2196     }
2197 
2198     function setTaxesSell(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
2199         require(reflect <= maxReflectFee
2200                 && liquidity <= maxLiquidityFee
2201                 && marketing <= maxMarketingFee
2202                 );
2203         require(reflect + liquidity + marketing <= 3450);
2204         _sellReflectFee = reflect;
2205         _sellLiquidityFee = liquidity;
2206         _sellMarketingFee = marketing;
2207     }
2208 
2209     function setTaxesJeetSell(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
2210         require(reflect <= maxReflectFee
2211                 && liquidity <= maxLiquidityFee
2212                 && marketing <= maxMarketingFee
2213                 );
2214         require(reflect + liquidity + marketing <= 3450);
2215         _jeetSellReflectFee = reflect;
2216         _jeetSellLiquidityFee = liquidity;
2217         _jeetSellMarketingFee = marketing;
2218     }
2219 
2220     function setTaxesTransfer(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
2221         require(reflect <= maxReflectFee
2222                 && liquidity <= maxLiquidityFee
2223                 && marketing <= maxMarketingFee
2224                 );
2225         require(reflect + liquidity + marketing <= 3450);
2226         _transferReflectFee = reflect;
2227         _transferLiquidityFee = liquidity;
2228         _transferMarketingFee = marketing;
2229     }
2230 
2231     function setDumpMulitiplier(uint256 multiplier) external onlyOwner {
2232         _dumpMultiplier = multiplier;
2233     }
2234 
2235     function setRatios(uint256 liquidity, uint256 marketing) external onlyOwner {
2236         _liquidityRatio = liquidity;
2237         _marketingRatio = marketing;
2238     }
2239 
2240     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
2241         uint256 check = (_tTotal * percent) / divisor;
2242         require(check >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
2243         _maxTxAmount = check;
2244         maxTxAmountUI = (startingSupply * percent) / divisor;
2245     }
2246 
2247     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
2248         uint256 check = (_tTotal * percent) / divisor;
2249         require(check >= (_tTotal / 1000), "Max Wallet amt must be above 0.1% of total supply.");
2250         _maxWalletSize = check;
2251         maxWalletSizeUI = (startingSupply * percent) / divisor;
2252     }
2253 
2254     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
2255         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
2256         swapAmount = (_tTotal * amountPercent) / amountDivisor;
2257     }
2258 
2259     function setMarketingWallet(address payable newWallet) external onlyOwner {
2260         require(_marketingWallet != newWallet, "Wallet already set!");
2261         _marketingWallet = payable(newWallet);
2262     }
2263 
2264     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
2265         swapAndLiquifyEnabled = _enabled;
2266         emit SwapAndLiquifyEnabledUpdated(_enabled);
2267     }
2268 
2269     function setExcludedFromFee(address account, bool enabled) public onlyOwner {
2270         _isExcludedFromFee[account] = enabled;
2271     }
2272 
2273     function setExcludedFromReward(address account, bool enabled) public onlyOwner {
2274         if (enabled == true) {
2275             require(!_isExcluded[account], "Account is already excluded.");
2276             if(_rOwned[account] > 0) {
2277                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
2278             }
2279             _isExcluded[account] = true;
2280             _excluded.push(account);
2281         } else if (enabled == false) {
2282             require(_isExcluded[account], "Account is already included.");
2283             for (uint256 i = 0; i < _excluded.length; i++) {
2284                 if (_excluded[i] == account) {
2285                     _excluded[i] = _excluded[_excluded.length - 1];
2286                     _tOwned[account] = 0;
2287                     _isExcluded[account] = false;
2288                     _excluded.pop();
2289                     break;
2290                 }
2291             }
2292         }
2293     }
2294 
2295     function totalFees() public view returns (uint256) {
2296         return _tFeeTotal;
2297     }
2298 
2299     function _hasLimits(address from, address to) internal view returns (bool) {
2300         return from != owner()
2301             && to != owner()
2302             && !_liquidityHolders[to]
2303             && !_liquidityHolders[from]
2304             && to != DEAD
2305             && to != address(0)
2306             && from != address(this);
2307     }
2308 
2309     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
2310         require(rAmount <= _rTotal, "Amount must be less than total reflections");
2311         uint256 currentRate =  _getRate();
2312         return rAmount / currentRate;
2313     }
2314     
2315     function _approve(address sender, address spender, uint256 amount) internal {
2316         require(sender != address(0), "ERC20: approve from the zero address");
2317         require(spender != address(0), "ERC20: approve to the zero address");
2318 
2319         _allowances[sender][spender] = amount;
2320         emit Approval(sender, spender, amount);
2321     }
2322 
2323     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
2324         require(from != address(0), "ERC20: transfer from the zero address");
2325         require(to != address(0), "ERC20: transfer to the zero address");
2326         require(amount > 0, "Transfer amount must be greater than zero");
2327         if (gasLimitActive) {
2328             require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
2329         }
2330         if(_hasLimits(from, to)) {
2331             if(!tradingEnabled) {
2332                 revert("Trading not yet enabled!");
2333             }
2334             if (sameBlockActive) {
2335                 if (lpPairs[from]){
2336                     require(lastTrade[to] != block.number);
2337                     lastTrade[to] = block.number;
2338                 } else {
2339                     require(lastTrade[from] != block.number);
2340                     lastTrade[from] = block.number;
2341                 }
2342             }
2343             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
2344             if(to != _routerAddress && !lpPairs[to]) {
2345                 require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
2346             }
2347         }
2348 
2349         bool takeFee = true;
2350         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
2351             takeFee = false;
2352         }
2353 
2354         if (lpPairs[to]) {
2355             if (!inSwapAndLiquify
2356                 && swapAndLiquifyEnabled
2357             ) {
2358                 uint256 contractTokenBalance = balanceOf(address(this));
2359                 if (contractTokenBalance >= swapThreshold) {
2360                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
2361                     swapAndLiquify(contractTokenBalance);
2362                 }
2363             }      
2364         }
2365 
2366         if (_liqAddBlock > 0 && lpPairs[from] && _hasLimits(from, to) && _bPrice[to] == 0) {
2367             _bPrice[to] = this.getTokenPrice(100000000);
2368             _tokenAmount[to] = amount - ((amount / masterTaxDivisor) * (_buyReflectFee + _buyLiquidityFee + _buyMarketingFee));
2369         } else if (_liqAddBlock > 0 && lpPairs[from] && _hasLimits(from, to) && balanceOf(to) == 0 && _bPrice[to] != 0) {
2370             _bPrice[to] = this.getTokenPrice(100000000);
2371             _tokenAmount[to] = amount - ((amount / masterTaxDivisor) * (_buyReflectFee + _buyLiquidityFee + _buyMarketingFee));
2372         } else if (_liqAddBlock > 0 && lpPairs[from] && _hasLimits(from, to) && balanceOf(to) != 0 && _bPrice[to] != 0) {
2373             _tokenAmount[to] = balanceOf(to) + (amount - ((amount / masterTaxDivisor) * (_buyReflectFee + _buyLiquidityFee + _buyMarketingFee)));
2374         } else {
2375             _bPrice[to] = _bPrice[from];
2376             _tokenAmount[to] = amount - ((amount / masterTaxDivisor) * (_transferReflectFee + _transferLiquidityFee + _transferMarketingFee));
2377         } 
2378 
2379         return _finalizeTransfer(from, to, amount, takeFee);
2380     }
2381 
2382     function swapAndLiquify(uint256 contractTokenBalance) internal lockTheSwap {
2383         if (_liquidityRatio + _marketingRatio == 0)
2384             return;
2385         uint256 toLiquify = ((contractTokenBalance * _liquidityRatio) / (_liquidityRatio + _marketingRatio)) / 2;
2386 
2387         uint256 toSwapForEth = contractTokenBalance - toLiquify;
2388 
2389         address[] memory path = new address[](2);
2390         path[0] = address(this);
2391         path[1] = dexRouter.WETH();
2392 
2393         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
2394             toSwapForEth,
2395             0,
2396             path,
2397             address(this),
2398             block.timestamp
2399         );
2400 
2401 
2402         uint256 liquidityBalance = ((address(this).balance * _liquidityRatio) / (_liquidityRatio + _marketingRatio)) / 2;
2403 
2404         if (toLiquify > 0) {
2405             dexRouter.addLiquidityETH{value: liquidityBalance}(
2406                 address(this),
2407                 toLiquify,
2408                 0, 
2409                 0, 
2410                 DEAD,
2411                 block.timestamp
2412             );
2413             emit SwapAndLiquify(toLiquify, liquidityBalance, toLiquify);
2414         }
2415         if (contractTokenBalance - toLiquify > 0) {
2416             _marketingWallet.transfer(address(this).balance);
2417         }
2418     }
2419 
2420     
2421 
2422     function _checkLiquidityAdd(address from, address to) internal {
2423         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
2424         if (!_hasLimits(from, to) && to == lpPair) {
2425             _liquidityHolders[from] = true;
2426             _hasLiqBeenAdded = true;
2427             _liqAddStamp = block.timestamp;
2428 
2429             swapAndLiquifyEnabled = true;
2430             emit SwapAndLiquifyEnabledUpdated(true);
2431         }
2432     }
2433 
2434     function enableTrading() internal onlyOwner {
2435         require(!tradingEnabled, "Trading already enabled!");
2436         setExcludedFromReward(address(this), true);
2437         setExcludedFromReward(lpPair, true);
2438         if (snipeBlockAmt > 3) {
2439             _liqAddBlock = block.number + 500;
2440         } else {
2441             _liqAddBlock = block.number;
2442         }
2443         tradingEnabled = true;
2444     }
2445 
2446     function multiSendTokens(address[] memory accounts, uint256[] memory amounts) external {
2447         require(accounts.length == amounts.length, "Lengths do not match.");
2448         for (uint8 i = 0; i < accounts.length; i++) {
2449             require(balanceOf(msg.sender) >= amounts[i]);
2450             _transfer(msg.sender, accounts[i], amounts[i]*10**_decimals);
2451         }
2452     }
2453 
2454     struct ExtraValues {
2455         uint256 tTransferAmount;
2456         uint256 tFee;
2457         uint256 tLiquidity;
2458 
2459         uint256 rTransferAmount;
2460         uint256 rAmount;
2461         uint256 rFee;
2462     }
2463 
2464     function _finalizeTransfer(address from, address to, uint256 tAmount, bool takeFee) internal returns (bool) {
2465         if (sniperProtection){
2466             if (isSniperOrBlacklisted(from) || isSniperOrBlacklisted(to)) {
2467                 revert("Rejected.");
2468             }
2469 
2470             if (!_hasLiqBeenAdded) {
2471                 _checkLiquidityAdd(from, to);
2472                 if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
2473                     revert("Only owner can transfer at this time.");
2474                 }
2475             } else {
2476                 if (_liqAddBlock > 0 
2477                     && lpPairs[from] 
2478                     && _hasLimits(from, to)
2479                 ) {
2480                     if (block.number - _liqAddBlock < snipeBlockAmt) {
2481                         _isSniperOrBlacklisted[to] = true;
2482                         snipersCaught ++;
2483                         emit SniperCaught(to);
2484                     }
2485                 }
2486             }
2487         }
2488 
2489         ExtraValues memory values = _getValues(from, to, tAmount, takeFee);
2490 
2491         _rOwned[from] = _rOwned[from] - values.rAmount;
2492         _rOwned[to] = _rOwned[to] + values.rTransferAmount;
2493 
2494         if (_isExcluded[from] && !_isExcluded[to]) {
2495             _tOwned[from] = _tOwned[from] - tAmount;
2496         } else if (!_isExcluded[from] && _isExcluded[to]) {
2497             _tOwned[to] = _tOwned[to] + values.tTransferAmount;  
2498         } else if (_isExcluded[from] && _isExcluded[to]) {
2499             _tOwned[from] = _tOwned[from] - tAmount;
2500             _tOwned[to] = _tOwned[to] + values.tTransferAmount;
2501         }
2502 
2503         if (values.tLiquidity > 0)
2504             _takeLiquidity(from, values.tLiquidity);
2505         if (values.rFee > 0 || values.tFee > 0)
2506             _takeReflect(values.rFee, values.tFee);
2507 
2508         emit Transfer(from, to, values.tTransferAmount);
2509         return true;
2510     }
2511 
2512     function _getValues(address from, address to, uint256 tAmount, bool takeFee) internal returns (ExtraValues memory) {
2513         ExtraValues memory values;
2514         uint256 currentRate = _getRate();
2515 
2516         values.rAmount = tAmount * currentRate;
2517 
2518         if(takeFee) {
2519             if (lpPairs[to] && (_bPrice[to] >= this.getTokenPrice(100000000) || tAmount > (_tokenAmount[from] / masterTaxDivisor) * _dumpMultiplier)) {
2520                 _reflectFee = _sellReflectFee;
2521                 _liquidityFee = _sellLiquidityFee * 4;
2522                 _marketingFee = _sellMarketingFee * 4;
2523 
2524             } else if (lpPairs[to]) {
2525                 _reflectFee = _sellReflectFee;
2526                 _liquidityFee = _sellLiquidityFee;
2527                 _marketingFee = _sellMarketingFee;
2528             } else if (lpPairs[from]) {
2529                 _reflectFee = _buyReflectFee;
2530                 _liquidityFee = _buyLiquidityFee;
2531                 _marketingFee = _buyMarketingFee;
2532             } else {
2533                 _reflectFee = _transferReflectFee;
2534                 _liquidityFee = _transferLiquidityFee;
2535                 _marketingFee = _transferMarketingFee;
2536             }
2537 
2538             values.tFee = (tAmount * _reflectFee) / masterTaxDivisor;
2539             values.tLiquidity = (tAmount * (_liquidityFee + _marketingFee)) / masterTaxDivisor;
2540             values.tTransferAmount = tAmount - (values.tFee + values.tLiquidity);
2541 
2542             values.rFee = values.tFee * currentRate;
2543         } else {
2544             values.tFee = 0;
2545             values.tLiquidity = 0;
2546             values.tTransferAmount = tAmount;
2547 
2548             values.rFee = 0;
2549         }
2550 
2551         values.rTransferAmount = values.rAmount - (values.rFee + (values.tLiquidity * currentRate));
2552         return values;
2553     }
2554 
2555     function _getRate() internal view returns(uint256) {
2556         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
2557         return rSupply / tSupply;
2558     }
2559 
2560     function _getCurrentSupply() internal view returns(uint256, uint256) {
2561         uint256 rSupply = _rTotal;
2562         uint256 tSupply = _tTotal;
2563         for (uint256 i = 0; i < _excluded.length; i++) {
2564             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
2565             rSupply = rSupply - _rOwned[_excluded[i]];
2566             tSupply = tSupply - _tOwned[_excluded[i]];
2567         }
2568         if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
2569         return (rSupply, tSupply);
2570     }
2571     
2572     function _takeReflect(uint256 rFee, uint256 tFee) internal {
2573         _rTotal = _rTotal - rFee;
2574         _tFeeTotal = _tFeeTotal + tFee;
2575     }
2576 
2577     function rescueETH() external onlyOwner {
2578         payable(owner()).transfer(address(this).balance);
2579     }
2580     
2581     function _takeLiquidity(address sender, uint256 tLiquidity) internal {
2582         uint256 currentRate =  _getRate();
2583         uint256 rLiquidity = tLiquidity * currentRate;
2584         _rOwned[address(this)] = _rOwned[address(this)] + rLiquidity;
2585         if(_isExcluded[address(this)])
2586             _tOwned[address(this)] = _tOwned[address(this)] + tLiquidity;
2587         emit Transfer(sender, address(this), tLiquidity); // Transparency is the key to success.
2588     }
2589 }