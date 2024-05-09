1 // Sources flattened with hardhat v2.8.0 https://hardhat.org
2 
3 // File hardhat/console.sol@v2.8.0
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
1537 
1538 // File contracts/BondDepositoryRewardBased.sol
1539 
1540 // SPDX-License-Identifier: AGPL-3.0-or-later
1541 pragma solidity 0.7.5;
1542 
1543 interface IOwnable {
1544   function policy() external view returns (address);
1545 
1546   function renounceManagement() external;
1547   
1548   function pushManagement( address newOwner_ ) external;
1549   
1550   function pullManagement() external;
1551 }
1552 
1553 contract Ownable is IOwnable {
1554 
1555     address internal _owner;
1556     address internal _newOwner;
1557 
1558     event OwnershipPushed(address indexed previousOwner, address indexed newOwner);
1559     event OwnershipPulled(address indexed previousOwner, address indexed newOwner);
1560 
1561     constructor () {
1562         _owner = msg.sender;
1563         emit OwnershipPushed( address(0), _owner );
1564     }
1565 
1566     function policy() public view override returns (address) {
1567         return _owner;
1568     }
1569 
1570     modifier onlyPolicy() {
1571         require( _owner == msg.sender, "Ownable: caller is not the owner" );
1572         _;
1573     }
1574 
1575     function renounceManagement() public virtual override onlyPolicy() {
1576         emit OwnershipPushed( _owner, address(0) );
1577         _owner = address(0);
1578     }
1579 
1580     function pushManagement( address newOwner_ ) public virtual override onlyPolicy() {
1581         require( newOwner_ != address(0), "Ownable: new owner is the zero address");
1582         emit OwnershipPushed( _owner, newOwner_ );
1583         _newOwner = newOwner_;
1584     }
1585     
1586     function pullManagement() public virtual override {
1587         require( msg.sender == _newOwner, "Ownable: must be new owner to pull");
1588         emit OwnershipPulled( _owner, _newOwner );
1589         _owner = _newOwner;
1590     }
1591 }
1592 
1593 library SafeMath {
1594 
1595     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1596         uint256 c = a + b;
1597         require(c >= a, "SafeMath: addition overflow");
1598 
1599         return c;
1600     }
1601 
1602     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1603         return sub(a, b, "SafeMath: subtraction overflow");
1604     }
1605 
1606     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1607         require(b <= a, errorMessage);
1608         uint256 c = a - b;
1609 
1610         return c;
1611     }
1612 
1613     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1614         if (a == 0) {
1615             return 0;
1616         }
1617 
1618         uint256 c = a * b;
1619         require(c / a == b, "SafeMath: multiplication overflow");
1620 
1621         return c;
1622     }
1623 
1624     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1625         return div(a, b, "SafeMath: division by zero");
1626     }
1627 
1628     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1629         require(b > 0, errorMessage);
1630         uint256 c = a / b;
1631         return c;
1632     }
1633 
1634     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1635         return mod(a, b, "SafeMath: modulo by zero");
1636     }
1637 
1638     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1639         require(b != 0, errorMessage);
1640         return a % b;
1641     }
1642 
1643     function sqrrt(uint256 a) internal pure returns (uint c) {
1644         if (a > 3) {
1645             c = a;
1646             uint b = add( div( a, 2), 1 );
1647             while (b < c) {
1648                 c = b;
1649                 b = div( add( div( a, b ), b), 2 );
1650             }
1651         } else if (a != 0) {
1652             c = 1;
1653         }
1654     }
1655 }
1656 
1657 library Address {
1658 
1659     function isContract(address account) internal view returns (bool) {
1660 
1661         uint256 size;
1662         // solhint-disable-next-line no-inline-assembly
1663         assembly { size := extcodesize(account) }
1664         return size > 0;
1665     }
1666 
1667     function sendValue(address payable recipient, uint256 amount) internal {
1668         require(address(this).balance >= amount, "Address: insufficient balance");
1669 
1670         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
1671         (bool success, ) = recipient.call{ value: amount }("");
1672         require(success, "Address: unable to send value, recipient may have reverted");
1673     }
1674 
1675     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1676       return functionCall(target, data, "Address: low-level call failed");
1677     }
1678 
1679     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1680         return _functionCallWithValue(target, data, 0, errorMessage);
1681     }
1682 
1683     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
1684         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1685     }
1686 
1687     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
1688         require(address(this).balance >= value, "Address: insufficient balance for call");
1689         require(isContract(target), "Address: call to non-contract");
1690 
1691         // solhint-disable-next-line avoid-low-level-calls
1692         (bool success, bytes memory returndata) = target.call{ value: value }(data);
1693         return _verifyCallResult(success, returndata, errorMessage);
1694     }
1695 
1696     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
1697         require(isContract(target), "Address: call to non-contract");
1698 
1699         // solhint-disable-next-line avoid-low-level-calls
1700         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
1701         if (success) {
1702             return returndata;
1703         } else {
1704             // Look for revert reason and bubble it up if present
1705             if (returndata.length > 0) {
1706                 // The easiest way to bubble the revert reason is using memory via assembly
1707 
1708                 // solhint-disable-next-line no-inline-assembly
1709                 assembly {
1710                     let returndata_size := mload(returndata)
1711                     revert(add(32, returndata), returndata_size)
1712                 }
1713             } else {
1714                 revert(errorMessage);
1715             }
1716         }
1717     }
1718 
1719     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1720         return functionStaticCall(target, data, "Address: low-level static call failed");
1721     }
1722 
1723     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
1724         require(isContract(target), "Address: static call to non-contract");
1725 
1726         // solhint-disable-next-line avoid-low-level-calls
1727         (bool success, bytes memory returndata) = target.staticcall(data);
1728         return _verifyCallResult(success, returndata, errorMessage);
1729     }
1730 
1731     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1732         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1733     }
1734 
1735     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1736         require(isContract(target), "Address: delegate call to non-contract");
1737 
1738         // solhint-disable-next-line avoid-low-level-calls
1739         (bool success, bytes memory returndata) = target.delegatecall(data);
1740         return _verifyCallResult(success, returndata, errorMessage);
1741     }
1742 
1743     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
1744         if (success) {
1745             return returndata;
1746         } else {
1747             if (returndata.length > 0) {
1748 
1749                 assembly {
1750                     let returndata_size := mload(returndata)
1751                     revert(add(32, returndata), returndata_size)
1752                 }
1753             } else {
1754                 revert(errorMessage);
1755             }
1756         }
1757     }
1758 
1759     function addressToString(address _address) internal pure returns(string memory) {
1760         bytes32 _bytes = bytes32(uint256(_address));
1761         bytes memory HEX = "0123456789abcdef";
1762         bytes memory _addr = new bytes(42);
1763 
1764         _addr[0] = '0';
1765         _addr[1] = 'x';
1766 
1767         for(uint256 i = 0; i < 20; i++) {
1768             _addr[2+i*2] = HEX[uint8(_bytes[i + 12] >> 4)];
1769             _addr[3+i*2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
1770         }
1771 
1772         return string(_addr);
1773 
1774     }
1775 }
1776 
1777 interface IERC20 {
1778     function decimals() external view returns (uint8);
1779 
1780     function totalSupply() external view returns (uint256);
1781 
1782     function balanceOf(address account) external view returns (uint256);
1783 
1784     function transfer(address recipient, uint256 amount) external returns (bool);
1785 
1786     function allowance(address owner, address spender) external view returns (uint256);
1787 
1788     function approve(address spender, uint256 amount) external returns (bool);
1789 
1790     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1791 
1792     event Transfer(address indexed from, address indexed to, uint256 value);
1793 
1794     event Approval(address indexed owner, address indexed spender, uint256 value);
1795 }
1796 
1797 abstract contract ERC20 is IERC20 {
1798 
1799     using SafeMath for uint256;
1800 
1801     // TODO comment actual hash value.
1802     bytes32 constant private ERC20TOKEN_ERC1820_INTERFACE_ID = keccak256( "ERC20Token" );
1803     
1804     mapping (address => uint256) internal _balances;
1805 
1806     mapping (address => mapping (address => uint256)) internal _allowances;
1807 
1808     uint256 internal _totalSupply;
1809 
1810     string internal _name;
1811     
1812     string internal _symbol;
1813     
1814     uint8 internal _decimals;
1815 
1816     constructor (string memory name_, string memory symbol_, uint8 decimals_) {
1817         _name = name_;
1818         _symbol = symbol_;
1819         _decimals = decimals_;
1820     }
1821 
1822     function name() public view returns (string memory) {
1823         return _name;
1824     }
1825 
1826     function symbol() public view returns (string memory) {
1827         return _symbol;
1828     }
1829 
1830     function decimals() public view override returns (uint8) {
1831         return _decimals;
1832     }
1833 
1834     function totalSupply() public view override returns (uint256) {
1835         return _totalSupply;
1836     }
1837 
1838     function balanceOf(address account) public view virtual override returns (uint256) {
1839         return _balances[account];
1840     }
1841 
1842     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1843         _transfer(msg.sender, recipient, amount);
1844         return true;
1845     }
1846 
1847     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1848         return _allowances[owner][spender];
1849     }
1850 
1851     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1852         _approve(msg.sender, spender, amount);
1853         return true;
1854     }
1855 
1856     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1857         _transfer(sender, recipient, amount);
1858         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
1859         return true;
1860     }
1861 
1862     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1863         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
1864         return true;
1865     }
1866 
1867     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1868         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1869         return true;
1870     }
1871 
1872     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1873         require(sender != address(0), "ERC20: transfer from the zero address");
1874         require(recipient != address(0), "ERC20: transfer to the zero address");
1875 
1876         _beforeTokenTransfer(sender, recipient, amount);
1877 
1878         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1879         _balances[recipient] = _balances[recipient].add(amount);
1880         emit Transfer(sender, recipient, amount);
1881     }
1882 
1883     function _mint(address account_, uint256 ammount_) internal virtual {
1884         require(account_ != address(0), "ERC20: mint to the zero address");
1885         _beforeTokenTransfer(address( this ), account_, ammount_);
1886         _totalSupply = _totalSupply.add(ammount_);
1887         _balances[account_] = _balances[account_].add(ammount_);
1888         emit Transfer(address( this ), account_, ammount_);
1889     }
1890 
1891     function _burn(address account, uint256 amount) internal virtual {
1892         require(account != address(0), "ERC20: burn from the zero address");
1893 
1894         _beforeTokenTransfer(account, address(0), amount);
1895 
1896         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1897         _totalSupply = _totalSupply.sub(amount);
1898         emit Transfer(account, address(0), amount);
1899     }
1900 
1901     function _approve(address owner, address spender, uint256 amount) internal virtual {
1902         require(owner != address(0), "ERC20: approve from the zero address");
1903         require(spender != address(0), "ERC20: approve to the zero address");
1904 
1905         _allowances[owner][spender] = amount;
1906         emit Approval(owner, spender, amount);
1907     }
1908 
1909   function _beforeTokenTransfer( address from_, address to_, uint256 amount_ ) internal virtual { }
1910 }
1911 
1912 interface IERC2612Permit {
1913 
1914     function permit(
1915         address owner,
1916         address spender,
1917         uint256 amount,
1918         uint256 deadline,
1919         uint8 v,
1920         bytes32 r,
1921         bytes32 s
1922     ) external;
1923 
1924     function nonces(address owner) external view returns (uint256);
1925 }
1926 
1927 library Counters {
1928     using SafeMath for uint256;
1929 
1930     struct Counter {
1931 
1932         uint256 _value; // default: 0
1933     }
1934 
1935     function current(Counter storage counter) internal view returns (uint256) {
1936         return counter._value;
1937     }
1938 
1939     function increment(Counter storage counter) internal {
1940         counter._value += 1;
1941     }
1942 
1943     function decrement(Counter storage counter) internal {
1944         counter._value = counter._value.sub(1);
1945     }
1946 }
1947 
1948 abstract contract ERC20Permit is ERC20, IERC2612Permit {
1949     using Counters for Counters.Counter;
1950 
1951     mapping(address => Counters.Counter) private _nonces;
1952 
1953     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1954     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
1955 
1956     bytes32 public DOMAIN_SEPARATOR;
1957 
1958     constructor() {
1959         uint256 chainID;
1960         assembly {
1961             chainID := chainid()
1962         }
1963 
1964         DOMAIN_SEPARATOR = keccak256(
1965             abi.encode(
1966                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
1967                 keccak256(bytes(name())),
1968                 keccak256(bytes("1")), // Version
1969                 chainID,
1970                 address(this)
1971             )
1972         );
1973     }
1974 
1975     function permit(
1976         address owner,
1977         address spender,
1978         uint256 amount,
1979         uint256 deadline,
1980         uint8 v,
1981         bytes32 r,
1982         bytes32 s
1983     ) public virtual override {
1984         require(block.timestamp <= deadline, "Permit: expired deadline");
1985 
1986         bytes32 hashStruct =
1987             keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, amount, _nonces[owner].current(), deadline));
1988 
1989         bytes32 _hash = keccak256(abi.encodePacked(uint16(0x1901), DOMAIN_SEPARATOR, hashStruct));
1990 
1991         address signer = ecrecover(_hash, v, r, s);
1992         require(signer != address(0) && signer == owner, "ZeroSwapPermit: Invalid signature");
1993 
1994         _nonces[owner].increment();
1995         _approve(owner, spender, amount);
1996     }
1997 
1998     function nonces(address owner) public view override returns (uint256) {
1999         return _nonces[owner].current();
2000     }
2001 }
2002 
2003 library SafeERC20 {
2004     using SafeMath for uint256;
2005     using Address for address;
2006 
2007     function safeTransfer(IERC20 token, address to, uint256 value) internal {
2008         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
2009     }
2010 
2011     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
2012         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
2013     }
2014 
2015     function safeApprove(IERC20 token, address spender, uint256 value) internal {
2016 
2017         require((value == 0) || (token.allowance(address(this), spender) == 0),
2018             "SafeERC20: approve from non-zero to non-zero allowance"
2019         );
2020         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
2021     }
2022 
2023     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
2024         uint256 newAllowance = token.allowance(address(this), spender).add(value);
2025         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2026     }
2027 
2028     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
2029         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
2030         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2031     }
2032 
2033     function _callOptionalReturn(IERC20 token, bytes memory data) private {
2034 
2035         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
2036         if (returndata.length > 0) { // Return data is optional
2037             // solhint-disable-next-line max-line-length
2038             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
2039         }
2040     }
2041 }
2042 
2043 library FullMath {
2044     function fullMul(uint256 x, uint256 y) private pure returns (uint256 l, uint256 h) {
2045         uint256 mm = mulmod(x, y, uint256(-1));
2046         l = x * y;
2047         h = mm - l;
2048         if (mm < l) h -= 1;
2049     }
2050 
2051     function fullDiv(
2052         uint256 l,
2053         uint256 h,
2054         uint256 d
2055     ) private pure returns (uint256) {
2056         uint256 pow2 = d & -d;
2057         d /= pow2;
2058         l /= pow2;
2059         l += h * ((-pow2) / pow2 + 1);
2060         uint256 r = 1;
2061         r *= 2 - d * r;
2062         r *= 2 - d * r;
2063         r *= 2 - d * r;
2064         r *= 2 - d * r;
2065         r *= 2 - d * r;
2066         r *= 2 - d * r;
2067         r *= 2 - d * r;
2068         r *= 2 - d * r;
2069         return l * r;
2070     }
2071 
2072     function mulDiv(
2073         uint256 x,
2074         uint256 y,
2075         uint256 d
2076     ) internal pure returns (uint256) {
2077         (uint256 l, uint256 h) = fullMul(x, y);
2078         uint256 mm = mulmod(x, y, d);
2079         if (mm > l) h -= 1;
2080         l -= mm;
2081         require(h < d, 'FullMath::mulDiv: overflow');
2082         return fullDiv(l, h, d);
2083     }
2084 }
2085 
2086 library FixedPoint {
2087 
2088     struct uq112x112 {
2089         uint224 _x;
2090     }
2091 
2092     struct uq144x112 {
2093         uint256 _x;
2094     }
2095 
2096     uint8 private constant RESOLUTION = 112;
2097     uint256 private constant Q112 = 0x10000000000000000000000000000;
2098     uint256 private constant Q224 = 0x100000000000000000000000000000000000000000000000000000000;
2099     uint256 private constant LOWER_MASK = 0xffffffffffffffffffffffffffff; // decimal of UQ*x112 (lower 112 bits)
2100 
2101     function decode(uq112x112 memory self) internal pure returns (uint112) {
2102         return uint112(self._x >> RESOLUTION);
2103     }
2104 
2105     function decode112with18(uq112x112 memory self) internal pure returns (uint) {
2106 
2107         return uint(self._x) / 5192296858534827;
2108     }
2109 
2110     function fraction(uint256 numerator, uint256 denominator) internal pure returns (uq112x112 memory) {
2111         require(denominator > 0, 'FixedPoint::fraction: division by zero');
2112         if (numerator == 0) return FixedPoint.uq112x112(0);
2113 
2114         if (numerator <= uint144(-1)) {
2115             uint256 result = (numerator << RESOLUTION) / denominator;
2116             require(result <= uint224(-1), 'FixedPoint::fraction: overflow');
2117             return uq112x112(uint224(result));
2118         } else {
2119             uint256 result = FullMath.mulDiv(numerator, Q112, denominator);
2120             require(result <= uint224(-1), 'FixedPoint::fraction: overflow');
2121             return uq112x112(uint224(result));
2122         }
2123     }
2124 }
2125 
2126 interface ITreasury {
2127     function deposit( uint _amount, address _token, uint _profit ) external returns ( bool );
2128     function valueOf( address _token, uint _amount ) external view returns ( uint value_ );
2129     function getFloor(address _token) external view returns(uint);
2130     function mintRewards(address _recipient, uint _amount ) external;
2131 }
2132 
2133 interface IBondCalculator {
2134     function valuation( address _LP, uint _amount ) external view returns ( uint );
2135     function markdown( address _LP ) external view returns ( uint );
2136 }
2137 
2138 interface IStaking {
2139     function stake( uint _amount, address _recipient ) external returns ( bool );
2140 }
2141 
2142 interface IStakingHelper {
2143     function stake( uint _amount, address _recipient ) external;
2144 }
2145 
2146 contract REDACTEDBondDepositoryRewardBased is Ownable {
2147 
2148     using FixedPoint for *;
2149     using SafeERC20 for IERC20;
2150     using SafeMath for uint;
2151 
2152 
2153 
2154 
2155     /* ======== EVENTS ======== */
2156 
2157     event BondCreated( uint deposit, uint indexed payout, uint indexed expires, uint indexed nativePrice );
2158     event BondRedeemed( address indexed recipient, uint payout, uint remaining );
2159     event BondPriceChanged( uint indexed nativePrice, uint indexed internalPrice, uint indexed debtRatio );
2160     event ControlVariableAdjustment( uint initialBCV, uint newBCV, uint adjustment, bool addition );
2161 
2162 
2163 
2164 
2165     /* ======== STATE VARIABLES ======== */
2166 
2167     address public immutable BTRFLY; // token given as payment for bond
2168     address public immutable principal; // token used to create bond
2169     address public immutable OLYMPUSDAO; // we pay homage to these guys :) (tithe/ti-the hahahahhahah)
2170     address public immutable treasury; // mints BTRFLY when receives principal
2171     address public immutable DAO; // receives profit share from bond
2172     address public OLYMPUSTreasury; // Olympus treasury can be updated by the OLYMPUSDAO
2173 
2174     bool public immutable isLiquidityBond; // LP and Reserve bonds are treated slightly different
2175     address public immutable bondCalculator; // calculates value of LP tokens
2176 
2177     address public staking; // to auto-stake payout
2178     address public stakingHelper; // to stake and claim if no staking warmup
2179     bool public useHelper;
2180 
2181     Terms public terms; // stores terms for new bonds
2182     Adjust public adjustment; // stores adjustment to BCV data
2183 
2184     mapping( address => Bond ) public bondInfo; // stores bond information for depositors
2185 
2186     uint public totalDebt; // total value of outstanding bonds; used for pricing
2187     uint public lastDecay; // reference block for debt decay
2188 
2189 
2190 
2191 
2192     /* ======== STRUCTS ======== */
2193 
2194     // Info for creating new bonds
2195     struct Terms {
2196         uint controlVariable; // scaling variable for price
2197         uint vestingTerm; // in blocks
2198         uint minimumPrice; // vs principal value
2199         uint maxPayout; // in thousandths of a %. i.e. 500 = 0.5%
2200         uint fee; // as % of bond payout, in hundreths. ( 500 = 5% = 0.05 for every 1 paid)
2201         uint tithe; // in thousandths of a %. i.e. 500 = 0.5%
2202         uint maxDebt; // 9 decimal debt ratio, max % total supply created as debt
2203     }
2204 
2205     // Info for bond holder
2206     struct Bond {
2207         uint payout; // BTRFLY remaining to be paid
2208         uint vesting; // Blocks left to vest
2209         uint lastBlock; // Last interaction
2210         uint pricePaid; // In native asset, for front end viewing
2211     }
2212 
2213     // Info for incremental adjustments to control variable 
2214     struct Adjust {
2215         bool add; // addition or subtraction
2216         uint rate; // increment
2217         uint target; // BCV when adjustment finished
2218         uint buffer; // minimum length (in blocks) between adjustments
2219         uint lastBlock; // block when last adjustment made
2220     }
2221 
2222 
2223 
2224 
2225     /* ======== INITIALIZATION ======== */
2226 
2227     constructor ( 
2228         address _BTRFLY,
2229         address _principal,
2230         address _treasury, 
2231         address _DAO, 
2232         address _bondCalculator,
2233         address _OLYMPUSDAO,
2234         address _OLYMPUSTreasury
2235     ) {
2236         require( _BTRFLY != address(0) );
2237         BTRFLY = _BTRFLY;
2238         require( _principal != address(0) );
2239         principal = _principal;
2240         require( _treasury != address(0) );
2241         treasury = _treasury;
2242         require( _DAO != address(0) );
2243         DAO = _DAO;
2244         // bondCalculator should be address(0) if not LP bond
2245         bondCalculator = _bondCalculator;
2246         isLiquidityBond = ( _bondCalculator != address(0) );
2247         OLYMPUSDAO = _OLYMPUSDAO;
2248         OLYMPUSTreasury = _OLYMPUSTreasury;
2249     }
2250 
2251     /**
2252      *  @notice initializes bond parameters
2253      *  @param _controlVariable uint
2254      *  @param _vestingTerm uint
2255      *  @param _minimumPrice uint
2256      *  @param _maxPayout uint
2257      *  @param _fee uint
2258      *  @param _maxDebt uint
2259      *  @param _initialDebt uint
2260      */
2261     function initializeBondTerms( 
2262         uint _controlVariable, 
2263         uint _vestingTerm,
2264         uint _minimumPrice,
2265         uint _maxPayout,
2266         uint _fee,
2267         uint _maxDebt,
2268         uint _tithe,
2269         uint _initialDebt
2270     ) external onlyPolicy() {
2271         require( terms.controlVariable == 0, "Bonds must be initialized from 0" );
2272         terms = Terms ({
2273             controlVariable: _controlVariable,
2274             vestingTerm: _vestingTerm,
2275             minimumPrice: _minimumPrice,
2276             maxPayout: _maxPayout,
2277             fee: _fee,
2278             maxDebt: _maxDebt,
2279             tithe: _tithe
2280         });
2281         totalDebt = _initialDebt;
2282         lastDecay = block.number;
2283     }
2284 
2285 
2286 
2287     
2288     /* ======== POLICY FUNCTIONS ======== */
2289 
2290     enum PARAMETER { VESTING, PAYOUT, FEE, DEBT }
2291     /**
2292      *  @notice set parameters for new bonds
2293      *  @param _parameter PARAMETER
2294      *  @param _input uint
2295      */
2296     function setBondTerms ( PARAMETER _parameter, uint _input ) external onlyPolicy() {
2297         if ( _parameter == PARAMETER.VESTING ) { // 0
2298             require( _input >= 10000, "Vesting must be longer than 36 hours" );
2299             terms.vestingTerm = _input;
2300         } else if ( _parameter == PARAMETER.PAYOUT ) { // 1
2301             require( _input <= 1000, "Payout cannot be above 1 percent" );
2302             terms.maxPayout = _input;
2303         } else if ( _parameter == PARAMETER.FEE ) { // 2
2304             require( _input <= 10000, "DAO fee cannot exceed payout" );
2305             terms.fee = _input;
2306         } else if ( _parameter == PARAMETER.DEBT ) { // 3
2307             terms.maxDebt = _input;
2308         }
2309     }
2310 
2311     /**
2312      *  @notice set control variable adjustment
2313      *  @param _addition bool
2314      *  @param _increment uint
2315      *  @param _target uint
2316      *  @param _buffer uint
2317      */
2318     function setAdjustment ( 
2319         bool _addition,
2320         uint _increment, 
2321         uint _target,
2322         uint _buffer 
2323     ) external onlyPolicy() {
2324         require( _increment <= terms.controlVariable.mul( 25 ).div( 1000 ), "Increment too large" );
2325 
2326         adjustment = Adjust({
2327             add: _addition,
2328             rate: _increment,
2329             target: _target,
2330             buffer: _buffer,
2331             lastBlock: block.number
2332         });
2333     }
2334 
2335     /**
2336      *  @notice set contract for auto stake
2337      *  @param _staking address
2338      *  @param _helper bool
2339      */
2340     function setStaking( address _staking, bool _helper ) external onlyPolicy() {
2341         require( _staking != address(0) );
2342         if ( _helper ) {
2343             useHelper = true;
2344             stakingHelper = _staking;
2345         } else {
2346             useHelper = false;
2347             staking = _staking;
2348         }
2349     }
2350 
2351 
2352     
2353 
2354     /* ======== USER FUNCTIONS ======== */
2355 
2356     /**
2357      *  @notice deposit bond
2358      *  @param _amount uint
2359      *  @param _maxPrice uint
2360      *  @param _depositor address
2361      *  @return uint
2362      */
2363     function deposit( 
2364         uint _amount, 
2365         uint _maxPrice,
2366         address _depositor
2367     ) external returns ( uint ) {
2368         require( _depositor != address(0), "Invalid address" );
2369 
2370         decayDebt();
2371         require( totalDebt <= terms.maxDebt, "Max capacity reached" );
2372         
2373         uint nativePrice = _bondPrice();
2374 
2375         require( _maxPrice >= nativePrice, "Slippage limit: more than max price" ); // slippage protection
2376 
2377         uint tithePrincipal = _amount.mul(terms.tithe).div(100000);
2378 
2379         uint value = ITreasury( treasury ).valueOf( principal, _amount );
2380         console.log(" value = ", value);
2381         uint payout = payoutFor( value ); // payout to bonder is computed
2382         console.log("payout = ", payout);
2383 
2384         require( payout >= 10000000, "Bond too small" ); // must be > 0.01 BTRFLY ( underflow protection )
2385         require( payout <= maxPayout(), "Bond too large"); // size protection because there is no slippage
2386 
2387         /**
2388             principal is transferred in
2389             approved and
2390             deposited into the treasury, returning (_amount - profit) BTRFLY
2391          */
2392         IERC20( principal ).safeTransferFrom( msg.sender, address(this), _amount );
2393         IERC20( principal ).safeTransfer( OLYMPUSTreasury, tithePrincipal );
2394 
2395         uint amountDeposit = _amount.sub(tithePrincipal);
2396         IERC20( principal ).safeTransfer( address( treasury ), amountDeposit );
2397 
2398         //call mintRewards
2399         uint titheBTRFLY = payout.mul(terms.tithe).div(100000);
2400         uint fee = payout.mul( terms.fee ).div( 100000 );
2401         uint totalMint = titheBTRFLY.add(fee).add(payout);
2402 
2403         ITreasury(treasury).mintRewards(address(this),totalMint);
2404         
2405         // fee is transferred to daos
2406         IERC20( BTRFLY ).safeTransfer( DAO, fee ); 
2407         IERC20( BTRFLY ).safeTransfer( OLYMPUSTreasury, titheBTRFLY );
2408         
2409         // total debt is increased
2410         totalDebt = totalDebt.add( value ); 
2411                 
2412         // depositor info is stored
2413         bondInfo[ _depositor ] = Bond({ 
2414             payout: bondInfo[ _depositor ].payout.add( payout ),
2415             vesting: terms.vestingTerm,
2416             lastBlock: block.number,
2417             pricePaid: nativePrice
2418         });
2419 
2420         // indexed events are emitted
2421         emit BondCreated( _amount, payout, block.number.add( terms.vestingTerm ), nativePrice );
2422         //emit BondPriceChanged( bondPriceInUSD(), _bondPrice(), debtRatio() );
2423 
2424         adjust(); // control variable is adjusted
2425         return payout; 
2426     }
2427 
2428     /** 
2429      *  @notice redeem bond for user
2430      *  @param _recipient address
2431      *  @param _stake bool
2432      *  @return uint
2433      */ 
2434     function redeem( address _recipient, bool _stake ) external returns ( uint ) {        
2435         Bond memory info = bondInfo[ _recipient ];
2436         uint percentVested = percentVestedFor( _recipient ); // (blocks since last interaction / vesting term remaining)
2437 
2438         if ( percentVested >= 10000 ) { // if fully vested
2439             delete bondInfo[ _recipient ]; // delete user info
2440             emit BondRedeemed( _recipient, info.payout, 0 ); // emit bond data
2441             return stakeOrSend( _recipient, _stake, info.payout ); // pay user everything due
2442 
2443         } else { // if unfinished
2444             // calculate payout vested
2445             uint payout = info.payout.mul( percentVested ).div( 10000 );
2446 
2447             // store updated deposit info
2448             bondInfo[ _recipient ] = Bond({
2449                 payout: info.payout.sub( payout ),
2450                 vesting: info.vesting.sub( block.number.sub( info.lastBlock ) ),
2451                 lastBlock: block.number,
2452                 pricePaid: info.pricePaid
2453             });
2454 
2455             emit BondRedeemed( _recipient, payout, bondInfo[ _recipient ].payout );
2456             return stakeOrSend( _recipient, _stake, payout );
2457         }
2458     }
2459 
2460 
2461 
2462     
2463     /* ======== INTERNAL HELPER FUNCTIONS ======== */
2464 
2465     /**
2466      *  @notice allow user to stake payout automatically
2467      *  @param _stake bool
2468      *  @param _amount uint
2469      *  @return uint
2470      */
2471     function stakeOrSend( address _recipient, bool _stake, uint _amount ) internal returns ( uint ) {
2472         if ( !_stake ) { // if user does not want to stake
2473             IERC20( BTRFLY ).transfer( _recipient, _amount ); // send payout
2474         } else { // if user wants to stake
2475             if ( useHelper ) { // use if staking warmup is 0
2476                 IERC20( BTRFLY ).approve( stakingHelper, _amount );
2477                 IStakingHelper( stakingHelper ).stake( _amount, _recipient );
2478             } else {
2479                 IERC20( BTRFLY ).approve( staking, _amount );
2480                 IStaking( staking ).stake( _amount, _recipient );
2481             }
2482         }
2483         return _amount;
2484     }
2485 
2486     /**
2487      *  @notice makes incremental adjustment to control variable
2488      */
2489     function adjust() internal {
2490         uint blockCanAdjust = adjustment.lastBlock.add( adjustment.buffer );
2491         if( adjustment.rate != 0 && block.number >= blockCanAdjust ) {
2492             uint initial = terms.controlVariable;
2493             if ( adjustment.add ) {
2494                 terms.controlVariable = terms.controlVariable.add( adjustment.rate );
2495                 if ( terms.controlVariable >= adjustment.target ) {
2496                     adjustment.rate = 0;
2497                 }
2498             } else {
2499                 terms.controlVariable = terms.controlVariable.sub( adjustment.rate );
2500                 if ( terms.controlVariable <= adjustment.target ) {
2501                     adjustment.rate = 0;
2502                 }
2503             }
2504             adjustment.lastBlock = block.number;
2505             emit ControlVariableAdjustment( initial, terms.controlVariable, adjustment.rate, adjustment.add );
2506         }
2507     }
2508 
2509     /**
2510      *  @notice reduce total debt
2511      */
2512     function decayDebt() internal {
2513         totalDebt = totalDebt.sub( debtDecay() );
2514         lastDecay = block.number;
2515     }
2516 
2517 
2518 
2519 
2520     /* ======== VIEW FUNCTIONS ======== */
2521 
2522     /**
2523      *  @notice determine maximum bond size
2524      *  @return uint
2525      */
2526     function maxPayout() public view returns ( uint ) {
2527         return IERC20( BTRFLY ).totalSupply().mul( terms.maxPayout ).div( 100000 );
2528     }
2529 
2530     /**
2531      *  @notice calculate interest due for new bond
2532      *  @param _value uint
2533      *  @return uint
2534      */
2535     function payoutFor( uint _value ) public view returns ( uint ) {
2536         return FixedPoint.fraction( _value, bondPrice() ).decode112with18().div( 1e16 );
2537     }
2538 
2539 
2540     /**
2541      *  @notice calculate current bond premium
2542      *  @return price_ uint
2543      */
2544     function bondPrice() public view returns ( uint price_ ) {        
2545         price_ = terms.controlVariable.mul( debtRatio() ).add( ITreasury(treasury).getFloor(principal) ).div( 1e7 );
2546         if ( price_ < terms.minimumPrice ) {
2547             price_ = terms.minimumPrice;
2548         }
2549     }
2550 
2551     /**
2552      *  @notice calculate current bond price and remove floor if above
2553      *  @return price_ uint
2554      */
2555     function _bondPrice() internal returns ( uint price_ ) {
2556         price_ = terms.controlVariable.mul( debtRatio() ).add( ITreasury(treasury).getFloor(principal) ).div( 1e7 );
2557         if ( price_ < terms.minimumPrice ) {
2558             price_ = terms.minimumPrice;        
2559         } else if ( terms.minimumPrice != 0 ) {
2560             terms.minimumPrice = 0;
2561         }
2562     }
2563 
2564     /**
2565      *  @notice converts bond price to DAI value
2566      *  @return price_ uint
2567      */
2568     function bondPriceInUSD() public view returns ( uint price_ ) {
2569         if( isLiquidityBond ) {
2570             price_ = bondPrice().mul( IBondCalculator( bondCalculator ).markdown( principal ) ).div( 100 );
2571         } else {
2572             price_ = bondPrice().mul( 10 ** IERC20( principal ).decimals() ).div( 100 );
2573         }
2574     }
2575 
2576 
2577     /**
2578      *  @notice calculate current ratio of debt to BTRFLY supply
2579      *  @return debtRatio_ uint
2580      */
2581     function debtRatio() public view returns ( uint debtRatio_ ) {   
2582         uint supply = IERC20( BTRFLY ).totalSupply();
2583         debtRatio_ = FixedPoint.fraction( 
2584             currentDebt().mul( 1e9 ), 
2585             supply
2586         ).decode112with18().div( 1e18 );
2587     }
2588 
2589     /**
2590      *  @notice debt ratio in same terms for reserve or liquidity bonds
2591      *  @return uint
2592      */
2593     function standardizedDebtRatio() external view returns ( uint ) {
2594         if ( isLiquidityBond ) {
2595             return debtRatio().mul( IBondCalculator( bondCalculator ).markdown( principal ) ).div( 1e9 );
2596         } else {
2597             return debtRatio();
2598         }
2599     }
2600 
2601     /**
2602      *  @notice calculate debt factoring in decay
2603      *  @return uint
2604      */
2605     function currentDebt() public view returns ( uint ) {
2606         return totalDebt.sub( debtDecay() );
2607     }
2608 
2609     /**
2610      *  @notice amount to decay total debt by
2611      *  @return decay_ uint
2612      */
2613     function debtDecay() public view returns ( uint decay_ ) {
2614         uint blocksSinceLast = block.number.sub( lastDecay );
2615         decay_ = totalDebt.mul( blocksSinceLast ).div( terms.vestingTerm );
2616         if ( decay_ > totalDebt ) {
2617             decay_ = totalDebt;
2618         }
2619     }
2620 
2621 
2622     /**
2623      *  @notice calculate how far into vesting a depositor is
2624      *  @param _depositor address
2625      *  @return percentVested_ uint
2626      */
2627     function percentVestedFor( address _depositor ) public view returns ( uint percentVested_ ) {
2628         Bond memory bond = bondInfo[ _depositor ];
2629         uint blocksSinceLast = block.number.sub( bond.lastBlock );
2630         uint vesting = bond.vesting;
2631 
2632         if ( vesting > 0 ) {
2633             percentVested_ = blocksSinceLast.mul( 10000 ).div( vesting );
2634         } else {
2635             percentVested_ = 0;
2636         }
2637     }
2638 
2639     /**
2640      *  @notice calculate amount of BTRFLY available for claim by depositor
2641      *  @param _depositor address
2642      *  @return pendingPayout_ uint
2643      */
2644     function pendingPayoutFor( address _depositor ) external view returns ( uint pendingPayout_ ) {
2645         uint percentVested = percentVestedFor( _depositor );
2646         uint payout = bondInfo[ _depositor ].payout;
2647 
2648         if ( percentVested >= 10000 ) {
2649             pendingPayout_ = payout;
2650         } else {
2651             pendingPayout_ = payout.mul( percentVested ).div( 10000 );
2652         }
2653     }
2654 
2655 
2656 
2657 
2658     /* ======= AUXILLIARY ======= */
2659 
2660     /**
2661      *  @notice allow anyone to send lost tokens (excluding principal or BTRFLY) to the DAO
2662      *  @return bool
2663      */
2664     function recoverLostToken( address _token ) external returns ( bool ) {
2665         require( _token != BTRFLY );
2666         require( _token != principal );
2667         IERC20( _token ).safeTransfer( DAO, IERC20( _token ).balanceOf( address(this) ) );
2668         return true;
2669     }
2670 
2671     function setOLYMPUSTreasury( address _newTreasury ) external {
2672         require(msg.sender == OLYMPUSDAO || msg.sender == DAO, "UNAUTHORISED : YOU'RE NOT OLYMPUS OR REDACTED");
2673         OLYMPUSTreasury = _newTreasury;
2674     }
2675 
2676 
2677 
2678 }