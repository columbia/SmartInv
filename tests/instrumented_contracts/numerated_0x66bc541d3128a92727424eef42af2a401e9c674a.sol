1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8   function totalSupply() external view returns (uint256);
9 
10   function balanceOf(address who) external view returns (uint256);
11 
12   function allowance(address owner, address spender)
13     external view returns (uint256);
14 
15   function transfer(address to, uint256 value) external returns (bool);
16 
17   function approve(address spender, uint256 value)
18     external returns (bool);
19 
20   function transferFrom(address from, address to, uint256 value)
21     external returns (bool);
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
45   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47     // benefit is lost if 'b' is also tested.
48     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
49     if (a == 0) {
50       return 0;
51     }
52 
53     uint256 c = a * b;
54     require(c / a == b);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
61   */
62   function div(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b > 0); // Solidity only automatically asserts when dividing by 0
64     uint256 c = a / b;
65     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66 
67     return c;
68   }
69 
70   /**
71   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
72   */
73   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74     require(b <= a);
75     uint256 c = a - b;
76 
77     return c;
78   }
79 
80   /**
81   * @dev Adds two numbers, reverts on overflow.
82   */
83   function add(uint256 a, uint256 b) internal pure returns (uint256) {
84     uint256 c = a + b;
85     require(c >= a);
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
101 contract ERC20 is IERC20 {
102   using SafeMath for uint256;
103 
104   mapping (address => uint256) private _balances;
105 
106   mapping (address => mapping (address => uint256)) private _allowed;
107 
108   uint256 private _totalSupply;
109 
110   /**
111   * @dev Total number of tokens in existence
112   */
113   function totalSupply() public view returns (uint256) {
114     return _totalSupply;
115   }
116 
117   /**
118   * @dev Gets the balance of the specified address.
119   * @param owner The address to query the balance of.
120   * @return An uint256 representing the amount owned by the passed address.
121   */
122   function balanceOf(address owner) public view returns (uint256) {
123     return _balances[owner];
124   }
125 
126   /**
127    * @dev Function to check the amount of tokens that an owner allowed to a spender.
128    * @param owner address The address which owns the funds.
129    * @param spender address The address which will spend the funds.
130    * @return A uint256 specifying the amount of tokens still available for the spender.
131    */
132   function allowance(    address owner,    address spender   )    public    view    returns (uint256)
133   {
134     return _allowed[owner][spender];
135   }
136 
137   /**
138   * @dev Transfer token for a specified address
139   * @param to The address to transfer to.
140   * @param value The amount to be transferred.
141   */
142   function transfer(address to, uint256 value) public returns (bool) {
143     require(value <= _balances[msg.sender]);
144     require(to != address(0));
145 
146     _balances[msg.sender] = _balances[msg.sender].sub(value);
147     _balances[to] = _balances[to].add(value);
148     emit Transfer(msg.sender, to, value);
149     return true;
150   }
151 
152   /**
153    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
154    * Beware that changing an allowance with this method brings the risk that someone may use both the old
155    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
156    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
157    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158    * @param spender The address which will spend the funds.
159    * @param value The amount of tokens to be spent.
160    */
161   function approve(address spender, uint256 value) public returns (bool) {
162     require(spender != address(0));
163 
164     _allowed[msg.sender][spender] = value;
165     emit Approval(msg.sender, spender, value);
166     return true;
167   }
168 
169   /**
170    * @dev Transfer tokens from one address to another
171    * @param from address The address which you want to send tokens from
172    * @param to address The address which you want to transfer to
173    * @param value uint256 the amount of tokens to be transferred
174    */
175   function transferFrom(  address from,  address to,    uint256 value  )  public    returns (bool)
176   {
177     require(value <= _balances[from]);
178     require(value <= _allowed[from][msg.sender]);
179     require(to != address(0));
180 
181     _balances[from] = _balances[from].sub(value);
182     _balances[to] = _balances[to].add(value);
183     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
184     emit Transfer(from, to, value);
185     return true;
186   }
187 
188   /**
189    * @dev Internal function that mints an amount of the token and assigns it to
190    * an account. This encapsulates the modification of balances such that the
191    * proper events are emitted.
192    * @param account The account that will receive the created tokens.
193    * @param amount The amount that will be created.
194    */
195   function _mint(address account, uint256 amount) internal {
196     require(account != 0);
197     _totalSupply = _totalSupply.add(amount);
198     _balances[account] = _balances[account].add(amount);
199     emit Transfer(address(0), account, amount);
200   }
201 
202 }
203 contract VUUXToken is ERC20 {
204 
205   string public constant name = "VUUX";
206   string public constant symbol = "VUUX";
207   uint8 public constant decimals = 18;
208 
209   uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));
210 
211   /**
212    * @dev Constructor that gives msg.sender all of existing tokens.
213    */
214   constructor() public {
215     _mint(msg.sender, INITIAL_SUPPLY);
216   }
217 
218 }