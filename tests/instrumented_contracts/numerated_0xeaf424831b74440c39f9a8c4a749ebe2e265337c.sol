1 /**
2  * Source Code first verified at https://etherscan.io on Tuesday, January 22, 2019
3  (UTC) */
4 
5 pragma solidity ^0.4.24;
6 
7 /**
8  * @title ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/20
10  */
11 contract ERC20 {
12   function totalSupply() public view returns (uint256);
13 
14   function balanceOf(address _who) public view returns (uint256);
15 
16   function allowance(address _owner, address _spender)
17     public view returns (uint256);
18 
19   function transfer(address _to, uint256 _value) public returns (bool);
20 
21   function approve(address _spender, uint256 _value)
22     public returns (bool);
23 
24   function transferFrom(address _from, address _to, uint256 _value)
25     public returns (bool);
26 
27   event Transfer(
28     address indexed from,
29     address indexed to,
30     uint256 value
31   );
32 
33   event Approval(
34     address indexed owner,
35     address indexed spender,
36     uint256 value
37   );
38   
39   event Burn(address indexed from, uint256 value);
40 }
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
107 
108 
109 /**
110  * @title Standard ERC20, Cova Token
111  *
112  * @dev Implementation of the basic standard token.
113  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
114  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
115  */
116 
117 contract BCWToken is ERC20 {
118   using SafeMath for uint256;
119 
120   mapping (address => uint256) private balances;
121   mapping (address => mapping (address => uint256)) private allowed;
122 
123   uint256 private totalSupply_ = 1000000000 * (10 ** 18);
124   string private constant name_ = 'BCWToken';                                 // Set the token name for display
125   string private constant symbol_ = 'BCW';                                         // Set the token symbol for display
126   uint8 private constant decimals_ = 18;                                          // Set the number of decimals for display
127   
128 
129   constructor () public {
130     balances[msg.sender] = totalSupply_;
131     emit Transfer(address(0), msg.sender, totalSupply_);
132   }
133 
134   /**
135   * @dev Total number of tokens in existence
136   */
137   function totalSupply() public view returns (uint256) {
138     return totalSupply_;
139   }
140   
141    /**
142   * @dev Token name
143   */
144   function name() public view returns (string) {
145     return name_;
146   }
147 
148   /**
149   * @dev Token symbol
150   */
151   function symbol() public view returns (string) {
152     return symbol_;
153   }
154 
155   /**
156   * @dev Token decinal
157   */
158   function decimals() public view returns (uint8) {
159     return decimals_;
160   }
161 
162   /**
163   * @dev Gets the balance of the specified address.
164   * @param _owner The address to query the the balance of.
165   * @return An uint256 representing the amount owned by the passed address.
166   */
167   function balanceOf(address _owner) public view returns (uint256) {
168     return balances[_owner];
169   }
170 
171   /**
172    * @dev Function to check the amount of tokens that an owner allowed to a spender.
173    * @param _owner address The address which owns the funds.
174    * @param _spender address The address which will spend the funds.
175    * @return A uint256 specifying the amount of tokens still available for the spender.
176    */
177   function allowance(
178     address _owner,
179     address _spender
180    )
181     public
182     view
183     returns (uint256)
184   {
185     return allowed[_owner][_spender];
186   }
187 
188   /**
189   * @dev Transfer token for a specified address
190   * @param _to The address to transfer to.
191   * @param _value The amount to be transferred.
192   */
193   function transfer(address _to, uint256 _value) public returns (bool) {
194     require(_value <= balances[msg.sender]);
195     require(_to != address(0));
196 
197     balances[msg.sender] = balances[msg.sender].sub(_value);
198     balances[_to] = balances[_to].add(_value);
199     emit Transfer(msg.sender, _to, _value);
200     return true;
201   }
202 
203   /**
204    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
205    * Beware that changing an allowance with this method brings the risk that someone may use both the old
206    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
207    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
208    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
209    * @param _spender The address which will spend the funds.
210    * @param _value The amount of tokens to be spent.
211    */
212   function approve(address _spender, uint256 _value) public returns (bool) {
213     require(_spender != address(0));
214 	
215     allowed[msg.sender][_spender] = _value;
216     emit Approval(msg.sender, _spender, _value);
217     return true;
218   }
219 
220   /**
221    * @dev Transfer tokens from one address to another
222    * @param _from address The address which you want to send tokens from
223    * @param _to address The address which you want to transfer to
224    * @param _value uint256 the amount of tokens to be transferred
225    */
226   function transferFrom(
227     address _from,
228     address _to,
229     uint256 _value
230   )
231     public
232     returns (bool)
233   {
234     require(_value <= balances[_from]);
235     require(_value <= allowed[_from][msg.sender]);
236     require(_to != address(0));
237 
238     balances[_from] = balances[_from].sub(_value);
239     balances[_to] = balances[_to].add(_value);
240     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
241     emit Transfer(_from, _to, _value);
242     return true;
243   }
244   
245   function burn(uint256 _value) public returns (bool success) {
246     require(msg.sender != address(0));
247 	require(balances[msg.sender] >= _value);   // 必须要有这么多
248 	
249 	balances[msg.sender] = balances[msg.sender].sub(_value);
250 	totalSupply_ = totalSupply_.sub(_value);
251 
252 	emit Burn(msg.sender, _value);
253     return true;
254   }
255 }