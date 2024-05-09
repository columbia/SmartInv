1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://eips.ethereum.org/EIPS/eip-20
6  */
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 /**
26  * @title Standard ERC20 token
27  *
28  * @dev Implementation of the basic standard token.
29  * https://eips.ethereum.org/EIPS/eip-20
30  * Originally based on code by FirstBlood:
31  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
32  *
33  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
34  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
35  * compliant implementations may not do it.
36  */
37 contract ERC20 is IERC20 {
38     using SafeMath for uint256;
39 
40     mapping (address => uint256) private _balances;
41 
42     mapping (address => mapping (address => uint256)) private _allowed;
43 
44     uint256 private _totalSupply;
45 
46     /**
47      * @dev Total number of tokens in existence.
48      */
49     function totalSupply() public view returns (uint256) {
50         return _totalSupply;
51     }
52 
53     /**
54      * @dev Gets the balance of the specified address.
55      * @param owner The address to query the balance of.
56      * @return A uint256 representing the amount owned by the passed address.
57      */
58     function balanceOf(address owner) public view returns (uint256) {
59         return _balances[owner];
60     }
61 
62     /**
63      * @dev Function to check the amount of tokens that an owner allowed to a spender.
64      * @param owner address The address which owns the funds.
65      * @param spender address The address which will spend the funds.
66      * @return A uint256 specifying the amount of tokens still available for the spender.
67      */
68     function allowance(address owner, address spender) public view returns (uint256) {
69         return _allowed[owner][spender];
70     }
71 
72     /**
73      * @dev Transfer token to a specified address.
74      * @param to The address to transfer to.
75      * @param value The amount to be transferred.
76      */
77     function transfer(address to, uint256 value) public returns (bool) {
78         _transfer(msg.sender, to, value);
79         return true;
80     }
81 
82     /**
83      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
84      * Beware that changing an allowance with this method brings the risk that someone may use both the old
85      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
86      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
87      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
88      * @param spender The address which will spend the funds.
89      * @param value The amount of tokens to be spent.
90      */
91     function approve(address spender, uint256 value) public returns (bool) {
92         _approve(msg.sender, spender, value);
93         return true;
94     }
95 
96     /**
97      * @dev Transfer tokens from one address to another.
98      * Note that while this function emits an Approval event, this is not required as per the specification,
99      * and other compliant implementations may not emit the event.
100      * @param from address The address which you want to send tokens from
101      * @param to address The address which you want to transfer to
102      * @param value uint256 the amount of tokens to be transferred
103      */
104     function transferFrom(address from, address to, uint256 value) public returns (bool) {
105         _transfer(from, to, value);
106         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
107         return true;
108     }
109 
110     /**
111      * @dev Increase the amount of tokens that an owner allowed to a spender.
112      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
113      * allowed value is better to use this function to avoid 2 calls (and wait until
114      * the first transaction is mined)
115      * From MonolithDAO Token.sol
116      * Emits an Approval event.
117      * @param spender The address which will spend the funds.
118      * @param addedValue The amount of tokens to increase the allowance by.
119      */
120     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
121         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
122         return true;
123     }
124 
125     /**
126      * @dev Decrease the amount of tokens that an owner allowed to a spender.
127      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
128      * allowed value is better to use this function to avoid 2 calls (and wait until
129      * the first transaction is mined)
130      * From MonolithDAO Token.sol
131      * Emits an Approval event.
132      * @param spender The address which will spend the funds.
133      * @param subtractedValue The amount of tokens to decrease the allowance by.
134      */
135     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
136         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
137         return true;
138     }
139 
140     /**
141      * @dev Transfer token for a specified addresses.
142      * @param from The address to transfer from.
143      * @param to The address to transfer to.
144      * @param value The amount to be transferred.
145      */
146     function _transfer(address from, address to, uint256 value) internal {
147         require(to != address(0));
148 
149         _balances[from] = _balances[from].sub(value);
150         _balances[to] = _balances[to].add(value);
151         emit Transfer(from, to, value);
152     }
153 
154     /**
155      * @dev Internal function that mints an amount of the token and assigns it to
156      * an account. This encapsulates the modification of balances such that the
157      * proper events are emitted.
158      * @param account The account that will receive the created tokens.
159      * @param value The amount that will be created.
160      */
161     function _mint(address account, uint256 value) internal {
162         require(account != address(0));
163 
164         _totalSupply = _totalSupply.add(value);
165         _balances[account] = _balances[account].add(value);
166         emit Transfer(address(0), account, value);
167     }
168 
169     /**
170      * @dev Internal function that burns an amount of the token of a given
171      * account.
172      * @param account The account whose tokens will be burnt.
173      * @param value The amount that will be burnt.
174      */
175     function _burn(address account, uint256 value) internal {
176         require(account != address(0));
177 
178         _totalSupply = _totalSupply.sub(value);
179         _balances[account] = _balances[account].sub(value);
180         emit Transfer(account, address(0), value);
181     }
182 
183     /**
184      * @dev Approve an address to spend another addresses' tokens.
185      * @param owner The address that owns the tokens.
186      * @param spender The address that will spend the tokens.
187      * @param value The number of tokens that can be spent.
188      */
189     function _approve(address owner, address spender, uint256 value) internal {
190         require(spender != address(0));
191         require(owner != address(0));
192 
193         _allowed[owner][spender] = value;
194         emit Approval(owner, spender, value);
195     }
196 
197     /**
198      * @dev Internal function that burns an amount of the token of a given
199      * account, deducting from the sender's allowance for said account. Uses the
200      * internal burn function.
201      * Emits an Approval event (reflecting the reduced allowance).
202      * @param account The account whose tokens will be burnt.
203      * @param value The amount that will be burnt.
204      */
205     function _burnFrom(address account, uint256 value) internal {
206         _burn(account, value);
207         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
208     }
209 }
210 
211 
212 
213 /**
214  * @title Burnable Token
215  * @dev Token that can be irreversibly burned (destroyed).
216  */
217 contract ERC20Burnable is ERC20 {
218     /**
219      * @dev Burns a specific amount of tokens.
220      * @param value The amount of token to be burned.
221      */
222     function burn(uint256 value) public {
223         _burn(msg.sender, value);
224     }
225 
226     /**
227      * @dev Burns a specific amount of tokens from the target address and decrements allowance.
228      * @param from address The account whose tokens will be burned.
229      * @param value uint256 The amount of token to be burned.
230      */
231     function burnFrom(address from, uint256 value) public {
232         _burnFrom(from, value);
233     }
234 }
235 
236 /**
237  * @title ERC20Detailed token
238  * @dev The decimals are only for visualization purposes.
239  * All the operations are done using the smallest and indivisible token unit,
240  * just as on Ethereum all the operations are done in wei.
241  */
242 contract ERC20Detailed is IERC20 {
243     string private _name;
244     string private _symbol;
245     uint8 private _decimals;
246 
247     constructor (string memory name, string memory symbol, uint8 decimals) public {
248         _name = name;
249         _symbol = symbol;
250         _decimals = decimals;
251     }
252 
253     /**
254      * @return the name of the token.
255      */
256     function name() public view returns (string memory) {
257         return _name;
258     }
259 
260     /**
261      * @return the symbol of the token.
262      */
263     function symbol() public view returns (string memory) {
264         return _symbol;
265     }
266 
267     /**
268      * @return the number of decimals of the token.
269      */
270     function decimals() public view returns (uint8) {
271         return _decimals;
272     }
273 }
274 
275 library SafeMath {
276     /**
277      * @dev Multiplies two unsigned integers, reverts on overflow.
278      */
279     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
280         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
281         // benefit is lost if 'b' is also tested.
282         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
283         if (a == 0) {
284             return 0;
285         }
286 
287         uint256 c = a * b;
288         require(c / a == b);
289 
290         return c;
291     }
292 
293     /**
294      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
295      */
296     function div(uint256 a, uint256 b) internal pure returns (uint256) {
297         // Solidity only automatically asserts when dividing by 0
298         require(b > 0);
299         uint256 c = a / b;
300         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
301 
302         return c;
303     }
304 
305     /**
306      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
307      */
308     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
309         require(b <= a);
310         uint256 c = a - b;
311 
312         return c;
313     }
314 
315     /**
316      * @dev Adds two unsigned integers, reverts on overflow.
317      */
318     function add(uint256 a, uint256 b) internal pure returns (uint256) {
319         uint256 c = a + b;
320         require(c >= a);
321 
322         return c;
323     }
324 
325     /**
326      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
327      * reverts when dividing by zero.
328      */
329     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
330         require(b != 0);
331         return a % b;
332     }
333 }
334 
335 /**
336  * @title tranToken
337  * Note they can later distribute these tokens as they wish using `transfer` and other
338  * `ERC20` functions.
339  */
340 contract ndwtToken is ERC20, ERC20Burnable, ERC20Detailed {
341     uint8 public constant DECIMALS = 18;
342     uint256 public constant INITIAL_SUPPLY = 40000000000 * (10 ** uint256(DECIMALS)); 
343 
344     /**
345      * @dev Constructor that gives msg.sender all of existing tokens.
346      */
347     constructor () public ERC20Detailed("Summit Token", "SMIT", 18) {
348         _mint(msg.sender, INITIAL_SUPPLY); 
349     }
350 }