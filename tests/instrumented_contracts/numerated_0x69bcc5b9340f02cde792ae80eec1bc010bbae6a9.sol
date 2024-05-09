1 pragma solidity ^0.4.24;
2 pragma experimental "v0.5.0";
3 
4 /**
5  * @title ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 contract ERC20 {
9   function totalSupply() public view returns (uint256);
10 
11   function balanceOf(address _who) public view returns (uint256);
12 
13   function allowance(address _owner, address _spender)
14     public view returns (uint256);
15 
16   function transfer(address _to, uint256 _value) public returns (bool);
17 
18   function approve(address _spender, uint256 _value)
19     public returns (bool);
20 
21   function transferFrom(address _from, address _to, uint256 _value)
22     public returns (bool);
23 
24   event Transfer(
25     address indexed from,
26     address indexed to,
27     uint256 value
28   );
29 
30   event Approval(
31     address indexed owner,
32     address indexed spender,
33     uint256 value
34   );
35 }
36 
37 /**
38  * @title SafeMath
39  * @dev Math operations with safety checks that revert on error
40  */
41 library SafeMath {
42 
43   /**
44   * @dev Multiplies two numbers, reverts on overflow.
45   */
46   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
47     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
48     // benefit is lost if 'b' is also tested.
49     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
50     if (_a == 0) {
51       return 0;
52     }
53 
54     uint256 c = _a * _b;
55     require(c / _a == _b);
56 
57     return c;
58   }
59 
60   /**
61   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
62   */
63   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
64     require(_b > 0); // Solidity only automatically asserts when dividing by 0
65     uint256 c = _a / _b;
66     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
67 
68     return c;
69   }
70 
71   /**
72   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
73   */
74   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
75     require(_b <= _a);
76     uint256 c = _a - _b;
77 
78     return c;
79   }
80 
81   /**
82   * @dev Adds two numbers, reverts on overflow.
83   */
84   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
85     uint256 c = _a + _b;
86     require(c >= _a);
87 
88     return c;
89   }
90 
91   /**
92   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
93   * reverts when dividing by zero.
94   */
95   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
96     require(b != 0);
97     return a % b;
98   }
99 }
100 
101 
102 /**
103  * @title Standard ERC20 token
104  *
105  * @dev Implementation of the basic standard token.
106  * https://github.com/ethereum/EIPs/issues/20
107  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  */
109 contract StandardToken is ERC20 {
110   using SafeMath for uint256;
111 
112   mapping(address => uint256) balances;
113 
114   mapping (address => mapping (address => uint256)) internal allowed;
115 
116   uint256 totalSupply_;
117 
118   /**
119   * @dev Total number of tokens in existence
120   */
121   function totalSupply() public view returns (uint256) {
122     return totalSupply_;
123   }
124 
125   /**
126   * @dev Gets the balance of the specified address.
127   * @param _owner The address to query the the balance of.
128   * @return An uint256 representing the amount owned by the passed address.
129   */
130   function balanceOf(address _owner) public view returns (uint256) {
131     return balances[_owner];
132   }
133 
134   /**
135    * @dev Function to check the amount of tokens that an owner allowed to a spender.
136    * @param _owner address The address which owns the funds.
137    * @param _spender address The address which will spend the funds.
138    * @return A uint256 specifying the amount of tokens still available for the spender.
139    */
140   function allowance(
141     address _owner,
142     address _spender
143    )
144     public
145     view
146     returns (uint256)
147   {
148     return allowed[_owner][_spender];
149   }
150 
151   /**
152   * @dev Transfer token for a specified address
153   * @param _to The address to transfer to.
154   * @param _value The amount to be transferred.
155   */
156   function transfer(address _to, uint256 _value) public returns (bool) {
157     require(_value <= balances[msg.sender]);
158     require(_to != address(0));
159 
160     balances[msg.sender] = balances[msg.sender].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     emit Transfer(msg.sender, _to, _value);
163     return true;
164   }
165 
166   /**
167    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
168    * Beware that changing an allowance with this method brings the risk that someone may use both the old
169    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
170    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
171    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172    * @param _spender The address which will spend the funds.
173    * @param _value The amount of tokens to be spent.
174    */
175   function approve(address _spender, uint256 _value) public returns (bool) {
176     allowed[msg.sender][_spender] = _value;
177     emit Approval(msg.sender, _spender, _value);
178     return true;
179   }
180 
181   /**
182    * @dev Transfer tokens from one address to another
183    * @param _from address The address which you want to send tokens from
184    * @param _to address The address which you want to transfer to
185    * @param _value uint256 the amount of tokens to be transferred
186    */
187   function transferFrom(
188     address _from,
189     address _to,
190     uint256 _value
191   )
192     public
193     returns (bool)
194   {
195     require(_value <= balances[_from]);
196     require(_value <= allowed[_from][msg.sender]);
197     require(_to != address(0));
198 
199     balances[_from] = balances[_from].sub(_value);
200     balances[_to] = balances[_to].add(_value);
201     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
202     emit Transfer(_from, _to, _value);
203     return true;
204   }
205 
206   /**
207    * @dev Increase the amount of tokens that an owner allowed to a spender.
208    * approve should be called when allowed[_spender] == 0. To increment
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param _spender The address which will spend the funds.
213    * @param _addedValue The amount of tokens to increase the allowance by.
214    */
215   function increaseApproval(
216     address _spender,
217     uint256 _addedValue
218   )
219     public
220     returns (bool)
221   {
222     allowed[msg.sender][_spender] = (
223       allowed[msg.sender][_spender].add(_addedValue));
224     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225     return true;
226   }
227 
228   /**
229    * @dev Decrease the amount of tokens that an owner allowed to a spender.
230    * approve should be called when allowed[_spender] == 0. To decrement
231    * allowed value is better to use this function to avoid 2 calls (and wait until
232    * the first transaction is mined)
233    * From MonolithDAO Token.sol
234    * @param _spender The address which will spend the funds.
235    * @param _subtractedValue The amount of tokens to decrease the allowance by.
236    */
237   function decreaseApproval(
238     address _spender,
239     uint256 _subtractedValue
240   )
241     public
242     returns (bool)
243   {
244     uint256 oldValue = allowed[msg.sender][_spender];
245     if (_subtractedValue >= oldValue) {
246       allowed[msg.sender][_spender] = 0;
247     } else {
248       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
249     }
250     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251     return true;
252   }
253 
254 }
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
318 contract DetailedStandardToken is StandardToken {
319   string public name;
320   string public symbol;
321   uint8 public decimals;
322 
323   constructor(string _name, string _symbol, uint8 _decimals) public {
324     name = _name;
325     symbol = _symbol;
326     decimals = _decimals;
327   }
328 }
329 
330 contract NovovivoToken is DetailedStandardToken, Ownable {
331     constructor() DetailedStandardToken("Novovivo Token Test", "NVT", 18) public {
332         totalSupply_ = 8 * 10**9 * 10**uint256(decimals);
333         balances[address(this)] = totalSupply_;
334     }
335     
336     function send(address _to, uint256 _value) onlyOwner public returns (bool) {
337         uint256 value = _value.mul(10 ** uint256(decimals));
338         
339         ERC20 token;
340         token = ERC20(address(this));
341         return token.transfer(_to, value);
342     }
343     
344     function stopTest() onlyOwner public {
345         selfdestruct(owner);
346     }
347     
348     function () external {
349         revert();
350     }
351 }