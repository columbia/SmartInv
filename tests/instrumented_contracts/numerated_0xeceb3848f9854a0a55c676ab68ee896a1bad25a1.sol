1 pragma solidity ^0.4.24;
2 
3 contract ERC20 {
4   function totalSupply() public view returns (uint256);
5 
6   function balanceOf(address _who) public view returns (uint256);
7 
8   function allowance(address _owner, address _spender)
9     public view returns (uint256);
10 
11   function transfer(address _to, uint256 _value) public returns (bool);
12 
13   function approve(address _spender, uint256 _value)
14     public returns (bool);
15 
16   function transferFrom(address _from, address _to, uint256 _value)
17     public returns (bool);
18 
19   event Transfer(
20     address indexed from,
21     address indexed to,
22     uint256 value
23   );
24 
25   event Approval(
26     address indexed owner,
27     address indexed spender,
28     uint256 value
29   );
30 }
31 
32 pragma solidity ^0.4.24;
33 
34 
35 /**
36  * @title SafeMath
37  * @dev Math operations with safety checks that revert on error
38  */
39 library SafeMath {
40 
41   /**
42   * @dev Multiplies two numbers, reverts on overflow.
43   */
44   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
45     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
46     // benefit is lost if 'b' is also tested.
47     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
48     if (_a == 0) {
49       return 0;
50     }
51 
52     uint256 c = _a * _b;
53     require(c / _a == _b);
54 
55     return c;
56   }
57 
58   /**
59   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
60   */
61   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
62     require(_b > 0); // Solidity only automatically asserts when dividing by 0
63     uint256 c = _a / _b;
64     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
65 
66     return c;
67   }
68 
69   /**
70   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
71   */
72   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
73     require(_b <= _a);
74     uint256 c = _a - _b;
75 
76     return c;
77   }
78 
79   /**
80   * @dev Adds two numbers, reverts on overflow.
81   */
82   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
83     uint256 c = _a + _b;
84     require(c >= _a);
85 
86     return c;
87   }
88 
89   /**
90   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
91   * reverts when dividing by zero.
92   */
93   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
94     require(b != 0);
95     return a % b;
96   }
97 }
98 
99 
100 
101 /**
102  * @title Standard ERC20, Cova Token
103  *
104  * @dev Implementation of the basic standard token.
105  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
106  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
107  */
108 
109 contract CovaToken is ERC20 {
110   using SafeMath for uint256;
111 
112   mapping (address => uint256) private balances;
113   mapping (address => mapping (address => uint256)) private allowed;
114 
115   uint256 private totalSupply_ = 65 * (10 ** (8 + 18));
116   string private constant name_ = 'Covalent Token';                                 // Set the token name for display
117   string private constant symbol_ = 'COVA';                                         // Set the token symbol for display
118   uint8 private constant decimals_ = 18;                                          // Set the number of decimals for display
119   
120 
121   constructor () public {
122     balances[msg.sender] = totalSupply_;
123     emit Transfer(address(0), msg.sender, totalSupply_);
124   }
125 
126   /**
127   * @dev Total number of tokens in existence
128   */
129   function totalSupply() public view returns (uint256) {
130     return totalSupply_;
131   }
132 
133   /**
134   * @dev Token name
135   */
136   function name() public view returns (string) {
137     return name_;
138   }
139 
140   /**
141   * @dev Token symbol
142   */
143   function symbol() public view returns (string) {
144     return symbol_;
145   }
146 
147   /**
148   * @dev Token decinal
149   */
150   function decimals() public view returns (uint8) {
151     return decimals_;
152   }
153 
154   /**
155   * @dev Gets the balance of the specified address.
156   * @param _owner The address to query the the balance of.
157   * @return An uint256 representing the amount owned by the passed address.
158   */
159   function balanceOf(address _owner) public view returns (uint256) {
160     return balances[_owner];
161   }
162 
163   /**
164    * @dev Function to check the amount of tokens that an owner allowed to a spender.
165    * @param _owner address The address which owns the funds.
166    * @param _spender address The address which will spend the funds.
167    * @return A uint256 specifying the amount of tokens still available for the spender.
168    */
169   function allowance(
170     address _owner,
171     address _spender
172    )
173     public
174     view
175     returns (uint256)
176   {
177     return allowed[_owner][_spender];
178   }
179 
180   /**
181   * @dev Transfer token for a specified address
182   * @param _to The address to transfer to.
183   * @param _value The amount to be transferred.
184   */
185   function transfer(address _to, uint256 _value) public returns (bool) {
186     require(_value <= balances[msg.sender]);
187     require(_to != address(0));
188 
189     balances[msg.sender] = balances[msg.sender].sub(_value);
190     balances[_to] = balances[_to].add(_value);
191     emit Transfer(msg.sender, _to, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
197    * Beware that changing an allowance with this method brings the risk that someone may use both the old
198    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
199    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
200    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201    * @param _spender The address which will spend the funds.
202    * @param _value The amount of tokens to be spent.
203    */
204   function approve(address _spender, uint256 _value) public returns (bool) {
205     allowed[msg.sender][_spender] = _value;
206     emit Approval(msg.sender, _spender, _value);
207     return true;
208   }
209 
210   /**
211    * @dev Transfer tokens from one address to another
212    * @param _from address The address which you want to send tokens from
213    * @param _to address The address which you want to transfer to
214    * @param _value uint256 the amount of tokens to be transferred
215    */
216   function transferFrom(
217     address _from,
218     address _to,
219     uint256 _value
220   )
221     public
222     returns (bool)
223   {
224     require(_value <= balances[_from]);
225     require(_value <= allowed[_from][msg.sender]);
226     require(_to != address(0));
227 
228     balances[_from] = balances[_from].sub(_value);
229     balances[_to] = balances[_to].add(_value);
230     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
231     emit Transfer(_from, _to, _value);
232     return true;
233   }
234 
235   /**
236    * @dev Increase the amount of tokens that an owner allowed to a spender.
237    * approve should be called when allowed[_spender] == 0. To increment
238    * allowed value is better to use this function to avoid 2 calls (and wait until
239    * the first transaction is mined)
240    * From MonolithDAO Token.sol
241    * @param _spender The address which will spend the funds.
242    * @param _addedValue The amount of tokens to increase the allowance by.
243    */
244   function increaseApproval(
245     address _spender,
246     uint256 _addedValue
247   )
248     public
249     returns (bool)
250   {
251     allowed[msg.sender][_spender] = (
252       allowed[msg.sender][_spender].add(_addedValue));
253     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
254     return true;
255   }
256 
257   /**
258    * @dev Decrease the amount of tokens that an owner allowed to a spender.
259    * approve should be called when allowed[_spender] == 0. To decrement
260    * allowed value is better to use this function to avoid 2 calls (and wait until
261    * the first transaction is mined)
262    * From MonolithDAO Token.sol
263    * @param _spender The address which will spend the funds.
264    * @param _subtractedValue The amount of tokens to decrease the allowance by.
265    */
266   function decreaseApproval(
267     address _spender,
268     uint256 _subtractedValue
269   )
270     public
271     returns (bool)
272   {
273     uint256 oldValue = allowed[msg.sender][_spender];
274     if (_subtractedValue >= oldValue) {
275       allowed[msg.sender][_spender] = 0;
276     } else {
277       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
278     }
279     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
280     return true;
281   }
282 }