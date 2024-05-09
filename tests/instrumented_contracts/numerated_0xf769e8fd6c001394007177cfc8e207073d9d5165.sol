1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     uint256 c = a / b;
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract ERC20Basic {
30   function totalSupply() public view returns (uint256);
31   function balanceOf(address who) public view returns (uint256);
32   function transfer(address to, uint256 value) public returns (bool);
33   event Transfer(address indexed from, address indexed to, uint256 value);
34 }
35 
36 contract ERC20 is ERC20Basic {
37   function allowance(address owner, address spender) public view returns (uint256);
38   function transferFrom(address from, address to, uint256 value) public returns (bool);
39   function approve(address spender, uint256 value) public returns (bool);
40   event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 contract KahnAirDrop{
44     using SafeMath for uint256;
45 	
46     struct User{
47 		address user_address;
48 		uint signup_time;
49 		uint256 reward_amount;
50 		bool blacklisted;
51 		uint paid_time;
52 		uint256 paid_token;
53 		bool status;
54 	}
55 	
56 	/* @dev Contract creator address */
57     address public owner;
58 	
59     /* @dev Assigned wallet where the remaining unclaim tokens to be return */
60     address public wallet;
61 	
62 	/* @dev The minimum either in wei must received to execute the claim function */
63     uint256 public mineth = 0;
64 
65 	/* @dev The minimum either in wei must received to execute the claim function */
66     uint256 public minsignupeth = 0;
67 
68 	/* @dev Whether or not the contract is pause (in case of a problem is detected) */
69 	bool public paused = false;
70 	
71 	/* @dev Fixed amount payout for each bounty */
72 	uint public maxSignup = 1000;
73 	
74 	/* @dev allows direct signup  */
75 	bool public allowsSignup = true;
76 	
77 	/* @dev bounty address  */
78 	address[] public bountyaddress;
79 	
80 	/* @dev admin address  */
81 	address[] public adminaddress;
82 	
83 	/* @dev staff address  */
84 	address[] public staffaddress;
85 	
86 	/* @dev block time to start the contract */
87 	uint public startTimes;
88 	
89 	/* @dev block time to end the contract */
90 	uint public endTimes;
91 	
92 	/* @dev Whether or not the contract is blacklisted (in case of a problem is detected) */
93 	bool public contractbacklist = false;
94 
95     /* @dev Total Signup count */
96     uint public userSignupCount = 0;
97 	
98     /* @dev Total tokens claimed */
99     uint256 public userClaimAmt = 0;
100 
101     /* @dev The token being distribute */
102     ERC20 public token;
103 
104 	/* 
105 	* @dev This set how the bounty reward will be paying out 
106 	* @param 0 = pay evenly
107 	* @param 1 = pay fixed amount
108 	* @param 2 = pay various amount
109 	*/
110 	uint public payStyle = 2;
111 	
112 	/* 
113 	* @dev False = Free version, contract creator will received the ether
114 	* @dev True = Paid version, client will received the ether 
115 	*/
116 	bool public paidversion = true;
117 
118 	/* @dev Setup the payout method
119 	* @param 0 = Enabled Signup Disabled Payout
120 	* @param 1 = Disable Signup Disable Payout
121 	* @param 2 = Disabled Signup Enable Payout
122 	* @param 3 = Enabled Signup Enabled Payout
123 	* @param 4 = Disabled Signup Immediate Payout
124 	*/
125 	uint public payoutNow = 4;
126 	
127 	/* @dev Fixed amount payout for each bounty */
128 	uint256 public fixPayAmt = 0;
129 	
130     /* @dev To record the different reward amount for each bounty  */
131     mapping(address => User) public bounties;
132 	
133     /* @dev to include the bounty in the list */
134 	mapping(address => bool) public signups;
135 	
136     /* @dev Store bounty address to blacklist */
137 	mapping(address => bool) public blacklist;
138 	
139     /* @dev to check is the claim in the process */
140 	mapping(address => bool) public isProcess;
141 	
142     /* @dev Admin with permission to manage the signed up bounty */
143     mapping (address => bool) public admins;
144 	
145     /* @dev Staff with permission to manage the signed up bounty */
146     mapping (address => bool) public staffs;
147 	
148     /**
149     * @dev Event for token distribution logging
150     * @param _address who claim the tokens
151     * @param _amount amount of tokens to be delivery
152     */
153     event eTokenClaim(address indexed _address, uint256 _amount);   
154     event eReClaimToken(uint256 _taBal, address _wallet, address _address);   
155     event eWalletChange(address _wallet, address indexed _address);
156     event eUpdatePayout(uint _payStyle, uint _payoutNow, uint256 _fixPayAmt, bool _allowsSignup, address indexed _address); 
157     event eUpdateStartEndTime(uint _startTimes, uint _endTimes, address indexed _address); 
158 
159     /* 
160     * event eAddAdmin(address _newaddress, address indexed _byaddress);   
161     * event eRemoveAdmin(address _newaddress, address indexed _byaddress);   
162     * event eAddStaff(address _newaddress, address indexed _byaddress);   
163     * event eRemoveStaff(address _newaddress, address indexed _byaddress);   
164     * event eAddBounty(address _newaddress, address indexed _byaddress);   
165     * event eRemoveBounty(address _address, address indexed _byaddress);   
166 	*/
167 	
168     /**
169     * @param _token Token smart contract address
170     * @param _wallet ETH address to reclaim unclaim tokens
171     */
172     function KahnAirDrop(ERC20 _token, uint256 _min_eth, uint256 _minsignupeth, uint _paystyle, address _wallet, uint _starttimes, uint _endtimes, uint _payoutnow, uint256 _fixpayamt, uint _maxsignup, bool _allowssignup, bool _paidversion) public {
173         require(_token != address(0));
174         token = _token;
175         admins[msg.sender] = true;
176         adminaddress.push(msg.sender) -1;
177         owner = msg.sender;
178         mineth = _min_eth;
179         minsignupeth = _minsignupeth;
180         wallet = _wallet;
181         payStyle = _paystyle;
182         startTimes = _starttimes;
183         endTimes = _endtimes;
184         payoutNow = _payoutnow;
185         fixPayAmt = _fixpayamt;
186         maxSignup = _maxsignup;
187         allowsSignup = _allowssignup;
188         paidversion = _paidversion;
189     }
190 
191     modifier onlyOwner {
192        require(msg.sender == owner);
193        _;
194     }
195 	
196     modifier onlyAdmin {
197         require(admins[msg.sender]);
198         _;
199     }
200 
201     modifier onlyStaffs {
202         require(admins[msg.sender] || staffs[msg.sender]);
203         _;
204     }
205 
206     modifier ifNotPaused {
207        require(!paused);
208        _;
209     }
210 
211     modifier ifNotStartExp {
212        require(now >= startTimes && now <= endTimes);
213        _;
214     }
215 
216     modifier ifNotBlacklisted {
217        require(!contractbacklist);
218        _;
219     }
220 
221 	/*******************/
222 	/* Owner Function **/
223 	/*******************/
224     /* @dev Update Contract Configuration  */
225     function ownerUpdateToken(ERC20 _token, address _wallet) public onlyOwner{
226         token = _token;
227         wallet = _wallet;
228         emit eWalletChange(wallet, msg.sender);
229     }
230 
231     /* @dev Update Contract Configuration  */
232     function ownerUpdateOthers(uint _maxno, bool _isBacklisted, uint256 _min_eth, uint256 _minsignupeth, bool _paidversion) public onlyOwner{
233         maxSignup = _maxno;
234         contractbacklist = _isBacklisted;
235         mineth = _min_eth;
236         minsignupeth = _minsignupeth;
237         paidversion = _paidversion;
238     }
239 
240 	/* @dev Owner Retrieve Contract Configuration */
241     function ownerRetrieveTokenDetails() view public onlyOwner returns(ERC20, address, uint256, uint256, bool){
242 		return(token, wallet, token.balanceOf(this), userClaimAmt, contractbacklist);
243     }
244 
245 	/* @dev Owner Retrieve Contract Configuration */
246     function ownerRetrieveContractConfig2() view public onlyOwner returns(uint256, bool, uint, uint, uint, uint, uint256, uint, bool){
247 		return(mineth, paidversion, payStyle, startTimes, endTimes, payoutNow, fixPayAmt, maxSignup, allowsSignup);
248     }
249 
250 	/*******************/
251 	/* Admin Function **/
252 	/*******************/
253     /* @dev Add admin to whitelist */
254 	function addAdminWhitelist(address[] _userlist) public onlyOwner onlyAdmin{
255 		require(_userlist.length > 0);
256 		for (uint256 i = 0; i < _userlist.length; i++) {
257 			address baddr = _userlist[i];
258 			if(baddr != address(0)){
259 				if(!admins[baddr]){
260 					admins[baddr] = true;
261 					adminaddress.push(baddr) -1;
262 				}
263 			}
264 		}
265 	}
266 	
267     /* @dev Remove admin from whitelist */
268 	function removeAdminWhitelist(address[] _userlist) public onlyAdmin{
269 		require(_userlist.length > 0);
270 		for (uint256 i = 0; i < _userlist.length; i++) {
271 			address baddr = _userlist[i];
272 			if(baddr != address(0)){
273 				if(admins[baddr]){
274 					admins[baddr] = false;
275 				}
276 			}
277 		}
278 	}
279 	
280     /* @dev Add staff to whitelist */
281 	function addStaffWhitelist(address[] _userlist) public onlyAdmin{
282 		require(_userlist.length > 0);
283 		for (uint256 i = 0; i < _userlist.length; i++) {
284 			address baddr = _userlist[i];
285 			if(baddr != address(0)){
286 				if(!staffs[baddr]){
287 					staffs[baddr] = true;
288 					staffaddress.push(baddr) -1;
289 				}
290 			}
291 		}
292 	}
293 	
294     /* @dev Remove staff from whitelist */
295 	function removeStaffWhitelist(address[] _userlist) public onlyAdmin{
296 		require(_userlist.length > 0);
297 		for (uint256 i = 0; i < _userlist.length; i++) {
298 			address baddr = _userlist[i];
299 			if(baddr != address(0)){
300 				if(staffs[baddr]){
301 					staffs[baddr] = false;
302 				}
303 			}
304 		}
305 	}
306 	
307 	/* @dev Allow Admin to reclaim all unclaim tokens back to the specified wallet */
308 	function reClaimBalance() public onlyAdmin{
309 		uint256 taBal = token.balanceOf(this);
310 		token.transfer(wallet, taBal);
311 		emit eReClaimToken(taBal, wallet, msg.sender);
312 	}
313 	
314 	function adminUpdateWallet(address _wallet) public onlyAdmin{
315 		require(_wallet != address(0));
316 		wallet = _wallet;
317 		emit eWalletChange(wallet, msg.sender);
318 	}
319 
320 	function adminUpdateStartEndTime(uint _startTimes, uint _endTimes) public onlyAdmin{
321 		require(_startTimes > 0);
322 		require(_endTimes > 0);
323 		startTimes = _startTimes;
324 		endTimes = _endTimes;
325 		emit eUpdateStartEndTime(startTimes, endTimes, msg.sender);
326 	}
327 
328     /* @dev Update Contract Configuration  */
329     function adminUpdMinSign(uint256 _min_eth, uint256 _minsignupeth) public onlyAdmin{
330        if(paidversion){
331 			mineth = _min_eth;
332 			minsignupeth = _minsignupeth;
333 	   } 
334     }
335 
336 	function adminUpdatePayout(uint _payStyle, uint _payoutNow, uint256 _fixPayAmt, bool _allowsSignup) public onlyAdmin{
337 		payStyle = _payStyle;
338 		payoutNow = _payoutNow;
339 		fixPayAmt = _fixPayAmt;
340 		allowsSignup = _allowsSignup;
341 		emit eUpdatePayout(payStyle, payoutNow, fixPayAmt, allowsSignup, msg.sender);
342 	}
343 
344 	/***************************/
345 	/* Admin & Staff Function **/
346 	/***************************/
347 	/* @dev Admin/Staffs Update Contract Configuration */
348 
349     /* @dev Add user to whitelist */
350     function signupUserWhitelist(address[] _userlist, uint256[] _amount) public onlyStaffs{
351     	require(_userlist.length > 0);
352 		require(_amount.length > 0);
353     	for (uint256 i = 0; i < _userlist.length; i++) {
354     		address baddr = _userlist[i];
355     		uint256 bval = _amount[i];
356     		if(baddr != address(0) && userSignupCount <= maxSignup){
357     			if(!bounties[baddr].blacklisted && bounties[baddr].user_address != baddr){
358 					signups[baddr] = true;
359 					bountyaddress.push(baddr) -1;
360 					userSignupCount++;
361 					if(payoutNow==4){
362 						bounties[baddr] = User(baddr,now,0,false,now,bval,true);
363 						token.transfer(baddr, bval);
364 						userClaimAmt = userClaimAmt.add(bval);
365 					}else{
366 						bounties[baddr] = User(baddr,now,bval,false,0,0,true);
367 					}
368     			}
369     		}
370     	}
371     }
372 	
373     /* @dev Remove user from whitelist */
374     function removeUserWhitelist(address[] _userlist) public onlyStaffs{
375 		require(_userlist.length > 0);
376 		for (uint256 i = 0; i < _userlist.length; i++) {
377 			address baddr = _userlist[i];
378 			if(baddr != address(0) && bounties[baddr].user_address == baddr){
379 				bounties[baddr].status = false;
380             	signups[baddr] = false;
381             	userSignupCount--;
382 			}
383 		}
384     }
385 	
386 	function updUserBlackList(address[] _addlist, address[] _removelist) public onlyStaffs{
387 		if(_addlist.length > 0){
388 			for (uint256 i = 0; i < _addlist.length; i++) {
389 				address baddr = _addlist[i];
390 				if(baddr != address(0) && !bounties[baddr].blacklisted){
391 					bounties[baddr].blacklisted = true;
392 					blacklist[baddr] = true;
393 				}
394 			}
395 		}
396 		
397 		if(_removelist.length > 0){ removeUserFromBlackList(_removelist); }
398 	}
399 	
400 	function removeUserFromBlackList(address[] _userlist) internal{
401 		require(_userlist.length > 0);
402 		for (uint256 i = 0; i < _userlist.length; i++) {
403 			address baddr = _userlist[i];
404 			if(baddr != address(0) && bounties[baddr].blacklisted){
405 				bounties[baddr].blacklisted = false;
406 				blacklist[baddr] = false;
407 			}
408 		}
409 	}
410 	
411     /* @dev Update Multiple Users Reward Amount */
412     function updateMultipleUsersReward(address[] _userlist, uint256[] _amount) public onlyStaffs{
413 		require(_userlist.length > 0);
414 		require(_amount.length > 0);
415 		for (uint256 i = 0; i < _userlist.length; i++) {
416 			address baddr = _userlist[i];
417 			uint256 bval = _amount[i];
418 			if(baddr != address(0)){
419 				if(bounties[baddr].user_address == baddr){
420 					bounties[baddr].reward_amount = bval;
421 				}else{
422 					if(userSignupCount <= maxSignup){
423 					    bounties[baddr] = User(baddr,now,bval,false,0,0,true);
424 					    signups[baddr] = true;
425 						bountyaddress.push(baddr) -1;
426 					    userSignupCount++;
427 					}
428 				}
429 			}
430 		}
431     }
432 	
433 	/***************************/
434 	/* Query Display Function **/
435 	/***************************/
436     function adminRetrieveContractConfig() view public onlyStaffs returns(uint, uint, uint256, uint, bool, bool){
437 		return(payStyle, payoutNow, fixPayAmt, maxSignup, allowsSignup, paidversion);
438     }
439 
440     function adminRetrieveContractConfig2() view public onlyStaffs returns(uint256, uint256, address, uint, uint, uint){
441     	return(mineth, minsignupeth, wallet, startTimes, endTimes, userSignupCount);
442     }
443 
444     function adminRetrieveContractConfig3() view public onlyStaffs returns(ERC20, uint256, uint256, uint, uint){
445     	uint256 taBal = token.balanceOf(this);
446 		return(token, taBal,userClaimAmt, now, block.number);
447     }
448 
449 	/* @dev Check is the address is in Admin list */
450 	function chkAdmin(address _address) view public onlyAdmin returns(bool){
451 		return admins[_address];
452 	}
453 	
454 	/* @dev Check is the address is in Staff list */
455 	function chkStaff(address _address) view public onlyAdmin returns(bool){
456 		return staffs[_address];
457 	}
458 
459 	/* @dev Return admin addresses list */
460 	function getAllAdmin() view public onlyAdmin returns(address[]){
461 		return adminaddress;
462 	}
463 
464 	/* @dev Return staff addresses list */
465 	function getAllStaff() view public onlyAdmin returns(address[]){
466 		return staffaddress;
467 	}
468 
469 	/* @dev Return list of bounty addresses */
470 	function getBountyAddress() view public onlyStaffs returns(address[]){
471 		return bountyaddress;
472 	}
473 	
474 	/*  
475 	* @dev Check is the user is in Signed up list 
476 	* @dev bool = address is in the signup mapping list
477 	* @dev uint256 = the given bounty address reward entitlement amount
478 	*/
479 	function chkUserDetails(address _address) view public onlyStaffs returns(address,uint,uint256,bool,uint,uint256,bool){
480 		require(_address != address(0));
481 		return(bounties[_address].user_address, bounties[_address].signup_time, bounties[_address].reward_amount, bounties[_address].blacklisted, bounties[_address].paid_time, bounties[_address].paid_token, bounties[_address].status);
482 	}
483 	
484 	/***************************/
485 	/* Main Contract Function **/
486 	/***************************/
487 	/* @dev Bounty send in either to execute the claim */
488 	function () external payable ifNotStartExp ifNotPaused ifNotBlacklisted{
489 		require(!blacklist[msg.sender]);
490 		if(payoutNow == 0){
491 			require(allowsSignup);
492 			singleUserSignUp(msg.sender);
493 		}else if(payoutNow == 1){
494 			require(allowsSignup);
495 		}else if(payoutNow == 2){
496 			claimTokens(msg.sender);
497 		}else if(payoutNow == 3){
498 			claimImmediateTokens(msg.sender);
499 		}
500 	}
501 	
502 	function singleUserSignUp(address _address) internal ifNotStartExp ifNotPaused ifNotBlacklisted {
503 		if(userSignupCount <= maxSignup){
504 			if(!signups[_address] && bounties[_address].user_address != _address && msg.value >= minsignupeth){
505 				if(payoutNow != 1 || payoutNow != 2){
506 					signups[_address] = true;
507 					uint256 temrew = 0;
508 					if(payStyle == 1){ temrew = fixPayAmt; }
509 					bounties[_address] = User(_address,now,temrew,false,0,0,true);
510 					signups[_address] = true;
511 					bountyaddress.push(_address) -1;
512 					userSignupCount++;
513 				}
514 			}
515 		}
516 		forwardWei();
517 	}
518 	
519     /* @dev Bounty claim their reward tokens by sending zero ETH to this smart contract */
520     function claimTokens(address _beneficiary) public payable ifNotStartExp ifNotPaused ifNotBlacklisted {
521 	   require(msg.value >= mineth);
522 	   require(_beneficiary != address(0));
523 	   require(!blacklist[msg.sender]);
524 	   
525 	   /* @dev Check to ensure the address is not in processing to avoid double claim */
526        require(!isProcess[_beneficiary]);
527 	   
528 	   /* @dev Check to ensure the address is signed up to the airdrop */
529        require(signups[_beneficiary]);
530 	   
531 	   /* @dev Get the reward token for the given address */
532 	   uint256 rewardAmount = getReward(_beneficiary);
533 	   
534 	   /* @dev if the baounty reward amount is less than zero, quit the prorcess */
535 	   require(rewardAmount > 0);
536 	   
537 	   /* @dev get the available balance for airdrop */
538 	   uint256 taBal = token.balanceOf(this);
539 	   
540 	   /* @dev Check is the balance enough to pay for the claim */
541 	   require(rewardAmount <= taBal);
542 	   
543 	   /* @dev Set the address to processing */
544 	   isProcess[_beneficiary] = true;
545 	   
546 	   /* @dev Transer the token to the bounty */
547 	   token.transfer(_beneficiary, rewardAmount);
548 	   
549 	   /* @dev Set the bounty reward entitlement to zero */
550 	   bounties[_beneficiary].reward_amount = 0;
551 	   bounties[_beneficiary].status = true;
552 	   bounties[_beneficiary].paid_time = now;
553 	   
554 	   /* @dev Set the In Process to false to mark the process is completed */
555 	   isProcess[_beneficiary] = false;
556 	   
557 	   /* @dev Add the claim tokens to total claimed tokens */
558 	   userClaimAmt = userClaimAmt.add(rewardAmount);
559 	   
560 	   /* @dev Transfer the ether */
561 	   forwardWei();
562 	   
563 	   emit eTokenClaim(_beneficiary, rewardAmount);
564     }
565 	
566 	
567     /* @dev Bounty claim their reward tokens by sending zero ETH to this smart contract */
568     function claimImmediateTokens(address _beneficiary) public payable ifNotStartExp ifNotPaused ifNotBlacklisted {
569 	   require(msg.value >= mineth);
570 	   require(_beneficiary != address(0));
571 	   require(!blacklist[msg.sender]);
572 	   require(userSignupCount <= maxSignup);
573 	   require(fixPayAmt > 0);
574 	   uint256 taBal = token.balanceOf(this);
575 	   require(taBal > 0);
576 	   require(fixPayAmt <= taBal);
577        require(!isProcess[_beneficiary]);
578 	   isProcess[_beneficiary] = true;
579 	   signups[_beneficiary] = true;
580 	   bounties[_beneficiary] = User(_beneficiary,now,0,false,now,fixPayAmt,true);
581 	   bountyaddress.push(_beneficiary) -1;
582 	   userSignupCount++;
583 	   token.transfer(_beneficiary, fixPayAmt);
584 	   userClaimAmt = userClaimAmt.add(fixPayAmt);
585 	   forwardWei();
586 	   emit eTokenClaim(_beneficiary, fixPayAmt);
587     }
588 
589     /* @dev Get Reward function based on the payout style */
590 	function getReward(address _address) internal constant returns(uint256){
591 		uint256 rtnVal = 0;
592 		if(payStyle == 0){
593 			/* Reward divided evenly by the total number of signed up bounty */
594 			uint256 taBal = token.balanceOf(this);
595 			rtnVal = taBal.div(userSignupCount);
596 		}else if(payStyle == 1){
597 			// Reward for each bounty is based on Fixed amount
598 			rtnVal = fixPayAmt;
599 		}else if(payStyle == 2){
600 			// Reward for each bounty is based on the amount set by the Admin when adding the bounty
601 			rtnVal = bounties[_address].reward_amount;
602 		}
603 		return rtnVal;
604 	}
605 	
606 	/* @dev Function for who will receive the paid ether */
607 	function forwardWei() internal {
608 		if(!paidversion){
609 			/* if paidversion is false, this is a free version, client agreed to contract creator to received the either */
610 			/* in exchnage to use the service for free */
611 			if(msg.value > 0)
612 				owner.transfer(msg.value);
613 		}else{
614 			/* if paidversion is true, this is a paid version, received ether pay directly to client wallet */
615 			if(msg.value > 0)
616 				wallet.transfer(msg.value);
617 		}
618 	}
619 }