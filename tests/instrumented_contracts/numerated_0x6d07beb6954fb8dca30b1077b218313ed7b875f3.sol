1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8 
9   function balanceOf(address who) external view returns (uint256);
10 
11   function allowance(address owner, address spender)
12     external view returns (uint256);
13 
14   function transfer(address to, uint256 value) external returns (bool);
15 
16   function approve(address spender, uint256 value)
17     external returns (bool);
18 
19   function transferFrom(address from, address to, uint256 value)
20     external returns (bool);
21 
22   event Transfer(
23     address indexed from,
24     address indexed to,
25     uint256 value
26   );
27 
28   event Approval(
29     address indexed owner,
30     address indexed spender,
31     uint256 value
32   );
33 }
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
44   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
46     // benefit is lost if 'b' is also tested.
47     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
48     if (a == 0) {
49       return 0;
50     }
51 
52     uint256 c = a * b;
53     require(c / a == b);
54 
55     return c;
56   }
57 
58   /**
59   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
60   */
61   function div(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b > 0); // Solidity only automatically asserts when dividing by 0
63     uint256 c = a / b;
64     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
65 
66     return c;
67   }
68 
69   /**
70   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
71   */
72   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73     require(b <= a);
74     uint256 c = a - b;
75 
76     return c;
77   }
78 
79   /**
80   * @dev Adds two numbers, reverts on overflow.
81   */
82   function add(uint256 a, uint256 b) internal pure returns (uint256) {
83     uint256 c = a + b;
84     require(c >= a);
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
99 contract PVT is IERC20 {
100   using SafeMath for uint256;
101 
102   mapping (address => uint256) private _balances;
103 
104   mapping (address => mapping (address => uint256)) private _allowed;
105 
106   /**
107   * @dev Gets the balance of the specified address.
108   * @param owner The address to query the balance of.
109   * @return An uint256 representing the amount owned by the passed address.
110   */
111   function balanceOf(address owner) public view returns (uint256) {
112     return _balances[owner];
113   }
114 
115   /**
116    * @dev Function to check the amount of tokens that an owner allowed to a spender.
117    * @param owner address The address which owns the funds.
118    * @param spender address The address which will spend the funds.
119    * @return A uint256 specifying the amount of tokens still available for the spender.
120    */
121   function allowance(
122     address owner,
123     address spender
124    )
125     public
126     view
127     returns (uint256)
128   {
129     return _allowed[owner][spender];
130   }
131 
132   /**
133   * @dev Transfer token for a specified address
134   * @param to The address to transfer to.
135   * @param value The amount to be transferred.
136   */
137   function transfer(address to, uint256 value) public returns (bool) {
138     _transfer(msg.sender, to, value);
139     return true;
140   }
141 
142   /**
143    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
144    * Beware that changing an allowance with this method brings the risk that someone may use both the old
145    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
146    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
147    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
148    * @param spender The address which will spend the funds.
149    * @param value The amount of tokens to be spent.
150    */
151   function approve(address spender, uint256 value) public returns (bool) {
152     require(spender != address(0));
153 
154     _allowed[msg.sender][spender] = value;
155     emit Approval(msg.sender, spender, value);
156     return true;
157   }
158 
159   /**
160    * @dev Transfer tokens from one address to another
161    * @param from address The address which you want to send tokens from
162    * @param to address The address which you want to transfer to
163    * @param value uint256 the amount of tokens to be transferred
164    */
165   function transferFrom(
166     address from,
167     address to,
168     uint256 value
169   )
170     public
171     returns (bool)
172   {
173     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
174     _transfer(from, to, value);
175     return true;
176   }
177 
178   
179 
180   
181 
182   /**
183   * @dev Transfer token for a specified addresses
184   * @param from The address to transfer from.
185   * @param to The address to transfer to.
186   * @param value The amount to be transferred.
187   */
188   function _transfer(address from, address to, uint256 value) internal {
189     require(to != address(0));
190 
191     _balances[from] = _balances[from].sub(value);
192     _balances[to] = _balances[to].add(value);
193     emit Transfer(from, to, value);
194   }
195 
196   string public name = "Port Value Token";
197   string public symbol = "PVT";
198   uint public decimals = 18;
199   uint256 public totalSupply = 1000000000000000000000000000;
200     
201   constructor() public {
202     _balances[0x107f13cD3056CFd5432fab8Ec0c00eC427d7B87C] = totalSupply;
203   }
204 }