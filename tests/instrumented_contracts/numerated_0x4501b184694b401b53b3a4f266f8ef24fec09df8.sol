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
89 }
90 
91 /**
92  * @title Standard ERC20 token
93  *
94  * @dev Implementation of the basic standard token.
95  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
96  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
97  */
98 contract ERC20 is IERC20 {
99   using SafeMath for uint256;
100 
101   mapping (address => uint256) public _balances;
102 
103   mapping (address => mapping (address => uint256)) public _allowed;
104 
105   uint256 public _totalSupply;
106 
107   /**
108   * @dev Total number of tokens in existence
109   */
110   function totalSupply() public view returns (uint256) {
111     return _totalSupply;
112   }
113 
114   /**
115   * @dev Gets the balance of the specified address.
116   * @param owner The address to query the balance of.
117   * @return An uint256 representing the amount owned by the passed address.
118   */
119   function balanceOf(address owner) public view returns (uint256) {
120     return _balances[owner];
121   }
122 
123   /**
124    * @dev Function to check the amount of tokens that an owner allowed to a spender.
125    * @param owner address The address which owns the funds.
126    * @param spender address The address which will spend the funds.
127    * @return A uint256 specifying the amount of tokens still available for the spender.
128    */
129   function allowance(
130     address owner,
131     address spender
132    )
133     public
134     view
135     returns (uint256)
136   {
137     return _allowed[owner][spender];
138   }
139 
140   /**
141   * @dev Transfer token for a specified address
142   * @param to The address to transfer to.
143   * @param value The amount to be transferred.
144   */
145   function transfer(address to, uint256 value) public returns (bool) {
146     _transfer(msg.sender, to, value);
147     return true;
148   }
149 
150   /**
151    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
152    * Beware that changing an allowance with this method brings the risk that someone may use both the old
153    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
154    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
155    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156    * @param spender The address which will spend the funds.
157    * @param value The amount of tokens to be spent.
158    */
159   function approve(address spender, uint256 value) public returns (bool) {
160     require(spender != address(0));
161 
162     _allowed[msg.sender][spender] = value;
163     emit Approval(msg.sender, spender, value);
164     return true;
165   }
166 
167   /**
168    * @dev Transfer tokens from one address to another
169    * @param from address The address which you want to send tokens from
170    * @param to address The address which you want to transfer to
171    * @param value uint256 the amount of tokens to be transferred
172    */
173   function transferFrom(
174     address from,
175     address to,
176     uint256 value
177   )
178     public
179     returns (bool)
180   {
181     require(value <= _allowed[from][msg.sender]);
182 
183     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
184     _transfer(from, to, value);
185     return true;
186   }
187 
188   /**
189   * @dev Transfer token for a specified addresses
190   * @param from The address to transfer from.
191   * @param to The address to transfer to.
192   * @param value The amount to be transferred.
193   */
194   function _transfer(address from, address to, uint256 value) internal {
195     require(value <= _balances[from]);
196     require(to != address(0));
197 
198     _balances[from] = _balances[from].sub(value);
199     _balances[to] = _balances[to].add(value);
200     emit Transfer(from, to, value);
201   }
202 }
203 
204 contract ACUToken is ERC20 {
205 
206   string public constant name = "FDG";
207   string public constant symbol = "FDG";
208   uint8 public constant decimals = 18;
209 
210   uint256 public constant INITIAL_SUPPLY = 210000000 * (10 ** uint256(decimals));
211 
212   /**
213   * @dev Constructor that gives operation all of existing tokens.
214   */
215   constructor(address operation) public {
216     _totalSupply = INITIAL_SUPPLY;
217     _balances[operation] = INITIAL_SUPPLY;
218     emit Transfer(address(0), operation, INITIAL_SUPPLY);
219   }
220 }