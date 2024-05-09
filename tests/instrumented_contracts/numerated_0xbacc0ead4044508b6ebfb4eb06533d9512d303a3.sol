1 pragma solidity ^0.4.20;
2 
3 library SafeMath {
4 
5 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6 		if (a == 0) {
7 			return 0;
8 		}
9 		uint256 c = a * b;
10 		assert(c / a == b);
11 		return c;
12 	}
13 
14 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
15 		// assert(b > 0); // Solidity automatically throws when dividing by 0
16 		uint256 c = a / b;
17 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
18 		return c;
19 	}
20 
21 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22 		assert(b <= a);
23 		return a - b;
24 	}
25 
26 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
27 		uint256 c = a + b;
28 		assert(c >= a);
29 		return c;
30 	}
31 }
32 
33 contract Ownable {
34 	address public owner;
35 	address public controller;
36 	
37 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38 
39 	constructor() public {
40 		owner = msg.sender;
41 	}
42 
43 	modifier onlyOwner() {
44 		require(msg.sender == owner);
45 		_;
46 	}
47 	
48 	modifier onlyController() {
49 		require(msg.sender == controller);
50 		_;
51 	}
52 
53 	function transferOwnership(address newOwner) public onlyOwner {
54 		require(newOwner != address(0));
55 		emit OwnershipTransferred(owner, newOwner);
56 		owner = newOwner;
57 	}
58 	
59 	function setControler(address _controller) public onlyOwner {
60 		controller = _controller;
61 	}
62 }
63 
64 contract OwnableToken {
65 	address public owner;
66 	address public minter;
67 	address public burner;
68 	address public controller;
69 	
70 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71 
72 	function OwnableToken() public {
73 		owner = msg.sender;
74 	}
75 
76 	modifier onlyOwner() {
77 		require(msg.sender == owner);
78 		_;
79 	}
80 	
81 	modifier onlyMinter() {
82 		require(msg.sender == minter);
83 		_;
84 	}
85 	
86 	modifier onlyBurner() {
87 		require(msg.sender == burner);
88 		_;
89 	}
90 	modifier onlyController() {
91 		require(msg.sender == controller);
92 		_;
93 	}
94   
95 	modifier onlyPayloadSize(uint256 numwords) {                                       
96 		assert(msg.data.length == numwords * 32 + 4);
97 		_;
98 	}
99 
100 	function transferOwnership(address newOwner) public onlyOwner {
101 		require(newOwner != address(0));
102 		emit OwnershipTransferred(owner, newOwner);
103 		owner = newOwner;
104 	}
105 	
106 	function setMinter(address _minterAddress) public onlyOwner {
107 		minter = _minterAddress;
108 	}
109 	
110 	function setBurner(address _burnerAddress) public onlyOwner {
111 		burner = _burnerAddress;
112 	}
113 	
114 	function setControler(address _controller) public onlyOwner {
115 		controller = _controller;
116 	}
117 }
118 
119 contract KYCControl is OwnableToken {
120 	event KYCApproved(address _user, bool isApproved);
121 	mapping(address => bool) public KYCParticipants;
122 	
123 	function isKYCApproved(address _who) view public returns (bool _isAprroved){
124 		return KYCParticipants[_who];
125 	}
126 
127 	function approveKYC(address _userAddress) onlyController public {
128 		KYCParticipants[_userAddress] = true;
129 		emit KYCApproved(_userAddress, true);
130 	}
131 }
132 
133 contract VernamCrowdSaleToken is OwnableToken, KYCControl {
134 	using SafeMath for uint256;
135 	
136     event Transfer(address indexed from, address indexed to, uint256 value);
137     
138 	/* Public variables of the token */
139 	string public name;
140 	string public symbol;
141 	uint8 public decimals;
142 	uint256 public _totalSupply;
143 	
144 	/*Private Variables*/
145 	uint256 constant POW = 10 ** 18;
146 	uint256 _circulatingSupply;
147 	
148 	/* This creates an array with all balances */
149 	mapping (address => uint256) public balances;
150 		
151 	// This notifies clients about the amount burnt
152 	event Burn(address indexed from, uint256 value);
153 	event Mint(address indexed _participant, uint256 value);
154 
155 	/* Initializes contract with initial supply tokens to the creator of the contract */
156 	function VernamCrowdSaleToken() public {
157 		name = "Vernam Crowdsale Token";                            // Set the name for display purposes
158 		symbol = "VCT";                               				// Set the symbol for display purposes
159 		decimals = 18;                            					// Amount of decimals for display purposes
160 		_totalSupply = SafeMath.mul(1000000000, POW);     			//1 Billion Tokens with 18 Decimals
161 		_circulatingSupply = 0;
162 	}
163 	
164 	function mintToken(address _participant, uint256 _mintedAmount) public onlyMinter returns (bool _success) {
165 		require(_mintedAmount > 0);
166 		require(_circulatingSupply.add(_mintedAmount) <= _totalSupply);
167 		KYCParticipants[_participant] = false;
168 
169         balances[_participant] =  balances[_participant].add(_mintedAmount);
170         _circulatingSupply = _circulatingSupply.add(_mintedAmount);
171 		
172 		emit Transfer(0, this, _mintedAmount);
173         emit Transfer(this, _participant, _mintedAmount);
174 		emit Mint(_participant, _mintedAmount);
175 		
176 		return true;
177     }
178 	
179 	function burn(address _participant, uint256 _value) public onlyBurner returns (bool _success) {
180         require(_value > 0);
181 		require(balances[_participant] >= _value);   							// Check if the sender has enough
182 		require(isKYCApproved(_participant) == true);
183 		balances[_participant] = balances[_participant].sub(_value);            // Subtract from the sender
184 		_circulatingSupply = _circulatingSupply.sub(_value);
185         _totalSupply = _totalSupply.sub(_value);                      			// Updates totalSupply
186 		emit Transfer(_participant, 0, _value);
187         emit Burn(_participant, _value);
188         
189 		return true;
190     }
191   
192 	function totalSupply() public view returns (uint256) {
193 		return _totalSupply;
194 	}
195 	
196 	function circulatingSupply() public view returns (uint256) {
197 		return _circulatingSupply;
198 	}
199 	
200 	function balanceOf(address _owner) public view returns (uint256 balance) {
201 		return balances[_owner];
202 	}
203 }
204 
205 contract VernamCrowdSale is Ownable {
206 	using SafeMath for uint256;
207 	
208 	// After day 7 you can contribute only more than 10 ethers 
209 	uint constant TEN_ETHERS = 10 ether;
210 	// Minimum and maximum contribution amount
211 	uint constant minimumContribution = 100 finney;
212 	uint constant maximumContribution = 500 ether;
213 	
214 	// 
215 	uint constant FIRST_MONTH = 0;
216 	uint constant SECOND_MONTH = 1;
217 	uint constant THIRD_MONTH = 2;
218 	uint constant FORTH_MONTH = 3;
219 	uint constant FIFTH_MONTH = 4;
220 	uint constant SIXTH_MONTH = 5;	
221 	
222 	address public benecifiary;
223 	
224     // Check if the crowdsale is active
225 	bool public isInCrowdsale;
226 	
227 	// The start time of the crowdsale
228 	uint public startTime;
229 	// The total sold tokens
230 	uint public totalSoldTokens;
231 	
232 	// The total contributed wei
233 	uint public totalContributedWei;
234 
235     // Public parameters for all the stages
236 	uint constant public threeHotHoursDuration = 3 hours;
237 	uint constant public threeHotHoursPriceOfTokenInWei = 63751115644524 wei; //0.00006375111564452380 ETH per Token // 15686 VRN per ETH
238 		
239 	uint public threeHotHoursTokensCap; 
240 	uint public threeHotHoursCapInWei; 
241 	uint public threeHotHoursEnd;
242 
243 	uint public firstStageDuration = 8 days;
244 	uint public firstStagePriceOfTokenInWei = 85005100306018 wei;    //0.00008500510030601840 ETH per Token // 11764 VRN per ETH
245 
246 	uint public firstStageEnd;
247 	
248 	uint constant public secondStageDuration = 12 days;
249 	uint constant public secondStagePriceOfTokenInWei = 90000900009000 wei;     //0.00009000090000900010 ETH per Token // 11111 VRN per ETH
250     
251 	uint public secondStageEnd;
252 	
253 	uint constant public thirdStageDuration = 41 days;
254 	uint constant public thirdStagePriceOfTokenInWei = 106258633513973 wei;          //0.00010625863351397300 ETH per Token // 9411 VRN per ETH
255 	
256 	uint constant public thirdStageDiscountPriceOfTokenInWei = 95002850085503 wei;  //0.00009500285008550260 ETH per Token // 10526 VRN per ETH
257 	
258 	uint public thirdStageEnd;
259 	
260 	uint constant public TOKENS_HARD_CAP = 500000000000000000000000000; // 500 000 000 with 18 decimals
261 	
262 	// 18 decimals
263 	uint constant POW = 10 ** 18;
264 	
265 	// Constants for Realase Three Hot Hours
266 	uint constant public LOCK_TOKENS_DURATION = 30 days;
267 	uint public firstMonthEnd;
268 	uint public secondMonthEnd;
269 	uint public thirdMonthEnd;
270 	uint public fourthMonthEnd;
271 	uint public fifthMonthEnd;
272     
273     // Mappings
274 	mapping(address => uint) public contributedInWei;
275 	mapping(address => uint) public threeHotHoursTokens;
276 	mapping(address => mapping(uint => uint)) public getTokensBalance;
277 	mapping(address => mapping(uint => bool)) public isTokensTaken;
278 	mapping(address => bool) public isCalculated;
279 	
280 	VernamCrowdSaleToken public vernamCrowdsaleToken;
281 	
282 	// Modifiers
283     modifier afterCrowdsale() {
284         require(block.timestamp > thirdStageEnd);
285         _;
286     }
287     
288     modifier isAfterThreeHotHours {
289 	    require(block.timestamp > threeHotHoursEnd);
290 	    _;
291 	}
292 	
293     // Events
294     event CrowdsaleActivated(uint startTime, uint endTime);
295     event TokensBought(address participant, uint weiAmount, uint tokensAmount);
296     event ReleasedTokens(uint _amount);
297     event TokensClaimed(address _participant, uint tokensToGetFromWhiteList);
298     
299     /** @dev Constructor 
300       * @param _benecifiary 
301       * @param _vernamCrowdSaleTokenAddress The address of the crowdsale token.
302       * 
303       */
304 	constructor(address _benecifiary, address _vernamCrowdSaleTokenAddress) public {
305 		benecifiary = _benecifiary;
306 		vernamCrowdsaleToken = VernamCrowdSaleToken(_vernamCrowdSaleTokenAddress);
307         
308 		isInCrowdsale = false;
309 	}
310 	
311 	/** @dev Function which activates the crowdsale 
312       * Only the owner can call the function
313       * Activates the threeHotHours and the whole crowdsale
314       * Set the duration of crowdsale stages 
315       * Set the tokens and wei cap of crowdsale stages 
316       * Set the duration in which the tokens bought in threeHotHours will be locked
317       */
318 	function activateCrowdSale() public onlyOwner {
319 	    		
320 		setTimeForCrowdsalePeriods();
321 		
322 		threeHotHoursTokensCap = 100000000000000000000000000;
323 		threeHotHoursCapInWei = threeHotHoursPriceOfTokenInWei.mul((threeHotHoursTokensCap).div(POW));
324 	    
325 		timeLock();
326 		
327 		isInCrowdsale = true;
328 		
329 	    emit CrowdsaleActivated(startTime, thirdStageEnd);
330 	}
331 	
332 	/** @dev Fallback function.
333       * Provides functionality for person to buy tokens.
334       */
335 	function() public payable {
336 		buyTokens(msg.sender,msg.value);
337 	}
338 	
339 	/** @dev Buy tokens function
340       * Provides functionality for person to buy tokens.
341       * @param _participant The investor which want to buy tokens.
342       * @param _weiAmount The wei amount which the investor want to contribute.
343       * @return success Is the buy tokens function called successfully.
344       */
345 	function buyTokens(address _participant, uint _weiAmount) public payable returns(bool success) {
346 	    // Check if the crowdsale is active
347 		require(isInCrowdsale == true);
348 		// Check if the wei amount is between minimum and maximum contribution amount
349 		require(_weiAmount >= minimumContribution);
350 		require(_weiAmount <= maximumContribution);
351 		
352 		// Vaidates the purchase 
353 		// Check if the _participant address is not null and the weiAmount is not zero
354 		validatePurchase(_participant, _weiAmount);
355 
356 		uint currentLevelTokens;
357 		uint nextLevelTokens;
358 		// Returns the current and next level tokens amount
359 		(currentLevelTokens, nextLevelTokens) = calculateAndCreateTokens(_weiAmount);
360 		uint tokensAmount = currentLevelTokens.add(nextLevelTokens);
361 		
362 		// If the hard cap is reached the crowdsale is not active anymore
363 		if(totalSoldTokens.add(tokensAmount) > TOKENS_HARD_CAP) {
364 			isInCrowdsale = false;
365 			return;
366 		}
367 		
368 		// Transfer Ethers
369 		benecifiary.transfer(_weiAmount);
370 		
371 		// Stores the participant's contributed wei
372 		contributedInWei[_participant] = contributedInWei[_participant].add(_weiAmount);
373 		
374 		// If it is in threeHotHours tokens will not be minted they will be stored in mapping threeHotHoursTokens
375 		if(threeHotHoursEnd > block.timestamp) {
376 			threeHotHoursTokens[_participant] = threeHotHoursTokens[_participant].add(currentLevelTokens);
377 			isCalculated[_participant] = false;
378 			// If we overflow threeHotHours tokens cap the tokens for the next level will not be zero
379 			// So we should deactivate the threeHotHours and mint tokens
380 			if(nextLevelTokens > 0) {
381 				vernamCrowdsaleToken.mintToken(_participant, nextLevelTokens);
382 			} 
383 		} else {	
384 			vernamCrowdsaleToken.mintToken(_participant, tokensAmount);        
385 		}
386 		
387 		// Store total sold tokens amount
388 		totalSoldTokens = totalSoldTokens.add(tokensAmount);
389 		
390 		// Store total contributed wei amount
391 		totalContributedWei = totalContributedWei.add(_weiAmount);
392 		
393 		emit TokensBought(_participant, _weiAmount, tokensAmount);
394 		
395 		return true;
396 	}
397 	
398 	/** @dev Function which gets the tokens amount for current and next level.
399 	  * If we did not overflow the current level cap, the next level tokens will be zero.
400       * @return _currentLevelTokensAmount and _nextLevelTokensAmount Returns the calculated tokens for the current and next level
401       * It is called by calculateAndCreateTokens function
402       */
403 	function calculateAndCreateTokens(uint weiAmount) internal view returns (uint _currentLevelTokensAmount, uint _nextLevelTokensAmount) {
404 
405 		if(block.timestamp < threeHotHoursEnd && totalSoldTokens < threeHotHoursTokensCap) {
406 		    (_currentLevelTokensAmount, _nextLevelTokensAmount) = tokensCalculator(weiAmount, threeHotHoursPriceOfTokenInWei, firstStagePriceOfTokenInWei, threeHotHoursCapInWei);
407 			return (_currentLevelTokensAmount, _nextLevelTokensAmount);
408 		}
409 		
410 		if(block.timestamp < firstStageEnd) {
411 		    _currentLevelTokensAmount = weiAmount.div(firstStagePriceOfTokenInWei);
412 	        _currentLevelTokensAmount = _currentLevelTokensAmount.mul(POW);
413 	        
414 		    return (_currentLevelTokensAmount, 0);
415 		}
416 		
417 		if(block.timestamp < secondStageEnd) {		
418 		    _currentLevelTokensAmount = weiAmount.div(secondStagePriceOfTokenInWei);
419 	        _currentLevelTokensAmount = _currentLevelTokensAmount.mul(POW);
420 	        
421 		    return (_currentLevelTokensAmount, 0);
422 		}
423 		
424 		if(block.timestamp < thirdStageEnd && weiAmount >= TEN_ETHERS) {
425 		    _currentLevelTokensAmount = weiAmount.div(thirdStageDiscountPriceOfTokenInWei);
426 	        _currentLevelTokensAmount = _currentLevelTokensAmount.mul(POW);
427 	        
428 		    return (_currentLevelTokensAmount, 0);
429 		}
430 		
431 		if(block.timestamp < thirdStageEnd){	
432 		    _currentLevelTokensAmount = weiAmount.div(thirdStagePriceOfTokenInWei);
433 	        _currentLevelTokensAmount = _currentLevelTokensAmount.mul(POW);
434 	        
435 		    return (_currentLevelTokensAmount, 0);
436 		}
437 		
438 		revert();
439 	}
440 	
441 	/** @dev Realase the tokens from the three hot hours.
442       */
443 	function release() public {
444 	    releaseThreeHotHourTokens(msg.sender);
445 	}
446 	
447 	/** @dev Realase the tokens from the three hot hours.
448 	  * It can be called after the end of three hot hours
449       * @param _participant The investor who want to release his tokens
450       * @return success Is the release tokens function called successfully.
451       */
452 	function releaseThreeHotHourTokens(address _participant) public isAfterThreeHotHours returns(bool success) { 
453 	    // Check if the _participants tokens are realased
454 	    // If not calculate his tokens for every month and set the isCalculated to true
455 		if(isCalculated[_participant] == false) {
456 		    calculateTokensForMonth(_participant);
457 		    isCalculated[_participant] = true;
458 		}
459 		
460 		// Unlock the tokens amount for the _participant
461 		uint _amount = unlockTokensAmount(_participant);
462 		
463 		// Substract the _amount from the threeHotHoursTokens mapping
464 		threeHotHoursTokens[_participant] = threeHotHoursTokens[_participant].sub(_amount);
465 		
466 		// Mint to the _participant vernamCrowdsaleTokens
467 		vernamCrowdsaleToken.mintToken(_participant, _amount);        
468 
469 		emit ReleasedTokens(_amount);
470 		
471 		return true;
472 	}
473 	
474 	/** @dev Get contributed amount in wei.
475       * @return contributedInWei[_participant].
476       */
477 	function getContributedAmountInWei(address _participant) public view returns (uint) {
478         return contributedInWei[_participant];
479     }
480 	
481 	/** @dev Function which calculate tokens for every month (6 months).
482       * @param weiAmount Participant's contribution in wei.
483       * @param currentLevelPrice Price of the tokens for the current level.
484       * @param nextLevelPrice Price of the tokens for the next level.
485       * @param currentLevelCap Current level cap in wei.
486       * @return _currentLevelTokensAmount and _nextLevelTokensAmount Returns the calculated tokens for the current and next level
487       * It is called by three hot hours
488       */
489       
490 	function tokensCalculator(uint weiAmount, uint currentLevelPrice, uint nextLevelPrice, uint currentLevelCap) internal view returns (uint _currentLevelTokensAmount, uint _nextLevelTokensAmount){
491 	    uint currentAmountInWei = 0;
492 		uint remainingAmountInWei = 0;
493 		uint currentLevelTokensAmount = 0;
494 		uint nextLevelTokensAmount = 0;
495 		
496 		// Check if the contribution overflows and you should buy tokens on next level price
497 		if(weiAmount.add(totalContributedWei) > currentLevelCap) {
498 		    remainingAmountInWei = (weiAmount.add(totalContributedWei)).sub(currentLevelCap);
499 		    currentAmountInWei = weiAmount.sub(remainingAmountInWei);
500             
501             currentLevelTokensAmount = currentAmountInWei.div(currentLevelPrice);
502             nextLevelTokensAmount = remainingAmountInWei.div(nextLevelPrice); 
503 	    } else {
504 	        currentLevelTokensAmount = weiAmount.div(currentLevelPrice);
505 			nextLevelTokensAmount = 0;
506 	    }
507 	    currentLevelTokensAmount = currentLevelTokensAmount.mul(POW);
508 	    nextLevelTokensAmount = nextLevelTokensAmount.mul(POW);
509 		
510 		
511 		return (currentLevelTokensAmount, nextLevelTokensAmount);
512 	}
513 	
514 	/** @dev Function which calculate tokens for every month (6 months).
515       * @param _participant The investor whose tokens are calculated.
516       * It is called once from the releaseThreeHotHourTokens function
517       */
518 	function calculateTokensForMonth(address _participant) internal {
519 	    // Get the max balance of the participant  
520 	    uint maxBalance = threeHotHoursTokens[_participant];
521 	    
522 	    // Start from 10% for the first three months
523 	    uint percentage = 10;
524 	    for(uint month = 0; month < 6; month++) {
525 	        // The fourth month the unlock tokens percentage is increased by 10% and for the fourth and fifth month will be 20%
526 	        // It will increase one more by 10% in the last month and will become 30% 
527 	        if(month == 3 || month == 5) {
528 	            percentage += 10;
529 	        }
530 	        
531 	        // Set the participant at which month how much he will get
532 	        getTokensBalance[_participant][month] = maxBalance.div(percentage);
533 	        
534 	        // Set for every month false to see the tokens for the month is not get it 
535 	        isTokensTaken[_participant][month] = false; 
536 	    }
537 	}
538 	
539 		
540 	/** @dev Function which validates if the participan is not null address and the wei amount is not zero
541       * @param _participant The investor who want to unlock his tokens
542       * @return _tokensAmount Tokens which are unlocked
543       */
544 	function unlockTokensAmount(address _participant) internal returns (uint _tokensAmount) {
545 	    // Check if the _participant have tokens in threeHotHours stage
546 		require(threeHotHoursTokens[_participant] > 0);
547 		
548 		// Check if the _participant got his tokens in first month and if the time for the first month end has come 
549         if(block.timestamp < firstMonthEnd && isTokensTaken[_participant][FIRST_MONTH] == false) {
550             // Go and get the tokens for the current month
551             return getTokens(_participant, FIRST_MONTH.add(1)); // First month
552         } 
553         
554         // Check if the _participant got his tokens in second month and if the time is in the period between first and second month end
555         if(((block.timestamp >= firstMonthEnd) && (block.timestamp < secondMonthEnd)) 
556             && isTokensTaken[_participant][SECOND_MONTH] == false) {
557             // Go and get the tokens for the current month
558             return getTokens(_participant, SECOND_MONTH.add(1)); // Second month
559         } 
560         
561         // Check if the _participant got his tokens in second month and if the time is in the period between second and third month end
562         if(((block.timestamp >= secondMonthEnd) && (block.timestamp < thirdMonthEnd)) 
563             && isTokensTaken[_participant][THIRD_MONTH] == false) {
564             // Go and get the tokens for the current month
565             return getTokens(_participant, THIRD_MONTH.add(1)); // Third month
566         } 
567         
568         // Check if the _participant got his tokens in second month and if the time is in the period between third and fourth month end
569         if(((block.timestamp >= thirdMonthEnd) && (block.timestamp < fourthMonthEnd)) 
570             && isTokensTaken[_participant][FORTH_MONTH] == false) {
571             // Go and get the tokens for the current month
572             return getTokens(_participant, FORTH_MONTH.add(1)); // Forth month
573         } 
574         
575         // Check if the _participant got his tokens in second month and if the time is in the period between forth and fifth month end
576         if(((block.timestamp >= fourthMonthEnd) && (block.timestamp < fifthMonthEnd)) 
577             && isTokensTaken[_participant][FIFTH_MONTH] == false) {
578             // Go and get the tokens for the current month
579             return getTokens(_participant, FIFTH_MONTH.add(1)); // Fifth month
580         } 
581         
582         // Check if the _participant got his tokens in second month and if the time is after the end of the fifth month
583         if((block.timestamp >= fifthMonthEnd) 
584             && isTokensTaken[_participant][SIXTH_MONTH] == false) {
585             return getTokens(_participant, SIXTH_MONTH.add(1)); // Last month
586         }
587     }
588     
589     /** @dev Function for getting the tokens for unlock
590       * @param _participant The investor who want to unlock his tokens
591       * @param _period The period for which will be unlocked the tokens
592       * @return tokensAmount Returns the amount of tokens for unlocing
593       */
594     function getTokens(address _participant, uint _period) internal returns(uint tokensAmount) {
595         uint tokens = 0;
596         for(uint month = 0; month < _period; month++) {
597             // Check if the tokens fot the current month unlocked
598             if(isTokensTaken[_participant][month] == false) { 
599                 // Set the isTokensTaken to true
600                 isTokensTaken[_participant][month] = true;
601                 
602                 // Calculates the tokens
603                 tokens += getTokensBalance[_participant][month];
604                 
605                 // Set the balance for the curren month to zero
606                 getTokensBalance[_participant][month] = 0;
607             }
608         }
609         
610         return tokens;
611     }
612 	
613 	/** @dev Function which validates if the participan is not null address and the wei amount is not zero
614       * @param _participant The investor who want to buy tokens
615       * @param _weiAmount The amount of wei which the investor want to contribute
616       */
617 	function validatePurchase(address _participant, uint _weiAmount) pure internal {
618         require(_participant != address(0));
619         require(_weiAmount != 0);
620     }
621 	
622 	 /** @dev Function which set the duration of crowdsale stages
623       * Called by the activateCrowdSale function 
624       */
625 	function setTimeForCrowdsalePeriods() internal {
626 		startTime = block.timestamp;
627 		threeHotHoursEnd = startTime.add(threeHotHoursDuration);
628 		firstStageEnd = threeHotHoursEnd.add(firstStageDuration);
629 		secondStageEnd = firstStageEnd.add(secondStageDuration);
630 		thirdStageEnd = secondStageEnd.add(thirdStageDuration);
631 	}
632 	
633 	/** @dev Function which set the duration in which the tokens bought in threeHotHours will be locked
634       * Called by the activateCrowdSale function 
635       */
636 	function timeLock() internal {
637 		firstMonthEnd = (startTime.add(LOCK_TOKENS_DURATION)).add(threeHotHoursDuration);
638 		secondMonthEnd = firstMonthEnd.add(LOCK_TOKENS_DURATION);
639 		thirdMonthEnd = secondMonthEnd.add(LOCK_TOKENS_DURATION);
640 		fourthMonthEnd = thirdMonthEnd.add(LOCK_TOKENS_DURATION);
641 		fifthMonthEnd = fourthMonthEnd.add(LOCK_TOKENS_DURATION);
642 	}
643 	
644 	function getPrice(uint256 time, uint256 weiAmount) public view returns (uint levelPrice) {
645 
646 		if(time < threeHotHoursEnd && totalSoldTokens < threeHotHoursTokensCap) {
647             return threeHotHoursPriceOfTokenInWei;
648 		}
649 		
650 		if(time < firstStageEnd) {
651             return firstStagePriceOfTokenInWei;
652 		}
653 		
654 		if(time < secondStageEnd) {
655             return secondStagePriceOfTokenInWei;
656 		}
657 		
658 		if(time < thirdStageEnd && weiAmount > TEN_ETHERS) {
659             return thirdStageDiscountPriceOfTokenInWei;
660 		}
661 		
662 		if(time < thirdStageEnd){		
663 		    return thirdStagePriceOfTokenInWei;
664 		}
665 	}
666 	
667 	function setBenecifiary(address _newBenecifiary) public onlyOwner {
668 		benecifiary = _newBenecifiary;
669 	}
670 }
671 contract OwnableController {
672 	address public owner;
673 	address public KYCTeam;
674 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
675 
676 	constructor() public {
677 		owner = msg.sender;
678 	}
679 
680 	modifier onlyOwner() {
681 		require(msg.sender == owner);
682 		_;
683 	}
684 	
685 	modifier onlyKYCTeam() {
686 		require(msg.sender == KYCTeam);
687 		_;
688 	}
689 	
690 	function setKYCTeam(address _KYCTeam) public onlyOwner {
691 		KYCTeam = _KYCTeam;
692 	}
693 
694 	function transferOwnership(address newOwner) public onlyOwner {
695 		require(newOwner != address(0));
696 		emit OwnershipTransferred(owner, newOwner);
697 		owner = newOwner;
698 	}
699 }
700 contract Controller is OwnableController {
701     
702     VernamCrowdSale public vernamCrowdSale;
703 	VernamCrowdSaleToken public vernamCrowdsaleToken;
704 	VernamToken public vernamToken;
705 	
706 	mapping(address => bool) public isParticipantApproved;
707     
708     event Refunded(address _to, uint amountInWei);
709 	event Convert(address indexed participant, uint tokens);
710     
711     function Controller(address _crowdsaleAddress, address _vernamCrowdSaleToken) public {
712         vernamCrowdSale = VernamCrowdSale(_crowdsaleAddress);
713 		vernamCrowdsaleToken = VernamCrowdSaleToken(_vernamCrowdSaleToken);
714     }
715     
716     function releaseThreeHotHourTokens() public {
717         vernamCrowdSale.releaseThreeHotHourTokens(msg.sender);
718     }
719 	
720 	function convertYourTokens() public {
721 		convertTokens(msg.sender);
722 	}
723 	
724 	function convertTokens(address _participant) public {
725 	    bool isApproved = vernamCrowdsaleToken.isKYCApproved(_participant);
726 		if(isApproved == false && isParticipantApproved[_participant] == true){
727 			vernamCrowdsaleToken.approveKYC(_participant);
728 			isApproved = vernamCrowdsaleToken.isKYCApproved(_participant);
729 		}
730 	    
731 	    require(isApproved == true);
732 	    
733 		uint256 tokens = vernamCrowdsaleToken.balanceOf(_participant);
734 		
735 		require(tokens > 0);
736 		vernamCrowdsaleToken.burn(_participant, tokens);
737 		vernamToken.transfer(_participant, tokens);
738 		
739 		emit Convert(_participant, tokens);
740 	}
741 	
742 	function approveKYC(address _participant) public onlyKYCTeam returns(bool _success) {
743 	    vernamCrowdsaleToken.approveKYC(_participant);
744 		isParticipantApproved[_participant] = vernamCrowdsaleToken.isKYCApproved(_participant);
745 	    return isParticipantApproved[_participant];
746 	}
747 	
748 	function setVernamOriginalToken(address _vernamToken) public onlyOwner {
749 		vernamToken = VernamToken(_vernamToken);
750 	}
751 }
752 
753 contract ERC20 {
754   function totalSupply() public view returns (uint256);
755   function balanceOf(address who) public view returns (uint256);
756   function transfer(address to, uint256 value) public returns (bool);
757   function allowance(address owner, address spender) public view returns (uint256);
758   function transferFrom(address from, address to, uint256 value) public returns (bool);
759   function approve(address spender, uint256 value) public returns (bool);
760   event Transfer(address indexed from, address indexed to, uint256 value);
761   event Approval(address indexed owner, address indexed spender, uint256 value);
762 }
763 
764 contract VernamToken is ERC20 {
765 	using SafeMath for uint256;
766 	
767 	/* Public variables of the token */
768 	string public name;
769 	string public symbol;
770 	uint8 public decimals;
771 	uint256 public _totalSupply;
772 		
773 	modifier onlyPayloadSize(uint256 numwords) {                                         //https://blog.golemproject.net/how-to-find-10m-by-just-reading-blockchain-6ae9d39fcd95
774 		assert(msg.data.length == numwords * 32 + 4);
775 		_;
776 	}
777 	
778 	/* This creates an array with all balances */
779 	mapping (address => uint256) public balances;
780     mapping (address => mapping (address => uint256)) internal allowed;
781 
782 	/* Initializes contract with initial supply tokens to the creator of the contract */
783 	function VernamToken(uint256 _totalSupply_) public {
784 		name = "Vernam Token";                                   	// Set the name for display purposes
785 		symbol = "VRN";                               				// Set the symbol for display purposes
786 		decimals = 18;                            					// Amount of decimals for display purposes
787 		_totalSupply = _totalSupply_;     			//1 Billion Tokens with 18 Decimals
788 		balances[msg.sender] = _totalSupply_;
789 	}
790 
791 	function transfer(address _to, uint256 _value) onlyPayloadSize(2) public returns (bool _success) {
792 		return _transfer(msg.sender, _to, _value);
793 	}
794 	
795     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {
796         require(_value <= allowed[_from][msg.sender]);     								// Check allowance
797         
798 		_transfer(_from, _to, _value);
799 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
800 		
801 		return true;
802     }
803 	
804 	/* Internal transfer, only can be called by this contract */
805 	function _transfer(address _from, address _to, uint256 _value) internal returns (bool _success) {
806 		require (_to != address(0x0));														// Prevent transfer to 0x0 address.
807 		require(_value >= 0);
808 		require (balances[_from] >= _value);                								// Check if the sender has enough
809 		require (balances[_to].add(_value) > balances[_to]); 								// Check for overflows
810 		
811 		uint256 previousBalances = balances[_from].add(balances[_to]);					// Save this for an assertion in the future
812 		
813 		balances[_from] = balances[_from].sub(_value);        				   				// Subtract from the sender
814 		balances[_to] = balances[_to].add(_value);                            				// Add the same to the recipient
815 		
816 		emit Transfer(_from, _to, _value);
817 		
818 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
819         assert(balances[_from] + balances[_to] == previousBalances); //add safeMath
820 		
821 		return true;
822 	}
823 
824 	function increaseApproval(address _spender, uint256 _addedValue) onlyPayloadSize(2) public returns (bool _success) {
825 		require(allowed[msg.sender][_spender].add(_addedValue) <= balances[msg.sender]);
826 		
827 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
828 		
829 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
830 		
831 		return true;
832 	}
833 
834 	function decreaseApproval(address _spender, uint256 _subtractedValue) onlyPayloadSize(2) public returns (bool _success) {
835 		uint256 oldValue = allowed[msg.sender][_spender];
836 		
837 		if (_subtractedValue > oldValue) {
838 			allowed[msg.sender][_spender] = 0;
839 		} else {
840 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
841 		}
842 		
843 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
844 		
845 		return true;
846 	}
847 	
848 	function approve(address _spender, uint256 _value) onlyPayloadSize(2) public returns (bool _success) {
849 		require(_value <= balances[msg.sender]);
850 		
851 		allowed[msg.sender][_spender] = _value;
852 		
853 		emit Approval(msg.sender, _spender, _value);
854 		
855 		return true;
856 	}
857   
858 	function totalSupply() public view returns (uint256) {
859 		return _totalSupply;
860 	}
861 	
862 	function balanceOf(address _owner) public view returns (uint256 balance) {
863 		return balances[_owner];
864 	}
865 	
866 	function allowance(address _owner, address _spender) public view returns (uint256 _remaining) {
867 		return allowed[_owner][_spender];
868 	}
869 }