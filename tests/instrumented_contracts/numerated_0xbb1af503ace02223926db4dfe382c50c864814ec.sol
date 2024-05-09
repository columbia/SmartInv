1 /**
2 CORIA code created @ 10/05/2020
3                                                             
4                                                                                                                                    
5                                                                                                                                                               
6 */
7 
8 pragma solidity 0.5.17;
9 
10 // Standar ERC Token Interface
11 contract ERC20Interface {
12     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
13    
14     function approve(address spender, uint tokens) public returns (bool success);
15     function totalSupply() public view returns (uint);
16    
17     function balanceOf(address tokenOwner) public view returns (uint balance);
18     function transfer(address to, uint tokens) public returns (bool success);
19     function transferFrom(address from, address to, uint tokens) public returns (bool success);
20      
21     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
22     event Transfer(address indexed from, address indexed to, uint tokens);
23     
24 }
25 
26 // ----------------------------------------------------------------------------
27 // Safe Math Library 
28 // ----------------------------------------------------------------------------
29 library SafeMath {
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33       }
34     
35       function add(uint256 a, uint256 b) internal pure returns (uint256) {
36         uint256 c = a + b;
37         assert(c >= a);
38         return c;
39       }
40     
41     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42         if (a == 0) {
43           return 0;
44         }
45         uint256 c = a * b;
46         assert(c / a == b);
47         return c;
48     }
49     
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a / b;
52         return c;
53     }
54     
55     function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
56         uint256 c = add(a,m);
57         uint256 d = sub(c,1);
58         return mul(div(d,m),m);
59     }
60 }
61 
62 library console {
63 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
64 
65 	function _sendLogPayload(bytes memory payload) private view {
66 		uint256 payloadLength = payload.length;
67 		address consoleAddress = CONSOLE_ADDRESS;
68 		assembly {
69 			let payloadStart := add(payload, 32)
70 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
71 		}
72 	}
73 
74 	function log() internal view {
75 		_sendLogPayload(abi.encodeWithSignature("log()"));
76 	}
77 
78 	function logInt(int p0) internal view {
79 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
80 	}
81 
82 	function logUint(uint p0) internal view {
83 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
84 	}
85 
86 	function logString(string memory p0) internal view {
87 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
88 	}
89 
90 	function logBool(bool p0) internal view {
91 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
92 	}
93 
94 	function logAddress(address p0) internal view {
95 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
96 	}
97 
98 	function logBytes(bytes memory p0) internal view {
99 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
100 	}
101 
102 	function logByte(byte p0) internal view {
103 		_sendLogPayload(abi.encodeWithSignature("log(byte)", p0));
104 	}
105 
106 	function logBytes1(bytes1 p0) internal view {
107 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
108 	}
109 
110 	function logBytes2(bytes2 p0) internal view {
111 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
112 	}
113 
114 	function logBytes3(bytes3 p0) internal view {
115 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
116 	}
117 
118 	function logBytes4(bytes4 p0) internal view {
119 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
120 	}
121 
122 	function logBytes5(bytes5 p0) internal view {
123 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
124 	}
125 
126 	function logBytes6(bytes6 p0) internal view {
127 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
128 	}
129 
130 	function logBytes7(bytes7 p0) internal view {
131 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
132 	}
133 
134 	function logBytes8(bytes8 p0) internal view {
135 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
136 	}
137 
138 	function logBytes9(bytes9 p0) internal view {
139 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
140 	}
141 
142 	function logBytes10(bytes10 p0) internal view {
143 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
144 	}
145 
146 	function logBytes11(bytes11 p0) internal view {
147 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
148 	}
149 
150 	function logBytes12(bytes12 p0) internal view {
151 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
152 	}
153 
154 	function logBytes13(bytes13 p0) internal view {
155 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
156 	}
157 
158 	function logBytes14(bytes14 p0) internal view {
159 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
160 	}
161 
162 	function logBytes15(bytes15 p0) internal view {
163 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
164 	}
165 
166 	function logBytes16(bytes16 p0) internal view {
167 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
168 	}
169 
170 	function logBytes17(bytes17 p0) internal view {
171 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
172 	}
173 
174 	function logBytes18(bytes18 p0) internal view {
175 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
176 	}
177 
178 	function logBytes19(bytes19 p0) internal view {
179 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
180 	}
181 
182 	function logBytes20(bytes20 p0) internal view {
183 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
184 	}
185 
186 	function logBytes21(bytes21 p0) internal view {
187 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
188 	}
189 
190 	function logBytes22(bytes22 p0) internal view {
191 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
192 	}
193 
194 	function logBytes23(bytes23 p0) internal view {
195 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
196 	}
197 
198 	function logBytes24(bytes24 p0) internal view {
199 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
200 	}
201 
202 	function logBytes25(bytes25 p0) internal view {
203 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
204 	}
205 
206 	function logBytes26(bytes26 p0) internal view {
207 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
208 	}
209 
210 	function logBytes27(bytes27 p0) internal view {
211 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
212 	}
213 
214 	function logBytes28(bytes28 p0) internal view {
215 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
216 	}
217 
218 	function logBytes29(bytes29 p0) internal view {
219 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
220 	}
221 
222 	function logBytes30(bytes30 p0) internal view {
223 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
224 	}
225 
226 	function logBytes31(bytes31 p0) internal view {
227 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
228 	}
229 
230 	function logBytes32(bytes32 p0) internal view {
231 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
232 	}
233 
234 	function log(uint p0) internal view {
235 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
236 	}
237 
238 	function log(string memory p0) internal view {
239 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
240 	}
241 
242 	function log(bool p0) internal view {
243 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
244 	}
245 
246 	function log(address p0) internal view {
247 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
248 	}
249 
250 	function log(uint p0, uint p1) internal view {
251 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
252 	}
253 
254 	function log(uint p0, string memory p1) internal view {
255 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
256 	}
257 
258 	function log(uint p0, bool p1) internal view {
259 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
260 	}
261 
262 	function log(uint p0, address p1) internal view {
263 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
264 	}
265 
266 	function log(string memory p0, uint p1) internal view {
267 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
268 	}
269 
270 	function log(string memory p0, string memory p1) internal view {
271 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
272 	}
273 
274 	function log(string memory p0, bool p1) internal view {
275 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
276 	}
277 
278 	function log(string memory p0, address p1) internal view {
279 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
280 	}
281 
282 	function log(bool p0, uint p1) internal view {
283 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
284 	}
285 
286 	function log(bool p0, string memory p1) internal view {
287 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
288 	}
289 
290 	function log(bool p0, bool p1) internal view {
291 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
292 	}
293 
294 	function log(bool p0, address p1) internal view {
295 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
296 	}
297 
298 	function log(address p0, uint p1) internal view {
299 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
300 	}
301 
302 	function log(address p0, string memory p1) internal view {
303 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
304 	}
305 
306 	function log(address p0, bool p1) internal view {
307 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
308 	}
309 
310 	function log(address p0, address p1) internal view {
311 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
312 	}
313 
314 	function log(uint p0, uint p1, uint p2) internal view {
315 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
316 	}
317 
318 	function log(uint p0, uint p1, string memory p2) internal view {
319 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
320 	}
321 
322 	function log(uint p0, uint p1, bool p2) internal view {
323 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
324 	}
325 
326 	function log(uint p0, uint p1, address p2) internal view {
327 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
328 	}
329 
330 	function log(uint p0, string memory p1, uint p2) internal view {
331 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
332 	}
333 
334 	function log(uint p0, string memory p1, string memory p2) internal view {
335 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
336 	}
337 
338 	function log(uint p0, string memory p1, bool p2) internal view {
339 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
340 	}
341 
342 	function log(uint p0, string memory p1, address p2) internal view {
343 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
344 	}
345 
346 	function log(uint p0, bool p1, uint p2) internal view {
347 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
348 	}
349 
350 	function log(uint p0, bool p1, string memory p2) internal view {
351 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
352 	}
353 
354 	function log(uint p0, bool p1, bool p2) internal view {
355 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
356 	}
357 
358 	function log(uint p0, bool p1, address p2) internal view {
359 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
360 	}
361 
362 	function log(uint p0, address p1, uint p2) internal view {
363 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
364 	}
365 
366 	function log(uint p0, address p1, string memory p2) internal view {
367 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
368 	}
369 
370 	function log(uint p0, address p1, bool p2) internal view {
371 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
372 	}
373 
374 	function log(uint p0, address p1, address p2) internal view {
375 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
376 	}
377 
378 	function log(string memory p0, uint p1, uint p2) internal view {
379 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
380 	}
381 
382 	function log(string memory p0, uint p1, string memory p2) internal view {
383 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
384 	}
385 
386 	function log(string memory p0, uint p1, bool p2) internal view {
387 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
388 	}
389 
390 	function log(string memory p0, uint p1, address p2) internal view {
391 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
392 	}
393 
394 	function log(string memory p0, string memory p1, uint p2) internal view {
395 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
396 	}
397 
398 	function log(string memory p0, string memory p1, string memory p2) internal view {
399 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
400 	}
401 
402 	function log(string memory p0, string memory p1, bool p2) internal view {
403 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
404 	}
405 
406 	function log(string memory p0, string memory p1, address p2) internal view {
407 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
408 	}
409 
410 	function log(string memory p0, bool p1, uint p2) internal view {
411 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
412 	}
413 
414 	function log(string memory p0, bool p1, string memory p2) internal view {
415 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
416 	}
417 
418 	function log(string memory p0, bool p1, bool p2) internal view {
419 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
420 	}
421 
422 	function log(string memory p0, bool p1, address p2) internal view {
423 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
424 	}
425 
426 	function log(string memory p0, address p1, uint p2) internal view {
427 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
428 	}
429 
430 	function log(string memory p0, address p1, string memory p2) internal view {
431 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
432 	}
433 
434 	function log(string memory p0, address p1, bool p2) internal view {
435 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
436 	}
437 
438 	function log(string memory p0, address p1, address p2) internal view {
439 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
440 	}
441 
442 	function log(bool p0, uint p1, uint p2) internal view {
443 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
444 	}
445 
446 	function log(bool p0, uint p1, string memory p2) internal view {
447 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
448 	}
449 
450 	function log(bool p0, uint p1, bool p2) internal view {
451 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
452 	}
453 
454 	function log(bool p0, uint p1, address p2) internal view {
455 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
456 	}
457 
458 	function log(bool p0, string memory p1, uint p2) internal view {
459 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
460 	}
461 
462 	function log(bool p0, string memory p1, string memory p2) internal view {
463 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
464 	}
465 
466 	function log(bool p0, string memory p1, bool p2) internal view {
467 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
468 	}
469 
470 	function log(bool p0, string memory p1, address p2) internal view {
471 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
472 	}
473 
474 	function log(bool p0, bool p1, uint p2) internal view {
475 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
476 	}
477 
478 	function log(bool p0, bool p1, string memory p2) internal view {
479 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
480 	}
481 
482 	function log(bool p0, bool p1, bool p2) internal view {
483 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
484 	}
485 
486 	function log(bool p0, bool p1, address p2) internal view {
487 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
488 	}
489 
490 	function log(bool p0, address p1, uint p2) internal view {
491 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
492 	}
493 
494 	function log(bool p0, address p1, string memory p2) internal view {
495 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
496 	}
497 
498 	function log(bool p0, address p1, bool p2) internal view {
499 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
500 	}
501 
502 	function log(bool p0, address p1, address p2) internal view {
503 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
504 	}
505 
506 	function log(address p0, uint p1, uint p2) internal view {
507 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
508 	}
509 
510 	function log(address p0, uint p1, string memory p2) internal view {
511 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
512 	}
513 
514 	function log(address p0, uint p1, bool p2) internal view {
515 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
516 	}
517 
518 	function log(address p0, uint p1, address p2) internal view {
519 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
520 	}
521 
522 	function log(address p0, string memory p1, uint p2) internal view {
523 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
524 	}
525 
526 	function log(address p0, string memory p1, string memory p2) internal view {
527 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
528 	}
529 
530 	function log(address p0, string memory p1, bool p2) internal view {
531 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
532 	}
533 
534 	function log(address p0, string memory p1, address p2) internal view {
535 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
536 	}
537 
538 	function log(address p0, bool p1, uint p2) internal view {
539 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
540 	}
541 
542 	function log(address p0, bool p1, string memory p2) internal view {
543 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
544 	}
545 
546 	function log(address p0, bool p1, bool p2) internal view {
547 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
548 	}
549 
550 	function log(address p0, bool p1, address p2) internal view {
551 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
552 	}
553 
554 	function log(address p0, address p1, uint p2) internal view {
555 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
556 	}
557 
558 	function log(address p0, address p1, string memory p2) internal view {
559 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
560 	}
561 
562 	function log(address p0, address p1, bool p2) internal view {
563 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
564 	}
565 
566 	function log(address p0, address p1, address p2) internal view {
567 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
568 	}
569 
570 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
571 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
572 	}
573 
574 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
575 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
576 	}
577 
578 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
579 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
580 	}
581 
582 	function log(uint p0, uint p1, uint p2, address p3) internal view {
583 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
584 	}
585 
586 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
587 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
588 	}
589 
590 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
591 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
592 	}
593 
594 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
595 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
596 	}
597 
598 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
599 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
600 	}
601 
602 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
603 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
604 	}
605 
606 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
607 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
608 	}
609 
610 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
611 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
612 	}
613 
614 	function log(uint p0, uint p1, bool p2, address p3) internal view {
615 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
616 	}
617 
618 	function log(uint p0, uint p1, address p2, uint p3) internal view {
619 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
620 	}
621 
622 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
623 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
624 	}
625 
626 	function log(uint p0, uint p1, address p2, bool p3) internal view {
627 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
628 	}
629 
630 	function log(uint p0, uint p1, address p2, address p3) internal view {
631 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
632 	}
633 
634 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
635 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
636 	}
637 
638 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
639 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
640 	}
641 
642 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
643 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
644 	}
645 
646 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
647 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
648 	}
649 
650 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
651 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
652 	}
653 
654 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
655 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
656 	}
657 
658 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
659 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
660 	}
661 
662 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
663 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
664 	}
665 
666 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
667 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
668 	}
669 
670 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
671 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
672 	}
673 
674 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
675 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
676 	}
677 
678 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
679 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
680 	}
681 
682 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
683 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
684 	}
685 
686 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
687 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
688 	}
689 
690 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
691 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
692 	}
693 
694 	function log(uint p0, string memory p1, address p2, address p3) internal view {
695 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
696 	}
697 
698 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
699 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
700 	}
701 
702 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
703 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
704 	}
705 
706 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
707 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
708 	}
709 
710 	function log(uint p0, bool p1, uint p2, address p3) internal view {
711 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
712 	}
713 
714 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
715 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
716 	}
717 
718 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
719 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
720 	}
721 
722 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
723 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
724 	}
725 
726 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
727 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
728 	}
729 
730 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
731 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
732 	}
733 
734 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
735 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
736 	}
737 
738 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
739 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
740 	}
741 
742 	function log(uint p0, bool p1, bool p2, address p3) internal view {
743 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
744 	}
745 
746 	function log(uint p0, bool p1, address p2, uint p3) internal view {
747 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
748 	}
749 
750 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
751 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
752 	}
753 
754 	function log(uint p0, bool p1, address p2, bool p3) internal view {
755 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
756 	}
757 
758 	function log(uint p0, bool p1, address p2, address p3) internal view {
759 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
760 	}
761 
762 	function log(uint p0, address p1, uint p2, uint p3) internal view {
763 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
764 	}
765 
766 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
767 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
768 	}
769 
770 	function log(uint p0, address p1, uint p2, bool p3) internal view {
771 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
772 	}
773 
774 	function log(uint p0, address p1, uint p2, address p3) internal view {
775 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
776 	}
777 
778 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
779 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
780 	}
781 
782 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
783 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
784 	}
785 
786 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
787 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
788 	}
789 
790 	function log(uint p0, address p1, string memory p2, address p3) internal view {
791 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
792 	}
793 
794 	function log(uint p0, address p1, bool p2, uint p3) internal view {
795 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
796 	}
797 
798 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
799 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
800 	}
801 
802 	function log(uint p0, address p1, bool p2, bool p3) internal view {
803 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
804 	}
805 
806 	function log(uint p0, address p1, bool p2, address p3) internal view {
807 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
808 	}
809 
810 	function log(uint p0, address p1, address p2, uint p3) internal view {
811 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
812 	}
813 
814 	function log(uint p0, address p1, address p2, string memory p3) internal view {
815 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
816 	}
817 
818 	function log(uint p0, address p1, address p2, bool p3) internal view {
819 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
820 	}
821 
822 	function log(uint p0, address p1, address p2, address p3) internal view {
823 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
824 	}
825 
826 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
827 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
828 	}
829 
830 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
831 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
832 	}
833 
834 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
835 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
836 	}
837 
838 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
839 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
840 	}
841 
842 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
843 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
844 	}
845 
846 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
847 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
848 	}
849 
850 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
851 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
852 	}
853 
854 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
855 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
856 	}
857 
858 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
859 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
860 	}
861 
862 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
863 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
864 	}
865 
866 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
867 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
868 	}
869 
870 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
871 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
872 	}
873 
874 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
875 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
876 	}
877 
878 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
879 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
880 	}
881 
882 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
883 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
884 	}
885 
886 	function log(string memory p0, uint p1, address p2, address p3) internal view {
887 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
888 	}
889 
890 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
891 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
892 	}
893 
894 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
895 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
896 	}
897 
898 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
899 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
900 	}
901 
902 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
903 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
904 	}
905 
906 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
907 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
908 	}
909 
910 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
911 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
912 	}
913 
914 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
915 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
916 	}
917 
918 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
919 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
920 	}
921 
922 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
923 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
924 	}
925 
926 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
927 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
928 	}
929 
930 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
931 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
932 	}
933 
934 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
935 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
936 	}
937 
938 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
939 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
940 	}
941 
942 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
943 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
944 	}
945 
946 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
947 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
948 	}
949 
950 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
951 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
952 	}
953 
954 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
955 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
956 	}
957 
958 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
959 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
960 	}
961 
962 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
963 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
964 	}
965 
966 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
967 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
968 	}
969 
970 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
971 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
972 	}
973 
974 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
975 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
976 	}
977 
978 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
979 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
980 	}
981 
982 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
983 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
984 	}
985 
986 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
987 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
988 	}
989 
990 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
991 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
992 	}
993 
994 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
995 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
996 	}
997 
998 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
999 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
1000 	}
1001 
1002 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
1003 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
1004 	}
1005 
1006 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
1007 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
1008 	}
1009 
1010 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
1011 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
1012 	}
1013 
1014 	function log(string memory p0, bool p1, address p2, address p3) internal view {
1015 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
1016 	}
1017 
1018 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
1019 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
1020 	}
1021 
1022 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
1023 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
1024 	}
1025 
1026 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
1027 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
1028 	}
1029 
1030 	function log(string memory p0, address p1, uint p2, address p3) internal view {
1031 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
1032 	}
1033 
1034 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
1035 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
1036 	}
1037 
1038 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
1039 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
1040 	}
1041 
1042 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
1043 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
1044 	}
1045 
1046 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
1047 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
1048 	}
1049 
1050 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
1051 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
1052 	}
1053 
1054 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
1055 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
1056 	}
1057 
1058 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
1059 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
1060 	}
1061 
1062 	function log(string memory p0, address p1, bool p2, address p3) internal view {
1063 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
1064 	}
1065 
1066 	function log(string memory p0, address p1, address p2, uint p3) internal view {
1067 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
1068 	}
1069 
1070 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
1071 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
1072 	}
1073 
1074 	function log(string memory p0, address p1, address p2, bool p3) internal view {
1075 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
1076 	}
1077 
1078 	function log(string memory p0, address p1, address p2, address p3) internal view {
1079 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
1080 	}
1081 
1082 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
1083 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
1084 	}
1085 
1086 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
1087 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
1088 	}
1089 
1090 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
1091 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
1092 	}
1093 
1094 	function log(bool p0, uint p1, uint p2, address p3) internal view {
1095 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
1096 	}
1097 
1098 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
1099 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
1100 	}
1101 
1102 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
1103 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
1104 	}
1105 
1106 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
1107 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
1108 	}
1109 
1110 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
1111 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
1112 	}
1113 
1114 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
1115 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
1116 	}
1117 
1118 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
1119 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
1120 	}
1121 
1122 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
1123 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
1124 	}
1125 
1126 	function log(bool p0, uint p1, bool p2, address p3) internal view {
1127 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
1128 	}
1129 
1130 	function log(bool p0, uint p1, address p2, uint p3) internal view {
1131 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
1132 	}
1133 
1134 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
1135 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
1136 	}
1137 
1138 	function log(bool p0, uint p1, address p2, bool p3) internal view {
1139 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
1140 	}
1141 
1142 	function log(bool p0, uint p1, address p2, address p3) internal view {
1143 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
1144 	}
1145 
1146 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
1147 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
1148 	}
1149 
1150 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
1151 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
1152 	}
1153 
1154 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
1155 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
1156 	}
1157 
1158 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
1159 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
1160 	}
1161 
1162 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
1163 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
1164 	}
1165 
1166 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
1167 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
1168 	}
1169 
1170 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
1171 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
1172 	}
1173 
1174 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
1175 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
1176 	}
1177 
1178 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
1179 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
1180 	}
1181 
1182 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
1183 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
1184 	}
1185 
1186 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
1187 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
1188 	}
1189 
1190 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
1191 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
1192 	}
1193 
1194 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
1195 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
1196 	}
1197 
1198 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
1199 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
1200 	}
1201 
1202 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
1203 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
1204 	}
1205 
1206 	function log(bool p0, string memory p1, address p2, address p3) internal view {
1207 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
1208 	}
1209 
1210 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
1211 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
1212 	}
1213 
1214 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
1215 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
1216 	}
1217 
1218 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
1219 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
1220 	}
1221 
1222 	function log(bool p0, bool p1, uint p2, address p3) internal view {
1223 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
1224 	}
1225 
1226 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
1227 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
1228 	}
1229 
1230 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
1231 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
1232 	}
1233 
1234 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
1235 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
1236 	}
1237 
1238 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
1239 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
1240 	}
1241 
1242 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
1243 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
1244 	}
1245 
1246 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
1247 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
1248 	}
1249 
1250 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
1251 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
1252 	}
1253 
1254 	function log(bool p0, bool p1, bool p2, address p3) internal view {
1255 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
1256 	}
1257 
1258 	function log(bool p0, bool p1, address p2, uint p3) internal view {
1259 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
1260 	}
1261 
1262 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
1263 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
1264 	}
1265 
1266 	function log(bool p0, bool p1, address p2, bool p3) internal view {
1267 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
1268 	}
1269 
1270 	function log(bool p0, bool p1, address p2, address p3) internal view {
1271 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
1272 	}
1273 
1274 	function log(bool p0, address p1, uint p2, uint p3) internal view {
1275 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
1276 	}
1277 
1278 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
1279 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
1280 	}
1281 
1282 	function log(bool p0, address p1, uint p2, bool p3) internal view {
1283 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
1284 	}
1285 
1286 	function log(bool p0, address p1, uint p2, address p3) internal view {
1287 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
1288 	}
1289 
1290 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
1291 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
1292 	}
1293 
1294 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
1295 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
1296 	}
1297 
1298 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
1299 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
1300 	}
1301 
1302 	function log(bool p0, address p1, string memory p2, address p3) internal view {
1303 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
1304 	}
1305 
1306 	function log(bool p0, address p1, bool p2, uint p3) internal view {
1307 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
1308 	}
1309 
1310 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
1311 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
1312 	}
1313 
1314 	function log(bool p0, address p1, bool p2, bool p3) internal view {
1315 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
1316 	}
1317 
1318 	function log(bool p0, address p1, bool p2, address p3) internal view {
1319 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
1320 	}
1321 
1322 	function log(bool p0, address p1, address p2, uint p3) internal view {
1323 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
1324 	}
1325 
1326 	function log(bool p0, address p1, address p2, string memory p3) internal view {
1327 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
1328 	}
1329 
1330 	function log(bool p0, address p1, address p2, bool p3) internal view {
1331 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
1332 	}
1333 
1334 	function log(bool p0, address p1, address p2, address p3) internal view {
1335 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
1336 	}
1337 
1338 	function log(address p0, uint p1, uint p2, uint p3) internal view {
1339 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
1340 	}
1341 
1342 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
1343 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
1344 	}
1345 
1346 	function log(address p0, uint p1, uint p2, bool p3) internal view {
1347 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
1348 	}
1349 
1350 	function log(address p0, uint p1, uint p2, address p3) internal view {
1351 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
1352 	}
1353 
1354 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
1355 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
1356 	}
1357 
1358 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
1359 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
1360 	}
1361 
1362 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
1363 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
1364 	}
1365 
1366 	function log(address p0, uint p1, string memory p2, address p3) internal view {
1367 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
1368 	}
1369 
1370 	function log(address p0, uint p1, bool p2, uint p3) internal view {
1371 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
1372 	}
1373 
1374 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
1375 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
1376 	}
1377 
1378 	function log(address p0, uint p1, bool p2, bool p3) internal view {
1379 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
1380 	}
1381 
1382 	function log(address p0, uint p1, bool p2, address p3) internal view {
1383 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
1384 	}
1385 
1386 	function log(address p0, uint p1, address p2, uint p3) internal view {
1387 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
1388 	}
1389 
1390 	function log(address p0, uint p1, address p2, string memory p3) internal view {
1391 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
1392 	}
1393 
1394 	function log(address p0, uint p1, address p2, bool p3) internal view {
1395 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
1396 	}
1397 
1398 	function log(address p0, uint p1, address p2, address p3) internal view {
1399 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
1400 	}
1401 
1402 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
1403 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
1404 	}
1405 
1406 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
1407 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
1408 	}
1409 
1410 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
1411 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
1412 	}
1413 
1414 	function log(address p0, string memory p1, uint p2, address p3) internal view {
1415 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
1416 	}
1417 
1418 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
1419 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
1420 	}
1421 
1422 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
1423 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
1424 	}
1425 
1426 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
1427 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
1428 	}
1429 
1430 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
1431 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
1432 	}
1433 
1434 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
1435 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
1436 	}
1437 
1438 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
1439 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
1440 	}
1441 
1442 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
1443 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
1444 	}
1445 
1446 	function log(address p0, string memory p1, bool p2, address p3) internal view {
1447 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
1448 	}
1449 
1450 	function log(address p0, string memory p1, address p2, uint p3) internal view {
1451 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
1452 	}
1453 
1454 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
1455 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
1456 	}
1457 
1458 	function log(address p0, string memory p1, address p2, bool p3) internal view {
1459 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
1460 	}
1461 
1462 	function log(address p0, string memory p1, address p2, address p3) internal view {
1463 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
1464 	}
1465 
1466 	function log(address p0, bool p1, uint p2, uint p3) internal view {
1467 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
1468 	}
1469 
1470 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
1471 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
1472 	}
1473 
1474 	function log(address p0, bool p1, uint p2, bool p3) internal view {
1475 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
1476 	}
1477 
1478 	function log(address p0, bool p1, uint p2, address p3) internal view {
1479 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
1480 	}
1481 
1482 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
1483 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
1484 	}
1485 
1486 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
1487 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
1488 	}
1489 
1490 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
1491 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
1492 	}
1493 
1494 	function log(address p0, bool p1, string memory p2, address p3) internal view {
1495 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
1496 	}
1497 
1498 	function log(address p0, bool p1, bool p2, uint p3) internal view {
1499 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
1500 	}
1501 
1502 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
1503 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
1504 	}
1505 
1506 	function log(address p0, bool p1, bool p2, bool p3) internal view {
1507 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
1508 	}
1509 
1510 	function log(address p0, bool p1, bool p2, address p3) internal view {
1511 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
1512 	}
1513 
1514 	function log(address p0, bool p1, address p2, uint p3) internal view {
1515 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
1516 	}
1517 
1518 	function log(address p0, bool p1, address p2, string memory p3) internal view {
1519 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
1520 	}
1521 
1522 	function log(address p0, bool p1, address p2, bool p3) internal view {
1523 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
1524 	}
1525 
1526 	function log(address p0, bool p1, address p2, address p3) internal view {
1527 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
1528 	}
1529 
1530 	function log(address p0, address p1, uint p2, uint p3) internal view {
1531 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
1532 	}
1533 
1534 	function log(address p0, address p1, uint p2, string memory p3) internal view {
1535 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
1536 	}
1537 
1538 	function log(address p0, address p1, uint p2, bool p3) internal view {
1539 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
1540 	}
1541 
1542 	function log(address p0, address p1, uint p2, address p3) internal view {
1543 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
1544 	}
1545 
1546 	function log(address p0, address p1, string memory p2, uint p3) internal view {
1547 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
1548 	}
1549 
1550 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
1551 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
1552 	}
1553 
1554 	function log(address p0, address p1, string memory p2, bool p3) internal view {
1555 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
1556 	}
1557 
1558 	function log(address p0, address p1, string memory p2, address p3) internal view {
1559 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
1560 	}
1561 
1562 	function log(address p0, address p1, bool p2, uint p3) internal view {
1563 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
1564 	}
1565 
1566 	function log(address p0, address p1, bool p2, string memory p3) internal view {
1567 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
1568 	}
1569 
1570 	function log(address p0, address p1, bool p2, bool p3) internal view {
1571 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
1572 	}
1573 
1574 	function log(address p0, address p1, bool p2, address p3) internal view {
1575 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
1576 	}
1577 
1578 	function log(address p0, address p1, address p2, uint p3) internal view {
1579 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
1580 	}
1581 
1582 	function log(address p0, address p1, address p2, string memory p3) internal view {
1583 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
1584 	}
1585 
1586 	function log(address p0, address p1, address p2, bool p3) internal view {
1587 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
1588 	}
1589 
1590 	function log(address p0, address p1, address p2, address p3) internal view {
1591 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
1592 	}
1593 
1594 }
1595 
1596 
1597 contract CORIA is ERC20Interface {
1598     
1599     using SafeMath for uint256;
1600     string public name;
1601     string public symbol;
1602     uint8 public decimals; // 18 standard decimal place
1603     
1604     uint256 public basePercent = 150;
1605     uint256 public rewardPercent = 130;
1606     
1607     uint256 public _totalSupply;
1608     
1609     mapping(address => uint) balances;
1610     mapping(address => mapping(address => uint)) allowed;
1611 
1612     constructor() public {
1613         name = "covault.finance";
1614         symbol = "CORIA";
1615         decimals = 18;
1616         _totalSupply = 5000000000000000000000;
1617         
1618         balances[msg.sender] = _totalSupply;
1619         emit Transfer(address(0), msg.sender, _totalSupply);
1620     }
1621     
1622     function balanceOf(address tokenOwner) public view returns (uint balance) {
1623         return balances[tokenOwner];
1624     }
1625     
1626     function approve(address spender, uint tokens) public returns (bool success) {
1627         allowed[msg.sender][spender] = tokens;
1628         emit Approval(msg.sender, spender, tokens);
1629         return true;
1630     }
1631     
1632     
1633     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
1634         balances[from] = balances[from].sub(tokens);
1635         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
1636         balances[to] = balances[to].add(tokens);
1637         emit Transfer(from, to, tokens);
1638         return true;
1639     }
1640     
1641     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
1642         return allowed[tokenOwner][spender];
1643     }
1644     
1645     function findCoriaBurnPercent(uint256 value) public view returns (uint256)  {
1646         uint256 roundValue = value.ceil(basePercent);
1647         uint256 onePercent = roundValue.mul(basePercent).div(10000);
1648         return onePercent;
1649       }
1650     
1651     function transfer(address to, uint value) public returns (bool success) {
1652         // balances[msg.sender] = safeSub(balances[msg.sender], tokens);
1653         // balances[to] = safeAdd(balances[to], tokens);
1654         // emit Transfer(msg.sender, to, tokens);
1655         // return true;
1656         
1657         require(value <= balances[msg.sender]);
1658         require(to != address(0));
1659     
1660         uint256 tokensToBurn = findCoriaBurnPercent(value);
1661         uint256 tokensToTransfer = value.sub(tokensToBurn);
1662     
1663         balances[msg.sender] = balances[msg.sender].sub(value);
1664         balances[to] = balances[to].add(tokensToTransfer);
1665     
1666         _totalSupply = _totalSupply.sub(tokensToBurn);
1667     
1668         emit Transfer(msg.sender, to, tokensToTransfer);
1669         emit Transfer(msg.sender, address(0), tokensToBurn);
1670         return true;
1671     }
1672     
1673     function totalSupply() public view returns (uint) {
1674         return _totalSupply  - balances[address(0)];
1675     }
1676     
1677 }