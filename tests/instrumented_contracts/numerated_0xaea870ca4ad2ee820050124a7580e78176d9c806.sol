1 pragma solidity ^0.4.13;
2 
3 contract Ownable 
4 
5 {
6 
7   address public owner;
8 
9  
10 
11   constructor(address _owner) public 
12 
13   {
14 
15     owner = _owner;
16 
17   }
18 
19  
20 
21   modifier onlyOwner() 
22 
23   {
24 
25     require(msg.sender == owner);
26 
27     _;
28 
29   }
30 
31  
32 
33   function transferOwnership(address newOwner) onlyOwner 
34 
35   {
36 
37     require(newOwner != address(0));      
38 
39     owner = newOwner;
40 
41   }
42 
43 }
44 
45 contract LoanLogic is Ownable {
46 
47 	using SafeMath for uint256;
48 
49 	struct LoanInfo {
50 
51 	    uint256 id; 
52 
53 		address tokenPledge;
54 
55 		address tokenBorrow;
56 
57 		address borrower;
58 
59 		address lender;
60 
61 		uint256 amount;
62 
63 		uint256 amountPledge;
64 
65 		uint256 amountInterest;
66 
67 		uint256 periodDays;
68 
69 		uint256 timeLoan;
70 
71 		CoinExchangeRatio cerForceClose;
72 
73 	}
74 
75 
76 
77 	struct CoinExchangeRatio {
78 
79 		uint256 num;
80 
81 		uint256 denom;
82 
83 	}
84 
85 	
86 
87 	address public contractMarketData;
88 
89 	address public contractBiLinkLoan;
90 
91 	uint256 public incrementalId;
92 
93 	mapping (address => uint256[]) public borrower2LoanInfoId;
94 
95 	mapping (address => uint256[]) public lender2LoanInfoId;
96 
97 	mapping (uint256 => LoanInfo) public id2LoanInfo;
98 
99 	uint256[] allLoanId;
100 
101 
102 
103 	event OnAddMargin(uint256 id, uint256 amount, address borrower, uint256 timestamp);
104 
105 	
106 
107 	constructor (address _owner, address _contractMarketData) public 
108 
109 		Ownable(_owner) {
110 
111 		incrementalId= 0;
112 
113 		contractMarketData= _contractMarketData;
114 
115 	}
116 
117 	
118 
119 	function setBiLinkLoanContract(address _contractBiLinkLoan) public onlyOwner {
120 
121 		contractBiLinkLoan= _contractBiLinkLoan;
122 
123 	}
124 
125 
126 
127 	function getLoanDataPart(uint256 _id) public constant returns (address, address, address, address) {
128 
129 		LoanInfo memory _li= id2LoanInfo[_id];
130 
131 		return(_li.tokenPledge, _li.tokenBorrow, _li.borrower, _li.lender);
132 
133 	}
134 
135 
136 
137 	function getLoanDataFull(uint256 _id) public constant returns (address, address, address, address,uint256,uint256,uint256,uint256,uint256,uint256,uint256) {
138 
139 		LoanInfo memory _li= id2LoanInfo[_id];
140 
141 		return(_li.tokenPledge, _li.tokenBorrow, _li.borrower, _li.lender, _li.amount, _li.amountPledge, _li.amountInterest, _li.periodDays, _li.timeLoan, _li.cerForceClose.num,_li.cerForceClose.denom);
142 
143 	}
144 
145 
146 
147 	function getTotalPledgeAmount(address _token, address _account) public constant returns (uint256) {
148 
149 		uint256 _amountPledge= 0; 
150 
151 		for(uint256 i= 0; i<borrower2LoanInfoId[_account].length;i++) {
152 
153 			LoanInfo memory _li= id2LoanInfo[borrower2LoanInfoId[_account][i]];
154 
155 			if(_li.borrower== _account&& _token== _li.tokenPledge) {
156 
157 				_amountPledge= _amountPledge.add(_li.amountPledge);
158 
159 				_amountPledge= _amountPledge.add(_li.amountInterest);
160 
161 			}
162 
163 		}
164 
165 		
166 
167 		return _amountPledge; 
168 
169 	}
170 
171 
172 
173 	function getTotalBorrowAmount(address _token) public constant returns (uint256) {
174 
175 		uint256 _amountBorrow= 0; 
176 
177 		for(uint256 i= 0; i< allLoanId.length; i++) {
178 
179 			LoanInfo memory _li= id2LoanInfo[allLoanId[i]];
180 
181 			if(_token== _li.tokenBorrow) {
182 
183 				_amountBorrow= _amountBorrow.add(_li.amount);
184 
185 			}
186 
187 		}
188 
189 		
190 
191 		return _amountBorrow; 
192 
193 	}
194 
195 
196 
197 	function hasUnpaidLoan(address _account) public constant returns (bool) {
198 
199 		return (borrower2LoanInfoId[_account].length!= 0|| lender2LoanInfoId[_account].length!= 0 );
200 
201 	}
202 
203 
204 
205 	function getUnpaiedLoanInfo(address _tokenPledge, address _tokenBorrow, address _account, bool _borrowOrLend) public constant returns (uint256[]) {
206 
207 	    uint256[] memory _arrId= new uint256[]((_borrowOrLend? borrower2LoanInfoId[_account].length: lender2LoanInfoId[_account].length));
208 
209 		uint256 _count= 0;
210 
211 
212 
213 		if(_borrowOrLend) {
214 
215 		    for(uint256 i= 0; i<borrower2LoanInfoId[_account].length;i++) {
216 
217 			    if(id2LoanInfo[borrower2LoanInfoId[_account][i]].tokenBorrow== _tokenBorrow&& id2LoanInfo[borrower2LoanInfoId[_account][i]].tokenPledge== _tokenPledge)
218 
219 					_arrId[_count++]= borrower2LoanInfoId[_account][i];
220 
221 			}
222 
223 		}
224 
225 		else {
226 
227 		    for(i= 0; i<lender2LoanInfoId[_account].length;i++) {
228 
229 			    if(id2LoanInfo[lender2LoanInfoId[_account][i]].tokenBorrow== _tokenBorrow&& id2LoanInfo[lender2LoanInfoId[_account][i]].tokenPledge== _tokenPledge)
230 
231 					_arrId[_count++]= lender2LoanInfoId[_account][i];
232 
233 			}
234 
235 		}
236 
237 
238 
239 		return _arrId;
240 
241 	}
242 
243 	 
244 
245 	function getPledgeAmount(address _tokenPledge, address _tokenBorrow, uint256 _amount,uint16 _ratioPledge) public constant returns (uint256) {
246 
247 		(uint256 _num, uint256 _denom)= IMarketData(contractMarketData).getTokenExchangeRatio(_tokenPledge, _tokenBorrow);
248 
249 		if(_num!= 0)
250 
251 			return _num.mul(_amount).mul(_ratioPledge).div(_denom).div(100);
252 
253 		else
254 
255 			return 0;
256 
257 	}
258 
259 
260 
261 	function updateDataAfterTrade(address _tokenPledge, address _tokenBorrow, address _borrower, address _lender,
262 
263 		uint256 _amount, uint256 _amountPledge, uint256 _amountInterest, uint256 _periodDays) public returns (bool) {
264 
265 		require(msg.sender== contractBiLinkLoan);
266 
267 
268 
269 		CoinExchangeRatio memory _cerForceCloseLine= getForceCloseLine(_tokenPledge, _tokenBorrow, _amountPledge, _amount);
270 
271 
272 
273 		incrementalId= incrementalId.add(1);
274 
275 		LoanInfo memory _li= LoanInfo({id:incrementalId, tokenPledge: _tokenPledge, tokenBorrow: _tokenBorrow, borrower: _borrower, lender: _lender
276 
277 		    , amount: _amount, amountPledge: _amountPledge, amountInterest: _amountInterest, periodDays: _periodDays, timeLoan: now, cerForceClose:_cerForceCloseLine});
278 
279 		borrower2LoanInfoId[_borrower].push(incrementalId);
280 
281 		lender2LoanInfoId[_lender].push(incrementalId);
282 
283 
284 
285 		id2LoanInfo[incrementalId]= _li;
286 
287 		allLoanId.push(incrementalId);
288 
289 
290 
291 		return true;
292 
293 	}
294 
295 
296 
297 	function getForceCloseLine(address _tokenPledge, address _tokenBorrow, uint256 _amountPledge, uint256 _amount) private returns (CoinExchangeRatio _cerForceCloseLine) {
298 
299 		(uint256 _num, uint256 _denom)= IMarketData(contractMarketData).getTokenExchangeRatio(_tokenPledge, _tokenBorrow);
300 
301 		uint256 _ratioPledge= _amountPledge.mul(100).mul(_denom).div(_amount).div(_num);
302 
303 		return CoinExchangeRatio({num:_num* _ratioPledge, denom:_denom* ((_ratioPledge- 100)/ 4+ 100)});
304 
305 	}
306 
307 
308 
309 	function updateDataAfterRepay(uint256 _id, uint256 _availableAmountOfBorrower) public returns (uint256, uint256, uint256, uint256, uint256) {
310 
311 		require(msg.sender== contractBiLinkLoan);
312 
313 		LoanInfo memory _li= id2LoanInfo[_id];
314 
315 		
316 
317 		deleteLoan(_li);
318 
319 
320 
321 		if(_availableAmountOfBorrower>= _li.amount) {
322 
323 			return(_li.amount, _li.amountInterest, getActualInterest(_li), 0, _li.amountPledge);
324 
325 		}
326 
327 		else {
328 
329 			return(_li.amount, _li.amountInterest, getActualInterest(_li), (_li.amount- _availableAmountOfBorrower), _li.amountPledge);
330 
331 		}
332 
333 	}
334 
335 
336 
337 	function deleteLoan (LoanInfo _li) private {
338 
339 		uint256 _indexOne;
340 
341 		for(_indexOne= 0; _indexOne< borrower2LoanInfoId[_li.borrower].length; _indexOne++) {
342 
343 		    if(borrower2LoanInfoId[_li.borrower][_indexOne]== _li.id) {
344 
345 				break;
346 
347 		    }
348 
349 		}
350 
351 		 
352 
353 		uint256 _indexTwo;
354 
355 		for(_indexTwo= 0; _indexTwo< lender2LoanInfoId[_li.lender].length; _indexTwo++) {
356 
357 		    if(lender2LoanInfoId[_li.lender][_indexTwo]== _li.id) {
358 
359 				break;
360 
361 		    }
362 
363 		}
364 
365 
366 
367 		for(uint256 i= 0; i< allLoanId.length; i++) {
368 
369 			if(allLoanId[i]== _li.id) {
370 
371 				if(i< allLoanId.length- 1&& allLoanId.length> 1)
372 
373 					allLoanId[i]= allLoanId[allLoanId.length- 1];
374 
375 				delete allLoanId[allLoanId.length- 1];
376 
377 				allLoanId.length--;
378 
379 				break;
380 
381 			}
382 
383 		}
384 
385 
386 
387 		delete(id2LoanInfo[_li.id]);
388 
389 		
390 
391 		if(_indexOne< borrower2LoanInfoId[_li.borrower].length- 1&& borrower2LoanInfoId[_li.borrower].length> 1)
392 
393 			borrower2LoanInfoId[_li.borrower][_indexOne]= borrower2LoanInfoId[_li.borrower][borrower2LoanInfoId[_li.borrower].length- 1];
394 
395 		delete borrower2LoanInfoId[_li.borrower][borrower2LoanInfoId[_li.borrower].length- 1];
396 
397 		borrower2LoanInfoId[_li.borrower].length--;
398 
399 		 
400 
401 		if(_indexTwo< lender2LoanInfoId[_li.lender].length- 1&& lender2LoanInfoId[_li.lender].length> 1)
402 
403 			lender2LoanInfoId[_li.lender][_indexTwo]= lender2LoanInfoId[_li.lender][lender2LoanInfoId[_li.lender].length- 1];
404 
405 		delete lender2LoanInfoId[_li.lender][lender2LoanInfoId[_li.lender].length- 1];
406 
407 		lender2LoanInfoId[_li.lender].length--;
408 
409 	}
410 
411 
412 
413 	function getActualInterest(LoanInfo _li) private returns (uint256) {
414 
415 		uint256 _elapsedDays= (now.sub(_li.timeLoan))/ (24* 3600)+ 1;
416 
417 		if(_elapsedDays> _li.periodDays)
418 
419 			_elapsedDays= _li.periodDays;
420 
421 
422 
423 		return _li.amountInterest.mul(_elapsedDays).div(_li.periodDays);
424 
425 	}
426 
427 
428 
429 	function checkForceClose() public constant returns(uint256[]) {
430 
431 		uint256[] memory _arrId= new uint256[](allLoanId.length);
432 
433 		uint256 _count= 0;
434 
435 		for(uint256 i= 0; i< allLoanId.length; i++) {
436 
437 			if(needForceClose(allLoanId[i]))
438 
439 				_arrId[_count++]= allLoanId[i];
440 
441 		}
442 
443 
444 
445 		return _arrId;
446 
447 	}
448 
449 
450 
451 	function needForceClose(uint256 _id) public constant returns (bool) {
452 
453 		LoanInfo memory _li= id2LoanInfo[_id];
454 
455 		uint256 _totalDays= (now.sub(_li.timeLoan))/ (24* 3600);
456 
457 		if(_totalDays>= _li.periodDays) {
458 
459 			return true;
460 
461 		}
462 
463 		else {
464 
465 			(uint256 _num, uint256 _denom)= IMarketData(contractMarketData).getTokenExchangeRatio(_li.tokenPledge, _li.tokenBorrow);
466 
467 			if(_num* _li.cerForceClose.denom> _denom* _li.cerForceClose.num) {
468 
469 				return true;
470 
471 			}
472 
473 		}
474 
475 
476 
477 		return false;
478 
479 	}
480 
481 
482 
483 	function addMargin(uint256 _id, uint256 _amount) public {
484 
485 		LoanInfo memory _li= id2LoanInfo[_id];
486 
487 		require(_amount> 0&& _li.borrower!= address(0)&& _li.borrower==msg.sender);
488 
489 
490 
491 		id2LoanInfo[_id].amountPledge= id2LoanInfo[_id].amountPledge.add(_amount);
492 
493 		emit OnAddMargin(_id, _amount, _li.borrower, now);
494 
495 	}
496 
497 }
498 
499 library SafeMath {
500 
501 
502 
503   /**
504 
505   * @dev Multiplies two numbers, throws on overflow.
506 
507   */
508 
509   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
510 
511     if (a == 0) {
512 
513       return 0;
514 
515     }
516 
517     uint256 c = a * b;
518 
519     require(c / a == b);
520 
521     return c;
522 
523   }
524 
525 
526 
527   /**
528 
529   * @dev Integer division of two numbers, truncating the quotient.
530 
531   */
532 
533   function div(uint256 a, uint256 b) internal pure returns (uint256) {
534 
535     require(b > 0); // Solidity automatically throws when dividing by 0
536 
537     uint256 c = a / b;
538 
539     return c;
540 
541   }
542 
543 
544 
545   /**
546 
547   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
548 
549   */
550 
551   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
552 
553     require(b <= a);
554 
555     return a - b;
556 
557   }
558 
559 
560 
561   /**
562 
563   * @dev Adds two numbers, throws on overflow.
564 
565   */
566 
567   function add(uint256 a, uint256 b) internal pure returns (uint256) {
568 
569     uint256 c = a + b;
570 
571     require(c >= a);
572 
573     return c;
574 
575   }
576 
577 }
578 
579 contract IMarketData {
580 
581 	function getTokenExchangeRatio(address _tokenNum, address _tokenDenom) public returns (uint256 num, uint256 denom);
582 
583 }