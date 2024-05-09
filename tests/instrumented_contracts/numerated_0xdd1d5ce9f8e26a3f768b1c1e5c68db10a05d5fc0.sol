1 pragma solidity ^0.4.16;
2 
3 
4 /**
5  * @title WeBetCrypto
6  * @author AL_X
7  * @dev The WBC ERC-223 Token Contract
8  */
9 contract WeBetCrypto {
10     string public name = "We Bet Crypto";
11     string public symbol = "WBC";
12 	
13     address public selfAddress;
14     address public admin;
15     address[] private users;
16 	
17     uint8 public decimals = 7;
18     uint256 public relativeDateSave;
19     uint256 public totalFunds;
20     uint256 public totalSupply = 300000000000000;
21     uint256 public pricePerEther;
22     uint256 private amountInCirculation;
23     uint256 private currentProfits;
24     uint256 private currentIteration;
25 	uint256 private actualProfitSplit;
26 	
27     bool public DAppReady;
28     bool public isFrozen;
29 	bool public splitInService = true;
30 	bool private hasICORun;
31     bool private running;
32 	bool[4] private devApprovals;
33 	
34     mapping(address => uint256) balances;
35     mapping(address => uint256) monthlyLimit;
36 	
37     mapping(address => bool) isAdded;
38     mapping(address => bool) freezeUser;
39 	
40     mapping (address => mapping (address => uint256)) allowed;
41 	mapping (address => mapping (address => uint256)) cooldown;
42 	
43     event Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
44     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45     event CurrentTLSNProof(address indexed _from, string _proof);
46     
47 	/**
48 	 * @notice Ensures admin is caller
49 	 */
50     modifier isAdmin() {
51         require(msg.sender == admin);
52         //Continue executing rest of method body
53         _;
54     }
55     
56     /**
57 	 * @notice Re-entry protection
58 	 */
59     modifier isRunning() {
60         require(!running);
61         running = true;
62         _;
63         running = false;
64     }
65     
66 	/**
67 	 * @notice Ensures system isn't frozen
68 	 */
69     modifier requireThaw() {
70         require(!isFrozen);
71         _;
72     }
73     
74 	/**
75 	 * @notice Ensures player isn't logged in on platform
76 	 */
77     modifier userNotPlaying(address _user) {
78         require(!freezeUser[_user]);
79         _;
80     }
81 	
82 	/**
83 	 * @notice Ensures function runs only once
84 	 */
85 	modifier oneTime() {
86 		require(!hasICORun);
87 		_;
88 	}
89     
90 	/**
91 	 * @notice Ensures WBC DApp is online
92 	 */
93     modifier DAppOnline() {
94         require(DAppReady);
95         _;
96     }
97     
98     /**
99 	 * @notice SafeMath Library safeSub Import
100 	 * @dev 
101 	        Since we are dealing with a limited currency
102 	        circulation of 30 million tokens and values
103 	        that will not surpass the uint256 limit, only
104 	        safeSub is required to prevent underflows.
105 	 */
106     function safeSub(uint256 a, uint256 b) internal constant returns (uint256 z) {
107         assert((z = a - b) <= a);
108     }
109 	
110 	/**
111 	 * @notice WBC Constructor
112 	 * @dev 
113 	        Constructor function containing proper initializations such as 
114 	        token distribution to the team members and pushing the first 
115 	        profit split to 6 months when the DApp will already be live.
116 	 */
117     function WeBetCrypto() {
118         admin = msg.sender;
119         balances[0x166Cb48973C2447dafFA8EFd3526da18076088de] = 22500000000000;
120         addUser(0x166Cb48973C2447dafFA8EFd3526da18076088de);
121         balances[0xE59CbD028f71447B804F31Cf0fC41F0e5E13f4bF] = 15000000000000;
122         addUser(0xE59CbD028f71447B804F31Cf0fC41F0e5E13f4bF);
123         balances[0x1ab13D2C1AC4303737981Ce8B8bD5116C84c744d] = 5000000000000;
124         addUser(0x1ab13D2C1AC4303737981Ce8B8bD5116C84c744d);
125         balances[0x06908Df389Cf2589375b6908D0b1c8FcC34721B5] = 2500000000000;
126         addUser(0x06908Df389Cf2589375b6908D0b1c8FcC34721B5);
127         balances[0xEdBd4c6757DC425321584a91bDB355Ce65c42b13] = 2500000000000;
128         addUser(0xEdBd4c6757DC425321584a91bDB355Ce65c42b13);
129         balances[0x4309Fb4B31aA667673d69db1072E6dcD50Fd8858] = 2500000000000;
130         addUser(0x4309Fb4B31aA667673d69db1072E6dcD50Fd8858);
131         selfAddress = this;
132         relativeDateSave = now + 180 days;
133         pricePerEther = 33209;
134         balances[selfAddress] = 250000000000000;
135     }
136     
137     /**
138      * @notice Check the name of the token ~ ERC-20 Standard
139      * @return {
140 					"_name": "The token name"
141 				}
142      */
143     function name() external constant returns (string _name) {
144         return name;
145     }
146     
147 	/**
148      * @notice Check the symbol of the token ~ ERC-20 Standard
149      * @return {
150 					"_symbol": "The token symbol"
151 				}
152      */
153     function symbol() external constant returns (string _symbol) {
154         return symbol;
155     }
156     
157     /**
158      * @notice Check the decimals of the token ~ ERC-20 Standard
159      * @return {
160 					"_decimals": "The token decimals"
161 				}
162      */
163     function decimals() external constant returns (uint8 _decimals) {
164         return decimals;
165     }
166     
167     /**
168      * @notice Check the total supply of the token ~ ERC-20 Standard
169      * @return {
170 					"_totalSupply": "Total supply of tokens"
171 				}
172      */
173     function totalSupply() external constant returns (uint256 _totalSupply) {
174         return totalSupply;
175     }
176     
177     /**
178      * @notice Query the available balance of an address ~ ERC-20 Standard
179 	 * @param _owner The address whose balance we wish to retrieve
180      * @return {
181 					"balance": "Balance of the address"
182 				}
183      */
184     function balanceOf(address _owner) external constant returns (uint256 balance) {
185         return balances[_owner];
186     }
187 	
188 	/**
189 	 * @notice Query the amount of tokens the spender address can withdraw from the owner address ~ ERC-20 Standard
190 	 * @param _owner The address who owns the tokens
191 	 * @param _spender The address who can withdraw the tokens
192 	 * @return {
193 					"remaining": "Remaining withdrawal amount"
194 				}
195      */
196     function allowance(address _owner, address _spender) external constant returns (uint256 remaining) {
197         return allowed[_owner][_spender];
198     }
199     
200     /**
201      * @notice Transfer tokens from an address to another ~ ERC-20 Standard
202 	 * @dev 
203 	        Adjusts the monthly limit in case the _from address is the Casino
204 	        and ensures that the user isn't logged in when retrieving funds
205 	        so as to prevent against a race attack with the Casino.
206      * @param _from The address whose balance we will transfer
207      * @param _to The recipient address
208 	 * @param _value The amount of tokens to be transferred
209      */
210     function transferFrom(address _from, address _to, uint256 _value) external requireThaw userNotPlaying(_to) {
211 		require(cooldown[_from][_to] <= now);
212         var _allowance = allowed[_from][_to];
213         if (_from == selfAddress) {
214             monthlyLimit[_to] = safeSub(monthlyLimit[_to], _value);
215         }
216         balances[_to] = balances[_to]+_value;
217         balances[_from] = safeSub(balances[_from], _value);
218         allowed[_from][_to] = safeSub(_allowance, _value);
219         addUser(_to);
220         bytes memory empty;
221         Transfer(_from, _to, _value, empty);
222     }
223     
224     /**
225 	 * @notice Authorize an address to retrieve funds from you ~ ERC-20 Standard
226 	 * @dev 
227 	        Each approval comes with a default cooldown of 30 minutes
228 	        to prevent against the ERC-20 race attack.
229 	 * @param _spender The address you wish to authorize
230 	 * @param _value The amount of tokens you wish to authorize
231 	 */
232     function approve(address _spender, uint256 _value) external {
233         allowed[msg.sender][_spender] = _value;
234 		cooldown[msg.sender][_spender] = now + 30 minutes;
235         Approval(msg.sender, _spender, _value);
236     }
237 	
238 	/**
239 	 * @notice Authorize an address to retrieve funds from you with a custom cooldown ~ ERC-20 Standard
240 	 * @dev Allowing custom cooldown for the ERC-20 race attack prevention.
241 	 * @param _spender The address you wish to authorize
242 	 * @param _value The amount of tokens you wish to authorize
243 	 * @param _cooldown The amount of seconds the recipient needs to wait before withdrawing the balance
244 	 */
245     function approve(address _spender, uint256 _value, uint256 _cooldown) external {
246         allowed[msg.sender][_spender] = _value;
247 		cooldown[msg.sender][_spender] = now + _cooldown;
248         Approval(msg.sender, _spender, _value);
249     }
250     
251     /**
252 	 * @notice Transfer the specified amount to the target address ~ ERC-20 Standard
253 	 * @dev 
254 	        A boolean is returned so that callers of the function 
255 	        will know if their transaction went through.
256 	 * @param _to The address you wish to send the tokens to
257 	 * @param _value The amount of tokens you wish to send
258 	 * @return {
259 					"success": "Transaction success"
260 				}
261      */
262     function transfer(address _to, uint256 _value) external isRunning requireThaw returns (bool success){
263         bytes memory empty;
264         if (_to == selfAddress) {
265             return transferToSelf(_value, empty);
266         } else if (isContract(_to)) {
267             return transferToContract(_to, _value, empty);
268         } else {
269             return transferToAddress(_to, _value, empty);
270         }
271     }
272     
273     /**
274 	 * @notice Check whether address is a contract ~ ERC-223 Proposed Standard
275 	 * @param _address The address to check
276 	 * @return {
277 					"is_contract": "Result of query"
278 				}
279      */
280     function isContract(address _address) internal returns (bool is_contract) {
281         uint length;
282         assembly {
283             length := extcodesize(_address)
284         }
285         return length > 0;
286     }
287     
288     /**
289 	 * @notice Transfer the specified amount to the target address with embedded bytes data ~ ERC-223 Proposed Standard
290 	 * @dev Includes an extra transferToSelf function to handle Casino deposits
291 	 * @param _to The address to transfer to
292 	 * @param _value The amount of tokens to transfer
293 	 * @param _data Any extra embedded data of the transaction
294 	 * @return {
295 					"success": "Transaction success"
296 				}
297      */
298     function transfer(address _to, uint256 _value, bytes _data) external isRunning requireThaw returns (bool success){
299         if (_to == selfAddress) {
300             return transferToSelf(_value, _data);
301         } else if (isContract(_to)) {
302             return transferToContract(_to, _value, _data);
303         } else {
304             return transferToAddress(_to, _value, _data);
305         }
306     }
307     
308     /**
309 	 * @notice Handles transfer to an ECA (Externally Controlled Account), a normal account ~ ERC-223 Proposed Standard
310 	 * @param _to The address to transfer to
311 	 * @param _value The amount of tokens to transfer
312 	 * @param _data Any extra embedded data of the transaction
313 	 * @return {
314 					"success": "Transaction success"
315 				}
316      */
317     function transferToAddress(address _to, uint256 _value, bytes _data) internal returns (bool success) {
318         balances[msg.sender] = safeSub(balances[msg.sender], _value);
319         balances[_to] = balances[_to]+_value;
320         addUser(_to);
321         Transfer(msg.sender, _to, _value, _data);
322         return true;
323     }
324     
325     /**
326 	 * @notice Handles transfer to a contract ~ ERC-223 Proposed Standard
327 	 * @param _to The address to transfer to
328 	 * @param _value The amount of tokens to transfer
329 	 * @param _data Any extra embedded data of the transaction
330 	 * @return {
331 					"success": "Transaction success"
332 				}
333      */
334     function transferToContract(address _to, uint256 _value, bytes _data) internal returns (bool success) {
335         balances[msg.sender] = safeSub(balances[msg.sender], _value);
336         balances[_to] = balances[_to]+_value;
337         WeBetCrypto rec = WeBetCrypto(_to);
338         rec.tokenFallback(msg.sender, _value, _data);
339         addUser(_to);
340         Transfer(msg.sender, _to, _value, _data);
341         return true;
342     }
343     
344     /**
345 	 * @notice Handles Casino deposits ~ Custom ERC-223 Proposed Standard Addition
346 	 * @param _value The amount of tokens to transfer
347 	 * @param _data Any extra embedded data of the transaction
348 	 * @return {
349 					"success": "Transaction success"
350 				}
351      */
352     function transferToSelf(uint256 _value, bytes _data) internal returns (bool success) {
353         balances[msg.sender] = safeSub(balances[msg.sender], _value);
354         balances[selfAddress] = balances[selfAddress]+_value;
355         Transfer(msg.sender, selfAddress, _value, _data);
356 		allowed[selfAddress][msg.sender] = _value + allowed[selfAddress][msg.sender];
357 		Approval(selfAddress, msg.sender, allowed[selfAddress][msg.sender]);
358         return true;
359     }
360 	
361 	/**
362 	 * @notice Empty tokenFallback method to ensure ERC-223 compatibility
363 	 * @param _sender The address who sent the ERC-223 tokens
364 	 * @param _value The amount of tokens the address sent to this contract
365 	 * @param _data Any embedded data of the transaction
366 	 */
367 	function tokenFallback(address _sender, uint256 _value, bytes _data) {}
368 	
369 	/**
370 	 * @notice Check the cooldown remaining until the allowee can withdraw the balance
371 	 * @param _allower The holder of the balance
372 	 * @param _allowee The recipient of the balance
373 	 * @return {
374 					"remaining": "Cooldown remaining in seconds"
375 				}
376      */
377 	function checkCooldown(address _allower, address _allowee) external constant returns (uint256 remaining) {
378 		if (cooldown[_allower][_allowee] > now) {
379 			return (cooldown[_allower][_allowee] - now);
380 		} else {
381 			return 0;
382 		}
383 	}
384 	
385 	/**
386 	 * @notice Check how much Casino withdrawal balance remains for address
387 	 * @param _owner The address to check
388 	 * @return {
389 					"remaining": "Withdrawal balance remaining"
390 				}
391      */
392     function checkMonthlyLimit(address _owner) external constant returns (uint256 remaining) {
393         return monthlyLimit[_owner];
394     }
395 	
396 	/**
397 	 * @notice Retrieve ERC Tokens sent to contract
398 	 * @dev Feel free to contact us and retrieve your ERC tokens should you wish so.
399 	 * @param _token The token contract address
400 	 */
401     function claimTokens(address _token) isAdmin external { 
402 		require(_token != selfAddress);
403         WeBetCrypto token = WeBetCrypto(_token); 
404         uint balance = token.balanceOf(selfAddress); 
405         token.transfer(admin, balance); 
406     }
407     
408 	/**
409 	 * @notice Freeze token circulation - splitProfits internal
410 	 * @dev 
411 	        Ensures that one doesn't transfer his total balance mid-split to 
412 	        an account later in the split queue in order to receive twice the
413 	        monthly profits
414 	 */
415     function assetFreeze() internal {
416         isFrozen = true;
417     }
418     
419 	/**
420 	 * @notice Re-enable token circulation - splitProfits internal
421 	 */
422     function assetThaw() internal {
423         isFrozen = false;
424     }
425     
426 	/**
427 	 * @notice Freeze token circulation
428 	 * @dev To be used only in extreme circumstances.
429 	 */
430     function emergencyFreeze() isAdmin external {
431         isFrozen = true;
432     }
433     
434 	/**
435 	 * @notice Re-enable token circulation
436 	 * @dev To be used only in extreme circumstances
437 	 */
438     function emergencyThaw() isAdmin external {
439         isFrozen = false;
440     }
441 	
442 	/**
443 	 * @notice Disable the splitting function
444 	 * @dev 
445 	        To be used in case the system is upgraded to a 
446 	        node.js operated profit reward system via the 
447 			alterBankBalance function. Ensures scalability 
448 			in case userbase gets too big.
449 	 */
450 	function emergencySplitToggle() external {
451 		splitInService = !splitInService;
452 	}
453     
454 	/**
455 	 * @notice Adjust the price of Ether according to Coin Market Cap's API
456 	 * @dev 
457 	        The subfolder is public domain so anyone can verify that we indeed got the price
458 	        from a trusted source at the time we updated it. 2 decimal precision is achieved
459 	        by multiplying the price of Ether by 100 and then offsetting the multiplication
460 	        in the calculation the price is used in. The TLSNotaryProof string can be added
461 	        to the end of https://webetcrypto.io/TLSNotary/ to get the perspective TLS proof.
462 	 * @param newPrice The new Ethereum price with 2 decimal precision
463 	 * @param TLSNotaryProof The webetcrypto.io subfolder the TLSNotary proof is stored
464 	 */
465     function setPriceOfEther(uint256 newPrice, string TLSNotaryProof) external isAdmin {
466         pricePerEther = newPrice;
467         CurrentTLSNProof(selfAddress, TLSNotaryProof);
468     }
469 	
470 	/**
471 	 * @notice Get the current 2-decimal precision price per token
472 	 * @dev 
473 	        The price retains the 2 decimal precision by multiplying it with
474 	        100 and offsetting that in the calculations the price is used in.
475 	        For example 50 means each token costs 0.50$.
476 	 * @return {
477 					"price": "Price of a single WBC Token"
478 				}
479      */
480 	function getPricePerToken() public constant returns (uint256 price) {
481         if (balances[selfAddress] > 200000000000000) {
482             return 50;
483         } else if (balances[selfAddress] > 150000000000000) {
484 			return 200;
485 		} else if (balances[selfAddress] > 100000000000000) {
486 			return 400;
487 		} else {
488 			return 550;
489         }
490     }
491 	
492 	/**
493 	 * @notice Convert Wei to WBC tokens
494 	 * @dev 
495 		    The _value is multiplied by 10^7 because of the 7 decimal precision
496 			of WBC and to ensure that a user can invest less than 1 ether and 
497 			still get his WBC tokens, preventing rounding errors. A hard cap
498 			of 500k WBC tokens per purchase is enforced so as to prevent users
499 			from buying large amounts at a higher or lower Ether price due to 
500 			hourly price updates.
501 	 * @param _value The amount of Wei to convert
502 	 * @return {
503 					"tokenAmount": "Amount of WBC Tokens input is worth"
504 				}
505      */
506 	function calculateTokenAmount(uint256 _value) internal returns (uint256 tokenAmount) {
507 		tokenAmount = ((_value*(10**7)/1 ether)*pricePerEther)/getPricePerToken();
508 		assert(tokenAmount <= 5000000000000);
509 	}
510 	
511 	/**
512 	 * @notice Add the address to the user list 
513 	 * @dev Used for the splitting function to take it into account
514 	 * @param _user User to add to database
515 	 */
516 	function addUser(address _user) internal {
517 		if (!isAdded[_user]) {
518             users.push(_user);
519             monthlyLimit[_user] = 5000000000000;
520             isAdded[_user] = true;
521         }
522 	}
523     
524 	/**
525 	 * @notice Split the monthly profits of the Casino to the users
526 	 * @dev 
527 			The formula that calculates the profit a user is owed can be seen on 
528 			the white paper. The actualProfitSplit variable stores the actual values
529 	   		that are distributed to the users to prevent rounding errors from burning 
530 			tokens. Since gas requirements will spike the more users use our platform,
531 			a loop-state-save is implemented to ensure scalability.
532 	 */
533     function splitProfits() external {
534 		require(splitInService);
535         bytes memory empty;
536         uint i;
537         if (!isFrozen) {
538             require(now >= relativeDateSave);
539             assetFreeze();
540             require(balances[selfAddress] > 30000000000000);
541             relativeDateSave = now + 30 days;
542             currentProfits = ((balances[selfAddress]-30000000000000)/10)*7; 
543             amountInCirculation = safeSub(300000000000000, balances[selfAddress]);
544             currentIteration = 0;
545 			actualProfitSplit = 0;
546         } else {
547             for (i = currentIteration; i < users.length; i++) {
548                 monthlyLimit[users[i]] = 5000000000000;
549                 if (msg.gas < 240000) {
550                     currentIteration = i;
551                     break;
552                 }
553 				if (allowed[selfAddress][users[i]] == 0) {
554 					checkSplitEnd(i);
555 					continue;
556 				} else if ((balances[users[i]]/allowed[selfAddress][users[i]]) < 19) {
557 					checkSplitEnd(i);
558                     continue;
559                 }
560                 balances[users[i]] += (balances[users[i]]*currentProfits)/amountInCirculation;
561 				actualProfitSplit += (balances[users[i]]*currentProfits)/amountInCirculation;
562 				checkSplitEnd(i);
563                 Transfer(selfAddress, users[i], (balances[users[i]]/amountInCirculation)*currentProfits, empty);
564             }
565         }
566     }
567 	
568 	/**
569 	 * @notice Change variables on split end
570 	 * @param i The current index of the split loop
571 	 */
572 	function checkSplitEnd(uint256 i) internal {
573 		if (i == users.length-1) {
574 			assetThaw();
575 			balances[0x166Cb48973C2447dafFA8EFd3526da18076088de] = balances[0x166Cb48973C2447dafFA8EFd3526da18076088de] + currentProfits/22;
576 			balances[selfAddress] = balances[selfAddress] - actualProfitSplit - currentProfits/22;
577 		}
578 	}
579 	
580 	/**
581 	 * @notice Split the unsold WBC of the ICO
582 	 * @dev 
583 			One time function to distribute the unsold tokens.
584 	 */
585     function ICOSplit() external isAdmin oneTime {
586         bytes memory empty;
587         uint i;
588         if (!isFrozen) {
589             require((relativeDateSave - now) >= (relativeDateSave - 150 days));
590             assetFreeze();
591             require(balances[selfAddress] > 50000000000000);
592             currentProfits = ((balances[selfAddress] - 50000000000000) / 10) * 7; 
593             amountInCirculation = safeSub(300000000000000, balances[selfAddress]);
594             currentIteration = 0;
595 			actualProfitSplit = 0;
596         } else {
597             for (i = currentIteration; i < users.length; i++) {
598                 if (msg.gas < 240000) {
599                     currentIteration = i;
600                     break;
601                 }
602                 balances[users[i]] += (balances[users[i]]*currentProfits)/amountInCirculation;
603 				actualProfitSplit += (balances[users[i]]*currentProfits)/amountInCirculation;
604                 if (i == users.length-1) {
605                     assetThaw();
606                     balances[selfAddress] = balances[selfAddress] - actualProfitSplit;
607 					hasICORun = true;
608                 }
609                 Transfer(selfAddress, users[i], (balances[users[i]]/amountInCirculation)*currentProfits, empty);
610             }
611         }
612     }
613 	
614 	/**
615 	 * @notice Sign that the DApp is ready
616 	 * @dev 
617 	        Only the core team members have access to this function. This is 
618 	        created as an extra layer of security for investors and users of 
619 			the coin, since a multi-signature approval is required before the 
620 			function that alters the Casino balance is used.
621 	 */
622     function assureDAppIsReady() external {
623         if (msg.sender == 0x166Cb48973C2447dafFA8EFd3526da18076088de) {
624             devApprovals[0] = true;
625         } else if (msg.sender == 0x1ab13D2C1AC4303737981Ce8B8bD5116C84c744d) {
626             devApprovals[1] = true;
627         } else if (msg.sender == 0xEC5a48d6F11F8a981aa3D913DA0A69194280cDBc) {
628             devApprovals[2] = true;
629         } else if (msg.sender == 0xE59CbD028f71447B804F31Cf0fC41F0e5E13f4bF) {
630             devApprovals[3] = true;
631         } else {
632 			revert();
633 		}
634     }
635 	
636 	/**
637      * @notice Verify that the DApp is ready
638 	 * @dev 
639 			Since iterating through the devApprovals array costs gas
640 			and the functions with the DAppOnline modifier are going
641 			to be repetitively used, it is better to store the DApp
642 			state in a variable that needs to be altered once.
643 	 */
644     function isDAppReady() external isAdmin {
645         uint8 numOfApprovals = 0;
646         for (uint i = 0; i < devApprovals.length; i++) {
647             if (devApprovals[i]) {
648                 numOfApprovals++;
649             }
650         }
651         DAppReady = (numOfApprovals>=2);
652     }
653     
654 	/**
655 	 * @notice Rise or lower user bank balance - Backend Function
656 	 * @dev 
657 	        This allows real-time adjustment of the balance a user has within the Casino to
658 			represent earnings and losses. Underflow impossible since only bets can lower the
659 			balance.
660 	 * @param _toAlter The address whose Casino balance to alter
661 	 * @param _amount The amount to alter it by
662 	 */
663     function alterBankBalance(address _toAlter, uint256 _amount, bool sign) external DAppOnline isAdmin {
664         if (sign && (_amount+allowed[selfAddress][_toAlter]) > allowed[selfAddress][_toAlter]) {
665 			allowed[selfAddress][_toAlter] = _amount + allowed[selfAddress][_toAlter];
666 			Approval(selfAddress, _toAlter, allowed[selfAddress][_toAlter]);
667         } else {
668             allowed[selfAddress][_toAlter] = safeSub(allowed[selfAddress][_toAlter], _amount);
669 			Approval(selfAddress, _toAlter, allowed[selfAddress][_toAlter]);
670         }
671     }
672     
673 	/**
674 	 * @notice Freeze user during platform use - Backend Function
675 	 * @dev Prevents against the ERC-20 race attack on the Casino
676 	 * @param _user The user to freeze
677 	 */
678     function loginUser(address _user) external DAppOnline isAdmin {
679         freezeUser[_user] = true;
680     }
681 	
682 	/**
683 	 * @notice De-Freeze user - Backend Function
684      * @dev Used when a user logs out or loses connection with the DApp
685 	 * @param _user The user to de-freeze
686 	 */
687 	function logoutUser(address _user) external DAppOnline isAdmin {
688 		freezeUser[_user] = false;
689 	}
690     
691     /**
692 	 * @notice Fallback function 
693 	 * @dev Triggered when Ether is sent to the contract. Throws intentionally to refund the sender.
694 	 */
695     function() payable {
696 		revert();
697     }
698 	
699 	/**
700 	 * @notice Purchase WBC Tokens for Address - ICO
701 	 * @param _recipient The recipient of the WBC tokens
702 	 */
703 	function buyTokensForAddress(address _recipient) external payable {
704         totalFunds = totalFunds + msg.value;
705         require(msg.value > 0);
706 		require(_recipient != admin);
707 		require((totalFunds/1 ether)*pricePerEther < 6000000000);
708         addUser(_recipient);
709         bytes memory empty;
710 		uint tokenAmount = calculateTokenAmount(msg.value);
711 		balances[selfAddress] = balances[selfAddress] - tokenAmount;
712 		assert(balances[selfAddress] >= 50000000000000);
713         balances[_recipient] = balances[_recipient] + tokenAmount;
714         Transfer(selfAddress, _recipient, tokenAmount, empty);
715         address etherTransfer = 0x166Cb48973C2447dafFA8EFd3526da18076088de;
716         etherTransfer.transfer(msg.value);
717     }
718 	
719 	/**
720 	 * @notice Purchase WBC Tokens for Self - ICO
721 	 */
722 	function buyTokensForSelf() external payable {
723         totalFunds = totalFunds + msg.value;
724 		address etherTransfer = 0x166Cb48973C2447dafFA8EFd3526da18076088de;
725         require(msg.value > 0);
726 		require(msg.sender != etherTransfer);
727 		require((totalFunds/1 ether)*pricePerEther < 6000000000);
728         addUser(msg.sender);
729         bytes memory empty;
730 		uint tokenAmount = calculateTokenAmount(msg.value);
731 		balances[selfAddress] = balances[selfAddress] - tokenAmount;
732 		assert(balances[selfAddress] >= 50000000000000);
733         balances[msg.sender] = balances[msg.sender] + tokenAmount;
734         Transfer(selfAddress, msg.sender, tokenAmount, empty);
735         etherTransfer.transfer(msg.value);
736     }
737 }