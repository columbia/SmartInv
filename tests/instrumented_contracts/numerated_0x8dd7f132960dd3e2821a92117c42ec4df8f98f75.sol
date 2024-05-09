1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() public {
35     owner = msg.sender;
36   }
37 
38   /**
39    * @dev Throws if called by any account other than the owner.
40    */
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address newOwner) public onlyOwner {
51     require(newOwner != address(0));
52     OwnershipTransferred(owner, newOwner);
53     owner = newOwner;
54   }
55 
56 }
57 
58 
59 
60 
61 
62 
63 
64 
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
80   * @dev total number of tokens in existence
81   */
82   function totalSupply() public view returns (uint256) {
83     return totalSupply_;
84   }
85 
86   /**
87   * @dev transfer token for a specified address
88   * @param _to The address to transfer to.
89   * @param _value The amount to be transferred.
90   */
91   function transfer(address _to, uint256 _value) public returns (bool) {
92     require(_to != address(0));
93     require(_value <= balances[msg.sender]);
94 
95     // SafeMath.sub will throw if there is not enough balance.
96     balances[msg.sender] = balances[msg.sender].sub(_value);
97     balances[_to] = balances[_to].add(_value);
98     Transfer(msg.sender, _to, _value);
99     return true;
100   }
101 
102   /**
103   * @dev Gets the balance of the specified address.
104   * @param _owner The address to query the the balance of.
105   * @return An uint256 representing the amount owned by the passed address.
106   */
107   function balanceOf(address _owner) public view returns (uint256 balance) {
108     return balances[_owner];
109   }
110 
111 }
112 
113 
114 
115 
116 
117 
118 /**
119  * @title ERC20 interface
120  * @dev see https://github.com/ethereum/EIPs/issues/20
121  */
122 contract ERC20 is ERC20Basic {
123   function allowance(address owner, address spender) public view returns (uint256);
124   function transferFrom(address from, address to, uint256 value) public returns (bool);
125   function approve(address spender, uint256 value) public returns (bool);
126   event Approval(address indexed owner, address indexed spender, uint256 value);
127 }
128 
129 
130 
131 /**
132  * @title Standard ERC20 token
133  *
134  * @dev Implementation of the basic standard token.
135  * @dev https://github.com/ethereum/EIPs/issues/20
136  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
137  */
138 contract StandardToken is ERC20, BasicToken {
139 
140   mapping (address => mapping (address => uint256)) internal allowed;
141 
142 
143   /**
144    * @dev Transfer tokens from one address to another
145    * @param _from address The address which you want to send tokens from
146    * @param _to address The address which you want to transfer to
147    * @param _value uint256 the amount of tokens to be transferred
148    */
149   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
150     require(_to != address(0));
151     require(_value <= balances[_from]);
152     require(_value <= allowed[_from][msg.sender]);
153 
154     balances[_from] = balances[_from].sub(_value);
155     balances[_to] = balances[_to].add(_value);
156     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
157     Transfer(_from, _to, _value);
158     return true;
159   }
160 
161   /**
162    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
163    *
164    * Beware that changing an allowance with this method brings the risk that someone may use both the old
165    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
166    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
167    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168    * @param _spender The address which will spend the funds.
169    * @param _value The amount of tokens to be spent.
170    */
171   function approve(address _spender, uint256 _value) public returns (bool) {
172     allowed[msg.sender][_spender] = _value;
173     Approval(msg.sender, _spender, _value);
174     return true;
175   }
176 
177   /**
178    * @dev Function to check the amount of tokens that an owner allowed to a spender.
179    * @param _owner address The address which owns the funds.
180    * @param _spender address The address which will spend the funds.
181    * @return A uint256 specifying the amount of tokens still available for the spender.
182    */
183   function allowance(address _owner, address _spender) public view returns (uint256) {
184     return allowed[_owner][_spender];
185   }
186 
187   /**
188    * @dev Increase the amount of tokens that an owner allowed to a spender.
189    *
190    * approve should be called when allowed[_spender] == 0. To increment
191    * allowed value is better to use this function to avoid 2 calls (and wait until
192    * the first transaction is mined)
193    * From MonolithDAO Token.sol
194    * @param _spender The address which will spend the funds.
195    * @param _addedValue The amount of tokens to increase the allowance by.
196    */
197   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
198     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
199     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
200     return true;
201   }
202 
203   /**
204    * @dev Decrease the amount of tokens that an owner allowed to a spender.
205    *
206    * approve should be called when allowed[_spender] == 0. To decrement
207    * allowed value is better to use this function to avoid 2 calls (and wait until
208    * the first transaction is mined)
209    * From MonolithDAO Token.sol
210    * @param _spender The address which will spend the funds.
211    * @param _subtractedValue The amount of tokens to decrease the allowance by.
212    */
213   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
214     uint oldValue = allowed[msg.sender][_spender];
215     if (_subtractedValue > oldValue) {
216       allowed[msg.sender][_spender] = 0;
217     } else {
218       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
219     }
220     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
221     return true;
222   }
223 
224 }
225 
226 
227 
228 
229 
230 
231 /**
232  * @title Burnable Token
233  * @dev Token that can be irreversibly burned (destroyed).
234  */
235 contract BurnableToken is BasicToken {
236 
237   event Burn(address indexed burner, uint256 value);
238 
239   /**
240    * @dev Burns a specific amount of tokens.
241    * @param _value The amount of token to be burned.
242    */
243   function burn(uint256 _value) public {
244     require(_value <= balances[msg.sender]);
245     // no need to require value <= totalSupply, since that would imply the
246     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
247 
248     address burner = msg.sender;
249     balances[burner] = balances[burner].sub(_value);
250     totalSupply_ = totalSupply_.sub(_value);
251     Burn(burner, _value);
252   }
253 }
254 
255 
256 
257 
258 
259 /**
260  * @title SafeMath
261  * @dev Math operations with safety checks that throw on error
262  */
263 library SafeMath {
264 
265   /**
266   * @dev Multiplies two numbers, throws on overflow.
267   */
268   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
269     if (a == 0) {
270       return 0;
271     }
272     uint256 c = a * b;
273     assert(c / a == b);
274     return c;
275   }
276 
277   /**
278   * @dev Integer division of two numbers, truncating the quotient.
279   */
280   function div(uint256 a, uint256 b) internal pure returns (uint256) {
281     // assert(b > 0); // Solidity automatically throws when dividing by 0
282     uint256 c = a / b;
283     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
284     return c;
285   }
286 
287   /**
288   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
289   */
290   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
291     assert(b <= a);
292     return a - b;
293   }
294 
295   /**
296   * @dev Adds two numbers, throws on overflow.
297   */
298   function add(uint256 a, uint256 b) internal pure returns (uint256) {
299     uint256 c = a + b;
300     assert(c >= a);
301     return c;
302   }
303 }
304 
305 
306 /**
307  * The (HMC - Home Chain) has a fixed supply
308  *
309  * The owner can associate the token with a token sale contract. In that
310  * case, the token balance is moved to the token sale contract, which
311  * in turn can transfer its tokens to contributors to the sale.
312  */
313 contract HomeChainToken is StandardToken, BurnableToken, Ownable {
314 
315     // Constants
316     string  public constant name = "Home Chain";
317     string  public constant symbol = "HMC";
318     uint8   public constant decimals = 18;
319     //string  public website = ""; 
320     uint256 public constant INITIAL_SUPPLY      =  100000000 * (10 ** uint256(decimals));
321     //uint256 public constant CROWDSALE_ALLOWANCE =  160000000 * (10 ** uint256(decimals));
322     uint256 public constant ADMIN_ALLOWANCE     =  100000000 * (10 ** uint256(decimals));
323 
324     // Properties
325     uint256 public totalSupply;
326     //uint256 public crowdSaleAllowance;      // the number of tokens available for crowdsales
327     uint256 public adminAllowance;          // the number of tokens available for the administrator
328     //address public crowdSaleAddr;           // the address of a crowdsale currently selling this token
329     address public adminAddr;               // the address of a crowdsale currently selling this token
330     //bool    public transferEnabled = false; // indicates if transferring tokens is enabled or not
331     bool    public transferEnabled = true;  // Enables everyone to transfer tokens 
332 
333     // Modifiers
334 
335     /**
336      * The listed addresses are not valid recipients of tokens.
337      *
338      * 0x0           - the zero address is not valid
339      * this          - the contract itself should not receive tokens
340      * owner         - the owner has all the initial tokens, but cannot receive any back
341      * adminAddr     - the admin has an allowance of tokens to transfer, but does not receive any
342      * crowdSaleAddr - the crowdsale has an allowance of tokens to transfer, but does not receive any
343      */
344     modifier validDestination(address _to) {
345         require(_to != address(0x0));
346         require(_to != address(this));
347         require(_to != owner);
348         require(_to != address(adminAddr));
349         //require(_to != address(crowdSaleAddr));
350         _;
351     }
352 
353     /**
354      * Constructor - instantiates token supply and allocates balanace of
355      * to the owner (msg.sender).
356      */
357     function HomeChainToken(address _admin) public {
358         // the owner is a custodian of tokens that can
359         // give an allowance of tokens for crowdsales
360         // or to the admin, but cannot itself transfer
361         // tokens; hence, this requirement
362         require(msg.sender != _admin);
363 
364         totalSupply = INITIAL_SUPPLY;
365         //crowdSaleAllowance = CROWDSALE_ALLOWANCE;
366         adminAllowance = ADMIN_ALLOWANCE;
367 
368         // mint all tokens
369         //balances[msg.sender] = totalSupply.sub(adminAllowance);
370         //Transfer(address(0x0), msg.sender, totalSupply.sub(adminAllowance));
371 
372         balances[_admin] = adminAllowance;
373         Transfer(address(0x0), _admin, adminAllowance);
374 
375         adminAddr = _admin;
376         approve(adminAddr, adminAllowance);
377     }
378 
379     /**
380      * Overrides ERC20 transfer function with modifier that prevents the
381      * ability to transfer tokens until after transfers have been enabled.
382      */
383     function transfer(address _to, uint256 _value) public validDestination(_to) returns (bool) {
384         return super.transfer(_to, _value);
385     }
386 
387 
388     /**
389      * Overrides the burn function so that it cannot be called until after
390      * transfers have been enabled.
391      *
392      * @param _value    The amount of tokens to burn in wei-HMC
393      */
394     function burn(uint256 _value) public {
395         require(transferEnabled || msg.sender == owner || msg.sender == adminAddr);
396         super.burn(_value);
397         Transfer(msg.sender, address(0x0), _value);
398     }
399 
400 }