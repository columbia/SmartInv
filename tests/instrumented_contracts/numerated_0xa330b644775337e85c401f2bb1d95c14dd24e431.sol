1 pragma solidity ^0.4.13;
2 
3 contract IToken {
4 
5 
6 
7   /// @notice send `_value` token to `_to` from `msg.sender`
8 
9   /// @param _to The address of the recipient
10 
11   /// @param _value The amount of token to be transferred
12 
13   /// @return Whether the transfer was successful or not
14 
15   function transfer(address _to, uint256 _value) public returns (bool success);
16 
17 
18 
19   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
20 
21   /// @param _from The address of the sender
22 
23   /// @param _to The address of the recipient
24 
25   /// @param _value The amount of token to be transferred
26 
27   /// @return Whether the transfer was successful or not
28 
29   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
30 
31 
32 
33   function approve(address _spender, uint256 _value) public returns (bool success);
34 
35 
36 
37 }
38 
39 contract IMarketData {
40 
41 	function getTokenExchangeRatio(address _tokenNum, address _tokenDenom) public returns (uint256 num, uint256 denom);
42 
43 }
44 
45 contract Ownable 
46 
47 {
48 
49   address public owner;
50 
51  
52 
53   constructor(address _owner) public 
54 
55   {
56 
57     owner = _owner;
58 
59   }
60 
61  
62 
63   modifier onlyOwner() 
64 
65   {
66 
67     require(msg.sender == owner);
68 
69     _;
70 
71   }
72 
73  
74 
75   function transferOwnership(address newOwner) onlyOwner 
76 
77   {
78 
79     require(newOwner != address(0));      
80 
81     owner = newOwner;
82 
83   }
84 
85 }
86 
87 contract BiLinkLoan is Ownable {
88 
89 	using SafeMath for uint256;
90 
91 
92 
93 	address public contractLoanLogic;
94 
95 	address public contractBalance;
96 
97 	address public contractMarketData;
98 
99 	address public accountCost;
100 
101 	uint256 public commissionRatio;//percentage
102 
103 	
104 
105 	mapping (address => mapping ( bytes32 => uint256)) public account2Order2TradeAmount;
106 
107 	
108 
109 	mapping (address => mapping (address => uint16)) public tokenPledgeRatio;//pledge 2 borrow percentage
110 
111 	bool public isLegacy;//if true, not allow new trade,new deposit
112 
113 
114 
115 	event OnTrade(address tokenPledge, address tokenBorrow, address borrower, address lender, uint256 amountPledge, uint256 amountInterest, uint256 amountBorrow, uint256 timestamp);
116 
117 	event OnUserRepay(address tokenPledge, address tokenBorrow, address borrower, address lender, uint256 amountPledge, uint256 amountOriginInterest, uint256 amountActualInterest
118 
119 		, uint256 amountRepaied, uint256 amountRepaiedPledgeToken, uint256 timestamp);
120 
121 	event OnForceRepay(address tokenPledge, address tokenBorrow, address borrower, address lender, uint256 amountPledge, uint256 amountOriginInterest, uint256 amountActualInterest
122 
123 		, uint256 amountRepaied, uint256 amountRepaiedPledgeToken, uint256 timestamp);
124 
125 	event OnLossCompensated(address tokenPledge, address tokenBorrow, address borrower, address lender, uint256 amountLoss, uint256 amountCompensated, uint256 timestamp);
126 
127 	event OnLossCompensatedByAssurance(address tokenPledge, address tokenBorrow, address borrower, address lender, uint256 amountLoss, uint256 amountCompensated, uint256 timestamp);
128 
129 		
130 
131 	constructor(address _owner, address _accountCost, address _contractLoanLogic, address _contractMarketData, uint256 _commissionRatio) public Ownable(_owner) {
132 
133 		contractLoanLogic= _contractLoanLogic;
134 
135 		contractMarketData= _contractMarketData;
136 
137 		isLegacy= false;
138 
139 		commissionRatio= _commissionRatio;
140 
141 		accountCost= _accountCost;
142 
143 	}
144 
145 	
146 
147 	function setTokenPledgeRatio(address[] _pledgeTokens, address[] _borrowTokens, uint16[] _ratioPledges) public onlyOwner {
148 
149 		for(uint256 i= 0; i< _pledgeTokens.length; i++) {
150 
151 			tokenPledgeRatio[_pledgeTokens[i]][_borrowTokens[i]]= _ratioPledges[i];
152 
153 		}
154 
155 	}
156 
157 
158 
159 	function setThisContractAsLegacy() public onlyOwner {
160 
161 		isLegacy= true;
162 
163 	}
164 
165 
166 
167 	function setBalanceContract(address _contractBalance) public onlyOwner {
168 
169 		contractBalance= _contractBalance;
170 
171 	}
172 
173 
174 
175 	//_arr1:tokenPledge,tokenBorrow,borrower,lender
176 
177 	//_arr2:amountOrigin,amountInterest,periodDays,expireTime,amountTake
178 
179 	//_arr3:rMaker,sMaker
180 
181 	function trade(address[] _arr1, uint256[] _arr2, bool _borrowOrLend, uint8 _vMaker, bytes32[] _arr3) public {
182 
183 		require(isLegacy== false&& _arr2[4]<= _arr2[0]&& verifyInput( _arr1, _arr2, _borrowOrLend, _vMaker, _arr3)&& tokenPledgeRatio[_arr1[0]][_arr1[1]]> 0);
184 
185 		if(_borrowOrLend)
186 
187 			require(msg.sender== _arr1[2]);
188 
189 		else
190 
191 			require(msg.sender== _arr1[3]);
192 
193 
194 
195 		uint256 amountPledge= ILoanLogic(contractLoanLogic).getPledgeAmount(_arr1[0], _arr1[1], _arr2[4], tokenPledgeRatio[_arr1[0]][_arr1[1]]);
196 
197 		require(amountPledge!= 0);
198 
199 
200 
201 		uint256 amountInterest = amountPledge.mul(_arr2[1]).mul(_arr2[2]).mul(100).div(tokenPledgeRatio[_arr1[0]][_arr1[1]]).div(100000);
202 
203 		require(amountPledge.add(amountInterest)<= IBalance(contractBalance).getAvailableBalance(_arr1[0], _arr1[2])&&_arr2[4]<= IBalance(contractBalance).getAvailableBalance(_arr1[1], _arr1[3]));
204 
205 
206 
207 		IBalance(contractBalance).modifyBalance(_arr1[3], _arr1[1], _arr2[4], false); 
208 
209 		IBalance(contractBalance).modifyBalance(_arr1[2], _arr1[1], _arr2[4], true); 
210 
211 
212 
213 		require(ILoanLogic(contractLoanLogic).updateDataAfterTrade(_arr1[0], _arr1[1], _arr1[2], _arr1[3], _arr2[4], amountPledge, amountInterest, _arr2[2]));
214 
215 		
216 
217 		emit OnTrade(_arr1[0], _arr1[1], _arr1[2], _arr1[3], amountPledge, amountInterest, _arr2[4], now);
218 
219 	}
220 
221 
222 
223 	function verifyInput( address[] _arr1, uint256[] _arr2, bool _borrowOrLend, uint8 _vMaker, bytes32[] _arr3) private returns (bool) {
224 
225 		require(now <= _arr2[3]);
226 
227 		address _accountPledgeAssurance= IBalance(contractBalance).getTokenAssuranceAccount(_arr1[0]);
228 
229 		address _accountBorrowAssurance= IBalance(contractBalance).getTokenAssuranceAccount(_arr1[1]);
230 
231 		require(_accountPledgeAssurance!= _arr1[2]&& _accountPledgeAssurance!= _arr1[3]&& _accountBorrowAssurance!= _arr1[2]&& _accountBorrowAssurance!= _arr1[3]);
232 
233 
234 
235 		bytes32 _hash= keccak256(abi.encodePacked(this, _arr1[0], _arr1[1], _arr2[1], _arr2[2], _arr2[3]));
236 
237 		require(ecrecover(_hash, _vMaker, _arr3[0], _arr3[1]) == (_borrowOrLend? _arr1[3] : _arr1[2]));
238 
239 		
240 
241 		if(_borrowOrLend) {
242 
243 			require(account2Order2TradeAmount[_arr1[3]][_hash].add(_arr2[4])<= _arr2[0]);
244 
245 			account2Order2TradeAmount[_arr1[3]][_hash]= account2Order2TradeAmount[_arr1[3]][_hash].add(_arr2[4]);
246 
247 		}
248 
249 		else {
250 
251 			require(account2Order2TradeAmount[_arr1[2]][_hash].add(_arr2[4])<= _arr2[0]);
252 
253 			account2Order2TradeAmount[_arr1[2]][_hash]= account2Order2TradeAmount[_arr1[2]][_hash].add(_arr2[4]);
254 
255 		}
256 
257 		return true;
258 
259 	}
260 
261 
262 
263 	function getNeedRepayPledgeTokenAmount(uint256 _amountUnRepaiedPledgeTokenAmount, address _pledgeToken, address _borrowToken) private returns (uint256) {
264 
265 		return _amountUnRepaiedPledgeTokenAmount.mul((tokenPledgeRatio[_pledgeToken][_borrowToken] - 100)/4 + 100).div(100);
266 
267 	}
268 
269 
270 
271 	function doRepay(uint256 _id, bool _userOrForce) private {
272 
273 		var (_tokenPledge,_tokenBorrow,_borrower,_lender)= ILoanLogic(contractLoanLogic).getLoanDataPart(_id);
274 
275 		require(_borrower!= address(0));
276 
277 		 
278 
279 		uint256 _available= IBalance(contractBalance).getAvailableBalance(_tokenBorrow, _borrower);
280 
281 		var (_amount, _amountOriginInterest, _amountActualInterest,_amountUnRepaiedAmount, _amountPledge)= ILoanLogic(contractLoanLogic).updateDataAfterRepay(_id, _available);
282 
283 		require(_amount!= 0);
284 
285 
286 
287 		uint256 _amountUnRepaiedPledgeToken= tryCompensateLossByAssurance(_tokenPledge, _tokenBorrow, _borrower, _lender, _amountPledge, _amountUnRepaiedAmount);
288 
289 
290 
291 		_available= IBalance(contractBalance).getAvailableBalance(_tokenBorrow, _borrower);
292 
293 		uint256 _amountRepaiedPledgeToken= getNeedRepayPledgeTokenAmount(_amountUnRepaiedPledgeToken, _tokenPledge, _tokenBorrow);
294 
295 		adjustBalancesAfterRepay(_tokenPledge, _tokenBorrow, _borrower, _lender, _amountActualInterest, (_amountRepaiedPledgeToken< _amountPledge? _amountRepaiedPledgeToken: _amountPledge), (_available> _amount? _amount: _available)
296 
297 			, (_amountUnRepaiedPledgeToken > _amountPledge? _amountUnRepaiedPledgeToken - _amountPledge: 0));
298 
299 
300 
301 		if(_userOrForce)
302 
303 			emit OnUserRepay(_tokenPledge, _tokenBorrow, _borrower, _lender, _amountPledge, _amountOriginInterest, _amountActualInterest, _amount, _amountRepaiedPledgeToken, now);
304 
305 		else
306 
307 			emit OnForceRepay(_tokenPledge, _tokenBorrow, _borrower, _lender, _amountPledge, _amountOriginInterest, _amountActualInterest, _amount, _amountRepaiedPledgeToken, now);
308 
309 	}
310 
311 
312 
313 	function tryCompensateLossByAssurance(address _tokenPledge, address _tokenBorrow, address _borrower, address _lender, uint256 _amountPledge, uint256 _amountUnRepaiedAmount) private returns (uint256) {
314 
315 		uint256 _amountUnRepaiedPledgeToken= 0;
316 
317 		address _accountAssurance= IBalance(contractBalance).getTokenAssuranceAccount(_tokenBorrow);
318 
319 		uint256 _available= IBalance(contractBalance).getAvailableBalance(_tokenBorrow, _accountAssurance);
320 
321 		(uint256 _num, uint256 _denom)= IMarketData(contractMarketData).getTokenExchangeRatio(_tokenPledge, _tokenBorrow);
322 
323 		uint256 _equalAmount= _amountPledge.mul(_denom).div(_num);
324 
325 
326 
327 		if(_amountUnRepaiedAmount > _equalAmount&& _available> 0) {
328 
329 			uint256 _actualCompensatedAmountByAssurance= _amountUnRepaiedAmount.sub(_equalAmount);
330 
331 			if(_available< _amountUnRepaiedAmount)
332 
333 				_actualCompensatedAmountByAssurance= _available;
334 
335 			IBalance(contractBalance).modifyBalance(_accountAssurance, _tokenBorrow, _actualCompensatedAmountByAssurance, false); 
336 
337 			IBalance(contractBalance).modifyBalance(_borrower, _tokenBorrow, _actualCompensatedAmountByAssurance, true); 
338 
339 			
340 
341 			emit OnLossCompensatedByAssurance(_tokenPledge, _tokenBorrow, _borrower, _lender, _amountUnRepaiedAmount, _actualCompensatedAmountByAssurance, now);
342 
343 			_amountUnRepaiedAmount= _amountUnRepaiedAmount.sub(_actualCompensatedAmountByAssurance);
344 
345 		}
346 
347 
348 
349 		_amountUnRepaiedPledgeToken= _amountUnRepaiedAmount.mul(_num).div(_denom);
350 
351 
352 
353 		return _amountUnRepaiedPledgeToken;
354 
355 	}
356 
357 
358 
359 	function userRepay(uint256 _id) public {
360 
361 		var (_tokenPledge, _tokenBorrow, _borrower, _lender)= ILoanLogic(contractLoanLogic).getLoanDataPart(_id);
362 
363 		require(msg.sender == _borrower);
364 
365 		 
366 
367 		doRepay(_id, true);
368 
369 	}
370 
371 
372 
373 	function forceRepay(uint256[] _arr) public onlyOwner {
374 
375 		for(uint256 i= 0; i< _arr.length; i++) {
376 
377 			if(ILoanLogic(contractLoanLogic).needForceClose(_arr[i])) {
378 
379 				doRepay(_arr[i], false);
380 
381 			}
382 
383 		}
384 
385 	}
386 
387 
388 
389 	function adjustBalancesAfterRepay(address _tokenPledge, address _tokenBorrow, address _borrower, address _lender, uint256 _amountActualInterest, uint256 _amountRepaiedPeldgeToken, uint256 _amountRepaiedBorrowToken, uint256 _amountLoss) private {
390 
391 		uint256 _amountProfit= (_amountActualInterest.mul(commissionRatio))/ 100;
392 
393 		IBalance(contractBalance).modifyBalance(_borrower, _tokenPledge, _amountRepaiedPeldgeToken.add(_amountActualInterest), false); 
394 
395 		IBalance(contractBalance).modifyBalance(_lender, _tokenPledge, _amountActualInterest.sub(_amountProfit), true);
396 
397 		 		 
398 
399 		if(_amountRepaiedBorrowToken> 0) {
400 
401 			IBalance(contractBalance).modifyBalance(_borrower, _tokenBorrow, _amountRepaiedBorrowToken, false);
402 
403 			IBalance(contractBalance).modifyBalance(_lender, _tokenBorrow, _amountRepaiedBorrowToken, true);
404 
405 		}
406 
407 
408 
409 		if(_amountLoss> 0) {
410 
411 			if(IBalance(contractBalance).getAvailableBalance(_tokenPledge, accountCost)/ 10> _amountLoss) {
412 
413 				IBalance(contractBalance).modifyBalance(accountCost, _tokenPledge, _amountLoss, false); 
414 
415 				IBalance(contractBalance).modifyBalance(_lender, _tokenPledge, _amountLoss, true); 
416 
417 				emit OnLossCompensated(_tokenPledge, _tokenBorrow, _borrower, _lender, _amountLoss, _amountLoss, now);
418 
419 			}
420 
421 			else {
422 
423 				uint256 uActualPaiedLoss= IBalance(contractBalance).getAvailableBalance(_tokenPledge, accountCost)/ 10;
424 
425 				IBalance(contractBalance).modifyBalance(accountCost, _tokenPledge, uActualPaiedLoss, false); 
426 
427 				IBalance(contractBalance).modifyBalance(_lender, _tokenPledge, uActualPaiedLoss, true); 
428 
429 				emit OnLossCompensated(_tokenPledge, _tokenBorrow, _borrower, _lender, _amountLoss, uActualPaiedLoss, now);
430 
431 			}
432 
433 		}
434 
435 
436 
437 		IBalance(contractBalance).modifyBalance(_lender, _tokenPledge, _amountRepaiedPeldgeToken, true);
438 
439 
440 
441 		if(_tokenPledge== address(0)) {
442 
443 			IBalance(contractBalance).distributeEthProfit(_lender, _amountProfit);
444 
445 		}
446 
447 		else {
448 
449 			IBalance(contractBalance).distributeTokenProfit(_lender, _tokenPledge, _amountProfit);
450 
451 		}
452 
453 	}
454 
455 }
456 
457 library SafeMath {
458 
459 
460 
461   /**
462 
463   * @dev Multiplies two numbers, throws on overflow.
464 
465   */
466 
467   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
468 
469     if (a == 0) {
470 
471       return 0;
472 
473     }
474 
475     uint256 c = a * b;
476 
477     require(c / a == b);
478 
479     return c;
480 
481   }
482 
483 
484 
485   /**
486 
487   * @dev Integer division of two numbers, truncating the quotient.
488 
489   */
490 
491   function div(uint256 a, uint256 b) internal pure returns (uint256) {
492 
493     require(b > 0); // Solidity automatically throws when dividing by 0
494 
495     uint256 c = a / b;
496 
497     return c;
498 
499   }
500 
501 
502 
503   /**
504 
505   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
506 
507   */
508 
509   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
510 
511     require(b <= a);
512 
513     return a - b;
514 
515   }
516 
517 
518 
519   /**
520 
521   * @dev Adds two numbers, throws on overflow.
522 
523   */
524 
525   function add(uint256 a, uint256 b) internal pure returns (uint256) {
526 
527     uint256 c = a + b;
528 
529     require(c >= a);
530 
531     return c;
532 
533   }
534 
535 }
536 
537 contract ILoanLogic {  
538 
539 	function setTokenExchangeRatio(address[] tokenPledge, address[] tokenBorrow, uint256[] amountDenom, uint256[] amountNum) public returns (bool);
540 
541 	function getPledgeAmount(address tokenPledge, address tokenBorrow, uint256 amount,uint16 ratioPledge) public constant returns (uint256);
542 
543 	function updateDataAfterTrade(address tokenPledge, address tokenBorrow, address borrower, address lender,
544 
545 		uint256 amountPledge, uint256 amount, uint256 amountInterest, uint256 periodDays) public returns(bool);
546 
547 	function updateDataAfterRepay(uint256 id, uint256 uBorrowerAvailableAmount) public returns (uint256, uint256, uint256, uint256, uint256);
548 
549 	function getLoanDataPart(uint256 id) public constant returns (address, address, address, address);
550 
551 	function needForceClose(uint256 id) public constant returns (bool);
552 
553 }
554 
555 contract IBalance {
556 
557 	function distributeEthProfit(address profitMaker, uint256 amount) public ;
558 
559 	function distributeTokenProfit (address profitMaker, address token, uint256 amount) public ;
560 
561 	function modifyBalance(address _account, address _token, uint256 _amount, bool _addOrSub) public;
562 
563 	function getAvailableBalance(address _token, address _account) public constant returns (uint256);
564 
565 	function getTokenAssuranceAccount(address _token) public constant returns (address);
566 
567 }