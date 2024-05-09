1 pragma solidity 0.4.24;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5 
6     function balanceOf(address who) external view returns (uint256);
7 
8     function allowance(address owner, address spender) external view returns (uint256);
9 
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 library SafeMath {
22     int256 constant private INT256_MIN = -2**255;
23 
24     /**
25     * @dev Multiplies two unsigned integers, reverts on overflow.
26     */
27     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
29         // benefit is lost if 'b' is also tested.
30         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
31         if (a == 0) {
32             return 0;
33         }
34 
35         uint256 c = a * b;
36         require(c / a == b);
37 
38         return c;
39     }
40 
41     /**
42     * @dev Multiplies two signed integers, reverts on overflow.
43     */
44     function mul(int256 a, int256 b) internal pure returns (int256) {
45         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
46         // benefit is lost if 'b' is also tested.
47         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
48         if (a == 0) {
49             return 0;
50         }
51 
52         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
53 
54         int256 c = a * b;
55         require(c / a == b);
56 
57         return c;
58     }
59 
60     /**
61     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
62     */
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         // Solidity only automatically asserts when dividing by 0
65         require(b > 0);
66         uint256 c = a / b;
67         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68 
69         return c;
70     }
71 
72     /**
73     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
74     */
75     function div(int256 a, int256 b) internal pure returns (int256) {
76         require(b != 0); // Solidity only automatically asserts when dividing by 0
77         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
78 
79         int256 c = a / b;
80 
81         return c;
82     }
83 
84     /**
85     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
86     */
87     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
88         require(b <= a);
89         uint256 c = a - b;
90 
91         return c;
92     }
93 
94     /**
95     * @dev Subtracts two signed integers, reverts on overflow.
96     */
97     function sub(int256 a, int256 b) internal pure returns (int256) {
98         int256 c = a - b;
99         require((b >= 0 && c <= a) || (b < 0 && c > a));
100 
101         return c;
102     }
103 
104     /**
105     * @dev Adds two unsigned integers, reverts on overflow.
106     */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a);
110 
111         return c;
112     }
113 
114     /**
115     * @dev Adds two signed integers, reverts on overflow.
116     */
117     function add(int256 a, int256 b) internal pure returns (int256) {
118         int256 c = a + b;
119         require((b >= 0 && c >= a) || (b < 0 && c < a));
120 
121         return c;
122     }
123 
124     /**
125     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
126     * reverts when dividing by zero.
127     */
128     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
129         require(b != 0);
130         return a % b;
131     }
132 }
133 
134 contract UnlimitedAllowanceToken is IERC20 {
135   using SafeMath for uint256;
136 
137   /* ============ State variables ============ */
138 
139   uint256 public totalSupply;
140   mapping (address => uint256) public  balances;
141   mapping (address => mapping (address => uint256)) public allowed;
142 
143   /* ============ Events ============ */
144 
145   event Approval(address indexed src, address indexed spender, uint256 amount);
146   event Transfer(address indexed src, address indexed dest, uint256 amount);
147 
148   /* ============ Constructor ============ */
149 
150   constructor () public { }
151 
152   /* ============ Public functions ============ */
153 
154   function approve(address _spender, uint256 _amount) public returns (bool) {
155     allowed[msg.sender][_spender] = _amount;
156     emit Approval(msg.sender, _spender, _amount);
157     return true;
158   }
159 
160   function transfer(address _dest, uint256 _amount) public returns (bool) {
161     return transferFrom(msg.sender, _dest, _amount);
162   }
163 
164   function transferFrom(address _src, address _dest, uint256 _amount) public returns (bool) {
165     require(balances[_src] >= _amount, "Insufficient user balance");
166 
167     if (_src != msg.sender && allowance(_src, msg.sender) != uint256(-1)) {
168       require(allowance(_src, msg.sender) >= _amount, "Insufficient user allowance");
169       allowed[_src][msg.sender] = allowed[_src][msg.sender].sub(_amount);
170     }
171 
172     balances[_src] = balances[_src].sub(_amount);
173     balances[_dest] = balances[_dest].add(_amount);
174 
175     emit Transfer(_src, _dest, _amount);
176 
177     return true;
178   }
179 
180   function allowance(address _owner, address _spender) public view returns (uint256) {
181     return allowed[_owner][_spender];
182   }
183 
184   function balanceOf(address _owner) public view returns (uint256) {
185     return balances[_owner];
186   }
187 
188   function totalSupply() public view returns (uint256) {
189     return totalSupply;
190   }
191 }
192 
193 
194 /**
195  * @title VeilEther
196  * @author Veil
197  *
198  * WETH-like token with the ability to deposit ETH and approve in a single transaction
199  */
200 contract VeilEther is UnlimitedAllowanceToken {
201   using SafeMath for uint256;
202 
203   /* ============ Constants ============ */
204 
205   string constant public name = "Veil Ether"; // solium-disable-line uppercase
206   string constant public symbol = "Veil ETH"; // solium-disable-line uppercase
207   uint256 constant public decimals = 18; // solium-disable-line uppercase
208 
209   /* ============ Events ============ */
210 
211   event Deposit(address indexed dest, uint256 amount);
212   event Withdrawal(address indexed src, uint256 amount);
213 
214   /* ============ Constructor ============ */
215 
216   constructor () public { }
217 
218   /* ============ Public functions ============ */
219 
220   /**
221    * @dev Fallback function can be used to buy tokens by proxying the call to deposit()
222    */
223   function() public payable {
224     deposit();
225   }
226 
227   /* ============ New functionality ============ */
228 
229   /**
230    * Buys tokens with Ether, exchanging them 1:1 and sets the spender allowance
231    *
232    * @param _spender          Spender address for the allowance
233    * @param _allowance        Allowance amount
234    */
235   function depositAndApprove(address _spender, uint256 _allowance) public payable returns (bool) {
236     deposit();
237     approve(_spender, _allowance);
238     return true;
239   }
240 
241   /**
242    * Withdraws from msg.sender's balance and transfers to a target address instead of msg.sender
243    *
244    * @param _amount           Amount to withdraw
245    * @param _target           Address to send the withdrawn ETH
246    */
247   function withdrawAndTransfer(uint256 _amount, address _target) public returns (bool) {
248     require(balances[msg.sender] >= _amount, "Insufficient user balance");
249     require(_target != address(0), "Invalid target address");
250 
251     balances[msg.sender] = balances[msg.sender].sub(_amount);
252     totalSupply = totalSupply.sub(_amount);
253     _target.transfer(_amount);
254 
255     emit Withdrawal(msg.sender, _amount);
256     return true;
257   }
258 
259   /* ============ Standard WETH functionality ============ */
260 
261   function deposit() public payable returns (bool) {
262     balances[msg.sender] = balances[msg.sender].add(msg.value);
263     totalSupply = totalSupply.add(msg.value);
264     emit Deposit(msg.sender, msg.value);
265     return true;
266   }
267 
268   function withdraw(uint256 _amount) public returns (bool) {
269     require(balances[msg.sender] >= _amount, "Insufficient user balance");
270 
271     balances[msg.sender] = balances[msg.sender].sub(_amount);
272     totalSupply = totalSupply.sub(_amount);
273     msg.sender.transfer(_amount);
274 
275     emit Withdrawal(msg.sender, _amount);
276     return true;
277   }
278 }