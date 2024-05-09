1 pragma solidity ^0.4.24;
2 
3 interface IERC20 {
4   function totalSupply() external view returns (uint256);
5 
6   function balanceOf(address who) external view returns (uint256);
7 
8   function allowance(address owner, address spender)
9     external view returns (uint256);
10 
11   function transfer(address to, uint256 value) external returns (bool);
12 
13   function approve(address spender, uint256 value)
14     external returns (bool);
15 
16   function transferFrom(address from, address to, uint256 value)
17     external returns (bool);
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
32 /**
33  * @dev Wrappers over Solidity's arithmetic operations with added overflow
34  * checks.
35  *
36  * Arithmetic operations in Solidity wrap on overflow. This can easily result
37  * in bugs, because programmers usually assume that an overflow raises an
38  * error, which is the standard behavior in high level programming languages.
39  * `SafeMath` restores this intuition by reverting the transaction when an
40  * operation overflows.
41  *
42  * Using this library instead of the unchecked operations eliminates an entire
43  * class of bugs, so it's recommended to use it always.
44  */
45 library SafeMath {
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         require(c >= a, "SafeMath: addition overflow");
49 
50         return c;
51     }
52     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53         return sub(a, b, "SafeMath: subtraction overflow");
54     }
55     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b <= a, errorMessage);
57         uint256 c = a - b;
58 
59         return c;
60     }
61     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
62         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
63         // benefit is lost if 'b' is also tested.
64         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
65         if (a == 0) {
66             return 0;
67         }
68 
69         uint256 c = a * b;
70         require(c / a == b, "SafeMath: multiplication overflow");
71 
72         return c;
73     }
74     function div(uint256 a, uint256 b) internal pure returns (uint256) {
75         return div(a, b, "SafeMath: division by zero");
76     }
77     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
78         // Solidity only automatically asserts when dividing by 0
79         require(b > 0, errorMessage);
80         uint256 c = a / b;
81         return c;
82     }
83     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
84         return mod(a, b, "SafeMath: modulo by zero");
85     }
86     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
87         require(b != 0, errorMessage);
88         return a % b;
89     }
90 }
91 
92 /**
93  * @title Standard ERC20 token
94  *
95  * @dev Implementation of the basic standard token.
96  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
97  */
98 contract InnerCoin is IERC20 {
99   using SafeMath for uint256;
100 
101   mapping (address => uint256) private _balances;
102 
103   mapping (address => mapping (address => uint256)) private _allowed;
104 
105   uint256 private _totalSupply;
106 
107   string public symbol;
108   string public  name;
109   uint8 public decimals;
110 
111     // ------------------------------------------------------------------------
112     // Constructor
113     // ------------------------------------------------------------------------
114     constructor() public {
115         symbol = "INC";
116         name = "Inner Coin";
117         decimals = 18;
118         _totalSupply = 7781040979000000000000000000;
119         _balances[0x34DF51D99039B10c278a481D3F91a8cfC1C8B9EF] = _totalSupply;
120         emit Transfer(address(0), 0x34DF51D99039B10c278a481D3F91a8cfC1C8B9EF, _totalSupply);
121     }
122 
123   /**
124   * @dev Total number of tokens in existence
125   */
126   function totalSupply() public view returns (uint256) {
127     return _totalSupply;
128   }
129 
130   /**
131   * @dev Gets the balance of the specified address.
132   * @param owner The address to query the balance of.
133   * @return An uint256 representing the amount owned by the passed address.
134   */
135   function balanceOf(address owner) public view returns (uint256) {
136     return _balances[owner];
137   }
138 
139   /**
140    * @dev Function to check the amount of tokens that an owner allowed to a spender.
141    * @param owner address The address which owns the funds.
142    * @param spender address The address which will spend the funds.
143    * @return A uint256 specifying the amount of tokens still available for the spender.
144    */
145   function allowance(
146     address owner,
147     address spender
148    )
149     public
150     view
151     returns (uint256)
152   {
153     return _allowed[owner][spender];
154   }
155 
156   /**
157   * @dev Transfer token for a specified address
158   * @param to The address to transfer to.
159   * @param value The amount to be transferred.
160   */
161   function transfer(address to, uint256 value) public returns (bool) {
162     require(value <= _balances[msg.sender], "Sender does not have enough amount");
163     require(to != address(0), "You can't send tokens to the null address");
164 
165     _balances[msg.sender] = _balances[msg.sender].sub(value);
166     _balances[to] = _balances[to].add(value);
167     emit Transfer(msg.sender, to, value);
168     return true;
169   }
170 
171   /**
172    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
173    * Beware that changing an allowance with this method brings the risk that someone may use both the old
174    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
175    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
176    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
177    * @param spender The address which will spend the funds.
178    * @param value The amount of tokens to be spent.
179    */
180   function approve(address spender, uint256 value) public returns (bool) {
181     require(spender != address(0), "Address is null");
182 
183     _allowed[msg.sender][spender] = value;
184     emit Approval(msg.sender, spender, value);
185     return true;
186   }
187 
188   /**
189    * @dev Transfer tokens from one address to another
190    * @param from address The address which you want to send tokens from
191    * @param to address The address which you want to transfer to
192    * @param value uint256 the amount of tokens to be transferred
193    */
194   function transferFrom(
195     address from,
196     address to,
197     uint256 value
198   )
199     public
200     returns (bool)
201   {
202     require(value <= _balances[from], "Balance not enough");
203     require(value <= _allowed[from][msg.sender], "Not allowed");
204     require(to != address(0), "Address is null");
205 
206     _balances[from] = _balances[from].sub(value);
207     _balances[to] = _balances[to].add(value);
208     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
209     emit Transfer(from, to, value);
210     return true;
211   }
212 
213   /**
214    * @dev Increase the amount of tokens that an owner allowed to a spender.
215    * approve should be called when allowed_[_spender] == 0. To increment
216    * allowed value is better to use this function to avoid 2 calls (and wait until
217    * the first transaction is mined)
218    * From MonolithDAO Token.sol
219    * @param spender The address which will spend the funds.
220    * @param addedValue The amount of tokens to increase the allowance by.
221    */
222   function increaseAllowance(
223     address spender,
224     uint256 addedValue
225   )
226     public
227     returns (bool)
228   {
229     require(spender != address(0), "Address is null");
230 
231     _allowed[msg.sender][spender] = (
232       _allowed[msg.sender][spender].add(addedValue));
233     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
234     return true;
235   }
236 
237   /**
238    * @dev Decrease the amount of tokens that an owner allowed to a spender.
239    * approve should be called when allowed_[_spender] == 0. To decrement
240    * allowed value is better to use this function to avoid 2 calls (and wait until
241    * the first transaction is mined)
242    * From MonolithDAO Token.sol
243    * @param spender The address which will spend the funds.
244    * @param subtractedValue The amount of tokens to decrease the allowance by.
245    */
246   function decreaseAllowance(
247     address spender,
248     uint256 subtractedValue
249   )
250     public
251     returns (bool)
252   {
253     require(spender != address(0), "Address is null");
254 
255     _allowed[msg.sender][spender] = (
256       _allowed[msg.sender][spender].sub(subtractedValue));
257     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
258     return true;
259   }
260 
261   // ------------------------------------------------------------------------
262     // Don't accept ETH
263     // ------------------------------------------------------------------------
264     function () public payable {
265         revert();
266     }
267 }