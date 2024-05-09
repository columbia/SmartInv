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
32 library SafeMath {
33 
34   /**
35   * @dev Multiplies two numbers, reverts on overflow.
36   */
37   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
38     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
39     // benefit is lost if 'b' is also tested.
40     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
41     if (_a == 0) {
42       return 0;
43     }
44 
45     uint256 c = _a * _b;
46     require(c / _a == _b);
47 
48     return c;
49   }
50 
51   /**
52   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
53   */
54   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
55     require(_b > 0); // Solidity only automatically asserts when dividing by 0
56     uint256 c = _a / _b;
57     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
58 
59     return c;
60   }
61 
62   /**
63   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
64   */
65   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
66     require(_b <= _a);
67     uint256 c = _a - _b;
68 
69     return c;
70   }
71 
72   /**
73   * @dev Adds two numbers, reverts on overflow.
74   */
75   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
76     uint256 c = _a + _b;
77     require(c >= _a);
78 
79     return c;
80   }
81 
82   /**
83   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
84   * reverts when dividing by zero.
85   */
86   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
87     require(b != 0);
88     return a % b;
89   }
90 }
91 
92 contract StandardToken is ERC20 {
93   using SafeMath for uint256;
94 
95   mapping (address => uint256) private balances;
96 
97   mapping (address => mapping (address => uint256)) private allowed;
98 
99   uint256 private totalSupply_;
100 
101   /**
102   * @dev Total number of tokens in existence
103   */
104   function totalSupply() public view returns (uint256) {
105     return totalSupply_;
106   }
107 
108   /**
109   * @dev Gets the balance of the specified address.
110   * @param _owner The address to query the the balance of.
111   * @return An uint256 representing the amount owned by the passed address.
112   */
113   function balanceOf(address _owner) public view returns (uint256) {
114     return balances[_owner];
115   }
116 
117   /**
118    * @dev Function to check the amount of tokens that an owner allowed to a spender.
119    * @param _owner address The address which owns the funds.
120    * @param _spender address The address which will spend the funds.
121    * @return A uint256 specifying the amount of tokens still available for the spender.
122    */
123   function allowance(
124     address _owner,
125     address _spender
126    )
127     public
128     view
129     returns (uint256)
130   {
131     return allowed[_owner][_spender];
132   }
133 
134   /**
135   * @dev Transfer token for a specified address
136   * @param _to The address to transfer to.
137   * @param _value The amount to be transferred.
138   */
139   function transfer(address _to, uint256 _value) public returns (bool) {
140     require(_value <= balances[msg.sender]);
141     require(_to != address(0));
142 
143     balances[msg.sender] = balances[msg.sender].sub(_value);
144     balances[_to] = balances[_to].add(_value);
145     emit Transfer(msg.sender, _to, _value);
146     return true;
147   }
148 
149   /**
150    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
151    * Beware that changing an allowance with this method brings the risk that someone may use both the old
152    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
153    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
154    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
155    * @param _spender The address which will spend the funds.
156    * @param _value The amount of tokens to be spent.
157    */
158   function approve(address _spender, uint256 _value) public returns (bool) {
159     allowed[msg.sender][_spender] = _value;
160     emit Approval(msg.sender, _spender, _value);
161     return true;
162   }
163 
164   /**
165    * @dev Transfer tokens from one address to another
166    * @param _from address The address which you want to send tokens from
167    * @param _to address The address which you want to transfer to
168    * @param _value uint256 the amount of tokens to be transferred
169    */
170   function transferFrom(
171     address _from,
172     address _to,
173     uint256 _value
174   )
175     public
176     returns (bool)
177   {
178     require(_value <= balances[_from]);
179     require(_value <= allowed[_from][msg.sender]);
180     require(_to != address(0));
181 
182     balances[_from] = balances[_from].sub(_value);
183     balances[_to] = balances[_to].add(_value);
184     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
185     emit Transfer(_from, _to, _value);
186     return true;
187   }
188 
189   /**
190    * @dev Internal function that mints an amount of the token and assigns it to
191    * an account. This encapsulates the modification of balances such that the
192    * proper events are emitted.
193    * @param _account The account that will receive the created tokens.
194    * @param _amount The amount that will be created.
195    */
196   function _mint(address _account, uint256 _amount) internal {
197     require(_account != 0);
198     totalSupply_ = totalSupply_.add(_amount);
199     balances[_account] = balances[_account].add(_amount);
200     emit Transfer(address(0), _account, _amount);
201   }
202 }
203 
204 contract RHHToken is StandardToken {
205 
206   string public constant name = "Russian Hiphop";
207   string public constant symbol = "RHH";
208   uint8 public constant decimals = 2;
209 
210   uint256 public constant INITIAL_SUPPLY = 10000000 * (10 ** uint256(decimals));
211 
212   constructor() public {
213     _mint(msg.sender, INITIAL_SUPPLY);
214   }
215 
216 }