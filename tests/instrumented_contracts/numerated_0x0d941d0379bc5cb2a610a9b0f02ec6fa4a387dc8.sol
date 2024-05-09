1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * See https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 /**
15  * @title ERC20 interface
16  * @dev see https://github.com/ethereum/EIPs/issues/20
17  */
18 contract ERC20 is ERC20Basic {
19   function allowance(address owner, address spender)
20     public view returns (uint256);
21 
22   function transferFrom(address from, address to, uint256 value)
23     public returns (bool);
24 
25   function approve(address spender, uint256 value) public returns (bool);
26   event Approval(
27     address indexed owner,
28     address indexed spender,
29     uint256 value
30   );
31 }
32 /**
33  * @title SafeMath
34  * @dev Math operations with safety checks that throw on error
35  */
36 library SafeMath {
37 
38   /**
39   * @dev Multiplies two numbers, throws on overflow.
40   */
41   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
42     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
43     // benefit is lost if 'b' is also tested.
44     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
45     if (a == 0) {
46       return 0;
47     }
48 
49     c = a * b;
50     assert(c / a == b);
51     return c;
52   }
53 
54   /**
55   * @dev Integer division of two numbers, truncating the quotient.
56   */
57   function div(uint256 a, uint256 b) internal pure returns (uint256) {
58     // assert(b > 0); // Solidity automatically throws when dividing by 0
59     // uint256 c = a / b;
60     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61     return a / b;
62   }
63 
64   /**
65   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
66   */
67   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68     assert(b <= a);
69     return a - b;
70   }
71 
72   /**
73   * @dev Adds two numbers, throws on overflow.
74   */
75   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
76     c = a + b;
77     assert(c >= a);
78     return c;
79   }
80 }
81 /**
82  * @title Basic token
83  * @dev Basic version of StandardToken, with no allowances.
84  */
85 contract BasicToken is ERC20Basic {
86   using SafeMath for uint256;
87 
88   mapping(address => uint256) balances;
89 
90   uint256 totalSupply_;
91 
92   /**
93   * @dev Total number of tokens in existence
94   */
95   function totalSupply() public view returns (uint256) {
96     return totalSupply_;
97   }
98 
99   /**
100   * @dev Transfer token for a specified address
101   * @param _to The address to transfer to.
102   * @param _value The amount to be transferred.
103   */
104   function transfer(address _to, uint256 _value) public returns (bool) {
105     require(_to != address(0));
106     require(_value <= balances[msg.sender]);
107 
108     balances[msg.sender] = balances[msg.sender].sub(_value);
109     balances[_to] = balances[_to].add(_value);
110     emit Transfer(msg.sender, _to, _value);
111     return true;
112   }
113 
114   /**
115   * @dev Gets the balance of the specified address.
116   * @param _owner The address to query the the balance of.
117   * @return An uint256 representing the amount owned by the passed address.
118   */
119   function balanceOf(address _owner) public view returns (uint256) {
120     return balances[_owner];
121   }
122 
123 }
124 /**
125  * @title Burnable Token
126  * @dev Token that can be irreversibly burned (destroyed).
127  */
128 contract BurnableToken is BasicToken {
129 
130   event Burn(address indexed burner, uint256 value);
131 
132   /**
133    * @dev Burns a specific amount of tokens.
134    * @param _value The amount of token to be burned.
135    */
136   function burn(uint256 _value) public {
137     _burn(msg.sender, _value);
138   }
139 
140   function _burn(address _who, uint256 _value) internal {
141     require(_value <= balances[_who]);
142     // no need to require value <= totalSupply, since that would imply the
143     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
144 
145     balances[_who] = balances[_who].sub(_value);
146     totalSupply_ = totalSupply_.sub(_value);
147     emit Burn(_who, _value);
148     emit Transfer(_who, address(0), _value);
149   }
150 }
151 /**
152  * @title Ownable
153  * @dev The Ownable contract has an owner address, and provides basic authorization control
154  * functions, this simplifies the implementation of "user permissions".
155  */
156 contract Ownable {
157   address public owner;
158 
159 
160   event OwnershipRenounced(address indexed previousOwner);
161   event OwnershipTransferred(
162     address indexed previousOwner,
163     address indexed newOwner
164   );
165 
166 
167   /**
168    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
169    * account.
170    */
171   constructor() public {
172     owner = msg.sender;
173   }
174 
175   /**
176    * @dev Throws if called by any account other than the owner.
177    */
178   modifier onlyOwner() {
179     require(msg.sender == owner);
180     _;
181   }
182 
183   /**
184    * @dev Allows the current owner to relinquish control of the contract.
185    * @notice Renouncing to ownership will leave the contract without an owner.
186    * It will not be possible to call the functions with the `onlyOwner`
187    * modifier anymore.
188    */
189   function renounceOwnership() public onlyOwner {
190     emit OwnershipRenounced(owner);
191     owner = address(0);
192   }
193 
194   /**
195    * @dev Allows the current owner to transfer control of the contract to a newOwner.
196    * @param _newOwner The address to transfer ownership to.
197    */
198   function transferOwnership(address _newOwner) public onlyOwner {
199     _transferOwnership(_newOwner);
200   }
201 
202   /**
203    * @dev Transfers control of the contract to a newOwner.
204    * @param _newOwner The address to transfer ownership to.
205    */
206   function _transferOwnership(address _newOwner) internal {
207     require(_newOwner != address(0));
208     emit OwnershipTransferred(owner, _newOwner);
209     owner = _newOwner;
210   }
211 }
212 /**
213  * @title Standard ERC20 token
214  *
215  * @dev Implementation of the basic standard token.
216  * https://github.com/ethereum/EIPs/issues/20
217  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
218  */
219 contract StandardToken is ERC20, BasicToken {
220 
221   mapping (address => mapping (address => uint256)) internal allowed;
222 
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
238     require(_to != address(0));
239     require(_value <= balances[_from]);
240     require(_value <= allowed[_from][msg.sender]);
241 
242     balances[_from] = balances[_from].sub(_value);
243     balances[_to] = balances[_to].add(_value);
244     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
245     emit Transfer(_from, _to, _value);
246     return true;
247   }
248 
249   /**
250    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
251    * Beware that changing an allowance with this method brings the risk that someone may use both the old
252    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
253    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
254    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
255    * @param _spender The address which will spend the funds.
256    * @param _value The amount of tokens to be spent.
257    */
258   function approve(address _spender, uint256 _value) public returns (bool) {
259     allowed[msg.sender][_spender] = _value;
260     emit Approval(msg.sender, _spender, _value);
261     return true;
262   }
263 
264   /**
265    * @dev Function to check the amount of tokens that an owner allowed to a spender.
266    * @param _owner address The address which owns the funds.
267    * @param _spender address The address which will spend the funds.
268    * @return A uint256 specifying the amount of tokens still available for the spender.
269    */
270   function allowance(
271     address _owner,
272     address _spender
273    )
274     public
275     view
276     returns (uint256)
277   {
278     return allowed[_owner][_spender];
279   }
280 
281   /**
282    * @dev Increase the amount of tokens that an owner allowed to a spender.
283    * approve should be called when allowed[_spender] == 0. To increment
284    * allowed value is better to use this function to avoid 2 calls (and wait until
285    * the first transaction is mined)
286    * From MonolithDAO Token.sol
287    * @param _spender The address which will spend the funds.
288    * @param _addedValue The amount of tokens to increase the allowance by.
289    */
290   function increaseApproval(
291     address _spender,
292     uint256 _addedValue
293   )
294     public
295     returns (bool)
296   {
297     allowed[msg.sender][_spender] = (
298       allowed[msg.sender][_spender].add(_addedValue));
299     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
300     return true;
301   }
302 
303   /**
304    * @dev Decrease the amount of tokens that an owner allowed to a spender.
305    * approve should be called when allowed[_spender] == 0. To decrement
306    * allowed value is better to use this function to avoid 2 calls (and wait until
307    * the first transaction is mined)
308    * From MonolithDAO Token.sol
309    * @param _spender The address which will spend the funds.
310    * @param _subtractedValue The amount of tokens to decrease the allowance by.
311    */
312   function decreaseApproval(
313     address _spender,
314     uint256 _subtractedValue
315   )
316     public
317     returns (bool)
318   {
319     uint256 oldValue = allowed[msg.sender][_spender];
320     if (_subtractedValue > oldValue) {
321       allowed[msg.sender][_spender] = 0;
322     } else {
323       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
324     }
325     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
326     return true;
327   }
328 
329 }
330 /**
331  * @title Standard Burnable Token
332  * @dev Adds burnFrom method to ERC20 implementations
333  */
334 contract StandardBurnableToken is BurnableToken, StandardToken {
335 
336   /**
337    * @dev Burns a specific amount of tokens from the target address and decrements allowance
338    * @param _from address The address which you want to send tokens from
339    * @param _value uint256 The amount of token to be burned
340    */
341   function burnFrom(address _from, uint256 _value) public {
342     require(_value <= allowed[_from][msg.sender]);
343     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
344     // this function needs to emit an event with the updated approval.
345     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
346     _burn(_from, _value);
347   }
348 }
349 
350 contract Teza is StandardBurnableToken {
351 
352     string  public constant name     = "Teza Token";
353     string  public constant symbol   = "TEZ";
354     uint32  public constant decimals = 18;
355 
356     uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals));
357 
358     /**
359     * @dev Constructor that gives msg.sender all of existing tokens.
360     */
361     constructor() public {
362 
363         totalSupply_         = INITIAL_SUPPLY;
364         balances[msg.sender] = INITIAL_SUPPLY;
365 
366         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
367     }
368 }