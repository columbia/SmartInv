1 pragma solidity ^0.4.24;
2 
3 
4 /*
5                                                                                                              
6 
7 ███████╗██╗   ██╗██████╗ ███████╗██████╗                                    
8 ██╔════╝██║   ██║██╔══██╗██╔════╝██╔══██╗                                   
9 ███████╗██║   ██║██████╔╝█████╗  ██████╔╝                                   
10 ╚════██║██║   ██║██╔═══╝ ██╔══╝  ██╔══██╗                                   
11 ███████║╚██████╔╝██║     ███████╗██║  ██║                                   
12 ╚══════╝ ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═╝                                   
13                                                                             
14      ██████╗ ██████╗ ██╗   ██╗███╗   ██╗████████╗██████╗ ██╗███████╗███████╗
15     ██╔════╝██╔═══██╗██║   ██║████╗  ██║╚══██╔══╝██╔══██╗██║██╔════╝██╔════╝
16     ██║     ██║   ██║██║   ██║██╔██╗ ██║   ██║   ██████╔╝██║█████╗  ███████╗
17     ██║     ██║   ██║██║   ██║██║╚██╗██║   ██║   ██╔══██╗██║██╔══╝  ╚════██║
18     ╚██████╗╚██████╔╝╚██████╔╝██║ ╚████║   ██║   ██║  ██║██║███████╗███████║
19      ╚═════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚═╝╚══════╝╚══════╝
20                                                                            
21 
22 © 2018 SuperCountries
23 
24 所有权 - 4CE434B6058EC7C24889EC2512734B5DBA26E39891C09DF50C3CE3191CE9C51E
25 
26 Xuxuxu - LB - Xufo
27 																										   
28 */
29 
30 
31 
32 library SafeMath {
33 
34   /**
35   * @dev Multiplies two numbers, throws on overflow.
36   */
37   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38     if (a == 0) {
39       return 0;
40     }
41     uint256 c = a * b;
42     assert(c / a == b);
43     return c;
44   }
45 
46   /**
47   * @dev Integer division of two numbers, truncating the quotient.
48   */
49   function div(uint256 a, uint256 b) internal pure returns (uint256) {
50     // assert(b > 0); // Solidity automatically throws when dividing by 0
51     uint256 c = a / b;
52     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
53     return c;
54   }
55 
56   /**
57   * @dev subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
58   */
59   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60     assert(b <= a);
61     return a - b;
62   }
63 
64   /**
65   * @dev Adds two numbers, throws on overflow.
66   */
67   function add(uint256 a, uint256 b) internal pure returns (uint256) {
68     uint256 c = a + b;
69     assert(c >= a);
70     return c;
71   }
72 }
73 
74 
75 
76 
77 
78 
79 contract SuperCountriesEth {
80   using SafeMath for uint256;
81 
82  
83 ////////////////////////////
84 /// 	CONSTRUCTOR		 ///	
85 ////////////////////////////
86    
87 	constructor () public {
88     owner = msg.sender;
89 	}
90 	
91 	address public owner;  
92 
93   
94   /**
95    * @dev Throws if called by any account other than the owner.
96    */
97 	modifier onlyOwner() {
98 		require(owner == msg.sender);
99 		_;
100 	}
101 
102 
103   /**
104    * @dev Allows the current owner to transfer control of the contract to a newOwner.
105    * @param newOwner The address to transfer ownership to.
106    */
107 	function transferOwnership(address newOwner) public onlyOwner {
108 		require(newOwner != address(0));
109 		emit OwnershipTransferred(owner, newOwner);
110 		owner = newOwner;
111 	}
112 
113 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
114 
115  
116  
117 
118 
119 ////////////////////////
120 /// 	EVENTS		 ///	
121 ////////////////////////
122   
123   event Bought (uint256 indexed _itemId, address indexed _owner, uint256 _price);
124   event Sold (uint256 indexed _itemId, address indexed _owner, uint256 _price);
125   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
126   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
127   
128   event SetReferrerEvent(address indexed referral, address indexed referrer);
129   event PayReferrerEvent(address indexed oldOwner, address indexed referrer1, address indexed referrer2, uint256 referralPart);
130   
131   event BonusConstant(uint256 bonusToDispatch_, uint256 bonusDispatched_, uint256 notYetDispatched_, uint256 indexed _itemSoldId_, uint256 kBonus, uint256 indexed countryScore);
132   event BonusDispatch(uint256 bonusToGet_, uint256 indexed playerScoreForThisCountry_, address indexed player_, uint256 pendingBalanceTotal_, uint256 indexed _itemSoldId);
133   event DivsDispatch(uint256 dividendsCut_, uint256 dividendsScore, uint256 indexed _itemId, uint256 price, uint256 worldScore_);
134   event newRichest(address indexed richest_, uint256 richestScore_, uint256 indexed blocktimestamp_, uint256 indexed blocknumber_);
135   
136   event Withdrawal(address indexed playerAddress, uint256 indexed ethereumWithdrawn, uint256 indexed potVersion_);
137   event ConfirmWithdraw(address indexed playerAddress, uint256 refbonus_, uint256 divs_, uint256 totalPending_, uint256 playerSc_, uint256 _handicap_);
138   event ConfirmPotWithdraw(uint256 contractBalance, address indexed richest_, uint256 richestBalance_, address indexed lastBuyer_, uint256 lastBalance_, uint256 indexed potVersion);
139   event PotWithdrawConstant(uint256 indexed blocktimestamp_, uint256 indexed timestamplimit_, uint256 dividendsScore_, uint256 indexed potVersion, uint256 lastWithdrawPotVersion_);
140   event WithdrawOwner(uint256 indexed potVersion, uint256 indexed lastWithdrawPotVersion_, uint256 indexed balance_);
141 
142  
143  
144 
145 
146 ///////////////////////////////////////////
147 /// 	VARIABLES, MAPPINGS, STRUCTS 	///	
148 ///////////////////////////////////////////
149   
150   bool private erc721Enabled = false;
151 
152   /// Price increase limits
153   uint256 private increaseLimit1 = 0.04 ether;
154   uint256 private increaseLimit2 = 0.6 ether;
155   uint256 private increaseLimit3 = 2.5 ether;
156   uint256 private increaseLimit4 = 7.0 ether;
157 
158   /// All countries
159   uint256[] private listedItems;
160   mapping (uint256 => address) private ownerOfItem;
161   mapping (uint256 => uint256) private priceOfItem;
162   mapping (uint256 => uint256) private previousPriceOfItem;
163   mapping (uint256 => address) private approvedOfItem;
164    
165   
166   /// Referrals and their referrers
167   mapping(address => address) public referrerOf;
168   
169   /// Dividends and score
170   uint256 private worldScore ; /// Worldscore = cumulated price of all owned countries + all spent ethers in this game
171   mapping (address => uint256) private playerScore; /// For each player, the sum of each owned country + the sum of all spent ethers since the beginning of the game
172   uint256 private dividendsScore ; /// Balance of dividends divided by the worldScore 
173   mapping(uint256 => mapping(address => uint256)) private pendingBalance; /// Divs from referrals, bonus and dividends calculated after the playerScore change ; if the playerScore didn't change recently, there are some pending divs that can be calculated using dividendsScore and playerScore. The first mapping (uint256) is the jackpot version to use, the value goes up after each pot distribution and the previous pendingBalance are reseted.
174   mapping(uint256 => mapping(address => uint256)) private handicap; /// a player cannot claim a % of all dividends but a % of the cumulated dividends after his join date, this is a handicap
175   mapping(uint256 => mapping(address => uint256)) private balanceToWithdraw; /// A player cannot withdraw pending divs, he must request a withdraw first (pending divs move to balanceToWithdraw) then withdraw.	
176 
177   uint256 private potVersion = 1; /// Number of jackpots
178   uint256 private lastWithdrawPotVersion = 1; /// Latest withdraw in the game (pot version)
179   address private richestBuyer ; /// current player with the highest PlayerScore
180   address private lastBuyer ; /// current latest buyer in the game
181   uint256 private timestampLimit = 1528108990; /// after this timestamp, the richestBuyer and the lastBuyer will be allowed to withdraw 1/2 of the contract balance (1/4 each)
182   
183   struct CountryStruct {
184 		address[] itemToAddressArray; /// addresses that owned the same country	 
185 		uint256 priceHistory; /// cumulated price of the country
186 		uint256 startingPrice; /// starting price of the country
187 		}
188 
189   mapping (uint256 => CountryStruct) public countryStructs;
190   
191   mapping (uint256 => mapping(address => uint256)) private itemHistory; /// Store price history (cumulated) for each address for each country
192   
193   uint256 private HUGE = 1e13;
194  
195  
196  
197 
198 
199 ////////////////////////////////
200 /// 	USEFUL MODIFIER		 ///	
201 ////////////////////////////////
202 
203 	modifier onlyRealAddress() {
204 		require(msg.sender != address(0));
205 		_;
206 	}
207 
208 
209 	
210 
211 	
212 ////////////////////////////////
213 /// 	ERC721 PRIVILEGES	 ///	
214 ////////////////////////////////
215 
216 	modifier onlyERC721() {
217 		require(erc721Enabled);
218 		_;
219 	} 
220 
221 
222   /**
223    * @dev Unlocks ERC721 behaviour, allowing for trading on third party platforms.
224    */	 
225 	function enableERC721 () onlyOwner() public {
226 		erc721Enabled = true;
227 	} 
228 
229   
230  
231 
232  
233 ///////////////////////////////////
234 ///		LISTING NEW COUNTRIES 	///
235 ///////////////////////////////////
236 	
237 	function listMultipleItems (uint256[] _itemIds, uint256 _price, address _owner) onlyOwner() external {
238 		for (uint256 i = 0; i < _itemIds.length; i++) {
239 			listItem(_itemIds[i], _price, _owner);
240 		}
241 	}
242 
243 	
244 	function listItem (uint256 _itemId, uint256 _price, address _owner) onlyOwner() public {
245 		require(_price > 0);
246 		require(priceOfItem[_itemId] == 0);
247 		require(ownerOfItem[_itemId] == address(0));
248 
249 		ownerOfItem[_itemId] = _owner;
250 		priceOfItem[_itemId] = _price;
251 		previousPriceOfItem[_itemId] = 0;
252 		listedItems.push(_itemId);
253 		newEntity(_itemId, _price);
254 	}
255 
256 	
257   /**
258    * @dev Creates new Struct for a country each time a new country is listed.
259    */	
260 	function newEntity(uint256 countryId, uint256 startPrice) private returns(bool success) {
261 		countryStructs[countryId].startingPrice = startPrice;
262 		return true;
263 	}
264 
265 	
266   /**
267    * @dev Update the Struc each time a country is sold.
268    * Push the newOwner, update the price history
269    */	
270 	function updateEntity(uint256 countryId, address newOwner, uint256 priceUpdate) internal {
271 		countryStructs[countryId].priceHistory += priceUpdate;
272 		if (itemHistory[countryId][newOwner] == 0 ){
273 			countryStructs[countryId].itemToAddressArray.push(newOwner);
274 		}
275 	  }
276  
277 
278 
279 
280  
281 ///////////////////////
282 /// CALCULATE PRICE ///
283 ///////////////////////
284 
285 	function calculateNextPrice (uint256 _price) public view returns (uint256 _nextPrice) {
286 		if (_price < increaseLimit1) {
287 			return _price.mul(200).div(95);
288 		} else if (_price < increaseLimit2) {
289 			return _price.mul(160).div(96);
290 		} else if (_price < increaseLimit3) {
291 			return _price.mul(148).div(97);
292 		} else if (_price < increaseLimit4) {
293 			return _price.mul(136).div(97);
294 		} else {
295 			return _price.mul(124).div(98);
296 		}
297 	}
298 
299 	function calculateDevCut (uint256 _price) public view returns (uint256 _devCut) {
300 		if (_price < increaseLimit1) {
301 			return _price.mul(5).div(100); // 5%
302 		} else if (_price < increaseLimit2) {
303 			return _price.mul(4).div(100); // 4%
304 		} else if (_price < increaseLimit4) {
305 			return _price.mul(3).div(100); // 3%
306 		} else {
307 			return _price.mul(2).div(100); // 2%
308 		}
309 	}
310  
311 
312 
313 
314  
315 //////////////////////////////
316 /// BALANCES & WITHDRAWALS ///
317 //////////////////////////////
318 
319 	function getBalance(address _playerAddress)
320 		public
321 		view
322 		returns(uint256 pendingRefBonus_, uint256 pendingFromScore_, uint256 totalPending_, uint256 balanceReadyToWithdraw_, uint256 playerScore_, uint256 handicap_, uint256 dividendsScore_)
323 		{
324 			uint256 refbonus = pendingBalance[potVersion][_playerAddress];
325 			uint256 playerSc = playerScore[_playerAddress];
326 			uint256 playerHandicap = handicap[potVersion][_playerAddress];
327 			uint256 divs = playerSc.mul(dividendsScore.sub(playerHandicap)).div(HUGE);
328 			uint256 totalPending = refbonus.add(divs);
329 			uint256 ready = balanceToWithdraw[potVersion][_playerAddress];
330 			return (refbonus, divs, totalPending, ready, playerSc, playerHandicap, dividendsScore);				
331 		}
332 
333 
334 		
335 	function getOldBalance(uint256 _potVersion, address _playerAddress)
336 		public
337 		view
338 		returns(uint256 oldPendingRefBonus_, uint256 oldHandicap_, uint256 oldReadyToWithdraw_)
339 		{
340 			uint256 oldRefBonus = pendingBalance[_potVersion][_playerAddress];
341 			uint256 oldPlayerHandicap = handicap[_potVersion][_playerAddress];
342 			uint256 oldReady = balanceToWithdraw[_potVersion][_playerAddress];
343 			return (oldRefBonus, oldPlayerHandicap, oldReady);				
344 		}
345 		
346 		
347 		
348   /**
349    * @dev First step to withdraw : players must confirm their pending Divs before withdrawing
350    * this function sums the pending balances (pendingDividends and the pending divs from playerScore)
351    * Then this sum moves to balanceReadyToWithdraw, the player can call the next function and withdraw divs
352    */
353 	function confirmDividends() public onlyRealAddress {
354 		require(playerScore[msg.sender] > 0);/// the player exists
355 		require (dividendsScore >= handicap[potVersion][msg.sender]);
356 		require (dividendsScore >= 0);
357 		
358 		address _playerAddress = msg.sender;
359 		uint256 playerSc = playerScore[_playerAddress];
360 		uint256 handicap_ = handicap[potVersion][_playerAddress];
361 		
362 		uint256 refbonus = pendingBalance[potVersion][_playerAddress];
363 		uint256 divs = playerSc.mul(dividendsScore.sub(handicap_)).div(HUGE);
364 		uint256 totalPending = refbonus.add(divs);	
365 						
366 		/// Reset the values
367 		pendingBalance[potVersion][_playerAddress] = 0; /// Reset the pending balance
368 		handicap[potVersion][_playerAddress] = dividendsScore;
369 		
370 		/// Now the player is ready to withdraw ///
371 		balanceToWithdraw[potVersion][_playerAddress] += totalPending;
372 		
373 		// fire event
374 		emit ConfirmWithdraw(_playerAddress, refbonus, divs, totalPending, playerSc, handicap_);
375 		
376 	}
377 
378 
379   /**
380    * @dev Second step to withdraw : after confirming divs, players can withdraw divs to their wallet
381    */	
382 	function withdraw() public onlyRealAddress {
383 		require(balanceOf(msg.sender) > 0);
384 		require(balanceToWithdraw[potVersion][msg.sender] > 0);
385 				
386 		address _playerAddress = msg.sender;
387 		
388 			if (lastWithdrawPotVersion != potVersion){
389 					lastWithdrawPotVersion = potVersion;
390 			}
391 
392         
393         /// Add referrals earnings, bonus and divs
394 		uint256 divToTransfer = balanceToWithdraw[potVersion][_playerAddress];
395 		balanceToWithdraw[potVersion][_playerAddress] = 0;
396 		
397         _playerAddress.transfer(divToTransfer);
398 		
399         /// fire event
400         emit Withdrawal(_playerAddress, divToTransfer, potVersion);
401     }
402 	
403 
404 	
405   /**
406    * @dev After 7 days without any buy, the richest user and the latest player will share the contract balance !
407    */		
408 	function confirmDividendsFromPot() public {
409 		require(richestBuyer != address(0) && lastBuyer != address(0)) ;
410 		require(address(this).balance > 100000000);	/// mini 1e8 wei
411 		require(block.timestamp > timestampLimit);
412 		
413 		uint256 confirmation_TimeStamp = timestampLimit;
414 		potVersion ++;
415 		uint256 balance = address(this).balance;
416 		uint256 balanceQuarter = balance.div(4);
417 		dividendsScore = 0; /// reset dividends
418 		updateTimestampLimit(); /// Reset the timer, if no new buys, the richest and the last buyers will be able to withdraw the left quarter in a week or so
419 		balanceToWithdraw[potVersion][richestBuyer] = balanceQuarter;
420 		balanceToWithdraw[potVersion][lastBuyer] += balanceQuarter; /// if the richest = last, dividends cumulate
421 		
422 		
423 		// fire events
424         emit ConfirmPotWithdraw(	
425 			 balance, 
426 			 richestBuyer, 
427 			 balanceToWithdraw[potVersion][richestBuyer],
428 			 lastBuyer,
429 			 balanceToWithdraw[potVersion][lastBuyer],
430 			 potVersion
431 		);
432 		
433 		emit PotWithdrawConstant(	
434 			 block.timestamp,
435 			 confirmation_TimeStamp,
436 			 dividendsScore,
437 			 potVersion,
438 			 lastWithdrawPotVersion
439 		);
440 		
441 	}
442 
443 
444 	
445   /**
446    * @dev If no new buys occur (dividendsScore = 0) and the richest and latest players don't withdraw their dividends after 3 jackpots, the game can be stuck forever
447    * Prevent from jackpot vicious circle : same dividends are shared between latest and richest users again and again
448    * If the richest and/or the latest player withdraw(s) at least once between 3 jackpots, it means the game is alive
449    * Or if contract balance drops down to 1e8 wei (that means many successful jackpots and that a current withdrawal could cost too much gas for players)
450    */	
451 	function withdrawAll() public onlyOwner {
452 		require((potVersion > lastWithdrawPotVersion.add(3) && dividendsScore == 0) || (address(this).balance < 100000001) );
453 		require (address(this).balance >0);
454 		
455 		potVersion ++;
456 		updateTimestampLimit();
457 		uint256 balance = address(this).balance;
458 		
459 		owner.transfer(balance);
460 		
461         // fire event
462         emit WithdrawOwner(potVersion, lastWithdrawPotVersion, balance);
463     } 	
464 
465 	
466 	
467 	
468 	
469 ///////////////////////////////////////
470 /// REFERRERS - Setting and payment ///   
471 ///////////////////////////////////////	
472 
473   /**
474    * @dev Get the referrer of a player.
475    * @param player The address of the player to get the referrer of.
476    */
477     function getReferrerOf(address player) public view returns (address) {
478         return referrerOf[player];
479     }
480 
481 	
482   /**
483    * @dev Set a referrer.
484    * @param newReferral The address to set the referrer for.
485    * @param referrer The address of the referrer to set.
486    * The referrer must own at least one country to keep his reflink active
487    * Referrals got with an active link are forever, even if all the referrer's countries are sold
488    */
489     function setReferrer(address newReferral, address referrer) internal {
490 		if (getReferrerOf(newReferral) == address(0x0) && newReferral != referrer && balanceOf(referrer) > 0 && playerScore[newReferral] == 0) {
491 			
492 			/// Set the referrer, if no referrer has been set yet, and the player
493 			/// and referrer are not the same address.
494 				referrerOf[newReferral] = referrer;
495         
496 			/// Emit event.
497 				emit SetReferrerEvent(newReferral, referrer);
498 		}
499     }
500 	
501 	
502 	
503 
504   /**
505    * @dev Dispatch the referrer bonus when a country is sold
506    * @param referralDivToPay which dividends percentage will be dispatched to refererrs : 0 if no referrer, 2.5% if 1 referrer, 5% if 2
507    */
508 	function payReferrer (address _oldOwner, uint256 _netProfit) internal returns (uint256 referralDivToPay) {
509 		address referrer_1 = referrerOf[_oldOwner];
510 		
511 		if (referrer_1 != 0x0) {
512 			referralDivToPay = _netProfit.mul(25).div(1000);
513 			pendingBalance[potVersion][referrer_1] += referralDivToPay;  /// 2.5% for the first referrer
514 			address referrer_2 = referrerOf[referrer_1];
515 				
516 				if (referrer_2 != 0x0) {
517 						pendingBalance[potVersion][referrer_2] += referralDivToPay;  /// 2.5% for the 2nd referrer
518 						referralDivToPay += referralDivToPay;
519 				}
520 		}
521 			
522 		emit PayReferrerEvent(_oldOwner, referrer_1, referrer_2, referralDivToPay);
523 		
524 		return referralDivToPay;
525 		
526 	}
527 	
528 	
529 	
530 
531 	
532 ///////////////////////////////////
533 /// INTERNAL FUNCTIONS WHEN BUY ///   
534 ///////////////////////////////////	
535 
536   /**
537    * @dev Dispatch dividends to former owners of a country
538    */
539 	function bonusPreviousOwner(uint256 _itemSoldId, uint256 _paidPrice, uint256 _bonusToDispatch) private {
540 		require(_bonusToDispatch < (_paidPrice.mul(5).div(100)));
541 		require(countryStructs[_itemSoldId].priceHistory > 0);
542 
543 		CountryStruct storage c = countryStructs[_itemSoldId];
544 		uint256 countryScore = c.priceHistory;
545 		uint256 kBonus = _bonusToDispatch.mul(HUGE).div(countryScore);
546 		uint256 bonusDispatched = 0;
547 		  
548 		for (uint256 i = 0; i < c.itemToAddressArray.length && bonusDispatched < _bonusToDispatch ; i++) {
549 			address listedBonusPlayer = c.itemToAddressArray[i];
550 			uint256 playerBonusScore = itemHistory[_itemSoldId][listedBonusPlayer];
551 			uint256 bonusToGet = playerBonusScore.mul(kBonus).div(HUGE);
552 				
553 				if (bonusDispatched.add(bonusToGet) <= _bonusToDispatch) {
554 					pendingBalance[potVersion][listedBonusPlayer] += bonusToGet;
555 					bonusDispatched += bonusToGet;
556 					
557 					emitInfo(bonusToGet, playerBonusScore, listedBonusPlayer, pendingBalance[potVersion][listedBonusPlayer], _itemSoldId);
558 				}
559 		}  
560 			
561 		emit BonusConstant(_bonusToDispatch, bonusDispatched, _bonusToDispatch.sub(bonusDispatched), _itemSoldId, kBonus, countryScore);
562 	}
563 
564 
565 	
566 	function emitInfo(uint256 dividendsToG_, uint256 playerSc_, address player_, uint256 divsBalance_, uint256 itemId_) private {
567 		emit BonusDispatch(dividendsToG_, playerSc_, player_, divsBalance_, itemId_);
568   
569 	}
570 
571   
572 
573   /**
574    * @dev we need to update the oldOwner and newOwner balances each time a country is sold, their handicap and playerscore will also change
575    * Worldscore and dividendscore : we don't care, it will be updated later.
576    * If accurate, set a new richest player
577    */
578 	function updateScoreAndBalance(uint256 _paidPrice, uint256 _itemId, address _oldOwner, address _newOwner) internal {	
579 		uint256 _previousPaidPrice = previousPriceOfItem[_itemId];
580 		assert (_paidPrice > _previousPaidPrice);
581 
582 		
583 		/// OLD OWNER ///
584 			uint256 scoreSubHandicap = dividendsScore.sub(handicap[potVersion][_oldOwner]);
585 			uint256 playerScore_ = playerScore[_oldOwner];
586 		
587 			/// If the old owner is the owner of this contract, we skip this part, the owner of the contract won't get dividends
588 				if (_oldOwner != owner && scoreSubHandicap >= 0 && playerScore_ > _previousPaidPrice) {
589 					pendingBalance[potVersion][_oldOwner] += playerScore_.mul(scoreSubHandicap).div(HUGE);
590 					playerScore[_oldOwner] -= _previousPaidPrice; ///for the oldOwner, the playerScore goes down the previous price
591 					handicap[potVersion][_oldOwner] = dividendsScore; /// and setting his handicap to dividendsScore after updating his balance
592 				}
593 
594 				
595 		/// NEW OWNER ///
596 			scoreSubHandicap = dividendsScore.sub(handicap[potVersion][_newOwner]); /// Rewrite the var with the newOwner values
597 			playerScore_ = playerScore[_newOwner]; /// Rewrite the var playerScore with the newOwner PlayerScore
598 				
599 			/// If new player, his playerscore = 0, handicap = 0, so the pendingBalance math = 0
600 				if (scoreSubHandicap >= 0) {
601 					pendingBalance[potVersion][_newOwner] += playerScore_.mul(scoreSubHandicap).div(HUGE);
602 					playerScore[_newOwner] += _paidPrice.mul(2); ///for the newOwner, the playerScore goes up twice the value of the purchase price
603 					handicap[potVersion][_newOwner] = dividendsScore; /// and setting his handicap to dividendsScore after updating his balance
604 				}
605 
606 				
607 		/// Change the richest user if this is the case...
608 				if (playerScore[_newOwner] > playerScore[richestBuyer]) {
609 					richestBuyer = _newOwner;
610 					
611 					emit newRichest(_newOwner, playerScore[_newOwner], block.timestamp, block.number);
612 				}		
613 
614 				
615 		/// Change the last Buyer in any case
616 			lastBuyer = _newOwner;
617 		
618 	}
619 		
620 
621 		
622 
623   /**
624    * @dev Update the worldScore
625    * After each buy, the worldscore increases : 2x current purchase price - 1x previousPrice
626    */
627 	function updateWorldScore(uint256 _countryId, uint256 _price) internal	{
628 		worldScore += _price.mul(2).sub(previousPriceOfItem[_countryId]);
629 	}
630 		
631 
632 		
633   /**
634    * @dev Update timestampLimit : the date on which the richest player and the last buyer will be able to share the contract balance (1/4 each)
635    */ 
636 	function updateTimestampLimit() internal {
637 		timestampLimit = block.timestamp.add(604800).add(potVersion.mul(28800)); /// add 7 days + (pot version * X 8hrs)
638 	}
639 
640 
641 	
642   /**
643    * @dev Refund the buyer if excess
644    */ 
645 	function excessRefund(address _newOwner, uint256 _price) internal {		
646 		uint256 excess = msg.value.sub(_price);
647 			if (excess > 0) {
648 				_newOwner.transfer(excess);
649 			}
650 	}	
651 	
652 
653 	
654 
655 
656 ///////////////////////////   
657 /// 	BUY A COUNTRY 	///
658 ///////////////////////////
659 /*
660      Buy a country directly from the contract for the calculated price
661      which ensures that the owner gets a profit.  All countries that
662      have been listed can be bought by this method. User funds are sent
663      directly to the previous owner and are never stored in the contract.
664 */
665 	
666 	function buy (uint256 _itemId, address referrerAddress) payable public onlyRealAddress {
667 		require(priceOf(_itemId) > 0);
668 		require(ownerOf(_itemId) != address(0));
669 		require(msg.value >= priceOf(_itemId));
670 		require(ownerOf(_itemId) != msg.sender);
671 		require(!isContract(msg.sender));
672 		require(msg.sender != owner);
673 		require(block.timestamp < timestampLimit || block.timestamp > timestampLimit.add(3600));
674 		
675 		
676 		address oldOwner = ownerOf(_itemId);
677 		address newOwner = msg.sender;
678 		uint256 price = priceOf(_itemId);
679 
680 		
681 		
682 	
683 	////////////////////////
684 	/// Set the referrer ///
685 	////////////////////////
686 		
687 		setReferrer(newOwner, referrerAddress);
688 		
689 	
690 
691 	
692 	///////////////////////////////////
693 	/// Update scores and timestamp ///
694 	///////////////////////////////////
695 		
696 		/// Dividends are dispatched among players accordingly to their "playerScore".
697 		/// The playerScore equals the sum of all their countries (owned now, paid price) + sum of all their previously owned countries 
698 		/// After each sell / buy, players that owned at least one country can claim dividends
699 		/// DIVS of a player = playerScore * DIVS to dispatch / worldScore
700 		/// If a player is a seller or a buyer, his playerScore will change, we need to adjust his parameters
701 		/// If a player is not a buyer / seller, his playerScore doesn't change, no need to adjust
702 			updateScoreAndBalance(price, _itemId, oldOwner, newOwner);
703 			
704 		/// worldScore change after each flip, we need to adjust
705 		/// To calculate the worldScore after a flip: add buy price x 2, subtract previous price
706 			updateWorldScore(_itemId, price);
707 		
708 		/// If 7 days with no buys, the richest player and the last buyer win the jackpot (1/2 of contract balance ; 1/4 each)
709 		/// Waiting time increases after each pot distribution
710 			updateTimestampLimit();
711 	
712 
713 
714 	
715 	///////////////////////
716 	/// Who earns what? ///
717 	///////////////////////	
718 	
719 		/// When a country flips, who earns how much?
720 		/// Devs : 2% to 5% of country price
721 		/// Seller's reward : current paidPrice - previousPrice - devsCut = net profit. The seller gets the previous Price + ca.65% of net Profit
722 		/// The referrers of the seller : % of netProfit from their referrals R+1 & R+2. If no referrers, all the referrers' cut goes to dividends to all players.
723 		/// All players, with or without a country now : dividends (% of netProfit)
724 		/// All previous owners of the flipped country : a special part of dividends called Bonus. If no previous buyer, all the bonus is also added up to dividends to all players.
725 			
726 		/// Calculate the devs cut
727 			uint256 devCut_ = calculateDevCut(price);
728 			
729 		/// Calculate the netProfit
730 			uint256 netProfit = price.sub(devCut_).sub(previousPriceOfItem[_itemId]);
731 		
732 		/// Calculate dividends cut from netProfit and what referrers left
733 			uint256 dividendsCut_ = netProfit.mul(30).div(100);
734 			
735 		/// Calculate the seller's reward
736 		/// Price sub the cuts : dev cut and 35% including referrer cut (5% max), 30% (25% if referrers) dividends (including 80% divs / 20% bonus max) and 5% (jackpot)
737 			uint256 oldOwnerReward = price.sub(devCut_).sub(netProfit.mul(35).div(100));
738 
739 		/// Calculate the referrers cut and store the referrer's cut in the referrer's pending balance ///
740 		/// Update dividend's cut : 30% max ; 27,5% if 1 referrer ; 25% if 2 referrers
741 			uint256 refCut = payReferrer(oldOwner, netProfit);
742 			dividendsCut_ -= refCut;
743 		
744 	
745 
746 	
747 	////////////////////////////////////////////////////////////
748 	///          Dispatch dividends to all players           ///
749 	/// Dispatch bonuses to previous owners of this country  ///
750 	////////////////////////////////////////////////////////////
751 		
752 		/// Dividends = 80% to all country owners (previous and current owners, no matter the country) + 20% bonus to previous owners of this country
753 		/// If no previous owners, 100% to all countries owners
754 	
755 		/// Are there previous owners for the current flipped country?
756 			if (price > countryStructs[_itemId].startingPrice && dividendsCut_ > 1000000 && worldScore > 0) {
757 				
758 				/// Yes, there are previous owners, they will get 20% of dividends of this country
759 					bonusPreviousOwner(_itemId, price, dividendsCut_.mul(20).div(100));
760 				
761 				/// So dividends for all the country owners are 100% - 20% = 80%
762 					dividendsCut_ = dividendsCut_.mul(80).div(100); 
763 			} 
764 	
765 				/// If else... nothing special to do, there are no previous owners, dividends remain 100%	
766 		
767 		/// Dispatch dividends to all country owners, no matter the country
768 		/// Note : to avoid floating numbers, we divide a constant called HUGE (1e13) by worldScore, of course we will multiply by HUGE when retrieving
769 			if (worldScore > 0) { /// worldScore must be greater than 0, the opposite is impossible and dividends are not calculated
770 				
771 				dividendsScore += HUGE.mul(dividendsCut_).div(worldScore);
772 			}
773 	
774 
775 	
776 	////////////////////////////////////////////////
777 	/// Update the price history of the newOwner ///
778 	////////////////////////////////////////////////
779 	
780 		/// The newOwner is now known as an OWNER for this country
781 		/// We'll store his cumulated buy price for this country in a mapping
782 		/// Bonus : each time a country is flipped, players that previously owned this country get bonuses proportionally to the sum of their buys	
783 			updateEntity(_itemId, newOwner, price);
784 			itemHistory[_itemId][newOwner] += price;
785 
786 	
787 
788 	
789 	////////////////////////
790 	/// Update the price ///
791 	////////////////////////
792 	
793 		/// The price of purchase becomes the "previousPrice", and the "price" is the next price 
794 			previousPriceOfItem[_itemId] = price;
795 			priceOfItem[_itemId] = nextPriceOf(_itemId);
796 	
797 
798 	
799 	/////////////////////////////////////////
800 	/// Transfer the reward to the seller ///
801 	/////////////////////////////////////////
802 
803 		/// The seller's reward is transfered automatically to his wallet
804 		/// The dev cut is transfered automatically out the contract
805 		/// The other rewards (bonus, dividends, referrer's cut) will be stored in a pending balance
806 			oldOwner.transfer(oldOwnerReward);
807 			owner.transfer(devCut_);
808 			
809 		/// Transfer the token from oldOwner to newOwner
810 			_transfer(oldOwner, newOwner, _itemId);  	
811 	
812 		/// Emit the events
813 			emit Bought(_itemId, newOwner, price);
814 			emit Sold(_itemId, oldOwner, price);	
815 		
816 	
817 
818 	
819 	///////////////////////////////////////////
820 	/// Transfer the excess to the newOwner ///
821 	///////////////////////////////////////////
822 	
823 		/// If the newOwner sent a higher price than the asked price, the excess is refunded
824 			excessRefund(newOwner, price);
825 		
826 
827 	
828 	/// Send informations
829 		emit DivsDispatch(dividendsCut_, dividendsScore, _itemId, price, worldScore);		
830 		
831 /// END OF THE BUY FUNCTION ///
832   
833 	}
834   
835  
836   
837 //////////////////////////////
838 /// Practical informations ///
839 //////////////////////////////
840 
841 	function itemHistoryOfPlayer(uint256 _itemId, address _owner) public view returns (uint256 _valueAddressOne) {
842 		return itemHistory[_itemId][_owner];
843 	}
844   
845   
846 	function implementsERC721() public view returns (bool _implements) {
847 		return erc721Enabled;
848 	}
849 
850 	
851 	function name() public pure returns (string _name) {
852 		return "SuperCountries";
853 	}
854 
855 	
856 	function symbol() public pure returns (string _symbol) {
857 		return "SUP";
858 	}
859 
860 	
861 	function totalSupply() public view returns (uint256 _totalSupply) {
862 		return listedItems.length;
863 	}
864 
865 	
866 	function balanceOf (address _owner) public view returns (uint256 _balance) {
867 		uint256 counter = 0;
868 
869 			for (uint256 i = 0; i < listedItems.length; i++) {
870 				if (ownerOf(listedItems[i]) == _owner) {
871 					counter++;
872 				}
873 			}
874 
875 		return counter;
876 	}
877 
878 
879 	function ownerOf (uint256 _itemId) public view returns (address _owner) {
880 		return ownerOfItem[_itemId];
881 	}
882 
883 	
884 	function tokensOf (address _owner) public view returns (uint256[] _tokenIds) {
885 		uint256[] memory items = new uint256[](balanceOf(_owner));
886 		uint256 itemCounter = 0;
887 			
888 			for (uint256 i = 0; i < listedItems.length; i++) {
889 				if (ownerOf(listedItems[i]) == _owner) {
890 					items[itemCounter] = listedItems[i];
891 					itemCounter += 1;
892 				}
893 			}
894 
895 		return items;
896 	}
897 
898 
899 	function tokenExists (uint256 _itemId) public view returns (bool _exists) {
900 		return priceOf(_itemId) > 0;
901 	}
902 
903 	
904 	function approvedFor(uint256 _itemId) public view returns (address _approved) {
905 		return approvedOfItem[_itemId];
906 	}
907 
908 
909 	function approve(address _to, uint256 _itemId) onlyERC721() public {
910 		require(msg.sender != _to);
911 		require(tokenExists(_itemId));
912 		require(ownerOf(_itemId) == msg.sender);
913 
914 		if (_to == 0) {
915 			if (approvedOfItem[_itemId] != 0) {
916 				delete approvedOfItem[_itemId];
917 				emit Approval(msg.sender, 0, _itemId);
918 			}
919 		}
920 		else {
921 			approvedOfItem[_itemId] = _to;
922 			emit Approval(msg.sender, _to, _itemId);
923 		}
924 	  }
925 
926 	  
927   /* Transferring a country to another owner will entitle the new owner the profits from `buy` */
928 	function transfer(address _to, uint256 _itemId) onlyERC721() public {
929 		require(msg.sender == ownerOf(_itemId));
930 		_transfer(msg.sender, _to, _itemId);
931 	}
932 
933 	
934 	function transferFrom(address _from, address _to, uint256 _itemId) onlyERC721() public {
935 		require(approvedFor(_itemId) == msg.sender);
936 		_transfer(_from, _to, _itemId);
937 	}
938 
939 	
940 	function _transfer(address _from, address _to, uint256 _itemId) internal {
941 		require(tokenExists(_itemId));
942 		require(ownerOf(_itemId) == _from);
943 		require(_to != address(0));
944 		require(_to != address(this));
945 
946 		ownerOfItem[_itemId] = _to;
947 		approvedOfItem[_itemId] = 0;
948 
949 		emit Transfer(_from, _to, _itemId);
950 	}
951 
952 
953 	
954 ///////////////////////////	
955 /// READ ONLY FUNCTIONS ///
956 ///////////////////////////
957 
958 	function gameInfo() public view returns (address richestPlayer_, address lastBuyer_, uint256 thisBalance_, uint256 lastWithdrawPotVersion_, uint256 worldScore_, uint256 potVersion_,  uint256 timestampLimit_) {
959 		
960 		return (richestBuyer, lastBuyer, address(this).balance, lastWithdrawPotVersion, worldScore, potVersion, timestampLimit);
961 	}
962 	
963 	
964 	function priceOf(uint256 _itemId) public view returns (uint256 _price) {
965 		return priceOfItem[_itemId];
966 	}
967 	
968 	
969 	function nextPriceOf(uint256 _itemId) public view returns (uint256 _nextPrice) {
970 		return calculateNextPrice(priceOf(_itemId));
971 	}
972 
973 	
974 	function allOf(uint256 _itemId) external view returns (address _owner, uint256 _price, uint256 previous_, uint256 _nextPrice) {
975 		return (ownerOf(_itemId), priceOf(_itemId), previousPriceOfItem[_itemId], nextPriceOf(_itemId));
976 	}
977 
978 
979 ///  is Contract ///
980 	function isContract(address addr) internal view returns (bool) {
981 		uint size;
982 		assembly { size := extcodesize(addr) } // solium-disable-line
983 		return size > 0;
984 	}
985 
986 
987 
988 
989 ////////////////////////
990 /// USEFUL FUNCTIONS ///
991 ////////////////////////
992 
993   /** 
994    * @dev Fallback function to accept all ether sent directly to the contract
995    * Nothing is lost, it will raise the jackpot !
996    */
997 
998     function() payable public
999     {    }
1000 
1001 
1002 }