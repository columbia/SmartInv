1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return a / b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48     c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 
55 /**
56  * @title ERC20Basic
57  * @dev Simpler version of ERC20 interface
58  * See https://github.com/ethereum/EIPs/issues/179
59  */
60 contract ERC20Basic {
61   function totalSupply() public view returns (uint256);
62   function balanceOf(address who) public view returns (uint256);
63   function transfer(address to, uint256 value) public returns (bool);
64   event Transfer(address indexed from, address indexed to, uint256 value);
65 }
66 
67 
68 
69 
70 /**
71  * @title Basic token
72  * @dev Basic version of StandardToken, with no allowances.
73  */
74 contract BCIOBasicToken is ERC20Basic {
75   using SafeMath for uint256;
76 
77   mapping(address => uint256) balances;
78 
79   uint256 totalSupply_;
80 
81   /**
82   * @dev total number of tokens in existence
83   */
84   function totalSupply() public view returns (uint256) {
85     return totalSupply_;
86   }
87 
88   /**
89   * @dev transfer token for a specified address
90   * @param _to The address to transfer to.
91   * @param _value The amount to be transferred.
92   */
93   function transfer(address _to, uint256 _value) public returns (bool) {
94     require(_to != address(0), "0x0 address not accepted");
95     require(_to != address(this), "This contract address not accepted");
96     require(_value <= balances[msg.sender], "Not enouth balance");
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
115 
116 /**
117  * @title Claimable
118  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
119  * This allows the new owner to accept the transfer.
120  */
121 contract BCIOClaimable {
122   address public owner;
123   address public pendingOwner;
124 
125   event OwnershipTransferred(
126     address indexed previousOwner,
127     address indexed newOwner
128   );
129 
130   /**
131    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
132    * account.
133    */
134   constructor() public {
135     owner = msg.sender;
136   }
137   
138   /**
139    * @dev Throws if called by any account other than the owner.
140    */
141   modifier onlyOwner() {
142     require(msg.sender == owner, "Must be owner");
143     _;
144   }
145 
146   /**
147    * @dev Modifier throws if called by any account other than the pendingOwner.
148    */
149   modifier onlyPendingOwner() {
150     require(msg.sender == pendingOwner, "Must be pendingOwner");
151     _;
152   }
153 
154   /**
155    * @dev Allows the current owner to set the pendingOwner address.
156    * @param newOwner The address to transfer ownership to.
157    */
158   function transferOwnership(address newOwner) public onlyOwner {
159     pendingOwner = newOwner;
160   }
161 
162   /**
163    * @dev Allows the pendingOwner address to finalize the transfer.
164    */
165   function claimOwnership() public onlyPendingOwner {
166     emit OwnershipTransferred(owner, pendingOwner);
167     owner = pendingOwner;
168     pendingOwner = address(0);
169   }
170 }
171 
172 
173 /**
174  * @title ERC20 interface
175  * @dev see https://github.com/ethereum/EIPs/issues/20
176  */
177 contract ERC20 is ERC20Basic {
178   function allowance(address owner, address spender)
179     public view returns (uint256);
180 
181   function transferFrom(address from, address to, uint256 value)
182     public returns (bool);
183 
184   function approve(address spender, uint256 value) public returns (bool);
185   event Approval(
186     address indexed owner,
187     address indexed spender,
188     uint256 value
189   );
190 }
191 
192 
193 /**
194  * @title BCIOStandardToken
195  * @dev Implementation of the basic standard token.
196  * @dev https://github.com/ethereum/EIPs/issues/20
197  */
198 contract BCIOStandardToken is ERC20, BCIOBasicToken {
199 
200   mapping (address => mapping (address => uint256)) internal allowed;
201 
202   /**
203    * @dev Transfer tokens from one address to another
204    * @param _from address The address which you want to send tokens from
205    * @param _to address The address which you want to transfer to
206    * @param _value uint256 the amount of tokens to be transferred
207    */
208   function transferFrom(
209     address _from,
210     address _to,
211     uint256 _value
212   )
213     public
214     returns (bool)
215   {
216     require(_to != address(0), "0x0 address not accepted");
217     require(_to != address(this), "This contract address not accepted");
218     require(_value <= balances[_from], "Not enouth balance");
219     require(_value <= allowed[_from][msg.sender], "Not enouth allowed");
220 
221     balances[_from] = balances[_from].sub(_value);
222     balances[_to] = balances[_to].add(_value);
223     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
224     emit Transfer(_from, _to, _value);
225     return true;
226   }
227 
228   /**
229    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
230    *
231    * Beware that changing an allowance with this method brings the risk that someone may use both the old
232    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
233    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
234    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
235    * @param _spender The address which will spend the funds.
236    * @param _value The amount of tokens to be spent.
237    */
238   function approve(address _spender, uint256 _value) public returns (bool) {
239     require((_value == 0) || (allowed[msg.sender][_spender] == 0), "Must approve 0 first"); // solium-disable-line max-len
240 
241     allowed[msg.sender][_spender] = _value;
242     emit Approval(msg.sender, _spender, _value);
243     return true;
244   }
245 
246   /**
247    * @dev Function to check the amount of tokens that an owner allowed to a spender.
248    * @param _owner address The address which owns the funds.
249    * @param _spender address The address which will spend the funds.
250    * @return A uint256 specifying the amount of tokens still available for the spender.
251    */
252   function allowance(
253     address _owner,
254     address _spender
255    )
256     public
257     view
258     returns (uint256)
259   {
260     return allowed[_owner][_spender];
261   }
262 
263   /**
264    * @dev Increase the amount of tokens that an owner allowed to a spender.
265    *
266    * approve should be called when allowed[_spender] == 0. To increment
267    * allowed value is better to use this function to avoid 2 calls (and wait until
268    * the first transaction is mined)
269    * From MonolithDAO Token.sol
270    * @param _spender The address which will spend the funds.
271    * @param _addedValue The amount of tokens to increase the allowance by.
272    */
273   function increaseApproval(
274     address _spender,
275     uint _addedValue
276   )
277     public
278     returns (bool)
279   {
280     allowed[msg.sender][_spender] = (
281       allowed[msg.sender][_spender].add(_addedValue));
282     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
283     return true;
284   }
285 
286   /**
287    * @dev Decrease the amount of tokens that an owner allowed to a spender.
288    *
289    * approve should be called when allowed[_spender] == 0. To decrement
290    * allowed value is better to use this function to avoid 2 calls (and wait until
291    * the first transaction is mined)
292    * From MonolithDAO Token.sol
293    * @param _spender The address which will spend the funds.
294    * @param _subtractedValue The amount of tokens to decrease the allowance by.
295    */
296   function decreaseApproval(
297     address _spender,
298     uint _subtractedValue
299   )
300     public
301     returns (bool)
302   {
303     uint oldValue = allowed[msg.sender][_spender];
304     if (_subtractedValue >= oldValue) {
305       allowed[msg.sender][_spender] = 0;
306     } else {
307       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
308     }
309     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
310     return true;
311   }
312 
313 }
314 
315 /**
316  * @title Burnable Token
317  * @dev Token that can be irreversibly burned (destroyed).
318  */
319 contract BCIOBurnableToken is BCIOStandardToken, BCIOClaimable {
320 
321   event Burn(address indexed burner, uint256 value);
322 
323   /**
324    * @dev Burns a specific amount of tokens.
325    * @param _value The amount of token to be burned.
326    */
327   function burn(uint256 _value) public onlyOwner {
328     _burn(msg.sender, _value);
329   }
330 
331   /**
332    * @dev Burns a specific amount of tokens from the target address and decrements allowance
333    * @param _from address The address which you want to send tokens from
334    * @param _value uint256 The amount of token to be burned
335    */
336   function burnFrom(address _from, uint256 _value) public onlyOwner {
337     require(_value <= allowed[_from][msg.sender], "Not enouth allowed");
338     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
339     _burn(_from, _value);
340   }
341 
342   function _burn(address _who, uint256 _value) internal {
343     require(_value <= balances[_who], "Not enouth balance");
344     // no need to require value <= totalSupply, since that would imply the
345     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
346 
347     balances[_who] = balances[_who].sub(_value);
348     totalSupply_ = totalSupply_.sub(_value);
349     emit Burn(_who, _value);
350     emit Transfer(_who, address(0), _value);
351   }
352 }
353 
354 /**
355  * @title BCIOToken
356  * @dev 
357  */
358 contract BCIOToken is BCIOBurnableToken {
359   string public constant version = "1.0"; // solium-disable-line uppercase
360 
361   string public constant name = "Blockchain.io"; // solium-disable-line uppercase, max-len
362   string public constant symbol = "BCIO"; // solium-disable-line uppercase 
363   uint8 public constant decimals = 18; // solium-disable-line uppercase
364 
365   // 200M tokens => 200000000
366   uint256 public constant INITIAL_SUPPLY = 100 * (10 ** 6) * (10 ** uint256(decimals)); // solium-disable-line max-len
367 
368   /**
369    * @dev Constructor that gives msg.sender all of existing tokens.
370    */
371   constructor() public {
372     totalSupply_ = INITIAL_SUPPLY;
373     balances[msg.sender] = INITIAL_SUPPLY;
374     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
375   }
376 
377 }