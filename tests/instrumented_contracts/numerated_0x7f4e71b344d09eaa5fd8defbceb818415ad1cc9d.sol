1 pragma solidity 0.4.25;
2 
3 
4 library SafeMath {
5 
6     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
7         if (_a == 0) {
8             return 0;
9         }
10 
11         uint256 c = _a * _b;
12         require(c / _a == _b);
13 
14         return c;
15     }
16 
17     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
18         require(_b > 0);
19         uint256 c = _a / _b;
20 
21         return c;
22     }
23 
24     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
25         require(_b <= _a);
26         uint256 c = _a - _b;
27 
28         return c;
29     }
30 
31     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
32         uint256 c = _a + _b;
33         require(c >= _a);
34 
35         return c;
36     }
37 
38     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
39         require(b != 0);
40         return a % b;
41     }
42 }
43 
44 interface IERC20 {
45   function totalSupply() external view returns (uint256);
46 
47   function balanceOf(address who) external view returns (uint256);
48 
49   function allowance(address owner, address spender)
50     external view returns (uint256);
51 
52   function transfer(address to, uint256 value) external returns (bool);
53 
54   function approve(address spender, uint256 value)
55     external returns (bool);
56 
57   function transferFrom(address from, address to, uint256 value)
58     external returns (bool);
59 
60   event Transfer(
61     address indexed from,
62     address indexed to,
63     uint256 value
64   );
65 
66   event Approval(
67     address indexed owner,
68     address indexed spender,
69     uint256 value
70   );
71 }
72 
73 /**
74  * @title Standard ERC20 token
75  */
76 contract ERC20 is IERC20 {
77   using SafeMath for uint256;
78 
79   mapping (address => uint256) private _balances;
80 
81   mapping (address => mapping (address => uint256)) private _allowed;
82 
83   uint256 private _totalSupply;
84 
85   /**
86   * @dev Total number of tokens in existence
87   */
88   function totalSupply() public view returns (uint256) {
89     return _totalSupply;
90   }
91 
92   /**
93   * @dev Gets the balance of the specified address.
94   * @param owner The address to query the balance of.
95   * @return An uint256 representing the amount owned by the passed address.
96   */
97   function balanceOf(address owner) public view returns (uint256) {
98     return _balances[owner];
99   }
100 
101   /**
102    * @dev Function to check the amount of tokens that an owner allowed to a spender.
103    * @param owner address The address which owns the funds.
104    * @param spender address The address which will spend the funds.
105    * @return A uint256 specifying the amount of tokens still available for the spender.
106    */
107   function allowance(
108     address owner,
109     address spender
110    )
111     public
112     view
113     returns (uint256)
114   {
115     return _allowed[owner][spender];
116   }
117 
118   /**
119   * @dev Transfer token for a specified address
120   * @param to The address to transfer to.
121   * @param value The amount to be transferred.
122   */
123   function transfer(address to, uint256 value) public returns (bool) {
124     _transfer(msg.sender, to, value);
125     return true;
126   }
127 
128   function approve(address spender, uint256 value) public returns (bool) {
129     require(spender != address(0));
130 
131     _allowed[msg.sender][spender] = value;
132     emit Approval(msg.sender, spender, value);
133     return true;
134   }
135 
136   /**
137    * @dev Transfer tokens from one address to another
138    * @param from address The address which you want to send tokens from
139    * @param to address The address which you want to transfer to
140    * @param value uint256 the amount of tokens to be transferred
141    */
142   function transferFrom(
143     address from,
144     address to,
145     uint256 value
146   )
147     public
148     returns (bool)
149   {
150     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
151     _transfer(from, to, value);
152     return true;
153   }
154 
155   function increaseAllowance(
156     address spender,
157     uint256 addedValue
158   )
159     public
160     returns (bool)
161   {
162     require(spender != address(0));
163 
164     _allowed[msg.sender][spender] = (
165       _allowed[msg.sender][spender].add(addedValue));
166     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
167     return true;
168   }
169 
170   function decreaseAllowance(
171     address spender,
172     uint256 subtractedValue
173   )
174     public
175     returns (bool)
176   {
177     require(spender != address(0));
178 
179     _allowed[msg.sender][spender] = (
180       _allowed[msg.sender][spender].sub(subtractedValue));
181     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
182     return true;
183   }
184 
185   /**
186   * @dev Transfer token for a specified addresses
187   * @param from The address to transfer from.
188   * @param to The address to transfer to.
189   * @param value The amount to be transferred.
190   */
191   function _transfer(address from, address to, uint256 value) internal {
192     require(to != address(0));
193 
194     _balances[from] = _balances[from].sub(value);
195     _balances[to] = _balances[to].add(value);
196     emit Transfer(from, to, value);
197   }
198 
199   /**
200    * @dev Internal function that mints an amount of the token and assigns it to
201    * an account. This encapsulates the modification of balances such that the
202    * proper events are emitted.
203    * @param account The account that will receive the created tokens.
204    * @param value The amount that will be created.
205    */
206   function _mint(address account, uint256 value) internal {
207     require(account != address(0));
208 
209     _totalSupply = _totalSupply.add(value);
210     _balances[account] = _balances[account].add(value);
211     emit Transfer(address(0), account, value);
212   }
213 
214   /**
215    * @dev Internal function that burns an amount of the token of a given
216    * account.
217    * @param account The account whose tokens will be burnt.
218    * @param value The amount that will be burnt.
219    */
220   function _burn(address account, uint256 value) internal {
221     require(account != address(0));
222 
223     _totalSupply = _totalSupply.sub(value);
224     _balances[account] = _balances[account].sub(value);
225     emit Transfer(account, address(0), value);
226   }
227 
228   /**
229    * @dev Internal function that burns an amount of the token of a given
230    * account, deducting from the sender's allowance for said account. Uses the
231    * internal burn function.
232    * @param account The account whose tokens will be burnt.
233    * @param value The amount that will be burnt.
234    */
235   function _burnFrom(address account, uint256 value) internal {
236     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
237       value);
238     _burn(account, value);
239   }
240 }
241 
242 
243 /**
244  * @title Burnable Token
245  * @dev Token that can be irreversibly burned (destroyed).
246  */
247 contract ERC20Burnable is ERC20 {
248 
249   /**
250    * @dev Burns a specific amount of tokens.
251    * @param value The amount of token to be burned.
252    */
253   function burn(uint256 value) public {
254     _burn(msg.sender, value);
255   }
256 
257   /**
258    * @dev Burns a specific amount of tokens from the target address and decrements allowance
259    * @param from address The address which you want to send tokens from
260    * @param value uint256 The amount of token to be burned
261    */
262   function burnFrom(address from, uint256 value) public {
263     _burnFrom(from, value);
264   }
265 }
266 
267 
268 contract LeadRexTokenX is ERC20Burnable {
269 
270     string private _name = "LeadRex Token X";
271     string private _symbol = "LDXX";
272     uint8 private _decimals = 18;
273 
274     uint256 constant INITIAL_SUPPLY = 33975000 * (10 ** 18);
275 
276     constructor() public {
277         _mint(0xC2F732432952bF38B32C14a92e0d43945F5bf733, INITIAL_SUPPLY);
278     }
279 
280     /**
281      * @return the name of the token.
282      */
283     function name() public view returns(string) {
284       return _name;
285     }
286 
287     /**
288      * @return the symbol of the token.
289      */
290     function symbol() public view returns(string) {
291       return _symbol;
292     }
293 
294     /**
295      * @return the number of decimals of the token.
296      */
297     function decimals() public view returns(uint8) {
298       return _decimals;
299     }
300 }