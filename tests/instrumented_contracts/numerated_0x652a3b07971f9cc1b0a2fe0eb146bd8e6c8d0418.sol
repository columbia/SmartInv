1 pragma solidity ^0.4.25;
2 
3 
4 
5 
6 /**
7  * @title ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/20
9  */
10 interface IERC20 {
11     function transfer(address to, uint256 value) external returns (bool);
12 
13     function approve(address spender, uint256 value) external returns (bool);
14 
15     function transferFrom(address from, address to, uint256 value) external returns (bool);
16 
17     function totalSupply() external view returns (uint256);
18 
19     function balanceOf(address who) external view returns (uint256);
20 
21     function allowance(address owner, address spender) external view returns (uint256);
22 
23     event Transfer(address indexed from, address indexed to, uint256 value);
24 
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 
29 /**
30  * @title ERC20Detailed token
31  * @dev The decimals are only for visualization purposes.
32  * All the operations are done using the smallest and indivisible token unit,
33  * just as on Ethereum all the operations are done in wei.
34  */
35 contract ERC20Detailed is IERC20 {
36     string private _name;
37     string private _symbol;
38     uint8 private _decimals;
39 
40     constructor (string memory name, string memory symbol, uint8 decimals) public {
41         _name = name;
42         _symbol = symbol;
43         _decimals = decimals;
44     }
45 
46     /**
47      * @return the name of the token.
48      */
49     function name() public view returns (string memory) {
50         return _name;
51     }
52 
53     /**
54      * @return the symbol of the token.
55      */
56     function symbol() public view returns (string memory) {
57         return _symbol;
58     }
59 
60     /**
61      * @return the number of decimals of the token.
62      */
63     function decimals() public view returns (uint8) {
64         return _decimals;
65     }
66 }
67 
68 
69 
70 
71 
72 
73 /**
74  * @title SafeMath
75  * @dev Unsigned math operations with safety checks that revert on error
76  */
77 library SafeMath {
78     /**
79     * @dev Multiplies two unsigned integers, reverts on overflow.
80     */
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
83         // benefit is lost if 'b' is also tested.
84         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
85         if (a == 0) {
86             return 0;
87         }
88 
89         uint256 c = a * b;
90         require(c / a == b);
91 
92         return c;
93     }
94 
95     /**
96     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
97     */
98     function div(uint256 a, uint256 b) internal pure returns (uint256) {
99         // Solidity only automatically asserts when dividing by 0
100         require(b > 0);
101         uint256 c = a / b;
102         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
103 
104         return c;
105     }
106 
107     /**
108     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
109     */
110     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
111         require(b <= a);
112         uint256 c = a - b;
113 
114         return c;
115     }
116 
117     /**
118     * @dev Adds two unsigned integers, reverts on overflow.
119     */
120     function add(uint256 a, uint256 b) internal pure returns (uint256) {
121         uint256 c = a + b;
122         require(c >= a);
123 
124         return c;
125     }
126 
127     /**
128     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
129     * reverts when dividing by zero.
130     */
131     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
132         require(b != 0);
133         return a % b;
134     }
135 }
136 
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
143  * Originally based on code by FirstBlood:
144  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
145  *
146  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
147  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
148  * compliant implementations may not do it.
149  */
150 contract ERC20 is IERC20 {
151     using SafeMath for uint256;
152 
153     mapping (address => uint256) private _balances;
154 
155     mapping (address => mapping (address => uint256)) private _allowed;
156 
157     uint256 private _totalSupply;
158 
159     /**
160     * @dev Total number of tokens in existence
161     */
162     function totalSupply() public view returns (uint256) {
163         return _totalSupply;
164     }
165 
166     /**
167     * @dev Gets the balance of the specified address.
168     * @param owner The address to query the balance of.
169     * @return An uint256 representing the amount owned by the passed address.
170     */
171     function balanceOf(address owner) public view returns (uint256) {
172         return _balances[owner];
173     }
174 
175     /**
176      * @dev Function to check the amount of tokens that an owner allowed to a spender.
177      * @param owner address The address which owns the funds.
178      * @param spender address The address which will spend the funds.
179      * @return A uint256 specifying the amount of tokens still available for the spender.
180      */
181     function allowance(address owner, address spender) public view returns (uint256) {
182         return _allowed[owner][spender];
183     }
184 
185     /**
186     * @dev Transfer token for a specified address
187     * @param to The address to transfer to.
188     * @param value The amount to be transferred.
189     */
190     function transfer(address to, uint256 value) public returns (bool) {
191         _transfer(msg.sender, to, value);
192         return true;
193     }
194 
195     /**
196      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
197      * Beware that changing an allowance with this method brings the risk that someone may use both the old
198      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
199      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
200      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201      * @param spender The address which will spend the funds.
202      * @param value The amount of tokens to be spent.
203      */
204     function approve(address spender, uint256 value) public returns (bool) {
205         require(spender != address(0));
206 
207         _allowed[msg.sender][spender] = value;
208         emit Approval(msg.sender, spender, value);
209         return true;
210     }
211 
212     /**
213      * @dev Transfer tokens from one address to another.
214      * Note that while this function emits an Approval event, this is not required as per the specification,
215      * and other compliant implementations may not emit the event.
216      * @param from address The address which you want to send tokens from
217      * @param to address The address which you want to transfer to
218      * @param value uint256 the amount of tokens to be transferred
219      */
220     function transferFrom(address from, address to, uint256 value) public returns (bool) {
221         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
222         _transfer(from, to, value);
223         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
224         return true;
225     }
226 
227     /**
228      * @dev Increase the amount of tokens that an owner allowed to a spender.
229      * approve should be called when allowed_[_spender] == 0. To increment
230      * allowed value is better to use this function to avoid 2 calls (and wait until
231      * the first transaction is mined)
232      * From MonolithDAO Token.sol
233      * Emits an Approval event.
234      * @param spender The address which will spend the funds.
235      * @param addedValue The amount of tokens to increase the allowance by.
236      */
237     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
238         require(spender != address(0));
239 
240         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
241         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
242         return true;
243     }
244 
245     /**
246      * @dev Decrease the amount of tokens that an owner allowed to a spender.
247      * approve should be called when allowed_[_spender] == 0. To decrement
248      * allowed value is better to use this function to avoid 2 calls (and wait until
249      * the first transaction is mined)
250      * From MonolithDAO Token.sol
251      * Emits an Approval event.
252      * @param spender The address which will spend the funds.
253      * @param subtractedValue The amount of tokens to decrease the allowance by.
254      */
255     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
256         require(spender != address(0));
257 
258         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
259         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
260         return true;
261     }
262 
263     /**
264     * @dev Transfer token for a specified addresses
265     * @param from The address to transfer from.
266     * @param to The address to transfer to.
267     * @param value The amount to be transferred.
268     */
269     function _transfer(address from, address to, uint256 value) internal {
270         require(to != address(0));
271 
272         _balances[from] = _balances[from].sub(value);
273         _balances[to] = _balances[to].add(value);
274         emit Transfer(from, to, value);
275     }
276 
277     /**
278      * @dev Internal function that mints an amount of the token and assigns it to
279      * an account. This encapsulates the modification of balances such that the
280      * proper events are emitted.
281      * @param account The account that will receive the created tokens.
282      * @param value The amount that will be created.
283      */
284     function _mint(address account, uint256 value) internal {
285         require(account != address(0));
286 
287         _totalSupply = _totalSupply.add(value);
288         _balances[account] = _balances[account].add(value);
289         emit Transfer(address(0), account, value);
290     }
291 
292     /**
293      * @dev Internal function that burns an amount of the token of a given
294      * account.
295      * @param account The account whose tokens will be burnt.
296      * @param value The amount that will be burnt.
297      */
298     function _burn(address account, uint256 value) internal {
299         require(account != address(0));
300 
301         _totalSupply = _totalSupply.sub(value);
302         _balances[account] = _balances[account].sub(value);
303         emit Transfer(account, address(0), value);
304     }
305 
306     /**
307      * @dev Internal function that burns an amount of the token of a given
308      * account, deducting from the sender's allowance for said account. Uses the
309      * internal burn function.
310      * Emits an Approval event (reflecting the reduced allowance).
311      * @param account The account whose tokens will be burnt.
312      * @param value The amount that will be burnt.
313      */
314     function _burnFrom(address account, uint256 value) internal {
315         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
316         _burn(account, value);
317         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
318     }
319 }
320 
321 
322 contract DILK is ERC20, ERC20Detailed {
323     uint256 public constant INITIAL_SUPPLY = 21000000 * (10 ** uint256(decimals()));
324     
325     constructor () public ERC20Detailed("DigitalToken", "DILK", 18){
326         _mint(msg.sender, INITIAL_SUPPLY);
327     }
328 }