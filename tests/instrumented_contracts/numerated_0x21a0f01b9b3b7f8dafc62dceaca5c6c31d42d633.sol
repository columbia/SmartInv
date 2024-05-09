1 pragma solidity ^0.4.18;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   /**
21   * @dev Integer division of two numbers, truncating the quotient.
22   */
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return c;
28   }
29 
30   /**
31   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32   */
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   /**
39   * @dev Adds two numbers, throws on overflow.
40   */
41   function add(uint256 a, uint256 b) internal pure returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 /**
48  * @title Ownable
49  * @dev The Ownable contract has an owner address, and provides basic authorization control
50  * functions, this simplifies the implementation of "user permissions".
51  */
52 contract Ownable {
53   address public owner;
54 
55 
56   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58 
59   /**
60    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
61    * account.
62    */
63   function Ownable() public {
64     owner = msg.sender;
65   }
66 
67   /**
68    * @dev Throws if called by any account other than the owner.
69    */
70   modifier onlyOwner() {
71     require(msg.sender == owner);
72     _;
73   }
74 
75   /**
76    * @dev Allows the current owner to transfer control of the contract to a newOwner.
77    * @param newOwner The address to transfer ownership to.
78    */
79   function transferOwnership(address newOwner) public onlyOwner {
80     require(newOwner != address(0));
81     OwnershipTransferred(owner, newOwner);
82     owner = newOwner;
83   }
84 
85 }
86 
87 
88 //Announcement of an interface for recipient approving
89 interface tokenRecipient { 
90 	function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData)public; 
91 }
92 
93 contract ERC20Basic {
94   function totalSupply() public view returns (uint256);
95   function balanceOf(address who) public view returns (uint256);
96   function transfer(address to, uint256 value) public returns (bool);
97   event Transfer(address indexed from, address indexed to, uint256 value);
98 }
99 
100 /**
101  * @title ERC20 interface
102  * @dev see https://github.com/ethereum/EIPs/issues/20
103  */
104 contract ERC20 is ERC20Basic {
105   function allowance(address owner, address spender) public view returns (uint256);
106   function transferFrom(address from, address to, uint256 value) public returns (bool);
107   function approve(address spender, uint256 value) public returns (bool);
108   event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 
112 contract ShareXERC20 is Ownable{
113 	
114 	//===================public variables definition start==================
115     string public name;															//Name of your Token
116     string public symbol;														//Symbol of your Token
117     uint8 public decimals;														//Decimals of your Token
118     uint256 public totalSupply;													//Maximum amount of Token supplies
119 
120     //define dictionaries of balance
121     mapping (address => uint256) public balanceOf;								//Announce the dictionary of account's balance
122     mapping (address => mapping (address => uint256)) public allowance;			//Announce the dictionary of account's available balance
123 	//===================public variables definition end==================
124 
125 	
126 	//===================events definition start==================    
127     event Transfer(address indexed from, address indexed to, uint256 value);	//Event on blockchain which notify client
128 	//===================events definition end==================
129 	
130 	
131 	//===================Contract Initialization Sequence Definition start===================
132     function ShareXERC20 () public {
133 		decimals=8;															//Assignment of Token's decimals
134 		totalSupply = 1000000000 * 10 ** uint256(decimals);  				//Assignment of Token's total supply with decimals
135         balanceOf[owner] = totalSupply;                						//Assignment of Token's creator initial tokens
136         name = "ShareX";                                   					//Set the name of Token
137         symbol = "SEXC";                               						//Set the symbol of  Token
138         
139     }
140 	//===================Contract Initialization Sequence definition end===================
141 	
142 	//===================Contract behavior & funtions definition start===================
143 	
144 	/*
145 	*	Funtion: Transfer funtions
146 	*	Type:Internal
147 	*	Parameters:
148 			@_from:	address of sender's account
149 			@_to:	address of recipient's account
150 			@_value:transaction amount
151 	*/
152     function _transfer(address _from, address _to, uint _value) internal {
153 		//Fault-tolerant processing
154 		require(_to != 0x0);						//
155         require(balanceOf[_from] >= _value);
156         require(balanceOf[_to] + _value > balanceOf[_to]);
157 
158         //Execute transaction
159 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
160         balanceOf[_from] -= _value;
161         balanceOf[_to] += _value;
162         Transfer(_from, _to, _value);
163 		
164 		//Verify transaction
165         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
166         
167     }
168 	
169 	
170 	/*
171 	*	Funtion: Transfer tokens
172 	*	Type:Public
173 	*	Parameters:
174 			@_to:	address of recipient's account
175 			@_value:transaction amount
176 	*/
177     function transfer(address _to, uint256 _value) public returns (bool success) {
178 		
179         _transfer(msg.sender, _to, _value);
180         return true;
181     }	
182 	
183 	/*
184 	*	Funtion: Transfer tokens from other address
185 	*	Type:Public
186 	*	Parameters:
187 			@_from:	address of sender's account
188 			@_to:	address of recipient's account
189 			@_value:transaction amount
190 	*/
191 
192     function transferFrom(address _from, address _to, uint256 _value) public 
193 	returns (bool success) {
194         require(_value <= allowance[_from][msg.sender]);     					//Allowance verification
195         allowance[_from][msg.sender] -= _value;
196         _transfer(_from, _to, _value);
197         return true;
198     }
199     
200 	/*
201 	*	Funtion: Approve usable amount for an account
202 	*	Type:Public
203 	*	Parameters:
204 			@_spender:	address of spender's account
205 			@_value:	approve amount
206 	*/
207     function approve(address _spender, uint256 _value) public 
208         returns (bool success) {
209         allowance[msg.sender][_spender] = _value;
210         return true;
211         }
212 
213 	/*
214 	*	Funtion: Approve usable amount for other address and then notify the contract
215 	*	Type:Public
216 	*	Parameters:
217 			@_spender:	address of other account
218 			@_value:	approve amount
219 			@_extraData:additional information to send to the approved contract
220 	*/
221     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public 
222         returns (bool success) {
223         tokenRecipient spender = tokenRecipient(_spender);
224         if (approve(_spender, _value)) {
225             spender.receiveApproval(msg.sender, _value, this, _extraData);
226             return true;
227         }
228     }
229     /*
230 	*	Funtion: Transfer owner's authority and account balance
231 	*	Type:Public and onlyOwner
232 	*	Parameters:
233 			@newOwner:	address of newOwner
234 	*/
235     function transferOwnershipWithBalance(address newOwner) onlyOwner public{
236 		if (newOwner != address(0)) {
237 		    _transfer(owner,newOwner,balanceOf[owner]);
238 		    owner = newOwner;
239 		}
240 	}
241    //===================Contract behavior & funtions definition end===================
242 }
243 
244 
245 
246 contract ShareXTokenVault is Ownable {
247     using SafeMath for uint256;
248 
249     //Wallet Addresses for allocation
250     address public teamReserveWallet = 0x78e27c0347fa3afcc31e160b0fbc6f90186fd2b6;
251     address public firstReserveWallet = 0xef2ab7226c1a3d274caad2dec6d79a4db5d5799e;
252     
253     address public CEO = 0x2Fc7607CE5f6c36979CC63aFcDA6D62Df656e4aE;
254     address public COO = 0x08465f80A28E095DEE4BE0692AC1bA1A2E3EEeE9;
255     address public CTO = 0xB22E5Ac6C3a9427C48295806a34f7a3C0FD21443;
256     address public CMO = 0xf34C06cd907AD036b75cee40755b6937176f24c3;
257     address public CPO = 0xa33da3654d5fdaBC4Dd49fB4e6c81C58D28aA74a;
258     address public CEO_TEAM =0xc0e3294E567e965C3Ff3687015fCf88eD3CCC9EA;
259     address public AWD = 0xc0e3294E567e965C3Ff3687015fCf88eD3CCC9EA;
260     
261     uint256 public CEO_SHARE = 45;
262     uint256 public COO_SHARE = 12;
263     uint256 public CTO_SHARE = 9;
264     uint256 public CMO_SHARE = 9;
265     uint256 public CPO_SHARE = 9;
266     uint256 public CEO_TEAM_SHARE =6;
267     uint256 public AWD_SHARE =10;
268     
269     uint256 public DIV = 100;
270 
271     //Token Allocations
272     uint256 public teamReserveAllocation = 16 * (10 ** 7) * (10 ** 8);
273     uint256 public firstReserveAllocation = 4 * (10 ** 7) * (10 ** 8);
274     
275 
276     //Total Token Allocations
277     uint256 public totalAllocation = 2 * (10 ** 8) * (10 ** 8);
278 
279     uint256 public teamVestingStages = 8;
280     //first unlocked Token 
281     uint256 public firstTime =1531584000;  //2018-07-15 00:00:00
282     
283     //teamTimeLock
284     uint256 public teamTimeLock = 2 * 365 days;
285     //team unlocked over
286     uint256 public secondTime =firstTime.add(teamTimeLock);
287 
288 
289     /** Reserve allocations */
290     mapping(address => uint256) public allocations;
291 
292     /** When timeLocks are over (UNIX Timestamp)  */  
293     mapping(address => uint256) public timeLocks;
294 
295     /** How many tokens each reserve wallet has claimed */
296     mapping(address => uint256) public claimed;
297 
298     /** When this vault was locked (UNIX Timestamp)*/
299     uint256 public lockedAt = 0;
300 
301     ShareXERC20 public token;
302 
303     /** Allocated reserve tokens */
304     event Allocated(address wallet, uint256 value);
305 
306     /** Distributed reserved tokens */
307     event Distributed(address wallet, uint256 value);
308 
309     /** Tokens have been locked */
310     event Locked(uint256 lockTime);
311 
312     //Any of the two reserve wallets
313     modifier onlyReserveWallets {
314         require(allocations[msg.sender] > 0);
315         _;
316     }
317 
318     //Only ShareX team reserve wallet
319     modifier onlyTeamReserve {
320         require(msg.sender == teamReserveWallet);
321         require(allocations[msg.sender] > 0);
322         _;
323     }
324 
325     //Only first and second token reserve wallets
326     modifier onlyTokenReserve {
327         require(msg.sender == firstReserveWallet );
328         require(allocations[msg.sender] > 0);
329         _;
330     }
331 
332     //Has not been locked yet
333     modifier notLocked {
334         require(lockedAt == 0);
335         _;
336     }
337 
338     modifier locked {
339         require(lockedAt > 0);
340         _;
341     }
342 
343     //Token allocations have not been set
344     modifier notAllocated {
345         require(allocations[teamReserveWallet] == 0);
346         require(allocations[firstReserveWallet] == 0);
347         _;
348     }
349 
350     function ShareXTokenVault(ERC20 _token) public {
351 
352         owner = msg.sender;
353         token = ShareXERC20(_token);
354         
355     }
356 
357     function allocate() public notLocked notAllocated onlyOwner {
358 
359         //Makes sure Token Contract has the exact number of tokens
360         require(token.balanceOf(address(this)) == totalAllocation);
361         
362         allocations[teamReserveWallet] = teamReserveAllocation;
363         allocations[firstReserveWallet] = firstReserveAllocation;
364 
365         Allocated(teamReserveWallet, teamReserveAllocation);
366         Allocated(firstReserveWallet, firstReserveAllocation);
367 
368         lock();
369     }
370 
371     //Lock the vault for the two wallets
372     function lock() internal notLocked onlyOwner {
373 
374         lockedAt = block.timestamp;
375 
376         // timeLocks[teamReserveWallet] = lockedAt.add(teamTimeLock);
377         timeLocks[teamReserveWallet] = secondTime;
378         
379         // timeLocks[firstReserveWallet] = lockedAt.add(firstReserveTimeLock);
380         timeLocks[firstReserveWallet] = firstTime;
381 
382         Locked(lockedAt);
383     }
384 
385     //In the case locking failed, then allow the owner to reclaim the tokens on the contract.
386     //Recover Tokens in case incorrect amount was sent to contract.
387     function recoverFailedLock() external notLocked notAllocated onlyOwner {
388 
389         // Transfer all tokens on this contract back to the owner
390         require(token.transfer(owner, token.balanceOf(address(this))));
391     }
392 
393     // Total number of tokens currently in the vault
394     function getTotalBalance() public view returns (uint256 tokensCurrentlyInVault) {
395 
396         return token.balanceOf(address(this));
397 
398     }
399 
400     // Number of tokens that are still locked
401     function getLockedBalance() public view onlyReserveWallets returns (uint256 tokensLocked) {
402 
403         return allocations[msg.sender].sub(claimed[msg.sender]);
404 
405     }
406 
407     //Claim tokens for first reserve wallets
408     function claimTokenReserve() onlyTokenReserve locked public {
409 
410         address reserveWallet = msg.sender;
411 
412         // Can't claim before Lock ends
413         require(block.timestamp > timeLocks[reserveWallet]);
414 
415         // Must Only claim once
416         require(claimed[reserveWallet] == 0);
417 
418         uint256 amount = allocations[reserveWallet];
419 
420         claimed[reserveWallet] = amount;
421 
422         require(token.transfer(CEO,amount.mul(CEO_SHARE).div(DIV)));
423         require(token.transfer(COO,amount.mul(COO_SHARE).div(DIV)));
424         require(token.transfer(CTO,amount.mul(CTO_SHARE).div(DIV)));
425         require(token.transfer(CMO,amount.mul(CMO_SHARE).div(DIV)));
426         require(token.transfer(CPO,amount.mul(CPO_SHARE).div(DIV)));
427         require(token.transfer(CEO_TEAM,amount.mul(CEO_TEAM_SHARE).div(DIV)));
428         require(token.transfer(AWD,amount.mul(AWD_SHARE).div(DIV)));
429 
430         Distributed(CEO, amount.mul(CEO_SHARE).div(DIV));
431         Distributed(COO, amount.mul(COO_SHARE).div(DIV));
432         Distributed(CTO, amount.mul(CTO_SHARE).div(DIV));
433         Distributed(CMO, amount.mul(CMO_SHARE).div(DIV));
434         Distributed(CPO, amount.mul(CPO_SHARE).div(DIV));
435         Distributed(CEO_TEAM, amount.mul(CEO_TEAM_SHARE).div(DIV));
436         Distributed(AWD, amount.mul(AWD_SHARE).div(DIV));
437     }
438 
439     //Claim tokens for ShareX team reserve wallet
440     function claimTeamReserve() onlyTeamReserve locked public {
441 
442         uint256 vestingStage = teamVestingStage();
443 
444         //Amount of tokens the team should have at this vesting stage
445         uint256 totalUnlocked = vestingStage.mul(allocations[teamReserveWallet]).div(teamVestingStages);
446 
447         require(totalUnlocked <= allocations[teamReserveWallet]);
448 
449         //Previously claimed tokens must be less than what is unlocked
450         require(claimed[teamReserveWallet] < totalUnlocked);
451 
452         uint256 payment = totalUnlocked.sub(claimed[teamReserveWallet]);
453 
454         claimed[teamReserveWallet] = totalUnlocked;
455 
456         // require(token.transfer(teamReserveWallet, payment));
457         
458         require(token.transfer(AWD,payment));
459         
460         Distributed(AWD, payment);
461     }
462   
463     //Current Vesting stage for ShareX team 
464     function teamVestingStage() public view onlyTeamReserve returns(uint256){
465         
466         // Every 3 months
467         uint256 vestingMonths = teamTimeLock.div(teamVestingStages); 
468 
469         // uint256 stage = (block.timestamp.sub(lockedAt)).div(vestingMonths);
470         uint256 stage  = (block.timestamp).sub(firstTime).div(vestingMonths);
471 
472         //Ensures team vesting stage doesn't go past teamVestingStages
473         if(stage > teamVestingStages){
474             stage = teamVestingStages;
475         }
476 
477         return stage;
478 
479     }
480 
481     // Checks if msg.sender can collect tokens
482     function canCollect() public view onlyReserveWallets returns(bool) {
483 
484         return block.timestamp > timeLocks[msg.sender] && claimed[msg.sender] == 0;
485 
486     }
487 
488 }