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
1536 // File: @openzeppelin/contracts/utils/Context.sol
1537 
1538 
1539 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1540 
1541 pragma solidity ^0.8.0;
1542 
1543 /**
1544  * @dev Provides information about the current execution context, including the
1545  * sender of the transaction and its data. While these are generally available
1546  * via msg.sender and msg.data, they should not be accessed in such a direct
1547  * manner, since when dealing with meta-transactions the account sending and
1548  * paying for execution may not be the actual sender (as far as an application
1549  * is concerned).
1550  *
1551  * This contract is only required for intermediate, library-like contracts.
1552  */
1553 abstract contract Context {
1554     function _msgSender() internal view virtual returns (address) {
1555         return msg.sender;
1556     }
1557 
1558     function _msgData() internal view virtual returns (bytes calldata) {
1559         return msg.data;
1560     }
1561 }
1562 
1563 // File: @openzeppelin/contracts/access/Ownable.sol
1564 
1565 
1566 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1567 
1568 pragma solidity ^0.8.0;
1569 
1570 
1571 /**
1572  * @dev Contract module which provides a basic access control mechanism, where
1573  * there is an account (an owner) that can be granted exclusive access to
1574  * specific functions.
1575  *
1576  * By default, the owner account will be the one that deploys the contract. This
1577  * can later be changed with {transferOwnership}.
1578  *
1579  * This module is used through inheritance. It will make available the modifier
1580  * `onlyOwner`, which can be applied to your functions to restrict their use to
1581  * the owner.
1582  */
1583 abstract contract Ownable is Context {
1584     address private _owner;
1585 
1586     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1587 
1588     /**
1589      * @dev Initializes the contract setting the deployer as the initial owner.
1590      */
1591     constructor() {
1592         _transferOwnership(_msgSender());
1593     }
1594 
1595     /**
1596      * @dev Throws if called by any account other than the owner.
1597      */
1598     modifier onlyOwner() {
1599         _checkOwner();
1600         _;
1601     }
1602 
1603     /**
1604      * @dev Returns the address of the current owner.
1605      */
1606     function owner() public view virtual returns (address) {
1607         return _owner;
1608     }
1609 
1610     /**
1611      * @dev Throws if the sender is not the owner.
1612      */
1613     function _checkOwner() internal view virtual {
1614         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1615     }
1616 
1617     /**
1618      * @dev Leaves the contract without owner. It will not be possible to call
1619      * `onlyOwner` functions anymore. Can only be called by the current owner.
1620      *
1621      * NOTE: Renouncing ownership will leave the contract without an owner,
1622      * thereby removing any functionality that is only available to the owner.
1623      */
1624     function renounceOwnership() public virtual onlyOwner {
1625         _transferOwnership(address(0));
1626     }
1627 
1628     /**
1629      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1630      * Can only be called by the current owner.
1631      */
1632     function transferOwnership(address newOwner) public virtual onlyOwner {
1633         require(newOwner != address(0), "Ownable: new owner is the zero address");
1634         _transferOwnership(newOwner);
1635     }
1636 
1637     /**
1638      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1639      * Internal function without access restriction.
1640      */
1641     function _transferOwnership(address newOwner) internal virtual {
1642         address oldOwner = _owner;
1643         _owner = newOwner;
1644         emit OwnershipTransferred(oldOwner, newOwner);
1645     }
1646 }
1647 
1648 // File: @openzeppelin/contracts/utils/Address.sol
1649 
1650 
1651 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
1652 
1653 pragma solidity ^0.8.1;
1654 
1655 /**
1656  * @dev Collection of functions related to the address type
1657  */
1658 library Address {
1659     /**
1660      * @dev Returns true if `account` is a contract.
1661      *
1662      * [IMPORTANT]
1663      * ====
1664      * It is unsafe to assume that an address for which this function returns
1665      * false is an externally-owned account (EOA) and not a contract.
1666      *
1667      * Among others, `isContract` will return false for the following
1668      * types of addresses:
1669      *
1670      *  - an externally-owned account
1671      *  - a contract in construction
1672      *  - an address where a contract will be created
1673      *  - an address where a contract lived, but was destroyed
1674      * ====
1675      *
1676      * [IMPORTANT]
1677      * ====
1678      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1679      *
1680      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1681      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1682      * constructor.
1683      * ====
1684      */
1685     function isContract(address account) internal view returns (bool) {
1686         // This method relies on extcodesize/address.code.length, which returns 0
1687         // for contracts in construction, since the code is only stored at the end
1688         // of the constructor execution.
1689 
1690         return account.code.length > 0;
1691     }
1692 
1693     /**
1694      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1695      * `recipient`, forwarding all available gas and reverting on errors.
1696      *
1697      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1698      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1699      * imposed by `transfer`, making them unable to receive funds via
1700      * `transfer`. {sendValue} removes this limitation.
1701      *
1702      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1703      *
1704      * IMPORTANT: because control is transferred to `recipient`, care must be
1705      * taken to not create reentrancy vulnerabilities. Consider using
1706      * {ReentrancyGuard} or the
1707      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1708      */
1709     function sendValue(address payable recipient, uint256 amount) internal {
1710         require(address(this).balance >= amount, "Address: insufficient balance");
1711 
1712         (bool success, ) = recipient.call{value: amount}("");
1713         require(success, "Address: unable to send value, recipient may have reverted");
1714     }
1715 
1716     /**
1717      * @dev Performs a Solidity function call using a low level `call`. A
1718      * plain `call` is an unsafe replacement for a function call: use this
1719      * function instead.
1720      *
1721      * If `target` reverts with a revert reason, it is bubbled up by this
1722      * function (like regular Solidity function calls).
1723      *
1724      * Returns the raw returned data. To convert to the expected return value,
1725      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1726      *
1727      * Requirements:
1728      *
1729      * - `target` must be a contract.
1730      * - calling `target` with `data` must not revert.
1731      *
1732      * _Available since v3.1._
1733      */
1734     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1735         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
1736     }
1737 
1738     /**
1739      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1740      * `errorMessage` as a fallback revert reason when `target` reverts.
1741      *
1742      * _Available since v3.1._
1743      */
1744     function functionCall(
1745         address target,
1746         bytes memory data,
1747         string memory errorMessage
1748     ) internal returns (bytes memory) {
1749         return functionCallWithValue(target, data, 0, errorMessage);
1750     }
1751 
1752     /**
1753      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1754      * but also transferring `value` wei to `target`.
1755      *
1756      * Requirements:
1757      *
1758      * - the calling contract must have an ETH balance of at least `value`.
1759      * - the called Solidity function must be `payable`.
1760      *
1761      * _Available since v3.1._
1762      */
1763     function functionCallWithValue(
1764         address target,
1765         bytes memory data,
1766         uint256 value
1767     ) internal returns (bytes memory) {
1768         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1769     }
1770 
1771     /**
1772      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1773      * with `errorMessage` as a fallback revert reason when `target` reverts.
1774      *
1775      * _Available since v3.1._
1776      */
1777     function functionCallWithValue(
1778         address target,
1779         bytes memory data,
1780         uint256 value,
1781         string memory errorMessage
1782     ) internal returns (bytes memory) {
1783         require(address(this).balance >= value, "Address: insufficient balance for call");
1784         (bool success, bytes memory returndata) = target.call{value: value}(data);
1785         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1786     }
1787 
1788     /**
1789      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1790      * but performing a static call.
1791      *
1792      * _Available since v3.3._
1793      */
1794     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1795         return functionStaticCall(target, data, "Address: low-level static call failed");
1796     }
1797 
1798     /**
1799      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1800      * but performing a static call.
1801      *
1802      * _Available since v3.3._
1803      */
1804     function functionStaticCall(
1805         address target,
1806         bytes memory data,
1807         string memory errorMessage
1808     ) internal view returns (bytes memory) {
1809         (bool success, bytes memory returndata) = target.staticcall(data);
1810         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1811     }
1812 
1813     /**
1814      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1815      * but performing a delegate call.
1816      *
1817      * _Available since v3.4._
1818      */
1819     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1820         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1821     }
1822 
1823     /**
1824      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1825      * but performing a delegate call.
1826      *
1827      * _Available since v3.4._
1828      */
1829     function functionDelegateCall(
1830         address target,
1831         bytes memory data,
1832         string memory errorMessage
1833     ) internal returns (bytes memory) {
1834         (bool success, bytes memory returndata) = target.delegatecall(data);
1835         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1836     }
1837 
1838     /**
1839      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1840      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1841      *
1842      * _Available since v4.8._
1843      */
1844     function verifyCallResultFromTarget(
1845         address target,
1846         bool success,
1847         bytes memory returndata,
1848         string memory errorMessage
1849     ) internal view returns (bytes memory) {
1850         if (success) {
1851             if (returndata.length == 0) {
1852                 // only check isContract if the call was successful and the return data is empty
1853                 // otherwise we already know that it was a contract
1854                 require(isContract(target), "Address: call to non-contract");
1855             }
1856             return returndata;
1857         } else {
1858             _revert(returndata, errorMessage);
1859         }
1860     }
1861 
1862     /**
1863      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1864      * revert reason or using the provided one.
1865      *
1866      * _Available since v4.3._
1867      */
1868     function verifyCallResult(
1869         bool success,
1870         bytes memory returndata,
1871         string memory errorMessage
1872     ) internal pure returns (bytes memory) {
1873         if (success) {
1874             return returndata;
1875         } else {
1876             _revert(returndata, errorMessage);
1877         }
1878     }
1879 
1880     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1881         // Look for revert reason and bubble it up if present
1882         if (returndata.length > 0) {
1883             // The easiest way to bubble the revert reason is using memory via assembly
1884             /// @solidity memory-safe-assembly
1885             assembly {
1886                 let returndata_size := mload(returndata)
1887                 revert(add(32, returndata), returndata_size)
1888             }
1889         } else {
1890             revert(errorMessage);
1891         }
1892     }
1893 }
1894 
1895 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
1896 
1897 
1898 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
1899 
1900 pragma solidity ^0.8.0;
1901 
1902 /**
1903  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1904  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1905  *
1906  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1907  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
1908  * need to send a transaction, and thus is not required to hold Ether at all.
1909  */
1910 interface IERC20Permit {
1911     /**
1912      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
1913      * given ``owner``'s signed approval.
1914      *
1915      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
1916      * ordering also apply here.
1917      *
1918      * Emits an {Approval} event.
1919      *
1920      * Requirements:
1921      *
1922      * - `spender` cannot be the zero address.
1923      * - `deadline` must be a timestamp in the future.
1924      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
1925      * over the EIP712-formatted function arguments.
1926      * - the signature must use ``owner``'s current nonce (see {nonces}).
1927      *
1928      * For more information on the signature format, see the
1929      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
1930      * section].
1931      */
1932     function permit(
1933         address owner,
1934         address spender,
1935         uint256 value,
1936         uint256 deadline,
1937         uint8 v,
1938         bytes32 r,
1939         bytes32 s
1940     ) external;
1941 
1942     /**
1943      * @dev Returns the current nonce for `owner`. This value must be
1944      * included whenever a signature is generated for {permit}.
1945      *
1946      * Every successful call to {permit} increases ``owner``'s nonce by one. This
1947      * prevents a signature from being used multiple times.
1948      */
1949     function nonces(address owner) external view returns (uint256);
1950 
1951     /**
1952      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
1953      */
1954     // solhint-disable-next-line func-name-mixedcase
1955     function DOMAIN_SEPARATOR() external view returns (bytes32);
1956 }
1957 
1958 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1959 
1960 
1961 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1962 
1963 pragma solidity ^0.8.0;
1964 
1965 /**
1966  * @dev Interface of the ERC20 standard as defined in the EIP.
1967  */
1968 interface IERC20 {
1969     /**
1970      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1971      * another (`to`).
1972      *
1973      * Note that `value` may be zero.
1974      */
1975     event Transfer(address indexed from, address indexed to, uint256 value);
1976 
1977     /**
1978      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1979      * a call to {approve}. `value` is the new allowance.
1980      */
1981     event Approval(address indexed owner, address indexed spender, uint256 value);
1982 
1983     /**
1984      * @dev Returns the amount of tokens in existence.
1985      */
1986     function totalSupply() external view returns (uint256);
1987 
1988     /**
1989      * @dev Returns the amount of tokens owned by `account`.
1990      */
1991     function balanceOf(address account) external view returns (uint256);
1992 
1993     /**
1994      * @dev Moves `amount` tokens from the caller's account to `to`.
1995      *
1996      * Returns a boolean value indicating whether the operation succeeded.
1997      *
1998      * Emits a {Transfer} event.
1999      */
2000     function transfer(address to, uint256 amount) external returns (bool);
2001 
2002     /**
2003      * @dev Returns the remaining number of tokens that `spender` will be
2004      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2005      * zero by default.
2006      *
2007      * This value changes when {approve} or {transferFrom} are called.
2008      */
2009     function allowance(address owner, address spender) external view returns (uint256);
2010 
2011     /**
2012      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2013      *
2014      * Returns a boolean value indicating whether the operation succeeded.
2015      *
2016      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2017      * that someone may use both the old and the new allowance by unfortunate
2018      * transaction ordering. One possible solution to mitigate this race
2019      * condition is to first reduce the spender's allowance to 0 and set the
2020      * desired value afterwards:
2021      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2022      *
2023      * Emits an {Approval} event.
2024      */
2025     function approve(address spender, uint256 amount) external returns (bool);
2026 
2027     /**
2028      * @dev Moves `amount` tokens from `from` to `to` using the
2029      * allowance mechanism. `amount` is then deducted from the caller's
2030      * allowance.
2031      *
2032      * Returns a boolean value indicating whether the operation succeeded.
2033      *
2034      * Emits a {Transfer} event.
2035      */
2036     function transferFrom(
2037         address from,
2038         address to,
2039         uint256 amount
2040     ) external returns (bool);
2041 }
2042 
2043 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
2044 
2045 
2046 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)
2047 
2048 pragma solidity ^0.8.0;
2049 
2050 
2051 
2052 
2053 /**
2054  * @title SafeERC20
2055  * @dev Wrappers around ERC20 operations that throw on failure (when the token
2056  * contract returns false). Tokens that return no value (and instead revert or
2057  * throw on failure) are also supported, non-reverting calls are assumed to be
2058  * successful.
2059  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
2060  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
2061  */
2062 library SafeERC20 {
2063     using Address for address;
2064 
2065     function safeTransfer(
2066         IERC20 token,
2067         address to,
2068         uint256 value
2069     ) internal {
2070         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
2071     }
2072 
2073     function safeTransferFrom(
2074         IERC20 token,
2075         address from,
2076         address to,
2077         uint256 value
2078     ) internal {
2079         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
2080     }
2081 
2082     /**
2083      * @dev Deprecated. This function has issues similar to the ones found in
2084      * {IERC20-approve}, and its usage is discouraged.
2085      *
2086      * Whenever possible, use {safeIncreaseAllowance} and
2087      * {safeDecreaseAllowance} instead.
2088      */
2089     function safeApprove(
2090         IERC20 token,
2091         address spender,
2092         uint256 value
2093     ) internal {
2094         // safeApprove should only be called when setting an initial allowance,
2095         // or when resetting it to zero. To increase and decrease it, use
2096         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
2097         require(
2098             (value == 0) || (token.allowance(address(this), spender) == 0),
2099             "SafeERC20: approve from non-zero to non-zero allowance"
2100         );
2101         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
2102     }
2103 
2104     function safeIncreaseAllowance(
2105         IERC20 token,
2106         address spender,
2107         uint256 value
2108     ) internal {
2109         uint256 newAllowance = token.allowance(address(this), spender) + value;
2110         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2111     }
2112 
2113     function safeDecreaseAllowance(
2114         IERC20 token,
2115         address spender,
2116         uint256 value
2117     ) internal {
2118         unchecked {
2119             uint256 oldAllowance = token.allowance(address(this), spender);
2120             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
2121             uint256 newAllowance = oldAllowance - value;
2122             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2123         }
2124     }
2125 
2126     function safePermit(
2127         IERC20Permit token,
2128         address owner,
2129         address spender,
2130         uint256 value,
2131         uint256 deadline,
2132         uint8 v,
2133         bytes32 r,
2134         bytes32 s
2135     ) internal {
2136         uint256 nonceBefore = token.nonces(owner);
2137         token.permit(owner, spender, value, deadline, v, r, s);
2138         uint256 nonceAfter = token.nonces(owner);
2139         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
2140     }
2141 
2142     /**
2143      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
2144      * on the return value: the return value is optional (but if data is returned, it must not be false).
2145      * @param token The token targeted by the call.
2146      * @param data The call data (encoded using abi.encode or one of its variants).
2147      */
2148     function _callOptionalReturn(IERC20 token, bytes memory data) private {
2149         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
2150         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
2151         // the target address contains contract code and also asserts for success in the low-level call.
2152 
2153         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
2154         if (returndata.length > 0) {
2155             // Return data is optional
2156             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
2157         }
2158     }
2159 }
2160 
2161 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2162 
2163 
2164 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
2165 
2166 pragma solidity ^0.8.0;
2167 
2168 /**
2169  * @dev These functions deal with verification of Merkle Tree proofs.
2170  *
2171  * The tree and the proofs can be generated using our
2172  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
2173  * You will find a quickstart guide in the readme.
2174  *
2175  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
2176  * hashing, or use a hash function other than keccak256 for hashing leaves.
2177  * This is because the concatenation of a sorted pair of internal nodes in
2178  * the merkle tree could be reinterpreted as a leaf value.
2179  * OpenZeppelin's JavaScript library generates merkle trees that are safe
2180  * against this attack out of the box.
2181  */
2182 library MerkleProof {
2183     /**
2184      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
2185      * defined by `root`. For this, a `proof` must be provided, containing
2186      * sibling hashes on the branch from the leaf to the root of the tree. Each
2187      * pair of leaves and each pair of pre-images are assumed to be sorted.
2188      */
2189     function verify(
2190         bytes32[] memory proof,
2191         bytes32 root,
2192         bytes32 leaf
2193     ) internal pure returns (bool) {
2194         return processProof(proof, leaf) == root;
2195     }
2196 
2197     /**
2198      * @dev Calldata version of {verify}
2199      *
2200      * _Available since v4.7._
2201      */
2202     function verifyCalldata(
2203         bytes32[] calldata proof,
2204         bytes32 root,
2205         bytes32 leaf
2206     ) internal pure returns (bool) {
2207         return processProofCalldata(proof, leaf) == root;
2208     }
2209 
2210     /**
2211      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
2212      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
2213      * hash matches the root of the tree. When processing the proof, the pairs
2214      * of leafs & pre-images are assumed to be sorted.
2215      *
2216      * _Available since v4.4._
2217      */
2218     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
2219         bytes32 computedHash = leaf;
2220         for (uint256 i = 0; i < proof.length; i++) {
2221             computedHash = _hashPair(computedHash, proof[i]);
2222         }
2223         return computedHash;
2224     }
2225 
2226     /**
2227      * @dev Calldata version of {processProof}
2228      *
2229      * _Available since v4.7._
2230      */
2231     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
2232         bytes32 computedHash = leaf;
2233         for (uint256 i = 0; i < proof.length; i++) {
2234             computedHash = _hashPair(computedHash, proof[i]);
2235         }
2236         return computedHash;
2237     }
2238 
2239     /**
2240      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
2241      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
2242      *
2243      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
2244      *
2245      * _Available since v4.7._
2246      */
2247     function multiProofVerify(
2248         bytes32[] memory proof,
2249         bool[] memory proofFlags,
2250         bytes32 root,
2251         bytes32[] memory leaves
2252     ) internal pure returns (bool) {
2253         return processMultiProof(proof, proofFlags, leaves) == root;
2254     }
2255 
2256     /**
2257      * @dev Calldata version of {multiProofVerify}
2258      *
2259      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
2260      *
2261      * _Available since v4.7._
2262      */
2263     function multiProofVerifyCalldata(
2264         bytes32[] calldata proof,
2265         bool[] calldata proofFlags,
2266         bytes32 root,
2267         bytes32[] memory leaves
2268     ) internal pure returns (bool) {
2269         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
2270     }
2271 
2272     /**
2273      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
2274      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
2275      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
2276      * respectively.
2277      *
2278      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
2279      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
2280      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
2281      *
2282      * _Available since v4.7._
2283      */
2284     function processMultiProof(
2285         bytes32[] memory proof,
2286         bool[] memory proofFlags,
2287         bytes32[] memory leaves
2288     ) internal pure returns (bytes32 merkleRoot) {
2289         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
2290         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
2291         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
2292         // the merkle tree.
2293         uint256 leavesLen = leaves.length;
2294         uint256 totalHashes = proofFlags.length;
2295 
2296         // Check proof validity.
2297         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
2298 
2299         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
2300         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
2301         bytes32[] memory hashes = new bytes32[](totalHashes);
2302         uint256 leafPos = 0;
2303         uint256 hashPos = 0;
2304         uint256 proofPos = 0;
2305         // At each step, we compute the next hash using two values:
2306         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
2307         //   get the next hash.
2308         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
2309         //   `proof` array.
2310         for (uint256 i = 0; i < totalHashes; i++) {
2311             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
2312             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
2313             hashes[i] = _hashPair(a, b);
2314         }
2315 
2316         if (totalHashes > 0) {
2317             return hashes[totalHashes - 1];
2318         } else if (leavesLen > 0) {
2319             return leaves[0];
2320         } else {
2321             return proof[0];
2322         }
2323     }
2324 
2325     /**
2326      * @dev Calldata version of {processMultiProof}.
2327      *
2328      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
2329      *
2330      * _Available since v4.7._
2331      */
2332     function processMultiProofCalldata(
2333         bytes32[] calldata proof,
2334         bool[] calldata proofFlags,
2335         bytes32[] memory leaves
2336     ) internal pure returns (bytes32 merkleRoot) {
2337         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
2338         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
2339         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
2340         // the merkle tree.
2341         uint256 leavesLen = leaves.length;
2342         uint256 totalHashes = proofFlags.length;
2343 
2344         // Check proof validity.
2345         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
2346 
2347         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
2348         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
2349         bytes32[] memory hashes = new bytes32[](totalHashes);
2350         uint256 leafPos = 0;
2351         uint256 hashPos = 0;
2352         uint256 proofPos = 0;
2353         // At each step, we compute the next hash using two values:
2354         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
2355         //   get the next hash.
2356         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
2357         //   `proof` array.
2358         for (uint256 i = 0; i < totalHashes; i++) {
2359             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
2360             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
2361             hashes[i] = _hashPair(a, b);
2362         }
2363 
2364         if (totalHashes > 0) {
2365             return hashes[totalHashes - 1];
2366         } else if (leavesLen > 0) {
2367             return leaves[0];
2368         } else {
2369             return proof[0];
2370         }
2371     }
2372 
2373     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
2374         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
2375     }
2376 
2377     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
2378         /// @solidity memory-safe-assembly
2379         assembly {
2380             mstore(0x00, a)
2381             mstore(0x20, b)
2382             value := keccak256(0x00, 0x40)
2383         }
2384     }
2385 }
2386 
2387 // File: parapad.sol
2388 
2389 
2390 pragma solidity ^0.8.4;
2391 
2392 
2393 
2394 
2395 
2396 
2397 contract Parapad is Ownable {
2398     using SafeERC20 for IERC20; 
2399 
2400     address public usdtAddress;
2401     address public paradoxAddress;
2402 
2403     IERC20 internal para;
2404     IERC20 internal usdt;
2405 
2406     mapping(address => bool) public _claimed;
2407 
2408     uint256 constant internal PARADOX_DECIMALS = 10 ** 18;
2409     uint256 constant internal USDT_DECIMALS = 10 ** 6;
2410     
2411     uint256 constant internal EXCHANGE_RATE = 3;
2412     uint256 constant internal EXCHANGE_RATE_DENOMINATOR = 100;
2413 
2414     uint256 constant internal MONTH = 4 weeks;
2415 
2416     /** MAXIMUM OF $1000 per person */
2417     uint256 constant internal MAX_AMOUNT = 1000 * USDT_DECIMALS;
2418 
2419     mapping(address => Lock) public locks;
2420 
2421     struct Lock {
2422         uint256 total;
2423         uint256 paid;
2424         uint256 debt;
2425         uint256 startTime;
2426     }
2427 
2428     constructor (address _usdt, address _paradox) {
2429         usdtAddress = _usdt;
2430         usdt = IERC20(_usdt);
2431 
2432         paradoxAddress = _paradox;
2433         para = IERC20(_paradox);
2434     }
2435 
2436     function getClaimed(address _user) external view returns (bool) {
2437         return _claimed[_user];
2438     }
2439 
2440     function buyParadox(
2441         uint256 amount
2442     ) external {
2443         require(!_claimed[msg.sender], "Limit reached");
2444         require(amount <= MAX_AMOUNT, "Wrong amount");
2445         // get exchange rate to para
2446         uint256 rate = amount * EXCHANGE_RATE_DENOMINATOR * PARADOX_DECIMALS / (USDT_DECIMALS * EXCHANGE_RATE);
2447         require(rate <= para.balanceOf(address(this)), "Low balance");
2448         // give user 20% now
2449         uint256 rateNow = rate * 20 / 100;
2450         uint256 vestingRate = rate - rateNow;
2451 
2452         if (locks[msg.sender].total == 0) {
2453             // new claim
2454             locks[msg.sender] = Lock({
2455                 total: vestingRate,
2456                 paid: amount,
2457                 debt: 0,
2458                 startTime: block.timestamp
2459             });
2460 
2461             if (amount == MAX_AMOUNT) _claimed[msg.sender] = true;
2462         } else {
2463             // at this point, the user still has some pending amount they can claim
2464             require(amount + locks[msg.sender].paid <= MAX_AMOUNT, "Too Much");
2465 
2466             locks[msg.sender].total += vestingRate;
2467             if (amount + locks[msg.sender].paid == MAX_AMOUNT) _claimed[msg.sender] = true;
2468             locks[msg.sender].paid += amount;
2469         }
2470 
2471         usdt.safeTransferFrom(msg.sender, address(this), amount);
2472         para.safeTransfer(msg.sender, rateNow);
2473     }
2474 
2475     // New Function
2476     function pendingVestedParadox(address _user) external view returns(uint256) {
2477         Lock memory userLock = locks[_user];
2478 
2479         uint256 monthsPassed = (block.timestamp - userLock.startTime) / 4 weeks;
2480         /** @notice 5% released each MONTH after 2 MONTHs */ 
2481         uint256 monthlyRelease = userLock.total * 5 / 100;
2482         uint256 release;
2483         for (uint256 i = 0; i < monthsPassed; i++) {
2484             if (i >= 2) {
2485                 if (release >= userLock.total) {
2486                     release = userLock.total;
2487                     break;
2488                 }
2489                 release += monthlyRelease;
2490             }
2491         }
2492 
2493         return release - userLock.debt;
2494     }
2495  
2496     // New Function
2497     function claimVestedParadox() external {
2498         Lock storage userLock = locks[msg.sender];
2499         require(userLock.total > userLock.debt, "Vesting Complete");
2500 
2501         uint256 monthsPassed = (block.timestamp - userLock.startTime) / 4 weeks;
2502         /** @notice 5% released each MONTH after 2 MONTHs */
2503         uint256 monthlyRelease = userLock.total * 5 / 100;
2504 
2505         uint256 release;
2506         for (uint256 i = 0; i < monthsPassed; i++) {
2507             if (i >= 2) {
2508                 if (release >= userLock.total) {
2509                     release = userLock.total;
2510                     break;
2511                 }
2512                 release += monthlyRelease;
2513             }
2514         }
2515 
2516         uint256 reward = release - userLock.debt;
2517         userLock.debt += reward;
2518         para.transfer(msg.sender, reward);
2519     }
2520 
2521     function withdrawTether(address _destination) external onlyOwner {
2522         usdt.safeTransfer(_destination, usdt.balanceOf(address(this)));
2523     }
2524 
2525     /** @notice EMERGENCY FUNCTIONS */
2526     function updateClaimed(address _user) external onlyOwner {
2527         _claimed[_user] = !_claimed[_user];
2528     }
2529 
2530     function updateUserLock(address _user, uint256 _total, uint256 _paid, uint256 _startTime) external onlyOwner {
2531         Lock storage lock = locks[_user];
2532         lock.total = _total;
2533         lock.paid = _paid;
2534         lock.startTime = _startTime;
2535     }
2536     
2537     function withdrawETH() external onlyOwner {
2538         address payable to = payable(msg.sender);
2539         to.transfer(address(this).balance);
2540     }
2541 
2542     function withdrawParadox() external onlyOwner {
2543         para.safeTransfer(msg.sender, para.balanceOf(address(this)));
2544     }
2545 }