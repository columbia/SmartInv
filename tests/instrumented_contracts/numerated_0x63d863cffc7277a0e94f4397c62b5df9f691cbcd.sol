1 pragma solidity 0.4.21;
2 
3 /** @title LockableToken
4   * @dev Base contract which allows token issuer control over when token transfer
5   * is allowed globally as well as per address based.
6   */
7 contract LockableToken {
8     // token issuer
9     address public owner;
10 
11     // Check if msg.sender is token issuer
12     modifier isOwner {
13         require(owner == msg.sender);
14         _;
15     }
16 
17     /**
18       * @dev The LockableToken constructor sets the original `owner` of the
19       * contract to the issuer, and sets global lock in locked state.
20       */
21     function LockableToken() public {
22         owner = msg.sender;
23     }
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31 
32   /**
33   * @dev Multiplies two numbers, throws on overflow.
34   */
35   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36     if (a == 0) {
37       return 0;
38     }
39     uint256 c = a * b;
40     assert(c / a == b);
41     return c;
42   }
43 
44   /**
45   * @dev Integer division of two numbers, truncating the quotient.
46   */
47   function div(uint256 a, uint256 b) internal pure returns (uint256) {
48     // assert(b > 0); // Solidity automatically throws when dividing by 0
49     uint256 c = a / b;
50     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51     return c;
52   }
53 
54   /**
55   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
56   */
57   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58     assert(b <= a);
59     return a - b;
60   }
61 
62   /**
63   * @dev Adds two numbers, throws on overflow.
64   */
65   function add(uint256 a, uint256 b) internal pure returns (uint256) {
66     uint256 c = a + b;
67     assert(c >= a);
68     return c;
69   }
70 }
71 
72 /**
73  * @title ERC20Basic
74  * @dev Simpler version of ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/179
76  */
77 contract ERC20Basic {
78   function totalSupply() public view returns (uint256);
79   function balanceOf(address who) public view returns (uint256);
80   function transfer(address to, uint256 value) public returns (bool);
81   event Transfer(address indexed from, address indexed to, uint256 value);
82 }
83 
84 /**
85  * @title Basic token
86  * @dev Basic version of StandardToken, with no allowances.
87  */
88 contract BasicToken is ERC20Basic {
89   using SafeMath for uint256;
90 
91   mapping(address => uint256) balances;
92 
93   uint256 totalSupply_;
94 
95   /**
96   * @dev total number of tokens in existence
97   */
98   function totalSupply() public view returns (uint256) {
99     return totalSupply_;
100   }
101 
102   /**
103   * @dev transfer token for a specified address
104   * @param _to The address to transfer to.
105   * @param _value The amount to be transferred.
106   */
107   function transfer(address _to, uint256 _value) public returns (bool) {
108     require(_to != address(0));
109     require(_value <= balances[msg.sender]);
110 
111     // SafeMath.sub will throw if there is not enough balance.
112     balances[msg.sender] = balances[msg.sender].sub(_value);
113     balances[_to] = balances[_to].add(_value);
114     Transfer(msg.sender, _to, _value);
115     return true;
116   }
117 
118   /**
119   * @dev Gets the balance of the specified address.
120   * @param _owner The address to query the the balance of.
121   * @return An uint256 representing the amount owned by the passed address.
122   */
123   function balanceOf(address _owner) public view returns (uint256 balance) {
124     return balances[_owner];
125   }
126 
127 }
128 
129 /**
130  * @title Burnable Token
131  * @dev Token that can be irreversibly burned (destroyed).
132  */
133 contract BurnableToken is BasicToken {
134 
135   event Burn(address indexed burner, uint256 value);
136 
137   /**
138    * @dev Burns a specific amount of tokens.
139    * @param _value The amount of token to be burned.
140    */
141   function burn(uint256 _value) public {
142     require(_value <= balances[msg.sender]);
143     // no need to require value <= totalSupply, since that would imply the
144     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
145 
146     address burner = msg.sender;
147     balances[burner] = balances[burner].sub(_value);
148     totalSupply_ = totalSupply_.sub(_value);
149     Burn(burner, _value);
150     Transfer(burner, address(0), _value);
151   }
152 }
153 
154 /**
155  * @title Ownable
156  * @dev The Ownable contract has an owner address, and provides basic authorization control
157  * functions, this simplifies the implementation of "user permissions".
158  */
159 contract Ownable {
160   address public owner;
161 
162 
163   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
164 
165 
166   /**
167    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
168    * account.
169    */
170   function Ownable() public {
171     owner = msg.sender;
172   }
173 
174   /**
175    * @dev Throws if called by any account other than the owner.
176    */
177   modifier onlyOwner() {
178     require(msg.sender == owner);
179     _;
180   }
181 
182   /**
183    * @dev Allows the current owner to transfer control of the contract to a newOwner.
184    * @param newOwner The address to transfer ownership to.
185    */
186   function transferOwnership(address newOwner) public onlyOwner {
187     require(newOwner != address(0));
188     OwnershipTransferred(owner, newOwner);
189     owner = newOwner;
190   }
191 
192 }
193 
194 /**
195  * @title ERC20 interface
196  * @dev see https://github.com/ethereum/EIPs/issues/20
197  */
198 contract ERC20 is ERC20Basic {
199   function allowance(address owner, address spender) public view returns (uint256);
200   function transferFrom(address from, address to, uint256 value) public returns (bool);
201   function approve(address spender, uint256 value) public returns (bool);
202   event Approval(address indexed owner, address indexed spender, uint256 value);
203 }
204 
205 /**
206  * @title Standard ERC20 token
207  *
208  * @dev Implementation of the basic standard token.
209  * @dev https://github.com/ethereum/EIPs/issues/20
210  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
211  */
212 contract StandardToken is ERC20, BasicToken {
213 
214   mapping (address => mapping (address => uint256)) internal allowed;
215 
216 
217   /**
218    * @dev Transfer tokens from one address to another
219    * @param _from address The address which you want to send tokens from
220    * @param _to address The address which you want to transfer to
221    * @param _value uint256 the amount of tokens to be transferred
222    */
223   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
224     require(_to != address(0));
225     require(_value <= balances[_from]);
226     require(_value <= allowed[_from][msg.sender]);
227 
228     balances[_from] = balances[_from].sub(_value);
229     balances[_to] = balances[_to].add(_value);
230     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
231     Transfer(_from, _to, _value);
232     return true;
233   }
234 
235   /**
236    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
237    *
238    * Beware that changing an allowance with this method brings the risk that someone may use both the old
239    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
240    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
241    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
242    * @param _spender The address which will spend the funds.
243    * @param _value The amount of tokens to be spent.
244    */
245   function approve(address _spender, uint256 _value) public returns (bool) {
246     allowed[msg.sender][_spender] = _value;
247     Approval(msg.sender, _spender, _value);
248     return true;
249   }
250 
251   /**
252    * @dev Function to check the amount of tokens that an owner allowed to a spender.
253    * @param _owner address The address which owns the funds.
254    * @param _spender address The address which will spend the funds.
255    * @return A uint256 specifying the amount of tokens still available for the spender.
256    */
257   function allowance(address _owner, address _spender) public view returns (uint256) {
258     return allowed[_owner][_spender];
259   }
260 
261   /**
262    * @dev Increase the amount of tokens that an owner allowed to a spender.
263    *
264    * approve should be called when allowed[_spender] == 0. To increment
265    * allowed value is better to use this function to avoid 2 calls (and wait until
266    * the first transaction is mined)
267    * From MonolithDAO Token.sol
268    * @param _spender The address which will spend the funds.
269    * @param _addedValue The amount of tokens to increase the allowance by.
270    */
271   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
272     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
273     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
274     return true;
275   }
276 
277   /**
278    * @dev Decrease the amount of tokens that an owner allowed to a spender.
279    *
280    * approve should be called when allowed[_spender] == 0. To decrement
281    * allowed value is better to use this function to avoid 2 calls (and wait until
282    * the first transaction is mined)
283    * From MonolithDAO Token.sol
284    * @param _spender The address which will spend the funds.
285    * @param _subtractedValue The amount of tokens to decrease the allowance by.
286    */
287   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
288     uint oldValue = allowed[msg.sender][_spender];
289     if (_subtractedValue > oldValue) {
290       allowed[msg.sender][_spender] = 0;
291     } else {
292       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
293     }
294     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
295     return true;
296   }
297 
298 }
299 
300 /**
301  * @title Mintable token
302  * @dev Simple ERC20 Token example, with mintable token creation
303  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
304  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
305  */
306 contract MintableToken is StandardToken, Ownable {
307   event Mint(address indexed to, uint256 amount);
308   event MintFinished();
309 
310   bool public mintingFinished = false;
311 
312 
313   modifier canMint() {
314     require(!mintingFinished);
315     _;
316   }
317 
318   /**
319    * @dev Function to mint tokens
320    * @param _to The address that will receive the minted tokens.
321    * @param _amount The amount of tokens to mint.
322    * @return A boolean that indicates if the operation was successful.
323    */
324   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
325     totalSupply_ = totalSupply_.add(_amount);
326     balances[_to] = balances[_to].add(_amount);
327     Mint(_to, _amount);
328     Transfer(address(0), _to, _amount);
329     return true;
330   }
331 
332   /**
333    * @dev Function to stop minting new tokens.
334    * @return True if the operation was successful.
335    */
336   function finishMinting() onlyOwner canMint public returns (bool) {
337     mintingFinished = true;
338     MintFinished();
339     return true;
340   }
341 }
342 
343 /** @title CNUS Token
344   * An ERC20-compliant token that is transferable only after preordered product
345   * reception is confirmed. Once the product is used by the holder, token lock
346   * will be automatically released.
347   */
348 contract CnusToken is MintableToken, LockableToken, BurnableToken {
349     using SafeMath for uint256;
350 
351     string public name = "CoinUs";
352     string public symbol = "CNUS";
353     uint256 public decimals = 18;
354 
355     // global token transfer lock
356     bool public globalTokenTransferLock;
357 
358     // mapping that provides address based lock. default at the time of issueance
359     // is locked, and will not be transferrable until explicit unlock call for
360     // the address.
361     mapping( address => bool ) public lockedStatusAddress;
362 
363     event Locked(address lockedAddress);
364     event Unlocked(address unlockedaddress);
365 
366     // Check for global lock status to be unlocked
367     modifier checkGlobalTokenTransferLock {
368         require(!globalTokenTransferLock);
369         _;
370     }
371 
372     // Check for address lock to be unlocked
373     modifier checkAddressLock {
374         require(!lockedStatusAddress[msg.sender]);
375         _;
376     }
377 
378     function setGlobalTokenTransferLock(bool locked) public
379     isOwner
380     returns (bool)
381     {
382         globalTokenTransferLock = locked;
383         return globalTokenTransferLock;
384     }
385 
386     /**
387       * @dev Allows token issuer to lock token transfer for an address.
388       * @param target Target address to lock token transfer.
389       */
390     function initialLockAddress(address target) public
391     onlyOwner
392     {
393         require(owner != target);
394         lockedStatusAddress[target] = true;
395         emit Locked(target);
396     }
397 
398     /**
399       * @dev Allows token issuer to lock token transfer for an address.
400       * @param target Target address to lock token transfer.
401       */
402     function lockAddress(address target) public
403     isOwner
404     {
405         require(owner != target);
406         lockedStatusAddress[target] = true;
407         emit Locked(target);
408     }
409 
410     /**
411       * @dev Allows token issuer to unlock token transfer for an address.
412       * @param target Target address to unlock token transfer.
413       */
414     function unlockAddress(address target) public
415     isOwner
416     {
417         lockedStatusAddress[target] = false;
418         emit Unlocked(target);
419     }
420 
421     /** @dev Transfer `_value` token to `_to` from `msg.sender`, on the condition
422       * that global token lock and individual address lock in the `msg.sender`
423       * accountare both released.
424       * @param _to The address of the recipient.
425       * @param _value The amount of token to be transferred.
426       * @return Whether the transfer was successful or not.
427       */
428     function transfer(address _to, uint256 _value)
429     public
430     checkGlobalTokenTransferLock
431     checkAddressLock
432     returns (bool) {
433         require(_to != address(0));
434         require(_value <= balances[msg.sender]);
435 
436         // SafeMath.sub will throw if there is not enough balance.
437         balances[msg.sender] = balances[msg.sender].sub(_value);
438         balances[_to] = balances[_to].add(_value);
439         emit Transfer(msg.sender, _to, _value);
440         return true;
441     }
442 
443     /** @dev Send `_value` token to `_to` from `_from` on the condition
444       * that global token lock and individual address lock in the `from` account
445       * are both released.
446       * @param _from The address of the sender.
447       * @param _to The address of the recipient.
448       * @param _value The amount of token to be transferred.
449       * @return Whether the transfer was successful or not.
450       */
451     function transferFrom(address _from, address _to, uint256 _value)
452     public
453     checkGlobalTokenTransferLock
454     checkAddressLock
455     returns (bool) {
456         require(_to != address(0));
457         require(_value <= balances[_from]);
458         require(_value <= allowed[_from][msg.sender]);
459 
460         balances[_from] = balances[_from].sub(_value);
461         balances[_to] = balances[_to].add(_value);
462         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
463         emit Transfer(_from, _to, _value);
464         return true;
465     }
466 }