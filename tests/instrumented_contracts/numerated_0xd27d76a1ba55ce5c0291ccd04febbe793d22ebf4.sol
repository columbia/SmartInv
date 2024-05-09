1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * See https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address _who) public view returns (uint256);
12   function transfer(address _to, uint256 _value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22 
23   /**
24   * @dev Multiplies two numbers, throws on overflow.
25   */
26   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
27     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
28     // benefit is lost if 'b' is also tested.
29     if (_a == 0) {
30       return 0;
31     }
32 
33     c = _a * _b;
34     assert(c / _a == _b);
35     return c;
36   }
37 
38   /**
39   * @dev Integer division of two numbers, truncating the quotient.
40   */
41   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
42     // assert(_b > 0); // Solidity automatically throws when dividing by 0
43     // uint256 c = _a / _b;
44     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
45     return _a / _b;
46   }
47 
48   /**
49   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
50   */
51   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
52     assert(_b <= _a);
53     return _a - _b;
54   }
55 
56   /**
57   * @dev Adds two numbers, throws on overflow.
58   */
59   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
60     c = _a + _b;
61     assert(c >= _a);
62     return c;
63   }
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
75   mapping(address => uint256) internal balances;
76 
77   uint256 internal totalSupply_;
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
92     require(_value <= balances[msg.sender]);
93     require(_to != address(0));
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
113 
114 /**
115  * @title ERC20 interface
116  * @dev see https://github.com/ethereum/EIPs/issues/20
117  */
118 contract ERC20 is ERC20Basic {
119   function allowance(address _owner, address _spender)
120     public view returns (uint256);
121 
122   function transferFrom(address _from, address _to, uint256 _value)
123     public returns (bool);
124 
125   function approve(address _spender, uint256 _value) public returns (bool);
126   event Approval(
127     address indexed owner,
128     address indexed spender,
129     uint256 value
130   );
131 }
132 
133 
134 
135 /**
136  * @title Standard ERC20 token
137  *
138  * @dev Implementation of the basic standard token.
139  * https://github.com/ethereum/EIPs/issues/20
140  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
141  */
142 contract StandardToken is ERC20, BasicToken {
143 
144   mapping (address => mapping (address => uint256)) internal allowed;
145 
146 
147   /**
148    * @dev Transfer tokens from one address to another
149    * @param _from address The address which you want to send tokens from
150    * @param _to address The address which you want to transfer to
151    * @param _value uint256 the amount of tokens to be transferred
152    */
153   function transferFrom(
154     address _from,
155     address _to,
156     uint256 _value
157   )
158     public
159     returns (bool)
160   {
161     require(_value <= balances[_from]);
162     require(_value <= allowed[_from][msg.sender]);
163     require(_to != address(0));
164 
165     balances[_from] = balances[_from].sub(_value);
166     balances[_to] = balances[_to].add(_value);
167     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
168     emit Transfer(_from, _to, _value);
169     return true;
170   }
171 
172   /**
173    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
174    * Beware that changing an allowance with this method brings the risk that someone may use both the old
175    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
176    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
177    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
178    * @param _spender The address which will spend the funds.
179    * @param _value The amount of tokens to be spent.
180    */
181   function approve(address _spender, uint256 _value) public returns (bool) {
182     allowed[msg.sender][_spender] = _value;
183     emit Approval(msg.sender, _spender, _value);
184     return true;
185   }
186 
187   /**
188    * @dev Function to check the amount of tokens that an owner allowed to a spender.
189    * @param _owner address The address which owns the funds.
190    * @param _spender address The address which will spend the funds.
191    * @return A uint256 specifying the amount of tokens still available for the spender.
192    */
193   function allowance(
194     address _owner,
195     address _spender
196    )
197     public
198     view
199     returns (uint256)
200   {
201     return allowed[_owner][_spender];
202   }
203 
204   /**
205    * @dev Increase the amount of tokens that an owner allowed to a spender.
206    * approve should be called when allowed[_spender] == 0. To increment
207    * allowed value is better to use this function to avoid 2 calls (and wait until
208    * the first transaction is mined)
209    * From MonolithDAO Token.sol
210    * @param _spender The address which will spend the funds.
211    * @param _addedValue The amount of tokens to increase the allowance by.
212    */
213   function increaseApproval(
214     address _spender,
215     uint256 _addedValue
216   )
217     public
218     returns (bool)
219   {
220     allowed[msg.sender][_spender] = (
221       allowed[msg.sender][_spender].add(_addedValue));
222     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223     return true;
224   }
225 
226   /**
227    * @dev Decrease the amount of tokens that an owner allowed to a spender.
228    * approve should be called when allowed[_spender] == 0. To decrement
229    * allowed value is better to use this function to avoid 2 calls (and wait until
230    * the first transaction is mined)
231    * From MonolithDAO Token.sol
232    * @param _spender The address which will spend the funds.
233    * @param _subtractedValue The amount of tokens to decrease the allowance by.
234    */
235   function decreaseApproval(
236     address _spender,
237     uint256 _subtractedValue
238   )
239     public
240     returns (bool)
241   {
242     uint256 oldValue = allowed[msg.sender][_spender];
243     if (_subtractedValue >= oldValue) {
244       allowed[msg.sender][_spender] = 0;
245     } else {
246       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
247     }
248     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
249     return true;
250   }
251 
252 }
253 
254 
255 
256 /**
257  * @title Ownable
258  * @dev The Ownable contract has an owner address, and provides basic authorization control
259  * functions, this simplifies the implementation of "user permissions".
260  */
261 contract Ownable {
262   address public owner;
263 
264 
265   event OwnershipRenounced(address indexed previousOwner);
266   event OwnershipTransferred(
267     address indexed previousOwner,
268     address indexed newOwner
269   );
270 
271 
272   /**
273    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
274    * account.
275    */
276   constructor() public {
277     owner = msg.sender;
278   }
279 
280   /**
281    * @dev Throws if called by any account other than the owner.
282    */
283   modifier onlyOwner() {
284     require(msg.sender == owner);
285     _;
286   }
287 
288   /**
289    * @dev Allows the current owner to relinquish control of the contract.
290    * @notice Renouncing to ownership will leave the contract without an owner.
291    * It will not be possible to call the functions with the `onlyOwner`
292    * modifier anymore.
293    */
294   function renounceOwnership() public onlyOwner {
295     emit OwnershipRenounced(owner);
296     owner = address(0);
297   }
298 
299   /**
300    * @dev Allows the current owner to transfer control of the contract to a newOwner.
301    * @param _newOwner The address to transfer ownership to.
302    */
303   function transferOwnership(address _newOwner) public onlyOwner {
304     _transferOwnership(_newOwner);
305   }
306 
307   /**
308    * @dev Transfers control of the contract to a newOwner.
309    * @param _newOwner The address to transfer ownership to.
310    */
311   function _transferOwnership(address _newOwner) internal {
312     require(_newOwner != address(0));
313     emit OwnershipTransferred(owner, _newOwner);
314     owner = _newOwner;
315   }
316 }
317 
318 
319 contract BenepitToken is StandardToken, Ownable {
320     string public name = "Benepit";
321     string public symbol = "BNP";
322     uint8 public decimals = 18;
323     constructor() public {
324       totalSupply_ = 30000000000 * 10**uint(decimals);
325       balances[msg.sender] = totalSupply_;
326     }
327 }