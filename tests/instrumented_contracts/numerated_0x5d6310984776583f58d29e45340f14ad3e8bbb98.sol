1 // SPDX-License-Identifier: MIT
2 
3 // File: hardhat/console.sol
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
24 	function logInt(int256 p0) internal view {
25 		_sendLogPayload(abi.encodeWithSignature("log(int256)", p0));
26 	}
27 
28 	function logUint(uint256 p0) internal view {
29 		_sendLogPayload(abi.encodeWithSignature("log(uint256)", p0));
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
176 	function log(uint256 p0) internal view {
177 		_sendLogPayload(abi.encodeWithSignature("log(uint256)", p0));
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
192 	function log(uint256 p0, uint256 p1) internal view {
193 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256)", p0, p1));
194 	}
195 
196 	function log(uint256 p0, string memory p1) internal view {
197 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string)", p0, p1));
198 	}
199 
200 	function log(uint256 p0, bool p1) internal view {
201 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool)", p0, p1));
202 	}
203 
204 	function log(uint256 p0, address p1) internal view {
205 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address)", p0, p1));
206 	}
207 
208 	function log(string memory p0, uint256 p1) internal view {
209 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256)", p0, p1));
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
224 	function log(bool p0, uint256 p1) internal view {
225 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256)", p0, p1));
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
240 	function log(address p0, uint256 p1) internal view {
241 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256)", p0, p1));
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
256 	function log(uint256 p0, uint256 p1, uint256 p2) internal view {
257 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256)", p0, p1, p2));
258 	}
259 
260 	function log(uint256 p0, uint256 p1, string memory p2) internal view {
261 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string)", p0, p1, p2));
262 	}
263 
264 	function log(uint256 p0, uint256 p1, bool p2) internal view {
265 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool)", p0, p1, p2));
266 	}
267 
268 	function log(uint256 p0, uint256 p1, address p2) internal view {
269 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address)", p0, p1, p2));
270 	}
271 
272 	function log(uint256 p0, string memory p1, uint256 p2) internal view {
273 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256)", p0, p1, p2));
274 	}
275 
276 	function log(uint256 p0, string memory p1, string memory p2) internal view {
277 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string)", p0, p1, p2));
278 	}
279 
280 	function log(uint256 p0, string memory p1, bool p2) internal view {
281 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool)", p0, p1, p2));
282 	}
283 
284 	function log(uint256 p0, string memory p1, address p2) internal view {
285 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address)", p0, p1, p2));
286 	}
287 
288 	function log(uint256 p0, bool p1, uint256 p2) internal view {
289 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256)", p0, p1, p2));
290 	}
291 
292 	function log(uint256 p0, bool p1, string memory p2) internal view {
293 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string)", p0, p1, p2));
294 	}
295 
296 	function log(uint256 p0, bool p1, bool p2) internal view {
297 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool)", p0, p1, p2));
298 	}
299 
300 	function log(uint256 p0, bool p1, address p2) internal view {
301 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address)", p0, p1, p2));
302 	}
303 
304 	function log(uint256 p0, address p1, uint256 p2) internal view {
305 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256)", p0, p1, p2));
306 	}
307 
308 	function log(uint256 p0, address p1, string memory p2) internal view {
309 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string)", p0, p1, p2));
310 	}
311 
312 	function log(uint256 p0, address p1, bool p2) internal view {
313 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool)", p0, p1, p2));
314 	}
315 
316 	function log(uint256 p0, address p1, address p2) internal view {
317 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address)", p0, p1, p2));
318 	}
319 
320 	function log(string memory p0, uint256 p1, uint256 p2) internal view {
321 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256)", p0, p1, p2));
322 	}
323 
324 	function log(string memory p0, uint256 p1, string memory p2) internal view {
325 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string)", p0, p1, p2));
326 	}
327 
328 	function log(string memory p0, uint256 p1, bool p2) internal view {
329 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool)", p0, p1, p2));
330 	}
331 
332 	function log(string memory p0, uint256 p1, address p2) internal view {
333 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address)", p0, p1, p2));
334 	}
335 
336 	function log(string memory p0, string memory p1, uint256 p2) internal view {
337 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256)", p0, p1, p2));
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
352 	function log(string memory p0, bool p1, uint256 p2) internal view {
353 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256)", p0, p1, p2));
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
368 	function log(string memory p0, address p1, uint256 p2) internal view {
369 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256)", p0, p1, p2));
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
384 	function log(bool p0, uint256 p1, uint256 p2) internal view {
385 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256)", p0, p1, p2));
386 	}
387 
388 	function log(bool p0, uint256 p1, string memory p2) internal view {
389 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string)", p0, p1, p2));
390 	}
391 
392 	function log(bool p0, uint256 p1, bool p2) internal view {
393 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool)", p0, p1, p2));
394 	}
395 
396 	function log(bool p0, uint256 p1, address p2) internal view {
397 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address)", p0, p1, p2));
398 	}
399 
400 	function log(bool p0, string memory p1, uint256 p2) internal view {
401 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256)", p0, p1, p2));
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
416 	function log(bool p0, bool p1, uint256 p2) internal view {
417 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256)", p0, p1, p2));
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
432 	function log(bool p0, address p1, uint256 p2) internal view {
433 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256)", p0, p1, p2));
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
448 	function log(address p0, uint256 p1, uint256 p2) internal view {
449 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256)", p0, p1, p2));
450 	}
451 
452 	function log(address p0, uint256 p1, string memory p2) internal view {
453 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string)", p0, p1, p2));
454 	}
455 
456 	function log(address p0, uint256 p1, bool p2) internal view {
457 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool)", p0, p1, p2));
458 	}
459 
460 	function log(address p0, uint256 p1, address p2) internal view {
461 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address)", p0, p1, p2));
462 	}
463 
464 	function log(address p0, string memory p1, uint256 p2) internal view {
465 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256)", p0, p1, p2));
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
480 	function log(address p0, bool p1, uint256 p2) internal view {
481 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256)", p0, p1, p2));
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
496 	function log(address p0, address p1, uint256 p2) internal view {
497 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256)", p0, p1, p2));
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
512 	function log(uint256 p0, uint256 p1, uint256 p2, uint256 p3) internal view {
513 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,uint256)", p0, p1, p2, p3));
514 	}
515 
516 	function log(uint256 p0, uint256 p1, uint256 p2, string memory p3) internal view {
517 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,string)", p0, p1, p2, p3));
518 	}
519 
520 	function log(uint256 p0, uint256 p1, uint256 p2, bool p3) internal view {
521 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,bool)", p0, p1, p2, p3));
522 	}
523 
524 	function log(uint256 p0, uint256 p1, uint256 p2, address p3) internal view {
525 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,address)", p0, p1, p2, p3));
526 	}
527 
528 	function log(uint256 p0, uint256 p1, string memory p2, uint256 p3) internal view {
529 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,uint256)", p0, p1, p2, p3));
530 	}
531 
532 	function log(uint256 p0, uint256 p1, string memory p2, string memory p3) internal view {
533 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,string)", p0, p1, p2, p3));
534 	}
535 
536 	function log(uint256 p0, uint256 p1, string memory p2, bool p3) internal view {
537 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,bool)", p0, p1, p2, p3));
538 	}
539 
540 	function log(uint256 p0, uint256 p1, string memory p2, address p3) internal view {
541 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,address)", p0, p1, p2, p3));
542 	}
543 
544 	function log(uint256 p0, uint256 p1, bool p2, uint256 p3) internal view {
545 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,uint256)", p0, p1, p2, p3));
546 	}
547 
548 	function log(uint256 p0, uint256 p1, bool p2, string memory p3) internal view {
549 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,string)", p0, p1, p2, p3));
550 	}
551 
552 	function log(uint256 p0, uint256 p1, bool p2, bool p3) internal view {
553 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,bool)", p0, p1, p2, p3));
554 	}
555 
556 	function log(uint256 p0, uint256 p1, bool p2, address p3) internal view {
557 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,address)", p0, p1, p2, p3));
558 	}
559 
560 	function log(uint256 p0, uint256 p1, address p2, uint256 p3) internal view {
561 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,uint256)", p0, p1, p2, p3));
562 	}
563 
564 	function log(uint256 p0, uint256 p1, address p2, string memory p3) internal view {
565 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,string)", p0, p1, p2, p3));
566 	}
567 
568 	function log(uint256 p0, uint256 p1, address p2, bool p3) internal view {
569 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,bool)", p0, p1, p2, p3));
570 	}
571 
572 	function log(uint256 p0, uint256 p1, address p2, address p3) internal view {
573 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,address)", p0, p1, p2, p3));
574 	}
575 
576 	function log(uint256 p0, string memory p1, uint256 p2, uint256 p3) internal view {
577 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,uint256)", p0, p1, p2, p3));
578 	}
579 
580 	function log(uint256 p0, string memory p1, uint256 p2, string memory p3) internal view {
581 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,string)", p0, p1, p2, p3));
582 	}
583 
584 	function log(uint256 p0, string memory p1, uint256 p2, bool p3) internal view {
585 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,bool)", p0, p1, p2, p3));
586 	}
587 
588 	function log(uint256 p0, string memory p1, uint256 p2, address p3) internal view {
589 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,address)", p0, p1, p2, p3));
590 	}
591 
592 	function log(uint256 p0, string memory p1, string memory p2, uint256 p3) internal view {
593 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,uint256)", p0, p1, p2, p3));
594 	}
595 
596 	function log(uint256 p0, string memory p1, string memory p2, string memory p3) internal view {
597 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,string)", p0, p1, p2, p3));
598 	}
599 
600 	function log(uint256 p0, string memory p1, string memory p2, bool p3) internal view {
601 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,bool)", p0, p1, p2, p3));
602 	}
603 
604 	function log(uint256 p0, string memory p1, string memory p2, address p3) internal view {
605 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,address)", p0, p1, p2, p3));
606 	}
607 
608 	function log(uint256 p0, string memory p1, bool p2, uint256 p3) internal view {
609 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,uint256)", p0, p1, p2, p3));
610 	}
611 
612 	function log(uint256 p0, string memory p1, bool p2, string memory p3) internal view {
613 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,string)", p0, p1, p2, p3));
614 	}
615 
616 	function log(uint256 p0, string memory p1, bool p2, bool p3) internal view {
617 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,bool)", p0, p1, p2, p3));
618 	}
619 
620 	function log(uint256 p0, string memory p1, bool p2, address p3) internal view {
621 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,address)", p0, p1, p2, p3));
622 	}
623 
624 	function log(uint256 p0, string memory p1, address p2, uint256 p3) internal view {
625 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,uint256)", p0, p1, p2, p3));
626 	}
627 
628 	function log(uint256 p0, string memory p1, address p2, string memory p3) internal view {
629 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,string)", p0, p1, p2, p3));
630 	}
631 
632 	function log(uint256 p0, string memory p1, address p2, bool p3) internal view {
633 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,bool)", p0, p1, p2, p3));
634 	}
635 
636 	function log(uint256 p0, string memory p1, address p2, address p3) internal view {
637 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,address)", p0, p1, p2, p3));
638 	}
639 
640 	function log(uint256 p0, bool p1, uint256 p2, uint256 p3) internal view {
641 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,uint256)", p0, p1, p2, p3));
642 	}
643 
644 	function log(uint256 p0, bool p1, uint256 p2, string memory p3) internal view {
645 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,string)", p0, p1, p2, p3));
646 	}
647 
648 	function log(uint256 p0, bool p1, uint256 p2, bool p3) internal view {
649 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,bool)", p0, p1, p2, p3));
650 	}
651 
652 	function log(uint256 p0, bool p1, uint256 p2, address p3) internal view {
653 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,address)", p0, p1, p2, p3));
654 	}
655 
656 	function log(uint256 p0, bool p1, string memory p2, uint256 p3) internal view {
657 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,uint256)", p0, p1, p2, p3));
658 	}
659 
660 	function log(uint256 p0, bool p1, string memory p2, string memory p3) internal view {
661 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,string)", p0, p1, p2, p3));
662 	}
663 
664 	function log(uint256 p0, bool p1, string memory p2, bool p3) internal view {
665 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,bool)", p0, p1, p2, p3));
666 	}
667 
668 	function log(uint256 p0, bool p1, string memory p2, address p3) internal view {
669 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,address)", p0, p1, p2, p3));
670 	}
671 
672 	function log(uint256 p0, bool p1, bool p2, uint256 p3) internal view {
673 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,uint256)", p0, p1, p2, p3));
674 	}
675 
676 	function log(uint256 p0, bool p1, bool p2, string memory p3) internal view {
677 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,string)", p0, p1, p2, p3));
678 	}
679 
680 	function log(uint256 p0, bool p1, bool p2, bool p3) internal view {
681 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,bool)", p0, p1, p2, p3));
682 	}
683 
684 	function log(uint256 p0, bool p1, bool p2, address p3) internal view {
685 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,address)", p0, p1, p2, p3));
686 	}
687 
688 	function log(uint256 p0, bool p1, address p2, uint256 p3) internal view {
689 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,uint256)", p0, p1, p2, p3));
690 	}
691 
692 	function log(uint256 p0, bool p1, address p2, string memory p3) internal view {
693 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,string)", p0, p1, p2, p3));
694 	}
695 
696 	function log(uint256 p0, bool p1, address p2, bool p3) internal view {
697 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,bool)", p0, p1, p2, p3));
698 	}
699 
700 	function log(uint256 p0, bool p1, address p2, address p3) internal view {
701 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,address)", p0, p1, p2, p3));
702 	}
703 
704 	function log(uint256 p0, address p1, uint256 p2, uint256 p3) internal view {
705 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,uint256)", p0, p1, p2, p3));
706 	}
707 
708 	function log(uint256 p0, address p1, uint256 p2, string memory p3) internal view {
709 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,string)", p0, p1, p2, p3));
710 	}
711 
712 	function log(uint256 p0, address p1, uint256 p2, bool p3) internal view {
713 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,bool)", p0, p1, p2, p3));
714 	}
715 
716 	function log(uint256 p0, address p1, uint256 p2, address p3) internal view {
717 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,address)", p0, p1, p2, p3));
718 	}
719 
720 	function log(uint256 p0, address p1, string memory p2, uint256 p3) internal view {
721 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,uint256)", p0, p1, p2, p3));
722 	}
723 
724 	function log(uint256 p0, address p1, string memory p2, string memory p3) internal view {
725 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,string)", p0, p1, p2, p3));
726 	}
727 
728 	function log(uint256 p0, address p1, string memory p2, bool p3) internal view {
729 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,bool)", p0, p1, p2, p3));
730 	}
731 
732 	function log(uint256 p0, address p1, string memory p2, address p3) internal view {
733 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,address)", p0, p1, p2, p3));
734 	}
735 
736 	function log(uint256 p0, address p1, bool p2, uint256 p3) internal view {
737 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,uint256)", p0, p1, p2, p3));
738 	}
739 
740 	function log(uint256 p0, address p1, bool p2, string memory p3) internal view {
741 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,string)", p0, p1, p2, p3));
742 	}
743 
744 	function log(uint256 p0, address p1, bool p2, bool p3) internal view {
745 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,bool)", p0, p1, p2, p3));
746 	}
747 
748 	function log(uint256 p0, address p1, bool p2, address p3) internal view {
749 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,address)", p0, p1, p2, p3));
750 	}
751 
752 	function log(uint256 p0, address p1, address p2, uint256 p3) internal view {
753 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,uint256)", p0, p1, p2, p3));
754 	}
755 
756 	function log(uint256 p0, address p1, address p2, string memory p3) internal view {
757 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,string)", p0, p1, p2, p3));
758 	}
759 
760 	function log(uint256 p0, address p1, address p2, bool p3) internal view {
761 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,bool)", p0, p1, p2, p3));
762 	}
763 
764 	function log(uint256 p0, address p1, address p2, address p3) internal view {
765 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,address)", p0, p1, p2, p3));
766 	}
767 
768 	function log(string memory p0, uint256 p1, uint256 p2, uint256 p3) internal view {
769 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,uint256)", p0, p1, p2, p3));
770 	}
771 
772 	function log(string memory p0, uint256 p1, uint256 p2, string memory p3) internal view {
773 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,string)", p0, p1, p2, p3));
774 	}
775 
776 	function log(string memory p0, uint256 p1, uint256 p2, bool p3) internal view {
777 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,bool)", p0, p1, p2, p3));
778 	}
779 
780 	function log(string memory p0, uint256 p1, uint256 p2, address p3) internal view {
781 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,address)", p0, p1, p2, p3));
782 	}
783 
784 	function log(string memory p0, uint256 p1, string memory p2, uint256 p3) internal view {
785 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,uint256)", p0, p1, p2, p3));
786 	}
787 
788 	function log(string memory p0, uint256 p1, string memory p2, string memory p3) internal view {
789 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,string)", p0, p1, p2, p3));
790 	}
791 
792 	function log(string memory p0, uint256 p1, string memory p2, bool p3) internal view {
793 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,bool)", p0, p1, p2, p3));
794 	}
795 
796 	function log(string memory p0, uint256 p1, string memory p2, address p3) internal view {
797 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,address)", p0, p1, p2, p3));
798 	}
799 
800 	function log(string memory p0, uint256 p1, bool p2, uint256 p3) internal view {
801 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,uint256)", p0, p1, p2, p3));
802 	}
803 
804 	function log(string memory p0, uint256 p1, bool p2, string memory p3) internal view {
805 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,string)", p0, p1, p2, p3));
806 	}
807 
808 	function log(string memory p0, uint256 p1, bool p2, bool p3) internal view {
809 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,bool)", p0, p1, p2, p3));
810 	}
811 
812 	function log(string memory p0, uint256 p1, bool p2, address p3) internal view {
813 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,address)", p0, p1, p2, p3));
814 	}
815 
816 	function log(string memory p0, uint256 p1, address p2, uint256 p3) internal view {
817 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,uint256)", p0, p1, p2, p3));
818 	}
819 
820 	function log(string memory p0, uint256 p1, address p2, string memory p3) internal view {
821 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,string)", p0, p1, p2, p3));
822 	}
823 
824 	function log(string memory p0, uint256 p1, address p2, bool p3) internal view {
825 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,bool)", p0, p1, p2, p3));
826 	}
827 
828 	function log(string memory p0, uint256 p1, address p2, address p3) internal view {
829 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,address)", p0, p1, p2, p3));
830 	}
831 
832 	function log(string memory p0, string memory p1, uint256 p2, uint256 p3) internal view {
833 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,uint256)", p0, p1, p2, p3));
834 	}
835 
836 	function log(string memory p0, string memory p1, uint256 p2, string memory p3) internal view {
837 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,string)", p0, p1, p2, p3));
838 	}
839 
840 	function log(string memory p0, string memory p1, uint256 p2, bool p3) internal view {
841 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,bool)", p0, p1, p2, p3));
842 	}
843 
844 	function log(string memory p0, string memory p1, uint256 p2, address p3) internal view {
845 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,address)", p0, p1, p2, p3));
846 	}
847 
848 	function log(string memory p0, string memory p1, string memory p2, uint256 p3) internal view {
849 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint256)", p0, p1, p2, p3));
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
864 	function log(string memory p0, string memory p1, bool p2, uint256 p3) internal view {
865 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint256)", p0, p1, p2, p3));
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
880 	function log(string memory p0, string memory p1, address p2, uint256 p3) internal view {
881 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint256)", p0, p1, p2, p3));
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
896 	function log(string memory p0, bool p1, uint256 p2, uint256 p3) internal view {
897 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,uint256)", p0, p1, p2, p3));
898 	}
899 
900 	function log(string memory p0, bool p1, uint256 p2, string memory p3) internal view {
901 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,string)", p0, p1, p2, p3));
902 	}
903 
904 	function log(string memory p0, bool p1, uint256 p2, bool p3) internal view {
905 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,bool)", p0, p1, p2, p3));
906 	}
907 
908 	function log(string memory p0, bool p1, uint256 p2, address p3) internal view {
909 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,address)", p0, p1, p2, p3));
910 	}
911 
912 	function log(string memory p0, bool p1, string memory p2, uint256 p3) internal view {
913 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint256)", p0, p1, p2, p3));
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
928 	function log(string memory p0, bool p1, bool p2, uint256 p3) internal view {
929 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint256)", p0, p1, p2, p3));
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
944 	function log(string memory p0, bool p1, address p2, uint256 p3) internal view {
945 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint256)", p0, p1, p2, p3));
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
960 	function log(string memory p0, address p1, uint256 p2, uint256 p3) internal view {
961 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,uint256)", p0, p1, p2, p3));
962 	}
963 
964 	function log(string memory p0, address p1, uint256 p2, string memory p3) internal view {
965 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,string)", p0, p1, p2, p3));
966 	}
967 
968 	function log(string memory p0, address p1, uint256 p2, bool p3) internal view {
969 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,bool)", p0, p1, p2, p3));
970 	}
971 
972 	function log(string memory p0, address p1, uint256 p2, address p3) internal view {
973 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,address)", p0, p1, p2, p3));
974 	}
975 
976 	function log(string memory p0, address p1, string memory p2, uint256 p3) internal view {
977 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint256)", p0, p1, p2, p3));
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
992 	function log(string memory p0, address p1, bool p2, uint256 p3) internal view {
993 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint256)", p0, p1, p2, p3));
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
1008 	function log(string memory p0, address p1, address p2, uint256 p3) internal view {
1009 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint256)", p0, p1, p2, p3));
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
1024 	function log(bool p0, uint256 p1, uint256 p2, uint256 p3) internal view {
1025 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,uint256)", p0, p1, p2, p3));
1026 	}
1027 
1028 	function log(bool p0, uint256 p1, uint256 p2, string memory p3) internal view {
1029 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,string)", p0, p1, p2, p3));
1030 	}
1031 
1032 	function log(bool p0, uint256 p1, uint256 p2, bool p3) internal view {
1033 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,bool)", p0, p1, p2, p3));
1034 	}
1035 
1036 	function log(bool p0, uint256 p1, uint256 p2, address p3) internal view {
1037 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,address)", p0, p1, p2, p3));
1038 	}
1039 
1040 	function log(bool p0, uint256 p1, string memory p2, uint256 p3) internal view {
1041 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,uint256)", p0, p1, p2, p3));
1042 	}
1043 
1044 	function log(bool p0, uint256 p1, string memory p2, string memory p3) internal view {
1045 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,string)", p0, p1, p2, p3));
1046 	}
1047 
1048 	function log(bool p0, uint256 p1, string memory p2, bool p3) internal view {
1049 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,bool)", p0, p1, p2, p3));
1050 	}
1051 
1052 	function log(bool p0, uint256 p1, string memory p2, address p3) internal view {
1053 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,address)", p0, p1, p2, p3));
1054 	}
1055 
1056 	function log(bool p0, uint256 p1, bool p2, uint256 p3) internal view {
1057 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,uint256)", p0, p1, p2, p3));
1058 	}
1059 
1060 	function log(bool p0, uint256 p1, bool p2, string memory p3) internal view {
1061 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,string)", p0, p1, p2, p3));
1062 	}
1063 
1064 	function log(bool p0, uint256 p1, bool p2, bool p3) internal view {
1065 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,bool)", p0, p1, p2, p3));
1066 	}
1067 
1068 	function log(bool p0, uint256 p1, bool p2, address p3) internal view {
1069 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,address)", p0, p1, p2, p3));
1070 	}
1071 
1072 	function log(bool p0, uint256 p1, address p2, uint256 p3) internal view {
1073 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,uint256)", p0, p1, p2, p3));
1074 	}
1075 
1076 	function log(bool p0, uint256 p1, address p2, string memory p3) internal view {
1077 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,string)", p0, p1, p2, p3));
1078 	}
1079 
1080 	function log(bool p0, uint256 p1, address p2, bool p3) internal view {
1081 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,bool)", p0, p1, p2, p3));
1082 	}
1083 
1084 	function log(bool p0, uint256 p1, address p2, address p3) internal view {
1085 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,address)", p0, p1, p2, p3));
1086 	}
1087 
1088 	function log(bool p0, string memory p1, uint256 p2, uint256 p3) internal view {
1089 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,uint256)", p0, p1, p2, p3));
1090 	}
1091 
1092 	function log(bool p0, string memory p1, uint256 p2, string memory p3) internal view {
1093 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,string)", p0, p1, p2, p3));
1094 	}
1095 
1096 	function log(bool p0, string memory p1, uint256 p2, bool p3) internal view {
1097 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,bool)", p0, p1, p2, p3));
1098 	}
1099 
1100 	function log(bool p0, string memory p1, uint256 p2, address p3) internal view {
1101 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,address)", p0, p1, p2, p3));
1102 	}
1103 
1104 	function log(bool p0, string memory p1, string memory p2, uint256 p3) internal view {
1105 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint256)", p0, p1, p2, p3));
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
1120 	function log(bool p0, string memory p1, bool p2, uint256 p3) internal view {
1121 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint256)", p0, p1, p2, p3));
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
1136 	function log(bool p0, string memory p1, address p2, uint256 p3) internal view {
1137 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint256)", p0, p1, p2, p3));
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
1152 	function log(bool p0, bool p1, uint256 p2, uint256 p3) internal view {
1153 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,uint256)", p0, p1, p2, p3));
1154 	}
1155 
1156 	function log(bool p0, bool p1, uint256 p2, string memory p3) internal view {
1157 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,string)", p0, p1, p2, p3));
1158 	}
1159 
1160 	function log(bool p0, bool p1, uint256 p2, bool p3) internal view {
1161 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,bool)", p0, p1, p2, p3));
1162 	}
1163 
1164 	function log(bool p0, bool p1, uint256 p2, address p3) internal view {
1165 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,address)", p0, p1, p2, p3));
1166 	}
1167 
1168 	function log(bool p0, bool p1, string memory p2, uint256 p3) internal view {
1169 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint256)", p0, p1, p2, p3));
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
1184 	function log(bool p0, bool p1, bool p2, uint256 p3) internal view {
1185 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint256)", p0, p1, p2, p3));
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
1200 	function log(bool p0, bool p1, address p2, uint256 p3) internal view {
1201 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint256)", p0, p1, p2, p3));
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
1216 	function log(bool p0, address p1, uint256 p2, uint256 p3) internal view {
1217 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,uint256)", p0, p1, p2, p3));
1218 	}
1219 
1220 	function log(bool p0, address p1, uint256 p2, string memory p3) internal view {
1221 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,string)", p0, p1, p2, p3));
1222 	}
1223 
1224 	function log(bool p0, address p1, uint256 p2, bool p3) internal view {
1225 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,bool)", p0, p1, p2, p3));
1226 	}
1227 
1228 	function log(bool p0, address p1, uint256 p2, address p3) internal view {
1229 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,address)", p0, p1, p2, p3));
1230 	}
1231 
1232 	function log(bool p0, address p1, string memory p2, uint256 p3) internal view {
1233 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint256)", p0, p1, p2, p3));
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
1248 	function log(bool p0, address p1, bool p2, uint256 p3) internal view {
1249 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint256)", p0, p1, p2, p3));
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
1264 	function log(bool p0, address p1, address p2, uint256 p3) internal view {
1265 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint256)", p0, p1, p2, p3));
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
1280 	function log(address p0, uint256 p1, uint256 p2, uint256 p3) internal view {
1281 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,uint256)", p0, p1, p2, p3));
1282 	}
1283 
1284 	function log(address p0, uint256 p1, uint256 p2, string memory p3) internal view {
1285 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,string)", p0, p1, p2, p3));
1286 	}
1287 
1288 	function log(address p0, uint256 p1, uint256 p2, bool p3) internal view {
1289 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,bool)", p0, p1, p2, p3));
1290 	}
1291 
1292 	function log(address p0, uint256 p1, uint256 p2, address p3) internal view {
1293 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,address)", p0, p1, p2, p3));
1294 	}
1295 
1296 	function log(address p0, uint256 p1, string memory p2, uint256 p3) internal view {
1297 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,uint256)", p0, p1, p2, p3));
1298 	}
1299 
1300 	function log(address p0, uint256 p1, string memory p2, string memory p3) internal view {
1301 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,string)", p0, p1, p2, p3));
1302 	}
1303 
1304 	function log(address p0, uint256 p1, string memory p2, bool p3) internal view {
1305 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,bool)", p0, p1, p2, p3));
1306 	}
1307 
1308 	function log(address p0, uint256 p1, string memory p2, address p3) internal view {
1309 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,address)", p0, p1, p2, p3));
1310 	}
1311 
1312 	function log(address p0, uint256 p1, bool p2, uint256 p3) internal view {
1313 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,uint256)", p0, p1, p2, p3));
1314 	}
1315 
1316 	function log(address p0, uint256 p1, bool p2, string memory p3) internal view {
1317 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,string)", p0, p1, p2, p3));
1318 	}
1319 
1320 	function log(address p0, uint256 p1, bool p2, bool p3) internal view {
1321 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,bool)", p0, p1, p2, p3));
1322 	}
1323 
1324 	function log(address p0, uint256 p1, bool p2, address p3) internal view {
1325 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,address)", p0, p1, p2, p3));
1326 	}
1327 
1328 	function log(address p0, uint256 p1, address p2, uint256 p3) internal view {
1329 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,uint256)", p0, p1, p2, p3));
1330 	}
1331 
1332 	function log(address p0, uint256 p1, address p2, string memory p3) internal view {
1333 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,string)", p0, p1, p2, p3));
1334 	}
1335 
1336 	function log(address p0, uint256 p1, address p2, bool p3) internal view {
1337 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,bool)", p0, p1, p2, p3));
1338 	}
1339 
1340 	function log(address p0, uint256 p1, address p2, address p3) internal view {
1341 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,address)", p0, p1, p2, p3));
1342 	}
1343 
1344 	function log(address p0, string memory p1, uint256 p2, uint256 p3) internal view {
1345 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,uint256)", p0, p1, p2, p3));
1346 	}
1347 
1348 	function log(address p0, string memory p1, uint256 p2, string memory p3) internal view {
1349 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,string)", p0, p1, p2, p3));
1350 	}
1351 
1352 	function log(address p0, string memory p1, uint256 p2, bool p3) internal view {
1353 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,bool)", p0, p1, p2, p3));
1354 	}
1355 
1356 	function log(address p0, string memory p1, uint256 p2, address p3) internal view {
1357 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,address)", p0, p1, p2, p3));
1358 	}
1359 
1360 	function log(address p0, string memory p1, string memory p2, uint256 p3) internal view {
1361 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint256)", p0, p1, p2, p3));
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
1376 	function log(address p0, string memory p1, bool p2, uint256 p3) internal view {
1377 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint256)", p0, p1, p2, p3));
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
1392 	function log(address p0, string memory p1, address p2, uint256 p3) internal view {
1393 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint256)", p0, p1, p2, p3));
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
1408 	function log(address p0, bool p1, uint256 p2, uint256 p3) internal view {
1409 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,uint256)", p0, p1, p2, p3));
1410 	}
1411 
1412 	function log(address p0, bool p1, uint256 p2, string memory p3) internal view {
1413 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,string)", p0, p1, p2, p3));
1414 	}
1415 
1416 	function log(address p0, bool p1, uint256 p2, bool p3) internal view {
1417 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,bool)", p0, p1, p2, p3));
1418 	}
1419 
1420 	function log(address p0, bool p1, uint256 p2, address p3) internal view {
1421 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,address)", p0, p1, p2, p3));
1422 	}
1423 
1424 	function log(address p0, bool p1, string memory p2, uint256 p3) internal view {
1425 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint256)", p0, p1, p2, p3));
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
1440 	function log(address p0, bool p1, bool p2, uint256 p3) internal view {
1441 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint256)", p0, p1, p2, p3));
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
1456 	function log(address p0, bool p1, address p2, uint256 p3) internal view {
1457 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint256)", p0, p1, p2, p3));
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
1472 	function log(address p0, address p1, uint256 p2, uint256 p3) internal view {
1473 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,uint256)", p0, p1, p2, p3));
1474 	}
1475 
1476 	function log(address p0, address p1, uint256 p2, string memory p3) internal view {
1477 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,string)", p0, p1, p2, p3));
1478 	}
1479 
1480 	function log(address p0, address p1, uint256 p2, bool p3) internal view {
1481 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,bool)", p0, p1, p2, p3));
1482 	}
1483 
1484 	function log(address p0, address p1, uint256 p2, address p3) internal view {
1485 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,address)", p0, p1, p2, p3));
1486 	}
1487 
1488 	function log(address p0, address p1, string memory p2, uint256 p3) internal view {
1489 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint256)", p0, p1, p2, p3));
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
1504 	function log(address p0, address p1, bool p2, uint256 p3) internal view {
1505 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint256)", p0, p1, p2, p3));
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
1520 	function log(address p0, address p1, address p2, uint256 p3) internal view {
1521 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint256)", p0, p1, p2, p3));
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
1538 // File: contracts/Owner.sol
1539 
1540 
1541 
1542 pragma solidity >=0.7.0 <0.9.0;
1543 
1544 
1545 /**
1546  * @title Owner
1547  * @dev Set & change owner
1548  */
1549 contract Owner {
1550 
1551     address private owner;
1552 
1553     // event for EVM logging
1554     event OwnerSet(address indexed oldOwner, address indexed newOwner);
1555 
1556     // modifier to check if caller is owner
1557     modifier isOwner() {
1558         // If the first argument of 'require' evaluates to 'false', execution terminates and all
1559         // changes to the state and to Ether balances are reverted.
1560         // This used to consume all gas in old EVM versions, but not anymore.
1561         // It is often a good idea to use 'require' to check if functions are called correctly.
1562         // As a second argument, you can also provide an explanation about what went wrong.
1563         require(msg.sender == owner, "Caller is not owner");
1564         _;
1565     }
1566 
1567     /**
1568      * @dev Set contract deployer as owner
1569      */
1570     constructor() {
1571         console.log("Owner contract deployed by:", msg.sender);
1572         owner = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
1573         emit OwnerSet(address(0), owner);
1574     }
1575 
1576     /**
1577      * @dev Change owner
1578      * @param newOwner address of new owner
1579      */
1580     function changeOwner(address newOwner) public isOwner {
1581         emit OwnerSet(owner, newOwner);
1582         owner = newOwner;
1583     }
1584 
1585     /**
1586      * @dev Return owner address 
1587      * @return address of owner
1588      */
1589     function getOwner() external view returns (address) {
1590         return owner;
1591     }
1592 } 
1593 // File: contracts/SafeMath.sol
1594 
1595 
1596 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
1597 
1598 pragma solidity ^0.8.0;
1599 
1600 // CAUTION
1601 // This version of SafeMath should only be used with Solidity 0.8 or later,
1602 // because it relies on the compiler's built in overflow checks.
1603 
1604 /**
1605  * @dev Wrappers over Solidity's arithmetic operations.
1606  *
1607  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1608  * now has built in overflow checking.
1609  */
1610 library SafeMath {
1611     /**
1612      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1613      *
1614      * _Available since v3.4._
1615      */
1616     function tryAdd(
1617         uint256 a,
1618         uint256 b
1619     ) internal pure returns (bool, uint256) {
1620         unchecked {
1621             uint256 c = a + b;
1622             if (c < a) return (false, 0);
1623             return (true, c);
1624         }
1625     }
1626 
1627     /**
1628      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
1629      *
1630      * _Available since v3.4._
1631      */
1632     function trySub(
1633         uint256 a,
1634         uint256 b
1635     ) internal pure returns (bool, uint256) {
1636         unchecked {
1637             if (b > a) return (false, 0);
1638             return (true, a - b);
1639         }
1640     }
1641 
1642     /**
1643      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1644      *
1645      * _Available since v3.4._
1646      */
1647     function tryMul(
1648         uint256 a,
1649         uint256 b
1650     ) internal pure returns (bool, uint256) {
1651         unchecked {
1652             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1653             // benefit is lost if 'b' is also tested.
1654             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1655             if (a == 0) return (true, 0);
1656             uint256 c = a * b;
1657             if (c / a != b) return (false, 0);
1658             return (true, c);
1659         }
1660     }
1661 
1662     /**
1663      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1664      *
1665      * _Available since v3.4._
1666      */
1667     function tryDiv(
1668         uint256 a,
1669         uint256 b
1670     ) internal pure returns (bool, uint256) {
1671         unchecked {
1672             if (b == 0) return (false, 0);
1673             return (true, a / b);
1674         }
1675     }
1676 
1677     /**
1678      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1679      *
1680      * _Available since v3.4._
1681      */
1682     function tryMod(
1683         uint256 a,
1684         uint256 b
1685     ) internal pure returns (bool, uint256) {
1686         unchecked {
1687             if (b == 0) return (false, 0);
1688             return (true, a % b);
1689         }
1690     }
1691 
1692     /**
1693      * @dev Returns the addition of two unsigned integers, reverting on
1694      * overflow.
1695      *
1696      * Counterpart to Solidity's `+` operator.
1697      *
1698      * Requirements:
1699      *
1700      * - Addition cannot overflow.
1701      */
1702     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1703         return a + b;
1704     }
1705 
1706     /**
1707      * @dev Returns the subtraction of two unsigned integers, reverting on
1708      * overflow (when the result is negative).
1709      *
1710      * Counterpart to Solidity's `-` operator.
1711      *
1712      * Requirements:
1713      *
1714      * - Subtraction cannot overflow.
1715      */
1716     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1717         return a - b;
1718     }
1719 
1720     /**
1721      * @dev Returns the multiplication of two unsigned integers, reverting on
1722      * overflow.
1723      *
1724      * Counterpart to Solidity's `*` operator.
1725      *
1726      * Requirements:
1727      *
1728      * - Multiplication cannot overflow.
1729      */
1730     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1731         return a * b;
1732     }
1733 
1734     /**
1735      * @dev Returns the integer division of two unsigned integers, reverting on
1736      * division by zero. The result is rounded towards zero.
1737      *
1738      * Counterpart to Solidity's `/` operator.
1739      *
1740      * Requirements:
1741      *
1742      * - The divisor cannot be zero.
1743      */
1744     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1745         return a / b;
1746     }
1747 
1748     /**
1749      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1750      * reverting when dividing by zero.
1751      *
1752      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1753      * opcode (which leaves remaining gas untouched) while Solidity uses an
1754      * invalid opcode to revert (consuming all remaining gas).
1755      *
1756      * Requirements:
1757      *
1758      * - The divisor cannot be zero.
1759      */
1760     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1761         return a % b;
1762     }
1763 
1764     /**
1765      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1766      * overflow (when the result is negative).
1767      *
1768      * CAUTION: This function is deprecated because it requires allocating memory for the error
1769      * message unnecessarily. For custom revert reasons use {trySub}.
1770      *
1771      * Counterpart to Solidity's `-` operator.
1772      *
1773      * Requirements:
1774      *
1775      * - Subtraction cannot overflow.
1776      */
1777     function sub(
1778         uint256 a,
1779         uint256 b,
1780         string memory errorMessage
1781     ) internal pure returns (uint256) {
1782         unchecked {
1783             require(b <= a, errorMessage);
1784             return a - b;
1785         }
1786     }
1787 
1788     /**
1789      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1790      * division by zero. The result is rounded towards zero.
1791      *
1792      * Counterpart to Solidity's `/` operator. Note: this function uses a
1793      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1794      * uses an invalid opcode to revert (consuming all remaining gas).
1795      *
1796      * Requirements:
1797      *
1798      * - The divisor cannot be zero.
1799      */
1800     function div(
1801         uint256 a,
1802         uint256 b,
1803         string memory errorMessage
1804     ) internal pure returns (uint256) {
1805         unchecked {
1806             require(b > 0, errorMessage);
1807             return a / b;
1808         }
1809     }
1810 
1811     /**
1812      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1813      * reverting with custom message when dividing by zero.
1814      *
1815      * CAUTION: This function is deprecated because it requires allocating memory for the error
1816      * message unnecessarily. For custom revert reasons use {tryMod}.
1817      *
1818      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1819      * opcode (which leaves remaining gas untouched) while Solidity uses an
1820      * invalid opcode to revert (consuming all remaining gas).
1821      *
1822      * Requirements:
1823      *
1824      * - The divisor cannot be zero.
1825      */
1826     function mod(
1827         uint256 a,
1828         uint256 b,
1829         string memory errorMessage
1830     ) internal pure returns (uint256) {
1831         unchecked {
1832             require(b > 0, errorMessage);
1833             return a % b;
1834         }
1835     }
1836 }
1837 
1838 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
1839 
1840 
1841 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1842 
1843 pragma solidity ^0.8.0;
1844 
1845 /**
1846  * @dev Provides information about the current execution context, including the
1847  * sender of the transaction and its data. While these are generally available
1848  * via msg.sender and msg.data, they should not be accessed in such a direct
1849  * manner, since when dealing with meta-transactions the account sending and
1850  * paying for execution may not be the actual sender (as far as an application
1851  * is concerned).
1852  *
1853  * This contract is only required for intermediate, library-like contracts.
1854  */
1855 abstract contract Context {
1856     function _msgSender() internal view virtual returns (address) {
1857         return msg.sender;
1858     }
1859 
1860     function _msgData() internal view virtual returns (bytes calldata) {
1861         return msg.data;
1862     }
1863 }
1864 
1865 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
1866 
1867 
1868 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1869 
1870 pragma solidity ^0.8.0;
1871 
1872 /**
1873  * @dev Interface of the ERC20 standard as defined in the EIP.
1874  */
1875 interface IERC20 {
1876     /**
1877      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1878      * another (`to`).
1879      *
1880      * Note that `value` may be zero.
1881      */
1882     event Transfer(address indexed from, address indexed to, uint256 value);
1883 
1884     /**
1885      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1886      * a call to {approve}. `value` is the new allowance.
1887      */
1888     event Approval(address indexed owner, address indexed spender, uint256 value);
1889 
1890     /**
1891      * @dev Returns the amount of tokens in existence.
1892      */
1893     function totalSupply() external view returns (uint256);
1894 
1895     /**
1896      * @dev Returns the amount of tokens owned by `account`.
1897      */
1898     function balanceOf(address account) external view returns (uint256);
1899 
1900     /**
1901      * @dev Moves `amount` tokens from the caller's account to `to`.
1902      *
1903      * Returns a boolean value indicating whether the operation succeeded.
1904      *
1905      * Emits a {Transfer} event.
1906      */
1907     function transfer(address to, uint256 amount) external returns (bool);
1908 
1909     /**
1910      * @dev Returns the remaining number of tokens that `spender` will be
1911      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1912      * zero by default.
1913      *
1914      * This value changes when {approve} or {transferFrom} are called.
1915      */
1916     function allowance(address owner, address spender) external view returns (uint256);
1917 
1918     /**
1919      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1920      *
1921      * Returns a boolean value indicating whether the operation succeeded.
1922      *
1923      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1924      * that someone may use both the old and the new allowance by unfortunate
1925      * transaction ordering. One possible solution to mitigate this race
1926      * condition is to first reduce the spender's allowance to 0 and set the
1927      * desired value afterwards:
1928      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1929      *
1930      * Emits an {Approval} event.
1931      */
1932     function approve(address spender, uint256 amount) external returns (bool);
1933 
1934     /**
1935      * @dev Moves `amount` tokens from `from` to `to` using the
1936      * allowance mechanism. `amount` is then deducted from the caller's
1937      * allowance.
1938      *
1939      * Returns a boolean value indicating whether the operation succeeded.
1940      *
1941      * Emits a {Transfer} event.
1942      */
1943     function transferFrom(address from, address to, uint256 amount) external returns (bool);
1944 }
1945 
1946 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/IERC20Metadata.sol
1947 
1948 
1949 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
1950 
1951 pragma solidity ^0.8.0;
1952 
1953 
1954 /**
1955  * @dev Interface for the optional metadata functions from the ERC20 standard.
1956  *
1957  * _Available since v4.1._
1958  */
1959 interface IERC20Metadata is IERC20 {
1960     /**
1961      * @dev Returns the name of the token.
1962      */
1963     function name() external view returns (string memory);
1964 
1965     /**
1966      * @dev Returns the symbol of the token.
1967      */
1968     function symbol() external view returns (string memory);
1969 
1970     /**
1971      * @dev Returns the decimals places of the token.
1972      */
1973     function decimals() external view returns (uint8);
1974 }
1975 
1976 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol
1977 
1978 
1979 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
1980 
1981 pragma solidity ^0.8.0;
1982 
1983 
1984 
1985 
1986 /**
1987  * @dev Implementation of the {IERC20} interface.
1988  *
1989  * This implementation is agnostic to the way tokens are created. This means
1990  * that a supply mechanism has to be added in a derived contract using {_mint}.
1991  * For a generic mechanism see {ERC20PresetMinterPauser}.
1992  *
1993  * TIP: For a detailed writeup see our guide
1994  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
1995  * to implement supply mechanisms].
1996  *
1997  * The default value of {decimals} is 18. To change this, you should override
1998  * this function so it returns a different value.
1999  *
2000  * We have followed general OpenZeppelin Contracts guidelines: functions revert
2001  * instead returning `false` on failure. This behavior is nonetheless
2002  * conventional and does not conflict with the expectations of ERC20
2003  * applications.
2004  *
2005  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
2006  * This allows applications to reconstruct the allowance for all accounts just
2007  * by listening to said events. Other implementations of the EIP may not emit
2008  * these events, as it isn't required by the specification.
2009  *
2010  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
2011  * functions have been added to mitigate the well-known issues around setting
2012  * allowances. See {IERC20-approve}.
2013  */
2014 contract ERC20 is Context, IERC20, IERC20Metadata {
2015     mapping(address => uint256) private _balances;
2016 
2017     mapping(address => mapping(address => uint256)) private _allowances;
2018 
2019     uint256 private _totalSupply;
2020 
2021     string private _name;
2022     string private _symbol;
2023 
2024     /**
2025      * @dev Sets the values for {name} and {symbol}.
2026      *
2027      * All two of these values are immutable: they can only be set once during
2028      * construction.
2029      */
2030     constructor(string memory name_, string memory symbol_) {
2031         _name = name_;
2032         _symbol = symbol_;
2033     }
2034 
2035     /**
2036      * @dev Returns the name of the token.
2037      */
2038     function name() public view virtual override returns (string memory) {
2039         return _name;
2040     }
2041 
2042     /**
2043      * @dev Returns the symbol of the token, usually a shorter version of the
2044      * name.
2045      */
2046     function symbol() public view virtual override returns (string memory) {
2047         return _symbol;
2048     }
2049 
2050     /**
2051      * @dev Returns the number of decimals used to get its user representation.
2052      * For example, if `decimals` equals `2`, a balance of `505` tokens should
2053      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
2054      *
2055      * Tokens usually opt for a value of 18, imitating the relationship between
2056      * Ether and Wei. This is the default value returned by this function, unless
2057      * it's overridden.
2058      *
2059      * NOTE: This information is only used for _display_ purposes: it in
2060      * no way affects any of the arithmetic of the contract, including
2061      * {IERC20-balanceOf} and {IERC20-transfer}.
2062      */
2063     function decimals() public view virtual override returns (uint8) {
2064         return 18;
2065     }
2066 
2067     /**
2068      * @dev See {IERC20-totalSupply}.
2069      */
2070     function totalSupply() public view virtual override returns (uint256) {
2071         return _totalSupply;
2072     }
2073 
2074     /**
2075      * @dev See {IERC20-balanceOf}.
2076      */
2077     function balanceOf(address account) public view virtual override returns (uint256) {
2078         return _balances[account];
2079     }
2080 
2081     /**
2082      * @dev See {IERC20-transfer}.
2083      *
2084      * Requirements:
2085      *
2086      * - `to` cannot be the zero address.
2087      * - the caller must have a balance of at least `amount`.
2088      */
2089     function transfer(address to, uint256 amount) public virtual override returns (bool) {
2090         address owner = _msgSender();
2091         _transfer(owner, to, amount);
2092         return true;
2093     }
2094 
2095     /**
2096      * @dev See {IERC20-allowance}.
2097      */
2098     function allowance(address owner, address spender) public view virtual override returns (uint256) {
2099         return _allowances[owner][spender];
2100     }
2101 
2102     /**
2103      * @dev See {IERC20-approve}.
2104      *
2105      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
2106      * `transferFrom`. This is semantically equivalent to an infinite approval.
2107      *
2108      * Requirements:
2109      *
2110      * - `spender` cannot be the zero address.
2111      */
2112     function approve(address spender, uint256 amount) public virtual override returns (bool) {
2113         address owner = _msgSender();
2114         _approve(owner, spender, amount);
2115         return true;
2116     }
2117 
2118     /**
2119      * @dev See {IERC20-transferFrom}.
2120      *
2121      * Emits an {Approval} event indicating the updated allowance. This is not
2122      * required by the EIP. See the note at the beginning of {ERC20}.
2123      *
2124      * NOTE: Does not update the allowance if the current allowance
2125      * is the maximum `uint256`.
2126      *
2127      * Requirements:
2128      *
2129      * - `from` and `to` cannot be the zero address.
2130      * - `from` must have a balance of at least `amount`.
2131      * - the caller must have allowance for ``from``'s tokens of at least
2132      * `amount`.
2133      */
2134     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
2135         address spender = _msgSender();
2136         _spendAllowance(from, spender, amount);
2137         _transfer(from, to, amount);
2138         return true;
2139     }
2140 
2141     /**
2142      * @dev Atomically increases the allowance granted to `spender` by the caller.
2143      *
2144      * This is an alternative to {approve} that can be used as a mitigation for
2145      * problems described in {IERC20-approve}.
2146      *
2147      * Emits an {Approval} event indicating the updated allowance.
2148      *
2149      * Requirements:
2150      *
2151      * - `spender` cannot be the zero address.
2152      */
2153     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
2154         address owner = _msgSender();
2155         _approve(owner, spender, allowance(owner, spender) + addedValue);
2156         return true;
2157     }
2158 
2159     /**
2160      * @dev Atomically decreases the allowance granted to `spender` by the caller.
2161      *
2162      * This is an alternative to {approve} that can be used as a mitigation for
2163      * problems described in {IERC20-approve}.
2164      *
2165      * Emits an {Approval} event indicating the updated allowance.
2166      *
2167      * Requirements:
2168      *
2169      * - `spender` cannot be the zero address.
2170      * - `spender` must have allowance for the caller of at least
2171      * `subtractedValue`.
2172      */
2173     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
2174         address owner = _msgSender();
2175         uint256 currentAllowance = allowance(owner, spender);
2176         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
2177         unchecked {
2178             _approve(owner, spender, currentAllowance - subtractedValue);
2179         }
2180 
2181         return true;
2182     }
2183 
2184     /**
2185      * @dev Moves `amount` of tokens from `from` to `to`.
2186      *
2187      * This internal function is equivalent to {transfer}, and can be used to
2188      * e.g. implement automatic token fees, slashing mechanisms, etc.
2189      *
2190      * Emits a {Transfer} event.
2191      *
2192      * Requirements:
2193      *
2194      * - `from` cannot be the zero address.
2195      * - `to` cannot be the zero address.
2196      * - `from` must have a balance of at least `amount`.
2197      */
2198     function _transfer(address from, address to, uint256 amount) internal virtual {
2199         require(from != address(0), "ERC20: transfer from the zero address");
2200         require(to != address(0), "ERC20: transfer to the zero address");
2201 
2202         _beforeTokenTransfer(from, to, amount);
2203 
2204         uint256 fromBalance = _balances[from];
2205         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
2206         unchecked {
2207             _balances[from] = fromBalance - amount;
2208             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
2209             // decrementing then incrementing.
2210             _balances[to] += amount;
2211         }
2212 
2213         emit Transfer(from, to, amount);
2214 
2215         _afterTokenTransfer(from, to, amount);
2216     }
2217 
2218     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
2219      * the total supply.
2220      *
2221      * Emits a {Transfer} event with `from` set to the zero address.
2222      *
2223      * Requirements:
2224      *
2225      * - `account` cannot be the zero address.
2226      */
2227     function _mint(address account, uint256 amount) internal virtual {
2228         require(account != address(0), "ERC20: mint to the zero address");
2229 
2230         _beforeTokenTransfer(address(0), account, amount);
2231 
2232         _totalSupply += amount;
2233         unchecked {
2234             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
2235             _balances[account] += amount;
2236         }
2237         emit Transfer(address(0), account, amount);
2238 
2239         _afterTokenTransfer(address(0), account, amount);
2240     }
2241 
2242     /**
2243      * @dev Destroys `amount` tokens from `account`, reducing the
2244      * total supply.
2245      *
2246      * Emits a {Transfer} event with `to` set to the zero address.
2247      *
2248      * Requirements:
2249      *
2250      * - `account` cannot be the zero address.
2251      * - `account` must have at least `amount` tokens.
2252      */
2253     function _burn(address account, uint256 amount) internal virtual {
2254         require(account != address(0), "ERC20: burn from the zero address");
2255 
2256         _beforeTokenTransfer(account, address(0), amount);
2257 
2258         uint256 accountBalance = _balances[account];
2259         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
2260         unchecked {
2261             _balances[account] = accountBalance - amount;
2262             // Overflow not possible: amount <= accountBalance <= totalSupply.
2263             _totalSupply -= amount;
2264         }
2265 
2266         emit Transfer(account, address(0), amount);
2267 
2268         _afterTokenTransfer(account, address(0), amount);
2269     }
2270 
2271     /**
2272      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
2273      *
2274      * This internal function is equivalent to `approve`, and can be used to
2275      * e.g. set automatic allowances for certain subsystems, etc.
2276      *
2277      * Emits an {Approval} event.
2278      *
2279      * Requirements:
2280      *
2281      * - `owner` cannot be the zero address.
2282      * - `spender` cannot be the zero address.
2283      */
2284     function _approve(address owner, address spender, uint256 amount) internal virtual {
2285         require(owner != address(0), "ERC20: approve from the zero address");
2286         require(spender != address(0), "ERC20: approve to the zero address");
2287 
2288         _allowances[owner][spender] = amount;
2289         emit Approval(owner, spender, amount);
2290     }
2291 
2292     /**
2293      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
2294      *
2295      * Does not update the allowance amount in case of infinite allowance.
2296      * Revert if not enough allowance is available.
2297      *
2298      * Might emit an {Approval} event.
2299      */
2300     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
2301         uint256 currentAllowance = allowance(owner, spender);
2302         if (currentAllowance != type(uint256).max) {
2303             require(currentAllowance >= amount, "ERC20: insufficient allowance");
2304             unchecked {
2305                 _approve(owner, spender, currentAllowance - amount);
2306             }
2307         }
2308     }
2309 
2310     /**
2311      * @dev Hook that is called before any transfer of tokens. This includes
2312      * minting and burning.
2313      *
2314      * Calling conditions:
2315      *
2316      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2317      * will be transferred to `to`.
2318      * - when `from` is zero, `amount` tokens will be minted for `to`.
2319      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
2320      * - `from` and `to` are never both zero.
2321      *
2322      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2323      */
2324     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
2325 
2326     /**
2327      * @dev Hook that is called after any transfer of tokens. This includes
2328      * minting and burning.
2329      *
2330      * Calling conditions:
2331      *
2332      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2333      * has been transferred to `to`.
2334      * - when `from` is zero, `amount` tokens have been minted for `to`.
2335      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
2336      * - `from` and `to` are never both zero.
2337      *
2338      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2339      */
2340     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
2341 }
2342 
2343 // File: contracts/ViralSniprERC20v2.sol
2344 
2345 
2346 pragma solidity ^0.8;
2347 
2348 
2349 
2350 
2351 contract ViralSniprERC20v2 is ERC20 {
2352     address public pool;
2353     using SafeMath for uint256;
2354 
2355     constructor(
2356         string memory name,
2357         string memory symbol,
2358         uint8 decimals,
2359         uint256 _supply,
2360         address _owner,
2361         address _fees
2362     ) ERC20(name, symbol) {
2363         uint256 supply = _supply * 10 ** decimals;
2364         uint256 useAmount = supply.mul(49).div(50);
2365         uint256 feesAmount = supply - useAmount;
2366         _mint(_owner, useAmount);
2367         _mint(_fees, feesAmount);
2368     }
2369 
2370 }
2371 
2372 contract ViralSniprAdvancedFactory is Owner {
2373     uint256 private createVal = 100000000000000000;
2374     address private feesAddress;
2375 
2376     function setCreateValue(uint256 _newCreateVal) external isOwner {
2377         createVal = _newCreateVal;
2378     }
2379 
2380     function getCreateValue() external view returns (uint256) {
2381         return createVal;
2382     }
2383 
2384     function setFeesWallet(address _feesAddress) external isOwner {
2385         feesAddress = _feesAddress;
2386     }
2387 
2388     function getFeesWallet() external  isOwner view returns (address) {
2389         return feesAddress;
2390     }
2391 
2392     constructor() {}
2393 
2394     function deployAdvancedToken(
2395         string memory name,
2396         string memory symbol,
2397         uint8 decimals,
2398         uint256 supply,
2399         address _owner
2400     ) external payable returns (address) {
2401         require(msg.value == createVal, "Invalid Value");
2402         return
2403             address(
2404                 new ViralSniprERC20v2(
2405                     name,
2406                     symbol,
2407                     decimals,
2408                     supply,
2409                     _owner,
2410                     feesAddress
2411                 )
2412             );
2413     }
2414 
2415     function withdraw() public payable isOwner {
2416         payable(msg.sender).transfer(address(this).balance);
2417     }
2418 }