1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8     function totalSupply() external view returns (uint256);
9 
10     function balanceOf(address who) external view returns (uint256);
11 
12     function allowance(address owner, address spender) external view returns (uint256);
13 
14     function transfer(address to, uint256 value) external returns (bool);
15 
16     function approve(address spender, uint256 value) external returns (bool);
17 
18     function transferFrom(address from, address to, uint256 value) external returns (bool);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 /**
26  * @title SafeMath
27  * @dev Math operations with safety checks that revert on error
28  */
29 library SafeMath {
30     /**
31     * @dev Multiplies two numbers, reverts on overflow.
32     */
33     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
35         // benefit is lost if 'b' is also tested.
36         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
37         if (a == 0) {
38             return 0;
39         }
40 
41         uint256 c = a * b;
42         require(c / a == b);
43 
44         return c;
45     }
46 
47     /**
48     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
49     */
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         // Solidity only automatically asserts when dividing by 0
52         require(b > 0);
53         uint256 c = a / b;
54         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55 
56         return c;
57     }
58 
59     /**
60     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
61     */
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b <= a);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70     * @dev Adds two numbers, reverts on overflow.
71     */
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a);
75 
76         return c;
77     }
78 
79     /**
80     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
81     * reverts when dividing by zero.
82     */
83     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
84         require(b != 0);
85         return a % b;
86     }
87 }
88 
89 /**
90  * @title Standard ERC20 token
91  *
92  * @dev Implementation of the basic standard token.
93  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
94  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
95  *
96  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
97  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
98  * compliant implementations may not do it.
99  */
100 contract ERC20 is IERC20 {
101     using SafeMath for uint256;
102 
103     mapping (address => uint256) private _balances;
104 
105     mapping (address => mapping (address => uint256)) private _allowed;
106 
107     uint256 private _totalSupply;
108 
109     /**
110     * @dev Total number of tokens in existence
111     */
112     function totalSupply() public view returns (uint256) {
113         return _totalSupply;
114     }
115 
116     /**
117     * @dev Gets the balance of the specified address.
118     * @param owner The address to query the balance of.
119     * @return An uint256 representing the amount owned by the passed address.
120     */
121     function balanceOf(address owner) public view returns (uint256) {
122         return _balances[owner];
123     }
124 
125     /**
126      * @dev Function to check the amount of tokens that an owner allowed to a spender.
127      * @param owner address The address which owns the funds.
128      * @param spender address The address which will spend the funds.
129      * @return A uint256 specifying the amount of tokens still available for the spender.
130      */
131     function allowance(address owner, address spender) public view returns (uint256) {
132         return _allowed[owner][spender];
133     }
134 
135     /**
136     * @dev Transfer token for a specified address
137     * @param to The address to transfer to.
138     * @param value The amount to be transferred.
139     */
140     function transfer(address to, uint256 value) public returns (bool) {
141         _transfer(msg.sender, to, value);
142         return true;
143     }
144 
145     /**
146      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
147      * Beware that changing an allowance with this method brings the risk that someone may use both the old
148      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
149      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
150      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151      * @param spender The address which will spend the funds.
152      * @param value The amount of tokens to be spent.
153      */
154     function approve(address spender, uint256 value) public returns (bool) {
155         require(spender != address(0));
156 
157         _allowed[msg.sender][spender] = value;
158         emit Approval(msg.sender, spender, value);
159         return true;
160     }
161 
162     /**
163      * @dev Transfer tokens from one address to another.
164      * Note that while this function emits an Approval event, this is not required as per the specification,
165      * and other compliant implementations may not emit the event.
166      * @param from address The address which you want to send tokens from
167      * @param to address The address which you want to transfer to
168      * @param value uint256 the amount of tokens to be transferred
169      */
170     function transferFrom(address from, address to, uint256 value) public returns (bool) {
171         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
172         _transfer(from, to, value);
173         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
174         return true;
175     }
176 
177     /**
178      * @dev Increase the amount of tokens that an owner allowed to a spender.
179      * approve should be called when allowed_[_spender] == 0. To increment
180      * allowed value is better to use this function to avoid 2 calls (and wait until
181      * the first transaction is mined)
182      * From MonolithDAO Token.sol
183      * Emits an Approval event.
184      * @param spender The address which will spend the funds.
185      * @param addedValue The amount of tokens to increase the allowance by.
186      */
187     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
188         require(spender != address(0));
189 
190         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
191         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
192         return true;
193     }
194 
195     /**
196      * @dev Decrease the amount of tokens that an owner allowed to a spender.
197      * approve should be called when allowed_[_spender] == 0. To decrement
198      * allowed value is better to use this function to avoid 2 calls (and wait until
199      * the first transaction is mined)
200      * From MonolithDAO Token.sol
201      * Emits an Approval event.
202      * @param spender The address which will spend the funds.
203      * @param subtractedValue The amount of tokens to decrease the allowance by.
204      */
205     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
206         require(spender != address(0));
207 
208         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
209         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
210         return true;
211     }
212 
213     /**
214     * @dev Transfer token for a specified addresses
215     * @param from The address to transfer from.
216     * @param to The address to transfer to.
217     * @param value The amount to be transferred.
218     */
219     function _transfer(address from, address to, uint256 value) internal {
220         require(to != address(0));
221 
222         _balances[from] = _balances[from].sub(value);
223         _balances[to] = _balances[to].add(value);
224         emit Transfer(from, to, value);
225     }
226 
227     /**
228      * @dev Internal function that mints an amount of the token and assigns it to
229      * an account. This encapsulates the modification of balances such that the
230      * proper events are emitted.
231      * @param account The account that will receive the created tokens.
232      * @param value The amount that will be created.
233      */
234     function _mint(address account, uint256 value) internal {
235         require(account != address(0));
236 
237         _totalSupply = _totalSupply.add(value);
238         _balances[account] = _balances[account].add(value);
239         emit Transfer(address(0), account, value);
240     }
241 
242     /**
243      * @dev Internal function that burns an amount of the token of a given
244      * account.
245      * @param account The account whose tokens will be burnt.
246      * @param value The amount that will be burnt.
247      */
248     function _burn(address account, uint256 value) internal {
249         require(account != address(0));
250 
251         _totalSupply = _totalSupply.sub(value);
252         _balances[account] = _balances[account].sub(value);
253         emit Transfer(account, address(0), value);
254     }
255 
256     /**
257      * @dev Internal function that burns an amount of the token of a given
258      * account, deducting from the sender's allowance for said account. Uses the
259      * internal burn function.
260      * Emits an Approval event (reflecting the reduced allowance).
261      * @param account The account whose tokens will be burnt.
262      * @param value The amount that will be burnt.
263      */
264     function _burnFrom(address account, uint256 value) internal {
265         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
266         _burn(account, value);
267         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
268     }
269 }
270 
271 /**
272  * @title ERC20Detailed token
273  * @dev The decimals are only for visualization purposes.
274  * All the operations are done using the smallest and indivisible token unit,
275  * just as on Ethereum all the operations are done in wei.
276  */
277 contract ERC20Detailed is IERC20 {
278     string private _name;
279     string private _symbol;
280     uint8 private _decimals;
281 
282     constructor (string memory name, string memory symbol, uint8 decimals) public {
283         _name = name;
284         _symbol = symbol;
285         _decimals = decimals;
286     }
287 
288     /**
289      * @return the name of the token.
290      */
291     function name() public view returns (string memory) {
292         return _name;
293     }
294 
295     /**
296      * @return the symbol of the token.
297      */
298     function symbol() public view returns (string memory) {
299         return _symbol;
300     }
301 
302     /**
303      * @return the number of decimals of the token.
304      */
305     function decimals() public view returns (uint8) {
306         return _decimals;
307     }
308 }
309 
310 /**
311  * @title SimpleToken
312  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
313  * Note they can later distribute these tokens as they wish using `transfer` and other
314  * `ERC20` functions.
315  */
316 contract SimpleToken is ERC20, ERC20Detailed {
317     /**
318      * @dev Constructor that gives msg.sender all of existing tokens.
319      */
320     constructor (
321         uint256 _initialAmount,
322         string memory _tokenName,
323         uint8 _decimalUnits,
324         string memory _tokenSymbol
325 
326     ) public ERC20Detailed(_tokenName, _tokenSymbol, _decimalUnits) {
327         _mint(msg.sender, _initialAmount * (10 ** uint256(_decimalUnits)));
328     }
329 }