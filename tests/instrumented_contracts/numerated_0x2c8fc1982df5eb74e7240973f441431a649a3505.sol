1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipRenounced(address indexed previousOwner);
8   event OwnershipTransferred(
9     address indexed previousOwner,
10     address indexed newOwner
11   );
12 
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   constructor() public {
19     owner = msg.sender;
20   }
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30   /**
31    * @dev Allows the current owner to relinquish control of the contract.
32    * @notice Renouncing to ownership will leave the contract without an owner.
33    * It will not be possible to call the functions with the `onlyOwner`
34    * modifier anymore.
35    */
36   function renounceOwnership() public onlyOwner {
37     emit OwnershipRenounced(owner);
38     owner = address(0);
39   }
40 
41   /**
42    * @dev Allows the current owner to transfer control of the contract to a newOwner.
43    * @param _newOwner The address to transfer ownership to.
44    */
45   function transferOwnership(address _newOwner) public onlyOwner {
46     _transferOwnership(_newOwner);
47   }
48 
49   /**
50    * @dev Transfers control of the contract to a newOwner.
51    * @param _newOwner The address to transfer ownership to.
52    */
53   function _transferOwnership(address _newOwner) internal {
54     require(_newOwner != address(0));
55     emit OwnershipTransferred(owner, _newOwner);
56     owner = _newOwner;
57   }
58 }
59 
60 library SafeMath {
61 
62   /**
63   * @dev Multiplies two numbers, reverts on overflow.
64   */
65   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
66     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
67     // benefit is lost if 'b' is also tested.
68     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
69     if (_a == 0) {
70       return 0;
71     }
72 
73     uint256 c = _a * _b;
74     require(c / _a == _b);
75 
76     return c;
77   }
78 
79   /**
80   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
81   */
82   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
83     require(_b > 0); // Solidity only automatically asserts when dividing by 0
84     uint256 c = _a / _b;
85     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
86 
87     return c;
88   }
89 
90   /**
91   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
92   */
93   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
94     require(_b <= _a);
95     uint256 c = _a - _b;
96 
97     return c;
98   }
99 
100   /**
101   * @dev Adds two numbers, reverts on overflow.
102   */
103   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
104     uint256 c = _a + _b;
105     require(c >= _a);
106 
107     return c;
108   }
109 
110   /**
111   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
112   * reverts when dividing by zero.
113   */
114   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
115     require(b != 0);
116     return a % b;
117   }
118 }
119 
120 contract ERC20 {
121   function totalSupply() public view returns (uint256);
122 
123   function balanceOf(address _who) public view returns (uint256);
124 
125   function allowance(address _owner, address _spender)
126     public view returns (uint256);
127 
128   function transfer(address _to, uint256 _value) public returns (bool);
129 
130   function approve(address _spender, uint256 _value)
131     public returns (bool);
132 
133   function transferFrom(address _from, address _to, uint256 _value)
134     public returns (bool);
135 
136   event Transfer(
137     address indexed from,
138     address indexed to,
139     uint256 value
140   );
141 
142   event Approval(
143     address indexed owner,
144     address indexed spender,
145     uint256 value
146   );
147 }
148 
149 contract StandardToken is ERC20 {
150   using SafeMath for uint256;
151 
152   mapping (address => uint256) private balances;
153 
154   mapping (address => mapping (address => uint256)) private allowed;
155 
156   uint256 private totalSupply_;
157 
158   /**
159   * @dev Total number of tokens in existence
160   */
161   function totalSupply() public view returns (uint256) {
162     return totalSupply_;
163   }
164 
165   /**
166   * @dev Gets the balance of the specified address.
167   * @param _owner The address to query the the balance of.
168   * @return An uint256 representing the amount owned by the passed address.
169   */
170   function balanceOf(address _owner) public view returns (uint256) {
171     return balances[_owner];
172   }
173 
174   /**
175    * @dev Function to check the amount of tokens that an owner allowed to a spender.
176    * @param _owner address The address which owns the funds.
177    * @param _spender address The address which will spend the funds.
178    * @return A uint256 specifying the amount of tokens still available for the spender.
179    */
180   function allowance(
181     address _owner,
182     address _spender
183    )
184     public
185     view
186     returns (uint256)
187   {
188     return allowed[_owner][_spender];
189   }
190 
191   /**
192   * @dev Transfer token for a specified address
193   * @param _to The address to transfer to.
194   * @param _value The amount to be transferred.
195   */
196   function transfer(address _to, uint256 _value) public returns (bool) {
197     require(_value <= balances[msg.sender]);
198     require(_to != address(0));
199 
200     balances[msg.sender] = balances[msg.sender].sub(_value);
201     balances[_to] = balances[_to].add(_value);
202     emit Transfer(msg.sender, _to, _value);
203     return true;
204   }
205 
206   /**
207    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
208    * Beware that changing an allowance with this method brings the risk that someone may use both the old
209    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
210    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
211    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
212    * @param _spender The address which will spend the funds.
213    * @param _value The amount of tokens to be spent.
214    */
215   function approve(address _spender, uint256 _value) public returns (bool) {
216     allowed[msg.sender][_spender] = _value;
217     emit Approval(msg.sender, _spender, _value);
218     return true;
219   }
220 
221   /**
222    * @dev Transfer tokens from one address to another
223    * @param _from address The address which you want to send tokens from
224    * @param _to address The address which you want to transfer to
225    * @param _value uint256 the amount of tokens to be transferred
226    */
227   function transferFrom(
228     address _from,
229     address _to,
230     uint256 _value
231   )
232     public
233     returns (bool)
234   {
235     require(_value <= balances[_from]);
236     require(_value <= allowed[_from][msg.sender]);
237     require(_to != address(0));
238 
239     balances[_from] = balances[_from].sub(_value);
240     balances[_to] = balances[_to].add(_value);
241     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
242     emit Transfer(_from, _to, _value);
243     return true;
244   }
245 
246   /**
247    * @dev Increase the amount of tokens that an owner allowed to a spender.
248    * approve should be called when allowed[_spender] == 0. To increment
249    * allowed value is better to use this function to avoid 2 calls (and wait until
250    * the first transaction is mined)
251    * From MonolithDAO Token.sol
252    * @param _spender The address which will spend the funds.
253    * @param _addedValue The amount of tokens to increase the allowance by.
254    */
255   function increaseApproval(
256     address _spender,
257     uint256 _addedValue
258   )
259     public
260     returns (bool)
261   {
262     allowed[msg.sender][_spender] = (
263       allowed[msg.sender][_spender].add(_addedValue));
264     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
265     return true;
266   }
267 
268   /**
269    * @dev Decrease the amount of tokens that an owner allowed to a spender.
270    * approve should be called when allowed[_spender] == 0. To decrement
271    * allowed value is better to use this function to avoid 2 calls (and wait until
272    * the first transaction is mined)
273    * From MonolithDAO Token.sol
274    * @param _spender The address which will spend the funds.
275    * @param _subtractedValue The amount of tokens to decrease the allowance by.
276    */
277   function decreaseApproval(
278     address _spender,
279     uint256 _subtractedValue
280   )
281     public
282     returns (bool)
283   {
284     uint256 oldValue = allowed[msg.sender][_spender];
285     if (_subtractedValue >= oldValue) {
286       allowed[msg.sender][_spender] = 0;
287     } else {
288       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
289     }
290     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291     return true;
292   }
293 
294   /**
295    * @dev Internal function that mints an amount of the token and assigns it to
296    * an account. This encapsulates the modification of balances such that the
297    * proper events are emitted.
298    * @param _account The account that will receive the created tokens.
299    * @param _amount The amount that will be created.
300    */
301   function _mint(address _account, uint256 _amount) internal {
302     require(_account != 0);
303     totalSupply_ = totalSupply_.add(_amount);
304     balances[_account] = balances[_account].add(_amount);
305     emit Transfer(address(0), _account, _amount);
306   }
307 
308   /**
309    * @dev Internal function that burns an amount of the token of a given
310    * account.
311    * @param _account The account whose tokens will be burnt.
312    * @param _amount The amount that will be burnt.
313    */
314   function _burn(address _account, uint256 _amount) internal {
315     require(_account != 0);
316     require(balances[_account] > _amount);
317 
318     totalSupply_ = totalSupply_.sub(_amount);
319     balances[_account] = balances[_account].sub(_amount);
320     emit Transfer(_account, address(0), _amount);
321   }
322 
323   /**
324    * @dev Internal function that burns an amount of the token of a given
325    * account, deducting from the sender's allowance for said account. Uses the
326    * internal _burn function.
327    * @param _account The account whose tokens will be burnt.
328    * @param _amount The amount that will be burnt.
329    */
330   function _burnFrom(address _account, uint256 _amount) internal {
331     require(allowed[_account][msg.sender] > _amount);
332 
333     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
334     // this function needs to emit an event with the updated approval.
335     allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
336     _burn(_account, _amount);
337   }
338 }
339 
340 contract MintableToken is StandardToken, Ownable {
341   event Mint(address indexed to, uint256 amount);
342   event MintFinished();
343 
344   bool public mintingFinished = false;
345 
346 
347   modifier canMint() {
348     require(!mintingFinished);
349     _;
350   }
351 
352   modifier hasMintPermission() {
353     require(msg.sender == owner);
354     _;
355   }
356 
357   /**
358    * @dev Function to mint tokens
359    * @param _to The address that will receive the minted tokens.
360    * @param _amount The amount of tokens to mint.
361    * @return A boolean that indicates if the operation was successful.
362    */
363   function mint(
364     address _to,
365     uint256 _amount
366   )
367     public
368     hasMintPermission
369     canMint
370     returns (bool)
371   {
372     _mint(_to, _amount);
373     emit Mint(_to, _amount);
374     return true;
375   }
376 
377   /**
378    * @dev Function to stop minting new tokens.
379    * @return True if the operation was successful.
380    */
381   function finishMinting() public onlyOwner canMint returns (bool) {
382     mintingFinished = true;
383     emit MintFinished();
384     return true;
385   }
386 }
387 
388 contract DetailedERC20 is ERC20 {
389   string public name;
390   string public symbol;
391   uint8 public decimals;
392 
393   constructor(string _name, string _symbol, uint8 _decimals) public {
394     name = _name;
395     symbol = _symbol;
396     decimals = _decimals;
397   }
398 }
399 
400 
401 
402 contract MonstersGameXToken is MintableToken, DetailedERC20 {
403     
404   constructor() public DetailedERC20("Monsters-Game-X", "MGX", 18) {
405   }
406   
407 }