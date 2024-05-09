1 // File: contracts/IgmRenderer.sol
2 
3 //  ▄▄▄       ▒█████   ▄████▄  
4 // ▒████▄    ▒██▒  ██▒▒██▀ ▀█  
5 // ▒██  ▀█▄  ▒██░  ██▒▒▓█    ▄ 
6 // ░██▄▄▄▄██ ▒██   ██░▒▓▓▄ ▄██▒
7 //  ▓█   ▓██▒░ ████▓▒░▒ ▓███▀ ░
8 //  ▒▒   ▓▒█░░ ▒░▒░▒░ ░ ░▒ ▒  ░
9 //   ▒   ▒▒ ░  ░ ▒ ▒░   ░  ▒   
10 //   ░   ▒   ░ ░ ░ ▒  ░        
11 //       ░  ░    ░ ░  ░ ░      
12 //                    ░       
13 // https://aolcoin.xyz/
14 // https://twitter.com/aolcoin
15 // https://t.co/MwNyKcButP
16 
17 pragma solidity 0.8.17;
18 
19 interface IgmRenderer {
20     function applyStyle(uint16 id) external;
21 
22     function addAddress(uint16 tokenId, address newAddress) external;
23 
24     function tokenUri(uint16 id) external view returns (string memory);
25 }
26 // File: hardhat/console.sol
27 
28 
29 pragma solidity >= 0.4.22 <0.9.0;
30 
31 library console {
32 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
33 
34 	function _sendLogPayload(bytes memory payload) private view {
35 		uint256 payloadLength = payload.length;
36 		address consoleAddress = CONSOLE_ADDRESS;
37 		assembly {
38 			let payloadStart := add(payload, 32)
39 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
40 		}
41 	}
42 
43 	function log() internal view {
44 		_sendLogPayload(abi.encodeWithSignature("log()"));
45 	}
46 
47 	function logInt(int256 p0) internal view {
48 		_sendLogPayload(abi.encodeWithSignature("log(int256)", p0));
49 	}
50 
51 	function logUint(uint256 p0) internal view {
52 		_sendLogPayload(abi.encodeWithSignature("log(uint256)", p0));
53 	}
54 
55 	function logString(string memory p0) internal view {
56 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
57 	}
58 
59 	function logBool(bool p0) internal view {
60 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
61 	}
62 
63 	function logAddress(address p0) internal view {
64 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
65 	}
66 
67 	function logBytes(bytes memory p0) internal view {
68 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
69 	}
70 
71 	function logBytes1(bytes1 p0) internal view {
72 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
73 	}
74 
75 	function logBytes2(bytes2 p0) internal view {
76 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
77 	}
78 
79 	function logBytes3(bytes3 p0) internal view {
80 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
81 	}
82 
83 	function logBytes4(bytes4 p0) internal view {
84 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
85 	}
86 
87 	function logBytes5(bytes5 p0) internal view {
88 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
89 	}
90 
91 	function logBytes6(bytes6 p0) internal view {
92 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
93 	}
94 
95 	function logBytes7(bytes7 p0) internal view {
96 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
97 	}
98 
99 	function logBytes8(bytes8 p0) internal view {
100 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
101 	}
102 
103 	function logBytes9(bytes9 p0) internal view {
104 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
105 	}
106 
107 	function logBytes10(bytes10 p0) internal view {
108 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
109 	}
110 
111 	function logBytes11(bytes11 p0) internal view {
112 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
113 	}
114 
115 	function logBytes12(bytes12 p0) internal view {
116 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
117 	}
118 
119 	function logBytes13(bytes13 p0) internal view {
120 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
121 	}
122 
123 	function logBytes14(bytes14 p0) internal view {
124 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
125 	}
126 
127 	function logBytes15(bytes15 p0) internal view {
128 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
129 	}
130 
131 	function logBytes16(bytes16 p0) internal view {
132 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
133 	}
134 
135 	function logBytes17(bytes17 p0) internal view {
136 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
137 	}
138 
139 	function logBytes18(bytes18 p0) internal view {
140 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
141 	}
142 
143 	function logBytes19(bytes19 p0) internal view {
144 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
145 	}
146 
147 	function logBytes20(bytes20 p0) internal view {
148 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
149 	}
150 
151 	function logBytes21(bytes21 p0) internal view {
152 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
153 	}
154 
155 	function logBytes22(bytes22 p0) internal view {
156 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
157 	}
158 
159 	function logBytes23(bytes23 p0) internal view {
160 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
161 	}
162 
163 	function logBytes24(bytes24 p0) internal view {
164 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
165 	}
166 
167 	function logBytes25(bytes25 p0) internal view {
168 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
169 	}
170 
171 	function logBytes26(bytes26 p0) internal view {
172 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
173 	}
174 
175 	function logBytes27(bytes27 p0) internal view {
176 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
177 	}
178 
179 	function logBytes28(bytes28 p0) internal view {
180 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
181 	}
182 
183 	function logBytes29(bytes29 p0) internal view {
184 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
185 	}
186 
187 	function logBytes30(bytes30 p0) internal view {
188 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
189 	}
190 
191 	function logBytes31(bytes31 p0) internal view {
192 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
193 	}
194 
195 	function logBytes32(bytes32 p0) internal view {
196 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
197 	}
198 
199 	function log(uint256 p0) internal view {
200 		_sendLogPayload(abi.encodeWithSignature("log(uint256)", p0));
201 	}
202 
203 	function log(string memory p0) internal view {
204 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
205 	}
206 
207 	function log(bool p0) internal view {
208 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
209 	}
210 
211 	function log(address p0) internal view {
212 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
213 	}
214 
215 	function log(uint256 p0, uint256 p1) internal view {
216 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256)", p0, p1));
217 	}
218 
219 	function log(uint256 p0, string memory p1) internal view {
220 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string)", p0, p1));
221 	}
222 
223 	function log(uint256 p0, bool p1) internal view {
224 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool)", p0, p1));
225 	}
226 
227 	function log(uint256 p0, address p1) internal view {
228 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address)", p0, p1));
229 	}
230 
231 	function log(string memory p0, uint256 p1) internal view {
232 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256)", p0, p1));
233 	}
234 
235 	function log(string memory p0, string memory p1) internal view {
236 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
237 	}
238 
239 	function log(string memory p0, bool p1) internal view {
240 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
241 	}
242 
243 	function log(string memory p0, address p1) internal view {
244 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
245 	}
246 
247 	function log(bool p0, uint256 p1) internal view {
248 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256)", p0, p1));
249 	}
250 
251 	function log(bool p0, string memory p1) internal view {
252 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
253 	}
254 
255 	function log(bool p0, bool p1) internal view {
256 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
257 	}
258 
259 	function log(bool p0, address p1) internal view {
260 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
261 	}
262 
263 	function log(address p0, uint256 p1) internal view {
264 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256)", p0, p1));
265 	}
266 
267 	function log(address p0, string memory p1) internal view {
268 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
269 	}
270 
271 	function log(address p0, bool p1) internal view {
272 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
273 	}
274 
275 	function log(address p0, address p1) internal view {
276 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
277 	}
278 
279 	function log(uint256 p0, uint256 p1, uint256 p2) internal view {
280 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256)", p0, p1, p2));
281 	}
282 
283 	function log(uint256 p0, uint256 p1, string memory p2) internal view {
284 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string)", p0, p1, p2));
285 	}
286 
287 	function log(uint256 p0, uint256 p1, bool p2) internal view {
288 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool)", p0, p1, p2));
289 	}
290 
291 	function log(uint256 p0, uint256 p1, address p2) internal view {
292 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address)", p0, p1, p2));
293 	}
294 
295 	function log(uint256 p0, string memory p1, uint256 p2) internal view {
296 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256)", p0, p1, p2));
297 	}
298 
299 	function log(uint256 p0, string memory p1, string memory p2) internal view {
300 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string)", p0, p1, p2));
301 	}
302 
303 	function log(uint256 p0, string memory p1, bool p2) internal view {
304 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool)", p0, p1, p2));
305 	}
306 
307 	function log(uint256 p0, string memory p1, address p2) internal view {
308 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address)", p0, p1, p2));
309 	}
310 
311 	function log(uint256 p0, bool p1, uint256 p2) internal view {
312 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256)", p0, p1, p2));
313 	}
314 
315 	function log(uint256 p0, bool p1, string memory p2) internal view {
316 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string)", p0, p1, p2));
317 	}
318 
319 	function log(uint256 p0, bool p1, bool p2) internal view {
320 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool)", p0, p1, p2));
321 	}
322 
323 	function log(uint256 p0, bool p1, address p2) internal view {
324 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address)", p0, p1, p2));
325 	}
326 
327 	function log(uint256 p0, address p1, uint256 p2) internal view {
328 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256)", p0, p1, p2));
329 	}
330 
331 	function log(uint256 p0, address p1, string memory p2) internal view {
332 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string)", p0, p1, p2));
333 	}
334 
335 	function log(uint256 p0, address p1, bool p2) internal view {
336 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool)", p0, p1, p2));
337 	}
338 
339 	function log(uint256 p0, address p1, address p2) internal view {
340 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address)", p0, p1, p2));
341 	}
342 
343 	function log(string memory p0, uint256 p1, uint256 p2) internal view {
344 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256)", p0, p1, p2));
345 	}
346 
347 	function log(string memory p0, uint256 p1, string memory p2) internal view {
348 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string)", p0, p1, p2));
349 	}
350 
351 	function log(string memory p0, uint256 p1, bool p2) internal view {
352 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool)", p0, p1, p2));
353 	}
354 
355 	function log(string memory p0, uint256 p1, address p2) internal view {
356 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address)", p0, p1, p2));
357 	}
358 
359 	function log(string memory p0, string memory p1, uint256 p2) internal view {
360 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256)", p0, p1, p2));
361 	}
362 
363 	function log(string memory p0, string memory p1, string memory p2) internal view {
364 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
365 	}
366 
367 	function log(string memory p0, string memory p1, bool p2) internal view {
368 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
369 	}
370 
371 	function log(string memory p0, string memory p1, address p2) internal view {
372 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
373 	}
374 
375 	function log(string memory p0, bool p1, uint256 p2) internal view {
376 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256)", p0, p1, p2));
377 	}
378 
379 	function log(string memory p0, bool p1, string memory p2) internal view {
380 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
381 	}
382 
383 	function log(string memory p0, bool p1, bool p2) internal view {
384 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
385 	}
386 
387 	function log(string memory p0, bool p1, address p2) internal view {
388 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
389 	}
390 
391 	function log(string memory p0, address p1, uint256 p2) internal view {
392 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256)", p0, p1, p2));
393 	}
394 
395 	function log(string memory p0, address p1, string memory p2) internal view {
396 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
397 	}
398 
399 	function log(string memory p0, address p1, bool p2) internal view {
400 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
401 	}
402 
403 	function log(string memory p0, address p1, address p2) internal view {
404 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
405 	}
406 
407 	function log(bool p0, uint256 p1, uint256 p2) internal view {
408 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256)", p0, p1, p2));
409 	}
410 
411 	function log(bool p0, uint256 p1, string memory p2) internal view {
412 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string)", p0, p1, p2));
413 	}
414 
415 	function log(bool p0, uint256 p1, bool p2) internal view {
416 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool)", p0, p1, p2));
417 	}
418 
419 	function log(bool p0, uint256 p1, address p2) internal view {
420 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address)", p0, p1, p2));
421 	}
422 
423 	function log(bool p0, string memory p1, uint256 p2) internal view {
424 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256)", p0, p1, p2));
425 	}
426 
427 	function log(bool p0, string memory p1, string memory p2) internal view {
428 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
429 	}
430 
431 	function log(bool p0, string memory p1, bool p2) internal view {
432 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
433 	}
434 
435 	function log(bool p0, string memory p1, address p2) internal view {
436 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
437 	}
438 
439 	function log(bool p0, bool p1, uint256 p2) internal view {
440 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256)", p0, p1, p2));
441 	}
442 
443 	function log(bool p0, bool p1, string memory p2) internal view {
444 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
445 	}
446 
447 	function log(bool p0, bool p1, bool p2) internal view {
448 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
449 	}
450 
451 	function log(bool p0, bool p1, address p2) internal view {
452 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
453 	}
454 
455 	function log(bool p0, address p1, uint256 p2) internal view {
456 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256)", p0, p1, p2));
457 	}
458 
459 	function log(bool p0, address p1, string memory p2) internal view {
460 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
461 	}
462 
463 	function log(bool p0, address p1, bool p2) internal view {
464 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
465 	}
466 
467 	function log(bool p0, address p1, address p2) internal view {
468 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
469 	}
470 
471 	function log(address p0, uint256 p1, uint256 p2) internal view {
472 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256)", p0, p1, p2));
473 	}
474 
475 	function log(address p0, uint256 p1, string memory p2) internal view {
476 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string)", p0, p1, p2));
477 	}
478 
479 	function log(address p0, uint256 p1, bool p2) internal view {
480 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool)", p0, p1, p2));
481 	}
482 
483 	function log(address p0, uint256 p1, address p2) internal view {
484 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address)", p0, p1, p2));
485 	}
486 
487 	function log(address p0, string memory p1, uint256 p2) internal view {
488 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256)", p0, p1, p2));
489 	}
490 
491 	function log(address p0, string memory p1, string memory p2) internal view {
492 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
493 	}
494 
495 	function log(address p0, string memory p1, bool p2) internal view {
496 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
497 	}
498 
499 	function log(address p0, string memory p1, address p2) internal view {
500 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
501 	}
502 
503 	function log(address p0, bool p1, uint256 p2) internal view {
504 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256)", p0, p1, p2));
505 	}
506 
507 	function log(address p0, bool p1, string memory p2) internal view {
508 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
509 	}
510 
511 	function log(address p0, bool p1, bool p2) internal view {
512 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
513 	}
514 
515 	function log(address p0, bool p1, address p2) internal view {
516 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
517 	}
518 
519 	function log(address p0, address p1, uint256 p2) internal view {
520 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256)", p0, p1, p2));
521 	}
522 
523 	function log(address p0, address p1, string memory p2) internal view {
524 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
525 	}
526 
527 	function log(address p0, address p1, bool p2) internal view {
528 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
529 	}
530 
531 	function log(address p0, address p1, address p2) internal view {
532 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
533 	}
534 
535 	function log(uint256 p0, uint256 p1, uint256 p2, uint256 p3) internal view {
536 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,uint256)", p0, p1, p2, p3));
537 	}
538 
539 	function log(uint256 p0, uint256 p1, uint256 p2, string memory p3) internal view {
540 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,string)", p0, p1, p2, p3));
541 	}
542 
543 	function log(uint256 p0, uint256 p1, uint256 p2, bool p3) internal view {
544 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,bool)", p0, p1, p2, p3));
545 	}
546 
547 	function log(uint256 p0, uint256 p1, uint256 p2, address p3) internal view {
548 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,address)", p0, p1, p2, p3));
549 	}
550 
551 	function log(uint256 p0, uint256 p1, string memory p2, uint256 p3) internal view {
552 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,uint256)", p0, p1, p2, p3));
553 	}
554 
555 	function log(uint256 p0, uint256 p1, string memory p2, string memory p3) internal view {
556 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,string)", p0, p1, p2, p3));
557 	}
558 
559 	function log(uint256 p0, uint256 p1, string memory p2, bool p3) internal view {
560 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,bool)", p0, p1, p2, p3));
561 	}
562 
563 	function log(uint256 p0, uint256 p1, string memory p2, address p3) internal view {
564 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,address)", p0, p1, p2, p3));
565 	}
566 
567 	function log(uint256 p0, uint256 p1, bool p2, uint256 p3) internal view {
568 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,uint256)", p0, p1, p2, p3));
569 	}
570 
571 	function log(uint256 p0, uint256 p1, bool p2, string memory p3) internal view {
572 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,string)", p0, p1, p2, p3));
573 	}
574 
575 	function log(uint256 p0, uint256 p1, bool p2, bool p3) internal view {
576 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,bool)", p0, p1, p2, p3));
577 	}
578 
579 	function log(uint256 p0, uint256 p1, bool p2, address p3) internal view {
580 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,address)", p0, p1, p2, p3));
581 	}
582 
583 	function log(uint256 p0, uint256 p1, address p2, uint256 p3) internal view {
584 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,uint256)", p0, p1, p2, p3));
585 	}
586 
587 	function log(uint256 p0, uint256 p1, address p2, string memory p3) internal view {
588 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,string)", p0, p1, p2, p3));
589 	}
590 
591 	function log(uint256 p0, uint256 p1, address p2, bool p3) internal view {
592 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,bool)", p0, p1, p2, p3));
593 	}
594 
595 	function log(uint256 p0, uint256 p1, address p2, address p3) internal view {
596 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,address)", p0, p1, p2, p3));
597 	}
598 
599 	function log(uint256 p0, string memory p1, uint256 p2, uint256 p3) internal view {
600 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,uint256)", p0, p1, p2, p3));
601 	}
602 
603 	function log(uint256 p0, string memory p1, uint256 p2, string memory p3) internal view {
604 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,string)", p0, p1, p2, p3));
605 	}
606 
607 	function log(uint256 p0, string memory p1, uint256 p2, bool p3) internal view {
608 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,bool)", p0, p1, p2, p3));
609 	}
610 
611 	function log(uint256 p0, string memory p1, uint256 p2, address p3) internal view {
612 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,address)", p0, p1, p2, p3));
613 	}
614 
615 	function log(uint256 p0, string memory p1, string memory p2, uint256 p3) internal view {
616 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,uint256)", p0, p1, p2, p3));
617 	}
618 
619 	function log(uint256 p0, string memory p1, string memory p2, string memory p3) internal view {
620 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,string)", p0, p1, p2, p3));
621 	}
622 
623 	function log(uint256 p0, string memory p1, string memory p2, bool p3) internal view {
624 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,bool)", p0, p1, p2, p3));
625 	}
626 
627 	function log(uint256 p0, string memory p1, string memory p2, address p3) internal view {
628 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,address)", p0, p1, p2, p3));
629 	}
630 
631 	function log(uint256 p0, string memory p1, bool p2, uint256 p3) internal view {
632 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,uint256)", p0, p1, p2, p3));
633 	}
634 
635 	function log(uint256 p0, string memory p1, bool p2, string memory p3) internal view {
636 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,string)", p0, p1, p2, p3));
637 	}
638 
639 	function log(uint256 p0, string memory p1, bool p2, bool p3) internal view {
640 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,bool)", p0, p1, p2, p3));
641 	}
642 
643 	function log(uint256 p0, string memory p1, bool p2, address p3) internal view {
644 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,address)", p0, p1, p2, p3));
645 	}
646 
647 	function log(uint256 p0, string memory p1, address p2, uint256 p3) internal view {
648 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,uint256)", p0, p1, p2, p3));
649 	}
650 
651 	function log(uint256 p0, string memory p1, address p2, string memory p3) internal view {
652 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,string)", p0, p1, p2, p3));
653 	}
654 
655 	function log(uint256 p0, string memory p1, address p2, bool p3) internal view {
656 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,bool)", p0, p1, p2, p3));
657 	}
658 
659 	function log(uint256 p0, string memory p1, address p2, address p3) internal view {
660 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,address)", p0, p1, p2, p3));
661 	}
662 
663 	function log(uint256 p0, bool p1, uint256 p2, uint256 p3) internal view {
664 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,uint256)", p0, p1, p2, p3));
665 	}
666 
667 	function log(uint256 p0, bool p1, uint256 p2, string memory p3) internal view {
668 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,string)", p0, p1, p2, p3));
669 	}
670 
671 	function log(uint256 p0, bool p1, uint256 p2, bool p3) internal view {
672 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,bool)", p0, p1, p2, p3));
673 	}
674 
675 	function log(uint256 p0, bool p1, uint256 p2, address p3) internal view {
676 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,address)", p0, p1, p2, p3));
677 	}
678 
679 	function log(uint256 p0, bool p1, string memory p2, uint256 p3) internal view {
680 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,uint256)", p0, p1, p2, p3));
681 	}
682 
683 	function log(uint256 p0, bool p1, string memory p2, string memory p3) internal view {
684 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,string)", p0, p1, p2, p3));
685 	}
686 
687 	function log(uint256 p0, bool p1, string memory p2, bool p3) internal view {
688 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,bool)", p0, p1, p2, p3));
689 	}
690 
691 	function log(uint256 p0, bool p1, string memory p2, address p3) internal view {
692 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,address)", p0, p1, p2, p3));
693 	}
694 
695 	function log(uint256 p0, bool p1, bool p2, uint256 p3) internal view {
696 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,uint256)", p0, p1, p2, p3));
697 	}
698 
699 	function log(uint256 p0, bool p1, bool p2, string memory p3) internal view {
700 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,string)", p0, p1, p2, p3));
701 	}
702 
703 	function log(uint256 p0, bool p1, bool p2, bool p3) internal view {
704 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,bool)", p0, p1, p2, p3));
705 	}
706 
707 	function log(uint256 p0, bool p1, bool p2, address p3) internal view {
708 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,address)", p0, p1, p2, p3));
709 	}
710 
711 	function log(uint256 p0, bool p1, address p2, uint256 p3) internal view {
712 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,uint256)", p0, p1, p2, p3));
713 	}
714 
715 	function log(uint256 p0, bool p1, address p2, string memory p3) internal view {
716 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,string)", p0, p1, p2, p3));
717 	}
718 
719 	function log(uint256 p0, bool p1, address p2, bool p3) internal view {
720 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,bool)", p0, p1, p2, p3));
721 	}
722 
723 	function log(uint256 p0, bool p1, address p2, address p3) internal view {
724 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,address)", p0, p1, p2, p3));
725 	}
726 
727 	function log(uint256 p0, address p1, uint256 p2, uint256 p3) internal view {
728 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,uint256)", p0, p1, p2, p3));
729 	}
730 
731 	function log(uint256 p0, address p1, uint256 p2, string memory p3) internal view {
732 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,string)", p0, p1, p2, p3));
733 	}
734 
735 	function log(uint256 p0, address p1, uint256 p2, bool p3) internal view {
736 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,bool)", p0, p1, p2, p3));
737 	}
738 
739 	function log(uint256 p0, address p1, uint256 p2, address p3) internal view {
740 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,address)", p0, p1, p2, p3));
741 	}
742 
743 	function log(uint256 p0, address p1, string memory p2, uint256 p3) internal view {
744 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,uint256)", p0, p1, p2, p3));
745 	}
746 
747 	function log(uint256 p0, address p1, string memory p2, string memory p3) internal view {
748 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,string)", p0, p1, p2, p3));
749 	}
750 
751 	function log(uint256 p0, address p1, string memory p2, bool p3) internal view {
752 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,bool)", p0, p1, p2, p3));
753 	}
754 
755 	function log(uint256 p0, address p1, string memory p2, address p3) internal view {
756 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,address)", p0, p1, p2, p3));
757 	}
758 
759 	function log(uint256 p0, address p1, bool p2, uint256 p3) internal view {
760 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,uint256)", p0, p1, p2, p3));
761 	}
762 
763 	function log(uint256 p0, address p1, bool p2, string memory p3) internal view {
764 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,string)", p0, p1, p2, p3));
765 	}
766 
767 	function log(uint256 p0, address p1, bool p2, bool p3) internal view {
768 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,bool)", p0, p1, p2, p3));
769 	}
770 
771 	function log(uint256 p0, address p1, bool p2, address p3) internal view {
772 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,address)", p0, p1, p2, p3));
773 	}
774 
775 	function log(uint256 p0, address p1, address p2, uint256 p3) internal view {
776 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,uint256)", p0, p1, p2, p3));
777 	}
778 
779 	function log(uint256 p0, address p1, address p2, string memory p3) internal view {
780 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,string)", p0, p1, p2, p3));
781 	}
782 
783 	function log(uint256 p0, address p1, address p2, bool p3) internal view {
784 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,bool)", p0, p1, p2, p3));
785 	}
786 
787 	function log(uint256 p0, address p1, address p2, address p3) internal view {
788 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,address)", p0, p1, p2, p3));
789 	}
790 
791 	function log(string memory p0, uint256 p1, uint256 p2, uint256 p3) internal view {
792 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,uint256)", p0, p1, p2, p3));
793 	}
794 
795 	function log(string memory p0, uint256 p1, uint256 p2, string memory p3) internal view {
796 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,string)", p0, p1, p2, p3));
797 	}
798 
799 	function log(string memory p0, uint256 p1, uint256 p2, bool p3) internal view {
800 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,bool)", p0, p1, p2, p3));
801 	}
802 
803 	function log(string memory p0, uint256 p1, uint256 p2, address p3) internal view {
804 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,address)", p0, p1, p2, p3));
805 	}
806 
807 	function log(string memory p0, uint256 p1, string memory p2, uint256 p3) internal view {
808 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,uint256)", p0, p1, p2, p3));
809 	}
810 
811 	function log(string memory p0, uint256 p1, string memory p2, string memory p3) internal view {
812 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,string)", p0, p1, p2, p3));
813 	}
814 
815 	function log(string memory p0, uint256 p1, string memory p2, bool p3) internal view {
816 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,bool)", p0, p1, p2, p3));
817 	}
818 
819 	function log(string memory p0, uint256 p1, string memory p2, address p3) internal view {
820 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,address)", p0, p1, p2, p3));
821 	}
822 
823 	function log(string memory p0, uint256 p1, bool p2, uint256 p3) internal view {
824 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,uint256)", p0, p1, p2, p3));
825 	}
826 
827 	function log(string memory p0, uint256 p1, bool p2, string memory p3) internal view {
828 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,string)", p0, p1, p2, p3));
829 	}
830 
831 	function log(string memory p0, uint256 p1, bool p2, bool p3) internal view {
832 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,bool)", p0, p1, p2, p3));
833 	}
834 
835 	function log(string memory p0, uint256 p1, bool p2, address p3) internal view {
836 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,address)", p0, p1, p2, p3));
837 	}
838 
839 	function log(string memory p0, uint256 p1, address p2, uint256 p3) internal view {
840 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,uint256)", p0, p1, p2, p3));
841 	}
842 
843 	function log(string memory p0, uint256 p1, address p2, string memory p3) internal view {
844 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,string)", p0, p1, p2, p3));
845 	}
846 
847 	function log(string memory p0, uint256 p1, address p2, bool p3) internal view {
848 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,bool)", p0, p1, p2, p3));
849 	}
850 
851 	function log(string memory p0, uint256 p1, address p2, address p3) internal view {
852 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,address)", p0, p1, p2, p3));
853 	}
854 
855 	function log(string memory p0, string memory p1, uint256 p2, uint256 p3) internal view {
856 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,uint256)", p0, p1, p2, p3));
857 	}
858 
859 	function log(string memory p0, string memory p1, uint256 p2, string memory p3) internal view {
860 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,string)", p0, p1, p2, p3));
861 	}
862 
863 	function log(string memory p0, string memory p1, uint256 p2, bool p3) internal view {
864 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,bool)", p0, p1, p2, p3));
865 	}
866 
867 	function log(string memory p0, string memory p1, uint256 p2, address p3) internal view {
868 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,address)", p0, p1, p2, p3));
869 	}
870 
871 	function log(string memory p0, string memory p1, string memory p2, uint256 p3) internal view {
872 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint256)", p0, p1, p2, p3));
873 	}
874 
875 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
876 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
877 	}
878 
879 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
880 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
881 	}
882 
883 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
884 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
885 	}
886 
887 	function log(string memory p0, string memory p1, bool p2, uint256 p3) internal view {
888 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint256)", p0, p1, p2, p3));
889 	}
890 
891 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
892 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
893 	}
894 
895 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
896 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
897 	}
898 
899 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
900 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
901 	}
902 
903 	function log(string memory p0, string memory p1, address p2, uint256 p3) internal view {
904 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint256)", p0, p1, p2, p3));
905 	}
906 
907 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
908 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
909 	}
910 
911 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
912 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
913 	}
914 
915 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
916 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
917 	}
918 
919 	function log(string memory p0, bool p1, uint256 p2, uint256 p3) internal view {
920 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,uint256)", p0, p1, p2, p3));
921 	}
922 
923 	function log(string memory p0, bool p1, uint256 p2, string memory p3) internal view {
924 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,string)", p0, p1, p2, p3));
925 	}
926 
927 	function log(string memory p0, bool p1, uint256 p2, bool p3) internal view {
928 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,bool)", p0, p1, p2, p3));
929 	}
930 
931 	function log(string memory p0, bool p1, uint256 p2, address p3) internal view {
932 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,address)", p0, p1, p2, p3));
933 	}
934 
935 	function log(string memory p0, bool p1, string memory p2, uint256 p3) internal view {
936 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint256)", p0, p1, p2, p3));
937 	}
938 
939 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
940 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
941 	}
942 
943 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
944 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
945 	}
946 
947 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
948 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
949 	}
950 
951 	function log(string memory p0, bool p1, bool p2, uint256 p3) internal view {
952 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint256)", p0, p1, p2, p3));
953 	}
954 
955 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
956 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
957 	}
958 
959 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
960 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
961 	}
962 
963 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
964 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
965 	}
966 
967 	function log(string memory p0, bool p1, address p2, uint256 p3) internal view {
968 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint256)", p0, p1, p2, p3));
969 	}
970 
971 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
972 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
973 	}
974 
975 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
976 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
977 	}
978 
979 	function log(string memory p0, bool p1, address p2, address p3) internal view {
980 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
981 	}
982 
983 	function log(string memory p0, address p1, uint256 p2, uint256 p3) internal view {
984 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,uint256)", p0, p1, p2, p3));
985 	}
986 
987 	function log(string memory p0, address p1, uint256 p2, string memory p3) internal view {
988 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,string)", p0, p1, p2, p3));
989 	}
990 
991 	function log(string memory p0, address p1, uint256 p2, bool p3) internal view {
992 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,bool)", p0, p1, p2, p3));
993 	}
994 
995 	function log(string memory p0, address p1, uint256 p2, address p3) internal view {
996 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,address)", p0, p1, p2, p3));
997 	}
998 
999 	function log(string memory p0, address p1, string memory p2, uint256 p3) internal view {
1000 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint256)", p0, p1, p2, p3));
1001 	}
1002 
1003 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
1004 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
1005 	}
1006 
1007 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
1008 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
1009 	}
1010 
1011 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
1012 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
1013 	}
1014 
1015 	function log(string memory p0, address p1, bool p2, uint256 p3) internal view {
1016 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint256)", p0, p1, p2, p3));
1017 	}
1018 
1019 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
1020 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
1021 	}
1022 
1023 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
1024 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
1025 	}
1026 
1027 	function log(string memory p0, address p1, bool p2, address p3) internal view {
1028 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
1029 	}
1030 
1031 	function log(string memory p0, address p1, address p2, uint256 p3) internal view {
1032 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint256)", p0, p1, p2, p3));
1033 	}
1034 
1035 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
1036 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
1037 	}
1038 
1039 	function log(string memory p0, address p1, address p2, bool p3) internal view {
1040 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
1041 	}
1042 
1043 	function log(string memory p0, address p1, address p2, address p3) internal view {
1044 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
1045 	}
1046 
1047 	function log(bool p0, uint256 p1, uint256 p2, uint256 p3) internal view {
1048 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,uint256)", p0, p1, p2, p3));
1049 	}
1050 
1051 	function log(bool p0, uint256 p1, uint256 p2, string memory p3) internal view {
1052 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,string)", p0, p1, p2, p3));
1053 	}
1054 
1055 	function log(bool p0, uint256 p1, uint256 p2, bool p3) internal view {
1056 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,bool)", p0, p1, p2, p3));
1057 	}
1058 
1059 	function log(bool p0, uint256 p1, uint256 p2, address p3) internal view {
1060 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,address)", p0, p1, p2, p3));
1061 	}
1062 
1063 	function log(bool p0, uint256 p1, string memory p2, uint256 p3) internal view {
1064 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,uint256)", p0, p1, p2, p3));
1065 	}
1066 
1067 	function log(bool p0, uint256 p1, string memory p2, string memory p3) internal view {
1068 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,string)", p0, p1, p2, p3));
1069 	}
1070 
1071 	function log(bool p0, uint256 p1, string memory p2, bool p3) internal view {
1072 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,bool)", p0, p1, p2, p3));
1073 	}
1074 
1075 	function log(bool p0, uint256 p1, string memory p2, address p3) internal view {
1076 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,address)", p0, p1, p2, p3));
1077 	}
1078 
1079 	function log(bool p0, uint256 p1, bool p2, uint256 p3) internal view {
1080 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,uint256)", p0, p1, p2, p3));
1081 	}
1082 
1083 	function log(bool p0, uint256 p1, bool p2, string memory p3) internal view {
1084 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,string)", p0, p1, p2, p3));
1085 	}
1086 
1087 	function log(bool p0, uint256 p1, bool p2, bool p3) internal view {
1088 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,bool)", p0, p1, p2, p3));
1089 	}
1090 
1091 	function log(bool p0, uint256 p1, bool p2, address p3) internal view {
1092 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,address)", p0, p1, p2, p3));
1093 	}
1094 
1095 	function log(bool p0, uint256 p1, address p2, uint256 p3) internal view {
1096 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,uint256)", p0, p1, p2, p3));
1097 	}
1098 
1099 	function log(bool p0, uint256 p1, address p2, string memory p3) internal view {
1100 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,string)", p0, p1, p2, p3));
1101 	}
1102 
1103 	function log(bool p0, uint256 p1, address p2, bool p3) internal view {
1104 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,bool)", p0, p1, p2, p3));
1105 	}
1106 
1107 	function log(bool p0, uint256 p1, address p2, address p3) internal view {
1108 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,address)", p0, p1, p2, p3));
1109 	}
1110 
1111 	function log(bool p0, string memory p1, uint256 p2, uint256 p3) internal view {
1112 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,uint256)", p0, p1, p2, p3));
1113 	}
1114 
1115 	function log(bool p0, string memory p1, uint256 p2, string memory p3) internal view {
1116 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,string)", p0, p1, p2, p3));
1117 	}
1118 
1119 	function log(bool p0, string memory p1, uint256 p2, bool p3) internal view {
1120 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,bool)", p0, p1, p2, p3));
1121 	}
1122 
1123 	function log(bool p0, string memory p1, uint256 p2, address p3) internal view {
1124 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,address)", p0, p1, p2, p3));
1125 	}
1126 
1127 	function log(bool p0, string memory p1, string memory p2, uint256 p3) internal view {
1128 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint256)", p0, p1, p2, p3));
1129 	}
1130 
1131 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
1132 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
1133 	}
1134 
1135 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
1136 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
1137 	}
1138 
1139 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
1140 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
1141 	}
1142 
1143 	function log(bool p0, string memory p1, bool p2, uint256 p3) internal view {
1144 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint256)", p0, p1, p2, p3));
1145 	}
1146 
1147 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
1148 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
1149 	}
1150 
1151 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
1152 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
1153 	}
1154 
1155 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
1156 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
1157 	}
1158 
1159 	function log(bool p0, string memory p1, address p2, uint256 p3) internal view {
1160 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint256)", p0, p1, p2, p3));
1161 	}
1162 
1163 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
1164 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
1165 	}
1166 
1167 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
1168 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
1169 	}
1170 
1171 	function log(bool p0, string memory p1, address p2, address p3) internal view {
1172 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
1173 	}
1174 
1175 	function log(bool p0, bool p1, uint256 p2, uint256 p3) internal view {
1176 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,uint256)", p0, p1, p2, p3));
1177 	}
1178 
1179 	function log(bool p0, bool p1, uint256 p2, string memory p3) internal view {
1180 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,string)", p0, p1, p2, p3));
1181 	}
1182 
1183 	function log(bool p0, bool p1, uint256 p2, bool p3) internal view {
1184 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,bool)", p0, p1, p2, p3));
1185 	}
1186 
1187 	function log(bool p0, bool p1, uint256 p2, address p3) internal view {
1188 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,address)", p0, p1, p2, p3));
1189 	}
1190 
1191 	function log(bool p0, bool p1, string memory p2, uint256 p3) internal view {
1192 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint256)", p0, p1, p2, p3));
1193 	}
1194 
1195 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
1196 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
1197 	}
1198 
1199 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
1200 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
1201 	}
1202 
1203 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
1204 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
1205 	}
1206 
1207 	function log(bool p0, bool p1, bool p2, uint256 p3) internal view {
1208 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint256)", p0, p1, p2, p3));
1209 	}
1210 
1211 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
1212 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
1213 	}
1214 
1215 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
1216 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
1217 	}
1218 
1219 	function log(bool p0, bool p1, bool p2, address p3) internal view {
1220 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
1221 	}
1222 
1223 	function log(bool p0, bool p1, address p2, uint256 p3) internal view {
1224 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint256)", p0, p1, p2, p3));
1225 	}
1226 
1227 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
1228 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
1229 	}
1230 
1231 	function log(bool p0, bool p1, address p2, bool p3) internal view {
1232 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
1233 	}
1234 
1235 	function log(bool p0, bool p1, address p2, address p3) internal view {
1236 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
1237 	}
1238 
1239 	function log(bool p0, address p1, uint256 p2, uint256 p3) internal view {
1240 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,uint256)", p0, p1, p2, p3));
1241 	}
1242 
1243 	function log(bool p0, address p1, uint256 p2, string memory p3) internal view {
1244 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,string)", p0, p1, p2, p3));
1245 	}
1246 
1247 	function log(bool p0, address p1, uint256 p2, bool p3) internal view {
1248 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,bool)", p0, p1, p2, p3));
1249 	}
1250 
1251 	function log(bool p0, address p1, uint256 p2, address p3) internal view {
1252 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,address)", p0, p1, p2, p3));
1253 	}
1254 
1255 	function log(bool p0, address p1, string memory p2, uint256 p3) internal view {
1256 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint256)", p0, p1, p2, p3));
1257 	}
1258 
1259 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
1260 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
1261 	}
1262 
1263 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
1264 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
1265 	}
1266 
1267 	function log(bool p0, address p1, string memory p2, address p3) internal view {
1268 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
1269 	}
1270 
1271 	function log(bool p0, address p1, bool p2, uint256 p3) internal view {
1272 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint256)", p0, p1, p2, p3));
1273 	}
1274 
1275 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
1276 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
1277 	}
1278 
1279 	function log(bool p0, address p1, bool p2, bool p3) internal view {
1280 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
1281 	}
1282 
1283 	function log(bool p0, address p1, bool p2, address p3) internal view {
1284 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
1285 	}
1286 
1287 	function log(bool p0, address p1, address p2, uint256 p3) internal view {
1288 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint256)", p0, p1, p2, p3));
1289 	}
1290 
1291 	function log(bool p0, address p1, address p2, string memory p3) internal view {
1292 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
1293 	}
1294 
1295 	function log(bool p0, address p1, address p2, bool p3) internal view {
1296 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
1297 	}
1298 
1299 	function log(bool p0, address p1, address p2, address p3) internal view {
1300 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
1301 	}
1302 
1303 	function log(address p0, uint256 p1, uint256 p2, uint256 p3) internal view {
1304 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,uint256)", p0, p1, p2, p3));
1305 	}
1306 
1307 	function log(address p0, uint256 p1, uint256 p2, string memory p3) internal view {
1308 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,string)", p0, p1, p2, p3));
1309 	}
1310 
1311 	function log(address p0, uint256 p1, uint256 p2, bool p3) internal view {
1312 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,bool)", p0, p1, p2, p3));
1313 	}
1314 
1315 	function log(address p0, uint256 p1, uint256 p2, address p3) internal view {
1316 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,address)", p0, p1, p2, p3));
1317 	}
1318 
1319 	function log(address p0, uint256 p1, string memory p2, uint256 p3) internal view {
1320 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,uint256)", p0, p1, p2, p3));
1321 	}
1322 
1323 	function log(address p0, uint256 p1, string memory p2, string memory p3) internal view {
1324 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,string)", p0, p1, p2, p3));
1325 	}
1326 
1327 	function log(address p0, uint256 p1, string memory p2, bool p3) internal view {
1328 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,bool)", p0, p1, p2, p3));
1329 	}
1330 
1331 	function log(address p0, uint256 p1, string memory p2, address p3) internal view {
1332 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,address)", p0, p1, p2, p3));
1333 	}
1334 
1335 	function log(address p0, uint256 p1, bool p2, uint256 p3) internal view {
1336 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,uint256)", p0, p1, p2, p3));
1337 	}
1338 
1339 	function log(address p0, uint256 p1, bool p2, string memory p3) internal view {
1340 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,string)", p0, p1, p2, p3));
1341 	}
1342 
1343 	function log(address p0, uint256 p1, bool p2, bool p3) internal view {
1344 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,bool)", p0, p1, p2, p3));
1345 	}
1346 
1347 	function log(address p0, uint256 p1, bool p2, address p3) internal view {
1348 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,address)", p0, p1, p2, p3));
1349 	}
1350 
1351 	function log(address p0, uint256 p1, address p2, uint256 p3) internal view {
1352 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,uint256)", p0, p1, p2, p3));
1353 	}
1354 
1355 	function log(address p0, uint256 p1, address p2, string memory p3) internal view {
1356 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,string)", p0, p1, p2, p3));
1357 	}
1358 
1359 	function log(address p0, uint256 p1, address p2, bool p3) internal view {
1360 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,bool)", p0, p1, p2, p3));
1361 	}
1362 
1363 	function log(address p0, uint256 p1, address p2, address p3) internal view {
1364 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,address)", p0, p1, p2, p3));
1365 	}
1366 
1367 	function log(address p0, string memory p1, uint256 p2, uint256 p3) internal view {
1368 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,uint256)", p0, p1, p2, p3));
1369 	}
1370 
1371 	function log(address p0, string memory p1, uint256 p2, string memory p3) internal view {
1372 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,string)", p0, p1, p2, p3));
1373 	}
1374 
1375 	function log(address p0, string memory p1, uint256 p2, bool p3) internal view {
1376 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,bool)", p0, p1, p2, p3));
1377 	}
1378 
1379 	function log(address p0, string memory p1, uint256 p2, address p3) internal view {
1380 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,address)", p0, p1, p2, p3));
1381 	}
1382 
1383 	function log(address p0, string memory p1, string memory p2, uint256 p3) internal view {
1384 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint256)", p0, p1, p2, p3));
1385 	}
1386 
1387 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
1388 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
1389 	}
1390 
1391 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
1392 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
1393 	}
1394 
1395 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
1396 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
1397 	}
1398 
1399 	function log(address p0, string memory p1, bool p2, uint256 p3) internal view {
1400 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint256)", p0, p1, p2, p3));
1401 	}
1402 
1403 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
1404 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
1405 	}
1406 
1407 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
1408 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
1409 	}
1410 
1411 	function log(address p0, string memory p1, bool p2, address p3) internal view {
1412 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
1413 	}
1414 
1415 	function log(address p0, string memory p1, address p2, uint256 p3) internal view {
1416 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint256)", p0, p1, p2, p3));
1417 	}
1418 
1419 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
1420 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
1421 	}
1422 
1423 	function log(address p0, string memory p1, address p2, bool p3) internal view {
1424 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
1425 	}
1426 
1427 	function log(address p0, string memory p1, address p2, address p3) internal view {
1428 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
1429 	}
1430 
1431 	function log(address p0, bool p1, uint256 p2, uint256 p3) internal view {
1432 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,uint256)", p0, p1, p2, p3));
1433 	}
1434 
1435 	function log(address p0, bool p1, uint256 p2, string memory p3) internal view {
1436 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,string)", p0, p1, p2, p3));
1437 	}
1438 
1439 	function log(address p0, bool p1, uint256 p2, bool p3) internal view {
1440 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,bool)", p0, p1, p2, p3));
1441 	}
1442 
1443 	function log(address p0, bool p1, uint256 p2, address p3) internal view {
1444 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,address)", p0, p1, p2, p3));
1445 	}
1446 
1447 	function log(address p0, bool p1, string memory p2, uint256 p3) internal view {
1448 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint256)", p0, p1, p2, p3));
1449 	}
1450 
1451 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
1452 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
1453 	}
1454 
1455 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
1456 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
1457 	}
1458 
1459 	function log(address p0, bool p1, string memory p2, address p3) internal view {
1460 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
1461 	}
1462 
1463 	function log(address p0, bool p1, bool p2, uint256 p3) internal view {
1464 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint256)", p0, p1, p2, p3));
1465 	}
1466 
1467 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
1468 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
1469 	}
1470 
1471 	function log(address p0, bool p1, bool p2, bool p3) internal view {
1472 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
1473 	}
1474 
1475 	function log(address p0, bool p1, bool p2, address p3) internal view {
1476 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
1477 	}
1478 
1479 	function log(address p0, bool p1, address p2, uint256 p3) internal view {
1480 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint256)", p0, p1, p2, p3));
1481 	}
1482 
1483 	function log(address p0, bool p1, address p2, string memory p3) internal view {
1484 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
1485 	}
1486 
1487 	function log(address p0, bool p1, address p2, bool p3) internal view {
1488 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
1489 	}
1490 
1491 	function log(address p0, bool p1, address p2, address p3) internal view {
1492 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
1493 	}
1494 
1495 	function log(address p0, address p1, uint256 p2, uint256 p3) internal view {
1496 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,uint256)", p0, p1, p2, p3));
1497 	}
1498 
1499 	function log(address p0, address p1, uint256 p2, string memory p3) internal view {
1500 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,string)", p0, p1, p2, p3));
1501 	}
1502 
1503 	function log(address p0, address p1, uint256 p2, bool p3) internal view {
1504 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,bool)", p0, p1, p2, p3));
1505 	}
1506 
1507 	function log(address p0, address p1, uint256 p2, address p3) internal view {
1508 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,address)", p0, p1, p2, p3));
1509 	}
1510 
1511 	function log(address p0, address p1, string memory p2, uint256 p3) internal view {
1512 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint256)", p0, p1, p2, p3));
1513 	}
1514 
1515 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
1516 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
1517 	}
1518 
1519 	function log(address p0, address p1, string memory p2, bool p3) internal view {
1520 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
1521 	}
1522 
1523 	function log(address p0, address p1, string memory p2, address p3) internal view {
1524 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
1525 	}
1526 
1527 	function log(address p0, address p1, bool p2, uint256 p3) internal view {
1528 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint256)", p0, p1, p2, p3));
1529 	}
1530 
1531 	function log(address p0, address p1, bool p2, string memory p3) internal view {
1532 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
1533 	}
1534 
1535 	function log(address p0, address p1, bool p2, bool p3) internal view {
1536 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
1537 	}
1538 
1539 	function log(address p0, address p1, bool p2, address p3) internal view {
1540 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
1541 	}
1542 
1543 	function log(address p0, address p1, address p2, uint256 p3) internal view {
1544 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint256)", p0, p1, p2, p3));
1545 	}
1546 
1547 	function log(address p0, address p1, address p2, string memory p3) internal view {
1548 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
1549 	}
1550 
1551 	function log(address p0, address p1, address p2, bool p3) internal view {
1552 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
1553 	}
1554 
1555 	function log(address p0, address p1, address p2, address p3) internal view {
1556 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
1557 	}
1558 
1559 }
1560 
1561 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1562 
1563 
1564 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1565 
1566 pragma solidity ^0.8.0;
1567 
1568 /**
1569  * @dev Interface of the ERC20 standard as defined in the EIP.
1570  */
1571 interface IERC20 {
1572     /**
1573      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1574      * another (`to`).
1575      *
1576      * Note that `value` may be zero.
1577      */
1578     event Transfer(address indexed from, address indexed to, uint256 value);
1579 
1580     /**
1581      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1582      * a call to {approve}. `value` is the new allowance.
1583      */
1584     event Approval(address indexed owner, address indexed spender, uint256 value);
1585 
1586     /**
1587      * @dev Returns the amount of tokens in existence.
1588      */
1589     function totalSupply() external view returns (uint256);
1590 
1591     /**
1592      * @dev Returns the amount of tokens owned by `account`.
1593      */
1594     function balanceOf(address account) external view returns (uint256);
1595 
1596     /**
1597      * @dev Moves `amount` tokens from the caller's account to `to`.
1598      *
1599      * Returns a boolean value indicating whether the operation succeeded.
1600      *
1601      * Emits a {Transfer} event.
1602      */
1603     function transfer(address to, uint256 amount) external returns (bool);
1604 
1605     /**
1606      * @dev Returns the remaining number of tokens that `spender` will be
1607      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1608      * zero by default.
1609      *
1610      * This value changes when {approve} or {transferFrom} are called.
1611      */
1612     function allowance(address owner, address spender) external view returns (uint256);
1613 
1614     /**
1615      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1616      *
1617      * Returns a boolean value indicating whether the operation succeeded.
1618      *
1619      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1620      * that someone may use both the old and the new allowance by unfortunate
1621      * transaction ordering. One possible solution to mitigate this race
1622      * condition is to first reduce the spender's allowance to 0 and set the
1623      * desired value afterwards:
1624      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1625      *
1626      * Emits an {Approval} event.
1627      */
1628     function approve(address spender, uint256 amount) external returns (bool);
1629 
1630     /**
1631      * @dev Moves `amount` tokens from `from` to `to` using the
1632      * allowance mechanism. `amount` is then deducted from the caller's
1633      * allowance.
1634      *
1635      * Returns a boolean value indicating whether the operation succeeded.
1636      *
1637      * Emits a {Transfer} event.
1638      */
1639     function transferFrom(
1640         address from,
1641         address to,
1642         uint256 amount
1643     ) external returns (bool);
1644 }
1645 
1646 // File: operator-filter-registry/src/lib/Constants.sol
1647 
1648 
1649 pragma solidity ^0.8.13;
1650 
1651 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
1652 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
1653 
1654 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
1655 
1656 
1657 pragma solidity ^0.8.13;
1658 
1659 interface IOperatorFilterRegistry {
1660     /**
1661      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
1662      *         true if supplied registrant address is not registered.
1663      */
1664     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1665 
1666     /**
1667      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
1668      */
1669     function register(address registrant) external;
1670 
1671     /**
1672      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
1673      */
1674     function registerAndSubscribe(address registrant, address subscription) external;
1675 
1676     /**
1677      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
1678      *         address without subscribing.
1679      */
1680     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1681 
1682     /**
1683      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
1684      *         Note that this does not remove any filtered addresses or codeHashes.
1685      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
1686      */
1687     function unregister(address addr) external;
1688 
1689     /**
1690      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
1691      */
1692     function updateOperator(address registrant, address operator, bool filtered) external;
1693 
1694     /**
1695      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
1696      */
1697     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1698 
1699     /**
1700      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
1701      */
1702     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1703 
1704     /**
1705      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
1706      */
1707     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1708 
1709     /**
1710      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
1711      *         subscription if present.
1712      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
1713      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
1714      *         used.
1715      */
1716     function subscribe(address registrant, address registrantToSubscribe) external;
1717 
1718     /**
1719      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
1720      */
1721     function unsubscribe(address registrant, bool copyExistingEntries) external;
1722 
1723     /**
1724      * @notice Get the subscription address of a given registrant, if any.
1725      */
1726     function subscriptionOf(address addr) external returns (address registrant);
1727 
1728     /**
1729      * @notice Get the set of addresses subscribed to a given registrant.
1730      *         Note that order is not guaranteed as updates are made.
1731      */
1732     function subscribers(address registrant) external returns (address[] memory);
1733 
1734     /**
1735      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
1736      *         Note that order is not guaranteed as updates are made.
1737      */
1738     function subscriberAt(address registrant, uint256 index) external returns (address);
1739 
1740     /**
1741      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
1742      */
1743     function copyEntriesOf(address registrant, address registrantToCopy) external;
1744 
1745     /**
1746      * @notice Returns true if operator is filtered by a given address or its subscription.
1747      */
1748     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1749 
1750     /**
1751      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
1752      */
1753     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1754 
1755     /**
1756      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
1757      */
1758     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1759 
1760     /**
1761      * @notice Returns a list of filtered operators for a given address or its subscription.
1762      */
1763     function filteredOperators(address addr) external returns (address[] memory);
1764 
1765     /**
1766      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
1767      *         Note that order is not guaranteed as updates are made.
1768      */
1769     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1770 
1771     /**
1772      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
1773      *         its subscription.
1774      *         Note that order is not guaranteed as updates are made.
1775      */
1776     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1777 
1778     /**
1779      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
1780      *         its subscription.
1781      *         Note that order is not guaranteed as updates are made.
1782      */
1783     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1784 
1785     /**
1786      * @notice Returns true if an address has registered
1787      */
1788     function isRegistered(address addr) external returns (bool);
1789 
1790     /**
1791      * @dev Convenience method to compute the code hash of an arbitrary contract
1792      */
1793     function codeHashOf(address addr) external returns (bytes32);
1794 }
1795 
1796 // File: operator-filter-registry/src/OperatorFilterer.sol
1797 
1798 
1799 pragma solidity ^0.8.13;
1800 
1801 
1802 /**
1803  * @title  OperatorFilterer
1804  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1805  *         registrant's entries in the OperatorFilterRegistry.
1806  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1807  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1808  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1809  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
1810  *         administration methods on the contract itself to interact with the registry otherwise the subscription
1811  *         will be locked to the options set during construction.
1812  */
1813 
1814 abstract contract OperatorFilterer {
1815     /// @dev Emitted when an operator is not allowed.
1816     error OperatorNotAllowed(address operator);
1817 
1818     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1819         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
1820 
1821     /// @dev The constructor that is called when the contract is being deployed.
1822     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1823         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1824         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1825         // order for the modifier to filter addresses.
1826         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1827             if (subscribe) {
1828                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1829             } else {
1830                 if (subscriptionOrRegistrantToCopy != address(0)) {
1831                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1832                 } else {
1833                     OPERATOR_FILTER_REGISTRY.register(address(this));
1834                 }
1835             }
1836         }
1837     }
1838 
1839     /**
1840      * @dev A helper function to check if an operator is allowed.
1841      */
1842     modifier onlyAllowedOperator(address from) virtual {
1843         // Allow spending tokens from addresses with balance
1844         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1845         // from an EOA.
1846         if (from != msg.sender) {
1847             _checkFilterOperator(msg.sender);
1848         }
1849         _;
1850     }
1851 
1852     /**
1853      * @dev A helper function to check if an operator approval is allowed.
1854      */
1855     modifier onlyAllowedOperatorApproval(address operator) virtual {
1856         _checkFilterOperator(operator);
1857         _;
1858     }
1859 
1860     /**
1861      * @dev A helper function to check if an operator is allowed.
1862      */
1863     function _checkFilterOperator(address operator) internal view virtual {
1864         // Check registry code length to facilitate testing in environments without a deployed registry.
1865         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1866             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
1867             // may specify their own OperatorFilterRegistry implementations, which may behave differently
1868             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1869                 revert OperatorNotAllowed(operator);
1870             }
1871         }
1872     }
1873 }
1874 
1875 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
1876 
1877 
1878 pragma solidity ^0.8.13;
1879 
1880 
1881 /**
1882  * @title  DefaultOperatorFilterer
1883  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1884  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
1885  *         administration methods on the contract itself to interact with the registry otherwise the subscription
1886  *         will be locked to the options set during construction.
1887  */
1888 
1889 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1890     /// @dev The constructor that is called when the contract is being deployed.
1891     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
1892 }
1893 
1894 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
1895 
1896 
1897 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
1898 
1899 pragma solidity ^0.8.0;
1900 
1901 // CAUTION
1902 // This version of SafeMath should only be used with Solidity 0.8 or later,
1903 // because it relies on the compiler's built in overflow checks.
1904 
1905 /**
1906  * @dev Wrappers over Solidity's arithmetic operations.
1907  *
1908  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1909  * now has built in overflow checking.
1910  */
1911 library SafeMath {
1912     /**
1913      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1914      *
1915      * _Available since v3.4._
1916      */
1917     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1918         unchecked {
1919             uint256 c = a + b;
1920             if (c < a) return (false, 0);
1921             return (true, c);
1922         }
1923     }
1924 
1925     /**
1926      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
1927      *
1928      * _Available since v3.4._
1929      */
1930     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1931         unchecked {
1932             if (b > a) return (false, 0);
1933             return (true, a - b);
1934         }
1935     }
1936 
1937     /**
1938      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1939      *
1940      * _Available since v3.4._
1941      */
1942     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1943         unchecked {
1944             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1945             // benefit is lost if 'b' is also tested.
1946             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1947             if (a == 0) return (true, 0);
1948             uint256 c = a * b;
1949             if (c / a != b) return (false, 0);
1950             return (true, c);
1951         }
1952     }
1953 
1954     /**
1955      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1956      *
1957      * _Available since v3.4._
1958      */
1959     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1960         unchecked {
1961             if (b == 0) return (false, 0);
1962             return (true, a / b);
1963         }
1964     }
1965 
1966     /**
1967      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1968      *
1969      * _Available since v3.4._
1970      */
1971     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1972         unchecked {
1973             if (b == 0) return (false, 0);
1974             return (true, a % b);
1975         }
1976     }
1977 
1978     /**
1979      * @dev Returns the addition of two unsigned integers, reverting on
1980      * overflow.
1981      *
1982      * Counterpart to Solidity's `+` operator.
1983      *
1984      * Requirements:
1985      *
1986      * - Addition cannot overflow.
1987      */
1988     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1989         return a + b;
1990     }
1991 
1992     /**
1993      * @dev Returns the subtraction of two unsigned integers, reverting on
1994      * overflow (when the result is negative).
1995      *
1996      * Counterpart to Solidity's `-` operator.
1997      *
1998      * Requirements:
1999      *
2000      * - Subtraction cannot overflow.
2001      */
2002     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
2003         return a - b;
2004     }
2005 
2006     /**
2007      * @dev Returns the multiplication of two unsigned integers, reverting on
2008      * overflow.
2009      *
2010      * Counterpart to Solidity's `*` operator.
2011      *
2012      * Requirements:
2013      *
2014      * - Multiplication cannot overflow.
2015      */
2016     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
2017         return a * b;
2018     }
2019 
2020     /**
2021      * @dev Returns the integer division of two unsigned integers, reverting on
2022      * division by zero. The result is rounded towards zero.
2023      *
2024      * Counterpart to Solidity's `/` operator.
2025      *
2026      * Requirements:
2027      *
2028      * - The divisor cannot be zero.
2029      */
2030     function div(uint256 a, uint256 b) internal pure returns (uint256) {
2031         return a / b;
2032     }
2033 
2034     /**
2035      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
2036      * reverting when dividing by zero.
2037      *
2038      * Counterpart to Solidity's `%` operator. This function uses a `revert`
2039      * opcode (which leaves remaining gas untouched) while Solidity uses an
2040      * invalid opcode to revert (consuming all remaining gas).
2041      *
2042      * Requirements:
2043      *
2044      * - The divisor cannot be zero.
2045      */
2046     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
2047         return a % b;
2048     }
2049 
2050     /**
2051      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
2052      * overflow (when the result is negative).
2053      *
2054      * CAUTION: This function is deprecated because it requires allocating memory for the error
2055      * message unnecessarily. For custom revert reasons use {trySub}.
2056      *
2057      * Counterpart to Solidity's `-` operator.
2058      *
2059      * Requirements:
2060      *
2061      * - Subtraction cannot overflow.
2062      */
2063     function sub(
2064         uint256 a,
2065         uint256 b,
2066         string memory errorMessage
2067     ) internal pure returns (uint256) {
2068         unchecked {
2069             require(b <= a, errorMessage);
2070             return a - b;
2071         }
2072     }
2073 
2074     /**
2075      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
2076      * division by zero. The result is rounded towards zero.
2077      *
2078      * Counterpart to Solidity's `/` operator. Note: this function uses a
2079      * `revert` opcode (which leaves remaining gas untouched) while Solidity
2080      * uses an invalid opcode to revert (consuming all remaining gas).
2081      *
2082      * Requirements:
2083      *
2084      * - The divisor cannot be zero.
2085      */
2086     function div(
2087         uint256 a,
2088         uint256 b,
2089         string memory errorMessage
2090     ) internal pure returns (uint256) {
2091         unchecked {
2092             require(b > 0, errorMessage);
2093             return a / b;
2094         }
2095     }
2096 
2097     /**
2098      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
2099      * reverting with custom message when dividing by zero.
2100      *
2101      * CAUTION: This function is deprecated because it requires allocating memory for the error
2102      * message unnecessarily. For custom revert reasons use {tryMod}.
2103      *
2104      * Counterpart to Solidity's `%` operator. This function uses a `revert`
2105      * opcode (which leaves remaining gas untouched) while Solidity uses an
2106      * invalid opcode to revert (consuming all remaining gas).
2107      *
2108      * Requirements:
2109      *
2110      * - The divisor cannot be zero.
2111      */
2112     function mod(
2113         uint256 a,
2114         uint256 b,
2115         string memory errorMessage
2116     ) internal pure returns (uint256) {
2117         unchecked {
2118             require(b > 0, errorMessage);
2119             return a % b;
2120         }
2121     }
2122 }
2123 
2124 // File: @openzeppelin/contracts/utils/Counters.sol
2125 
2126 
2127 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
2128 
2129 pragma solidity ^0.8.0;
2130 
2131 /**
2132  * @title Counters
2133  * @author Matt Condon (@shrugs)
2134  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
2135  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
2136  *
2137  * Include with `using Counters for Counters.Counter;`
2138  */
2139 library Counters {
2140     struct Counter {
2141         // This variable should never be directly accessed by users of the library: interactions must be restricted to
2142         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
2143         // this feature: see https://github.com/ethereum/solidity/issues/4637
2144         uint256 _value; // default: 0
2145     }
2146 
2147     function current(Counter storage counter) internal view returns (uint256) {
2148         return counter._value;
2149     }
2150 
2151     function increment(Counter storage counter) internal {
2152         unchecked {
2153             counter._value += 1;
2154         }
2155     }
2156 
2157     function decrement(Counter storage counter) internal {
2158         uint256 value = counter._value;
2159         require(value > 0, "Counter: decrement overflow");
2160         unchecked {
2161             counter._value = value - 1;
2162         }
2163     }
2164 
2165     function reset(Counter storage counter) internal {
2166         counter._value = 0;
2167     }
2168 }
2169 
2170 // File: @openzeppelin/contracts/utils/math/Math.sol
2171 
2172 
2173 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
2174 
2175 pragma solidity ^0.8.0;
2176 
2177 /**
2178  * @dev Standard math utilities missing in the Solidity language.
2179  */
2180 library Math {
2181     enum Rounding {
2182         Down, // Toward negative infinity
2183         Up, // Toward infinity
2184         Zero // Toward zero
2185     }
2186 
2187     /**
2188      * @dev Returns the largest of two numbers.
2189      */
2190     function max(uint256 a, uint256 b) internal pure returns (uint256) {
2191         return a > b ? a : b;
2192     }
2193 
2194     /**
2195      * @dev Returns the smallest of two numbers.
2196      */
2197     function min(uint256 a, uint256 b) internal pure returns (uint256) {
2198         return a < b ? a : b;
2199     }
2200 
2201     /**
2202      * @dev Returns the average of two numbers. The result is rounded towards
2203      * zero.
2204      */
2205     function average(uint256 a, uint256 b) internal pure returns (uint256) {
2206         // (a + b) / 2 can overflow.
2207         return (a & b) + (a ^ b) / 2;
2208     }
2209 
2210     /**
2211      * @dev Returns the ceiling of the division of two numbers.
2212      *
2213      * This differs from standard division with `/` in that it rounds up instead
2214      * of rounding down.
2215      */
2216     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
2217         // (a + b - 1) / b can overflow on addition, so we distribute.
2218         return a == 0 ? 0 : (a - 1) / b + 1;
2219     }
2220 
2221     /**
2222      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
2223      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
2224      * with further edits by Uniswap Labs also under MIT license.
2225      */
2226     function mulDiv(
2227         uint256 x,
2228         uint256 y,
2229         uint256 denominator
2230     ) internal pure returns (uint256 result) {
2231         unchecked {
2232             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
2233             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
2234             // variables such that product = prod1 * 2^256 + prod0.
2235             uint256 prod0; // Least significant 256 bits of the product
2236             uint256 prod1; // Most significant 256 bits of the product
2237             assembly {
2238                 let mm := mulmod(x, y, not(0))
2239                 prod0 := mul(x, y)
2240                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
2241             }
2242 
2243             // Handle non-overflow cases, 256 by 256 division.
2244             if (prod1 == 0) {
2245                 return prod0 / denominator;
2246             }
2247 
2248             // Make sure the result is less than 2^256. Also prevents denominator == 0.
2249             require(denominator > prod1);
2250 
2251             ///////////////////////////////////////////////
2252             // 512 by 256 division.
2253             ///////////////////////////////////////////////
2254 
2255             // Make division exact by subtracting the remainder from [prod1 prod0].
2256             uint256 remainder;
2257             assembly {
2258                 // Compute remainder using mulmod.
2259                 remainder := mulmod(x, y, denominator)
2260 
2261                 // Subtract 256 bit number from 512 bit number.
2262                 prod1 := sub(prod1, gt(remainder, prod0))
2263                 prod0 := sub(prod0, remainder)
2264             }
2265 
2266             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
2267             // See https://cs.stackexchange.com/q/138556/92363.
2268 
2269             // Does not overflow because the denominator cannot be zero at this stage in the function.
2270             uint256 twos = denominator & (~denominator + 1);
2271             assembly {
2272                 // Divide denominator by twos.
2273                 denominator := div(denominator, twos)
2274 
2275                 // Divide [prod1 prod0] by twos.
2276                 prod0 := div(prod0, twos)
2277 
2278                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
2279                 twos := add(div(sub(0, twos), twos), 1)
2280             }
2281 
2282             // Shift in bits from prod1 into prod0.
2283             prod0 |= prod1 * twos;
2284 
2285             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
2286             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
2287             // four bits. That is, denominator * inv = 1 mod 2^4.
2288             uint256 inverse = (3 * denominator) ^ 2;
2289 
2290             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
2291             // in modular arithmetic, doubling the correct bits in each step.
2292             inverse *= 2 - denominator * inverse; // inverse mod 2^8
2293             inverse *= 2 - denominator * inverse; // inverse mod 2^16
2294             inverse *= 2 - denominator * inverse; // inverse mod 2^32
2295             inverse *= 2 - denominator * inverse; // inverse mod 2^64
2296             inverse *= 2 - denominator * inverse; // inverse mod 2^128
2297             inverse *= 2 - denominator * inverse; // inverse mod 2^256
2298 
2299             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
2300             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
2301             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
2302             // is no longer required.
2303             result = prod0 * inverse;
2304             return result;
2305         }
2306     }
2307 
2308     /**
2309      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
2310      */
2311     function mulDiv(
2312         uint256 x,
2313         uint256 y,
2314         uint256 denominator,
2315         Rounding rounding
2316     ) internal pure returns (uint256) {
2317         uint256 result = mulDiv(x, y, denominator);
2318         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
2319             result += 1;
2320         }
2321         return result;
2322     }
2323 
2324     /**
2325      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
2326      *
2327      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
2328      */
2329     function sqrt(uint256 a) internal pure returns (uint256) {
2330         if (a == 0) {
2331             return 0;
2332         }
2333 
2334         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
2335         //
2336         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
2337         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
2338         //
2339         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
2340         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
2341         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
2342         //
2343         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
2344         uint256 result = 1 << (log2(a) >> 1);
2345 
2346         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
2347         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
2348         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
2349         // into the expected uint128 result.
2350         unchecked {
2351             result = (result + a / result) >> 1;
2352             result = (result + a / result) >> 1;
2353             result = (result + a / result) >> 1;
2354             result = (result + a / result) >> 1;
2355             result = (result + a / result) >> 1;
2356             result = (result + a / result) >> 1;
2357             result = (result + a / result) >> 1;
2358             return min(result, a / result);
2359         }
2360     }
2361 
2362     /**
2363      * @notice Calculates sqrt(a), following the selected rounding direction.
2364      */
2365     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
2366         unchecked {
2367             uint256 result = sqrt(a);
2368             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
2369         }
2370     }
2371 
2372     /**
2373      * @dev Return the log in base 2, rounded down, of a positive value.
2374      * Returns 0 if given 0.
2375      */
2376     function log2(uint256 value) internal pure returns (uint256) {
2377         uint256 result = 0;
2378         unchecked {
2379             if (value >> 128 > 0) {
2380                 value >>= 128;
2381                 result += 128;
2382             }
2383             if (value >> 64 > 0) {
2384                 value >>= 64;
2385                 result += 64;
2386             }
2387             if (value >> 32 > 0) {
2388                 value >>= 32;
2389                 result += 32;
2390             }
2391             if (value >> 16 > 0) {
2392                 value >>= 16;
2393                 result += 16;
2394             }
2395             if (value >> 8 > 0) {
2396                 value >>= 8;
2397                 result += 8;
2398             }
2399             if (value >> 4 > 0) {
2400                 value >>= 4;
2401                 result += 4;
2402             }
2403             if (value >> 2 > 0) {
2404                 value >>= 2;
2405                 result += 2;
2406             }
2407             if (value >> 1 > 0) {
2408                 result += 1;
2409             }
2410         }
2411         return result;
2412     }
2413 
2414     /**
2415      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
2416      * Returns 0 if given 0.
2417      */
2418     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
2419         unchecked {
2420             uint256 result = log2(value);
2421             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
2422         }
2423     }
2424 
2425     /**
2426      * @dev Return the log in base 10, rounded down, of a positive value.
2427      * Returns 0 if given 0.
2428      */
2429     function log10(uint256 value) internal pure returns (uint256) {
2430         uint256 result = 0;
2431         unchecked {
2432             if (value >= 10**64) {
2433                 value /= 10**64;
2434                 result += 64;
2435             }
2436             if (value >= 10**32) {
2437                 value /= 10**32;
2438                 result += 32;
2439             }
2440             if (value >= 10**16) {
2441                 value /= 10**16;
2442                 result += 16;
2443             }
2444             if (value >= 10**8) {
2445                 value /= 10**8;
2446                 result += 8;
2447             }
2448             if (value >= 10**4) {
2449                 value /= 10**4;
2450                 result += 4;
2451             }
2452             if (value >= 10**2) {
2453                 value /= 10**2;
2454                 result += 2;
2455             }
2456             if (value >= 10**1) {
2457                 result += 1;
2458             }
2459         }
2460         return result;
2461     }
2462 
2463     /**
2464      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
2465      * Returns 0 if given 0.
2466      */
2467     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
2468         unchecked {
2469             uint256 result = log10(value);
2470             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
2471         }
2472     }
2473 
2474     /**
2475      * @dev Return the log in base 256, rounded down, of a positive value.
2476      * Returns 0 if given 0.
2477      *
2478      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
2479      */
2480     function log256(uint256 value) internal pure returns (uint256) {
2481         uint256 result = 0;
2482         unchecked {
2483             if (value >> 128 > 0) {
2484                 value >>= 128;
2485                 result += 16;
2486             }
2487             if (value >> 64 > 0) {
2488                 value >>= 64;
2489                 result += 8;
2490             }
2491             if (value >> 32 > 0) {
2492                 value >>= 32;
2493                 result += 4;
2494             }
2495             if (value >> 16 > 0) {
2496                 value >>= 16;
2497                 result += 2;
2498             }
2499             if (value >> 8 > 0) {
2500                 result += 1;
2501             }
2502         }
2503         return result;
2504     }
2505 
2506     /**
2507      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
2508      * Returns 0 if given 0.
2509      */
2510     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
2511         unchecked {
2512             uint256 result = log256(value);
2513             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
2514         }
2515     }
2516 }
2517 
2518 // File: @openzeppelin/contracts/utils/Strings.sol
2519 
2520 
2521 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
2522 
2523 pragma solidity ^0.8.0;
2524 
2525 
2526 /**
2527  * @dev String operations.
2528  */
2529 library Strings {
2530     bytes16 private constant _SYMBOLS = "0123456789abcdef";
2531     uint8 private constant _ADDRESS_LENGTH = 20;
2532 
2533     /**
2534      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2535      */
2536     function toString(uint256 value) internal pure returns (string memory) {
2537         unchecked {
2538             uint256 length = Math.log10(value) + 1;
2539             string memory buffer = new string(length);
2540             uint256 ptr;
2541             /// @solidity memory-safe-assembly
2542             assembly {
2543                 ptr := add(buffer, add(32, length))
2544             }
2545             while (true) {
2546                 ptr--;
2547                 /// @solidity memory-safe-assembly
2548                 assembly {
2549                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
2550                 }
2551                 value /= 10;
2552                 if (value == 0) break;
2553             }
2554             return buffer;
2555         }
2556     }
2557 
2558     /**
2559      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2560      */
2561     function toHexString(uint256 value) internal pure returns (string memory) {
2562         unchecked {
2563             return toHexString(value, Math.log256(value) + 1);
2564         }
2565     }
2566 
2567     /**
2568      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2569      */
2570     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2571         bytes memory buffer = new bytes(2 * length + 2);
2572         buffer[0] = "0";
2573         buffer[1] = "x";
2574         for (uint256 i = 2 * length + 1; i > 1; --i) {
2575             buffer[i] = _SYMBOLS[value & 0xf];
2576             value >>= 4;
2577         }
2578         require(value == 0, "Strings: hex length insufficient");
2579         return string(buffer);
2580     }
2581 
2582     /**
2583      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
2584      */
2585     function toHexString(address addr) internal pure returns (string memory) {
2586         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
2587     }
2588 }
2589 
2590 // File: @openzeppelin/contracts/utils/Address.sol
2591 
2592 
2593 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
2594 
2595 pragma solidity ^0.8.1;
2596 
2597 /**
2598  * @dev Collection of functions related to the address type
2599  */
2600 library Address {
2601     /**
2602      * @dev Returns true if `account` is a contract.
2603      *
2604      * [IMPORTANT]
2605      * ====
2606      * It is unsafe to assume that an address for which this function returns
2607      * false is an externally-owned account (EOA) and not a contract.
2608      *
2609      * Among others, `isContract` will return false for the following
2610      * types of addresses:
2611      *
2612      *  - an externally-owned account
2613      *  - a contract in construction
2614      *  - an address where a contract will be created
2615      *  - an address where a contract lived, but was destroyed
2616      * ====
2617      *
2618      * [IMPORTANT]
2619      * ====
2620      * You shouldn't rely on `isContract` to protect against flash loan attacks!
2621      *
2622      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
2623      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
2624      * constructor.
2625      * ====
2626      */
2627     function isContract(address account) internal view returns (bool) {
2628         // This method relies on extcodesize/address.code.length, which returns 0
2629         // for contracts in construction, since the code is only stored at the end
2630         // of the constructor execution.
2631 
2632         return account.code.length > 0;
2633     }
2634 
2635     /**
2636      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
2637      * `recipient`, forwarding all available gas and reverting on errors.
2638      *
2639      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
2640      * of certain opcodes, possibly making contracts go over the 2300 gas limit
2641      * imposed by `transfer`, making them unable to receive funds via
2642      * `transfer`. {sendValue} removes this limitation.
2643      *
2644      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
2645      *
2646      * IMPORTANT: because control is transferred to `recipient`, care must be
2647      * taken to not create reentrancy vulnerabilities. Consider using
2648      * {ReentrancyGuard} or the
2649      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
2650      */
2651     function sendValue(address payable recipient, uint256 amount) internal {
2652         require(address(this).balance >= amount, "Address: insufficient balance");
2653 
2654         (bool success, ) = recipient.call{value: amount}("");
2655         require(success, "Address: unable to send value, recipient may have reverted");
2656     }
2657 
2658     /**
2659      * @dev Performs a Solidity function call using a low level `call`. A
2660      * plain `call` is an unsafe replacement for a function call: use this
2661      * function instead.
2662      *
2663      * If `target` reverts with a revert reason, it is bubbled up by this
2664      * function (like regular Solidity function calls).
2665      *
2666      * Returns the raw returned data. To convert to the expected return value,
2667      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
2668      *
2669      * Requirements:
2670      *
2671      * - `target` must be a contract.
2672      * - calling `target` with `data` must not revert.
2673      *
2674      * _Available since v3.1._
2675      */
2676     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
2677         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
2678     }
2679 
2680     /**
2681      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
2682      * `errorMessage` as a fallback revert reason when `target` reverts.
2683      *
2684      * _Available since v3.1._
2685      */
2686     function functionCall(
2687         address target,
2688         bytes memory data,
2689         string memory errorMessage
2690     ) internal returns (bytes memory) {
2691         return functionCallWithValue(target, data, 0, errorMessage);
2692     }
2693 
2694     /**
2695      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2696      * but also transferring `value` wei to `target`.
2697      *
2698      * Requirements:
2699      *
2700      * - the calling contract must have an ETH balance of at least `value`.
2701      * - the called Solidity function must be `payable`.
2702      *
2703      * _Available since v3.1._
2704      */
2705     function functionCallWithValue(
2706         address target,
2707         bytes memory data,
2708         uint256 value
2709     ) internal returns (bytes memory) {
2710         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
2711     }
2712 
2713     /**
2714      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
2715      * with `errorMessage` as a fallback revert reason when `target` reverts.
2716      *
2717      * _Available since v3.1._
2718      */
2719     function functionCallWithValue(
2720         address target,
2721         bytes memory data,
2722         uint256 value,
2723         string memory errorMessage
2724     ) internal returns (bytes memory) {
2725         require(address(this).balance >= value, "Address: insufficient balance for call");
2726         (bool success, bytes memory returndata) = target.call{value: value}(data);
2727         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
2728     }
2729 
2730     /**
2731      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2732      * but performing a static call.
2733      *
2734      * _Available since v3.3._
2735      */
2736     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
2737         return functionStaticCall(target, data, "Address: low-level static call failed");
2738     }
2739 
2740     /**
2741      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2742      * but performing a static call.
2743      *
2744      * _Available since v3.3._
2745      */
2746     function functionStaticCall(
2747         address target,
2748         bytes memory data,
2749         string memory errorMessage
2750     ) internal view returns (bytes memory) {
2751         (bool success, bytes memory returndata) = target.staticcall(data);
2752         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
2753     }
2754 
2755     /**
2756      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2757      * but performing a delegate call.
2758      *
2759      * _Available since v3.4._
2760      */
2761     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
2762         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
2763     }
2764 
2765     /**
2766      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2767      * but performing a delegate call.
2768      *
2769      * _Available since v3.4._
2770      */
2771     function functionDelegateCall(
2772         address target,
2773         bytes memory data,
2774         string memory errorMessage
2775     ) internal returns (bytes memory) {
2776         (bool success, bytes memory returndata) = target.delegatecall(data);
2777         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
2778     }
2779 
2780     /**
2781      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
2782      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
2783      *
2784      * _Available since v4.8._
2785      */
2786     function verifyCallResultFromTarget(
2787         address target,
2788         bool success,
2789         bytes memory returndata,
2790         string memory errorMessage
2791     ) internal view returns (bytes memory) {
2792         if (success) {
2793             if (returndata.length == 0) {
2794                 // only check isContract if the call was successful and the return data is empty
2795                 // otherwise we already know that it was a contract
2796                 require(isContract(target), "Address: call to non-contract");
2797             }
2798             return returndata;
2799         } else {
2800             _revert(returndata, errorMessage);
2801         }
2802     }
2803 
2804     /**
2805      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
2806      * revert reason or using the provided one.
2807      *
2808      * _Available since v4.3._
2809      */
2810     function verifyCallResult(
2811         bool success,
2812         bytes memory returndata,
2813         string memory errorMessage
2814     ) internal pure returns (bytes memory) {
2815         if (success) {
2816             return returndata;
2817         } else {
2818             _revert(returndata, errorMessage);
2819         }
2820     }
2821 
2822     function _revert(bytes memory returndata, string memory errorMessage) private pure {
2823         // Look for revert reason and bubble it up if present
2824         if (returndata.length > 0) {
2825             // The easiest way to bubble the revert reason is using memory via assembly
2826             /// @solidity memory-safe-assembly
2827             assembly {
2828                 let returndata_size := mload(returndata)
2829                 revert(add(32, returndata), returndata_size)
2830             }
2831         } else {
2832             revert(errorMessage);
2833         }
2834     }
2835 }
2836 
2837 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
2838 
2839 
2840 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
2841 
2842 pragma solidity ^0.8.0;
2843 
2844 /**
2845  * @title ERC721 token receiver interface
2846  * @dev Interface for any contract that wants to support safeTransfers
2847  * from ERC721 asset contracts.
2848  */
2849 interface IERC721Receiver {
2850     /**
2851      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
2852      * by `operator` from `from`, this function is called.
2853      *
2854      * It must return its Solidity selector to confirm the token transfer.
2855      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
2856      *
2857      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
2858      */
2859     function onERC721Received(
2860         address operator,
2861         address from,
2862         uint256 tokenId,
2863         bytes calldata data
2864     ) external returns (bytes4);
2865 }
2866 
2867 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2868 
2869 
2870 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
2871 
2872 pragma solidity ^0.8.0;
2873 
2874 /**
2875  * @dev Interface of the ERC165 standard, as defined in the
2876  * https://eips.ethereum.org/EIPS/eip-165[EIP].
2877  *
2878  * Implementers can declare support of contract interfaces, which can then be
2879  * queried by others ({ERC165Checker}).
2880  *
2881  * For an implementation, see {ERC165}.
2882  */
2883 interface IERC165 {
2884     /**
2885      * @dev Returns true if this contract implements the interface defined by
2886      * `interfaceId`. See the corresponding
2887      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
2888      * to learn more about how these ids are created.
2889      *
2890      * This function call must use less than 30 000 gas.
2891      */
2892     function supportsInterface(bytes4 interfaceId) external view returns (bool);
2893 }
2894 
2895 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
2896 
2897 
2898 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
2899 
2900 pragma solidity ^0.8.0;
2901 
2902 
2903 /**
2904  * @dev Implementation of the {IERC165} interface.
2905  *
2906  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
2907  * for the additional interface id that will be supported. For example:
2908  *
2909  * ```solidity
2910  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2911  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
2912  * }
2913  * ```
2914  *
2915  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
2916  */
2917 abstract contract ERC165 is IERC165 {
2918     /**
2919      * @dev See {IERC165-supportsInterface}.
2920      */
2921     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2922         return interfaceId == type(IERC165).interfaceId;
2923     }
2924 }
2925 
2926 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
2927 
2928 
2929 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
2930 
2931 pragma solidity ^0.8.0;
2932 
2933 
2934 /**
2935  * @dev Required interface of an ERC721 compliant contract.
2936  */
2937 interface IERC721 is IERC165 {
2938     /**
2939      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
2940      */
2941     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
2942 
2943     /**
2944      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
2945      */
2946     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
2947 
2948     /**
2949      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
2950      */
2951     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
2952 
2953     /**
2954      * @dev Returns the number of tokens in ``owner``'s account.
2955      */
2956     function balanceOf(address owner) external view returns (uint256 balance);
2957 
2958     /**
2959      * @dev Returns the owner of the `tokenId` token.
2960      *
2961      * Requirements:
2962      *
2963      * - `tokenId` must exist.
2964      */
2965     function ownerOf(uint256 tokenId) external view returns (address owner);
2966 
2967     /**
2968      * @dev Safely transfers `tokenId` token from `from` to `to`.
2969      *
2970      * Requirements:
2971      *
2972      * - `from` cannot be the zero address.
2973      * - `to` cannot be the zero address.
2974      * - `tokenId` token must exist and be owned by `from`.
2975      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2976      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2977      *
2978      * Emits a {Transfer} event.
2979      */
2980     function safeTransferFrom(
2981         address from,
2982         address to,
2983         uint256 tokenId,
2984         bytes calldata data
2985     ) external;
2986 
2987     /**
2988      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2989      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2990      *
2991      * Requirements:
2992      *
2993      * - `from` cannot be the zero address.
2994      * - `to` cannot be the zero address.
2995      * - `tokenId` token must exist and be owned by `from`.
2996      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
2997      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2998      *
2999      * Emits a {Transfer} event.
3000      */
3001     function safeTransferFrom(
3002         address from,
3003         address to,
3004         uint256 tokenId
3005     ) external;
3006 
3007     /**
3008      * @dev Transfers `tokenId` token from `from` to `to`.
3009      *
3010      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
3011      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
3012      * understand this adds an external call which potentially creates a reentrancy vulnerability.
3013      *
3014      * Requirements:
3015      *
3016      * - `from` cannot be the zero address.
3017      * - `to` cannot be the zero address.
3018      * - `tokenId` token must be owned by `from`.
3019      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
3020      *
3021      * Emits a {Transfer} event.
3022      */
3023     function transferFrom(
3024         address from,
3025         address to,
3026         uint256 tokenId
3027     ) external;
3028 
3029     /**
3030      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
3031      * The approval is cleared when the token is transferred.
3032      *
3033      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
3034      *
3035      * Requirements:
3036      *
3037      * - The caller must own the token or be an approved operator.
3038      * - `tokenId` must exist.
3039      *
3040      * Emits an {Approval} event.
3041      */
3042     function approve(address to, uint256 tokenId) external;
3043 
3044     /**
3045      * @dev Approve or remove `operator` as an operator for the caller.
3046      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
3047      *
3048      * Requirements:
3049      *
3050      * - The `operator` cannot be the caller.
3051      *
3052      * Emits an {ApprovalForAll} event.
3053      */
3054     function setApprovalForAll(address operator, bool _approved) external;
3055 
3056     /**
3057      * @dev Returns the account approved for `tokenId` token.
3058      *
3059      * Requirements:
3060      *
3061      * - `tokenId` must exist.
3062      */
3063     function getApproved(uint256 tokenId) external view returns (address operator);
3064 
3065     /**
3066      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
3067      *
3068      * See {setApprovalForAll}
3069      */
3070     function isApprovedForAll(address owner, address operator) external view returns (bool);
3071 }
3072 
3073 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
3074 
3075 
3076 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
3077 
3078 pragma solidity ^0.8.0;
3079 
3080 
3081 /**
3082  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
3083  * @dev See https://eips.ethereum.org/EIPS/eip-721
3084  */
3085 interface IERC721Metadata is IERC721 {
3086     /**
3087      * @dev Returns the token collection name.
3088      */
3089     function name() external view returns (string memory);
3090 
3091     /**
3092      * @dev Returns the token collection symbol.
3093      */
3094     function symbol() external view returns (string memory);
3095 
3096     /**
3097      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
3098      */
3099     function tokenURI(uint256 tokenId) external view returns (string memory);
3100 }
3101 
3102 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
3103 
3104 
3105 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
3106 
3107 pragma solidity ^0.8.0;
3108 
3109 
3110 /**
3111  * @dev Interface for the NFT Royalty Standard.
3112  *
3113  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
3114  * support for royalty payments across all NFT marketplaces and ecosystem participants.
3115  *
3116  * _Available since v4.5._
3117  */
3118 interface IERC2981 is IERC165 {
3119     /**
3120      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
3121      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
3122      */
3123     function royaltyInfo(uint256 tokenId, uint256 salePrice)
3124         external
3125         view
3126         returns (address receiver, uint256 royaltyAmount);
3127 }
3128 
3129 // File: @openzeppelin/contracts/utils/Context.sol
3130 
3131 
3132 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
3133 
3134 pragma solidity ^0.8.0;
3135 
3136 /**
3137  * @dev Provides information about the current execution context, including the
3138  * sender of the transaction and its data. While these are generally available
3139  * via msg.sender and msg.data, they should not be accessed in such a direct
3140  * manner, since when dealing with meta-transactions the account sending and
3141  * paying for execution may not be the actual sender (as far as an application
3142  * is concerned).
3143  *
3144  * This contract is only required for intermediate, library-like contracts.
3145  */
3146 abstract contract Context {
3147     function _msgSender() internal view virtual returns (address) {
3148         return msg.sender;
3149     }
3150 
3151     function _msgData() internal view virtual returns (bytes calldata) {
3152         return msg.data;
3153     }
3154 }
3155 
3156 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
3157 
3158 
3159 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
3160 
3161 pragma solidity ^0.8.0;
3162 
3163 
3164 
3165 
3166 
3167 
3168 
3169 
3170 /**
3171  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
3172  * the Metadata extension, but not including the Enumerable extension, which is available separately as
3173  * {ERC721Enumerable}.
3174  */
3175 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
3176     using Address for address;
3177     using Strings for uint256;
3178 
3179     // Token name
3180     string private _name;
3181 
3182     // Token symbol
3183     string private _symbol;
3184 
3185     // Mapping from token ID to owner address
3186     mapping(uint256 => address) private _owners;
3187 
3188     // Mapping owner address to token count
3189     mapping(address => uint256) private _balances;
3190 
3191     // Mapping from token ID to approved address
3192     mapping(uint256 => address) private _tokenApprovals;
3193 
3194     // Mapping from owner to operator approvals
3195     mapping(address => mapping(address => bool)) private _operatorApprovals;
3196 
3197     /**
3198      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
3199      */
3200     constructor(string memory name_, string memory symbol_) {
3201         _name = name_;
3202         _symbol = symbol_;
3203     }
3204 
3205     /**
3206      * @dev See {IERC165-supportsInterface}.
3207      */
3208     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
3209         return
3210             interfaceId == type(IERC721).interfaceId ||
3211             interfaceId == type(IERC721Metadata).interfaceId ||
3212             super.supportsInterface(interfaceId);
3213     }
3214 
3215     /**
3216      * @dev See {IERC721-balanceOf}.
3217      */
3218     function balanceOf(address owner) public view virtual override returns (uint256) {
3219         require(owner != address(0), "ERC721: address zero is not a valid owner");
3220         return _balances[owner];
3221     }
3222 
3223     /**
3224      * @dev See {IERC721-ownerOf}.
3225      */
3226     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
3227         address owner = _ownerOf(tokenId);
3228         require(owner != address(0), "ERC721: invalid token ID");
3229         return owner;
3230     }
3231 
3232     /**
3233      * @dev See {IERC721Metadata-name}.
3234      */
3235     function name() public view virtual override returns (string memory) {
3236         return _name;
3237     }
3238 
3239     /**
3240      * @dev See {IERC721Metadata-symbol}.
3241      */
3242     function symbol() public view virtual override returns (string memory) {
3243         return _symbol;
3244     }
3245 
3246     /**
3247      * @dev See {IERC721Metadata-tokenURI}.
3248      */
3249     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
3250         _requireMinted(tokenId);
3251 
3252         string memory baseURI = _baseURI();
3253         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
3254     }
3255 
3256     /**
3257      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
3258      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
3259      * by default, can be overridden in child contracts.
3260      */
3261     function _baseURI() internal view virtual returns (string memory) {
3262         return "";
3263     }
3264 
3265     /**
3266      * @dev See {IERC721-approve}.
3267      */
3268     function approve(address to, uint256 tokenId) public virtual override {
3269         address owner = ERC721.ownerOf(tokenId);
3270         require(to != owner, "ERC721: approval to current owner");
3271 
3272         require(
3273             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
3274             "ERC721: approve caller is not token owner or approved for all"
3275         );
3276 
3277         _approve(to, tokenId);
3278     }
3279 
3280     /**
3281      * @dev See {IERC721-getApproved}.
3282      */
3283     function getApproved(uint256 tokenId) public view virtual override returns (address) {
3284         _requireMinted(tokenId);
3285 
3286         return _tokenApprovals[tokenId];
3287     }
3288 
3289     /**
3290      * @dev See {IERC721-setApprovalForAll}.
3291      */
3292     function setApprovalForAll(address operator, bool approved) public virtual override {
3293         _setApprovalForAll(_msgSender(), operator, approved);
3294     }
3295 
3296     /**
3297      * @dev See {IERC721-isApprovedForAll}.
3298      */
3299     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
3300         return _operatorApprovals[owner][operator];
3301     }
3302 
3303     /**
3304      * @dev See {IERC721-transferFrom}.
3305      */
3306     function transferFrom(
3307         address from,
3308         address to,
3309         uint256 tokenId
3310     ) public virtual override {
3311         //solhint-disable-next-line max-line-length
3312         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
3313 
3314         _transfer(from, to, tokenId);
3315     }
3316 
3317     /**
3318      * @dev See {IERC721-safeTransferFrom}.
3319      */
3320     function safeTransferFrom(
3321         address from,
3322         address to,
3323         uint256 tokenId
3324     ) public virtual override {
3325         safeTransferFrom(from, to, tokenId, "");
3326     }
3327 
3328     /**
3329      * @dev See {IERC721-safeTransferFrom}.
3330      */
3331     function safeTransferFrom(
3332         address from,
3333         address to,
3334         uint256 tokenId,
3335         bytes memory data
3336     ) public virtual override {
3337         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
3338         _safeTransfer(from, to, tokenId, data);
3339     }
3340 
3341     /**
3342      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
3343      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
3344      *
3345      * `data` is additional data, it has no specified format and it is sent in call to `to`.
3346      *
3347      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
3348      * implement alternative mechanisms to perform token transfer, such as signature-based.
3349      *
3350      * Requirements:
3351      *
3352      * - `from` cannot be the zero address.
3353      * - `to` cannot be the zero address.
3354      * - `tokenId` token must exist and be owned by `from`.
3355      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
3356      *
3357      * Emits a {Transfer} event.
3358      */
3359     function _safeTransfer(
3360         address from,
3361         address to,
3362         uint256 tokenId,
3363         bytes memory data
3364     ) internal virtual {
3365         _transfer(from, to, tokenId);
3366         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
3367     }
3368 
3369     /**
3370      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
3371      */
3372     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
3373         return _owners[tokenId];
3374     }
3375 
3376     /**
3377      * @dev Returns whether `tokenId` exists.
3378      *
3379      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
3380      *
3381      * Tokens start existing when they are minted (`_mint`),
3382      * and stop existing when they are burned (`_burn`).
3383      */
3384     function _exists(uint256 tokenId) internal view virtual returns (bool) {
3385         return _ownerOf(tokenId) != address(0);
3386     }
3387 
3388     /**
3389      * @dev Returns whether `spender` is allowed to manage `tokenId`.
3390      *
3391      * Requirements:
3392      *
3393      * - `tokenId` must exist.
3394      */
3395     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
3396         address owner = ERC721.ownerOf(tokenId);
3397         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
3398     }
3399 
3400     /**
3401      * @dev Safely mints `tokenId` and transfers it to `to`.
3402      *
3403      * Requirements:
3404      *
3405      * - `tokenId` must not exist.
3406      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
3407      *
3408      * Emits a {Transfer} event.
3409      */
3410     function _safeMint(address to, uint256 tokenId) internal virtual {
3411         _safeMint(to, tokenId, "");
3412     }
3413 
3414     /**
3415      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
3416      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
3417      */
3418     function _safeMint(
3419         address to,
3420         uint256 tokenId,
3421         bytes memory data
3422     ) internal virtual {
3423         _mint(to, tokenId);
3424         require(
3425             _checkOnERC721Received(address(0), to, tokenId, data),
3426             "ERC721: transfer to non ERC721Receiver implementer"
3427         );
3428     }
3429 
3430     /**
3431      * @dev Mints `tokenId` and transfers it to `to`.
3432      *
3433      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
3434      *
3435      * Requirements:
3436      *
3437      * - `tokenId` must not exist.
3438      * - `to` cannot be the zero address.
3439      *
3440      * Emits a {Transfer} event.
3441      */
3442     function _mint(address to, uint256 tokenId) internal virtual {
3443         require(to != address(0), "ERC721: mint to the zero address");
3444         require(!_exists(tokenId), "ERC721: token already minted");
3445 
3446         _beforeTokenTransfer(address(0), to, tokenId, 1);
3447 
3448         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
3449         require(!_exists(tokenId), "ERC721: token already minted");
3450 
3451         unchecked {
3452             // Will not overflow unless all 2**256 token ids are minted to the same owner.
3453             // Given that tokens are minted one by one, it is impossible in practice that
3454             // this ever happens. Might change if we allow batch minting.
3455             // The ERC fails to describe this case.
3456             _balances[to] += 1;
3457         }
3458 
3459         _owners[tokenId] = to;
3460 
3461         emit Transfer(address(0), to, tokenId);
3462 
3463         _afterTokenTransfer(address(0), to, tokenId, 1);
3464     }
3465 
3466     /**
3467      * @dev Destroys `tokenId`.
3468      * The approval is cleared when the token is burned.
3469      * This is an internal function that does not check if the sender is authorized to operate on the token.
3470      *
3471      * Requirements:
3472      *
3473      * - `tokenId` must exist.
3474      *
3475      * Emits a {Transfer} event.
3476      */
3477     function _burn(uint256 tokenId) internal virtual {
3478         address owner = ERC721.ownerOf(tokenId);
3479 
3480         _beforeTokenTransfer(owner, address(0), tokenId, 1);
3481 
3482         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
3483         owner = ERC721.ownerOf(tokenId);
3484 
3485         // Clear approvals
3486         delete _tokenApprovals[tokenId];
3487 
3488         unchecked {
3489             // Cannot overflow, as that would require more tokens to be burned/transferred
3490             // out than the owner initially received through minting and transferring in.
3491             _balances[owner] -= 1;
3492         }
3493         delete _owners[tokenId];
3494 
3495         emit Transfer(owner, address(0), tokenId);
3496 
3497         _afterTokenTransfer(owner, address(0), tokenId, 1);
3498     }
3499 
3500     /**
3501      * @dev Transfers `tokenId` from `from` to `to`.
3502      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
3503      *
3504      * Requirements:
3505      *
3506      * - `to` cannot be the zero address.
3507      * - `tokenId` token must be owned by `from`.
3508      *
3509      * Emits a {Transfer} event.
3510      */
3511     function _transfer(
3512         address from,
3513         address to,
3514         uint256 tokenId
3515     ) internal virtual {
3516         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
3517         require(to != address(0), "ERC721: transfer to the zero address");
3518 
3519         _beforeTokenTransfer(from, to, tokenId, 1);
3520 
3521         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
3522         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
3523 
3524         // Clear approvals from the previous owner
3525         delete _tokenApprovals[tokenId];
3526 
3527         unchecked {
3528             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
3529             // `from`'s balance is the number of token held, which is at least one before the current
3530             // transfer.
3531             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
3532             // all 2**256 token ids to be minted, which in practice is impossible.
3533             _balances[from] -= 1;
3534             _balances[to] += 1;
3535         }
3536         _owners[tokenId] = to;
3537 
3538         emit Transfer(from, to, tokenId);
3539 
3540         _afterTokenTransfer(from, to, tokenId, 1);
3541     }
3542 
3543     /**
3544      * @dev Approve `to` to operate on `tokenId`
3545      *
3546      * Emits an {Approval} event.
3547      */
3548     function _approve(address to, uint256 tokenId) internal virtual {
3549         _tokenApprovals[tokenId] = to;
3550         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
3551     }
3552 
3553     /**
3554      * @dev Approve `operator` to operate on all of `owner` tokens
3555      *
3556      * Emits an {ApprovalForAll} event.
3557      */
3558     function _setApprovalForAll(
3559         address owner,
3560         address operator,
3561         bool approved
3562     ) internal virtual {
3563         require(owner != operator, "ERC721: approve to caller");
3564         _operatorApprovals[owner][operator] = approved;
3565         emit ApprovalForAll(owner, operator, approved);
3566     }
3567 
3568     /**
3569      * @dev Reverts if the `tokenId` has not been minted yet.
3570      */
3571     function _requireMinted(uint256 tokenId) internal view virtual {
3572         require(_exists(tokenId), "ERC721: invalid token ID");
3573     }
3574 
3575     /**
3576      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
3577      * The call is not executed if the target address is not a contract.
3578      *
3579      * @param from address representing the previous owner of the given token ID
3580      * @param to target address that will receive the tokens
3581      * @param tokenId uint256 ID of the token to be transferred
3582      * @param data bytes optional data to send along with the call
3583      * @return bool whether the call correctly returned the expected magic value
3584      */
3585     function _checkOnERC721Received(
3586         address from,
3587         address to,
3588         uint256 tokenId,
3589         bytes memory data
3590     ) private returns (bool) {
3591         if (to.isContract()) {
3592             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
3593                 return retval == IERC721Receiver.onERC721Received.selector;
3594             } catch (bytes memory reason) {
3595                 if (reason.length == 0) {
3596                     revert("ERC721: transfer to non ERC721Receiver implementer");
3597                 } else {
3598                     /// @solidity memory-safe-assembly
3599                     assembly {
3600                         revert(add(32, reason), mload(reason))
3601                     }
3602                 }
3603             }
3604         } else {
3605             return true;
3606         }
3607     }
3608 
3609     /**
3610      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
3611      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
3612      *
3613      * Calling conditions:
3614      *
3615      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
3616      * - When `from` is zero, the tokens will be minted for `to`.
3617      * - When `to` is zero, ``from``'s tokens will be burned.
3618      * - `from` and `to` are never both zero.
3619      * - `batchSize` is non-zero.
3620      *
3621      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3622      */
3623     function _beforeTokenTransfer(
3624         address from,
3625         address to,
3626         uint256, /* firstTokenId */
3627         uint256 batchSize
3628     ) internal virtual {
3629         if (batchSize > 1) {
3630             if (from != address(0)) {
3631                 _balances[from] -= batchSize;
3632             }
3633             if (to != address(0)) {
3634                 _balances[to] += batchSize;
3635             }
3636         }
3637     }
3638 
3639     /**
3640      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
3641      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
3642      *
3643      * Calling conditions:
3644      *
3645      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
3646      * - When `from` is zero, the tokens were minted for `to`.
3647      * - When `to` is zero, ``from``'s tokens were burned.
3648      * - `from` and `to` are never both zero.
3649      * - `batchSize` is non-zero.
3650      *
3651      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3652      */
3653     function _afterTokenTransfer(
3654         address from,
3655         address to,
3656         uint256 firstTokenId,
3657         uint256 batchSize
3658     ) internal virtual {}
3659 }
3660 
3661 // File: @openzeppelin/contracts/access/Ownable.sol
3662 
3663 
3664 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
3665 
3666 pragma solidity ^0.8.0;
3667 
3668 
3669 /**
3670  * @dev Contract module which provides a basic access control mechanism, where
3671  * there is an account (an owner) that can be granted exclusive access to
3672  * specific functions.
3673  *
3674  * By default, the owner account will be the one that deploys the contract. This
3675  * can later be changed with {transferOwnership}.
3676  *
3677  * This module is used through inheritance. It will make available the modifier
3678  * `onlyOwner`, which can be applied to your functions to restrict their use to
3679  * the owner.
3680  */
3681 abstract contract Ownable is Context {
3682     address private _owner;
3683 
3684     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
3685 
3686     /**
3687      * @dev Initializes the contract setting the deployer as the initial owner.
3688      */
3689     constructor() {
3690         _transferOwnership(_msgSender());
3691     }
3692 
3693     /**
3694      * @dev Throws if called by any account other than the owner.
3695      */
3696     modifier onlyOwner() {
3697         _checkOwner();
3698         _;
3699     }
3700 
3701     /**
3702      * @dev Returns the address of the current owner.
3703      */
3704     function owner() public view virtual returns (address) {
3705         return _owner;
3706     }
3707 
3708     /**
3709      * @dev Throws if the sender is not the owner.
3710      */
3711     function _checkOwner() internal view virtual {
3712         require(owner() == _msgSender(), "Ownable: caller is not the owner");
3713     }
3714 
3715     /**
3716      * @dev Leaves the contract without owner. It will not be possible to call
3717      * `onlyOwner` functions anymore. Can only be called by the current owner.
3718      *
3719      * NOTE: Renouncing ownership will leave the contract without an owner,
3720      * thereby removing any functionality that is only available to the owner.
3721      */
3722     function renounceOwnership() public virtual onlyOwner {
3723         _transferOwnership(address(0));
3724     }
3725 
3726     /**
3727      * @dev Transfers ownership of the contract to a new account (`newOwner`).
3728      * Can only be called by the current owner.
3729      */
3730     function transferOwnership(address newOwner) public virtual onlyOwner {
3731         require(newOwner != address(0), "Ownable: new owner is the zero address");
3732         _transferOwnership(newOwner);
3733     }
3734 
3735     /**
3736      * @dev Transfers ownership of the contract to a new account (`newOwner`).
3737      * Internal function without access restriction.
3738      */
3739     function _transferOwnership(address newOwner) internal virtual {
3740         address oldOwner = _owner;
3741         _owner = newOwner;
3742         emit OwnershipTransferred(oldOwner, newOwner);
3743     }
3744 }
3745 
3746 // File: contracts/sayaol.sol
3747 
3748 
3749 pragma solidity 0.8.17;
3750 
3751 
3752 
3753 
3754 
3755 
3756 
3757 
3758 
3759 
3760 contract AOLNFT is ERC721("Aol", "AOL"), IERC2981, Ownable, DefaultOperatorFilterer {
3761 
3762     using Counters for Counters.Counter;
3763 
3764     // The number of AOL tokens needed to claim a mint
3765     uint256 public constant TOKENS_TO_MINT = 69000000000 * 10**18;
3766     
3767     // The AOL token contract
3768     IERC20 public aolToken;
3769 
3770     /* Constants */
3771     uint256 public MAX_SUPPLY = 3333; 
3772     uint256 public constant ROYALTY_PERCENTAGE = 5;
3773     uint256 public constant WALLET_LIMIT = 15;
3774     uint256 public constant PRICE = 30000000000000000;
3775     
3776     /* Variables */
3777     Counters.Counter private _tokenIdCounter;
3778     bool public isSaleActive = false;
3779     bool public isClaimActive = false;
3780     mapping(address => uint8) public hasMintedCount;
3781     mapping(address => uint8) public hasClaimedCount;
3782     IgmRenderer public renderer;
3783 
3784     /* Errors */
3785     error LimitReachedForWallet();
3786     error IncorrectAmountForMint();
3787     error MaxSupplyReached();
3788     error NotEnoughAllowance(uint256 available, uint256 required);
3789     error SaleNotActive();
3790     error SendToAddressZero();
3791     error TokenDoesNotExist(uint256 id);
3792     error WithdrawSendFailed();
3793 
3794     constructor() {
3795     }
3796 
3797     function mint(uint8 quantity) payable public {
3798         if (!isSaleActive) {
3799             revert SaleNotActive();
3800         }
3801 
3802         if (_tokenIdCounter.current()+quantity > MAX_SUPPLY) {
3803             revert MaxSupplyReached();
3804         }
3805 
3806         if (hasMintedCount[msg.sender] == WALLET_LIMIT || hasMintedCount[msg.sender]+quantity > WALLET_LIMIT) {
3807             revert LimitReachedForWallet();
3808         }
3809 
3810         if (msg.value < PRICE*quantity) {
3811             revert IncorrectAmountForMint();
3812         }
3813 
3814         hasMintedCount[msg.sender] += quantity;
3815 
3816         // set params in renderer
3817         for (uint8 i = 0; i < quantity; i++) {
3818             uint256 tokenId = _tokenIdCounter.current();
3819             _tokenIdCounter.increment();
3820             renderer.applyStyle(uint16(tokenId));
3821             renderer.addAddress(uint16(tokenId), msg.sender);
3822             _safeMint(msg.sender, tokenId);
3823         }
3824 
3825     }
3826 
3827     function claim(uint8 quantity) public {
3828 
3829         require(isClaimActive, "Sale is not currently active");
3830 
3831         uint256 balance = aolToken.balanceOf(msg.sender);
3832         uint256 eligibleQuantity = balance / TOKENS_TO_MINT; // Calculate how many NFTs they're eligible to mint
3833 
3834         // Ensure the caller has enough AOL tokens to claim the requested number of NFTs
3835         require(hasClaimedCount[msg.sender] + quantity <= eligibleQuantity, "You do not have enough AOL tokens to claim this amount of NFTs.");
3836 
3837         // Ensure we haven't reached the max supply
3838         require(_tokenIdCounter.current() + quantity <= MAX_SUPPLY, "Max supply reached");
3839 
3840         // Ensure the wallet limit isn't reached
3841         require(hasMintedCount[msg.sender] + quantity <= WALLET_LIMIT, "Wallet limit reached");
3842 
3843         hasMintedCount[msg.sender] += quantity;
3844         hasClaimedCount[msg.sender] += quantity;
3845 
3846         // Mint the NFTs
3847         for (uint8 i = 0; i < quantity; i++) {
3848             uint256 tokenId = _tokenIdCounter.current();
3849             _tokenIdCounter.increment();
3850             renderer.applyStyle(uint16(tokenId));
3851             renderer.addAddress(uint16(tokenId), msg.sender);
3852             _safeMint(msg.sender, tokenId);
3853         }
3854     }
3855 
3856     function currentCounterId() external view returns (uint256) {
3857         return _tokenIdCounter.current();
3858     }
3859 
3860     function toggleSaleActive(bool _isSaleActive) public onlyOwner {
3861         isSaleActive = _isSaleActive;
3862     }
3863 
3864     function setMAX_SUPPLY(uint256 newMaxSupply) public onlyOwner {
3865         MAX_SUPPLY = newMaxSupply;
3866     }
3867 
3868     function toggleClaimActive(bool _isClaimActive) public onlyOwner {
3869         isClaimActive = _isClaimActive;
3870     }
3871 
3872     function setAOLToken(IERC20 _aoladdres) public onlyOwner {
3873         aolToken = _aoladdres;
3874     }
3875 
3876     function setRenderer(address rendererAddress) public onlyOwner {
3877         renderer = IgmRenderer(rendererAddress);
3878     }
3879 
3880     function tokenURI(uint256 id) public view override returns (string memory) {
3881         if (id > MAX_SUPPLY || _tokenIdCounter.current() < id) {
3882             revert TokenDoesNotExist(id);
3883         }
3884         
3885         return renderer.tokenUri(uint16(id));
3886     }
3887 
3888     /* ERC 2891 */
3889     function royaltyInfo(uint256 tokenId, uint256 salePrice)
3890         external
3891         view
3892         override
3893         returns (address receiver, uint256 royaltyAmount)
3894     {
3895         if (!_exists(tokenId)) {
3896             revert TokenDoesNotExist(tokenId);
3897         }
3898 
3899         return (address(0x70A49DaA289eD9fAd113be61Af7505A4342edEB2), SafeMath.div(SafeMath.mul(salePrice, ROYALTY_PERCENTAGE), 100));
3900     }
3901 
3902     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, IERC165) returns (bool) {
3903         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
3904     }
3905 
3906     /* Operator Filter */
3907     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
3908         super.setApprovalForAll(operator, approved);
3909     }
3910 
3911     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
3912         super.approve(operator, tokenId);
3913     }
3914 
3915     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
3916         renderer.addAddress(uint16(tokenId), to);
3917         super.transferFrom(from, to, tokenId);
3918     }
3919 
3920     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
3921         renderer.addAddress(uint16(tokenId), to);
3922         super.safeTransferFrom(from, to, tokenId);
3923     }
3924 
3925     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
3926         public
3927         override
3928         onlyAllowedOperator(from)
3929     {
3930         renderer.addAddress(uint16(tokenId), to);
3931         super.safeTransferFrom(from, to, tokenId, data);
3932     }
3933 
3934     function withdraw(address to) public onlyOwner {
3935         if (to == address(0)) {
3936             revert SendToAddressZero();
3937         }
3938 
3939         uint256 amount = address(this).balance;
3940 
3941         (bool sent,) = payable(to).call{value: amount}("");
3942         if (!sent) {
3943             revert WithdrawSendFailed();
3944         }
3945         
3946     }
3947 
3948 }