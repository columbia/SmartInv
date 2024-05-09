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
101 	uint256 public minTradeAmountOfEth;
102 
103 
104 
105 	event OnAddMargin(uint256 id, uint256 amount, address borrower, uint256 timestamp);
106 
107 	
108 
109 	constructor (address _owner, address _contractMarketData, uint256 _minTradeAmountOfEth) public 
110 
111 		Ownable(_owner) {
112 
113 		incrementalId= 0;
114 
115 		minTradeAmountOfEth= _minTradeAmountOfEth;
116 
117 		contractMarketData= _contractMarketData;
118 
119 	}
120 
121 
122 
123 	function setMinTradeAmountOfETH(uint256 _minTradeAmountOfEth) public onlyOwner {
124 
125 		minTradeAmountOfEth= _minTradeAmountOfEth;
126 
127 	}
128 
129 	
130 
131 	function setBiLinkLoanContract(address _contractBiLinkLoan) public onlyOwner {
132 
133 		contractBiLinkLoan= _contractBiLinkLoan;
134 
135 	}
136 
137 
138 
139 	function getLoanDataPart(uint256 _id) public constant returns (address, address, address, address) {
140 
141 		LoanInfo memory _li= id2LoanInfo[_id];
142 
143 		return(_li.tokenPledge, _li.tokenBorrow, _li.borrower, _li.lender);
144 
145 	}
146 
147 
148 
149 	function getLoanDataFull(uint256 _id) public constant returns (address, address, address, address,uint256,uint256,uint256,uint256,uint256,uint256,uint256) {
150 
151 		LoanInfo memory _li= id2LoanInfo[_id];
152 
153 		return(_li.tokenPledge, _li.tokenBorrow, _li.borrower, _li.lender, _li.amount, _li.amountPledge, _li.amountInterest, _li.periodDays, _li.timeLoan, _li.cerForceClose.num,_li.cerForceClose.denom);
154 
155 	}
156 
157 
158 
159 	function getTotalPledgeAmount(address _token, address _account) public constant returns (uint256) {
160 
161 		uint256 _amountPledge= 0; 
162 
163 		for(uint256 i= 0; i<borrower2LoanInfoId[_account].length;i++) {
164 
165 			LoanInfo memory _li= id2LoanInfo[borrower2LoanInfoId[_account][i]];
166 
167 			if(_li.borrower== _account&& _token== _li.tokenPledge) {
168 
169 				_amountPledge= _amountPledge.add(_li.amountPledge);
170 
171 				_amountPledge= _amountPledge.add(_li.amountInterest);
172 
173 			}
174 
175 		}
176 
177 		
178 
179 		return _amountPledge; 
180 
181 	}
182 
183 
184 
185 	function getTotalBorrowAmount(address _token) public constant returns (uint256) {
186 
187 		uint256 _amountBorrow= 0; 
188 
189 		for(uint256 i= 0; i< allLoanId.length; i++) {
190 
191 			LoanInfo memory _li= id2LoanInfo[allLoanId[i]];
192 
193 			if(_token== _li.tokenBorrow) {
194 
195 				_amountBorrow= _amountBorrow.add(_li.amount);
196 
197 			}
198 
199 		}
200 
201 		
202 
203 		return _amountBorrow; 
204 
205 	}
206 
207 
208 
209 	function hasUnpaidLoan(address _account) public constant returns (bool) {
210 
211 		return (borrower2LoanInfoId[_account].length!= 0|| lender2LoanInfoId[_account].length!= 0 );
212 
213 	}
214 
215 
216 
217 	function getUnpaiedLoanInfo(address _tokenPledge, address _tokenBorrow, address _account, bool _borrowOrLend) public constant returns (uint256[]) {
218 
219 	    uint256[] memory _arrId= new uint256[]((_borrowOrLend? borrower2LoanInfoId[_account].length: lender2LoanInfoId[_account].length));
220 
221 		uint256 _count= 0;
222 
223 
224 
225 		if(_borrowOrLend) {
226 
227 		    for(uint256 i= 0; i<borrower2LoanInfoId[_account].length;i++) {
228 
229 			    if(id2LoanInfo[borrower2LoanInfoId[_account][i]].tokenBorrow== _tokenBorrow&& id2LoanInfo[borrower2LoanInfoId[_account][i]].tokenPledge== _tokenPledge)
230 
231 					_arrId[_count++]= borrower2LoanInfoId[_account][i];
232 
233 			}
234 
235 		}
236 
237 		else {
238 
239 		    for(i= 0; i<lender2LoanInfoId[_account].length;i++) {
240 
241 			    if(id2LoanInfo[lender2LoanInfoId[_account][i]].tokenBorrow== _tokenBorrow&& id2LoanInfo[lender2LoanInfoId[_account][i]].tokenPledge== _tokenPledge)
242 
243 					_arrId[_count++]= lender2LoanInfoId[_account][i];
244 
245 			}
246 
247 		}
248 
249 
250 
251 		return _arrId;
252 
253 	}
254 
255 	 
256 
257 	function getPledgeAmount(address _tokenPledge, address _tokenBorrow, uint256 _amount,uint16 _ratioPledge) public constant returns (uint256) {
258 
259 		(uint256 _num, uint256 _denom)= IMarketData(contractMarketData).getTokenExchangeRatio(_tokenPledge, _tokenBorrow);
260 
261 		if(_num!= 0)
262 
263 			return _num.mul(_amount).mul(_ratioPledge).div(_denom).div(100);
264 
265 		else
266 
267 			return 0;
268 
269 	}
270 
271 
272 
273 	function updateDataAfterTrade(address _tokenPledge, address _tokenBorrow, address _borrower, address _lender,
274 
275 		uint256 _amount, uint256 _amountPledge, uint256 _amountInterest, uint256 _periodDays) public returns (bool) {
276 
277 		require(msg.sender== contractBiLinkLoan);
278 
279 		if(checkMinAmountRequirement(_tokenPledge, _tokenBorrow, _amount)== false)
280 
281 			return false;
282 
283 
284 
285 		CoinExchangeRatio memory _cerForceCloseLine= getForceCloseLine(_tokenPledge, _tokenBorrow, _amountPledge, _amount);
286 
287 
288 
289 		incrementalId= incrementalId.add(1);
290 
291 		LoanInfo memory _li= LoanInfo({id:incrementalId, tokenPledge: _tokenPledge, tokenBorrow: _tokenBorrow, borrower: _borrower, lender: _lender
292 
293 		    , amount: _amount, amountPledge: _amountPledge, amountInterest: _amountInterest, periodDays: _periodDays, timeLoan: now, cerForceClose:_cerForceCloseLine});
294 
295 		borrower2LoanInfoId[_borrower].push(incrementalId);
296 
297 		lender2LoanInfoId[_lender].push(incrementalId);
298 
299 
300 
301 		id2LoanInfo[incrementalId]= _li;
302 
303 		allLoanId.push(incrementalId);
304 
305 
306 
307 		return true;
308 
309 	}
310 
311 
312 
313 	function checkMinAmountRequirement(address _tokenPledge, address _tokenBorrow, uint256 _amount) private returns (bool) {
314 
315 		(uint256 _num, uint256 _denom)= IMarketData(contractMarketData).getTokenExchangeRatio(_tokenPledge, _tokenBorrow);
316 
317 		if((_amount.mul(_num).div(_denom))< minTradeAmountOfEth)
318 
319 			return false;
320 
321 
322 
323 		return true;
324 
325 	}
326 
327 
328 
329 	function getForceCloseLine(address _tokenPledge, address _tokenBorrow, uint256 _amountPledge, uint256 _amount) private returns (CoinExchangeRatio _cerForceCloseLine) {
330 
331 		(uint256 _num, uint256 _denom)= IMarketData(contractMarketData).getTokenExchangeRatio(_tokenPledge, _tokenBorrow);
332 
333 		uint256 _ratioPledge= _amountPledge.mul(100).mul(_denom).div(_amount).div(_num);
334 
335 		return CoinExchangeRatio({num:_num* _ratioPledge, denom:_denom* ((_ratioPledge- 100)/ 4+ 100)});
336 
337 	}
338 
339 
340 
341 	function updateDataAfterRepay(uint256 _id, uint256 _availableAmountOfBorrower) public returns (uint256, uint256, uint256, uint256, uint256) {
342 
343 		require(msg.sender== contractBiLinkLoan);
344 
345 		LoanInfo memory _li= id2LoanInfo[_id];
346 
347 		
348 
349 		deleteLoan(_li);
350 
351 
352 
353 		if(_availableAmountOfBorrower>= _li.amount) {
354 
355 			return(_li.amount, _li.amountInterest, getActualInterest(_li), 0, _li.amountPledge);
356 
357 		}
358 
359 		else {
360 
361 			return(_li.amount, _li.amountInterest, getActualInterest(_li), (_li.amount- _availableAmountOfBorrower), _li.amountPledge);
362 
363 		}
364 
365 	}
366 
367 
368 
369 	function deleteLoan (LoanInfo _li) private {
370 
371 		uint256 _indexOne;
372 
373 		for(_indexOne= 0; _indexOne< borrower2LoanInfoId[_li.borrower].length; _indexOne++) {
374 
375 		    if(borrower2LoanInfoId[_li.borrower][_indexOne]== _li.id) {
376 
377 				break;
378 
379 		    }
380 
381 		}
382 
383 		 
384 
385 		uint256 _indexTwo;
386 
387 		for(_indexTwo= 0; _indexTwo< lender2LoanInfoId[_li.lender].length; _indexTwo++) {
388 
389 		    if(lender2LoanInfoId[_li.lender][_indexTwo]== _li.id) {
390 
391 				break;
392 
393 		    }
394 
395 		}
396 
397 
398 
399 		for(uint256 i= 0; i< allLoanId.length; i++) {
400 
401 			if(allLoanId[i]== _li.id) {
402 
403 				if(i< allLoanId.length- 1&& allLoanId.length> 1)
404 
405 					allLoanId[i]= allLoanId[allLoanId.length- 1];
406 
407 				delete allLoanId[allLoanId.length- 1];
408 
409 				allLoanId.length--;
410 
411 				break;
412 
413 			}
414 
415 		}
416 
417 
418 
419 		delete(id2LoanInfo[_li.id]);
420 
421 		
422 
423 		if(_indexOne< borrower2LoanInfoId[_li.borrower].length- 1&& borrower2LoanInfoId[_li.borrower].length> 1)
424 
425 			borrower2LoanInfoId[_li.borrower][_indexOne]= borrower2LoanInfoId[_li.borrower][borrower2LoanInfoId[_li.borrower].length- 1];
426 
427 		delete borrower2LoanInfoId[_li.borrower][borrower2LoanInfoId[_li.borrower].length- 1];
428 
429 		borrower2LoanInfoId[_li.borrower].length--;
430 
431 		 
432 
433 		if(_indexTwo< lender2LoanInfoId[_li.lender].length- 1&& lender2LoanInfoId[_li.lender].length> 1)
434 
435 			lender2LoanInfoId[_li.lender][_indexTwo]= lender2LoanInfoId[_li.lender][lender2LoanInfoId[_li.lender].length- 1];
436 
437 		delete lender2LoanInfoId[_li.lender][lender2LoanInfoId[_li.lender].length- 1];
438 
439 		lender2LoanInfoId[_li.lender].length--;
440 
441 	}
442 
443 
444 
445 	function getActualInterest(LoanInfo _li) private returns (uint256) {
446 
447 		uint256 _elapsedDays= (now.sub(_li.timeLoan))/ (24* 3600)+ 1;
448 
449 		if(_elapsedDays> _li.periodDays)
450 
451 			_elapsedDays= _li.periodDays;
452 
453 
454 
455 		return _li.amountInterest.mul(_elapsedDays).div(_li.periodDays);
456 
457 	}
458 
459 
460 
461 	function checkForceClose() public constant returns(uint256[]) {
462 
463 		uint256[] memory _arrId= new uint256[](allLoanId.length);
464 
465 		uint256 _count= 0;
466 
467 		for(uint256 i= 0; i< allLoanId.length; i++) {
468 
469 			if(needForceClose(allLoanId[i]))
470 
471 				_arrId[_count++]= allLoanId[i];
472 
473 		}
474 
475 
476 
477 		return _arrId;
478 
479 	}
480 
481 
482 
483 	function needForceClose(uint256 _id) public constant returns (bool) {
484 
485 		LoanInfo memory _li= id2LoanInfo[_id];
486 
487 		uint256 _totalDays= (now.sub(_li.timeLoan))/ (24* 3600);
488 
489 		if(_totalDays>= _li.periodDays) {
490 
491 			return true;
492 
493 		}
494 
495 		else {
496 
497 			(uint256 _num, uint256 _denom)= IMarketData(contractMarketData).getTokenExchangeRatio(_li.tokenPledge, _li.tokenBorrow);
498 
499 			if(_num* _li.cerForceClose.denom> _denom* _li.cerForceClose.num) {
500 
501 				return true;
502 
503 			}
504 
505 		}
506 
507 
508 
509 		return false;
510 
511 	}
512 
513 
514 
515 	function addMargin(uint256 _id, uint256 _amount) public {
516 
517 		LoanInfo memory _li= id2LoanInfo[_id];
518 
519 		require(_amount> 0&& _li.borrower!= address(0)&& _li.borrower==msg.sender);
520 
521 
522 
523 		id2LoanInfo[_id].amountPledge= id2LoanInfo[_id].amountPledge.add(_amount);
524 
525 		emit OnAddMargin(_id, _amount, _li.borrower, now);
526 
527 	}
528 
529 }
530 
531 contract IMarketData {
532 
533 	function getTokenExchangeRatio(address _tokenNum, address _tokenDenom) public returns (uint256 num, uint256 denom);
534 
535 }
536 
537 library SafeMath {
538 
539 
540 
541   /**
542 
543   * @dev Multiplies two numbers, throws on overflow.
544 
545   */
546 
547   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
548 
549     if (a == 0) {
550 
551       return 0;
552 
553     }
554 
555     uint256 c = a * b;
556 
557     require(c / a == b);
558 
559     return c;
560 
561   }
562 
563 
564 
565   /**
566 
567   * @dev Integer division of two numbers, truncating the quotient.
568 
569   */
570 
571   function div(uint256 a, uint256 b) internal pure returns (uint256) {
572 
573     require(b > 0); // Solidity automatically throws when dividing by 0
574 
575     uint256 c = a / b;
576 
577     return c;
578 
579   }
580 
581 
582 
583   /**
584 
585   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
586 
587   */
588 
589   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
590 
591     require(b <= a);
592 
593     return a - b;
594 
595   }
596 
597 
598 
599   /**
600 
601   * @dev Adds two numbers, throws on overflow.
602 
603   */
604 
605   function add(uint256 a, uint256 b) internal pure returns (uint256) {
606 
607     uint256 c = a + b;
608 
609     require(c >= a);
610 
611     return c;
612 
613   }
614 
615 }