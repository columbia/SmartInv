1 pragma solidity >=0.6.0 <0.8.0;
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
1535 /*
1536  * @dev Provides information about the current execution context, including the
1537  * sender of the transaction and its data. While these are generally available
1538  * via msg.sender and msg.data, they should not be accessed in such a direct
1539  * manner, since when dealing with GSN meta-transactions the account sending and
1540  * paying for execution may not be the actual sender (as far as an application
1541  * is concerned).
1542  *
1543  * This contract is only required for intermediate, library-like contracts.
1544  */
1545 abstract contract Context {
1546     function _msgSender() internal view virtual returns (address payable) {
1547         return msg.sender;
1548     }
1549 
1550     function _msgData() internal view virtual returns (bytes memory) {
1551         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1552         return msg.data;
1553     }
1554 }
1555 
1556 /**
1557  * @dev Interface of the ERC20 standard as defined in the EIP.
1558  */
1559 interface IERC20 {
1560     /**
1561      * @dev Returns the amount of tokens in existence.
1562      */
1563     function totalSupply() external view returns (uint256);
1564 
1565     /**
1566      * @dev Returns the amount of tokens owned by `account`.
1567      */
1568     function balanceOf(address account) external view returns (uint256);
1569 
1570     /**
1571      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1572      *
1573      * Returns a boolean value indicating whether the operation succeeded.
1574      *
1575      * Emits a {Transfer} event.
1576      */
1577     function transfer(address recipient, uint256 amount) external returns (bool);
1578 
1579     /**
1580      * @dev Returns the remaining number of tokens that `spender` will be
1581      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1582      * zero by default.
1583      *
1584      * This value changes when {approve} or {transferFrom} are called.
1585      */
1586     function allowance(address owner, address spender) external view returns (uint256);
1587 
1588     /**
1589      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1590      *
1591      * Returns a boolean value indicating whether the operation succeeded.
1592      *
1593      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1594      * that someone may use both the old and the new allowance by unfortunate
1595      * transaction ordering. One possible solution to mitigate this race
1596      * condition is to first reduce the spender's allowance to 0 and set the
1597      * desired value afterwards:
1598      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1599      *
1600      * Emits an {Approval} event.
1601      */
1602     function approve(address spender, uint256 amount) external returns (bool);
1603 
1604     /**
1605      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1606      * allowance mechanism. `amount` is then deducted from the caller's
1607      * allowance.
1608      *
1609      * Returns a boolean value indicating whether the operation succeeded.
1610      *
1611      * Emits a {Transfer} event.
1612      */
1613     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1614 
1615     /**
1616      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1617      * another (`to`).
1618      *
1619      * Note that `value` may be zero.
1620      */
1621     event Transfer(address indexed from, address indexed to, uint256 value);
1622 
1623     /**
1624      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1625      * a call to {approve}. `value` is the new allowance.
1626      */
1627     event Approval(address indexed owner, address indexed spender, uint256 value);
1628 }
1629 
1630 /**
1631  * @dev Wrappers over Solidity's arithmetic operations with added overflow
1632  * checks.
1633  *
1634  * Arithmetic operations in Solidity wrap on overflow. This can easily result
1635  * in bugs, because programmers usually assume that an overflow raises an
1636  * error, which is the standard behavior in high level programming languages.
1637  * `SafeMath` restores this intuition by reverting the transaction when an
1638  * operation overflows.
1639  *
1640  * Using this library instead of the unchecked operations eliminates an entire
1641  * class of bugs, so it's recommended to use it always.
1642  */
1643 library SafeMath {
1644     /**
1645      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1646      *
1647      * _Available since v3.4._
1648      */
1649     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1650         uint256 c = a + b;
1651         if (c < a) return (false, 0);
1652         return (true, c);
1653     }
1654 
1655     /**
1656      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1657      *
1658      * _Available since v3.4._
1659      */
1660     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1661         if (b > a) return (false, 0);
1662         return (true, a - b);
1663     }
1664 
1665     /**
1666      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1667      *
1668      * _Available since v3.4._
1669      */
1670     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1671         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1672         // benefit is lost if 'b' is also tested.
1673         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1674         if (a == 0) return (true, 0);
1675         uint256 c = a * b;
1676         if (c / a != b) return (false, 0);
1677         return (true, c);
1678     }
1679 
1680     /**
1681      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1682      *
1683      * _Available since v3.4._
1684      */
1685     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1686         if (b == 0) return (false, 0);
1687         return (true, a / b);
1688     }
1689 
1690     /**
1691      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1692      *
1693      * _Available since v3.4._
1694      */
1695     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1696         if (b == 0) return (false, 0);
1697         return (true, a % b);
1698     }
1699 
1700     /**
1701      * @dev Returns the addition of two unsigned integers, reverting on
1702      * overflow.
1703      *
1704      * Counterpart to Solidity's `+` operator.
1705      *
1706      * Requirements:
1707      *
1708      * - Addition cannot overflow.
1709      */
1710     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1711         uint256 c = a + b;
1712         require(c >= a, "SafeMath: addition overflow");
1713         return c;
1714     }
1715 
1716     /**
1717      * @dev Returns the subtraction of two unsigned integers, reverting on
1718      * overflow (when the result is negative).
1719      *
1720      * Counterpart to Solidity's `-` operator.
1721      *
1722      * Requirements:
1723      *
1724      * - Subtraction cannot overflow.
1725      */
1726     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1727         require(b <= a, "SafeMath: subtraction overflow");
1728         return a - b;
1729     }
1730 
1731     /**
1732      * @dev Returns the multiplication of two unsigned integers, reverting on
1733      * overflow.
1734      *
1735      * Counterpart to Solidity's `*` operator.
1736      *
1737      * Requirements:
1738      *
1739      * - Multiplication cannot overflow.
1740      */
1741     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1742         if (a == 0) return 0;
1743         uint256 c = a * b;
1744         require(c / a == b, "SafeMath: multiplication overflow");
1745         return c;
1746     }
1747 
1748     /**
1749      * @dev Returns the integer division of two unsigned integers, reverting on
1750      * division by zero. The result is rounded towards zero.
1751      *
1752      * Counterpart to Solidity's `/` operator. Note: this function uses a
1753      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1754      * uses an invalid opcode to revert (consuming all remaining gas).
1755      *
1756      * Requirements:
1757      *
1758      * - The divisor cannot be zero.
1759      */
1760     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1761         require(b > 0, "SafeMath: division by zero");
1762         return a / b;
1763     }
1764 
1765     /**
1766      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1767      * reverting when dividing by zero.
1768      *
1769      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1770      * opcode (which leaves remaining gas untouched) while Solidity uses an
1771      * invalid opcode to revert (consuming all remaining gas).
1772      *
1773      * Requirements:
1774      *
1775      * - The divisor cannot be zero.
1776      */
1777     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1778         require(b > 0, "SafeMath: modulo by zero");
1779         return a % b;
1780     }
1781 
1782     /**
1783      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1784      * overflow (when the result is negative).
1785      *
1786      * CAUTION: This function is deprecated because it requires allocating memory for the error
1787      * message unnecessarily. For custom revert reasons use {trySub}.
1788      *
1789      * Counterpart to Solidity's `-` operator.
1790      *
1791      * Requirements:
1792      *
1793      * - Subtraction cannot overflow.
1794      */
1795     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1796         require(b <= a, errorMessage);
1797         return a - b;
1798     }
1799 
1800     /**
1801      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1802      * division by zero. The result is rounded towards zero.
1803      *
1804      * CAUTION: This function is deprecated because it requires allocating memory for the error
1805      * message unnecessarily. For custom revert reasons use {tryDiv}.
1806      *
1807      * Counterpart to Solidity's `/` operator. Note: this function uses a
1808      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1809      * uses an invalid opcode to revert (consuming all remaining gas).
1810      *
1811      * Requirements:
1812      *
1813      * - The divisor cannot be zero.
1814      */
1815     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1816         require(b > 0, errorMessage);
1817         return a / b;
1818     }
1819 
1820     /**
1821      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1822      * reverting with custom message when dividing by zero.
1823      *
1824      * CAUTION: This function is deprecated because it requires allocating memory for the error
1825      * message unnecessarily. For custom revert reasons use {tryMod}.
1826      *
1827      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1828      * opcode (which leaves remaining gas untouched) while Solidity uses an
1829      * invalid opcode to revert (consuming all remaining gas).
1830      *
1831      * Requirements:
1832      *
1833      * - The divisor cannot be zero.
1834      */
1835     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1836         require(b > 0, errorMessage);
1837         return a % b;
1838     }
1839 }
1840 
1841 /**
1842  * @dev Implementation of the {IERC20} interface.
1843  *
1844  * This implementation is agnostic to the way tokens are created. This means
1845  * that a supply mechanism has to be added in a derived contract using {_mint}.
1846  * For a generic mechanism see {ERC20PresetMinterPauser}.
1847  *
1848  * TIP: For a detailed writeup see our guide
1849  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1850  * to implement supply mechanisms].
1851  *
1852  * We have followed general OpenZeppelin guidelines: functions revert instead
1853  * of returning `false` on failure. This behavior is nonetheless conventional
1854  * and does not conflict with the expectations of ERC20 applications.
1855  *
1856  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1857  * This allows applications to reconstruct the allowance for all accounts just
1858  * by listening to said events. Other implementations of the EIP may not emit
1859  * these events, as it isn't required by the specification.
1860  *
1861  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1862  * functions have been added to mitigate the well-known issues around setting
1863  * allowances. See {IERC20-approve}.
1864  */
1865 contract ERC20 is Context, IERC20 {
1866     using SafeMath for uint256;
1867 
1868     mapping (address => uint256) private _balances;
1869 
1870     mapping (address => mapping (address => uint256)) private _allowances;
1871 
1872     uint256 private _totalSupply;
1873 
1874     string private _name;
1875     string private _symbol;
1876     uint8 private _decimals;
1877 
1878     /**
1879      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1880      * a default value of 18.
1881      *
1882      * To select a different value for {decimals}, use {_setupDecimals}.
1883      *
1884      * All three of these values are immutable: they can only be set once during
1885      * construction.
1886      */
1887     constructor (string memory name_, string memory symbol_) public {
1888         _name = name_;
1889         _symbol = symbol_;
1890         _decimals = 18;
1891     }
1892 
1893     /**
1894      * @dev Returns the name of the token.
1895      */
1896     function name() public view virtual returns (string memory) {
1897         return _name;
1898     }
1899 
1900     /**
1901      * @dev Returns the symbol of the token, usually a shorter version of the
1902      * name.
1903      */
1904     function symbol() public view virtual returns (string memory) {
1905         return _symbol;
1906     }
1907 
1908     /**
1909      * @dev Returns the number of decimals used to get its user representation.
1910      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1911      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1912      *
1913      * Tokens usually opt for a value of 18, imitating the relationship between
1914      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1915      * called.
1916      *
1917      * NOTE: This information is only used for _display_ purposes: it in
1918      * no way affects any of the arithmetic of the contract, including
1919      * {IERC20-balanceOf} and {IERC20-transfer}.
1920      */
1921     function decimals() public view virtual returns (uint8) {
1922         return _decimals;
1923     }
1924 
1925     /**
1926      * @dev See {IERC20-totalSupply}.
1927      */
1928     function totalSupply() public view virtual override returns (uint256) {
1929         return _totalSupply;
1930     }
1931 
1932     /**
1933      * @dev See {IERC20-balanceOf}.
1934      */
1935     function balanceOf(address account) public view virtual override returns (uint256) {
1936         return _balances[account];
1937     }
1938 
1939     /**
1940      * @dev See {IERC20-transfer}.
1941      *
1942      * Requirements:
1943      *
1944      * - `recipient` cannot be the zero address.
1945      * - the caller must have a balance of at least `amount`.
1946      */
1947     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1948         _transfer(_msgSender(), recipient, amount);
1949         return true;
1950     }
1951 
1952     /**
1953      * @dev See {IERC20-allowance}.
1954      */
1955     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1956         return _allowances[owner][spender];
1957     }
1958 
1959     /**
1960      * @dev See {IERC20-approve}.
1961      *
1962      * Requirements:
1963      *
1964      * - `spender` cannot be the zero address.
1965      */
1966     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1967         _approve(_msgSender(), spender, amount);
1968         return true;
1969     }
1970 
1971     /**
1972      * @dev See {IERC20-transferFrom}.
1973      *
1974      * Emits an {Approval} event indicating the updated allowance. This is not
1975      * required by the EIP. See the note at the beginning of {ERC20}.
1976      *
1977      * Requirements:
1978      *
1979      * - `sender` and `recipient` cannot be the zero address.
1980      * - `sender` must have a balance of at least `amount`.
1981      * - the caller must have allowance for ``sender``'s tokens of at least
1982      * `amount`.
1983      */
1984     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1985         _transfer(sender, recipient, amount);
1986         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1987         return true;
1988     }
1989 
1990     /**
1991      * @dev Atomically increases the allowance granted to `spender` by the caller.
1992      *
1993      * This is an alternative to {approve} that can be used as a mitigation for
1994      * problems described in {IERC20-approve}.
1995      *
1996      * Emits an {Approval} event indicating the updated allowance.
1997      *
1998      * Requirements:
1999      *
2000      * - `spender` cannot be the zero address.
2001      */
2002     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
2003         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
2004         return true;
2005     }
2006 
2007     /**
2008      * @dev Atomically decreases the allowance granted to `spender` by the caller.
2009      *
2010      * This is an alternative to {approve} that can be used as a mitigation for
2011      * problems described in {IERC20-approve}.
2012      *
2013      * Emits an {Approval} event indicating the updated allowance.
2014      *
2015      * Requirements:
2016      *
2017      * - `spender` cannot be the zero address.
2018      * - `spender` must have allowance for the caller of at least
2019      * `subtractedValue`.
2020      */
2021     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
2022         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
2023         return true;
2024     }
2025 
2026     /**
2027      * @dev Moves tokens `amount` from `sender` to `recipient`.
2028      *
2029      * This is internal function is equivalent to {transfer}, and can be used to
2030      * e.g. implement automatic token fees, slashing mechanisms, etc.
2031      *
2032      * Emits a {Transfer} event.
2033      *
2034      * Requirements:
2035      *
2036      * - `sender` cannot be the zero address.
2037      * - `recipient` cannot be the zero address.
2038      * - `sender` must have a balance of at least `amount`.
2039      */
2040     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
2041         require(sender != address(0), "ERC20: transfer from the zero address");
2042         require(recipient != address(0), "ERC20: transfer to the zero address");
2043 
2044         _beforeTokenTransfer(sender, recipient, amount);
2045 
2046         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
2047         _balances[recipient] = _balances[recipient].add(amount);
2048         emit Transfer(sender, recipient, amount);
2049     }
2050 
2051     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
2052      * the total supply.
2053      *
2054      * Emits a {Transfer} event with `from` set to the zero address.
2055      *
2056      * Requirements:
2057      *
2058      * - `to` cannot be the zero address.
2059      */
2060     function _mint(address account, uint256 amount) internal virtual {
2061         require(account != address(0), "ERC20: mint to the zero address");
2062 
2063         _beforeTokenTransfer(address(0), account, amount);
2064 
2065         _totalSupply = _totalSupply.add(amount);
2066         _balances[account] = _balances[account].add(amount);
2067         emit Transfer(address(0), account, amount);
2068     }
2069 
2070     /**
2071      * @dev Destroys `amount` tokens from `account`, reducing the
2072      * total supply.
2073      *
2074      * Emits a {Transfer} event with `to` set to the zero address.
2075      *
2076      * Requirements:
2077      *
2078      * - `account` cannot be the zero address.
2079      * - `account` must have at least `amount` tokens.
2080      */
2081     function _burn(address account, uint256 amount) internal virtual {
2082         require(account != address(0), "ERC20: burn from the zero address");
2083 
2084         _beforeTokenTransfer(account, address(0), amount);
2085 
2086         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
2087         _totalSupply = _totalSupply.sub(amount);
2088         emit Transfer(account, address(0), amount);
2089     }
2090 
2091     /**
2092      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
2093      *
2094      * This internal function is equivalent to `approve`, and can be used to
2095      * e.g. set automatic allowances for certain subsystems, etc.
2096      *
2097      * Emits an {Approval} event.
2098      *
2099      * Requirements:
2100      *
2101      * - `owner` cannot be the zero address.
2102      * - `spender` cannot be the zero address.
2103      */
2104     function _approve(address owner, address spender, uint256 amount) internal virtual {
2105         require(owner != address(0), "ERC20: approve from the zero address");
2106         require(spender != address(0), "ERC20: approve to the zero address");
2107 
2108         _allowances[owner][spender] = amount;
2109         emit Approval(owner, spender, amount);
2110     }
2111 
2112     /**
2113      * @dev Sets {decimals} to a value other than the default one of 18.
2114      *
2115      * WARNING: This function should only be called from the constructor. Most
2116      * applications that interact with token contracts will not expect
2117      * {decimals} to ever change, and may work incorrectly if it does.
2118      */
2119     function _setupDecimals(uint8 decimals_) internal virtual {
2120         _decimals = decimals_;
2121     }
2122 
2123     /**
2124      * @dev Hook that is called before any transfer of tokens. This includes
2125      * minting and burning.
2126      *
2127      * Calling conditions:
2128      *
2129      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2130      * will be to transferred to `to`.
2131      * - when `from` is zero, `amount` tokens will be minted for `to`.
2132      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
2133      * - `from` and `to` are never both zero.
2134      *
2135      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2136      */
2137     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
2138 }
2139 
2140 /**
2141  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
2142  */
2143 abstract contract ERC20Capped is ERC20 {
2144     using SafeMath for uint256;
2145 
2146     uint256 private _cap;
2147 
2148     /**
2149      * @dev Sets the value of the `cap`. This value is immutable, it can only be
2150      * set once during construction.
2151      */
2152     constructor (uint256 cap_) internal {
2153         require(cap_ > 0, "ERC20Capped: cap is 0");
2154         _cap = cap_;
2155     }
2156 
2157     /**
2158      * @dev Returns the cap on the token's total supply.
2159      */
2160     function cap() public view virtual returns (uint256) {
2161         return _cap;
2162     }
2163 
2164     /**
2165      * @dev See {ERC20-_beforeTokenTransfer}.
2166      *
2167      * Requirements:
2168      *
2169      * - minted tokens must not cause the total supply to go over the cap.
2170      */
2171     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
2172         super._beforeTokenTransfer(from, to, amount);
2173 
2174         if (from == address(0)) { // When minting tokens
2175             require(totalSupply().add(amount) <= cap(), "ERC20Capped: cap exceeded");
2176         }
2177     }
2178 }
2179 
2180 /**
2181  * @dev Contract module which provides a basic access control mechanism, where
2182  * there is an account (an owner) that can be granted exclusive access to
2183  * specific functions.
2184  *
2185  * By default, the owner account will be the one that deploys the contract. This
2186  * can later be changed with {transferOwnership}.
2187  *
2188  * This module is used through inheritance. It will make available the modifier
2189  * `onlyOwner`, which can be applied to your functions to restrict their use to
2190  * the owner.
2191  */
2192 abstract contract Ownable is Context {
2193     address private _owner;
2194 
2195     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2196 
2197     /**
2198      * @dev Initializes the contract setting the deployer as the initial owner.
2199      */
2200     constructor () internal {
2201         address msgSender = _msgSender();
2202         _owner = msgSender;
2203         emit OwnershipTransferred(address(0), msgSender);
2204     }
2205 
2206     /**
2207      * @dev Returns the address of the current owner.
2208      */
2209     function owner() public view virtual returns (address) {
2210         return _owner;
2211     }
2212 
2213     /**
2214      * @dev Throws if called by any account other than the owner.
2215      */
2216     modifier onlyOwner() {
2217         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2218         _;
2219     }
2220 
2221     /**
2222      * @dev Leaves the contract without owner. It will not be possible to call
2223      * `onlyOwner` functions anymore. Can only be called by the current owner.
2224      *
2225      * NOTE: Renouncing ownership will leave the contract without an owner,
2226      * thereby removing any functionality that is only available to the owner.
2227      */
2228     function renounceOwnership() public virtual onlyOwner {
2229         emit OwnershipTransferred(_owner, address(0));
2230         _owner = address(0);
2231     }
2232 
2233     /**
2234      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2235      * Can only be called by the current owner.
2236      */
2237     function transferOwnership(address newOwner) public virtual onlyOwner {
2238         require(newOwner != address(0), "Ownable: new owner is the zero address");
2239         emit OwnershipTransferred(_owner, newOwner);
2240         _owner = newOwner;
2241     }
2242 }
2243 
2244 //SPDX-License-Identifier: MIT
2245 contract ARGO is ERC20Capped, Ownable {
2246     using SafeMath for uint256;
2247 
2248     constructor(
2249         address reserve,
2250         uint256 amount,
2251         uint256 initialSupply
2252     ) ERC20("ArGo Token", "ARGO") ERC20Capped(initialSupply) {
2253         _mint(reserve, amount);
2254     }
2255 
2256     /**
2257      * @dev Destroys `amount` tokens from the caller.
2258      *
2259      * See {ERC20-_burn}.
2260      */
2261     function burn(uint256 amount) public {
2262         _burn(_msgSender(), amount);
2263     }
2264 
2265     /**
2266      * @dev Mints `amount` tokens and transfers to the recipient address.
2267      *
2268      * See {ERC20-_mint}.
2269      */
2270     function mint(address recipient, uint256 amount) public onlyOwner {
2271         _mint(recipient, amount);
2272     }
2273 
2274     /**
2275      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
2276      * allowance.
2277      *
2278      * See {ERC20-_burn} and {ERC20-allowance}.
2279      *
2280      * Requirements:
2281      *
2282      * - the caller must have allowance for ``accounts``'s tokens of at least
2283      * `amount`.
2284      */
2285     function burnFrom(address account, uint256 amount) public {
2286         uint256 decreasedAllowance =
2287             allowance(account, _msgSender()).sub(
2288                 amount,
2289                 "ERC20: burn amount exceeds allowance"
2290             );
2291 
2292         _approve(account, _msgSender(), decreasedAllowance);
2293         _burn(account, amount);
2294     }
2295 }