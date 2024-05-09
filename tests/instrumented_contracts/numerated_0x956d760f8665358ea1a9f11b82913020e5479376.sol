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
34     uint256 c = a * b;
35     assert(a == 0 || c / a == b);
36     return c;
37   }
38 
39   function div(uint256 a, uint256 b) internal constant returns (uint256) {
40     // assert(b > 0); // Solidity automatically throws when dividing by 0
41     uint256 c = a / b;
42     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43     return c;
44   }
45 
46   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   function add(uint256 a, uint256 b) internal constant returns (uint256) {
52     uint256 c = a + b;
53     assert(c >= a);
54     return c;
55   }
56 }
57 
58 
59 /**
60  * @title SafeERC20
61  * @dev Wrappers around ERC20 operations that throw on failure.
62  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
63  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
64  */
65 library SafeERC20 {
66   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
67     assert(token.transfer(to, value));
68   }
69 
70   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
71     assert(token.transferFrom(from, to, value));
72   }
73 
74   function safeApprove(ERC20 token, address spender, uint256 value) internal {
75     assert(token.approve(spender, value));
76   }
77 }
78 
79 /**
80  * @title Ownable
81  * @dev The Ownable contract has an owner address, and provides basic authorization control
82  * functions, this simplifies the implementation of "user permissions".
83  */
84 contract Ownable {
85   address public owner;
86 
87 
88   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
89 
90 
91   /**
92    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
93    * account.
94    */
95   function Ownable() {
96     owner = msg.sender;
97   }
98 
99 
100   /**
101    * @dev Throws if called by any account other than the owner.
102    */
103   modifier onlyOwner() {
104     require(msg.sender == owner);
105     _;
106   }
107 
108 
109   /**
110    * @dev Allows the current owner to transfer control of the contract to a newOwner.
111    * @param newOwner The address to transfer ownership to.
112    */
113   function transferOwnership(address newOwner) onlyOwner public {
114     require(newOwner != address(0));
115     OwnershipTransferred(owner, newOwner);
116     owner = newOwner;
117   }
118 
119 }
120 
121 
122 /**
123  * @title Contracts that should not own Ether
124  * @author Remco Bloemen <remco@2π.com>
125  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
126  * in the contract, it will allow the owner to reclaim this ether.
127  * @notice Ether can still be send to this contract by:
128  * calling functions labeled `payable`
129  * `selfdestruct(contract_address)`
130  * mining directly to the contract address
131 */
132 contract HasNoEther is Ownable {
133 
134   /**
135   * @dev Constructor that rejects incoming Ether
136   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
137   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
138   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
139   * we could use assembly to access msg.value.
140   */
141   function HasNoEther() payable {
142     require(msg.value == 0);
143   }
144 
145   /**
146    * @dev Disallows direct send by settings a default function without the `payable` flag.
147    */
148   function() external {
149   }
150 
151   /**
152    * @dev Transfer all Ether held by the contract to the owner.
153    */
154   function reclaimEther() external onlyOwner {
155     assert(owner.send(this.balance));
156   }
157 }
158 
159 /**
160  * @title Contracts that should not own Contracts
161  * @author Remco Bloemen <remco@2π.com>
162  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
163  * of this contract to reclaim ownership of the contracts.
164  */
165 contract HasNoContracts is Ownable {
166 
167   /**
168    * @dev Reclaim ownership of Ownable contracts
169    * @param contractAddr The address of the Ownable to be reclaimed.
170    */
171   function reclaimContract(address contractAddr) external onlyOwner {
172     Ownable contractInst = Ownable(contractAddr);
173     contractInst.transferOwnership(owner);
174   }
175 }
176 
177 /**
178  * @title Contracts that should be able to recover tokens
179  * @author SylTi
180  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
181  * This will prevent any accidental loss of tokens.
182  */
183 contract CanReclaimToken is Ownable {
184   using SafeERC20 for ERC20Basic;
185 
186   /**
187    * @dev Reclaim all ERC20Basic compatible tokens
188    * @param token ERC20Basic The address of the token contract
189    */
190   function reclaimToken(ERC20Basic token) external onlyOwner {
191     uint256 balance = token.balanceOf(this);
192     token.safeTransfer(owner, balance);
193   }
194 
195 }
196 
197 /**
198  * @title Contracts that should not own Tokens
199  * @author Remco Bloemen <remco@2π.com>
200  * @dev This blocks incoming ERC23 tokens to prevent accidental loss of tokens.
201  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
202  * owner to reclaim the tokens.
203  */
204 contract HasNoTokens is CanReclaimToken {
205 
206  /**
207   * @dev Reject all ERC23 compatible tokens
208   * param from_ address The address that is transferring the tokens
209   * param value_ uint256 the amount of the specified token
210   * param data_ Bytes The data passed from the caller.
211   */
212   function tokenFallback(address /*from_*/, uint256 /*value_*/, bytes /*data_*/) external {
213     revert();
214   }
215 
216 }
217 
218 /**
219  * @title Basic token
220  * @dev Basic version of StandardToken, with no allowances.
221  */
222 contract BasicToken is ERC20Basic {
223   using SafeMath for uint256;
224 
225   mapping(address => uint256) balances;
226 
227   /**
228   * @dev transfer token for a specified address
229   * @param _to The address to transfer to.
230   * @param _value The amount to be transferred.
231   */
232   function transfer(address _to, uint256 _value) public returns (bool) {
233     require(_to != address(0));
234     require(_value <= balances[msg.sender]);
235 
236     // SafeMath.sub will throw if there is not enough balance.
237     balances[msg.sender] = balances[msg.sender].sub(_value);
238     balances[_to] = balances[_to].add(_value);
239     Transfer(msg.sender, _to, _value);
240     return true;
241   }
242 
243   /**
244   * @dev Gets the balance of the specified address.
245   * @param _owner The address to query the the balance of.
246   * @return An uint256 representing the amount owned by the passed address.
247   */
248   function balanceOf(address _owner) public constant returns (uint256 balance) {
249     return balances[_owner];
250   }
251 
252 }
253 
254 /**
255  * @title Standard ERC20 token
256  *
257  * @dev Implementation of the basic standard token.
258  * @dev https://github.com/ethereum/EIPs/issues/20
259  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
260  */
261 contract StandardToken is ERC20, BasicToken {
262 
263   mapping (address => mapping (address => uint256)) internal allowed;
264 
265 
266   /**
267    * @dev Transfer tokens from one address to another
268    * @param _from address The address which you want to send tokens from
269    * @param _to address The address which you want to transfer to
270    * @param _value uint256 the amount of tokens to be transferred
271    */
272   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
273     require(_to != address(0));
274     require(_value <= balances[_from]);
275     require(_value <= allowed[_from][msg.sender]);
276 
277     balances[_from] = balances[_from].sub(_value);
278     balances[_to] = balances[_to].add(_value);
279     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
280     Transfer(_from, _to, _value);
281     return true;
282   }
283 
284   /**
285    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
286    *
287    * Beware that changing an allowance with this method brings the risk that someone may use both the old
288    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
289    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
290    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
291    * @param _spender The address which will spend the funds.
292    * @param _value The amount of tokens to be spent.
293    */
294   function approve(address _spender, uint256 _value) public returns (bool) {
295     allowed[msg.sender][_spender] = _value;
296     Approval(msg.sender, _spender, _value);
297     return true;
298   }
299 
300   /**
301    * @dev Function to check the amount of tokens that an owner allowed to a spender.
302    * @param _owner address The address which owns the funds.
303    * @param _spender address The address which will spend the funds.
304    * @return A uint256 specifying the amount of tokens still available for the spender.
305    */
306   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
307     return allowed[_owner][_spender];
308   }
309 
310   /**
311    * approve should be called when allowed[_spender] == 0. To increment
312    * allowed value is better to use this function to avoid 2 calls (and wait until
313    * the first transaction is mined)
314    * From MonolithDAO Token.sol
315    */
316   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
317     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
318     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
319     return true;
320   }
321 
322   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
323     uint oldValue = allowed[msg.sender][_spender];
324     if (_subtractedValue > oldValue) {
325       allowed[msg.sender][_spender] = 0;
326     } else {
327       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
328     }
329     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
330     return true;
331   }
332 
333 }
334 
335 /**
336  * @title Mintable token
337  * @dev Simple ERC20 Token example, with mintable token creation
338  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
339  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
340  */
341 
342 contract MintableToken is StandardToken, Ownable {
343   event Mint(address indexed to, uint256 amount);
344   event MintFinished();
345 
346   bool public mintingFinished = false;
347 
348 
349   modifier canMint() {
350     require(!mintingFinished);
351     _;
352   }
353 
354   /**
355    * @dev Function to mint tokens
356    * @param _to The address that will receive the minted tokens.
357    * @param _amount The amount of tokens to mint.
358    * @return A boolean that indicates if the operation was successful.
359    */
360   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
361     totalSupply = totalSupply.add(_amount);
362     balances[_to] = balances[_to].add(_amount);
363     Mint(_to, _amount);
364     Transfer(address(0), _to, _amount);
365     return true;
366   }
367 
368   /**
369    * @dev Function to stop minting new tokens.
370    * @return True if the operation was successful.
371    */
372   function finishMinting() onlyOwner public returns (bool) {
373     mintingFinished = true;
374     MintFinished();
375     return true;
376   }
377 }
378 
379 //====== Zloadr Contracts =====
380 contract ZDRToken is MintableToken, HasNoContracts, HasNoTokens { //MintableToken is StandardToken, Ownable
381     string public symbol = 'ZDR';
382     string public name = 'Zloadr Token';
383     uint8 public constant decimals = 8;
384 
385     /**
386      * Allow transfer only after crowdsale finished
387      */
388     modifier canTransfer() {
389         require(mintingFinished);
390         _;
391     }
392     
393     function transfer(address _to, uint256 _value) canTransfer returns (bool) {
394         super.transfer(_to, _value);
395     }
396 
397     function transferFrom(address _from, address _to, uint256 _value) canTransfer returns (bool) {
398         super.transferFrom(_from, _to, _value);
399     }
400 }