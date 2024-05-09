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
45 contract Balance is Ownable {
46 
47 	using SafeMath for uint256;
48 
49      
50 
51 	mapping (address => mapping (address => uint256)) public account2Token2Balance;
52 
53 	mapping (address => uint256) public token2ProfitShare;
54 
55 	mapping (address => address) public token2AssuranceAccount;
56 
57 	mapping (address => uint256) public assuranceAccount2LastDepositTime;
58 
59 
60 
61 	address public contractBLK;
62 
63 	address public contractBiLinkLoan;
64 
65 	address public contractLoanLogic;
66 
67 	address public contractBiLinkExchange;
68 
69 	address public contractMarketData;
70 
71 	
72 
73 	address public accountCost;
74 
75 	uint256 public ratioProfit2Cost;//percentage
76 
77 	uint256 public ratioProfit2BuyBLK;//percentage
78 
79 	uint256 public ETH_BLK_MULTIPLIER= 1000;
80 
81 	uint256 public amountEthToBuyBLK;
82 
83 	uint256 public priceBLK;//eth
84 
85 
86 
87 	bool public isLegacy;//if true, not allow new trade,new deposit
88 
89 	bool private depositingTokenFlag;
90 
91 
92 
93 	event OnShareProfit(address account, address token, uint256 amount, uint256 timestamp );
94 
95 	event OnSellBLK(address account, uint256 amount, uint256 timestamp );
96 
97 	
98 
99 	event OnDeposit(address token, address account, uint256 amount, uint256 balance, uint256 timestamp);
100 
101 	event OnWithdraw(address token, address account, uint256 amount, uint256 balance, uint256 timestamp);
102 
103 	event OnFundsMigrated(address account, address newContract, uint256 timestamp);
104 
105 
106 
107     constructor (address _owner, address _contractBLK, address _contractBiLinkLoan, address _contractLoanLogic, address _contractBiLinkExchange, address _contractMarketData
108 
109 		, address _accountCost, uint256 _ratioProfit2Cost, uint256 _ratioProfit2BuyBLK, uint256 _priceBLK) public Ownable(_owner) {
110 
111 		contractBLK= _contractBLK;
112 
113 		contractBiLinkExchange= _contractBiLinkExchange;
114 
115 		contractBiLinkLoan= _contractBiLinkLoan;
116 
117 		contractLoanLogic= _contractLoanLogic;
118 
119 		contractMarketData= _contractMarketData;
120 
121 		accountCost= _accountCost;
122 
123 		ratioProfit2Cost= _ratioProfit2Cost;
124 
125 		ratioProfit2BuyBLK= _ratioProfit2BuyBLK;
126 
127 		priceBLK= _priceBLK;
128 
129 	}
130 
131 
132 
133 	function setThisContractAsLegacy() public onlyOwner {
134 
135 		isLegacy= true;
136 
137 	}
138 
139 
140 
141 	function setRatioProfit2Cost(uint256 _ratio) public onlyOwner {
142 
143 		require(_ratio <= 20);
144 
145 		ratioProfit2Cost= _ratio;
146 
147 	}
148 
149 
150 
151 	function setRatioProfit2BuyBLK(uint256 _ratio) public onlyOwner {
152 
153 		ratioProfit2BuyBLK= _ratio;
154 
155 	}
156 
157 
158 
159 	function setTokenAssuranceAccount(address _token, address _account) public onlyOwner {
160 
161 		require(token2AssuranceAccount[_token]== address(0));
162 
163 
164 
165 		token2AssuranceAccount[_token]= _account;
166 
167 	}
168 
169 
170 
171 	function getTokenAssuranceAccount(address _token) public constant returns (address) {
172 
173 		return token2AssuranceAccount[_token];
174 
175 	}
176 
177 
178 
179 	function getTokenAssuranceAmount(address _token) public constant returns (uint256) {
180 
181 		return account2Token2Balance[token2AssuranceAccount[_token]][_token];
182 
183 	}
184 
185 
186 
187 	function depositEther() public payable {
188 
189 		require(isLegacy== false);
190 
191 
192 
193 		account2Token2Balance[msg.sender][address(0)]= account2Token2Balance[msg.sender][address(0)].add(msg.value);
194 
195 		emit OnDeposit(0, msg.sender, msg.value, account2Token2Balance[msg.sender][0], now);
196 
197 	}
198 
199 
200 
201 	function withdrawEther(uint256 _amount) public {
202 
203 		require(account2Token2Balance[msg.sender][0] >= _amount);
204 
205 		account2Token2Balance[msg.sender][0] = account2Token2Balance[msg.sender][0].sub(_amount);
206 
207 
208 
209 		msg.sender.transfer(_amount);
210 
211 		emit OnWithdraw(0, msg.sender, _amount, account2Token2Balance[msg.sender][0], now);
212 
213 	}
214 
215 
216 
217 	function depositToken(address _token, uint256 _amount) public {
218 
219 		require(_token != address(0)&& isLegacy== false);
220 
221 		depositingTokenFlag = true;
222 
223 		require(IToken(_token).transferFrom(msg.sender, this, _amount));
224 
225 		depositingTokenFlag = false;
226 
227 
228 
229 		if(token2AssuranceAccount[_token]== msg.sender)
230 
231 			assuranceAccount2LastDepositTime[msg.sender]= now;
232 
233 		 
234 
235 		account2Token2Balance[msg.sender][_token] = account2Token2Balance[msg.sender][_token].add(_amount);
236 
237 		emit OnDeposit(_token, msg.sender, _amount, account2Token2Balance[msg.sender][_token], now);
238 
239 	}
240 
241 
242 
243 	function withdrawToken(address _token, uint256 _amount) public {
244 
245 		require(_token != address(0));
246 
247 		require(account2Token2Balance[msg.sender][_token] >= _amount);
248 
249 
250 
251 		if(token2AssuranceAccount[_token]== msg.sender) {
252 
253 			require(_amount<= account2Token2Balance[msg.sender][_token].sub(ILoanLogic(contractLoanLogic).getTotalBorrowAmount(_token)));
254 
255 			require(now.sub(assuranceAccount2LastDepositTime[msg.sender]) > 30 * 24 * 3600);
256 
257 		}
258 
259 
260 
261 		account2Token2Balance[msg.sender][_token] = account2Token2Balance[msg.sender][_token].sub(_amount);
262 
263 		require(IToken(_token).transfer(msg.sender, _amount));
264 
265 		emit OnWithdraw(_token, msg.sender, _amount, account2Token2Balance[msg.sender][_token], now);
266 
267 	}
268 
269 
270 
271 	function tokenFallback( address _sender, uint256 _amount, bytes _data) public returns (bool ok) {
272 
273 		if (depositingTokenFlag) {
274 
275 			// Transfer was initiated from depositToken(). User token balance will be updated there.
276 
277 			return true;
278 
279 		} 
280 
281 		else {
282 
283 			// Direct ECR223 Token.transfer into this contract not allowed, to keep it consistent
284 
285 			// with direct transfers of ECR20 and ETH.
286 
287 			revert();
288 
289 		}
290 
291 	}
292 
293 
294 
295 	function getBalance(address _token, address _account) public constant returns (uint256, uint256) {		
296 
297 		return (account2Token2Balance[_account][_token] , getAvailableBalance(_token, _account)); 
298 
299 	}
300 
301 
302 
303 	function getAvailableBalance(address _token, address _account) public constant returns (uint256) {		
304 
305 		return account2Token2Balance[_account][_token].sub(ILoanLogic(contractLoanLogic).getTotalPledgeAmount(_token, _account)); 
306 
307 	}
308 
309 
310 
311 	function modifyBalance(address _account, address _token, uint256 _amount, bool _addOrSub) public {
312 
313 		require(msg.sender== contractBiLinkLoan|| msg.sender== contractBiLinkExchange);
314 
315 
316 
317 		if(_addOrSub)
318 
319 			account2Token2Balance[_account][_token]= account2Token2Balance[_account][_token].add(_amount);
320 
321 		else
322 
323 			account2Token2Balance[_account][_token]= account2Token2Balance[_account][_token].sub(_amount);
324 
325 	}
326 
327 
328 
329 	function distributeEthProfit (address _profitMaker, uint256 _amount) public {
330 
331 		uint256 _amountCost= _amount.mul(ratioProfit2Cost).div(100);
332 
333 		account2Token2Balance[accountCost][address(0)]= account2Token2Balance[accountCost][address(0)].add(_amountCost);
334 
335 
336 
337 		uint256 _amountToBuyBLK= _amount.mul(ratioProfit2BuyBLK).div(100);
338 
339 		amountEthToBuyBLK= amountEthToBuyBLK.add(_amountToBuyBLK);
340 
341 
342 
343 		token2ProfitShare[address(0)]= token2ProfitShare[address(0)].add(_amount.sub(_amountCost).sub(_amountToBuyBLK));
344 
345 		
346 
347 		IBiLinkToken(contractBLK).mint(_profitMaker, _amountToBuyBLK.mul(ETH_BLK_MULTIPLIER));
348 
349 	}
350 
351 	
352 
353 	function distributeTokenProfit (address _profitMaker, address _token, uint256 _amount) public {
354 
355 		token2ProfitShare[_token]= token2ProfitShare[_token].add(_amount);
356 
357 
358 
359 		(uint256 _num, uint256 _denom)= IMarketData(contractMarketData).getTokenExchangeRatio(address(0), _token);
360 
361 		IBiLinkToken(contractBLK).mint(_profitMaker, _amount.mul(_num* 5).div(_denom* 8).mul(ETH_BLK_MULTIPLIER));
362 
363 	}
364 
365 
366 
367 	function shareProfit(address _token) public {
368 
369 		require(token2ProfitShare[_token]> 0);
370 
371 
372 
373 		uint256 _amountBLKMined= IBiLinkToken(contractBLK).totalSupply();
374 
375 
376 
377 		uint256 _amountProfit= token2ProfitShare[_token];
378 
379 		token2ProfitShare[_token]= 0;
380 
381 
382 
383 		address[] memory _accounts= IBiLinkToken(contractBLK).getCanShareProfitAccounts();
384 
385 		for(uint256 i= 0; i< _accounts.length; i++) {
386 
387 			uint256 _balance= IBiLinkToken(contractBLK).balanceOf(_accounts[i]);
388 
389 			if(_balance> 0) {
390 
391 				account2Token2Balance[_accounts[i]][_token]= account2Token2Balance[_accounts[i]][_token].add(_balance.mul(_amountProfit).div(_amountBLKMined));
392 
393 				
394 
395 				emit OnShareProfit(_accounts[i], _token, _amountProfit, now);
396 
397 			}
398 
399 		}
400 
401 	}
402 
403 
404 
405 	function migrateFund(address _newContract, address[] _tokens) public {
406 
407 		require(_newContract != address(0)&& ILoanLogic(contractLoanLogic).hasUnpaidLoan(msg.sender)== false);
408 
409     
410 
411 		Balance _newBalance= Balance(_newContract);
412 
413 
414 
415 		uint256 _amountEther = account2Token2Balance[msg.sender][0];
416 
417 		if (_amountEther > 0) {
418 
419 			account2Token2Balance[msg.sender][0] = 0;
420 
421 			_newBalance.depositFromUserMigration.value(_amountEther)(msg.sender);
422 
423 		}
424 
425 
426 
427 		for (uint16 n = 0; n < _tokens.length; n++) {
428 
429 			address _token = _tokens[n];
430 
431 			require(_token != address(0)); // Ether is handled above.
432 
433 			uint256 _amountToken = account2Token2Balance[msg.sender][_token];
434 
435       
436 
437 			if (_amountToken != 0) {      
438 
439 				require(IToken(_token).approve(_newBalance, _amountToken));
440 
441 				account2Token2Balance[msg.sender][_token] = 0;
442 
443 				_newBalance.depositTokenFromUserMigration(_token, _amountToken, msg.sender);
444 
445 			}
446 
447 		}
448 
449 
450 
451 		emit OnFundsMigrated(msg.sender, _newBalance, now);
452 
453 	}
454 
455 	 
456 
457 	function depositFromUserMigration(address _account) public payable {
458 
459 		require(_account != address(0));
460 
461 		require(msg.value > 0);
462 
463 		account2Token2Balance[_account][0] = account2Token2Balance[_account][0].add(msg.value);
464 
465 	}
466 
467   
468 
469 	function depositTokenFromUserMigration(address _token, uint _amount, address _account) public {
470 
471 		require(_token != address(0));
472 
473 		require(_account != address(0));
474 
475 		require(_amount > 0);
476 
477 		depositingTokenFlag = true;
478 
479 		require(IToken(_token).transferFrom(msg.sender, this, _amount));
480 
481 		depositingTokenFlag = false;
482 
483 		account2Token2Balance[_account][_token] = account2Token2Balance[_account][_token].add(_amount);
484 
485 	}
486 
487 	
488 
489 	function getRemainBuyBLKAmount() public constant returns (uint256) {
490 
491 		return amountEthToBuyBLK;
492 
493 	}
494 
495 
496 
497 	function sellBLK(uint256 _amountBLK) public {
498 
499 		require(_amountBLK> 0);
500 
501 		account2Token2Balance[msg.sender][contractBLK]= account2Token2Balance[msg.sender][contractBLK].sub(_amountBLK);
502 
503 		uint256 _amountEth= _amountBLK.mul(priceBLK).div(1 ether);
504 
505 		amountEthToBuyBLK= amountEthToBuyBLK.sub(_amountEth);
506 
507 		account2Token2Balance[msg.sender][address(0)]= account2Token2Balance[msg.sender][address(0)].add(_amountEth);
508 
509 
510 
511 		IBiLinkToken(contractBLK).burn(_amountBLK);
512 
513 
514 
515 		emit OnSellBLK(msg.sender, _amountBLK, now);
516 
517 	}
518 
519 }
520 
521 contract ILoanLogic {
522 
523 	function getTotalPledgeAmount(address token, address account) public constant returns (uint256);
524 
525 	function hasUnpaidLoan(address account) public constant returns (bool);
526 
527 	function getTotalBorrowAmount(address _token) public constant returns (uint256);
528 
529 }
530 
531 contract IMarketData {
532 
533 	function getTokenExchangeRatio(address _tokenNum, address _tokenDenom) public returns (uint256 num, uint256 denom);
534 
535 }
536 
537 contract IToken {
538 
539 
540 
541   /// @notice send `_value` token to `_to` from `msg.sender`
542 
543   /// @param _to The address of the recipient
544 
545   /// @param _value The amount of token to be transferred
546 
547   /// @return Whether the transfer was successful or not
548 
549   function transfer(address _to, uint256 _value) public returns (bool success);
550 
551 
552 
553   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
554 
555   /// @param _from The address of the sender
556 
557   /// @param _to The address of the recipient
558 
559   /// @param _value The amount of token to be transferred
560 
561   /// @return Whether the transfer was successful or not
562 
563   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
564 
565 
566 
567   function approve(address _spender, uint256 _value) public returns (bool success);
568 
569 
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