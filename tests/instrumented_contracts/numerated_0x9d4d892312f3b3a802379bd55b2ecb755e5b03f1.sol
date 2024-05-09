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
39 contract IBiLinkToken is IToken {
40 
41 	function getCanShareProfitAccounts() public constant returns (address[]);
42 
43 	function totalSupply() public view returns (uint256);
44 
45 	function balanceOf(address _account) public view returns (uint256);
46 
47 	function mint(address _to, uint256 _amount) public returns (bool);
48 
49 	function burn(uint256 amount) public;
50 
51 }
52 
53 library SafeMath {
54 
55 
56 
57   /**
58 
59   * @dev Multiplies two numbers, throws on overflow.
60 
61   */
62 
63   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64 
65     if (a == 0) {
66 
67       return 0;
68 
69     }
70 
71     uint256 c = a * b;
72 
73     require(c / a == b);
74 
75     return c;
76 
77   }
78 
79 
80 
81   /**
82 
83   * @dev Integer division of two numbers, truncating the quotient.
84 
85   */
86 
87   function div(uint256 a, uint256 b) internal pure returns (uint256) {
88 
89     require(b > 0); // Solidity automatically throws when dividing by 0
90 
91     uint256 c = a / b;
92 
93     return c;
94 
95   }
96 
97 
98 
99   /**
100 
101   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
102 
103   */
104 
105   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106 
107     require(b <= a);
108 
109     return a - b;
110 
111   }
112 
113 
114 
115   /**
116 
117   * @dev Adds two numbers, throws on overflow.
118 
119   */
120 
121   function add(uint256 a, uint256 b) internal pure returns (uint256) {
122 
123     uint256 c = a + b;
124 
125     require(c >= a);
126 
127     return c;
128 
129   }
130 
131 }
132 
133 contract Ownable 
134 
135 {
136 
137   address public owner;
138 
139  
140 
141   constructor(address _owner) public 
142 
143   {
144 
145     owner = _owner;
146 
147   }
148 
149  
150 
151   modifier onlyOwner() 
152 
153   {
154 
155     require(msg.sender == owner);
156 
157     _;
158 
159   }
160 
161  
162 
163   function transferOwnership(address newOwner) onlyOwner 
164 
165   {
166 
167     require(newOwner != address(0));      
168 
169     owner = newOwner;
170 
171   }
172 
173 }
174 
175 contract ILoanLogic {
176 
177 	function getTotalPledgeAmount(address token, address account) public constant returns (uint256);
178 
179 	function hasUnpaidLoan(address account) public constant returns (bool);
180 
181 	function getTotalBorrowAmount(address _token) public constant returns (uint256);
182 
183 }
184 
185 contract IMarketData {
186 
187 	function getTokenExchangeRatio(address _tokenNum, address _tokenDenom) public returns (uint256 num, uint256 denom);
188 
189 }
190 
191 contract Balance is Ownable {
192 
193 	using SafeMath for uint256;
194 
195      
196 
197 	mapping (address => mapping (address => uint256)) public account2Token2Balance;
198 
199 	mapping (address => uint256) public token2ProfitShare;
200 
201 	mapping (address => address) public token2AssuranceAccount;
202 
203 	mapping (address => uint256) public assuranceAccount2LastDepositTime;
204 
205 
206 
207 	address public contractBLK;
208 
209 	address public contractBiLinkLoan;
210 
211 	address public contractLoanLogic;
212 
213 	address public contractBiLinkExchange;
214 
215 	address public contractMarketData;
216 
217 	
218 
219 	address public accountCost;
220 
221 	uint256 public ratioProfit2Cost;//percentage
222 
223 	uint256 public ratioProfit2BuyBLK;//percentage
224 
225 	uint256 public ETH_BLK_MULTIPLIER= 1000;
226 
227 	uint256 public amountEthToBuyBLK;
228 
229 	uint256 public priceBLK;//eth
230 
231 
232 
233 	bool public isLegacy;//if true, not allow new trade,new deposit
234 
235 	bool private depositingTokenFlag;
236 
237 
238 
239 	event OnShareProfit(address token, uint256 amount, uint256 timestamp );
240 
241 	event OnSellBLK(address account, uint256 amount, uint256 timestamp );
242 
243 	
244 
245 	event OnDeposit(address token, address account, uint256 amount, uint256 balance, uint256 timestamp);
246 
247 	event OnWithdraw(address token, address account, uint256 amount, uint256 balance, uint256 timestamp);
248 
249 	event OnFundsMigrated(address account, address newContract, uint256 timestamp);
250 
251 
252 
253     constructor (address _owner, address _contractBLK, address _contractBiLinkLoan, address _contractLoanLogic, address _contractBiLinkExchange, address _contractMarketData
254 
255 		, address _accountCost, uint256 _ratioProfit2Cost, uint256 _ratioProfit2BuyBLK, uint256 _priceBLK) public Ownable(_owner) {
256 
257 		contractBLK= _contractBLK;
258 
259 		contractBiLinkExchange= _contractBiLinkExchange;
260 
261 		contractBiLinkLoan= _contractBiLinkLoan;
262 
263 		contractLoanLogic= _contractLoanLogic;
264 
265 		contractMarketData= _contractMarketData;
266 
267 		accountCost= _accountCost;
268 
269 		ratioProfit2Cost= _ratioProfit2Cost;
270 
271 		ratioProfit2BuyBLK= _ratioProfit2BuyBLK;
272 
273 		priceBLK= _priceBLK;
274 
275 	}
276 
277 
278 
279 	function setThisContractAsLegacy() public onlyOwner {
280 
281 		isLegacy= true;
282 
283 	}
284 
285 
286 
287 	function setRatioProfit2Cost(uint256 _ratio) public onlyOwner {
288 
289 		require(_ratio <= 20);
290 
291 		ratioProfit2Cost= _ratio;
292 
293 	}
294 
295 
296 
297 	function setRatioProfit2BuyBLK(uint256 _ratio) public onlyOwner {
298 
299 		ratioProfit2BuyBLK= _ratio;
300 
301 	}
302 
303 
304 
305 	function setTokenAssuranceAccount(address _token, address _account) public onlyOwner {
306 
307 		require(token2AssuranceAccount[_token]== address(0));
308 
309 
310 
311 		token2AssuranceAccount[_token]= _account;
312 
313 	}
314 
315 
316 
317 	function getTokenAssuranceAccount(address _token) public constant returns (address) {
318 
319 		return token2AssuranceAccount[_token];
320 
321 	}
322 
323 
324 
325 	function getTokenAssuranceAmount(address _token) public constant returns (uint256) {
326 
327 		return account2Token2Balance[token2AssuranceAccount[_token]][_token];
328 
329 	}
330 
331 
332 
333 	function depositEther() public payable {
334 
335 		require(isLegacy== false);
336 
337 
338 
339 		account2Token2Balance[msg.sender][address(0)]= account2Token2Balance[msg.sender][address(0)].add(msg.value);
340 
341 		emit OnDeposit(0, msg.sender, msg.value, account2Token2Balance[msg.sender][0], now);
342 
343 	}
344 
345 
346 
347 	function withdrawEther(uint256 _amount) public {
348 
349 		require(account2Token2Balance[msg.sender][0] >= _amount);
350 
351 		account2Token2Balance[msg.sender][0] = account2Token2Balance[msg.sender][0].sub(_amount);
352 
353 
354 
355 		msg.sender.transfer(_amount);
356 
357 		emit OnWithdraw(0, msg.sender, _amount, account2Token2Balance[msg.sender][0], now);
358 
359 	}
360 
361 
362 
363 	function depositToken(address _token, uint256 _amount) public {
364 
365 		require(_token != address(0)&& isLegacy== false);
366 
367 		depositingTokenFlag = true;
368 
369 		require(IToken(_token).transferFrom(msg.sender, this, _amount));
370 
371 		depositingTokenFlag = false;
372 
373 
374 
375 		if(token2AssuranceAccount[_token]== msg.sender)
376 
377 			assuranceAccount2LastDepositTime[msg.sender]= now;
378 
379 		 
380 
381 		account2Token2Balance[msg.sender][_token] = account2Token2Balance[msg.sender][_token].add(_amount);
382 
383 		emit OnDeposit(_token, msg.sender, _amount, account2Token2Balance[msg.sender][_token], now);
384 
385 	}
386 
387 
388 
389 	function withdrawToken(address _token, uint256 _amount) public {
390 
391 		require(_token != address(0));
392 
393 		require(account2Token2Balance[msg.sender][_token] >= _amount);
394 
395 
396 
397 		if(token2AssuranceAccount[_token]== msg.sender) {
398 
399 			require(_amount<= account2Token2Balance[msg.sender][_token].sub(ILoanLogic(contractLoanLogic).getTotalBorrowAmount(_token)));
400 
401 			require(now.sub(assuranceAccount2LastDepositTime[msg.sender]) > 30 * 24 * 3600);
402 
403 		}
404 
405 
406 
407 		account2Token2Balance[msg.sender][_token] = account2Token2Balance[msg.sender][_token].sub(_amount);
408 
409 		require(IToken(_token).transfer(msg.sender, _amount));
410 
411 		emit OnWithdraw(_token, msg.sender, _amount, account2Token2Balance[msg.sender][_token], now);
412 
413 	}
414 
415 
416 
417 	function tokenFallback( address _sender, uint256 _amount, bytes _data) public returns (bool ok) {
418 
419 		if (depositingTokenFlag) {
420 
421 			// Transfer was initiated from depositToken(). User token balance will be updated there.
422 
423 			return true;
424 
425 		} 
426 
427 		else {
428 
429 			// Direct ECR223 Token.transfer into this contract not allowed, to keep it consistent
430 
431 			// with direct transfers of ECR20 and ETH.
432 
433 			revert();
434 
435 		}
436 
437 	}
438 
439 
440 
441 	function getBalance(address _token, address _account) public constant returns (uint256, uint256) {		
442 
443 		return (account2Token2Balance[_account][_token] , getAvailableBalance(_token, _account)); 
444 
445 	}
446 
447 
448 
449 	function getAvailableBalance(address _token, address _account) public constant returns (uint256) {		
450 
451 		return account2Token2Balance[_account][_token].sub(ILoanLogic(contractLoanLogic).getTotalPledgeAmount(_token, _account)); 
452 
453 	}
454 
455 
456 
457 	function modifyBalance(address _account, address _token, uint256 _amount, bool _addOrSub) public {
458 
459 		require(msg.sender== contractBiLinkLoan|| msg.sender== contractBiLinkExchange);
460 
461 
462 
463 		if(_addOrSub)
464 
465 			account2Token2Balance[_account][_token]= account2Token2Balance[_account][_token].add(_amount);
466 
467 		else
468 
469 			account2Token2Balance[_account][_token]= account2Token2Balance[_account][_token].sub(_amount);
470 
471 	}
472 
473 
474 
475 	function distributeEthProfit (address _profitMaker, uint256 _amount) public {
476 
477 		uint256 _amountCost= _amount.mul(ratioProfit2Cost).div(100);
478 
479 		account2Token2Balance[accountCost][address(0)]= account2Token2Balance[accountCost][address(0)].add(_amountCost);
480 
481 
482 
483 		uint256 _amountToBuyBLK= _amount.mul(ratioProfit2BuyBLK).div(100);
484 
485 		amountEthToBuyBLK= amountEthToBuyBLK.add(_amountToBuyBLK);
486 
487 
488 
489 		token2ProfitShare[address(0)]= token2ProfitShare[address(0)].add(_amount.sub(_amountCost).sub(_amountToBuyBLK));
490 
491 		
492 
493 		IBiLinkToken(contractBLK).mint(_profitMaker, _amountToBuyBLK.mul(ETH_BLK_MULTIPLIER));
494 
495 	}
496 
497 	
498 
499 	function distributeTokenProfit (address _profitMaker, address _token, uint256 _amount) public {
500 
501 		token2ProfitShare[_token]= token2ProfitShare[_token].add(_amount);
502 
503 
504 
505 		(uint256 _num, uint256 _denom)= IMarketData(contractMarketData).getTokenExchangeRatio(address(0), _token);
506 
507 		IBiLinkToken(contractBLK).mint(_profitMaker, _amount.mul(_num* 5).div(_denom* 8).mul(ETH_BLK_MULTIPLIER));
508 
509 	}
510 
511 
512 
513 	function shareProfit(address _token) public {
514 
515 		require(token2ProfitShare[_token]> 0);
516 
517 
518 
519 		uint256 _amountBLKMined= IBiLinkToken(contractBLK).totalSupply();
520 
521 
522 
523 		uint256 _amountProfit= token2ProfitShare[_token];
524 
525 		token2ProfitShare[_token]= 0;
526 
527 
528 
529 		address[] memory _accounts= IBiLinkToken(contractBLK).getCanShareProfitAccounts();
530 
531 		for(uint256 i= 0; i< _accounts.length; i++) {
532 
533 			uint256 _balance= IBiLinkToken(contractBLK).balanceOf(_accounts[i]);
534 
535 			if(_balance> 0)
536 
537 				IToken(_token).transfer(_accounts[i], _balance.mul(_amountProfit).div(_amountBLKMined));
538 
539 		}
540 
541 
542 
543 		emit OnShareProfit(_token, _amountProfit, now);
544 
545 	}
546 
547 
548 
549 	function migrateFund(address _newContract, address[] _tokens) public {
550 
551 		require(_newContract != address(0)&& ILoanLogic(contractLoanLogic).hasUnpaidLoan(msg.sender)== false);
552 
553     
554 
555 		Balance _newBalance= Balance(_newContract);
556 
557 
558 
559 		uint256 _amountEther = account2Token2Balance[msg.sender][0];
560 
561 		if (_amountEther > 0) {
562 
563 			account2Token2Balance[msg.sender][0] = 0;
564 
565 			_newBalance.depositFromUserMigration.value(_amountEther)(msg.sender);
566 
567 		}
568 
569 
570 
571 		for (uint16 n = 0; n < _tokens.length; n++) {
572 
573 			address _token = _tokens[n];
574 
575 			require(_token != address(0)); // Ether is handled above.
576 
577 			uint256 _amountToken = account2Token2Balance[msg.sender][_token];
578 
579       
580 
581 			if (_amountToken != 0) {      
582 
583 				require(IToken(_token).approve(_newBalance, _amountToken));
584 
585 				account2Token2Balance[msg.sender][_token] = 0;
586 
587 				_newBalance.depositTokenFromUserMigration(_token, _amountToken, msg.sender);
588 
589 			}
590 
591 		}
592 
593 
594 
595 		emit OnFundsMigrated(msg.sender, _newBalance, now);
596 
597 	}
598 
599 	 
600 
601 	function depositFromUserMigration(address _account) public payable {
602 
603 		require(_account != address(0));
604 
605 		require(msg.value > 0);
606 
607 		account2Token2Balance[_account][0] = account2Token2Balance[_account][0].add(msg.value);
608 
609 	}
610 
611   
612 
613 	function depositTokenFromUserMigration(address _token, uint _amount, address _account) public {
614 
615 		require(_token != address(0));
616 
617 		require(_account != address(0));
618 
619 		require(_amount > 0);
620 
621 		depositingTokenFlag = true;
622 
623 		require(IToken(_token).transferFrom(msg.sender, this, _amount));
624 
625 		depositingTokenFlag = false;
626 
627 		account2Token2Balance[_account][_token] = account2Token2Balance[_account][_token].add(_amount);
628 
629 	}
630 
631 	
632 
633 	function getRemainBuyBLKAmount() public constant returns (uint256) {
634 
635 		return amountEthToBuyBLK;
636 
637 	}
638 
639 
640 
641 	function sellBLK(uint256 _amountBLK) public {
642 
643 		require(_amountBLK> 0);
644 
645 		account2Token2Balance[msg.sender][contractBLK]= account2Token2Balance[msg.sender][contractBLK].sub(_amountBLK);
646 
647 		uint256 _amountEth= _amountBLK.mul(priceBLK).div(1 ether);
648 
649 		amountEthToBuyBLK= amountEthToBuyBLK.sub(_amountEth);
650 
651 		account2Token2Balance[msg.sender][address(0)]= account2Token2Balance[msg.sender][address(0)].add(_amountEth);
652 
653 
654 
655 		IBiLinkToken(contractBLK).burn(_amountBLK);
656 
657 
658 
659 		emit OnSellBLK(msg.sender, _amountBLK, now);
660 
661 	}
662 
663 }