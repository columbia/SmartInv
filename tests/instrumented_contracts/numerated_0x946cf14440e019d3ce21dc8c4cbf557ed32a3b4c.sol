1 pragma solidity ^0.4.23;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to transfer control of the contract to a newOwner.
39    * @param newOwner The address to transfer ownership to.
40    */
41   function transferOwnership(address newOwner) public onlyOwner {
42     require(newOwner != address(0));
43     emit OwnershipTransferred(owner, newOwner);
44     owner = newOwner;
45   }
46 
47   /**
48    * @dev Allows the current owner to relinquish control of the contract.
49    */
50   function renounceOwnership() public onlyOwner {
51     emit OwnershipRenounced(owner);
52     owner = address(0);
53   }
54 }
55 
56 // File: openzeppelin-solidity/contracts/ownership/HasNoContracts.sol
57 
58 /**
59  * @title Contracts that should not own Contracts
60  * @author Remco Bloemen <remco@2π.com>
61  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
62  * of this contract to reclaim ownership of the contracts.
63  */
64 contract HasNoContracts is Ownable {
65 
66   /**
67    * @dev Reclaim ownership of Ownable contracts
68    * @param contractAddr The address of the Ownable to be reclaimed.
69    */
70   function reclaimContract(address contractAddr) external onlyOwner {
71     Ownable contractInst = Ownable(contractAddr);
72     contractInst.transferOwnership(owner);
73   }
74 }
75 
76 // File: openzeppelin-solidity/contracts/ownership/HasNoEther.sol
77 
78 /**
79  * @title Contracts that should not own Ether
80  * @author Remco Bloemen <remco@2π.com>
81  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
82  * in the contract, it will allow the owner to reclaim this ether.
83  * @notice Ether can still be sent to this contract by:
84  * calling functions labeled `payable`
85  * `selfdestruct(contract_address)`
86  * mining directly to the contract address
87  */
88 contract HasNoEther is Ownable {
89 
90   /**
91   * @dev Constructor that rejects incoming Ether
92   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
93   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
94   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
95   * we could use assembly to access msg.value.
96   */
97   constructor() public payable {
98     require(msg.value == 0);
99   }
100 
101   /**
102    * @dev Disallows direct send by settings a default function without the `payable` flag.
103    */
104   function() external {
105   }
106 
107   /**
108    * @dev Transfer all Ether held by the contract to the owner.
109    */
110   function reclaimEther() external onlyOwner {
111     owner.transfer(address(this).balance);
112   }
113 }
114 
115 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
116 
117 /**
118  * @title ERC20Basic
119  * @dev Simpler version of ERC20 interface
120  * @dev see https://github.com/ethereum/EIPs/issues/179
121  */
122 contract ERC20Basic {
123   function totalSupply() public view returns (uint256);
124   function balanceOf(address who) public view returns (uint256);
125   function transfer(address to, uint256 value) public returns (bool);
126   event Transfer(address indexed from, address indexed to, uint256 value);
127 }
128 
129 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
130 
131 /**
132  * @title ERC20 interface
133  * @dev see https://github.com/ethereum/EIPs/issues/20
134  */
135 contract ERC20 is ERC20Basic {
136   function allowance(address owner, address spender)
137     public view returns (uint256);
138 
139   function transferFrom(address from, address to, uint256 value)
140     public returns (bool);
141 
142   function approve(address spender, uint256 value) public returns (bool);
143   event Approval(
144     address indexed owner,
145     address indexed spender,
146     uint256 value
147   );
148 }
149 
150 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
151 
152 /**
153  * @title SafeERC20
154  * @dev Wrappers around ERC20 operations that throw on failure.
155  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
156  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
157  */
158 library SafeERC20 {
159   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
160     require(token.transfer(to, value));
161   }
162 
163   function safeTransferFrom(
164     ERC20 token,
165     address from,
166     address to,
167     uint256 value
168   )
169     internal
170   {
171     require(token.transferFrom(from, to, value));
172   }
173 
174   function safeApprove(ERC20 token, address spender, uint256 value) internal {
175     require(token.approve(spender, value));
176   }
177 }
178 
179 // File: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol
180 
181 /**
182  * @title Contracts that should be able to recover tokens
183  * @author SylTi
184  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
185  * This will prevent any accidental loss of tokens.
186  */
187 contract CanReclaimToken is Ownable {
188   using SafeERC20 for ERC20Basic;
189 
190   /**
191    * @dev Reclaim all ERC20Basic compatible tokens
192    * @param token ERC20Basic The address of the token contract
193    */
194   function reclaimToken(ERC20Basic token) external onlyOwner {
195     uint256 balance = token.balanceOf(this);
196     token.safeTransfer(owner, balance);
197   }
198 
199 }
200 
201 // File: openzeppelin-solidity/contracts/ownership/HasNoTokens.sol
202 
203 /**
204  * @title Contracts that should not own Tokens
205  * @author Remco Bloemen <remco@2π.com>
206  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
207  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
208  * owner to reclaim the tokens.
209  */
210 contract HasNoTokens is CanReclaimToken {
211 
212  /**
213   * @dev Reject all ERC223 compatible tokens
214   * @param from_ address The address that is transferring the tokens
215   * @param value_ uint256 the amount of the specified token
216   * @param data_ Bytes The data passed from the caller.
217   */
218   function tokenFallback(address from_, uint256 value_, bytes data_) external {
219     from_;
220     value_;
221     data_;
222     revert();
223   }
224 
225 }
226 
227 // File: openzeppelin-solidity/contracts/ownership/NoOwner.sol
228 
229 /**
230  * @title Base contract for contracts that should not own things.
231  * @author Remco Bloemen <remco@2π.com>
232  * @dev Solves a class of errors where a contract accidentally becomes owner of Ether, Tokens or
233  * Owned contracts. See respective base contracts for details.
234  */
235 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
236 }
237 
238 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
239 
240 /**
241  * @title SafeMath
242  * @dev Math operations with safety checks that throw on error
243  */
244 library SafeMath {
245 
246   /**
247   * @dev Multiplies two numbers, throws on overflow.
248   */
249   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
250     if (a == 0) {
251       return 0;
252     }
253     c = a * b;
254     assert(c / a == b);
255     return c;
256   }
257 
258   /**
259   * @dev Integer division of two numbers, truncating the quotient.
260   */
261   function div(uint256 a, uint256 b) internal pure returns (uint256) {
262     // assert(b > 0); // Solidity automatically throws when dividing by 0
263     // uint256 c = a / b;
264     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
265     return a / b;
266   }
267 
268   /**
269   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
270   */
271   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
272     assert(b <= a);
273     return a - b;
274   }
275 
276   /**
277   * @dev Adds two numbers, throws on overflow.
278   */
279   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
280     c = a + b;
281     assert(c >= a);
282     return c;
283   }
284 }
285 
286 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
287 
288 /**
289  * @title Basic token
290  * @dev Basic version of StandardToken, with no allowances.
291  */
292 contract BasicToken is ERC20Basic {
293   using SafeMath for uint256;
294 
295   mapping(address => uint256) balances;
296 
297   uint256 totalSupply_;
298 
299   /**
300   * @dev total number of tokens in existence
301   */
302   function totalSupply() public view returns (uint256) {
303     return totalSupply_;
304   }
305 
306   /**
307   * @dev transfer token for a specified address
308   * @param _to The address to transfer to.
309   * @param _value The amount to be transferred.
310   */
311   function transfer(address _to, uint256 _value) public returns (bool) {
312     require(_to != address(0));
313     require(_value <= balances[msg.sender]);
314 
315     balances[msg.sender] = balances[msg.sender].sub(_value);
316     balances[_to] = balances[_to].add(_value);
317     emit Transfer(msg.sender, _to, _value);
318     return true;
319   }
320 
321   /**
322   * @dev Gets the balance of the specified address.
323   * @param _owner The address to query the the balance of.
324   * @return An uint256 representing the amount owned by the passed address.
325   */
326   function balanceOf(address _owner) public view returns (uint256) {
327     return balances[_owner];
328   }
329 
330 }
331 
332 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
333 
334 /**
335  * @title Burnable Token
336  * @dev Token that can be irreversibly burned (destroyed).
337  */
338 contract BurnableToken is BasicToken {
339 
340   event Burn(address indexed burner, uint256 value);
341 
342   /**
343    * @dev Burns a specific amount of tokens.
344    * @param _value The amount of token to be burned.
345    */
346   function burn(uint256 _value) public {
347     _burn(msg.sender, _value);
348   }
349 
350   function _burn(address _who, uint256 _value) internal {
351     require(_value <= balances[_who]);
352     // no need to require value <= totalSupply, since that would imply the
353     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
354 
355     balances[_who] = balances[_who].sub(_value);
356     totalSupply_ = totalSupply_.sub(_value);
357     emit Burn(_who, _value);
358     emit Transfer(_who, address(0), _value);
359   }
360 }
361 
362 // File: contracts/ClarityToken.sol
363 
364 contract ClarityToken is BurnableToken, NoOwner {
365   string public constant name = "Clarity Token"; // solium-disable-line uppercase
366   string public constant symbol = "CLRTY"; // solium-disable-line uppercase
367   uint8 public constant decimals = 18; // solium-disable-line uppercase
368 
369   uint256 public constant INITIAL_SUPPLY = 240000000 * (10 ** uint256(decimals));
370 
371   /**
372    * @dev Constructor that gives msg.sender all of existing tokens.
373    */
374   constructor() public {
375     totalSupply_ = INITIAL_SUPPLY;
376     balances[msg.sender] = INITIAL_SUPPLY;
377     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
378   }
379 }