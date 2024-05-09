1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    * @notice Renouncing to ownership will leave the contract without an owner.
38    * It will not be possible to call the functions with the `onlyOwner`
39    * modifier anymore.
40    */
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address _newOwner) public onlyOwner {
51     _transferOwnership(_newOwner);
52   }
53 
54   /**
55    * @dev Transfers control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function _transferOwnership(address _newOwner) internal {
59     require(_newOwner != address(0));
60     emit OwnershipTransferred(owner, _newOwner);
61     owner = _newOwner;
62   }
63 }
64 
65 /**
66  * @title ERC20Basic
67  * @dev Simpler version of ERC20 interface
68  * See https://github.com/ethereum/EIPs/issues/179
69  */
70 contract ERC20Basic {
71   function totalSupply() public view returns (uint256);
72   function balanceOf(address _who) public view returns (uint256);
73   function transfer(address _to, uint256 _value) public returns (bool);
74   event Transfer(address indexed from, address indexed to, uint256 value);
75 }
76 
77 /**
78  * @title SafeMath
79  * @dev Math operations with safety checks that throw on error
80  */
81 library SafeMath {
82 
83   /**
84   * @dev Multiplies two numbers, throws on overflow.
85   */
86   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
87     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
88     // benefit is lost if 'b' is also tested.
89     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
90     if (_a == 0) {
91       return 0;
92     }
93 
94     c = _a * _b;
95     assert(c / _a == _b);
96     return c;
97   }
98 
99   /**
100   * @dev Integer division of two numbers, truncating the quotient.
101   */
102   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
103     // assert(_b > 0); // Solidity automatically throws when dividing by 0
104     // uint256 c = _a / _b;
105     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
106     return _a / _b;
107   }
108 
109   /**
110   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
111   */
112   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
113     assert(_b <= _a);
114     return _a - _b;
115   }
116 
117   /**
118   * @dev Adds two numbers, throws on overflow.
119   */
120   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
121     c = _a + _b;
122     assert(c >= _a);
123     return c;
124   }
125 }
126 
127 /**
128  * @title Basic token
129  * @dev Basic version of StandardToken, with no allowances.
130  */
131 contract BasicToken is ERC20Basic {
132   using SafeMath for uint256;
133 
134   mapping(address => uint256) internal balances;
135 
136   uint256 internal totalSupply_;
137 
138   /**
139   * @dev Total number of tokens in existence
140   */
141   function totalSupply() public view returns (uint256) {
142     return totalSupply_;
143   }
144 
145   /**
146   * @dev Transfer token for a specified address
147   * @param _to The address to transfer to.
148   * @param _value The amount to be transferred.
149   */
150   function transfer(address _to, uint256 _value) public returns (bool) {
151     require(_value <= balances[msg.sender]);
152     require(_to != address(0));
153 
154     balances[msg.sender] = balances[msg.sender].sub(_value);
155     balances[_to] = balances[_to].add(_value);
156     emit Transfer(msg.sender, _to, _value);
157     return true;
158   }
159 
160   /**
161   * @dev Gets the balance of the specified address.
162   * @param _owner The address to query the the balance of.
163   * @return An uint256 representing the amount owned by the passed address.
164   */
165   function balanceOf(address _owner) public view returns (uint256) {
166     return balances[_owner];
167   }
168 
169 }
170 
171 /**
172  * @title Burnable Token
173  * @dev Token that can be irreversibly burned (destroyed).
174  */
175 contract BurnableToken is BasicToken {
176 
177   event Burn(address indexed burner, uint256 value);
178 
179   /**
180    * @dev Burns a specific amount of tokens.
181    * @param _value The amount of token to be burned.
182    */
183   function burn(uint256 _value) public {
184     _burn(msg.sender, _value);
185   }
186 
187   function _burn(address _who, uint256 _value) internal {
188     require(_value <= balances[_who]);
189     // no need to require value <= totalSupply, since that would imply the
190     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
191 
192     balances[_who] = balances[_who].sub(_value);
193     totalSupply_ = totalSupply_.sub(_value);
194     emit Burn(_who, _value);
195     emit Transfer(_who, address(0), _value);
196   }
197 }
198 
199 /**
200  * @title ERC20 interface
201  * @dev see https://github.com/ethereum/EIPs/issues/20
202  */
203 contract ERC20 is ERC20Basic {
204   function allowance(address _owner, address _spender)
205     public view returns (uint256);
206 
207   function transferFrom(address _from, address _to, uint256 _value)
208     public returns (bool);
209 
210   function approve(address _spender, uint256 _value) public returns (bool);
211   event Approval(
212     address indexed owner,
213     address indexed spender,
214     uint256 value
215   );
216 }
217 
218 /**
219  * @title Standard ERC20 token
220  *
221  * @dev Implementation of the basic standard token.
222  * https://github.com/ethereum/EIPs/issues/20
223  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
224  */
225 contract StandardToken is ERC20, BasicToken {
226 
227   mapping (address => mapping (address => uint256)) internal allowed;
228 
229 
230   /**
231    * @dev Transfer tokens from one address to another
232    * @param _from address The address which you want to send tokens from
233    * @param _to address The address which you want to transfer to
234    * @param _value uint256 the amount of tokens to be transferred
235    */
236   function transferFrom(
237     address _from,
238     address _to,
239     uint256 _value
240   )
241     public
242     returns (bool)
243   {
244     require(_value <= balances[_from]);
245     require(_value <= allowed[_from][msg.sender]);
246     require(_to != address(0));
247 
248     balances[_from] = balances[_from].sub(_value);
249     balances[_to] = balances[_to].add(_value);
250     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
251     emit Transfer(_from, _to, _value);
252     return true;
253   }
254 
255   /**
256    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
257    * Beware that changing an allowance with this method brings the risk that someone may use both the old
258    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
259    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
260    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
261    * @param _spender The address which will spend the funds.
262    * @param _value The amount of tokens to be spent.
263    */
264   function approve(address _spender, uint256 _value) public returns (bool) {
265     allowed[msg.sender][_spender] = _value;
266     emit Approval(msg.sender, _spender, _value);
267     return true;
268   }
269 
270   /**
271    * @dev Function to check the amount of tokens that an owner allowed to a spender.
272    * @param _owner address The address which owns the funds.
273    * @param _spender address The address which will spend the funds.
274    * @return A uint256 specifying the amount of tokens still available for the spender.
275    */
276   function allowance(
277     address _owner,
278     address _spender
279    )
280     public
281     view
282     returns (uint256)
283   {
284     return allowed[_owner][_spender];
285   }
286 
287   /**
288    * @dev Increase the amount of tokens that an owner allowed to a spender.
289    * approve should be called when allowed[_spender] == 0. To increment
290    * allowed value is better to use this function to avoid 2 calls (and wait until
291    * the first transaction is mined)
292    * From MonolithDAO Token.sol
293    * @param _spender The address which will spend the funds.
294    * @param _addedValue The amount of tokens to increase the allowance by.
295    */
296   function increaseApproval(
297     address _spender,
298     uint256 _addedValue
299   )
300     public
301     returns (bool)
302   {
303     allowed[msg.sender][_spender] = (
304       allowed[msg.sender][_spender].add(_addedValue));
305     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
306     return true;
307   }
308 
309   /**
310    * @dev Decrease the amount of tokens that an owner allowed to a spender.
311    * approve should be called when allowed[_spender] == 0. To decrement
312    * allowed value is better to use this function to avoid 2 calls (and wait until
313    * the first transaction is mined)
314    * From MonolithDAO Token.sol
315    * @param _spender The address which will spend the funds.
316    * @param _subtractedValue The amount of tokens to decrease the allowance by.
317    */
318   function decreaseApproval(
319     address _spender,
320     uint256 _subtractedValue
321   )
322     public
323     returns (bool)
324   {
325     uint256 oldValue = allowed[msg.sender][_spender];
326     if (_subtractedValue >= oldValue) {
327       allowed[msg.sender][_spender] = 0;
328     } else {
329       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
330     }
331     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
332     return true;
333   }
334 
335 }
336 
337 contract JewelToken is Ownable, StandardToken, BurnableToken {
338   string public name = 'Jewel';
339   string public symbol = 'JWL';
340   uint8 public decimals = 18;
341   uint256 public totalSupply = 300000000 * 10 ** uint256(decimals);
342 
343   constructor() public {
344     balances[msg.sender] = totalSupply;
345   }
346 }