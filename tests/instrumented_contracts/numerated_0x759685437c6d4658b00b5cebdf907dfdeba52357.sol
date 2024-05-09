1 pragma solidity 0.5.2;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that revert on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, reverts on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     uint256 c = a * b;
22     require(c / a == b);
23 
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     require(b > 0); // Solidity only automatically asserts when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35     return c;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     require(b <= a);
43     uint256 c = a - b;
44 
45     return c;
46   }
47 
48   /**
49   * @dev Adds two numbers, reverts on overflow.
50   */
51   function add(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a + b;
53     require(c >= a);
54 
55     return c;
56   }
57 
58   /**
59   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
60   * reverts when dividing by zero.
61   */
62   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b != 0);
64     return a % b;
65   }
66 }
67 
68 
69 /**
70  * @title Standard ERC20 token
71  *
72  * @dev Implementation of the basic standard token.
73  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
74  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
75  */
76 contract MyToken {
77   using SafeMath for uint256;
78 
79   mapping (address => uint256) private _balances;
80 
81   mapping (address => mapping (address => uint256)) private _allowed;
82 
83   uint256 private _totalSupply;
84   
85   string private _name;
86   string private _symbol;
87   uint8 private _decimals;
88 
89   constructor() public {
90     _name = "Dukas Coins";
91     _symbol = "DUK+";
92     _decimals = 4;
93 
94     _totalSupply = 200000000000000;
95     _balances[msg.sender] = _totalSupply;
96     emit Transfer(address(0), msg.sender, _totalSupply);
97   }
98   
99   /**
100    * @return the name of the token.
101    */
102   function name() public view returns(string memory) {
103     return _name;
104   }
105 
106   /**
107    * @return the symbol of the token.
108    */
109   function symbol() public view returns(string memory) {
110     return _symbol;
111   }
112 
113   /**
114    * @return the number of decimals of the token.
115    */
116   function decimals() public view returns(uint8) {
117     return _decimals;
118   }
119 
120 
121   /**
122   * @dev Total number of tokens in existence
123   */
124   function totalSupply() public view returns (uint256) {
125     return _totalSupply;
126   }
127 
128   /**
129   * @dev Gets the balance of the specified address.
130   * @param owner The address to query the balance of.
131   * @return An uint256 representing the amount owned by the passed address.
132   */
133   function balanceOf(address owner) public view returns (uint256) {
134     return _balances[owner];
135   }
136 
137   /**
138    * @dev Function to check the amount of tokens that an owner allowed to a spender.
139    * @param owner address The address which owns the funds.
140    * @param spender address The address which will spend the funds.
141    * @return A uint256 specifying the amount of tokens still available for the spender.
142    */
143   function allowance(
144     address owner,
145     address spender
146    )
147     public
148     view
149     returns (uint256)
150   {
151     return _allowed[owner][spender];
152   }
153 
154   /**
155   * @dev Transfer token for a specified address
156   * @param to The address to transfer to.
157   * @param value The amount to be transferred.
158   */
159   function transfer(address to, uint256 value) public returns (bool) {
160     _transfer(msg.sender, to, value);
161     return true;
162   }
163 
164   /**
165    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
166    * Beware that changing an allowance with this method brings the risk that someone may use both the old
167    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
168    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
169    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
170    * @param spender The address which will spend the funds.
171    * @param value The amount of tokens to be spent.
172    */
173   function approve(address spender, uint256 value) public returns (bool) {
174     require(spender != address(0));
175 
176     _allowed[msg.sender][spender] = value;
177     emit Approval(msg.sender, spender, value);
178     return true;
179   }
180 
181   /**
182    * @dev Transfer tokens from one address to another
183    * @param from address The address which you want to send tokens from
184    * @param to address The address which you want to transfer to
185    * @param value uint256 the amount of tokens to be transferred
186    */
187   function transferFrom(
188     address from,
189     address to,
190     uint256 value
191   )
192     public
193     returns (bool)
194   {
195     require(value <= _allowed[from][msg.sender]);
196 
197     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
198     _transfer(from, to, value);
199     return true;
200   }
201 
202   /**
203    * @dev Increase the amount of tokens that an owner allowed to a spender.
204    * approve should be called when allowed_[_spender] == 0. To increment
205    * allowed value is better to use this function to avoid 2 calls (and wait until
206    * the first transaction is mined)
207    * From MonolithDAO Token.sol
208    * @param spender The address which will spend the funds.
209    * @param addedValue The amount of tokens to increase the allowance by.
210    */
211   function increaseAllowance(
212     address spender,
213     uint256 addedValue
214   )
215     public
216     returns (bool)
217   {
218     require(spender != address(0));
219 
220     _allowed[msg.sender][spender] = (
221       _allowed[msg.sender][spender].add(addedValue));
222     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
223     return true;
224   }
225 
226   /**
227    * @dev Decrease the amount of tokens that an owner allowed to a spender.
228    * approve should be called when allowed_[_spender] == 0. To decrement
229    * allowed value is better to use this function to avoid 2 calls (and wait until
230    * the first transaction is mined)
231    * From MonolithDAO Token.sol
232    * @param spender The address which will spend the funds.
233    * @param subtractedValue The amount of tokens to decrease the allowance by.
234    */
235   function decreaseAllowance(
236     address spender,
237     uint256 subtractedValue
238   )
239     public
240     returns (bool)
241   {
242     require(spender != address(0));
243 
244     _allowed[msg.sender][spender] = (
245       _allowed[msg.sender][spender].sub(subtractedValue));
246     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
247     return true;
248   }
249 
250   /**
251   * @dev Transfer token for a specified addresses
252   * @param from The address to transfer from.
253   * @param to The address to transfer to.
254   * @param value The amount to be transferred.
255   */
256   function _transfer(address from, address to, uint256 value) internal {
257     require(value <= _balances[from]);
258     require(to != address(0));
259 
260     _balances[from] = _balances[from].sub(value);
261     _balances[to] = _balances[to].add(value);
262     emit Transfer(from, to, value);
263   }
264   
265   event Transfer(
266     address indexed from,
267     address indexed to,
268     uint256 value
269   );
270 
271   event Approval(
272     address indexed owner,
273     address indexed spender,
274     uint256 value
275   );
276 }