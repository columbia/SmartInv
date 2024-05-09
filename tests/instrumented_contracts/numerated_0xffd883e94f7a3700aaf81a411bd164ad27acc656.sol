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
39 library SafeMath {
40 
41 
42 
43   /**
44 
45   * @dev Multiplies two numbers, throws on overflow.
46 
47   */
48 
49   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50 
51     if (a == 0) {
52 
53       return 0;
54 
55     }
56 
57     uint256 c = a * b;
58 
59     require(c / a == b);
60 
61     return c;
62 
63   }
64 
65 
66 
67   /**
68 
69   * @dev Integer division of two numbers, truncating the quotient.
70 
71   */
72 
73   function div(uint256 a, uint256 b) internal pure returns (uint256) {
74 
75     require(b > 0); // Solidity automatically throws when dividing by 0
76 
77     uint256 c = a / b;
78 
79     return c;
80 
81   }
82 
83 
84 
85   /**
86 
87   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
88 
89   */
90 
91   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
92 
93     require(b <= a);
94 
95     return a - b;
96 
97   }
98 
99 
100 
101   /**
102 
103   * @dev Adds two numbers, throws on overflow.
104 
105   */
106 
107   function add(uint256 a, uint256 b) internal pure returns (uint256) {
108 
109     uint256 c = a + b;
110 
111     require(c >= a);
112 
113     return c;
114 
115   }
116 
117 }
118 
119 contract Ownable 
120 
121 {
122 
123   address public owner;
124 
125  
126 
127   constructor(address _owner) public 
128 
129   {
130 
131     owner = _owner;
132 
133   }
134 
135  
136 
137   modifier onlyOwner() 
138 
139   {
140 
141     require(msg.sender == owner);
142 
143     _;
144 
145   }
146 
147  
148 
149   function transferOwnership(address newOwner) onlyOwner 
150 
151   {
152 
153     require(newOwner != address(0));      
154 
155     owner = newOwner;
156 
157   }
158 
159 }
160 
161 contract BiLinkLoan is Ownable {
162 
163 	using SafeMath for uint256;
164 
165 
166 
167 	address public contractLoanLogic;
168 
169 	address public contractBalance;
170 
171 	address public contractMarketData;
172 
173 	address public accountCost;
174 
175 	uint256 public commissionRatio;//percentage
176 
177 	
178 
179 	mapping (address => mapping ( bytes32 => uint256)) public account2Order2TradeAmount;
180 
181 	
182 
183 	mapping (address => mapping (address => uint16)) public tokenPledgeRatio;//pledge 2 borrow percentage
184 
185 	bool public isLegacy;//if true, not allow new trade,new deposit
186 
187 
188 
189 	event OnTrade(bytes32 guid,address tokenPledge, address tokenBorrow, address borrower, address lender, uint256 amountPledge, uint256 amountInterest, uint256 amountBorrow, uint256 timestamp);
190 
191 	event OnUserRepay(uint256 id, address tokenPledge, address tokenBorrow, address borrower, address lender, uint256 amountPledge, uint256 amountOriginInterest, uint256 amountActualInterest
192 
193 		, uint256 amountRepaied, uint256 amountRepaiedPledgeToken, uint256 timestamp);
194 
195 	event OnForceRepay(uint256 id, address tokenPledge, address tokenBorrow, address borrower, address lender, uint256 amountPledge, uint256 amountOriginInterest, uint256 amountActualInterest
196 
197 		, uint256 amountRepaied, uint256 amountRepaiedPledgeToken, uint256 timestamp);
198 
199 	event OnLossCompensated(address tokenPledge, address tokenBorrow, address borrower, address lender, uint256 amountLoss, uint256 amountCompensated, uint256 timestamp);
200 
201 	event OnLossCompensatedByAssurance(address tokenPledge, address tokenBorrow, address borrower, address lender, uint256 amountLoss, uint256 amountCompensated, uint256 timestamp);
202 
203 		
204 
205 	constructor(address _owner, address _accountCost, address _contractLoanLogic, address _contractMarketData, uint256 _commissionRatio) public Ownable(_owner) {
206 
207 		contractLoanLogic= _contractLoanLogic;
208 
209 		contractMarketData= _contractMarketData;
210 
211 		isLegacy= false;
212 
213 		commissionRatio= _commissionRatio;
214 
215 		accountCost= _accountCost;
216 
217 	}
218 
219 	
220 
221 	function setTokenPledgeRatio(address[] _pledgeTokens, address[] _borrowTokens, uint16[] _ratioPledges) public onlyOwner {
222 
223 		for(uint256 i= 0; i< _pledgeTokens.length; i++) {
224 
225 			tokenPledgeRatio[_pledgeTokens[i]][_borrowTokens[i]]= _ratioPledges[i];
226 
227 		}
228 
229 	}
230 
231 
232 
233 	function setThisContractAsLegacy() public onlyOwner {
234 
235 		isLegacy= true;
236 
237 	}
238 
239 
240 
241 	function setBalanceContract(address _contractBalance) public onlyOwner {
242 
243 		contractBalance= _contractBalance;
244 
245 	}
246 
247 
248 
249 	//_arr1:tokenPledge,tokenBorrow,borrower,lender
250 
251 	//_arr2:amountOrigin,amountInterest,periodDays,expireTime,amountTake
252 
253 	//_arr3:rMaker,sMaker
254 
255 	function trade(address[] _arr1, uint256[] _arr2, bool _borrowOrLend, bytes32 _guid, uint8 _vMaker, bytes32[] _arr3) public {
256 
257 		require(isLegacy== false&& _arr2[4]<= _arr2[0]&& verifyInput( _arr1, _arr2, _borrowOrLend, _vMaker, _arr3)&& tokenPledgeRatio[_arr1[0]][_arr1[1]]> 0);
258 
259 		if(_borrowOrLend)
260 
261 			require(msg.sender== _arr1[2]);
262 
263 		else
264 
265 			require(msg.sender== _arr1[3]);
266 
267 
268 
269 		uint256 amountPledge= ILoanLogic(contractLoanLogic).getPledgeAmount(_arr1[0], _arr1[1], _arr2[4], tokenPledgeRatio[_arr1[0]][_arr1[1]]);
270 
271 		require(amountPledge!= 0);
272 
273 
274 
275 		uint256 amountInterest = amountPledge.mul(_arr2[1]).mul(_arr2[2]).mul(100).div(tokenPledgeRatio[_arr1[0]][_arr1[1]]).div(100000);
276 
277 		require(amountPledge.add(amountInterest)<= IBalance(contractBalance).getAvailableBalance(_arr1[0], _arr1[2])&&_arr2[4]<= IBalance(contractBalance).getAvailableBalance(_arr1[1], _arr1[3]));
278 
279 
280 
281 		IBalance(contractBalance).modifyBalance(_arr1[3], _arr1[1], _arr2[4], false); 
282 
283 		IBalance(contractBalance).modifyBalance(_arr1[2], _arr1[1], _arr2[4], true); 
284 
285 
286 
287 		require(ILoanLogic(contractLoanLogic).updateDataAfterTrade(_arr1[0], _arr1[1], _arr1[2], _arr1[3], _arr2[4], amountPledge, amountInterest, _arr2[2]));
288 
289 		
290 
291 		emit OnTrade(_guid, _arr1[0], _arr1[1], _arr1[2], _arr1[3], amountPledge, amountInterest, _arr2[4], now);
292 
293 	}
294 
295 
296 
297 	function verifyInput( address[] _arr1, uint256[] _arr2, bool _borrowOrLend, uint8 _vMaker, bytes32[] _arr3) private returns (bool) {
298 
299 		require(now <= _arr2[3]);
300 
301 		address _accountPledgeAssurance= IBalance(contractBalance).getTokenAssuranceAccount(_arr1[0]);
302 
303 		address _accountBorrowAssurance= IBalance(contractBalance).getTokenAssuranceAccount(_arr1[1]);
304 
305 		require(_accountPledgeAssurance!= _arr1[2]&& _accountPledgeAssurance!= _arr1[3]&& _accountBorrowAssurance!= _arr1[2]&& _accountBorrowAssurance!= _arr1[3]);
306 
307 
308 
309 		bytes32 _hash= keccak256(abi.encodePacked(this, _arr1[0], _arr1[1], _arr2[1], _arr2[2], _arr2[3]));
310 
311 		require(ecrecover(_hash, _vMaker, _arr3[0], _arr3[1]) == (_borrowOrLend? _arr1[3] : _arr1[2]));
312 
313 		
314 
315 		if(_borrowOrLend) {
316 
317 			require(account2Order2TradeAmount[_arr1[3]][_hash].add(_arr2[4])<= _arr2[0]);
318 
319 			account2Order2TradeAmount[_arr1[3]][_hash]= account2Order2TradeAmount[_arr1[3]][_hash].add(_arr2[4]);
320 
321 		}
322 
323 		else {
324 
325 			require(account2Order2TradeAmount[_arr1[2]][_hash].add(_arr2[4])<= _arr2[0]);
326 
327 			account2Order2TradeAmount[_arr1[2]][_hash]= account2Order2TradeAmount[_arr1[2]][_hash].add(_arr2[4]);
328 
329 		}
330 
331 		return true;
332 
333 	}
334 
335 
336 
337 	function getNeedRepayPledgeTokenAmount(uint256 _amountUnRepaiedPledgeTokenAmount, address _pledgeToken, address _borrowToken) private returns (uint256) {
338 
339 		return _amountUnRepaiedPledgeTokenAmount.mul((tokenPledgeRatio[_pledgeToken][_borrowToken] - 100)/4 + 100).div(100);
340 
341 	}
342 
343 
344 
345 	function doRepay(uint256 _id, bool _userOrForce) private {
346 
347 		var (_tokenPledge,_tokenBorrow,_borrower,_lender)= ILoanLogic(contractLoanLogic).getLoanDataPart(_id);
348 
349 		require(_borrower!= address(0));
350 
351 		 
352 
353 		uint256 _available= IBalance(contractBalance).getAvailableBalance(_tokenBorrow, _borrower);
354 
355 		var (_amount, _amountOriginInterest, _amountActualInterest,_amountUnRepaiedAmount, _amountPledge)= ILoanLogic(contractLoanLogic).updateDataAfterRepay(_id, _available);
356 
357 		require(_amount!= 0);
358 
359 
360 
361 		uint256 _amountUnRepaiedPledgeToken= tryCompensateLossByAssurance(_tokenPledge, _tokenBorrow, _borrower, _lender, _amountPledge, _amountUnRepaiedAmount);
362 
363 
364 
365 		_available= IBalance(contractBalance).getAvailableBalance(_tokenBorrow, _borrower);
366 
367 		uint256 _amountRepaiedPledgeToken= getNeedRepayPledgeTokenAmount(_amountUnRepaiedPledgeToken, _tokenPledge, _tokenBorrow);
368 
369 		adjustBalancesAfterRepay(_tokenPledge, _tokenBorrow, _borrower, _lender, _amountActualInterest, (_amountRepaiedPledgeToken< _amountPledge? _amountRepaiedPledgeToken: _amountPledge), (_available> _amount? _amount: _available)
370 
371 			, (_amountUnRepaiedPledgeToken > _amountPledge? _amountUnRepaiedPledgeToken - _amountPledge: 0));
372 
373 
374 
375 		if(_userOrForce)
376 
377 			emit OnUserRepay(_id, _tokenPledge, _tokenBorrow, _borrower, _lender, _amountPledge, _amountOriginInterest, _amountActualInterest, _amount, _amountRepaiedPledgeToken, now);
378 
379 		else
380 
381 			emit OnForceRepay(_id, _tokenPledge, _tokenBorrow, _borrower, _lender, _amountPledge, _amountOriginInterest, _amountActualInterest, _amount, _amountRepaiedPledgeToken, now);
382 
383 	}
384 
385 
386 
387 	function tryCompensateLossByAssurance(address _tokenPledge, address _tokenBorrow, address _borrower, address _lender, uint256 _amountPledge, uint256 _amountUnRepaiedAmount) private returns (uint256) {
388 
389 		uint256 _amountUnRepaiedPledgeToken= 0;
390 
391 		address _accountAssurance= IBalance(contractBalance).getTokenAssuranceAccount(_tokenBorrow);
392 
393 		uint256 _available= IBalance(contractBalance).getAvailableBalance(_tokenBorrow, _accountAssurance);
394 
395 		(uint256 _num, uint256 _denom)= IMarketData(contractMarketData).getTokenExchangeRatio(_tokenPledge, _tokenBorrow);
396 
397 		uint256 _equalAmount= _amountPledge.mul(_denom).div(_num);
398 
399 
400 
401 		if(_amountUnRepaiedAmount > _equalAmount&& _available> 0) {
402 
403 			uint256 _actualCompensatedAmountByAssurance= _amountUnRepaiedAmount.sub(_equalAmount);
404 
405 			if(_available< _amountUnRepaiedAmount)
406 
407 				_actualCompensatedAmountByAssurance= _available;
408 
409 			IBalance(contractBalance).modifyBalance(_accountAssurance, _tokenBorrow, _actualCompensatedAmountByAssurance, false); 
410 
411 			IBalance(contractBalance).modifyBalance(_borrower, _tokenBorrow, _actualCompensatedAmountByAssurance, true); 
412 
413 			
414 
415 			emit OnLossCompensatedByAssurance(_tokenPledge, _tokenBorrow, _borrower, _lender, _amountUnRepaiedAmount, _actualCompensatedAmountByAssurance, now);
416 
417 			_amountUnRepaiedAmount= _amountUnRepaiedAmount.sub(_actualCompensatedAmountByAssurance);
418 
419 		}
420 
421 
422 
423 		_amountUnRepaiedPledgeToken= _amountUnRepaiedAmount.mul(_num).div(_denom);
424 
425 
426 
427 		return _amountUnRepaiedPledgeToken;
428 
429 	}
430 
431 
432 
433 	function userRepay(uint256 _id) public {
434 
435 		var (_tokenPledge, _tokenBorrow, _borrower, _lender)= ILoanLogic(contractLoanLogic).getLoanDataPart(_id);
436 
437 		require(msg.sender == _borrower);
438 
439 		 
440 
441 		doRepay(_id, true);
442 
443 	}
444 
445 
446 
447 	function forceRepay(uint256[] _arr) public onlyOwner {
448 
449 		for(uint256 i= 0; i< _arr.length; i++) {
450 
451 			if(ILoanLogic(contractLoanLogic).needForceClose(_arr[i])) {
452 
453 				doRepay(_arr[i], false);
454 
455 			}
456 
457 		}
458 
459 	}
460 
461 
462 
463 	function adjustBalancesAfterRepay(address _tokenPledge, address _tokenBorrow, address _borrower, address _lender, uint256 _amountActualInterest, uint256 _amountRepaiedPeldgeToken, uint256 _amountRepaiedBorrowToken, uint256 _amountLoss) private {
464 
465 		uint256 _amountProfit= (_amountActualInterest.mul(commissionRatio))/ 100;
466 
467 		IBalance(contractBalance).modifyBalance(_borrower, _tokenPledge, _amountRepaiedPeldgeToken.add(_amountActualInterest), false); 
468 
469 		IBalance(contractBalance).modifyBalance(_lender, _tokenPledge, _amountActualInterest.sub(_amountProfit), true);
470 
471 		 		 
472 
473 		if(_amountRepaiedBorrowToken> 0) {
474 
475 			IBalance(contractBalance).modifyBalance(_borrower, _tokenBorrow, _amountRepaiedBorrowToken, false);
476 
477 			IBalance(contractBalance).modifyBalance(_lender, _tokenBorrow, _amountRepaiedBorrowToken, true);
478 
479 		}
480 
481 
482 
483 		if(_amountLoss> 0) {
484 
485 			if(IBalance(contractBalance).getAvailableBalance(_tokenPledge, accountCost)/ 10> _amountLoss) {
486 
487 				IBalance(contractBalance).modifyBalance(accountCost, _tokenPledge, _amountLoss, false); 
488 
489 				IBalance(contractBalance).modifyBalance(_lender, _tokenPledge, _amountLoss, true); 
490 
491 				emit OnLossCompensated(_tokenPledge, _tokenBorrow, _borrower, _lender, _amountLoss, _amountLoss, now);
492 
493 			}
494 
495 			else {
496 
497 				uint256 uActualPaiedLoss= IBalance(contractBalance).getAvailableBalance(_tokenPledge, accountCost)/ 10;
498 
499 				IBalance(contractBalance).modifyBalance(accountCost, _tokenPledge, uActualPaiedLoss, false); 
500 
501 				IBalance(contractBalance).modifyBalance(_lender, _tokenPledge, uActualPaiedLoss, true); 
502 
503 				emit OnLossCompensated(_tokenPledge, _tokenBorrow, _borrower, _lender, _amountLoss, uActualPaiedLoss, now);
504 
505 			}
506 
507 		}
508 
509 
510 
511 		IBalance(contractBalance).modifyBalance(_lender, _tokenPledge, _amountRepaiedPeldgeToken, true);
512 
513 
514 
515 		if(_tokenPledge== address(0)) {
516 
517 			IBalance(contractBalance).distributeEthProfit(_lender, _amountProfit);
518 
519 		}
520 
521 		else {
522 
523 			IBalance(contractBalance).distributeTokenProfit(_lender, _tokenPledge, _amountProfit);
524 
525 		}
526 
527 	}
528 
529 }
530 
531 contract ILoanLogic {  
532 
533 	function setTokenExchangeRatio(address[] tokenPledge, address[] tokenBorrow, uint256[] amountDenom, uint256[] amountNum) public returns (bool);
534 
535 	function getPledgeAmount(address tokenPledge, address tokenBorrow, uint256 amount,uint16 ratioPledge) public constant returns (uint256);
536 
537 	function updateDataAfterTrade(address tokenPledge, address tokenBorrow, address borrower, address lender,
538 
539 		uint256 amountPledge, uint256 amount, uint256 amountInterest, uint256 periodDays) public returns(bool);
540 
541 	function updateDataAfterRepay(uint256 id, uint256 uBorrowerAvailableAmount) public returns (uint256, uint256, uint256, uint256, uint256);
542 
543 	function getLoanDataPart(uint256 id) public constant returns (address, address, address, address);
544 
545 	function needForceClose(uint256 id) public constant returns (bool);
546 
547 }
548 
549 contract IMarketData {
550 
551 	function getTokenExchangeRatio(address _tokenNum, address _tokenDenom) public returns (uint256 num, uint256 denom);
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