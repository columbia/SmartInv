1 pragma solidity ^0.4.25;
2 
3 
4 /////////////////////////// import "./IERC20.sol"; /////////////////////////
5 
6 /**
7  * @title ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/20
9  */
10 interface IERC20 {
11   function totalSupply() public view returns (uint256);
12 
13   function balanceOf(address _who) public view returns (uint256);
14 
15   function allowance(address _owner, address _spender)
16     public view returns (uint256);
17 
18   function transfer(address _to, uint256 _value) public returns (bool);
19 
20   function approve(address _spender, uint256 _value)
21     public returns (bool);
22 
23   function transferFrom(address _from, address _to, uint256 _value)
24     public returns (bool);
25 
26   event Transfer(
27     address indexed from,
28     address indexed to,
29     uint256 value
30   );
31 
32   event Approval(
33     address indexed owner,
34     address indexed spender,
35     uint256 value
36   );
37 }
38 
39 
40 //////////////////////  "../../math/SafeMath.sol" ///////////////////////
41 
42 /**
43  * @title SafeMath
44  * @dev Math operations with safety checks that revert on error
45  */
46 library SafeMath {
47 
48   /**
49   * @dev Multiplies two numbers, reverts on overflow.
50   */
51   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
52     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
53     // benefit is lost if 'b' is also tested.
54     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
55     if (_a == 0) {
56       return 0;
57     }
58 
59     uint256 c = _a * _b;
60     require(c / _a == _b);
61 
62     return c;
63   }
64 
65   /**
66   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
67   */
68   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
69     require(_b > 0); // Solidity only automatically asserts when dividing by 0
70     uint256 c = _a / _b;
71     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
72 
73     return c;
74   }
75 
76   /**
77   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
78   */
79   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
80     require(_b <= _a);
81     uint256 c = _a - _b;
82 
83     return c;
84   }
85 
86   /**
87   * @dev Adds two numbers, reverts on overflow.
88   */
89   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
90     uint256 c = _a + _b;
91     require(c >= _a);
92 
93     return c;
94   }
95 
96   /**
97   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
98   * reverts when dividing by zero.
99   */
100   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
101     require(b != 0);
102     return a % b;
103   }
104 }
105 
106 
107 /////////////////////////////////////"../token/ERC20/ERC20.sol"///////////////////////////////
108 
109 /**
110  * @title Standard ERC20 token
111  *
112  * @dev Implementation of the basic standard token.
113  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
114  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
115  */
116 contract ERC20 is IERC20 {
117   using SafeMath for uint256;
118 
119   mapping (address => uint256) private balances_;
120 
121   mapping (address => mapping (address => uint256)) private allowed_;
122 
123   uint256 private totalSupply_;
124 
125   /**
126   * @dev Total number of tokens in existence
127   */
128   function totalSupply() public view returns (uint256) {
129     return totalSupply_;
130   }
131 
132   /**
133   * @dev Gets the balance of the specified address.
134   * @param _owner The address to query the the balance of.
135   * @return An uint256 representing the amount owned by the passed address.
136   */
137   function balanceOf(address _owner) public view returns (uint256) {
138     return balances_[_owner];
139   }
140 
141   /**
142    * @dev Function to check the amount of tokens that an owner allowed to a spender.
143    * @param _owner address The address which owns the funds.
144    * @param _spender address The address which will spend the funds.
145    * @return A uint256 specifying the amount of tokens still available for the spender.
146    */
147   function allowance(
148     address _owner,
149     address _spender
150    )
151     public
152     view
153     returns (uint256)
154   {
155     return allowed_[_owner][_spender];
156   }
157 
158   /**
159   * @dev Transfer token for a specified address
160   * @param _to The address to transfer to.
161   * @param _value The amount to be transferred.
162   */
163   function transfer(address _to, uint256 _value) public returns (bool) {
164     require(_value <= balances_[msg.sender]);
165     require(_to != address(0));
166 
167     balances_[msg.sender] = balances_[msg.sender].sub(_value);
168     balances_[_to] = balances_[_to].add(_value);
169     emit Transfer(msg.sender, _to, _value);
170     return true;
171   }
172 
173   /**
174    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
175    * Beware that changing an allowance with this method brings the risk that someone may use both the old
176    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
177    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
178    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
179    * @param _spender The address which will spend the funds.
180    * @param _value The amount of tokens to be spent.
181    */
182   function approve(address _spender, uint256 _value) public returns (bool) {
183     allowed_[msg.sender][_spender] = _value;
184     emit Approval(msg.sender, _spender, _value);
185     return true;
186   }
187 
188   /**
189    * @dev Transfer tokens from one address to another
190    * @param _from address The address which you want to send tokens from
191    * @param _to address The address which you want to transfer to
192    * @param _value uint256 the amount of tokens to be transferred
193    */
194   function transferFrom(
195     address _from,
196     address _to,
197     uint256 _value
198   )
199     public
200     returns (bool)
201   {
202     require(_value <= balances_[_from]);
203     require(_value <= allowed_[_from][msg.sender]);
204     require(_to != address(0));
205 
206     balances_[_from] = balances_[_from].sub(_value);
207     balances_[_to] = balances_[_to].add(_value);
208     allowed_[_from][msg.sender] = allowed_[_from][msg.sender].sub(_value);
209     emit Transfer(_from, _to, _value);
210     return true;
211   }
212 
213   /**
214    * @dev Increase the amount of tokens that an owner allowed to a spender.
215    * approve should be called when allowed_[_spender] == 0. To increment
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
229     allowed_[msg.sender][_spender] = (
230       allowed_[msg.sender][_spender].add(_addedValue));
231     emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
232     return true;
233   }
234 
235   /**
236    * @dev Decrease the amount of tokens that an owner allowed to a spender.
237    * approve should be called when allowed_[_spender] == 0. To decrement
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
251     uint256 oldValue = allowed_[msg.sender][_spender];
252     if (_subtractedValue >= oldValue) {
253       allowed_[msg.sender][_spender] = 0;
254     } else {
255       allowed_[msg.sender][_spender] = oldValue.sub(_subtractedValue);
256     }
257     emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
258     return true;
259   }
260 
261   /**
262    * @dev Internal function that mints an amount of the token and assigns it to
263    * an account. This encapsulates the modification of balances such that the
264    * proper events are emitted.
265    * @param _account The account that will receive the created tokens.
266    * @param _amount The amount that will be created.
267    */
268   function _mint(address _account, uint256 _amount) internal {
269     require(_account != 0);
270     totalSupply_ = totalSupply_.add(_amount);
271     balances_[_account] = balances_[_account].add(_amount);
272     emit Transfer(address(0), _account, _amount);
273   }
274 
275   /**
276    * @dev Internal function that burns an amount of the token of a given
277    * account.
278    * @param _account The account whose tokens will be burnt.
279    * @param _amount The amount that will be burnt.
280    */
281   function _burn(address _account, uint256 _amount) internal {
282     require(_account != 0);
283     require(_amount <= balances_[_account]);
284 
285     totalSupply_ = totalSupply_.sub(_amount);
286     balances_[_account] = balances_[_account].sub(_amount);
287     emit Transfer(_account, address(0), _amount);
288   }
289 
290   /**
291    * @dev Internal function that burns an amount of the token of a given
292    * account, deducting from the sender's allowance for said account. Uses the
293    * internal _burn function.
294    * @param _account The account whose tokens will be burnt.
295    * @param _amount The amount that will be burnt.
296    */
297   function _burnFrom(address _account, uint256 _amount) internal {
298     require(_amount <= allowed_[_account][msg.sender]);
299 
300     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
301     // this function needs to emit an event with the updated approval.
302     allowed_[_account][msg.sender] = allowed_[_account][msg.sender].sub(
303       _amount);
304     _burn(_account, _amount);
305   }
306 }
307 
308 ////////////////////////////////////////////////////////////////////////////////////////
309 
310 
311 contract HGGToken is ERC20 {
312 
313   string public constant name = "HGGToken";
314   string public constant symbol = "HGG";
315   uint8 public constant decimals = 18;
316 
317   uint256 public constant INITIAL_SUPPLY = 50 * (10 ** uint256(7)) * (10 ** uint256(decimals));
318 
319   /**
320    * @dev Constructor that gives msg.sender all of existing tokens.
321    */
322   constructor() public {
323     _mint(msg.sender, INITIAL_SUPPLY);
324   }
325 
326 }