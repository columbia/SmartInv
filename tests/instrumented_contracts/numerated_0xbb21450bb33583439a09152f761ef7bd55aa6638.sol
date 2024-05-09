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
22 	function logInt(int256 p0) internal view {
23 		_sendLogPayload(abi.encodeWithSignature("log(int256)", p0));
24 	}
25 
26 	function logUint(uint256 p0) internal view {
27 		_sendLogPayload(abi.encodeWithSignature("log(uint256)", p0));
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
174 	function log(uint256 p0) internal view {
175 		_sendLogPayload(abi.encodeWithSignature("log(uint256)", p0));
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
190 	function log(uint256 p0, uint256 p1) internal view {
191 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256)", p0, p1));
192 	}
193 
194 	function log(uint256 p0, string memory p1) internal view {
195 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string)", p0, p1));
196 	}
197 
198 	function log(uint256 p0, bool p1) internal view {
199 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool)", p0, p1));
200 	}
201 
202 	function log(uint256 p0, address p1) internal view {
203 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address)", p0, p1));
204 	}
205 
206 	function log(string memory p0, uint256 p1) internal view {
207 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256)", p0, p1));
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
222 	function log(bool p0, uint256 p1) internal view {
223 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256)", p0, p1));
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
238 	function log(address p0, uint256 p1) internal view {
239 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256)", p0, p1));
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
254 	function log(uint256 p0, uint256 p1, uint256 p2) internal view {
255 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256)", p0, p1, p2));
256 	}
257 
258 	function log(uint256 p0, uint256 p1, string memory p2) internal view {
259 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string)", p0, p1, p2));
260 	}
261 
262 	function log(uint256 p0, uint256 p1, bool p2) internal view {
263 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool)", p0, p1, p2));
264 	}
265 
266 	function log(uint256 p0, uint256 p1, address p2) internal view {
267 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address)", p0, p1, p2));
268 	}
269 
270 	function log(uint256 p0, string memory p1, uint256 p2) internal view {
271 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256)", p0, p1, p2));
272 	}
273 
274 	function log(uint256 p0, string memory p1, string memory p2) internal view {
275 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string)", p0, p1, p2));
276 	}
277 
278 	function log(uint256 p0, string memory p1, bool p2) internal view {
279 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool)", p0, p1, p2));
280 	}
281 
282 	function log(uint256 p0, string memory p1, address p2) internal view {
283 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address)", p0, p1, p2));
284 	}
285 
286 	function log(uint256 p0, bool p1, uint256 p2) internal view {
287 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256)", p0, p1, p2));
288 	}
289 
290 	function log(uint256 p0, bool p1, string memory p2) internal view {
291 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string)", p0, p1, p2));
292 	}
293 
294 	function log(uint256 p0, bool p1, bool p2) internal view {
295 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool)", p0, p1, p2));
296 	}
297 
298 	function log(uint256 p0, bool p1, address p2) internal view {
299 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address)", p0, p1, p2));
300 	}
301 
302 	function log(uint256 p0, address p1, uint256 p2) internal view {
303 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256)", p0, p1, p2));
304 	}
305 
306 	function log(uint256 p0, address p1, string memory p2) internal view {
307 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string)", p0, p1, p2));
308 	}
309 
310 	function log(uint256 p0, address p1, bool p2) internal view {
311 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool)", p0, p1, p2));
312 	}
313 
314 	function log(uint256 p0, address p1, address p2) internal view {
315 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address)", p0, p1, p2));
316 	}
317 
318 	function log(string memory p0, uint256 p1, uint256 p2) internal view {
319 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256)", p0, p1, p2));
320 	}
321 
322 	function log(string memory p0, uint256 p1, string memory p2) internal view {
323 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string)", p0, p1, p2));
324 	}
325 
326 	function log(string memory p0, uint256 p1, bool p2) internal view {
327 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool)", p0, p1, p2));
328 	}
329 
330 	function log(string memory p0, uint256 p1, address p2) internal view {
331 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address)", p0, p1, p2));
332 	}
333 
334 	function log(string memory p0, string memory p1, uint256 p2) internal view {
335 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256)", p0, p1, p2));
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
350 	function log(string memory p0, bool p1, uint256 p2) internal view {
351 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256)", p0, p1, p2));
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
366 	function log(string memory p0, address p1, uint256 p2) internal view {
367 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256)", p0, p1, p2));
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
382 	function log(bool p0, uint256 p1, uint256 p2) internal view {
383 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256)", p0, p1, p2));
384 	}
385 
386 	function log(bool p0, uint256 p1, string memory p2) internal view {
387 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string)", p0, p1, p2));
388 	}
389 
390 	function log(bool p0, uint256 p1, bool p2) internal view {
391 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool)", p0, p1, p2));
392 	}
393 
394 	function log(bool p0, uint256 p1, address p2) internal view {
395 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address)", p0, p1, p2));
396 	}
397 
398 	function log(bool p0, string memory p1, uint256 p2) internal view {
399 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256)", p0, p1, p2));
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
414 	function log(bool p0, bool p1, uint256 p2) internal view {
415 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256)", p0, p1, p2));
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
430 	function log(bool p0, address p1, uint256 p2) internal view {
431 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256)", p0, p1, p2));
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
446 	function log(address p0, uint256 p1, uint256 p2) internal view {
447 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256)", p0, p1, p2));
448 	}
449 
450 	function log(address p0, uint256 p1, string memory p2) internal view {
451 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string)", p0, p1, p2));
452 	}
453 
454 	function log(address p0, uint256 p1, bool p2) internal view {
455 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool)", p0, p1, p2));
456 	}
457 
458 	function log(address p0, uint256 p1, address p2) internal view {
459 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address)", p0, p1, p2));
460 	}
461 
462 	function log(address p0, string memory p1, uint256 p2) internal view {
463 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256)", p0, p1, p2));
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
478 	function log(address p0, bool p1, uint256 p2) internal view {
479 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256)", p0, p1, p2));
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
494 	function log(address p0, address p1, uint256 p2) internal view {
495 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256)", p0, p1, p2));
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
510 	function log(uint256 p0, uint256 p1, uint256 p2, uint256 p3) internal view {
511 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,uint256)", p0, p1, p2, p3));
512 	}
513 
514 	function log(uint256 p0, uint256 p1, uint256 p2, string memory p3) internal view {
515 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,string)", p0, p1, p2, p3));
516 	}
517 
518 	function log(uint256 p0, uint256 p1, uint256 p2, bool p3) internal view {
519 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,bool)", p0, p1, p2, p3));
520 	}
521 
522 	function log(uint256 p0, uint256 p1, uint256 p2, address p3) internal view {
523 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,address)", p0, p1, p2, p3));
524 	}
525 
526 	function log(uint256 p0, uint256 p1, string memory p2, uint256 p3) internal view {
527 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,uint256)", p0, p1, p2, p3));
528 	}
529 
530 	function log(uint256 p0, uint256 p1, string memory p2, string memory p3) internal view {
531 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,string)", p0, p1, p2, p3));
532 	}
533 
534 	function log(uint256 p0, uint256 p1, string memory p2, bool p3) internal view {
535 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,bool)", p0, p1, p2, p3));
536 	}
537 
538 	function log(uint256 p0, uint256 p1, string memory p2, address p3) internal view {
539 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,address)", p0, p1, p2, p3));
540 	}
541 
542 	function log(uint256 p0, uint256 p1, bool p2, uint256 p3) internal view {
543 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,uint256)", p0, p1, p2, p3));
544 	}
545 
546 	function log(uint256 p0, uint256 p1, bool p2, string memory p3) internal view {
547 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,string)", p0, p1, p2, p3));
548 	}
549 
550 	function log(uint256 p0, uint256 p1, bool p2, bool p3) internal view {
551 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,bool)", p0, p1, p2, p3));
552 	}
553 
554 	function log(uint256 p0, uint256 p1, bool p2, address p3) internal view {
555 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,address)", p0, p1, p2, p3));
556 	}
557 
558 	function log(uint256 p0, uint256 p1, address p2, uint256 p3) internal view {
559 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,uint256)", p0, p1, p2, p3));
560 	}
561 
562 	function log(uint256 p0, uint256 p1, address p2, string memory p3) internal view {
563 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,string)", p0, p1, p2, p3));
564 	}
565 
566 	function log(uint256 p0, uint256 p1, address p2, bool p3) internal view {
567 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,bool)", p0, p1, p2, p3));
568 	}
569 
570 	function log(uint256 p0, uint256 p1, address p2, address p3) internal view {
571 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,address)", p0, p1, p2, p3));
572 	}
573 
574 	function log(uint256 p0, string memory p1, uint256 p2, uint256 p3) internal view {
575 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,uint256)", p0, p1, p2, p3));
576 	}
577 
578 	function log(uint256 p0, string memory p1, uint256 p2, string memory p3) internal view {
579 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,string)", p0, p1, p2, p3));
580 	}
581 
582 	function log(uint256 p0, string memory p1, uint256 p2, bool p3) internal view {
583 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,bool)", p0, p1, p2, p3));
584 	}
585 
586 	function log(uint256 p0, string memory p1, uint256 p2, address p3) internal view {
587 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,address)", p0, p1, p2, p3));
588 	}
589 
590 	function log(uint256 p0, string memory p1, string memory p2, uint256 p3) internal view {
591 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,uint256)", p0, p1, p2, p3));
592 	}
593 
594 	function log(uint256 p0, string memory p1, string memory p2, string memory p3) internal view {
595 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,string)", p0, p1, p2, p3));
596 	}
597 
598 	function log(uint256 p0, string memory p1, string memory p2, bool p3) internal view {
599 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,bool)", p0, p1, p2, p3));
600 	}
601 
602 	function log(uint256 p0, string memory p1, string memory p2, address p3) internal view {
603 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,address)", p0, p1, p2, p3));
604 	}
605 
606 	function log(uint256 p0, string memory p1, bool p2, uint256 p3) internal view {
607 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,uint256)", p0, p1, p2, p3));
608 	}
609 
610 	function log(uint256 p0, string memory p1, bool p2, string memory p3) internal view {
611 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,string)", p0, p1, p2, p3));
612 	}
613 
614 	function log(uint256 p0, string memory p1, bool p2, bool p3) internal view {
615 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,bool)", p0, p1, p2, p3));
616 	}
617 
618 	function log(uint256 p0, string memory p1, bool p2, address p3) internal view {
619 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,address)", p0, p1, p2, p3));
620 	}
621 
622 	function log(uint256 p0, string memory p1, address p2, uint256 p3) internal view {
623 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,uint256)", p0, p1, p2, p3));
624 	}
625 
626 	function log(uint256 p0, string memory p1, address p2, string memory p3) internal view {
627 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,string)", p0, p1, p2, p3));
628 	}
629 
630 	function log(uint256 p0, string memory p1, address p2, bool p3) internal view {
631 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,bool)", p0, p1, p2, p3));
632 	}
633 
634 	function log(uint256 p0, string memory p1, address p2, address p3) internal view {
635 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,address)", p0, p1, p2, p3));
636 	}
637 
638 	function log(uint256 p0, bool p1, uint256 p2, uint256 p3) internal view {
639 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,uint256)", p0, p1, p2, p3));
640 	}
641 
642 	function log(uint256 p0, bool p1, uint256 p2, string memory p3) internal view {
643 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,string)", p0, p1, p2, p3));
644 	}
645 
646 	function log(uint256 p0, bool p1, uint256 p2, bool p3) internal view {
647 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,bool)", p0, p1, p2, p3));
648 	}
649 
650 	function log(uint256 p0, bool p1, uint256 p2, address p3) internal view {
651 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,address)", p0, p1, p2, p3));
652 	}
653 
654 	function log(uint256 p0, bool p1, string memory p2, uint256 p3) internal view {
655 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,uint256)", p0, p1, p2, p3));
656 	}
657 
658 	function log(uint256 p0, bool p1, string memory p2, string memory p3) internal view {
659 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,string)", p0, p1, p2, p3));
660 	}
661 
662 	function log(uint256 p0, bool p1, string memory p2, bool p3) internal view {
663 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,bool)", p0, p1, p2, p3));
664 	}
665 
666 	function log(uint256 p0, bool p1, string memory p2, address p3) internal view {
667 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,address)", p0, p1, p2, p3));
668 	}
669 
670 	function log(uint256 p0, bool p1, bool p2, uint256 p3) internal view {
671 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,uint256)", p0, p1, p2, p3));
672 	}
673 
674 	function log(uint256 p0, bool p1, bool p2, string memory p3) internal view {
675 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,string)", p0, p1, p2, p3));
676 	}
677 
678 	function log(uint256 p0, bool p1, bool p2, bool p3) internal view {
679 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,bool)", p0, p1, p2, p3));
680 	}
681 
682 	function log(uint256 p0, bool p1, bool p2, address p3) internal view {
683 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,address)", p0, p1, p2, p3));
684 	}
685 
686 	function log(uint256 p0, bool p1, address p2, uint256 p3) internal view {
687 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,uint256)", p0, p1, p2, p3));
688 	}
689 
690 	function log(uint256 p0, bool p1, address p2, string memory p3) internal view {
691 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,string)", p0, p1, p2, p3));
692 	}
693 
694 	function log(uint256 p0, bool p1, address p2, bool p3) internal view {
695 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,bool)", p0, p1, p2, p3));
696 	}
697 
698 	function log(uint256 p0, bool p1, address p2, address p3) internal view {
699 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,address)", p0, p1, p2, p3));
700 	}
701 
702 	function log(uint256 p0, address p1, uint256 p2, uint256 p3) internal view {
703 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,uint256)", p0, p1, p2, p3));
704 	}
705 
706 	function log(uint256 p0, address p1, uint256 p2, string memory p3) internal view {
707 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,string)", p0, p1, p2, p3));
708 	}
709 
710 	function log(uint256 p0, address p1, uint256 p2, bool p3) internal view {
711 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,bool)", p0, p1, p2, p3));
712 	}
713 
714 	function log(uint256 p0, address p1, uint256 p2, address p3) internal view {
715 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,address)", p0, p1, p2, p3));
716 	}
717 
718 	function log(uint256 p0, address p1, string memory p2, uint256 p3) internal view {
719 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,uint256)", p0, p1, p2, p3));
720 	}
721 
722 	function log(uint256 p0, address p1, string memory p2, string memory p3) internal view {
723 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,string)", p0, p1, p2, p3));
724 	}
725 
726 	function log(uint256 p0, address p1, string memory p2, bool p3) internal view {
727 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,bool)", p0, p1, p2, p3));
728 	}
729 
730 	function log(uint256 p0, address p1, string memory p2, address p3) internal view {
731 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,address)", p0, p1, p2, p3));
732 	}
733 
734 	function log(uint256 p0, address p1, bool p2, uint256 p3) internal view {
735 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,uint256)", p0, p1, p2, p3));
736 	}
737 
738 	function log(uint256 p0, address p1, bool p2, string memory p3) internal view {
739 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,string)", p0, p1, p2, p3));
740 	}
741 
742 	function log(uint256 p0, address p1, bool p2, bool p3) internal view {
743 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,bool)", p0, p1, p2, p3));
744 	}
745 
746 	function log(uint256 p0, address p1, bool p2, address p3) internal view {
747 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,address)", p0, p1, p2, p3));
748 	}
749 
750 	function log(uint256 p0, address p1, address p2, uint256 p3) internal view {
751 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,uint256)", p0, p1, p2, p3));
752 	}
753 
754 	function log(uint256 p0, address p1, address p2, string memory p3) internal view {
755 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,string)", p0, p1, p2, p3));
756 	}
757 
758 	function log(uint256 p0, address p1, address p2, bool p3) internal view {
759 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,bool)", p0, p1, p2, p3));
760 	}
761 
762 	function log(uint256 p0, address p1, address p2, address p3) internal view {
763 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,address)", p0, p1, p2, p3));
764 	}
765 
766 	function log(string memory p0, uint256 p1, uint256 p2, uint256 p3) internal view {
767 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,uint256)", p0, p1, p2, p3));
768 	}
769 
770 	function log(string memory p0, uint256 p1, uint256 p2, string memory p3) internal view {
771 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,string)", p0, p1, p2, p3));
772 	}
773 
774 	function log(string memory p0, uint256 p1, uint256 p2, bool p3) internal view {
775 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,bool)", p0, p1, p2, p3));
776 	}
777 
778 	function log(string memory p0, uint256 p1, uint256 p2, address p3) internal view {
779 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,address)", p0, p1, p2, p3));
780 	}
781 
782 	function log(string memory p0, uint256 p1, string memory p2, uint256 p3) internal view {
783 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,uint256)", p0, p1, p2, p3));
784 	}
785 
786 	function log(string memory p0, uint256 p1, string memory p2, string memory p3) internal view {
787 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,string)", p0, p1, p2, p3));
788 	}
789 
790 	function log(string memory p0, uint256 p1, string memory p2, bool p3) internal view {
791 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,bool)", p0, p1, p2, p3));
792 	}
793 
794 	function log(string memory p0, uint256 p1, string memory p2, address p3) internal view {
795 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,address)", p0, p1, p2, p3));
796 	}
797 
798 	function log(string memory p0, uint256 p1, bool p2, uint256 p3) internal view {
799 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,uint256)", p0, p1, p2, p3));
800 	}
801 
802 	function log(string memory p0, uint256 p1, bool p2, string memory p3) internal view {
803 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,string)", p0, p1, p2, p3));
804 	}
805 
806 	function log(string memory p0, uint256 p1, bool p2, bool p3) internal view {
807 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,bool)", p0, p1, p2, p3));
808 	}
809 
810 	function log(string memory p0, uint256 p1, bool p2, address p3) internal view {
811 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,address)", p0, p1, p2, p3));
812 	}
813 
814 	function log(string memory p0, uint256 p1, address p2, uint256 p3) internal view {
815 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,uint256)", p0, p1, p2, p3));
816 	}
817 
818 	function log(string memory p0, uint256 p1, address p2, string memory p3) internal view {
819 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,string)", p0, p1, p2, p3));
820 	}
821 
822 	function log(string memory p0, uint256 p1, address p2, bool p3) internal view {
823 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,bool)", p0, p1, p2, p3));
824 	}
825 
826 	function log(string memory p0, uint256 p1, address p2, address p3) internal view {
827 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,address)", p0, p1, p2, p3));
828 	}
829 
830 	function log(string memory p0, string memory p1, uint256 p2, uint256 p3) internal view {
831 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,uint256)", p0, p1, p2, p3));
832 	}
833 
834 	function log(string memory p0, string memory p1, uint256 p2, string memory p3) internal view {
835 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,string)", p0, p1, p2, p3));
836 	}
837 
838 	function log(string memory p0, string memory p1, uint256 p2, bool p3) internal view {
839 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,bool)", p0, p1, p2, p3));
840 	}
841 
842 	function log(string memory p0, string memory p1, uint256 p2, address p3) internal view {
843 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,address)", p0, p1, p2, p3));
844 	}
845 
846 	function log(string memory p0, string memory p1, string memory p2, uint256 p3) internal view {
847 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint256)", p0, p1, p2, p3));
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
862 	function log(string memory p0, string memory p1, bool p2, uint256 p3) internal view {
863 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint256)", p0, p1, p2, p3));
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
878 	function log(string memory p0, string memory p1, address p2, uint256 p3) internal view {
879 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint256)", p0, p1, p2, p3));
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
894 	function log(string memory p0, bool p1, uint256 p2, uint256 p3) internal view {
895 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,uint256)", p0, p1, p2, p3));
896 	}
897 
898 	function log(string memory p0, bool p1, uint256 p2, string memory p3) internal view {
899 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,string)", p0, p1, p2, p3));
900 	}
901 
902 	function log(string memory p0, bool p1, uint256 p2, bool p3) internal view {
903 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,bool)", p0, p1, p2, p3));
904 	}
905 
906 	function log(string memory p0, bool p1, uint256 p2, address p3) internal view {
907 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,address)", p0, p1, p2, p3));
908 	}
909 
910 	function log(string memory p0, bool p1, string memory p2, uint256 p3) internal view {
911 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint256)", p0, p1, p2, p3));
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
926 	function log(string memory p0, bool p1, bool p2, uint256 p3) internal view {
927 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint256)", p0, p1, p2, p3));
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
942 	function log(string memory p0, bool p1, address p2, uint256 p3) internal view {
943 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint256)", p0, p1, p2, p3));
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
958 	function log(string memory p0, address p1, uint256 p2, uint256 p3) internal view {
959 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,uint256)", p0, p1, p2, p3));
960 	}
961 
962 	function log(string memory p0, address p1, uint256 p2, string memory p3) internal view {
963 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,string)", p0, p1, p2, p3));
964 	}
965 
966 	function log(string memory p0, address p1, uint256 p2, bool p3) internal view {
967 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,bool)", p0, p1, p2, p3));
968 	}
969 
970 	function log(string memory p0, address p1, uint256 p2, address p3) internal view {
971 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,address)", p0, p1, p2, p3));
972 	}
973 
974 	function log(string memory p0, address p1, string memory p2, uint256 p3) internal view {
975 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint256)", p0, p1, p2, p3));
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
990 	function log(string memory p0, address p1, bool p2, uint256 p3) internal view {
991 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint256)", p0, p1, p2, p3));
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
1006 	function log(string memory p0, address p1, address p2, uint256 p3) internal view {
1007 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint256)", p0, p1, p2, p3));
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
1022 	function log(bool p0, uint256 p1, uint256 p2, uint256 p3) internal view {
1023 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,uint256)", p0, p1, p2, p3));
1024 	}
1025 
1026 	function log(bool p0, uint256 p1, uint256 p2, string memory p3) internal view {
1027 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,string)", p0, p1, p2, p3));
1028 	}
1029 
1030 	function log(bool p0, uint256 p1, uint256 p2, bool p3) internal view {
1031 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,bool)", p0, p1, p2, p3));
1032 	}
1033 
1034 	function log(bool p0, uint256 p1, uint256 p2, address p3) internal view {
1035 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,address)", p0, p1, p2, p3));
1036 	}
1037 
1038 	function log(bool p0, uint256 p1, string memory p2, uint256 p3) internal view {
1039 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,uint256)", p0, p1, p2, p3));
1040 	}
1041 
1042 	function log(bool p0, uint256 p1, string memory p2, string memory p3) internal view {
1043 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,string)", p0, p1, p2, p3));
1044 	}
1045 
1046 	function log(bool p0, uint256 p1, string memory p2, bool p3) internal view {
1047 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,bool)", p0, p1, p2, p3));
1048 	}
1049 
1050 	function log(bool p0, uint256 p1, string memory p2, address p3) internal view {
1051 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,address)", p0, p1, p2, p3));
1052 	}
1053 
1054 	function log(bool p0, uint256 p1, bool p2, uint256 p3) internal view {
1055 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,uint256)", p0, p1, p2, p3));
1056 	}
1057 
1058 	function log(bool p0, uint256 p1, bool p2, string memory p3) internal view {
1059 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,string)", p0, p1, p2, p3));
1060 	}
1061 
1062 	function log(bool p0, uint256 p1, bool p2, bool p3) internal view {
1063 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,bool)", p0, p1, p2, p3));
1064 	}
1065 
1066 	function log(bool p0, uint256 p1, bool p2, address p3) internal view {
1067 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,address)", p0, p1, p2, p3));
1068 	}
1069 
1070 	function log(bool p0, uint256 p1, address p2, uint256 p3) internal view {
1071 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,uint256)", p0, p1, p2, p3));
1072 	}
1073 
1074 	function log(bool p0, uint256 p1, address p2, string memory p3) internal view {
1075 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,string)", p0, p1, p2, p3));
1076 	}
1077 
1078 	function log(bool p0, uint256 p1, address p2, bool p3) internal view {
1079 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,bool)", p0, p1, p2, p3));
1080 	}
1081 
1082 	function log(bool p0, uint256 p1, address p2, address p3) internal view {
1083 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,address)", p0, p1, p2, p3));
1084 	}
1085 
1086 	function log(bool p0, string memory p1, uint256 p2, uint256 p3) internal view {
1087 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,uint256)", p0, p1, p2, p3));
1088 	}
1089 
1090 	function log(bool p0, string memory p1, uint256 p2, string memory p3) internal view {
1091 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,string)", p0, p1, p2, p3));
1092 	}
1093 
1094 	function log(bool p0, string memory p1, uint256 p2, bool p3) internal view {
1095 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,bool)", p0, p1, p2, p3));
1096 	}
1097 
1098 	function log(bool p0, string memory p1, uint256 p2, address p3) internal view {
1099 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,address)", p0, p1, p2, p3));
1100 	}
1101 
1102 	function log(bool p0, string memory p1, string memory p2, uint256 p3) internal view {
1103 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint256)", p0, p1, p2, p3));
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
1118 	function log(bool p0, string memory p1, bool p2, uint256 p3) internal view {
1119 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint256)", p0, p1, p2, p3));
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
1134 	function log(bool p0, string memory p1, address p2, uint256 p3) internal view {
1135 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint256)", p0, p1, p2, p3));
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
1150 	function log(bool p0, bool p1, uint256 p2, uint256 p3) internal view {
1151 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,uint256)", p0, p1, p2, p3));
1152 	}
1153 
1154 	function log(bool p0, bool p1, uint256 p2, string memory p3) internal view {
1155 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,string)", p0, p1, p2, p3));
1156 	}
1157 
1158 	function log(bool p0, bool p1, uint256 p2, bool p3) internal view {
1159 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,bool)", p0, p1, p2, p3));
1160 	}
1161 
1162 	function log(bool p0, bool p1, uint256 p2, address p3) internal view {
1163 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,address)", p0, p1, p2, p3));
1164 	}
1165 
1166 	function log(bool p0, bool p1, string memory p2, uint256 p3) internal view {
1167 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint256)", p0, p1, p2, p3));
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
1182 	function log(bool p0, bool p1, bool p2, uint256 p3) internal view {
1183 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint256)", p0, p1, p2, p3));
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
1198 	function log(bool p0, bool p1, address p2, uint256 p3) internal view {
1199 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint256)", p0, p1, p2, p3));
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
1214 	function log(bool p0, address p1, uint256 p2, uint256 p3) internal view {
1215 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,uint256)", p0, p1, p2, p3));
1216 	}
1217 
1218 	function log(bool p0, address p1, uint256 p2, string memory p3) internal view {
1219 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,string)", p0, p1, p2, p3));
1220 	}
1221 
1222 	function log(bool p0, address p1, uint256 p2, bool p3) internal view {
1223 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,bool)", p0, p1, p2, p3));
1224 	}
1225 
1226 	function log(bool p0, address p1, uint256 p2, address p3) internal view {
1227 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,address)", p0, p1, p2, p3));
1228 	}
1229 
1230 	function log(bool p0, address p1, string memory p2, uint256 p3) internal view {
1231 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint256)", p0, p1, p2, p3));
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
1246 	function log(bool p0, address p1, bool p2, uint256 p3) internal view {
1247 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint256)", p0, p1, p2, p3));
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
1262 	function log(bool p0, address p1, address p2, uint256 p3) internal view {
1263 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint256)", p0, p1, p2, p3));
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
1278 	function log(address p0, uint256 p1, uint256 p2, uint256 p3) internal view {
1279 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,uint256)", p0, p1, p2, p3));
1280 	}
1281 
1282 	function log(address p0, uint256 p1, uint256 p2, string memory p3) internal view {
1283 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,string)", p0, p1, p2, p3));
1284 	}
1285 
1286 	function log(address p0, uint256 p1, uint256 p2, bool p3) internal view {
1287 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,bool)", p0, p1, p2, p3));
1288 	}
1289 
1290 	function log(address p0, uint256 p1, uint256 p2, address p3) internal view {
1291 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,address)", p0, p1, p2, p3));
1292 	}
1293 
1294 	function log(address p0, uint256 p1, string memory p2, uint256 p3) internal view {
1295 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,uint256)", p0, p1, p2, p3));
1296 	}
1297 
1298 	function log(address p0, uint256 p1, string memory p2, string memory p3) internal view {
1299 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,string)", p0, p1, p2, p3));
1300 	}
1301 
1302 	function log(address p0, uint256 p1, string memory p2, bool p3) internal view {
1303 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,bool)", p0, p1, p2, p3));
1304 	}
1305 
1306 	function log(address p0, uint256 p1, string memory p2, address p3) internal view {
1307 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,address)", p0, p1, p2, p3));
1308 	}
1309 
1310 	function log(address p0, uint256 p1, bool p2, uint256 p3) internal view {
1311 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,uint256)", p0, p1, p2, p3));
1312 	}
1313 
1314 	function log(address p0, uint256 p1, bool p2, string memory p3) internal view {
1315 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,string)", p0, p1, p2, p3));
1316 	}
1317 
1318 	function log(address p0, uint256 p1, bool p2, bool p3) internal view {
1319 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,bool)", p0, p1, p2, p3));
1320 	}
1321 
1322 	function log(address p0, uint256 p1, bool p2, address p3) internal view {
1323 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,address)", p0, p1, p2, p3));
1324 	}
1325 
1326 	function log(address p0, uint256 p1, address p2, uint256 p3) internal view {
1327 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,uint256)", p0, p1, p2, p3));
1328 	}
1329 
1330 	function log(address p0, uint256 p1, address p2, string memory p3) internal view {
1331 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,string)", p0, p1, p2, p3));
1332 	}
1333 
1334 	function log(address p0, uint256 p1, address p2, bool p3) internal view {
1335 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,bool)", p0, p1, p2, p3));
1336 	}
1337 
1338 	function log(address p0, uint256 p1, address p2, address p3) internal view {
1339 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,address)", p0, p1, p2, p3));
1340 	}
1341 
1342 	function log(address p0, string memory p1, uint256 p2, uint256 p3) internal view {
1343 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,uint256)", p0, p1, p2, p3));
1344 	}
1345 
1346 	function log(address p0, string memory p1, uint256 p2, string memory p3) internal view {
1347 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,string)", p0, p1, p2, p3));
1348 	}
1349 
1350 	function log(address p0, string memory p1, uint256 p2, bool p3) internal view {
1351 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,bool)", p0, p1, p2, p3));
1352 	}
1353 
1354 	function log(address p0, string memory p1, uint256 p2, address p3) internal view {
1355 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,address)", p0, p1, p2, p3));
1356 	}
1357 
1358 	function log(address p0, string memory p1, string memory p2, uint256 p3) internal view {
1359 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint256)", p0, p1, p2, p3));
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
1374 	function log(address p0, string memory p1, bool p2, uint256 p3) internal view {
1375 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint256)", p0, p1, p2, p3));
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
1390 	function log(address p0, string memory p1, address p2, uint256 p3) internal view {
1391 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint256)", p0, p1, p2, p3));
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
1406 	function log(address p0, bool p1, uint256 p2, uint256 p3) internal view {
1407 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,uint256)", p0, p1, p2, p3));
1408 	}
1409 
1410 	function log(address p0, bool p1, uint256 p2, string memory p3) internal view {
1411 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,string)", p0, p1, p2, p3));
1412 	}
1413 
1414 	function log(address p0, bool p1, uint256 p2, bool p3) internal view {
1415 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,bool)", p0, p1, p2, p3));
1416 	}
1417 
1418 	function log(address p0, bool p1, uint256 p2, address p3) internal view {
1419 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,address)", p0, p1, p2, p3));
1420 	}
1421 
1422 	function log(address p0, bool p1, string memory p2, uint256 p3) internal view {
1423 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint256)", p0, p1, p2, p3));
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
1438 	function log(address p0, bool p1, bool p2, uint256 p3) internal view {
1439 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint256)", p0, p1, p2, p3));
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
1454 	function log(address p0, bool p1, address p2, uint256 p3) internal view {
1455 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint256)", p0, p1, p2, p3));
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
1470 	function log(address p0, address p1, uint256 p2, uint256 p3) internal view {
1471 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,uint256)", p0, p1, p2, p3));
1472 	}
1473 
1474 	function log(address p0, address p1, uint256 p2, string memory p3) internal view {
1475 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,string)", p0, p1, p2, p3));
1476 	}
1477 
1478 	function log(address p0, address p1, uint256 p2, bool p3) internal view {
1479 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,bool)", p0, p1, p2, p3));
1480 	}
1481 
1482 	function log(address p0, address p1, uint256 p2, address p3) internal view {
1483 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,address)", p0, p1, p2, p3));
1484 	}
1485 
1486 	function log(address p0, address p1, string memory p2, uint256 p3) internal view {
1487 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint256)", p0, p1, p2, p3));
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
1502 	function log(address p0, address p1, bool p2, uint256 p3) internal view {
1503 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint256)", p0, p1, p2, p3));
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
1518 	function log(address p0, address p1, address p2, uint256 p3) internal view {
1519 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint256)", p0, p1, p2, p3));
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
1536 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1537 
1538 
1539 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
1540 
1541 pragma solidity ^0.8.0;
1542 
1543 /**
1544  * @dev Contract module that helps prevent reentrant calls to a function.
1545  *
1546  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1547  * available, which can be applied to functions to make sure there are no nested
1548  * (reentrant) calls to them.
1549  *
1550  * Note that because there is a single `nonReentrant` guard, functions marked as
1551  * `nonReentrant` may not call one another. This can be worked around by making
1552  * those functions `private`, and then adding `external` `nonReentrant` entry
1553  * points to them.
1554  *
1555  * TIP: If you would like to learn more about reentrancy and alternative ways
1556  * to protect against it, check out our blog post
1557  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1558  */
1559 abstract contract ReentrancyGuard {
1560     // Booleans are more expensive than uint256 or any type that takes up a full
1561     // word because each write operation emits an extra SLOAD to first read the
1562     // slot's contents, replace the bits taken up by the boolean, and then write
1563     // back. This is the compiler's defense against contract upgrades and
1564     // pointer aliasing, and it cannot be disabled.
1565 
1566     // The values being non-zero value makes deployment a bit more expensive,
1567     // but in exchange the refund on every call to nonReentrant will be lower in
1568     // amount. Since refunds are capped to a percentage of the total
1569     // transaction's gas, it is best to keep them low in cases like this one, to
1570     // increase the likelihood of the full refund coming into effect.
1571     uint256 private constant _NOT_ENTERED = 1;
1572     uint256 private constant _ENTERED = 2;
1573 
1574     uint256 private _status;
1575 
1576     constructor() {
1577         _status = _NOT_ENTERED;
1578     }
1579 
1580     /**
1581      * @dev Prevents a contract from calling itself, directly or indirectly.
1582      * Calling a `nonReentrant` function from another `nonReentrant`
1583      * function is not supported. It is possible to prevent this from happening
1584      * by making the `nonReentrant` function external, and making it call a
1585      * `private` function that does the actual work.
1586      */
1587     modifier nonReentrant() {
1588         _nonReentrantBefore();
1589         _;
1590         _nonReentrantAfter();
1591     }
1592 
1593     function _nonReentrantBefore() private {
1594         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1595         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1596 
1597         // Any calls to nonReentrant after this point will fail
1598         _status = _ENTERED;
1599     }
1600 
1601     function _nonReentrantAfter() private {
1602         // By storing the original value once again, a refund is triggered (see
1603         // https://eips.ethereum.org/EIPS/eip-2200)
1604         _status = _NOT_ENTERED;
1605     }
1606 }
1607 
1608 // File: @openzeppelin/contracts/utils/math/Math.sol
1609 
1610 
1611 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
1612 
1613 pragma solidity ^0.8.0;
1614 
1615 /**
1616  * @dev Standard math utilities missing in the Solidity language.
1617  */
1618 library Math {
1619     enum Rounding {
1620         Down, // Toward negative infinity
1621         Up, // Toward infinity
1622         Zero // Toward zero
1623     }
1624 
1625     /**
1626      * @dev Returns the largest of two numbers.
1627      */
1628     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1629         return a > b ? a : b;
1630     }
1631 
1632     /**
1633      * @dev Returns the smallest of two numbers.
1634      */
1635     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1636         return a < b ? a : b;
1637     }
1638 
1639     /**
1640      * @dev Returns the average of two numbers. The result is rounded towards
1641      * zero.
1642      */
1643     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1644         // (a + b) / 2 can overflow.
1645         return (a & b) + (a ^ b) / 2;
1646     }
1647 
1648     /**
1649      * @dev Returns the ceiling of the division of two numbers.
1650      *
1651      * This differs from standard division with `/` in that it rounds up instead
1652      * of rounding down.
1653      */
1654     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1655         // (a + b - 1) / b can overflow on addition, so we distribute.
1656         return a == 0 ? 0 : (a - 1) / b + 1;
1657     }
1658 
1659     /**
1660      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1661      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1662      * with further edits by Uniswap Labs also under MIT license.
1663      */
1664     function mulDiv(
1665         uint256 x,
1666         uint256 y,
1667         uint256 denominator
1668     ) internal pure returns (uint256 result) {
1669         unchecked {
1670             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1671             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1672             // variables such that product = prod1 * 2^256 + prod0.
1673             uint256 prod0; // Least significant 256 bits of the product
1674             uint256 prod1; // Most significant 256 bits of the product
1675             assembly {
1676                 let mm := mulmod(x, y, not(0))
1677                 prod0 := mul(x, y)
1678                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1679             }
1680 
1681             // Handle non-overflow cases, 256 by 256 division.
1682             if (prod1 == 0) {
1683                 return prod0 / denominator;
1684             }
1685 
1686             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1687             require(denominator > prod1);
1688 
1689             ///////////////////////////////////////////////
1690             // 512 by 256 division.
1691             ///////////////////////////////////////////////
1692 
1693             // Make division exact by subtracting the remainder from [prod1 prod0].
1694             uint256 remainder;
1695             assembly {
1696                 // Compute remainder using mulmod.
1697                 remainder := mulmod(x, y, denominator)
1698 
1699                 // Subtract 256 bit number from 512 bit number.
1700                 prod1 := sub(prod1, gt(remainder, prod0))
1701                 prod0 := sub(prod0, remainder)
1702             }
1703 
1704             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1705             // See https://cs.stackexchange.com/q/138556/92363.
1706 
1707             // Does not overflow because the denominator cannot be zero at this stage in the function.
1708             uint256 twos = denominator & (~denominator + 1);
1709             assembly {
1710                 // Divide denominator by twos.
1711                 denominator := div(denominator, twos)
1712 
1713                 // Divide [prod1 prod0] by twos.
1714                 prod0 := div(prod0, twos)
1715 
1716                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1717                 twos := add(div(sub(0, twos), twos), 1)
1718             }
1719 
1720             // Shift in bits from prod1 into prod0.
1721             prod0 |= prod1 * twos;
1722 
1723             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1724             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1725             // four bits. That is, denominator * inv = 1 mod 2^4.
1726             uint256 inverse = (3 * denominator) ^ 2;
1727 
1728             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1729             // in modular arithmetic, doubling the correct bits in each step.
1730             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1731             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1732             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1733             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1734             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1735             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1736 
1737             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1738             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1739             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1740             // is no longer required.
1741             result = prod0 * inverse;
1742             return result;
1743         }
1744     }
1745 
1746     /**
1747      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1748      */
1749     function mulDiv(
1750         uint256 x,
1751         uint256 y,
1752         uint256 denominator,
1753         Rounding rounding
1754     ) internal pure returns (uint256) {
1755         uint256 result = mulDiv(x, y, denominator);
1756         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1757             result += 1;
1758         }
1759         return result;
1760     }
1761 
1762     /**
1763      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1764      *
1765      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1766      */
1767     function sqrt(uint256 a) internal pure returns (uint256) {
1768         if (a == 0) {
1769             return 0;
1770         }
1771 
1772         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1773         //
1774         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1775         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1776         //
1777         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1778         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1779         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1780         //
1781         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1782         uint256 result = 1 << (log2(a) >> 1);
1783 
1784         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1785         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1786         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1787         // into the expected uint128 result.
1788         unchecked {
1789             result = (result + a / result) >> 1;
1790             result = (result + a / result) >> 1;
1791             result = (result + a / result) >> 1;
1792             result = (result + a / result) >> 1;
1793             result = (result + a / result) >> 1;
1794             result = (result + a / result) >> 1;
1795             result = (result + a / result) >> 1;
1796             return min(result, a / result);
1797         }
1798     }
1799 
1800     /**
1801      * @notice Calculates sqrt(a), following the selected rounding direction.
1802      */
1803     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1804         unchecked {
1805             uint256 result = sqrt(a);
1806             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1807         }
1808     }
1809 
1810     /**
1811      * @dev Return the log in base 2, rounded down, of a positive value.
1812      * Returns 0 if given 0.
1813      */
1814     function log2(uint256 value) internal pure returns (uint256) {
1815         uint256 result = 0;
1816         unchecked {
1817             if (value >> 128 > 0) {
1818                 value >>= 128;
1819                 result += 128;
1820             }
1821             if (value >> 64 > 0) {
1822                 value >>= 64;
1823                 result += 64;
1824             }
1825             if (value >> 32 > 0) {
1826                 value >>= 32;
1827                 result += 32;
1828             }
1829             if (value >> 16 > 0) {
1830                 value >>= 16;
1831                 result += 16;
1832             }
1833             if (value >> 8 > 0) {
1834                 value >>= 8;
1835                 result += 8;
1836             }
1837             if (value >> 4 > 0) {
1838                 value >>= 4;
1839                 result += 4;
1840             }
1841             if (value >> 2 > 0) {
1842                 value >>= 2;
1843                 result += 2;
1844             }
1845             if (value >> 1 > 0) {
1846                 result += 1;
1847             }
1848         }
1849         return result;
1850     }
1851 
1852     /**
1853      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1854      * Returns 0 if given 0.
1855      */
1856     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1857         unchecked {
1858             uint256 result = log2(value);
1859             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1860         }
1861     }
1862 
1863     /**
1864      * @dev Return the log in base 10, rounded down, of a positive value.
1865      * Returns 0 if given 0.
1866      */
1867     function log10(uint256 value) internal pure returns (uint256) {
1868         uint256 result = 0;
1869         unchecked {
1870             if (value >= 10**64) {
1871                 value /= 10**64;
1872                 result += 64;
1873             }
1874             if (value >= 10**32) {
1875                 value /= 10**32;
1876                 result += 32;
1877             }
1878             if (value >= 10**16) {
1879                 value /= 10**16;
1880                 result += 16;
1881             }
1882             if (value >= 10**8) {
1883                 value /= 10**8;
1884                 result += 8;
1885             }
1886             if (value >= 10**4) {
1887                 value /= 10**4;
1888                 result += 4;
1889             }
1890             if (value >= 10**2) {
1891                 value /= 10**2;
1892                 result += 2;
1893             }
1894             if (value >= 10**1) {
1895                 result += 1;
1896             }
1897         }
1898         return result;
1899     }
1900 
1901     /**
1902      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1903      * Returns 0 if given 0.
1904      */
1905     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1906         unchecked {
1907             uint256 result = log10(value);
1908             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1909         }
1910     }
1911 
1912     /**
1913      * @dev Return the log in base 256, rounded down, of a positive value.
1914      * Returns 0 if given 0.
1915      *
1916      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1917      */
1918     function log256(uint256 value) internal pure returns (uint256) {
1919         uint256 result = 0;
1920         unchecked {
1921             if (value >> 128 > 0) {
1922                 value >>= 128;
1923                 result += 16;
1924             }
1925             if (value >> 64 > 0) {
1926                 value >>= 64;
1927                 result += 8;
1928             }
1929             if (value >> 32 > 0) {
1930                 value >>= 32;
1931                 result += 4;
1932             }
1933             if (value >> 16 > 0) {
1934                 value >>= 16;
1935                 result += 2;
1936             }
1937             if (value >> 8 > 0) {
1938                 result += 1;
1939             }
1940         }
1941         return result;
1942     }
1943 
1944     /**
1945      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1946      * Returns 0 if given 0.
1947      */
1948     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1949         unchecked {
1950             uint256 result = log256(value);
1951             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1952         }
1953     }
1954 }
1955 
1956 // File: @openzeppelin/contracts/utils/Strings.sol
1957 
1958 
1959 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1960 
1961 pragma solidity ^0.8.0;
1962 
1963 
1964 /**
1965  * @dev String operations.
1966  */
1967 library Strings {
1968     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1969     uint8 private constant _ADDRESS_LENGTH = 20;
1970 
1971     /**
1972      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1973      */
1974     function toString(uint256 value) internal pure returns (string memory) {
1975         unchecked {
1976             uint256 length = Math.log10(value) + 1;
1977             string memory buffer = new string(length);
1978             uint256 ptr;
1979             /// @solidity memory-safe-assembly
1980             assembly {
1981                 ptr := add(buffer, add(32, length))
1982             }
1983             while (true) {
1984                 ptr--;
1985                 /// @solidity memory-safe-assembly
1986                 assembly {
1987                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1988                 }
1989                 value /= 10;
1990                 if (value == 0) break;
1991             }
1992             return buffer;
1993         }
1994     }
1995 
1996     /**
1997      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1998      */
1999     function toHexString(uint256 value) internal pure returns (string memory) {
2000         unchecked {
2001             return toHexString(value, Math.log256(value) + 1);
2002         }
2003     }
2004 
2005     /**
2006      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2007      */
2008     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2009         bytes memory buffer = new bytes(2 * length + 2);
2010         buffer[0] = "0";
2011         buffer[1] = "x";
2012         for (uint256 i = 2 * length + 1; i > 1; --i) {
2013             buffer[i] = _SYMBOLS[value & 0xf];
2014             value >>= 4;
2015         }
2016         require(value == 0, "Strings: hex length insufficient");
2017         return string(buffer);
2018     }
2019 
2020     /**
2021      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
2022      */
2023     function toHexString(address addr) internal pure returns (string memory) {
2024         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
2025     }
2026 }
2027 
2028 // File: @openzeppelin/contracts/utils/Context.sol
2029 
2030 
2031 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2032 
2033 pragma solidity ^0.8.0;
2034 
2035 /**
2036  * @dev Provides information about the current execution context, including the
2037  * sender of the transaction and its data. While these are generally available
2038  * via msg.sender and msg.data, they should not be accessed in such a direct
2039  * manner, since when dealing with meta-transactions the account sending and
2040  * paying for execution may not be the actual sender (as far as an application
2041  * is concerned).
2042  *
2043  * This contract is only required for intermediate, library-like contracts.
2044  */
2045 abstract contract Context {
2046     function _msgSender() internal view virtual returns (address) {
2047         return msg.sender;
2048     }
2049 
2050     function _msgData() internal view virtual returns (bytes calldata) {
2051         return msg.data;
2052     }
2053 }
2054 
2055 // File: @openzeppelin/contracts/security/Pausable.sol
2056 
2057 
2058 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
2059 
2060 pragma solidity ^0.8.0;
2061 
2062 
2063 /**
2064  * @dev Contract module which allows children to implement an emergency stop
2065  * mechanism that can be triggered by an authorized account.
2066  *
2067  * This module is used through inheritance. It will make available the
2068  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
2069  * the functions of your contract. Note that they will not be pausable by
2070  * simply including this module, only once the modifiers are put in place.
2071  */
2072 abstract contract Pausable is Context {
2073     /**
2074      * @dev Emitted when the pause is triggered by `account`.
2075      */
2076     event Paused(address account);
2077 
2078     /**
2079      * @dev Emitted when the pause is lifted by `account`.
2080      */
2081     event Unpaused(address account);
2082 
2083     bool private _paused;
2084 
2085     /**
2086      * @dev Initializes the contract in unpaused state.
2087      */
2088     constructor() {
2089         _paused = false;
2090     }
2091 
2092     /**
2093      * @dev Modifier to make a function callable only when the contract is not paused.
2094      *
2095      * Requirements:
2096      *
2097      * - The contract must not be paused.
2098      */
2099     modifier whenNotPaused() {
2100         _requireNotPaused();
2101         _;
2102     }
2103 
2104     /**
2105      * @dev Modifier to make a function callable only when the contract is paused.
2106      *
2107      * Requirements:
2108      *
2109      * - The contract must be paused.
2110      */
2111     modifier whenPaused() {
2112         _requirePaused();
2113         _;
2114     }
2115 
2116     /**
2117      * @dev Returns true if the contract is paused, and false otherwise.
2118      */
2119     function paused() public view virtual returns (bool) {
2120         return _paused;
2121     }
2122 
2123     /**
2124      * @dev Throws if the contract is paused.
2125      */
2126     function _requireNotPaused() internal view virtual {
2127         require(!paused(), "Pausable: paused");
2128     }
2129 
2130     /**
2131      * @dev Throws if the contract is not paused.
2132      */
2133     function _requirePaused() internal view virtual {
2134         require(paused(), "Pausable: not paused");
2135     }
2136 
2137     /**
2138      * @dev Triggers stopped state.
2139      *
2140      * Requirements:
2141      *
2142      * - The contract must not be paused.
2143      */
2144     function _pause() internal virtual whenNotPaused {
2145         _paused = true;
2146         emit Paused(_msgSender());
2147     }
2148 
2149     /**
2150      * @dev Returns to normal state.
2151      *
2152      * Requirements:
2153      *
2154      * - The contract must be paused.
2155      */
2156     function _unpause() internal virtual whenPaused {
2157         _paused = false;
2158         emit Unpaused(_msgSender());
2159     }
2160 }
2161 
2162 // File: @openzeppelin/contracts/access/Ownable.sol
2163 
2164 
2165 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2166 
2167 pragma solidity ^0.8.0;
2168 
2169 
2170 /**
2171  * @dev Contract module which provides a basic access control mechanism, where
2172  * there is an account (an owner) that can be granted exclusive access to
2173  * specific functions.
2174  *
2175  * By default, the owner account will be the one that deploys the contract. This
2176  * can later be changed with {transferOwnership}.
2177  *
2178  * This module is used through inheritance. It will make available the modifier
2179  * `onlyOwner`, which can be applied to your functions to restrict their use to
2180  * the owner.
2181  */
2182 abstract contract Ownable is Context {
2183     address private _owner;
2184 
2185     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2186 
2187     /**
2188      * @dev Initializes the contract setting the deployer as the initial owner.
2189      */
2190     constructor() {
2191         _transferOwnership(_msgSender());
2192     }
2193 
2194     /**
2195      * @dev Throws if called by any account other than the owner.
2196      */
2197     modifier onlyOwner() {
2198         _checkOwner();
2199         _;
2200     }
2201 
2202     /**
2203      * @dev Returns the address of the current owner.
2204      */
2205     function owner() public view virtual returns (address) {
2206         return _owner;
2207     }
2208 
2209     /**
2210      * @dev Throws if the sender is not the owner.
2211      */
2212     function _checkOwner() internal view virtual {
2213         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2214     }
2215 
2216     /**
2217      * @dev Leaves the contract without owner. It will not be possible to call
2218      * `onlyOwner` functions anymore. Can only be called by the current owner.
2219      *
2220      * NOTE: Renouncing ownership will leave the contract without an owner,
2221      * thereby removing any functionality that is only available to the owner.
2222      */
2223     function renounceOwnership() public virtual onlyOwner {
2224         _transferOwnership(address(0));
2225     }
2226 
2227     /**
2228      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2229      * Can only be called by the current owner.
2230      */
2231     function transferOwnership(address newOwner) public virtual onlyOwner {
2232         require(newOwner != address(0), "Ownable: new owner is the zero address");
2233         _transferOwnership(newOwner);
2234     }
2235 
2236     /**
2237      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2238      * Internal function without access restriction.
2239      */
2240     function _transferOwnership(address newOwner) internal virtual {
2241         address oldOwner = _owner;
2242         _owner = newOwner;
2243         emit OwnershipTransferred(oldOwner, newOwner);
2244     }
2245 }
2246 
2247 // File: @openzeppelin/contracts/utils/Address.sol
2248 
2249 
2250 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
2251 
2252 pragma solidity ^0.8.1;
2253 
2254 /**
2255  * @dev Collection of functions related to the address type
2256  */
2257 library Address {
2258     /**
2259      * @dev Returns true if `account` is a contract.
2260      *
2261      * [IMPORTANT]
2262      * ====
2263      * It is unsafe to assume that an address for which this function returns
2264      * false is an externally-owned account (EOA) and not a contract.
2265      *
2266      * Among others, `isContract` will return false for the following
2267      * types of addresses:
2268      *
2269      *  - an externally-owned account
2270      *  - a contract in construction
2271      *  - an address where a contract will be created
2272      *  - an address where a contract lived, but was destroyed
2273      * ====
2274      *
2275      * [IMPORTANT]
2276      * ====
2277      * You shouldn't rely on `isContract` to protect against flash loan attacks!
2278      *
2279      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
2280      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
2281      * constructor.
2282      * ====
2283      */
2284     function isContract(address account) internal view returns (bool) {
2285         // This method relies on extcodesize/address.code.length, which returns 0
2286         // for contracts in construction, since the code is only stored at the end
2287         // of the constructor execution.
2288 
2289         return account.code.length > 0;
2290     }
2291 
2292     /**
2293      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
2294      * `recipient`, forwarding all available gas and reverting on errors.
2295      *
2296      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
2297      * of certain opcodes, possibly making contracts go over the 2300 gas limit
2298      * imposed by `transfer`, making them unable to receive funds via
2299      * `transfer`. {sendValue} removes this limitation.
2300      *
2301      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
2302      *
2303      * IMPORTANT: because control is transferred to `recipient`, care must be
2304      * taken to not create reentrancy vulnerabilities. Consider using
2305      * {ReentrancyGuard} or the
2306      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
2307      */
2308     function sendValue(address payable recipient, uint256 amount) internal {
2309         require(address(this).balance >= amount, "Address: insufficient balance");
2310 
2311         (bool success, ) = recipient.call{value: amount}("");
2312         require(success, "Address: unable to send value, recipient may have reverted");
2313     }
2314 
2315     /**
2316      * @dev Performs a Solidity function call using a low level `call`. A
2317      * plain `call` is an unsafe replacement for a function call: use this
2318      * function instead.
2319      *
2320      * If `target` reverts with a revert reason, it is bubbled up by this
2321      * function (like regular Solidity function calls).
2322      *
2323      * Returns the raw returned data. To convert to the expected return value,
2324      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
2325      *
2326      * Requirements:
2327      *
2328      * - `target` must be a contract.
2329      * - calling `target` with `data` must not revert.
2330      *
2331      * _Available since v3.1._
2332      */
2333     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
2334         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
2335     }
2336 
2337     /**
2338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
2339      * `errorMessage` as a fallback revert reason when `target` reverts.
2340      *
2341      * _Available since v3.1._
2342      */
2343     function functionCall(
2344         address target,
2345         bytes memory data,
2346         string memory errorMessage
2347     ) internal returns (bytes memory) {
2348         return functionCallWithValue(target, data, 0, errorMessage);
2349     }
2350 
2351     /**
2352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2353      * but also transferring `value` wei to `target`.
2354      *
2355      * Requirements:
2356      *
2357      * - the calling contract must have an ETH balance of at least `value`.
2358      * - the called Solidity function must be `payable`.
2359      *
2360      * _Available since v3.1._
2361      */
2362     function functionCallWithValue(
2363         address target,
2364         bytes memory data,
2365         uint256 value
2366     ) internal returns (bytes memory) {
2367         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
2368     }
2369 
2370     /**
2371      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
2372      * with `errorMessage` as a fallback revert reason when `target` reverts.
2373      *
2374      * _Available since v3.1._
2375      */
2376     function functionCallWithValue(
2377         address target,
2378         bytes memory data,
2379         uint256 value,
2380         string memory errorMessage
2381     ) internal returns (bytes memory) {
2382         require(address(this).balance >= value, "Address: insufficient balance for call");
2383         (bool success, bytes memory returndata) = target.call{value: value}(data);
2384         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
2385     }
2386 
2387     /**
2388      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2389      * but performing a static call.
2390      *
2391      * _Available since v3.3._
2392      */
2393     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
2394         return functionStaticCall(target, data, "Address: low-level static call failed");
2395     }
2396 
2397     /**
2398      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2399      * but performing a static call.
2400      *
2401      * _Available since v3.3._
2402      */
2403     function functionStaticCall(
2404         address target,
2405         bytes memory data,
2406         string memory errorMessage
2407     ) internal view returns (bytes memory) {
2408         (bool success, bytes memory returndata) = target.staticcall(data);
2409         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
2410     }
2411 
2412     /**
2413      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2414      * but performing a delegate call.
2415      *
2416      * _Available since v3.4._
2417      */
2418     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
2419         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
2420     }
2421 
2422     /**
2423      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2424      * but performing a delegate call.
2425      *
2426      * _Available since v3.4._
2427      */
2428     function functionDelegateCall(
2429         address target,
2430         bytes memory data,
2431         string memory errorMessage
2432     ) internal returns (bytes memory) {
2433         (bool success, bytes memory returndata) = target.delegatecall(data);
2434         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
2435     }
2436 
2437     /**
2438      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
2439      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
2440      *
2441      * _Available since v4.8._
2442      */
2443     function verifyCallResultFromTarget(
2444         address target,
2445         bool success,
2446         bytes memory returndata,
2447         string memory errorMessage
2448     ) internal view returns (bytes memory) {
2449         if (success) {
2450             if (returndata.length == 0) {
2451                 // only check isContract if the call was successful and the return data is empty
2452                 // otherwise we already know that it was a contract
2453                 require(isContract(target), "Address: call to non-contract");
2454             }
2455             return returndata;
2456         } else {
2457             _revert(returndata, errorMessage);
2458         }
2459     }
2460 
2461     /**
2462      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
2463      * revert reason or using the provided one.
2464      *
2465      * _Available since v4.3._
2466      */
2467     function verifyCallResult(
2468         bool success,
2469         bytes memory returndata,
2470         string memory errorMessage
2471     ) internal pure returns (bytes memory) {
2472         if (success) {
2473             return returndata;
2474         } else {
2475             _revert(returndata, errorMessage);
2476         }
2477     }
2478 
2479     function _revert(bytes memory returndata, string memory errorMessage) private pure {
2480         // Look for revert reason and bubble it up if present
2481         if (returndata.length > 0) {
2482             // The easiest way to bubble the revert reason is using memory via assembly
2483             /// @solidity memory-safe-assembly
2484             assembly {
2485                 let returndata_size := mload(returndata)
2486                 revert(add(32, returndata), returndata_size)
2487             }
2488         } else {
2489             revert(errorMessage);
2490         }
2491     }
2492 }
2493 
2494 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
2495 
2496 
2497 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
2498 
2499 pragma solidity ^0.8.0;
2500 
2501 /**
2502  * @title ERC721 token receiver interface
2503  * @dev Interface for any contract that wants to support safeTransfers
2504  * from ERC721 asset contracts.
2505  */
2506 interface IERC721Receiver {
2507     /**
2508      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
2509      * by `operator` from `from`, this function is called.
2510      *
2511      * It must return its Solidity selector to confirm the token transfer.
2512      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
2513      *
2514      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
2515      */
2516     function onERC721Received(
2517         address operator,
2518         address from,
2519         uint256 tokenId,
2520         bytes calldata data
2521     ) external returns (bytes4);
2522 }
2523 
2524 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2525 
2526 
2527 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
2528 
2529 pragma solidity ^0.8.0;
2530 
2531 /**
2532  * @dev Interface of the ERC165 standard, as defined in the
2533  * https://eips.ethereum.org/EIPS/eip-165[EIP].
2534  *
2535  * Implementers can declare support of contract interfaces, which can then be
2536  * queried by others ({ERC165Checker}).
2537  *
2538  * For an implementation, see {ERC165}.
2539  */
2540 interface IERC165 {
2541     /**
2542      * @dev Returns true if this contract implements the interface defined by
2543      * `interfaceId`. See the corresponding
2544      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
2545      * to learn more about how these ids are created.
2546      *
2547      * This function call must use less than 30 000 gas.
2548      */
2549     function supportsInterface(bytes4 interfaceId) external view returns (bool);
2550 }
2551 
2552 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
2553 
2554 
2555 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
2556 
2557 pragma solidity ^0.8.0;
2558 
2559 
2560 /**
2561  * @dev Implementation of the {IERC165} interface.
2562  *
2563  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
2564  * for the additional interface id that will be supported. For example:
2565  *
2566  * ```solidity
2567  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2568  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
2569  * }
2570  * ```
2571  *
2572  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
2573  */
2574 abstract contract ERC165 is IERC165 {
2575     /**
2576      * @dev See {IERC165-supportsInterface}.
2577      */
2578     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2579         return interfaceId == type(IERC165).interfaceId;
2580     }
2581 }
2582 
2583 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
2584 
2585 
2586 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
2587 
2588 pragma solidity ^0.8.0;
2589 
2590 
2591 /**
2592  * @dev Required interface of an ERC721 compliant contract.
2593  */
2594 interface IERC721 is IERC165 {
2595     /**
2596      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
2597      */
2598     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
2599 
2600     /**
2601      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
2602      */
2603     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
2604 
2605     /**
2606      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
2607      */
2608     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
2609 
2610     /**
2611      * @dev Returns the number of tokens in ``owner``'s account.
2612      */
2613     function balanceOf(address owner) external view returns (uint256 balance);
2614 
2615     /**
2616      * @dev Returns the owner of the `tokenId` token.
2617      *
2618      * Requirements:
2619      *
2620      * - `tokenId` must exist.
2621      */
2622     function ownerOf(uint256 tokenId) external view returns (address owner);
2623 
2624     /**
2625      * @dev Safely transfers `tokenId` token from `from` to `to`.
2626      *
2627      * Requirements:
2628      *
2629      * - `from` cannot be the zero address.
2630      * - `to` cannot be the zero address.
2631      * - `tokenId` token must exist and be owned by `from`.
2632      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2633      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2634      *
2635      * Emits a {Transfer} event.
2636      */
2637     function safeTransferFrom(
2638         address from,
2639         address to,
2640         uint256 tokenId,
2641         bytes calldata data
2642     ) external;
2643 
2644     /**
2645      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2646      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2647      *
2648      * Requirements:
2649      *
2650      * - `from` cannot be the zero address.
2651      * - `to` cannot be the zero address.
2652      * - `tokenId` token must exist and be owned by `from`.
2653      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
2654      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2655      *
2656      * Emits a {Transfer} event.
2657      */
2658     function safeTransferFrom(
2659         address from,
2660         address to,
2661         uint256 tokenId
2662     ) external;
2663 
2664     /**
2665      * @dev Transfers `tokenId` token from `from` to `to`.
2666      *
2667      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
2668      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
2669      * understand this adds an external call which potentially creates a reentrancy vulnerability.
2670      *
2671      * Requirements:
2672      *
2673      * - `from` cannot be the zero address.
2674      * - `to` cannot be the zero address.
2675      * - `tokenId` token must be owned by `from`.
2676      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2677      *
2678      * Emits a {Transfer} event.
2679      */
2680     function transferFrom(
2681         address from,
2682         address to,
2683         uint256 tokenId
2684     ) external;
2685 
2686     /**
2687      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2688      * The approval is cleared when the token is transferred.
2689      *
2690      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
2691      *
2692      * Requirements:
2693      *
2694      * - The caller must own the token or be an approved operator.
2695      * - `tokenId` must exist.
2696      *
2697      * Emits an {Approval} event.
2698      */
2699     function approve(address to, uint256 tokenId) external;
2700 
2701     /**
2702      * @dev Approve or remove `operator` as an operator for the caller.
2703      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
2704      *
2705      * Requirements:
2706      *
2707      * - The `operator` cannot be the caller.
2708      *
2709      * Emits an {ApprovalForAll} event.
2710      */
2711     function setApprovalForAll(address operator, bool _approved) external;
2712 
2713     /**
2714      * @dev Returns the account approved for `tokenId` token.
2715      *
2716      * Requirements:
2717      *
2718      * - `tokenId` must exist.
2719      */
2720     function getApproved(uint256 tokenId) external view returns (address operator);
2721 
2722     /**
2723      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2724      *
2725      * See {setApprovalForAll}
2726      */
2727     function isApprovedForAll(address owner, address operator) external view returns (bool);
2728 }
2729 
2730 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
2731 
2732 
2733 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
2734 
2735 pragma solidity ^0.8.0;
2736 
2737 
2738 /**
2739  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
2740  * @dev See https://eips.ethereum.org/EIPS/eip-721
2741  */
2742 interface IERC721Metadata is IERC721 {
2743     /**
2744      * @dev Returns the token collection name.
2745      */
2746     function name() external view returns (string memory);
2747 
2748     /**
2749      * @dev Returns the token collection symbol.
2750      */
2751     function symbol() external view returns (string memory);
2752 
2753     /**
2754      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2755      */
2756     function tokenURI(uint256 tokenId) external view returns (string memory);
2757 }
2758 
2759 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
2760 
2761 
2762 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
2763 
2764 pragma solidity ^0.8.0;
2765 
2766 
2767 
2768 
2769 
2770 
2771 
2772 
2773 /**
2774  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2775  * the Metadata extension, but not including the Enumerable extension, which is available separately as
2776  * {ERC721Enumerable}.
2777  */
2778 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
2779     using Address for address;
2780     using Strings for uint256;
2781 
2782     // Token name
2783     string private _name;
2784 
2785     // Token symbol
2786     string private _symbol;
2787 
2788     // Mapping from token ID to owner address
2789     mapping(uint256 => address) private _owners;
2790 
2791     // Mapping owner address to token count
2792     mapping(address => uint256) private _balances;
2793 
2794     // Mapping from token ID to approved address
2795     mapping(uint256 => address) private _tokenApprovals;
2796 
2797     // Mapping from owner to operator approvals
2798     mapping(address => mapping(address => bool)) private _operatorApprovals;
2799 
2800     /**
2801      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2802      */
2803     constructor(string memory name_, string memory symbol_) {
2804         _name = name_;
2805         _symbol = symbol_;
2806     }
2807 
2808     /**
2809      * @dev See {IERC165-supportsInterface}.
2810      */
2811     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2812         return
2813             interfaceId == type(IERC721).interfaceId ||
2814             interfaceId == type(IERC721Metadata).interfaceId ||
2815             super.supportsInterface(interfaceId);
2816     }
2817 
2818     /**
2819      * @dev See {IERC721-balanceOf}.
2820      */
2821     function balanceOf(address owner) public view virtual override returns (uint256) {
2822         require(owner != address(0), "ERC721: address zero is not a valid owner");
2823         return _balances[owner];
2824     }
2825 
2826     /**
2827      * @dev See {IERC721-ownerOf}.
2828      */
2829     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2830         address owner = _ownerOf(tokenId);
2831         require(owner != address(0), "ERC721: invalid token ID");
2832         return owner;
2833     }
2834 
2835     /**
2836      * @dev See {IERC721Metadata-name}.
2837      */
2838     function name() public view virtual override returns (string memory) {
2839         return _name;
2840     }
2841 
2842     /**
2843      * @dev See {IERC721Metadata-symbol}.
2844      */
2845     function symbol() public view virtual override returns (string memory) {
2846         return _symbol;
2847     }
2848 
2849     /**
2850      * @dev See {IERC721Metadata-tokenURI}.
2851      */
2852     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2853         _requireMinted(tokenId);
2854 
2855         string memory baseURI = _baseURI();
2856         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2857     }
2858 
2859     /**
2860      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2861      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2862      * by default, can be overridden in child contracts.
2863      */
2864     function _baseURI() internal view virtual returns (string memory) {
2865         return "";
2866     }
2867 
2868     /**
2869      * @dev See {IERC721-approve}.
2870      */
2871     function approve(address to, uint256 tokenId) public virtual override {
2872         address owner = ERC721.ownerOf(tokenId);
2873         require(to != owner, "ERC721: approval to current owner");
2874 
2875         require(
2876             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2877             "ERC721: approve caller is not token owner or approved for all"
2878         );
2879 
2880         _approve(to, tokenId);
2881     }
2882 
2883     /**
2884      * @dev See {IERC721-getApproved}.
2885      */
2886     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2887         _requireMinted(tokenId);
2888 
2889         return _tokenApprovals[tokenId];
2890     }
2891 
2892     /**
2893      * @dev See {IERC721-setApprovalForAll}.
2894      */
2895     function setApprovalForAll(address operator, bool approved) public virtual override {
2896         _setApprovalForAll(_msgSender(), operator, approved);
2897     }
2898 
2899     /**
2900      * @dev See {IERC721-isApprovedForAll}.
2901      */
2902     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2903         return _operatorApprovals[owner][operator];
2904     }
2905 
2906     /**
2907      * @dev See {IERC721-transferFrom}.
2908      */
2909     function transferFrom(
2910         address from,
2911         address to,
2912         uint256 tokenId
2913     ) public virtual override {
2914         //solhint-disable-next-line max-line-length
2915         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
2916 
2917         _transfer(from, to, tokenId);
2918     }
2919 
2920     /**
2921      * @dev See {IERC721-safeTransferFrom}.
2922      */
2923     function safeTransferFrom(
2924         address from,
2925         address to,
2926         uint256 tokenId
2927     ) public virtual override {
2928         safeTransferFrom(from, to, tokenId, "");
2929     }
2930 
2931     /**
2932      * @dev See {IERC721-safeTransferFrom}.
2933      */
2934     function safeTransferFrom(
2935         address from,
2936         address to,
2937         uint256 tokenId,
2938         bytes memory data
2939     ) public virtual override {
2940         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
2941         _safeTransfer(from, to, tokenId, data);
2942     }
2943 
2944     /**
2945      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2946      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2947      *
2948      * `data` is additional data, it has no specified format and it is sent in call to `to`.
2949      *
2950      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2951      * implement alternative mechanisms to perform token transfer, such as signature-based.
2952      *
2953      * Requirements:
2954      *
2955      * - `from` cannot be the zero address.
2956      * - `to` cannot be the zero address.
2957      * - `tokenId` token must exist and be owned by `from`.
2958      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2959      *
2960      * Emits a {Transfer} event.
2961      */
2962     function _safeTransfer(
2963         address from,
2964         address to,
2965         uint256 tokenId,
2966         bytes memory data
2967     ) internal virtual {
2968         _transfer(from, to, tokenId);
2969         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
2970     }
2971 
2972     /**
2973      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
2974      */
2975     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
2976         return _owners[tokenId];
2977     }
2978 
2979     /**
2980      * @dev Returns whether `tokenId` exists.
2981      *
2982      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2983      *
2984      * Tokens start existing when they are minted (`_mint`),
2985      * and stop existing when they are burned (`_burn`).
2986      */
2987     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2988         return _ownerOf(tokenId) != address(0);
2989     }
2990 
2991     /**
2992      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2993      *
2994      * Requirements:
2995      *
2996      * - `tokenId` must exist.
2997      */
2998     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2999         address owner = ERC721.ownerOf(tokenId);
3000         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
3001     }
3002 
3003     /**
3004      * @dev Safely mints `tokenId` and transfers it to `to`.
3005      *
3006      * Requirements:
3007      *
3008      * - `tokenId` must not exist.
3009      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
3010      *
3011      * Emits a {Transfer} event.
3012      */
3013     function _safeMint(address to, uint256 tokenId) internal virtual {
3014         _safeMint(to, tokenId, "");
3015     }
3016 
3017     /**
3018      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
3019      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
3020      */
3021     function _safeMint(
3022         address to,
3023         uint256 tokenId,
3024         bytes memory data
3025     ) internal virtual {
3026         _mint(to, tokenId);
3027         require(
3028             _checkOnERC721Received(address(0), to, tokenId, data),
3029             "ERC721: transfer to non ERC721Receiver implementer"
3030         );
3031     }
3032 
3033     /**
3034      * @dev Mints `tokenId` and transfers it to `to`.
3035      *
3036      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
3037      *
3038      * Requirements:
3039      *
3040      * - `tokenId` must not exist.
3041      * - `to` cannot be the zero address.
3042      *
3043      * Emits a {Transfer} event.
3044      */
3045     function _mint(address to, uint256 tokenId) internal virtual {
3046         require(to != address(0), "ERC721: mint to the zero address");
3047         require(!_exists(tokenId), "ERC721: token already minted");
3048 
3049         _beforeTokenTransfer(address(0), to, tokenId, 1);
3050 
3051         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
3052         require(!_exists(tokenId), "ERC721: token already minted");
3053 
3054         unchecked {
3055             // Will not overflow unless all 2**256 token ids are minted to the same owner.
3056             // Given that tokens are minted one by one, it is impossible in practice that
3057             // this ever happens. Might change if we allow batch minting.
3058             // The ERC fails to describe this case.
3059             _balances[to] += 1;
3060         }
3061 
3062         _owners[tokenId] = to;
3063 
3064         emit Transfer(address(0), to, tokenId);
3065 
3066         _afterTokenTransfer(address(0), to, tokenId, 1);
3067     }
3068 
3069     /**
3070      * @dev Destroys `tokenId`.
3071      * The approval is cleared when the token is burned.
3072      * This is an internal function that does not check if the sender is authorized to operate on the token.
3073      *
3074      * Requirements:
3075      *
3076      * - `tokenId` must exist.
3077      *
3078      * Emits a {Transfer} event.
3079      */
3080     function _burn(uint256 tokenId) internal virtual {
3081         address owner = ERC721.ownerOf(tokenId);
3082 
3083         _beforeTokenTransfer(owner, address(0), tokenId, 1);
3084 
3085         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
3086         owner = ERC721.ownerOf(tokenId);
3087 
3088         // Clear approvals
3089         delete _tokenApprovals[tokenId];
3090 
3091         unchecked {
3092             // Cannot overflow, as that would require more tokens to be burned/transferred
3093             // out than the owner initially received through minting and transferring in.
3094             _balances[owner] -= 1;
3095         }
3096         delete _owners[tokenId];
3097 
3098         emit Transfer(owner, address(0), tokenId);
3099 
3100         _afterTokenTransfer(owner, address(0), tokenId, 1);
3101     }
3102 
3103     /**
3104      * @dev Transfers `tokenId` from `from` to `to`.
3105      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
3106      *
3107      * Requirements:
3108      *
3109      * - `to` cannot be the zero address.
3110      * - `tokenId` token must be owned by `from`.
3111      *
3112      * Emits a {Transfer} event.
3113      */
3114     function _transfer(
3115         address from,
3116         address to,
3117         uint256 tokenId
3118     ) internal virtual {
3119         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
3120         require(to != address(0), "ERC721: transfer to the zero address");
3121 
3122         _beforeTokenTransfer(from, to, tokenId, 1);
3123 
3124         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
3125         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
3126 
3127         // Clear approvals from the previous owner
3128         delete _tokenApprovals[tokenId];
3129 
3130         unchecked {
3131             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
3132             // `from`'s balance is the number of token held, which is at least one before the current
3133             // transfer.
3134             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
3135             // all 2**256 token ids to be minted, which in practice is impossible.
3136             _balances[from] -= 1;
3137             _balances[to] += 1;
3138         }
3139         _owners[tokenId] = to;
3140 
3141         emit Transfer(from, to, tokenId);
3142 
3143         _afterTokenTransfer(from, to, tokenId, 1);
3144     }
3145 
3146     /**
3147      * @dev Approve `to` to operate on `tokenId`
3148      *
3149      * Emits an {Approval} event.
3150      */
3151     function _approve(address to, uint256 tokenId) internal virtual {
3152         _tokenApprovals[tokenId] = to;
3153         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
3154     }
3155 
3156     /**
3157      * @dev Approve `operator` to operate on all of `owner` tokens
3158      *
3159      * Emits an {ApprovalForAll} event.
3160      */
3161     function _setApprovalForAll(
3162         address owner,
3163         address operator,
3164         bool approved
3165     ) internal virtual {
3166         require(owner != operator, "ERC721: approve to caller");
3167         _operatorApprovals[owner][operator] = approved;
3168         emit ApprovalForAll(owner, operator, approved);
3169     }
3170 
3171     /**
3172      * @dev Reverts if the `tokenId` has not been minted yet.
3173      */
3174     function _requireMinted(uint256 tokenId) internal view virtual {
3175         require(_exists(tokenId), "ERC721: invalid token ID");
3176     }
3177 
3178     /**
3179      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
3180      * The call is not executed if the target address is not a contract.
3181      *
3182      * @param from address representing the previous owner of the given token ID
3183      * @param to target address that will receive the tokens
3184      * @param tokenId uint256 ID of the token to be transferred
3185      * @param data bytes optional data to send along with the call
3186      * @return bool whether the call correctly returned the expected magic value
3187      */
3188     function _checkOnERC721Received(
3189         address from,
3190         address to,
3191         uint256 tokenId,
3192         bytes memory data
3193     ) private returns (bool) {
3194         if (to.isContract()) {
3195             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
3196                 return retval == IERC721Receiver.onERC721Received.selector;
3197             } catch (bytes memory reason) {
3198                 if (reason.length == 0) {
3199                     revert("ERC721: transfer to non ERC721Receiver implementer");
3200                 } else {
3201                     /// @solidity memory-safe-assembly
3202                     assembly {
3203                         revert(add(32, reason), mload(reason))
3204                     }
3205                 }
3206             }
3207         } else {
3208             return true;
3209         }
3210     }
3211 
3212     /**
3213      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
3214      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
3215      *
3216      * Calling conditions:
3217      *
3218      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
3219      * - When `from` is zero, the tokens will be minted for `to`.
3220      * - When `to` is zero, ``from``'s tokens will be burned.
3221      * - `from` and `to` are never both zero.
3222      * - `batchSize` is non-zero.
3223      *
3224      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3225      */
3226     function _beforeTokenTransfer(
3227         address from,
3228         address to,
3229         uint256, /* firstTokenId */
3230         uint256 batchSize
3231     ) internal virtual {
3232         if (batchSize > 1) {
3233             if (from != address(0)) {
3234                 _balances[from] -= batchSize;
3235             }
3236             if (to != address(0)) {
3237                 _balances[to] += batchSize;
3238             }
3239         }
3240     }
3241 
3242     /**
3243      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
3244      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
3245      *
3246      * Calling conditions:
3247      *
3248      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
3249      * - When `from` is zero, the tokens were minted for `to`.
3250      * - When `to` is zero, ``from``'s tokens were burned.
3251      * - `from` and `to` are never both zero.
3252      * - `batchSize` is non-zero.
3253      *
3254      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3255      */
3256     function _afterTokenTransfer(
3257         address from,
3258         address to,
3259         uint256 firstTokenId,
3260         uint256 batchSize
3261     ) internal virtual {}
3262 }
3263 
3264 // File: contracts/SpoiledBananaSocietyPlayoffsSeasonOne.sol
3265 
3266 
3267 pragma solidity ^0.8.9;
3268 
3269 
3270 
3271 
3272 
3273 
3274 /**
3275  *    .--.--.       ,---,.   .--.--.
3276  *   /  /    '.   ,'  .'  \ /  /    '.
3277  *  |  :  /`. / ,---.' .' ||  :  /`. /
3278  *  ;  |  |--`  |   |  |: |;  |  |--`
3279  *  |  :  ;_    :   :  :  /|  :  ;_
3280  *   \  \    `. :   |    ;  \  \    `.
3281  *    `----.   \|   :     \  `----.   \
3282  *    __ \  \  ||   |   . |  __ \  \  |
3283  *   /  /`--'  /'   :  '; | /  /`--'  /
3284  *  '--'.     / |   |  | ; '--'.     /
3285  *    `--'---'  |   :   /    `--'---'
3286  *              |   | ,'
3287  *              `----'
3288  * @title Spoiled Banana Society ERC-721 Smart Contract
3289  */
3290 
3291 contract SpoiledBananaSocietyPlayoffsSeasonOne is ERC721, Ownable, Pausable, ReentrancyGuard {
3292 
3293     string public SPOILEDBANANASOCIETY_PROVENANCE = "";
3294     string private baseURI;
3295     uint256 public MAX_TOKENS = 15000;
3296     uint256 public constant RESERVED_TOKENS = 20;
3297     uint256 public constant TOKEN_PRICE = 20000000000000000; // 0.08 ETH
3298     uint256 public constant MAX_TOKENS_PURCHASE = 20;
3299     uint256 public numTokensMinted = 10000;
3300     uint256 public numTokensBurned = 0;
3301 
3302     // PUBLIC MINT
3303     bool public mintIsActive = false;
3304 
3305     // WALLET BASED PRESALE MINT
3306     bool public presaleIsActive = false;
3307     mapping (address => bool) public presaleWalletList;
3308 
3309     // FREE WALLET BASED MINT
3310     bool public freeWalletIsActive = false;
3311     mapping (address => bool) public freeWalletList;
3312 
3313     constructor() ERC721("Spoiled Banana Society Playoffs Season #1", "SBS") {}
3314 
3315     // PUBLIC MINT
3316     function flipMintState() external onlyOwner {
3317         mintIsActive = !mintIsActive;
3318     }
3319 
3320     function setMaxTokens(uint256 amount) external onlyOwner {
3321         require(amount >= MAX_TOKENS, "You are setting the max number of tokens to an amount that is less than the current max");
3322         MAX_TOKENS = amount;
3323     }
3324 
3325     function mint(uint256 numberOfTokens) external payable nonReentrant {
3326         require(mintIsActive, "Mint is not active");
3327         require(numberOfTokens <= MAX_TOKENS_PURCHASE, "You went over max tokens per transaction");
3328         require(numTokensMinted + numberOfTokens <= MAX_TOKENS, "Not enough tokens left to mint that many");
3329         require(TOKEN_PRICE * numberOfTokens <= msg.value, "You sent the incorrect amount of ETH");
3330         for (uint256 i = 0; i < numberOfTokens; i++) {
3331             uint256 mintIndex = numTokensMinted;
3332             if (numTokensMinted < MAX_TOKENS) {
3333                 numTokensMinted++;
3334                 _safeMint(msg.sender, mintIndex);
3335             }
3336         }
3337     }
3338 
3339     // WALLET BASED PRESALE MINT
3340     function flipPresaleState() external onlyOwner {
3341 	    presaleIsActive = !presaleIsActive;
3342     }
3343 
3344     function initPresaleWalletList(address[] memory walletList) external onlyOwner {
3345 	    for (uint256 i = 0; i < walletList.length; i++) {
3346 		    presaleWalletList[walletList[i]] = true;
3347 	    }
3348     }
3349 
3350     function mintPresaleWalletList(uint256 numberOfTokens) external payable nonReentrant {
3351         require(presaleIsActive, "Mint is not active");
3352 	    require(numberOfTokens <= MAX_TOKENS_PURCHASE, "You went over max tokens per transaction");
3353 	    require(presaleWalletList[msg.sender] == true, "You are not on the presale wallet list or have already minted");
3354 	    require(numTokensMinted + numberOfTokens <= MAX_TOKENS, "Not enough tokens left to mint that many");
3355         require(TOKEN_PRICE * numberOfTokens <= msg.value, "You sent the incorrect amount of ETH");
3356 	    for (uint256 i = 0; i < numberOfTokens; i++) {
3357 		    uint256 mintIndex = numTokensMinted;
3358 		    if (numTokensMinted < MAX_TOKENS) {
3359 			    numTokensMinted++;
3360 			    _safeMint(msg.sender, mintIndex);
3361 		    }
3362 	    }
3363 	    presaleWalletList[msg.sender] = false;
3364     }
3365 
3366     // FREE WALLET BASED GIVEAWAY MINT - Only Mint One
3367     function flipFreeWalletState() external onlyOwner {
3368 	    freeWalletIsActive = !freeWalletIsActive;
3369     }
3370 
3371     function initFreeWalletList(address[] memory walletList) external onlyOwner {
3372 	    for (uint256 i = 0; i < walletList.length; i++) {
3373 		    freeWalletList[walletList[i]] = true;
3374 	    }
3375     }
3376 
3377     function mintFreeWalletList() external nonReentrant {
3378         require(freeWalletIsActive, "Mint is not active");
3379 	    require(freeWalletList[msg.sender] == true, "You are not on the free wallet list or have already minted");
3380 	    require(numTokensMinted + 1 <= MAX_TOKENS, "Not enough tokens left to mint that many");
3381 
3382         uint256 mintIndex = numTokensMinted;
3383         numTokensMinted++;
3384         _safeMint(msg.sender, mintIndex);
3385 
3386 	    freeWalletList[msg.sender] = false;
3387     }
3388 
3389     // TOTAL SUPPLY
3390     function totalSupply() external view returns (uint) { 
3391         return numTokensMinted - numTokensBurned;
3392     }
3393 
3394     // BURN IT 
3395     function burn(uint256 tokenId) public virtual {
3396 	    require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
3397 	    _burn(tokenId);
3398         numTokensBurned++;
3399     }
3400 
3401     // OWNER FUNCTIONS
3402     function withdraw() external onlyOwner {
3403         uint256 balance = address(this).balance;
3404         Address.sendValue(payable(owner()), balance);
3405     }
3406 
3407     function reserveTokens() external onlyOwner {
3408         uint256 mintIndex = numTokensMinted;
3409         for (uint256 i = 0; i < RESERVED_TOKENS; i++) {
3410             numTokensMinted++;
3411             _safeMint(msg.sender, mintIndex + i);
3412         }
3413     }
3414 
3415     function setPaused(bool _setPaused) external onlyOwner {
3416 	    return (_setPaused) ? _pause() : _unpause();
3417     }
3418 
3419     function _baseURI() internal view override returns (string memory) {
3420         return baseURI;
3421     }
3422 
3423     function setBaseURI(string memory uri) external onlyOwner {
3424         baseURI = uri;
3425     }
3426 
3427     function setProvenanceHash(string memory provenanceHash) external onlyOwner {
3428         SPOILEDBANANASOCIETY_PROVENANCE = provenanceHash;
3429     }
3430 
3431 }