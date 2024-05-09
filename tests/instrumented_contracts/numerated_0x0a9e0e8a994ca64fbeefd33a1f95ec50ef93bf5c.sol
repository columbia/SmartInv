1 pragma solidity ^0.4.24;
2 
3 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address _who) public view returns (uint256);
13   function transfer(address _to, uint256 _value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: node_modules\zeppelin-solidity\contracts\math\SafeMath.sol
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
28   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
29     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (_a == 0) {
33       return 0;
34     }
35 
36     c = _a * _b;
37     assert(c / _a == _b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
45     // assert(_b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = _a / _b;
47     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
48     return _a / _b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
55     assert(_b <= _a);
56     return _a - _b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
63     c = _a + _b;
64     assert(c >= _a);
65     return c;
66   }
67 }
68 
69 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\BasicToken.sol
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) internal balances;
79 
80   address[] public holders;
81 
82   uint256 internal totalSupply_;
83 
84   /**
85   * @dev Total number of tokens in existence
86   */
87   function totalSupply() public view returns (uint256) {
88     return totalSupply_;
89   }
90   function getHoldersCount() public view returns (uint256) {
91       return holders.length;
92   }
93   /**
94   * @dev Transfer token for a specified address
95   * @param _to The address to transfer to.
96   * @param _value The amount to be transferred.
97   */
98   function transfer(address _to, uint256 _value) public returns (bool) {
99     require(_value <= balances[msg.sender]);
100     require(_to != address(0));
101 
102     balances[msg.sender] = balances[msg.sender].sub(_value);
103     if (balances[_to] == 0) holders.push(_to);
104     balances[_to] = balances[_to].add(_value);
105     emit Transfer(msg.sender, _to, _value);
106     return true;
107   }
108 
109   /**
110   * @dev Gets the balance of the specified address.
111   * @param _owner The address to query the the balance of.
112   * @return An uint256 representing the amount owned by the passed address.
113   */
114   function balanceOf(address _owner) public view returns (uint256) {
115     return balances[_owner];
116   }
117 
118 }
119 
120 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\ERC20.sol
121 
122 /**
123  * @title ERC20 interface
124  * @dev see https://github.com/ethereum/EIPs/issues/20
125  */
126 contract ERC20 is ERC20Basic {
127   function allowance(address _owner, address _spender)
128     public view returns (uint256);
129 
130   function transferFrom(address _from, address _to, uint256 _value)
131     public returns (bool);
132 
133   function approve(address _spender, uint256 _value) public returns (bool);
134   event Approval(
135     address indexed owner,
136     address indexed spender,
137     uint256 value
138   );
139 }
140 
141 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\StandardToken.sol
142 
143 /**
144  * @title Standard ERC20 token
145  *
146  * @dev Implementation of the basic standard token.
147  * https://github.com/ethereum/EIPs/issues/20
148  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
149  */
150 contract StandardToken is ERC20, BasicToken {
151 
152   mapping (address => mapping (address => uint256)) internal allowed;
153 
154 
155   /**
156    * @dev Transfer tokens from one address to another
157    * @param _from address The address which you want to send tokens from
158    * @param _to address The address which you want to transfer to
159    * @param _value uint256 the amount of tokens to be transferred
160    */
161   function transferFrom(
162     address _from,
163     address _to,
164     uint256 _value
165   )
166     public
167     returns (bool)
168   {
169     require(_value <= balances[_from]);
170     require(_value <= allowed[_from][msg.sender]);
171     require(_to != address(0));
172 
173     balances[_from] = balances[_from].sub(_value);
174     if (balances[_to] == 0) holders.push(_to);
175     balances[_to] = balances[_to].add(_value);
176     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
177     emit Transfer(_from, _to, _value);
178     return true;
179   }
180 
181   /**
182    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
183    * Beware that changing an allowance with this method brings the risk that someone may use both the old
184    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
185    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
186    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
187    * @param _spender The address which will spend the funds.
188    * @param _value The amount of tokens to be spent.
189    */
190   function approve(address _spender, uint256 _value) public returns (bool) {
191     allowed[msg.sender][_spender] = _value;
192     emit Approval(msg.sender, _spender, _value);
193     return true;
194   }
195 
196   /**
197    * @dev Function to check the amount of tokens that an owner allowed to a spender.
198    * @param _owner address The address which owns the funds.
199    * @param _spender address The address which will spend the funds.
200    * @return A uint256 specifying the amount of tokens still available for the spender.
201    */
202   function allowance(
203     address _owner,
204     address _spender
205    )
206     public
207     view
208     returns (uint256)
209   {
210     return allowed[_owner][_spender];
211   }
212 
213   /**
214    * @dev Increase the amount of tokens that an owner allowed to a spender.
215    * approve should be called when allowed[_spender] == 0. To increment
216    * allowed value is better to use this function to avoid 2 calls (and wait until
217    * the first transaction is mined)
218    * From MonolithDAO Token.sol
219    * @param _spender The address which will spend the funds.
220    * @param _addedValue The amount of tokens to increase the allowance by.
221    */
222   function increaseApproval(
223     address _spender,
224     uint256 _addedValue
225   )
226     public
227     returns (bool)
228   {
229     allowed[msg.sender][_spender] = (
230       allowed[msg.sender][_spender].add(_addedValue));
231     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
232     return true;
233   }
234 
235   /**
236    * @dev Decrease the amount of tokens that an owner allowed to a spender.
237    * approve should be called when allowed[_spender] == 0. To decrement
238    * allowed value is better to use this function to avoid 2 calls (and wait until
239    * the first transaction is mined)
240    * From MonolithDAO Token.sol
241    * @param _spender The address which will spend the funds.
242    * @param _subtractedValue The amount of tokens to decrease the allowance by.
243    */
244   function decreaseApproval(
245     address _spender,
246     uint256 _subtractedValue
247   )
248     public
249     returns (bool)
250   {
251     uint256 oldValue = allowed[msg.sender][_spender];
252     if (_subtractedValue >= oldValue) {
253       allowed[msg.sender][_spender] = 0;
254     } else {
255       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
256     }
257     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258     return true;
259   }
260 
261 }
262 
263 // File: node_modules\zeppelin-solidity\contracts\ownership\Ownable.sol
264 
265 /**
266  * @title Ownable
267  * @dev The Ownable contract has an owner address, and provides basic authorization control
268  * functions, this simplifies the implementation of "user permissions".
269  */
270 contract Ownable {
271   address public owner;
272 
273 
274   event OwnershipRenounced(address indexed previousOwner);
275   event OwnershipTransferred(
276     address indexed previousOwner,
277     address indexed newOwner
278   );
279 
280 
281   /**
282    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
283    * account.
284    */
285   constructor() public {
286     owner = msg.sender;
287   }
288 
289   /**
290    * @dev Throws if called by any account other than the owner.
291    */
292   modifier onlyOwner() {
293     require(msg.sender == owner);
294     _;
295   }
296 
297   /**
298    * @dev Allows the current owner to relinquish control of the contract.
299    * @notice Renouncing to ownership will leave the contract without an owner.
300    * It will not be possible to call the functions with the `onlyOwner`
301    * modifier anymore.
302    */
303   function renounceOwnership() public onlyOwner {
304     emit OwnershipRenounced(owner);
305     owner = address(0);
306   }
307 
308   /**
309    * @dev Allows the current owner to transfer control of the contract to a newOwner.
310    * @param _newOwner The address to transfer ownership to.
311    */
312   function transferOwnership(address _newOwner) public onlyOwner {
313     _transferOwnership(_newOwner);
314   }
315 
316   /**
317    * @dev Transfers control of the contract to a newOwner.
318    * @param _newOwner The address to transfer ownership to.
319    */
320   function _transferOwnership(address _newOwner) internal {
321     require(_newOwner != address(0));
322     emit OwnershipTransferred(owner, _newOwner);
323     owner = _newOwner;
324   }
325 }
326 
327 // File: contracts\Xirus.sol
328 
329 //solium-disable linebreak-style
330 pragma solidity ^0.4.24;
331 
332 
333 
334 contract Xirus is StandardToken, Ownable {
335 
336     string public constant name = "Xirus"; // solium-disable-line uppercase
337     string public constant symbol = "XIS"; // solium-disable-line uppercase
338     uint8 public constant decimals = 18; // solium-disable-line uppercase
339 
340     uint256 public constant INITIAL_SUPPLY = 88880000 * (10 ** uint256(decimals));
341 
342     constructor() public {
343         totalSupply_ = INITIAL_SUPPLY;
344         balances[msg.sender] = INITIAL_SUPPLY;
345         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
346     }
347 }