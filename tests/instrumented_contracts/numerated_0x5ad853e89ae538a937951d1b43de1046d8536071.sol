1 /**
2   * stake users levs
3   * get fee from trading contract
4   * get eth from trading contract
5   * calculate fee tokens to be generated
6   * distribute fee tokens and lev to users in chunks.
7   * re-purpose it for next trading duration.
8   * what happens to extra fee if not enough trading happened? destroy it.
9   * Stake will have full control over FEE.sol
10   */
11 pragma solidity ^0.4.18;
12 
13 
14 /**
15  * @title SafeMath
16  * @dev Math operations with safety checks that throw on error
17  */
18 library SafeMath {
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     uint256 c = a * b;
21     assert(a == 0 || c / a == b);
22     return c;
23   }
24 
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   function add(uint256 a, uint256 b) internal pure returns (uint256) {
38     uint256 c = a + b;
39     assert(c >= a);
40     return c;
41   }
42 }
43 contract Owned {
44   event OwnerAddition(address indexed owner);
45 
46   event OwnerRemoval(address indexed owner);
47 
48   // owner address to enable admin functions
49   mapping (address => bool) public isOwner;
50 
51   address[] public owners;
52 
53   address public operator;
54 
55   modifier onlyOwner {
56 
57     require(isOwner[msg.sender]);
58     _;
59   }
60 
61   modifier onlyOperator {
62     require(msg.sender == operator);
63     _;
64   }
65 
66   function setOperator(address _operator) external onlyOwner {
67     require(_operator != address(0));
68     operator = _operator;
69   }
70 
71   function removeOwner(address _owner) public onlyOwner {
72     require(owners.length > 1);
73     isOwner[_owner] = false;
74     for (uint i = 0; i < owners.length - 1; i++) {
75       if (owners[i] == _owner) {
76         owners[i] = owners[SafeMath.sub(owners.length, 1)];
77         break;
78       }
79     }
80     owners.length = SafeMath.sub(owners.length, 1);
81     OwnerRemoval(_owner);
82   }
83 
84   function addOwner(address _owner) external onlyOwner {
85     require(_owner != address(0));
86     if(isOwner[_owner]) return;
87     isOwner[_owner] = true;
88     owners.push(_owner);
89     OwnerAddition(_owner);
90   }
91 
92   function setOwners(address[] _owners) internal {
93     for (uint i = 0; i < _owners.length; i++) {
94       require(_owners[i] != address(0));
95       isOwner[_owners[i]] = true;
96       OwnerAddition(_owners[i]);
97     }
98     owners = _owners;
99   }
100 
101   function getOwners() public constant returns (address[])  {
102     return owners;
103   }
104 
105 }
106 
107 pragma solidity ^0.4.18;
108 
109 
110 contract Validating {
111 
112   modifier validAddress(address _address) {
113     require(_address != address(0x0));
114     _;
115   }
116 
117   modifier notZero(uint _number) {
118     require(_number != 0);
119     _;
120   }
121 
122   modifier notEmpty(string _string) {
123     require(bytes(_string).length != 0);
124     _;
125   }
126 
127 }
128 
129 
130 contract Token {
131     /* This is a slight change to the ERC20 base standard.
132     function totalSupply() constant returns (uint256 supply);
133     is replaced with:
134     uint256 public totalSupply;
135     This automatically creates a getter function for the totalSupply.
136     This is moved to the base contract since public getter functions are not
137     currently recognised as an implementation of the matching abstract
138     function by the compiler.
139     */
140     /// total amount of tokens
141     uint256 public totalSupply;
142 
143     /// @param _owner The address from which the balance will be retrieved
144     /// @return The balance
145     function balanceOf(address _owner) public constant returns (uint256 balance);
146 
147     /// @notice send `_value` token to `_to` from `msg.sender`
148     /// @param _to The address of the recipient
149     /// @param _value The amount of token to be transferred
150     /// @return Whether the transfer was successful or not
151     function transfer(address _to, uint256 _value) public returns (bool success);
152 
153     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
154     /// @param _from The address of the sender
155     /// @param _to The address of the recipient
156     /// @param _value The amount of token to be transferred
157     /// @return Whether the transfer was successful or not
158     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
159 
160     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
161     /// @param _spender The address of the account able to transfer the tokens
162     /// @param _value The amount of tokens to be approved for transfer
163     /// @return Whether the approval was successful or not
164     function approve(address _spender, uint256 _value) public returns (bool success);
165 
166     /// @param _owner The address of the account owning tokens
167     /// @param _spender The address of the account able to transfer the tokens
168     /// @return Amount of remaining tokens allowed to spent
169     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
170 
171     event Transfer(address indexed _from, address indexed _to, uint256 _value);
172     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
173 }
174 contract StandardToken is Token {
175 
176     function transfer(address _to, uint256 _value) public returns (bool success) {
177         //Default assumes totalSupply can't be over max (2^256 - 1).
178         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
179         //Replace the if with this one instead.
180         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
181         require(balances[msg.sender] >= _value);
182         balances[msg.sender] -= _value;
183         balances[_to] += _value;
184         Transfer(msg.sender, _to, _value);
185         return true;
186     }
187 
188     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
189         //same as above. Replace this line with the following if you want to protect against wrapping uints.
190         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
191         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
192         balances[_to] += _value;
193         balances[_from] -= _value;
194         allowed[_from][msg.sender] -= _value;
195         Transfer(_from, _to, _value);
196         return true;
197     }
198 
199     function balanceOf(address _owner) public constant returns (uint256 balance) {
200         return balances[_owner];
201     }
202 
203     function approve(address _spender, uint256 _value) public returns (bool success) {
204         allowed[msg.sender][_spender] = _value;
205         Approval(msg.sender, _spender, _value);
206         return true;
207     }
208 
209     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
210       return allowed[_owner][_spender];
211     }
212 
213     mapping (address => uint256) balances;
214     mapping (address => mapping (address => uint256)) allowed;
215 }
216 /**
217   * @title FEE is an ERC20 token used to pay for trading on the exchange.
218   * For deeper rational read https://leverj.io/whitepaper.pdf.
219   * FEE tokens do not have limit. A new token can be generated by owner.
220   */
221 contract Fee is Owned, Validating, StandardToken {
222 
223   /* This notifies clients about the amount burnt */
224   event Burn(address indexed from, uint256 value);
225 
226   string public name;                   //fancy name: eg Simon Bucks
227   uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
228   string public symbol;                 //An identifier: eg SBX
229   uint256 public feeInCirculation;      //total fee in circulation
230   string public version = 'F0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
231   address public minter;
232 
233   modifier onlyMinter {
234     require(msg.sender == minter);
235     _;
236   }
237 
238   /// @notice Constructor to set the owner, tokenName, decimals and symbol
239   function Fee(
240   address[] _owners,
241   string _tokenName,
242   uint8 _decimalUnits,
243   string _tokenSymbol
244   )
245   public
246   notEmpty(_tokenName)
247   notEmpty(_tokenSymbol)
248   {
249     setOwners(_owners);
250     name = _tokenName;
251     decimals = _decimalUnits;
252     symbol = _tokenSymbol;
253   }
254 
255   /// @notice To set a new minter address
256   /// @param _minter The address of the minter
257   function setMinter(address _minter) external onlyOwner validAddress(_minter) {
258     minter = _minter;
259   }
260 
261   /// @notice To eliminate tokens and adjust the price of the FEE tokens
262   /// @param _value Amount of tokens to delete
263   function burnTokens(uint _value) public notZero(_value) {
264     require(balances[msg.sender] >= _value);
265 
266     balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
267     feeInCirculation = SafeMath.sub(feeInCirculation, _value);
268     Burn(msg.sender, _value);
269   }
270 
271   /// @notice To send tokens to another user. New FEE tokens are generated when
272   /// doing this process by the minter
273   /// @param _to The receiver of the tokens
274   /// @param _value The amount o
275   function sendTokens(address _to, uint _value) public onlyMinter validAddress(_to) notZero(_value) {
276     balances[_to] = SafeMath.add(balances[_to], _value);
277     feeInCirculation = SafeMath.add(feeInCirculation, _value);
278     Transfer(msg.sender, _to, _value);
279   }
280 }
281 
282 
283 contract Stake is Owned, Validating {
284   using SafeMath for uint;
285 
286   event StakeEvent(address indexed user, uint levs, uint startBlock, uint endBlock);
287   event RedeemEvent(address indexed user, uint levs, uint feeEarned, uint startBlock, uint endBlock);
288   event FeeCalculated(uint feeCalculated, uint feeReceived, uint weiReceived, uint startBlock, uint endBlock);
289   event StakingInterval(uint startBlock, uint endBlock);
290 
291   // User address to (lev tokens)*(blocks left to end)
292   mapping (address => uint) public levBlocks;
293 
294   // User address to lev tokens at stake
295   mapping (address => uint) public stakes;
296 
297   uint public totalLevs;
298 
299   // Total lev blocks. this will be help not to iterate through full mapping
300   uint public totalLevBlocks;
301 
302   // Wei for each Fee token
303   uint public weiPerFee;
304 
305   // Total fee to be distributed
306   uint public feeForTheStakingInterval;
307 
308   // Lev token reference
309   Token public levToken; //revisit: is there a difference in storage versus using address?
310 
311   // FEE token reference
312   Fee public feeToken; //revisit: is there a difference in storage versus using address?
313 
314   uint public startBlock;
315 
316   uint public endBlock;
317 
318   address public wallet;
319 
320   bool public feeCalculated = false;
321 
322   modifier isStaking {
323     require(startBlock <= block.number && block.number < endBlock);
324     _;
325   }
326 
327   modifier isDoneStaking {
328     require(block.number >= endBlock);
329     _;
330   }
331 
332   function() public payable {
333   }
334 
335   /// @notice Constructor to set all the default values for the owner, wallet,
336   /// weiPerFee, tokenID and endBlock
337   function Stake(
338   address[] _owners,
339   address _operator,
340   address _wallet,
341   uint _weiPerFee,
342   address _levToken
343   ) public
344   validAddress(_wallet)
345   validAddress(_operator)
346   validAddress(_levToken)
347   notZero(_weiPerFee)
348   {
349     setOwners(_owners);
350     operator = _operator;
351     wallet = _wallet;
352     weiPerFee = _weiPerFee;
353     levToken = Token(_levToken);
354   }
355 
356   function version() external pure returns (string) {
357     return "1.0.0";
358   }
359 
360   /// @notice To set the the address of the LEV token
361   /// @param _levToken The token address
362   function setLevToken(address _levToken) external validAddress(_levToken) onlyOwner {
363     levToken = Token(_levToken);
364   }
365 
366   /// @notice To set the FEE token address
367   /// @param _feeToken The address of that token
368   function setFeeToken(address _feeToken) external validAddress(_feeToken) onlyOwner {
369     feeToken = Fee(_feeToken);
370   }
371 
372   /// @notice To set the wallet address by the owner only
373   /// @param _wallet The wallet address
374   function setWallet(address _wallet) external validAddress(_wallet) onlyOwner {
375     wallet = _wallet;
376   }
377 
378   /// @notice Public function to stake tokens executable by any user.
379   /// The user has to approve the staking contract on token before calling this function.
380   /// Refer to the tests for more information
381   /// @param _quantity How many LEV tokens to lock for staking
382   function stakeTokens(uint _quantity) external isStaking notZero(_quantity) {
383     require(levToken.allowance(msg.sender, this) >= _quantity);
384 
385     levBlocks[msg.sender] = levBlocks[msg.sender].add(_quantity.mul(endBlock.sub(block.number)));
386     stakes[msg.sender] = stakes[msg.sender].add(_quantity);
387     totalLevBlocks = totalLevBlocks.add(_quantity.mul(endBlock.sub(block.number)));
388     totalLevs = totalLevs.add(_quantity);
389     require(levToken.transferFrom(msg.sender, this, _quantity));
390     StakeEvent(msg.sender, _quantity, startBlock, endBlock);
391   }
392 
393   function revertFeeCalculatedFlag(bool _flag) external onlyOwner isDoneStaking {
394     feeCalculated = _flag;
395   }
396 
397   /// @notice To update the price of FEE tokens to the current value.
398   /// Executable by the operator only
399   function updateFeeForCurrentStakingInterval() external onlyOperator isDoneStaking {
400     require(feeCalculated == false);
401     uint feeReceived = feeToken.balanceOf(this);
402     feeForTheStakingInterval = feeForTheStakingInterval.add(feeReceived.add(this.balance.div(weiPerFee)));
403     feeCalculated = true;
404     FeeCalculated(feeForTheStakingInterval, feeReceived, this.balance, startBlock, endBlock);
405     if (feeReceived > 0) feeToken.burnTokens(feeReceived);
406     if (this.balance > 0) wallet.transfer(this.balance);
407   }
408 
409   /// @notice To unlock and recover your LEV and FEE tokens after staking and fee to any user
410   function redeemLevAndFeeByStaker() external {
411     redeemLevAndFee(msg.sender);
412   }
413 
414   function redeemLevAndFeeToStakers(address[] _stakers) external onlyOperator {
415     for (uint i = 0; i < _stakers.length; i++) redeemLevAndFee(_stakers[i]);
416   }
417 
418   function redeemLevAndFee(address _staker) private validAddress(_staker) isDoneStaking {
419     require(feeCalculated);
420     require(totalLevBlocks > 0);
421 
422     uint levBlock = levBlocks[_staker];
423     uint stake = stakes[_staker];
424     require(stake > 0);
425 
426     uint feeEarned = levBlock.mul(feeForTheStakingInterval).div(totalLevBlocks);
427     delete stakes[_staker];
428     delete levBlocks[_staker];
429     totalLevs = totalLevs.sub(stake);
430     if (feeEarned > 0) feeToken.sendTokens(_staker, feeEarned);
431     require(levToken.transfer(_staker, stake));
432     RedeemEvent(_staker, stake, feeEarned, startBlock, endBlock);
433   }
434 
435   /// @notice To start a new trading staking-interval where the price of the FEE will be updated
436   /// @param _start The starting block.number of the new staking-interval
437   /// @param _end When the new staking-interval ends in block.number
438   function startNewStakingInterval(uint _start, uint _end)
439   external
440   notZero(_start)
441   notZero(_end)
442   onlyOperator
443   isDoneStaking
444   {
445     require(totalLevs == 0);
446 
447     startBlock = _start;
448     endBlock = _end;
449 
450     // reset
451     totalLevBlocks = 0;
452     feeForTheStakingInterval = 0;
453     feeCalculated = false;
454     StakingInterval(_start, _end);
455   }
456 
457 }