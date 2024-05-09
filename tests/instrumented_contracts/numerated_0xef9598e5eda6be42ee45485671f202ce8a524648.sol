1 pragma solidity ^0.4.18;
2 
3 /**
4   * DocTailor: https://www.doctailor.com
5   */
6 
7 // ==== Open Zeppelin library ===
8 
9 /**
10  * @title ERC20Basic
11  * @dev Simpler version of ERC20 interface
12  * @dev see https://github.com/ethereum/EIPs/issues/179
13  */
14 contract ERC20Basic {
15   function totalSupply() public view returns (uint256);
16   function balanceOf(address who) public view returns (uint256);
17   function transfer(address to, uint256 value) public returns (bool);
18   event Transfer(address indexed from, address indexed to, uint256 value);
19 }
20 
21 /**
22  * @title ERC20 interface
23  * @dev see https://github.com/ethereum/EIPs/issues/20
24  */
25 contract ERC20 is ERC20Basic {
26   function allowance(address owner, address spender) public view returns (uint256);
27   function transferFrom(address from, address to, uint256 value) public returns (bool);
28   function approve(address spender, uint256 value) public returns (bool);
29   event Approval(address indexed owner, address indexed spender, uint256 value);
30 }
31 
32 /**
33    @title ERC827 interface, an extension of ERC20 token standard
34 
35    Interface of a ERC827 token, following the ERC20 standard with extra
36    methods to transfer value and data and execute calls in transfers and
37    approvals.
38  */
39 contract ERC827 is ERC20 {
40 
41   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
42   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
43   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
44 
45 }
46 
47 /**
48  * @title SafeERC20
49  * @dev Wrappers around ERC20 operations that throw on failure.
50  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
51  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
52  */
53 library SafeERC20 {
54   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
55     assert(token.transfer(to, value));
56   }
57 
58   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
59     assert(token.transferFrom(from, to, value));
60   }
61 
62   function safeApprove(ERC20 token, address spender, uint256 value) internal {
63     assert(token.approve(spender, value));
64   }
65 }
66 
67 /**
68  * @title SafeMath
69  * @dev Math operations with safety checks that throw on error
70  */
71 library SafeMath {
72   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
73     if (a == 0) {
74       return 0;
75     }
76     uint256 c = a * b;
77     assert(c / a == b);
78     return c;
79   }
80 
81   function div(uint256 a, uint256 b) internal pure returns (uint256) {
82     // assert(b > 0); // Solidity automatically throws when dividing by 0
83     uint256 c = a / b;
84     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
85     return c;
86   }
87 
88   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
89     assert(b <= a);
90     return a - b;
91   }
92 
93   function add(uint256 a, uint256 b) internal pure returns (uint256) {
94     uint256 c = a + b;
95     assert(c >= a);
96     return c;
97   }
98 }
99 
100 
101 /**
102  * @title Ownable
103  * @dev The Ownable contract has an owner address, and provides basic authorization control
104  * functions, this simplifies the implementation of "user permissions".
105  */
106 contract Ownable {
107   address public owner;
108 
109 
110   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
111 
112 
113   /**
114    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
115    * account.
116    */
117   function Ownable() public {
118     owner = msg.sender;
119   }
120 
121   /**
122    * @dev Throws if called by any account other than the owner.
123    */
124   modifier onlyOwner() {
125     require(msg.sender == owner);
126     _;
127   }
128 
129   /**
130    * @dev Allows the current owner to transfer control of the contract to a newOwner.
131    * @param newOwner The address to transfer ownership to.
132    */
133   function transferOwnership(address newOwner) public onlyOwner {
134     require(newOwner != address(0));
135     OwnershipTransferred(owner, newOwner);
136     owner = newOwner;
137   }
138 
139 }
140 
141 /**
142  * @title Contracts that should not own Ether
143  * @author Remco Bloemen <remco@2π.com>
144  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
145  * in the contract, it will allow the owner to reclaim this ether.
146  * @notice Ether can still be send to this contract by:
147  * calling functions labeled `payable`
148  * `selfdestruct(contract_address)`
149  * mining directly to the contract address
150 */
151 contract HasNoEther is Ownable {
152 
153   /**
154   * @dev Constructor that rejects incoming Ether
155   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
156   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
157   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
158   * we could use assembly to access msg.value.
159   */
160   function HasNoEther() public payable {
161     require(msg.value == 0);
162   }
163 
164   /**
165    * @dev Disallows direct send by settings a default function without the `payable` flag.
166    */
167   function() external {
168   }
169 
170   /**
171    * @dev Transfer all Ether held by the contract to the owner.
172    */
173   function reclaimEther() external onlyOwner {
174     assert(owner.send(this.balance));
175   }
176 }
177 
178 /**
179  * @title Contracts that should not own Contracts
180  * @author Remco Bloemen <remco@2π.com>
181  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
182  * of this contract to reclaim ownership of the contracts.
183  */
184 contract HasNoContracts is Ownable {
185 
186   /**
187    * @dev Reclaim ownership of Ownable contracts
188    * @param contractAddr The address of the Ownable to be reclaimed.
189    */
190   function reclaimContract(address contractAddr) external onlyOwner {
191     Ownable contractInst = Ownable(contractAddr);
192     contractInst.transferOwnership(owner);
193   }
194 }
195 
196 /**
197  * @title Contracts that should be able to recover tokens
198  * @author SylTi
199  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
200  * This will prevent any accidental loss of tokens.
201  */
202 contract CanReclaimToken is Ownable {
203   using SafeERC20 for ERC20Basic;
204 
205   /**
206    * @dev Reclaim all ERC20Basic compatible tokens
207    * @param token ERC20Basic The address of the token contract
208    */
209   function reclaimToken(ERC20Basic token) external onlyOwner {
210     uint256 balance = token.balanceOf(this);
211     token.safeTransfer(owner, balance);
212   }
213 
214 }
215 
216 /**
217  * @title Contracts that should not own Tokens
218  * @author Remco Bloemen <remco@2π.com>
219  * @dev This blocks incoming ERC23 tokens to prevent accidental loss of tokens.
220  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
221  * owner to reclaim the tokens.
222  */
223 contract HasNoTokens is CanReclaimToken {
224 
225  /**
226   * @dev Reject all ERC23 compatible tokens
227   * @param from_ address The address that is transferring the tokens
228   * @param value_ uint256 the amount of the specified token
229   * @param data_ Bytes The data passed from the caller.
230   */
231   function tokenFallback(address from_, uint256 value_, bytes data_) pure external {
232     from_;
233     value_;
234     data_;
235     revert();
236   }
237 
238 }
239 
240 /**
241  * @title Base contract for contracts that should not own things.
242  * @author Remco Bloemen <remco@2π.com>
243  * @dev Solves a class of errors where a contract accidentally becomes owner of Ether, Tokens or
244  * Owned contracts. See respective base contracts for details.
245  */
246 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
247 }
248 
249 /**
250  * @title Basic token
251  * @dev Basic version of StandardToken, with no allowances.
252  */
253 contract BasicToken is ERC20Basic {
254   using SafeMath for uint256;
255 
256   mapping(address => uint256) balances;
257 
258   uint256 totalSupply_;
259 
260   /**
261   * @dev total number of tokens in existence
262   */
263   function totalSupply() public view returns (uint256) {
264     return totalSupply_;
265   }
266 
267   /**
268   * @dev transfer token for a specified address
269   * @param _to The address to transfer to.
270   * @param _value The amount to be transferred.
271   */
272   function transfer(address _to, uint256 _value) public returns (bool) {
273     require(_to != address(0));
274     require(_value <= balances[msg.sender]);
275 
276     // SafeMath.sub will throw if there is not enough balance.
277     balances[msg.sender] = balances[msg.sender].sub(_value);
278     balances[_to] = balances[_to].add(_value);
279     Transfer(msg.sender, _to, _value);
280     return true;
281   }
282 
283   /**
284   * @dev Gets the balance of the specified address.
285   * @param _owner The address to query the the balance of.
286   * @return An uint256 representing the amount owned by the passed address.
287   */
288   function balanceOf(address _owner) public view returns (uint256 balance) {
289     return balances[_owner];
290   }
291 
292 }
293 
294 /**
295  * @title Standard ERC20 token
296  *
297  * @dev Implementation of the basic standard token.
298  * @dev https://github.com/ethereum/EIPs/issues/20
299  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
300  */
301 contract StandardToken is ERC20, BasicToken {
302 
303   mapping (address => mapping (address => uint256)) internal allowed;
304 
305 
306   /**
307    * @dev Transfer tokens from one address to another
308    * @param _from address The address which you want to send tokens from
309    * @param _to address The address which you want to transfer to
310    * @param _value uint256 the amount of tokens to be transferred
311    */
312   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
313     require(_to != address(0));
314     require(_value <= balances[_from]);
315     require(_value <= allowed[_from][msg.sender]);
316 
317     balances[_from] = balances[_from].sub(_value);
318     balances[_to] = balances[_to].add(_value);
319     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
320     Transfer(_from, _to, _value);
321     return true;
322   }
323 
324   /**
325    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
326    *
327    * Beware that changing an allowance with this method brings the risk that someone may use both the old
328    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
329    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
330    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
331    * @param _spender The address which will spend the funds.
332    * @param _value The amount of tokens to be spent.
333    */
334   function approve(address _spender, uint256 _value) public returns (bool) {
335     allowed[msg.sender][_spender] = _value;
336     Approval(msg.sender, _spender, _value);
337     return true;
338   }
339 
340   /**
341    * @dev Function to check the amount of tokens that an owner allowed to a spender.
342    * @param _owner address The address which owns the funds.
343    * @param _spender address The address which will spend the funds.
344    * @return A uint256 specifying the amount of tokens still available for the spender.
345    */
346   function allowance(address _owner, address _spender) public view returns (uint256) {
347     return allowed[_owner][_spender];
348   }
349 
350   /**
351    * @dev Increase the amount of tokens that an owner allowed to a spender.
352    *
353    * approve should be called when allowed[_spender] == 0. To increment
354    * allowed value is better to use this function to avoid 2 calls (and wait until
355    * the first transaction is mined)
356    * From MonolithDAO Token.sol
357    * @param _spender The address which will spend the funds.
358    * @param _addedValue The amount of tokens to increase the allowance by.
359    */
360   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
361     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
362     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
363     return true;
364   }
365 
366   /**
367    * @dev Decrease the amount of tokens that an owner allowed to a spender.
368    *
369    * approve should be called when allowed[_spender] == 0. To decrement
370    * allowed value is better to use this function to avoid 2 calls (and wait until
371    * the first transaction is mined)
372    * From MonolithDAO Token.sol
373    * @param _spender The address which will spend the funds.
374    * @param _subtractedValue The amount of tokens to decrease the allowance by.
375    */
376   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
377     uint oldValue = allowed[msg.sender][_spender];
378     if (_subtractedValue > oldValue) {
379       allowed[msg.sender][_spender] = 0;
380     } else {
381       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
382     }
383     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
384     return true;
385   }
386 
387 }
388 
389 /**
390  * @title Mintable token
391  * @dev Simple ERC20 Token example, with mintable token creation
392  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
393  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
394  */
395 contract MintableToken is StandardToken, Ownable {
396   event Mint(address indexed to, uint256 amount);
397   event MintFinished();
398 
399   bool public mintingFinished = false;
400 
401 
402   modifier canMint() {
403     require(!mintingFinished);
404     _;
405   }
406 
407   /**
408    * @dev Function to mint tokens
409    * @param _to The address that will receive the minted tokens.
410    * @param _amount The amount of tokens to mint.
411    * @return A boolean that indicates if the operation was successful.
412    */
413   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
414     totalSupply_ = totalSupply_.add(_amount);
415     balances[_to] = balances[_to].add(_amount);
416     Mint(_to, _amount);
417     Transfer(address(0), _to, _amount);
418     return true;
419   }
420 
421   /**
422    * @dev Function to stop minting new tokens.
423    * @return True if the operation was successful.
424    */
425   function finishMinting() onlyOwner canMint public returns (bool) {
426     mintingFinished = true;
427     MintFinished();
428     return true;
429   }
430 }
431 
432 /**
433    @title ERC827, an extension of ERC20 token standard
434 
435    Implementation the ERC827, following the ERC20 standard with extra
436    methods to transfer value and data and execute calls in transfers and
437    approvals.
438    Uses OpenZeppelin StandardToken.
439  */
440 contract ERC827Token is ERC827, StandardToken {
441 
442   /**
443      @dev Addition to ERC20 token methods. It allows to
444      approve the transfer of value and execute a call with the sent data.
445 
446      Beware that changing an allowance with this method brings the risk that
447      someone may use both the old and the new allowance by unfortunate
448      transaction ordering. One possible solution to mitigate this race condition
449      is to first reduce the spender's allowance to 0 and set the desired value
450      afterwards:
451      https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
452 
453      @param _spender The address that will spend the funds.
454      @param _value The amount of tokens to be spent.
455      @param _data ABI-encoded contract call to call `_to` address.
456 
457      @return true if the call function was executed successfully
458    */
459   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
460     require(_spender != address(this));
461 
462     super.approve(_spender, _value);
463 
464     require(_spender.call(_data));
465 
466     return true;
467   }
468 
469   /**
470      @dev Addition to ERC20 token methods. Transfer tokens to a specified
471      address and execute a call with the sent data on the same transaction
472 
473      @param _to address The address which you want to transfer to
474      @param _value uint256 the amout of tokens to be transfered
475      @param _data ABI-encoded contract call to call `_to` address.
476 
477      @return true if the call function was executed successfully
478    */
479   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
480     require(_to != address(this));
481 
482     super.transfer(_to, _value);
483 
484     require(_to.call(_data));
485     return true;
486   }
487 
488   /**
489      @dev Addition to ERC20 token methods. Transfer tokens from one address to
490      another and make a contract call on the same transaction
491 
492      @param _from The address which you want to send tokens from
493      @param _to The address which you want to transfer to
494      @param _value The amout of tokens to be transferred
495      @param _data ABI-encoded contract call to call `_to` address.
496 
497      @return true if the call function was executed successfully
498    */
499   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
500     require(_to != address(this));
501 
502     super.transferFrom(_from, _to, _value);
503 
504     require(_to.call(_data));
505     return true;
506   }
507 
508   /**
509    * @dev Addition to StandardToken methods. Increase the amount of tokens that
510    * an owner allowed to a spender and execute a call with the sent data.
511    *
512    * approve should be called when allowed[_spender] == 0. To increment
513    * allowed value is better to use this function to avoid 2 calls (and wait until
514    * the first transaction is mined)
515    * From MonolithDAO Token.sol
516    * @param _spender The address which will spend the funds.
517    * @param _addedValue The amount of tokens to increase the allowance by.
518    * @param _data ABI-encoded contract call to call `_spender` address.
519    */
520   function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
521     require(_spender != address(this));
522 
523     super.increaseApproval(_spender, _addedValue);
524 
525     require(_spender.call(_data));
526 
527     return true;
528   }
529 
530   /**
531    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
532    * an owner allowed to a spender and execute a call with the sent data.
533    *
534    * approve should be called when allowed[_spender] == 0. To decrement
535    * allowed value is better to use this function to avoid 2 calls (and wait until
536    * the first transaction is mined)
537    * From MonolithDAO Token.sol
538    * @param _spender The address which will spend the funds.
539    * @param _subtractedValue The amount of tokens to decrease the allowance by.
540    * @param _data ABI-encoded contract call to call `_spender` address.
541    */
542   function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
543     require(_spender != address(this));
544 
545     super.decreaseApproval(_spender, _subtractedValue);
546 
547     require(_spender.call(_data));
548 
549     return true;
550   }
551 
552 }
553 
554 // ==== DOCT Contracts ===
555 
556 contract DOCTToken is MintableToken, ERC827Token, NoOwner {
557     string public symbol = 'DOCT';
558     string public name = 'DocTailor';
559     uint8 public constant decimals = 8;
560 
561     address founder;                //founder address to allow him transfer tokens even when transfers disabled
562     bool public transferEnabled;    //allows to dissable transfers while minting and in case of emergency
563 
564     function setFounder(address _founder) onlyOwner public {
565         founder = _founder;
566     }
567     function setTransferEnabled(bool enable) onlyOwner public {
568         transferEnabled = enable;
569     }
570     modifier canTransfer() {
571         require( transferEnabled || msg.sender == founder || msg.sender == owner);
572         _;
573     }
574     
575     function transfer(address _to, uint256 _value) canTransfer public returns (bool) {
576         return super.transfer(_to, _value);
577     }
578     function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {
579         return super.transferFrom(_from, _to, _value);
580     }
581     function transfer(address _to, uint256 _value, bytes _data) canTransfer public returns (bool) {
582         return super.transfer(_to, _value, _data);
583     }
584     function transferFrom(address _from, address _to, uint256 _value, bytes _data) canTransfer public returns (bool) {
585         return super.transferFrom(_from, _to, _value, _data);
586     }
587 }