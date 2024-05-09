1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title WeBetCrypto
6  * @author AL_X
7  * @dev The WBC ERC-223 Token Contract
8  */
9 contract WeBetCrypto {
10     string public name = "We Bet Crypto";
11     string public symbol = "WBA";
12 	
13     address public selfAddress;
14     address public admin;
15     address[] private users;
16 	
17     uint8 public decimals = 7;
18     uint256 public relativeDateSave;
19     uint256 public totalFunds;
20     uint256 public totalSupply = 400000000000000;
21     uint256 public IOUSupply = 0;
22     uint256 private amountInCirculation;
23     uint256 private currentProfits;
24     uint256 private currentIteration;
25 	uint256 private actualProfitSplit;
26 	
27     bool public isFrozen;
28     bool private running;
29 	
30     mapping(address => uint256) balances;
31     mapping(address => uint256) moneySpent;
32     mapping(address => uint256) monthlyLimit;
33 	mapping(address => uint256) cooldown;
34 	
35     mapping(address => bool) isAdded;
36     mapping(address => bool) claimedBonus;
37 	mapping(address => bool) bannedUser;
38     //mapping(address => bool) loggedUser;
39 	
40     mapping (address => mapping (address => uint256)) allowed;
41 	
42     event Transfer(address indexed _from, address indexed _to, uint256 _value);
43     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
44     
45 	/**
46 	 * @notice Ensures admin is caller
47 	 */
48     modifier isAdmin() {
49         require(msg.sender == admin);
50         //Continue executing rest of method body
51         _;
52     }
53     
54     /**
55 	 * @notice Re-entry protection
56 	 */
57     modifier isRunning() {
58         require(!running);
59         running = true;
60         _;
61         running = false;
62     }
63     
64 	/**
65 	 * @notice Ensures system isn't frozen
66 	 */
67     modifier noFreeze() {
68         require(!isFrozen);
69         _;
70     }
71     
72 	/**
73 	 * @notice Ensures player isn't logged in on platform
74 	 */
75     modifier userNotPlaying(address _user) {
76         //require(!loggedUser[_user]);
77         uint256 check = 0;
78         check -= 1;
79         require(cooldown[_user] == check);
80         _;
81     }
82     
83     /**
84      * @notice Ensures player isn't bannedUser
85      */
86     modifier userNotBanned(address _user) {
87         require(!bannedUser[_user]);
88         _;
89     }
90     
91     /**
92 	 * @notice SafeMath Library safeSub Import
93 	 * @dev 
94 	        Since we are dealing with a limited currency
95 	        circulation of 40 million tokens and values
96 	        that will not surpass the uint256 limit, only
97 	        safeSub is required to prevent underflows.
98 	 */
99     function safeSub(uint256 a, uint256 b) internal pure returns (uint256 z) {
100         assert((z = a - b) <= a);
101     }
102 	
103 	/**
104 	 * @notice WBC Constructor
105 	 * @dev 
106 	        Constructor function containing proper initializations such as 
107 	        token distribution to the team members and pushing the first 
108 	        profit split to 6 months when the DApp will already be live.
109 	 */
110     function WeBetCrypto() public {
111         admin = msg.sender;
112         selfAddress = this;
113         balances[0x66AE070A8501E816CA95ac99c4E15C7e132fd289] = 200000000000000;
114         addUser(0x66AE070A8501E816CA95ac99c4E15C7e132fd289);
115         Transfer(selfAddress, 0x66AE070A8501E816CA95ac99c4E15C7e132fd289, 200000000000000);
116         balances[0xcf8d242C523bfaDC384Cc1eFF852Bf299396B22D] = 50000000000000;
117         addUser(0xcf8d242C523bfaDC384Cc1eFF852Bf299396B22D);
118         Transfer(selfAddress, 0xcf8d242C523bfaDC384Cc1eFF852Bf299396B22D, 50000000000000);
119         relativeDateSave = now + 40 days;
120         balances[selfAddress] = 150000000000000;
121     }
122     
123     /**
124      * @notice Check the name of the token ~ ERC-20 Standard
125      * @return {
126 					"_name": "The token name"
127 				}
128      */
129     function name() external constant returns (string _name) {
130         return name;
131     }
132     
133 	/**
134      * @notice Check the symbol of the token ~ ERC-20 Standard
135      * @return {
136 					"_symbol": "The token symbol"
137 				}
138      */
139     function symbol() external constant returns (string _symbol) {
140         return symbol;
141     }
142     
143     /**
144      * @notice Check the decimals of the token ~ ERC-20 Standard
145      * @return {
146 					"_decimals": "The token decimals"
147 				}
148      */
149     function decimals() external constant returns (uint8 _decimals) {
150         return decimals;
151     }
152     
153     /**
154      * @notice Check the total supply of the token ~ ERC-20 Standard
155      * @return {
156 					"_totalSupply": "Total supply of tokens"
157 				}
158      */
159     function totalSupply() external constant returns (uint256 _totalSupply) {
160         return totalSupply;
161     }
162     
163     /**
164      * @notice Query the available balance of an address ~ ERC-20 Standard
165 	 * @param _owner The address whose balance we wish to retrieve
166      * @return {
167 					"balance": "Balance of the address"
168 				}
169      */
170     function balanceOf(address _owner) external constant returns (uint256 balance) {
171         return balances[_owner];
172     }
173 	
174 	/**
175 	 * @notice Query the amount of tokens the spender address can withdraw from the owner address ~ ERC-20 Standard
176 	 * @param _owner The address who owns the tokens
177 	 * @param _spender The address who can withdraw the tokens
178 	 * @return {
179 					"remaining": "Remaining withdrawal amount"
180 				}
181      */
182     function allowance(address _owner, address _spender) external constant returns (uint256 remaining) {
183         return allowed[_owner][_spender];
184     }
185     
186     /**
187      * @notice Query whether the user is eligible for claiming dividence
188      * @param _user The address to query
189      * @return _success Whether or not the user is eligible
190      */
191     function eligibleForDividence(address _user) public view returns (bool _success) {
192         if (moneySpent[_user] == 0) {
193             return false;
194 		} else if ((balances[_user] + allowed[selfAddress][_user])/moneySpent[_user] > 20) {
195 		    return false;
196         }
197         return true;
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
210     function transferFrom(address _from, address _to, uint256 _value) external noFreeze {
211         var _allowance = allowed[_from][_to];
212         if (_from == selfAddress) {
213             monthlyLimit[_to] = safeSub(monthlyLimit[_to], _value);
214             require(cooldown[_to] < now /*&& !loggedUser[_to]*/);
215             IOUSupply -= _value;
216         }
217         balances[_to] = balances[_to]+_value;
218         balances[_from] = safeSub(balances[_from], _value);
219         allowed[_from][_to] = safeSub(_allowance, _value);
220         addUser(_to);
221         Transfer(_from, _to, _value);
222     }
223     
224     /**
225 	 * @notice Authorize an address to retrieve funds from you ~ ERC-20 Standard
226 	 * @dev 
227 	        30 minute cooldown removed for easier participation in
228 	        trading platforms such as Ether Delta
229 	 * @param _spender The address you wish to authorize
230 	 * @param _value The amount of tokens you wish to authorize
231 	 */
232     function approve(address _spender, uint256 _value) external {
233         allowed[msg.sender][_spender] = _value;
234         Approval(msg.sender, _spender, _value);
235     }
236     
237     /**
238 	 * @notice Transfer the specified amount to the target address ~ ERC-20 Standard
239 	 * @dev 
240 	        A boolean is returned so that callers of the function 
241 	        will know if their transaction went through.
242 	 * @param _to The address you wish to send the tokens to
243 	 * @param _value The amount of tokens you wish to send
244 	 * @return {
245 					"success": "Transaction success"
246 				}
247      */
248     function transfer(address _to, uint256 _value) external isRunning noFreeze returns (bool success) {
249         bytes memory empty;
250         if (_to == selfAddress) {
251             return transferToSelf(_value);
252         } else if (isContract(_to)) {
253             return transferToContract(_to, _value, empty);
254         } else {
255             return transferToAddress(_to, _value);
256         }
257     }
258     
259     /**
260 	 * @notice Check whether address is a contract ~ ERC-223 Proposed Standard
261 	 * @param _address The address to check
262 	 * @return {
263 					"is_contract": "Result of query"
264 				}
265      */
266     function isContract(address _address) internal view returns (bool is_contract) {
267         uint length;
268         assembly {
269             length := extcodesize(_address)
270         }
271         return length > 0;
272     }
273     
274     /**
275 	 * @notice Transfer the specified amount to the target address with embedded bytes data ~ ERC-223 Proposed Standard
276 	 * @dev Includes an extra transferToSelf function to handle Casino deposits
277 	 * @param _to The address to transfer to
278 	 * @param _value The amount of tokens to transfer
279 	 * @param _data Any extra embedded data of the transaction
280 	 * @return {
281 					"success": "Transaction success"
282 				}
283      */
284     function transfer(address _to, uint256 _value, bytes _data) external isRunning noFreeze returns (bool success){
285         if (_to == selfAddress) {
286             return transferToSelf(_value);
287         } else if (isContract(_to)) {
288             return transferToContract(_to, _value, _data);
289         } else {
290             return transferToAddress(_to, _value);
291         }
292     }
293     
294     /**
295 	 * @notice Handles transfer to an ECA (Externally Controlled Account), a normal account ~ ERC-223 Proposed Standard
296 	 * @param _to The address to transfer to
297 	 * @param _value The amount of tokens to transfer
298 	 * @return {
299 					"success": "Transaction success"
300 				}
301      */
302     function transferToAddress(address _to, uint256 _value) internal returns (bool success) {
303         balances[msg.sender] = safeSub(balances[msg.sender], _value);
304         balances[_to] = balances[_to]+_value;
305         addUser(_to);
306         Transfer(msg.sender, _to, _value);
307         return true;
308     }
309     
310     /**
311 	 * @notice Handles transfer to a contract ~ ERC-223 Proposed Standard
312 	 * @param _to The address to transfer to
313 	 * @param _value The amount of tokens to transfer
314 	 * @param _data Any extra embedded data of the transaction
315 	 * @return {
316 					"success": "Transaction success"
317 				}
318      */
319     function transferToContract(address _to, uint256 _value, bytes _data) internal returns (bool success) {
320         balances[msg.sender] = safeSub(balances[msg.sender], _value);
321         balances[_to] = balances[_to]+_value;
322         WeBetCrypto rec = WeBetCrypto(_to);
323         rec.tokenFallback(msg.sender, _value, _data);
324         addUser(_to);
325         Transfer(msg.sender, _to, _value);
326         return true;
327     }
328     
329     /**
330 	 * @notice Handles Casino deposits ~ Custom ERC-223 Proposed Standard Addition
331 	 * @param _value The amount of tokens to transfer
332 	 * @return {
333 					"success": "Transaction success"
334 				}
335      */
336     function transferToSelf(uint256 _value) internal returns (bool success) {
337         balances[msg.sender] = safeSub(balances[msg.sender], _value);
338         balances[selfAddress] = balances[selfAddress]+_value;
339         Transfer(msg.sender, selfAddress, _value);
340 		allowed[selfAddress][msg.sender] = _value + allowed[selfAddress][msg.sender];
341 		IOUSupply += _value;
342 		Approval(selfAddress, msg.sender, allowed[selfAddress][msg.sender]);
343         return true;
344     }
345 	
346 	/**
347 	 * @notice Empty tokenFallback method to ensure ERC-223 compatibility
348 	 * @param _sender The address who sent the ERC-223 tokens
349 	 * @param _value The amount of tokens the address sent to this contract
350 	 * @param _data Any embedded data of the transaction
351 	 */
352 	function tokenFallback(address _sender, uint256 _value, bytes _data) public {}
353 	
354 	/**
355 	 * @notice Check how much Casino withdrawal balance remains for address
356 	 * @return {
357 					"remaining": "Withdrawal balance remaining"
358 				}
359      */
360     function checkMonthlyLimit() external constant returns (uint256 remaining) {
361         return monthlyLimit[msg.sender];
362     }
363 	
364 	/**
365 	 * @notice Retrieve ERC Tokens sent to contract
366 	 * @dev Feel free to contact us and retrieve your ERC tokens should you wish so.
367 	 * @param _token The token contract address
368 	 */
369     function claimTokens(address _token) isAdmin external { 
370 		require(_token != selfAddress);
371         WeBetCrypto token = WeBetCrypto(_token); 
372         uint balance = token.balanceOf(selfAddress); 
373         token.transfer(admin, balance); 
374     }
375     
376 	/**
377 	 * @notice Freeze token circulation - splitProfits internal
378 	 * @dev 
379 	        Ensures that one doesn't transfer his total balance mid-split to 
380 	        an account later in the split queue in order to receive twice the
381 	        monthly profits
382 	 */
383     function assetFreeze() internal {
384         isFrozen = true;
385     }
386     
387 	/**
388 	 * @notice Re-enable token circulation - splitProfits internal
389 	 */
390     function assetThaw() internal {
391         isFrozen = false;
392     }
393     
394 	/**
395 	 * @notice Freeze token circulation
396 	 * @dev To be used only in extreme circumstances.
397 	 */
398     function emergencyFreeze() isAdmin external {
399         isFrozen = true;
400     }
401     
402 	/**
403 	 * @notice Re-enable token circulation
404 	 * @dev To be used only in extreme circumstances
405 	 */
406     function emergencyThaw() isAdmin external {
407         isFrozen = false;
408     }
409 	
410 	/**
411 	 * @notice Disable the splitting function
412 	 * @dev 
413 	        To be used in case the system is upgraded to a 
414 	        node.js operated profit reward system via the 
415 			alterBankBalance function. Ensures scalability 
416 			in case userbase gets too big.
417 	 */
418 	function emergencySplitToggle() isAdmin external {
419 		uint temp = 0;
420 		temp -= 1;
421 		if (relativeDateSave == temp) {
422 		    relativeDateSave = now;
423 		} else {
424 	    	relativeDateSave = temp;
425 		}
426 	}
427 	
428 	/**
429 	 * @notice Add the address to the user list 
430 	 * @dev Used for the splitting function to take it into account
431 	 * @param _user User to add to database
432 	 */
433 	function addUser(address _user) internal {
434 		if (!isAdded[_user]) {
435             users.push(_user);
436             monthlyLimit[_user] = 1000000000000;
437             isAdded[_user] = true;
438         }
439 	}
440     
441 	/**
442 	 * @notice Split the monthly profits of the Casino to the users
443 	 * @dev 
444 			The formula that calculates the profit a user is owed can be seen on 
445 			the white paper. The actualProfitSplit variable stores the actual values
446 	   		that are distributed to the users to prevent rounding errors from burning 
447 			tokens. Since gas requirements will spike the more users use our platform,
448 			a loop-state-save is implemented to ensure scalability.
449 	 */
450     function splitProfits() external {
451         uint i;
452         if (!isFrozen) {
453             require(now >= relativeDateSave);
454             assetFreeze();
455             require(balances[selfAddress] > 30000000000000);
456             relativeDateSave = now + 30 days;
457             currentProfits = ((balances[selfAddress]-30000000000000)/10)*7; 
458             amountInCirculation = safeSub(400000000000000, balances[selfAddress]) + IOUSupply;
459             currentIteration = 0;
460 			actualProfitSplit = 0;
461         } else {
462             for (i = currentIteration; i < users.length; i++) {
463                 monthlyLimit[users[i]] = 1000000000000;
464                 if (msg.gas < 250000) {
465                     currentIteration = i;
466                     break;
467                 }
468 				if (!eligibleForDividence(users[i])) {
469 				    moneySpent[users[i]] = 0;
470         			checkSplitEnd(i);
471                     continue;
472 				}
473 				moneySpent[users[i]] = 0;
474 				actualProfitSplit += ((balances[users[i]]+allowed[selfAddress][users[i]])*currentProfits)/amountInCirculation;
475                 Transfer(selfAddress, users[i], ((balances[users[i]]+allowed[selfAddress][users[i]])*currentProfits)/amountInCirculation);
476                 balances[users[i]] += ((balances[users[i]]+allowed[selfAddress][users[i]])*currentProfits)/amountInCirculation;
477 				checkSplitEnd(i);
478             }
479         }
480     }
481 	
482 	/**
483 	 * @notice Change variables on split end
484 	 * @param i The current index of the split loop.
485 	 */
486 	function checkSplitEnd(uint256 i) internal {
487 		if (i == users.length-1) {
488 			assetThaw();
489 			balances[0x66AE070A8501E816CA95ac99c4E15C7e132fd289] = balances[0x66AE070A8501E816CA95ac99c4E15C7e132fd289] + currentProfits/20;
490 			balances[selfAddress] = balances[selfAddress] - actualProfitSplit - currentProfits/20;
491 		}
492 	}
493     
494 	/**
495 	 * @notice Rise or lower user bank balance - Backend Function
496 	 * @dev 
497 	        This allows adjustment of the balance a user has within the Casino to
498 			represent earnings and losses.
499 	 * @param _toAlter The address whose Casino balance to alter
500 	 * @param _amount The amount to alter it by
501 	 */
502     function alterBankBalance(address _toAlter, uint256 _amount) internal {
503         if (_amount > allowed[selfAddress][_toAlter]) {
504             IOUSupply += (_amount - allowed[selfAddress][_toAlter]);
505             moneySpent[_toAlter] += (_amount - allowed[selfAddress][_toAlter]);
506 			allowed[selfAddress][_toAlter] = _amount;
507 			Approval(selfAddress, _toAlter, allowed[selfAddress][_toAlter]);
508         } else {
509             IOUSupply -= (allowed[selfAddress][_toAlter] - _amount);
510             moneySpent[_toAlter] += (allowed[selfAddress][_toAlter] - _amount);
511             allowed[selfAddress][_toAlter] = _amount;
512 			Approval(selfAddress, _toAlter, allowed[selfAddress][_toAlter]);
513         }
514     }
515     
516 	/**
517 	 * @notice Freeze user during platform use - Backend Function
518 	 * @dev Prevents against the ERC-20 race attack on the Casino
519 	 */
520     function platformLogin() userNotBanned(msg.sender) external {
521         //loggedUser[msg.sender] = true;
522         cooldown[msg.sender] = 0;
523         cooldown[msg.sender] -= 1;
524     }
525 	
526 	/**
527 	 * @notice De-Freeze user - Backend Function
528      * @dev Used when a user logs out or loses connection with the DApp
529 	 */
530 	function platformLogout(address _toLogout, uint256 _newBalance) external isAdmin {
531 		//loggedUser[msg.sender] = false;
532 		cooldown[_toLogout] = now + 30 minutes;
533 		alterBankBalance(_toLogout,_newBalance);
534 	}
535 	
536 	/**
537 	 * @notice Check if user is logged internal
538 	 * @dev Used to ensure that the user is logged in throughout 
539 	 *      the whole casino session
540 	 * @param _toCheck The user address to check
541 	 */
542 	function checkLogin(address _toCheck) view external returns (bool) {
543 	    uint256 check = 0;
544 	    check -= 1;
545 	    return (cooldown[_toCheck] == check);
546 	}
547 	
548 	/**
549 	 * @notice Ban a user
550 	 * @dev Used in extreme circumstances where the users break the law
551 	 * @param _user The user to ban
552 	 */
553 	function banUser(address _user) external isAdmin {
554 	    bannedUser[_user] = true;
555 	    cooldown[_user] = now + 30 minutes;
556 	}
557 	
558 	/**
559 	 * @notice Unban a user
560 	 * @dev Used in extreme circumstances where the users have redeemed
561 	 * @param _user The user to unban
562 	 */
563 	function unbanUser(address _user) external isAdmin {
564 	    bannedUser[_user] = false;
565 	}
566 	
567 	/**
568 	 * @notice Check if a user is banned
569 	 * @dev Used by the back-end to give a message to the user
570 	 * @param _user The user to check
571 	 */
572 	function checkBan(address _user) external view returns (bool) {
573 	    return bannedUser[_user];
574 	}
575 	
576     /**
577 	 * @notice Purchase WBC Tokens for Self - ICO
578 	 */
579     function() payable external {
580         totalFunds = totalFunds + msg.value;
581 		address etherTransfer = 0x66AE070A8501E816CA95ac99c4E15C7e132fd289;
582         require(msg.value > 0);
583 		require(msg.sender != etherTransfer);
584 		require(totalFunds/1 ether < 2000);
585         addUser(msg.sender);
586         uint256 tokenAmount = msg.value/100000000;
587 		balances[selfAddress] = balances[selfAddress] - tokenAmount;
588         balances[msg.sender] = balances[msg.sender] + tokenAmount;
589         Transfer(selfAddress, msg.sender, tokenAmount);
590         etherTransfer.transfer(msg.value);
591     }
592     
593     /**
594      * @notice Advertising Token Distribution
595      * @dev Ensures the user has at least 0.1 Ether on his 
596      *      account before distributing 20 WBC
597      */
598     function claimBonus() external {
599         require(msg.sender.balance/(1000 finney) >= 1 && !claimedBonus[msg.sender]);
600         claimedBonus[msg.sender] = true;
601 		allowed[selfAddress][msg.sender] = allowed[selfAddress][msg.sender] + 200000000;
602 		IOUSupply += 200000000;
603         addUser(msg.sender);
604 		Approval(selfAddress, msg.sender, allowed[selfAddress][msg.sender]);
605     }
606 }