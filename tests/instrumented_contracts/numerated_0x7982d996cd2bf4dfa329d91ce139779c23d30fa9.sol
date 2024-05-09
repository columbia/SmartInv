1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract Token {
50 
51     /// @return total amount of tokens
52     function totalSupply() constant returns (uint256 supply) {}
53 
54     /// @param _owner The address from which the balance will be retrieved
55     /// @return The balance
56     function balanceOf(address _owner) constant returns (uint256 balance) {}
57 
58     /// @notice send `_value` token to `_to` from `msg.sender`
59     /// @param _to The address of the recipient
60     /// @param _value The amount of token to be transferred
61     /// @return Whether the transfer was successful or not
62     function transfer(address _to, uint256 _value) returns (bool success) {}
63 
64     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
65     /// @param _from The address of the sender
66     /// @param _to The address of the recipient
67     /// @param _value The amount of token to be transferred
68     /// @return Whether the transfer was successful or not
69     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
70 
71     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
72     /// @param _spender The address of the account able to transfer the tokens
73     /// @param _value The amount of wei to be approved for transfer
74     /// @return Whether the approval was successful or not
75     function approve(address _spender, uint256 _value) returns (bool success) {}
76 
77     /// @param _owner The address of the account owning tokens
78     /// @param _spender The address of the account able to transfer the tokens
79     /// @return Amount of remaining tokens allowed to spent
80     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
81 
82     event Transfer(address indexed _from, address indexed _to, uint256 _value);
83     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
84     
85 }
86 
87 
88 
89 contract StandardToken is Token {
90 
91     function transfer(address _to, uint256 _value) returns (bool success) {
92         //Default assumes totalSupply can't be over max (2^256 - 1).
93         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
94         //Replace the if with this one instead.
95         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
96         if (balances[msg.sender] >= _value && _value > 0) {
97             balances[msg.sender] -= _value;
98             balances[_to] += _value;
99             Transfer(msg.sender, _to, _value);
100             return true;
101         } else { return false; }
102     }
103 
104     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
105         //same as above. Replace this line with the following if you want to protect against wrapping uints.
106         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
107         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
108             balances[_to] += _value;
109             balances[_from] -= _value;
110             allowed[_from][msg.sender] -= _value;
111             Transfer(_from, _to, _value);
112             return true;
113         } else { return false; }
114     }
115 
116     function balanceOf(address _owner) constant returns (uint256 balance) {
117         return balances[_owner];
118     }
119 
120     function approve(address _spender, uint256 _value) returns (bool success) {
121         allowed[msg.sender][_spender] = _value;
122         Approval(msg.sender, _spender, _value);
123         return true;
124     }
125 
126     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
127       return allowed[_owner][_spender];
128     }
129 
130     mapping (address => uint256) balances;
131     mapping (address => mapping (address => uint256)) allowed;
132     uint256 public totalSupply;
133 }
134 
135 
136 //name this contract whatever you'd like
137 contract MuskToken is StandardToken {
138 
139     function () {
140         //if ether is sent to this address, send it back.
141         throw;
142     }
143 
144     /* Public variables of the token */
145 
146     /*
147     NOTE:
148     The following variables are OPTIONAL vanities. One does not have to include them.
149     They allow one to customise the token contract & in no way influences the core functionality.
150     Some wallets/interfaces might not even bother to look at this information.
151     */
152     string public name;                   //fancy name: eg Simon Bucks
153     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
154     string public symbol;                 //An identifier: eg SBX
155     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
156 
157 //
158 // CHANGE THESE VALUES FOR YOUR TOKEN
159 //
160 
161 //make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the 
162 //contract name above is also TutorialToken instead of MuskToken
163 
164     function MuskToken(
165         ) {
166         balances[msg.sender] = 1000000000000000000000000000;               // Give the creator all initial tokens (100000 for example)
167         totalSupply = 1000000000000000000000000000;                        // Update total supply (100000 for example)
168         name = "Musk Token";                                   // Set the name for display purposes
169         decimals = 18;                            // Amount of decimals for display purposes
170         symbol = "MUSK";                               // Set the symbol for display purposes
171     }
172 
173     /* Approves and then calls the receiving contract */
174     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
175         allowed[msg.sender][_spender] = _value;
176         Approval(msg.sender, _spender, _value);
177 
178         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
179         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
180         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
181         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
182         return true;
183     }
184 }
185 
186 /**
187  * @title Ownable
188  * @dev The Ownable contract has an owner address, and provides basic authorization control
189  * functions, this simplifies the implementation of "user permissions".
190  */
191 contract Ownable {
192   address public owner;
193 
194 
195   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
196 
197 
198   /**
199    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
200    * account.
201    */
202   function Ownable() public {
203     owner = msg.sender;
204   }
205 
206   /**
207    * @dev Throws if called by any account other than the owner.
208    */
209   modifier onlyOwner() {
210     require(msg.sender == owner);
211     _;
212   }
213 
214   /**
215    * @dev Allows the current owner to transfer control of the contract to a newOwner.
216    * @param newOwner The address to transfer ownership to.
217    */
218   function transferOwnership(address newOwner) public onlyOwner {
219     require(newOwner != address(0));
220     OwnershipTransferred(owner, newOwner);
221     owner = newOwner;
222   }
223 
224 }
225 
226 contract MuskTokenVault is Ownable {
227     using SafeMath for uint256;
228 
229     //Wallet Addresses for allocation
230     address public teamReserveWallet = 0xBf7E6DC9317dF0e9Fde7847577154e6C5114370d;
231     address public finalReserveWallet = 0xBf7E6DC9317dF0e9Fde7847577154e6C5114370d;
232 
233     //Token Allocations
234     uint256 public teamReserveAllocation = 240 * (10 ** 6) * (10 ** 18);
235     uint256 public finalReserveAllocation = 10 * (10 ** 6) * (10 ** 18);
236 
237     //Total Token Allocations
238     uint256 public totalAllocation = 250 * (10 ** 6) * (10 ** 18);
239 
240     uint256 public teamTimeLock = 2 * 365 days;
241     uint256 public teamVestingStages = 8;
242     uint256 public finalReserveTimeLock = 2 * 365 days;
243 
244     /** Reserve allocations */
245     mapping(address => uint256) public allocations;
246 
247     /** When timeLocks are over (UNIX Timestamp)  */  
248     mapping(address => uint256) public timeLocks;
249 
250     /** How many tokens each reserve wallet has claimed */
251     mapping(address => uint256) public claimed;
252 
253     /** When this vault was locked (UNIX Timestamp)*/
254     uint256 public lockedAt = 0;
255 
256     MuskToken public token;
257 
258     /** Allocated reserve tokens */
259     event Allocated(address wallet, uint256 value);
260 
261     /** Distributed reserved tokens */
262     event Distributed(address wallet, uint256 value);
263 
264     /** Tokens have been locked */
265     event Locked(uint256 lockTime);
266 
267     //Any of the three reserve wallets
268     modifier onlyReserveWallets {
269         require(allocations[msg.sender] > 0);
270         _;
271     }
272 
273     //Only Musk team reserve wallet
274     modifier onlyTeamReserve {
275         require(msg.sender == teamReserveWallet);
276         require(allocations[msg.sender] > 0);
277         _;
278     }
279 
280     //Only final token reserve wallet
281     modifier onlyTokenReserve {
282         require(msg.sender == finalReserveWallet);
283         require(allocations[msg.sender] > 0);
284         _;
285     }
286 
287     //Has not been locked yet
288     modifier notLocked {
289         require(lockedAt == 0);
290         _;
291     }
292 
293     modifier locked {
294         require(lockedAt > 0);
295         _;
296     }
297 
298     //Token allocations have not been set
299     modifier notAllocated {
300         require(allocations[teamReserveWallet] == 0);
301         require(allocations[finalReserveWallet] == 0);
302         _;
303     }
304 
305     function MuskTokenVault(Token _token) public {
306 
307         owner = msg.sender;
308         token = MuskToken(_token);
309         
310     }
311 
312     function allocate() public notLocked notAllocated onlyOwner {
313 
314         //Makes sure Token Contract has the exact number of tokens
315         require(token.balanceOf(address(this)) == totalAllocation);
316         
317         allocations[teamReserveWallet] = teamReserveAllocation;
318         allocations[finalReserveWallet] = finalReserveAllocation;
319 
320         Allocated(teamReserveWallet, teamReserveAllocation);
321         Allocated(finalReserveWallet, finalReserveAllocation);
322 
323         lock();
324     }
325 
326     //Lock the vault for the wallets
327     function lock() internal notLocked onlyOwner {
328 
329         lockedAt = block.timestamp;
330 
331         timeLocks[teamReserveWallet] = lockedAt.add(teamTimeLock);
332         timeLocks[finalReserveWallet] = lockedAt.add(finalReserveTimeLock);
333 
334         Locked(lockedAt);
335     }
336 
337     //In the case locking failed, then allow the owner to reclaim the tokens on the contract.
338     //Recover Tokens in case incorrect amount was sent to contract.
339     function recoverFailedLock() external notLocked notAllocated onlyOwner {
340 
341         // Transfer all tokens on this contract back to the owner
342         require(token.transfer(owner, token.balanceOf(address(this))));
343     }
344 
345     // Total number of tokens currently in the vault
346     function getTotalBalance() public view returns (uint256 tokensCurrentlyInVault) {
347 
348         return token.balanceOf(address(this));
349 
350     }
351 
352     // Number of tokens that are still locked
353     function getLockedBalance() public view onlyReserveWallets returns (uint256 tokensLocked) {
354 
355         return allocations[msg.sender].sub(claimed[msg.sender]);
356 
357     }
358 
359     //Claim tokens for final reserve wallet
360     function claimTokenReserve() onlyTokenReserve locked public {
361 
362         address reserveWallet = msg.sender;
363 
364         // Can't claim before Lock ends
365         require(block.timestamp > timeLocks[reserveWallet]);
366 
367         // Must Only claim once
368         require(claimed[reserveWallet] == 0);
369 
370         uint256 amount = allocations[reserveWallet];
371 
372         claimed[reserveWallet] = amount;
373 
374         require(token.transfer(reserveWallet, amount));
375 
376         Distributed(reserveWallet, amount);
377     }
378 
379     //Claim tokens for Musk team reserve wallet
380     function claimTeamReserve() onlyTeamReserve locked public {
381 
382         uint256 vestingStage = teamVestingStage();
383 
384         //Amount of tokens the team should have at this vesting stage
385         uint256 totalUnlocked = vestingStage.mul(allocations[teamReserveWallet]).div(teamVestingStages);
386 
387         require(totalUnlocked <= allocations[teamReserveWallet]);
388 
389         //Previously claimed tokens must be less than what is unlocked
390         require(claimed[teamReserveWallet] < totalUnlocked);
391 
392         uint256 payment = totalUnlocked.sub(claimed[teamReserveWallet]);
393 
394         claimed[teamReserveWallet] = totalUnlocked;
395 
396         require(token.transfer(teamReserveWallet, payment));
397 
398         Distributed(teamReserveWallet, payment);
399     }
400 
401     //Current Vesting stage for Musk team 
402     function teamVestingStage() public view onlyTeamReserve returns(uint256){
403         
404         // Every 3 months
405         uint256 vestingMonths = teamTimeLock.div(teamVestingStages); 
406 
407         uint256 stage = (block.timestamp.sub(lockedAt)).div(vestingMonths);
408 
409         //Ensures team vesting stage doesn't go past teamVestingStages
410         if(stage > teamVestingStages){
411             stage = teamVestingStages;
412         }
413 
414         return stage;
415 
416     }
417 
418     // Checks if msg.sender can collect tokens
419     function canCollect() public view onlyReserveWallets returns(bool) {
420 
421         return block.timestamp > timeLocks[msg.sender] && claimed[msg.sender] == 0;
422 
423     }
424 
425 }