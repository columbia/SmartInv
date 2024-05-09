1 pragma solidity ^0.4.26;
2 
3 // File: contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 // File: contracts/math/SafeMath.sol
45 
46 /**
47  * @title SafeMath
48  * @dev Math operations with safety checks that throw on error
49  */
50 library SafeMath {
51 
52   /**
53   * @dev Multiplies two numbers, throws on overflow.
54   */
55   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
56     if (a == 0) {
57       return 0;
58     }
59     c = a * b;
60     assert(c / a == b);
61     return c;
62   }
63 
64   /**
65   * @dev Integer division of two numbers, truncating the quotient.
66   */
67   function div(uint256 a, uint256 b) internal pure returns (uint256) {
68     // assert(b > 0); // Solidity automatically throws when dividing by 0
69     // uint256 c = a / b;
70     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
71     return a / b;
72   }
73 
74   /**
75   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
76   */
77   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78     assert(b <= a);
79     return a - b;
80   }
81 
82   /**
83   * @dev Adds two numbers, throws on overflow.
84   */
85   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
86     c = a + b;
87     assert(c >= a);
88     return c;
89   }
90 }
91 
92 contract LockableToken is Ownable {
93 
94   event Lock(address indexed spender, uint256 value);
95 
96   using SafeMath for uint256;
97 
98   mapping(address => uint256) internal locked;
99 
100   function lock(address _spender, uint256 _value) public onlyOwner returns (bool) {
101     if ((_value != 0) && (locked[_spender] != 0)) revert();
102 
103     locked[_spender] = _value;
104     emit Lock(_spender, _value);
105     return true;
106   }
107 
108   function locking(address _spender) public view returns (uint256) {
109     return locked[_spender];
110   }
111 
112   function increaseLocking(address _spender, uint _addedValue) public onlyOwner returns (bool) {
113     locked[_spender] = locked[_spender].add(_addedValue);
114     emit Lock(_spender, locked[_spender]);
115     return true;
116   }
117 
118   function decreaseLocking(address _spender, uint _subtractedValue) public onlyOwner returns (bool) {
119     uint oldValue = locked[_spender];
120     if (_subtractedValue > oldValue) {
121       locked[_spender] = 0;
122     } else {
123       locked[_spender] = oldValue.sub(_subtractedValue);
124     }
125     emit Lock(_spender, locked[_spender]);
126     return true;
127   }
128 
129 }
130 
131 // File: contracts/token/ERC20/ERC20Basic.sol
132 
133 /**
134  * @title ERC20Basic
135  * @dev Simpler version of ERC20 interface
136  * @dev see https://github.com/ethereum/EIPs/issues/179
137  */
138 contract ERC20Basic {
139   function totalSupply() public view returns (uint256);
140 
141   function balanceOf(address who) public view returns (uint256);
142 
143   function transfer(address to, uint256 value) public returns (bool);
144 
145   event Transfer(address indexed from, address indexed to, uint256 value);
146 }
147 
148 // File: contracts/token/ERC20/BasicToken.sol
149 
150 /**
151  * @title Basic token
152  * @dev Basic version of StandardToken, with no allowances.
153  */
154 contract BasicToken is ERC20Basic, LockableToken {
155 
156   mapping(address => uint256) balances;
157 
158   uint256 totalSupply_;
159 
160   /**
161   * @dev total number of tokens in existence
162   */
163   function totalSupply() public view returns (uint256) {
164     return totalSupply_;
165   }
166 
167   /**
168   * @dev transfer token for a specified address
169   * @param _to The address to transfer to.
170   * @param _value The amount to be transferred.
171   */
172   function transfer(address _to, uint256 _value) public returns (bool) {
173     require(_to != address(0));
174     require(_value <= balances[msg.sender]);
175     require(locked[msg.sender] <= balances[msg.sender].sub(_value));
176 
177     balances[msg.sender] = balances[msg.sender].sub(_value);
178     balances[_to] = balances[_to].add(_value);
179     emit Transfer(msg.sender, _to, _value);
180     return true;
181   }
182 
183   /**
184   * @dev Gets the balance of the specified address.
185   * @param _owner The address to query the the balance of.
186   * @return An uint256 representing the amount owned by the passed address.
187   */
188   function balanceOf(address _owner) public view returns (uint256) {
189     return balances[_owner];
190   }
191 
192 }
193 
194 // File: contracts/token/ERC20/BurnableToken.sol
195 
196 /**
197  * @title Burnable Token
198  * @dev Token that can be irreversibly burned (destroyed).
199  */
200 contract BurnableToken is BasicToken {
201 
202   event Burn(address indexed burner, uint256 value);
203 
204   /**
205    * @dev Burns a specific amount of tokens.
206    * @param _value The amount of token to be burned.
207    */
208   function burn(uint256 _value) public {
209     _burn(msg.sender, _value);
210   }
211 
212   function _burn(address _who, uint256 _value) internal {
213     require(_value <= balances[_who]);
214     // no need to require value <= totalSupply, since that would imply the
215     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
216 
217     balances[_who] = balances[_who].sub(_value);
218     totalSupply_ = totalSupply_.sub(_value);
219     emit Burn(_who, _value);
220     emit Transfer(_who, address(0), _value);
221   }
222 }
223 
224 // File: contracts/token/ERC20/ERC20.sol
225 
226 /**
227  * @title ERC20 interface
228  * @dev see https://github.com/ethereum/EIPs/issues/20
229  */
230 contract ERC20 is ERC20Basic {
231   function allowance(address owner, address spender) public view returns (uint256);
232 
233   function transferFrom(address from, address to, uint256 value) public returns (bool);
234 
235   function approve(address spender, uint256 value) public returns (bool);
236 
237   event Approval(address indexed owner, address indexed spender, uint256 value);
238 }
239 
240 // File: contracts/token/ERC20/StandardToken.sol
241 
242 /**
243  * @title Standard ERC20 token
244  *
245  * @dev Implementation of the basic standard token.
246  * @dev https://github.com/ethereum/EIPs/issues/20
247  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
248  */
249 contract StandardToken is ERC20, BasicToken {
250 
251   mapping(address => mapping(address => uint256)) internal allowed;
252 
253 
254   /**
255    * @dev Transfer tokens from one address to another
256    * @param _from address The address which you want to send tokens from
257    * @param _to address The address which you want to transfer to
258    * @param _value uint256 the amount of tokens to be transferred
259    */
260   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
261     require(_to != address(0));
262     require(_value <= balances[_from]);
263     require(_value <= allowed[_from][msg.sender]);
264     require(locked[_from] <= balances[_from].sub(_value));
265 
266     balances[_from] = balances[_from].sub(_value);
267     balances[_to] = balances[_to].add(_value);
268     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
269     emit Transfer(_from, _to, _value);
270     return true;
271   }
272 
273   /**
274    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
275    *
276    * Beware that changing an allowance with this method brings the risk that someone may use both the old
277    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
278    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
279    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
280    * @param _spender The address which will spend the funds.
281    * @param _value The amount of tokens to be spent.
282    */
283   function approve(address _spender, uint256 _value) public returns (bool) {
284     // To change the approve amount you first have to reduce the addresses`
285     //  allowance to zero by calling `approve(_spender, 0)` if it is not
286     //  already 0 to mitigate the race condition described here:
287     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
288     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
289 
290     allowed[msg.sender][_spender] = _value;
291     emit Approval(msg.sender, _spender, _value);
292     return true;
293   }
294 
295   /**
296    * @dev Function to check the amount of tokens that an owner allowed to a spender.
297    * @param _owner address The address which owns the funds.
298    * @param _spender address The address which will spend the funds.
299    * @return A uint256 specifying the amount of tokens still available for the spender.
300    */
301   function allowance(address _owner, address _spender) public view returns (uint256) {
302     return allowed[_owner][_spender];
303   }
304 
305   /**
306    * @dev Increase the amount of tokens that an owner allowed to a spender.
307    *
308    * approve should be called when allowed[_spender] == 0. To increment
309    * allowed value is better to use this function to avoid 2 calls (and wait until
310    * the first transaction is mined)
311    * From MonolithDAO Token.sol
312    * @param _spender The address which will spend the funds.
313    * @param _addedValue The amount of tokens to increase the allowance by.
314    */
315   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
316     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
317     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
318     return true;
319   }
320 
321   /**
322    * @dev Decrease the amount of tokens that an owner allowed to a spender.
323    *
324    * approve should be called when allowed[_spender] == 0. To decrement
325    * allowed value is better to use this function to avoid 2 calls (and wait until
326    * the first transaction is mined)
327    * From MonolithDAO Token.sol
328    * @param _spender The address which will spend the funds.
329    * @param _subtractedValue The amount of tokens to decrease the allowance by.
330    */
331   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
332     uint oldValue = allowed[msg.sender][_spender];
333     if (_subtractedValue > oldValue) {
334       allowed[msg.sender][_spender] = 0;
335     } else {
336       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
337     }
338     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
339     return true;
340   }
341 
342 }
343 
344 contract MintableToken is StandardToken {
345   /**
346  * @dev Function to mint tokens
347  * @param _to The address that will receive the minted tokens.
348  * @param _amount The amount of tokens to mint.
349  * @return A boolean that indicates if the operation was successful.
350  */
351   function mint(
352     address _to,
353     uint256 _amount
354   )
355   public
356   onlyOwner
357   returns (bool)
358   {
359     totalSupply_ = totalSupply_.add(_amount);
360     balances[_to] = balances[_to].add(_amount);
361     emit Transfer(address(0), _to, _amount);
362     return true;
363   }
364 }
365 
366 contract VIE is StandardToken, BurnableToken, MintableToken {
367   // Constants
368   string  public constant name = "Viecology";
369   string  public constant symbol = "VIE";
370   uint8   public constant decimals = 18;
371   uint256 public constant INITIAL_SUPPLY = 1899000000 * (10 ** uint256(decimals));
372   address constant holder = 0xBC878377b22FADD7Edcd7e6CCB6334038a4Ef8Ec;
373 
374   constructor() public {
375     totalSupply_ = INITIAL_SUPPLY;
376     balances[holder] = INITIAL_SUPPLY;
377     emit Transfer(address(0), holder, INITIAL_SUPPLY);
378   }
379 
380   function() external payable {
381     revert();
382   }
383 
384 }