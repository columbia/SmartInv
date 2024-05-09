1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 
54 /**
55  * @title ERC20Basic
56  * @dev Simpler version of ERC20 interface
57  * See https://github.com/ethereum/EIPs/issues/179
58  */
59 contract ERC20Basic {
60   function totalSupply() public view returns (uint256);
61   function balanceOf(address who) public view returns (uint256);
62   function transfer(address to, uint256 value) public returns (bool);
63   event Transfer(address indexed from, address indexed to, uint256 value);
64 }
65 
66 
67 
68 /**
69  * @title Basic token
70  * @dev Basic version of StandardToken, with no allowances.
71  */
72 contract BasicToken is ERC20Basic {
73   using SafeMath for uint256;
74 
75   mapping(address => uint256) balances;
76 
77   uint256 totalSupply_;
78 
79   /**
80   * @dev Total number of tokens in existence
81   */
82   function totalSupply() public view returns (uint256) {
83     return totalSupply_;
84   }
85 
86   /**
87   * @dev Transfer token for a specified address
88   * @param _to The address to transfer to.
89   * @param _value The amount to be transferred.
90   */
91   function transfer(address _to, uint256 _value) public returns (bool) {
92     require(_to != address(0));
93     require(_value <= balances[msg.sender]);
94 
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     emit Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   /**
102   * @dev Gets the balance of the specified address.
103   * @param _owner The address to query the the balance of.
104   * @return An uint256 representing the amount owned by the passed address.
105   */
106   function balanceOf(address _owner) public view returns (uint256) {
107     return balances[_owner];
108   }
109 
110 }
111 
112 
113 /**
114  * @title Burnable Token
115  * @dev Token that can be irreversibly burned (destroyed).
116  */
117 contract BurnableToken is BasicToken {
118 
119   event Burn(address indexed burner, uint256 value);
120 
121   /**
122    * @dev Burns a specific amount of tokens.
123    * @param _value The amount of token to be burned.
124    */
125   function burn(uint256 _value) public {
126     _burn(msg.sender, _value);
127   }
128 
129   function _burn(address _who, uint256 _value) internal {
130     require(_value <= balances[_who]);
131     // no need to require value <= totalSupply, since that would imply the
132     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
133 
134     balances[_who] = balances[_who].sub(_value);
135     totalSupply_ = totalSupply_.sub(_value);
136     emit Burn(_who, _value);
137     emit Transfer(_who, address(0), _value);
138   }
139 }
140 
141 
142 /**
143  * @title Ownable
144  * @dev The Ownable contract has an owner address, and provides basic authorization control
145  * functions, this simplifies the implementation of "user permissions".
146  */
147 contract Ownable {
148   address public owner;
149 
150 
151   event OwnershipRenounced(address indexed previousOwner);
152   event OwnershipTransferred(
153     address indexed previousOwner,
154     address indexed newOwner
155   );
156 
157 
158   /**
159    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
160    * account.
161    */
162   constructor() public {
163     owner = msg.sender;
164   }
165 
166   /**
167    * @dev Throws if called by any account other than the owner.
168    */
169   modifier onlyOwner() {
170     require(msg.sender == owner);
171     _;
172   }
173 
174   /**
175    * @dev Allows the current owner to relinquish control of the contract.
176    * @notice Renouncing to ownership will leave the contract without an owner.
177    * It will not be possible to call the functions with the `onlyOwner`
178    * modifier anymore.
179    */
180   function renounceOwnership() public onlyOwner {
181     emit OwnershipRenounced(owner);
182     owner = address(0);
183   }
184 
185   /**
186    * @dev Allows the current owner to transfer control of the contract to a newOwner.
187    * @param _newOwner The address to transfer ownership to.
188    */
189   function transferOwnership(address _newOwner) public onlyOwner {
190     _transferOwnership(_newOwner);
191   }
192 
193   /**
194    * @dev Transfers control of the contract to a newOwner.
195    * @param _newOwner The address to transfer ownership to.
196    */
197   function _transferOwnership(address _newOwner) internal {
198     require(_newOwner != address(0));
199     emit OwnershipTransferred(owner, _newOwner);
200     owner = _newOwner;
201   }
202 }
203 
204 
205 /**
206  * @title BurnableByOwnerToken
207  * @dev Burnable token which can be burnt only by owner
208  **/
209 contract BurnableByOwnerToken is BurnableToken, Ownable {
210 
211   function burn(uint256 _value) public onlyOwner {
212     super.burn(_value);
213   }
214 
215 }
216 
217 
218 /**
219  * @title ERC20 interface
220  * @dev see https://github.com/ethereum/EIPs/issues/20
221  */
222 contract ERC20 is ERC20Basic {
223   function allowance(address owner, address spender)
224     public view returns (uint256);
225 
226   function transferFrom(address from, address to, uint256 value)
227     public returns (bool);
228 
229   function approve(address spender, uint256 value) public returns (bool);
230   event Approval(
231     address indexed owner,
232     address indexed spender,
233     uint256 value
234   );
235 }
236 
237 
238 /**
239  * @title Standard ERC20 token
240  *
241  * @dev Implementation of the basic standard token.
242  * https://github.com/ethereum/EIPs/issues/20
243  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
244  */
245 contract StandardToken is ERC20, BasicToken {
246 
247   mapping (address => mapping (address => uint256)) internal allowed;
248 
249 
250   /**
251    * @dev Transfer tokens from one address to another
252    * @param _from address The address which you want to send tokens from
253    * @param _to address The address which you want to transfer to
254    * @param _value uint256 the amount of tokens to be transferred
255    */
256   function transferFrom(
257     address _from,
258     address _to,
259     uint256 _value
260   )
261     public
262     returns (bool)
263   {
264     require(_to != address(0));
265     require(_value <= balances[_from]);
266     require(_value <= allowed[_from][msg.sender]);
267 
268     balances[_from] = balances[_from].sub(_value);
269     balances[_to] = balances[_to].add(_value);
270     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
271     emit Transfer(_from, _to, _value);
272     return true;
273   }
274 
275   /**
276    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
277    * Beware that changing an allowance with this method brings the risk that someone may use both the old
278    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
279    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
280    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
281    * @param _spender The address which will spend the funds.
282    * @param _value The amount of tokens to be spent.
283    */
284   function approve(address _spender, uint256 _value) public returns (bool) {
285     allowed[msg.sender][_spender] = _value;
286     emit Approval(msg.sender, _spender, _value);
287     return true;
288   }
289 
290   /**
291    * @dev Function to check the amount of tokens that an owner allowed to a spender.
292    * @param _owner address The address which owns the funds.
293    * @param _spender address The address which will spend the funds.
294    * @return A uint256 specifying the amount of tokens still available for the spender.
295    */
296   function allowance(
297     address _owner,
298     address _spender
299    )
300     public
301     view
302     returns (uint256)
303   {
304     return allowed[_owner][_spender];
305   }
306 
307   /**
308    * @dev Increase the amount of tokens that an owner allowed to a spender.
309    * approve should be called when allowed[_spender] == 0. To increment
310    * allowed value is better to use this function to avoid 2 calls (and wait until
311    * the first transaction is mined)
312    * From MonolithDAO Token.sol
313    * @param _spender The address which will spend the funds.
314    * @param _addedValue The amount of tokens to increase the allowance by.
315    */
316   function increaseApproval(
317     address _spender,
318     uint256 _addedValue
319   )
320     public
321     returns (bool)
322   {
323     allowed[msg.sender][_spender] = (
324       allowed[msg.sender][_spender].add(_addedValue));
325     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
326     return true;
327   }
328 
329   /**
330    * @dev Decrease the amount of tokens that an owner allowed to a spender.
331    * approve should be called when allowed[_spender] == 0. To decrement
332    * allowed value is better to use this function to avoid 2 calls (and wait until
333    * the first transaction is mined)
334    * From MonolithDAO Token.sol
335    * @param _spender The address which will spend the funds.
336    * @param _subtractedValue The amount of tokens to decrease the allowance by.
337    */
338   function decreaseApproval(
339     address _spender,
340     uint256 _subtractedValue
341   )
342     public
343     returns (bool)
344   {
345     uint256 oldValue = allowed[msg.sender][_spender];
346     if (_subtractedValue > oldValue) {
347       allowed[msg.sender][_spender] = 0;
348     } else {
349       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
350     }
351     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
352     return true;
353   }
354 
355 }
356 
357 
358 /**
359  * @title HyperQuantToken
360  * @dev Implements StandardToken and BurnableByOwnerToken.
361  */
362 contract HyperQuantToken is StandardToken, BurnableByOwnerToken {
363   string public constant name = "HyperQuant Token";
364   string public constant symbol = "HQT";
365   uint8 public constant decimals = 18;
366 
367   uint256 constant INITIAL_SUPPLY = 200 * (10 ** 6) * (10 ** (uint256(decimals)));
368 
369   /**
370    * @dev Constructor that set initial supply to this contract
371      and allows owner to transfer tokens.
372    */
373   constructor() public {
374     totalSupply_ = INITIAL_SUPPLY;
375     balances[this] = INITIAL_SUPPLY;
376     emit Transfer(address(0), this, INITIAL_SUPPLY);
377     allowed[this][msg.sender] = INITIAL_SUPPLY;
378     emit Approval(this, msg.sender, INITIAL_SUPPLY);
379   }
380 }