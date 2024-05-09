1 pragma solidity ^0.8.0;
2 
3 library console {
4 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
5 
6 	function _sendLogPayload(bytes memory payload) private view {
7 		uint256 payloadLength = payload.length;
8 		address consoleAddress = CONSOLE_ADDRESS;
9 		assembly {
10 			let payloadStart := add(payload, 32)
11 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
12 		}
13 	}
14 
15 	function log() internal view {
16 		_sendLogPayload(abi.encodeWithSignature("log()"));
17 	}
18 
19 	function logInt(int p0) internal view {
20 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
21 	}
22 
23 	function logUint(uint p0) internal view {
24 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
25 	}
26 
27 	function logString(string memory p0) internal view {
28 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
29 	}
30 
31 	function logBool(bool p0) internal view {
32 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
33 	}
34 
35 	function logAddress(address p0) internal view {
36 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
37 	}
38 
39 	function logBytes(bytes memory p0) internal view {
40 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
41 	}
42 
43 	function logBytes1(bytes1 p0) internal view {
44 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
45 	}
46 
47 	function logBytes2(bytes2 p0) internal view {
48 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
49 	}
50 
51 	function logBytes3(bytes3 p0) internal view {
52 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
53 	}
54 
55 	function logBytes4(bytes4 p0) internal view {
56 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
57 	}
58 
59 	function logBytes5(bytes5 p0) internal view {
60 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
61 	}
62 
63 	function logBytes6(bytes6 p0) internal view {
64 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
65 	}
66 
67 	function logBytes7(bytes7 p0) internal view {
68 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
69 	}
70 
71 	function logBytes8(bytes8 p0) internal view {
72 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
73 	}
74 
75 	function logBytes9(bytes9 p0) internal view {
76 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
77 	}
78 
79 	function logBytes10(bytes10 p0) internal view {
80 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
81 	}
82 
83 	function logBytes11(bytes11 p0) internal view {
84 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
85 	}
86 
87 	function logBytes12(bytes12 p0) internal view {
88 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
89 	}
90 
91 	function logBytes13(bytes13 p0) internal view {
92 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
93 	}
94 
95 	function logBytes14(bytes14 p0) internal view {
96 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
97 	}
98 
99 	function logBytes15(bytes15 p0) internal view {
100 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
101 	}
102 
103 	function logBytes16(bytes16 p0) internal view {
104 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
105 	}
106 
107 	function logBytes17(bytes17 p0) internal view {
108 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
109 	}
110 
111 	function logBytes18(bytes18 p0) internal view {
112 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
113 	}
114 
115 	function logBytes19(bytes19 p0) internal view {
116 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
117 	}
118 
119 	function logBytes20(bytes20 p0) internal view {
120 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
121 	}
122 
123 	function logBytes21(bytes21 p0) internal view {
124 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
125 	}
126 
127 	function logBytes22(bytes22 p0) internal view {
128 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
129 	}
130 
131 	function logBytes23(bytes23 p0) internal view {
132 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
133 	}
134 
135 	function logBytes24(bytes24 p0) internal view {
136 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
137 	}
138 
139 	function logBytes25(bytes25 p0) internal view {
140 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
141 	}
142 
143 	function logBytes26(bytes26 p0) internal view {
144 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
145 	}
146 
147 	function logBytes27(bytes27 p0) internal view {
148 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
149 	}
150 
151 	function logBytes28(bytes28 p0) internal view {
152 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
153 	}
154 
155 	function logBytes29(bytes29 p0) internal view {
156 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
157 	}
158 
159 	function logBytes30(bytes30 p0) internal view {
160 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
161 	}
162 
163 	function logBytes31(bytes31 p0) internal view {
164 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
165 	}
166 
167 	function logBytes32(bytes32 p0) internal view {
168 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
169 	}
170 
171 	function log(uint p0) internal view {
172 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
173 	}
174 
175 	function log(string memory p0) internal view {
176 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
177 	}
178 
179 	function log(bool p0) internal view {
180 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
181 	}
182 
183 	function log(address p0) internal view {
184 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
185 	}
186 
187 	function log(uint p0, uint p1) internal view {
188 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
189 	}
190 
191 	function log(uint p0, string memory p1) internal view {
192 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
193 	}
194 
195 	function log(uint p0, bool p1) internal view {
196 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
197 	}
198 
199 	function log(uint p0, address p1) internal view {
200 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
201 	}
202 
203 	function log(string memory p0, uint p1) internal view {
204 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
205 	}
206 
207 	function log(string memory p0, string memory p1) internal view {
208 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
209 	}
210 
211 	function log(string memory p0, bool p1) internal view {
212 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
213 	}
214 
215 	function log(string memory p0, address p1) internal view {
216 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
217 	}
218 
219 	function log(bool p0, uint p1) internal view {
220 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
221 	}
222 
223 	function log(bool p0, string memory p1) internal view {
224 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
225 	}
226 
227 	function log(bool p0, bool p1) internal view {
228 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
229 	}
230 
231 	function log(bool p0, address p1) internal view {
232 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
233 	}
234 
235 	function log(address p0, uint p1) internal view {
236 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
237 	}
238 
239 	function log(address p0, string memory p1) internal view {
240 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
241 	}
242 
243 	function log(address p0, bool p1) internal view {
244 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
245 	}
246 
247 	function log(address p0, address p1) internal view {
248 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
249 	}
250 
251 	function log(uint p0, uint p1, uint p2) internal view {
252 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
253 	}
254 
255 	function log(uint p0, uint p1, string memory p2) internal view {
256 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
257 	}
258 
259 	function log(uint p0, uint p1, bool p2) internal view {
260 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
261 	}
262 
263 	function log(uint p0, uint p1, address p2) internal view {
264 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
265 	}
266 
267 	function log(uint p0, string memory p1, uint p2) internal view {
268 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
269 	}
270 
271 	function log(uint p0, string memory p1, string memory p2) internal view {
272 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
273 	}
274 
275 	function log(uint p0, string memory p1, bool p2) internal view {
276 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
277 	}
278 
279 	function log(uint p0, string memory p1, address p2) internal view {
280 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
281 	}
282 
283 	function log(uint p0, bool p1, uint p2) internal view {
284 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
285 	}
286 
287 	function log(uint p0, bool p1, string memory p2) internal view {
288 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
289 	}
290 
291 	function log(uint p0, bool p1, bool p2) internal view {
292 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
293 	}
294 
295 	function log(uint p0, bool p1, address p2) internal view {
296 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
297 	}
298 
299 	function log(uint p0, address p1, uint p2) internal view {
300 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
301 	}
302 
303 	function log(uint p0, address p1, string memory p2) internal view {
304 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
305 	}
306 
307 	function log(uint p0, address p1, bool p2) internal view {
308 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
309 	}
310 
311 	function log(uint p0, address p1, address p2) internal view {
312 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
313 	}
314 
315 	function log(string memory p0, uint p1, uint p2) internal view {
316 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
317 	}
318 
319 	function log(string memory p0, uint p1, string memory p2) internal view {
320 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
321 	}
322 
323 	function log(string memory p0, uint p1, bool p2) internal view {
324 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
325 	}
326 
327 	function log(string memory p0, uint p1, address p2) internal view {
328 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
329 	}
330 
331 	function log(string memory p0, string memory p1, uint p2) internal view {
332 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
333 	}
334 
335 	function log(string memory p0, string memory p1, string memory p2) internal view {
336 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
337 	}
338 
339 	function log(string memory p0, string memory p1, bool p2) internal view {
340 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
341 	}
342 
343 	function log(string memory p0, string memory p1, address p2) internal view {
344 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
345 	}
346 
347 	function log(string memory p0, bool p1, uint p2) internal view {
348 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
349 	}
350 
351 	function log(string memory p0, bool p1, string memory p2) internal view {
352 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
353 	}
354 
355 	function log(string memory p0, bool p1, bool p2) internal view {
356 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
357 	}
358 
359 	function log(string memory p0, bool p1, address p2) internal view {
360 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
361 	}
362 
363 	function log(string memory p0, address p1, uint p2) internal view {
364 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
365 	}
366 
367 	function log(string memory p0, address p1, string memory p2) internal view {
368 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
369 	}
370 
371 	function log(string memory p0, address p1, bool p2) internal view {
372 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
373 	}
374 
375 	function log(string memory p0, address p1, address p2) internal view {
376 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
377 	}
378 
379 	function log(bool p0, uint p1, uint p2) internal view {
380 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
381 	}
382 
383 	function log(bool p0, uint p1, string memory p2) internal view {
384 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
385 	}
386 
387 	function log(bool p0, uint p1, bool p2) internal view {
388 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
389 	}
390 
391 	function log(bool p0, uint p1, address p2) internal view {
392 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
393 	}
394 
395 	function log(bool p0, string memory p1, uint p2) internal view {
396 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
397 	}
398 
399 	function log(bool p0, string memory p1, string memory p2) internal view {
400 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
401 	}
402 
403 	function log(bool p0, string memory p1, bool p2) internal view {
404 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
405 	}
406 
407 	function log(bool p0, string memory p1, address p2) internal view {
408 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
409 	}
410 
411 	function log(bool p0, bool p1, uint p2) internal view {
412 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
413 	}
414 
415 	function log(bool p0, bool p1, string memory p2) internal view {
416 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
417 	}
418 
419 	function log(bool p0, bool p1, bool p2) internal view {
420 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
421 	}
422 
423 	function log(bool p0, bool p1, address p2) internal view {
424 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
425 	}
426 
427 	function log(bool p0, address p1, uint p2) internal view {
428 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
429 	}
430 
431 	function log(bool p0, address p1, string memory p2) internal view {
432 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
433 	}
434 
435 	function log(bool p0, address p1, bool p2) internal view {
436 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
437 	}
438 
439 	function log(bool p0, address p1, address p2) internal view {
440 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
441 	}
442 
443 	function log(address p0, uint p1, uint p2) internal view {
444 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
445 	}
446 
447 	function log(address p0, uint p1, string memory p2) internal view {
448 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
449 	}
450 
451 	function log(address p0, uint p1, bool p2) internal view {
452 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
453 	}
454 
455 	function log(address p0, uint p1, address p2) internal view {
456 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
457 	}
458 
459 	function log(address p0, string memory p1, uint p2) internal view {
460 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
461 	}
462 
463 	function log(address p0, string memory p1, string memory p2) internal view {
464 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
465 	}
466 
467 	function log(address p0, string memory p1, bool p2) internal view {
468 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
469 	}
470 
471 	function log(address p0, string memory p1, address p2) internal view {
472 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
473 	}
474 
475 	function log(address p0, bool p1, uint p2) internal view {
476 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
477 	}
478 
479 	function log(address p0, bool p1, string memory p2) internal view {
480 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
481 	}
482 
483 	function log(address p0, bool p1, bool p2) internal view {
484 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
485 	}
486 
487 	function log(address p0, bool p1, address p2) internal view {
488 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
489 	}
490 
491 	function log(address p0, address p1, uint p2) internal view {
492 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
493 	}
494 
495 	function log(address p0, address p1, string memory p2) internal view {
496 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
497 	}
498 
499 	function log(address p0, address p1, bool p2) internal view {
500 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
501 	}
502 
503 	function log(address p0, address p1, address p2) internal view {
504 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
505 	}
506 
507 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
508 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
509 	}
510 
511 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
512 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
513 	}
514 
515 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
516 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
517 	}
518 
519 	function log(uint p0, uint p1, uint p2, address p3) internal view {
520 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
521 	}
522 
523 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
524 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
525 	}
526 
527 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
528 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
529 	}
530 
531 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
532 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
533 	}
534 
535 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
536 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
537 	}
538 
539 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
540 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
541 	}
542 
543 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
544 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
545 	}
546 
547 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
548 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
549 	}
550 
551 	function log(uint p0, uint p1, bool p2, address p3) internal view {
552 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
553 	}
554 
555 	function log(uint p0, uint p1, address p2, uint p3) internal view {
556 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
557 	}
558 
559 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
560 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
561 	}
562 
563 	function log(uint p0, uint p1, address p2, bool p3) internal view {
564 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
565 	}
566 
567 	function log(uint p0, uint p1, address p2, address p3) internal view {
568 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
569 	}
570 
571 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
572 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
573 	}
574 
575 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
576 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
577 	}
578 
579 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
580 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
581 	}
582 
583 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
584 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
585 	}
586 
587 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
588 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
589 	}
590 
591 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
592 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
593 	}
594 
595 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
596 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
597 	}
598 
599 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
600 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
601 	}
602 
603 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
604 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
605 	}
606 
607 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
608 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
609 	}
610 
611 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
612 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
613 	}
614 
615 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
616 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
617 	}
618 
619 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
620 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
621 	}
622 
623 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
624 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
625 	}
626 
627 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
628 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
629 	}
630 
631 	function log(uint p0, string memory p1, address p2, address p3) internal view {
632 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
633 	}
634 
635 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
636 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
637 	}
638 
639 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
640 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
641 	}
642 
643 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
644 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
645 	}
646 
647 	function log(uint p0, bool p1, uint p2, address p3) internal view {
648 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
649 	}
650 
651 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
652 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
653 	}
654 
655 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
656 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
657 	}
658 
659 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
660 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
661 	}
662 
663 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
664 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
665 	}
666 
667 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
668 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
669 	}
670 
671 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
672 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
673 	}
674 
675 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
676 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
677 	}
678 
679 	function log(uint p0, bool p1, bool p2, address p3) internal view {
680 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
681 	}
682 
683 	function log(uint p0, bool p1, address p2, uint p3) internal view {
684 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
685 	}
686 
687 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
688 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
689 	}
690 
691 	function log(uint p0, bool p1, address p2, bool p3) internal view {
692 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
693 	}
694 
695 	function log(uint p0, bool p1, address p2, address p3) internal view {
696 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
697 	}
698 
699 	function log(uint p0, address p1, uint p2, uint p3) internal view {
700 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
701 	}
702 
703 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
704 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
705 	}
706 
707 	function log(uint p0, address p1, uint p2, bool p3) internal view {
708 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
709 	}
710 
711 	function log(uint p0, address p1, uint p2, address p3) internal view {
712 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
713 	}
714 
715 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
716 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
717 	}
718 
719 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
720 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
721 	}
722 
723 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
724 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
725 	}
726 
727 	function log(uint p0, address p1, string memory p2, address p3) internal view {
728 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
729 	}
730 
731 	function log(uint p0, address p1, bool p2, uint p3) internal view {
732 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
733 	}
734 
735 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
736 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
737 	}
738 
739 	function log(uint p0, address p1, bool p2, bool p3) internal view {
740 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
741 	}
742 
743 	function log(uint p0, address p1, bool p2, address p3) internal view {
744 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
745 	}
746 
747 	function log(uint p0, address p1, address p2, uint p3) internal view {
748 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
749 	}
750 
751 	function log(uint p0, address p1, address p2, string memory p3) internal view {
752 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
753 	}
754 
755 	function log(uint p0, address p1, address p2, bool p3) internal view {
756 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
757 	}
758 
759 	function log(uint p0, address p1, address p2, address p3) internal view {
760 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
761 	}
762 
763 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
764 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
765 	}
766 
767 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
768 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
769 	}
770 
771 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
772 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
773 	}
774 
775 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
776 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
777 	}
778 
779 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
780 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
781 	}
782 
783 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
784 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
785 	}
786 
787 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
788 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
789 	}
790 
791 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
792 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
793 	}
794 
795 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
796 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
797 	}
798 
799 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
800 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
801 	}
802 
803 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
804 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
805 	}
806 
807 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
808 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
809 	}
810 
811 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
812 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
813 	}
814 
815 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
816 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
817 	}
818 
819 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
820 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
821 	}
822 
823 	function log(string memory p0, uint p1, address p2, address p3) internal view {
824 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
825 	}
826 
827 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
828 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
829 	}
830 
831 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
832 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
833 	}
834 
835 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
836 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
837 	}
838 
839 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
840 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
841 	}
842 
843 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
844 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
845 	}
846 
847 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
848 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
849 	}
850 
851 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
852 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
853 	}
854 
855 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
856 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
857 	}
858 
859 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
860 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
861 	}
862 
863 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
864 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
865 	}
866 
867 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
868 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
869 	}
870 
871 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
872 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
873 	}
874 
875 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
876 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
877 	}
878 
879 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
880 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
881 	}
882 
883 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
884 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
885 	}
886 
887 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
888 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
889 	}
890 
891 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
892 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
893 	}
894 
895 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
896 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
897 	}
898 
899 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
900 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
901 	}
902 
903 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
904 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
905 	}
906 
907 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
908 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
909 	}
910 
911 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
912 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
913 	}
914 
915 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
916 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
917 	}
918 
919 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
920 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
921 	}
922 
923 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
924 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
925 	}
926 
927 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
928 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
929 	}
930 
931 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
932 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
933 	}
934 
935 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
936 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
937 	}
938 
939 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
940 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
941 	}
942 
943 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
944 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
945 	}
946 
947 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
948 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
949 	}
950 
951 	function log(string memory p0, bool p1, address p2, address p3) internal view {
952 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
953 	}
954 
955 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
956 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
957 	}
958 
959 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
960 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
961 	}
962 
963 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
964 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
965 	}
966 
967 	function log(string memory p0, address p1, uint p2, address p3) internal view {
968 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
969 	}
970 
971 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
972 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
973 	}
974 
975 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
976 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
977 	}
978 
979 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
980 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
981 	}
982 
983 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
984 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
985 	}
986 
987 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
988 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
989 	}
990 
991 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
992 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
993 	}
994 
995 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
996 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
997 	}
998 
999 	function log(string memory p0, address p1, bool p2, address p3) internal view {
1000 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
1001 	}
1002 
1003 	function log(string memory p0, address p1, address p2, uint p3) internal view {
1004 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
1005 	}
1006 
1007 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
1008 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
1009 	}
1010 
1011 	function log(string memory p0, address p1, address p2, bool p3) internal view {
1012 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
1013 	}
1014 
1015 	function log(string memory p0, address p1, address p2, address p3) internal view {
1016 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
1017 	}
1018 
1019 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
1020 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
1021 	}
1022 
1023 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
1024 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
1025 	}
1026 
1027 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
1028 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
1029 	}
1030 
1031 	function log(bool p0, uint p1, uint p2, address p3) internal view {
1032 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
1033 	}
1034 
1035 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
1036 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
1037 	}
1038 
1039 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
1040 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
1041 	}
1042 
1043 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
1044 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
1045 	}
1046 
1047 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
1048 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
1049 	}
1050 
1051 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
1052 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
1053 	}
1054 
1055 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
1056 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
1057 	}
1058 
1059 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
1060 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
1061 	}
1062 
1063 	function log(bool p0, uint p1, bool p2, address p3) internal view {
1064 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
1065 	}
1066 
1067 	function log(bool p0, uint p1, address p2, uint p3) internal view {
1068 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
1069 	}
1070 
1071 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
1072 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
1073 	}
1074 
1075 	function log(bool p0, uint p1, address p2, bool p3) internal view {
1076 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
1077 	}
1078 
1079 	function log(bool p0, uint p1, address p2, address p3) internal view {
1080 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
1081 	}
1082 
1083 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
1084 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
1085 	}
1086 
1087 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
1088 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
1089 	}
1090 
1091 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
1092 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
1093 	}
1094 
1095 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
1096 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
1097 	}
1098 
1099 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
1100 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
1101 	}
1102 
1103 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
1104 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
1105 	}
1106 
1107 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
1108 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
1109 	}
1110 
1111 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
1112 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
1113 	}
1114 
1115 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
1116 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
1117 	}
1118 
1119 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
1120 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
1121 	}
1122 
1123 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
1124 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
1125 	}
1126 
1127 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
1128 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
1129 	}
1130 
1131 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
1132 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
1133 	}
1134 
1135 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
1136 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
1137 	}
1138 
1139 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
1140 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
1141 	}
1142 
1143 	function log(bool p0, string memory p1, address p2, address p3) internal view {
1144 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
1145 	}
1146 
1147 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
1148 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
1149 	}
1150 
1151 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
1152 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
1153 	}
1154 
1155 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
1156 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
1157 	}
1158 
1159 	function log(bool p0, bool p1, uint p2, address p3) internal view {
1160 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
1161 	}
1162 
1163 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
1164 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
1165 	}
1166 
1167 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
1168 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
1169 	}
1170 
1171 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
1172 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
1173 	}
1174 
1175 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
1176 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
1177 	}
1178 
1179 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
1180 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
1181 	}
1182 
1183 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
1184 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
1185 	}
1186 
1187 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
1188 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
1189 	}
1190 
1191 	function log(bool p0, bool p1, bool p2, address p3) internal view {
1192 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
1193 	}
1194 
1195 	function log(bool p0, bool p1, address p2, uint p3) internal view {
1196 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
1197 	}
1198 
1199 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
1200 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
1201 	}
1202 
1203 	function log(bool p0, bool p1, address p2, bool p3) internal view {
1204 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
1205 	}
1206 
1207 	function log(bool p0, bool p1, address p2, address p3) internal view {
1208 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
1209 	}
1210 
1211 	function log(bool p0, address p1, uint p2, uint p3) internal view {
1212 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
1213 	}
1214 
1215 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
1216 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
1217 	}
1218 
1219 	function log(bool p0, address p1, uint p2, bool p3) internal view {
1220 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
1221 	}
1222 
1223 	function log(bool p0, address p1, uint p2, address p3) internal view {
1224 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
1225 	}
1226 
1227 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
1228 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
1229 	}
1230 
1231 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
1232 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
1233 	}
1234 
1235 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
1236 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
1237 	}
1238 
1239 	function log(bool p0, address p1, string memory p2, address p3) internal view {
1240 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
1241 	}
1242 
1243 	function log(bool p0, address p1, bool p2, uint p3) internal view {
1244 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
1245 	}
1246 
1247 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
1248 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
1249 	}
1250 
1251 	function log(bool p0, address p1, bool p2, bool p3) internal view {
1252 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
1253 	}
1254 
1255 	function log(bool p0, address p1, bool p2, address p3) internal view {
1256 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
1257 	}
1258 
1259 	function log(bool p0, address p1, address p2, uint p3) internal view {
1260 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
1261 	}
1262 
1263 	function log(bool p0, address p1, address p2, string memory p3) internal view {
1264 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
1265 	}
1266 
1267 	function log(bool p0, address p1, address p2, bool p3) internal view {
1268 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
1269 	}
1270 
1271 	function log(bool p0, address p1, address p2, address p3) internal view {
1272 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
1273 	}
1274 
1275 	function log(address p0, uint p1, uint p2, uint p3) internal view {
1276 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
1277 	}
1278 
1279 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
1280 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
1281 	}
1282 
1283 	function log(address p0, uint p1, uint p2, bool p3) internal view {
1284 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
1285 	}
1286 
1287 	function log(address p0, uint p1, uint p2, address p3) internal view {
1288 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
1289 	}
1290 
1291 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
1292 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
1293 	}
1294 
1295 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
1296 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
1297 	}
1298 
1299 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
1300 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
1301 	}
1302 
1303 	function log(address p0, uint p1, string memory p2, address p3) internal view {
1304 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
1305 	}
1306 
1307 	function log(address p0, uint p1, bool p2, uint p3) internal view {
1308 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
1309 	}
1310 
1311 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
1312 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
1313 	}
1314 
1315 	function log(address p0, uint p1, bool p2, bool p3) internal view {
1316 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
1317 	}
1318 
1319 	function log(address p0, uint p1, bool p2, address p3) internal view {
1320 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
1321 	}
1322 
1323 	function log(address p0, uint p1, address p2, uint p3) internal view {
1324 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
1325 	}
1326 
1327 	function log(address p0, uint p1, address p2, string memory p3) internal view {
1328 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
1329 	}
1330 
1331 	function log(address p0, uint p1, address p2, bool p3) internal view {
1332 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
1333 	}
1334 
1335 	function log(address p0, uint p1, address p2, address p3) internal view {
1336 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
1337 	}
1338 
1339 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
1340 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
1341 	}
1342 
1343 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
1344 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
1345 	}
1346 
1347 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
1348 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
1349 	}
1350 
1351 	function log(address p0, string memory p1, uint p2, address p3) internal view {
1352 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
1353 	}
1354 
1355 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
1356 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
1357 	}
1358 
1359 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
1360 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
1361 	}
1362 
1363 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
1364 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
1365 	}
1366 
1367 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
1368 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
1369 	}
1370 
1371 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
1372 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
1373 	}
1374 
1375 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
1376 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
1377 	}
1378 
1379 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
1380 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
1381 	}
1382 
1383 	function log(address p0, string memory p1, bool p2, address p3) internal view {
1384 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
1385 	}
1386 
1387 	function log(address p0, string memory p1, address p2, uint p3) internal view {
1388 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
1389 	}
1390 
1391 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
1392 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
1393 	}
1394 
1395 	function log(address p0, string memory p1, address p2, bool p3) internal view {
1396 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
1397 	}
1398 
1399 	function log(address p0, string memory p1, address p2, address p3) internal view {
1400 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
1401 	}
1402 
1403 	function log(address p0, bool p1, uint p2, uint p3) internal view {
1404 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
1405 	}
1406 
1407 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
1408 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
1409 	}
1410 
1411 	function log(address p0, bool p1, uint p2, bool p3) internal view {
1412 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
1413 	}
1414 
1415 	function log(address p0, bool p1, uint p2, address p3) internal view {
1416 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
1417 	}
1418 
1419 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
1420 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
1421 	}
1422 
1423 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
1424 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
1425 	}
1426 
1427 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
1428 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
1429 	}
1430 
1431 	function log(address p0, bool p1, string memory p2, address p3) internal view {
1432 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
1433 	}
1434 
1435 	function log(address p0, bool p1, bool p2, uint p3) internal view {
1436 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
1437 	}
1438 
1439 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
1440 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
1441 	}
1442 
1443 	function log(address p0, bool p1, bool p2, bool p3) internal view {
1444 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
1445 	}
1446 
1447 	function log(address p0, bool p1, bool p2, address p3) internal view {
1448 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
1449 	}
1450 
1451 	function log(address p0, bool p1, address p2, uint p3) internal view {
1452 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
1453 	}
1454 
1455 	function log(address p0, bool p1, address p2, string memory p3) internal view {
1456 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
1457 	}
1458 
1459 	function log(address p0, bool p1, address p2, bool p3) internal view {
1460 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
1461 	}
1462 
1463 	function log(address p0, bool p1, address p2, address p3) internal view {
1464 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
1465 	}
1466 
1467 	function log(address p0, address p1, uint p2, uint p3) internal view {
1468 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
1469 	}
1470 
1471 	function log(address p0, address p1, uint p2, string memory p3) internal view {
1472 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
1473 	}
1474 
1475 	function log(address p0, address p1, uint p2, bool p3) internal view {
1476 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
1477 	}
1478 
1479 	function log(address p0, address p1, uint p2, address p3) internal view {
1480 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
1481 	}
1482 
1483 	function log(address p0, address p1, string memory p2, uint p3) internal view {
1484 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
1485 	}
1486 
1487 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
1488 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
1489 	}
1490 
1491 	function log(address p0, address p1, string memory p2, bool p3) internal view {
1492 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
1493 	}
1494 
1495 	function log(address p0, address p1, string memory p2, address p3) internal view {
1496 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
1497 	}
1498 
1499 	function log(address p0, address p1, bool p2, uint p3) internal view {
1500 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
1501 	}
1502 
1503 	function log(address p0, address p1, bool p2, string memory p3) internal view {
1504 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
1505 	}
1506 
1507 	function log(address p0, address p1, bool p2, bool p3) internal view {
1508 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
1509 	}
1510 
1511 	function log(address p0, address p1, bool p2, address p3) internal view {
1512 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
1513 	}
1514 
1515 	function log(address p0, address p1, address p2, uint p3) internal view {
1516 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
1517 	}
1518 
1519 	function log(address p0, address p1, address p2, string memory p3) internal view {
1520 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
1521 	}
1522 
1523 	function log(address p0, address p1, address p2, bool p3) internal view {
1524 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
1525 	}
1526 
1527 	function log(address p0, address p1, address p2, address p3) internal view {
1528 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
1529 	}
1530 
1531 }
1532 
1533 
1534 /**
1535  * @dev Interface of the ERC165 standard, as defined in the
1536  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1537  *
1538  * Implementers can declare support of contract interfaces, which can then be
1539  * queried by others ({ERC165Checker}).
1540  *
1541  * For an implementation, see {ERC165}.
1542  */
1543 interface IERC165 {
1544     /**
1545      * @dev Returns true if this contract implements the interface defined by
1546      * `interfaceId`. See the corresponding
1547      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1548      * to learn more about how these ids are created.
1549      *
1550      * This function call must use less than 30 000 gas.
1551      */
1552     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1553 }
1554 
1555 
1556 /**
1557  * @dev Required interface of an ERC721 compliant contract.
1558  */
1559 interface IERC721 is IERC165 {
1560     /**
1561      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1562      */
1563     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1564 
1565     /**
1566      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1567      */
1568     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1569 
1570     /**
1571      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1572      */
1573     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1574 
1575     /**
1576      * @dev Returns the number of tokens in ``owner``'s account.
1577      */
1578     function balanceOf(address owner) external view returns (uint256 balance);
1579 
1580     /**
1581      * @dev Returns the owner of the `tokenId` token.
1582      *
1583      * Requirements:
1584      *
1585      * - `tokenId` must exist.
1586      */
1587     function ownerOf(uint256 tokenId) external view returns (address owner);
1588 
1589     /**
1590      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1591      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1592      *
1593      * Requirements:
1594      *
1595      * - `from` cannot be the zero address.
1596      * - `to` cannot be the zero address.
1597      * - `tokenId` token must exist and be owned by `from`.
1598      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1599      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1600      *
1601      * Emits a {Transfer} event.
1602      */
1603     function safeTransferFrom(
1604         address from,
1605         address to,
1606         uint256 tokenId
1607     ) external;
1608 
1609     /**
1610      * @dev Transfers `tokenId` token from `from` to `to`.
1611      *
1612      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1613      *
1614      * Requirements:
1615      *
1616      * - `from` cannot be the zero address.
1617      * - `to` cannot be the zero address.
1618      * - `tokenId` token must be owned by `from`.
1619      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1620      *
1621      * Emits a {Transfer} event.
1622      */
1623     function transferFrom(
1624         address from,
1625         address to,
1626         uint256 tokenId
1627     ) external;
1628 
1629     /**
1630      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1631      * The approval is cleared when the token is transferred.
1632      *
1633      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1634      *
1635      * Requirements:
1636      *
1637      * - The caller must own the token or be an approved operator.
1638      * - `tokenId` must exist.
1639      *
1640      * Emits an {Approval} event.
1641      */
1642     function approve(address to, uint256 tokenId) external;
1643 
1644     /**
1645      * @dev Returns the account approved for `tokenId` token.
1646      *
1647      * Requirements:
1648      *
1649      * - `tokenId` must exist.
1650      */
1651     function getApproved(uint256 tokenId) external view returns (address operator);
1652 
1653     /**
1654      * @dev Approve or remove `operator` as an operator for the caller.
1655      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1656      *
1657      * Requirements:
1658      *
1659      * - The `operator` cannot be the caller.
1660      *
1661      * Emits an {ApprovalForAll} event.
1662      */
1663     function setApprovalForAll(address operator, bool _approved) external;
1664 
1665     /**
1666      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1667      *
1668      * See {setApprovalForAll}
1669      */
1670     function isApprovedForAll(address owner, address operator) external view returns (bool);
1671 
1672     /**
1673      * @dev Safely transfers `tokenId` token from `from` to `to`.
1674      *
1675      * Requirements:
1676      *
1677      * - `from` cannot be the zero address.
1678      * - `to` cannot be the zero address.
1679      * - `tokenId` token must exist and be owned by `from`.
1680      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1681      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1682      *
1683      * Emits a {Transfer} event.
1684      */
1685     function safeTransferFrom(
1686         address from,
1687         address to,
1688         uint256 tokenId,
1689         bytes calldata data
1690     ) external;
1691 }
1692 
1693 
1694 /**
1695  * @title ERC721 token receiver interface
1696  * @dev Interface for any contract that wants to support safeTransfers
1697  * from ERC721 asset contracts.
1698  */
1699 interface IERC721Receiver {
1700     /**
1701      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1702      * by `operator` from `from`, this function is called.
1703      *
1704      * It must return its Solidity selector to confirm the token transfer.
1705      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1706      *
1707      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1708      */
1709     function onERC721Received(
1710         address operator,
1711         address from,
1712         uint256 tokenId,
1713         bytes calldata data
1714     ) external returns (bytes4);
1715 }
1716 
1717 
1718 /**
1719  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1720  * @dev See https://eips.ethereum.org/EIPS/eip-721
1721  */
1722 interface IERC721Metadata is IERC721 {
1723     /**
1724      * @dev Returns the token collection name.
1725      */
1726     function name() external view returns (string memory);
1727 
1728     /**
1729      * @dev Returns the token collection symbol.
1730      */
1731     function symbol() external view returns (string memory);
1732 
1733     /**
1734      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1735      */
1736     function tokenURI(uint256 tokenId) external view returns (string memory);
1737 }
1738 
1739 
1740 /**
1741  * @dev Collection of functions related to the address type
1742  */
1743 library Address {
1744     /**
1745      * @dev Returns true if `account` is a contract.
1746      *
1747      * [IMPORTANT]
1748      * ====
1749      * It is unsafe to assume that an address for which this function returns
1750      * false is an externally-owned account (EOA) and not a contract.
1751      *
1752      * Among others, `isContract` will return false for the following
1753      * types of addresses:
1754      *
1755      *  - an externally-owned account
1756      *  - a contract in construction
1757      *  - an address where a contract will be created
1758      *  - an address where a contract lived, but was destroyed
1759      * ====
1760      */
1761     function isContract(address account) internal view returns (bool) {
1762         // This method relies on extcodesize, which returns 0 for contracts in
1763         // construction, since the code is only stored at the end of the
1764         // constructor execution.
1765 
1766         uint256 size;
1767         assembly {
1768             size := extcodesize(account)
1769         }
1770         return size > 0;
1771     }
1772 
1773     /**
1774      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1775      * `recipient`, forwarding all available gas and reverting on errors.
1776      *
1777      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1778      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1779      * imposed by `transfer`, making them unable to receive funds via
1780      * `transfer`. {sendValue} removes this limitation.
1781      *
1782      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1783      *
1784      * IMPORTANT: because control is transferred to `recipient`, care must be
1785      * taken to not create reentrancy vulnerabilities. Consider using
1786      * {ReentrancyGuard} or the
1787      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1788      */
1789     function sendValue(address payable recipient, uint256 amount) internal {
1790         require(address(this).balance >= amount, "Address: insufficient balance");
1791 
1792         (bool success, ) = recipient.call{value: amount}("");
1793         require(success, "Address: unable to send value, recipient may have reverted");
1794     }
1795 
1796     /**
1797      * @dev Performs a Solidity function call using a low level `call`. A
1798      * plain `call` is an unsafe replacement for a function call: use this
1799      * function instead.
1800      *
1801      * If `target` reverts with a revert reason, it is bubbled up by this
1802      * function (like regular Solidity function calls).
1803      *
1804      * Returns the raw returned data. To convert to the expected return value,
1805      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1806      *
1807      * Requirements:
1808      *
1809      * - `target` must be a contract.
1810      * - calling `target` with `data` must not revert.
1811      *
1812      * _Available since v3.1._
1813      */
1814     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1815         return functionCall(target, data, "Address: low-level call failed");
1816     }
1817 
1818     /**
1819      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1820      * `errorMessage` as a fallback revert reason when `target` reverts.
1821      *
1822      * _Available since v3.1._
1823      */
1824     function functionCall(
1825         address target,
1826         bytes memory data,
1827         string memory errorMessage
1828     ) internal returns (bytes memory) {
1829         return functionCallWithValue(target, data, 0, errorMessage);
1830     }
1831 
1832     /**
1833      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1834      * but also transferring `value` wei to `target`.
1835      *
1836      * Requirements:
1837      *
1838      * - the calling contract must have an ETH balance of at least `value`.
1839      * - the called Solidity function must be `payable`.
1840      *
1841      * _Available since v3.1._
1842      */
1843     function functionCallWithValue(
1844         address target,
1845         bytes memory data,
1846         uint256 value
1847     ) internal returns (bytes memory) {
1848         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1849     }
1850 
1851     /**
1852      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1853      * with `errorMessage` as a fallback revert reason when `target` reverts.
1854      *
1855      * _Available since v3.1._
1856      */
1857     function functionCallWithValue(
1858         address target,
1859         bytes memory data,
1860         uint256 value,
1861         string memory errorMessage
1862     ) internal returns (bytes memory) {
1863         require(address(this).balance >= value, "Address: insufficient balance for call");
1864         require(isContract(target), "Address: call to non-contract");
1865 
1866         (bool success, bytes memory returndata) = target.call{value: value}(data);
1867         return _verifyCallResult(success, returndata, errorMessage);
1868     }
1869 
1870     /**
1871      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1872      * but performing a static call.
1873      *
1874      * _Available since v3.3._
1875      */
1876     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1877         return functionStaticCall(target, data, "Address: low-level static call failed");
1878     }
1879 
1880     /**
1881      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1882      * but performing a static call.
1883      *
1884      * _Available since v3.3._
1885      */
1886     function functionStaticCall(
1887         address target,
1888         bytes memory data,
1889         string memory errorMessage
1890     ) internal view returns (bytes memory) {
1891         require(isContract(target), "Address: static call to non-contract");
1892 
1893         (bool success, bytes memory returndata) = target.staticcall(data);
1894         return _verifyCallResult(success, returndata, errorMessage);
1895     }
1896 
1897     /**
1898      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1899      * but performing a delegate call.
1900      *
1901      * _Available since v3.4._
1902      */
1903     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1904         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1905     }
1906 
1907     /**
1908      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1909      * but performing a delegate call.
1910      *
1911      * _Available since v3.4._
1912      */
1913     function functionDelegateCall(
1914         address target,
1915         bytes memory data,
1916         string memory errorMessage
1917     ) internal returns (bytes memory) {
1918         require(isContract(target), "Address: delegate call to non-contract");
1919 
1920         (bool success, bytes memory returndata) = target.delegatecall(data);
1921         return _verifyCallResult(success, returndata, errorMessage);
1922     }
1923 
1924     function _verifyCallResult(
1925         bool success,
1926         bytes memory returndata,
1927         string memory errorMessage
1928     ) private pure returns (bytes memory) {
1929         if (success) {
1930             return returndata;
1931         } else {
1932             // Look for revert reason and bubble it up if present
1933             if (returndata.length > 0) {
1934                 // The easiest way to bubble the revert reason is using memory via assembly
1935 
1936                 assembly {
1937                     let returndata_size := mload(returndata)
1938                     revert(add(32, returndata), returndata_size)
1939                 }
1940             } else {
1941                 revert(errorMessage);
1942             }
1943         }
1944     }
1945 }
1946 
1947 
1948 /*
1949  * @dev Provides information about the current execution context, including the
1950  * sender of the transaction and its data. While these are generally available
1951  * via msg.sender and msg.data, they should not be accessed in such a direct
1952  * manner, since when dealing with meta-transactions the account sending and
1953  * paying for execution may not be the actual sender (as far as an application
1954  * is concerned).
1955  *
1956  * This contract is only required for intermediate, library-like contracts.
1957  */
1958 abstract contract Context {
1959     function _msgSender() internal view virtual returns (address) {
1960         return msg.sender;
1961     }
1962 
1963     function _msgData() internal view virtual returns (bytes calldata) {
1964         return msg.data;
1965     }
1966 }
1967 
1968 
1969 /**
1970  * @dev String operations.
1971  */
1972 library Strings {
1973     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1974 
1975     /**
1976      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1977      */
1978     function toString(uint256 value) internal pure returns (string memory) {
1979         // Inspired by OraclizeAPI's implementation - MIT licence
1980         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1981 
1982         if (value == 0) {
1983             return "0";
1984         }
1985         uint256 temp = value;
1986         uint256 digits;
1987         while (temp != 0) {
1988             digits++;
1989             temp /= 10;
1990         }
1991         bytes memory buffer = new bytes(digits);
1992         while (value != 0) {
1993             digits -= 1;
1994             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1995             value /= 10;
1996         }
1997         return string(buffer);
1998     }
1999 
2000     /**
2001      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2002      */
2003     function toHexString(uint256 value) internal pure returns (string memory) {
2004         if (value == 0) {
2005             return "0x00";
2006         }
2007         uint256 temp = value;
2008         uint256 length = 0;
2009         while (temp != 0) {
2010             length++;
2011             temp >>= 8;
2012         }
2013         return toHexString(value, length);
2014     }
2015 
2016     /**
2017      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2018      */
2019     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2020         bytes memory buffer = new bytes(2 * length + 2);
2021         buffer[0] = "0";
2022         buffer[1] = "x";
2023         for (uint256 i = 2 * length + 1; i > 1; --i) {
2024             buffer[i] = _HEX_SYMBOLS[value & 0xf];
2025             value >>= 4;
2026         }
2027         require(value == 0, "Strings: hex length insufficient");
2028         return string(buffer);
2029     }
2030 }
2031 
2032 
2033 /**
2034  * @dev Implementation of the {IERC165} interface.
2035  *
2036  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
2037  * for the additional interface id that will be supported. For example:
2038  *
2039  * ```solidity
2040  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2041  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
2042  * }
2043  * ```
2044  *
2045  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
2046  */
2047 abstract contract ERC165 is IERC165 {
2048     /**
2049      * @dev See {IERC165-supportsInterface}.
2050      */
2051     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2052         return interfaceId == type(IERC165).interfaceId;
2053     }
2054 }
2055 
2056 
2057 /**
2058  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2059  * the Metadata extension, but not including the Enumerable extension, which is available separately as
2060  * {ERC721Enumerable}.
2061  */
2062 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
2063     using Address for address;
2064     using Strings for uint256;
2065 
2066     // Token name
2067     string private _name;
2068 
2069     // Token symbol
2070     string private _symbol;
2071 
2072     // Mapping from token ID to owner address
2073     mapping(uint256 => address) private _owners;
2074 
2075     // Mapping owner address to token count
2076     mapping(address => uint256) private _balances;
2077 
2078     // Mapping from token ID to approved address
2079     mapping(uint256 => address) private _tokenApprovals;
2080 
2081     // Mapping from owner to operator approvals
2082     mapping(address => mapping(address => bool)) private _operatorApprovals;
2083 
2084     /**
2085      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2086      */
2087     constructor(string memory name_, string memory symbol_) {
2088         _name = name_;
2089         _symbol = symbol_;
2090     }
2091 
2092     /**
2093      * @dev See {IERC165-supportsInterface}.
2094      */
2095     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2096         return
2097             interfaceId == type(IERC721).interfaceId ||
2098             interfaceId == type(IERC721Metadata).interfaceId ||
2099             super.supportsInterface(interfaceId);
2100     }
2101 
2102     /**
2103      * @dev See {IERC721-balanceOf}.
2104      */
2105     function balanceOf(address owner) public view virtual override returns (uint256) {
2106         require(owner != address(0), "ERC721: balance query for the zero address");
2107         return _balances[owner];
2108     }
2109 
2110     /**
2111      * @dev See {IERC721-ownerOf}.
2112      */
2113     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2114         address owner = _owners[tokenId];
2115         require(owner != address(0), "ERC721: owner query for nonexistent token");
2116         return owner;
2117     }
2118 
2119     /**
2120      * @dev See {IERC721Metadata-name}.
2121      */
2122     function name() public view virtual override returns (string memory) {
2123         return _name;
2124     }
2125 
2126     /**
2127      * @dev See {IERC721Metadata-symbol}.
2128      */
2129     function symbol() public view virtual override returns (string memory) {
2130         return _symbol;
2131     }
2132 
2133     /**
2134      * @dev See {IERC721Metadata-tokenURI}.
2135      */
2136     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2137         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2138 
2139         string memory baseURI = _baseURI();
2140         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2141     }
2142 
2143     /**
2144      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2145      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2146      * by default, can be overriden in child contracts.
2147      */
2148     function _baseURI() internal view virtual returns (string memory) {
2149         return "";
2150     }
2151 
2152     /**
2153      * @dev See {IERC721-approve}.
2154      */
2155     function approve(address to, uint256 tokenId) public virtual override {
2156         address owner = ERC721.ownerOf(tokenId);
2157         require(to != owner, "ERC721: approval to current owner");
2158 
2159         require(
2160             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2161             "ERC721: approve caller is not owner nor approved for all"
2162         );
2163 
2164         _approve(to, tokenId);
2165     }
2166 
2167     /**
2168      * @dev See {IERC721-getApproved}.
2169      */
2170     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2171         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
2172 
2173         return _tokenApprovals[tokenId];
2174     }
2175 
2176     /**
2177      * @dev See {IERC721-setApprovalForAll}.
2178      */
2179     function setApprovalForAll(address operator, bool approved) public virtual override {
2180         require(operator != _msgSender(), "ERC721: approve to caller");
2181 
2182         _operatorApprovals[_msgSender()][operator] = approved;
2183         emit ApprovalForAll(_msgSender(), operator, approved);
2184     }
2185 
2186     /**
2187      * @dev See {IERC721-isApprovedForAll}.
2188      */
2189     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2190         return _operatorApprovals[owner][operator];
2191     }
2192 
2193     /**
2194      * @dev See {IERC721-transferFrom}.
2195      */
2196     function transferFrom(
2197         address from,
2198         address to,
2199         uint256 tokenId
2200     ) public virtual override {
2201         //solhint-disable-next-line max-line-length
2202         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2203 
2204         _transfer(from, to, tokenId);
2205     }
2206 
2207     /**
2208      * @dev See {IERC721-safeTransferFrom}.
2209      */
2210     function safeTransferFrom(
2211         address from,
2212         address to,
2213         uint256 tokenId
2214     ) public virtual override {
2215         safeTransferFrom(from, to, tokenId, "");
2216     }
2217 
2218     /**
2219      * @dev See {IERC721-safeTransferFrom}.
2220      */
2221     function safeTransferFrom(
2222         address from,
2223         address to,
2224         uint256 tokenId,
2225         bytes memory _data
2226     ) public virtual override {
2227         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2228         _safeTransfer(from, to, tokenId, _data);
2229     }
2230 
2231     /**
2232      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2233      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2234      *
2235      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
2236      *
2237      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2238      * implement alternative mechanisms to perform token transfer, such as signature-based.
2239      *
2240      * Requirements:
2241      *
2242      * - `from` cannot be the zero address.
2243      * - `to` cannot be the zero address.
2244      * - `tokenId` token must exist and be owned by `from`.
2245      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2246      *
2247      * Emits a {Transfer} event.
2248      */
2249     function _safeTransfer(
2250         address from,
2251         address to,
2252         uint256 tokenId,
2253         bytes memory _data
2254     ) internal virtual {
2255         _transfer(from, to, tokenId);
2256         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
2257     }
2258 
2259     /**
2260      * @dev Returns whether `tokenId` exists.
2261      *
2262      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2263      *
2264      * Tokens start existing when they are minted (`_mint`),
2265      * and stop existing when they are burned (`_burn`).
2266      */
2267     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2268         return _owners[tokenId] != address(0);
2269     }
2270 
2271     /**
2272      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2273      *
2274      * Requirements:
2275      *
2276      * - `tokenId` must exist.
2277      */
2278     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2279         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
2280         address owner = ERC721.ownerOf(tokenId);
2281         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
2282     }
2283 
2284     /**
2285      * @dev Safely mints `tokenId` and transfers it to `to`.
2286      *
2287      * Requirements:
2288      *
2289      * - `tokenId` must not exist.
2290      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2291      *
2292      * Emits a {Transfer} event.
2293      */
2294     function _safeMint(address to, uint256 tokenId) internal virtual {
2295         _safeMint(to, tokenId, "");
2296     }
2297 
2298     /**
2299      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2300      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2301      */
2302     function _safeMint(
2303         address to,
2304         uint256 tokenId,
2305         bytes memory _data
2306     ) internal virtual {
2307         _mint(to, tokenId);
2308         require(
2309             _checkOnERC721Received(address(0), to, tokenId, _data),
2310             "ERC721: transfer to non ERC721Receiver implementer"
2311         );
2312     }
2313 
2314     /**
2315      * @dev Mints `tokenId` and transfers it to `to`.
2316      *
2317      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2318      *
2319      * Requirements:
2320      *
2321      * - `tokenId` must not exist.
2322      * - `to` cannot be the zero address.
2323      *
2324      * Emits a {Transfer} event.
2325      */
2326     function _mint(address to, uint256 tokenId) internal virtual {
2327         require(to != address(0), "ERC721: mint to the zero address");
2328         require(!_exists(tokenId), "ERC721: token already minted");
2329 
2330         _beforeTokenTransfer(address(0), to, tokenId);
2331 
2332         _balances[to] += 1;
2333         _owners[tokenId] = to;
2334 
2335         emit Transfer(address(0), to, tokenId);
2336     }
2337 
2338     /**
2339      * @dev Destroys `tokenId`.
2340      * The approval is cleared when the token is burned.
2341      *
2342      * Requirements:
2343      *
2344      * - `tokenId` must exist.
2345      *
2346      * Emits a {Transfer} event.
2347      */
2348     function _burn(uint256 tokenId) internal virtual {
2349         address owner = ERC721.ownerOf(tokenId);
2350 
2351         _beforeTokenTransfer(owner, address(0), tokenId);
2352 
2353         // Clear approvals
2354         _approve(address(0), tokenId);
2355 
2356         _balances[owner] -= 1;
2357         delete _owners[tokenId];
2358 
2359         emit Transfer(owner, address(0), tokenId);
2360     }
2361 
2362     /**
2363      * @dev Transfers `tokenId` from `from` to `to`.
2364      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2365      *
2366      * Requirements:
2367      *
2368      * - `to` cannot be the zero address.
2369      * - `tokenId` token must be owned by `from`.
2370      *
2371      * Emits a {Transfer} event.
2372      */
2373     function _transfer(
2374         address from,
2375         address to,
2376         uint256 tokenId
2377     ) internal virtual {
2378         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
2379         require(to != address(0), "ERC721: transfer to the zero address");
2380 
2381         _beforeTokenTransfer(from, to, tokenId);
2382 
2383         // Clear approvals from the previous owner
2384         _approve(address(0), tokenId);
2385 
2386         _balances[from] -= 1;
2387         _balances[to] += 1;
2388         _owners[tokenId] = to;
2389 
2390         emit Transfer(from, to, tokenId);
2391     }
2392 
2393     /**
2394      * @dev Approve `to` to operate on `tokenId`
2395      *
2396      * Emits a {Approval} event.
2397      */
2398     function _approve(address to, uint256 tokenId) internal virtual {
2399         _tokenApprovals[tokenId] = to;
2400         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2401     }
2402 
2403     /**
2404      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2405      * The call is not executed if the target address is not a contract.
2406      *
2407      * @param from address representing the previous owner of the given token ID
2408      * @param to target address that will receive the tokens
2409      * @param tokenId uint256 ID of the token to be transferred
2410      * @param _data bytes optional data to send along with the call
2411      * @return bool whether the call correctly returned the expected magic value
2412      */
2413     function _checkOnERC721Received(
2414         address from,
2415         address to,
2416         uint256 tokenId,
2417         bytes memory _data
2418     ) private returns (bool) {
2419         if (to.isContract()) {
2420             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2421                 return retval == IERC721Receiver(to).onERC721Received.selector;
2422             } catch (bytes memory reason) {
2423                 if (reason.length == 0) {
2424                     revert("ERC721: transfer to non ERC721Receiver implementer");
2425                 } else {
2426                     assembly {
2427                         revert(add(32, reason), mload(reason))
2428                     }
2429                 }
2430             }
2431         } else {
2432             return true;
2433         }
2434     }
2435 
2436     /**
2437      * @dev Hook that is called before any token transfer. This includes minting
2438      * and burning.
2439      *
2440      * Calling conditions:
2441      *
2442      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2443      * transferred to `to`.
2444      * - When `from` is zero, `tokenId` will be minted for `to`.
2445      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2446      * - `from` and `to` are never both zero.
2447      *
2448      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2449      */
2450     function _beforeTokenTransfer(
2451         address from,
2452         address to,
2453         uint256 tokenId
2454     ) internal virtual {}
2455 }
2456 
2457 
2458 /**
2459  * @title ERC721 Burnable Token
2460  * @dev ERC721 Token that can be irreversibly burned (destroyed).
2461  */
2462 abstract contract ERC721Burnable is Context, ERC721 {
2463     /**
2464      * @dev Burns `tokenId`. See {ERC721-_burn}.
2465      *
2466      * Requirements:
2467      *
2468      * - The caller must own `tokenId` or be an approved operator.
2469      */
2470     function burn(uint256 tokenId) public virtual {
2471         //solhint-disable-next-line max-line-length
2472         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
2473         _burn(tokenId);
2474     }
2475 }
2476 
2477 
2478 /**
2479  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
2480  * @dev See https://eips.ethereum.org/EIPS/eip-721
2481  */
2482 interface IERC721Enumerable is IERC721 {
2483     /**
2484      * @dev Returns the total amount of tokens stored by the contract.
2485      */
2486     function totalSupply() external view returns (uint256);
2487 
2488     /**
2489      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
2490      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
2491      */
2492     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
2493 
2494     /**
2495      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
2496      * Use along with {totalSupply} to enumerate all tokens.
2497      */
2498     function tokenByIndex(uint256 index) external view returns (uint256);
2499 }
2500 
2501 
2502 /**
2503  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
2504  * enumerability of all the token ids in the contract as well as all token ids owned by each
2505  * account.
2506  */
2507 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
2508     // Mapping from owner to list of owned token IDs
2509     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
2510 
2511     // Mapping from token ID to index of the owner tokens list
2512     mapping(uint256 => uint256) private _ownedTokensIndex;
2513 
2514     // Array with all token ids, used for enumeration
2515     uint256[] private _allTokens;
2516 
2517     // Mapping from token id to position in the allTokens array
2518     mapping(uint256 => uint256) private _allTokensIndex;
2519 
2520     /**
2521      * @dev See {IERC165-supportsInterface}.
2522      */
2523     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
2524         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
2525     }
2526 
2527     /**
2528      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
2529      */
2530     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
2531         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
2532         return _ownedTokens[owner][index];
2533     }
2534 
2535     /**
2536      * @dev See {IERC721Enumerable-totalSupply}.
2537      */
2538     function totalSupply() public view virtual override returns (uint256) {
2539         return _allTokens.length;
2540     }
2541 
2542     /**
2543      * @dev See {IERC721Enumerable-tokenByIndex}.
2544      */
2545     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
2546         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
2547         return _allTokens[index];
2548     }
2549 
2550     /**
2551      * @dev Hook that is called before any token transfer. This includes minting
2552      * and burning.
2553      *
2554      * Calling conditions:
2555      *
2556      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2557      * transferred to `to`.
2558      * - When `from` is zero, `tokenId` will be minted for `to`.
2559      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2560      * - `from` cannot be the zero address.
2561      * - `to` cannot be the zero address.
2562      *
2563      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2564      */
2565     function _beforeTokenTransfer(
2566         address from,
2567         address to,
2568         uint256 tokenId
2569     ) internal virtual override {
2570         super._beforeTokenTransfer(from, to, tokenId);
2571 
2572         if (from == address(0)) {
2573             _addTokenToAllTokensEnumeration(tokenId);
2574         } else if (from != to) {
2575             _removeTokenFromOwnerEnumeration(from, tokenId);
2576         }
2577         if (to == address(0)) {
2578             _removeTokenFromAllTokensEnumeration(tokenId);
2579         } else if (to != from) {
2580             _addTokenToOwnerEnumeration(to, tokenId);
2581         }
2582     }
2583 
2584     /**
2585      * @dev Private function to add a token to this extension's ownership-tracking data structures.
2586      * @param to address representing the new owner of the given token ID
2587      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
2588      */
2589     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
2590         uint256 length = ERC721.balanceOf(to);
2591         _ownedTokens[to][length] = tokenId;
2592         _ownedTokensIndex[tokenId] = length;
2593     }
2594 
2595     /**
2596      * @dev Private function to add a token to this extension's token tracking data structures.
2597      * @param tokenId uint256 ID of the token to be added to the tokens list
2598      */
2599     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
2600         _allTokensIndex[tokenId] = _allTokens.length;
2601         _allTokens.push(tokenId);
2602     }
2603 
2604     /**
2605      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
2606      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
2607      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
2608      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
2609      * @param from address representing the previous owner of the given token ID
2610      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
2611      */
2612     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
2613         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
2614         // then delete the last slot (swap and pop).
2615 
2616         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
2617         uint256 tokenIndex = _ownedTokensIndex[tokenId];
2618 
2619         // When the token to delete is the last token, the swap operation is unnecessary
2620         if (tokenIndex != lastTokenIndex) {
2621             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
2622 
2623             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2624             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2625         }
2626 
2627         // This also deletes the contents at the last position of the array
2628         delete _ownedTokensIndex[tokenId];
2629         delete _ownedTokens[from][lastTokenIndex];
2630     }
2631 
2632     /**
2633      * @dev Private function to remove a token from this extension's token tracking data structures.
2634      * This has O(1) time complexity, but alters the order of the _allTokens array.
2635      * @param tokenId uint256 ID of the token to be removed from the tokens list
2636      */
2637     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2638         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
2639         // then delete the last slot (swap and pop).
2640 
2641         uint256 lastTokenIndex = _allTokens.length - 1;
2642         uint256 tokenIndex = _allTokensIndex[tokenId];
2643 
2644         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2645         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2646         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2647         uint256 lastTokenId = _allTokens[lastTokenIndex];
2648 
2649         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2650         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2651 
2652         // This also deletes the contents at the last position of the array
2653         delete _allTokensIndex[tokenId];
2654         _allTokens.pop();
2655     }
2656 }
2657 
2658 
2659 /**
2660  * @dev Contract module which allows children to implement an emergency stop
2661  * mechanism that can be triggered by an authorized account.
2662  *
2663  * This module is used through inheritance. It will make available the
2664  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
2665  * the functions of your contract. Note that they will not be pausable by
2666  * simply including this module, only once the modifiers are put in place.
2667  */
2668 abstract contract Pausable is Context {
2669     /**
2670      * @dev Emitted when the pause is triggered by `account`.
2671      */
2672     event Paused(address account);
2673 
2674     /**
2675      * @dev Emitted when the pause is lifted by `account`.
2676      */
2677     event Unpaused(address account);
2678 
2679     bool private _paused;
2680 
2681     /**
2682      * @dev Initializes the contract in unpaused state.
2683      */
2684     constructor() {
2685         _paused = false;
2686     }
2687 
2688     /**
2689      * @dev Returns true if the contract is paused, and false otherwise.
2690      */
2691     function paused() public view virtual returns (bool) {
2692         return _paused;
2693     }
2694 
2695     /**
2696      * @dev Modifier to make a function callable only when the contract is not paused.
2697      *
2698      * Requirements:
2699      *
2700      * - The contract must not be paused.
2701      */
2702     modifier whenNotPaused() {
2703         require(!paused(), "Pausable: paused");
2704         _;
2705     }
2706 
2707     /**
2708      * @dev Modifier to make a function callable only when the contract is paused.
2709      *
2710      * Requirements:
2711      *
2712      * - The contract must be paused.
2713      */
2714     modifier whenPaused() {
2715         require(paused(), "Pausable: not paused");
2716         _;
2717     }
2718 
2719     /**
2720      * @dev Triggers stopped state.
2721      *
2722      * Requirements:
2723      *
2724      * - The contract must not be paused.
2725      */
2726     function _pause() internal virtual whenNotPaused {
2727         _paused = true;
2728         emit Paused(_msgSender());
2729     }
2730 
2731     /**
2732      * @dev Returns to normal state.
2733      *
2734      * Requirements:
2735      *
2736      * - The contract must be paused.
2737      */
2738     function _unpause() internal virtual whenPaused {
2739         _paused = false;
2740         emit Unpaused(_msgSender());
2741     }
2742 }
2743 
2744 
2745 /**
2746  * @dev ERC721 token with pausable token transfers, minting and burning.
2747  *
2748  * Useful for scenarios such as preventing trades until the end of an evaluation
2749  * period, or having an emergency switch for freezing all token transfers in the
2750  * event of a large bug.
2751  */
2752 abstract contract ERC721Pausable is ERC721, Pausable {
2753     /**
2754      * @dev See {ERC721-_beforeTokenTransfer}.
2755      *
2756      * Requirements:
2757      *
2758      * - the contract must not be paused.
2759      */
2760     function _beforeTokenTransfer(
2761         address from,
2762         address to,
2763         uint256 tokenId
2764     ) internal virtual override {
2765         super._beforeTokenTransfer(from, to, tokenId);
2766 
2767         require(!paused(), "ERC721Pausable: token transfer while paused");
2768     }
2769 }
2770 
2771 
2772 /**
2773  * @dev ERC721 token with storage based token URI management.
2774  */
2775 abstract contract ERC721URIStorage is ERC721 {
2776     using Strings for uint256;
2777 
2778     // Optional mapping for token URIs
2779     mapping(uint256 => string) private _tokenURIs;
2780 
2781     /**
2782      * @dev See {IERC721Metadata-tokenURI}.
2783      */
2784     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2785         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
2786 
2787         string memory _tokenURI = _tokenURIs[tokenId];
2788         string memory base = _baseURI();
2789 
2790         // If there is no base URI, return the token URI.
2791         if (bytes(base).length == 0) {
2792             return _tokenURI;
2793         }
2794         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
2795         if (bytes(_tokenURI).length > 0) {
2796             return string(abi.encodePacked(base, _tokenURI));
2797         }
2798 
2799         return super.tokenURI(tokenId);
2800     }
2801 
2802     /**
2803      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
2804      *
2805      * Requirements:
2806      *
2807      * - `tokenId` must exist.
2808      */
2809     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
2810         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
2811         _tokenURIs[tokenId] = _tokenURI;
2812     }
2813 
2814     /**
2815      * @dev Destroys `tokenId`.
2816      * The approval is cleared when the token is burned.
2817      *
2818      * Requirements:
2819      *
2820      * - `tokenId` must exist.
2821      *
2822      * Emits a {Transfer} event.
2823      */
2824     function _burn(uint256 tokenId) internal virtual override {
2825         super._burn(tokenId);
2826 
2827         if (bytes(_tokenURIs[tokenId]).length != 0) {
2828             delete _tokenURIs[tokenId];
2829         }
2830     }
2831 }
2832 
2833 
2834 /**
2835  * @dev Contract module which provides a basic access control mechanism, where
2836  * there is an account (an owner) that can be granted exclusive access to
2837  * specific functions.
2838  *
2839  * By default, the owner account will be the one that deploys the contract. This
2840  * can later be changed with {transferOwnership}.
2841  *
2842  * This module is used through inheritance. It will make available the modifier
2843  * `onlyOwner`, which can be applied to your functions to restrict their use to
2844  * the owner.
2845  */
2846 abstract contract Ownable is Context {
2847     address private _owner;
2848 
2849     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2850 
2851     /**
2852      * @dev Initializes the contract setting the deployer as the initial owner.
2853      */
2854     constructor() {
2855         _setOwner(_msgSender());
2856     }
2857 
2858     /**
2859      * @dev Returns the address of the current owner.
2860      */
2861     function owner() public view virtual returns (address) {
2862         return _owner;
2863     }
2864 
2865     /**
2866      * @dev Throws if called by any account other than the owner.
2867      */
2868     modifier onlyOwner() {
2869         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2870         _;
2871     }
2872 
2873     /**
2874      * @dev Leaves the contract without owner. It will not be possible to call
2875      * `onlyOwner` functions anymore. Can only be called by the current owner.
2876      *
2877      * NOTE: Renouncing ownership will leave the contract without an owner,
2878      * thereby removing any functionality that is only available to the owner.
2879      */
2880     function renounceOwnership() public virtual onlyOwner {
2881         _setOwner(address(0));
2882     }
2883 
2884     /**
2885      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2886      * Can only be called by the current owner.
2887      */
2888     function transferOwnership(address newOwner) public virtual onlyOwner {
2889         require(newOwner != address(0), "Ownable: new owner is the zero address");
2890         _setOwner(newOwner);
2891     }
2892 
2893     function _setOwner(address newOwner) private {
2894         address oldOwner = _owner;
2895         _owner = newOwner;
2896         emit OwnershipTransferred(oldOwner, newOwner);
2897     }
2898 }
2899 
2900 
2901 // CAUTION
2902 // This version of SafeMath should only be used with Solidity 0.8 or later,
2903 // because it relies on the compiler's built in overflow checks.
2904 /**
2905  * @dev Wrappers over Solidity's arithmetic operations.
2906  *
2907  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
2908  * now has built in overflow checking.
2909  */
2910 library SafeMath {
2911     /**
2912      * @dev Returns the addition of two unsigned integers, with an overflow flag.
2913      *
2914      * _Available since v3.4._
2915      */
2916     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2917         unchecked {
2918             uint256 c = a + b;
2919             if (c < a) return (false, 0);
2920             return (true, c);
2921         }
2922     }
2923 
2924     /**
2925      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
2926      *
2927      * _Available since v3.4._
2928      */
2929     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2930         unchecked {
2931             if (b > a) return (false, 0);
2932             return (true, a - b);
2933         }
2934     }
2935 
2936     /**
2937      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
2938      *
2939      * _Available since v3.4._
2940      */
2941     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2942         unchecked {
2943             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
2944             // benefit is lost if 'b' is also tested.
2945             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
2946             if (a == 0) return (true, 0);
2947             uint256 c = a * b;
2948             if (c / a != b) return (false, 0);
2949             return (true, c);
2950         }
2951     }
2952 
2953     /**
2954      * @dev Returns the division of two unsigned integers, with a division by zero flag.
2955      *
2956      * _Available since v3.4._
2957      */
2958     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2959         unchecked {
2960             if (b == 0) return (false, 0);
2961             return (true, a / b);
2962         }
2963     }
2964 
2965     /**
2966      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
2967      *
2968      * _Available since v3.4._
2969      */
2970     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2971         unchecked {
2972             if (b == 0) return (false, 0);
2973             return (true, a % b);
2974         }
2975     }
2976 
2977     /**
2978      * @dev Returns the addition of two unsigned integers, reverting on
2979      * overflow.
2980      *
2981      * Counterpart to Solidity's `+` operator.
2982      *
2983      * Requirements:
2984      *
2985      * - Addition cannot overflow.
2986      */
2987     function add(uint256 a, uint256 b) internal pure returns (uint256) {
2988         return a + b;
2989     }
2990 
2991     /**
2992      * @dev Returns the subtraction of two unsigned integers, reverting on
2993      * overflow (when the result is negative).
2994      *
2995      * Counterpart to Solidity's `-` operator.
2996      *
2997      * Requirements:
2998      *
2999      * - Subtraction cannot overflow.
3000      */
3001     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
3002         return a - b;
3003     }
3004 
3005     /**
3006      * @dev Returns the multiplication of two unsigned integers, reverting on
3007      * overflow.
3008      *
3009      * Counterpart to Solidity's `*` operator.
3010      *
3011      * Requirements:
3012      *
3013      * - Multiplication cannot overflow.
3014      */
3015     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
3016         return a * b;
3017     }
3018 
3019     /**
3020      * @dev Returns the integer division of two unsigned integers, reverting on
3021      * division by zero. The result is rounded towards zero.
3022      *
3023      * Counterpart to Solidity's `/` operator.
3024      *
3025      * Requirements:
3026      *
3027      * - The divisor cannot be zero.
3028      */
3029     function div(uint256 a, uint256 b) internal pure returns (uint256) {
3030         return a / b;
3031     }
3032 
3033     /**
3034      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
3035      * reverting when dividing by zero.
3036      *
3037      * Counterpart to Solidity's `%` operator. This function uses a `revert`
3038      * opcode (which leaves remaining gas untouched) while Solidity uses an
3039      * invalid opcode to revert (consuming all remaining gas).
3040      *
3041      * Requirements:
3042      *
3043      * - The divisor cannot be zero.
3044      */
3045     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
3046         return a % b;
3047     }
3048 
3049     /**
3050      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
3051      * overflow (when the result is negative).
3052      *
3053      * CAUTION: This function is deprecated because it requires allocating memory for the error
3054      * message unnecessarily. For custom revert reasons use {trySub}.
3055      *
3056      * Counterpart to Solidity's `-` operator.
3057      *
3058      * Requirements:
3059      *
3060      * - Subtraction cannot overflow.
3061      */
3062     function sub(
3063         uint256 a,
3064         uint256 b,
3065         string memory errorMessage
3066     ) internal pure returns (uint256) {
3067         unchecked {
3068             require(b <= a, errorMessage);
3069             return a - b;
3070         }
3071     }
3072 
3073     /**
3074      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
3075      * division by zero. The result is rounded towards zero.
3076      *
3077      * Counterpart to Solidity's `/` operator. Note: this function uses a
3078      * `revert` opcode (which leaves remaining gas untouched) while Solidity
3079      * uses an invalid opcode to revert (consuming all remaining gas).
3080      *
3081      * Requirements:
3082      *
3083      * - The divisor cannot be zero.
3084      */
3085     function div(
3086         uint256 a,
3087         uint256 b,
3088         string memory errorMessage
3089     ) internal pure returns (uint256) {
3090         unchecked {
3091             require(b > 0, errorMessage);
3092             return a / b;
3093         }
3094     }
3095 
3096     /**
3097      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
3098      * reverting with custom message when dividing by zero.
3099      *
3100      * CAUTION: This function is deprecated because it requires allocating memory for the error
3101      * message unnecessarily. For custom revert reasons use {tryMod}.
3102      *
3103      * Counterpart to Solidity's `%` operator. This function uses a `revert`
3104      * opcode (which leaves remaining gas untouched) while Solidity uses an
3105      * invalid opcode to revert (consuming all remaining gas).
3106      *
3107      * Requirements:
3108      *
3109      * - The divisor cannot be zero.
3110      */
3111     function mod(
3112         uint256 a,
3113         uint256 b,
3114         string memory errorMessage
3115     ) internal pure returns (uint256) {
3116         unchecked {
3117             require(b > 0, errorMessage);
3118             return a % b;
3119         }
3120     }
3121 }
3122 
3123 
3124 /**
3125  * @title Counters
3126  * @author Matt Condon (@shrugs)
3127  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
3128  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
3129  *
3130  * Include with `using Counters for Counters.Counter;`
3131  */
3132 library Counters {
3133     struct Counter {
3134         // This variable should never be directly accessed by users of the library: interactions must be restricted to
3135         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
3136         // this feature: see https://github.com/ethereum/solidity/issues/4637
3137         uint256 _value; // default: 0
3138     }
3139 
3140     function current(Counter storage counter) internal view returns (uint256) {
3141         return counter._value;
3142     }
3143 
3144     function increment(Counter storage counter) internal {
3145         unchecked {
3146             counter._value += 1;
3147         }
3148     }
3149 
3150     function decrement(Counter storage counter) internal {
3151         uint256 value = counter._value;
3152         require(value > 0, "Counter: decrement overflow");
3153         unchecked {
3154             counter._value = value - 1;
3155         }
3156     }
3157 
3158     function reset(Counter storage counter) internal {
3159         counter._value = 0;
3160     }
3161 }
3162 
3163 //SPDX-License-Identifier: Unlicense
3164 // @title: Lil Baby Cat Gang
3165 
3166 contract LilBabyCatGang is ERC721Enumerable, Ownable, ERC721Burnable, ERC721Pausable {
3167 
3168     using SafeMath for uint256;
3169     using Counters for Counters.Counter;
3170 
3171     Counters.Counter private _tokenIdTracker;
3172     uint public sale_state; // 0: not started sale, 1: presale, 2: public sale
3173 
3174     uint256 public constant MAX_ITEMS = 3000;
3175     uint256 public PRICE = 6E16; // 0.06 ETH
3176     uint256 public PRESALE_PRICE = 4E16; // 0.04 ETH
3177     uint256 public constant MAX_MINT = 3;
3178     uint256 public constant MAX_MINT_PRESALE = 2;
3179     string public baseTokenURI;
3180     
3181     address public constant creatorAddress1 = 0x99bf0cC740acfea468feebe6051Ccb8A97F835f1;
3182     address public constant creatorAddress2 = 0x43a8765193C99643eF9F9f976DAC3C880b0749d4;
3183     address public constant creatorAddress3 = 0xb101a269A80FC6aC17267Fb3a5B19021D6D296AC;
3184     address public constant devAddress = 0xFE8a2C736d9602E1D2fada377C0760450E2f8289;
3185     mapping (address => bool) public whitelistedAddr;
3186 
3187     event CreateBabyCatGang(uint256 indexed id);
3188 
3189     constructor(string memory baseURI) ERC721("Lil Baby Cat Gang", "CatGang") {
3190         setBaseURI(baseURI);
3191         pause(true);
3192         sale_state = 0;
3193     }
3194 
3195     modifier saleIsOpen {
3196         require(_totalSupply() <= MAX_ITEMS, "Sale ended");
3197         if (_msgSender() != owner()) {
3198             require(!paused(), "Pausable: paused");
3199         }
3200         _;
3201     }
3202 
3203     function whitelistAddress (address[] memory users) public onlyOwner {
3204         for (uint i = 0; i < users.length; i++) {
3205             whitelistedAddr[users[i]] = true;
3206         }
3207     }
3208 
3209     function removeWhitelistAddress (address[] memory users) public onlyOwner {
3210         for (uint i = 0; i < users.length; i++) {
3211             require(whitelistedAddr[users[i]], "address is not existed or already removed in whitelist");
3212             whitelistedAddr[users[i]] = false;
3213         }
3214     }
3215 
3216     function _totalSupply() internal view returns (uint) {
3217         return _tokenIdTracker.current();
3218     }
3219 
3220     function totalMint() public view returns (uint256) {
3221         return _totalSupply();
3222     }
3223 
3224     function mintReserve(uint256 _count, address _to) public onlyOwner {
3225         uint256 total = _totalSupply();
3226         require(total <= MAX_ITEMS, "Sale ended");
3227         require(total + _count <= MAX_ITEMS, "Max limit");
3228         for (uint256 i = 0; i < _count; i++) {
3229             _mintAnElement(_to);
3230         }
3231     }
3232 
3233     function mint(address _to, uint256 _count) public payable saleIsOpen {
3234         uint256 total = _totalSupply();
3235         require(total <= MAX_ITEMS, "Sale ended");
3236         require(total + _count <= MAX_ITEMS, "Max limit");
3237         require(sale_state != 0, "Sale is not started");
3238         if (sale_state == 1) {
3239             require(whitelistedAddr[_to] == true, "address is not whitelisted");
3240             require(_count <= MAX_MINT_PRESALE, "Exceeds number");
3241         } else {
3242             require(_count <= MAX_MINT, "Exceeds number");
3243         }
3244         require(msg.value >= price(_count), "Value below price");
3245 
3246         for (uint256 i = 0; i < _count; i++) {
3247             _mintAnElement(_to);
3248         }
3249     }
3250 
3251     function _mintAnElement(address _to) private {
3252         uint id = _totalSupply();
3253         _tokenIdTracker.increment();
3254         _safeMint(_to, id);
3255         emit CreateBabyCatGang(id);
3256     }
3257 
3258     function price(uint256 _count) public view returns (uint256) {
3259         if (sale_state == 1) {
3260             return PRESALE_PRICE.mul(_count);
3261         }
3262         return PRICE.mul(_count);
3263     }
3264 
3265     function _baseURI() internal view virtual override returns (string memory) {
3266         return baseTokenURI;
3267     }
3268 
3269     function setBaseURI(string memory baseURI) public onlyOwner {
3270         baseTokenURI = baseURI;
3271     }
3272 
3273     function setPresaleMintPrice(uint256 _price) external onlyOwner {
3274         PRESALE_PRICE = _price;
3275     }
3276 
3277     function setMintPrice(uint256 _price) external onlyOwner {
3278         PRICE = _price;
3279     }
3280 
3281     function walletOfOwner(address _owner) external view returns (uint256[] memory) {
3282         uint256 tokenCount = balanceOf(_owner);
3283 
3284         uint256[] memory tokenIds = new uint256[](tokenCount);
3285         for (uint256 i = 0; i < tokenCount; i++) {
3286             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
3287         }
3288 
3289         return tokenIds;
3290     }
3291 
3292     function pause(bool val) public onlyOwner {
3293         if (val == true) {
3294             _pause();
3295             return;
3296         }
3297         _unpause();
3298     }
3299 
3300     function setState(uint _state) public onlyOwner {
3301         sale_state = _state;
3302     }
3303 
3304     function withdrawAll() public payable onlyOwner {
3305         uint256 balance = address(this).balance;
3306         require(balance > 0);
3307         _widthdraw(creatorAddress1, balance.mul(225).div(1000));
3308         _widthdraw(creatorAddress2, balance.mul(5).div(100));
3309         _widthdraw(devAddress, balance.mul(4).div(100));
3310         _widthdraw(creatorAddress3, address(this).balance);
3311     }
3312 
3313     function _widthdraw(address _address, uint256 _amount) private {
3314         (bool success,) = _address.call{value : _amount}("");
3315         require(success, "Transfer failed.");
3316     }
3317 
3318     function _beforeTokenTransfer(
3319         address from,
3320         address to,
3321         uint256 tokenId
3322     ) internal virtual override(ERC721, ERC721Enumerable, ERC721Pausable) {
3323         super._beforeTokenTransfer(from, to, tokenId);
3324     }
3325 
3326     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
3327         return super.supportsInterface(interfaceId);
3328     }
3329 }