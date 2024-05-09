1 pragma solidity ^0.4.24;
2 
3 /**
4 * @title SafeMath
5 * @dev Math operations with safety checks that revert on error
6 */
7 library SafeMath {
8   function add(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a + b;
10     require(c >= a);
11 
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     require(b <= a);
17     uint256 c = a - b;
18 
19     return c;
20   }
21 
22   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a * b;
24     assert(a == 0 || c / a == b);
25 
26     return c;
27   }
28 
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 }
37 
38 interface IERC20 {
39   function totalSupply() external view returns (uint256);
40 
41   function balanceOf(address who) external view returns (uint256);
42 
43   function allowance(address owner, address spender) external view returns (uint256);
44 
45   function transfer(address to, uint256 value) external returns (bool);
46 
47   function approve(address spender, uint256 value) external returns (bool);
48 
49   function transferFrom(address from, address to, uint256 value) external returns (bool);
50 
51   event Transfer(
52     address indexed from,
53     address indexed to,
54     uint256 value
55   );
56 
57   event Approval(
58     address indexed owner,
59     address indexed spender,
60     uint256 value
61   );
62 }
63 
64 
65 contract ERC20 is IERC20 {
66   using SafeMath for uint256;
67 
68   mapping (address => uint256) private _balances;
69 
70   mapping (address => mapping (address => uint256)) private _allowed;
71 
72   uint256 private _totalSupply;
73 
74   function totalSupply() public view returns (uint256) {
75     return _totalSupply;
76   }
77 
78   function balanceOf(address owner) public view returns (uint256) {
79     return _balances[owner];
80   }
81 
82   function allowance(address owner, address spender) public view returns (uint256) {
83     return _allowed[owner][spender];
84   }
85 
86   /**
87   * @dev Transfer token for a specified address
88   * @param to The address to transfer to.
89   * @param value The amount to be transferred.
90   */
91   function transfer(address to, uint256 value) public returns (bool) {
92     require(value <= _balances[msg.sender]);
93     require(to != address(0));
94 
95     _balances[msg.sender] = _balances[msg.sender].sub(value);
96     _balances[to] = _balances[to].add(value);
97     emit Transfer(msg.sender, to, value);
98     return true;
99   }
100 
101   /**
102    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
103    * Beware that changing an allowance with this method brings the risk that someone may use both the old
104    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
105    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
106    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
107    * @param spender The address which will spend the funds.
108    * @param value The amount of tokens to be spent.
109    */
110   function approve(address spender, uint256 value) public returns (bool) {
111     require(spender != address(0));
112 
113     _allowed[msg.sender][spender] = value;
114     emit Approval(msg.sender, spender, value);
115     return true;
116   }
117 
118   /**
119    * @dev Transfer tokens from one address to another
120    * @param from address The address which you want to send tokens from
121    * @param to address The address which you want to transfer to
122    * @param value uint256 the amount of tokens to be transferred
123    */
124   function transferFrom(address from, address to, uint256 value) public returns (bool) {
125     require(value <= _balances[from]);
126     require(value <= _allowed[from][msg.sender]);
127     require(to != address(0));
128 
129     _balances[from] = _balances[from].sub(value);
130     _balances[to] = _balances[to].add(value);
131     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
132     emit Transfer(from, to, value);
133     return true;
134   }
135 
136   /**
137    * @dev Increase the amount of tokens that an owner allowed to a spender.
138    * approve should be called when allowed_[_spender] == 0. To increment
139    * allowed value is better to use this function to avoid 2 calls (and wait until
140    * the first transaction is mined)
141    * From MonolithDAO Token.sol
142    * @param spender The address which will spend the funds.
143    * @param addedValue The amount of tokens to increase the allowance by.
144    */
145   function increaseAllowance(
146     address spender,
147     uint256 addedValue
148   )
149     public
150     returns (bool)
151   {
152     require(spender != address(0));
153 
154     _allowed[msg.sender][spender] = (
155       _allowed[msg.sender][spender].add(addedValue));
156     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
157     return true;
158   }
159 
160   /**
161    * @dev Decrease the amount of tokens that an owner allowed to a spender.
162    * approve should be called when allowed_[_spender] == 0. To decrement
163    * allowed value is better to use this function to avoid 2 calls (and wait until
164    * the first transaction is mined)
165    * From MonolithDAO Token.sol
166    * @param spender The address which will spend the funds.
167    * @param subtractedValue The amount of tokens to decrease the allowance by.
168    */
169   function decreaseAllowance(
170     address spender,
171     uint256 subtractedValue
172   )
173     public
174     returns (bool)
175   {
176     require(spender != address(0));
177 
178     _allowed[msg.sender][spender] = (
179       _allowed[msg.sender][spender].sub(subtractedValue));
180     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
181     return true;
182   }
183 
184   /**
185    * @dev Internal function that mints an amount of the token and assigns it to
186    * an account. This encapsulates the modification of balances such that the
187    * proper events are emitted.
188    * @param account The account that will receive the created tokens.
189    * @param amount The amount that will be created.
190    */
191   function _mint(address account, uint256 amount) internal {
192     require(account != 0);
193     _totalSupply = _totalSupply.add(amount);
194     _balances[account] = _balances[account].add(amount);
195     emit Transfer(address(0), account, amount);
196   }
197 }
198 
199 
200 contract TalarToken is ERC20 {
201 
202   string public constant name = "TalaR Token";
203   string public constant symbol = "TALAR";
204   uint8 public constant decimals = 18;
205 
206 
207   // Constructor that gives msg.sender all of existing tokens.
208   constructor(uint256 initialSupply) public {
209     _mint(msg.sender, initialSupply * (10 ** uint256(decimals)));
210   }
211 }