1 pragma solidity ^0.8.0;
2 
3 
4 
5 library console {
6 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
7 
8 	function _sendLogPayload(bytes memory payload) private view {
9 		uint256 payloadLength = payload.length;
10 		address consoleAddress = CONSOLE_ADDRESS;
11 		assembly {
12 			let payloadStart := add(payload, 32)
13 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
14 		}
15 	}
16 
17 	function log() internal view {
18 		_sendLogPayload(abi.encodeWithSignature("log()"));
19 	}
20 
21 	function logInt(int p0) internal view {
22 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
23 	}
24 
25 	function logUint(uint p0) internal view {
26 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
27 	}
28 
29 	function logString(string memory p0) internal view {
30 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
31 	}
32 
33 	function logBool(bool p0) internal view {
34 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
35 	}
36 
37 	function logAddress(address p0) internal view {
38 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
39 	}
40 
41 	function logBytes(bytes memory p0) internal view {
42 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
43 	}
44 
45 	function logBytes1(bytes1 p0) internal view {
46 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
47 	}
48 
49 	function logBytes2(bytes2 p0) internal view {
50 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
51 	}
52 
53 	function logBytes3(bytes3 p0) internal view {
54 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
55 	}
56 
57 	function logBytes4(bytes4 p0) internal view {
58 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
59 	}
60 
61 	function logBytes5(bytes5 p0) internal view {
62 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
63 	}
64 
65 	function logBytes6(bytes6 p0) internal view {
66 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
67 	}
68 
69 	function logBytes7(bytes7 p0) internal view {
70 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
71 	}
72 
73 	function logBytes8(bytes8 p0) internal view {
74 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
75 	}
76 
77 	function logBytes9(bytes9 p0) internal view {
78 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
79 	}
80 
81 	function logBytes10(bytes10 p0) internal view {
82 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
83 	}
84 
85 	function logBytes11(bytes11 p0) internal view {
86 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
87 	}
88 
89 	function logBytes12(bytes12 p0) internal view {
90 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
91 	}
92 
93 	function logBytes13(bytes13 p0) internal view {
94 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
95 	}
96 
97 	function logBytes14(bytes14 p0) internal view {
98 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
99 	}
100 
101 	function logBytes15(bytes15 p0) internal view {
102 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
103 	}
104 
105 	function logBytes16(bytes16 p0) internal view {
106 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
107 	}
108 
109 	function logBytes17(bytes17 p0) internal view {
110 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
111 	}
112 
113 	function logBytes18(bytes18 p0) internal view {
114 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
115 	}
116 
117 	function logBytes19(bytes19 p0) internal view {
118 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
119 	}
120 
121 	function logBytes20(bytes20 p0) internal view {
122 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
123 	}
124 
125 	function logBytes21(bytes21 p0) internal view {
126 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
127 	}
128 
129 	function logBytes22(bytes22 p0) internal view {
130 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
131 	}
132 
133 	function logBytes23(bytes23 p0) internal view {
134 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
135 	}
136 
137 	function logBytes24(bytes24 p0) internal view {
138 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
139 	}
140 
141 	function logBytes25(bytes25 p0) internal view {
142 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
143 	}
144 
145 	function logBytes26(bytes26 p0) internal view {
146 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
147 	}
148 
149 	function logBytes27(bytes27 p0) internal view {
150 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
151 	}
152 
153 	function logBytes28(bytes28 p0) internal view {
154 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
155 	}
156 
157 	function logBytes29(bytes29 p0) internal view {
158 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
159 	}
160 
161 	function logBytes30(bytes30 p0) internal view {
162 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
163 	}
164 
165 	function logBytes31(bytes31 p0) internal view {
166 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
167 	}
168 
169 	function logBytes32(bytes32 p0) internal view {
170 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
171 	}
172 
173 	function log(uint p0) internal view {
174 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
175 	}
176 
177 	function log(string memory p0) internal view {
178 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
179 	}
180 
181 	function log(bool p0) internal view {
182 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
183 	}
184 
185 	function log(address p0) internal view {
186 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
187 	}
188 
189 	function log(uint p0, uint p1) internal view {
190 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
191 	}
192 
193 	function log(uint p0, string memory p1) internal view {
194 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
195 	}
196 
197 	function log(uint p0, bool p1) internal view {
198 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
199 	}
200 
201 	function log(uint p0, address p1) internal view {
202 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
203 	}
204 
205 	function log(string memory p0, uint p1) internal view {
206 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
207 	}
208 
209 	function log(string memory p0, string memory p1) internal view {
210 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
211 	}
212 
213 	function log(string memory p0, bool p1) internal view {
214 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
215 	}
216 
217 	function log(string memory p0, address p1) internal view {
218 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
219 	}
220 
221 	function log(bool p0, uint p1) internal view {
222 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
223 	}
224 
225 	function log(bool p0, string memory p1) internal view {
226 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
227 	}
228 
229 	function log(bool p0, bool p1) internal view {
230 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
231 	}
232 
233 	function log(bool p0, address p1) internal view {
234 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
235 	}
236 
237 	function log(address p0, uint p1) internal view {
238 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
239 	}
240 
241 	function log(address p0, string memory p1) internal view {
242 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
243 	}
244 
245 	function log(address p0, bool p1) internal view {
246 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
247 	}
248 
249 	function log(address p0, address p1) internal view {
250 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
251 	}
252 
253 	function log(uint p0, uint p1, uint p2) internal view {
254 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
255 	}
256 
257 	function log(uint p0, uint p1, string memory p2) internal view {
258 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
259 	}
260 
261 	function log(uint p0, uint p1, bool p2) internal view {
262 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
263 	}
264 
265 	function log(uint p0, uint p1, address p2) internal view {
266 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
267 	}
268 
269 	function log(uint p0, string memory p1, uint p2) internal view {
270 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
271 	}
272 
273 	function log(uint p0, string memory p1, string memory p2) internal view {
274 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
275 	}
276 
277 	function log(uint p0, string memory p1, bool p2) internal view {
278 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
279 	}
280 
281 	function log(uint p0, string memory p1, address p2) internal view {
282 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
283 	}
284 
285 	function log(uint p0, bool p1, uint p2) internal view {
286 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
287 	}
288 
289 	function log(uint p0, bool p1, string memory p2) internal view {
290 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
291 	}
292 
293 	function log(uint p0, bool p1, bool p2) internal view {
294 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
295 	}
296 
297 	function log(uint p0, bool p1, address p2) internal view {
298 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
299 	}
300 
301 	function log(uint p0, address p1, uint p2) internal view {
302 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
303 	}
304 
305 	function log(uint p0, address p1, string memory p2) internal view {
306 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
307 	}
308 
309 	function log(uint p0, address p1, bool p2) internal view {
310 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
311 	}
312 
313 	function log(uint p0, address p1, address p2) internal view {
314 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
315 	}
316 
317 	function log(string memory p0, uint p1, uint p2) internal view {
318 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
319 	}
320 
321 	function log(string memory p0, uint p1, string memory p2) internal view {
322 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
323 	}
324 
325 	function log(string memory p0, uint p1, bool p2) internal view {
326 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
327 	}
328 
329 	function log(string memory p0, uint p1, address p2) internal view {
330 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
331 	}
332 
333 	function log(string memory p0, string memory p1, uint p2) internal view {
334 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
335 	}
336 
337 	function log(string memory p0, string memory p1, string memory p2) internal view {
338 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
339 	}
340 
341 	function log(string memory p0, string memory p1, bool p2) internal view {
342 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
343 	}
344 
345 	function log(string memory p0, string memory p1, address p2) internal view {
346 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
347 	}
348 
349 	function log(string memory p0, bool p1, uint p2) internal view {
350 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
351 	}
352 
353 	function log(string memory p0, bool p1, string memory p2) internal view {
354 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
355 	}
356 
357 	function log(string memory p0, bool p1, bool p2) internal view {
358 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
359 	}
360 
361 	function log(string memory p0, bool p1, address p2) internal view {
362 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
363 	}
364 
365 	function log(string memory p0, address p1, uint p2) internal view {
366 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
367 	}
368 
369 	function log(string memory p0, address p1, string memory p2) internal view {
370 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
371 	}
372 
373 	function log(string memory p0, address p1, bool p2) internal view {
374 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
375 	}
376 
377 	function log(string memory p0, address p1, address p2) internal view {
378 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
379 	}
380 
381 	function log(bool p0, uint p1, uint p2) internal view {
382 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
383 	}
384 
385 	function log(bool p0, uint p1, string memory p2) internal view {
386 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
387 	}
388 
389 	function log(bool p0, uint p1, bool p2) internal view {
390 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
391 	}
392 
393 	function log(bool p0, uint p1, address p2) internal view {
394 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
395 	}
396 
397 	function log(bool p0, string memory p1, uint p2) internal view {
398 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
399 	}
400 
401 	function log(bool p0, string memory p1, string memory p2) internal view {
402 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
403 	}
404 
405 	function log(bool p0, string memory p1, bool p2) internal view {
406 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
407 	}
408 
409 	function log(bool p0, string memory p1, address p2) internal view {
410 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
411 	}
412 
413 	function log(bool p0, bool p1, uint p2) internal view {
414 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
415 	}
416 
417 	function log(bool p0, bool p1, string memory p2) internal view {
418 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
419 	}
420 
421 	function log(bool p0, bool p1, bool p2) internal view {
422 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
423 	}
424 
425 	function log(bool p0, bool p1, address p2) internal view {
426 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
427 	}
428 
429 	function log(bool p0, address p1, uint p2) internal view {
430 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
431 	}
432 
433 	function log(bool p0, address p1, string memory p2) internal view {
434 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
435 	}
436 
437 	function log(bool p0, address p1, bool p2) internal view {
438 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
439 	}
440 
441 	function log(bool p0, address p1, address p2) internal view {
442 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
443 	}
444 
445 	function log(address p0, uint p1, uint p2) internal view {
446 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
447 	}
448 
449 	function log(address p0, uint p1, string memory p2) internal view {
450 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
451 	}
452 
453 	function log(address p0, uint p1, bool p2) internal view {
454 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
455 	}
456 
457 	function log(address p0, uint p1, address p2) internal view {
458 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
459 	}
460 
461 	function log(address p0, string memory p1, uint p2) internal view {
462 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
463 	}
464 
465 	function log(address p0, string memory p1, string memory p2) internal view {
466 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
467 	}
468 
469 	function log(address p0, string memory p1, bool p2) internal view {
470 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
471 	}
472 
473 	function log(address p0, string memory p1, address p2) internal view {
474 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
475 	}
476 
477 	function log(address p0, bool p1, uint p2) internal view {
478 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
479 	}
480 
481 	function log(address p0, bool p1, string memory p2) internal view {
482 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
483 	}
484 
485 	function log(address p0, bool p1, bool p2) internal view {
486 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
487 	}
488 
489 	function log(address p0, bool p1, address p2) internal view {
490 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
491 	}
492 
493 	function log(address p0, address p1, uint p2) internal view {
494 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
495 	}
496 
497 	function log(address p0, address p1, string memory p2) internal view {
498 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
499 	}
500 
501 	function log(address p0, address p1, bool p2) internal view {
502 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
503 	}
504 
505 	function log(address p0, address p1, address p2) internal view {
506 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
507 	}
508 
509 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
510 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
511 	}
512 
513 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
514 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
515 	}
516 
517 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
518 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
519 	}
520 
521 	function log(uint p0, uint p1, uint p2, address p3) internal view {
522 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
523 	}
524 
525 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
526 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
527 	}
528 
529 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
530 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
531 	}
532 
533 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
534 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
535 	}
536 
537 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
538 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
539 	}
540 
541 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
542 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
543 	}
544 
545 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
546 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
547 	}
548 
549 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
550 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
551 	}
552 
553 	function log(uint p0, uint p1, bool p2, address p3) internal view {
554 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
555 	}
556 
557 	function log(uint p0, uint p1, address p2, uint p3) internal view {
558 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
559 	}
560 
561 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
562 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
563 	}
564 
565 	function log(uint p0, uint p1, address p2, bool p3) internal view {
566 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
567 	}
568 
569 	function log(uint p0, uint p1, address p2, address p3) internal view {
570 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
571 	}
572 
573 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
574 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
575 	}
576 
577 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
578 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
579 	}
580 
581 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
582 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
583 	}
584 
585 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
586 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
587 	}
588 
589 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
590 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
591 	}
592 
593 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
594 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
595 	}
596 
597 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
598 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
599 	}
600 
601 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
602 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
603 	}
604 
605 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
606 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
607 	}
608 
609 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
610 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
611 	}
612 
613 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
614 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
615 	}
616 
617 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
618 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
619 	}
620 
621 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
622 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
623 	}
624 
625 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
626 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
627 	}
628 
629 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
630 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
631 	}
632 
633 	function log(uint p0, string memory p1, address p2, address p3) internal view {
634 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
635 	}
636 
637 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
638 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
639 	}
640 
641 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
642 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
643 	}
644 
645 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
646 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
647 	}
648 
649 	function log(uint p0, bool p1, uint p2, address p3) internal view {
650 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
651 	}
652 
653 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
654 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
655 	}
656 
657 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
658 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
659 	}
660 
661 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
662 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
663 	}
664 
665 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
666 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
667 	}
668 
669 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
670 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
671 	}
672 
673 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
674 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
675 	}
676 
677 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
678 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
679 	}
680 
681 	function log(uint p0, bool p1, bool p2, address p3) internal view {
682 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
683 	}
684 
685 	function log(uint p0, bool p1, address p2, uint p3) internal view {
686 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
687 	}
688 
689 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
690 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
691 	}
692 
693 	function log(uint p0, bool p1, address p2, bool p3) internal view {
694 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
695 	}
696 
697 	function log(uint p0, bool p1, address p2, address p3) internal view {
698 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
699 	}
700 
701 	function log(uint p0, address p1, uint p2, uint p3) internal view {
702 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
703 	}
704 
705 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
706 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
707 	}
708 
709 	function log(uint p0, address p1, uint p2, bool p3) internal view {
710 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
711 	}
712 
713 	function log(uint p0, address p1, uint p2, address p3) internal view {
714 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
715 	}
716 
717 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
718 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
719 	}
720 
721 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
722 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
723 	}
724 
725 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
726 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
727 	}
728 
729 	function log(uint p0, address p1, string memory p2, address p3) internal view {
730 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
731 	}
732 
733 	function log(uint p0, address p1, bool p2, uint p3) internal view {
734 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
735 	}
736 
737 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
738 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
739 	}
740 
741 	function log(uint p0, address p1, bool p2, bool p3) internal view {
742 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
743 	}
744 
745 	function log(uint p0, address p1, bool p2, address p3) internal view {
746 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
747 	}
748 
749 	function log(uint p0, address p1, address p2, uint p3) internal view {
750 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
751 	}
752 
753 	function log(uint p0, address p1, address p2, string memory p3) internal view {
754 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
755 	}
756 
757 	function log(uint p0, address p1, address p2, bool p3) internal view {
758 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
759 	}
760 
761 	function log(uint p0, address p1, address p2, address p3) internal view {
762 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
763 	}
764 
765 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
766 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
767 	}
768 
769 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
770 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
771 	}
772 
773 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
774 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
775 	}
776 
777 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
778 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
779 	}
780 
781 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
782 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
783 	}
784 
785 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
786 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
787 	}
788 
789 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
790 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
791 	}
792 
793 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
794 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
795 	}
796 
797 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
798 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
799 	}
800 
801 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
802 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
803 	}
804 
805 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
806 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
807 	}
808 
809 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
810 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
811 	}
812 
813 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
814 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
815 	}
816 
817 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
818 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
819 	}
820 
821 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
822 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
823 	}
824 
825 	function log(string memory p0, uint p1, address p2, address p3) internal view {
826 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
827 	}
828 
829 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
830 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
831 	}
832 
833 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
834 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
835 	}
836 
837 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
838 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
839 	}
840 
841 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
842 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
843 	}
844 
845 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
846 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
847 	}
848 
849 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
850 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
851 	}
852 
853 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
854 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
855 	}
856 
857 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
858 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
859 	}
860 
861 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
862 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
863 	}
864 
865 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
866 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
867 	}
868 
869 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
870 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
871 	}
872 
873 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
874 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
875 	}
876 
877 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
878 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
879 	}
880 
881 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
882 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
883 	}
884 
885 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
886 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
887 	}
888 
889 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
890 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
891 	}
892 
893 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
894 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
895 	}
896 
897 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
898 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
899 	}
900 
901 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
902 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
903 	}
904 
905 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
906 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
907 	}
908 
909 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
910 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
911 	}
912 
913 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
914 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
915 	}
916 
917 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
918 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
919 	}
920 
921 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
922 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
923 	}
924 
925 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
926 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
927 	}
928 
929 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
930 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
931 	}
932 
933 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
934 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
935 	}
936 
937 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
938 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
939 	}
940 
941 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
942 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
943 	}
944 
945 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
946 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
947 	}
948 
949 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
950 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
951 	}
952 
953 	function log(string memory p0, bool p1, address p2, address p3) internal view {
954 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
955 	}
956 
957 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
958 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
959 	}
960 
961 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
962 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
963 	}
964 
965 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
966 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
967 	}
968 
969 	function log(string memory p0, address p1, uint p2, address p3) internal view {
970 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
971 	}
972 
973 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
974 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
975 	}
976 
977 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
978 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
979 	}
980 
981 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
982 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
983 	}
984 
985 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
986 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
987 	}
988 
989 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
990 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
991 	}
992 
993 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
994 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
995 	}
996 
997 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
998 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
999 	}
1000 
1001 	function log(string memory p0, address p1, bool p2, address p3) internal view {
1002 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
1003 	}
1004 
1005 	function log(string memory p0, address p1, address p2, uint p3) internal view {
1006 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
1007 	}
1008 
1009 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
1010 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
1011 	}
1012 
1013 	function log(string memory p0, address p1, address p2, bool p3) internal view {
1014 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
1015 	}
1016 
1017 	function log(string memory p0, address p1, address p2, address p3) internal view {
1018 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
1019 	}
1020 
1021 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
1022 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
1023 	}
1024 
1025 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
1026 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
1027 	}
1028 
1029 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
1030 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
1031 	}
1032 
1033 	function log(bool p0, uint p1, uint p2, address p3) internal view {
1034 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
1035 	}
1036 
1037 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
1038 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
1039 	}
1040 
1041 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
1042 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
1043 	}
1044 
1045 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
1046 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
1047 	}
1048 
1049 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
1050 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
1051 	}
1052 
1053 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
1054 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
1055 	}
1056 
1057 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
1058 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
1059 	}
1060 
1061 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
1062 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
1063 	}
1064 
1065 	function log(bool p0, uint p1, bool p2, address p3) internal view {
1066 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
1067 	}
1068 
1069 	function log(bool p0, uint p1, address p2, uint p3) internal view {
1070 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
1071 	}
1072 
1073 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
1074 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
1075 	}
1076 
1077 	function log(bool p0, uint p1, address p2, bool p3) internal view {
1078 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
1079 	}
1080 
1081 	function log(bool p0, uint p1, address p2, address p3) internal view {
1082 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
1083 	}
1084 
1085 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
1086 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
1087 	}
1088 
1089 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
1090 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
1091 	}
1092 
1093 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
1094 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
1095 	}
1096 
1097 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
1098 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
1099 	}
1100 
1101 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
1102 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
1103 	}
1104 
1105 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
1106 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
1107 	}
1108 
1109 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
1110 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
1111 	}
1112 
1113 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
1114 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
1115 	}
1116 
1117 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
1118 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
1119 	}
1120 
1121 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
1122 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
1123 	}
1124 
1125 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
1126 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
1127 	}
1128 
1129 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
1130 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
1131 	}
1132 
1133 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
1134 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
1135 	}
1136 
1137 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
1138 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
1139 	}
1140 
1141 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
1142 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
1143 	}
1144 
1145 	function log(bool p0, string memory p1, address p2, address p3) internal view {
1146 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
1147 	}
1148 
1149 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
1150 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
1151 	}
1152 
1153 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
1154 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
1155 	}
1156 
1157 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
1158 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
1159 	}
1160 
1161 	function log(bool p0, bool p1, uint p2, address p3) internal view {
1162 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
1163 	}
1164 
1165 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
1166 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
1167 	}
1168 
1169 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
1170 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
1171 	}
1172 
1173 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
1174 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
1175 	}
1176 
1177 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
1178 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
1179 	}
1180 
1181 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
1182 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
1183 	}
1184 
1185 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
1186 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
1187 	}
1188 
1189 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
1190 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
1191 	}
1192 
1193 	function log(bool p0, bool p1, bool p2, address p3) internal view {
1194 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
1195 	}
1196 
1197 	function log(bool p0, bool p1, address p2, uint p3) internal view {
1198 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
1199 	}
1200 
1201 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
1202 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
1203 	}
1204 
1205 	function log(bool p0, bool p1, address p2, bool p3) internal view {
1206 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
1207 	}
1208 
1209 	function log(bool p0, bool p1, address p2, address p3) internal view {
1210 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
1211 	}
1212 
1213 	function log(bool p0, address p1, uint p2, uint p3) internal view {
1214 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
1215 	}
1216 
1217 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
1218 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
1219 	}
1220 
1221 	function log(bool p0, address p1, uint p2, bool p3) internal view {
1222 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
1223 	}
1224 
1225 	function log(bool p0, address p1, uint p2, address p3) internal view {
1226 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
1227 	}
1228 
1229 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
1230 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
1231 	}
1232 
1233 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
1234 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
1235 	}
1236 
1237 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
1238 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
1239 	}
1240 
1241 	function log(bool p0, address p1, string memory p2, address p3) internal view {
1242 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
1243 	}
1244 
1245 	function log(bool p0, address p1, bool p2, uint p3) internal view {
1246 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
1247 	}
1248 
1249 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
1250 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
1251 	}
1252 
1253 	function log(bool p0, address p1, bool p2, bool p3) internal view {
1254 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
1255 	}
1256 
1257 	function log(bool p0, address p1, bool p2, address p3) internal view {
1258 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
1259 	}
1260 
1261 	function log(bool p0, address p1, address p2, uint p3) internal view {
1262 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
1263 	}
1264 
1265 	function log(bool p0, address p1, address p2, string memory p3) internal view {
1266 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
1267 	}
1268 
1269 	function log(bool p0, address p1, address p2, bool p3) internal view {
1270 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
1271 	}
1272 
1273 	function log(bool p0, address p1, address p2, address p3) internal view {
1274 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
1275 	}
1276 
1277 	function log(address p0, uint p1, uint p2, uint p3) internal view {
1278 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
1279 	}
1280 
1281 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
1282 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
1283 	}
1284 
1285 	function log(address p0, uint p1, uint p2, bool p3) internal view {
1286 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
1287 	}
1288 
1289 	function log(address p0, uint p1, uint p2, address p3) internal view {
1290 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
1291 	}
1292 
1293 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
1294 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
1295 	}
1296 
1297 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
1298 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
1299 	}
1300 
1301 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
1302 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
1303 	}
1304 
1305 	function log(address p0, uint p1, string memory p2, address p3) internal view {
1306 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
1307 	}
1308 
1309 	function log(address p0, uint p1, bool p2, uint p3) internal view {
1310 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
1311 	}
1312 
1313 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
1314 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
1315 	}
1316 
1317 	function log(address p0, uint p1, bool p2, bool p3) internal view {
1318 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
1319 	}
1320 
1321 	function log(address p0, uint p1, bool p2, address p3) internal view {
1322 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
1323 	}
1324 
1325 	function log(address p0, uint p1, address p2, uint p3) internal view {
1326 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
1327 	}
1328 
1329 	function log(address p0, uint p1, address p2, string memory p3) internal view {
1330 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
1331 	}
1332 
1333 	function log(address p0, uint p1, address p2, bool p3) internal view {
1334 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
1335 	}
1336 
1337 	function log(address p0, uint p1, address p2, address p3) internal view {
1338 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
1339 	}
1340 
1341 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
1342 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
1343 	}
1344 
1345 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
1346 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
1347 	}
1348 
1349 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
1350 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
1351 	}
1352 
1353 	function log(address p0, string memory p1, uint p2, address p3) internal view {
1354 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
1355 	}
1356 
1357 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
1358 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
1359 	}
1360 
1361 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
1362 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
1363 	}
1364 
1365 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
1366 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
1367 	}
1368 
1369 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
1370 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
1371 	}
1372 
1373 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
1374 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
1375 	}
1376 
1377 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
1378 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
1379 	}
1380 
1381 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
1382 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
1383 	}
1384 
1385 	function log(address p0, string memory p1, bool p2, address p3) internal view {
1386 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
1387 	}
1388 
1389 	function log(address p0, string memory p1, address p2, uint p3) internal view {
1390 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
1391 	}
1392 
1393 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
1394 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
1395 	}
1396 
1397 	function log(address p0, string memory p1, address p2, bool p3) internal view {
1398 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
1399 	}
1400 
1401 	function log(address p0, string memory p1, address p2, address p3) internal view {
1402 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
1403 	}
1404 
1405 	function log(address p0, bool p1, uint p2, uint p3) internal view {
1406 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
1407 	}
1408 
1409 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
1410 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
1411 	}
1412 
1413 	function log(address p0, bool p1, uint p2, bool p3) internal view {
1414 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
1415 	}
1416 
1417 	function log(address p0, bool p1, uint p2, address p3) internal view {
1418 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
1419 	}
1420 
1421 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
1422 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
1423 	}
1424 
1425 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
1426 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
1427 	}
1428 
1429 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
1430 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
1431 	}
1432 
1433 	function log(address p0, bool p1, string memory p2, address p3) internal view {
1434 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
1435 	}
1436 
1437 	function log(address p0, bool p1, bool p2, uint p3) internal view {
1438 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
1439 	}
1440 
1441 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
1442 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
1443 	}
1444 
1445 	function log(address p0, bool p1, bool p2, bool p3) internal view {
1446 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
1447 	}
1448 
1449 	function log(address p0, bool p1, bool p2, address p3) internal view {
1450 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
1451 	}
1452 
1453 	function log(address p0, bool p1, address p2, uint p3) internal view {
1454 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
1455 	}
1456 
1457 	function log(address p0, bool p1, address p2, string memory p3) internal view {
1458 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
1459 	}
1460 
1461 	function log(address p0, bool p1, address p2, bool p3) internal view {
1462 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
1463 	}
1464 
1465 	function log(address p0, bool p1, address p2, address p3) internal view {
1466 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
1467 	}
1468 
1469 	function log(address p0, address p1, uint p2, uint p3) internal view {
1470 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
1471 	}
1472 
1473 	function log(address p0, address p1, uint p2, string memory p3) internal view {
1474 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
1475 	}
1476 
1477 	function log(address p0, address p1, uint p2, bool p3) internal view {
1478 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
1479 	}
1480 
1481 	function log(address p0, address p1, uint p2, address p3) internal view {
1482 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
1483 	}
1484 
1485 	function log(address p0, address p1, string memory p2, uint p3) internal view {
1486 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
1487 	}
1488 
1489 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
1490 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
1491 	}
1492 
1493 	function log(address p0, address p1, string memory p2, bool p3) internal view {
1494 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
1495 	}
1496 
1497 	function log(address p0, address p1, string memory p2, address p3) internal view {
1498 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
1499 	}
1500 
1501 	function log(address p0, address p1, bool p2, uint p3) internal view {
1502 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
1503 	}
1504 
1505 	function log(address p0, address p1, bool p2, string memory p3) internal view {
1506 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
1507 	}
1508 
1509 	function log(address p0, address p1, bool p2, bool p3) internal view {
1510 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
1511 	}
1512 
1513 	function log(address p0, address p1, bool p2, address p3) internal view {
1514 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
1515 	}
1516 
1517 	function log(address p0, address p1, address p2, uint p3) internal view {
1518 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
1519 	}
1520 
1521 	function log(address p0, address p1, address p2, string memory p3) internal view {
1522 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
1523 	}
1524 
1525 	function log(address p0, address p1, address p2, bool p3) internal view {
1526 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
1527 	}
1528 
1529 	function log(address p0, address p1, address p2, address p3) internal view {
1530 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
1531 	}
1532 
1533 }
1534 
1535 
1536 /**
1537  * @dev Interface of the ERC165 standard, as defined in the
1538  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1539  *
1540  * Implementers can declare support of contract interfaces, which can then be
1541  * queried by others ({ERC165Checker}).
1542  *
1543  * For an implementation, see {ERC165}.
1544  */
1545 interface IERC165 {
1546     /**
1547      * @dev Returns true if this contract implements the interface defined by
1548      * `interfaceId`. See the corresponding
1549      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1550      * to learn more about how these ids are created.
1551      *
1552      * This function call must use less than 30 000 gas.
1553      */
1554     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1555 }
1556 
1557 
1558 /**
1559  * @dev Required interface of an ERC721 compliant contract.
1560  */
1561 interface IERC721 is IERC165 {
1562     /**
1563      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1564      */
1565     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1566 
1567     /**
1568      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1569      */
1570     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1571 
1572     /**
1573      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1574      */
1575     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1576 
1577     /**
1578      * @dev Returns the number of tokens in ``owner``'s account.
1579      */
1580     function balanceOf(address owner) external view returns (uint256 balance);
1581 
1582     /**
1583      * @dev Returns the owner of the `tokenId` token.
1584      *
1585      * Requirements:
1586      *
1587      * - `tokenId` must exist.
1588      */
1589     function ownerOf(uint256 tokenId) external view returns (address owner);
1590 
1591     /**
1592      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1593      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1594      *
1595      * Requirements:
1596      *
1597      * - `from` cannot be the zero address.
1598      * - `to` cannot be the zero address.
1599      * - `tokenId` token must exist and be owned by `from`.
1600      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1601      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1602      *
1603      * Emits a {Transfer} event.
1604      */
1605     function safeTransferFrom(
1606         address from,
1607         address to,
1608         uint256 tokenId
1609     ) external;
1610 
1611     /**
1612      * @dev Transfers `tokenId` token from `from` to `to`.
1613      *
1614      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1615      *
1616      * Requirements:
1617      *
1618      * - `from` cannot be the zero address.
1619      * - `to` cannot be the zero address.
1620      * - `tokenId` token must be owned by `from`.
1621      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1622      *
1623      * Emits a {Transfer} event.
1624      */
1625     function transferFrom(
1626         address from,
1627         address to,
1628         uint256 tokenId
1629     ) external;
1630 
1631     /**
1632      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1633      * The approval is cleared when the token is transferred.
1634      *
1635      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1636      *
1637      * Requirements:
1638      *
1639      * - The caller must own the token or be an approved operator.
1640      * - `tokenId` must exist.
1641      *
1642      * Emits an {Approval} event.
1643      */
1644     function approve(address to, uint256 tokenId) external;
1645 
1646     /**
1647      * @dev Returns the account approved for `tokenId` token.
1648      *
1649      * Requirements:
1650      *
1651      * - `tokenId` must exist.
1652      */
1653     function getApproved(uint256 tokenId) external view returns (address operator);
1654 
1655     /**
1656      * @dev Approve or remove `operator` as an operator for the caller.
1657      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1658      *
1659      * Requirements:
1660      *
1661      * - The `operator` cannot be the caller.
1662      *
1663      * Emits an {ApprovalForAll} event.
1664      */
1665     function setApprovalForAll(address operator, bool _approved) external;
1666 
1667     /**
1668      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1669      *
1670      * See {setApprovalForAll}
1671      */
1672     function isApprovedForAll(address owner, address operator) external view returns (bool);
1673 
1674     /**
1675      * @dev Safely transfers `tokenId` token from `from` to `to`.
1676      *
1677      * Requirements:
1678      *
1679      * - `from` cannot be the zero address.
1680      * - `to` cannot be the zero address.
1681      * - `tokenId` token must exist and be owned by `from`.
1682      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1683      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1684      *
1685      * Emits a {Transfer} event.
1686      */
1687     function safeTransferFrom(
1688         address from,
1689         address to,
1690         uint256 tokenId,
1691         bytes calldata data
1692     ) external;
1693 }
1694 
1695 
1696 /**
1697  * @title ERC721 token receiver interface
1698  * @dev Interface for any contract that wants to support safeTransfers
1699  * from ERC721 asset contracts.
1700  */
1701 interface IERC721Receiver {
1702     /**
1703      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1704      * by `operator` from `from`, this function is called.
1705      *
1706      * It must return its Solidity selector to confirm the token transfer.
1707      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1708      *
1709      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1710      */
1711     function onERC721Received(
1712         address operator,
1713         address from,
1714         uint256 tokenId,
1715         bytes calldata data
1716     ) external returns (bytes4);
1717 }
1718 
1719 
1720 /**
1721  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1722  * @dev See https://eips.ethereum.org/EIPS/eip-721
1723  */
1724 interface IERC721Metadata is IERC721 {
1725     /**
1726      * @dev Returns the token collection name.
1727      */
1728     function name() external view returns (string memory);
1729 
1730     /**
1731      * @dev Returns the token collection symbol.
1732      */
1733     function symbol() external view returns (string memory);
1734 
1735     /**
1736      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1737      */
1738     function tokenURI(uint256 tokenId) external view returns (string memory);
1739 }
1740 
1741 
1742 /**
1743  * @dev Collection of functions related to the address type
1744  */
1745 library Address {
1746     /**
1747      * @dev Returns true if `account` is a contract.
1748      *
1749      * [IMPORTANT]
1750      * ====
1751      * It is unsafe to assume that an address for which this function returns
1752      * false is an externally-owned account (EOA) and not a contract.
1753      *
1754      * Among others, `isContract` will return false for the following
1755      * types of addresses:
1756      *
1757      *  - an externally-owned account
1758      *  - a contract in construction
1759      *  - an address where a contract will be created
1760      *  - an address where a contract lived, but was destroyed
1761      * ====
1762      */
1763     function isContract(address account) internal view returns (bool) {
1764         // This method relies on extcodesize, which returns 0 for contracts in
1765         // construction, since the code is only stored at the end of the
1766         // constructor execution.
1767 
1768         uint256 size;
1769         assembly {
1770             size := extcodesize(account)
1771         }
1772         return size > 0;
1773     }
1774 
1775     /**
1776      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1777      * `recipient`, forwarding all available gas and reverting on errors.
1778      *
1779      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1780      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1781      * imposed by `transfer`, making them unable to receive funds via
1782      * `transfer`. {sendValue} removes this limitation.
1783      *
1784      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1785      *
1786      * IMPORTANT: because control is transferred to `recipient`, care must be
1787      * taken to not create reentrancy vulnerabilities. Consider using
1788      * {ReentrancyGuard} or the
1789      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1790      */
1791     function sendValue(address payable recipient, uint256 amount) internal {
1792         require(address(this).balance >= amount, "Address: insufficient balance");
1793 
1794         (bool success, ) = recipient.call{value: amount}("");
1795         require(success, "Address: unable to send value, recipient may have reverted");
1796     }
1797 
1798     /**
1799      * @dev Performs a Solidity function call using a low level `call`. A
1800      * plain `call` is an unsafe replacement for a function call: use this
1801      * function instead.
1802      *
1803      * If `target` reverts with a revert reason, it is bubbled up by this
1804      * function (like regular Solidity function calls).
1805      *
1806      * Returns the raw returned data. To convert to the expected return value,
1807      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1808      *
1809      * Requirements:
1810      *
1811      * - `target` must be a contract.
1812      * - calling `target` with `data` must not revert.
1813      *
1814      * _Available since v3.1._
1815      */
1816     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1817         return functionCall(target, data, "Address: low-level call failed");
1818     }
1819 
1820     /**
1821      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1822      * `errorMessage` as a fallback revert reason when `target` reverts.
1823      *
1824      * _Available since v3.1._
1825      */
1826     function functionCall(
1827         address target,
1828         bytes memory data,
1829         string memory errorMessage
1830     ) internal returns (bytes memory) {
1831         return functionCallWithValue(target, data, 0, errorMessage);
1832     }
1833 
1834     /**
1835      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1836      * but also transferring `value` wei to `target`.
1837      *
1838      * Requirements:
1839      *
1840      * - the calling contract must have an ETH balance of at least `value`.
1841      * - the called Solidity function must be `payable`.
1842      *
1843      * _Available since v3.1._
1844      */
1845     function functionCallWithValue(
1846         address target,
1847         bytes memory data,
1848         uint256 value
1849     ) internal returns (bytes memory) {
1850         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1851     }
1852 
1853     /**
1854      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1855      * with `errorMessage` as a fallback revert reason when `target` reverts.
1856      *
1857      * _Available since v3.1._
1858      */
1859     function functionCallWithValue(
1860         address target,
1861         bytes memory data,
1862         uint256 value,
1863         string memory errorMessage
1864     ) internal returns (bytes memory) {
1865         require(address(this).balance >= value, "Address: insufficient balance for call");
1866         require(isContract(target), "Address: call to non-contract");
1867 
1868         (bool success, bytes memory returndata) = target.call{value: value}(data);
1869         return _verifyCallResult(success, returndata, errorMessage);
1870     }
1871 
1872     /**
1873      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1874      * but performing a static call.
1875      *
1876      * _Available since v3.3._
1877      */
1878     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1879         return functionStaticCall(target, data, "Address: low-level static call failed");
1880     }
1881 
1882     /**
1883      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1884      * but performing a static call.
1885      *
1886      * _Available since v3.3._
1887      */
1888     function functionStaticCall(
1889         address target,
1890         bytes memory data,
1891         string memory errorMessage
1892     ) internal view returns (bytes memory) {
1893         require(isContract(target), "Address: static call to non-contract");
1894 
1895         (bool success, bytes memory returndata) = target.staticcall(data);
1896         return _verifyCallResult(success, returndata, errorMessage);
1897     }
1898 
1899     /**
1900      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1901      * but performing a delegate call.
1902      *
1903      * _Available since v3.4._
1904      */
1905     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1906         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1907     }
1908 
1909     /**
1910      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1911      * but performing a delegate call.
1912      *
1913      * _Available since v3.4._
1914      */
1915     function functionDelegateCall(
1916         address target,
1917         bytes memory data,
1918         string memory errorMessage
1919     ) internal returns (bytes memory) {
1920         require(isContract(target), "Address: delegate call to non-contract");
1921 
1922         (bool success, bytes memory returndata) = target.delegatecall(data);
1923         return _verifyCallResult(success, returndata, errorMessage);
1924     }
1925 
1926     function _verifyCallResult(
1927         bool success,
1928         bytes memory returndata,
1929         string memory errorMessage
1930     ) private pure returns (bytes memory) {
1931         if (success) {
1932             return returndata;
1933         } else {
1934             // Look for revert reason and bubble it up if present
1935             if (returndata.length > 0) {
1936                 // The easiest way to bubble the revert reason is using memory via assembly
1937 
1938                 assembly {
1939                     let returndata_size := mload(returndata)
1940                     revert(add(32, returndata), returndata_size)
1941                 }
1942             } else {
1943                 revert(errorMessage);
1944             }
1945         }
1946     }
1947 }
1948 
1949 
1950 /*
1951  * @dev Provides information about the current execution context, including the
1952  * sender of the transaction and its data. While these are generally available
1953  * via msg.sender and msg.data, they should not be accessed in such a direct
1954  * manner, since when dealing with meta-transactions the account sending and
1955  * paying for execution may not be the actual sender (as far as an application
1956  * is concerned).
1957  *
1958  * This contract is only required for intermediate, library-like contracts.
1959  */
1960 abstract contract Context {
1961     function _msgSender() internal view virtual returns (address) {
1962         return msg.sender;
1963     }
1964 
1965     function _msgData() internal view virtual returns (bytes calldata) {
1966         return msg.data;
1967     }
1968 }
1969 
1970 
1971 /**
1972  * @dev String operations.
1973  */
1974 library Strings {
1975     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1976 
1977     /**
1978      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1979      */
1980     function toString(uint256 value) internal pure returns (string memory) {
1981         // Inspired by OraclizeAPI's implementation - MIT licence
1982         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1983 
1984         if (value == 0) {
1985             return "0";
1986         }
1987         uint256 temp = value;
1988         uint256 digits;
1989         while (temp != 0) {
1990             digits++;
1991             temp /= 10;
1992         }
1993         bytes memory buffer = new bytes(digits);
1994         while (value != 0) {
1995             digits -= 1;
1996             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1997             value /= 10;
1998         }
1999         return string(buffer);
2000     }
2001 
2002     /**
2003      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2004      */
2005     function toHexString(uint256 value) internal pure returns (string memory) {
2006         if (value == 0) {
2007             return "0x00";
2008         }
2009         uint256 temp = value;
2010         uint256 length = 0;
2011         while (temp != 0) {
2012             length++;
2013             temp >>= 8;
2014         }
2015         return toHexString(value, length);
2016     }
2017 
2018     /**
2019      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2020      */
2021     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2022         bytes memory buffer = new bytes(2 * length + 2);
2023         buffer[0] = "0";
2024         buffer[1] = "x";
2025         for (uint256 i = 2 * length + 1; i > 1; --i) {
2026             buffer[i] = _HEX_SYMBOLS[value & 0xf];
2027             value >>= 4;
2028         }
2029         require(value == 0, "Strings: hex length insufficient");
2030         return string(buffer);
2031     }
2032 }
2033 
2034 
2035 /**
2036  * @dev Implementation of the {IERC165} interface.
2037  *
2038  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
2039  * for the additional interface id that will be supported. For example:
2040  *
2041  * ```solidity
2042  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2043  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
2044  * }
2045  * ```
2046  *
2047  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
2048  */
2049 abstract contract ERC165 is IERC165 {
2050     /**
2051      * @dev See {IERC165-supportsInterface}.
2052      */
2053     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2054         return interfaceId == type(IERC165).interfaceId;
2055     }
2056 }
2057 
2058 
2059 /**
2060  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2061  * the Metadata extension, but not including the Enumerable extension, which is available separately as
2062  * {ERC721Enumerable}.
2063  */
2064 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
2065     using Address for address;
2066     using Strings for uint256;
2067 
2068     // Token name
2069     string private _name;
2070 
2071     // Token symbol
2072     string private _symbol;
2073 
2074     // Mapping from token ID to owner address
2075     mapping(uint256 => address) private _owners;
2076 
2077     // Mapping owner address to token count
2078     mapping(address => uint256) private _balances;
2079 
2080     // Mapping from token ID to approved address
2081     mapping(uint256 => address) private _tokenApprovals;
2082 
2083     // Mapping from owner to operator approvals
2084     mapping(address => mapping(address => bool)) private _operatorApprovals;
2085 
2086     /**
2087      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2088      */
2089     constructor(string memory name_, string memory symbol_) {
2090         _name = name_;
2091         _symbol = symbol_;
2092     }
2093 
2094     /**
2095      * @dev See {IERC165-supportsInterface}.
2096      */
2097     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2098         return
2099             interfaceId == type(IERC721).interfaceId ||
2100             interfaceId == type(IERC721Metadata).interfaceId ||
2101             super.supportsInterface(interfaceId);
2102     }
2103 
2104     /**
2105      * @dev See {IERC721-balanceOf}.
2106      */
2107     function balanceOf(address owner) public view virtual override returns (uint256) {
2108         require(owner != address(0), "ERC721: balance query for the zero address");
2109         return _balances[owner];
2110     }
2111 
2112     /**
2113      * @dev See {IERC721-ownerOf}.
2114      */
2115     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2116         address owner = _owners[tokenId];
2117         require(owner != address(0), "ERC721: owner query for nonexistent token");
2118         return owner;
2119     }
2120 
2121     /**
2122      * @dev See {IERC721Metadata-name}.
2123      */
2124     function name() public view virtual override returns (string memory) {
2125         return _name;
2126     }
2127 
2128     /**
2129      * @dev See {IERC721Metadata-symbol}.
2130      */
2131     function symbol() public view virtual override returns (string memory) {
2132         return _symbol;
2133     }
2134 
2135     /**
2136      * @dev See {IERC721Metadata-tokenURI}.
2137      */
2138     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2139         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2140 
2141         string memory baseURI = _baseURI();
2142         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2143     }
2144 
2145     /**
2146      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2147      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2148      * by default, can be overriden in child contracts.
2149      */
2150     function _baseURI() internal view virtual returns (string memory) {
2151         return "";
2152     }
2153 
2154     /**
2155      * @dev See {IERC721-approve}.
2156      */
2157     function approve(address to, uint256 tokenId) public virtual override {
2158         address owner = ERC721.ownerOf(tokenId);
2159         require(to != owner, "ERC721: approval to current owner");
2160 
2161         require(
2162             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2163             "ERC721: approve caller is not owner nor approved for all"
2164         );
2165 
2166         _approve(to, tokenId);
2167     }
2168 
2169     /**
2170      * @dev See {IERC721-getApproved}.
2171      */
2172     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2173         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
2174 
2175         return _tokenApprovals[tokenId];
2176     }
2177 
2178     /**
2179      * @dev See {IERC721-setApprovalForAll}.
2180      */
2181     function setApprovalForAll(address operator, bool approved) public virtual override {
2182         require(operator != _msgSender(), "ERC721: approve to caller");
2183 
2184         _operatorApprovals[_msgSender()][operator] = approved;
2185         emit ApprovalForAll(_msgSender(), operator, approved);
2186     }
2187 
2188     /**
2189      * @dev See {IERC721-isApprovedForAll}.
2190      */
2191     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2192         return _operatorApprovals[owner][operator];
2193     }
2194 
2195     /**
2196      * @dev See {IERC721-transferFrom}.
2197      */
2198     function transferFrom(
2199         address from,
2200         address to,
2201         uint256 tokenId
2202     ) public virtual override {
2203         //solhint-disable-next-line max-line-length
2204         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2205 
2206         _transfer(from, to, tokenId);
2207     }
2208 
2209     /**
2210      * @dev See {IERC721-safeTransferFrom}.
2211      */
2212     function safeTransferFrom(
2213         address from,
2214         address to,
2215         uint256 tokenId
2216     ) public virtual override {
2217         safeTransferFrom(from, to, tokenId, "");
2218     }
2219 
2220     /**
2221      * @dev See {IERC721-safeTransferFrom}.
2222      */
2223     function safeTransferFrom(
2224         address from,
2225         address to,
2226         uint256 tokenId,
2227         bytes memory _data
2228     ) public virtual override {
2229         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2230         _safeTransfer(from, to, tokenId, _data);
2231     }
2232 
2233     /**
2234      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2235      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2236      *
2237      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
2238      *
2239      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2240      * implement alternative mechanisms to perform token transfer, such as signature-based.
2241      *
2242      * Requirements:
2243      *
2244      * - `from` cannot be the zero address.
2245      * - `to` cannot be the zero address.
2246      * - `tokenId` token must exist and be owned by `from`.
2247      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2248      *
2249      * Emits a {Transfer} event.
2250      */
2251     function _safeTransfer(
2252         address from,
2253         address to,
2254         uint256 tokenId,
2255         bytes memory _data
2256     ) internal virtual {
2257         _transfer(from, to, tokenId);
2258         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
2259     }
2260 
2261     /**
2262      * @dev Returns whether `tokenId` exists.
2263      *
2264      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2265      *
2266      * Tokens start existing when they are minted (`_mint`),
2267      * and stop existing when they are burned (`_burn`).
2268      */
2269     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2270         return _owners[tokenId] != address(0);
2271     }
2272 
2273     /**
2274      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2275      *
2276      * Requirements:
2277      *
2278      * - `tokenId` must exist.
2279      */
2280     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2281         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
2282         address owner = ERC721.ownerOf(tokenId);
2283         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
2284     }
2285 
2286     /**
2287      * @dev Safely mints `tokenId` and transfers it to `to`.
2288      *
2289      * Requirements:
2290      *
2291      * - `tokenId` must not exist.
2292      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2293      *
2294      * Emits a {Transfer} event.
2295      */
2296     function _safeMint(address to, uint256 tokenId) internal virtual {
2297         _safeMint(to, tokenId, "");
2298     }
2299 
2300     /**
2301      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2302      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2303      */
2304     function _safeMint(
2305         address to,
2306         uint256 tokenId,
2307         bytes memory _data
2308     ) internal virtual {
2309         _mint(to, tokenId);
2310         require(
2311             _checkOnERC721Received(address(0), to, tokenId, _data),
2312             "ERC721: transfer to non ERC721Receiver implementer"
2313         );
2314     }
2315 
2316     /**
2317      * @dev Mints `tokenId` and transfers it to `to`.
2318      *
2319      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2320      *
2321      * Requirements:
2322      *
2323      * - `tokenId` must not exist.
2324      * - `to` cannot be the zero address.
2325      *
2326      * Emits a {Transfer} event.
2327      */
2328     function _mint(address to, uint256 tokenId) internal virtual {
2329         require(to != address(0), "ERC721: mint to the zero address");
2330         require(!_exists(tokenId), "ERC721: token already minted");
2331 
2332         _beforeTokenTransfer(address(0), to, tokenId);
2333 
2334         _balances[to] += 1;
2335         _owners[tokenId] = to;
2336 
2337         emit Transfer(address(0), to, tokenId);
2338     }
2339 
2340     /**
2341      * @dev Destroys `tokenId`.
2342      * The approval is cleared when the token is burned.
2343      *
2344      * Requirements:
2345      *
2346      * - `tokenId` must exist.
2347      *
2348      * Emits a {Transfer} event.
2349      */
2350     function _burn(uint256 tokenId) internal virtual {
2351         address owner = ERC721.ownerOf(tokenId);
2352 
2353         _beforeTokenTransfer(owner, address(0), tokenId);
2354 
2355         // Clear approvals
2356         _approve(address(0), tokenId);
2357 
2358         _balances[owner] -= 1;
2359         delete _owners[tokenId];
2360 
2361         emit Transfer(owner, address(0), tokenId);
2362     }
2363 
2364     /**
2365      * @dev Transfers `tokenId` from `from` to `to`.
2366      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2367      *
2368      * Requirements:
2369      *
2370      * - `to` cannot be the zero address.
2371      * - `tokenId` token must be owned by `from`.
2372      *
2373      * Emits a {Transfer} event.
2374      */
2375     function _transfer(
2376         address from,
2377         address to,
2378         uint256 tokenId
2379     ) internal virtual {
2380         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
2381         require(to != address(0), "ERC721: transfer to the zero address");
2382 
2383         _beforeTokenTransfer(from, to, tokenId);
2384 
2385         // Clear approvals from the previous owner
2386         _approve(address(0), tokenId);
2387 
2388         _balances[from] -= 1;
2389         _balances[to] += 1;
2390         _owners[tokenId] = to;
2391 
2392         emit Transfer(from, to, tokenId);
2393     }
2394 
2395     /**
2396      * @dev Approve `to` to operate on `tokenId`
2397      *
2398      * Emits a {Approval} event.
2399      */
2400     function _approve(address to, uint256 tokenId) internal virtual {
2401         _tokenApprovals[tokenId] = to;
2402         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2403     }
2404 
2405     /**
2406      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2407      * The call is not executed if the target address is not a contract.
2408      *
2409      * @param from address representing the previous owner of the given token ID
2410      * @param to target address that will receive the tokens
2411      * @param tokenId uint256 ID of the token to be transferred
2412      * @param _data bytes optional data to send along with the call
2413      * @return bool whether the call correctly returned the expected magic value
2414      */
2415     function _checkOnERC721Received(
2416         address from,
2417         address to,
2418         uint256 tokenId,
2419         bytes memory _data
2420     ) private returns (bool) {
2421         if (to.isContract()) {
2422             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2423                 return retval == IERC721Receiver(to).onERC721Received.selector;
2424             } catch (bytes memory reason) {
2425                 if (reason.length == 0) {
2426                     revert("ERC721: transfer to non ERC721Receiver implementer");
2427                 } else {
2428                     assembly {
2429                         revert(add(32, reason), mload(reason))
2430                     }
2431                 }
2432             }
2433         } else {
2434             return true;
2435         }
2436     }
2437 
2438     /**
2439      * @dev Hook that is called before any token transfer. This includes minting
2440      * and burning.
2441      *
2442      * Calling conditions:
2443      *
2444      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2445      * transferred to `to`.
2446      * - When `from` is zero, `tokenId` will be minted for `to`.
2447      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2448      * - `from` and `to` are never both zero.
2449      *
2450      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2451      */
2452     function _beforeTokenTransfer(
2453         address from,
2454         address to,
2455         uint256 tokenId
2456     ) internal virtual {}
2457 }
2458 
2459 
2460 /**
2461  * @title ERC721 Burnable Token
2462  * @dev ERC721 Token that can be irreversibly burned (destroyed).
2463  */
2464 abstract contract ERC721Burnable is Context, ERC721 {
2465     /**
2466      * @dev Burns `tokenId`. See {ERC721-_burn}.
2467      *
2468      * Requirements:
2469      *
2470      * - The caller must own `tokenId` or be an approved operator.
2471      */
2472     function burn(uint256 tokenId) public virtual {
2473         //solhint-disable-next-line max-line-length
2474         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
2475         _burn(tokenId);
2476     }
2477 }
2478 
2479 
2480 /**
2481  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
2482  * @dev See https://eips.ethereum.org/EIPS/eip-721
2483  */
2484 interface IERC721Enumerable is IERC721 {
2485     /**
2486      * @dev Returns the total amount of tokens stored by the contract.
2487      */
2488     function totalSupply() external view returns (uint256);
2489 
2490     /**
2491      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
2492      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
2493      */
2494     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
2495 
2496     /**
2497      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
2498      * Use along with {totalSupply} to enumerate all tokens.
2499      */
2500     function tokenByIndex(uint256 index) external view returns (uint256);
2501 }
2502 
2503 
2504 /**
2505  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
2506  * enumerability of all the token ids in the contract as well as all token ids owned by each
2507  * account.
2508  */
2509 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
2510     // Mapping from owner to list of owned token IDs
2511     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
2512 
2513     // Mapping from token ID to index of the owner tokens list
2514     mapping(uint256 => uint256) private _ownedTokensIndex;
2515 
2516     // Array with all token ids, used for enumeration
2517     uint256[] private _allTokens;
2518 
2519     // Mapping from token id to position in the allTokens array
2520     mapping(uint256 => uint256) private _allTokensIndex;
2521 
2522     /**
2523      * @dev See {IERC165-supportsInterface}.
2524      */
2525     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
2526         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
2527     }
2528 
2529     /**
2530      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
2531      */
2532     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
2533         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
2534         return _ownedTokens[owner][index];
2535     }
2536 
2537     /**
2538      * @dev See {IERC721Enumerable-totalSupply}.
2539      */
2540     function totalSupply() public view virtual override returns (uint256) {
2541         return _allTokens.length;
2542     }
2543 
2544     /**
2545      * @dev See {IERC721Enumerable-tokenByIndex}.
2546      */
2547     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
2548         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
2549         return _allTokens[index];
2550     }
2551 
2552     /**
2553      * @dev Hook that is called before any token transfer. This includes minting
2554      * and burning.
2555      *
2556      * Calling conditions:
2557      *
2558      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2559      * transferred to `to`.
2560      * - When `from` is zero, `tokenId` will be minted for `to`.
2561      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2562      * - `from` cannot be the zero address.
2563      * - `to` cannot be the zero address.
2564      *
2565      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2566      */
2567     function _beforeTokenTransfer(
2568         address from,
2569         address to,
2570         uint256 tokenId
2571     ) internal virtual override {
2572         super._beforeTokenTransfer(from, to, tokenId);
2573 
2574         if (from == address(0)) {
2575             _addTokenToAllTokensEnumeration(tokenId);
2576         } else if (from != to) {
2577             _removeTokenFromOwnerEnumeration(from, tokenId);
2578         }
2579         if (to == address(0)) {
2580             _removeTokenFromAllTokensEnumeration(tokenId);
2581         } else if (to != from) {
2582             _addTokenToOwnerEnumeration(to, tokenId);
2583         }
2584     }
2585 
2586     /**
2587      * @dev Private function to add a token to this extension's ownership-tracking data structures.
2588      * @param to address representing the new owner of the given token ID
2589      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
2590      */
2591     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
2592         uint256 length = ERC721.balanceOf(to);
2593         _ownedTokens[to][length] = tokenId;
2594         _ownedTokensIndex[tokenId] = length;
2595     }
2596 
2597     /**
2598      * @dev Private function to add a token to this extension's token tracking data structures.
2599      * @param tokenId uint256 ID of the token to be added to the tokens list
2600      */
2601     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
2602         _allTokensIndex[tokenId] = _allTokens.length;
2603         _allTokens.push(tokenId);
2604     }
2605 
2606     /**
2607      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
2608      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
2609      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
2610      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
2611      * @param from address representing the previous owner of the given token ID
2612      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
2613      */
2614     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
2615         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
2616         // then delete the last slot (swap and pop).
2617 
2618         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
2619         uint256 tokenIndex = _ownedTokensIndex[tokenId];
2620 
2621         // When the token to delete is the last token, the swap operation is unnecessary
2622         if (tokenIndex != lastTokenIndex) {
2623             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
2624 
2625             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2626             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2627         }
2628 
2629         // This also deletes the contents at the last position of the array
2630         delete _ownedTokensIndex[tokenId];
2631         delete _ownedTokens[from][lastTokenIndex];
2632     }
2633 
2634     /**
2635      * @dev Private function to remove a token from this extension's token tracking data structures.
2636      * This has O(1) time complexity, but alters the order of the _allTokens array.
2637      * @param tokenId uint256 ID of the token to be removed from the tokens list
2638      */
2639     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2640         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
2641         // then delete the last slot (swap and pop).
2642 
2643         uint256 lastTokenIndex = _allTokens.length - 1;
2644         uint256 tokenIndex = _allTokensIndex[tokenId];
2645 
2646         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2647         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2648         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2649         uint256 lastTokenId = _allTokens[lastTokenIndex];
2650 
2651         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2652         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2653 
2654         // This also deletes the contents at the last position of the array
2655         delete _allTokensIndex[tokenId];
2656         _allTokens.pop();
2657     }
2658 }
2659 
2660 
2661 /**
2662  * @dev Contract module which allows children to implement an emergency stop
2663  * mechanism that can be triggered by an authorized account.
2664  *
2665  * This module is used through inheritance. It will make available the
2666  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
2667  * the functions of your contract. Note that they will not be pausable by
2668  * simply including this module, only once the modifiers are put in place.
2669  */
2670 abstract contract Pausable is Context {
2671     /**
2672      * @dev Emitted when the pause is triggered by `account`.
2673      */
2674     event Paused(address account);
2675 
2676     /**
2677      * @dev Emitted when the pause is lifted by `account`.
2678      */
2679     event Unpaused(address account);
2680 
2681     bool private _paused;
2682 
2683     /**
2684      * @dev Initializes the contract in unpaused state.
2685      */
2686     constructor() {
2687         _paused = false;
2688     }
2689 
2690     /**
2691      * @dev Returns true if the contract is paused, and false otherwise.
2692      */
2693     function paused() public view virtual returns (bool) {
2694         return _paused;
2695     }
2696 
2697     /**
2698      * @dev Modifier to make a function callable only when the contract is not paused.
2699      *
2700      * Requirements:
2701      *
2702      * - The contract must not be paused.
2703      */
2704     modifier whenNotPaused() {
2705         require(!paused(), "Pausable: paused");
2706         _;
2707     }
2708 
2709     /**
2710      * @dev Modifier to make a function callable only when the contract is paused.
2711      *
2712      * Requirements:
2713      *
2714      * - The contract must be paused.
2715      */
2716     modifier whenPaused() {
2717         require(paused(), "Pausable: not paused");
2718         _;
2719     }
2720 
2721     /**
2722      * @dev Triggers stopped state.
2723      *
2724      * Requirements:
2725      *
2726      * - The contract must not be paused.
2727      */
2728     function _pause() internal virtual whenNotPaused {
2729         _paused = true;
2730         emit Paused(_msgSender());
2731     }
2732 
2733     /**
2734      * @dev Returns to normal state.
2735      *
2736      * Requirements:
2737      *
2738      * - The contract must be paused.
2739      */
2740     function _unpause() internal virtual whenPaused {
2741         _paused = false;
2742         emit Unpaused(_msgSender());
2743     }
2744 }
2745 
2746 
2747 /**
2748  * @dev ERC721 token with pausable token transfers, minting and burning.
2749  *
2750  * Useful for scenarios such as preventing trades until the end of an evaluation
2751  * period, or having an emergency switch for freezing all token transfers in the
2752  * event of a large bug.
2753  */
2754 abstract contract ERC721Pausable is ERC721, Pausable {
2755     /**
2756      * @dev See {ERC721-_beforeTokenTransfer}.
2757      *
2758      * Requirements:
2759      *
2760      * - the contract must not be paused.
2761      */
2762     function _beforeTokenTransfer(
2763         address from,
2764         address to,
2765         uint256 tokenId
2766     ) internal virtual override {
2767         super._beforeTokenTransfer(from, to, tokenId);
2768 
2769         require(!paused(), "ERC721Pausable: token transfer while paused");
2770     }
2771 }
2772 
2773 
2774 /**
2775  * @dev ERC721 token with storage based token URI management.
2776  */
2777 abstract contract ERC721URIStorage is ERC721 {
2778     using Strings for uint256;
2779 
2780     // Optional mapping for token URIs
2781     mapping(uint256 => string) private _tokenURIs;
2782 
2783     /**
2784      * @dev See {IERC721Metadata-tokenURI}.
2785      */
2786     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2787         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
2788 
2789         string memory _tokenURI = _tokenURIs[tokenId];
2790         string memory base = _baseURI();
2791 
2792         // If there is no base URI, return the token URI.
2793         if (bytes(base).length == 0) {
2794             return _tokenURI;
2795         }
2796         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
2797         if (bytes(_tokenURI).length > 0) {
2798             return string(abi.encodePacked(base, _tokenURI));
2799         }
2800 
2801         return super.tokenURI(tokenId);
2802     }
2803 
2804     /**
2805      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
2806      *
2807      * Requirements:
2808      *
2809      * - `tokenId` must exist.
2810      */
2811     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
2812         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
2813         _tokenURIs[tokenId] = _tokenURI;
2814     }
2815 
2816     /**
2817      * @dev Destroys `tokenId`.
2818      * The approval is cleared when the token is burned.
2819      *
2820      * Requirements:
2821      *
2822      * - `tokenId` must exist.
2823      *
2824      * Emits a {Transfer} event.
2825      */
2826     function _burn(uint256 tokenId) internal virtual override {
2827         super._burn(tokenId);
2828 
2829         if (bytes(_tokenURIs[tokenId]).length != 0) {
2830             delete _tokenURIs[tokenId];
2831         }
2832     }
2833 }
2834 
2835 
2836 /**
2837  * @dev Contract module which provides a basic access control mechanism, where
2838  * there is an account (an owner) that can be granted exclusive access to
2839  * specific functions.
2840  *
2841  * By default, the owner account will be the one that deploys the contract. This
2842  * can later be changed with {transferOwnership}.
2843  *
2844  * This module is used through inheritance. It will make available the modifier
2845  * `onlyOwner`, which can be applied to your functions to restrict their use to
2846  * the owner.
2847  */
2848 abstract contract Ownable is Context {
2849     address private _owner;
2850 
2851     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2852 
2853     /**
2854      * @dev Initializes the contract setting the deployer as the initial owner.
2855      */
2856     constructor() {
2857         _setOwner(_msgSender());
2858     }
2859 
2860     /**
2861      * @dev Returns the address of the current owner.
2862      */
2863     function owner() public view virtual returns (address) {
2864         return _owner;
2865     }
2866 
2867     /**
2868      * @dev Throws if called by any account other than the owner.
2869      */
2870     modifier onlyOwner() {
2871         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2872         _;
2873     }
2874 
2875     /**
2876      * @dev Leaves the contract without owner. It will not be possible to call
2877      * `onlyOwner` functions anymore. Can only be called by the current owner.
2878      *
2879      * NOTE: Renouncing ownership will leave the contract without an owner,
2880      * thereby removing any functionality that is only available to the owner.
2881      */
2882     function renounceOwnership() public virtual onlyOwner {
2883         _setOwner(address(0));
2884     }
2885 
2886     /**
2887      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2888      * Can only be called by the current owner.
2889      */
2890     function transferOwnership(address newOwner) public virtual onlyOwner {
2891         require(newOwner != address(0), "Ownable: new owner is the zero address");
2892         _setOwner(newOwner);
2893     }
2894 
2895     function _setOwner(address newOwner) private {
2896         address oldOwner = _owner;
2897         _owner = newOwner;
2898         emit OwnershipTransferred(oldOwner, newOwner);
2899     }
2900 }
2901 
2902 
2903 // CAUTION
2904 // This version of SafeMath should only be used with Solidity 0.8 or later,
2905 // because it relies on the compiler's built in overflow checks.
2906 /**
2907  * @dev Wrappers over Solidity's arithmetic operations.
2908  *
2909  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
2910  * now has built in overflow checking.
2911  */
2912 library SafeMath {
2913     /**
2914      * @dev Returns the addition of two unsigned integers, with an overflow flag.
2915      *
2916      * _Available since v3.4._
2917      */
2918     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2919         unchecked {
2920             uint256 c = a + b;
2921             if (c < a) return (false, 0);
2922             return (true, c);
2923         }
2924     }
2925 
2926     /**
2927      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
2928      *
2929      * _Available since v3.4._
2930      */
2931     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2932         unchecked {
2933             if (b > a) return (false, 0);
2934             return (true, a - b);
2935         }
2936     }
2937 
2938     /**
2939      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
2940      *
2941      * _Available since v3.4._
2942      */
2943     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2944         unchecked {
2945             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
2946             // benefit is lost if 'b' is also tested.
2947             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
2948             if (a == 0) return (true, 0);
2949             uint256 c = a * b;
2950             if (c / a != b) return (false, 0);
2951             return (true, c);
2952         }
2953     }
2954 
2955     /**
2956      * @dev Returns the division of two unsigned integers, with a division by zero flag.
2957      *
2958      * _Available since v3.4._
2959      */
2960     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2961         unchecked {
2962             if (b == 0) return (false, 0);
2963             return (true, a / b);
2964         }
2965     }
2966 
2967     /**
2968      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
2969      *
2970      * _Available since v3.4._
2971      */
2972     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2973         unchecked {
2974             if (b == 0) return (false, 0);
2975             return (true, a % b);
2976         }
2977     }
2978 
2979     /**
2980      * @dev Returns the addition of two unsigned integers, reverting on
2981      * overflow.
2982      *
2983      * Counterpart to Solidity's `+` operator.
2984      *
2985      * Requirements:
2986      *
2987      * - Addition cannot overflow.
2988      */
2989     function add(uint256 a, uint256 b) internal pure returns (uint256) {
2990         return a + b;
2991     }
2992 
2993     /**
2994      * @dev Returns the subtraction of two unsigned integers, reverting on
2995      * overflow (when the result is negative).
2996      *
2997      * Counterpart to Solidity's `-` operator.
2998      *
2999      * Requirements:
3000      *
3001      * - Subtraction cannot overflow.
3002      */
3003     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
3004         return a - b;
3005     }
3006 
3007     /**
3008      * @dev Returns the multiplication of two unsigned integers, reverting on
3009      * overflow.
3010      *
3011      * Counterpart to Solidity's `*` operator.
3012      *
3013      * Requirements:
3014      *
3015      * - Multiplication cannot overflow.
3016      */
3017     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
3018         return a * b;
3019     }
3020 
3021     /**
3022      * @dev Returns the integer division of two unsigned integers, reverting on
3023      * division by zero. The result is rounded towards zero.
3024      *
3025      * Counterpart to Solidity's `/` operator.
3026      *
3027      * Requirements:
3028      *
3029      * - The divisor cannot be zero.
3030      */
3031     function div(uint256 a, uint256 b) internal pure returns (uint256) {
3032         return a / b;
3033     }
3034 
3035     /**
3036      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
3037      * reverting when dividing by zero.
3038      *
3039      * Counterpart to Solidity's `%` operator. This function uses a `revert`
3040      * opcode (which leaves remaining gas untouched) while Solidity uses an
3041      * invalid opcode to revert (consuming all remaining gas).
3042      *
3043      * Requirements:
3044      *
3045      * - The divisor cannot be zero.
3046      */
3047     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
3048         return a % b;
3049     }
3050 
3051     /**
3052      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
3053      * overflow (when the result is negative).
3054      *
3055      * CAUTION: This function is deprecated because it requires allocating memory for the error
3056      * message unnecessarily. For custom revert reasons use {trySub}.
3057      *
3058      * Counterpart to Solidity's `-` operator.
3059      *
3060      * Requirements:
3061      *
3062      * - Subtraction cannot overflow.
3063      */
3064     function sub(
3065         uint256 a,
3066         uint256 b,
3067         string memory errorMessage
3068     ) internal pure returns (uint256) {
3069         unchecked {
3070             require(b <= a, errorMessage);
3071             return a - b;
3072         }
3073     }
3074 
3075     /**
3076      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
3077      * division by zero. The result is rounded towards zero.
3078      *
3079      * Counterpart to Solidity's `/` operator. Note: this function uses a
3080      * `revert` opcode (which leaves remaining gas untouched) while Solidity
3081      * uses an invalid opcode to revert (consuming all remaining gas).
3082      *
3083      * Requirements:
3084      *
3085      * - The divisor cannot be zero.
3086      */
3087     function div(
3088         uint256 a,
3089         uint256 b,
3090         string memory errorMessage
3091     ) internal pure returns (uint256) {
3092         unchecked {
3093             require(b > 0, errorMessage);
3094             return a / b;
3095         }
3096     }
3097 
3098     /**
3099      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
3100      * reverting with custom message when dividing by zero.
3101      *
3102      * CAUTION: This function is deprecated because it requires allocating memory for the error
3103      * message unnecessarily. For custom revert reasons use {tryMod}.
3104      *
3105      * Counterpart to Solidity's `%` operator. This function uses a `revert`
3106      * opcode (which leaves remaining gas untouched) while Solidity uses an
3107      * invalid opcode to revert (consuming all remaining gas).
3108      *
3109      * Requirements:
3110      *
3111      * - The divisor cannot be zero.
3112      */
3113     function mod(
3114         uint256 a,
3115         uint256 b,
3116         string memory errorMessage
3117     ) internal pure returns (uint256) {
3118         unchecked {
3119             require(b > 0, errorMessage);
3120             return a % b;
3121         }
3122     }
3123 }
3124 
3125 
3126 /**
3127  * @title Counters
3128  * @author Matt Condon (@shrugs)
3129  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
3130  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
3131  *
3132  * Include with `using Counters for Counters.Counter;`
3133  */
3134 library Counters {
3135     struct Counter {
3136         // This variable should never be directly accessed by users of the library: interactions must be restricted to
3137         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
3138         // this feature: see https://github.com/ethereum/solidity/issues/4637
3139         uint256 _value; // default: 0
3140     }
3141 
3142     function current(Counter storage counter) internal view returns (uint256) {
3143         return counter._value;
3144     }
3145 
3146     function increment(Counter storage counter) internal {
3147         unchecked {
3148             counter._value += 1;
3149         }
3150     }
3151 
3152     function decrement(Counter storage counter) internal {
3153         uint256 value = counter._value;
3154         require(value > 0, "Counter: decrement overflow");
3155         unchecked {
3156             counter._value = value - 1;
3157         }
3158     }
3159 
3160     function reset(Counter storage counter) internal {
3161         counter._value = 0;
3162     }
3163 }
3164 
3165 //SPDX-License-Identifier: Unlicense
3166 // @title: BabyBallers
3167 // @author: JWall Team
3168 contract BabyBallers is ERC721Enumerable, Ownable, ERC721Burnable, ERC721Pausable {
3169 
3170     using SafeMath for uint256;
3171     using Counters for Counters.Counter;
3172 
3173     Counters.Counter private _tokenIdTracker;
3174     bool private presale;
3175     bool private sale;
3176 
3177     uint256 public constant MAX_ITEMS = 4000;
3178     uint256 public constant MAX_PRESALE_ITEMS = 1000;
3179     uint256 public PRICE = 15E16; // 0.15 ETH
3180     uint256 public constant RENAME_PRICE = 1E16; // 0.01 ETH
3181     uint256 public constant MAX_MINT = 30;
3182     uint256 public constant MAX_MINT_PRESALE = 30;
3183     string public baseTokenURI;
3184     string public PROVENANCE_HASH = "";
3185     uint256 public REVEAL_TIMESTAMP;
3186     uint256 public startingIndexBlock;
3187     uint256 public startingIndex;
3188 
3189     address public constant creatorAddress = 0x611078d27C4b0ecc330a8d3Ec7870626C643fEe8;
3190     address public constant devAddress = 0xe4D8bF31662c330ed120Ca0F5b3d41c8a34aFACF;
3191 
3192     event CreateBaller(uint256 indexed id);
3193     event AttributeChanged(uint256 indexed _tokenId, string _key, string _value);
3194 
3195     constructor(string memory baseURI) ERC721("Baby Ballers", "BabyBallers") {
3196         setBaseURI(baseURI);
3197         pause(true);
3198         presale = false;
3199         sale = false;
3200         REVEAL_TIMESTAMP = block.timestamp + (86400 * 7);
3201     }
3202 
3203     modifier saleIsOpen {
3204         require(_totalSupply() <= MAX_ITEMS, "Sale ended");
3205         if (_msgSender() != owner()) {
3206             require(!paused(), "Pausable: paused");
3207         }
3208         _;
3209     }
3210 
3211     function _totalSupply() internal view returns (uint) {
3212         return _tokenIdTracker.current();
3213     }
3214 
3215     function totalMint() public view returns (uint256) {
3216         return _totalSupply();
3217     }
3218 
3219     function mintReserve(uint256 _count, address _to) public onlyOwner {
3220         uint256 total = _totalSupply();
3221         require(total <= MAX_ITEMS, "Sale ended");
3222         require(total + _count <= MAX_ITEMS, "Max limit");
3223         for (uint256 i = 0; i < _count; i++) {
3224             _mintAnElement(_to);
3225         }
3226     }
3227 
3228     function presaleMint(address _to, uint256 _count) public payable {
3229         uint256 total = _totalSupply();
3230         require(presale == true, "Presale has not yet started");
3231         require(total <= MAX_PRESALE_ITEMS, "Presale ended");
3232         require(total + _count <= MAX_PRESALE_ITEMS, "Max limit");
3233         require(_count <= MAX_MINT_PRESALE, "Exceeds number");
3234         require(msg.value >= price(_count), "Value below price");
3235 
3236         for (uint256 i = 0; i < _count; i++) {
3237             _mintAnElement(_to);
3238         }
3239     }
3240 
3241     function mint(address _to, uint256 _count) public payable saleIsOpen {
3242         uint256 total = _totalSupply();
3243         require(sale == true, "Sale has not yet started");
3244         require(total <= MAX_ITEMS, "Sale ended");
3245         require(total + _count <= MAX_ITEMS, "Max limit");
3246         require(_count <= MAX_MINT, "Exceeds number");
3247         require(msg.value >= price(_count), "Value below price");
3248 
3249         for (uint256 i = 0; i < _count; i++) {
3250             _mintAnElement(_to);
3251         }
3252 
3253         if (startingIndexBlock == 0 && (totalSupply() == MAX_ITEMS || block.timestamp >= REVEAL_TIMESTAMP)) {
3254             startingIndexBlock = block.number;
3255         } 
3256     }
3257 
3258     function _mintAnElement(address _to) private {
3259         uint id = _totalSupply();
3260         _tokenIdTracker.increment();
3261         _safeMint(_to, id);
3262         emit CreateBaller(id);
3263     }
3264 
3265     function price(uint256 _count) public view returns (uint256) {
3266         return PRICE.mul(_count);
3267     }
3268 
3269     function _baseURI() internal view virtual override returns (string memory) {
3270         return baseTokenURI;
3271     }
3272 
3273     function setBaseURI(string memory baseURI) public onlyOwner {
3274         baseTokenURI = baseURI;
3275     }
3276 
3277     function setMintPrice(uint256 _price) external onlyOwner {
3278         PRICE = _price;
3279     }
3280 
3281     /*     
3282     * Set provenance once it's calculated
3283     */
3284     function setProvenanceHash(string memory _provenanceHash) external onlyOwner {
3285         PROVENANCE_HASH = _provenanceHash;
3286     }
3287 
3288     /**
3289      * Set the starting index for the collection
3290      */
3291     function setStartingIndex() external {
3292         require(startingIndex == 0, "Starting index is already set");
3293         require(startingIndexBlock != 0, "Starting index block must be set");
3294         
3295         startingIndex = uint256(blockhash(startingIndexBlock)) % MAX_ITEMS;
3296         // Just a sanity case in the worst case if this function is called late (EVM only stores last 256 block hashes)
3297         if (block.number.sub(startingIndexBlock) > 255) {
3298             startingIndex = uint256(blockhash(block.number - 1)) % MAX_ITEMS;
3299         }
3300         // Prevent default sequence
3301         if (startingIndex == 0) {
3302             startingIndex = startingIndex.add(1);
3303         }
3304     }
3305 
3306     /**
3307      * Set the starting index block for the collection, essentially unblocking
3308      * setting starting index
3309      */
3310     function emergencySetStartingIndexBlock() external onlyOwner {
3311         require(startingIndex == 0, "Starting index is already set");
3312         
3313         startingIndexBlock = block.number;
3314     }
3315 
3316     function walletOfOwner(address _owner) external view returns (uint256[] memory) {
3317         uint256 tokenCount = balanceOf(_owner);
3318 
3319         uint256[] memory tokenIds = new uint256[](tokenCount);
3320         for (uint256 i = 0; i < tokenCount; i++) {
3321             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
3322         }
3323 
3324         return tokenIds;
3325     }
3326 
3327     function pause(bool val) public onlyOwner {
3328         if (val == true) {
3329             _pause();
3330             return;
3331         }
3332         _unpause();
3333     }
3334 
3335     function startPresale() public onlyOwner {
3336         presale = true;
3337     }
3338 
3339     function startSale() public onlyOwner {
3340         sale = true;
3341     }
3342 
3343     function changeAttribute(uint256 tokenId, string memory key, string memory value) public payable {
3344         address owner = ERC721.ownerOf(tokenId);
3345         require(_msgSender() == owner, "This is not your Baller.");
3346 
3347         uint256 amountPaid = msg.value;
3348         require(amountPaid == RENAME_PRICE, "There is a price for changing your attributes.");
3349 
3350         emit AttributeChanged(tokenId, key, value);
3351     }
3352 
3353     function withdrawAll() public payable onlyOwner {
3354         uint256 balance = address(this).balance;
3355         require(balance > 0);
3356         _widthdraw(devAddress, balance.mul(25).div(1000));
3357         _widthdraw(creatorAddress, address(this).balance);
3358     }
3359 
3360     function _widthdraw(address _address, uint256 _amount) private {
3361         (bool success,) = _address.call{value : _amount}("");
3362         require(success, "Transfer failed.");
3363     }
3364 
3365     function _beforeTokenTransfer(
3366         address from,
3367         address to,
3368         uint256 tokenId
3369     ) internal virtual override(ERC721, ERC721Enumerable, ERC721Pausable) {
3370         super._beforeTokenTransfer(from, to, tokenId);
3371     }
3372 
3373     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
3374         return super.supportsInterface(interfaceId);
3375     }
3376 }