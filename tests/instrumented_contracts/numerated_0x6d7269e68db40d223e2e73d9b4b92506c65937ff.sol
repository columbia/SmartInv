1 pragma solidity >=0.4.21 <0.6.0;
2 
3 /* openzeppelin-solidity - safemath */
4 library SafeMath {
5 
6   /**
7   * @dev Multiplies two numbers, reverts on overflow.
8   */
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
11     // benefit is lost if 'b' is also tested.
12     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
13     if (a == 0) {
14       return 0;
15     }
16 
17     uint256 c = a * b;
18     require(c / a == b);
19 
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     require(b > 0); // Solidity only automatically asserts when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30 
31     return c;
32   }
33 
34   /**
35   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     require(b <= a);
39     uint256 c = a - b;
40 
41     return c;
42   }
43 
44   /**
45   * @dev Adds two numbers, reverts on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256) {
48     uint256 c = a + b;
49     require(c >= a);
50 
51     return c;
52   }
53 
54   /**
55   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
56   * reverts when dividing by zero.
57   */
58   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
59     require(b != 0);
60     return a % b;
61   }
62 }
63 
64 library AddressValidation {
65     function okAddress(address _address) internal pure returns (bool) {
66         if (_address == address(0)) return false;
67         //if (_address == address(1)) return false;
68         return true;
69     }
70 }
71 
72 interface IERC20 {
73   function totalSupply() external view returns (uint256);
74 
75   //function balanceOf(address who) external view returns (uint256);
76 
77   function allowance(address owner, address spender)
78     external view returns (uint256);
79 
80   function transfer(address to, uint256 value) external returns (bool);
81 
82   function approve(address spender, uint256 value)
83     external returns (bool);
84 
85   function transferFrom(address from, address to, uint256 value)
86     external returns (bool);
87 
88   event Transfer(
89     address indexed from,
90     address indexed to,
91     uint256 value
92   );
93 
94   event Approval(
95     address indexed owner,
96     address indexed spender,
97     uint256 value
98   );
99 }
100 
101 
102 /* openzeppelin-solidity ERC20 */
103 contract ERC20 is IERC20 {
104   using SafeMath for uint256;
105   using AddressValidation for address;
106 
107   mapping (address => uint256) public _balances;
108 
109   mapping (address => mapping (address => uint256)) private _allowed;
110 
111   uint256 private _totalSupply;
112 
113   /**
114   * @dev Total number of tokens in existence
115   */
116   function totalSupply() public view returns (uint256) {
117     return _totalSupply;
118   }
119 
120   function setTotalSupply(uint256 amount) internal {
121       _totalSupply = amount;
122   }
123 
124   /**
125   * @dev Gets the balance of the specified address.
126   * @param owner The address to query the balance of.
127   * @return An uint256 representing the amount owned by the passed address.
128   */
129   function balanceOf(address owner) public view returns (uint256) {
130     return _balances[owner];
131   }
132 
133   /**
134    * @dev Function to check the amount of tokens that an owner allowed to a spender.
135    * @param owner address The address which owns the funds.
136    * @param spender address The address which will spend the funds.
137    * @return A uint256 specifying the amount of tokens still available for the spender.
138    */
139   function allowance(
140     address owner,
141     address spender
142    )
143     public
144     view
145     returns (uint256)
146   {
147     return _allowed[owner][spender];
148   }
149 
150   /**
151   * @dev Transfer token for a specified address
152   * @param to The address to transfer to.
153   * @param value The amount to be transferred.
154   */
155   function transfer(address to, uint256 value) public returns (bool) {
156     _transfer(msg.sender, to, value);
157     return true;
158   }
159 
160   /**
161    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
162    * Beware that changing an allowance with this method brings the risk that someone may use both the old
163    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
164    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
165    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
166    * @param spender The address which will spend the funds.
167    * @param value The amount of tokens to be spent.
168    */
169   function approve(address spender, uint256 value) public returns (bool) {
170     require(spender.okAddress(), "Address not valid on approve");
171 
172     _allowed[msg.sender][spender] = value;
173     emit Approval(msg.sender, spender, value);
174     return true;
175   }
176 
177   /**
178    * @dev Transfer tokens from one address to another
179    * @param from address The address which you want to send tokens from
180    * @param to address The address which you want to transfer to
181    * @param value uint256 the amount of tokens to be transferred
182    */
183   function transferFrom(
184     address from,
185     address to,
186     uint256 value
187   )
188     public
189     returns (bool)
190   {
191     require(value <= _allowed[from][msg.sender], "Transfer amount too high for what is allowed");
192 
193     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
194     _transfer(from, to, value);
195     return true;
196   }
197 
198   /**
199    * @dev Increase the amount of tokens that an owner allowed to a spender.
200    * approve should be called when allowed_[_spender] == 0. To increment
201    * allowed value is better to use this function to avoid 2 calls (and wait until
202    * the first transaction is mined)
203    * From MonolithDAO Token.sol
204    * @param spender The address which will spend the funds.
205    * @param addedValue The amount of tokens to increase the allowance by.
206    */
207   function increaseAllowance(
208     address spender,
209     uint256 addedValue
210   )
211     public
212     returns (bool)
213   {
214     require(spender.okAddress(), "Address not valid on increase allowance");
215 
216     _allowed[msg.sender][spender] = (
217       _allowed[msg.sender][spender].add(addedValue));
218     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
219     return true;
220   }
221 
222   /**
223    * @dev Decrease the amount of tokens that an owner allowed to a spender.
224    * approve should be called when allowed_[_spender] == 0. To decrement
225    * allowed value is better to use this function to avoid 2 calls (and wait until
226    * the first transaction is mined)
227    * From MonolithDAO Token.sol
228    * @param spender The address which will spend the funds.
229    * @param subtractedValue The amount of tokens to decrease the allowance by.
230    */
231   function decreaseAllowance(
232     address spender,
233     uint256 subtractedValue
234   )
235     public
236     returns (bool)
237   {
238     require(spender.okAddress(), "Address not valid on decrease allowance");
239 
240     _allowed[msg.sender][spender] = (
241       _allowed[msg.sender][spender].sub(subtractedValue));
242     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
243     return true;
244   }
245 
246   /**
247   * @dev Transfer token for a specified addresses
248   * @param from The address to transfer from.
249   * @param to The address to transfer to.
250   * @param value The amount to be transferred.
251   */
252   function _transfer(address from, address to, uint256 value) internal {
253     require(value <= _balances[from], "Value too high to transfer from address");
254     require(to.okAddress(), "Address not valid to transfer to");
255 
256     _balances[from] = _balances[from].sub(value);
257     _balances[to] = _balances[to].add(value);
258     emit Transfer(from, to, value);
259   }
260 
261   /**
262    * @dev Internal function that mints an amount of the token and assigns it to
263    * an account. This encapsulates the modification of balances such that the
264    * proper events are emitted.
265    * @param account The account that will receive the created tokens.
266    * @param value The amount that will be created.
267    */
268   function _mint(address account, uint256 value) internal {
269     require(account.okAddress(), "Address not valid for mint");
270     _totalSupply = _totalSupply.add(value);
271     _balances[account] = _balances[account].add(value);
272     emit Transfer(address(0), account, value);
273   }
274 
275   /**
276    * @dev Internal function that burns an amount of the token of a given
277    * account.
278    * @param account The account whose tokens will be burnt.
279    * @param value The amount that will be burnt.
280    */
281   function _burn(address account, uint256 value) internal {
282     require(account.okAddress(), "Address not valid for burn");
283     require(value <= _balances[account], "Value is more that balance for address for burn");
284 
285     _totalSupply = _totalSupply.sub(value);
286     _balances[account] = _balances[account].sub(value);
287     emit Transfer(account, address(0), value);
288   }
289 
290   /**
291    * @dev Internal function that burns an amount of the token of a given
292    * account, deducting from the sender's allowance for said account. Uses the
293    * internal burn function.
294    * @param account The account whose tokens will be burnt.
295    * @param value The amount that will be burnt.
296    */
297   function _burnFrom(address account, uint256 value) internal {
298     require(value <= _allowed[account][msg.sender], "Value is higher than allowed to burn");
299 
300     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
301     // this function needs to emit an event with the updated approval.
302     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
303       value);
304     _burn(account, value);
305   }
306 }
307 
308 /* RLP token contract */
309 contract RLPToken is ERC20 {
310     string public name = "rLoop";
311     string public symbol = "RLP";
312     uint256 public decimals = 18;
313 
314     constructor() public {
315     
316         setTotalSupply(1000000000000000000000000000);
317         _balances[address(0)] = totalSupply();
318 
319         _transfer(address(0), msg.sender, totalSupply());
320         //emit Transfer(address(0), msg.sender, totalSupply());
321     }
322 }