1 pragma solidity ^0.4.13;
2 
3 contract IMarketData {
4 
5 	function getTokenExchangeRatio(address _tokenNum, address _tokenDenom) public returns (uint256 num, uint256 denom);
6 
7 }
8 
9 contract IToken {
10 
11 
12 
13   /// @notice send `_value` token to `_to` from `msg.sender`
14 
15   /// @param _to The address of the recipient
16 
17   /// @param _value The amount of token to be transferred
18 
19   /// @return Whether the transfer was successful or not
20 
21   function transfer(address _to, uint256 _value) public returns (bool success);
22 
23 
24 
25   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
26 
27   /// @param _from The address of the sender
28 
29   /// @param _to The address of the recipient
30 
31   /// @param _value The amount of token to be transferred
32 
33   /// @return Whether the transfer was successful or not
34 
35   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
36 
37 
38 
39   function approve(address _spender, uint256 _value) public returns (bool success);
40 
41 
42 
43 }
44 
45 contract ILoanLogic {
46 
47 	function getTotalPledgeAmount(address token, address account) public constant returns (uint256);
48 
49 	function hasUnpaidLoan(address account) public constant returns (bool);
50 
51 	function getTotalBorrowAmount(address _token) public constant returns (uint256);
52 
53 }
54 
55 contract Ownable 
56 
57 {
58 
59   address public owner;
60 
61  
62 
63   constructor(address _owner) public 
64 
65   {
66 
67     owner = _owner;
68 
69   }
70 
71  
72 
73   modifier onlyOwner() 
74 
75   {
76 
77     require(msg.sender == owner);
78 
79     _;
80 
81   }
82 
83  
84 
85   function transferOwnership(address newOwner) onlyOwner 
86 
87   {
88 
89     require(newOwner != address(0));      
90 
91     owner = newOwner;
92 
93   }
94 
95 }
96 
97 contract Balance is Ownable {
98 
99 	using SafeMath for uint256;
100 
101      
102 
103 	mapping (address => mapping (address => uint256)) public account2Token2Balance;
104 
105 	mapping (address => uint256) public token2ProfitShare;
106 
107 	mapping (address => address) public token2AssuranceAccount;
108 
109 	mapping (address => uint256) public assuranceAccount2LastDepositTime;
110 
111 
112 
113 	address public contractBLK;
114 
115 	address public contractBiLinkLoan;
116 
117 	address public contractLoanLogic;
118 
119 	address public contractBiLinkExchange;
120 
121 	address public contractMarketData;
122 
123 	
124 
125 	address public accountCost;
126 
127 	uint256 public ratioProfit2Cost;//percentage
128 
129 	uint256 public ratioProfit2BuyBLK;//percentage
130 
131 	uint256 public ETH_BLK_MULTIPLIER= 1000;
132 
133 	uint256 public amountEthToBuyBLK;
134 
135 	uint256 public priceBLK;//eth
136 
137 
138 
139 	bool public isLegacy;//if true, not allow new trade,new deposit
140 
141 	bool private depositingTokenFlag;
142 
143 
144 
145 	event OnShareProfit(address token, uint256 amount, uint256 timestamp );
146 
147 	event OnSellBLK(address account, uint256 amount, uint256 timestamp );
148 
149 	
150 
151 	event OnDeposit(address token, address account, uint256 amount, uint256 balance, uint256 timestamp);
152 
153 	event OnWithdraw(address token, address account, uint256 amount, uint256 balance, uint256 timestamp);
154 
155 	event OnFundsMigrated(address account, address newContract, uint256 timestamp);
156 
157 
158 
159     constructor (address _owner, address _contractBLK, address _contractBiLinkLoan, address _contractLoanLogic, address _contractBiLinkExchange, address _contractMarketData
160 
161 		, address _accountCost, uint256 _ratioProfit2Cost, uint256 _ratioProfit2BuyBLK, uint256 _priceBLK) public Ownable(_owner) {
162 
163 		contractBLK= _contractBLK;
164 
165 		contractBiLinkExchange= _contractBiLinkExchange;
166 
167 		contractBiLinkLoan= _contractBiLinkLoan;
168 
169 		contractLoanLogic= _contractLoanLogic;
170 
171 		contractMarketData= _contractMarketData;
172 
173 		accountCost= _accountCost;
174 
175 		ratioProfit2Cost= _ratioProfit2Cost;
176 
177 		ratioProfit2BuyBLK= _ratioProfit2BuyBLK;
178 
179 		priceBLK= _priceBLK;
180 
181 	}
182 
183 
184 
185 	function setThisContractAsLegacy() public onlyOwner {
186 
187 		isLegacy= true;
188 
189 	}
190 
191 
192 
193 	function setRatioProfit2Cost(uint256 _ratio) public onlyOwner {
194 
195 		require(_ratio <= 20);
196 
197 		ratioProfit2Cost= _ratio;
198 
199 	}
200 
201 
202 
203 	function setRatioProfit2BuyBLK(uint256 _ratio) public onlyOwner {
204 
205 		ratioProfit2BuyBLK= _ratio;
206 
207 	}
208 
209 
210 
211 	function setTokenAssuranceAccount(address _token, address _account) public onlyOwner {
212 
213 		require(token2AssuranceAccount[_token]== address(0));
214 
215 
216 
217 		token2AssuranceAccount[_token]= _account;
218 
219 	}
220 
221 
222 
223 	function getTokenAssuranceAccount(address _token) public constant returns (address) {
224 
225 		return token2AssuranceAccount[_token];
226 
227 	}
228 
229 
230 
231 	function getTokenAssuranceAmount(address _token) public constant returns (uint256) {
232 
233 		return account2Token2Balance[token2AssuranceAccount[_token]][_token];
234 
235 	}
236 
237 
238 
239 	function depositEther() public payable {
240 
241 		require(isLegacy== false);
242 
243 
244 
245 		account2Token2Balance[msg.sender][address(0)]= account2Token2Balance[msg.sender][address(0)].add(msg.value);
246 
247 		emit OnDeposit(0, msg.sender, msg.value, account2Token2Balance[msg.sender][0], now);
248 
249 	}
250 
251 
252 
253 	function withdrawEther(uint256 _amount) public {
254 
255 		require(account2Token2Balance[msg.sender][0] >= _amount);
256 
257 		account2Token2Balance[msg.sender][0] = account2Token2Balance[msg.sender][0].sub(_amount);
258 
259 
260 
261 		msg.sender.transfer(_amount);
262 
263 		emit OnWithdraw(0, msg.sender, _amount, account2Token2Balance[msg.sender][0], now);
264 
265 	}
266 
267 
268 
269 	function depositToken(address _token, uint256 _amount) public {
270 
271 		require(_token != address(0)&& isLegacy== false);
272 
273 		depositingTokenFlag = true;
274 
275 		require(IToken(_token).transferFrom(msg.sender, this, _amount));
276 
277 		depositingTokenFlag = false;
278 
279 
280 
281 		if(token2AssuranceAccount[_token]== msg.sender)
282 
283 			assuranceAccount2LastDepositTime[msg.sender]= now;
284 
285 		 
286 
287 		account2Token2Balance[msg.sender][_token] = account2Token2Balance[msg.sender][_token].add(_amount);
288 
289 		emit OnDeposit(_token, msg.sender, _amount, account2Token2Balance[msg.sender][_token], now);
290 
291 	}
292 
293 
294 
295 	function withdrawToken(address _token, uint256 _amount) public {
296 
297 		require(_token != address(0));
298 
299 		require(account2Token2Balance[msg.sender][_token] >= _amount);
300 
301 
302 
303 		if(token2AssuranceAccount[_token]== msg.sender) {
304 
305 			require(_amount<= account2Token2Balance[msg.sender][_token].sub(ILoanLogic(contractLoanLogic).getTotalBorrowAmount(_token)));
306 
307 			require(now.sub(assuranceAccount2LastDepositTime[msg.sender]) > 30 * 24 * 3600);
308 
309 		}
310 
311 
312 
313 		account2Token2Balance[msg.sender][_token] = account2Token2Balance[msg.sender][_token].sub(_amount);
314 
315 		require(IToken(_token).transfer(msg.sender, _amount));
316 
317 		emit OnWithdraw(_token, msg.sender, _amount, account2Token2Balance[msg.sender][_token], now);
318 
319 	}
320 
321 
322 
323 	function tokenFallback( address _sender, uint256 _amount, bytes _data) public returns (bool ok) {
324 
325 		if (depositingTokenFlag) {
326 
327 			// Transfer was initiated from depositToken(). User token balance will be updated there.
328 
329 			return true;
330 
331 		} 
332 
333 		else {
334 
335 			// Direct ECR223 Token.transfer into this contract not allowed, to keep it consistent
336 
337 			// with direct transfers of ECR20 and ETH.
338 
339 			revert();
340 
341 		}
342 
343 	}
344 
345 
346 
347 	function getBalance(address _token, address _account) public constant returns (uint256, uint256) {		
348 
349 		return (account2Token2Balance[_account][_token] , getAvailableBalance(_token, _account)); 
350 
351 	}
352 
353 
354 
355 	function getAvailableBalance(address _token, address _account) public constant returns (uint256) {		
356 
357 		return account2Token2Balance[_account][_token].sub(ILoanLogic(contractLoanLogic).getTotalPledgeAmount(_token, _account)); 
358 
359 	}
360 
361 
362 
363 	function modifyBalance(address _account, address _token, uint256 _amount, bool _addOrSub) public {
364 
365 		require(msg.sender== contractBiLinkLoan|| msg.sender== contractBiLinkExchange);
366 
367 
368 
369 		if(_addOrSub)
370 
371 			account2Token2Balance[_account][_token]= account2Token2Balance[_account][_token].add(_amount);
372 
373 		else
374 
375 			account2Token2Balance[_account][_token]= account2Token2Balance[_account][_token].sub(_amount);
376 
377 	}
378 
379 
380 
381 	function distributeEthProfit (address _profitMaker, uint256 _amount) public {
382 
383 		uint256 _amountCost= _amount.mul(ratioProfit2Cost).div(100);
384 
385 		account2Token2Balance[accountCost][address(0)]= account2Token2Balance[accountCost][address(0)].add(_amountCost);
386 
387 
388 
389 		uint256 _amountToBuyBLK= _amount.mul(ratioProfit2BuyBLK).div(100);
390 
391 		amountEthToBuyBLK= amountEthToBuyBLK.add(_amountToBuyBLK);
392 
393 
394 
395 		token2ProfitShare[address(0)]= token2ProfitShare[address(0)].add(_amount.sub(_amountCost).sub(_amountToBuyBLK));
396 
397 		
398 
399 		IBiLinkToken(contractBLK).mint(_profitMaker, _amountToBuyBLK.mul(ETH_BLK_MULTIPLIER));
400 
401 	}
402 
403 	
404 
405 	function distributeTokenProfit (address _profitMaker, address _token, uint256 _amount) public {
406 
407 		token2ProfitShare[_token]= token2ProfitShare[_token].add(_amount);
408 
409 
410 
411 		(uint256 _num, uint256 _denom)= IMarketData(contractMarketData).getTokenExchangeRatio(address(0), _token);
412 
413 		IBiLinkToken(contractBLK).mint(_profitMaker, _amount.mul(_num* 5).div(_denom* 8).mul(ETH_BLK_MULTIPLIER));
414 
415 	}
416 
417 
418 
419 	function shareProfit(address _token) public {
420 
421 		require(token2ProfitShare[_token]> 0);
422 
423 
424 
425 		uint256 _amountBLKMined= IBiLinkToken(contractBLK).totalSupply();
426 
427 		uint256 _amountEachBLKShare= token2ProfitShare[_token].div(_amountBLKMined);
428 
429 		require(_amountEachBLKShare> 0);
430 
431 
432 
433 		token2ProfitShare[_token]= token2ProfitShare[_token].sub(_amountBLKMined.mul(_amountEachBLKShare));
434 
435 
436 
437 		address[] memory _accounts= IBiLinkToken(contractBLK).getCanShareProfitAccounts();
438 
439 		for(uint256 i= 0; i< _accounts.length; i++) {
440 
441 			uint256 _balance= IBiLinkToken(contractBLK).balanceOf(_accounts[i]);
442 
443 			if(_balance> 0)
444 
445 				require(IToken(_token).transfer(_accounts[i], _balance.mul(_amountEachBLKShare)));
446 
447 		}
448 
449 
450 
451 		emit OnShareProfit(_token, _amountBLKMined.mul(_amountEachBLKShare), now);
452 
453 	}
454 
455 
456 
457 	function migrateFund(address _newContract, address[] _tokens) public {
458 
459 		require(_newContract != address(0)&& ILoanLogic(contractLoanLogic).hasUnpaidLoan(msg.sender)== false);
460 
461     
462 
463 		Balance _newBalance= Balance(_newContract);
464 
465 
466 
467 		uint256 _amountEther = account2Token2Balance[msg.sender][0];
468 
469 		if (_amountEther > 0) {
470 
471 			account2Token2Balance[msg.sender][0] = 0;
472 
473 			_newBalance.depositFromUserMigration.value(_amountEther)(msg.sender);
474 
475 		}
476 
477 
478 
479 		for (uint16 n = 0; n < _tokens.length; n++) {
480 
481 			address _token = _tokens[n];
482 
483 			require(_token != address(0)); // Ether is handled above.
484 
485 			uint256 _amountToken = account2Token2Balance[msg.sender][_token];
486 
487       
488 
489 			if (_amountToken != 0) {      
490 
491 				require(IToken(_token).approve(_newBalance, _amountToken));
492 
493 				account2Token2Balance[msg.sender][_token] = 0;
494 
495 				_newBalance.depositTokenFromUserMigration(_token, _amountToken, msg.sender);
496 
497 			}
498 
499 		}
500 
501 
502 
503 		emit OnFundsMigrated(msg.sender, _newBalance, now);
504 
505 	}
506 
507 	 
508 
509 	function depositFromUserMigration(address _account) public payable {
510 
511 		require(_account != address(0));
512 
513 		require(msg.value > 0);
514 
515 		account2Token2Balance[_account][0] = account2Token2Balance[_account][0].add(msg.value);
516 
517 	}
518 
519   
520 
521 	function depositTokenFromUserMigration(address _token, uint _amount, address _account) public {
522 
523 		require(_token != address(0));
524 
525 		require(_account != address(0));
526 
527 		require(_amount > 0);
528 
529 		depositingTokenFlag = true;
530 
531 		require(IToken(_token).transferFrom(msg.sender, this, _amount));
532 
533 		depositingTokenFlag = false;
534 
535 		account2Token2Balance[_account][_token] = account2Token2Balance[_account][_token].add(_amount);
536 
537 	}
538 
539 	
540 
541 	function getRemainBuyBLKAmount() public constant returns (uint256) {
542 
543 		return amountEthToBuyBLK;
544 
545 	}
546 
547 
548 
549 	function sellBLK(uint256 _amountBLK) public {
550 
551 		require(_amountBLK> 0);
552 
553 		account2Token2Balance[msg.sender][contractBLK]= account2Token2Balance[msg.sender][contractBLK].sub(_amountBLK);
554 
555 		uint256 _amountEth= _amountBLK.mul(priceBLK).div(1 ether);
556 
557 		amountEthToBuyBLK= amountEthToBuyBLK.sub(_amountEth);
558 
559 		account2Token2Balance[msg.sender][address(0)]= account2Token2Balance[msg.sender][address(0)].add(_amountEth);
560 
561 
562 
563 		IBiLinkToken(contractBLK).burn(_amountBLK);
564 
565 
566 
567 		emit OnSellBLK(msg.sender, _amountBLK, now);
568 
569 	}
570 
571 }
572 
573 contract IBiLinkToken is IToken {
574 
575 	function getCanShareProfitAccounts() public constant returns (address[]);
576 
577 	function totalSupply() public view returns (uint256);
578 
579 	function balanceOf(address _account) public view returns (uint256);
580 
581 	function mint(address _to, uint256 _amount) public returns (bool);
582 
583 	function burn(uint256 amount) public;
584 
585 }
586 
587 library SafeMath {
588 
589 
590 
591   /**
592 
593   * @dev Multiplies two numbers, throws on overflow.
594 
595   */
596 
597   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
598 
599     if (a == 0) {
600 
601       return 0;
602 
603     }
604 
605     uint256 c = a * b;
606 
607     require(c / a == b);
608 
609     return c;
610 
611   }
612 
613 
614 
615   /**
616 
617   * @dev Integer division of two numbers, truncating the quotient.
618 
619   */
620 
621   function div(uint256 a, uint256 b) internal pure returns (uint256) {
622 
623     require(b > 0); // Solidity automatically throws when dividing by 0
624 
625     uint256 c = a / b;
626 
627     return c;
628 
629   }
630 
631 
632 
633   /**
634 
635   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
636 
637   */
638 
639   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
640 
641     require(b <= a);
642 
643     return a - b;
644 
645   }
646 
647 
648 
649   /**
650 
651   * @dev Adds two numbers, throws on overflow.
652 
653   */
654 
655   function add(uint256 a, uint256 b) internal pure returns (uint256) {
656 
657     uint256 c = a + b;
658 
659     require(c >= a);
660 
661     return c;
662 
663   }
664 
665 }