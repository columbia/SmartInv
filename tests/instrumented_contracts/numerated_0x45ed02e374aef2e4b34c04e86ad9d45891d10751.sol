1 pragma solidity ^0.4.18;
2 
3 /**
4  * Digital Fantasy Sports is a digital sports platform that brings this concept of playing fantasy sports 
5  * while using cryptocurrencies to extraordinary fantasy players. It has created an ER20 token called 
6  * DFS that provides a simple secure interface between the players and the league action that they 
7  * love featuring multiple gaming sport platforms that use DFS as in-game currency.
8  *
9  * Website: https://www.digitalfantasysports.com/
10  * Twitter: https://twitter.com/dfstoken
11  * Reddit: https://www.reddit.com/r/dfstoken 
12  * Discord: https://discordapp.com/channels/397817936884269057/397817937731387403
13  * Bitcoin Talk: https://bitcointalk.org/index.php?topic=2223626.0
14  */
15 
16 // ==== Open Zeppelin library ===
17 
18 /**
19  * @title ERC20Basic
20  * @dev Simpler version of ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/179
22  */
23 contract ERC20Basic {
24   function totalSupply() public view returns (uint256);
25   function balanceOf(address who) public view returns (uint256);
26   function transfer(address to, uint256 value) public returns (bool);
27   event Transfer(address indexed from, address indexed to, uint256 value);
28 }
29 
30 /**
31  * @title ERC20 interface
32  * @dev see https://github.com/ethereum/EIPs/issues/20
33  */
34 contract ERC20 is ERC20Basic {
35   function allowance(address owner, address spender) public view returns (uint256);
36   function transferFrom(address from, address to, uint256 value) public returns (bool);
37   function approve(address spender, uint256 value) public returns (bool);
38   event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 /**
42    @title ERC827 interface, an extension of ERC20 token standard
43 
44    Interface of a ERC827 token, following the ERC20 standard with extra
45    methods to transfer value and data and execute calls in transfers and
46    approvals.
47  */
48 contract ERC827 is ERC20 {
49 
50   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
51   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
52   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
53 
54 }
55 
56 /**
57  * @title SafeERC20
58  * @dev Wrappers around ERC20 operations that throw on failure.
59  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
60  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
61  */
62 library SafeERC20 {
63   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
64     assert(token.transfer(to, value));
65   }
66 
67   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
68     assert(token.transferFrom(from, to, value));
69   }
70 
71   function safeApprove(ERC20 token, address spender, uint256 value) internal {
72     assert(token.approve(spender, value));
73   }
74 }
75 
76 /**
77  * @title SafeMath
78  * @dev Math operations with safety checks that throw on error
79  */
80 library SafeMath {
81   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82     if (a == 0) {
83       return 0;
84     }
85     uint256 c = a * b;
86     assert(c / a == b);
87     return c;
88   }
89 
90   function div(uint256 a, uint256 b) internal pure returns (uint256) {
91     // assert(b > 0); // Solidity automatically throws when dividing by 0
92     uint256 c = a / b;
93     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
94     return c;
95   }
96 
97   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98     assert(b <= a);
99     return a - b;
100   }
101 
102   function add(uint256 a, uint256 b) internal pure returns (uint256) {
103     uint256 c = a + b;
104     assert(c >= a);
105     return c;
106   }
107 }
108 
109 
110 /**
111  * @title Ownable
112  * @dev The Ownable contract has an owner address, and provides basic authorization control
113  * functions, this simplifies the implementation of "user permissions".
114  */
115 contract Ownable {
116   address public owner;
117 
118 
119   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
120 
121 
122   /**
123    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
124    * account.
125    */
126   function Ownable() public {
127     owner = msg.sender;
128   }
129 
130   /**
131    * @dev Throws if called by any account other than the owner.
132    */
133   modifier onlyOwner() {
134     require(msg.sender == owner);
135     _;
136   }
137 
138   /**
139    * @dev Allows the current owner to transfer control of the contract to a newOwner.
140    * @param newOwner The address to transfer ownership to.
141    */
142   function transferOwnership(address newOwner) public onlyOwner {
143     require(newOwner != address(0));
144     OwnershipTransferred(owner, newOwner);
145     owner = newOwner;
146   }
147 
148 }
149 
150 /**
151  * @title Contracts that should not own Ether
152  * @author Remco Bloemen <remco@2π.com>
153  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
154  * in the contract, it will allow the owner to reclaim this ether.
155  * @notice Ether can still be send to this contract by:
156  * calling functions labeled `payable`
157  * `selfdestruct(contract_address)`
158  * mining directly to the contract address
159 */
160 contract HasNoEther is Ownable {
161 
162   /**
163   * @dev Constructor that rejects incoming Ether
164   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
165   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
166   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
167   * we could use assembly to access msg.value.
168   */
169   function HasNoEther() public payable {
170     require(msg.value == 0);
171   }
172 
173   /**
174    * @dev Disallows direct send by settings a default function without the `payable` flag.
175    */
176   function() external {
177   }
178 
179   /**
180    * @dev Transfer all Ether held by the contract to the owner.
181    */
182   function reclaimEther() external onlyOwner {
183     assert(owner.send(this.balance));
184   }
185 }
186 
187 /**
188  * @title Contracts that should not own Contracts
189  * @author Remco Bloemen <remco@2π.com>
190  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
191  * of this contract to reclaim ownership of the contracts.
192  */
193 contract HasNoContracts is Ownable {
194 
195   /**
196    * @dev Reclaim ownership of Ownable contracts
197    * @param contractAddr The address of the Ownable to be reclaimed.
198    */
199   function reclaimContract(address contractAddr) external onlyOwner {
200     Ownable contractInst = Ownable(contractAddr);
201     contractInst.transferOwnership(owner);
202   }
203 }
204 
205 /**
206  * @title Contracts that should be able to recover tokens
207  * @author SylTi
208  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
209  * This will prevent any accidental loss of tokens.
210  */
211 contract CanReclaimToken is Ownable {
212   using SafeERC20 for ERC20Basic;
213 
214   /**
215    * @dev Reclaim all ERC20Basic compatible tokens
216    * @param token ERC20Basic The address of the token contract
217    */
218   function reclaimToken(ERC20Basic token) external onlyOwner {
219     uint256 balance = token.balanceOf(this);
220     token.safeTransfer(owner, balance);
221   }
222 
223 }
224 
225 /**
226  * @title Contracts that should not own Tokens
227  * @author Remco Bloemen <remco@2π.com>
228  * @dev This blocks incoming ERC23 tokens to prevent accidental loss of tokens.
229  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
230  * owner to reclaim the tokens.
231  */
232 contract HasNoTokens is CanReclaimToken {
233 
234  /**
235   * @dev Reject all ERC23 compatible tokens
236   * @param from_ address The address that is transferring the tokens
237   * @param value_ uint256 the amount of the specified token
238   * @param data_ Bytes The data passed from the caller.
239   */
240   function tokenFallback(address from_, uint256 value_, bytes data_) pure external {
241     from_;
242     value_;
243     data_;
244     revert();
245   }
246 
247 }
248 
249 /**
250  * @title Base contract for contracts that should not own things.
251  * @author Remco Bloemen <remco@2π.com>
252  * @dev Solves a class of errors where a contract accidentally becomes owner of Ether, Tokens or
253  * Owned contracts. See respective base contracts for details.
254  */
255 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
256 }
257 
258 /**
259  * @title Basic token
260  * @dev Basic version of StandardToken, with no allowances.
261  */
262 contract BasicToken is ERC20Basic {
263   using SafeMath for uint256;
264 
265   mapping(address => uint256) balances;
266 
267   uint256 totalSupply_;
268 
269   /**
270   * @dev total number of tokens in existence
271   */
272   function totalSupply() public view returns (uint256) {
273     return totalSupply_;
274   }
275 
276   /**
277   * @dev transfer token for a specified address
278   * @param _to The address to transfer to.
279   * @param _value The amount to be transferred.
280   */
281   function transfer(address _to, uint256 _value) public returns (bool) {
282     require(_to != address(0));
283     require(_value <= balances[msg.sender]);
284 
285     // SafeMath.sub will throw if there is not enough balance.
286     balances[msg.sender] = balances[msg.sender].sub(_value);
287     balances[_to] = balances[_to].add(_value);
288     Transfer(msg.sender, _to, _value);
289     return true;
290   }
291 
292   /**
293   * @dev Gets the balance of the specified address.
294   * @param _owner The address to query the the balance of.
295   * @return An uint256 representing the amount owned by the passed address.
296   */
297   function balanceOf(address _owner) public view returns (uint256 balance) {
298     return balances[_owner];
299   }
300 
301 }
302 
303 /**
304  * @title Standard ERC20 token
305  *
306  * @dev Implementation of the basic standard token.
307  * @dev https://github.com/ethereum/EIPs/issues/20
308  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
309  */
310 contract StandardToken is ERC20, BasicToken {
311 
312   mapping (address => mapping (address => uint256)) internal allowed;
313 
314 
315   /**
316    * @dev Transfer tokens from one address to another
317    * @param _from address The address which you want to send tokens from
318    * @param _to address The address which you want to transfer to
319    * @param _value uint256 the amount of tokens to be transferred
320    */
321   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
322     require(_to != address(0));
323     require(_value <= balances[_from]);
324     require(_value <= allowed[_from][msg.sender]);
325 
326     balances[_from] = balances[_from].sub(_value);
327     balances[_to] = balances[_to].add(_value);
328     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
329     Transfer(_from, _to, _value);
330     return true;
331   }
332 
333   /**
334    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
335    *
336    * Beware that changing an allowance with this method brings the risk that someone may use both the old
337    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
338    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
339    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
340    * @param _spender The address which will spend the funds.
341    * @param _value The amount of tokens to be spent.
342    */
343   function approve(address _spender, uint256 _value) public returns (bool) {
344     allowed[msg.sender][_spender] = _value;
345     Approval(msg.sender, _spender, _value);
346     return true;
347   }
348 
349   /**
350    * @dev Function to check the amount of tokens that an owner allowed to a spender.
351    * @param _owner address The address which owns the funds.
352    * @param _spender address The address which will spend the funds.
353    * @return A uint256 specifying the amount of tokens still available for the spender.
354    */
355   function allowance(address _owner, address _spender) public view returns (uint256) {
356     return allowed[_owner][_spender];
357   }
358 
359   /**
360    * @dev Increase the amount of tokens that an owner allowed to a spender.
361    *
362    * approve should be called when allowed[_spender] == 0. To increment
363    * allowed value is better to use this function to avoid 2 calls (and wait until
364    * the first transaction is mined)
365    * From MonolithDAO Token.sol
366    * @param _spender The address which will spend the funds.
367    * @param _addedValue The amount of tokens to increase the allowance by.
368    */
369   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
370     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
371     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
372     return true;
373   }
374 
375   /**
376    * @dev Decrease the amount of tokens that an owner allowed to a spender.
377    *
378    * approve should be called when allowed[_spender] == 0. To decrement
379    * allowed value is better to use this function to avoid 2 calls (and wait until
380    * the first transaction is mined)
381    * From MonolithDAO Token.sol
382    * @param _spender The address which will spend the funds.
383    * @param _subtractedValue The amount of tokens to decrease the allowance by.
384    */
385   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
386     uint oldValue = allowed[msg.sender][_spender];
387     if (_subtractedValue > oldValue) {
388       allowed[msg.sender][_spender] = 0;
389     } else {
390       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
391     }
392     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
393     return true;
394   }
395 
396 }
397 
398 /**
399  * @title Mintable token
400  * @dev Simple ERC20 Token example, with mintable token creation
401  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
402  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
403  */
404 contract MintableToken is StandardToken, Ownable {
405   event Mint(address indexed to, uint256 amount);
406   event MintFinished();
407 
408   bool public mintingFinished = false;
409 
410 
411   modifier canMint() {
412     require(!mintingFinished);
413     _;
414   }
415 
416   /**
417    * @dev Function to mint tokens
418    * @param _to The address that will receive the minted tokens.
419    * @param _amount The amount of tokens to mint.
420    * @return A boolean that indicates if the operation was successful.
421    */
422   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
423     totalSupply_ = totalSupply_.add(_amount);
424     balances[_to] = balances[_to].add(_amount);
425     Mint(_to, _amount);
426     Transfer(address(0), _to, _amount);
427     return true;
428   }
429 
430   /**
431    * @dev Function to stop minting new tokens.
432    * @return True if the operation was successful.
433    */
434   function finishMinting() onlyOwner canMint public returns (bool) {
435     mintingFinished = true;
436     MintFinished();
437     return true;
438   }
439 }
440 
441 /**
442    @title ERC827, an extension of ERC20 token standard
443 
444    Implementation the ERC827, following the ERC20 standard with extra
445    methods to transfer value and data and execute calls in transfers and
446    approvals.
447    Uses OpenZeppelin StandardToken.
448  */
449 contract ERC827Token is ERC827, StandardToken {
450 
451   /**
452      @dev Addition to ERC20 token methods. It allows to
453      approve the transfer of value and execute a call with the sent data.
454 
455      Beware that changing an allowance with this method brings the risk that
456      someone may use both the old and the new allowance by unfortunate
457      transaction ordering. One possible solution to mitigate this race condition
458      is to first reduce the spender's allowance to 0 and set the desired value
459      afterwards:
460      https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
461 
462      @param _spender The address that will spend the funds.
463      @param _value The amount of tokens to be spent.
464      @param _data ABI-encoded contract call to call `_to` address.
465 
466      @return true if the call function was executed successfully
467    */
468   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
469     require(_spender != address(this));
470 
471     super.approve(_spender, _value);
472 
473     require(_spender.call(_data));
474 
475     return true;
476   }
477 
478   /**
479      @dev Addition to ERC20 token methods. Transfer tokens to a specified
480      address and execute a call with the sent data on the same transaction
481 
482      @param _to address The address which you want to transfer to
483      @param _value uint256 the amout of tokens to be transfered
484      @param _data ABI-encoded contract call to call `_to` address.
485 
486      @return true if the call function was executed successfully
487    */
488   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
489     require(_to != address(this));
490 
491     super.transfer(_to, _value);
492 
493     require(_to.call(_data));
494     return true;
495   }
496 
497   /**
498      @dev Addition to ERC20 token methods. Transfer tokens from one address to
499      another and make a contract call on the same transaction
500 
501      @param _from The address which you want to send tokens from
502      @param _to The address which you want to transfer to
503      @param _value The amout of tokens to be transferred
504      @param _data ABI-encoded contract call to call `_to` address.
505 
506      @return true if the call function was executed successfully
507    */
508   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
509     require(_to != address(this));
510 
511     super.transferFrom(_from, _to, _value);
512 
513     require(_to.call(_data));
514     return true;
515   }
516 
517   /**
518    * @dev Addition to StandardToken methods. Increase the amount of tokens that
519    * an owner allowed to a spender and execute a call with the sent data.
520    *
521    * approve should be called when allowed[_spender] == 0. To increment
522    * allowed value is better to use this function to avoid 2 calls (and wait until
523    * the first transaction is mined)
524    * From MonolithDAO Token.sol
525    * @param _spender The address which will spend the funds.
526    * @param _addedValue The amount of tokens to increase the allowance by.
527    * @param _data ABI-encoded contract call to call `_spender` address.
528    */
529   function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
530     require(_spender != address(this));
531 
532     super.increaseApproval(_spender, _addedValue);
533 
534     require(_spender.call(_data));
535 
536     return true;
537   }
538 
539   /**
540    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
541    * an owner allowed to a spender and execute a call with the sent data.
542    *
543    * approve should be called when allowed[_spender] == 0. To decrement
544    * allowed value is better to use this function to avoid 2 calls (and wait until
545    * the first transaction is mined)
546    * From MonolithDAO Token.sol
547    * @param _spender The address which will spend the funds.
548    * @param _subtractedValue The amount of tokens to decrease the allowance by.
549    * @param _data ABI-encoded contract call to call `_spender` address.
550    */
551   function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
552     require(_spender != address(this));
553 
554     super.decreaseApproval(_spender, _subtractedValue);
555 
556     require(_spender.call(_data));
557 
558     return true;
559   }
560 
561 }
562 
563 // ==== DFS Contracts ===
564 
565 contract DFSToken is MintableToken, ERC827Token, NoOwner {
566     string public symbol = 'DFS';
567     string public name = 'Digital Fantasy Sports';
568     uint8 public constant decimals = 18;
569 
570     bool public transferEnabled;    //allows to dissable transfers while minting and in case of emergency
571 
572     function setTransferEnabled(bool enable) onlyOwner public {
573         transferEnabled = enable;
574     }
575     modifier canTransfer() {
576         require( transferEnabled || msg.sender == owner);
577         _;
578     }
579     
580     function transfer(address _to, uint256 _value) canTransfer public returns (bool) {
581         return super.transfer(_to, _value);
582     }
583     function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {
584         return super.transferFrom(_from, _to, _value);
585     }
586     function transfer(address _to, uint256 _value, bytes _data) canTransfer public returns (bool) {
587         return super.transfer(_to, _value, _data);
588     }
589     function transferFrom(address _from, address _to, uint256 _value, bytes _data) canTransfer public returns (bool) {
590         return super.transferFrom(_from, _to, _value, _data);
591     }
592 }