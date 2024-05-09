1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5 
6 
7   /**
8 
9   * @dev Multiplies two numbers, throws on overflow.
10 
11   */
12 
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14 
15     if (a == 0) {
16 
17       return 0;
18 
19     }
20 
21     uint256 c = a * b;
22 
23     require(c / a == b);
24 
25     return c;
26 
27   }
28 
29 
30 
31   /**
32 
33   * @dev Integer division of two numbers, truncating the quotient.
34 
35   */
36 
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38 
39     require(b > 0); // Solidity automatically throws when dividing by 0
40 
41     uint256 c = a / b;
42 
43     return c;
44 
45   }
46 
47 
48 
49   /**
50 
51   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
52 
53   */
54 
55   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56 
57     require(b <= a);
58 
59     return a - b;
60 
61   }
62 
63 
64 
65   /**
66 
67   * @dev Adds two numbers, throws on overflow.
68 
69   */
70 
71   function add(uint256 a, uint256 b) internal pure returns (uint256) {
72 
73     uint256 c = a + b;
74 
75     require(c >= a);
76 
77     return c;
78 
79   }
80 
81 }
82 
83 contract Ownable 
84 
85 {
86 
87   address public owner;
88 
89  
90 
91   constructor(address _owner) public 
92 
93   {
94 
95     owner = _owner;
96 
97   }
98 
99  
100 
101   modifier onlyOwner() 
102 
103   {
104 
105     require(msg.sender == owner);
106 
107     _;
108 
109   }
110 
111  
112 
113   function transferOwnership(address newOwner) onlyOwner 
114 
115   {
116 
117     require(newOwner != address(0));      
118 
119     owner = newOwner;
120 
121   }
122 
123 }
124 
125 contract IBalance {
126 
127 	function distributeEthProfit(address profitMaker, uint256 amount) public ;
128 
129 	function distributeTokenProfit (address profitMaker, address token, uint256 amount) public ;
130 
131 	function modifyBalance(address _account, address _token, uint256 _amount, bool _addOrSub) public;
132 
133 	function getAvailableBalance(address _token, address _account) public constant returns (uint256);
134 
135 	function getTokenAssuranceAccount(address _token) public constant returns (address);
136 
137 }
138 
139 contract IToken {
140 
141 
142 
143   /// @notice send `_value` token to `_to` from `msg.sender`
144 
145   /// @param _to The address of the recipient
146 
147   /// @param _value The amount of token to be transferred
148 
149   /// @return Whether the transfer was successful or not
150 
151   function transfer(address _to, uint256 _value) public returns (bool success);
152 
153 
154 
155   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
156 
157   /// @param _from The address of the sender
158 
159   /// @param _to The address of the recipient
160 
161   /// @param _value The amount of token to be transferred
162 
163   /// @return Whether the transfer was successful or not
164 
165   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
166 
167 
168 
169   function approve(address _spender, uint256 _value) public returns (bool success);
170 
171 
172 
173 }
174 
175 contract IMarketData {
176 
177 	function getTokenExchangeRatio(address _tokenNum, address _tokenDenom) public returns (uint256 num, uint256 denom);
178 
179 }
180 
181 contract ILoanLogic {  
182 
183 	function setTokenExchangeRatio(address[] tokenPledge, address[] tokenBorrow, uint256[] amountDenom, uint256[] amountNum) public returns (bool);
184 
185 	function getPledgeAmount(address tokenPledge, address tokenBorrow, uint256 amount,uint16 ratioPledge) public constant returns (uint256);
186 
187 	function updateDataAfterTrade(address tokenPledge, address tokenBorrow, address borrower, address lender,
188 
189 		uint256 amountPledge, uint256 amount, uint256 amountInterest, uint256 periodDays) public returns(bool);
190 
191 	function updateDataAfterRepay(uint256 id, uint256 uBorrowerAvailableAmount) public returns (uint256, uint256, uint256, uint256, uint256);
192 
193 	function getLoanDataPart(uint256 id) public constant returns (address, address, address, address);
194 
195 	function needForceClose(uint256 id) public constant returns (bool);
196 
197 }
198 
199 contract BiLinkLoan is Ownable {
200 
201 	using SafeMath for uint256;
202 
203 
204 
205 	address public contractLoanLogic;
206 
207 	address public contractBalance;
208 
209 	address public contractMarketData;
210 
211 	address public accountCost;
212 
213 	uint256 public commissionRatio;//percentage
214 
215 	
216 
217 	mapping (address => mapping ( bytes32 => uint256)) public account2Order2TradeAmount;
218 
219 	
220 
221 	mapping (address => uint16) public token2PledgeRatio;//percentage
222 
223 	bool public isLegacy;//if true, not allow new trade,new deposit
224 
225 
226 
227 	event OnTrade(address tokenPledge, address tokenBorrow, address borrower, address lender, uint256 amountPledge, uint256 amountInterest, uint256 amountBorrow, uint256 timestamp);
228 
229 	event OnUserRepay(address tokenPledge, address tokenBorrow, address borrower, address lender, uint256 amountPledge, uint256 amountOriginInterest, uint256 amountActualInterest
230 
231 		, uint256 amountRepaied, uint256 amountRepaiedPledgeToken, uint256 timestamp);
232 
233 	event OnForceRepay(address tokenPledge, address tokenBorrow, address borrower, address lender, uint256 amountPledge, uint256 amountOriginInterest, uint256 amountActualInterest
234 
235 		, uint256 amountRepaied, uint256 amountRepaiedPledgeToken, uint256 timestamp);
236 
237 	event OnLossCompensated(address tokenPledge, address tokenBorrow, address borrower, address lender, uint256 amountLoss, uint256 amountCompensated, uint256 timestamp);
238 
239 	event OnLossCompensatedByAssurance(address tokenPledge, address tokenBorrow, address borrower, address lender, uint256 amountLoss, uint256 amountCompensated, uint256 timestamp);
240 
241 		
242 
243 	constructor(address _owner, address _accountCost, address _contractLoanLogic, address _contractMarketData, uint256 _commissionRatio) public Ownable(_owner) {
244 
245 		contractLoanLogic= _contractLoanLogic;
246 
247 		contractMarketData= _contractMarketData;
248 
249 		isLegacy= false;
250 
251 		commissionRatio= _commissionRatio;
252 
253 		accountCost= _accountCost;
254 
255 	}
256 
257 	
258 
259 	function setTokenPledgeRatio(address _token, uint16 _ratioPledge) public onlyOwner {
260 
261 		require(_ratioPledge> 0);
262 
263 		token2PledgeRatio[_token]= _ratioPledge;
264 
265 	}
266 
267 
268 
269 	function setThisContractAsLegacy() public onlyOwner {
270 
271 		isLegacy= true;
272 
273 	}
274 
275 
276 
277 	function setBalanceContract(address _contractBalance) public onlyOwner {
278 
279 		contractBalance= _contractBalance;
280 
281 	}
282 
283 
284 
285 	//_arr1:tokenPledge,tokenBorrow,borrower,lender
286 
287 	//_arr2:amountOrigin,amountInterest,periodDays,expireTime,amountTake
288 
289 	//_arr3:rMaker,sMaker,rTaker,sTaker
290 
291 	function trade(address[] _arr1, uint256[] _arr2, bool _borrowOrLend, uint8 _vMaker,uint8 _vTaker, bytes32[] _arr3) public {
292 
293 		require(isLegacy== false&& _arr2[4]<= _arr2[0]&& verifyInput( _arr1, _arr2, _borrowOrLend, _vMaker, _vTaker, _arr3)&& token2PledgeRatio[_arr1[1]]> 0);
294 
295 
296 
297 		uint256 amountPledge= ILoanLogic(contractLoanLogic).getPledgeAmount(_arr1[0], _arr1[1], _arr2[4], token2PledgeRatio[_arr1[1]]);
298 
299 		require(amountPledge!= 0);
300 
301 
302 
303 		uint256 amountInterest = amountPledge.mul(_arr2[1]).mul(_arr2[2]).mul(100).div(token2PledgeRatio[_arr1[1]]).div(100000);
304 
305 		require(amountPledge.add(amountInterest)<= IBalance(contractBalance).getAvailableBalance(_arr1[0], _arr1[2])&&_arr2[4]<= IBalance(contractBalance).getAvailableBalance(_arr1[1], _arr1[3]));
306 
307 
308 
309 		IBalance(contractBalance).modifyBalance(_arr1[3], _arr1[1], _arr2[4], false); 
310 
311 		IBalance(contractBalance).modifyBalance(_arr1[2], _arr1[1], _arr2[4], true); 
312 
313 
314 
315 		require(ILoanLogic(contractLoanLogic).updateDataAfterTrade(_arr1[0], _arr1[1], _arr1[2], _arr1[3], _arr2[4], amountPledge, amountInterest, _arr2[2]));
316 
317 		
318 
319 		emit OnTrade(_arr1[0], _arr1[1], _arr1[2], _arr1[3], amountPledge, amountInterest, _arr2[4], now);
320 
321 	}
322 
323 
324 
325 	function verifyInput( address[] _arr1, uint256[] _arr2, bool _borrowOrLend, uint8 _vMaker, uint8 _vTaker, bytes32[] _arr3) private returns (bool) {
326 
327 		require(now <= _arr2[3]);
328 
329 		address _accountPledgeAssurance= IBalance(contractBalance).getTokenAssuranceAccount(_arr1[0]);
330 
331 		address _accountBorrowAssurance= IBalance(contractBalance).getTokenAssuranceAccount(_arr1[1]);
332 
333 		require(_accountPledgeAssurance!= _arr1[2]&& _accountPledgeAssurance!= _arr1[3]&& _accountBorrowAssurance!= _arr1[2]&& _accountBorrowAssurance!= _arr1[3]);
334 
335 
336 
337 		bytes32 _hash= keccak256(abi.encodePacked(this, _arr1[0], _arr1[1], _arr2[1], _arr2[2], _arr2[3]));
338 
339 		require(ecrecover(_hash, _vMaker, _arr3[0], _arr3[1]) == (_borrowOrLend? _arr1[3] : _arr1[2]));
340 
341 		require(ecrecover(getTakerHash(_arr1, _arr2, _borrowOrLend), _vTaker, _arr3[2], _arr3[3]) == (_borrowOrLend? _arr1[2]: _arr1[3]));
342 
343 		
344 
345 		if(_borrowOrLend) {
346 
347 			require(account2Order2TradeAmount[_arr1[3]][_hash].add(_arr2[4])<= _arr2[0]);
348 
349 			account2Order2TradeAmount[_arr1[3]][_hash]= account2Order2TradeAmount[_arr1[3]][_hash].add(_arr2[4]);
350 
351 		}
352 
353 		else {
354 
355 			require(account2Order2TradeAmount[_arr1[2]][_hash].add(_arr2[4])<= _arr2[0]);
356 
357 			account2Order2TradeAmount[_arr1[2]][_hash]= account2Order2TradeAmount[_arr1[2]][_hash].add(_arr2[4]);
358 
359 		}
360 
361 		return true;
362 
363 	}
364 
365 
366 
367 	function getTakerHash(address[] _arr1, uint256[] _arr2, bool _borrowOrLend) private returns (bytes32) {
368 
369 		return keccak256(abi.encodePacked(this, _arr1[0], _arr1[1], _arr2[0], _arr2[4], _arr2[1], _arr2[2], _arr2[3], (_borrowOrLend? _arr1[3] : _arr1[2])));
370 
371 	}
372 
373 
374 
375 	function getNeedRepayPledgeTokenAmount(uint256 _amountUnRepaiedPledgeTokenAmount, address _token) private returns (uint256) {
376 
377 		return _amountUnRepaiedPledgeTokenAmount.mul((token2PledgeRatio[_token] - 100)/4 + 100).div(100);
378 
379 	}
380 
381 
382 
383 	function doRepay(uint256 _id, bool _userOrForce) private {
384 
385 		var (_tokenPledge,_tokenBorrow,_borrower,_lender)= ILoanLogic(contractLoanLogic).getLoanDataPart(_id);
386 
387 		require(_borrower!= address(0));
388 
389 		 
390 
391 		uint256 _available= IBalance(contractBalance).getAvailableBalance(_tokenBorrow, _borrower);
392 
393 		var (_amount, _amountOriginInterest, _amountActualInterest,_amountUnRepaiedAmount, _amountPledge)= ILoanLogic(contractLoanLogic).updateDataAfterRepay(_id, _available);
394 
395 		require(_amount!= 0);
396 
397 
398 
399 		uint256 _amountUnRepaiedPledgeToken= tryCompensateLossByAssurance(_tokenPledge, _tokenBorrow, _borrower, _lender, _amountPledge, _amountUnRepaiedAmount);
400 
401 
402 
403 		_available= IBalance(contractBalance).getAvailableBalance(_tokenBorrow, _borrower);
404 
405 		uint256 _amountRepaiedPledgeToken= getNeedRepayPledgeTokenAmount(_amountUnRepaiedPledgeToken, _tokenBorrow);
406 
407 		adjustBalancesAfterRepay(_tokenPledge, _tokenBorrow, _borrower, _lender, _amountActualInterest, (_amountRepaiedPledgeToken< _amountPledge? _amountRepaiedPledgeToken: _amountPledge), (_available> _amount? _amount: _available)
408 
409 			, (_amountUnRepaiedPledgeToken > _amountPledge? _amountUnRepaiedPledgeToken - _amountPledge: 0));
410 
411 
412 
413 		if(_userOrForce)
414 
415 			emit OnUserRepay(_tokenPledge, _tokenBorrow, _borrower, _lender, _amountPledge, _amountOriginInterest, _amountActualInterest, _amount, _amountRepaiedPledgeToken, now);
416 
417 		else
418 
419 			emit OnForceRepay(_tokenPledge, _tokenBorrow, _borrower, _lender, _amountPledge, _amountOriginInterest, _amountActualInterest, _amount, _amountRepaiedPledgeToken, now);
420 
421 	}
422 
423 
424 
425 	function tryCompensateLossByAssurance(address _tokenPledge, address _tokenBorrow, address _borrower, address _lender, uint256 _amountPledge, uint256 _amountUnRepaiedAmount) private returns (uint256) {
426 
427 		uint256 _amountUnRepaiedPledgeToken= 0;
428 
429 		address _accountAssurance= IBalance(contractBalance).getTokenAssuranceAccount(_tokenBorrow);
430 
431 		uint256 _available= IBalance(contractBalance).getAvailableBalance(_tokenBorrow, _accountAssurance);
432 
433 		(uint256 _num, uint256 _denom)= IMarketData(contractMarketData).getTokenExchangeRatio(_tokenPledge, _tokenBorrow);
434 
435 		uint256 _equalAmount= _amountPledge.mul(_denom).div(_num);
436 
437 
438 
439 		if(_amountUnRepaiedAmount > _equalAmount&& _available> 0) {
440 
441 			uint256 _actualCompensatedAmountByAssurance= _amountUnRepaiedAmount.sub(_equalAmount);
442 
443 			if(_available< _amountUnRepaiedAmount)
444 
445 				_actualCompensatedAmountByAssurance= _available;
446 
447 			IBalance(contractBalance).modifyBalance(_accountAssurance, _tokenBorrow, _actualCompensatedAmountByAssurance, false); 
448 
449 			IBalance(contractBalance).modifyBalance(_borrower, _tokenBorrow, _actualCompensatedAmountByAssurance, true); 
450 
451 			
452 
453 			emit OnLossCompensatedByAssurance(_tokenPledge, _tokenBorrow, _borrower, _lender, _amountUnRepaiedAmount, _actualCompensatedAmountByAssurance, now);
454 
455 			_amountUnRepaiedAmount= _amountUnRepaiedAmount.sub(_actualCompensatedAmountByAssurance);
456 
457 		}
458 
459 
460 
461 		_amountUnRepaiedPledgeToken= _amountUnRepaiedAmount.mul(_num).div(_denom);
462 
463 
464 
465 		return _amountUnRepaiedPledgeToken;
466 
467 	}
468 
469 
470 
471 	function userRepay(uint256 _id, uint8 _v, bytes32 _r, bytes32 _s) public {
472 
473 		var (_tokenPledge, _tokenBorrow, _borrower, _lender)= ILoanLogic(contractLoanLogic).getLoanDataPart(_id);
474 
475 		require(ecrecover(keccak256(abi.encodePacked(this, _id)), _v, _r, _s) == _borrower);
476 
477 		 
478 
479 		doRepay(_id, true);
480 
481 	}
482 
483 
484 
485 	function forceRepay(uint256[] _arr) public onlyOwner {
486 
487 		for(uint256 i= 0; i< _arr.length; i++) {
488 
489 			if(ILoanLogic(contractLoanLogic).needForceClose(_arr[i])) {
490 
491 				doRepay(_arr[i], false);
492 
493 			}
494 
495 		}
496 
497 	}
498 
499 
500 
501 	function adjustBalancesAfterRepay(address _tokenPledge, address _tokenBorrow, address _borrower, address _lender, uint256 _amountActualInterest, uint256 _amountRepaiedPeldgeToken, uint256 _amountRepaiedBorrowToken, uint256 _amountLoss) private {
502 
503 		uint256 _amountProfit= (_amountActualInterest.mul(commissionRatio))/ 100;
504 
505 		IBalance(contractBalance).modifyBalance(_borrower, _tokenPledge, _amountRepaiedPeldgeToken.add(_amountActualInterest), false); 
506 
507 		IBalance(contractBalance).modifyBalance(_lender, _tokenPledge, _amountActualInterest.sub(_amountProfit), true);
508 
509 		 		 
510 
511 		if(_amountRepaiedBorrowToken> 0) {
512 
513 			IBalance(contractBalance).modifyBalance(_borrower, _tokenBorrow, _amountRepaiedBorrowToken, false);
514 
515 			IBalance(contractBalance).modifyBalance(_lender, _tokenBorrow, _amountRepaiedBorrowToken, true);
516 
517 		}
518 
519 
520 
521 		if(_amountLoss> 0) {
522 
523 			if(IBalance(contractBalance).getAvailableBalance(_tokenPledge, accountCost)/ 10> _amountLoss) {
524 
525 				IBalance(contractBalance).modifyBalance(accountCost, _tokenPledge, _amountLoss, false); 
526 
527 				IBalance(contractBalance).modifyBalance(_lender, _tokenPledge, _amountLoss, true); 
528 
529 				emit OnLossCompensated(_tokenPledge, _tokenBorrow, _borrower, _lender, _amountLoss, _amountLoss, now);
530 
531 			}
532 
533 			else {
534 
535 				uint256 uActualPaiedLoss= IBalance(contractBalance).getAvailableBalance(_tokenPledge, accountCost)/ 10;
536 
537 				IBalance(contractBalance).modifyBalance(accountCost, _tokenPledge, uActualPaiedLoss, false); 
538 
539 				IBalance(contractBalance).modifyBalance(_lender, _tokenPledge, uActualPaiedLoss, true); 
540 
541 				emit OnLossCompensated(_tokenPledge, _tokenBorrow, _borrower, _lender, _amountLoss, uActualPaiedLoss, now);
542 
543 			}
544 
545 		}
546 
547 
548 
549 		IBalance(contractBalance).modifyBalance(_lender, _tokenPledge, _amountRepaiedPeldgeToken, true);
550 
551 
552 
553 		if(_tokenPledge== address(0)) {
554 
555 			IBalance(contractBalance).distributeEthProfit(_lender, _amountProfit);
556 
557 		}
558 
559 		else {
560 
561 			IBalance(contractBalance).distributeTokenProfit(_lender, _tokenPledge, _amountProfit);
562 
563 		}
564 
565 	}
566 
567 }