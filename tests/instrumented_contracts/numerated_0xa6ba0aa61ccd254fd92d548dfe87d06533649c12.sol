1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13         uint256 c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         uint256 c = a / b;
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         assert(b <= a);
25         return a - b;
26     }
27 
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         assert(c >= a);
31         return c;
32     }
33 }
34 
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42     address public owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48      * account.
49      */
50     function Ownable() public {
51         owner = msg.sender;
52     }
53 
54     /**
55      * @dev Throws if called by any account other than the owner.
56      */
57     modifier onlyOwner() {
58         require(msg.sender == owner);
59         _;
60     }
61 
62     // Return true if sender is owner or super-owner of the contract
63     function isOwner() internal view returns(bool success) {
64         if (msg.sender == owner) return true;
65         return false;
66     }
67 
68     /**
69      * @dev Allows the current owner to transfer control of the contract to a newOwner.
70      * @param newOwner The address to transfer ownership to.
71      */
72     function transferOwnership(address newOwner) onlyOwner public {
73         require(newOwner != address(0));
74         OwnershipTransferred(owner, newOwner);
75         owner = newOwner;
76     }
77 }
78 
79 /**
80  * @title ERC20Basic
81  * @dev Simpler version of ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/179
83  */
84 contract ERC20Basic {
85     uint256 public totalSupply;
86     function balanceOf(address who) public view returns (uint256);
87     function transfer(address to, uint256 value) public returns (bool);
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 }
90 
91 /**
92  * @title ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/20
94  */
95 contract ERC20 is ERC20Basic {
96     function allowance(address owner, address spender) public view returns (uint256);
97     function transferFrom(address from, address to, uint256 value) public returns (bool);
98     function approve(address spender, uint256 value) public returns (bool);
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 /**
103  * @title Basic token
104  * @dev Basic version of StandardToken, with no allowances.
105  */
106 contract BasicToken is ERC20Basic {
107     using SafeMath for uint256;
108 
109     mapping(address => uint256) balances;
110 
111     /**
112     * @dev transfer token for a specified address
113     * @param _to The address to transfer to.
114     * @param _value The amount to be transferred.
115     */
116     function transfer(address _to, uint256 _value) public returns (bool) {
117         require(_to != address(0));
118         require(_value <= balances[msg.sender]);
119 
120         // SafeMath.sub will throw if there is not enough balance.
121         balances[msg.sender] = balances[msg.sender].sub(_value);
122         balances[_to] = balances[_to].add(_value);
123         Transfer(msg.sender, _to, _value);
124         return true;
125     }
126 
127     /**
128     * @dev Gets the balance of the specified address.
129     * @param _owner The address to query the the balance of.
130     * @return An uint256 representing the amount owned by the passed address.
131     */
132     function balanceOf(address _owner) public view returns (uint256 balance) {
133         return balances[_owner];
134     }
135 
136 }
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * @dev https://github.com/ethereum/EIPs/issues/20
143  * @dev Based on code by FirstBlood https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147     mapping (address => mapping (address => uint256)) internal allowed;
148 
149     /**
150     * @dev Transfer tokens from one address to another
151     * @param _from address The address which you want to send tokens from
152     * @param _to address The address which you want to transfer to
153     * @param _value uint256 the amount of tokens to be transferred
154     */
155     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
156         require(_to != address(0));
157         require(_value <= balances[_from]);
158         require(_value <= allowed[_from][msg.sender]);
159 
160         balances[_from] = balances[_from].sub(_value);
161         balances[_to] = balances[_to].add(_value);
162         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
163         Transfer(_from, _to, _value);
164         return true;
165     }
166 
167     /**
168     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169     *
170     * Beware that changing an allowance with this method brings the risk that someone may use both the old
171     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
172     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
173     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174     * @param _spender The address which will spend the funds.
175     * @param _value The amount of tokens to be spent.
176     */
177     function approve(address _spender, uint256 _value) public returns (bool) {
178         allowed[msg.sender][_spender] = _value;
179         Approval(msg.sender, _spender, _value);
180         return true;
181     }
182 
183     /**
184     * @dev Function to check the amount of tokens that an owner allowed to a spender.
185     * @param _owner address The address which owns the funds.
186     * @param _spender address The address which will spend the funds.
187     * @return A uint256 specifying the amount of tokens still available for the spender.
188     */
189     function allowance(address _owner, address _spender) public view returns (uint256) {
190         return allowed[_owner][_spender];
191     }
192 
193     /**
194     * approve should be called when allowed[_spender] == 0. To increment
195     * allowed value is better to use this function to avoid 2 calls (and wait until
196     * the first transaction is mined)
197     * From MonolithDAO Token.sol
198     */
199     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
200         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
201         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
202         return true;
203     }
204 
205     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
206         uint oldValue = allowed[msg.sender][_spender];
207         if (_subtractedValue > oldValue) {
208             allowed[msg.sender][_spender] = 0;
209         } else {
210             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
211         }
212         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213         return true;
214     }
215 }
216 
217 
218 contract CTESale is Ownable, StandardToken {
219 
220 
221     uint8 public constant TOKEN_DECIMALS = 18;  // decimals
222     uint8 public constant PRE_SALE_PERCENT = 20; // 20%
223 
224     // Public variables of the token
225     string public name = "Career Trust Ecosystem";
226     string public symbol = "CTE";
227     uint8 public decimals = TOKEN_DECIMALS; // 18 decimals is the strongly suggested default, avoid changing it
228 
229 
230     uint256 public totalSupply = 5000000000 * (10 ** uint256(TOKEN_DECIMALS)); // Five billion
231     uint256 public preSaleSupply; // PRE_SALE_PERCENT / 20 * totalSupply
232     uint256 public soldSupply = 0; // current supply tokens for sell
233     uint256 public sellSupply = 0;
234     uint256 public buySupply = 0;
235     bool public stopSell = false;
236     bool public stopBuy = false;
237 
238     /*
239     	Sell/Buy prices in wei
240     	1 ETH = 10^18 of wei
241     */
242     uint256 public buyExchangeRate = 8000;   // 8000 CTE tokens per 1 ETHs
243     uint256 public sellExchangeRate = 40000;  // 1 ETH need 40000 CTE token
244     address public ethFundDeposit;  // deposit address for ETH for CTE Team.
245 
246 
247     bool public allowTransfers = true; // if true then allow coin transfers
248 
249 
250     mapping (address => bool) public frozenAccount;
251 
252     bool public enableInternalLock = true; // if false then allow coin transfers by internal sell lock
253     mapping (address => bool) public internalLockAccount;
254 
255 
256 
257     /* This generates a public event on the blockchain that will notify clients */
258     event FrozenFunds(address target, bool frozen);
259     event IncreasePreSaleSupply(uint256 _value);
260     event DecreasePreSaleSupply(uint256 _value);
261     event IncreaseSoldSaleSupply(uint256 _value);
262     event DecreaseSoldSaleSupply(uint256 _value);
263 
264 
265     /* Initializes contract with initial supply tokens to the creator of the contract */
266     function CTESale() public {
267         balances[msg.sender] = totalSupply;                 // Give the creator all initial tokens
268         preSaleSupply = totalSupply * PRE_SALE_PERCENT / 100;      // preSaleSupply
269 
270         ethFundDeposit = msg.sender;                        // deposit eth
271         allowTransfers = false;
272     }
273 
274     function _isUserInternalLock() internal view returns (bool) {
275         return (enableInternalLock && internalLockAccount[msg.sender]);
276     }
277 
278     /// @dev increase the token's supply
279     function increasePreSaleSupply (uint256 _value) onlyOwner public {
280         require (_value + preSaleSupply < totalSupply);
281         preSaleSupply += _value;
282         IncreasePreSaleSupply(_value);
283     }
284 
285     /// @dev decrease the token's supply
286     function decreasePreSaleSupply (uint256 _value) onlyOwner public {
287         require (preSaleSupply - _value > 0);
288         preSaleSupply -= _value;
289         DecreasePreSaleSupply(_value);
290     }
291 
292     /// @dev increase the token's supply
293     function increaseSoldSaleSupply (uint256 _value) onlyOwner public {
294         require (_value + soldSupply < totalSupply);
295         soldSupply += _value;
296         IncreaseSoldSaleSupply(_value);
297     }
298 
299     /// @dev decrease the token's supply
300     function decreaseSoldSaleSupply (uint256 _value) onlyOwner public {
301         require (soldSupply - _value > 0);
302         soldSupply -= _value;
303         DecreaseSoldSaleSupply(_value);
304     }
305 
306     /// @notice Create `mintedAmount` tokens and send it to `target`
307     /// @param target Address to receive the tokens
308     /// @param mintedAmount the amount of tokens it will receive
309     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
310         balances[target] += mintedAmount;
311         totalSupply += mintedAmount;
312         Transfer(0, this, mintedAmount);
313         Transfer(this, target, mintedAmount);
314     }
315 
316     function destroyToken(address target, uint256 amount) onlyOwner public {
317         balances[target] -= amount;
318         totalSupply -= amount;
319         Transfer(target, this, amount);
320         Transfer(this, 0, amount);
321     }
322 
323 
324     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
325     /// @param target Address to be frozen
326     /// @param freeze either to freeze it or not
327     function freezeAccount(address target, bool freeze) onlyOwner public {
328         frozenAccount[target] = freeze;
329         FrozenFunds(target, freeze);
330     }
331 
332     /// @dev set EthFundDeposit
333     function setEthFundDeposit(address _ethFundDeposit) onlyOwner public {
334         require(_ethFundDeposit != address(0));
335         ethFundDeposit = _ethFundDeposit;
336     }
337 
338     /// @dev sends ETH to CTE team
339     function transferETH() onlyOwner public {
340         require(ethFundDeposit != address(0));
341         require(this.balance != 0);
342         require(ethFundDeposit.send(this.balance));
343     }
344 
345     /// @notice Allow users to buy tokens for `_buyExchangeRate` eth and sell tokens for `_sellExchangeRate` eth
346     /// @param _sellExchangeRate the users can sell to the contract
347     /// @param _buyExchangeRate users can buy from the contract
348     function setExchangeRate(uint256 _sellExchangeRate, uint256 _buyExchangeRate) onlyOwner public {
349         sellExchangeRate = _sellExchangeRate;
350         buyExchangeRate = _buyExchangeRate;
351     }
352 
353     function setExchangeStatus(bool _stopSell, bool _stopBuy) onlyOwner public {
354         stopSell = _stopSell;
355         stopBuy = _stopBuy;
356     }
357 
358     function setAllowTransfers(bool _allowTransfers) onlyOwner public {
359         allowTransfers = _allowTransfers;
360     }
361 
362     // Admin function for transfer coins
363     function transferFromAdmin(address _from, address _to, uint256 _value) onlyOwner public returns (bool) {
364         require(_to != address(0));
365         require(_value <= balances[_from]);
366 
367         // SafeMath.sub will throw if there is not enough balance.
368         balances[_from] = balances[_from].sub(_value);
369         balances[_to] = balances[_to].add(_value);
370         Transfer(_from, _to, _value);
371         return true;
372     }
373 
374     function setEnableInternalLock(bool _isEnable) onlyOwner public {
375         enableInternalLock = _isEnable;
376     }
377 
378     function lockInternalAccount(address target, bool lock) onlyOwner public {
379         require(target != address(0));
380         internalLockAccount[target] = lock;
381     }
382 
383     // sell token, soldSupply, lockAccount
384     function internalSellTokenFromAdmin(address _to, uint256 _value, bool _lock) onlyOwner public returns (bool) {
385         require(_to != address(0));
386         require(_value <= balances[owner]);
387 
388         // SafeMath.sub will throw if there is not enough balance.
389         balances[owner] = balances[owner].sub(_value);
390         balances[_to] = balances[_to].add(_value);
391         soldSupply += _value;
392         sellSupply += _value;
393 
394         Transfer(owner, _to, _value);
395 
396         internalLockAccount[_to] = _lock;     // lock internalSell lock
397 
398         return true;
399     }
400 
401     /***************************************************/
402     /*                        BASE                     */
403     /***************************************************/
404 
405     // @dev override
406     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
407         if (!isOwner()) {
408             require (allowTransfers);
409             require(!frozenAccount[_from]);                                          // Check if sender is frozen
410             require(!frozenAccount[_to]);                                            // Check if recipient is frozen
411             require(!_isUserInternalLock());                                         // Check if recipient is internalSellLock
412         }
413         return super.transferFrom(_from, _to, _value);
414     }
415 
416     // @dev override
417     function transfer(address _to, uint256 _value) public returns (bool) {
418         if (!isOwner()) {
419             require (allowTransfers);
420             require(!frozenAccount[msg.sender]);                                        // Check if sender is frozen
421             require(!frozenAccount[_to]);                                               // Check if recipient is frozen
422             require(!_isUserInternalLock());                                            // Check if recipient is internalSellLock
423         }
424         return super.transfer(_to, _value);
425     }
426 
427 
428     /// @dev send ether to contract
429     function pay() payable public {}
430 
431 
432     /// @notice Buy tokens from contract by sending ether
433     function buy() payable public {
434         uint256 amount = msg.value.mul(buyExchangeRate);
435 
436         require(!stopBuy);
437         require(amount <= balances[owner]);
438 
439         // SafeMath.sub will throw if there is not enough balance.
440         balances[owner] = balances[owner].sub(amount);
441         balances[msg.sender] = balances[msg.sender].add(amount);
442 
443         soldSupply += amount;
444         buySupply += amount;
445 
446         Transfer(owner, msg.sender, amount);
447     }
448 
449     /// @notice Sell `amount` tokens to contract
450     /// @param amount amount of tokens to be sold
451     function sell(uint256 amount) public {
452         uint256 ethAmount = amount.div(sellExchangeRate);
453         require(!stopSell);
454         require(this.balance >= ethAmount);      // checks if the contract has enough ether to buy
455         require(ethAmount >= 1);      // checks if the contract has enough ether to buy
456 
457         require(balances[msg.sender] >= amount);                   // Check if the sender has enough
458         require(balances[owner] + amount > balances[owner]);       // Check for overflows
459         require(!frozenAccount[msg.sender]);                        // Check if sender is frozen
460         require(!_isUserInternalLock());                                            // Check if recipient is internalSellLock
461 
462         // SafeMath.add will throw if there is not enough balance.
463         balances[owner] = balances[owner].add(amount);
464         balances[msg.sender] = balances[msg.sender].sub(amount);
465 
466         soldSupply -= amount;
467         sellSupply += amount;
468 
469         Transfer(msg.sender, owner, amount);
470 
471         msg.sender.transfer(ethAmount);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
472     }
473 }