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
34   
35   event Burn(address indexed from, uint256 value);
36 }
37 
38 /**
39  * @title SafeMath
40  * @dev Math operations with safety checks that revert on error
41  */
42 library SafeMath {
43 
44   /**
45   * @dev Multiplies two numbers, reverts on overflow.
46   */
47   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
48     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49     // benefit is lost if 'b' is also tested.
50     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
51     if (_a == 0) {
52       return 0;
53     }
54 
55     uint256 c = _a * _b;
56     require(c / _a == _b);
57 
58     return c;
59   }
60 
61   /**
62   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
63   */
64   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
65     require(_b > 0); // Solidity only automatically asserts when dividing by 0
66     uint256 c = _a / _b;
67     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
68 
69     return c;
70   }
71 
72   /**
73   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
74   */
75   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
76     require(_b <= _a);
77     uint256 c = _a - _b;
78 
79     return c;
80   }
81 
82   /**
83   * @dev Adds two numbers, reverts on overflow.
84   */
85   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
86     uint256 c = _a + _b;
87     require(c >= _a);
88 
89     return c;
90   }
91 
92   /**
93   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
94   * reverts when dividing by zero.
95   */
96   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
97     require(b != 0);
98     return a % b;
99   }
100 }
101 
102 
103 
104 
105 /**
106  * @title Standard ERC20, Cova Token
107  *
108  * @dev Implementation of the basic standard token.
109  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
110  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
111  */
112 
113 contract TLFToken is ERC20 {
114   using SafeMath for uint256;
115 
116   mapping (address => uint256) private balances;
117   mapping (address => mapping (address => uint256)) private allowed;
118 
119   uint256 private totalSupply_ = 1000000000 * (10 ** 18);
120   string private constant name_ = 'TLFToken';                                 // Set the token name for display
121   string private constant symbol_ = 'TLF';                                         // Set the token symbol for display
122   uint8 private constant decimals_ = 18;                                          // Set the number of decimals for display
123   
124 
125   constructor () public {
126     balances[msg.sender] = totalSupply_;
127     emit Transfer(address(0), msg.sender, totalSupply_);
128   }
129 
130   /**
131   * @dev Total number of tokens in existence
132   */
133   function totalSupply() public view returns (uint256) {
134     return totalSupply_;
135   }
136   
137    /**
138   * @dev Token name
139   */
140   function name() public view returns (string) {
141     return name_;
142   }
143 
144   /**
145   * @dev Token symbol
146   */
147   function symbol() public view returns (string) {
148     return symbol_;
149   }
150 
151   /**
152   * @dev Token decinal
153   */
154   function decimals() public view returns (uint8) {
155     return decimals_;
156   }
157 
158   /**
159   * @dev Gets the balance of the specified address.
160   * @param _owner The address to query the the balance of.
161   * @return An uint256 representing the amount owned by the passed address.
162   */
163   function balanceOf(address _owner) public view returns (uint256) {
164     return balances[_owner];
165   }
166 
167   /**
168    * @dev Function to check the amount of tokens that an owner allowed to a spender.
169    * @param _owner address The address which owns the funds.
170    * @param _spender address The address which will spend the funds.
171    * @return A uint256 specifying the amount of tokens still available for the spender.
172    */
173   function allowance(
174     address _owner,
175     address _spender
176    )
177     public
178     view
179     returns (uint256)
180   {
181     return allowed[_owner][_spender];
182   }
183 
184   /**
185   * @dev Transfer token for a specified address
186   * @param _to The address to transfer to.
187   * @param _value The amount to be transferred.
188   */
189   function transfer(address _to, uint256 _value) public returns (bool) {
190     require(_value <= balances[msg.sender]);
191     require(_to != address(0));
192 
193     balances[msg.sender] = balances[msg.sender].sub(_value);
194     balances[_to] = balances[_to].add(_value);
195     emit Transfer(msg.sender, _to, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
201    * Beware that changing an allowance with this method brings the risk that someone may use both the old
202    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
203    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
204    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205    * @param _spender The address which will spend the funds.
206    * @param _value The amount of tokens to be spent.
207    */
208   function approve(address _spender, uint256 _value) public returns (bool) {
209     require(_spender != address(0));
210 	
211     allowed[msg.sender][_spender] = _value;
212     emit Approval(msg.sender, _spender, _value);
213     return true;
214   }
215 
216   /**
217    * @dev Transfer tokens from one address to another
218    * @param _from address The address which you want to send tokens from
219    * @param _to address The address which you want to transfer to
220    * @param _value uint256 the amount of tokens to be transferred
221    */
222   function transferFrom(
223     address _from,
224     address _to,
225     uint256 _value
226   )
227     public
228     returns (bool)
229   {
230     require(_value <= balances[_from]);
231     require(_value <= allowed[_from][msg.sender]);
232     require(_to != address(0));
233 
234     balances[_from] = balances[_from].sub(_value);
235     balances[_to] = balances[_to].add(_value);
236     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
237     emit Transfer(_from, _to, _value);
238     return true;
239   }
240   
241   function burn(uint256 _value) public returns (bool success) {
242     require(msg.sender != address(0));
243 	require(balances[msg.sender] >= _value);   // 必须要有这么多
244 	
245 	balances[msg.sender] = balances[msg.sender].sub(_value);
246 	totalSupply_ = totalSupply_.sub(_value);
247 
248 	emit Burn(msg.sender, _value);
249     return true;
250   }
251 }