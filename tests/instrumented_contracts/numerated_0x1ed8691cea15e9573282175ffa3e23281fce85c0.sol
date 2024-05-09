1 pragma solidity ^0.4.19;
2 
3 // File: contracts/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 // File: contracts/Owned.sol
36 
37 contract Owned {
38   event OwnerAddition(address indexed owner);
39 
40   event OwnerRemoval(address indexed owner);
41 
42   // owner address to enable admin functions
43   mapping (address => bool) public isOwner;
44 
45   address[] public owners;
46 
47   address public operator;
48 
49   modifier onlyOwner {
50 
51     require(isOwner[msg.sender]);
52     _;
53   }
54 
55   modifier onlyOperator {
56     require(msg.sender == operator);
57     _;
58   }
59 
60   function setOperator(address _operator) external onlyOwner {
61     require(_operator != address(0));
62     operator = _operator;
63   }
64 
65   function removeOwner(address _owner) public onlyOwner {
66     require(owners.length > 1);
67     isOwner[_owner] = false;
68     for (uint i = 0; i < owners.length - 1; i++) {
69       if (owners[i] == _owner) {
70         owners[i] = owners[SafeMath.sub(owners.length, 1)];
71         break;
72       }
73     }
74     owners.length = SafeMath.sub(owners.length, 1);
75     OwnerRemoval(_owner);
76   }
77 
78   function addOwner(address _owner) external onlyOwner {
79     require(_owner != address(0));
80     if(isOwner[_owner]) return;
81     isOwner[_owner] = true;
82     owners.push(_owner);
83     OwnerAddition(_owner);
84   }
85 
86   function setOwners(address[] _owners) internal {
87     for (uint i = 0; i < _owners.length; i++) {
88       require(_owners[i] != address(0));
89       isOwner[_owners[i]] = true;
90       OwnerAddition(_owners[i]);
91     }
92     owners = _owners;
93   }
94 
95   function getOwners() public constant returns (address[])  {
96     return owners;
97   }
98 
99 }
100 
101 // File: contracts/Token.sol
102 
103 // Abstract contract for the full ERC 20 Token standard
104 // https://github.com/ethereum/EIPs/issues/20
105 pragma solidity ^0.4.19;
106 
107 contract Token {
108     /* This is a slight change to the ERC20 base standard.
109     function totalSupply() constant returns (uint256 supply);
110     is replaced with:
111     uint256 public totalSupply;
112     This automatically creates a getter function for the totalSupply.
113     This is moved to the base contract since public getter functions are not
114     currently recognised as an implementation of the matching abstract
115     function by the compiler.
116     */
117     /// total amount of tokens
118     uint256 public totalSupply;
119 
120     /// @param _owner The address from which the balance will be retrieved
121     /// @return The balance
122     function balanceOf(address _owner) public constant returns (uint256 balance);
123 
124     /// @notice send `_value` token to `_to` from `msg.sender`
125     /// @param _to The address of the recipient
126     /// @param _value The amount of token to be transferred
127     /// @return Whether the transfer was successful or not
128     function transfer(address _to, uint256 _value) public returns (bool success);
129 
130     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
131     /// @param _from The address of the sender
132     /// @param _to The address of the recipient
133     /// @param _value The amount of token to be transferred
134     /// @return Whether the transfer was successful or not
135     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
136 
137     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
138     /// @param _spender The address of the account able to transfer the tokens
139     /// @param _value The amount of tokens to be approved for transfer
140     /// @return Whether the approval was successful or not
141     function approve(address _spender, uint256 _value) public returns (bool success);
142 
143     /// @param _owner The address of the account owning tokens
144     /// @param _spender The address of the account able to transfer the tokens
145     /// @return Amount of remaining tokens allowed to spent
146     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
147 
148     event Transfer(address indexed _from, address indexed _to, uint256 _value);
149     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
150 }
151 
152 // File: contracts/StandardToken.sol
153 
154 /*
155 You should inherit from StandardToken or, for a token like you would want to
156 deploy in something like Mist, see HumanStandardToken.sol.
157 (This implements ONLY the standard functions and NOTHING else.
158 If you deploy this, you won't have anything useful.)
159 
160 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
161 .*/
162 pragma solidity ^0.4.19;
163 
164 
165 contract StandardToken is Token {
166 
167     function transfer(address _to, uint256 _value) public returns (bool success) {
168         //Default assumes totalSupply can't be over max (2^256 - 1).
169         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
170         //Replace the if with this one instead.
171         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
172         require(balances[msg.sender] >= _value);
173         balances[msg.sender] -= _value;
174         balances[_to] += _value;
175         Transfer(msg.sender, _to, _value);
176         return true;
177     }
178 
179     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
180         //same as above. Replace this line with the following if you want to protect against wrapping uints.
181         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
182         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
183         balances[_to] += _value;
184         balances[_from] -= _value;
185         allowed[_from][msg.sender] -= _value;
186         Transfer(_from, _to, _value);
187         return true;
188     }
189 
190     function balanceOf(address _owner) public constant returns (uint256 balance) {
191         return balances[_owner];
192     }
193 
194     function approve(address _spender, uint256 _value) public returns (bool success) {
195         allowed[msg.sender][_spender] = _value;
196         Approval(msg.sender, _spender, _value);
197         return true;
198     }
199 
200     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
201       return allowed[_owner][_spender];
202     }
203 
204     mapping (address => uint256) balances;
205     mapping (address => mapping (address => uint256)) allowed;
206 }
207 
208 // File: contracts/Validating.sol
209 
210 contract Validating {
211 
212   modifier validAddress(address _address) {
213     require(_address != address(0x0));
214     _;
215   }
216 
217   modifier notZero(uint _number) {
218     require(_number != 0);
219     _;
220   }
221 
222   modifier notEmpty(string _string) {
223     require(bytes(_string).length != 0);
224     _;
225   }
226 
227 }
228 
229 // File: contracts/Fee.sol
230 
231 /**
232   * @title FEE is an ERC20 token used to pay for trading on the exchange.
233   * For deeper rational read https://leverj.io/whitepaper.pdf.
234   * FEE tokens do not have limit. A new token can be generated by owner.
235   */
236 contract Fee is Owned, Validating, StandardToken {
237 
238   /* This notifies clients about the amount burnt */
239   event Burn(address indexed from, uint256 value);
240 
241   string public name;                   //fancy name: eg Simon Bucks
242   uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
243   string public symbol;                 //An identifier: eg SBX
244   string public version = 'F0.2';       //human 0.1 standard. Just an arbitrary versioning scheme.
245   address public minter;
246 
247   modifier onlyMinter {
248     require(msg.sender == minter);
249     _;
250   }
251 
252   /// @notice Constructor to set the owner, tokenName, decimals and symbol
253   function Fee(
254   address[] _owners,
255   string _tokenName,
256   uint8 _decimalUnits,
257   string _tokenSymbol
258   )
259   public
260   notEmpty(_tokenName)
261   notEmpty(_tokenSymbol)
262   {
263     setOwners(_owners);
264     name = _tokenName;
265     decimals = _decimalUnits;
266     symbol = _tokenSymbol;
267   }
268 
269   /// @notice To set a new minter address
270   /// @param _minter The address of the minter
271   function setMinter(address _minter) external onlyOwner validAddress(_minter) {
272     minter = _minter;
273   }
274 
275   /// @notice To eliminate tokens and adjust the price of the FEE tokens
276   /// @param _value Amount of tokens to delete
277   function burnTokens(uint _value) public notZero(_value) {
278     require(balances[msg.sender] >= _value);
279     balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
280     totalSupply = SafeMath.sub(totalSupply, _value);
281     Burn(msg.sender, _value);
282   }
283 
284   /// @notice To send tokens to another user. New FEE tokens are generated when
285   /// doing this process by the minter
286   /// @param _to The receiver of the tokens
287   /// @param _value The amount o
288   function sendTokens(address _to, uint _value) public onlyMinter validAddress(_to) notZero(_value) {
289     balances[_to] = SafeMath.add(balances[_to], _value);
290     totalSupply = SafeMath.add(totalSupply, _value);
291     Transfer(0x0, _to, _value);
292   }
293 }
294 
295 // File: contracts/GenericCall.sol
296 
297 contract GenericCall {
298 
299   /************************************ abstract **********************************/
300   modifier isAllowed {_;}
301   /********************************************************************************/
302 
303   event Execution(address destination, uint value, bytes data);
304 
305   function execute(address destination, uint value, bytes data) external isAllowed {
306     if (destination.call.value(value)(data)) {
307       Execution(destination, value, data);
308     }
309   }
310 }
311 
312 // File: contracts/Stake.sol
313 
314 /**
315   * stake users levs
316   * get fee from trading contract
317   * get eth from trading contract
318   * calculate fee tokens to be generated
319   * distribute fee tokens and lev to users in chunks.
320   * re-purpose it for next trading duration.
321   * what happens to extra fee if not enough trading happened? destroy it.
322   * Stake will have full control over FEE.sol
323   */
324 pragma solidity ^0.4.19;
325 
326 
327 
328 
329 
330 
331 
332 
333 contract Stake is Owned, Validating, GenericCall {
334   using SafeMath for uint;
335 
336   event StakeEvent(address indexed user, uint levs, uint startBlock, uint endBlock);
337 
338   event RedeemEvent(address indexed user, uint levs, uint feeEarned, uint startBlock, uint endBlock);
339 
340   event FeeCalculated(uint feeCalculated, uint feeReceived, uint weiReceived, uint startBlock, uint endBlock);
341 
342   event StakingInterval(uint startBlock, uint endBlock);
343 
344   // User address to (lev tokens)*(blocks left to end)
345   mapping (address => uint) public levBlocks;
346 
347   // User address to lev tokens at stake
348   mapping (address => uint) public stakes;
349 
350   uint public totalLevs;
351 
352   // Total lev blocks. this will be help not to iterate through full mapping
353   uint public totalLevBlocks;
354 
355   // Wei for each Fee token
356   uint public weiPerFee;
357 
358   // Total fee to be distributed
359   uint public feeForTheStakingInterval;
360 
361   // Lev token reference
362   Token public levToken; //revisit: is there a difference in storage versus using address?
363 
364   // FEE token reference
365   Fee public feeToken; //revisit: is there a difference in storage versus using address?
366 
367   uint public startBlock;
368 
369   uint public endBlock;
370 
371   address public wallet;
372 
373   bool public feeCalculated = false;
374 
375   modifier isStaking {
376     require(startBlock <= block.number && block.number < endBlock);
377     _;
378   }
379 
380   modifier isDoneStaking {
381     require(block.number >= endBlock);
382     _;
383   }
384 
385   modifier isAllowed{
386     require(isOwner[msg.sender]);
387     _;
388   }
389 
390   function() public payable {
391   }
392 
393   /// @notice Constructor to set all the default values for the owner, wallet,
394   /// weiPerFee, tokenID and endBlock
395   function Stake(
396   address[] _owners,
397   address _operator,
398   address _wallet,
399   uint _weiPerFee,
400   address _levToken
401   ) public
402   validAddress(_wallet)
403   validAddress(_operator)
404   validAddress(_levToken)
405   notZero(_weiPerFee)
406   {
407     setOwners(_owners);
408     operator = _operator;
409     wallet = _wallet;
410     weiPerFee = _weiPerFee;
411     levToken = Token(_levToken);
412   }
413 
414   function version() external pure returns (string) {
415     return "1.0.0";
416   }
417 
418   /// @notice To set the the address of the LEV token
419   /// @param _levToken The token address
420   function setLevToken(address _levToken) external validAddress(_levToken) onlyOwner {
421     levToken = Token(_levToken);
422   }
423 
424   /// @notice To set the FEE token address
425   /// @param _feeToken The address of that token
426   function setFeeToken(address _feeToken) external validAddress(_feeToken) onlyOwner {
427     feeToken = Fee(_feeToken);
428   }
429 
430   /// @notice To set the wallet address by the owner only
431   /// @param _wallet The wallet address
432   function setWallet(address _wallet) external validAddress(_wallet) onlyOwner {
433     wallet = _wallet;
434   }
435 
436   /// @notice Public function to stake tokens executable by any user.
437   /// The user has to approve the staking contract on token before calling this function.
438   /// Refer to the tests for more information
439   /// @param _quantity How many LEV tokens to lock for staking
440   function stakeTokens(uint _quantity) external isStaking notZero(_quantity) {
441     require(levToken.allowance(msg.sender, this) >= _quantity);
442 
443     levBlocks[msg.sender] = levBlocks[msg.sender].add(_quantity.mul(endBlock.sub(block.number)));
444     stakes[msg.sender] = stakes[msg.sender].add(_quantity);
445     totalLevBlocks = totalLevBlocks.add(_quantity.mul(endBlock.sub(block.number)));
446     totalLevs = totalLevs.add(_quantity);
447     require(levToken.transferFrom(msg.sender, this, _quantity));
448     StakeEvent(msg.sender, _quantity, startBlock, endBlock);
449   }
450 
451   function revertFeeCalculatedFlag(bool _flag) external onlyOwner isDoneStaking {
452     feeCalculated = _flag;
453   }
454 
455   /// @notice To update the price of FEE tokens to the current value.
456   /// Executable by the operator only
457   function updateFeeForCurrentStakingInterval() external onlyOperator isDoneStaking {
458     require(feeCalculated == false);
459     uint feeReceived = feeToken.balanceOf(this);
460     feeForTheStakingInterval = feeForTheStakingInterval.add(feeReceived.add(this.balance.div(weiPerFee)));
461     feeCalculated = true;
462     FeeCalculated(feeForTheStakingInterval, feeReceived, this.balance, startBlock, endBlock);
463     if (feeReceived > 0) feeToken.burnTokens(feeReceived);
464     if (this.balance > 0) wallet.transfer(this.balance);
465   }
466 
467   /// @notice To unlock and recover your LEV and FEE tokens after staking and fee to any user
468   function redeemLevAndFeeByStaker() external {
469     redeemLevAndFee(msg.sender);
470   }
471 
472   function redeemLevAndFeeToStakers(address[] _stakers) external onlyOperator {
473     for (uint i = 0; i < _stakers.length; i++) redeemLevAndFee(_stakers[i]);
474   }
475 
476   function redeemLevAndFee(address _staker) private validAddress(_staker) isDoneStaking {
477     require(feeCalculated);
478     require(totalLevBlocks > 0);
479 
480     uint levBlock = levBlocks[_staker];
481     uint stake = stakes[_staker];
482     require(stake > 0);
483 
484     uint feeEarned = levBlock.mul(feeForTheStakingInterval).div(totalLevBlocks);
485     delete stakes[_staker];
486     delete levBlocks[_staker];
487     totalLevs = totalLevs.sub(stake);
488     if (feeEarned > 0) feeToken.sendTokens(_staker, feeEarned);
489     require(levToken.transfer(_staker, stake));
490     RedeemEvent(_staker, stake, feeEarned, startBlock, endBlock);
491   }
492 
493   /// @notice To start a new trading staking-interval where the price of the FEE will be updated
494   /// @param _start The starting block.number of the new staking-interval
495   /// @param _end When the new staking-interval ends in block.number
496   function startNewStakingInterval(uint _start, uint _end)
497   external
498   notZero(_start)
499   notZero(_end)
500   onlyOperator
501   isDoneStaking
502   {
503     require(totalLevs == 0);
504 
505     startBlock = _start;
506     endBlock = _end;
507 
508     // reset
509     totalLevBlocks = 0;
510     feeForTheStakingInterval = 0;
511     feeCalculated = false;
512     StakingInterval(_start, _end);
513   }
514 
515 }