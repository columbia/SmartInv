1 pragma solidity ^0.4.23;
2 /**
3  * @title ERC20 interface
4  * @dev see https://eips.ethereum.org/EIPS/eip-20
5  */
6 interface IERC20 {
7     function transfer(address to, uint256 value) external returns (bool);
8 
9     function approve(address spender, uint256 value) external returns (bool);
10 
11     function transferFrom(address from, address to, uint256 value) external returns (bool);
12 
13     function totalSupply() external view returns (uint256);
14 
15     function balanceOf(address who) external view returns (uint256);
16 
17     function allowance(address owner, address spender) external view returns (uint256);
18 
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 
25 
26 
27 
28 
29 /**
30  * @title SafeMath
31  * @dev Unsigned math operations with safety checks that revert on error
32  */
33 library SafeMath {
34     /**
35      * @dev Multiplies two unsigned integers, reverts on overflow.
36      */
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
39         // benefit is lost if 'b' is also tested.
40         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
41         if (a == 0) {
42             return 0;
43         }
44 
45         uint256 c = a * b;
46         require(c / a == b);
47 
48         return c;
49     }
50 
51     /**
52      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
53      */
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         // Solidity only automatically asserts when dividing by 0
56         require(b > 0);
57         uint256 c = a / b;
58         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59 
60         return c;
61     }
62 
63     /**
64      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
65      */
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         require(b <= a);
68         uint256 c = a - b;
69 
70         return c;
71     }
72 
73     /**
74      * @dev Adds two unsigned integers, reverts on overflow.
75      */
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         require(c >= a);
79 
80         return c;
81     }
82 
83     /**
84      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
85      * reverts when dividing by zero.
86      */
87     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
88         require(b != 0);
89         return a % b;
90     }
91 }
92 
93 
94 /**
95  * @title Standard ERC20 token
96  *
97  * @dev Implementation of the basic standard token.
98  * https://eips.ethereum.org/EIPS/eip-20
99  * Originally based on code by FirstBlood:
100  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
101  *
102  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
103  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
104  * compliant implementations may not do it.
105  */
106 contract ERC20 is IERC20 {
107     using SafeMath for uint256;
108 
109     mapping (address => uint256) private _balances;
110 
111     mapping (address => mapping (address => uint256)) private _allowed;
112 
113     uint256 private _totalSupply;
114 
115     /**
116      * @dev Total number of tokens in existence
117      */
118     function totalSupply() public view returns (uint256) {
119         return _totalSupply;
120     }
121 
122     /**
123      * @dev Gets the balance of the specified address.
124      * @param owner The address to query the balance of.
125      * @return A uint256 representing the amount owned by the passed address.
126      */
127     function balanceOf(address owner) public view returns (uint256) {
128         return _balances[owner];
129     }
130 
131     /**
132      * @dev Function to check the amount of tokens that an owner allowed to a spender.
133      * @param owner address The address which owns the funds.
134      * @param spender address The address which will spend the funds.
135      * @return A uint256 specifying the amount of tokens still available for the spender.
136      */
137     function allowance(address owner, address spender) public view returns (uint256) {
138         return _allowed[owner][spender];
139     }
140 
141     /**
142      * @dev Transfer token to a specified address
143      * @param to The address to transfer to.
144      * @param value The amount to be transferred.
145      */
146     function transfer(address to, uint256 value) public returns (bool) {
147         _transfer(msg.sender, to, value);
148         return true;
149     }
150 
151     /**
152      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
153      * Beware that changing an allowance with this method brings the risk that someone may use both the old
154      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
155      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
156      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157      * @param spender The address which will spend the funds.
158      * @param value The amount of tokens to be spent.
159      */
160     function approve(address spender, uint256 value) public returns (bool) {
161         _approve(msg.sender, spender, value);
162         return true;
163     }
164 
165     /**
166      * @dev Transfer tokens from one address to another.
167      * Note that while this function emits an Approval event, this is not required as per the specification,
168      * and other compliant implementations may not emit the event.
169      * @param from address The address which you want to send tokens from
170      * @param to address The address which you want to transfer to
171      * @param value uint256 the amount of tokens to be transferred
172      */
173     function transferFrom(address from, address to, uint256 value) public returns (bool) {
174         _transfer(from, to, value);
175         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
176         return true;
177     }
178 
179     /**
180      * @dev Increase the amount of tokens that an owner allowed to a spender.
181      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
182      * allowed value is better to use this function to avoid 2 calls (and wait until
183      * the first transaction is mined)
184      * From MonolithDAO Token.sol
185      * Emits an Approval event.
186      * @param spender The address which will spend the funds.
187      * @param addedValue The amount of tokens to increase the allowance by.
188      */
189     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
190         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
191         return true;
192     }
193 
194     /**
195      * @dev Decrease the amount of tokens that an owner allowed to a spender.
196      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
197      * allowed value is better to use this function to avoid 2 calls (and wait until
198      * the first transaction is mined)
199      * From MonolithDAO Token.sol
200      * Emits an Approval event.
201      * @param spender The address which will spend the funds.
202      * @param subtractedValue The amount of tokens to decrease the allowance by.
203      */
204     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
205         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
206         return true;
207     }
208 
209     /**
210      * @dev Transfer token for a specified addresses
211      * @param from The address to transfer from.
212      * @param to The address to transfer to.
213      * @param value The amount to be transferred.
214      */
215     function _transfer(address from, address to, uint256 value) internal {
216         require(to != address(0));
217 
218         _balances[from] = _balances[from].sub(value);
219         _balances[to] = _balances[to].add(value);
220         emit Transfer(from, to, value);
221     }
222 
223     /**
224      * @dev Internal function that mints an amount of the token and assigns it to
225      * an account. This encapsulates the modification of balances such that the
226      * proper events are emitted.
227      * @param account The account that will receive the created tokens.
228      * @param value The amount that will be created.
229      */
230     function _mint(address account, uint256 value) internal {
231         require(account != address(0));
232 
233         _totalSupply = _totalSupply.add(value);
234         _balances[account] = _balances[account].add(value);
235         emit Transfer(address(0), account, value);
236     }
237 
238     /**
239      * @dev Internal function that burns an amount of the token of a given
240      * account.
241      * @param account The account whose tokens will be burnt.
242      * @param value The amount that will be burnt.
243      */
244     function _burn(address account, uint256 value) internal {
245         require(account != address(0));
246 
247         _totalSupply = _totalSupply.sub(value);
248         _balances[account] = _balances[account].sub(value);
249         emit Transfer(account, address(0), value);
250     }
251 
252     /**
253      * @dev Approve an address to spend another addresses' tokens.
254      * @param owner The address that owns the tokens.
255      * @param spender The address that will spend the tokens.
256      * @param value The number of tokens that can be spent.
257      */
258     function _approve(address owner, address spender, uint256 value) internal {
259         require(spender != address(0));
260         require(owner != address(0));
261 
262         _allowed[owner][spender] = value;
263         emit Approval(owner, spender, value);
264     }
265 
266     /**
267      * @dev Internal function that burns an amount of the token of a given
268      * account, deducting from the sender's allowance for said account. Uses the
269      * internal burn function.
270      * Emits an Approval event (reflecting the reduced allowance).
271      * @param account The account whose tokens will be burnt.
272      * @param value The amount that will be burnt.
273      */
274     function _burnFrom(address account, uint256 value) internal {
275         _burn(account, value);
276         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
277     }
278 }
279 
280 
281 
282 
283 
284 /**
285  * @title ERC20Detailed token
286  * @dev The decimals are only for visualization purposes.
287  * All the operations are done using the smallest and indivisible token unit,
288  * just as on Ethereum all the operations are done in wei.
289  */
290 contract ERC20Detailed is IERC20 {
291     string private _name;
292     string private _symbol;
293     uint8 private _decimals;
294 
295     constructor (string memory name, string memory symbol, uint8 decimals) public {
296         _name = name;
297         _symbol = symbol;
298         _decimals = decimals;
299     }
300 
301     /**
302      * @return the name of the token.
303      */
304     function name() public view returns (string memory) {
305         return _name;
306     }
307 
308     /**
309      * @return the symbol of the token.
310      */
311     function symbol() public view returns (string memory) {
312         return _symbol;
313     }
314 
315     /**
316      * @return the number of decimals of the token.
317      */
318     function decimals() public view returns (uint8) {
319         return _decimals;
320     }
321 }
322 contract LibertyCapitalContract is ERC20, ERC20Detailed {
323   
324   
325     uint8 public constant DECIMALS = 18;
326     uint256 public constant INITIAL_SUPPLY = 910000000 * (10 ** uint256(DECIMALS));
327 
328     /**
329      * @dev Constructor that gives msg.sender all of existing tokens.
330      */
331     constructor () public ERC20Detailed("Liberty Capital", "LBT", DECIMALS) {
332         _mint(msg.sender, INITIAL_SUPPLY);
333     }
334     
335 }