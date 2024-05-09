1 pragma solidity 0.4.24;
2 
3 // File: contracts/ERC677Receiver.sol
4 
5 contract ERC677Receiver {
6   function onTokenTransfer(address _from, uint _value, bytes _data) external returns(bool);
7 }
8 
9 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
10 
11 /**
12  * @title ERC20Basic
13  * @dev Simpler version of ERC20 interface
14  * @dev see https://github.com/ethereum/EIPs/issues/179
15  */
16 contract ERC20Basic {
17   function totalSupply() public view returns (uint256);
18   function balanceOf(address who) public view returns (uint256);
19   function transfer(address to, uint256 value) public returns (bool);
20   event Transfer(address indexed from, address indexed to, uint256 value);
21 }
22 
23 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
24 
25 /**
26  * @title ERC20 interface
27  * @dev see https://github.com/ethereum/EIPs/issues/20
28  */
29 contract ERC20 is ERC20Basic {
30   function allowance(address owner, address spender)
31     public view returns (uint256);
32 
33   function transferFrom(address from, address to, uint256 value)
34     public returns (bool);
35 
36   function approve(address spender, uint256 value) public returns (bool);
37   event Approval(
38     address indexed owner,
39     address indexed spender,
40     uint256 value
41   );
42 }
43 
44 // File: contracts/ERC677.sol
45 
46 contract ERC677 is ERC20 {
47     event Transfer(address indexed from, address indexed to, uint value, bytes data);
48 
49     function transferAndCall(address, uint, bytes) external returns (bool);
50 
51 }
52 
53 // File: contracts/IBurnableMintableERC677Token.sol
54 
55 contract IBurnableMintableERC677Token is ERC677 {
56     function mint(address, uint256) public returns (bool);
57     function burn(uint256 _value) public;
58     function claimTokens(address _token, address _to) public;
59 }
60 
61 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
62 
63 /**
64  * @title SafeMath
65  * @dev Math operations with safety checks that throw on error
66  */
67 library SafeMath {
68 
69   /**
70   * @dev Multiplies two numbers, throws on overflow.
71   */
72   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
73     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
74     // benefit is lost if 'b' is also tested.
75     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
76     if (a == 0) {
77       return 0;
78     }
79 
80     c = a * b;
81     assert(c / a == b);
82     return c;
83   }
84 
85   /**
86   * @dev Integer division of two numbers, truncating the quotient.
87   */
88   function div(uint256 a, uint256 b) internal pure returns (uint256) {
89     // assert(b > 0); // Solidity automatically throws when dividing by 0
90     // uint256 c = a / b;
91     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
92     return a / b;
93   }
94 
95   /**
96   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
97   */
98   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
99     assert(b <= a);
100     return a - b;
101   }
102 
103   /**
104   * @dev Adds two numbers, throws on overflow.
105   */
106   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
107     c = a + b;
108     assert(c >= a);
109     return c;
110   }
111 }
112 
113 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
114 
115 /**
116  * @title Basic token
117  * @dev Basic version of StandardToken, with no allowances.
118  */
119 contract BasicToken is ERC20Basic {
120   using SafeMath for uint256;
121 
122   mapping(address => uint256) balances;
123 
124   uint256 totalSupply_;
125 
126   /**
127   * @dev total number of tokens in existence
128   */
129   function totalSupply() public view returns (uint256) {
130     return totalSupply_;
131   }
132 
133   /**
134   * @dev transfer token for a specified address
135   * @param _to The address to transfer to.
136   * @param _value The amount to be transferred.
137   */
138   function transfer(address _to, uint256 _value) public returns (bool) {
139     require(_to != address(0));
140     require(_value <= balances[msg.sender]);
141 
142     balances[msg.sender] = balances[msg.sender].sub(_value);
143     balances[_to] = balances[_to].add(_value);
144     emit Transfer(msg.sender, _to, _value);
145     return true;
146   }
147 
148   /**
149   * @dev Gets the balance of the specified address.
150   * @param _owner The address to query the the balance of.
151   * @return An uint256 representing the amount owned by the passed address.
152   */
153   function balanceOf(address _owner) public view returns (uint256) {
154     return balances[_owner];
155   }
156 
157 }
158 
159 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
160 
161 /**
162  * @title Burnable Token
163  * @dev Token that can be irreversibly burned (destroyed).
164  */
165 contract BurnableToken is BasicToken {
166 
167   event Burn(address indexed burner, uint256 value);
168 
169   /**
170    * @dev Burns a specific amount of tokens.
171    * @param _value The amount of token to be burned.
172    */
173   function burn(uint256 _value) public {
174     _burn(msg.sender, _value);
175   }
176 
177   function _burn(address _who, uint256 _value) internal {
178     require(_value <= balances[_who]);
179     // no need to require value <= totalSupply, since that would imply the
180     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
181 
182     balances[_who] = balances[_who].sub(_value);
183     totalSupply_ = totalSupply_.sub(_value);
184     emit Burn(_who, _value);
185     emit Transfer(_who, address(0), _value);
186   }
187 }
188 
189 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
190 
191 /**
192  * @title DetailedERC20 token
193  * @dev The decimals are only for visualization purposes.
194  * All the operations are done using the smallest and indivisible token unit,
195  * just as on Ethereum all the operations are done in wei.
196  */
197 contract DetailedERC20 is ERC20 {
198   string public name;
199   string public symbol;
200   uint8 public decimals;
201 
202   constructor(string _name, string _symbol, uint8 _decimals) public {
203     name = _name;
204     symbol = _symbol;
205     decimals = _decimals;
206   }
207 }
208 
209 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
210 
211 /**
212  * @title Ownable
213  * @dev The Ownable contract has an owner address, and provides basic authorization control
214  * functions, this simplifies the implementation of "user permissions".
215  */
216 contract Ownable {
217   address public owner;
218 
219 
220   event OwnershipRenounced(address indexed previousOwner);
221   event OwnershipTransferred(
222     address indexed previousOwner,
223     address indexed newOwner
224   );
225 
226 
227   /**
228    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
229    * account.
230    */
231   constructor() public {
232     owner = msg.sender;
233   }
234 
235   /**
236    * @dev Throws if called by any account other than the owner.
237    */
238   modifier onlyOwner() {
239     require(msg.sender == owner);
240     _;
241   }
242 
243   /**
244    * @dev Allows the current owner to relinquish control of the contract.
245    */
246   function renounceOwnership() public onlyOwner {
247     emit OwnershipRenounced(owner);
248     owner = address(0);
249   }
250 
251   /**
252    * @dev Allows the current owner to transfer control of the contract to a newOwner.
253    * @param _newOwner The address to transfer ownership to.
254    */
255   function transferOwnership(address _newOwner) public onlyOwner {
256     _transferOwnership(_newOwner);
257   }
258 
259   /**
260    * @dev Transfers control of the contract to a newOwner.
261    * @param _newOwner The address to transfer ownership to.
262    */
263   function _transferOwnership(address _newOwner) internal {
264     require(_newOwner != address(0));
265     emit OwnershipTransferred(owner, _newOwner);
266     owner = _newOwner;
267   }
268 }
269 
270 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
271 
272 /**
273  * @title Standard ERC20 token
274  *
275  * @dev Implementation of the basic standard token.
276  * @dev https://github.com/ethereum/EIPs/issues/20
277  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
278  */
279 contract StandardToken is ERC20, BasicToken {
280 
281   mapping (address => mapping (address => uint256)) internal allowed;
282 
283 
284   /**
285    * @dev Transfer tokens from one address to another
286    * @param _from address The address which you want to send tokens from
287    * @param _to address The address which you want to transfer to
288    * @param _value uint256 the amount of tokens to be transferred
289    */
290   function transferFrom(
291     address _from,
292     address _to,
293     uint256 _value
294   )
295     public
296     returns (bool)
297   {
298     require(_to != address(0));
299     require(_value <= balances[_from]);
300     require(_value <= allowed[_from][msg.sender]);
301 
302     balances[_from] = balances[_from].sub(_value);
303     balances[_to] = balances[_to].add(_value);
304     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
305     emit Transfer(_from, _to, _value);
306     return true;
307   }
308 
309   /**
310    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
311    *
312    * Beware that changing an allowance with this method brings the risk that someone may use both the old
313    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
314    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
315    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
316    * @param _spender The address which will spend the funds.
317    * @param _value The amount of tokens to be spent.
318    */
319   function approve(address _spender, uint256 _value) public returns (bool) {
320     allowed[msg.sender][_spender] = _value;
321     emit Approval(msg.sender, _spender, _value);
322     return true;
323   }
324 
325   /**
326    * @dev Function to check the amount of tokens that an owner allowed to a spender.
327    * @param _owner address The address which owns the funds.
328    * @param _spender address The address which will spend the funds.
329    * @return A uint256 specifying the amount of tokens still available for the spender.
330    */
331   function allowance(
332     address _owner,
333     address _spender
334    )
335     public
336     view
337     returns (uint256)
338   {
339     return allowed[_owner][_spender];
340   }
341 
342   /**
343    * @dev Increase the amount of tokens that an owner allowed to a spender.
344    *
345    * approve should be called when allowed[_spender] == 0. To increment
346    * allowed value is better to use this function to avoid 2 calls (and wait until
347    * the first transaction is mined)
348    * From MonolithDAO Token.sol
349    * @param _spender The address which will spend the funds.
350    * @param _addedValue The amount of tokens to increase the allowance by.
351    */
352   function increaseApproval(
353     address _spender,
354     uint _addedValue
355   )
356     public
357     returns (bool)
358   {
359     allowed[msg.sender][_spender] = (
360       allowed[msg.sender][_spender].add(_addedValue));
361     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
362     return true;
363   }
364 
365   /**
366    * @dev Decrease the amount of tokens that an owner allowed to a spender.
367    *
368    * approve should be called when allowed[_spender] == 0. To decrement
369    * allowed value is better to use this function to avoid 2 calls (and wait until
370    * the first transaction is mined)
371    * From MonolithDAO Token.sol
372    * @param _spender The address which will spend the funds.
373    * @param _subtractedValue The amount of tokens to decrease the allowance by.
374    */
375   function decreaseApproval(
376     address _spender,
377     uint _subtractedValue
378   )
379     public
380     returns (bool)
381   {
382     uint oldValue = allowed[msg.sender][_spender];
383     if (_subtractedValue > oldValue) {
384       allowed[msg.sender][_spender] = 0;
385     } else {
386       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
387     }
388     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
389     return true;
390   }
391 
392 }
393 
394 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
395 
396 /**
397  * @title Mintable token
398  * @dev Simple ERC20 Token example, with mintable token creation
399  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
400  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
401  */
402 contract MintableToken is StandardToken, Ownable {
403   event Mint(address indexed to, uint256 amount);
404   event MintFinished();
405 
406   bool public mintingFinished = false;
407 
408 
409   modifier canMint() {
410     require(!mintingFinished);
411     _;
412   }
413 
414   modifier hasMintPermission() {
415     require(msg.sender == owner);
416     _;
417   }
418 
419   /**
420    * @dev Function to mint tokens
421    * @param _to The address that will receive the minted tokens.
422    * @param _amount The amount of tokens to mint.
423    * @return A boolean that indicates if the operation was successful.
424    */
425   function mint(
426     address _to,
427     uint256 _amount
428   )
429     hasMintPermission
430     canMint
431     public
432     returns (bool)
433   {
434     totalSupply_ = totalSupply_.add(_amount);
435     balances[_to] = balances[_to].add(_amount);
436     emit Mint(_to, _amount);
437     emit Transfer(address(0), _to, _amount);
438     return true;
439   }
440 
441   /**
442    * @dev Function to stop minting new tokens.
443    * @return True if the operation was successful.
444    */
445   function finishMinting() onlyOwner canMint public returns (bool) {
446     mintingFinished = true;
447     emit MintFinished();
448     return true;
449   }
450 }
451 
452 // File: contracts/ERC677BridgeToken.sol
453 
454 contract ERC677BridgeToken is
455     IBurnableMintableERC677Token,
456     DetailedERC20,
457     BurnableToken,
458     MintableToken {
459 
460     address public bridgeContract;
461 
462     event ContractFallbackCallFailed(address from, address to, uint value);
463 
464     constructor(
465         string _name,
466         string _symbol,
467         uint8 _decimals)
468     public DetailedERC20(_name, _symbol, _decimals) {}
469 
470     function setBridgeContract(address _bridgeContract) onlyOwner public {
471         require(_bridgeContract != address(0) && isContract(_bridgeContract));
472         bridgeContract = _bridgeContract;
473     }
474 
475     modifier validRecipient(address _recipient) {
476         require(_recipient != address(0) && _recipient != address(this));
477         _;
478     }
479 
480     function transferAndCall(address _to, uint _value, bytes _data)
481         external validRecipient(_to) returns (bool)
482     {
483         require(superTransfer(_to, _value));
484         emit Transfer(msg.sender, _to, _value, _data);
485 
486         if (isContract(_to)) {
487             require(contractFallback(_to, _value, _data));
488         }
489         return true;
490     }
491 
492     function getTokenInterfacesVersion() public pure returns(uint64 major, uint64 minor, uint64 patch) {
493         return (2, 0, 0);
494     }
495 
496     function superTransfer(address _to, uint256 _value) internal returns(bool)
497     {
498         return super.transfer(_to, _value);
499     }
500 
501     function transfer(address _to, uint256 _value) public returns (bool)
502     {
503         require(superTransfer(_to, _value));
504         if (isContract(_to) && !contractFallback(_to, _value, new bytes(0))) {
505             if (_to == bridgeContract) {
506                 revert();
507             } else {
508                 emit ContractFallbackCallFailed(msg.sender, _to, _value);
509             }
510         }
511         return true;
512     }
513 
514     function contractFallback(address _to, uint _value, bytes _data)
515         private
516         returns(bool)
517     {
518         return _to.call(abi.encodeWithSignature("onTokenTransfer(address,uint256,bytes)",  msg.sender, _value, _data));
519     }
520 
521     function isContract(address _addr)
522         private
523         view
524         returns (bool)
525     {
526         uint length;
527         assembly { length := extcodesize(_addr) }
528         return length > 0;
529     }
530 
531     function finishMinting() public returns (bool) {
532         revert();
533     }
534 
535     function renounceOwnership() public onlyOwner {
536         revert();
537     }
538 
539     function claimTokens(address _token, address _to) public onlyOwner {
540         require(_to != address(0));
541         if (_token == address(0)) {
542             _to.transfer(address(this).balance);
543             return;
544         }
545 
546         DetailedERC20 token = DetailedERC20(_token);
547         uint256 balance = token.balanceOf(address(this));
548         require(token.transfer(_to, balance));
549     }
550 
551 
552 }