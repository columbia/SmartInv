1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title Math
6  * @dev Assorted math operations
7  */
8 library Math {
9   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
10     return a >= b ? a : b;
11   }
12 
13   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
14     return a < b ? a : b;
15   }
16 
17   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
18     return a >= b ? a : b;
19   }
20 
21   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
22     return a < b ? a : b;
23   }
24 }
25 
26 
27 /**
28  * @title SafeMath
29  * @dev Math operations with safety checks that throw on error
30  */
31 library SafeMath {
32 
33   /**
34   * @dev Multiplies two numbers, throws on overflow.
35   */
36   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
37     if (a == 0) {
38       return 0;
39     }
40     c = a * b;
41     assert(c / a == b);
42     return c;
43   }
44 
45   /**
46   * @dev Integer division of two numbers, truncating the quotient.
47   */
48   function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     // assert(b > 0); // Solidity automatically throws when dividing by 0
50     // uint256 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52     return a / b;
53   }
54 
55   /**
56   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
57   */
58   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   /**
64   * @dev Adds two numbers, throws on overflow.
65   */
66   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
67     c = a + b;
68     assert(c >= a);
69     return c;
70   }
71 }
72 
73 
74 /**
75  * @title Ownable
76  * @dev The Ownable contract has an owner address, and provides basic authorization control
77  * functions, this simplifies the implementation of "user permissions".
78  */
79 contract Ownable {
80   address public owner;
81 
82 
83   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
84 
85 
86   /**
87    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
88    * account.
89    */
90   function Ownable() public {
91     owner = msg.sender;
92   }
93 
94   /**
95    * @dev Throws if called by any account other than the owner.
96    */
97   modifier onlyOwner() {
98     require(msg.sender == owner);
99     _;
100   }
101 
102   /**
103    * @dev Allows the current owner to transfer control of the contract to a newOwner.
104    * @param newOwner The address to transfer ownership to.
105    */
106   function transferOwnership(address newOwner) public onlyOwner {
107     require(newOwner != address(0));
108     emit OwnershipTransferred(owner, newOwner);
109     owner = newOwner;
110   }
111 
112 }
113 
114 
115 
116 /**
117  * @title Contracts that should be able to recover tokens
118  * @author SylTi
119  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
120  * This will prevent any accidental loss of tokens.
121  */
122 contract CanReclaimToken is Ownable {
123   using SafeERC20 for ERC20Basic;
124 
125   /**
126    * @dev Reclaim all ERC20Basic compatible tokens
127    * @param token ERC20Basic The address of the token contract
128    */
129   function reclaimToken(ERC20Basic token) external onlyOwner {
130     uint256 balance = token.balanceOf(this);
131     token.safeTransfer(owner, balance);
132   }
133 
134 }
135 
136 
137 
138 /**
139  * @title Contracts that should not own Contracts
140  * @author Remco Bloemen <remco@2π.com>
141  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
142  * of this contract to reclaim ownership of the contracts.
143  */
144 contract HasNoContracts is Ownable {
145 
146   /**
147    * @dev Reclaim ownership of Ownable contracts
148    * @param contractAddr The address of the Ownable to be reclaimed.
149    */
150   function reclaimContract(address contractAddr) external onlyOwner {
151     Ownable contractInst = Ownable(contractAddr);
152     contractInst.transferOwnership(owner);
153   }
154 }
155 
156 
157 
158 /**
159  * @title Contracts that should not own Tokens
160  * @author Remco Bloemen <remco@2π.com>
161  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
162  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
163  * owner to reclaim the tokens.
164  */
165 contract HasNoTokens is CanReclaimToken {
166 
167  /**
168   * @dev Reject all ERC223 compatible tokens
169   * @param from_ address The address that is transferring the tokens
170   * @param value_ uint256 the amount of the specified token
171   * @param data_ Bytes The data passed from the caller.
172   */
173   function tokenFallback(address from_, uint256 value_, bytes data_) external {
174     from_;
175     value_;
176     data_;
177     revert();
178   }
179 
180 }
181 
182 
183 /**
184  * @title ERC20Basic
185  * @dev Simpler version of ERC20 interface
186  * @dev see https://github.com/ethereum/EIPs/issues/179
187  */
188 contract ERC20Basic {
189   function totalSupply() public view returns (uint256);
190   function balanceOf(address who) public view returns (uint256);
191   function transfer(address to, uint256 value) public returns (bool);
192   event Transfer(address indexed from, address indexed to, uint256 value);
193 }
194 
195 
196 
197 /**
198  * @title ERC20 interface
199  * @dev see https://github.com/ethereum/EIPs/issues/20
200  */
201 contract ERC20 is ERC20Basic {
202   function allowance(address owner, address spender) public view returns (uint256);
203   function transferFrom(address from, address to, uint256 value) public returns (bool);
204   function approve(address spender, uint256 value) public returns (bool);
205   event Approval(address indexed owner, address indexed spender, uint256 value);
206 }
207 
208 
209 
210 
211 /**
212  * @title Basic token
213  * @dev Basic version of StandardToken, with no allowances.
214  */
215 contract BasicToken is ERC20Basic {
216   using SafeMath for uint256;
217 
218   mapping(address => uint256) balances;
219 
220   uint256 totalSupply_;
221 
222   /**
223   * @dev total number of tokens in existence
224   */
225   function totalSupply() public view returns (uint256) {
226     return totalSupply_;
227   }
228 
229   /**
230   * @dev transfer token for a specified address
231   * @param _to The address to transfer to.
232   * @param _value The amount to be transferred.
233   */
234   function transfer(address _to, uint256 _value) public returns (bool) {
235     require(_to != address(0));
236     require(_value <= balances[msg.sender]);
237 
238     balances[msg.sender] = balances[msg.sender].sub(_value);
239     balances[_to] = balances[_to].add(_value);
240     emit Transfer(msg.sender, _to, _value);
241     return true;
242   }
243 
244   /**
245   * @dev Gets the balance of the specified address.
246   * @param _owner The address to query the the balance of.
247   * @return An uint256 representing the amount owned by the passed address.
248   */
249   function balanceOf(address _owner) public view returns (uint256) {
250     return balances[_owner];
251   }
252 
253 }
254 
255 
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
283     emit Transfer(_from, _to, _value);
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
299     emit Approval(msg.sender, _spender, _value);
300     return true;
301   }
302 
303   /**
304    * @dev Function to check the amount of tokens that an owner allowed to a spender.
305    * @param _owner address The address which owns the funds.
306    * @param _spender address The address which will spend the funds.
307    * @return A uint256 specifying the amount of tokens still available for the spender.
308    */
309   function allowance(address _owner, address _spender) public view returns (uint256) {
310     return allowed[_owner][_spender];
311   }
312 
313   /**
314    * @dev Increase the amount of tokens that an owner allowed to a spender.
315    *
316    * approve should be called when allowed[_spender] == 0. To increment
317    * allowed value is better to use this function to avoid 2 calls (and wait until
318    * the first transaction is mined)
319    * From MonolithDAO Token.sol
320    * @param _spender The address which will spend the funds.
321    * @param _addedValue The amount of tokens to increase the allowance by.
322    */
323   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
324     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
325     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
326     return true;
327   }
328 
329   /**
330    * @dev Decrease the amount of tokens that an owner allowed to a spender.
331    *
332    * approve should be called when allowed[_spender] == 0. To decrement
333    * allowed value is better to use this function to avoid 2 calls (and wait until
334    * the first transaction is mined)
335    * From MonolithDAO Token.sol
336    * @param _spender The address which will spend the funds.
337    * @param _subtractedValue The amount of tokens to decrease the allowance by.
338    */
339   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
340     uint oldValue = allowed[msg.sender][_spender];
341     if (_subtractedValue > oldValue) {
342       allowed[msg.sender][_spender] = 0;
343     } else {
344       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
345     }
346     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
347     return true;
348   }
349 
350 }
351 
352 
353 
354 /**
355  * @title SafeERC20
356  * @dev Wrappers around ERC20 operations that throw on failure.
357  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
358  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
359  */
360 library SafeERC20 {
361   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
362     assert(token.transfer(to, value));
363   }
364 
365   function safeTransferFrom(
366     ERC20 token,
367     address from,
368     address to,
369     uint256 value
370   )
371     internal
372   {
373     assert(token.transferFrom(from, to, value));
374   }
375 
376   function safeApprove(ERC20 token, address spender, uint256 value) internal {
377     assert(token.approve(spender, value));
378   }
379 }
380 
381 
382 contract DULACoin is HasNoTokens, HasNoContracts, StandardToken {
383     // solhint-disable const-name-snakecase
384     string public constant name = "DULA Coin";
385     string public constant symbol = "DULA";
386     uint8 public constant decimals = 18;
387     // solhint-enable const-name-snakecase
388 
389     // Total supply of the DULA Coin.
390     uint256 public constant TOTAL_SUPPLY = 10 * 10 ** 9 * 10 ** uint256(decimals); // 10B
391 
392     constructor(address _distributor) public {
393         require(_distributor != address(0), "Distributor address must not be 0!");
394 
395         totalSupply_ = totalSupply_.add(TOTAL_SUPPLY);
396         balances[_distributor] = balances[_distributor].add(TOTAL_SUPPLY);
397         emit Transfer(address(0), _distributor, TOTAL_SUPPLY);
398     }
399 }