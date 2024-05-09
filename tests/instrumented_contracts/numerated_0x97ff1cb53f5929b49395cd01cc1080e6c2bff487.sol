1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 contract ERC20 {
9   function totalSupply() public view returns (uint256);
10 
11   function balanceOf(address _who) public view returns (uint256);
12 
13   function allowance(address _owner, address _spender)
14     public view returns (uint256);
15 
16   function transfer(address _to, uint256 _value) public returns (bool);
17 
18   function approve(address _spender, uint256 _value)
19     public returns (bool);
20 
21   function transferFrom(address _from, address _to, uint256 _value)
22     public returns (bool);
23 
24   event Transfer(
25     address indexed from,
26     address indexed to,
27     uint256 value
28   );
29 
30   event Approval(
31     address indexed owner,
32     address indexed spender,
33     uint256 value
34   );
35 }
36 
37 library SafeMath {
38 
39   /**
40   * @dev Multiplies two numbers, reverts on overflow.
41   */
42   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
43     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
44     // benefit is lost if 'b' is also tested.
45     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
46     if (_a == 0) {
47       return 0;
48     }
49 
50     uint256 c = _a * _b;
51     require(c / _a == _b);
52 
53     return c;
54   }
55 
56   /**
57   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
58   */
59   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
60     require(_b > 0); // Solidity only automatically asserts when dividing by 0
61     uint256 c = _a / _b;
62     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
63 
64     return c;
65   }
66 
67   /**
68   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
69   */
70   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
71     require(_b <= _a);
72     uint256 c = _a - _b;
73 
74     return c;
75   }
76 
77   /**
78   * @dev Adds two numbers, reverts on overflow.
79   */
80   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
81     uint256 c = _a + _b;
82     require(c >= _a);
83 
84     return c;
85   }
86 
87   /**
88   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
89   * reverts when dividing by zero.
90   */
91   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
92     require(b != 0);
93     return a % b;
94   }
95 }
96 contract Ownable {
97   address public owner;
98 
99 
100   event OwnershipRenounced(address indexed previousOwner);
101   event OwnershipTransferred(
102     address indexed previousOwner,
103     address indexed newOwner
104   );
105 
106 
107   /**
108    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
109    * account.
110    */
111   constructor() public {
112     owner = msg.sender;
113   }
114 
115   /**
116    * @dev Throws if called by any account other than the owner.
117    */
118   modifier onlyOwner() {
119     require(msg.sender == owner);
120     _;
121   }
122 
123   /**
124    * @dev Allows the current owner to relinquish control of the contract.
125    * @notice Renouncing to ownership will leave the contract without an owner.
126    * It will not be possible to call the functions with the `onlyOwner`
127    * modifier anymore.
128    */
129   function renounceOwnership() public onlyOwner {
130     emit OwnershipRenounced(owner);
131     owner = address(0);
132   }
133 
134   /**
135    * @dev Allows the current owner to transfer control of the contract to a newOwner.
136    * @param _newOwner The address to transfer ownership to.
137    */
138   function transferOwnership(address _newOwner) public onlyOwner {
139     _transferOwnership(_newOwner);
140   }
141 
142   /**
143    * @dev Transfers control of the contract to a newOwner.
144    * @param _newOwner The address to transfer ownership to.
145    */
146   function _transferOwnership(address _newOwner) internal {
147     require(_newOwner != address(0));
148     emit OwnershipTransferred(owner, _newOwner);
149     owner = _newOwner;
150   }
151 }
152 contract StandardToken is ERC20 {
153   using SafeMath for uint256;
154 
155   mapping(address => uint256) balances;
156 
157   mapping (address => mapping (address => uint256)) internal allowed;
158 
159   uint256 totalSupply_;
160 
161   /**
162   * @dev Total number of tokens in existence
163   */
164   function totalSupply() public view returns (uint256) {
165     return totalSupply_;
166   }
167 
168   /**
169   * @dev Gets the balance of the specified address.
170   * @param _owner The address to query the the balance of.
171   * @return An uint256 representing the amount owned by the passed address.
172   */
173   function balanceOf(address _owner) public view returns (uint256) {
174     return balances[_owner];
175   }
176 
177   /**
178    * @dev Function to check the amount of tokens that an owner allowed to a spender.
179    * @param _owner address The address which owns the funds.
180    * @param _spender address The address which will spend the funds.
181    * @return A uint256 specifying the amount of tokens still available for the spender.
182    */
183   function allowance(
184     address _owner,
185     address _spender
186    )
187     public
188     view
189     returns (uint256)
190   {
191     return allowed[_owner][_spender];
192   }
193 
194   /**
195   * @dev Transfer token for a specified address
196   * @param _to The address to transfer to.
197   * @param _value The amount to be transferred.
198   */
199   function transfer(address _to, uint256 _value) public returns (bool) {
200     require(_value <= balances[msg.sender]);
201     require(_to != address(0));
202 
203     balances[msg.sender] = balances[msg.sender].sub(_value);
204     balances[_to] = balances[_to].add(_value);
205     emit Transfer(msg.sender, _to, _value);
206     return true;
207   }
208 
209   /**
210    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
211    * Beware that changing an allowance with this method brings the risk that someone may use both the old
212    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
213    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
214    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
215    * @param _spender The address which will spend the funds.
216    * @param _value The amount of tokens to be spent.
217    */
218   function approve(address _spender, uint256 _value) public returns (bool) {
219     allowed[msg.sender][_spender] = _value;
220     emit Approval(msg.sender, _spender, _value);
221     return true;
222   }
223 
224   /**
225    * @dev Transfer tokens from one address to another
226    * @param _from address The address which you want to send tokens from
227    * @param _to address The address which you want to transfer to
228    * @param _value uint256 the amount of tokens to be transferred
229    */
230   function transferFrom(
231     address _from,
232     address _to,
233     uint256 _value
234   )
235     public
236     returns (bool)
237   {
238     require(_value <= balances[_from]);
239     require(_value <= allowed[_from][msg.sender]);
240     require(_to != address(0));
241 
242     balances[_from] = balances[_from].sub(_value);
243     balances[_to] = balances[_to].add(_value);
244     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
245     emit Transfer(_from, _to, _value);
246     return true;
247   }
248 
249   /**
250    * @dev Increase the amount of tokens that an owner allowed to a spender.
251    * approve should be called when allowed[_spender] == 0. To increment
252    * allowed value is better to use this function to avoid 2 calls (and wait until
253    * the first transaction is mined)
254    * From MonolithDAO Token.sol
255    * @param _spender The address which will spend the funds.
256    * @param _addedValue The amount of tokens to increase the allowance by.
257    */
258   function increaseApproval(
259     address _spender,
260     uint256 _addedValue
261   )
262     public
263     returns (bool)
264   {
265     allowed[msg.sender][_spender] = (
266       allowed[msg.sender][_spender].add(_addedValue));
267     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
268     return true;
269   }
270 
271   /**
272    * @dev Decrease the amount of tokens that an owner allowed to a spender.
273    * approve should be called when allowed[_spender] == 0. To decrement
274    * allowed value is better to use this function to avoid 2 calls (and wait until
275    * the first transaction is mined)
276    * From MonolithDAO Token.sol
277    * @param _spender The address which will spend the funds.
278    * @param _subtractedValue The amount of tokens to decrease the allowance by.
279    */
280   function decreaseApproval(
281     address _spender,
282     uint256 _subtractedValue
283   )
284     public
285     returns (bool)
286   {
287     uint256 oldValue = allowed[msg.sender][_spender];
288     if (_subtractedValue >= oldValue) {
289       allowed[msg.sender][_spender] = 0;
290     } else {
291       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
292     }
293     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
294     return true;
295   }
296 
297   event Burn(address indexed burner, uint256 value);
298 
299   /**
300    * @dev Burns a specific amount of tokens.
301    * @param _value The amount of token to be burned.
302    */
303   function burn(uint256 _value) public {
304     _burn(msg.sender, _value);
305   }
306 
307   /**
308    * @dev Burns a specific amount of tokens from the target address and decrements allowance
309    * @param _from address The address which you want to send tokens from
310    * @param _value uint256 The amount of token to be burned
311    */
312   function burnFrom(address _from, uint256 _value) public {
313     require(_value <= allowed[_from][msg.sender]);
314     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
315     // this function needs to emit an event with the updated approval.
316     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
317     _burn(_from, _value);
318   }
319 
320   function _burn(address _who, uint256 _value) internal {
321     require(_value <= balances[_who]);
322     // no need to require value <= totalSupply, since that would imply the
323     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
324 
325     balances[_who] = balances[_who].sub(_value);
326     totalSupply_ = totalSupply_.sub(_value);
327     emit Burn(_who, _value);
328     emit Transfer(_who, address(0), _value);
329   }
330 }
331 contract MintableToken is StandardToken, Ownable {
332   event Mint(address indexed to, uint256 amount);
333   event MintFinished();
334 
335   bool public mintingFinished = false;
336 
337 
338   modifier canMint() {
339     require(!mintingFinished);
340     _;
341   }
342 
343   modifier hasMintPermission() {
344     require(msg.sender == owner);
345     _;
346   }
347   
348   function MintableToken() {
349       mint (msg.sender, 500000000 * (10 ** 18));
350       finishMinting();
351   }
352 
353   /**
354    * @dev Function to mint tokens
355    * @param _to The address that will receive the minted tokens.
356    * @param _amount The amount of tokens to mint.
357    * @return A boolean that indicates if the operation was successful.
358    */
359   function mint(
360     address _to,
361     uint256 _amount
362   )
363     public
364     hasMintPermission
365     canMint
366     returns (bool)
367   {
368     totalSupply_ = totalSupply_.add(_amount);
369     balances[_to] = balances[_to].add(_amount);
370     emit Mint(_to, _amount);
371     emit Transfer(address(0), _to, _amount);
372     return true;
373   }
374 
375   /**
376    * @dev Function to stop minting new tokens.
377    * @return True if the operation was successful.
378    */
379   function finishMinting() public onlyOwner canMint returns (bool) {
380     mintingFinished = true;
381     emit MintFinished();
382     return true;
383   }
384 }
385 contract MCE is MintableToken {
386     string public name="MultiChainExchange token";
387     string public symbol="MCE";
388     uint256 public decimals = 18;
389     uint256 public constant initialSupply = 500000000 * (10 ** 18);
390     
391     }