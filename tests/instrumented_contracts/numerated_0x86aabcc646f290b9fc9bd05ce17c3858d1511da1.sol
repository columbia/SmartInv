1 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
2 
3 pragma solidity ^0.4.18;
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address who) public view returns (uint256);
14   function transfer(address to, uint256 value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
19 
20 pragma solidity ^0.4.18;
21 
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 library SafeMath {
28 
29   /**
30   * @dev Multiplies two numbers, throws on overflow.
31   */
32   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33     if (a == 0) {
34       return 0;
35     }
36     uint256 c = a * b;
37     assert(c / a == b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return c;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55     assert(b <= a);
56     return a - b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 a, uint256 b) internal pure returns (uint256) {
63     uint256 c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
70 
71 pragma solidity ^0.4.18;
72 
73 
74 
75 
76 /**
77  * @title Basic token
78  * @dev Basic version of StandardToken, with no allowances.
79  */
80 contract BasicToken is ERC20Basic {
81   using SafeMath for uint256;
82 
83   mapping(address => uint256) balances;
84 
85   uint256 totalSupply_;
86 
87   /**
88   * @dev total number of tokens in existence
89   */
90   function totalSupply() public view returns (uint256) {
91     return totalSupply_;
92   }
93 
94   /**
95   * @dev transfer token for a specified address
96   * @param _to The address to transfer to.
97   * @param _value The amount to be transferred.
98   */
99   function transfer(address _to, uint256 _value) public returns (bool) {
100     require(_to != address(0));
101     require(_value <= balances[msg.sender]);
102 
103     // SafeMath.sub will throw if there is not enough balance.
104     balances[msg.sender] = balances[msg.sender].sub(_value);
105     balances[_to] = balances[_to].add(_value);
106     Transfer(msg.sender, _to, _value);
107     return true;
108   }
109 
110   /**
111   * @dev Gets the balance of the specified address.
112   * @param _owner The address to query the the balance of.
113   * @return An uint256 representing the amount owned by the passed address.
114   */
115   function balanceOf(address _owner) public view returns (uint256 balance) {
116     return balances[_owner];
117   }
118 
119 }
120 
121 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
122 
123 pragma solidity ^0.4.18;
124 
125 
126 
127 /**
128  * @title Burnable Token
129  * @dev Token that can be irreversibly burned (destroyed).
130  */
131 contract BurnableToken is BasicToken {
132 
133   event Burn(address indexed burner, uint256 value);
134 
135   /**
136    * @dev Burns a specific amount of tokens.
137    * @param _value The amount of token to be burned.
138    */
139   function burn(uint256 _value) public {
140     require(_value <= balances[msg.sender]);
141     // no need to require value <= totalSupply, since that would imply the
142     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
143 
144     address burner = msg.sender;
145     balances[burner] = balances[burner].sub(_value);
146     totalSupply_ = totalSupply_.sub(_value);
147     Burn(burner, _value);
148     Transfer(burner, address(0), _value);
149   }
150 }
151 
152 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
153 
154 pragma solidity ^0.4.18;
155 
156 
157 
158 /**
159  * @title ERC20 interface
160  * @dev see https://github.com/ethereum/EIPs/issues/20
161  */
162 contract ERC20 is ERC20Basic {
163   function allowance(address owner, address spender) public view returns (uint256);
164   function transferFrom(address from, address to, uint256 value) public returns (bool);
165   function approve(address spender, uint256 value) public returns (bool);
166   event Approval(address indexed owner, address indexed spender, uint256 value);
167 }
168 
169 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
170 
171 pragma solidity ^0.4.18;
172 
173 
174 
175 
176 /**
177  * @title Standard ERC20 token
178  *
179  * @dev Implementation of the basic standard token.
180  * @dev https://github.com/ethereum/EIPs/issues/20
181  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
182  */
183 contract StandardToken is ERC20, BasicToken {
184 
185   mapping (address => mapping (address => uint256)) internal allowed;
186 
187 
188   /**
189    * @dev Transfer tokens from one address to another
190    * @param _from address The address which you want to send tokens from
191    * @param _to address The address which you want to transfer to
192    * @param _value uint256 the amount of tokens to be transferred
193    */
194   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
195     require(_to != address(0));
196     require(_value <= balances[_from]);
197     require(_value <= allowed[_from][msg.sender]);
198 
199     balances[_from] = balances[_from].sub(_value);
200     balances[_to] = balances[_to].add(_value);
201     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
202     Transfer(_from, _to, _value);
203     return true;
204   }
205 
206   /**
207    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
208    *
209    * Beware that changing an allowance with this method brings the risk that someone may use both the old
210    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
211    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
212    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
213    * @param _spender The address which will spend the funds.
214    * @param _value The amount of tokens to be spent.
215    */
216   function approve(address _spender, uint256 _value) public returns (bool) {
217     allowed[msg.sender][_spender] = _value;
218     Approval(msg.sender, _spender, _value);
219     return true;
220   }
221 
222   /**
223    * @dev Function to check the amount of tokens that an owner allowed to a spender.
224    * @param _owner address The address which owns the funds.
225    * @param _spender address The address which will spend the funds.
226    * @return A uint256 specifying the amount of tokens still available for the spender.
227    */
228   function allowance(address _owner, address _spender) public view returns (uint256) {
229     return allowed[_owner][_spender];
230   }
231 
232   /**
233    * @dev Increase the amount of tokens that an owner allowed to a spender.
234    *
235    * approve should be called when allowed[_spender] == 0. To increment
236    * allowed value is better to use this function to avoid 2 calls (and wait until
237    * the first transaction is mined)
238    * From MonolithDAO Token.sol
239    * @param _spender The address which will spend the funds.
240    * @param _addedValue The amount of tokens to increase the allowance by.
241    */
242   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
243     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
244     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
245     return true;
246   }
247 
248   /**
249    * @dev Decrease the amount of tokens that an owner allowed to a spender.
250    *
251    * approve should be called when allowed[_spender] == 0. To decrement
252    * allowed value is better to use this function to avoid 2 calls (and wait until
253    * the first transaction is mined)
254    * From MonolithDAO Token.sol
255    * @param _spender The address which will spend the funds.
256    * @param _subtractedValue The amount of tokens to decrease the allowance by.
257    */
258   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
259     uint oldValue = allowed[msg.sender][_spender];
260     if (_subtractedValue > oldValue) {
261       allowed[msg.sender][_spender] = 0;
262     } else {
263       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
264     }
265     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
266     return true;
267   }
268 
269 }
270 
271 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
272 
273 pragma solidity ^0.4.18;
274 
275 
276 /**
277  * @title Ownable
278  * @dev The Ownable contract has an owner address, and provides basic authorization control
279  * functions, this simplifies the implementation of "user permissions".
280  */
281 contract Ownable {
282   address public owner;
283 
284 
285   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
286 
287 
288   /**
289    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
290    * account.
291    */
292   function Ownable() public {
293     owner = msg.sender;
294   }
295 
296   /**
297    * @dev Throws if called by any account other than the owner.
298    */
299   modifier onlyOwner() {
300     require(msg.sender == owner);
301     _;
302   }
303 
304   /**
305    * @dev Allows the current owner to transfer control of the contract to a newOwner.
306    * @param newOwner The address to transfer ownership to.
307    */
308   function transferOwnership(address newOwner) public onlyOwner {
309     require(newOwner != address(0));
310     OwnershipTransferred(owner, newOwner);
311     owner = newOwner;
312   }
313 
314 }
315 
316 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
317 
318 pragma solidity ^0.4.18;
319 
320 
321 
322 
323 /**
324  * @title Mintable token
325  * @dev Simple ERC20 Token example, with mintable token creation
326  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
327  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
328  */
329 contract MintableToken is StandardToken, Ownable {
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
348     totalSupply_ = totalSupply_.add(_amount);
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
359   function finishMinting() onlyOwner canMint public returns (bool) {
360     mintingFinished = true;
361     MintFinished();
362     return true;
363   }
364 }
365 
366 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
367 
368 pragma solidity ^0.4.18;
369 
370 
371 
372 contract DetailedERC20 is ERC20 {
373   string public name;
374   string public symbol;
375   uint8 public decimals;
376 
377   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
378     name = _name;
379     symbol = _symbol;
380     decimals = _decimals;
381   }
382 }
383 
384 // File: contracts/ERC677.sol
385 
386 pragma solidity 0.4.19;
387 
388 
389 
390 contract ERC677 is ERC20 {
391     event Transfer(address indexed from, address indexed to, uint value, bytes data);
392 
393     function transferAndCall(address, uint, bytes) external returns (bool);
394 
395 }
396 
397 // File: contracts/IBurnableMintableERC677Token.sol
398 
399 pragma solidity 0.4.19;
400 
401 
402 
403 contract IBurnableMintableERC677Token is ERC677 {
404     function mint(address, uint256) public returns (bool);
405     function burn(uint256 _value) public;
406     function claimTokens(address _token, address _to) public;
407 }
408 
409 // File: contracts/ERC677Receiver.sol
410 
411 pragma solidity 0.4.19;
412 
413 
414 contract ERC677Receiver {
415   function onTokenTransfer(address _from, uint _value, bytes _data) external returns(bool);
416 }
417 
418 // File: contracts/ERC677BridgeToken.sol
419 
420 pragma solidity 0.4.19;
421 
422 
423 
424 
425 
426 
427 
428 contract ERC677BridgeToken is
429     IBurnableMintableERC677Token,
430     DetailedERC20,
431     BurnableToken,
432     MintableToken {
433 
434     address public bridgeContract;
435 
436     event ContractFallbackCallFailed(address from, address to, uint value);
437 
438     function ERC677BridgeToken(
439         string _name,
440         string _symbol,
441         uint8 _decimals)
442     public DetailedERC20(_name, _symbol, _decimals) {}
443 
444     function setBridgeContract(address _bridgeContract) onlyOwner public {
445         require(_bridgeContract != address(0) && isContract(_bridgeContract));
446         bridgeContract = _bridgeContract;
447     }
448 
449     modifier validRecipient(address _recipient) {
450         require(_recipient != address(0) && _recipient != address(this));
451         _;
452     }
453 
454     function transferAndCall(address _to, uint _value, bytes _data)
455         external validRecipient(_to) returns (bool)
456     {
457         require(superTransfer(_to, _value));
458         Transfer(msg.sender, _to, _value, _data);
459 
460         if (isContract(_to)) {
461             require(contractFallback(_to, _value, _data));
462         }
463         return true;
464     }
465 
466     function getTokenInterfacesVersion() public pure returns(uint64 major, uint64 minor, uint64 patch) {
467         return (2, 0, 0);
468     }
469 
470     function superTransfer(address _to, uint256 _value) internal returns(bool)
471     {
472         return super.transfer(_to, _value);
473     }
474 
475     function transfer(address _to, uint256 _value) public returns (bool)
476     {
477         require(superTransfer(_to, _value));
478         if (isContract(_to) && !contractFallback(_to, _value, new bytes(0))) {
479             if (_to == bridgeContract) {
480                 revert();
481             } else {
482                 ContractFallbackCallFailed(msg.sender, _to, _value);
483             }
484         }
485         return true;
486     }
487 
488     function contractFallback(address _to, uint _value, bytes _data)
489         private
490         returns(bool)
491     {
492         return _to.call(bytes4(keccak256("onTokenTransfer(address,uint256,bytes)")),  msg.sender, _value, _data);
493     }
494 
495     function isContract(address _addr)
496         internal
497         view
498         returns (bool)
499     {
500         uint length;
501         assembly { length := extcodesize(_addr) }
502         return length > 0;
503     }
504 
505     function finishMinting() public returns (bool) {
506         revert();
507     }
508 
509     function renounceOwnership() public onlyOwner {
510         revert();
511     }
512 
513     function claimTokens(address _token, address _to) public onlyOwner {
514         require(_to != address(0));
515         if (_token == address(0)) {
516             _to.transfer(address(this).balance);
517             return;
518         }
519 
520         DetailedERC20 token = DetailedERC20(_token);
521         uint256 balance = token.balanceOf(address(this));
522         require(token.transfer(_to, balance));
523     }
524 
525 
526 }