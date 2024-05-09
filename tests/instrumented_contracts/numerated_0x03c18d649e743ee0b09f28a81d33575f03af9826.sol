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
43     event Transfer(address indexed _from, address indexed _to, uint256 _value);
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
119         selfAddress = this;
120         balances[0x166Cb48973C2447dafFA8EFd3526da18076088de] = 22500000000000;
121         addUser(0x166Cb48973C2447dafFA8EFd3526da18076088de);
122         Transfer(selfAddress, 0x166Cb48973C2447dafFA8EFd3526da18076088de, 22500000000000);
123         balances[0xE59CbD028f71447B804F31Cf0fC41F0e5E13f4bF] = 15000000000000;
124         addUser(0xE59CbD028f71447B804F31Cf0fC41F0e5E13f4bF);
125         Transfer(selfAddress, 0xE59CbD028f71447B804F31Cf0fC41F0e5E13f4bF, 15000000000000);
126         balances[0x1ab13D2C1AC4303737981Ce8B8bD5116C84c744d] = 5000000000000;
127         addUser(0x1ab13D2C1AC4303737981Ce8B8bD5116C84c744d);
128         Transfer(selfAddress, 0x1ab13D2C1AC4303737981Ce8B8bD5116C84c744d, 5000000000000);
129         balances[0x06908Df389Cf2589375b6908D0b1c8FcC34721B5] = 2500000000000;
130         addUser(0x06908Df389Cf2589375b6908D0b1c8FcC34721B5);
131         Transfer(selfAddress, 0x06908Df389Cf2589375b6908D0b1c8FcC34721B5, 2500000000000);
132         balances[0xEdBd4c6757DC425321584a91bDB355Ce65c42b13] = 2500000000000;
133         addUser(0xEdBd4c6757DC425321584a91bDB355Ce65c42b13);
134         Transfer(selfAddress, 0xEdBd4c6757DC425321584a91bDB355Ce65c42b13, 2500000000000);
135         balances[0x4309Fb4B31aA667673d69db1072E6dcD50Fd8858] = 2500000000000;
136         addUser(0x4309Fb4B31aA667673d69db1072E6dcD50Fd8858);
137         Transfer(selfAddress, 0x4309Fb4B31aA667673d69db1072E6dcD50Fd8858, 2500000000000);
138         relativeDateSave = now + 180 days;
139         pricePerEther = 33209;
140         balances[selfAddress] = 250000000000000;
141     }
142     
143     /**
144      * @notice Check the name of the token ~ ERC-20 Standard
145      * @return {
146 					"_name": "The token name"
147 				}
148      */
149     function name() external constant returns (string _name) {
150         return name;
151     }
152     
153 	/**
154      * @notice Check the symbol of the token ~ ERC-20 Standard
155      * @return {
156 					"_symbol": "The token symbol"
157 				}
158      */
159     function symbol() external constant returns (string _symbol) {
160         return symbol;
161     }
162     
163     /**
164      * @notice Check the decimals of the token ~ ERC-20 Standard
165      * @return {
166 					"_decimals": "The token decimals"
167 				}
168      */
169     function decimals() external constant returns (uint8 _decimals) {
170         return decimals;
171     }
172     
173     /**
174      * @notice Check the total supply of the token ~ ERC-20 Standard
175      * @return {
176 					"_totalSupply": "Total supply of tokens"
177 				}
178      */
179     function totalSupply() external constant returns (uint256 _totalSupply) {
180         return totalSupply;
181     }
182     
183     /**
184      * @notice Query the available balance of an address ~ ERC-20 Standard
185 	 * @param _owner The address whose balance we wish to retrieve
186      * @return {
187 					"balance": "Balance of the address"
188 				}
189      */
190     function balanceOf(address _owner) external constant returns (uint256 balance) {
191         return balances[_owner];
192     }
193 	
194 	/**
195 	 * @notice Query the amount of tokens the spender address can withdraw from the owner address ~ ERC-20 Standard
196 	 * @param _owner The address who owns the tokens
197 	 * @param _spender The address who can withdraw the tokens
198 	 * @return {
199 					"remaining": "Remaining withdrawal amount"
200 				}
201      */
202     function allowance(address _owner, address _spender) external constant returns (uint256 remaining) {
203         return allowed[_owner][_spender];
204     }
205     
206     /**
207      * @notice Transfer tokens from an address to another ~ ERC-20 Standard
208 	 * @dev 
209 	        Adjusts the monthly limit in case the _from address is the Casino
210 	        and ensures that the user isn't logged in when retrieving funds
211 	        so as to prevent against a race attack with the Casino.
212      * @param _from The address whose balance we will transfer
213      * @param _to The recipient address
214 	 * @param _value The amount of tokens to be transferred
215      */
216     function transferFrom(address _from, address _to, uint256 _value) external requireThaw userNotPlaying(_to) {
217 		require(cooldown[_from][_to] <= now);
218         var _allowance = allowed[_from][_to];
219         if (_from == selfAddress) {
220             monthlyLimit[_to] = safeSub(monthlyLimit[_to], _value);
221         }
222         balances[_to] = balances[_to]+_value;
223         balances[_from] = safeSub(balances[_from], _value);
224         allowed[_from][_to] = safeSub(_allowance, _value);
225         addUser(_to);
226         Transfer(_from, _to, _value);
227     }
228     
229     /**
230 	 * @notice Authorize an address to retrieve funds from you ~ ERC-20 Standard
231 	 * @dev 
232 	        Each approval comes with a default cooldown of 30 minutes
233 	        to prevent against the ERC-20 race attack.
234 	 * @param _spender The address you wish to authorize
235 	 * @param _value The amount of tokens you wish to authorize
236 	 */
237     function approve(address _spender, uint256 _value) external {
238         allowed[msg.sender][_spender] = _value;
239 		cooldown[msg.sender][_spender] = now + 30 minutes;
240         Approval(msg.sender, _spender, _value);
241     }
242 	
243 	/**
244 	 * @notice Authorize an address to retrieve funds from you with a custom cooldown ~ ERC-20 Standard
245 	 * @dev Allowing custom cooldown for the ERC-20 race attack prevention.
246 	 * @param _spender The address you wish to authorize
247 	 * @param _value The amount of tokens you wish to authorize
248 	 * @param _cooldown The amount of seconds the recipient needs to wait before withdrawing the balance
249 	 */
250     function approve(address _spender, uint256 _value, uint256 _cooldown) external {
251         allowed[msg.sender][_spender] = _value;
252 		cooldown[msg.sender][_spender] = now + _cooldown;
253         Approval(msg.sender, _spender, _value);
254     }
255     
256     /**
257 	 * @notice Transfer the specified amount to the target address ~ ERC-20 Standard
258 	 * @dev 
259 	        A boolean is returned so that callers of the function 
260 	        will know if their transaction went through.
261 	 * @param _to The address you wish to send the tokens to
262 	 * @param _value The amount of tokens you wish to send
263 	 * @return {
264 					"success": "Transaction success"
265 				}
266      */
267     function transfer(address _to, uint256 _value) external isRunning requireThaw returns (bool success){
268         bytes memory empty;
269         if (_to == selfAddress) {
270             return transferToSelf(_value, empty);
271         } else if (isContract(_to)) {
272             return transferToContract(_to, _value, empty);
273         } else {
274             return transferToAddress(_to, _value, empty);
275         }
276     }
277     
278     /**
279 	 * @notice Check whether address is a contract ~ ERC-223 Proposed Standard
280 	 * @param _address The address to check
281 	 * @return {
282 					"is_contract": "Result of query"
283 				}
284      */
285     function isContract(address _address) internal returns (bool is_contract) {
286         uint length;
287         assembly {
288             length := extcodesize(_address)
289         }
290         return length > 0;
291     }
292     
293     /**
294 	 * @notice Transfer the specified amount to the target address with embedded bytes data ~ ERC-223 Proposed Standard
295 	 * @dev Includes an extra transferToSelf function to handle Casino deposits
296 	 * @param _to The address to transfer to
297 	 * @param _value The amount of tokens to transfer
298 	 * @param _data Any extra embedded data of the transaction
299 	 * @return {
300 					"success": "Transaction success"
301 				}
302      */
303     function transfer(address _to, uint256 _value, bytes _data) external isRunning requireThaw returns (bool success){
304         if (_to == selfAddress) {
305             return transferToSelf(_value, _data);
306         } else if (isContract(_to)) {
307             return transferToContract(_to, _value, _data);
308         } else {
309             return transferToAddress(_to, _value, _data);
310         }
311     }
312     
313     /**
314 	 * @notice Handles transfer to an ECA (Externally Controlled Account), a normal account ~ ERC-223 Proposed Standard
315 	 * @param _to The address to transfer to
316 	 * @param _value The amount of tokens to transfer
317 	 * @param _data Any extra embedded data of the transaction
318 	 * @return {
319 					"success": "Transaction success"
320 				}
321      */
322     function transferToAddress(address _to, uint256 _value, bytes _data) internal returns (bool success) {
323         balances[msg.sender] = safeSub(balances[msg.sender], _value);
324         balances[_to] = balances[_to]+_value;
325         addUser(_to);
326         Transfer(msg.sender, _to, _value);
327         return true;
328     }
329     
330     /**
331 	 * @notice Handles transfer to a contract ~ ERC-223 Proposed Standard
332 	 * @param _to The address to transfer to
333 	 * @param _value The amount of tokens to transfer
334 	 * @param _data Any extra embedded data of the transaction
335 	 * @return {
336 					"success": "Transaction success"
337 				}
338      */
339     function transferToContract(address _to, uint256 _value, bytes _data) internal returns (bool success) {
340         balances[msg.sender] = safeSub(balances[msg.sender], _value);
341         balances[_to] = balances[_to]+_value;
342         WeBetCrypto rec = WeBetCrypto(_to);
343         rec.tokenFallback(msg.sender, _value, _data);
344         addUser(_to);
345         Transfer(msg.sender, _to, _value);
346         return true;
347     }
348     
349     /**
350 	 * @notice Handles Casino deposits ~ Custom ERC-223 Proposed Standard Addition
351 	 * @param _value The amount of tokens to transfer
352 	 * @param _data Any extra embedded data of the transaction
353 	 * @return {
354 					"success": "Transaction success"
355 				}
356      */
357     function transferToSelf(uint256 _value, bytes _data) internal returns (bool success) {
358         balances[msg.sender] = safeSub(balances[msg.sender], _value);
359         balances[selfAddress] = balances[selfAddress]+_value;
360         Transfer(msg.sender, selfAddress, _value);
361 		allowed[selfAddress][msg.sender] = _value + allowed[selfAddress][msg.sender];
362 		Approval(selfAddress, msg.sender, allowed[selfAddress][msg.sender]);
363         return true;
364     }
365 	
366 	/**
367 	 * @notice Empty tokenFallback method to ensure ERC-223 compatibility
368 	 * @param _sender The address who sent the ERC-223 tokens
369 	 * @param _value The amount of tokens the address sent to this contract
370 	 * @param _data Any embedded data of the transaction
371 	 */
372 	function tokenFallback(address _sender, uint256 _value, bytes _data) {}
373 	
374 	/**
375 	 * @notice Check the cooldown remaining until the allowee can withdraw the balance
376 	 * @param _allower The holder of the balance
377 	 * @param _allowee The recipient of the balance
378 	 * @return {
379 					"remaining": "Cooldown remaining in seconds"
380 				}
381      */
382 	function checkCooldown(address _allower, address _allowee) external constant returns (uint256 remaining) {
383 		if (cooldown[_allower][_allowee] > now) {
384 			return (cooldown[_allower][_allowee] - now);
385 		} else {
386 			return 0;
387 		}
388 	}
389 	
390 	/**
391 	 * @notice Check how much Casino withdrawal balance remains for address
392 	 * @param _owner The address to check
393 	 * @return {
394 					"remaining": "Withdrawal balance remaining"
395 				}
396      */
397     function checkMonthlyLimit(address _owner) external constant returns (uint256 remaining) {
398         return monthlyLimit[_owner];
399     }
400 	
401 	/**
402 	 * @notice Retrieve ERC Tokens sent to contract
403 	 * @dev Feel free to contact us and retrieve your ERC tokens should you wish so.
404 	 * @param _token The token contract address
405 	 */
406     function claimTokens(address _token) isAdmin external { 
407 		require(_token != selfAddress);
408         WeBetCrypto token = WeBetCrypto(_token); 
409         uint balance = token.balanceOf(selfAddress); 
410         token.transfer(admin, balance); 
411     }
412     
413 	/**
414 	 * @notice Freeze token circulation - splitProfits internal
415 	 * @dev 
416 	        Ensures that one doesn't transfer his total balance mid-split to 
417 	        an account later in the split queue in order to receive twice the
418 	        monthly profits
419 	 */
420     function assetFreeze() internal {
421         isFrozen = true;
422     }
423     
424 	/**
425 	 * @notice Re-enable token circulation - splitProfits internal
426 	 */
427     function assetThaw() internal {
428         isFrozen = false;
429     }
430     
431 	/**
432 	 * @notice Freeze token circulation
433 	 * @dev To be used only in extreme circumstances.
434 	 */
435     function emergencyFreeze() isAdmin external {
436         isFrozen = true;
437     }
438     
439 	/**
440 	 * @notice Re-enable token circulation
441 	 * @dev To be used only in extreme circumstances
442 	 */
443     function emergencyThaw() isAdmin external {
444         isFrozen = false;
445     }
446 	
447 	/**
448 	 * @notice Disable the splitting function
449 	 * @dev 
450 	        To be used in case the system is upgraded to a 
451 	        node.js operated profit reward system via the 
452 			alterBankBalance function. Ensures scalability 
453 			in case userbase gets too big.
454 	 */
455 	function emergencySplitToggle() isAdmin external {
456 		splitInService = !splitInService;
457 	}
458     
459 	/**
460 	 * @notice Adjust the price of Ether according to Coin Market Cap's API
461 	 * @dev 
462 	        The subfolder is public domain so anyone can verify that we indeed got the price
463 	        from a trusted source at the time we updated it. 2 decimal precision is achieved
464 	        by multiplying the price of Ether by 100 and then offsetting the multiplication
465 	        in the calculation the price is used in. The TLSNotaryProof string can be added
466 	        to the end of https://webetcrypto.io/TLSNotary/ to get the perspective TLS proof.
467 	 * @param newPrice The new Ethereum price with 2 decimal precision
468 	 * @param TLSNotaryProof The webetcrypto.io subfolder the TLSNotary proof is stored
469 	 */
470     function setPriceOfEther(uint256 newPrice, string TLSNotaryProof) external isAdmin {
471         pricePerEther = newPrice;
472         CurrentTLSNProof(selfAddress, TLSNotaryProof);
473     }
474 	
475 	/**
476 	 * @notice Get the current 2-decimal precision price per token
477 	 * @dev 
478 	        The price retains the 2 decimal precision by multiplying it with
479 	        100 and offsetting that in the calculations the price is used in.
480 	        For example 50 means each token costs 0.50$.
481 	 * @return {
482 					"price": "Price of a single WBC Token"
483 				}
484      */
485 	function getPricePerToken() public constant returns (uint256 price) {
486         if (balances[selfAddress] > 200000000000000) {
487             return 50;
488         } else if (balances[selfAddress] > 150000000000000) {
489 			return 200;
490 		} else if (balances[selfAddress] > 100000000000000) {
491 			return 400;
492 		} else {
493 			return 550;
494         }
495     }
496 	
497 	/**
498 	 * @notice Convert Wei to WBC tokens
499 	 * @dev 
500 		    The _value is multiplied by 10^7 because of the 7 decimal precision
501 			of WBC and to ensure that a user can invest less than 1 ether and 
502 			still get his WBC tokens, preventing rounding errors. A hard cap
503 			of 500k WBC tokens per purchase is enforced so as to prevent users
504 			from buying large amounts at a higher or lower Ether price due to 
505 			hourly price updates.
506 	 * @param _value The amount of Wei to convert
507 	 * @return {
508 					"tokenAmount": "Amount of WBC Tokens input is worth"
509 				}
510      */
511 	function calculateTokenAmount(uint256 _value) internal returns (uint256 tokenAmount) {
512 		tokenAmount = ((_value*(10**7)/1 ether)*pricePerEther)/getPricePerToken();
513 		assert(tokenAmount <= 5000000000000);
514 	}
515 	
516 	/**
517 	 * @notice Add the address to the user list 
518 	 * @dev Used for the splitting function to take it into account
519 	 * @param _user User to add to database
520 	 */
521 	function addUser(address _user) internal {
522 		if (!isAdded[_user]) {
523             users.push(_user);
524             monthlyLimit[_user] = 5000000000000;
525             isAdded[_user] = true;
526         }
527 	}
528     
529 	/**
530 	 * @notice Split the monthly profits of the Casino to the users
531 	 * @dev 
532 			The formula that calculates the profit a user is owed can be seen on 
533 			the white paper. The actualProfitSplit variable stores the actual values
534 	   		that are distributed to the users to prevent rounding errors from burning 
535 			tokens. Since gas requirements will spike the more users use our platform,
536 			a loop-state-save is implemented to ensure scalability.
537 	 */
538     function splitProfits() external {
539 		require(splitInService);
540         uint i;
541         if (!isFrozen) {
542             require(now >= relativeDateSave);
543             assetFreeze();
544             require(balances[selfAddress] > 30000000000000);
545             relativeDateSave = now + 30 days;
546             currentProfits = ((balances[selfAddress]-30000000000000)/10)*7; 
547             amountInCirculation = safeSub(300000000000000, balances[selfAddress]);
548             currentIteration = 0;
549 			actualProfitSplit = 0;
550         } else {
551             for (i = currentIteration; i < users.length; i++) {
552                 monthlyLimit[users[i]] = 5000000000000;
553                 if (msg.gas < 240000) {
554                     currentIteration = i;
555                     break;
556                 }
557 				if (allowed[selfAddress][users[i]] == 0) {
558 					checkSplitEnd(i);
559 					continue;
560 				} else if ((balances[users[i]]/allowed[selfAddress][users[i]]) < 19) {
561 					checkSplitEnd(i);
562                     continue;
563                 }
564 				actualProfitSplit += (balances[users[i]]*currentProfits)/amountInCirculation;
565                 balances[users[i]] += (balances[users[i]]*currentProfits)/amountInCirculation;
566 				checkSplitEnd(i);
567                 Transfer(selfAddress, users[i], (balances[users[i]]/amountInCirculation)*currentProfits);
568             }
569         }
570     }
571 	
572 	/**
573 	 * @notice Change variables on split end
574 	 * @param i The current index of the split loop
575 	 */
576 	function checkSplitEnd(uint256 i) internal {
577 		if (i == users.length-1) {
578 			assetThaw();
579 			balances[0x166Cb48973C2447dafFA8EFd3526da18076088de] = balances[0x166Cb48973C2447dafFA8EFd3526da18076088de] + currentProfits/22;
580 			balances[selfAddress] = balances[selfAddress] - actualProfitSplit - currentProfits/22;
581 		}
582 	}
583 	
584 	/**
585 	 * @notice Split the unsold WBC of the ICO
586 	 * @dev 
587 			One time function to distribute the unsold tokens.
588 	 */
589     function ICOSplit() external isAdmin oneTime {
590         uint i;
591         if (!isFrozen) {
592             require((relativeDateSave - now) >= (relativeDateSave - 150 days));
593             assetFreeze();
594             require(balances[selfAddress] > 50000000000000);
595             currentProfits = ((balances[selfAddress] - 50000000000000) / 10) * 7; 
596             amountInCirculation = safeSub(300000000000000, balances[selfAddress]);
597             currentIteration = 0;
598 			actualProfitSplit = 0;
599         } else {
600             for (i = currentIteration; i < users.length; i++) {
601                 if (msg.gas < 240000) {
602                     currentIteration = i;
603                     break;
604                 }
605 				actualProfitSplit += (balances[users[i]]*currentProfits)/amountInCirculation;
606                 balances[users[i]] += (balances[users[i]]*currentProfits)/amountInCirculation;
607                 if (i == users.length-1) {
608                     assetThaw();
609                     balances[selfAddress] = balances[selfAddress] - actualProfitSplit;
610 					hasICORun = true;
611                 }
612                 Transfer(selfAddress, users[i], (balances[users[i]]/amountInCirculation)*currentProfits);
613             }
614         }
615     }
616 	
617 	/**
618 	 * @notice Sign that the DApp is ready
619 	 * @dev 
620 	        Only the core team members have access to this function. This is 
621 	        created as an extra layer of security for investors and users of 
622 			the coin, since a multi-signature approval is required before the 
623 			function that alters the Casino balance is used.
624 	 */
625     function assureDAppIsReady() external {
626         if (msg.sender == 0x166Cb48973C2447dafFA8EFd3526da18076088de) {
627             devApprovals[0] = true;
628         } else if (msg.sender == 0x1ab13D2C1AC4303737981Ce8B8bD5116C84c744d) {
629             devApprovals[1] = true;
630         } else if (msg.sender == 0xEC5a48d6F11F8a981aa3D913DA0A69194280cDBc) {
631             devApprovals[2] = true;
632         } else if (msg.sender == 0xE59CbD028f71447B804F31Cf0fC41F0e5E13f4bF) {
633             devApprovals[3] = true;
634         } else {
635 			revert();
636 		}
637     }
638 	
639 	/**
640      * @notice Verify that the DApp is ready
641 	 * @dev 
642 			Since iterating through the devApprovals array costs gas
643 			and the functions with the DAppOnline modifier are going
644 			to be repetitively used, it is better to store the DApp
645 			state in a variable that needs to be altered once.
646 	 */
647     function isDAppReady() external isAdmin {
648         uint8 numOfApprovals = 0;
649         for (uint i = 0; i < devApprovals.length; i++) {
650             if (devApprovals[i]) {
651                 numOfApprovals++;
652             }
653         }
654         DAppReady = (numOfApprovals>=2);
655     }
656     
657 	/**
658 	 * @notice Rise or lower user bank balance - Backend Function
659 	 * @dev 
660 	        This allows real-time adjustment of the balance a user has within the Casino to
661 			represent earnings and losses. Underflow impossible since only bets can lower the
662 			balance.
663 	 * @param _toAlter The address whose Casino balance to alter
664 	 * @param _amount The amount to alter it by
665 	 */
666     function alterBankBalance(address _toAlter, uint256 _amount, bool sign) external DAppOnline isAdmin {
667         if (sign && (_amount+allowed[selfAddress][_toAlter]) > allowed[selfAddress][_toAlter]) {
668 			allowed[selfAddress][_toAlter] = _amount + allowed[selfAddress][_toAlter];
669 			Approval(selfAddress, _toAlter, allowed[selfAddress][_toAlter]);
670         } else {
671             allowed[selfAddress][_toAlter] = safeSub(allowed[selfAddress][_toAlter], _amount);
672 			Approval(selfAddress, _toAlter, allowed[selfAddress][_toAlter]);
673         }
674     }
675     
676 	/**
677 	 * @notice Freeze user during platform use - Backend Function
678 	 * @dev Prevents against the ERC-20 race attack on the Casino
679 	 * @param _user The user to freeze
680 	 */
681     function loginUser(address _user) external DAppOnline isAdmin {
682         freezeUser[_user] = true;
683     }
684 	
685 	/**
686 	 * @notice De-Freeze user - Backend Function
687      * @dev Used when a user logs out or loses connection with the DApp
688 	 * @param _user The user to de-freeze
689 	 */
690 	function logoutUser(address _user) external DAppOnline isAdmin {
691 		freezeUser[_user] = false;
692 	}
693     
694     /**
695 	 * @notice Fallback function 
696 	 * @dev Triggered when Ether is sent to the contract. Throws intentionally to refund the sender.
697 	 */
698     function() payable {
699 		revert();
700     }
701 	
702 	/**
703 	 * @notice Purchase WBC Tokens for Address - ICO
704 	 * @param _recipient The recipient of the WBC tokens
705 	 */
706 	function buyTokensForAddress(address _recipient) external payable {
707         totalFunds = totalFunds + msg.value;
708         require(msg.value > 0);
709 		require(_recipient != admin);
710 		require((totalFunds/1 ether)*pricePerEther < 6000000000);
711         addUser(_recipient);
712 		uint tokenAmount = calculateTokenAmount(msg.value);
713 		balances[selfAddress] = balances[selfAddress] - tokenAmount;
714 		assert(balances[selfAddress] >= 50000000000000);
715         balances[_recipient] = balances[_recipient] + tokenAmount;
716         Transfer(selfAddress, _recipient, tokenAmount);
717         address etherTransfer = 0x166Cb48973C2447dafFA8EFd3526da18076088de;
718         etherTransfer.transfer(msg.value);
719     }
720 	
721 	/**
722 	 * @notice Purchase WBC Tokens for Self - ICO
723 	 */
724 	function buyTokensForSelf() external payable {
725         totalFunds = totalFunds + msg.value;
726 		address etherTransfer = 0x166Cb48973C2447dafFA8EFd3526da18076088de;
727         require(msg.value > 0);
728 		require(msg.sender != etherTransfer);
729 		require((totalFunds/1 ether)*pricePerEther < 6000000000);
730         addUser(msg.sender);
731 		uint tokenAmount = calculateTokenAmount(msg.value);
732 		balances[selfAddress] = balances[selfAddress] - tokenAmount;
733 		assert(balances[selfAddress] >= 50000000000000);
734         balances[msg.sender] = balances[msg.sender] + tokenAmount;
735         Transfer(selfAddress, msg.sender, tokenAmount);
736         etherTransfer.transfer(msg.value);
737     }
738 }