1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41   address public owner;
42 
43 
44   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51   function Ownable() public {
52     owner = msg.sender;
53   }
54 
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64 
65   /**
66    * @dev Allows the current owner to transfer control of the contract to a newOwner.
67    * @param newOwner The address to transfer ownership to.
68    */
69   function transferOwnership(address newOwner) public onlyOwner {
70     require(newOwner != address(0));
71     OwnershipTransferred(owner, newOwner);
72     owner = newOwner;
73   }
74 
75 }
76 
77 
78 
79 
80 /**
81  * @title Claimable
82  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
83  * This allows the new owner to accept the transfer.
84  */
85 contract Claimable is Ownable {
86     address public pendingOwner;
87 
88     /**
89      * @dev Modifier throws if called by any account other than the pendingOwner.
90      */
91     modifier onlyPendingOwner() {
92         require(msg.sender == pendingOwner);
93         _;
94     }
95 
96     /**
97      * @dev Allows the current owner to set the pendingOwner address.
98      * @param newOwner The address to transfer ownership to.
99      */
100     function transferOwnership(address newOwner) onlyOwner public {
101         pendingOwner = newOwner;
102     }
103 
104     /**
105      * @dev Allows the pendingOwner address to finalize the transfer.
106      */
107     function claimOwnership() onlyPendingOwner public {
108         OwnershipTransferred(owner, pendingOwner);
109         owner = pendingOwner;
110         pendingOwner = address(0);
111     }
112 }
113 
114 
115 /**
116  * @title ERC20Basic
117  * @dev Simpler version of ERC20 interface
118  * @dev see https://github.com/ethereum/EIPs/issues/179
119  */
120 contract ERC20Basic {
121   uint256 public totalSupply;
122   function balanceOf(address who) public view returns (uint256);
123   function transfer(address to, uint256 value) public returns (bool);
124   event Transfer(address indexed from, address indexed to, uint256 value);
125 }
126 
127 
128 
129 
130 /**
131  * @title ERC20 interface
132  * @dev see https://github.com/ethereum/EIPs/issues/20
133  */
134 contract ERC20 is ERC20Basic {
135   function allowance(address owner, address spender) public view returns (uint256);
136   function transferFrom(address from, address to, uint256 value) public returns (bool);
137   function approve(address spender, uint256 value) public returns (bool);
138   event Approval(address indexed owner, address indexed spender, uint256 value);
139 }
140 
141 
142 
143 
144 /**
145  * @title Basic token
146  * @dev Basic version of StandardToken, with no allowances.
147  */
148 contract BasicToken is ERC20Basic {
149   using SafeMath for uint256;
150 
151   mapping(address => uint256) balances;
152 
153   /**
154   * @dev transfer token for a specified address
155   * @param _to The address to transfer to.
156   * @param _value The amount to be transferred.
157   */
158   function transfer(address _to, uint256 _value) public returns (bool) {
159     require(_to != address(0));
160     require(_value <= balances[msg.sender]);
161 
162     // SafeMath.sub will throw if there is not enough balance.
163     balances[msg.sender] = balances[msg.sender].sub(_value);
164     balances[_to] = balances[_to].add(_value);
165     Transfer(msg.sender, _to, _value);
166     return true;
167   }
168 
169   /**
170   * @dev Gets the balance of the specified address.
171   * @param _owner The address to query the the balance of.
172   * @return An uint256 representing the amount owned by the passed address.
173   */
174   function balanceOf(address _owner) public view returns (uint256 balance) {
175     return balances[_owner];
176   }
177 
178 }
179 
180 
181 /**
182  * @title LimitedTransferToken
183  * @dev LimitedTransferToken defines the generic interface and the implementation to limit token
184  * transferability for different events. It is intended to be used as a base class for other token
185  * contracts.
186  * LimitedTransferToken has been designed to allow for different limiting factors,
187  * this can be achieved by recursively calling super.transferableTokens() until the base class is
188  * hit. For example:
189  *     function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
190  *       return min256(unlockedTokens, super.transferableTokens(holder, time));
191  *     }
192  * A working example is VestedToken.sol:
193  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/VestedToken.sol
194  */
195 
196 contract LimitedTransferToken is ERC20 {
197 
198   /**
199    * @dev Checks whether it can transfer or otherwise throws.
200    */
201   modifier canTransfer(address _sender, uint256 _value) {
202    require(_value <= transferableTokens(_sender, uint64(now)));
203    _;
204   }
205 
206   /**
207    * @dev Checks modifier and allows transfer if tokens are not locked.
208    * @param _to The address that will receive the tokens.
209    * @param _value The amount of tokens to be transferred.
210    */
211   function transfer(address _to, uint256 _value) canTransfer(msg.sender, _value) public returns (bool) {
212     return super.transfer(_to, _value);
213   }
214 
215   /**
216   * @dev Checks modifier and allows transfer if tokens are not locked.
217   * @param _from The address that will send the tokens.
218   * @param _to The address that will receive the tokens.
219   * @param _value The amount of tokens to be transferred.
220   */
221   function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from, _value) public returns (bool) {
222     return super.transferFrom(_from, _to, _value);
223   }
224 
225   /**
226    * @dev Default transferable tokens function returns all tokens for a holder (no limit).
227    * @dev Overwriting transferableTokens(address holder, uint64 time) is the way to provide the
228    * specific logic for limiting token transferability for a holder over time.
229    */
230   function transferableTokens(address holder, uint64 time) public view returns (uint256) {
231     return balanceOf(holder);
232   }
233 }
234 
235 
236 
237 
238 /**
239  * @title Standard ERC20 token
240  *
241  * @dev Implementation of the basic standard token.
242  * @dev https://github.com/ethereum/EIPs/issues/20
243  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
244  */
245 contract StandardToken is ERC20, BasicToken {
246 
247   mapping (address => mapping (address => uint256)) internal allowed;
248 
249 
250   /**
251    * @dev Transfer tokens from one address to another
252    * @param _from address The address which you want to send tokens from
253    * @param _to address The address which you want to transfer to
254    * @param _value uint256 the amount of tokens to be transferred
255    */
256   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
257     require(_to != address(0));
258     require(_value <= balances[_from]);
259     require(_value <= allowed[_from][msg.sender]);
260 
261     balances[_from] = balances[_from].sub(_value);
262     balances[_to] = balances[_to].add(_value);
263     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
264     Transfer(_from, _to, _value);
265     return true;
266   }
267 
268   /**
269    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
270    *
271    * Beware that changing an allowance with this method brings the risk that someone may use both the old
272    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
273    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
274    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
275    * @param _spender The address which will spend the funds.
276    * @param _value The amount of tokens to be spent.
277    */
278   function approve(address _spender, uint256 _value) public returns (bool) {
279     allowed[msg.sender][_spender] = _value;
280     Approval(msg.sender, _spender, _value);
281     return true;
282   }
283 
284   /**
285    * @dev Function to check the amount of tokens that an owner allowed to a spender.
286    * @param _owner address The address which owns the funds.
287    * @param _spender address The address which will spend the funds.
288    * @return A uint256 specifying the amount of tokens still available for the spender.
289    */
290   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
291     return allowed[_owner][_spender];
292   }
293 
294   /**
295    * approve should be called when allowed[_spender] == 0. To increment
296    * allowed value is better to use this function to avoid 2 calls (and wait until
297    * the first transaction is mined)
298    * From MonolithDAO Token.sol
299    */
300   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
301     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
302     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
303     return true;
304   }
305 
306   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
307     uint oldValue = allowed[msg.sender][_spender];
308     if (_subtractedValue > oldValue) {
309       allowed[msg.sender][_spender] = 0;
310     } else {
311       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
312     }
313     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
314     return true;
315   }
316 
317 }
318 
319 
320 
321 
322 /**
323  * @title Mintable token
324  * @dev Simple ERC20 Token example, with mintable token creation
325  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
326  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
327  */
328 
329 contract MintableToken is StandardToken, Claimable {
330   event Mint(address indexed to, uint256 amount);
331   event MintFinished();
332 
333   bool public mintingFinished = false;
334 
335 
336   modifier canMint() {
337     require(!mintingFinished);
338     _;
339   }
340 
341   /**
342    * @dev Function to mint tokens
343    * @param _to The address that will receive the minted tokens.
344    * @param _amount The amount of tokens to mint.
345    * @return A boolean that indicates if the operation was successful.
346    */
347   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
348     totalSupply = totalSupply.add(_amount);
349     balances[_to] = balances[_to].add(_amount);
350     Mint(_to, _amount);
351     Transfer(address(0), _to, _amount);
352     return true;
353   }
354 
355   /**
356    * @dev Function to stop minting new tokens.
357    * @return True if the operation was successful.
358    */
359   function finishMinting() onlyOwner public returns (bool) {
360     mintingFinished = true;
361     MintFinished();
362     return true;
363   }
364 }
365 
366 /*
367     Smart Token interface
368 */
369 contract ISmartToken {
370 
371     // =================================================================================================================
372     //                                      Members
373     // =================================================================================================================
374 
375     bool public transfersEnabled = false;
376 
377     // =================================================================================================================
378     //                                      Event
379     // =================================================================================================================
380 
381     // triggered when a smart token is deployed - the _token address is defined for forward compatibility, in case we want to trigger the event from a factory
382     event NewSmartToken(address _token);
383     // triggered when the total supply is increased
384     event Issuance(uint256 _amount);
385     // triggered when the total supply is decreased
386     event Destruction(uint256 _amount);
387 
388     // =================================================================================================================
389     //                                      Functions
390     // =================================================================================================================
391 
392     function disableTransfers(bool _disable) public;
393     function issue(address _to, uint256 _amount) public;
394     function destroy(address _from, uint256 _amount) public;
395 }
396 
397 
398 /**
399     BancorSmartToken
400 */
401 contract LimitedTransferBancorSmartToken is MintableToken, ISmartToken, LimitedTransferToken {
402 
403     // =================================================================================================================
404     //                                      Modifiers
405     // =================================================================================================================
406 
407     /**
408      * @dev Throws if destroy flag is not enabled.
409      */
410     modifier canDestroy() {
411         require(destroyEnabled);
412         _;
413     }
414 
415     // =================================================================================================================
416     //                                      Members
417     // =================================================================================================================
418 
419     // We add this flag to avoid users and owner from destroy tokens during crowdsale,
420     // This flag is set to false by default and blocks destroy function,
421     // We enable destroy option on finalize, so destroy will be possible after the crowdsale.
422     bool public destroyEnabled = false;
423 
424     // =================================================================================================================
425     //                                      Public Functions
426     // =================================================================================================================
427 
428     function setDestroyEnabled(bool _enable) onlyOwner public {
429         destroyEnabled = _enable;
430     }
431 
432     // =================================================================================================================
433     //                                      Impl ISmartToken
434     // =================================================================================================================
435 
436     //@Override
437     function disableTransfers(bool _disable) onlyOwner public {
438         transfersEnabled = !_disable;
439     }
440 
441     //@Override
442     function issue(address _to, uint256 _amount) onlyOwner public {
443         require(super.mint(_to, _amount));
444         Issuance(_amount);
445     }
446 
447     //@Override
448     function destroy(address _from, uint256 _amount) canDestroy public {
449 
450         require(msg.sender == _from || msg.sender == owner); // validate input
451 
452         balances[_from] = balances[_from].sub(_amount);
453         totalSupply = totalSupply.sub(_amount);
454 
455         Destruction(_amount);
456         Transfer(_from, 0x0, _amount);
457     }
458 
459     // =================================================================================================================
460     //                                      Impl LimitedTransferToken
461     // =================================================================================================================
462 
463 
464     // Enable/Disable token transfer
465     // Tokens will be locked in their wallets until the end of the Crowdsale.
466     // @holder - token`s owner
467     // @time - not used (framework unneeded functionality)
468     //
469     // @Override
470     function transferableTokens(address holder, uint64 time) public constant returns (uint256) {
471         require(transfersEnabled);
472         return super.transferableTokens(holder, time);
473     }
474 }
475 
476 
477 
478 
479 /**
480   A Token which is 'Bancor' compatible and can mint new tokens and pause token-transfer functionality
481 */
482 contract SirinSmartToken is LimitedTransferBancorSmartToken {
483 
484     // =================================================================================================================
485     //                                         Members
486     // =================================================================================================================
487 
488     string public name = "INVEST";
489 
490     string public symbol = "INVEST";
491 
492     uint8 public decimals = 18;
493 
494     // =================================================================================================================
495     //                                         Constructor
496     // =================================================================================================================
497 
498     function SirinSmartToken() public {
499         //Apart of 'Bancor' computability - triggered when a smart token is deployed
500         NewSmartToken(address(this));
501     }
502 }