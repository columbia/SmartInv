1 pragma solidity ^0.4.25;
2 
3 
4 // library for basic math operation + - * / to prevent and protect overflow error 
5 // (Overflow and Underflow) which can be occurred from unit256 (Unsigned int 256)
6  library SafeMath256 {
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if(a==0 || b==0)
9         return 0;  
10     uint256 c = a * b;
11     require(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     require(b>0);
17     uint256 c = a / b;
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22    require( b<= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     require(c >= a);
29 
30     return c;
31   }
32   
33 }
34 
35 
36 // Mandatory basic functions according to ERC20 standard
37 contract ERC20 {
38 	   event Transfer(address indexed from, address indexed to, uint256 tokens);
39        event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
40 
41    	   function totalSupply() public view returns (uint256);
42        function balanceOf(address tokenOwner) public view returns (uint256 balance);
43        function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);
44 
45        function transfer(address to, uint256 tokens) public returns (bool success);
46        
47        function approve(address spender, uint256 tokens) public returns (bool success);
48        function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
49   
50 
51 }
52 
53 
54 // Contract Ownable is used to specified which person has right/permission to execute/invoke the specific function.
55 // Different from OnlyOwner which is the only owner of the smart contract who has right/permission to call
56 // the specific function. Aside from OnlyOwner, 
57 // OnlyOwners can also be used which any of Owners can call the particular function.
58 
59 contract Ownable {
60 
61 
62 // A list of owners which will be saved as a list here, 
63 // and the values are the owner’s names. 
64 // This to allow investors / NATEE Token buyers to trace/monitor 
65 // who executes which functions written in this NATEE smart contract  string [] ownerName;
66 
67   string [] ownerName;  
68   mapping (address=>bool) owners;
69   mapping (address=>uint256) ownerToProfile;
70   address owner;
71 
72 // all events will be saved as log files
73   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
74   event AddOwner(address newOwner,string name);
75   event RemoveOwner(address owner);
76   /**
77    * @dev Ownable constructor , initializes sender’s account and 
78    * set as owner according to default value according to contract
79    *
80    */
81 
82    // this function will be executed during initial load and will keep the smart contract creator (msg.sender) as Owner
83    // and also saved in Owners. This smart contract creator/owner is 
84    // Mr. Samret Wajanasathian CTO of Seitee Pte Ltd (https://seitee.com.sg , https://natee.io)
85 
86    constructor() public {
87     owner = msg.sender;
88     owners[msg.sender] = true;
89     uint256 idx = ownerName.push("SAMRET WAJANASATHIAN");
90     ownerToProfile[msg.sender] = idx;
91 
92   }
93 
94 // function to check whether the given address is either Wallet address or Contract Address
95 
96   function isContract(address _addr) internal view returns(bool){
97      uint256 length;
98      assembly{
99       length := extcodesize(_addr)
100      }
101      if(length > 0){
102        return true;
103     }
104     else {
105       return false;
106     }
107 
108   }
109 
110 // function to check if the executor is the owner? This to ensure that only the person 
111 // who has right to execute/call the function has the permission to do so.
112   modifier onlyOwner(){
113     require(msg.sender == owner);
114     _;
115   }
116 
117 // This function has only one Owner. The ownership can be transferrable and only
118 //  the current Owner will only be  able to execute this function.
119   
120   function transferOwnership(address newOwner,string newOwnerName) public onlyOwner{
121     require(isContract(newOwner) == false);
122     uint256 idx;
123     if(ownerToProfile[newOwner] == 0)
124     {
125     	idx = ownerName.push(newOwnerName);
126     	ownerToProfile[newOwner] = idx;
127     }
128 
129 
130     emit OwnershipTransferred(owner,newOwner);
131     owner = newOwner;
132 
133   }
134 
135 // Function to check if the person is listed in a group of Owners and determine
136 // if the person has the any permissions in this smart contract such as Exec permission.
137   
138   modifier onlyOwners(){
139     require(owners[msg.sender] == true);
140     _;
141   }
142 
143 // Function to add Owner into a list. The person who wanted to add a new owner into this list but be an existing
144 // member of the Owners list. The log will be saved and can be traced / monitor who’s called this function.
145   
146   function addOwner(address newOwner,string newOwnerName) public onlyOwners{
147     require(owners[newOwner] == false);
148     require(newOwner != msg.sender);
149     if(ownerToProfile[newOwner] == 0)
150     {
151     	uint256 idx = ownerName.push(newOwnerName);
152     	ownerToProfile[newOwner] = idx;
153     }
154     owners[newOwner] = true;
155     emit AddOwner(newOwner,newOwnerName);
156   }
157 
158 // Function to remove the Owner from the Owners list. The person who wanted to remove any owner from Owners
159 // List must be an existing member of the Owners List. The owner cannot evict himself from the Owners
160 // List by his own, this is to ensure that there is at least one Owner of this NATEE Smart Contract.
161 // This NATEE Smart Contract will become useless if there is no owner at all.
162 
163   function removeOwner(address _owner) public onlyOwners{
164     require(_owner != msg.sender);  // can't remove your self
165     owners[_owner] = false;
166     emit RemoveOwner(_owner);
167   }
168 // this function is to check of the given address is allowed to call/execute the particular function
169 // return true if the given address has right to execute the function.
170 // for transparency purpose, anyone can use this to trace/monitor the behaviors of this NATEE smart contract.
171 
172   function isOwner(address _owner) public view returns(bool){
173     return owners[_owner];
174   }
175 
176 // Function to check who’s executed the functions of smart contract. This returns the name of 
177 // Owner and this give transparency of whose actions on this NATEE Smart Contract. 
178 
179   function getOwnerName(address ownerAddr) public view returns(string){
180   	require(ownerToProfile[ownerAddr] > 0);
181 
182   	return ownerName[ownerToProfile[ownerAddr] - 1];
183   }
184 }
185 
186 // ContractToken is for managing transactions of wallet address or contract address with its own 
187 // criterias and conditions such as settlement.
188 
189 contract ControlToken is Ownable{
190 	
191 	mapping (address => bool) lockAddr;
192 	address[] lockAddrList;
193 	uint32  unlockDate;
194 
195      bool disableBlock;
196      bool call2YLock;
197 
198 	mapping(address => bool) allowControl;
199 	address[] exchangeAddress;
200 	uint32    exchangeTimeOut;
201 
202 	event Call2YLock(address caller);
203 
204 // Initially the lockin period is set for 100 years starting from the date of Smart Contract Deployment.
205 // The company will have to adjust it to 2 years for lockin period starting from the first day that 
206 // NATEE token listed in exchange (in any exchange).
207 
208 	constructor() public{
209 		unlockDate = uint32(now) + 36500 days;  // Start Lock 100 Year first
210 		
211 	}
212 
213 // function to set Wallet Address that belong to Exclusive Exchange. 
214 // The lockin period for this setting has its minimum of 6 months.
215 
216 	function setExchangeAddr(address _addr) onlyOwners public{
217 		uint256 numEx = exchangeAddress.push(_addr);
218 		if(numEx == 1){
219 			exchangeTimeOut = uint32(now + 180 days);
220 		}
221 	}
222 
223 // Function to adjust lockin period of Exclusive Exchange,
224 // this could unlock the lockin period and allow freedom trade.
225 
226 	function setExchangeTimeOut(uint32 timStemp) onlyOwners public{
227 		exchangeTimeOut = timStemp;
228 	}
229 
230 // This function is used to set duration from 100 years to 2 years, start counting from the date that execute this function.
231 // To prevent early execution and to ensure that only the legitimate Owner can execute this function, 
232 // Seitee Pte Ltd has logged all activities from this function which open for public for transparency.
233 // The generated log will be publicly published on ERC20 network, anyone can check/trace from the log
234 // that this function will never been called if there no confirmed Exchange that accepts NATEE Token.
235 // Any NATEE token holders who still serving lockin period, can ensure that there will be no repeatedly 
236 // execution for this function (the repeatedly execution could lead to lockin period extension to more than 2 years). 
237 // The constraint “call2YLock” is initialized as boolean “False” when the NATEE Smart Contract is created and will only 
238 // be set to “true” when this function is executed. One the value changed from false > true, it will preserve the value forever.
239 
240 	function start2YearLock() onlyOwners public{
241 		if(call2YLock == false){
242 			unlockDate = uint32(now) + 730 days;
243 			call2YLock = true;
244 
245 			emit Call2YLock(msg.sender);
246 		}
247 	
248 	}
249 
250 	function lockAddress(address _addr) internal{
251 		if(lockAddr[_addr] == false)
252 		{
253 			lockAddr[_addr] = true;
254 			lockAddrList.push(_addr);
255 		}
256 	}
257 
258 	function isLockAddr(address _addr) public view returns(bool){
259 		return lockAddr[_addr];
260 	}
261 
262 // this internal function is used to add address into the locked address list. 
263 	
264 	function addLockAddress(address _addr) onlyOwners public{
265 		if(lockAddr[_addr] == false)
266 		{
267 			lockAddr[_addr] = true;
268 			lockAddrList.push(_addr);		
269 		}
270 	}
271 
272 // Function to unlock the token for all addresses. This function is open as public modifier
273 // stated to allow anyone to execute it. This to prevent the doubtful of delay of unlocking
274 // or any circumstances that prolong the unlocking. This just simply means, anyone can unlock 
275 // the address for anyone in this Smart Contract.
276 
277 	function unlockAllAddress() public{
278 		if(uint32(now) >= unlockDate)
279 		{
280 			for(uint256 i=0;i<lockAddrList.length;i++)
281 			{
282 				lockAddr[lockAddrList[i]] = false;
283 			}
284 		}
285 	}
286 
287 // The followings are the controls for Token Transfer, the Controls are managed by Seitee Pte Ltd
288 //========================= ADDRESS CONTROL =======================
289 //  This internal function is to indicate that the Wallet Address has been allowed and let Seitee Pte Ltd
290 //  to do transactions. The initial value is closed which means, Seitee Pte Lte cannot do any transactions.
291 
292 	function setAllowControl(address _addr) internal{
293 		if(allowControl[_addr] == false)
294 			allowControl[_addr] = true;
295 	}
296 
297 // this function is to check whether the given Wallet Address can be managed/controlled by Seitee Pte Ltd.
298 // If return “true” means, Seitee Pte Ltd take controls of this Wallet Address.
299 
300 	function checkAllowControl(address _addr) public view returns(bool){
301 		return allowControl[_addr];
302 	}
303 
304 // NATEE Token system prevents the transfer of token to non-verified Wallet Address
305 // (the Wallet Address that hasn’t been verified thru KYC). This can also means that 
306 // Token wont be transferable to other Wallet Address that not saved in this Smart Contract. 
307 // This function is created for everyone to unlock the Wallet Address, once the Wallet Address is unlocked,
308 // the Wallet Address can’t be set to lock again. Our Smart Contract doesn’t have any line that 
309 // contains “disableBlock = false”. The condition is when there is a new exchange in the system and 
310 // fulfill the 6 months lockin period or less (depends on the value set).
311    
312     function setDisableLock() public{
313     	if(uint256(now) >= exchangeTimeOut && exchangeAddress.length > 0)
314     	{
315       	if(disableBlock == false)
316       		disableBlock = true;
317       	}
318     }
319 
320 }
321 
322 // NATEE token smart contract stored KYC Data on Blockchain for transparency. 
323 // Only Seitee Pte Ltd has the access to this KYC data. The authorities/Government 
324 // Agencies can be given the access to view this KYC data, too (subject to approval).
325 // Please note, this is not open publicly.
326 
327 contract KYC is ControlToken{
328 
329 
330 	struct KYCData{
331 		bytes8    birthday; // yymmdd  
332 		bytes16   phoneNumber; 
333 
334 		uint16    documentType; // 2 byte;
335 		uint32    createTime; // 4 byte;
336 		// --- 32 byte
337 		bytes32   peronalID;  // Passport หรือ idcard
338 		// --- 32 byte 
339 		bytes32    name;
340 		bytes32    surName;
341 		bytes32    email;
342 		bytes8	  password;
343 	}
344 
345 	KYCData[] internal kycDatas;
346 
347 	mapping (uint256=>address) kycDataForOwners;
348 	mapping (address=>uint256) OwnerToKycData;
349 
350 	mapping (uint256=>address) internal kycSOSToOwner; //keccak256 for SOS function 
351 
352 
353 	event ChangePassword(address indexed owner_,uint256 kycIdx_);
354 	event CreateKYCData(address indexed owner_, uint256 kycIdx_);
355 
356 	// Individual KYC data the parameter is index of the KYC data. Only Seitee Pte Ltd can view this data.
357 
358 	function getKYCData(uint256 _idx) onlyOwners view public returns(bytes16 phoneNumber_,
359 										 							  bytes8  birthday_,
360 										 							  uint16 documentType_,
361 										 							  bytes32 peronalID_,
362 										 							  bytes32 name_,
363 										 							  bytes32 surname_,
364 										 							  bytes32 email_){
365 		require(_idx <= kycDatas.length && _idx > 0,"ERROR GetKYCData 01");
366 		KYCData memory _kyc;
367 		uint256  kycKey = _idx - 1; 
368 		_kyc = kycDatas[kycKey];
369 
370 		phoneNumber_ = _kyc.phoneNumber;
371 		birthday_ = _kyc.birthday;
372 		documentType_ = _kyc.documentType;
373 		peronalID_ = _kyc.peronalID;
374 		name_ = _kyc.name;
375 		surname_ = _kyc.surName;
376 		email_ = _kyc.email;
377 
378 		} 
379 
380 	// function to view KYC data from registered Wallet Address. Only Seitee Pte Ltd has right to view this data.
381 	function getKYCDataByAddr(address _addr) onlyOwners view public returns(bytes16 phoneNumber_,
382 										 							  bytes8  birthday_,
383 										 							  uint16 documentType_,
384 										 							  bytes32 peronalID_,
385 										 							  bytes32 name_,
386 										 							  bytes32 surname_,
387 										 							  bytes32 email_){
388 		require(OwnerToKycData[_addr] > 0,"ERROR GetKYCData 02");
389 		KYCData memory _kyc;
390 		uint256  kycKey = OwnerToKycData[_addr] - 1; 
391 		_kyc = kycDatas[kycKey];
392 
393 		phoneNumber_ = _kyc.phoneNumber;
394 		birthday_ = _kyc.birthday;
395 		documentType_ = _kyc.documentType;
396 		peronalID_ = _kyc.peronalID;
397 		name_ = _kyc.name;
398 		surname_ = _kyc.surName;
399 		email_ = _kyc.email;
400 
401 		} 
402 
403 	// The Owner can view the history records from KYC processes.
404 	function getKYCData() view public returns(bytes16 phoneNumber_,
405 										 					 bytes8  birthday_,
406 										 					 uint16 documentType_,
407 										 					 bytes32 peronalID_,
408 										 					 bytes32 name_,
409 										 					 bytes32 surname_,
410 										 					 bytes32 email_){
411 		require(OwnerToKycData[msg.sender] > 0,"ERROR GetKYCData 03"); // if == 0 not have data;
412 		uint256 id = OwnerToKycData[msg.sender] - 1;
413 
414 		KYCData memory _kyc;
415 		_kyc = kycDatas[id];
416 
417 		phoneNumber_ = _kyc.phoneNumber;
418 		birthday_ = _kyc.birthday;
419 		documentType_ = _kyc.documentType;
420 		peronalID_ = _kyc.peronalID;
421 		name_ = _kyc.name;
422 		surname_ = _kyc.surName;
423 		email_ = _kyc.email;
424 	}
425 
426 // 6 chars password which the Owner can update the password by himself/herself. Only the Owner can execute this function.
427 	function changePassword(bytes8 oldPass_, bytes8 newPass_) public returns(bool){
428 		require(OwnerToKycData[msg.sender] > 0,"ERROR changePassword"); 
429 		uint256 id = OwnerToKycData[msg.sender] - 1;
430 		if(kycDatas[id].password == oldPass_)
431 		{
432 			kycDatas[id].password = newPass_;
433 			emit ChangePassword(msg.sender, id);
434 		}
435 		else
436 		{
437 			assert(kycDatas[id].password == oldPass_);
438 		}
439 
440 		return true;
441 
442 
443 	}
444 
445 	// function to create record of KYC data
446 	function createKYCData(bytes32 _name, bytes32 _surname, bytes32 _email,bytes8 _password, bytes8 _birthday,bytes16 _phone,uint16 _docType,bytes32 _peronalID,address  _wallet) onlyOwners public returns(uint256){
447 		uint256 id = kycDatas.push(KYCData(_birthday, _phone, _docType, uint32(now) ,_peronalID, _name, _surname, _email, _password));
448 		uint256 sosHash = uint256(keccak256(abi.encodePacked(_name, _surname , _email, _password)));
449 
450 		OwnerToKycData[_wallet] = id;
451 		kycDataForOwners[id] = _wallet; 
452 		kycSOSToOwner[sosHash] = _wallet; 
453 		emit CreateKYCData(_wallet,id);
454 
455 		return id;
456 	}
457 
458 	function maxKYCData() public view returns(uint256){
459 		return kycDatas.length;
460 	}
461 
462 	function haveKYCData(address _addr) public view returns(bool){
463 		if(OwnerToKycData[_addr] > 0) return true;
464 		else return false;
465 	}
466 
467 }
468 
469 // Standard ERC20 function, no overriding at the moment.
470 
471 contract StandarERC20 is ERC20{
472 	using SafeMath256 for uint256;  
473      
474      mapping (address => uint256) balance;
475      mapping (address => mapping (address=>uint256)) allowed;
476 
477 
478      uint256 public totalSupply_;  
479      
480 
481      address[] public  holders;
482      mapping (address => uint256) holderToId;
483 
484 
485      event Transfer(address indexed from,address indexed to,uint256 value);
486      event Approval(address indexed owner,address indexed spender,uint256 value);
487 
488 
489 // Total number of Tokens 
490     function totalSupply() public view returns (uint256){
491      	return totalSupply_;
492     }
493 
494      function balanceOf(address _walletAddress) public view returns (uint256){
495         return balance[_walletAddress]; 
496      }
497 
498 // function to check on how many tokens set to be transfer between _owner and _spender. This is to check prior to confirm the transaction. 
499      function allowance(address _owner, address _spender) public view returns (uint256){
500           return allowed[_owner][_spender];
501         }
502 
503 // Standard function used to transfer the token according to ERC20 standard
504      function transfer(address _to, uint256 _value) public returns (bool){
505         require(_value <= balance[msg.sender]);
506         require(_to != address(0));
507         
508         balance[msg.sender] = balance[msg.sender].sub(_value);
509         balance[_to] = balance[_to].add(_value);
510 
511         emit Transfer(msg.sender,_to,_value); 
512         return true;
513 
514      }
515 // standard function to approve transfer of token
516      function approve(address _spender, uint256 _value)
517             public returns (bool){
518             allowed[msg.sender][_spender] = _value;
519 
520             emit Approval(msg.sender, _spender, _value);
521             return true;
522             }
523 
524 
525 // standard function to request the money used after the sender has initialize the 
526 // transition of money transfer. Only the beneficiary able to execute this function 
527 // and the amount of money has been set as transferable by the sender.  
528       function transferFrom(address _from, address _to, uint256 _value)
529             public returns (bool){
530                require(_value <= balance[_from]);
531                require(_value <= allowed[_from][msg.sender]); 
532                require(_to != address(0));
533 
534               balance[_from] = balance[_from].sub(_value);
535               balance[_to] = balance[_to].add(_value);
536               allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
537 
538               emit Transfer(_from, _to, _value);
539               return true;
540       }
541 
542 // additional function to store all NATEE Token holders as a list in blockchain.
543 // This could be use for bounty program in the future.
544      function addHolder(address _addr) internal{
545      	if(holderToId[_addr] == 0)
546      	{
547      		uint256 idx = holders.push(_addr);
548      		holderToId[_addr] = idx;
549      	}
550      }
551 
552 // function to request the top NATEE Token holders.
553      function getMaxHolders() external view returns(uint256){
554      	return holders.length;
555      }
556 
557 // function to read all indexes of NATEE Token holders. 
558      function getHolder(uint256 idx) external view returns(address){
559      	return holders[idx];
560      }
561      
562 }
563 
564 
565 // Contract for co-founders and advisors which is total of 5,000,000 Tokens for co-founders
566 // and 4,000,000 tokens for advisors. Maximum NATEE token for advisor is 200,000 Tokens and 
567 // the deficit from 4,000,000 tokens allocated to advisors, will be transferred to co-founders.
568 
569 contract FounderAdvisor is StandarERC20,Ownable,KYC {
570 
571 	uint256 FOUNDER_SUPPLY = 5000000 ether;
572 	uint256 ADVISOR_SUPPLY = 4000000 ether;
573 
574 	address[] advisors;
575 	address[] founders;
576 
577 	mapping (address => uint256) advisorToID;
578 	mapping (address => uint256) founderToID;
579 	// will have true if already redeem.
580 	// Advisor and founder can't be same people
581 
582 	bool  public closeICO;
583 
584 	// Will have this value after close ICO
585 
586 	uint256 public TOKEN_PER_FOUNDER = 0 ether; 
587 	uint256 public TOKEN_PER_ADVISOR = 0 ether;
588 
589 	event AddFounder(address indexed newFounder,string nane,uint256  curFoounder);
590 	event AddAdvisor(address indexed newAdvisor,string name,uint256  curAdvisor);
591 	event CloseICO();
592 
593 	event RedeemAdvisor(address indexed addr_, uint256 value);
594 	event RedeemFounder(address indexed addr_, uint256 value);
595 
596 	event ChangeAdvisorAddr(address indexed oldAddr_, address indexed newAddr_);
597 	event ChangeFounderAddr(address indexed oldAddr_, address indexed newAddr_);
598 
599 
600 // function to add founders, name and surname will be logged. This 
601 // function will be disabled after ICO closed.
602 	function addFounder(address newAddr, string _name) onlyOwners external returns (bool){
603 		require(closeICO == false);
604 		require(founderToID[newAddr] == 0);
605 
606 		uint256 idx = founders.push(newAddr);
607 		founderToID[newAddr] = idx;
608 		emit AddFounder(newAddr, _name, idx);
609 		return true;
610 	}
611 
612 // function to add advisors. This function will be disabled after ICO closed.
613 
614 	function addAdvisor(address newAdvis, string _name) onlyOwners external returns (bool){
615 		require(closeICO == false);
616 		require(advisorToID[newAdvis] == 0);
617 
618 		uint256 idx = advisors.push(newAdvis);
619 		advisorToID[newAdvis] = idx;
620 		emit AddAdvisor(newAdvis, _name, idx);
621 		return true;
622 	}
623 
624 // function to update Advisor’s Wallet Address. If there is a need to remove the advisor,
625 // just input address = 0. This function will be disabled after ICO closed.
626 
627 	function changeAdvisorAddr(address oldAddr, address newAddr) onlyOwners external returns(bool){
628 		require(closeICO == false);
629 		require(advisorToID[oldAddr] > 0); // it should be true if already have advisor
630 
631 		uint256 idx = advisorToID[oldAddr];
632 
633 		advisorToID[newAddr] = idx;
634 		advisorToID[oldAddr] = 0;
635 
636 		advisors[idx - 1] = newAddr;
637 
638 		emit ChangeAdvisorAddr(oldAddr,newAddr);
639 		return true;
640 	}
641 
642 // function to update founder’s Wallet Address. To remove the founder, 
643 // pass the value of address = 0. This function will be disabled after ICO closed.
644 	function changeFounderAddr(address oldAddr, address newAddr) onlyOwners external returns(bool){
645 		require(closeICO == false);
646 		require(founderToID[oldAddr] > 0);
647 
648 		uint256 idx = founderToID[oldAddr];
649 
650 		founderToID[newAddr] = idx;
651 		founderToID[oldAddr] = 0;
652 		founders[idx - 1] = newAddr;
653 
654 		emit ChangeFounderAddr(oldAddr, newAddr);
655 		return true;
656 	}
657 
658 	function isAdvisor(address addr) public view returns(bool){
659 		if(advisorToID[addr] > 0) return true;
660 		else return false;
661 	}
662 
663 	function isFounder(address addr) public view returns(bool){
664 		if(founderToID[addr] > 0) return true;
665 		else return false;
666 	}
667 }
668 
669 // Contract MyToken is created for extra permission to make a transfer of token. Typically,
670 // NATEE Token will be held and will only be able to transferred to those who has successfully 
671 // done the KYC. For those who holds NATEE PRIVATE TOKEN at least 8,000,000 tokens is able to 
672 // transfer the token to anyone with no limit.
673 
674 contract MyToken is FounderAdvisor {
675 	 using SafeMath256 for uint256;  
676      mapping(address => uint256) privateBalance;
677 
678 
679      event SOSTranfer(address indexed oldAddr_, address indexed newAddr_);
680 
681 // standard function according to ERC20, modified by adding the condition of lockin period (2 years)
682 // for founders and advisors. Including the check whether the address has been KYC verified and is 
683 // NATEE PRIVATE TOKEN holder will be able to freedomly trade the token.
684 
685      function transfer(address _to, uint256 _value) public returns (bool){
686      	if(lockAddr[msg.sender] == true) // 2 Year lock can Transfer only Lock Address
687      	{
688      		require(lockAddr[_to] == true);
689      	}
690 
691      	// if total number of NATEE PRIVATE TOKEN is less than amount that wish to transfer
692      	if(privateBalance[msg.sender] < _value){
693      		if(disableBlock == false)
694      		{
695         		require(OwnerToKycData[msg.sender] > 0,"You Not have permission to Send");
696         		require(OwnerToKycData[_to] > 0,"You not have permission to Recieve");
697         	}
698    		 }
699         
700          addHolder(_to);
701 
702         if(super.transfer(_to, _value) == true)
703         {
704         	// check if the total balance of token is less than transferred amount
705         	if(privateBalance[msg.sender] <= _value)
706         	{
707         		privateBalance[_to] += privateBalance[msg.sender];
708         		privateBalance[msg.sender] = 0;
709         	}
710         	else
711         	{
712         		privateBalance[msg.sender] = privateBalance[msg.sender].sub(_value);
713         		privateBalance[_to] = privateBalance[_to].add(_value);
714         	}
715 
716         	return true;
717         }
718 
719 
720         return false;
721 
722      }
723 
724 // standard function ERC20, with additional criteria for 2 years lockin period for Founders and Advisors.
725 // Check if the owner of that Address has done the KYC successfully, if yes and having NATEE Private Token
726 // then, will be allowed to make the transfer.
727 
728       function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
729             require(lockAddr[_from] == false); //2 Year Lock Can't Transfer
730 
731             if(privateBalance[_from] < _value)
732             {
733             	if(disableBlock == false)
734             	{	
735          	    	require(OwnerToKycData[msg.sender] > 0, "You Not Have permission to Send");
736             		require(OwnerToKycData[_to] > 0,"You not have permission to recieve");
737         		}
738         	}
739            
740             addHolder(_to);
741 
742             if(super.transferFrom(_from, _to, _value) == true)
743             {
744             	 if(privateBalance[msg.sender] <= _value)
745         		{
746         			privateBalance[_to] += privateBalance[msg.sender];
747         			privateBalance[msg.sender] = 0;
748         		}
749         		else
750         		{
751         			privateBalance[msg.sender] = privateBalance[msg.sender].sub(_value);
752         			privateBalance[_to] = privateBalance[_to].add(_value);
753         		}
754 
755         		return true;
756             }
757             return false;
758 
759       }
760 
761       // function to transfer all asset from the old wallet to new wallet. This is used, just in case, the owner forget the private key.
762       // The owner who which to update the wallet by calling this function must have successfully done KYC and the 6 alpha numeric password
763       // must be used and submit to Seitee Pte Ltd. The company will recover the old wallet address and transfer the assets to the new wallet
764       // address on behave of the owner of the wallet address.  
765       function sosTransfer(bytes32 _name, bytes32 _surname, bytes32 _email,bytes8 _password,address _newAddr) onlyOwners public returns(bool){
766 
767       	uint256 sosHash = uint256(keccak256(abi.encodePacked(_name, _surname , _email, _password)));
768       	address oldAddr = kycSOSToOwner[sosHash];
769       	uint256 idx = OwnerToKycData[oldAddr];
770 
771       	require(allowControl[oldAddr] == false);
772       	if(idx > 0)
773       	{
774       		idx = idx - 1;
775       		if(kycDatas[idx].name == _name &&
776       		   kycDatas[idx].surName == _surname &&
777       		   kycDatas[idx].email == _email &&
778       		   kycDatas[idx].password == _password)
779       		{
780 
781       			kycSOSToOwner[sosHash] = _newAddr;
782       			OwnerToKycData[oldAddr] = 0; // reset it
783       			OwnerToKycData[_newAddr] = idx;
784       			kycDataForOwners[idx] = _newAddr;
785 
786       			emit SOSTranfer(oldAddr, _newAddr);
787 
788       			lockAddr[_newAddr] = lockAddr[oldAddr];
789 
790       			//Transfer All Token to new address
791       			balance[_newAddr] = balance[oldAddr];
792       			balance[oldAddr] = 0;
793 
794       			privateBalance[_newAddr] = privateBalance[oldAddr];
795       			privateBalance[oldAddr] = 0;
796 
797       			emit Transfer(oldAddr, _newAddr, balance[_newAddr]);
798       		}
799       	}
800 
801 
802       	return true;
803       }
804      
805 // function for internal transfer between wallets that the controls have been given to
806 // the company (The owner can revoke these controls after ICO closed). Only the founders
807 // of Seitee Pte Ltd can execute this function. All activities will be publicly logged. 
808 // The user can trace/view the log to check transparency if any founders of the company 
809 // make the transfer of assets from your wallets. Again, Transparency is the key here.
810 
811       function inTransfer(address _from, address _to,uint256 value) onlyOwners public{
812       	require(allowControl[_from] == true); //default = false
813       	require(balance[_from] >= value);
814 
815       	balance[_from] -= value;
816         balance[_to] = balance[_to].add(value);
817 
818         if(privateBalance[_from] <= value)
819         {
820         	privateBalance[_to] += privateBalance[_from];
821         	privateBalance[_from] = 0;
822         }
823         else
824         {
825         	privateBalance[_from] = privateBalance[_from].sub(value);
826         	privateBalance[_to] = privateBalance[_to].add(value);
827         }
828 
829         emit Transfer(_from,_to,value); 
830       }
831 
832 
833      function balanceOfPrivate(address _walletAddress) public view returns (uint256){
834         return privateBalance[_walletAddress]; 
835      }
836 
837 }
838 
839 
840 
841 
842 
843 // Contract for NATEE PRIVATE TOKEN (1 NATEE PRIVATE TOKEN equivalent to 8 NATEE TOKEN)
844 contract NateePrivate {
845 	
846     function redeemToken(address _redeem, uint256 _value) external;
847 	function getMaxHolder() view external returns(uint256);
848 	function getAddressByID(uint256 _id) view external returns(address);
849 	function balancePrivate(address _walletAddress)  public view returns (uint256);
850 	
851 }
852 
853 // The interface of SGDS (Singapore Dollar Stable)
854 contract SGDSInterface{
855   function balanceOf(address tokenOwner) public view returns (uint256 balance);
856   function intTransfer(address _from, address _to, uint256 _value) external;
857   function transferWallet(address _from,address _to) external;
858   function getUserControl(address _addr) external view returns(bool); // if true mean user can control by him. false mean Company can control
859   function useSGDS(address useAddr,uint256 value) external returns(bool);
860   function transfer(address _to, uint256 _value) public returns (bool);
861 
862 }
863 
864 // Interface of NATEE Warrant
865 contract NateeWarrantInterface {
866 
867 	function balanceOf(address tokenOwner) public view returns (uint256 balance);
868 	function redeemWarrant(address _from, uint256 _value) external;
869 	function getWarrantInfo() external view returns(string name_,string symbol_,uint256 supply_ );
870 	function getUserControl(address _addr) external view returns(bool);
871 	function sendWarrant(address _to,uint256 _value) external;
872 	function expireDate() public pure returns (uint32);
873 }
874 
875 
876 
877 // HAVE 5 Type of REFERRAL
878 // 1 Buy 8,000 NATEE Then can get referral code REDEEM AFTER REACH SOFTCAP
879 // 2 FIX RATE REDEEM AFTER REARCH SOFTCAP NO Buy
880 // 3 adjust RATE REDEEM AFTER REARCH SOFTCAP NO Buy
881 // 4 adjust RATE REDEEM IMMEDIATLY NO Buy
882 // 5 FIX RATE REDEEM IMMEDIATLY NO Buy
883 
884 // Contract for marketing by using referral code from above 5 scenarios.
885 contract Marketing is MyToken{
886 	struct REFERAL{
887 		uint8   refType;
888 		uint8   fixRate; // user for type 2 and 5
889 		uint256 redeemCom; // summary commision that redeem
890 		uint256 allCommission;
891 		uint256 summaryInvest;
892 	}
893 
894 	REFERAL[] referals;
895 	mapping (address => uint256) referToID;
896 
897 // Add address for referrer
898 	function addReferal(address _address,uint8 referType,uint8 rate) onlyOwners public{
899 		require(referToID[_address] == 0);
900 		uint256 idx = referals.push(REFERAL(referType,rate,0,0,0));
901 		referToID[_address] = idx;
902 	}
903 
904 
905 // increase bounty/commission rate for those who has successfully registered the address with this smart contract
906 	function addCommission(address _address,uint256 buyToken) internal{
907 		uint256 idx;
908 		if(referToID[_address] > 0)
909 		{
910 			idx = referToID[_address] - 1;
911 			uint256 refType = uint256(referals[idx].refType);
912 			uint256 fixRate = uint256(referals[idx].fixRate);
913 
914 			if(refType == 1 || refType == 3 || refType == 4){
915 				referals[idx].summaryInvest += buyToken;
916 				if(referals[idx].summaryInvest <= 80000){
917 					referals[idx].allCommission =  referals[idx].summaryInvest / 20 / 2; // 5%
918 				}else if(referals[idx].summaryInvest >80000 && referals[idx].summaryInvest <=320000){
919 					referals[idx].allCommission = 2000 + (referals[idx].summaryInvest / 10 / 2); // 10%
920 				}else if(referals[idx].summaryInvest > 320000){
921 					referals[idx].allCommission = 2000 + 12000 + (referals[idx].summaryInvest * 15 / 100 / 2); // 10%					
922 				}
923 			}
924 			else if(refType == 2 || refType == 5){
925 				referals[idx].summaryInvest += buyToken;
926 				referals[idx].allCommission = (referals[idx].summaryInvest * 100) * fixRate / 100 / 2;
927 			}
928 		}
929 	}
930 
931 	function getReferByAddr(address _address) onlyOwners view public returns(uint8 refType,
932 																			 uint8 fixRate,
933 																			 uint256 commision,
934 																			 uint256 allCommission,
935 																			 uint256 summaryInvest){
936 		REFERAL memory refer = referals[referToID[_address]-1];
937 
938 		refType = refer.refType;
939 		fixRate = refer.fixRate;
940 		commision = refer.redeemCom;
941 		allCommission = refer.allCommission;
942 		summaryInvest = refer.summaryInvest;
943 
944 	}
945 // check if the given address is listed in referral list
946 	function checkHaveRefer(address _address) public view returns(bool){
947 		return (referToID[_address] > 0);
948 	}
949 
950 // check the total commission on what you have earned so far, the unit is SGDS (Singapore Dollar Stable)
951 	function getCommission(address addr) public view returns(uint256){
952 		require(referToID[addr] > 0);
953 
954 		return referals[referToID[addr] - 1].allCommission;
955 	}
956 }
957 
958 // ICO Contract
959 //	1. Set allocated tokens for sales during pre-sales, prices the duration for pre-sales is 270 days
960 //	2. Set allocated tokens for sales during public-sales, prices and the duration for public-sales is 90 days.
961 //	3. The entire duration pre-sales / public sales is no more than 270 days (9 months).
962 //	4. If the ICO fails to reach Soft Cap, the investors can request for refund by using SGDS and the company will give back into ETH (the exchange rate and ETH price depends on the market)
963 //	5. There are 2 addresses which will get 1% of fund raised and 5% but not more then 200,000 SGDS . These two addresses helped us in shaping up Business Model and Smart Contract. 
964 
965 contract ICO_Token is  Marketing{
966 
967 	uint256 PRE_ICO_ROUND = 20000000 ;
968 	uint256 ICO_ROUND = 40000000 ;
969 	uint256 TOKEN_PRICE = 50; // 0.5 SGDS PER TOKEN
970 
971 	bool    startICO;  //default = false;
972 	bool    icoPass;
973 	bool    hardCap;
974 	bool    public pauseICO;
975 	uint32  public icoEndTime;
976 	uint32  icoPauseTime;
977 	uint32  icoStartTime;
978 	uint256 totalSell;
979 	uint256 MIN_PRE_ICO_ROUND = 400 ;
980 	uint256 MIN_ICO_ROUND = 400 ;
981 	uint256 MAX_ICO_ROUND = 1000000 ;
982 	uint256 SOFT_CAP = 10000000 ;
983 
984 	uint256 _1Token = 1 ether;
985 
986 	SGDSInterface public sgds;
987 	NateeWarrantInterface public warrant;
988 
989 	mapping (address => uint256) totalBuyICO;
990 	mapping (address => uint256) redeemed;
991 	mapping (address => uint256) redeemPercent;
992 	mapping (address => uint256) redeemMax;
993 
994 
995 	event StartICO(address indexed admin, uint32 startTime,uint32 endTime);
996 	event PassSoftCap(uint32 passTime);
997 	event BuyICO(address indexed addr_,uint256 value);
998 	event BonusWarrant(address indexed,uint256 startRank,uint256 stopRank,uint256 warrantGot);
999 
1000 	event RedeemCommision(address indexed, uint256 sgdsValue,uint256 curCom);
1001 	event Refund(address indexed,uint256 sgds,uint256 totalBuy);
1002 
1003 	constructor() public {
1004 		//sgds = 
1005 		//warrant = 
1006 		pauseICO = false;
1007 		icoEndTime = uint32(now + 365 days); 
1008 	}
1009 
1010 	function pauseSellICO() onlyOwners external{
1011 		require(startICO == true);
1012 		require(pauseICO == false);
1013 		icoPauseTime = uint32(now);
1014 		pauseICO = true;
1015 
1016 	}
1017 // NEW FUNCTION 
1018 	function resumeSellICO() onlyOwners external{
1019 		require(pauseICO == true);
1020 		pauseICO = false;
1021 		// Add Time That PAUSE BUT NOT MORE THEN 2 YEAR
1022 		uint32   pauseTime = uint32(now) - icoPauseTime;
1023 		uint32   maxSellTime = icoStartTime + 730 days;
1024 		icoEndTime += pauseTime;
1025 		if(icoEndTime > maxSellTime) icoEndTime = maxSellTime;
1026 		pauseICO = false;
1027 	}
1028 
1029 // Function to kicks start the ICO, Auto triggered as soon as the first 
1030 // NATEE TOKEN transfer committed.
1031 
1032 	function startSellICO() internal returns(bool){
1033 		require(startICO == false); //  IF Start Already it can't call again
1034 		icoStartTime = uint32(now);
1035 		icoEndTime = uint32(now + 270 days); // ICO 9 month
1036 		startICO = true;
1037 
1038 		emit StartICO(msg.sender,icoStartTime,icoEndTime);
1039 
1040 		return true;
1041 	}
1042 
1043 // this function will be executed automatically as soon as Soft Cap reached. By limited additional 90 days 
1044 // for public-sales in the total remain days is more than 90 days (the entire ICO takes no more than 270 days).
1045 // For example, if the pre-sales takes 200 days, the public sales duration will be 70 days (270-200). 
1046 // Starting from the date that // Soft Cap reached
1047 // if the pre-sales takes 150 days, the public sales duration will be 90 days starting from the date that 
1048 // Soft Cap reached
1049 	function passSoftCap() internal returns(bool){
1050 		icoPass = true;
1051 		// after pass softcap will continue sell 90 days
1052 		if(icoEndTime - uint32(now) > 90 days)
1053 		{
1054 			icoEndTime = uint32(now) + 90 days;
1055 		}
1056 
1057 
1058 		emit PassSoftCap(uint32(now));
1059 	}
1060 
1061 // function to refund, this is used when fails to reach Soft CAP and the ICO takes more than 270 days.
1062 // if Soft Cap reached, no refund
1063 
1064 	function refund() public{
1065 		require(icoPass == false);
1066 		uint32   maxSellTime = icoStartTime + 730 days;
1067 		if(pauseICO == true)
1068 		{
1069 			if(uint32(now) <= maxSellTime)
1070 			{
1071 				return;
1072 			}
1073 		}
1074 		if(uint32(now) >= icoEndTime)
1075 		{
1076 			if(totalBuyICO[msg.sender] > 0) 
1077 			{
1078 				uint256  totalSGDS = totalBuyICO[msg.sender] * TOKEN_PRICE;
1079 				uint256  totalNatee = totalBuyICO[msg.sender] * _1Token;
1080 				require(totalNatee == balance[msg.sender]);
1081 
1082 				emit Refund(msg.sender,totalSGDS,totalBuyICO[msg.sender]);
1083 				totalBuyICO[msg.sender] = 0;
1084 				sgds.transfer(msg.sender,totalSGDS);
1085 			}	
1086 		}
1087 	}
1088 
1089 // This function is to allow the owner of Wallet Address to set the value (Boolean) to grant/not grant the permission to himself/herself.
1090 // This clearly shows that no one else could set the value to the anyone’s Wallet Address, only msg.sender or the executor of this 
1091 // function can set the value in this function.
1092 
1093 	function userSetAllowControl(bool allow) public{
1094 		require(closeICO == true);
1095 		allowControl[msg.sender] = allow;
1096 	}
1097 	
1098 // function to calculate the bonus. The bonus will be paid in Warrant according to listed in Bounty section in NATEE Whitepaper
1099 
1100 	function bonusWarrant(address _addr,uint256 buyToken) internal{
1101 	// 1-4M GOT 50%
1102 	// 4,000,0001 - 12M GOT 40% 	
1103 	// 12,000,0001 - 20M GOT 30%
1104 	// 20,000,0001 - 30M GOT 20%
1105 	// 30,000,0001 - 40M GOT 10%
1106 		uint256  gotWarrant;
1107 
1108 //======= PRE ICO ROUND =============
1109 		if(totalSell <= 4000000)
1110 			gotWarrant = buyToken / 2;  // Got 50%
1111 		else if(totalSell >= 4000001 && totalSell <= 12000000)
1112 		{
1113 			if(totalSell - buyToken < 4000000) // It mean between pre bonus and this bonus
1114 			{
1115 				gotWarrant = (4000000 - (totalSell - buyToken)) / 2;
1116 				gotWarrant += (totalSell - 4000000) * 40 / 100;
1117 			}
1118 			else
1119 			{
1120 				gotWarrant = buyToken * 40 / 100; 
1121 			}
1122 		}
1123 		else if(totalSell >= 12000001 && totalSell <= 20000000)
1124 		{
1125 			if(totalSell - buyToken < 4000000)
1126 			{
1127 				gotWarrant = (4000000 - (totalSell - buyToken)) / 2;
1128 				gotWarrant += 2400000; //8000000 * 40 / 100; fix got 2.4 M Token 
1129 				gotWarrant += (totalSell - 12000000) * 30 / 100; 
1130 			}
1131 			else if(totalSell - buyToken < 12000000 )
1132 			{
1133 				gotWarrant = (12000000 - (totalSell - buyToken)) * 40 / 100;
1134 				gotWarrant += (totalSell - 12000000) * 30 / 100; 				
1135 			}
1136 			else
1137 			{
1138 				gotWarrant = buyToken * 30 / 100; 
1139 			}
1140 		}
1141 		else if(totalSell >= 20000001 && totalSell <= 30000000) // public ROUND
1142 		{
1143 			gotWarrant = buyToken / 5; // 20%
1144 		}
1145 		else if(totalSell >= 30000001 && totalSell <= 40000000)
1146 		{
1147 			if(totalSell - buyToken < 30000000)
1148 			{
1149 				gotWarrant = (30000000 - (totalSell - buyToken)) / 5;
1150 				gotWarrant += (totalSell - 30000000) / 10;
1151 			}
1152 			else
1153 			{
1154 				gotWarrant = buyToken / 10;  // 10%
1155 			}
1156 		}
1157 		else if(totalSell >= 40000001)
1158 		{
1159 			if(totalSell - buyToken < 40000000)
1160 			{
1161 				gotWarrant = (40000000 - (totalSell - buyToken)) / 10;
1162 			}
1163 			else
1164 				gotWarrant = 0;
1165 		}
1166 
1167 //====================================
1168 
1169 		if(gotWarrant > 0)
1170 		{
1171 			gotWarrant = gotWarrant * _1Token;
1172 			warrant.sendWarrant(_addr,gotWarrant);
1173 			emit BonusWarrant(_addr,totalSell - buyToken,totalSell,gotWarrant);
1174 		}
1175 
1176 	}
1177 
1178 // NATEE Token can only be purchased by using SGDS
1179 // function to purchase NATEE token, if the purchase transaction committed, the address will be controlled. 
1180 // The address wont be able to make any transfer 
1181 
1182 	function buyNateeToken(address _addr, uint256 value,bool refer) onlyOwners external returns(bool){
1183 		
1184 		require(closeICO == false);
1185 		require(pauseICO == false);
1186 		require(uint32(now) <= icoEndTime);
1187 		require(value % 2 == 0); // 
1188 
1189 		if(startICO == false) startSellICO();
1190 		uint256  sgdWant;
1191 		uint256  buyToken = value;
1192 
1193 		if(totalSell < PRE_ICO_ROUND)   // Still in PRE ICO ROUND
1194 		{
1195 			require(buyToken >= MIN_PRE_ICO_ROUND);
1196 
1197 			if(buyToken > PRE_ICO_ROUND - totalSell)
1198 			   buyToken = uint256(PRE_ICO_ROUND - totalSell);
1199 		}
1200 		else if(totalSell < PRE_ICO_ROUND + ICO_ROUND)
1201 		{
1202 			require(buyToken >= MIN_ICO_ROUND);
1203 
1204 			if(buyToken > MAX_ICO_ROUND) buyToken = MAX_ICO_ROUND;
1205 			if(buyToken > (PRE_ICO_ROUND + ICO_ROUND) - totalSell)
1206 				buyToken = (PRE_ICO_ROUND + ICO_ROUND) - totalSell;
1207 		}
1208 		
1209 		sgdWant = buyToken * TOKEN_PRICE;
1210 
1211 		require(sgds.balanceOf(_addr) >= sgdWant);
1212 		sgds.intTransfer(_addr,address(this),sgdWant); // All SGSD Will Transfer to this account
1213 		emit BuyICO(_addr, buyToken * _1Token);
1214 
1215 		balance[_addr] += buyToken * _1Token;
1216 		totalBuyICO[_addr] += buyToken;
1217 		//-------------------------------------
1218 		// Add TotalSupply HERE
1219 		totalSupply_ += buyToken * _1Token;
1220 		//-------------------------------------  
1221 		totalSell += buyToken;
1222 		if(totalBuyICO[_addr] >= 8000 && referToID[_addr] == 0)
1223 			addReferal(_addr,1,0);
1224 
1225 		bonusWarrant(_addr,buyToken);
1226 		if(totalSell >= SOFT_CAP && icoPass == false) passSoftCap(); // mean just pass softcap
1227 
1228 		if(totalSell >= PRE_ICO_ROUND + ICO_ROUND && hardCap == false)
1229 		{
1230 			hardCap = true;
1231 			setCloseICO();
1232 		}
1233 		
1234 		setAllowControl(_addr);
1235 		addHolder(_addr);
1236 
1237 		if(refer == true)
1238 			addCommission(_addr,buyToken);
1239 
1240 		emit Transfer(address(this),_addr, buyToken * _1Token);
1241 
1242 
1243 		return true;
1244 	}
1245 
1246 
1247 // function to withdraw the earned commission. This depends on type of referral code you holding. 
1248 // If Soft Cap pass is required, you will earn SGDS and withdraw the commission to be paid in ETH
1249 	
1250 	function redeemCommision(address addr,uint256 value) public{
1251 		require(referToID[addr] > 0);
1252 		uint256 idx = referToID[addr] - 1;
1253 		uint256 refType = uint256(referals[idx].refType);
1254 
1255 		if(refType == 1 || refType == 2 || refType == 3)
1256 			require(icoPass == true);
1257 
1258 		require(value > 0);
1259 		require(value <= referals[idx].allCommission - referals[idx].redeemCom);
1260 
1261 		// TRANSFER SGDS TO address
1262 		referals[idx].redeemCom += value; 
1263 		sgds.transfer(addr,value);
1264 
1265 		emit RedeemCommision(addr,value,referals[idx].allCommission - referals[idx].redeemCom);
1266 
1267 	}
1268 
1269 
1270 // check how many tokens sold. This to display on official natee.io website.
1271 	function getTotalSell() external view returns(uint256){
1272 		return totalSell;
1273 	}
1274 // check how many token purchased from the given address.
1275 	function getTotalBuyICO(address _addr) external view returns(uint256){
1276 		return totalBuyICO[_addr];
1277 	}
1278 
1279 
1280 // VALUE IN SGDS 
1281 // Function for AGC and ICZ REDEEM SHARING  // 100 % = 10000
1282 	function addCOPartner(address addr,uint256 percent,uint256 maxFund) onlyOwners public {
1283 			require(redeemPercent[addr] == 0);
1284 			redeemPercent[addr] = percent;
1285 			redeemMax[addr] = maxFund;
1286 
1287 	}
1288 
1289 	function redeemFund(address addr,uint256 value) public {
1290 		require(icoPass == true);
1291 		require(redeemPercent[addr] > 0);
1292 		uint256 maxRedeem;
1293 
1294 		maxRedeem = (totalSell * TOKEN_PRICE) * redeemPercent[addr] / 10000;  
1295 		if(maxRedeem > redeemMax[addr]) maxRedeem = redeemMax[addr];
1296 
1297 		require(redeemed[addr] + value <= maxRedeem);
1298 
1299 		sgds.transfer(addr,value);
1300 		redeemed[addr] += value;
1301 
1302 	}
1303 
1304 	function checkRedeemFund(address addr) public view returns (uint256) {
1305 		uint256 maxRedeem;
1306 
1307 		maxRedeem = (totalSell * TOKEN_PRICE) * redeemPercent[addr] / 10000;  
1308 		if(maxRedeem > redeemMax[addr]) maxRedeem = redeemMax[addr];
1309 		
1310 		return maxRedeem - redeemed[addr];
1311 
1312 	}
1313 
1314 // Function to close the ICO, this function will transfer the token to founders and advisors
1315 
1316 	function setCloseICO() public {
1317 		require(closeICO == false);
1318 		require(startICO == true);
1319 		require(icoPass == true);
1320 
1321 		if(hardCap == false){
1322 			require(uint32(now) >= icoEndTime);
1323 		}
1324 
1325 
1326 
1327 		uint256 lessAdvisor;
1328 		uint256 maxAdvisor;
1329 		uint256 maxFounder;
1330 		uint256 i;
1331 		closeICO = true;
1332 
1333 		// Count Max Advisor
1334 		maxAdvisor = 0;
1335 		for(i=0;i<advisors.length;i++)
1336 		{
1337 			if(advisors[i] != address(0)) 
1338 				maxAdvisor++;
1339 		}
1340 
1341 		maxFounder = 0;
1342 		for(i=0;i<founders.length;i++)
1343 		{
1344 			if(founders[i] != address(0))
1345 				maxFounder++;
1346 		}
1347 
1348 		TOKEN_PER_ADVISOR = ADVISOR_SUPPLY / maxAdvisor;
1349 
1350 		// Maximum 200,000 Per Advisor or less
1351 		if(TOKEN_PER_ADVISOR > 200000 ether) { 
1352 			TOKEN_PER_ADVISOR = 200000 ether;
1353 		}
1354 
1355 		lessAdvisor = ADVISOR_SUPPLY - (TOKEN_PER_ADVISOR * maxAdvisor);
1356 		// less from Advisor will pay to Founder
1357 
1358 		TOKEN_PER_FOUNDER = (FOUNDER_SUPPLY + lessAdvisor) / maxFounder;
1359 		emit CloseICO();
1360 
1361 		// Start Send Token to Found and Advisor 
1362 		for(i=0;i<advisors.length;i++)
1363 		{
1364 			if(advisors[i] != address(0))
1365 			{
1366 				balance[advisors[i]] += TOKEN_PER_ADVISOR;
1367 				totalSupply_ += TOKEN_PER_ADVISOR;
1368 
1369 				lockAddress(advisors[i]); // THIS ADDRESS WILL LOCK FOR 2 YEAR CAN'T TRANSFER
1370 				addHolder(advisors[i]);
1371 				setAllowControl(advisors[i]);
1372 				emit Transfer(address(this), advisors[i], TOKEN_PER_ADVISOR);
1373 				emit RedeemAdvisor(advisors[i],TOKEN_PER_ADVISOR);
1374 
1375 			}
1376 		}
1377 
1378 		for(i=0;i<founders.length;i++)
1379 		{
1380 			if(founders[i] != address(0))
1381 			{
1382 				balance[founders[i]] += TOKEN_PER_FOUNDER;
1383 				totalSupply_ += TOKEN_PER_FOUNDER;
1384 
1385 				lockAddress(founders[i]);
1386 				addHolder(founders[i]);
1387 				setAllowControl(founders[i]);
1388 				emit Transfer(address(this),founders[i],TOKEN_PER_FOUNDER);
1389 				emit RedeemFounder(founders[i],TOKEN_PER_FOUNDER);
1390 
1391 			}
1392 		}
1393 
1394 	}
1395 
1396 } 
1397 
1398 
1399 // main Conttract of NATEE Token, total token is 100 millions and there is no burn token function.
1400 // The token will be auto generated from this function every time after the payment is confirmed 
1401 // from the buyer. In short, NATEE token will only be issued, based on the payment. 
1402 // There will be no NATEE Token issued in advance. There is no NATEE Token inventory, no stocking,hence, 
1403 // there is no need to have the burning function to burn the token/coin in this Smart Contract unlike others ICOs.
1404 
1405 
1406 contract NATEE is ICO_Token {
1407 	using SafeMath256 for uint256;
1408 	string public name = "NATEE";
1409 	string public symbol = "NATEE"; // Real Name NATEE
1410 	uint256 public decimals = 18;
1411 	
1412 	uint256 public INITIAL_SUPPLY = 100000000 ether;
1413 	
1414 	NateePrivate   public nateePrivate;
1415 	bool privateRedeem;
1416 	uint256 public nateeWExcRate = 100; // SGDS Price
1417 	uint256 public nateeWExcRateExp = 100; //SGDS Price
1418     address public AGC_ADDR;
1419     address public RM_PRIVATE_INVESTOR_ADDR;
1420     address public ICZ_ADDR;
1421     address public SEITEE_INTERNAL_USE;
1422 
1423 	event RedeemNatee(address indexed _addr, uint256 _private,uint256 _gotNatee);
1424 	event RedeemWarrat(address indexed _addr,address _warrant,string symbole,uint256 value);
1425 
1426 	constructor() public {
1427 
1428 		AGC_ADDR = 0xdd25648927291130CBE3f3716A7408182F28b80a; // 1% payment to strategic partne
1429 		addCOPartner(AGC_ADDR,100,30000000);
1430 		RM_PRIVATE_INVESTOR_ADDR = 0x32F359dE611CFe8f8974606633d8bDCBb33D91CB;
1431 	//ICZ is the ICO portal who provides ERC20 solutions and audit NATEE IC
1432 		ICZ_ADDR = 0x1F10C47A07BAc12eDe10270bCe1471bcfCEd4Baf; // 5% payment to ICZ capped at 200k SGD
1433 		addCOPartner(ICZ_ADDR,500,20000000);
1434 		// 20M Internal use to send to NATEE SDK USER 
1435 		SEITEE_INTERNAL_USE = 0x1219058023bE74FA30C663c4aE135E75019464b4;
1436 
1437 		balance[RM_PRIVATE_INVESTOR_ADDR] = 3000000 ether;
1438 		totalSupply_ += 3000000 ether;
1439 		lockAddress(RM_PRIVATE_INVESTOR_ADDR);
1440 		setAllowControl(RM_PRIVATE_INVESTOR_ADDR);
1441 		addHolder(RM_PRIVATE_INVESTOR_ADDR);
1442 		emit Transfer(address(this),RM_PRIVATE_INVESTOR_ADDR,3000000 ether);
1443 
1444 
1445 		balance[SEITEE_INTERNAL_USE] = 20000000 ether;
1446 		totalSupply_ += 20000000 ether;
1447 		setAllowControl(SEITEE_INTERNAL_USE);
1448 		addHolder(SEITEE_INTERNAL_USE);
1449 		emit Transfer(address(this),SEITEE_INTERNAL_USE,20000000 ether);
1450 
1451 
1452 		sgds = SGDSInterface(0xf7EfaF88B380469084f3018271A49fF743899C89);
1453 		warrant = NateeWarrantInterface(0x7F28D94D8dc94809a3f13e6a6e9d56ad0B6708fe);
1454 		nateePrivate = NateePrivate(0x67A9d6d1521E02eCfb4a4C110C673e2c027ec102);
1455 
1456 	}
1457 
1458 // SET SGDS Contract Address
1459 	function setSGDSContractAddress(address _addr) onlyOwners external {
1460 		sgds = SGDSInterface(_addr);
1461 	}
1462 
1463     function setNateePrivate(address _addr)	onlyOwners external {
1464         nateePrivate = NateePrivate(_addr);
1465     }
1466 
1467     function setNateeWarrant(address _addr) onlyOwners external {
1468     	warrant = NateeWarrantInterface(_addr);
1469     }
1470 
1471     function changeWarrantPrice(uint256 normalPrice,uint256 expPrice) onlyOwners external{
1472     	if(uint32(now) < warrant.expireDate())
1473     	{
1474     		nateeWExcRate = normalPrice;
1475     		nateeWExcRateExp = expPrice;
1476     	}
1477     }
1478     
1479 
1480 // function to convert Warrant to NATEE Token, the Warrant holders must have SGDS paid for the conversion fee.
1481 
1482 	function redeemWarrant(address addr,uint256 value) public returns(bool){
1483 		require(owners[msg.sender] == true || addr == msg.sender);
1484 		require(closeICO == true);
1485 		require(sgds.getUserControl(addr) == false);
1486 
1487 		uint256 sgdsPerToken; 
1488 		uint256 totalSGDSUse;
1489 		uint256 wRedeem;
1490 		uint256 nateeGot;
1491 
1492 		require(warrant.getUserControl(addr) == false);
1493 
1494 		if( uint32(now) <= warrant.expireDate())
1495 			sgdsPerToken = nateeWExcRate;
1496 		else
1497 			sgdsPerToken = nateeWExcRateExp;
1498 
1499 		wRedeem = value / _1Token; 
1500 		require(wRedeem > 0); 
1501 		totalSGDSUse = wRedeem * sgdsPerToken;
1502 
1503 		//check enought SGDS to redeem warrant;
1504 		require(sgds.balanceOf(addr) >= totalSGDSUse);
1505 		// Start Redeem Warrant;
1506 		if(sgds.useSGDS(addr,totalSGDSUse) == true) 
1507 		{
1508 			nateeGot = wRedeem * _1Token;
1509 			warrant.redeemWarrant(addr,nateeGot); // duduct Warrant;
1510 
1511 			balance[addr] += nateeGot;
1512 			// =================================
1513 			// TOTAL SUPPLY INCREATE
1514 			//==================================
1515 			totalSupply_ += nateeGot;
1516 			//==================================
1517 
1518 			addHolder(addr);
1519 			emit Transfer(address(this),addr,nateeGot);
1520 			emit RedeemWarrat(addr,address(warrant),"NATEE-W1",nateeGot);
1521 		}
1522 
1523 		return true;
1524 
1525 	}
1526 
1527 
1528 // function to distribute NATEE PRIVATE TOKEN to early investors (from private-sales) 
1529 	function reddemAllPrivate() onlyOwners public returns(bool){
1530 
1531 		require(privateRedeem == false);
1532 
1533         uint256 maxHolder = nateePrivate.getMaxHolder();
1534         address tempAddr;
1535         uint256 priToken;
1536         uint256  nateeGot;
1537         uint256 i;
1538         for(i=0;i<maxHolder;i++)
1539         {
1540             tempAddr = nateePrivate.getAddressByID(i);
1541             priToken = nateePrivate.balancePrivate(tempAddr);
1542             if(priToken > 0)
1543             {
1544             nateeGot = priToken * 8;
1545             nateePrivate.redeemToken(tempAddr,priToken);
1546             balance[tempAddr] += nateeGot;
1547             totalSupply_ += nateeGot;
1548             privateBalance[tempAddr] += nateeGot;
1549             allowControl[tempAddr] = true;
1550 
1551             addHolder(tempAddr);
1552             emit Transfer( address(this), tempAddr, nateeGot);
1553             emit RedeemNatee(tempAddr,priToken,nateeGot);
1554             }
1555         }
1556 
1557         privateRedeem = true;
1558     }
1559 
1560 }