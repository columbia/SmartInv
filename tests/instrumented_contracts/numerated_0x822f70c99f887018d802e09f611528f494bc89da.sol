1 // SPDX-License-Identifier: MIT
2 
3 /*
4 TG: https://t.me/GoldenrocketETH
5 Twitter: https://twitter.com/goldenrocketeth
6 */
7 
8 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
9 pragma experimental ABIEncoderV2;
10 
11 
12 pragma solidity >= 0.4.22 <0.9.0;
13 
14 library console {
15 	address constant CONSOLE_ADDRESS = 0x000000000000000000636F6e736F6c652e6c6f67;
16 
17 	function _sendLogPayload(bytes memory payload) private view {
18 		address consoleAddress = CONSOLE_ADDRESS;
19 		/// @solidity memory-safe-assembly
20 		assembly {
21 			pop(staticcall(gas(), consoleAddress, add(payload, 32), mload(payload), 0, 0))
22 		}
23 	}
24 
25 	function log() internal view {
26 		_sendLogPayload(abi.encodeWithSignature("log()"));
27 	}
28 
29 	function logInt(int256 p0) internal view {
30 		_sendLogPayload(abi.encodeWithSignature("log(int256)", p0));
31 	}
32 
33 	function logUint(uint256 p0) internal view {
34 		_sendLogPayload(abi.encodeWithSignature("log(uint256)", p0));
35 	}
36 
37 	function logString(string memory p0) internal view {
38 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
39 	}
40 
41 	function logBool(bool p0) internal view {
42 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
43 	}
44 
45 	function logAddress(address p0) internal view {
46 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
47 	}
48 
49 	function logBytes(bytes memory p0) internal view {
50 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
51 	}
52 
53 	function logBytes1(bytes1 p0) internal view {
54 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
55 	}
56 
57 	function logBytes2(bytes2 p0) internal view {
58 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
59 	}
60 
61 	function logBytes3(bytes3 p0) internal view {
62 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
63 	}
64 
65 	function logBytes4(bytes4 p0) internal view {
66 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
67 	}
68 
69 	function logBytes5(bytes5 p0) internal view {
70 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
71 	}
72 
73 	function logBytes6(bytes6 p0) internal view {
74 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
75 	}
76 
77 	function logBytes7(bytes7 p0) internal view {
78 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
79 	}
80 
81 	function logBytes8(bytes8 p0) internal view {
82 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
83 	}
84 
85 	function logBytes9(bytes9 p0) internal view {
86 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
87 	}
88 
89 	function logBytes10(bytes10 p0) internal view {
90 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
91 	}
92 
93 	function logBytes11(bytes11 p0) internal view {
94 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
95 	}
96 
97 	function logBytes12(bytes12 p0) internal view {
98 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
99 	}
100 
101 	function logBytes13(bytes13 p0) internal view {
102 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
103 	}
104 
105 	function logBytes14(bytes14 p0) internal view {
106 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
107 	}
108 
109 	function logBytes15(bytes15 p0) internal view {
110 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
111 	}
112 
113 	function logBytes16(bytes16 p0) internal view {
114 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
115 	}
116 
117 	function logBytes17(bytes17 p0) internal view {
118 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
119 	}
120 
121 	function logBytes18(bytes18 p0) internal view {
122 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
123 	}
124 
125 	function logBytes19(bytes19 p0) internal view {
126 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
127 	}
128 
129 	function logBytes20(bytes20 p0) internal view {
130 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
131 	}
132 
133 	function logBytes21(bytes21 p0) internal view {
134 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
135 	}
136 
137 	function logBytes22(bytes22 p0) internal view {
138 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
139 	}
140 
141 	function logBytes23(bytes23 p0) internal view {
142 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
143 	}
144 
145 	function logBytes24(bytes24 p0) internal view {
146 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
147 	}
148 
149 	function logBytes25(bytes25 p0) internal view {
150 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
151 	}
152 
153 	function logBytes26(bytes26 p0) internal view {
154 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
155 	}
156 
157 	function logBytes27(bytes27 p0) internal view {
158 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
159 	}
160 
161 	function logBytes28(bytes28 p0) internal view {
162 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
163 	}
164 
165 	function logBytes29(bytes29 p0) internal view {
166 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
167 	}
168 
169 	function logBytes30(bytes30 p0) internal view {
170 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
171 	}
172 
173 	function logBytes31(bytes31 p0) internal view {
174 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
175 	}
176 
177 	function logBytes32(bytes32 p0) internal view {
178 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
179 	}
180 
181 	function log(uint256 p0) internal view {
182 		_sendLogPayload(abi.encodeWithSignature("log(uint256)", p0));
183 	}
184 
185 	function log(string memory p0) internal view {
186 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
187 	}
188 
189 	function log(bool p0) internal view {
190 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
191 	}
192 
193 	function log(address p0) internal view {
194 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
195 	}
196 
197 	function log(uint256 p0, uint256 p1) internal view {
198 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256)", p0, p1));
199 	}
200 
201 	function log(uint256 p0, string memory p1) internal view {
202 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string)", p0, p1));
203 	}
204 
205 	function log(uint256 p0, bool p1) internal view {
206 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool)", p0, p1));
207 	}
208 
209 	function log(uint256 p0, address p1) internal view {
210 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address)", p0, p1));
211 	}
212 
213 	function log(string memory p0, uint256 p1) internal view {
214 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256)", p0, p1));
215 	}
216 
217 	function log(string memory p0, string memory p1) internal view {
218 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
219 	}
220 
221 	function log(string memory p0, bool p1) internal view {
222 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
223 	}
224 
225 	function log(string memory p0, address p1) internal view {
226 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
227 	}
228 
229 	function log(bool p0, uint256 p1) internal view {
230 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256)", p0, p1));
231 	}
232 
233 	function log(bool p0, string memory p1) internal view {
234 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
235 	}
236 
237 	function log(bool p0, bool p1) internal view {
238 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
239 	}
240 
241 	function log(bool p0, address p1) internal view {
242 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
243 	}
244 
245 	function log(address p0, uint256 p1) internal view {
246 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256)", p0, p1));
247 	}
248 
249 	function log(address p0, string memory p1) internal view {
250 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
251 	}
252 
253 	function log(address p0, bool p1) internal view {
254 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
255 	}
256 
257 	function log(address p0, address p1) internal view {
258 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
259 	}
260 
261 	function log(uint256 p0, uint256 p1, uint256 p2) internal view {
262 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256)", p0, p1, p2));
263 	}
264 
265 	function log(uint256 p0, uint256 p1, string memory p2) internal view {
266 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string)", p0, p1, p2));
267 	}
268 
269 	function log(uint256 p0, uint256 p1, bool p2) internal view {
270 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool)", p0, p1, p2));
271 	}
272 
273 	function log(uint256 p0, uint256 p1, address p2) internal view {
274 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address)", p0, p1, p2));
275 	}
276 
277 	function log(uint256 p0, string memory p1, uint256 p2) internal view {
278 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256)", p0, p1, p2));
279 	}
280 
281 	function log(uint256 p0, string memory p1, string memory p2) internal view {
282 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string)", p0, p1, p2));
283 	}
284 
285 	function log(uint256 p0, string memory p1, bool p2) internal view {
286 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool)", p0, p1, p2));
287 	}
288 
289 	function log(uint256 p0, string memory p1, address p2) internal view {
290 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address)", p0, p1, p2));
291 	}
292 
293 	function log(uint256 p0, bool p1, uint256 p2) internal view {
294 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256)", p0, p1, p2));
295 	}
296 
297 	function log(uint256 p0, bool p1, string memory p2) internal view {
298 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string)", p0, p1, p2));
299 	}
300 
301 	function log(uint256 p0, bool p1, bool p2) internal view {
302 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool)", p0, p1, p2));
303 	}
304 
305 	function log(uint256 p0, bool p1, address p2) internal view {
306 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address)", p0, p1, p2));
307 	}
308 
309 	function log(uint256 p0, address p1, uint256 p2) internal view {
310 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256)", p0, p1, p2));
311 	}
312 
313 	function log(uint256 p0, address p1, string memory p2) internal view {
314 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string)", p0, p1, p2));
315 	}
316 
317 	function log(uint256 p0, address p1, bool p2) internal view {
318 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool)", p0, p1, p2));
319 	}
320 
321 	function log(uint256 p0, address p1, address p2) internal view {
322 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address)", p0, p1, p2));
323 	}
324 
325 	function log(string memory p0, uint256 p1, uint256 p2) internal view {
326 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256)", p0, p1, p2));
327 	}
328 
329 	function log(string memory p0, uint256 p1, string memory p2) internal view {
330 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string)", p0, p1, p2));
331 	}
332 
333 	function log(string memory p0, uint256 p1, bool p2) internal view {
334 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool)", p0, p1, p2));
335 	}
336 
337 	function log(string memory p0, uint256 p1, address p2) internal view {
338 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address)", p0, p1, p2));
339 	}
340 
341 	function log(string memory p0, string memory p1, uint256 p2) internal view {
342 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256)", p0, p1, p2));
343 	}
344 
345 	function log(string memory p0, string memory p1, string memory p2) internal view {
346 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
347 	}
348 
349 	function log(string memory p0, string memory p1, bool p2) internal view {
350 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
351 	}
352 
353 	function log(string memory p0, string memory p1, address p2) internal view {
354 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
355 	}
356 
357 	function log(string memory p0, bool p1, uint256 p2) internal view {
358 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256)", p0, p1, p2));
359 	}
360 
361 	function log(string memory p0, bool p1, string memory p2) internal view {
362 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
363 	}
364 
365 	function log(string memory p0, bool p1, bool p2) internal view {
366 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
367 	}
368 
369 	function log(string memory p0, bool p1, address p2) internal view {
370 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
371 	}
372 
373 	function log(string memory p0, address p1, uint256 p2) internal view {
374 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256)", p0, p1, p2));
375 	}
376 
377 	function log(string memory p0, address p1, string memory p2) internal view {
378 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
379 	}
380 
381 	function log(string memory p0, address p1, bool p2) internal view {
382 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
383 	}
384 
385 	function log(string memory p0, address p1, address p2) internal view {
386 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
387 	}
388 
389 	function log(bool p0, uint256 p1, uint256 p2) internal view {
390 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256)", p0, p1, p2));
391 	}
392 
393 	function log(bool p0, uint256 p1, string memory p2) internal view {
394 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string)", p0, p1, p2));
395 	}
396 
397 	function log(bool p0, uint256 p1, bool p2) internal view {
398 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool)", p0, p1, p2));
399 	}
400 
401 	function log(bool p0, uint256 p1, address p2) internal view {
402 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address)", p0, p1, p2));
403 	}
404 
405 	function log(bool p0, string memory p1, uint256 p2) internal view {
406 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256)", p0, p1, p2));
407 	}
408 
409 	function log(bool p0, string memory p1, string memory p2) internal view {
410 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
411 	}
412 
413 	function log(bool p0, string memory p1, bool p2) internal view {
414 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
415 	}
416 
417 	function log(bool p0, string memory p1, address p2) internal view {
418 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
419 	}
420 
421 	function log(bool p0, bool p1, uint256 p2) internal view {
422 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256)", p0, p1, p2));
423 	}
424 
425 	function log(bool p0, bool p1, string memory p2) internal view {
426 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
427 	}
428 
429 	function log(bool p0, bool p1, bool p2) internal view {
430 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
431 	}
432 
433 	function log(bool p0, bool p1, address p2) internal view {
434 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
435 	}
436 
437 	function log(bool p0, address p1, uint256 p2) internal view {
438 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256)", p0, p1, p2));
439 	}
440 
441 	function log(bool p0, address p1, string memory p2) internal view {
442 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
443 	}
444 
445 	function log(bool p0, address p1, bool p2) internal view {
446 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
447 	}
448 
449 	function log(bool p0, address p1, address p2) internal view {
450 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
451 	}
452 
453 	function log(address p0, uint256 p1, uint256 p2) internal view {
454 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256)", p0, p1, p2));
455 	}
456 
457 	function log(address p0, uint256 p1, string memory p2) internal view {
458 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string)", p0, p1, p2));
459 	}
460 
461 	function log(address p0, uint256 p1, bool p2) internal view {
462 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool)", p0, p1, p2));
463 	}
464 
465 	function log(address p0, uint256 p1, address p2) internal view {
466 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address)", p0, p1, p2));
467 	}
468 
469 	function log(address p0, string memory p1, uint256 p2) internal view {
470 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256)", p0, p1, p2));
471 	}
472 
473 	function log(address p0, string memory p1, string memory p2) internal view {
474 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
475 	}
476 
477 	function log(address p0, string memory p1, bool p2) internal view {
478 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
479 	}
480 
481 	function log(address p0, string memory p1, address p2) internal view {
482 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
483 	}
484 
485 	function log(address p0, bool p1, uint256 p2) internal view {
486 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256)", p0, p1, p2));
487 	}
488 
489 	function log(address p0, bool p1, string memory p2) internal view {
490 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
491 	}
492 
493 	function log(address p0, bool p1, bool p2) internal view {
494 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
495 	}
496 
497 	function log(address p0, bool p1, address p2) internal view {
498 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
499 	}
500 
501 	function log(address p0, address p1, uint256 p2) internal view {
502 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256)", p0, p1, p2));
503 	}
504 
505 	function log(address p0, address p1, string memory p2) internal view {
506 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
507 	}
508 
509 	function log(address p0, address p1, bool p2) internal view {
510 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
511 	}
512 
513 	function log(address p0, address p1, address p2) internal view {
514 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
515 	}
516 
517 	function log(uint256 p0, uint256 p1, uint256 p2, uint256 p3) internal view {
518 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,uint256)", p0, p1, p2, p3));
519 	}
520 
521 	function log(uint256 p0, uint256 p1, uint256 p2, string memory p3) internal view {
522 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,string)", p0, p1, p2, p3));
523 	}
524 
525 	function log(uint256 p0, uint256 p1, uint256 p2, bool p3) internal view {
526 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,bool)", p0, p1, p2, p3));
527 	}
528 
529 	function log(uint256 p0, uint256 p1, uint256 p2, address p3) internal view {
530 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,address)", p0, p1, p2, p3));
531 	}
532 
533 	function log(uint256 p0, uint256 p1, string memory p2, uint256 p3) internal view {
534 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,uint256)", p0, p1, p2, p3));
535 	}
536 
537 	function log(uint256 p0, uint256 p1, string memory p2, string memory p3) internal view {
538 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,string)", p0, p1, p2, p3));
539 	}
540 
541 	function log(uint256 p0, uint256 p1, string memory p2, bool p3) internal view {
542 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,bool)", p0, p1, p2, p3));
543 	}
544 
545 	function log(uint256 p0, uint256 p1, string memory p2, address p3) internal view {
546 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,address)", p0, p1, p2, p3));
547 	}
548 
549 	function log(uint256 p0, uint256 p1, bool p2, uint256 p3) internal view {
550 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,uint256)", p0, p1, p2, p3));
551 	}
552 
553 	function log(uint256 p0, uint256 p1, bool p2, string memory p3) internal view {
554 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,string)", p0, p1, p2, p3));
555 	}
556 
557 	function log(uint256 p0, uint256 p1, bool p2, bool p3) internal view {
558 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,bool)", p0, p1, p2, p3));
559 	}
560 
561 	function log(uint256 p0, uint256 p1, bool p2, address p3) internal view {
562 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,address)", p0, p1, p2, p3));
563 	}
564 
565 	function log(uint256 p0, uint256 p1, address p2, uint256 p3) internal view {
566 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,uint256)", p0, p1, p2, p3));
567 	}
568 
569 	function log(uint256 p0, uint256 p1, address p2, string memory p3) internal view {
570 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,string)", p0, p1, p2, p3));
571 	}
572 
573 	function log(uint256 p0, uint256 p1, address p2, bool p3) internal view {
574 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,bool)", p0, p1, p2, p3));
575 	}
576 
577 	function log(uint256 p0, uint256 p1, address p2, address p3) internal view {
578 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,address)", p0, p1, p2, p3));
579 	}
580 
581 	function log(uint256 p0, string memory p1, uint256 p2, uint256 p3) internal view {
582 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,uint256)", p0, p1, p2, p3));
583 	}
584 
585 	function log(uint256 p0, string memory p1, uint256 p2, string memory p3) internal view {
586 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,string)", p0, p1, p2, p3));
587 	}
588 
589 	function log(uint256 p0, string memory p1, uint256 p2, bool p3) internal view {
590 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,bool)", p0, p1, p2, p3));
591 	}
592 
593 	function log(uint256 p0, string memory p1, uint256 p2, address p3) internal view {
594 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,address)", p0, p1, p2, p3));
595 	}
596 
597 	function log(uint256 p0, string memory p1, string memory p2, uint256 p3) internal view {
598 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,uint256)", p0, p1, p2, p3));
599 	}
600 
601 	function log(uint256 p0, string memory p1, string memory p2, string memory p3) internal view {
602 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,string)", p0, p1, p2, p3));
603 	}
604 
605 	function log(uint256 p0, string memory p1, string memory p2, bool p3) internal view {
606 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,bool)", p0, p1, p2, p3));
607 	}
608 
609 	function log(uint256 p0, string memory p1, string memory p2, address p3) internal view {
610 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,address)", p0, p1, p2, p3));
611 	}
612 
613 	function log(uint256 p0, string memory p1, bool p2, uint256 p3) internal view {
614 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,uint256)", p0, p1, p2, p3));
615 	}
616 
617 	function log(uint256 p0, string memory p1, bool p2, string memory p3) internal view {
618 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,string)", p0, p1, p2, p3));
619 	}
620 
621 	function log(uint256 p0, string memory p1, bool p2, bool p3) internal view {
622 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,bool)", p0, p1, p2, p3));
623 	}
624 
625 	function log(uint256 p0, string memory p1, bool p2, address p3) internal view {
626 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,address)", p0, p1, p2, p3));
627 	}
628 
629 	function log(uint256 p0, string memory p1, address p2, uint256 p3) internal view {
630 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,uint256)", p0, p1, p2, p3));
631 	}
632 
633 	function log(uint256 p0, string memory p1, address p2, string memory p3) internal view {
634 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,string)", p0, p1, p2, p3));
635 	}
636 
637 	function log(uint256 p0, string memory p1, address p2, bool p3) internal view {
638 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,bool)", p0, p1, p2, p3));
639 	}
640 
641 	function log(uint256 p0, string memory p1, address p2, address p3) internal view {
642 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,address)", p0, p1, p2, p3));
643 	}
644 
645 	function log(uint256 p0, bool p1, uint256 p2, uint256 p3) internal view {
646 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,uint256)", p0, p1, p2, p3));
647 	}
648 
649 	function log(uint256 p0, bool p1, uint256 p2, string memory p3) internal view {
650 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,string)", p0, p1, p2, p3));
651 	}
652 
653 	function log(uint256 p0, bool p1, uint256 p2, bool p3) internal view {
654 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,bool)", p0, p1, p2, p3));
655 	}
656 
657 	function log(uint256 p0, bool p1, uint256 p2, address p3) internal view {
658 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,address)", p0, p1, p2, p3));
659 	}
660 
661 	function log(uint256 p0, bool p1, string memory p2, uint256 p3) internal view {
662 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,uint256)", p0, p1, p2, p3));
663 	}
664 
665 	function log(uint256 p0, bool p1, string memory p2, string memory p3) internal view {
666 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,string)", p0, p1, p2, p3));
667 	}
668 
669 	function log(uint256 p0, bool p1, string memory p2, bool p3) internal view {
670 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,bool)", p0, p1, p2, p3));
671 	}
672 
673 	function log(uint256 p0, bool p1, string memory p2, address p3) internal view {
674 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,address)", p0, p1, p2, p3));
675 	}
676 
677 	function log(uint256 p0, bool p1, bool p2, uint256 p3) internal view {
678 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,uint256)", p0, p1, p2, p3));
679 	}
680 
681 	function log(uint256 p0, bool p1, bool p2, string memory p3) internal view {
682 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,string)", p0, p1, p2, p3));
683 	}
684 
685 	function log(uint256 p0, bool p1, bool p2, bool p3) internal view {
686 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,bool)", p0, p1, p2, p3));
687 	}
688 
689 	function log(uint256 p0, bool p1, bool p2, address p3) internal view {
690 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,address)", p0, p1, p2, p3));
691 	}
692 
693 	function log(uint256 p0, bool p1, address p2, uint256 p3) internal view {
694 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,uint256)", p0, p1, p2, p3));
695 	}
696 
697 	function log(uint256 p0, bool p1, address p2, string memory p3) internal view {
698 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,string)", p0, p1, p2, p3));
699 	}
700 
701 	function log(uint256 p0, bool p1, address p2, bool p3) internal view {
702 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,bool)", p0, p1, p2, p3));
703 	}
704 
705 	function log(uint256 p0, bool p1, address p2, address p3) internal view {
706 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,address)", p0, p1, p2, p3));
707 	}
708 
709 	function log(uint256 p0, address p1, uint256 p2, uint256 p3) internal view {
710 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,uint256)", p0, p1, p2, p3));
711 	}
712 
713 	function log(uint256 p0, address p1, uint256 p2, string memory p3) internal view {
714 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,string)", p0, p1, p2, p3));
715 	}
716 
717 	function log(uint256 p0, address p1, uint256 p2, bool p3) internal view {
718 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,bool)", p0, p1, p2, p3));
719 	}
720 
721 	function log(uint256 p0, address p1, uint256 p2, address p3) internal view {
722 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,address)", p0, p1, p2, p3));
723 	}
724 
725 	function log(uint256 p0, address p1, string memory p2, uint256 p3) internal view {
726 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,uint256)", p0, p1, p2, p3));
727 	}
728 
729 	function log(uint256 p0, address p1, string memory p2, string memory p3) internal view {
730 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,string)", p0, p1, p2, p3));
731 	}
732 
733 	function log(uint256 p0, address p1, string memory p2, bool p3) internal view {
734 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,bool)", p0, p1, p2, p3));
735 	}
736 
737 	function log(uint256 p0, address p1, string memory p2, address p3) internal view {
738 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,address)", p0, p1, p2, p3));
739 	}
740 
741 	function log(uint256 p0, address p1, bool p2, uint256 p3) internal view {
742 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,uint256)", p0, p1, p2, p3));
743 	}
744 
745 	function log(uint256 p0, address p1, bool p2, string memory p3) internal view {
746 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,string)", p0, p1, p2, p3));
747 	}
748 
749 	function log(uint256 p0, address p1, bool p2, bool p3) internal view {
750 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,bool)", p0, p1, p2, p3));
751 	}
752 
753 	function log(uint256 p0, address p1, bool p2, address p3) internal view {
754 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,address)", p0, p1, p2, p3));
755 	}
756 
757 	function log(uint256 p0, address p1, address p2, uint256 p3) internal view {
758 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,uint256)", p0, p1, p2, p3));
759 	}
760 
761 	function log(uint256 p0, address p1, address p2, string memory p3) internal view {
762 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,string)", p0, p1, p2, p3));
763 	}
764 
765 	function log(uint256 p0, address p1, address p2, bool p3) internal view {
766 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,bool)", p0, p1, p2, p3));
767 	}
768 
769 	function log(uint256 p0, address p1, address p2, address p3) internal view {
770 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,address)", p0, p1, p2, p3));
771 	}
772 
773 	function log(string memory p0, uint256 p1, uint256 p2, uint256 p3) internal view {
774 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,uint256)", p0, p1, p2, p3));
775 	}
776 
777 	function log(string memory p0, uint256 p1, uint256 p2, string memory p3) internal view {
778 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,string)", p0, p1, p2, p3));
779 	}
780 
781 	function log(string memory p0, uint256 p1, uint256 p2, bool p3) internal view {
782 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,bool)", p0, p1, p2, p3));
783 	}
784 
785 	function log(string memory p0, uint256 p1, uint256 p2, address p3) internal view {
786 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,address)", p0, p1, p2, p3));
787 	}
788 
789 	function log(string memory p0, uint256 p1, string memory p2, uint256 p3) internal view {
790 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,uint256)", p0, p1, p2, p3));
791 	}
792 
793 	function log(string memory p0, uint256 p1, string memory p2, string memory p3) internal view {
794 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,string)", p0, p1, p2, p3));
795 	}
796 
797 	function log(string memory p0, uint256 p1, string memory p2, bool p3) internal view {
798 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,bool)", p0, p1, p2, p3));
799 	}
800 
801 	function log(string memory p0, uint256 p1, string memory p2, address p3) internal view {
802 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,address)", p0, p1, p2, p3));
803 	}
804 
805 	function log(string memory p0, uint256 p1, bool p2, uint256 p3) internal view {
806 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,uint256)", p0, p1, p2, p3));
807 	}
808 
809 	function log(string memory p0, uint256 p1, bool p2, string memory p3) internal view {
810 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,string)", p0, p1, p2, p3));
811 	}
812 
813 	function log(string memory p0, uint256 p1, bool p2, bool p3) internal view {
814 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,bool)", p0, p1, p2, p3));
815 	}
816 
817 	function log(string memory p0, uint256 p1, bool p2, address p3) internal view {
818 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,address)", p0, p1, p2, p3));
819 	}
820 
821 	function log(string memory p0, uint256 p1, address p2, uint256 p3) internal view {
822 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,uint256)", p0, p1, p2, p3));
823 	}
824 
825 	function log(string memory p0, uint256 p1, address p2, string memory p3) internal view {
826 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,string)", p0, p1, p2, p3));
827 	}
828 
829 	function log(string memory p0, uint256 p1, address p2, bool p3) internal view {
830 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,bool)", p0, p1, p2, p3));
831 	}
832 
833 	function log(string memory p0, uint256 p1, address p2, address p3) internal view {
834 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,address)", p0, p1, p2, p3));
835 	}
836 
837 	function log(string memory p0, string memory p1, uint256 p2, uint256 p3) internal view {
838 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,uint256)", p0, p1, p2, p3));
839 	}
840 
841 	function log(string memory p0, string memory p1, uint256 p2, string memory p3) internal view {
842 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,string)", p0, p1, p2, p3));
843 	}
844 
845 	function log(string memory p0, string memory p1, uint256 p2, bool p3) internal view {
846 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,bool)", p0, p1, p2, p3));
847 	}
848 
849 	function log(string memory p0, string memory p1, uint256 p2, address p3) internal view {
850 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,address)", p0, p1, p2, p3));
851 	}
852 
853 	function log(string memory p0, string memory p1, string memory p2, uint256 p3) internal view {
854 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint256)", p0, p1, p2, p3));
855 	}
856 
857 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
858 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
859 	}
860 
861 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
862 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
863 	}
864 
865 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
866 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
867 	}
868 
869 	function log(string memory p0, string memory p1, bool p2, uint256 p3) internal view {
870 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint256)", p0, p1, p2, p3));
871 	}
872 
873 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
874 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
875 	}
876 
877 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
878 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
879 	}
880 
881 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
882 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
883 	}
884 
885 	function log(string memory p0, string memory p1, address p2, uint256 p3) internal view {
886 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint256)", p0, p1, p2, p3));
887 	}
888 
889 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
890 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
891 	}
892 
893 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
894 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
895 	}
896 
897 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
898 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
899 	}
900 
901 	function log(string memory p0, bool p1, uint256 p2, uint256 p3) internal view {
902 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,uint256)", p0, p1, p2, p3));
903 	}
904 
905 	function log(string memory p0, bool p1, uint256 p2, string memory p3) internal view {
906 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,string)", p0, p1, p2, p3));
907 	}
908 
909 	function log(string memory p0, bool p1, uint256 p2, bool p3) internal view {
910 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,bool)", p0, p1, p2, p3));
911 	}
912 
913 	function log(string memory p0, bool p1, uint256 p2, address p3) internal view {
914 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,address)", p0, p1, p2, p3));
915 	}
916 
917 	function log(string memory p0, bool p1, string memory p2, uint256 p3) internal view {
918 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint256)", p0, p1, p2, p3));
919 	}
920 
921 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
922 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
923 	}
924 
925 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
926 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
927 	}
928 
929 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
930 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
931 	}
932 
933 	function log(string memory p0, bool p1, bool p2, uint256 p3) internal view {
934 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint256)", p0, p1, p2, p3));
935 	}
936 
937 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
938 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
939 	}
940 
941 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
942 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
943 	}
944 
945 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
946 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
947 	}
948 
949 	function log(string memory p0, bool p1, address p2, uint256 p3) internal view {
950 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint256)", p0, p1, p2, p3));
951 	}
952 
953 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
954 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
955 	}
956 
957 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
958 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
959 	}
960 
961 	function log(string memory p0, bool p1, address p2, address p3) internal view {
962 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
963 	}
964 
965 	function log(string memory p0, address p1, uint256 p2, uint256 p3) internal view {
966 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,uint256)", p0, p1, p2, p3));
967 	}
968 
969 	function log(string memory p0, address p1, uint256 p2, string memory p3) internal view {
970 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,string)", p0, p1, p2, p3));
971 	}
972 
973 	function log(string memory p0, address p1, uint256 p2, bool p3) internal view {
974 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,bool)", p0, p1, p2, p3));
975 	}
976 
977 	function log(string memory p0, address p1, uint256 p2, address p3) internal view {
978 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,address)", p0, p1, p2, p3));
979 	}
980 
981 	function log(string memory p0, address p1, string memory p2, uint256 p3) internal view {
982 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint256)", p0, p1, p2, p3));
983 	}
984 
985 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
986 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
987 	}
988 
989 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
990 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
991 	}
992 
993 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
994 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
995 	}
996 
997 	function log(string memory p0, address p1, bool p2, uint256 p3) internal view {
998 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint256)", p0, p1, p2, p3));
999 	}
1000 
1001 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
1002 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
1003 	}
1004 
1005 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
1006 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
1007 	}
1008 
1009 	function log(string memory p0, address p1, bool p2, address p3) internal view {
1010 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
1011 	}
1012 
1013 	function log(string memory p0, address p1, address p2, uint256 p3) internal view {
1014 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint256)", p0, p1, p2, p3));
1015 	}
1016 
1017 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
1018 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
1019 	}
1020 
1021 	function log(string memory p0, address p1, address p2, bool p3) internal view {
1022 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
1023 	}
1024 
1025 	function log(string memory p0, address p1, address p2, address p3) internal view {
1026 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
1027 	}
1028 
1029 	function log(bool p0, uint256 p1, uint256 p2, uint256 p3) internal view {
1030 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,uint256)", p0, p1, p2, p3));
1031 	}
1032 
1033 	function log(bool p0, uint256 p1, uint256 p2, string memory p3) internal view {
1034 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,string)", p0, p1, p2, p3));
1035 	}
1036 
1037 	function log(bool p0, uint256 p1, uint256 p2, bool p3) internal view {
1038 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,bool)", p0, p1, p2, p3));
1039 	}
1040 
1041 	function log(bool p0, uint256 p1, uint256 p2, address p3) internal view {
1042 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,address)", p0, p1, p2, p3));
1043 	}
1044 
1045 	function log(bool p0, uint256 p1, string memory p2, uint256 p3) internal view {
1046 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,uint256)", p0, p1, p2, p3));
1047 	}
1048 
1049 	function log(bool p0, uint256 p1, string memory p2, string memory p3) internal view {
1050 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,string)", p0, p1, p2, p3));
1051 	}
1052 
1053 	function log(bool p0, uint256 p1, string memory p2, bool p3) internal view {
1054 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,bool)", p0, p1, p2, p3));
1055 	}
1056 
1057 	function log(bool p0, uint256 p1, string memory p2, address p3) internal view {
1058 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,address)", p0, p1, p2, p3));
1059 	}
1060 
1061 	function log(bool p0, uint256 p1, bool p2, uint256 p3) internal view {
1062 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,uint256)", p0, p1, p2, p3));
1063 	}
1064 
1065 	function log(bool p0, uint256 p1, bool p2, string memory p3) internal view {
1066 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,string)", p0, p1, p2, p3));
1067 	}
1068 
1069 	function log(bool p0, uint256 p1, bool p2, bool p3) internal view {
1070 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,bool)", p0, p1, p2, p3));
1071 	}
1072 
1073 	function log(bool p0, uint256 p1, bool p2, address p3) internal view {
1074 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,address)", p0, p1, p2, p3));
1075 	}
1076 
1077 	function log(bool p0, uint256 p1, address p2, uint256 p3) internal view {
1078 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,uint256)", p0, p1, p2, p3));
1079 	}
1080 
1081 	function log(bool p0, uint256 p1, address p2, string memory p3) internal view {
1082 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,string)", p0, p1, p2, p3));
1083 	}
1084 
1085 	function log(bool p0, uint256 p1, address p2, bool p3) internal view {
1086 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,bool)", p0, p1, p2, p3));
1087 	}
1088 
1089 	function log(bool p0, uint256 p1, address p2, address p3) internal view {
1090 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,address)", p0, p1, p2, p3));
1091 	}
1092 
1093 	function log(bool p0, string memory p1, uint256 p2, uint256 p3) internal view {
1094 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,uint256)", p0, p1, p2, p3));
1095 	}
1096 
1097 	function log(bool p0, string memory p1, uint256 p2, string memory p3) internal view {
1098 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,string)", p0, p1, p2, p3));
1099 	}
1100 
1101 	function log(bool p0, string memory p1, uint256 p2, bool p3) internal view {
1102 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,bool)", p0, p1, p2, p3));
1103 	}
1104 
1105 	function log(bool p0, string memory p1, uint256 p2, address p3) internal view {
1106 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,address)", p0, p1, p2, p3));
1107 	}
1108 
1109 	function log(bool p0, string memory p1, string memory p2, uint256 p3) internal view {
1110 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint256)", p0, p1, p2, p3));
1111 	}
1112 
1113 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
1114 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
1115 	}
1116 
1117 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
1118 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
1119 	}
1120 
1121 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
1122 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
1123 	}
1124 
1125 	function log(bool p0, string memory p1, bool p2, uint256 p3) internal view {
1126 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint256)", p0, p1, p2, p3));
1127 	}
1128 
1129 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
1130 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
1131 	}
1132 
1133 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
1134 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
1135 	}
1136 
1137 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
1138 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
1139 	}
1140 
1141 	function log(bool p0, string memory p1, address p2, uint256 p3) internal view {
1142 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint256)", p0, p1, p2, p3));
1143 	}
1144 
1145 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
1146 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
1147 	}
1148 
1149 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
1150 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
1151 	}
1152 
1153 	function log(bool p0, string memory p1, address p2, address p3) internal view {
1154 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
1155 	}
1156 
1157 	function log(bool p0, bool p1, uint256 p2, uint256 p3) internal view {
1158 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,uint256)", p0, p1, p2, p3));
1159 	}
1160 
1161 	function log(bool p0, bool p1, uint256 p2, string memory p3) internal view {
1162 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,string)", p0, p1, p2, p3));
1163 	}
1164 
1165 	function log(bool p0, bool p1, uint256 p2, bool p3) internal view {
1166 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,bool)", p0, p1, p2, p3));
1167 	}
1168 
1169 	function log(bool p0, bool p1, uint256 p2, address p3) internal view {
1170 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,address)", p0, p1, p2, p3));
1171 	}
1172 
1173 	function log(bool p0, bool p1, string memory p2, uint256 p3) internal view {
1174 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint256)", p0, p1, p2, p3));
1175 	}
1176 
1177 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
1178 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
1179 	}
1180 
1181 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
1182 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
1183 	}
1184 
1185 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
1186 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
1187 	}
1188 
1189 	function log(bool p0, bool p1, bool p2, uint256 p3) internal view {
1190 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint256)", p0, p1, p2, p3));
1191 	}
1192 
1193 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
1194 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
1195 	}
1196 
1197 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
1198 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
1199 	}
1200 
1201 	function log(bool p0, bool p1, bool p2, address p3) internal view {
1202 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
1203 	}
1204 
1205 	function log(bool p0, bool p1, address p2, uint256 p3) internal view {
1206 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint256)", p0, p1, p2, p3));
1207 	}
1208 
1209 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
1210 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
1211 	}
1212 
1213 	function log(bool p0, bool p1, address p2, bool p3) internal view {
1214 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
1215 	}
1216 
1217 	function log(bool p0, bool p1, address p2, address p3) internal view {
1218 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
1219 	}
1220 
1221 	function log(bool p0, address p1, uint256 p2, uint256 p3) internal view {
1222 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,uint256)", p0, p1, p2, p3));
1223 	}
1224 
1225 	function log(bool p0, address p1, uint256 p2, string memory p3) internal view {
1226 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,string)", p0, p1, p2, p3));
1227 	}
1228 
1229 	function log(bool p0, address p1, uint256 p2, bool p3) internal view {
1230 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,bool)", p0, p1, p2, p3));
1231 	}
1232 
1233 	function log(bool p0, address p1, uint256 p2, address p3) internal view {
1234 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,address)", p0, p1, p2, p3));
1235 	}
1236 
1237 	function log(bool p0, address p1, string memory p2, uint256 p3) internal view {
1238 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint256)", p0, p1, p2, p3));
1239 	}
1240 
1241 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
1242 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
1243 	}
1244 
1245 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
1246 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
1247 	}
1248 
1249 	function log(bool p0, address p1, string memory p2, address p3) internal view {
1250 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
1251 	}
1252 
1253 	function log(bool p0, address p1, bool p2, uint256 p3) internal view {
1254 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint256)", p0, p1, p2, p3));
1255 	}
1256 
1257 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
1258 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
1259 	}
1260 
1261 	function log(bool p0, address p1, bool p2, bool p3) internal view {
1262 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
1263 	}
1264 
1265 	function log(bool p0, address p1, bool p2, address p3) internal view {
1266 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
1267 	}
1268 
1269 	function log(bool p0, address p1, address p2, uint256 p3) internal view {
1270 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint256)", p0, p1, p2, p3));
1271 	}
1272 
1273 	function log(bool p0, address p1, address p2, string memory p3) internal view {
1274 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
1275 	}
1276 
1277 	function log(bool p0, address p1, address p2, bool p3) internal view {
1278 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
1279 	}
1280 
1281 	function log(bool p0, address p1, address p2, address p3) internal view {
1282 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
1283 	}
1284 
1285 	function log(address p0, uint256 p1, uint256 p2, uint256 p3) internal view {
1286 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,uint256)", p0, p1, p2, p3));
1287 	}
1288 
1289 	function log(address p0, uint256 p1, uint256 p2, string memory p3) internal view {
1290 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,string)", p0, p1, p2, p3));
1291 	}
1292 
1293 	function log(address p0, uint256 p1, uint256 p2, bool p3) internal view {
1294 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,bool)", p0, p1, p2, p3));
1295 	}
1296 
1297 	function log(address p0, uint256 p1, uint256 p2, address p3) internal view {
1298 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,address)", p0, p1, p2, p3));
1299 	}
1300 
1301 	function log(address p0, uint256 p1, string memory p2, uint256 p3) internal view {
1302 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,uint256)", p0, p1, p2, p3));
1303 	}
1304 
1305 	function log(address p0, uint256 p1, string memory p2, string memory p3) internal view {
1306 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,string)", p0, p1, p2, p3));
1307 	}
1308 
1309 	function log(address p0, uint256 p1, string memory p2, bool p3) internal view {
1310 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,bool)", p0, p1, p2, p3));
1311 	}
1312 
1313 	function log(address p0, uint256 p1, string memory p2, address p3) internal view {
1314 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,address)", p0, p1, p2, p3));
1315 	}
1316 
1317 	function log(address p0, uint256 p1, bool p2, uint256 p3) internal view {
1318 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,uint256)", p0, p1, p2, p3));
1319 	}
1320 
1321 	function log(address p0, uint256 p1, bool p2, string memory p3) internal view {
1322 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,string)", p0, p1, p2, p3));
1323 	}
1324 
1325 	function log(address p0, uint256 p1, bool p2, bool p3) internal view {
1326 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,bool)", p0, p1, p2, p3));
1327 	}
1328 
1329 	function log(address p0, uint256 p1, bool p2, address p3) internal view {
1330 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,address)", p0, p1, p2, p3));
1331 	}
1332 
1333 	function log(address p0, uint256 p1, address p2, uint256 p3) internal view {
1334 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,uint256)", p0, p1, p2, p3));
1335 	}
1336 
1337 	function log(address p0, uint256 p1, address p2, string memory p3) internal view {
1338 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,string)", p0, p1, p2, p3));
1339 	}
1340 
1341 	function log(address p0, uint256 p1, address p2, bool p3) internal view {
1342 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,bool)", p0, p1, p2, p3));
1343 	}
1344 
1345 	function log(address p0, uint256 p1, address p2, address p3) internal view {
1346 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,address)", p0, p1, p2, p3));
1347 	}
1348 
1349 	function log(address p0, string memory p1, uint256 p2, uint256 p3) internal view {
1350 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,uint256)", p0, p1, p2, p3));
1351 	}
1352 
1353 	function log(address p0, string memory p1, uint256 p2, string memory p3) internal view {
1354 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,string)", p0, p1, p2, p3));
1355 	}
1356 
1357 	function log(address p0, string memory p1, uint256 p2, bool p3) internal view {
1358 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,bool)", p0, p1, p2, p3));
1359 	}
1360 
1361 	function log(address p0, string memory p1, uint256 p2, address p3) internal view {
1362 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,address)", p0, p1, p2, p3));
1363 	}
1364 
1365 	function log(address p0, string memory p1, string memory p2, uint256 p3) internal view {
1366 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint256)", p0, p1, p2, p3));
1367 	}
1368 
1369 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
1370 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
1371 	}
1372 
1373 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
1374 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
1375 	}
1376 
1377 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
1378 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
1379 	}
1380 
1381 	function log(address p0, string memory p1, bool p2, uint256 p3) internal view {
1382 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint256)", p0, p1, p2, p3));
1383 	}
1384 
1385 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
1386 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
1387 	}
1388 
1389 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
1390 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
1391 	}
1392 
1393 	function log(address p0, string memory p1, bool p2, address p3) internal view {
1394 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
1395 	}
1396 
1397 	function log(address p0, string memory p1, address p2, uint256 p3) internal view {
1398 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint256)", p0, p1, p2, p3));
1399 	}
1400 
1401 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
1402 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
1403 	}
1404 
1405 	function log(address p0, string memory p1, address p2, bool p3) internal view {
1406 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
1407 	}
1408 
1409 	function log(address p0, string memory p1, address p2, address p3) internal view {
1410 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
1411 	}
1412 
1413 	function log(address p0, bool p1, uint256 p2, uint256 p3) internal view {
1414 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,uint256)", p0, p1, p2, p3));
1415 	}
1416 
1417 	function log(address p0, bool p1, uint256 p2, string memory p3) internal view {
1418 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,string)", p0, p1, p2, p3));
1419 	}
1420 
1421 	function log(address p0, bool p1, uint256 p2, bool p3) internal view {
1422 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,bool)", p0, p1, p2, p3));
1423 	}
1424 
1425 	function log(address p0, bool p1, uint256 p2, address p3) internal view {
1426 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,address)", p0, p1, p2, p3));
1427 	}
1428 
1429 	function log(address p0, bool p1, string memory p2, uint256 p3) internal view {
1430 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint256)", p0, p1, p2, p3));
1431 	}
1432 
1433 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
1434 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
1435 	}
1436 
1437 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
1438 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
1439 	}
1440 
1441 	function log(address p0, bool p1, string memory p2, address p3) internal view {
1442 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
1443 	}
1444 
1445 	function log(address p0, bool p1, bool p2, uint256 p3) internal view {
1446 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint256)", p0, p1, p2, p3));
1447 	}
1448 
1449 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
1450 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
1451 	}
1452 
1453 	function log(address p0, bool p1, bool p2, bool p3) internal view {
1454 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
1455 	}
1456 
1457 	function log(address p0, bool p1, bool p2, address p3) internal view {
1458 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
1459 	}
1460 
1461 	function log(address p0, bool p1, address p2, uint256 p3) internal view {
1462 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint256)", p0, p1, p2, p3));
1463 	}
1464 
1465 	function log(address p0, bool p1, address p2, string memory p3) internal view {
1466 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
1467 	}
1468 
1469 	function log(address p0, bool p1, address p2, bool p3) internal view {
1470 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
1471 	}
1472 
1473 	function log(address p0, bool p1, address p2, address p3) internal view {
1474 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
1475 	}
1476 
1477 	function log(address p0, address p1, uint256 p2, uint256 p3) internal view {
1478 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,uint256)", p0, p1, p2, p3));
1479 	}
1480 
1481 	function log(address p0, address p1, uint256 p2, string memory p3) internal view {
1482 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,string)", p0, p1, p2, p3));
1483 	}
1484 
1485 	function log(address p0, address p1, uint256 p2, bool p3) internal view {
1486 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,bool)", p0, p1, p2, p3));
1487 	}
1488 
1489 	function log(address p0, address p1, uint256 p2, address p3) internal view {
1490 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,address)", p0, p1, p2, p3));
1491 	}
1492 
1493 	function log(address p0, address p1, string memory p2, uint256 p3) internal view {
1494 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint256)", p0, p1, p2, p3));
1495 	}
1496 
1497 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
1498 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
1499 	}
1500 
1501 	function log(address p0, address p1, string memory p2, bool p3) internal view {
1502 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
1503 	}
1504 
1505 	function log(address p0, address p1, string memory p2, address p3) internal view {
1506 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
1507 	}
1508 
1509 	function log(address p0, address p1, bool p2, uint256 p3) internal view {
1510 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint256)", p0, p1, p2, p3));
1511 	}
1512 
1513 	function log(address p0, address p1, bool p2, string memory p3) internal view {
1514 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
1515 	}
1516 
1517 	function log(address p0, address p1, bool p2, bool p3) internal view {
1518 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
1519 	}
1520 
1521 	function log(address p0, address p1, bool p2, address p3) internal view {
1522 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
1523 	}
1524 
1525 	function log(address p0, address p1, address p2, uint256 p3) internal view {
1526 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint256)", p0, p1, p2, p3));
1527 	}
1528 
1529 	function log(address p0, address p1, address p2, string memory p3) internal view {
1530 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
1531 	}
1532 
1533 	function log(address p0, address p1, address p2, bool p3) internal view {
1534 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
1535 	}
1536 
1537 	function log(address p0, address p1, address p2, address p3) internal view {
1538 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
1539 	}
1540 
1541 }
1542 
1543 abstract contract Context {
1544     function _msgSender() internal view virtual returns (address) {
1545         return msg.sender;
1546     }
1547 
1548     function _msgData() internal view virtual returns (bytes calldata) {
1549         return msg.data;
1550     }
1551 }
1552 
1553 abstract contract Ownable is Context {
1554     address private _owner;
1555 
1556     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1557 
1558     /**
1559      * @dev Initializes the contract setting the deployer as the initial owner.
1560      */
1561     constructor() {
1562         _transferOwnership(_msgSender());
1563     }
1564 
1565     /**
1566      * @dev Returns the address of the current owner.
1567      */
1568     function owner() public view virtual returns (address) {
1569         return _owner;
1570     }
1571 
1572     /**
1573      * @dev Throws if called by any account other than the owner.
1574      */
1575     modifier onlyOwner() {
1576         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1577         _;
1578     }
1579 
1580     /**
1581      * @dev Leaves the contract without owner. It will not be possible to call
1582      * `onlyOwner` functions anymore. Can only be called by the current owner.
1583      *
1584      * NOTE: Renouncing ownership will leave the contract without an owner,
1585      * thereby removing any functionality that is only available to the owner.
1586      */
1587     function renounceOwnership() public virtual onlyOwner {
1588         _transferOwnership(address(0));
1589     }
1590 
1591     /**
1592      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1593      * Can only be called by the current owner.
1594      */
1595     function transferOwnership(address newOwner) public virtual onlyOwner {
1596         require(newOwner != address(0), "Ownable: new owner is the zero address");
1597         _transferOwnership(newOwner);
1598     }
1599 
1600     /**
1601      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1602      * Internal function without access restriction.
1603      */
1604     function _transferOwnership(address newOwner) internal virtual {
1605         address oldOwner = _owner;
1606         _owner = newOwner;
1607         emit OwnershipTransferred(oldOwner, newOwner);
1608     }
1609 }
1610 
1611 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
1612 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
1613 
1614 /* pragma solidity ^0.8.0; */
1615 
1616 /**
1617  * @dev Interface of the ERC20 standard as defined in the EIP.
1618  */
1619 interface IERC20 {
1620     /**
1621      * @dev Returns the amount of tokens in existence.
1622      */
1623     function totalSupply() external view returns (uint256);
1624 
1625     /**
1626      * @dev Returns the amount of tokens owned by `account`.
1627      */
1628     function balanceOf(address account) external view returns (uint256);
1629 
1630     /**
1631      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1632      *
1633      * Returns a boolean value indicating whether the operation succeeded.
1634      *
1635      * Emits a {Transfer} event.
1636      */
1637     function transfer(address recipient, uint256 amount) external returns (bool);
1638 
1639     /**
1640      * @dev Returns the remaining number of tokens that `spender` will be
1641      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1642      * zero by default.
1643      *
1644      * This value changes when {approve} or {transferFrom} are called.
1645      */
1646     function allowance(address owner, address spender) external view returns (uint256);
1647 
1648 
1649     function approve(address spender, uint256 amount) external returns (bool);
1650 
1651     /**
1652      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1653      * allowance mechanism. `amount` is then deducted from the caller's
1654      * allowance.
1655      *
1656      * Returns a boolean value indicating whether the operation succeeded.
1657      *
1658      * Emits a {Transfer} event.
1659      */
1660     function transferFrom(
1661         address sender,
1662         address recipient,
1663         uint256 amount
1664     ) external returns (bool);
1665 
1666     /**
1667      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1668      * another (`to`).
1669      *
1670      * Note that `value` may be zero.
1671      */
1672     event Transfer(address indexed from, address indexed to, uint256 value);
1673 
1674     /**
1675      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1676      * a call to {approve}. `value` is the new allowance.
1677      */
1678     event Approval(address indexed owner, address indexed spender, uint256 value);
1679 }
1680 
1681 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
1682 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
1683 
1684 /* pragma solidity ^0.8.0; */
1685 
1686 /* import "../IERC20.sol"; */
1687 
1688 /**
1689  * @dev Interface for the optional metadata functions from the ERC20 standard.
1690  *
1691  * _Available since v4.1._
1692  */
1693 interface IERC20Metadata is IERC20 {
1694     /**
1695      * @dev Returns the name of the token.
1696      */
1697     function name() external view returns (string memory);
1698 
1699     /**
1700      * @dev Returns the symbol of the token.
1701      */
1702     function symbol() external view returns (string memory);
1703 
1704     /**
1705      * @dev Returns the decimals places of the token.
1706      */
1707     function decimals() external view returns (uint8);
1708 }
1709 
1710 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
1711 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
1712 
1713 /* pragma solidity ^0.8.0; */
1714 
1715 /* import "./IERC20.sol"; */
1716 /* import "./extensions/IERC20Metadata.sol"; */
1717 /* import "../../utils/Context.sol"; */
1718 
1719 /**
1720  * @dev Implementation of the {IERC20} interface.
1721  *
1722  * This implementation is agnostic to the way tokens are created. This means
1723  * that a supply mechanism has to be added in a derived contract using {_mint}.
1724  * For a generic mechanism see {ERC20PresetMinterPauser}.
1725  *
1726  * TIP: For a detailed writeup see our guide
1727  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1728  * to implement supply mechanisms].
1729  *
1730  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1731  * instead returning `false` on failure. This behavior is nonetheless
1732  * conventional and does not conflict with the expectations of ERC20
1733  * applications.
1734  *
1735  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1736  * This allows applications to reconstruct the allowance for all accounts just
1737  * by listening to said events. Other implementations of the EIP may not emit
1738  * these events, as it isn't required by the specification.
1739  *
1740  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1741  * functions have been added to mitigate the well-known issues around setting
1742  * allowances. See {IERC20-approve}.
1743  */
1744 contract ERC20 is Context, IERC20, IERC20Metadata {
1745     mapping(address => uint256) private _balances;
1746 
1747     mapping(address => mapping(address => uint256)) private _allowances;
1748 
1749     uint256 private _totalSupply;
1750 
1751     string private _name;
1752     string private _symbol;
1753 
1754     /**
1755      * @dev Sets the values for {name} and {symbol}.
1756      *
1757      * The default value of {decimals} is 18. To select a different value for
1758      * {decimals} you should overload it.
1759      *
1760      * All two of these values are immutable: they can only be set once during
1761      * construction.
1762      */
1763     constructor(string memory name_, string memory symbol_) {
1764         _name = name_;
1765         _symbol = symbol_;
1766     }
1767 
1768     /**
1769      * @dev Returns the name of the token.
1770      */
1771     function name() public view virtual override returns (string memory) {
1772         return _name;
1773     }
1774 
1775     /**
1776      * @dev Returns the symbol of the token, usually a shorter version of the
1777      * name.
1778      */
1779     function symbol() public view virtual override returns (string memory) {
1780         return _symbol;
1781     }
1782 
1783     /**
1784      * @dev Returns the number of decimals used to get its user representation.
1785      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1786      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1787      *
1788      * Tokens usually opt for a value of 18, imitating the relationship between
1789      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1790      * overridden;
1791      *
1792      * NOTE: This information is only used for _display_ purposes: it in
1793      * no way affects any of the arithmetic of the contract, including
1794      * {IERC20-balanceOf} and {IERC20-transfer}.
1795      */
1796     function decimals() public view virtual override returns (uint8) {
1797         return 18;
1798     }
1799 
1800     /**
1801      * @dev See {IERC20-totalSupply}.
1802      */
1803     function totalSupply() public view virtual override returns (uint256) {
1804         return _totalSupply;
1805     }
1806 
1807     /**
1808      * @dev See {IERC20-balanceOf}.
1809      */
1810     function balanceOf(address account) public view virtual override returns (uint256) {
1811         return _balances[account];
1812     }
1813 
1814     /**
1815      * @dev See {IERC20-transfer}.
1816      *
1817      * Requirements:
1818      *
1819      * - `recipient` cannot be the zero address.
1820      * - the caller must have a balance of at least `amount`.
1821      */
1822     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1823         _transfer(_msgSender(), recipient, amount);
1824         return true;
1825     }
1826 
1827     /**
1828      * @dev See {IERC20-allowance}.
1829      */
1830     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1831         return _allowances[owner][spender];
1832     }
1833 
1834     /**
1835      * @dev See {IERC20-approve}.
1836      *
1837      * Requirements:
1838      *
1839      * - `spender` cannot be the zero address.
1840      */
1841     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1842         _approve(_msgSender(), spender, amount);
1843         return true;
1844     }
1845 
1846     /**
1847      * @dev See {IERC20-transferFrom}.
1848      *
1849      * Emits an {Approval} event indicating the updated allowance. This is not
1850      * required by the EIP. See the note at the beginning of {ERC20}.
1851      *
1852      * Requirements:
1853      *
1854      * - `sender` and `recipient` cannot be the zero address.
1855      * - `sender` must have a balance of at least `amount`.
1856      * - the caller must have allowance for ``sender``'s tokens of at least
1857      * `amount`.
1858      */
1859     function transferFrom(
1860         address sender,
1861         address recipient,
1862         uint256 amount
1863     ) public virtual override returns (bool) {
1864         _transfer(sender, recipient, amount);
1865 
1866         uint256 currentAllowance = _allowances[sender][_msgSender()];
1867         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
1868         unchecked {
1869             _approve(sender, _msgSender(), currentAllowance - amount);
1870         }
1871 
1872         return true;
1873     }
1874 
1875     /**
1876      * @dev Atomically increases the allowance granted to `spender` by the caller.
1877      *
1878      * This is an alternative to {approve} that can be used as a mitigation for
1879      * problems described in {IERC20-approve}.
1880      *
1881      * Emits an {Approval} event indicating the updated allowance.
1882      *
1883      * Requirements:
1884      *
1885      * - `spender` cannot be the zero address.
1886      */
1887     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1888         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
1889         return true;
1890     }
1891 
1892     /**
1893      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1894      *
1895      * This is an alternative to {approve} that can be used as a mitigation for
1896      * problems described in {IERC20-approve}.
1897      *
1898      * Emits an {Approval} event indicating the updated allowance.
1899      *
1900      * Requirements:
1901      *
1902      * - `spender` cannot be the zero address.
1903      * - `spender` must have allowance for the caller of at least
1904      * `subtractedValue`.
1905      */
1906     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1907         uint256 currentAllowance = _allowances[_msgSender()][spender];
1908         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1909         unchecked {
1910             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1911         }
1912 
1913         return true;
1914     }
1915 
1916     /**
1917      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1918      *
1919      * This internal function is equivalent to {transfer}, and can be used to
1920      * e.g. implement automatic token fees, slashing mechanisms, etc.
1921      *
1922      * Emits a {Transfer} event.
1923      *
1924      * Requirements:
1925      *
1926      * - `sender` cannot be the zero address.
1927      * - `recipient` cannot be the zero address.
1928      * - `sender` must have a balance of at least `amount`.
1929      */
1930     function _transfer(
1931         address sender,
1932         address recipient,
1933         uint256 amount
1934     ) internal virtual {
1935         require(sender != address(0), "ERC20: transfer from the zero address");
1936         require(recipient != address(0), "ERC20: transfer to the zero address");
1937 
1938         _beforeTokenTransfer(sender, recipient, amount);
1939 
1940         uint256 senderBalance = _balances[sender];
1941         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
1942         unchecked {
1943             _balances[sender] = senderBalance - amount;
1944         }
1945         _balances[recipient] += amount;
1946 
1947         emit Transfer(sender, recipient, amount);
1948 
1949         _afterTokenTransfer(sender, recipient, amount);
1950     }
1951 
1952     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1953      * the total supply.
1954      *
1955      * Emits a {Transfer} event with `from` set to the zero address.
1956      *
1957      * Requirements:
1958      *
1959      * - `account` cannot be the zero address.
1960      */
1961     function _mint(address account, uint256 amount) internal virtual {
1962         require(account != address(0), "ERC20: mint to the zero address");
1963 
1964         _beforeTokenTransfer(address(0), account, amount);
1965 
1966         _totalSupply += amount;
1967         _balances[account] += amount;
1968         emit Transfer(address(0), account, amount);
1969 
1970         _afterTokenTransfer(address(0), account, amount);
1971     }
1972 
1973     /**
1974      * @dev Destroys `amount` tokens from `account`, reducing the
1975      * total supply.
1976      *
1977      * Emits a {Transfer} event with `to` set to the zero address.
1978      *
1979      * Requirements:
1980      *
1981      * - `account` cannot be the zero address.
1982      * - `account` must have at least `amount` tokens.
1983      */
1984     function _burn(address account, uint256 amount) internal virtual {
1985         require(account != address(0), "ERC20: burn from the zero address");
1986 
1987         _beforeTokenTransfer(account, address(0), amount);
1988 
1989         uint256 accountBalance = _balances[account];
1990         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1991         unchecked {
1992             _balances[account] = accountBalance - amount;
1993         }
1994         _totalSupply -= amount;
1995 
1996         emit Transfer(account, address(0), amount);
1997 
1998         _afterTokenTransfer(account, address(0), amount);
1999     }
2000 
2001     /**
2002      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
2003      *
2004      * This internal function is equivalent to `approve`, and can be used to
2005      * e.g. set automatic allowances for certain subsystems, etc.
2006      *
2007      * Emits an {Approval} event.
2008      *
2009      * Requirements:
2010      *
2011      * - `owner` cannot be the zero address.
2012      * - `spender` cannot be the zero address.
2013      */
2014     function _approve(
2015         address owner,
2016         address spender,
2017         uint256 amount
2018     ) internal virtual {
2019         require(owner != address(0), "ERC20: approve from the zero address");
2020         require(spender != address(0), "ERC20: approve to the zero address");
2021 
2022         _allowances[owner][spender] = amount;
2023         emit Approval(owner, spender, amount);
2024     }
2025 
2026     /**
2027      * @dev Hook that is called before any transfer of tokens. This includes
2028      * minting and burning.
2029      *
2030      * Calling conditions:
2031      *
2032      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2033      * will be transferred to `to`.
2034      * - when `from` is zero, `amount` tokens will be minted for `to`.
2035      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
2036      * - `from` and `to` are never both zero.
2037      *
2038      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2039      */
2040     function _beforeTokenTransfer(
2041         address from,
2042         address to,
2043         uint256 amount
2044     ) internal virtual {}
2045 
2046     /**
2047      * @dev Hook that is called after any transfer of tokens. This includes
2048      * minting and burning.
2049      *
2050      * Calling conditions:
2051      *
2052      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2053      * has been transferred to `to`.
2054      * - when `from` is zero, `amount` tokens have been minted for `to`.
2055      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
2056      * - `from` and `to` are never both zero.
2057      *
2058      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2059      */
2060     function _afterTokenTransfer(
2061         address from,
2062         address to,
2063         uint256 amount
2064     ) internal virtual {}
2065 }
2066 
2067 
2068 library SafeMath {
2069     /**
2070      * @dev Returns the addition of two unsigned integers, with an overflow flag.
2071      *
2072      * _Available since v3.4._
2073      */
2074     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2075         unchecked {
2076             uint256 c = a + b;
2077             if (c < a) return (false, 0);
2078             return (true, c);
2079         }
2080     }
2081 
2082     /**
2083      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
2084      *
2085      * _Available since v3.4._
2086      */
2087     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2088         unchecked {
2089             if (b > a) return (false, 0);
2090             return (true, a - b);
2091         }
2092     }
2093 
2094     /**
2095      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
2096      *
2097      * _Available since v3.4._
2098      */
2099     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2100         unchecked {
2101             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
2102             // benefit is lost if 'b' is also tested.
2103             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
2104             if (a == 0) return (true, 0);
2105             uint256 c = a * b;
2106             if (c / a != b) return (false, 0);
2107             return (true, c);
2108         }
2109     }
2110 
2111     /**
2112      * @dev Returns the division of two unsigned integers, with a division by zero flag.
2113      *
2114      * _Available since v3.4._
2115      */
2116     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2117         unchecked {
2118             if (b == 0) return (false, 0);
2119             return (true, a / b);
2120         }
2121     }
2122 
2123     /**
2124      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
2125      *
2126      * _Available since v3.4._
2127      */
2128     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2129         unchecked {
2130             if (b == 0) return (false, 0);
2131             return (true, a % b);
2132         }
2133     }
2134 
2135     /**
2136      * @dev Returns the addition of two unsigned integers, reverting on
2137      * overflow.
2138      *
2139      * Counterpart to Solidity's `+` operator.
2140      *
2141      * Requirements:
2142      *
2143      * - Addition cannot overflow.
2144      */
2145     function add(uint256 a, uint256 b) internal pure returns (uint256) {
2146         return a + b;
2147     }
2148 
2149     /**
2150      * @dev Returns the subtraction of two unsigned integers, reverting on
2151      * overflow (when the result is negative).
2152      *
2153      * Counterpart to Solidity's `-` operator.
2154      *
2155      * Requirements:
2156      *
2157      * - Subtraction cannot overflow.
2158      */
2159     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
2160         return a - b;
2161     }
2162 
2163     /**
2164      * @dev Returns the multiplication of two unsigned integers, reverting on
2165      * overflow.
2166      *
2167      * Counterpart to Solidity's `*` operator.
2168      *
2169      * Requirements:
2170      *
2171      * - Multiplication cannot overflow.
2172      */
2173     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
2174         return a * b;
2175     }
2176 
2177     /**
2178      * @dev Returns the integer division of two unsigned integers, reverting on
2179      * division by zero. The result is rounded towards zero.
2180      *
2181      * Counterpart to Solidity's `/` operator.
2182      *
2183      * Requirements:
2184      *
2185      * - The divisor cannot be zero.
2186      */
2187     function div(uint256 a, uint256 b) internal pure returns (uint256) {
2188         return a / b;
2189     }
2190 
2191     /**
2192      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
2193      * reverting when dividing by zero.
2194      *
2195      * Counterpart to Solidity's `%` operator. This function uses a `revert`
2196      * opcode (which leaves remaining gas untouched) while Solidity uses an
2197      * invalid opcode to revert (consuming all remaining gas).
2198      *
2199      * Requirements:
2200      *
2201      * - The divisor cannot be zero.
2202      */
2203     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
2204         return a % b;
2205     }
2206 
2207     /**
2208      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
2209      * overflow (when the result is negative).
2210      *
2211      * CAUTION: This function is deprecated because it requires allocating memory for the error
2212      * message unnecessarily. For custom revert reasons use {trySub}.
2213      *
2214      * Counterpart to Solidity's `-` operator.
2215      *
2216      * Requirements:
2217      *
2218      * - Subtraction cannot overflow.
2219      */
2220     function sub(
2221         uint256 a,
2222         uint256 b,
2223         string memory errorMessage
2224     ) internal pure returns (uint256) {
2225         unchecked {
2226             require(b <= a, errorMessage);
2227             return a - b;
2228         }
2229     }
2230 
2231     /**
2232      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
2233      * division by zero. The result is rounded towards zero.
2234      *
2235      * Counterpart to Solidity's `/` operator. Note: this function uses a
2236      * `revert` opcode (which leaves remaining gas untouched) while Solidity
2237      * uses an invalid opcode to revert (consuming all remaining gas).
2238      *
2239      * Requirements:
2240      *
2241      * - The divisor cannot be zero.
2242      */
2243     function div(
2244         uint256 a,
2245         uint256 b,
2246         string memory errorMessage
2247     ) internal pure returns (uint256) {
2248         unchecked {
2249             require(b > 0, errorMessage);
2250             return a / b;
2251         }
2252     }
2253 
2254     /**
2255      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
2256      * reverting with custom message when dividing by zero.
2257      *
2258      * CAUTION: This function is deprecated because it requires allocating memory for the error
2259      * message unnecessarily. For custom revert reasons use {tryMod}.
2260      *
2261      * Counterpart to Solidity's `%` operator. This function uses a `revert`
2262      * opcode (which leaves remaining gas untouched) while Solidity uses an
2263      * invalid opcode to revert (consuming all remaining gas).
2264      *
2265      * Requirements:
2266      *
2267      * - The divisor cannot be zero.
2268      */
2269     function mod(
2270         uint256 a,
2271         uint256 b,
2272         string memory errorMessage
2273     ) internal pure returns (uint256) {
2274         unchecked {
2275             require(b > 0, errorMessage);
2276             return a % b;
2277         }
2278     }
2279 }
2280 
2281 /* pragma solidity 0.8.10; */
2282 /* pragma experimental ABIEncoderV2; */
2283 
2284 interface IUniswapV2Factory {
2285     event PairCreated(
2286         address indexed token0,
2287         address indexed token1,
2288         address pair,
2289         uint256
2290     );
2291 
2292     function feeTo() external view returns (address);
2293 
2294     function feeToSetter() external view returns (address);
2295 
2296     function getPair(address tokenA, address tokenB)
2297         external
2298         view
2299         returns (address pair);
2300 
2301     function allPairs(uint256) external view returns (address pair);
2302 
2303     function allPairsLength() external view returns (uint256);
2304 
2305     function createPair(address tokenA, address tokenB)
2306         external
2307         returns (address pair);
2308 
2309     function setFeeTo(address) external;
2310 
2311     function setFeeToSetter(address) external;
2312 }
2313 
2314 /* pragma solidity 0.8.10; */
2315 /* pragma experimental ABIEncoderV2; */
2316 
2317 interface IUniswapV2Pair {
2318     event Approval(
2319         address indexed owner,
2320         address indexed spender,
2321         uint256 value
2322     );
2323     event Transfer(address indexed from, address indexed to, uint256 value);
2324 
2325     function name() external pure returns (string memory);
2326 
2327     function symbol() external pure returns (string memory);
2328 
2329     function decimals() external pure returns (uint8);
2330 
2331     function totalSupply() external view returns (uint256);
2332 
2333     function balanceOf(address owner) external view returns (uint256);
2334 
2335     function allowance(address owner, address spender)
2336         external
2337         view
2338         returns (uint256);
2339 
2340     function approve(address spender, uint256 value) external returns (bool);
2341 
2342     function transfer(address to, uint256 value) external returns (bool);
2343 
2344     function transferFrom(
2345         address from,
2346         address to,
2347         uint256 value
2348     ) external returns (bool);
2349 
2350     function DOMAIN_SEPARATOR() external view returns (bytes32);
2351 
2352     function PERMIT_TYPEHASH() external pure returns (bytes32);
2353 
2354     function nonces(address owner) external view returns (uint256);
2355 
2356     function permit(
2357         address owner,
2358         address spender,
2359         uint256 value,
2360         uint256 deadline,
2361         uint8 v,
2362         bytes32 r,
2363         bytes32 s
2364     ) external;
2365 
2366     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
2367     event Burn(
2368         address indexed sender,
2369         uint256 amount0,
2370         uint256 amount1,
2371         address indexed to
2372     );
2373     event Swap(
2374         address indexed sender,
2375         uint256 amount0In,
2376         uint256 amount1In,
2377         uint256 amount0Out,
2378         uint256 amount1Out,
2379         address indexed to
2380     );
2381     event Sync(uint112 reserve0, uint112 reserve1);
2382 
2383     function MINIMUM_LIQUIDITY() external pure returns (uint256);
2384 
2385     function factory() external view returns (address);
2386 
2387     function token0() external view returns (address);
2388 
2389     function token1() external view returns (address);
2390 
2391     function getReserves()
2392         external
2393         view
2394         returns (
2395             uint112 reserve0,
2396             uint112 reserve1,
2397             uint32 blockTimestampLast
2398         );
2399 
2400     function price0CumulativeLast() external view returns (uint256);
2401 
2402     function price1CumulativeLast() external view returns (uint256);
2403 
2404     function kLast() external view returns (uint256);
2405 
2406     function mint(address to) external returns (uint256 liquidity);
2407 
2408     function burn(address to)
2409         external
2410         returns (uint256 amount0, uint256 amount1);
2411 
2412     function swap(
2413         uint256 amount0Out,
2414         uint256 amount1Out,
2415         address to,
2416         bytes calldata data
2417     ) external;
2418 
2419     function skim(address to) external;
2420 
2421     function sync() external;
2422 
2423     function initialize(address, address) external;
2424 }
2425 
2426 /* pragma solidity 0.8.10; */
2427 /* pragma experimental ABIEncoderV2; */
2428 
2429 interface IUniswapV2Router02 {
2430     function factory() external pure returns (address);
2431 
2432     function WETH() external pure returns (address);
2433 
2434     function addLiquidity(
2435         address tokenA,
2436         address tokenB,
2437         uint256 amountADesired,
2438         uint256 amountBDesired,
2439         uint256 amountAMin,
2440         uint256 amountBMin,
2441         address to,
2442         uint256 deadline
2443     )
2444         external
2445         returns (
2446             uint256 amountA,
2447             uint256 amountB,
2448             uint256 liquidity
2449         );
2450 
2451     function addLiquidityETH(
2452         address token,
2453         uint256 amountTokenDesired,
2454         uint256 amountTokenMin,
2455         uint256 amountETHMin,
2456         address to,
2457         uint256 deadline
2458     )
2459         external
2460         payable
2461         returns (
2462             uint256 amountToken,
2463             uint256 amountETH,
2464             uint256 liquidity
2465         );
2466 
2467     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
2468         uint256 amountIn,
2469         uint256 amountOutMin,
2470         address[] calldata path,
2471         address to,
2472         uint256 deadline
2473     ) external;
2474 
2475     function swapExactETHForTokensSupportingFeeOnTransferTokens(
2476         uint256 amountOutMin,
2477         address[] calldata path,
2478         address to,
2479         uint256 deadline
2480     ) external payable;
2481 
2482     function swapExactTokensForETHSupportingFeeOnTransferTokens(
2483         uint256 amountIn,
2484         uint256 amountOutMin,
2485         address[] calldata path,
2486         address to,
2487         uint256 deadline
2488     ) external;
2489 }
2490 
2491 /* pragma solidity >=0.8.10; */
2492 
2493 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
2494 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
2495 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
2496 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
2497 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
2498 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
2499 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
2500 
2501 contract GoldenRocket is ERC20, Ownable {
2502     using SafeMath for uint256;
2503 
2504     IUniswapV2Router02 public immutable uniswapV2Router;
2505     address public immutable uniswapV2Pair;
2506     address public constant deadAddress = address(0xdead);
2507 
2508     bool private swapping;
2509 
2510     address public marketingWallet;
2511     address public devWallet;
2512 
2513     uint256 public maxTransactionAmount;
2514     uint256 public swapTokensAtAmount;
2515     uint256 public maxWallet;
2516 
2517     bool public limitsInEffect = true;
2518     bool public tradingActive = false;
2519     bool public swapEnabled = false;
2520     bool private burnTax = true;
2521 
2522     // Anti-bot and anti-whale mappings and variables
2523     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
2524     mapping (address => uint256) private _firstBuyTimeStamp; // first buy!
2525     bool public transferDelayEnabled = true;
2526 
2527     uint256 public buyTotalFees;
2528     uint256 public buyMarketingFee;
2529     uint256 public buyLiquidityFee;
2530     uint256 public buyDevFee;
2531 
2532     uint256 public sellTotalFees;
2533     uint256 public sellMarketingFee;
2534     uint256 public sellLiquidityFee;
2535     uint256 public sellDevFee;
2536 
2537     uint256 public tokensForMarketing;
2538     uint256 public tokensForLiquidity;
2539     uint256 public tokensForDev;
2540 
2541     /******************/
2542 
2543     // exlcude from fees and max transaction amount
2544     mapping(address => bool) private _isExcludedFromFees;
2545     mapping(address => bool) public _isExcludedMaxTransactionAmount;
2546 
2547     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
2548     // could be subject to a maximum transfer amount
2549     mapping(address => bool) public automatedMarketMakerPairs;
2550 
2551     event UpdateUniswapV2Router(
2552         address indexed newAddress,
2553         address indexed oldAddress
2554     );
2555 
2556     event ExcludeFromFees(address indexed account, bool isExcluded);
2557 
2558     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
2559 
2560     event SwapAndLiquify(
2561         uint256 tokensSwapped,
2562         uint256 ethReceived,
2563         uint256 tokensIntoLiquidity
2564     );
2565 
2566     constructor() ERC20("Golden Rocket", "ROCKET") {
2567         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
2568             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
2569         );
2570 
2571         excludeFromMaxTransaction(address(_uniswapV2Router), true);
2572         uniswapV2Router = _uniswapV2Router;
2573 
2574         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
2575             .createPair(address(this), _uniswapV2Router.WETH());
2576         excludeFromMaxTransaction(address(uniswapV2Pair), true);
2577         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
2578 
2579         uint256 _buyMarketingFee = 0;
2580         uint256 _buyLiquidityFee = 0;
2581         uint256 _buyDevFee = 0;
2582 
2583         uint256 _sellMarketingFee = 8;
2584         uint256 _sellLiquidityFee = 0;
2585         uint256 _sellDevFee = 0;
2586 
2587         uint256 totalSupply = 21000000 * 1e18;
2588         maxTransactionAmount = (totalSupply * 2) / 100;
2589         maxWallet = (totalSupply * 2) / 100; // 0.5% max wallet
2590         swapTokensAtAmount = (totalSupply * 4) / 1000; // 0.4% swap wallet
2591 
2592         buyMarketingFee = _buyMarketingFee;
2593         buyLiquidityFee = _buyLiquidityFee;
2594         buyDevFee = _buyDevFee;
2595         buyTotalFees =  buyMarketingFee + buyLiquidityFee + buyDevFee;
2596 
2597         sellMarketingFee = _sellMarketingFee;
2598         sellLiquidityFee = _sellLiquidityFee;
2599         sellDevFee = _sellDevFee;
2600         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
2601 
2602         marketingWallet = address(0xEE34eF395B0a02bb381F1DaE59bA3B4018A86Eb7); 
2603         devWallet = address(0x26217aA88b25d3bFD79a0862963210211Ce3B575); 
2604 
2605         // exclude from paying fees or having max transaction amount
2606         excludeFromFees(owner(), true);
2607         excludeFromFees(address(this), true);
2608         excludeFromFees(address(0xdead), true);
2609 
2610         excludeFromMaxTransaction(owner(), true);
2611         excludeFromMaxTransaction(address(this), true);
2612         excludeFromMaxTransaction(address(0xdead), true);
2613 
2614         /*
2615             _mint is an internal function in ERC20.sol that is only called here,
2616             and CANNOT be called ever again
2617         */
2618         _mint(msg.sender, totalSupply);
2619     }
2620 
2621     receive() external payable {}
2622 
2623     // once enabled, can never be turned off
2624     function enableTrading() external onlyOwner {
2625         tradingActive = true;
2626         swapEnabled = true;
2627     }
2628 
2629     // remove limits after token is stable
2630     function removeLimits() external onlyOwner returns (bool) {
2631         limitsInEffect = false;
2632         return true;
2633     }
2634 
2635     // disable Transfer delay - cannot be reenabled
2636     function disableTransferDelay() external onlyOwner returns (bool) {
2637         transferDelayEnabled = false;
2638         return true;
2639     }
2640 
2641     // change the minimum amount of tokens to sell from fees
2642     function updateSwapTokensAtAmount(uint256 newAmount)
2643         external
2644         onlyOwner
2645         returns (bool)
2646     {
2647         require(
2648             newAmount >= (totalSupply() * 1) / 100000,
2649             "Swap amount cannot be lower than 0.001% total supply."
2650         );
2651         require(
2652             newAmount <= (totalSupply() * 5) / 1000,
2653             "Swap amount cannot be higher than 0.5% total supply."
2654         );
2655         swapTokensAtAmount = newAmount;
2656         return true;
2657     }
2658 
2659     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
2660         require(
2661             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
2662             "Cannot set maxTransactionAmount lower than 0.5%"
2663         );
2664         maxTransactionAmount = newNum * (10**18);
2665     }
2666 
2667     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
2668         require(
2669             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
2670             "Cannot set maxWallet lower than 0.5%"
2671         );
2672         maxWallet = newNum * (10**18);
2673     }
2674 	
2675     function excludeFromMaxTransaction(address updAds, bool isEx)
2676         public
2677         onlyOwner
2678     {
2679         _isExcludedMaxTransactionAmount[updAds] = isEx;
2680     }
2681 
2682     // only use to disable contract sales if absolutely necessary (emergency use only)
2683     function updateSwapEnabled(bool enabled) external onlyOwner {
2684         swapEnabled = enabled;
2685     }
2686 
2687     function updateBuyFees(
2688         uint256 _marketingFee,
2689         uint256 _liquidityFee,
2690         uint256 _devFee
2691     ) external onlyOwner {
2692 		require(( _marketingFee + _liquidityFee + _devFee) <= 10, "Max BuyFee 10%");
2693         buyMarketingFee = _marketingFee;
2694         buyLiquidityFee = _liquidityFee;
2695         buyDevFee = _devFee;
2696         buyTotalFees =  buyMarketingFee + buyLiquidityFee + buyDevFee;
2697      }
2698 
2699     function updateSellFees(
2700         uint256 _marketingFee,
2701         uint256 _liquidityFee,
2702         uint256 _devFee
2703     ) external onlyOwner {
2704 		require((_marketingFee + _liquidityFee + _devFee) <= 8, "Cant be more then 8%");
2705         sellMarketingFee = _marketingFee;
2706         sellLiquidityFee = _liquidityFee;
2707         sellDevFee = _devFee;
2708         sellTotalFees =  sellMarketingFee + sellLiquidityFee + sellDevFee;
2709     }
2710 
2711     function updateBurnTax(bool _burnTax) external onlyOwner {
2712         burnTax = _burnTax;
2713     }
2714 
2715     function excludeFromFees(address account, bool excluded) public onlyOwner {
2716         _isExcludedFromFees[account] = excluded;
2717         emit ExcludeFromFees(account, excluded);
2718     }
2719 
2720     function setAutomatedMarketMakerPair(address pair, bool value)
2721         public
2722         onlyOwner
2723     {
2724         require(
2725             pair != uniswapV2Pair,
2726             "The pair cannot be removed from automatedMarketMakerPairs"
2727         );
2728 
2729         _setAutomatedMarketMakerPair(pair, value);
2730     }
2731 
2732     function _setAutomatedMarketMakerPair(address pair, bool value) private {
2733         automatedMarketMakerPairs[pair] = value;
2734 
2735         emit SetAutomatedMarketMakerPair(pair, value);
2736     }
2737 
2738     function isExcludedFromFees(address account) public view returns (bool) {
2739         return _isExcludedFromFees[account];
2740     }
2741 
2742     function _burn (address account, uint256 amount) internal override {
2743         super._burn(account, amount);
2744     }
2745 
2746     function _transfer(
2747         address from,
2748         address to,
2749         uint256 amount
2750     ) internal override {
2751         require(from != address(0), "ERC20: transfer from the zero address");
2752         require(to != address(0), "ERC20: transfer to the zero address");
2753 
2754         if (amount == 0) {
2755             super._transfer(from, to, 0);
2756             return;
2757         }
2758 
2759         if (limitsInEffect) {
2760             if (
2761                 from != owner() &&
2762                 to != owner() &&
2763                 to != address(0) &&
2764                 to != address(0xdead) &&
2765                 !swapping
2766             ) {
2767                 if (!tradingActive) {
2768                     require(
2769                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
2770                         "Trading is not active."
2771                     );
2772                 }
2773 
2774                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
2775                 if (transferDelayEnabled) {
2776                     if (
2777                         to != owner() &&
2778                         to != address(uniswapV2Router) &&
2779                         to != address(uniswapV2Pair)
2780                     ) {
2781                         require(
2782                             _holderLastTransferTimestamp[tx.origin] <
2783                                 block.number,
2784                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
2785                         );
2786                         _holderLastTransferTimestamp[tx.origin] = block.number;
2787                     }
2788                 }
2789 
2790                 //when buy
2791                 if (
2792                     automatedMarketMakerPairs[from] &&
2793                     !_isExcludedMaxTransactionAmount[to]
2794                 ) {
2795                     require(
2796                         amount <= maxTransactionAmount,
2797                         "Buy transfer amount exceeds the maxTransactionAmount."
2798                     );
2799                     require(
2800                         amount + balanceOf(to) <= maxWallet,
2801                         "Max wallet exceeded"
2802                     );
2803                 }
2804                 //when sell
2805                 else if (
2806                     automatedMarketMakerPairs[to] &&
2807                     !_isExcludedMaxTransactionAmount[from]
2808                 ) {
2809                     require(
2810                         amount <= maxTransactionAmount,
2811                         "Sell transfer amount exceeds the maxTransactionAmount."
2812                     );
2813                 } else if (!_isExcludedMaxTransactionAmount[to]) {
2814                     require(
2815                         amount + balanceOf(to) <= maxWallet,
2816                         "Max wallet exceeded"
2817                     );
2818                 }
2819             }
2820         }
2821 
2822         uint256 contractTokenBalance = balanceOf(address(this));
2823 
2824         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
2825 
2826         if (
2827             canSwap &&
2828             swapEnabled &&
2829             !swapping &&
2830             !automatedMarketMakerPairs[from] &&
2831             !_isExcludedFromFees[from] &&
2832             !_isExcludedFromFees[to]
2833         ) {
2834             swapping = true;
2835 
2836             swapBack();
2837 
2838             swapping = false;
2839         }
2840 
2841         bool takeFee = !swapping;
2842 
2843         // if any account belongs to _isExcludedFromFee account then remove the fee
2844         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
2845             takeFee = false;
2846         }
2847 
2848         uint256 fees = 0;
2849         // only take fees on buys/sells, do not take on wallet transfers
2850         if (takeFee) {
2851             // on sell
2852             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
2853                 if (_firstBuyTimeStamp[tx.origin] > 0 && block.timestamp.sub(_firstBuyTimeStamp[tx.origin]) <= 1 days) {
2854                     fees = amount.mul(15).div(100);
2855                 }else{
2856                     fees = amount.mul(sellTotalFees).div(100);
2857                 }
2858                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
2859                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
2860                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
2861             }
2862             // on buy
2863             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
2864                 fees = amount.mul(buyTotalFees).div(100);
2865                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
2866                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
2867                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
2868             }
2869 
2870             if (fees > 0) {
2871                 super._transfer(from, address(this), fees);
2872             }
2873 
2874             amount -= fees;
2875         }
2876 
2877         if (_firstBuyTimeStamp[tx.origin] == 0) {
2878             _firstBuyTimeStamp[tx.origin] = block.timestamp;
2879         }
2880 
2881         super._transfer(from, to, amount);
2882     }
2883 
2884     function swapTokensForEth(uint256 tokenAmount) private {
2885         // generate the uniswap pair path of token -> weth
2886         address[] memory path = new address[](2);
2887         path[0] = address(this);
2888         path[1] = uniswapV2Router.WETH();
2889 
2890         _approve(address(this), address(uniswapV2Router), tokenAmount);
2891 
2892         // make the swap
2893         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
2894             tokenAmount,
2895             0, // accept any amount of ETH
2896             path,
2897             address(this),
2898             block.timestamp
2899         );
2900     }
2901 
2902     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
2903         // approve token transfer to cover all possible scenarios
2904         _approve(address(this), address(uniswapV2Router), tokenAmount);
2905 
2906         // add the liquidity
2907         uniswapV2Router.addLiquidityETH{value: ethAmount}(
2908             address(this),
2909             tokenAmount,
2910             0, // slippage is unavoidable
2911             0, // slippage is unavoidable
2912             devWallet,
2913             block.timestamp
2914         );
2915     }
2916 
2917     function SwapETHtoTokensandBurn() private {
2918         uint256 contractETHBalance = address(this).balance;
2919         if (contractETHBalance < 0.05 ether) {
2920             return;
2921         }
2922         address[] memory path = new address[](2);
2923         path[0] = uniswapV2Router.WETH();
2924         path[1] = address(this);
2925         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{
2926             value: contractETHBalance
2927         }(
2928             0,
2929             path,
2930             deadAddress,
2931             block.timestamp
2932         );
2933     }
2934 
2935     function swapBack() private {
2936         uint256 contractBalance = balanceOf(address(this));
2937         uint256 totalTokensToSwap =  tokensForLiquidity + tokensForMarketing + tokensForDev;
2938         bool success;
2939 
2940         if (contractBalance == 0 || totalTokensToSwap == 0) {
2941             return;
2942         }
2943 
2944         if (contractBalance > swapTokensAtAmount * 20) {
2945             contractBalance = swapTokensAtAmount * 20;
2946         }
2947 
2948         // Halve the amount of liquidity tokens
2949         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
2950         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
2951 
2952         uint256 initialETHBalance = address(this).balance;
2953 
2954         swapTokensForEth(amountToSwapForETH);
2955         if (burnTax){
2956             SwapETHtoTokensandBurn();
2957             return;
2958         }
2959         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
2960 
2961         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
2962         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
2963         uint256 ethForLiquidity = ethBalance  - ethForMarketing - ethForDev;
2964 
2965         tokensForLiquidity = 0;
2966         tokensForMarketing = 0;
2967         tokensForDev = 0;
2968 
2969         (success, ) = address(devWallet).call{value: ethForDev}("");
2970         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
2971 
2972         if (liquidityTokens > 0 && ethForLiquidity > 0) {
2973             addLiquidity(liquidityTokens, ethForLiquidity);
2974             emit SwapAndLiquify(
2975                 amountToSwapForETH,
2976                 ethForLiquidity,
2977                 tokensForLiquidity
2978             );
2979         }
2980     }
2981 
2982 }