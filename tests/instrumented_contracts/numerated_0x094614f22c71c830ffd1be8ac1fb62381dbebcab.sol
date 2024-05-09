1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that revert on error
7  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, reverts on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     uint256 c = a * b;
23     require(c / a == b);
24 
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     require(b > 0); // Solidity only automatically asserts when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36     return c;
37   }
38 
39   /**
40   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41   */
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43     require(b <= a);
44     uint256 c = a - b;
45 
46     return c;
47   }
48 
49   /**
50   * @dev Adds two numbers, reverts on overflow.
51   */
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     require(c >= a);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61   * reverts when dividing by zero.
62   */
63   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64     require(b != 0);
65     return a % b;
66   }
67 }
68 
69 
70 /**
71  * @title Ownable
72  * @dev The Ownable contract has an owner address, and provides basic authorization control
73  * functions, this simplifies the implementation of "user permissions".
74  */
75 contract Ownable {
76   address private _owner;
77 
78 
79   event OwnershipRenounced(address indexed previousOwner);
80   event OwnershipTransferred(
81     address indexed previousOwner,
82     address indexed newOwner
83   );
84 
85 
86   /**
87    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
88    * account.
89    */
90   constructor() public {
91     _owner = msg.sender;
92   }
93 
94   /**
95    * @return the address of the owner.
96    */
97   function owner() public view returns(address) {
98     return _owner;
99   }
100 
101   /**
102    * @dev Throws if called by any account other than the owner.
103    */
104   modifier onlyOwner() {
105     require(isOwner());
106     _;
107   }
108 
109   /**
110    * @return true if `msg.sender` is the owner of the contract.
111    */
112   function isOwner() public view returns(bool) {
113     return msg.sender == _owner;
114   }
115 
116   /**
117    * @dev Allows the current owner to relinquish control of the contract.
118    * @notice Renouncing to ownership will leave the contract without an owner.
119    * It will not be possible to call the functions with the `onlyOwner`
120    * modifier anymore.
121    */
122   function renounceOwnership() public onlyOwner {
123     emit OwnershipRenounced(_owner);
124     _owner = address(0);
125   }
126 
127   /**
128    * @dev Allows the current owner to transfer control of the contract to a newOwner.
129    * @param newOwner The address to transfer ownership to.
130    */
131   function transferOwnership(address newOwner) public onlyOwner {
132     _transferOwnership(newOwner);
133   }
134 
135   /**
136    * @dev Transfers control of the contract to a newOwner.
137    * @param newOwner The address to transfer ownership to.
138    */
139   function _transferOwnership(address newOwner) internal {
140     require(newOwner != address(0));
141     emit OwnershipTransferred(_owner, newOwner);
142     _owner = newOwner;
143   }
144 }
145 
146 
147 contract EIP20Interface {
148     /* This is a slight change to the ERC20 base standard.
149     function totalSupply() constant returns (uint256 supply);
150     is replaced with:
151     uint256 public totalSupply;
152     This automatically creates a getter function for the totalSupply.
153     This is moved to the base contract since public getter functions are not
154     currently recognised as an implementation of the matching abstract
155     function by the compiler.
156     */
157     /// total amount of tokens
158     uint256 public totalSupply;
159 
160     /// @param _owner The address from which the balance will be retrieved
161     /// @return The balance
162     function balanceOf(address _owner) public view returns (uint256 balance);
163 
164     /// @notice send `_value` token to `_to` from `msg.sender`
165     /// @param _to The address of the recipient
166     /// @param _value The amount of token to be transferred
167     /// @return Whether the transfer was successful or not
168     function transfer(address _to, uint256 _value) public returns (bool success);
169 
170     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
171     /// @param _from The address of the sender
172     /// @param _to The address of the recipient
173     /// @param _value The amount of token to be transferred
174     /// @return Whether the transfer was successful or not
175     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
176 
177     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
178     /// @param _spender The address of the account able to transfer the tokens
179     /// @param _value The amount of tokens to be approved for transfer
180     /// @return Whether the approval was successful or not
181     function approve(address _spender, uint256 _value) public returns (bool success);
182 
183     /// @param _owner The address of the account owning tokens
184     /// @param _spender The address of the account able to transfer the tokens
185     /// @return Amount of remaining tokens allowed to spent
186     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
187 
188     // solhint-disable-next-line no-simple-event-func-name  
189     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
190     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
191 }
192 
193 /// @dev A standard ERC20 token (with 18 decimals) contract with manager
194  /// @dev Tokens are initally minted in the contract address
195 contract standardToken is EIP20Interface, Ownable {
196     using SafeMath for uint;
197 
198     mapping (address => uint256) public balances;
199     mapping (address => mapping (address => uint256)) public allowed;
200 
201     uint8 public constant decimals = 18;  
202 
203     string public name;                    
204     string public symbol;                
205     uint public totalSupply;
206 
207     function transfer(address _to, uint _value) public returns (bool success) {
208         require(balances[msg.sender] >= _value, "Insufficient balance");
209         balances[msg.sender] = balances[msg.sender].sub(_value);
210         balances[_to] = balances[_to].add(_value);
211         emit Transfer(msg.sender, _to, _value);
212         return true;
213     }
214 
215     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
216         uint allowance = allowed[_from][msg.sender];
217         require(balances[_from] >= _value && allowance >= _value);
218         balances[_to] = balances[_to].add(_value);
219         balances[_from] = balances[_from].sub(_value);
220         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
221 
222         emit Transfer(_from, _to, _value);
223         return true;
224     }
225 
226     function balanceOf(address _owner) public view returns (uint balance) {
227         return balances[_owner];
228     }
229 
230     function approve(address _spender, uint256 _value) public returns (bool success) {
231         allowed[msg.sender][_spender] = _value;
232         emit Approval(msg.sender, _spender, _value);
233         return true;
234     }
235 
236     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
237         return allowed[_owner][_spender];
238     }   
239 
240     /**
241      * @dev Increase the amount of tokens that an owner allowed to a spender. *
242      * approve should be called when allowed[_spender] == 0. To increment
243      * allowed value is better to use this function to avoid 2 calls (and wait until
244      * the first transaction is mined)
245      * From MonolithDAO Token.sol
246      * @param _spender The address which will spend the funds.
247      * @param _addedValue The amount of tokens to increase the allowance by.
248      */
249     function increaseApproval(address _spender, uint _addedValue) public returns(bool)
250     {
251         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
252         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
253         return true;
254     }
255     
256     /**
257      * @dev Decrease the amount of tokens that an owner allowed to a spender. *
258      * approve should be called when allowed[_spender] == 0. To decrement
259      * allowed value is better to use this function to avoid 2 calls (and wait until
260      * the first transaction is mined)
261      * From MonolithDAO Token.sol
262      * @param _spender The address which will spend the funds.
263      * @param _subtractedValue The amount of tokens to decrease the allowance by.
264      */
265     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool)
266     {
267         uint oldValue = allowed[msg.sender][_spender];
268         if (_subtractedValue > oldValue){
269             allowed[msg.sender][_spender] = 0;
270         } else {
271             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
272         }
273         return true;
274     }
275 }
276 
277 /// @dev A standard token that is linked to another pairToken.
278 /// @dev The total supply of these two tokens should be the same.
279 /// @dev Sending one token to any of these two contract address
280 /// @dev using transfer method will result a receiving of 1:1 another token. 
281 contract pairToken is standardToken {
282     using SafeMath for uint;
283 
284     address public pairAddress;
285 
286     bool public pairInitialized = false;
287 
288     /// @dev Set the pair token contract, can only excute once
289     function initPair(address _pairAddress) public onlyOwner() {
290         require(!pairInitialized, "Pair already initialized");
291         pairAddress = _pairAddress;
292         pairInitialized = true;
293     }
294 
295     /// @dev Override
296     /// @dev A special transfer function that, if the target is either this contract
297     /// @dev or the pair token contract, the token will be sent to this contract, and
298     /// @dev 1:1 pair tokens are sent to the sender.
299     /// @dev When the target address are other than the two paired token address,
300     /// @dev this function behaves exactly the same as in a standard ERC20 token.
301     function transfer(address _to, uint _value) public returns (bool success) {
302         require(balances[msg.sender] >= _value, "Insufficient balance");
303         balances[msg.sender] = balances[msg.sender].sub(_value);
304         if (_to == pairAddress || _to == address(this)) {
305             balances[address(this)] = balances[address(this)].add(_value);
306             pairToken(pairAddress).pairTransfer(msg.sender, _value);
307             emit Exchange(msg.sender, address(this), _value);
308             emit Transfer(msg.sender, _to, _value);
309         } else {
310             balances[_to] = balances[_to].add(_value);
311             emit Transfer(msg.sender, _to, _value);
312         }
313         return true;
314     } 
315 
316     /// @dev Function called by pair token to excute 1:1 exchange of the token.
317     function pairTransfer(address _to, uint _value) external returns (bool success) {
318         require(msg.sender == pairAddress, "Only token pairs can transfer");
319         balances[address(this)] = balances[address(this)].sub(_value);
320         balances[_to] = balances[_to].add(_value);
321         return true;
322     }
323 
324     event Exchange(address indexed _from, address _tokenAddress, uint _value);
325 }
326 
327 /// @dev A pair token that can be mint by sending ether into this contract.
328 /// @dev The price of the token follows price = a*log(t)+b, where a and b are
329 /// @dev two parameters to be set, and t is the current round depends on current
330 /// @dev block height.
331 contract CryptojoyToken is pairToken {
332     using SafeMath for uint;
333 
334     string public name = "cryptojoy token";                    
335     string public symbol = "CJT";                
336     uint public totalSupply = 10**10 * 10**18; // 1 billion
337     uint public miningSupply; // minable part
338 
339     uint constant MAGNITUDE = 10**6;
340     uint constant LOG1DOT5 = 405465; // log(1.5) under MAGNITUDE
341     uint constant THREE_SECOND= 15 * MAGNITUDE / 10; // 1.5 under MAGNITUDE
342     uint constant MINING_INTERVAL = 365; // number of windows that the price is fixed
343 
344     uint public a; // paremeter a of the price fuction price = a*log(t)+b, 18 decimals
345     uint public b; // paremeter b of the price fuction price = a*log(t)+b, 18 decimals
346     uint public blockInterval; // number of blocks where the token price is fixed
347     uint public startBlockNumber; // The starting block that the token can be mint.
348 
349     address public platform;
350     uint public lowerBoundaryETH; // Refuse incoming ETH lower than this value
351     uint public upperBoundaryETH; // Refuse incoming ETH higher than this value
352 
353     uint public supplyPerInterval; // miningSupply / MINING_INTERVAL
354     uint public tokenMint = 0;
355 
356     bool paraInitialized = false;
357 
358     /// @param _beneficiary Address to send the remaining tokens
359     /// @param _miningSupply Amount of tokens of mining
360     constructor(
361         address _beneficiary, 
362         uint _miningSupply)
363         public {
364         require(_miningSupply < totalSupply, "Insufficient total supply");
365         miningSupply = _miningSupply;
366         uint _amount = totalSupply.sub(_miningSupply);
367         balances[address(this)] = miningSupply;
368         balances[_beneficiary] = _amount;
369         supplyPerInterval = miningSupply / MINING_INTERVAL;
370     }
371 
372 
373     /// @dev sets boundaries for incoming tx
374     /// @dev from FoMo3Dlong
375     modifier isWithinLimits(uint _eth) {
376         require(_eth >= lowerBoundaryETH, "pocket lint: not a valid currency");
377         require(_eth <= upperBoundaryETH, "no vitalik, no");
378         _;
379     }
380 
381     /// @dev Initialize the token mint parameters
382     /// @dev Can only be excuted once.
383     function initPara(
384         uint _a, 
385         uint _b, 
386         uint _blockInterval, 
387         uint _startBlockNumber,
388         address _platform,
389         uint _lowerBoundaryETH,
390         uint _upperBoundaryETH) 
391         public 
392         onlyOwner {
393         require(!paraInitialized, "Parameters are already set");
394         require(_lowerBoundaryETH < _upperBoundaryETH, "Lower boundary is larger than upper boundary!");
395         a = _a;
396         b = _b;
397         blockInterval = _blockInterval;
398         startBlockNumber = _startBlockNumber;
399 
400         platform = _platform;
401         lowerBoundaryETH = _lowerBoundaryETH;
402         upperBoundaryETH = _upperBoundaryETH;
403 
404         paraInitialized = true;
405     }
406 
407     function changeWithdraw(address _platform) public onlyOwner {
408         platform = _platform;
409     }
410 
411     /// @dev Mint token based on the current token price.
412     /// @dev The token number is limited during each interval.
413     function buy() public isWithinLimits(msg.value) payable {
414         uint currentStage = getCurrentStage(); // from 1 to MINING_INTERVAL
415         require(tokenMint < currentStage.mul(supplyPerInterval), "No token avaiable");
416         uint currentPrice = calculatePrice(currentStage); // 18 decimal
417         uint amountToBuy = msg.value.mul(10**uint(decimals)).div(currentPrice);
418         
419         if(tokenMint.add(amountToBuy) > currentStage.mul(supplyPerInterval)) {
420             amountToBuy = currentStage.mul(supplyPerInterval).sub(tokenMint);
421             balances[address(this)] = balances[address(this)].sub(amountToBuy);
422             balances[msg.sender] = balances[msg.sender].add(amountToBuy);
423             tokenMint = tokenMint.add(amountToBuy);
424             uint refund = msg.value.sub(amountToBuy.mul(currentPrice).div(10**uint(decimals)));
425             msg.sender.transfer(refund);          
426             platform.transfer(msg.value.sub(refund)); 
427         } else {
428             balances[address(this)] = balances[address(this)].sub(amountToBuy);
429             balances[msg.sender] = balances[msg.sender].add(amountToBuy);
430             tokenMint = tokenMint.add(amountToBuy);
431             platform.transfer(msg.value);
432         }
433         emit Buy(msg.sender, amountToBuy);
434     }
435 
436     function() public payable {
437         buy();
438     }
439 
440     /// @dev Shows the remaining token of the current token mint phase
441     function tokenRemain() public view returns (uint) {
442         uint currentStage = getCurrentStage();
443         return currentStage * supplyPerInterval - tokenMint;
444     }
445 
446     /// @dev Get the current token mint phase between 1 and MINING_INTERVAL
447     function getCurrentStage() public view returns (uint) {
448         require(block.number >= startBlockNumber, "Not started yet");
449         uint currentStage = (block.number.sub(startBlockNumber)).div(blockInterval) + 1;
450         if (currentStage <= MINING_INTERVAL) {
451             return currentStage;
452         } else {
453             return MINING_INTERVAL;
454         }
455     }
456 
457     /// @dev Return the price of one token during the nth stage
458     /// @param stage Current stage from 1 to 365
459     /// @return Price per token
460     function calculatePrice(uint stage) public view returns (uint) {
461         return a.mul(log(stage.mul(MAGNITUDE))).div(MAGNITUDE).add(b);
462     }
463 
464     /// @dev Return the e based logarithm of x demonstrated by Vitalik
465     /// @param input The actual input (>=1) times MAGNITUDE
466     /// @return result The actual output times MAGNITUDE
467     function log(uint input) internal pure returns (uint) {
468         uint x = input;
469         require(x >= MAGNITUDE);
470         if (x == MAGNITUDE) {
471             return 0;
472         }
473         uint result = 0;
474         while (x >= THREE_SECOND) {
475             result += LOG1DOT5;
476             x = x * 2 / 3;
477         }
478         
479         x = x - MAGNITUDE;
480         uint y = x;
481         uint i = 1;
482         while (i < 10) {
483             result = result + (y / i);
484             i += 1;
485             y = y * x / MAGNITUDE;
486             result = result - (y / i);
487             i += 1;
488             y = y * x / MAGNITUDE;
489         }
490         
491         return result;
492     }
493 
494     event Buy(address indexed _buyer, uint _value);
495 }
496 
497 contract CryptojoyStock is pairToken {
498 
499 
500     string public name = "cryptojoy stock";                    
501     string public symbol = "CJS";                
502     uint public totalSupply = 10**10 * 10**18;
503 
504     constructor() public {
505         balances[address(this)] = totalSupply;
506     } 
507 
508 }