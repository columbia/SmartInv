1 pragma solidity 0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (_a == 0) {
17       return 0;
18     }
19 
20     c = _a * _b;
21     assert(c / _a == _b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
29     // assert(_b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = _a / _b;
31     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
32     return _a / _b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
39     assert(_b <= _a);
40     return _a - _b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
47     c = _a + _b;
48     assert(c >= _a);
49     return c;
50   }
51 }
52 
53 
54 /**
55  * @title Ownable
56  * @dev The Ownable contract has an owner address, and provides basic authorization control
57  * functions, this simplifies the implementation of "user permissions".
58  */
59 contract Ownable {
60   address public owner;
61 
62 
63   event OwnershipRenounced(address indexed previousOwner);
64   event OwnershipTransferred(
65     address indexed previousOwner,
66     address indexed newOwner
67   );
68 
69 
70   /**
71    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
72    * account.
73    */
74   constructor() public {
75     owner = msg.sender;
76   }
77 
78   /**
79    * @dev Throws if called by any account other than the owner.
80    */
81   modifier onlyOwner() {
82     require(msg.sender == owner);
83     _;
84   }
85 
86   /**
87    * @dev Allows the current owner to relinquish control of the contract.
88    * @notice Renouncing to ownership will leave the contract without an owner.
89    * It will not be possible to call the functions with the `onlyOwner`
90    * modifier anymore.
91    */
92   function renounceOwnership() public onlyOwner {
93     emit OwnershipRenounced(owner);
94     owner = address(0);
95   }
96 
97   /**
98    * @dev Allows the current owner to transfer control of the contract to a newOwner.
99    * @param _newOwner The address to transfer ownership to.
100    */
101   function transferOwnership(address _newOwner) public onlyOwner {
102     _transferOwnership(_newOwner);
103   }
104 
105   /**
106    * @dev Transfers control of the contract to a newOwner.
107    * @param _newOwner The address to transfer ownership to.
108    */
109   function _transferOwnership(address _newOwner) internal {
110     require(_newOwner != address(0));
111     emit OwnershipTransferred(owner, _newOwner);
112     owner = _newOwner;
113   }
114 }
115 
116 /**
117  * @title ERC20Basic
118  * @dev Simpler version of ERC20 interface
119  * See https://github.com/ethereum/EIPs/issues/179
120  */
121 contract ERC20Basic {
122   function totalSupply() public view returns (uint256);
123   function balanceOf(address _who) public view returns (uint256);
124   function transfer(address _to, uint256 _value) public returns (bool);
125   event Transfer(address indexed from, address indexed to, uint256 value);
126 }
127 
128 
129 /**
130  * @title ERC20 interface
131  * @dev see https://github.com/ethereum/EIPs/issues/20
132  */
133 contract ERC20 is ERC20Basic {
134   function allowance(address _owner, address _spender)
135     public view returns (uint256);
136 
137   function transferFrom(address _from, address _to, uint256 _value)
138     public returns (bool);
139 
140   function approve(address _spender, uint256 _value) public returns (bool);
141   event Approval(
142     address indexed owner,
143     address indexed spender,
144     uint256 value
145   );
146 }
147 
148 
149 /**
150  * @title Basic token
151  * @dev Basic version of StandardToken, with no allowances.
152  */
153 contract BasicToken is ERC20Basic {
154   using SafeMath for uint256;
155 
156   mapping(address => uint256) internal balances;
157 
158   uint256 internal totalSupply_;
159 
160   /**
161   * @dev Total number of tokens in existence
162   */
163   function totalSupply() public view returns (uint256) {
164     return totalSupply_;
165   }
166 
167   /**
168   * @dev Transfer token for a specified address
169   * @param _to The address to transfer to.
170   * @param _value The amount to be transferred.
171   */
172   function transfer(address _to, uint256 _value) public returns (bool) {
173     require(_value <= balances[msg.sender]);
174     require(_to != address(0));
175 
176     balances[msg.sender] = balances[msg.sender].sub(_value);
177     balances[_to] = balances[_to].add(_value);
178     emit Transfer(msg.sender, _to, _value);
179     return true;
180   }
181 
182   /**
183   * @dev Gets the balance of the specified address.
184   * @param _owner The address to query the the balance of.
185   * @return An uint256 representing the amount owned by the passed address.
186   */
187   function balanceOf(address _owner) public view returns (uint256) {
188     return balances[_owner];
189   }
190 
191 }
192 
193 /**
194  * @title Standard ERC20 token
195  *
196  * @dev Implementation of the basic standard token.
197  * https://github.com/ethereum/EIPs/issues/20
198  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
199  */
200 contract StandardToken is ERC20, BasicToken {
201 
202   mapping (address => mapping (address => uint256)) internal allowed;
203 
204 
205   /**
206    * @dev Transfer tokens from one address to another
207    * @param _from address The address which you want to send tokens from
208    * @param _to address The address which you want to transfer to
209    * @param _value uint256 the amount of tokens to be transferred
210    */
211   function transferFrom(
212     address _from,
213     address _to,
214     uint256 _value
215   )
216     public
217     returns (bool)
218   {
219     require(_value <= balances[_from]);
220     require(_value <= allowed[_from][msg.sender]);
221     require(_to != address(0));
222 
223     balances[_from] = balances[_from].sub(_value);
224     balances[_to] = balances[_to].add(_value);
225     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
226     emit Transfer(_from, _to, _value);
227     return true;
228   }
229 
230   /**
231    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
232    * Beware that changing an allowance with this method brings the risk that someone may use both the old
233    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
234    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
235    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
236    * @param _spender The address which will spend the funds.
237    * @param _value The amount of tokens to be spent.
238    */
239   function approve(address _spender, uint256 _value) public returns (bool) {
240     allowed[msg.sender][_spender] = _value;
241     emit Approval(msg.sender, _spender, _value);
242     return true;
243   }
244 
245   /**
246    * @dev Function to check the amount of tokens that an owner allowed to a spender.
247    * @param _owner address The address which owns the funds.
248    * @param _spender address The address which will spend the funds.
249    * @return A uint256 specifying the amount of tokens still available for the spender.
250    */
251   function allowance(
252     address _owner,
253     address _spender
254    )
255     public
256     view
257     returns (uint256)
258   {
259     return allowed[_owner][_spender];
260   }
261 
262   /**
263    * @dev Increase the amount of tokens that an owner allowed to a spender.
264    * approve should be called when allowed[_spender] == 0. To increment
265    * allowed value is better to use this function to avoid 2 calls (and wait until
266    * the first transaction is mined)
267    * From MonolithDAO Token.sol
268    * @param _spender The address which will spend the funds.
269    * @param _addedValue The amount of tokens to increase the allowance by.
270    */
271   function increaseApproval(
272     address _spender,
273     uint256 _addedValue
274   )
275     public
276     returns (bool)
277   {
278     allowed[msg.sender][_spender] = (
279       allowed[msg.sender][_spender].add(_addedValue));
280     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
281     return true;
282   }
283 
284   /**
285    * @dev Decrease the amount of tokens that an owner allowed to a spender.
286    * approve should be called when allowed[_spender] == 0. To decrement
287    * allowed value is better to use this function to avoid 2 calls (and wait until
288    * the first transaction is mined)
289    * From MonolithDAO Token.sol
290    * @param _spender The address which will spend the funds.
291    * @param _subtractedValue The amount of tokens to decrease the allowance by.
292    */
293   function decreaseApproval(
294     address _spender,
295     uint256 _subtractedValue
296   )
297     public
298     returns (bool)
299   {
300     uint256 oldValue = allowed[msg.sender][_spender];
301     if (_subtractedValue >= oldValue) {
302       allowed[msg.sender][_spender] = 0;
303     } else {
304       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
305     }
306     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
307     return true;
308   }
309 
310 }
311 
312 contract Token is StandardToken, Ownable {
313   
314   /**
315    * Variables that define basic token features
316    */ 
317   uint256 public decimals;
318   string public name;
319   string public symbol;
320   uint256 public releasedAmount = 0;
321 
322   constructor(uint256 _totalSupply, uint256 _decimals, string _name, string _symbol) public {
323     require(_totalSupply > 0);
324     require(_decimals > 0);
325 
326     totalSupply_ = _totalSupply;
327     decimals = _decimals;
328     name = _name;
329     symbol = _symbol;
330 
331     balances[msg.sender] = _totalSupply;
332 
333     // transfer all supply to the owner
334     emit Transfer(address(0), msg.sender, _totalSupply);
335   }
336 }