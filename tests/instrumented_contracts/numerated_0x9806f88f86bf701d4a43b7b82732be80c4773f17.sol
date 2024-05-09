1 pragma solidity ^0.4.24;
2 
3 // File: contracts/ERC20.sol
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 contract ERC20 {
10   function totalSupply() public view returns (uint256);
11 
12   function balanceOf(address _who) public view returns (uint256);
13 
14   function allowance(address _owner, address _spender)
15     public view returns (uint256);
16 
17   function transfer(address _to, uint256 _value) public returns (bool);
18 
19   function approve(address _spender, uint256 _value)
20     public returns (bool);
21 
22   function transferFrom(address _from, address _to, uint256 _value)
23     public returns (bool);
24 
25   function burn(uint256 _value)
26     public returns (bool);
27 
28   event Transfer(
29     address indexed from,
30     address indexed to,
31     uint256 value
32   );
33 
34   event Approval(
35     address indexed owner,
36     address indexed spender,
37     uint256 value
38   );
39 
40   event Burn(
41     address indexed burner,
42     uint256 value
43   );
44 
45 }
46 
47 // File: contracts/SafeMath.sol
48 
49 /**
50  * @title SafeMath
51  * @dev Math operations with safety checks that revert on error
52  */
53 library SafeMath {
54 
55   /**
56   * @dev Multiplies two numbers, reverts on overflow.
57   */
58   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
59     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
60     // benefit is lost if 'b' is also tested.
61     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
62     if (_a == 0) {
63       return 0;
64     }
65 
66     uint256 c = _a * _b;
67     require(c / _a == _b);
68 
69     return c;
70   }
71 
72   /**
73   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
74   */
75   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
76     require(_b > 0); // Solidity only automatically asserts when dividing by 0
77     uint256 c = _a / _b;
78     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
79 
80     return c;
81   }
82 
83   /**
84   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
85   */
86   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
87     require(_b <= _a);
88     uint256 c = _a - _b;
89 
90     return c;
91   }
92 
93   /**
94   * @dev Adds two numbers, reverts on overflow.
95   */
96   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
97     uint256 c = _a + _b;
98     require(c >= _a);
99 
100     return c;
101   }
102 
103   /**
104   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
105   * reverts when dividing by zero.
106   */
107   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
108     require(b != 0);
109     return a % b;
110   }
111 }
112 
113 // File: contracts/Ownable.sol
114 
115 /**
116  * @title Ownable
117  * @dev The Ownable contract has an owner address, and provides basic authorization control
118  * functions, this simplifies the implementation of "user permissions".
119  */
120 contract Ownable {
121   address public owner;
122 
123 
124   event OwnershipRenounced(address indexed previousOwner);
125   event OwnershipTransferred(
126     address indexed previousOwner,
127     address indexed newOwner
128   );
129 
130 
131   /**
132    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
133    * account.
134    */
135   constructor() public {
136     owner = msg.sender;
137   }
138 
139   /**
140    * @dev Throws if called by any account other than the owner.
141    */
142   modifier onlyOwner() {
143     require(msg.sender == owner);
144     _;
145   }
146 
147   /**
148    * @dev Allows the current owner to relinquish control of the contract.
149    * @notice Renouncing to ownership will leave the contract without an owner.
150    * It will not be possible to call the functions with the `onlyOwner`
151    * modifier anymore.
152    */
153   function renounceOwnership() public onlyOwner {
154     emit OwnershipRenounced(owner);
155     owner = address(0);
156   }
157 
158   /**
159    * @dev Allows the current owner to transfer control of the contract to a newOwner.
160    * @param _newOwner The address to transfer ownership to.
161    */
162   function transferOwnership(address _newOwner) public onlyOwner {
163     _transferOwnership(_newOwner);
164   }
165 
166   /**
167    * @dev Transfers control of the contract to a newOwner.
168    * @param _newOwner The address to transfer ownership to.
169    */
170   function _transferOwnership(address _newOwner) internal {
171     require(_newOwner != address(0));
172     emit OwnershipTransferred(owner, _newOwner);
173     owner = _newOwner;
174   }
175 }
176 
177 // File: contracts/LoligoToken.sol
178 
179 /**
180  * @title LoligoToken ERC20 token
181  *
182  * @dev Implementation of the basic standard token.
183  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
184  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
185  */
186 contract LoligoToken is ERC20, Ownable {
187   using SafeMath for uint256;
188 
189   string public constant name = "Loligo Token";
190   string public constant symbol = "LLG";
191   uint8 public constant decimals = 18;
192   uint256 private totalSupply_ = 16000000 * (10 ** uint256(decimals));
193   bool public locked = true;
194   mapping (address => uint256) private balances;
195 
196   mapping (address => mapping (address => uint256)) private allowed;
197 
198   modifier onlyWhenUnlocked() {
199     require(!locked || msg.sender == owner);
200     _;
201   }
202 
203   constructor() public {
204       balances[msg.sender] = totalSupply_;
205   }
206   /**
207   * @dev Total number of tokens in existence
208   */
209   function totalSupply() public view returns (uint256) {
210     return totalSupply_;
211   }
212 
213   /**
214   * @dev Gets the balance of the specified address.
215   * @param _owner The address to query the the balance of.
216   * @return An uint256 representing the amount owned by the passed address.
217   */
218   function balanceOf(address _owner) public view returns (uint256) {
219     return balances[_owner];
220   }
221 
222   /**
223    * @dev Function to check the amount of tokens that an owner allowed to a spender.
224    * @param _owner address The address which owns the funds.
225    * @param _spender address The address which will spend the funds.
226    * @return A uint256 specifying the amount of tokens still available for the spender.
227    */
228   function allowance(
229     address _owner,
230     address _spender
231    )
232     public
233     view
234     returns (uint256)
235   {
236     return allowed[_owner][_spender];
237   }
238 
239   /**
240   * @dev Transfer token for a specified address
241   * @param _to The address to transfer to.
242   * @param _value The amount to be transferred.
243   */
244   function transfer(address _to, uint256 _value) public onlyWhenUnlocked returns (bool) {
245     require(_value <= balances[msg.sender]);
246     require(_to != address(0));
247 
248     balances[msg.sender] = balances[msg.sender].sub(_value);
249     balances[_to] = balances[_to].add(_value);
250     emit Transfer(msg.sender, _to, _value);
251     return true;
252   }
253 
254   /**
255    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
256    * Beware that changing an allowance with this method brings the risk that someone may use both the old
257    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
258    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
259    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
260    * @param _spender The address which will spend the funds.
261    * @param _value The amount of tokens to be spent.
262    */
263   function approve(address _spender, uint256 _value) public returns (bool) {
264     allowed[msg.sender][_spender] = _value;
265     emit Approval(msg.sender, _spender, _value);
266     return true;
267   }
268 
269   /**
270    * @dev Transfer tokens from one address to another
271    * @param _from address The address which you want to send tokens from
272    * @param _to address The address which you want to transfer to
273    * @param _value uint256 the amount of tokens to be transferred
274    */
275   function transferFrom(
276     address _from,
277     address _to,
278     uint256 _value
279   )
280     public
281     onlyWhenUnlocked
282     returns (bool)
283   {
284     require(_value <= balances[_from]);
285     require(_value <= allowed[_from][msg.sender]);
286     require(_to != address(0));
287 
288     balances[_from] = balances[_from].sub(_value);
289     balances[_to] = balances[_to].add(_value);
290     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
291     emit Transfer(_from, _to, _value);
292     return true;
293   }
294 
295   /**
296    * @dev Increase the amount of tokens that an owner allowed to a spender.
297    * approve should be called when allowed[_spender] == 0. To increment
298    * allowed value is better to use this function to avoid 2 calls (and wait until
299    * the first transaction is mined)
300    * From MonolithDAO Token.sol
301    * @param _spender The address which will spend the funds.
302    * @param _addedValue The amount of tokens to increase the allowance by.
303    */
304   function increaseApproval(
305     address _spender,
306     uint256 _addedValue
307   )
308     public
309     returns (bool)
310   {
311     allowed[msg.sender][_spender] = (
312       allowed[msg.sender][_spender].add(_addedValue));
313     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
314     return true;
315   }
316 
317   /**
318    * @dev Decrease the amount of tokens that an owner allowed to a spender.
319    * approve should be called when allowed[_spender] == 0. To decrement
320    * allowed value is better to use this function to avoid 2 calls (and wait until
321    * the first transaction is mined)
322    * From MonolithDAO Token.sol
323    * @param _spender The address which will spend the funds.
324    * @param _subtractedValue The amount of tokens to decrease the allowance by.
325    */
326   function decreaseApproval(
327     address _spender,
328     uint256 _subtractedValue
329   )
330     public
331     returns (bool)
332   {
333     uint256 oldValue = allowed[msg.sender][_spender];
334     if (_subtractedValue >= oldValue) {
335       allowed[msg.sender][_spender] = 0;
336     } else {
337       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
338     }
339     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
340     return true;
341   }
342 
343   function burn(uint256 _value) public returns (bool success){
344     require(_value > 0);
345     require(_value <= balances[msg.sender]);
346     address burner = msg.sender;
347     balances[burner] = balances[burner].sub(_value);
348     totalSupply_ = totalSupply_.sub(_value);
349     emit Burn(burner, _value);
350     return true;
351   }
352 
353   function unlock() public onlyOwner {
354     locked = false;
355   }
356 
357   function lock() public onlyOwner {
358     require(!locked);
359     locked = true;
360   }
361 }