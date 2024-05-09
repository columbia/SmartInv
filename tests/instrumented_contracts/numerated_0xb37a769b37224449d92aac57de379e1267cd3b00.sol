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
36 /**
37  * @title SafeMath
38  * @dev Math operations with safety checks that revert on error
39  */
40 library SafeMath {
41 
42   /**
43   * @dev Multiplies two numbers, reverts on overflow.
44   */
45   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
46     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47     // benefit is lost if 'b' is also tested.
48     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
49     if (_a == 0) {
50       return 0;
51     }
52 
53     uint256 c = _a * _b;
54     require(c / _a == _b);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
61   */
62   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
63     require(_b > 0); // Solidity only automatically asserts when dividing by 0
64     uint256 c = _a / _b;
65     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
66 
67     return c;
68   }
69 
70   /**
71   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
72   */
73   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
74     require(_b <= _a);
75     uint256 c = _a - _b;
76 
77     return c;
78   }
79 
80   /**
81   * @dev Adds two numbers, reverts on overflow.
82   */
83   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
84     uint256 c = _a + _b;
85     require(c >= _a);
86 
87     return c;
88   }
89 
90   /**
91   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
92   * reverts when dividing by zero.
93   */
94   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
95     require(b != 0);
96     return a % b;
97   }
98 }
99 
100 
101 
102 
103 /**
104  * @title Standard ERC20, Cova Token
105  *
106  * @dev Implementation of the basic standard token.
107  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
108  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
109  */
110 
111 contract CovaToken is ERC20 {
112   using SafeMath for uint256;
113 
114   mapping (address => uint256) private balances;
115   mapping (address => mapping (address => uint256)) private allowed;
116 
117   uint256 private totalSupply_ = 65 * (10 ** (8 + 18));
118   string private constant name_ = 'Covalent Token';                                 // Set the token name for display
119   string private constant symbol_ = 'COVA';                                         // Set the token symbol for display
120   uint8 private constant decimals_ = 18;                                          // Set the number of decimals for display
121   
122 
123   constructor () public {
124     balances[msg.sender] = totalSupply_;
125     emit Transfer(address(0), msg.sender, totalSupply_);
126   }
127 
128   /**
129   * @dev Total number of tokens in existence
130   */
131   function totalSupply() public view returns (uint256) {
132     return totalSupply_;
133   }
134 
135   /**
136   * @dev Token name
137   */
138   function name() public view returns (string) {
139     return name_;
140   }
141 
142   /**
143   * @dev Token symbol
144   */
145   function symbol() public view returns (string) {
146     return symbol_;
147   }
148 
149   /**
150   * @dev Token decinal
151   */
152   function decimals() public view returns (uint8) {
153     return decimals_;
154   }
155 
156   /**
157   * @dev Gets the balance of the specified address.
158   * @param _owner The address to query the the balance of.
159   * @return An uint256 representing the amount owned by the passed address.
160   */
161   function balanceOf(address _owner) public view returns (uint256) {
162     return balances[_owner];
163   }
164 
165   /**
166    * @dev Function to check the amount of tokens that an owner allowed to a spender.
167    * @param _owner address The address which owns the funds.
168    * @param _spender address The address which will spend the funds.
169    * @return A uint256 specifying the amount of tokens still available for the spender.
170    */
171   function allowance(
172     address _owner,
173     address _spender
174    )
175     public
176     view
177     returns (uint256)
178   {
179     return allowed[_owner][_spender];
180   }
181 
182   /**
183   * @dev Transfer token for a specified address
184   * @param _to The address to transfer to.
185   * @param _value The amount to be transferred.
186   */
187   function transfer(address _to, uint256 _value) public returns (bool) {
188     require(_value <= balances[msg.sender]);
189     require(_to != address(0));
190 
191     balances[msg.sender] = balances[msg.sender].sub(_value);
192     balances[_to] = balances[_to].add(_value);
193     emit Transfer(msg.sender, _to, _value);
194     return true;
195   }
196 
197   /**
198    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
199    * Beware that changing an allowance with this method brings the risk that someone may use both the old
200    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
201    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
202    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
203    * @param _spender The address which will spend the funds.
204    * @param _value The amount of tokens to be spent.
205    */
206   function approve(address _spender, uint256 _value) public returns (bool) {
207     allowed[msg.sender][_spender] = _value;
208     emit Approval(msg.sender, _spender, _value);
209     return true;
210   }
211 
212   /**
213    * @dev Transfer tokens from one address to another
214    * @param _from address The address which you want to send tokens from
215    * @param _to address The address which you want to transfer to
216    * @param _value uint256 the amount of tokens to be transferred
217    */
218   function transferFrom(
219     address _from,
220     address _to,
221     uint256 _value
222   )
223     public
224     returns (bool)
225   {
226     require(_value <= balances[_from]);
227     require(_value <= allowed[_from][msg.sender]);
228     require(_to != address(0));
229 
230     balances[_from] = balances[_from].sub(_value);
231     balances[_to] = balances[_to].add(_value);
232     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
233     emit Transfer(_from, _to, _value);
234     return true;
235   }
236 
237   /**
238    * @dev Increase the amount of tokens that an owner allowed to a spender.
239    * approve should be called when allowed[_spender] == 0. To increment
240    * allowed value is better to use this function to avoid 2 calls (and wait until
241    * the first transaction is mined)
242    * From MonolithDAO Token.sol
243    * @param _spender The address which will spend the funds.
244    * @param _addedValue The amount of tokens to increase the allowance by.
245    */
246   function increaseApproval(
247     address _spender,
248     uint256 _addedValue
249   )
250     public
251     returns (bool)
252   {
253     allowed[msg.sender][_spender] = (
254       allowed[msg.sender][_spender].add(_addedValue));
255     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
256     return true;
257   }
258 
259   /**
260    * @dev Decrease the amount of tokens that an owner allowed to a spender.
261    * approve should be called when allowed[_spender] == 0. To decrement
262    * allowed value is better to use this function to avoid 2 calls (and wait until
263    * the first transaction is mined)
264    * From MonolithDAO Token.sol
265    * @param _spender The address which will spend the funds.
266    * @param _subtractedValue The amount of tokens to decrease the allowance by.
267    */
268   function decreaseApproval(
269     address _spender,
270     uint256 _subtractedValue
271   )
272     public
273     returns (bool)
274   {
275     uint256 oldValue = allowed[msg.sender][_spender];
276     if (_subtractedValue >= oldValue) {
277       allowed[msg.sender][_spender] = 0;
278     } else {
279       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
280     }
281     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
282     return true;
283   }
284 }