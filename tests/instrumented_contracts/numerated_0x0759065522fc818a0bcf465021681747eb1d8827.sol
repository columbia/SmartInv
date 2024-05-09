1 pragma solidity ^0.4.24;
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
37     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
38     // benefit is lost if 'b' is also tested.
39     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
40     if (a == 0) {
41       return 0;
42     }
43 
44     c = a * b;
45     assert(c / a == b);
46     return c;
47   }
48 
49   /**
50   * @dev Integer division of two numbers, truncating the quotient.
51   */
52   function div(uint256 a, uint256 b) internal pure returns (uint256) {
53     // assert(b > 0); // Solidity automatically throws when dividing by 0
54     // uint256 c = a / b;
55     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56     return a / b;
57   }
58 
59   /**
60   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
61   */
62   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63     assert(b <= a);
64     return a - b;
65   }
66 
67   /**
68   * @dev Adds two numbers, throws on overflow.
69   */
70   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
71     c = a + b;
72     assert(c >= a);
73     return c;
74   }
75 }
76 
77 
78 /**
79  * Utility library of inline functions on addresses
80  */
81 library AddressUtils {
82 
83   /**
84    * Returns whether the target address is a contract
85    * @dev This function will return false if invoked during the constructor of a contract,
86    * as the code is not actually created until after the constructor finishes.
87    * @param addr address to check
88    * @return whether the target address is a contract
89    */
90   function isContract(address addr) internal view returns (bool) {
91     uint256 size;
92     // XXX Currently there is no better way to check if there is a contract in an address
93     // than to check the size of the code at that address.
94     // See https://ethereum.stackexchange.com/a/14016/36603
95     // for more details about how this works.
96     // TODO Check this again before the Serenity release, because all addresses will be
97     // contracts then.
98     // solium-disable-next-line security/no-inline-assembly
99     assembly { size := extcodesize(addr) }
100     return size > 0;
101   }
102 }
103 
104 
105 /**
106  * @title Ownable
107  * @dev The Ownable contract has an owner address, and provides basic authorization control
108  * functions, this simplifies the implementation of "user permissions".
109  */
110 contract Ownable {
111   address public owner;
112 
113 
114   event OwnershipRenounced(address indexed previousOwner);
115   event OwnershipTransferred(
116     address indexed previousOwner,
117     address indexed newOwner
118   );
119 
120 
121   /**
122    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
123    * account.
124    */
125   constructor() public {
126     owner = msg.sender;
127   }
128 
129   /**
130    * @dev Throws if called by any account other than the owner.
131    */
132   modifier onlyOwner() {
133     require(msg.sender == owner);
134     _;
135   }
136 
137   /**
138    * @dev Allows the current owner to relinquish control of the contract.
139    * @notice Renouncing to ownership will leave the contract without an owner.
140    * It will not be possible to call the functions with the `onlyOwner`
141    * modifier anymore.
142    */
143   function renounceOwnership() public onlyOwner {
144     emit OwnershipRenounced(owner);
145     owner = address(0);
146   }
147 
148   /**
149    * @dev Allows the current owner to transfer control of the contract to a newOwner.
150    * @param _newOwner The address to transfer ownership to.
151    */
152   function transferOwnership(address _newOwner) public onlyOwner {
153     _transferOwnership(_newOwner);
154   }
155 
156   /**
157    * @dev Transfers control of the contract to a newOwner.
158    * @param _newOwner The address to transfer ownership to.
159    */
160   function _transferOwnership(address _newOwner) internal {
161     require(_newOwner != address(0));
162     emit OwnershipTransferred(owner, _newOwner);
163     owner = _newOwner;
164   }
165 }
166 
167 
168 /**
169  * @title ERC20Basic
170  * @dev Simpler version of ERC20 interface
171  * See https://github.com/ethereum/EIPs/issues/179
172  */
173 contract ERC20Basic {
174   function totalSupply() public view returns (uint256);
175   function balanceOf(address who) public view returns (uint256);
176   function transfer(address to, uint256 value) public returns (bool);
177   event Transfer(address indexed from, address indexed to, uint256 value);
178 }
179 
180 
181 /**
182  * @title ERC20 interface
183  * @dev see https://github.com/ethereum/EIPs/issues/20
184  */
185 contract ERC20 is ERC20Basic {
186 
187   function allowance(address owner, address spender) public view returns (uint256);
188 
189   function transferFrom(address from, address to, uint256 value) public returns (bool);
190 
191   function approve(address spender, uint256 value) public returns (bool);
192 
193   event Approval(address indexed owner,address indexed spender,uint256 value);
194 }
195 
196 
197 /**
198  * @title Basic token
199  * @dev Basic version of StandardToken, with no allowances.
200  */
201 contract BasicToken is ERC20Basic {
202   using SafeMath for uint256;
203 
204   mapping(address => uint256) balances;
205 
206   uint256 totalSupply_;
207 
208   /**
209   * @dev Total number of tokens in existence
210   */
211   function totalSupply() public view returns (uint256) {
212     return totalSupply_;
213   }
214 
215   /**
216   * @dev Transfer token for a specified address
217   * @param _to The address to transfer to.
218   * @param _value The amount to be transferred.
219   */
220   function transfer(address _to, uint256 _value) public returns (bool) {
221     require(_to != address(0));
222     require(_value <= balances[msg.sender]);
223 
224     balances[msg.sender] = balances[msg.sender].sub(_value);
225     balances[_to] = balances[_to].add(_value);
226     emit Transfer(msg.sender, _to, _value);
227     return true;
228   }
229 
230   /**
231   * @dev Gets the balance of the specified address.
232   * @param _owner The address to query the the balance of.
233   * @return An uint256 representing the amount owned by the passed address.
234   */
235   function balanceOf(address _owner) public view returns (uint256) {
236     return balances[_owner];
237   }
238 
239 }
240 
241 
242 /**
243  * @title SafeERC20
244  * @dev Wrappers around ERC20 operations that throw on failure.
245  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
246  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
247  */
248 library SafeERC20 {
249   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
250     require(token.transfer(to, value));
251   }
252 
253   function safeTransferFrom(ERC20 token,address from,address to,uint256 value) internal{
254     require(token.transferFrom(from, to, value));
255   }
256 
257   function safeApprove(ERC20 token, address spender, uint256 value) internal {
258     require(token.approve(spender, value));
259   }
260 }
261 
262 
263 /**
264  * @title Standard ERC20 token
265  *
266  * @dev Implementation of the basic standard token.
267  * https://github.com/ethereum/EIPs/issues/20
268  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
269  */
270 contract StandardToken is ERC20, BasicToken,Ownable {
271 
272   mapping (address => mapping (address => uint256)) internal allowed;
273 
274 
275   /**
276    * @dev Transfer tokens from one address to another
277    * @param _from address The address which you want to send tokens from
278    * @param _to address The address which you want to transfer to
279    * @param _value uint256 the amount of tokens to be transferred
280    */
281   function transferFrom(address _from,address _to,uint256 _value) public returns (bool)
282   {
283     require(_to != address(0));
284     require(_value <= balances[_from]);
285     require(_value <= allowed[_from][msg.sender]);
286 
287     balances[_from] = balances[_from].sub(_value);
288     balances[_to] = balances[_to].add(_value);
289     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
290     emit Transfer(_from, _to, _value);
291     return true;
292   }
293 
294   /**
295    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
296    * Beware that changing an allowance with this method brings the risk that someone may use both the old
297    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
298    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
299    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
300    * @param _spender The address which will spend the funds.
301    * @param _value The amount of tokens to be spent.
302    */
303   function approve(address _spender, uint256 _value) public returns (bool) {
304     allowed[msg.sender][_spender] = _value;
305     emit Approval(msg.sender, _spender, _value);
306     return true;
307   }
308 
309   /**
310    * @dev Function to check the amount of tokens that an owner allowed to a spender.
311    * @param _owner address The address which owns the funds.
312    * @param _spender address The address which will spend the funds.
313    * @return A uint256 specifying the amount of tokens still available for the spender.
314    */
315   function allowance(address _owner, address _spender) public view returns (uint256){
316     return allowed[_owner][_spender];
317   }
318 
319   /**
320    * @dev Increase the amount of tokens that an owner allowed to a spender.
321    * approve should be called when allowed[_spender] == 0. To increment
322    * allowed value is better to use this function to avoid 2 calls (and wait until
323    * the first transaction is mined)
324    * From MonolithDAO Token.sol
325    * @param _spender The address which will spend the funds.
326    * @param _addedValue The amount of tokens to increase the allowance by.
327    */
328   function increaseApproval(address _spender,uint256 _addedValue) public returns (bool){
329     allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
330     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
331     return true;
332   }
333 
334   /**
335    * @dev Decrease the amount of tokens that an owner allowed to a spender.
336    * approve should be called when allowed[_spender] == 0. To decrement
337    * allowed value is better to use this function to avoid 2 calls (and wait until
338    * the first transaction is mined)
339    * From MonolithDAO Token.sol
340    * @param _spender The address which will spend the funds.
341    * @param _subtractedValue The amount of tokens to decrease the allowance by.
342    */
343   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool){
344     uint256 oldValue = allowed[msg.sender][_spender];
345     if (_subtractedValue > oldValue) {
346       allowed[msg.sender][_spender] = 0;
347     } else {
348       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
349     }
350     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
351     return true;
352   }
353 
354 }
355 
356 
357 /**
358  * @title UniHashToken
359  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
360  * Note they can later distribute these tokens as they wish using `transfer` and other
361  * `StandardToken` functions.
362  */
363 contract UniHashToken is StandardToken {
364 
365   string public constant name = "UniHashToken"; // solium-disable-line uppercase
366   string public constant symbol = "UHT"; // solium-disable-line uppercase
367   uint8 public constant decimals = 6; // solium-disable-line uppercase
368 
369   uint256 public constant INITIAL_SUPPLY = 5100000000 * (10 ** uint256(decimals));
370 
371   /**
372    * @dev Constructor that gives msg.sender all of existing tokens.
373    */
374   constructor() public {
375     totalSupply_ = INITIAL_SUPPLY;
376     balances[msg.sender] = INITIAL_SUPPLY;
377     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
378   }
379 
380 }