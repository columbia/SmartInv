1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
29     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (a == 0) {
33       return 0;
34     }
35 
36     c = a * b;
37     assert(c / a == b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return a / b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55     assert(b <= a);
56     return a - b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
63     c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) balances;
79 
80   uint256 totalSupply_;
81 
82   /**
83   * @dev total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_to != address(0));
96     require(_value <= balances[msg.sender]);
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
116 
117 /**
118  * @title ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/20
120  */
121 contract ERC20 is ERC20Basic {
122   function allowance(address owner, address spender)
123     public view returns (uint256);
124 
125   function transferFrom(address from, address to, uint256 value)
126     public returns (bool);
127 
128   function approve(address spender, uint256 value) public returns (bool);
129   event Approval(
130     address indexed owner,
131     address indexed spender,
132     uint256 value
133   );
134 }
135 
136 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * @dev https://github.com/ethereum/EIPs/issues/20
143  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(
157     address _from,
158     address _to,
159     uint256 _value
160   )
161     public
162     returns (bool)
163   {
164     require(_to != address(0));
165     require(_value <= balances[_from]);
166     require(_value <= allowed[_from][msg.sender]);
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     emit Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    *
178    * Beware that changing an allowance with this method brings the risk that someone may use both the old
179    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
180    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
181    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
182    * @param _spender The address which will spend the funds.
183    * @param _value The amount of tokens to be spent.
184    */
185   function approve(address _spender, uint256 _value) public returns (bool) {
186     allowed[msg.sender][_spender] = _value;
187     emit Approval(msg.sender, _spender, _value);
188     return true;
189   }
190 
191   /**
192    * @dev Function to check the amount of tokens that an owner allowed to a spender.
193    * @param _owner address The address which owns the funds.
194    * @param _spender address The address which will spend the funds.
195    * @return A uint256 specifying the amount of tokens still available for the spender.
196    */
197   function allowance(
198     address _owner,
199     address _spender
200    )
201     public
202     view
203     returns (uint256)
204   {
205     return allowed[_owner][_spender];
206   }
207 
208   /**
209    * @dev Increase the amount of tokens that an owner allowed to a spender.
210    *
211    * approve should be called when allowed[_spender] == 0. To increment
212    * allowed value is better to use this function to avoid 2 calls (and wait until
213    * the first transaction is mined)
214    * From MonolithDAO Token.sol
215    * @param _spender The address which will spend the funds.
216    * @param _addedValue The amount of tokens to increase the allowance by.
217    */
218   function increaseApproval(
219     address _spender,
220     uint _addedValue
221   )
222     public
223     returns (bool)
224   {
225     allowed[msg.sender][_spender] = (
226       allowed[msg.sender][_spender].add(_addedValue));
227     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228     return true;
229   }
230 
231   /**
232    * @dev Decrease the amount of tokens that an owner allowed to a spender.
233    *
234    * approve should be called when allowed[_spender] == 0. To decrement
235    * allowed value is better to use this function to avoid 2 calls (and wait until
236    * the first transaction is mined)
237    * From MonolithDAO Token.sol
238    * @param _spender The address which will spend the funds.
239    * @param _subtractedValue The amount of tokens to decrease the allowance by.
240    */
241   function decreaseApproval(
242     address _spender,
243     uint _subtractedValue
244   )
245     public
246     returns (bool)
247   {
248     uint oldValue = allowed[msg.sender][_spender];
249     if (_subtractedValue > oldValue) {
250       allowed[msg.sender][_spender] = 0;
251     } else {
252       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
253     }
254     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255     return true;
256   }
257 
258 }
259 
260 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
261 
262 /**
263  * @title Burnable Token
264  * @dev Token that can be irreversibly burned (destroyed).
265  */
266 contract BurnableToken is BasicToken {
267 
268   event Burn(address indexed burner, uint256 value);
269 
270   /**
271    * @dev Burns a specific amount of tokens.
272    * @param _value The amount of token to be burned.
273    */
274   function burn(uint256 _value) public {
275     _burn(msg.sender, _value);
276   }
277 
278   function _burn(address _who, uint256 _value) internal {
279     require(_value <= balances[_who]);
280     // no need to require value <= totalSupply, since that would imply the
281     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
282 
283     balances[_who] = balances[_who].sub(_value);
284     totalSupply_ = totalSupply_.sub(_value);
285     emit Burn(_who, _value);
286     emit Transfer(_who, address(0), _value);
287   }
288 }
289 
290 // File: contracts/BancrypToken.sol
291 
292 /// @title BancrypToken
293 /// @author Bancryp
294 contract BancrypToken is StandardToken, BurnableToken {
295   string public symbol  = "XBANC";
296   string public name    = "XBANC";
297   uint8 public decimals = 18;
298 
299   // Transfers will only be avaiable after the transfer time start
300   // 12/31/2018 @ 11:59pm (UTC)
301   uint256 public constant TRANSFERABLE_START_TIME = 1546300799;
302   
303   // Wallets for tokens split amongst team,
304   // advisors, reserve fund and social cause addresses
305   // Note: Those address will be replaced by the real addresses before the main net deploy
306   address public constant ADVISORS_WALLET     = 0x0fC8c4288841CB199bDdbf385BD762938f5A8328;
307   address public constant BANCRYP_WALLET      = 0xcafBCD7F36ae4506E4331a27CC6CAF12fD35E83C;
308   address public constant FUNDS_WALLET        = 0x66fC388e7AF7ee6198D849A37B89a813d559913a;
309   address public constant RESERVE_FUND_WALLET = 0xb8dc7BfB6D987464b2006aBd6B7511C8D2Ebe50f;
310   address public constant SOCIAL_CAUSE_WALLET = 0xd71383C04F67e2Db7F95aC58c9B2509Cf15AAa95;
311   address public constant TEAM_WALLET         = 0x2b400ee4Ff17dE03453e325e9198E6C9c4F88243;
312 
313   // 300.000.000 in initial supply
314   uint256 public constant INITIAL_SUPPLY = 300000000;
315 
316   // Allows transfer only after TRANSFERABLE_START_TIME
317   // With an exception of the wallets allowed on require function
318   modifier onlyWhenTransferEnabled(address _to) {
319     if ( now <= TRANSFERABLE_START_TIME ) {
320       // Only some wallets to transfer
321       // in case of transfer isn't available yet
322       require(msg.sender == TEAM_WALLET || msg.sender == ADVISORS_WALLET ||
323         msg.sender == RESERVE_FUND_WALLET || msg.sender == SOCIAL_CAUSE_WALLET ||
324         msg.sender == FUNDS_WALLET || msg.sender == BANCRYP_WALLET ||
325         _to == BANCRYP_WALLET, "Forbidden to transfer right now");
326     }
327     _;
328   }
329 
330   // Helper to test valid destion to transfer
331   modifier validDestination(address to) {
332     require(to != address(this));
333     _;
334   }
335 
336   /// @notice Constructor called on deploy of the contract which sets wallets
337   /// for team, advisors, reserve fund and social cause, the rest is are for
338   /// public sale
339   /// will be open to public other than wallets on this constructor
340   constructor() public {  
341     // After the initial supply been split amongst team, advisors, 
342     // reserve and social cause the value available will be 195.000.000
343     totalSupply_ = INITIAL_SUPPLY * (10 ** uint256(decimals));
344     balances[FUNDS_WALLET] = totalSupply_;
345   }
346 
347   /// @dev override transfer token for a specified address to add onlyWhenTransferEnabled
348   /// @param _to The address to transfer to.
349   /// @param _value The amount to be transferred.
350   function transfer(address _to, uint256 _value)
351       public
352       validDestination(_to)
353       onlyWhenTransferEnabled(_to)
354       returns (bool) 
355   {
356       return super.transfer(_to, _value);
357   }
358 
359   /// @dev override transferFrom token for a specified address to add onlyWhenTransferEnabled and validDestination
360   /// @param _from The address to transfer from.
361   /// @param _to The address to transfer to.
362   /// @param _value The amount to be transferred.
363   function transferFrom(address _from, address _to, uint256 _value)
364     public
365     validDestination(_to)
366     onlyWhenTransferEnabled(_to)
367     returns (bool)
368   {
369     return super.transferFrom(_from, _to, _value);
370   }
371 
372   /// @dev Burns a specific amount of tokens.
373   /// @param _value The amount of token to be burned.
374   function burn(uint256 _value) public {
375     require(msg.sender == FUNDS_WALLET, "Only funds wallet can burn");
376     _burn(msg.sender, _value);
377   }
378 }