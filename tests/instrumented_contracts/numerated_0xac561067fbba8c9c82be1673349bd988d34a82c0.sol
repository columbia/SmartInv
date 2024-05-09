1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57   address public owner;
58 
59 
60   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62 
63   /**
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67   function Ownable() public {
68     owner = msg.sender;
69   }
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74   modifier onlyOwner() {
75     require(msg.sender == owner);
76     _;
77   }
78 
79   /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param newOwner The address to transfer ownership to.
82    */
83   function transferOwnership(address newOwner) public onlyOwner {
84     require(newOwner != address(0));
85     OwnershipTransferred(owner, newOwner);
86     owner = newOwner;
87   }
88 
89 }
90 
91 
92 /**
93  * @title Claimable
94  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
95  * This allows the new owner to accept the transfer.
96  */
97 contract Claimable is Ownable {
98   address public pendingOwner;
99 
100   /**
101    * @dev Modifier throws if called by any account other than the pendingOwner.
102    */
103   modifier onlyPendingOwner() {
104     require(msg.sender == pendingOwner);
105     _;
106   }
107 
108   /**
109    * @dev Allows the current owner to set the pendingOwner address.
110    * @param newOwner The address to transfer ownership to.
111    */
112   function transferOwnership(address newOwner) onlyOwner public {
113     pendingOwner = newOwner;
114   }
115 
116   /**
117    * @dev Allows the pendingOwner address to finalize the transfer.
118    */
119   function claimOwnership() onlyPendingOwner public {
120     OwnershipTransferred(owner, pendingOwner);
121     owner = pendingOwner;
122     pendingOwner = address(0);
123   }
124 }
125 
126 
127 /**
128  * @title ERC20Basic
129  * @dev Simpler version of ERC20 interface
130  * @dev see https://github.com/ethereum/EIPs/issues/179
131  */
132 contract ERC20Basic {
133   function totalSupply() public view returns (uint256);
134   function balanceOf(address who) public view returns (uint256);
135   function transfer(address to, uint256 value) public returns (bool);
136   event Transfer(address indexed from, address indexed to, uint256 value);
137 }
138 
139 
140 
141 /**
142  * @title ERC20 interface
143  * @dev see https://github.com/ethereum/EIPs/issues/20
144  */
145 contract ERC20 is ERC20Basic {
146   function allowance(address owner, address spender) public view returns (uint256);
147   function transferFrom(address from, address to, uint256 value) public returns (bool);
148   function approve(address spender, uint256 value) public returns (bool);
149   event Approval(address indexed owner, address indexed spender, uint256 value);
150 }
151 
152 
153 /**
154  * @title Basic token
155  * @dev Basic version of StandardToken, with no allowances.
156  */
157 contract BasicToken is ERC20Basic {
158   using SafeMath for uint256;
159 
160   mapping(address => uint256) balances;
161 
162   uint256 totalSupply_;
163 
164   /**
165   * @dev total number of tokens in existence
166   */
167   function totalSupply() public view returns (uint256) {
168     return totalSupply_;
169   }
170 
171   /**
172   * @dev transfer token for a specified address
173   * @param _to The address to transfer to.
174   * @param _value The amount to be transferred.
175   */
176   function transfer(address _to, uint256 _value) public returns (bool) {
177     require(_to != address(0));
178     require(_value <= balances[msg.sender]);
179 
180     // SafeMath.sub will throw if there is not enough balance.
181     balances[msg.sender] = balances[msg.sender].sub(_value);
182     balances[_to] = balances[_to].add(_value);
183     Transfer(msg.sender, _to, _value);
184     return true;
185   }
186 
187   /**
188   * @dev Gets the balance of the specified address.
189   * @param _owner The address to query the the balance of.
190   * @return An uint256 representing the amount owned by the passed address.
191   */
192   function balanceOf(address _owner) public view returns (uint256 balance) {
193     return balances[_owner];
194   }
195 
196 }
197 
198 
199 /**
200  * @title Standard ERC20 token
201  *
202  * @dev Implementation of the basic standard token.
203  * @dev https://github.com/ethereum/EIPs/issues/20
204  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
205  */
206 contract StandardToken is ERC20, BasicToken {
207 
208   mapping (address => mapping (address => uint256)) internal allowed;
209 
210 
211   /**
212    * @dev Transfer tokens from one address to another
213    * @param _from address The address which you want to send tokens from
214    * @param _to address The address which you want to transfer to
215    * @param _value uint256 the amount of tokens to be transferred
216    */
217   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
218     require(_to != address(0));
219     require(_value <= balances[_from]);
220     require(_value <= allowed[_from][msg.sender]);
221 
222     balances[_from] = balances[_from].sub(_value);
223     balances[_to] = balances[_to].add(_value);
224     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
225     Transfer(_from, _to, _value);
226     return true;
227   }
228 
229   /**
230    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
231    *
232    * Beware that changing an allowance with this method brings the risk that someone may use both the old
233    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
234    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
235    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
236    * @param _spender The address which will spend the funds.
237    * @param _value The amount of tokens to be spent.
238    */
239   function approve(address _spender, uint256 _value) public returns (bool) {
240     allowed[msg.sender][_spender] = _value;
241     Approval(msg.sender, _spender, _value);
242     return true;
243   }
244 
245   /**
246    * @dev Function to check the amount of tokens that an owner allowed to a spender.
247    * @param _owner address The address which owns the funds.
248    * @param _spender address The address which will spend the funds.
249    * @return A uint256 specifying the amount of tokens still available for the spender.
250    */
251   function allowance(address _owner, address _spender) public view returns (uint256) {
252     return allowed[_owner][_spender];
253   }
254 
255   /**
256    * @dev Increase the amount of tokens that an owner allowed to a spender.
257    *
258    * approve should be called when allowed[_spender] == 0. To increment
259    * allowed value is better to use this function to avoid 2 calls (and wait until
260    * the first transaction is mined)
261    * From MonolithDAO Token.sol
262    * @param _spender The address which will spend the funds.
263    * @param _addedValue The amount of tokens to increase the allowance by.
264    */
265   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
266     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
267     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
268     return true;
269   }
270 
271   /**
272    * @dev Decrease the amount of tokens that an owner allowed to a spender.
273    *
274    * approve should be called when allowed[_spender] == 0. To decrement
275    * allowed value is better to use this function to avoid 2 calls (and wait until
276    * the first transaction is mined)
277    * From MonolithDAO Token.sol
278    * @param _spender The address which will spend the funds.
279    * @param _subtractedValue The amount of tokens to decrease the allowance by.
280    */
281   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
282     uint oldValue = allowed[msg.sender][_spender];
283     if (_subtractedValue > oldValue) {
284       allowed[msg.sender][_spender] = 0;
285     } else {
286       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
287     }
288     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
289     return true;
290   }
291 
292 }
293 
294 
295 /**
296  * @title Mintable token
297  * @dev Simple ERC20 Token example, with mintable token creation
298  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
299  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
300  */
301 contract MintableToken is StandardToken, Claimable {
302   event Mint(address indexed to, uint256 amount);
303   event MintFinished();
304 
305   bool public mintingFinished = false;
306 
307 
308   modifier canMint() {
309     require(!mintingFinished);
310     _;
311   }
312 
313   /**
314    * @dev Function to mint tokens
315    * @param _to The address that will receive the minted tokens.
316    * @param _amount The amount of tokens to mint.
317    * @return A boolean that indicates if the operation was successful.
318    */
319   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
320     totalSupply_ = totalSupply_.add(_amount);
321     balances[_to] = balances[_to].add(_amount);
322     Mint(_to, _amount);
323     Transfer(address(0), _to, _amount);
324     return true;
325   }
326 
327   /**
328    * @dev Function to stop minting new tokens.
329    * @return True if the operation was successful.
330    */
331   function finishMinting() onlyOwner canMint public returns (bool) {
332     mintingFinished = true;
333     MintFinished();
334     return true;
335   }
336 }
337 
338 //--------------------------------------------------
339 
340 contract LimitedTransferToken is ERC20 {
341 
342   /**
343    * @dev Checks whether it can transfer or otherwise throws.
344    */
345   modifier canTransfer(address _sender, uint256 _value) {
346    require(_value <= transferableTokens(_sender, uint64(now)));
347    _;
348   }
349 
350   /**
351    * @dev Checks modifier and allows transfer if tokens are not locked.
352    * @param _to The address that will receive the tokens.
353    * @param _value The amount of tokens to be transferred.
354    */
355   function transfer(address _to, uint256 _value) canTransfer(msg.sender, _value) public returns (bool) {
356     return super.transfer(_to, _value);
357   }
358 
359   /**
360   * @dev Checks modifier and allows transfer if tokens are not locked.
361   * @param _from The address that will send the tokens.
362   * @param _to The address that will receive the tokens.
363   * @param _value The amount of tokens to be transferred.
364   */
365   function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from, _value) public returns (bool) {
366     return super.transferFrom(_from, _to, _value);
367   }
368 
369   /**
370    * @dev Default transferable tokens function returns all tokens for a holder (no limit).
371    * @dev Overwriting transferableTokens(address holder, uint64 time) is the way to provide the
372    * specific logic for limiting token transferability for a holder over time.
373    */
374   function transferableTokens(address holder, uint64 /*time*/) public view returns (uint256) {
375     return balanceOf(holder);
376   }
377 }
378 
379 
380 
381 contract ISmartToken {
382     bool public transfersEnabled = false;
383 
384     // triggered when a smart token is deployed - the _token address is defined for forward compatibility, in case we want to trigger the event from a factory
385     event NewSmartToken(address _token);
386     // triggered when the total supply is increased
387     event Issuance(uint256 _amount);
388     // triggered when the total supply is decreased
389     event Destruction(uint256 _amount);
390 
391     function disableTransfers(bool _disable) public;
392     function issue(address _to, uint256 _amount) public;
393     function destroy(address _from, uint256 _amount) public;
394 }
395 
396 
397 contract LimitedTransferBancorSmartToken is MintableToken, ISmartToken, LimitedTransferToken {
398     /**
399      * @dev Throws if destroy flag is not enabled.
400      */
401     modifier canDestroy() {
402         require(destroyEnabled);
403         _;
404     }
405 
406     // We add this flag to avoid users and owner from destroy tokens during crowdsale,
407     // This flag is set to false by default and blocks destroy function,
408     // We enable destroy option on finalize, so destroy will be possible after the crowdsale.
409     bool public destroyEnabled = false;
410 
411     function setDestroyEnabled(bool _enable) onlyOwner public {
412         destroyEnabled = _enable;
413     }
414 
415     //@Override
416     function disableTransfers(bool _disable) onlyOwner public {
417         transfersEnabled = !_disable;
418     }
419 
420     //@Override
421     function issue(address _to, uint256 _amount) onlyOwner public {
422         require(super.mint(_to, _amount));
423         Issuance(_amount);
424     }
425 
426     //@Override
427     function destroy(address _from, uint256 _amount) canDestroy public {
428 
429         require(msg.sender == _from || msg.sender == owner); // validate input
430 
431         balances[_from] = balances[_from].sub(_amount);
432         totalSupply_ = totalSupply_.sub(_amount);
433 
434         Destruction(_amount);
435         Transfer(_from, 0x0, _amount);
436     }
437 
438     // Enable/Disable token transfer
439     // Tokens will be locked in their wallets until the end of the Crowdsale.
440     // @holder - token`s owner
441     // @time - not used (framework unneeded functionality)
442     //
443     // @Override
444     function transferableTokens(address holder, uint64 time) public constant returns (uint256) {
445         require(transfersEnabled);
446         return super.transferableTokens(holder, time);
447     }
448 }
449 
450 
451 /**
452   A Token which is 'Bancor' compatible and can mint new tokens and pause token-transfer functionality
453 */
454 contract KiroboSmartToken is LimitedTransferBancorSmartToken {
455 
456   string public constant name = "Kirobo Smart Token";
457 
458   string public constant symbol = "KBO";
459 
460   uint8 public constant decimals = 18;
461 
462   uint256 public constant INITIAL_SUPPLY = ((10 ** uint256(10) ) * (10 ** uint256(decimals)));
463 
464   function KiroboSmartToken() public {
465       //Apart of 'Bancor' computability - triggered when a smart token is deployed
466       totalSupply_ = INITIAL_SUPPLY;
467       balances[msg.sender] = INITIAL_SUPPLY;
468       Transfer(0x0, msg.sender, INITIAL_SUPPLY);
469       NewSmartToken(address(this));
470     }
471 }