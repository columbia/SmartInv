1 pragma solidity ^0.5.2;
2 
3 
4 /**
5  * @title ERC20 interface
6  * @dev see https://eips.ethereum.org/EIPS/eip-20
7  */
8 interface IERC20 {
9     function transfer(address to, uint256 value) external returns (bool);
10 
11     function approve(address spender, uint256 value) external returns (bool);
12 
13     function transferFrom(address from, address to, uint256 value)
14         external
15         returns (bool);
16 
17     function totalSupply() external view returns (uint256);
18 
19     function balanceOf(address who) external view returns (uint256);
20 
21     function allowance(address owner, address spender)
22         external
23         view
24         returns (uint256);
25 
26     event Transfer(address indexed from, address indexed to, uint256 value);
27 
28     event Approval(
29         address indexed owner,
30         address indexed spender,
31         uint256 value
32     );
33 }
34 
35 pragma solidity ^0.5.2;
36 
37 
38 /**
39  * @title SafeMath
40  * @dev Unsigned math operations with safety checks that revert on error
41  */
42 library SafeMath {
43     /**
44      * @dev Multiplies two unsigned integers, reverts on overflow.
45      */
46     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
48         // benefit is lost if 'b' is also tested.
49         if (a == 0) {
50             return 0;
51         }
52 
53         uint256 c = a * b;
54         require(c / a == b);
55 
56         return c;
57     }
58 
59     /**
60      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
61      */
62     function div(uint256 a, uint256 b) internal pure returns (uint256) {
63         // Solidity only automatically asserts when dividing by 0
64         require(b > 0);
65         uint256 c = a / b;
66         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67 
68         return c;
69     }
70 
71     /**
72      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
73      */
74     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75         require(b <= a);
76         uint256 c = a - b;
77 
78         return c;
79     }
80 
81     /**
82      * @dev Adds two unsigned integers, reverts on overflow.
83      */
84     function add(uint256 a, uint256 b) internal pure returns (uint256) {
85         uint256 c = a + b;
86         require(c >= a);
87 
88         return c;
89     }
90 
91     /**
92      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
93      * reverts when dividing by zero.
94      */
95     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
96         require(b != 0);
97         return a % b;
98     }
99 }
100 
101 pragma solidity ^0.5.2;
102 
103 
104 /**
105  * @title Standard ERC20 token
106  *
107  * @dev Implementation of the basic standard token.
108  * https://eips.ethereum.org/EIPS/eip-20
109  *
110  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
111  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
112  * compliant implementations may not do it.
113  */
114 contract ERC20 is IERC20 {
115     using SafeMath for uint256;
116 
117     mapping(address => uint256) private _balances;
118 
119     mapping(address => mapping(address => uint256)) private _allowed;
120 
121     uint256 private _totalSupply;
122 
123     /**
124      * @dev Total number of tokens in existence
125      */
126     function totalSupply() public view returns (uint256) {
127         return _totalSupply;
128     }
129 
130     /**
131      * @dev Gets the balance of the specified address.
132      * @param owner The address to query the balance of.
133      * @return A uint256 representing the amount owned by the passed address.
134      */
135     function balanceOf(address owner) public view returns (uint256) {
136         return _balances[owner];
137     }
138 
139     /**
140      * @dev Function to check the amount of tokens that an owner allowed to a spender.
141      * @param owner address The address which owns the funds.
142      * @param spender address The address which will spend the funds.
143      * @return A uint256 specifying the amount of tokens still available for the spender.
144      */
145     function allowance(address owner, address spender)
146         public
147         view
148         returns (uint256)
149     {
150         return _allowed[owner][spender];
151     }
152 
153     /**
154      * @dev Transfer token to a specified address
155      * @param to The address to transfer to.
156      * @param value The amount to be transferred.
157      */
158     function transfer(address to, uint256 value) public returns (bool) {
159         _transfer(msg.sender, to, value);
160         return true;
161     }
162 
163     /**
164      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
165      * Beware that changing an allowance with this method brings the risk that someone may use both the old
166      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
167      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
168      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169      * @param spender The address which will spend the funds.
170      * @param value The amount of tokens to be spent.
171      */
172     function approve(address spender, uint256 value) public returns (bool) {
173         _approve(msg.sender, spender, value);
174         return true;
175     }
176 
177     /**
178      * @dev Transfer tokens from one address to another.
179      * Note that while this function emits an Approval event, this is not required as per the specification,
180      * and other compliant implementations may not emit the event.
181      * @param from address The address which you want to send tokens from
182      * @param to address The address which you want to transfer to
183      * @param value uint256 the amount of tokens to be transferred
184      */
185     function transferFrom(address from, address to, uint256 value)
186         public
187         returns (bool)
188     {
189         _transfer(from, to, value);
190         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
191         return true;
192     }
193 
194     /**
195      * @dev Increase the amount of tokens that an owner allowed to a spender.
196      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
197      * allowed value is better to use this function to avoid 2 calls (and wait until
198      * the first transaction is mined)
199      * From MonolithDAO Token.sol
200      * Emits an Approval event.
201      * @param spender The address which will spend the funds.
202      * @param addedValue The amount of tokens to increase the allowance by.
203      */
204     function increaseAllowance(address spender, uint256 addedValue)
205         public
206         returns (bool)
207     {
208         _approve(
209             msg.sender,
210             spender,
211             _allowed[msg.sender][spender].add(addedValue)
212         );
213         return true;
214     }
215 
216     /**
217      * @dev Decrease the amount of tokens that an owner allowed to a spender.
218      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
219      * allowed value is better to use this function to avoid 2 calls (and wait until
220      * the first transaction is mined)
221      * From MonolithDAO Token.sol
222      * Emits an Approval event.
223      * @param spender The address which will spend the funds.
224      * @param subtractedValue The amount of tokens to decrease the allowance by.
225      */
226     function decreaseAllowance(address spender, uint256 subtractedValue)
227         public
228         returns (bool)
229     {
230         _approve(
231             msg.sender,
232             spender,
233             _allowed[msg.sender][spender].sub(subtractedValue)
234         );
235         return true;
236     }
237 
238     /**
239      * @dev Transfer token for a specified addresses
240      * @param from The address to transfer from.
241      * @param to The address to transfer to.
242      * @param value The amount to be transferred.
243      */
244     function _transfer(address from, address to, uint256 value) internal {
245         require(to != address(0));
246 
247         _balances[from] = _balances[from].sub(value);
248         _balances[to] = _balances[to].add(value);
249         emit Transfer(from, to, value);
250     }
251 
252     /**
253      * @dev Internal function that mints an amount of the token and assigns it to
254      * an account. This encapsulates the modification of balances such that the
255      * proper events are emitted.
256      * @param account The account that will receive the created tokens.
257      * @param value The amount that will be created.
258      */
259     function _mint(address account, uint256 value) internal {
260         require(account != address(0));
261 
262         _totalSupply = _totalSupply.add(value);
263         _balances[account] = _balances[account].add(value);
264         emit Transfer(address(0), account, value);
265     }
266 
267     /**
268      * @dev Internal function that burns an amount of the token of a given
269      * account.
270      * @param account The account whose tokens will be burnt.
271      * @param value The amount that will be burnt.
272      */
273     function _burn(address account, uint256 value) internal {
274         require(account != address(0));
275 
276         _totalSupply = _totalSupply.sub(value);
277         _balances[account] = _balances[account].sub(value);
278         emit Transfer(account, address(0), value);
279     }
280 
281     /**
282      * @dev Approve an address to spend another addresses' tokens.
283      * @param owner The address that owns the tokens.
284      * @param spender The address that will spend the tokens.
285      * @param value The number of tokens that can be spent.
286      */
287     function _approve(address owner, address spender, uint256 value) internal {
288         require(spender != address(0));
289         require(owner != address(0));
290 
291         _allowed[owner][spender] = value;
292         emit Approval(owner, spender, value);
293     }
294 
295     /**
296      * @dev Internal function that burns an amount of the token of a given
297      * account, deducting from the sender's allowance for said account. Uses the
298      * internal burn function.
299      * Emits an Approval event (reflecting the reduced allowance).
300      * @param account The account whose tokens will be burnt.
301      * @param value The amount that will be burnt.
302      */
303     function _burnFrom(address account, uint256 value) internal {
304         _burn(account, value);
305         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
306     }
307 }
308 
309 pragma solidity ^0.5.2;
310 
311 
312 /**
313  * @title ERC20Detailed token
314  * @dev The decimals are only for visualization purposes.
315  * All the operations are done using the smallest and indivisible token unit,
316  * just as on Ethereum all the operations are done in wei.
317  */
318 contract ERC20Detailed is IERC20 {
319     string private _name;
320     string private _symbol;
321     uint8 private _decimals;
322 
323     constructor(string memory name, string memory symbol, uint8 decimals)
324         public
325     {
326         _name = name;
327         _symbol = symbol;
328         _decimals = decimals;
329     }
330 
331     /**
332      * @return the name of the token.
333      */
334     function name() public view returns (string memory) {
335         return _name;
336     }
337 
338     /**
339      * @return the symbol of the token.
340      */
341     function symbol() public view returns (string memory) {
342         return _symbol;
343     }
344 
345     /**
346      * @return the number of decimals of the token.
347      */
348     function decimals() public view returns (uint8) {
349         return _decimals;
350     }
351 }
352 
353 pragma solidity ^0.5.2;
354 
355 
356 /**
357  * @title Burnable Token
358  * @dev Token that can be irreversibly burned (destroyed).
359  */
360 contract ERC20Burnable is ERC20 {
361     /**
362      * @dev Burns a specific amount of tokens.
363      * @param value The amount of token to be burned.
364      */
365     function burn(uint256 value) public {
366         _burn(msg.sender, value);
367     }
368 
369     /**
370      * @dev Burns a specific amount of tokens from the target address and decrements allowance
371      * @param from address The account whose tokens will be burned.
372      * @param value uint256 The amount of token to be burned.
373      */
374     function burnFrom(address from, uint256 value) public {
375         _burnFrom(from, value);
376     }
377 }
378 
379 pragma solidity ^0.5.0;
380 
381 
382 contract P2PG is ERC20, ERC20Detailed, ERC20Burnable {
383     constructor() public ERC20Detailed("P2PG", "P2PGO", 8) {
384         _mint(msg.sender, 600_000_000 * 10**8);
385     }
386 }