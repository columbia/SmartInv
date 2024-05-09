1 pragma solidity ^0.4.15;
2 
3 //====== Open Zeppelin Library =====
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   uint256 public totalSupply;
12   function balanceOf(address who) public constant returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 /**
18  * @title ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/20
20  */
21 contract ERC20 is ERC20Basic {
22   function allowance(address owner, address spender) public constant returns (uint256);
23   function transferFrom(address from, address to, uint256 value) public returns (bool);
24   function approve(address spender, uint256 value) public returns (bool);
25   event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 /**
29  * @title SafeMath
30  * @dev Math operations with safety checks that throw on error
31  */
32 library SafeMath {
33   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
34     if (a == 0) {
35       return 0;
36     }
37     uint256 c = a * b;
38     assert(c / a == b);
39     return c;
40   }
41 
42   function div(uint256 a, uint256 b) internal constant returns (uint256) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     uint256 c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return c;
47   }
48 
49   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
50     assert(b <= a);
51     return a - b;
52   }
53 
54   function add(uint256 a, uint256 b) internal constant returns (uint256) {
55     uint256 c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 
62 /**
63  * @title SafeERC20
64  * @dev Wrappers around ERC20 operations that throw on failure.
65  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
66  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
67  */
68 library SafeERC20 {
69   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
70     assert(token.transfer(to, value));
71   }
72 
73   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
74     assert(token.transferFrom(from, to, value));
75   }
76 
77   function safeApprove(ERC20 token, address spender, uint256 value) internal {
78     assert(token.approve(spender, value));
79   }
80 }
81 
82 /**
83  * @title Ownable
84  * @dev The Ownable contract has an owner address, and provides basic authorization control
85  * functions, this simplifies the implementation of "user permissions".
86  */
87 contract Ownable {
88   address public owner;
89 
90 
91   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
92 
93 
94   /**
95    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
96    * account.
97    */
98   function Ownable() {
99     owner = msg.sender;
100   }
101 
102 
103   /**
104    * @dev Throws if called by any account other than the owner.
105    */
106   modifier onlyOwner() {
107     require(msg.sender == owner);
108     _;
109   }
110 
111 
112   /**
113    * @dev Allows the current owner to transfer control of the contract to a newOwner.
114    * @param newOwner The address to transfer ownership to.
115    */
116   function transferOwnership(address newOwner) onlyOwner public {
117     require(newOwner != address(0));
118     OwnershipTransferred(owner, newOwner);
119     owner = newOwner;
120   }
121 
122 }
123 
124 
125 /**
126  * @title Contracts that should not own Ether
127  * @author Remco Bloemen <remco@2π.com>
128  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
129  * in the contract, it will allow the owner to reclaim this ether.
130  * @notice Ether can still be send to this contract by:
131  * calling functions labeled `payable`
132  * `selfdestruct(contract_address)`
133  * mining directly to the contract address
134 */
135 contract HasNoEther is Ownable {
136 
137   /**
138   * @dev Constructor that rejects incoming Ether
139   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
140   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
141   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
142   * we could use assembly to access msg.value.
143   */
144   function HasNoEther() payable {
145     require(msg.value == 0);
146   }
147 
148   /**
149    * @dev Disallows direct send by settings a default function without the `payable` flag.
150    */
151   function() external {
152   }
153 
154   /**
155    * @dev Transfer all Ether held by the contract to the owner.
156    */
157   function reclaimEther() external onlyOwner {
158     assert(owner.send(this.balance));
159   }
160 }
161 
162 /**
163  * @title Contracts that should not own Contracts
164  * @author Remco Bloemen <remco@2π.com>
165  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
166  * of this contract to reclaim ownership of the contracts.
167  */
168 contract HasNoContracts is Ownable {
169 
170   /**
171    * @dev Reclaim ownership of Ownable contracts
172    * @param contractAddr The address of the Ownable to be reclaimed.
173    */
174   function reclaimContract(address contractAddr) external onlyOwner {
175     Ownable contractInst = Ownable(contractAddr);
176     contractInst.transferOwnership(owner);
177   }
178 }
179 
180 /**
181  * @title Contracts that should be able to recover tokens
182  * @author SylTi
183  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
184  * This will prevent any accidental loss of tokens.
185  */
186 contract CanReclaimToken is Ownable {
187   using SafeERC20 for ERC20Basic;
188 
189   /**
190    * @dev Reclaim all ERC20Basic compatible tokens
191    * @param token ERC20Basic The address of the token contract
192    */
193   function reclaimToken(ERC20Basic token) external onlyOwner {
194     uint256 balance = token.balanceOf(this);
195     token.safeTransfer(owner, balance);
196   }
197 
198 }
199 
200 /**
201  * @title Contracts that should not own Tokens
202  * @author Remco Bloemen <remco@2π.com>
203  * @dev This blocks incoming ERC23 tokens to prevent accidental loss of tokens.
204  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
205  * owner to reclaim the tokens.
206  */
207 contract HasNoTokens is CanReclaimToken {
208 
209  /**
210   * @dev Reject all ERC23 compatible tokens
211   * @param from_ address The address that is transferring the tokens
212   * @param value_ uint256 the amount of the specified token
213   * @param data_ Bytes The data passed from the caller.
214   */
215   function tokenFallback(address from_, uint256 value_, bytes data_) external {
216     revert();
217   }
218 
219 }
220 
221 /**
222  * @title Basic token
223  * @dev Basic version of StandardToken, with no allowances.
224  */
225 contract BasicToken is ERC20Basic {
226   using SafeMath for uint256;
227 
228   mapping(address => uint256) balances;
229 
230   /**
231   * @dev transfer token for a specified address
232   * @param _to The address to transfer to.
233   * @param _value The amount to be transferred.
234   */
235   function transfer(address _to, uint256 _value) public returns (bool) {
236     require(_to != address(0));
237     require(_value <= balances[msg.sender]);
238 
239     // SafeMath.sub will throw if there is not enough balance.
240     balances[msg.sender] = balances[msg.sender].sub(_value);
241     balances[_to] = balances[_to].add(_value);
242     Transfer(msg.sender, _to, _value);
243     return true;
244   }
245 
246   /**
247   * @dev Gets the balance of the specified address.
248   * @param _owner The address to query the the balance of.
249   * @return An uint256 representing the amount owned by the passed address.
250   */
251   function balanceOf(address _owner) public constant returns (uint256 balance) {
252     return balances[_owner];
253   }
254 
255 }
256 
257 /**
258  * @title Standard ERC20 token
259  *
260  * @dev Implementation of the basic standard token.
261  * @dev https://github.com/ethereum/EIPs/issues/20
262  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
263  */
264 contract StandardToken is ERC20, BasicToken {
265 
266   mapping (address => mapping (address => uint256)) internal allowed;
267 
268 
269   /**
270    * @dev Transfer tokens from one address to another
271    * @param _from address The address which you want to send tokens from
272    * @param _to address The address which you want to transfer to
273    * @param _value uint256 the amount of tokens to be transferred
274    */
275   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
276     require(_to != address(0));
277     require(_value <= balances[_from]);
278     require(_value <= allowed[_from][msg.sender]);
279 
280     balances[_from] = balances[_from].sub(_value);
281     balances[_to] = balances[_to].add(_value);
282     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
283     Transfer(_from, _to, _value);
284     return true;
285   }
286 
287   /**
288    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
289    *
290    * Beware that changing an allowance with this method brings the risk that someone may use both the old
291    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
292    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
293    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
294    * @param _spender The address which will spend the funds.
295    * @param _value The amount of tokens to be spent.
296    */
297   function approve(address _spender, uint256 _value) public returns (bool) {
298     allowed[msg.sender][_spender] = _value;
299     Approval(msg.sender, _spender, _value);
300     return true;
301   }
302 
303   /**
304    * @dev Function to check the amount of tokens that an owner allowed to a spender.
305    * @param _owner address The address which owns the funds.
306    * @param _spender address The address which will spend the funds.
307    * @return A uint256 specifying the amount of tokens still available for the spender.
308    */
309   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
310     return allowed[_owner][_spender];
311   }
312 
313   /**
314    * approve should be called when allowed[_spender] == 0. To increment
315    * allowed value is better to use this function to avoid 2 calls (and wait until
316    * the first transaction is mined)
317    * From MonolithDAO Token.sol
318    */
319   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
320     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
321     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
322     return true;
323   }
324 
325   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
326     uint oldValue = allowed[msg.sender][_spender];
327     if (_subtractedValue > oldValue) {
328       allowed[msg.sender][_spender] = 0;
329     } else {
330       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
331     }
332     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
333     return true;
334   }
335 
336 }
337 
338 /**
339  * @title Mintable token
340  * @dev Simple ERC20 Token example, with mintable token creation
341  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
342  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
343  */
344 
345 contract MintableToken is StandardToken, Ownable {
346   event Mint(address indexed to, uint256 amount);
347   event MintFinished();
348 
349   bool public mintingFinished = false;
350 
351 
352   modifier canMint() {
353     require(!mintingFinished);
354     _;
355   }
356 
357   /**
358    * @dev Function to mint tokens
359    * @param _to The address that will receive the minted tokens.
360    * @param _amount The amount of tokens to mint.
361    * @return A boolean that indicates if the operation was successful.
362    */
363   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
364     totalSupply = totalSupply.add(_amount);
365     balances[_to] = balances[_to].add(_amount);
366     Mint(_to, _amount);
367     Transfer(address(0), _to, _amount);
368     return true;
369   }
370 
371   /**
372    * @dev Function to stop minting new tokens.
373    * @return True if the operation was successful.
374    */
375   function finishMinting() onlyOwner canMint public returns (bool) {
376     mintingFinished = true;
377     MintFinished();
378     return true;
379   }
380 }
381 
382 
383 //====== Zloadr Contracts =====
384 contract ZDRToken is MintableToken, HasNoContracts, HasNoTokens, HasNoEther { //MintableToken is StandardToken, Ownable
385     string public symbol = 'ZDR';
386     string public name = 'Zloadr Token';
387     uint8 public constant decimals = 8;
388 
389     /**
390      * Allow transfer only after crowdsale finished
391      */
392     modifier canTransfer() {
393         require(mintingFinished);
394         _;
395     }
396     
397     function transfer(address _to, uint256 _value) canTransfer public returns (bool) {
398         return super.transfer(_to, _value);
399     }
400 
401     function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {
402         return super.transferFrom(_from, _to, _value);
403     }
404 }