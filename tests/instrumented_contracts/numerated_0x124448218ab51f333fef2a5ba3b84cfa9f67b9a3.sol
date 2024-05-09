1 pragma solidity ^0.4.18;
2 
3 /**
4 * Bob Repair's Promo token Airdrop
5 * Web: http://bobsrepair.com/
6 * Telegram: https://t.me/Bobtoken
7 * Facebook: https://www.facebook.com/BobsRepairCom/
8 * Twitter:  https://twitter.com/BobsRepair
9 */
10 
11 // ==== Open Zeppelin library ===
12 
13 /**
14  * @title ERC20Basic
15  * @dev Simpler version of ERC20 interface
16  * @dev see https://github.com/ethereum/EIPs/issues/179
17  */
18 contract ERC20Basic {
19   uint256 public totalSupply;
20   function balanceOf(address who) public view returns (uint256);
21   function transfer(address to, uint256 value) public returns (bool);
22   event Transfer(address indexed from, address indexed to, uint256 value);
23 }
24 
25 /**
26  * @title ERC20 interface
27  * @dev see https://github.com/ethereum/EIPs/issues/20
28  */
29 contract ERC20 is ERC20Basic {
30   function allowance(address owner, address spender) public view returns (uint256);
31   function transferFrom(address from, address to, uint256 value) public returns (bool);
32   function approve(address spender, uint256 value) public returns (bool);
33   event Approval(address indexed owner, address indexed spender, uint256 value);
34 }
35 
36 
37 /**
38  * @title SafeMath
39  * @dev Math operations with safety checks that throw on error
40  */
41 library SafeMath {
42   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43     if (a == 0) {
44       return 0;
45     }
46     uint256 c = a * b;
47     assert(c / a == b);
48     return c;
49   }
50 
51   function div(uint256 a, uint256 b) internal pure returns (uint256) {
52     // assert(b > 0); // Solidity automatically throws when dividing by 0
53     uint256 c = a / b;
54     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55     return c;
56   }
57 
58   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   function add(uint256 a, uint256 b) internal pure returns (uint256) {
64     uint256 c = a + b;
65     assert(c >= a);
66     return c;
67   }
68 }
69 
70 /**
71  * @title SafeERC20
72  * @dev Wrappers around ERC20 operations that throw on failure.
73  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
74  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
75  */
76 library SafeERC20 {
77   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
78     assert(token.transfer(to, value));
79   }
80 
81   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
82     assert(token.transferFrom(from, to, value));
83   }
84 
85   function safeApprove(ERC20 token, address spender, uint256 value) internal {
86     assert(token.approve(spender, value));
87   }
88 }
89 
90 /**
91  * @title Ownable
92  * @dev The Ownable contract has an owner address, and provides basic authorization control
93  * functions, this simplifies the implementation of "user permissions".
94  */
95 contract Ownable {
96   address public owner;
97 
98 
99   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
100 
101 
102   /**
103    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
104    * account.
105    */
106   function Ownable() public {
107     owner = msg.sender;
108   }
109 
110 
111   /**
112    * @dev Throws if called by any account other than the owner.
113    */
114   modifier onlyOwner() {
115     require(msg.sender == owner);
116     _;
117   }
118 
119 
120   /**
121    * @dev Allows the current owner to transfer control of the contract to a newOwner.
122    * @param newOwner The address to transfer ownership to.
123    */
124   function transferOwnership(address newOwner) public onlyOwner {
125     require(newOwner != address(0));
126     OwnershipTransferred(owner, newOwner);
127     owner = newOwner;
128   }
129 
130 }
131 
132 /**
133  * @title Contracts that should not own Ether
134  * @author Remco Bloemen <remco@2π.com>
135  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
136  * in the contract, it will allow the owner to reclaim this ether.
137  * @notice Ether can still be send to this contract by:
138  * calling functions labeled `payable`
139  * `selfdestruct(contract_address)`
140  * mining directly to the contract address
141 */
142 contract HasNoEther is Ownable {
143 
144   /**
145   * @dev Constructor that rejects incoming Ether
146   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
147   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
148   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
149   * we could use assembly to access msg.value.
150   */
151   function HasNoEther() public payable {
152     require(msg.value == 0);
153   }
154 
155   /**
156    * @dev Disallows direct send by settings a default function without the `payable` flag.
157    */
158   function() external {
159   }
160 
161   /**
162    * @dev Transfer all Ether held by the contract to the owner.
163    */
164   function reclaimEther() external onlyOwner {
165     assert(owner.send(this.balance));
166   }
167 }
168 
169 /**
170  * @title Contracts that should not own Contracts
171  * @author Remco Bloemen <remco@2π.com>
172  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
173  * of this contract to reclaim ownership of the contracts.
174  */
175 contract HasNoContracts is Ownable {
176 
177   /**
178    * @dev Reclaim ownership of Ownable contracts
179    * @param contractAddr The address of the Ownable to be reclaimed.
180    */
181   function reclaimContract(address contractAddr) external onlyOwner {
182     Ownable contractInst = Ownable(contractAddr);
183     contractInst.transferOwnership(owner);
184   }
185 }
186 
187 /**
188  * @title Contracts that should be able to recover tokens
189  * @author SylTi
190  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
191  * This will prevent any accidental loss of tokens.
192  */
193 contract CanReclaimToken is Ownable {
194   using SafeERC20 for ERC20Basic;
195 
196   /**
197    * @dev Reclaim all ERC20Basic compatible tokens
198    * @param token ERC20Basic The address of the token contract
199    */
200   function reclaimToken(ERC20Basic token) external onlyOwner {
201     uint256 balance = token.balanceOf(this);
202     token.safeTransfer(owner, balance);
203   }
204 
205 }
206 
207 /**
208  * @title Contracts that should not own Tokens
209  * @author Remco Bloemen <remco@2π.com>
210  * @dev This blocks incoming ERC23 tokens to prevent accidental loss of tokens.
211  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
212  * owner to reclaim the tokens.
213  */
214 contract HasNoTokens is CanReclaimToken {
215 
216  /**
217   * @dev Reject all ERC23 compatible tokens
218   * @param from_ address The address that is transferring the tokens
219   * @param value_ uint256 the amount of the specified token
220   * @param data_ Bytes The data passed from the caller.
221   */
222   function tokenFallback(address from_, uint256 value_, bytes data_) pure external {
223     from_;
224     value_;
225     data_;
226     revert();
227   }
228 
229 }
230 
231 /**
232  * @title Base contract for contracts that should not own things.
233  * @author Remco Bloemen <remco@2π.com>
234  * @dev Solves a class of errors where a contract accidentally becomes owner of Ether, Tokens or
235  * Owned contracts. See respective base contracts for details.
236  */
237 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
238 }
239 
240 /**
241  * @title Destructible
242  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
243  */
244 contract Destructible is Ownable {
245 
246   function Destructible() public payable { }
247 
248   /**
249    * @dev Transfers the current balance to the owner and terminates the contract.
250    */
251   function destroy() onlyOwner public {
252     selfdestruct(owner);
253   }
254 
255   function destroyAndSend(address _recipient) onlyOwner public {
256     selfdestruct(_recipient);
257   }
258 }
259 
260 /**
261  * @title Basic token
262  * @dev Basic version of StandardToken, with no allowances.
263  */
264 contract BasicToken is ERC20Basic {
265   using SafeMath for uint256;
266 
267   mapping(address => uint256) balances;
268 
269   /**
270   * @dev transfer token for a specified address
271   * @param _to The address to transfer to.
272   * @param _value The amount to be transferred.
273   */
274   function transfer(address _to, uint256 _value) public returns (bool) {
275     require(_to != address(0));
276     require(_value <= balances[msg.sender]);
277 
278     // SafeMath.sub will throw if there is not enough balance.
279     balances[msg.sender] = balances[msg.sender].sub(_value);
280     balances[_to] = balances[_to].add(_value);
281     Transfer(msg.sender, _to, _value);
282     return true;
283   }
284 
285   /**
286   * @dev Gets the balance of the specified address.
287   * @param _owner The address to query the the balance of.
288   * @return An uint256 representing the amount owned by the passed address.
289   */
290   function balanceOf(address _owner) public view returns (uint256 balance) {
291     return balances[_owner];
292   }
293 
294 }
295 
296 /**
297  * @title Standard ERC20 token
298  *
299  * @dev Implementation of the basic standard token.
300  * @dev https://github.com/ethereum/EIPs/issues/20
301  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
302  */
303 contract StandardToken is ERC20, BasicToken {
304 
305   mapping (address => mapping (address => uint256)) internal allowed;
306 
307 
308   /**
309    * @dev Transfer tokens from one address to another
310    * @param _from address The address which you want to send tokens from
311    * @param _to address The address which you want to transfer to
312    * @param _value uint256 the amount of tokens to be transferred
313    */
314   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
315     require(_to != address(0));
316     require(_value <= balances[_from]);
317     require(_value <= allowed[_from][msg.sender]);
318 
319     balances[_from] = balances[_from].sub(_value);
320     balances[_to] = balances[_to].add(_value);
321     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
322     Transfer(_from, _to, _value);
323     return true;
324   }
325 
326   /**
327    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
328    *
329    * Beware that changing an allowance with this method brings the risk that someone may use both the old
330    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
331    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
332    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
333    * @param _spender The address which will spend the funds.
334    * @param _value The amount of tokens to be spent.
335    */
336   function approve(address _spender, uint256 _value) public returns (bool) {
337     allowed[msg.sender][_spender] = _value;
338     Approval(msg.sender, _spender, _value);
339     return true;
340   }
341 
342   /**
343    * @dev Function to check the amount of tokens that an owner allowed to a spender.
344    * @param _owner address The address which owns the funds.
345    * @param _spender address The address which will spend the funds.
346    * @return A uint256 specifying the amount of tokens still available for the spender.
347    */
348   function allowance(address _owner, address _spender) public view returns (uint256) {
349     return allowed[_owner][_spender];
350   }
351 
352   /**
353    * approve should be called when allowed[_spender] == 0. To increment
354    * allowed value is better to use this function to avoid 2 calls (and wait until
355    * the first transaction is mined)
356    * From MonolithDAO Token.sol
357    */
358   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
359     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
360     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
361     return true;
362   }
363 
364   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
365     uint oldValue = allowed[msg.sender][_spender];
366     if (_subtractedValue > oldValue) {
367       allowed[msg.sender][_spender] = 0;
368     } else {
369       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
370     }
371     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
372     return true;
373   }
374 
375 }
376 
377 /**
378  * @title Mintable token
379  * @dev Simple ERC20 Token example, with mintable token creation
380  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
381  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
382  */
383 
384 contract MintableToken is StandardToken, Ownable {
385   event Mint(address indexed to, uint256 amount);
386   event MintFinished();
387 
388   bool public mintingFinished = false;
389 
390 
391   modifier canMint() {
392     require(!mintingFinished);
393     _;
394   }
395 
396   /**
397    * @dev Function to mint tokens
398    * @param _to The address that will receive the minted tokens.
399    * @param _amount The amount of tokens to mint.
400    * @return A boolean that indicates if the operation was successful.
401    */
402   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
403     totalSupply = totalSupply.add(_amount);
404     balances[_to] = balances[_to].add(_amount);
405     Mint(_to, _amount);
406     Transfer(address(0), _to, _amount);
407     return true;
408   }
409 
410   /**
411    * @dev Function to stop minting new tokens.
412    * @return True if the operation was successful.
413    */
414   function finishMinting() onlyOwner canMint public returns (bool) {
415     mintingFinished = true;
416     MintFinished();
417     return true;
418   }
419 }
420 
421 // ==== BOB Contracts ===
422 contract TokenReceiver {
423     function tokenTransferNotify(address token, address from, uint256 value) public returns (bool);
424 }
425 
426 contract BOBPToken is MintableToken, NoOwner, Destructible { //MintableToken is StandardToken, Ownable
427     string public symbol = 'BOBP';
428     string public name = 'BOB Promo';
429     uint8 public constant decimals = 18;
430 
431     bool public transfersEnabled = true;
432     TokenReceiver public ico;
433 
434     /**
435      * Allow transfer only after crowdsale finished
436      */
437     modifier canTransfer() {
438         require(transfersEnabled);
439         _;
440     }
441     /**
442     * @notice Use for disable transfers before exchange to main BOB tokens
443     */
444     function setTransfersEnabled(bool enable) onlyOwner public {
445         transfersEnabled = enable;
446     }
447     
448     function transfer(address _to, uint256 _value) canTransfer public returns (bool) {
449         notifyICO(msg.sender, _to, _value);
450         return super.transfer(_to, _value);
451     }
452 
453     function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {
454         notifyICO(_from, _to, _value);
455         return super.transferFrom(_from, _to, _value);
456     }
457 
458     function setICO(TokenReceiver _ico) onlyOwner public {
459         ico = _ico;
460     }
461     function notifyICO(address _from, address _to, uint256 _value) internal {
462         if(address(ico) != address(0) && _to == address(ico)){
463             require(ico.tokenTransferNotify(address(this), _from, _value));
464         }
465     }
466 }