1 pragma solidity ^0.5.0;
2 
3 
4 // ----------------------------------------------------------------------------
5 
6 // 'CHN' 'Chain' token contract
7 
8 //
9 
10 // Symbol      : CHN
11 
12 // Name        : Chain
13 
14 // Total supply: 100,000,000.000000000000000000
15 
16 // Decimals    : 18
17 
18 // Website     : https://chain.com
19 
20 // Digital Asset Interoperability
21 
22 // ----------------------------------------------------------------------------
23 
24 /**
25  * @dev Wrappers over Solidity's arithmetic operations with added overflow
26  * checks.
27  *
28  * Arithmetic operations in Solidity wrap on overflow. This can easily result
29  * in bugs, because programmers usually assume that an overflow raises an
30  * error, which is the standard behavior in high level programming languages.
31  * `SafeMath` restores this intuition by reverting the transaction when an
32  * operation overflows.
33  *
34  * Using this library instead of the unchecked operations eliminates an entire
35  * class of bugs, so it's recommended to use it always.
36  */
37 library SafeMath {
38     /**
39      * @dev Returns the addition of two unsigned integers, reverting on
40      * overflow.
41      *
42      * Counterpart to Solidity's `+` operator.
43      *
44      * Requirements:
45      * - Addition cannot overflow.
46      */
47     function add(uint256 a, uint256 b) internal pure returns (uint256) {
48         uint256 c = a + b;
49         require(c >= a, "SafeMath: addition overflow");
50 
51         return c;
52     }
53 
54     /**
55      * @dev Returns the subtraction of two unsigned integers, reverting on
56      * overflow (when the result is negative).
57      *
58      * Counterpart to Solidity's `-` operator.
59      *
60      * Requirements:
61      * - Subtraction cannot overflow.
62      */
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b <= a, "SafeMath: subtraction overflow");
65         uint256 c = a - b;
66 
67         return c;
68     }
69 
70     /**
71      * @dev Returns the multiplication of two unsigned integers, reverting on
72      * overflow.
73      *
74      * Counterpart to Solidity's `*` operator.
75      *
76      * Requirements:
77      * - Multiplication cannot overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      * - The divisor cannot be zero.
103      */
104     function div(uint256 a, uint256 b) internal pure returns (uint256) {
105         // Solidity only automatically asserts when dividing by 0
106         require(b > 0, "SafeMath: division by zero");
107         uint256 c = a / b;
108         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
109 
110         return c;
111     }
112 
113     /**
114      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
115      * Reverts when dividing by zero.
116      *
117      * Counterpart to Solidity's `%` operator. This function uses a `revert`
118      * opcode (which leaves remaining gas untouched) while Solidity uses an
119      * invalid opcode to revert (consuming all remaining gas).
120      *
121      * Requirements:
122      * - The divisor cannot be zero.
123      */
124     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
125         require(b != 0, "SafeMath: modulo by zero");
126         return a % b;
127     }
128 }
129 
130 
131 /// @title Ownable Contract
132 contract Ownable {
133     address public owner;
134 
135     event OwnershipTransferred(address indexed _from, address indexed _to);
136 
137 
138     constructor() public {
139 
140         owner = msg.sender;
141 
142     }
143 
144 
145     modifier onlyOwner {
146 
147         require(msg.sender == owner);
148 
149         _;
150 
151     }
152 
153 
154     function transferOwnership(address newOwner) public onlyOwner {
155 
156         owner = newOwner;
157         emit OwnershipTransferred(owner, newOwner);
158 
159     }
160 }
161 
162 contract Pausable is Ownable {
163   event Pause();
164   event Unpause();
165 
166   bool public paused = false;
167 
168 
169   /**
170    * @dev Modifier to make a function callable only when the contract is not paused.
171    */
172   modifier whenNotPaused() {
173     require(!paused);
174     _;
175   }
176 
177   /**
178    * @dev Modifier to make a function callable only when the contract is paused.
179    */
180   modifier whenPaused() {
181     require(paused);
182     _;
183   }
184 
185   /**
186    * @dev called by the owner to pause, triggers stopped state
187    */
188   function pause() onlyOwner whenNotPaused public {
189     paused = true;
190     emit Pause();
191   }
192 
193   /**
194    * @dev called by the owner to unpause, returns to normal state
195    */
196   function unpause() onlyOwner whenPaused public {
197     paused = false;
198     emit Unpause();
199   }
200 }
201 
202 contract ERC20Basic {
203   uint256 public totalSupply;
204   function balanceOf(address who) public view returns (uint256);
205   function transfer(address to, uint256 value) public returns (bool);
206   event Transfer(address indexed from, address indexed to, uint256 value);
207 }
208 
209 contract BasicToken is ERC20Basic {
210   using SafeMath for uint256;
211 
212   mapping(address => uint256) balances;
213 
214   /**
215   * @dev transfer token for a specified address
216   * @param _to The address to transfer to.
217   * @param _value The amount to be transferred.
218   */
219   function transfer(address _to, uint256 _value) public returns (bool) {
220     require(_to != address(0));
221     require(_value <= balances[msg.sender]);
222 
223     // SafeMath.sub will throw if there is not enough balance.
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
235   function balanceOf(address _owner) public view returns (uint256 balance) {
236     return balances[_owner];
237   }
238 
239 }
240 
241 contract ERC20 is ERC20Basic {
242   function allowance(address owner, address spender) public view returns (uint256);
243   function transferFrom(address from, address to, uint256 value) public returns (bool);
244   function approve(address spender, uint256 value) public returns (bool);
245   event Approval(address indexed owner, address indexed spender, uint256 value);
246 }
247 
248 contract StandardToken is ERC20, BasicToken {
249 
250   mapping (address => mapping (address => uint256)) internal allowed;
251 
252 
253   /**
254    * @dev Transfer tokens from one address to another
255    * @param _from address The address which you want to send tokens from
256    * @param _to address The address which you want to transfer to
257    * @param _value uint256 the amount of tokens to be transferred
258    */
259   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
260     require(_to != address(0));
261     require(_value <= balances[_from]);
262     require(_value <= allowed[_from][msg.sender]);
263 
264     balances[_from] = balances[_from].sub(_value);
265     balances[_to] = balances[_to].add(_value);
266     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
267     emit Transfer(_from, _to, _value);
268     return true;
269   }
270 
271   /**
272    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
273    *
274    * Beware that changing an allowance with this method brings the risk that someone may use both the old
275    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
276    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
277    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
278    * @param _spender The address which will spend the funds.
279    * @param _value The amount of tokens to be spent.
280    */
281   function approve(address _spender, uint256 _value) public returns (bool) {
282     allowed[msg.sender][_spender] = _value;
283     emit Approval(msg.sender, _spender, _value);
284     return true;
285   }
286 
287   /**
288    * @dev Function to check the amount of tokens that an owner allowed to a spender.
289    * @param _owner address The address which owns the funds.
290    * @param _spender address The address which will spend the funds.
291    * @return A uint256 specifying the amount of tokens still available for the spender.
292    */
293   function allowance(address _owner, address _spender) public view returns (uint256) {
294     return allowed[_owner][_spender];
295   }
296 
297   /**
298    * approve should be called when allowed[_spender] == 0. To increment
299    * allowed value is better to use this function to avoid 2 calls (and wait until
300    * the first transaction is mined)
301    * From MonolithDAO Token.sol
302    */
303   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
304     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
305     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
306     return true;
307   }
308 
309   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
310     uint oldValue = allowed[msg.sender][_spender];
311     if (_subtractedValue > oldValue) {
312       allowed[msg.sender][_spender] = 0;
313     } else {
314       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
315     }
316     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
317     return true;
318   }
319 
320 }
321 
322 contract BurnableToken is StandardToken {
323 
324     event Burn(address indexed burner, uint256 value);
325 
326     /**
327      * @dev Burns a specific amount of tokens.
328      * @param _value The amount of token to be burned.
329      */
330     function burn(uint256 _value) public {
331         require(_value > 0);
332         require(_value <= balances[msg.sender]);
333         // no need to require value <= totalSupply, since that would imply the
334         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
335 
336         address burner = msg.sender;
337         balances[burner] = balances[burner].sub(_value);
338         totalSupply = totalSupply.sub(_value);
339         emit Burn(burner, _value);
340     }
341 }
342 
343 contract PausableToken is StandardToken, Pausable {
344 
345   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
346     return super.transfer(_to, _value);
347   }
348 
349   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
350     return super.transferFrom(_from, _to, _value);
351   }
352 
353   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
354     return super.approve(_spender, _value);
355   }
356 
357   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
358     return super.increaseApproval(_spender, _addedValue);
359   }
360 
361   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
362     return super.decreaseApproval(_spender, _subtractedValue);
363   }
364 }
365 
366 contract ChainToken is PausableToken, BurnableToken {
367 
368     string public constant name = "Chain";
369     string public constant symbol = "CHN";
370     uint8 public constant decimals = 18;
371     uint256 public constant INITIAL_SUPPLY = 100000000 * 10**uint256(decimals);
372     
373     /**
374     * @dev ChainToken Constructor
375     */
376 
377     constructor() public {
378         totalSupply = INITIAL_SUPPLY;   
379         balances[msg.sender] = INITIAL_SUPPLY;
380     }
381 
382     function transferTokens(address beneficiary, uint256 amount) public onlyOwner returns (bool) {
383         require(amount > 0);
384         balances[owner] = balances[owner].sub(amount);
385         balances[beneficiary] = balances[beneficiary].add(amount);
386         emit Transfer(owner, beneficiary, amount);
387 
388         return true;
389     }
390     
391     // ------------------------------------------------------------------------
392 
393     // Owner can transfer out any accidentally sent ERC20 tokens
394 
395     // ------------------------------------------------------------------------
396 
397     function transferAnyERC20Token(address tokenAddress, uint256 tokens) public onlyOwner returns (bool success) {
398 
399         return PausableToken(tokenAddress).transfer(owner, tokens);
400 
401     }
402 
403 }