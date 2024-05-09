1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that revert on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, reverts on overflow.
12   */
13   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
14     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (_a == 0) {
18       return 0;
19     }
20 
21     uint256 c = _a * _b;
22     require(c / _a == _b);
23 
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     require(_b > 0); // Solidity only automatically asserts when dividing by 0
32     uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34 
35     return c;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
42     require(_b <= _a);
43     uint256 c = _a - _b;
44 
45     return c;
46   }
47 
48   /**
49   * @dev Adds two numbers, reverts on overflow.
50   */
51   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
52     uint256 c = _a + _b;
53     require(c >= _a);
54 
55     return c;
56   }
57 
58   /**
59   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
60   * reverts when dividing by zero.
61   */
62   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b != 0);
64     return a % b;
65   }
66 }
67 
68 
69 /**
70  * @title Ownable
71  * @dev The Ownable contract has an owner address, and provides basic authorization control
72  * functions, this simplifies the implementation of "user permissions".
73  */
74 contract Ownable {
75   address public owner;
76 
77 
78   event OwnershipRenounced(address indexed previousOwner);
79   event OwnershipTransferred(
80     address indexed previousOwner,
81     address indexed newOwner
82   );
83 
84 
85   /**
86    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
87    * account.
88    */
89   constructor() public {
90     owner = msg.sender;
91   }
92 
93   /**
94    * @dev Throws if called by any account other than the owner.
95    */
96   modifier onlyOwner() {
97     require(msg.sender == owner);
98     _;
99   }
100 
101   /**
102    * @dev Allows the current owner to relinquish control of the contract.
103    * @notice Renouncing to ownership will leave the contract without an owner.
104    * It will not be possible to call the functions with the `onlyOwner`
105    * modifier anymore.
106    */
107   function renounceOwnership() public onlyOwner {
108     emit OwnershipRenounced(owner);
109     owner = address(0);
110   }
111 
112   /**
113    * @dev Allows the current owner to transfer control of the contract to a newOwner.
114    * @param _newOwner The address to transfer ownership to.
115    */
116   function transferOwnership(address _newOwner) public onlyOwner {
117     _transferOwnership(_newOwner);
118   }
119 
120   /**
121    * @dev Transfers control of the contract to a newOwner.
122    * @param _newOwner The address to transfer ownership to.
123    */
124   function _transferOwnership(address _newOwner) internal {
125     require(_newOwner != address(0));
126     emit OwnershipTransferred(owner, _newOwner);
127     owner = _newOwner;
128   }
129 }
130 
131 
132 
133 /**
134  * @title ERC20 interface
135  * @dev see https://github.com/ethereum/EIPs/issues/20
136  */
137 contract ERC20 {
138   function totalSupply() public view returns (uint256);
139 
140   function balanceOf(address _who) public view returns (uint256);
141 
142   function allowance(address _owner, address _spender)
143     public view returns (uint256);
144 
145   function transfer(address _to, uint256 _value) public returns (bool);
146 
147   function approve(address _spender, uint256 _value)
148     public returns (bool);
149 
150   function transferFrom(address _from, address _to, uint256 _value)
151     public returns (bool);
152 
153   event Transfer(
154     address indexed from,
155     address indexed to,
156     uint256 value
157   );
158 
159   event Approval(
160     address indexed owner,
161     address indexed spender,
162     uint256 value
163   );
164 }
165 
166 
167 /**
168  * @title Standard ERC20 token
169  *
170  * @dev Implementation of the basic standard token.
171  * https://github.com/ethereum/EIPs/issues/20
172  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
173  */
174 contract StandardToken is ERC20 {
175   using SafeMath for uint256;
176 
177   mapping(address => uint256) balances;
178 
179   mapping (address => mapping (address => uint256)) internal allowed;
180 
181   uint256 totalSupply_;
182 
183   /**
184   * @dev Total number of tokens in existence
185   */
186   function totalSupply() public view returns (uint256) {
187     return totalSupply_;
188   }
189 
190   /**
191   * @dev Gets the balance of the specified address.
192   * @param _owner The address to query the the balance of.
193   * @return An uint256 representing the amount owned by the passed address.
194   */
195   function balanceOf(address _owner) public view returns (uint256) {
196     return balances[_owner];
197   }
198 
199   /**
200    * @dev Function to check the amount of tokens that an owner allowed to a spender.
201    * @param _owner address The address which owns the funds.
202    * @param _spender address The address which will spend the funds.
203    * @return A uint256 specifying the amount of tokens still available for the spender.
204    */
205   function allowance(
206     address _owner,
207     address _spender
208    )
209     public
210     view
211     returns (uint256)
212   {
213     return allowed[_owner][_spender];
214   }
215 
216   /**
217   * @dev Transfer token for a specified address
218   * @param _to The address to transfer to.
219   * @param _value The amount to be transferred.
220   */
221   function transfer(address _to, uint256 _value) public returns (bool) {
222     require(_value <= balances[msg.sender]);
223     require(_to != address(0));
224 
225     balances[msg.sender] = balances[msg.sender].sub(_value);
226     balances[_to] = balances[_to].add(_value);
227     emit Transfer(msg.sender, _to, _value);
228     return true;
229   }
230 
231   /**
232    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
233    * Beware that changing an allowance with this method brings the risk that someone may use both the old
234    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
235    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
236    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
237    * @param _spender The address which will spend the funds.
238    * @param _value The amount of tokens to be spent.
239    */
240   function approve(address _spender, uint256 _value) public returns (bool) {
241     allowed[msg.sender][_spender] = _value;
242     emit Approval(msg.sender, _spender, _value);
243     return true;
244   }
245 
246   /**
247    * @dev Transfer tokens from one address to another
248    * @param _from address The address which you want to send tokens from
249    * @param _to address The address which you want to transfer to
250    * @param _value uint256 the amount of tokens to be transferred
251    */
252   function transferFrom(
253     address _from,
254     address _to,
255     uint256 _value
256   )
257     public
258     returns (bool)
259   {
260     require(_value <= balances[_from]);
261     require(_value <= allowed[_from][msg.sender]);
262     require(_to != address(0));
263 
264     balances[_from] = balances[_from].sub(_value);
265     balances[_to] = balances[_to].add(_value);
266     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
267     emit Transfer(_from, _to, _value);
268     return true;
269   }
270 
271   /**
272    * @dev Increase the amount of tokens that an owner allowed to a spender.
273    * approve should be called when allowed[_spender] == 0. To increment
274    * allowed value is better to use this function to avoid 2 calls (and wait until
275    * the first transaction is mined)
276    * From MonolithDAO Token.sol
277    * @param _spender The address which will spend the funds.
278    * @param _addedValue The amount of tokens to increase the allowance by.
279    */
280   function increaseApproval(
281     address _spender,
282     uint256 _addedValue
283   )
284     public
285     returns (bool)
286   {
287     allowed[msg.sender][_spender] = (
288       allowed[msg.sender][_spender].add(_addedValue));
289     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
290     return true;
291   }
292 
293   /**
294    * @dev Decrease the amount of tokens that an owner allowed to a spender.
295    * approve should be called when allowed[_spender] == 0. To decrement
296    * allowed value is better to use this function to avoid 2 calls (and wait until
297    * the first transaction is mined)
298    * From MonolithDAO Token.sol
299    * @param _spender The address which will spend the funds.
300    * @param _subtractedValue The amount of tokens to decrease the allowance by.
301    */
302   function decreaseApproval(
303     address _spender,
304     uint256 _subtractedValue
305   )
306     public
307     returns (bool)
308   {
309     uint256 oldValue = allowed[msg.sender][_spender];
310     if (_subtractedValue >= oldValue) {
311       allowed[msg.sender][_spender] = 0;
312     } else {
313       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
314     }
315     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
316     return true;
317   }
318 
319 }
320 
321 
322 /**
323  * @title DetailedERC20 token
324  * @dev The decimals are only for visualization purposes.
325  * All the operations are done using the smallest and indivisible token unit,
326  * just as on Ethereum all the operations are done in wei.
327  */
328 contract DetailedERC20 is ERC20 {
329   string public name;
330   string public symbol;
331   uint8 public decimals;
332 
333   constructor(string _name, string _symbol, uint8 _decimals) public {
334     name = _name;
335     symbol = _symbol;
336     decimals = _decimals;
337   }
338 }
339 
340 
341 /**
342  * @title Mintable token
343  * @dev Simple ERC20 Token example, with mintable token creation
344  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
345  */
346 contract MintableToken is StandardToken, Ownable {
347   event Mint(address indexed to, uint256 amount);
348   event MintFinished();
349 
350   bool public mintingFinished = false;
351 
352 
353   modifier canMint() {
354     require(!mintingFinished);
355     _;
356   }
357 
358   modifier hasMintPermission() {
359     require(msg.sender == owner);
360     _;
361   }
362 
363   /**
364    * @dev Function to mint tokens
365    * @param _to The address that will receive the minted tokens.
366    * @param _amount The amount of tokens to mint.
367    * @return A boolean that indicates if the operation was successful.
368    */
369   function mint(
370     address _to,
371     uint256 _amount
372   )
373     public
374     hasMintPermission
375     canMint
376     returns (bool)
377   {
378     totalSupply_ = totalSupply_.add(_amount);
379     balances[_to] = balances[_to].add(_amount);
380     emit Mint(_to, _amount);
381     emit Transfer(address(0), _to, _amount);
382     return true;
383   }
384 
385   /**
386    * @dev Function to stop minting new tokens.
387    * @return True if the operation was successful.
388    */
389   function finishMinting() public onlyOwner canMint returns (bool) {
390     mintingFinished = true;
391     emit MintFinished();
392     return true;
393   }
394 }
395 
396 
397 contract ACCOToken is MintableToken, DetailedERC20 {
398   constructor(string _name, string _symbol, uint8 _decimals) 
399     DetailedERC20(_name, _symbol, _decimals) 
400     public {}
401 }