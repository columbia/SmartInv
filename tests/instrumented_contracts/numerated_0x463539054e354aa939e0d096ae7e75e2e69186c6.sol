1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 contract ERC20 {
8   function totalSupply() public view returns (uint256);
9 
10   function balanceOf(address _who) public view returns (uint256);
11 
12   function allowance(address _owner, address _spender)
13     public view returns (uint256);
14 
15   function transfer(address _to, uint256 _value) public returns (bool);
16 
17   function approve(address _spender, uint256 _value)
18     public returns (bool);
19 
20   function transferFrom(address _from, address _to, uint256 _value)
21     public returns (bool);
22 
23   event Transfer(
24     address indexed from,
25     address indexed to,
26     uint256 value
27   );
28 
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
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
106  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
107  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  */
109 contract StandardToken is ERC20 {
110   using SafeMath for uint256;
111 
112   mapping (address => uint256) private balances;
113 
114   mapping (address => mapping (address => uint256)) private allowed;
115 
116   uint256 private totalSupply_;
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
254   /**
255    * @dev Internal function that mints an amount of the token and assigns it to
256    * an account. This encapsulates the modification of balances such that the
257    * proper events are emitted.
258    * @param _account The account that will receive the created tokens.
259    * @param _amount The amount that will be created.
260    */
261   function _mint(address _account, uint256 _amount) internal {
262     require(_account != 0);
263     totalSupply_ = totalSupply_.add(_amount);
264     balances[_account] = balances[_account].add(_amount);
265     emit Transfer(address(0), _account, _amount);
266   }
267 
268   /**
269    * @dev Internal function that burns an amount of the token of a given
270    * account.
271    * @param _account The account whose tokens will be burnt.
272    * @param _amount The amount that will be burnt.
273    */
274   function _burn(address _account, uint256 _amount) internal {
275     require(_account != 0);
276     require(_amount <= balances[_account]);
277 
278     totalSupply_ = totalSupply_.sub(_amount);
279     balances[_account] = balances[_account].sub(_amount);
280     emit Transfer(_account, address(0), _amount);
281   }
282 
283   /**
284    * @dev Internal function that burns an amount of the token of a given
285    * account, deducting from the sender's allowance for said account. Uses the
286    * internal _burn function.
287    * @param _account The account whose tokens will be burnt.
288    * @param _amount The amount that will be burnt.
289    */
290   function _burnFrom(address _account, uint256 _amount) internal {
291     require(_amount <= allowed[_account][msg.sender]);
292 
293     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
294     // this function needs to emit an event with the updated approval.
295     allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
296     _burn(_account, _amount);
297   }
298 }
299 
300 
301 contract FEEToken is StandardToken {
302   
303   string public constant name = "FEEToken";
304   string public constant symbol = "FEE";
305   uint8 public constant decimals = 18;
306 
307   uint256 private constant INITIAL_SUPPLY = 80000000 * (10 ** uint256(decimals));
308 
309   /**
310    * @dev Constructor that gives msg.sender all of existing tokens.
311    */
312   constructor() public {
313     _mint(msg.sender, INITIAL_SUPPLY);
314   }
315 
316 }