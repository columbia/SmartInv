1 // Copyright (C) Chromapolis Devcenter OU 2019
2 
3 
4 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
5 
6 pragma solidity ^0.5.2;
7 
8 /**
9  * @title ERC20 interface
10  * @dev see https://eips.ethereum.org/EIPS/eip-20
11  */
12 interface IERC20 {
13     function transfer(address to, uint256 value) external returns (bool);
14 
15     function approve(address spender, uint256 value) external returns (bool);
16 
17     function transferFrom(address from, address to, uint256 value) external returns (bool);
18 
19     function totalSupply() external view returns (uint256);
20 
21     function balanceOf(address who) external view returns (uint256);
22 
23     function allowance(address owner, address spender) external view returns (uint256);
24 
25     event Transfer(address indexed from, address indexed to, uint256 value);
26 
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
31 
32 pragma solidity ^0.5.2;
33 
34 /**
35  * @title SafeMath
36  * @dev Unsigned math operations with safety checks that revert on error
37  */
38 library SafeMath {
39     /**
40      * @dev Multiplies two unsigned integers, reverts on overflow.
41      */
42     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
44         // benefit is lost if 'b' is also tested.
45         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
46         if (a == 0) {
47             return 0;
48         }
49 
50         uint256 c = a * b;
51         require(c / a == b);
52 
53         return c;
54     }
55 
56     /**
57      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
58      */
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         // Solidity only automatically asserts when dividing by 0
61         require(b > 0);
62         uint256 c = a / b;
63         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
64 
65         return c;
66     }
67 
68     /**
69      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
70      */
71     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72         require(b <= a);
73         uint256 c = a - b;
74 
75         return c;
76     }
77 
78     /**
79      * @dev Adds two unsigned integers, reverts on overflow.
80      */
81     function add(uint256 a, uint256 b) internal pure returns (uint256) {
82         uint256 c = a + b;
83         require(c >= a);
84 
85         return c;
86     }
87 
88     /**
89      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
90      * reverts when dividing by zero.
91      */
92     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
93         require(b != 0);
94         return a % b;
95     }
96 }
97 
98 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
99 
100 pragma solidity ^0.5.2;
101 
102 
103 
104 /**
105  * @title Standard ERC20 token
106  *
107  * @dev Implementation of the basic standard token.
108  * https://eips.ethereum.org/EIPS/eip-20
109  * Originally based on code by FirstBlood:
110  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
111  *
112  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
113  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
114  * compliant implementations may not do it.
115  */
116 contract ERC20 is IERC20 {
117     using SafeMath for uint256;
118 
119     mapping (address => uint256) private _balances;
120 
121     mapping (address => mapping (address => uint256)) private _allowed;
122 
123     uint256 private _totalSupply;
124 
125     /**
126      * @dev Total number of tokens in existence
127      */
128     function totalSupply() public view returns (uint256) {
129         return _totalSupply;
130     }
131 
132     /**
133      * @dev Gets the balance of the specified address.
134      * @param owner The address to query the balance of.
135      * @return A uint256 representing the amount owned by the passed address.
136      */
137     function balanceOf(address owner) public view returns (uint256) {
138         return _balances[owner];
139     }
140 
141     /**
142      * @dev Function to check the amount of tokens that an owner allowed to a spender.
143      * @param owner address The address which owns the funds.
144      * @param spender address The address which will spend the funds.
145      * @return A uint256 specifying the amount of tokens still available for the spender.
146      */
147     function allowance(address owner, address spender) public view returns (uint256) {
148         return _allowed[owner][spender];
149     }
150 
151     /**
152      * @dev Transfer token to a specified address
153      * @param to The address to transfer to.
154      * @param value The amount to be transferred.
155      */
156     function transfer(address to, uint256 value) public returns (bool) {
157         _transfer(msg.sender, to, value);
158         return true;
159     }
160 
161     /**
162      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
163      * Beware that changing an allowance with this method brings the risk that someone may use both the old
164      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
165      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
166      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167      * @param spender The address which will spend the funds.
168      * @param value The amount of tokens to be spent.
169      */
170     function approve(address spender, uint256 value) public returns (bool) {
171         _approve(msg.sender, spender, value);
172         return true;
173     }
174 
175     /**
176      * @dev Transfer tokens from one address to another.
177      * Note that while this function emits an Approval event, this is not required as per the specification,
178      * and other compliant implementations may not emit the event.
179      * @param from address The address which you want to send tokens from
180      * @param to address The address which you want to transfer to
181      * @param value uint256 the amount of tokens to be transferred
182      */
183     function transferFrom(address from, address to, uint256 value) public returns (bool) {
184         _transfer(from, to, value);
185         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
186         return true;
187     }
188 
189     /**
190      * @dev Increase the amount of tokens that an owner allowed to a spender.
191      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
192      * allowed value is better to use this function to avoid 2 calls (and wait until
193      * the first transaction is mined)
194      * From MonolithDAO Token.sol
195      * Emits an Approval event.
196      * @param spender The address which will spend the funds.
197      * @param addedValue The amount of tokens to increase the allowance by.
198      */
199     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
200         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
201         return true;
202     }
203 
204     /**
205      * @dev Decrease the amount of tokens that an owner allowed to a spender.
206      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
207      * allowed value is better to use this function to avoid 2 calls (and wait until
208      * the first transaction is mined)
209      * From MonolithDAO Token.sol
210      * Emits an Approval event.
211      * @param spender The address which will spend the funds.
212      * @param subtractedValue The amount of tokens to decrease the allowance by.
213      */
214     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
215         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
216         return true;
217     }
218 
219     /**
220      * @dev Transfer token for a specified addresses
221      * @param from The address to transfer from.
222      * @param to The address to transfer to.
223      * @param value The amount to be transferred.
224      */
225     function _transfer(address from, address to, uint256 value) internal {
226         require(to != address(0));
227 
228         _balances[from] = _balances[from].sub(value);
229         _balances[to] = _balances[to].add(value);
230         emit Transfer(from, to, value);
231     }
232 
233     /**
234      * @dev Internal function that mints an amount of the token and assigns it to
235      * an account. This encapsulates the modification of balances such that the
236      * proper events are emitted.
237      * @param account The account that will receive the created tokens.
238      * @param value The amount that will be created.
239      */
240     function _mint(address account, uint256 value) internal {
241         require(account != address(0));
242 
243         _totalSupply = _totalSupply.add(value);
244         _balances[account] = _balances[account].add(value);
245         emit Transfer(address(0), account, value);
246     }
247 
248     /**
249      * @dev Internal function that burns an amount of the token of a given
250      * account.
251      * @param account The account whose tokens will be burnt.
252      * @param value The amount that will be burnt.
253      */
254     function _burn(address account, uint256 value) internal {
255         require(account != address(0));
256 
257         _totalSupply = _totalSupply.sub(value);
258         _balances[account] = _balances[account].sub(value);
259         emit Transfer(account, address(0), value);
260     }
261 
262     /**
263      * @dev Approve an address to spend another addresses' tokens.
264      * @param owner The address that owns the tokens.
265      * @param spender The address that will spend the tokens.
266      * @param value The number of tokens that can be spent.
267      */
268     function _approve(address owner, address spender, uint256 value) internal {
269         require(spender != address(0));
270         require(owner != address(0));
271 
272         _allowed[owner][spender] = value;
273         emit Approval(owner, spender, value);
274     }
275 
276     /**
277      * @dev Internal function that burns an amount of the token of a given
278      * account, deducting from the sender's allowance for said account. Uses the
279      * internal burn function.
280      * Emits an Approval event (reflecting the reduced allowance).
281      * @param account The account whose tokens will be burnt.
282      * @param value The amount that will be burnt.
283      */
284     function _burnFrom(address account, uint256 value) internal {
285         _burn(account, value);
286         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
287     }
288 }
289 
290 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
291 
292 pragma solidity ^0.5.2;
293 
294 
295 /**
296  * @title ERC20Detailed token
297  * @dev The decimals are only for visualization purposes.
298  * All the operations are done using the smallest and indivisible token unit,
299  * just as on Ethereum all the operations are done in wei.
300  */
301 contract ERC20Detailed is IERC20 {
302     string private _name;
303     string private _symbol;
304     uint8 private _decimals;
305 
306     constructor (string memory name, string memory symbol, uint8 decimals) public {
307         _name = name;
308         _symbol = symbol;
309         _decimals = decimals;
310     }
311 
312     /**
313      * @return the name of the token.
314      */
315     function name() public view returns (string memory) {
316         return _name;
317     }
318 
319     /**
320      * @return the symbol of the token.
321      */
322     function symbol() public view returns (string memory) {
323         return _symbol;
324     }
325 
326     /**
327      * @return the number of decimals of the token.
328      */
329     function decimals() public view returns (uint8) {
330         return _decimals;
331     }
332 }
333 
334 // File: contracts/token/ERC20/Chromia.sol
335 
336 // Copyright (C) Chromapolis Devcenter OU 2019
337 
338 pragma solidity 0.5.8;
339 
340 
341 
342 contract Chromia is ERC20, ERC20Detailed {
343     uint8 public constant DECIMALS = 6;
344     address private _minter;
345     // one billion tokens with 6 decimals
346     uint256 private _cap = 1000000000 * 1000000;
347 
348     event MinterSet(address indexed account);
349     event TransferToChromia(address indexed from, bytes32 indexed to, uint256 value);
350     event TransferFromChromia(address indexed to, bytes32 indexed refID, uint256 value);
351 
352     /**
353      * @dev Constructor that gives msg.sender all of existing tokens.
354      * @param minter the multi-sig contract address
355      */
356     constructor(address minter, uint256 initialBalance) public ERC20Detailed("Chroma", "CHR", DECIMALS) {
357         _mint(msg.sender, initialBalance);
358         _setMinter(minter);
359     }
360 
361     modifier onlyMinter() {
362         require(isMinter(msg.sender), "caller is not a minter");
363         _;
364     }
365     
366     function cap() public view returns (uint256) {
367         return _cap;
368     }
369 
370     /**
371      * @dev Burns a specific amount of tokens and emit transfer event for Chromia
372      * @param to The address to transfer to in Chromia.
373      * @param value The amount of token to be burned.
374      */
375     function transferToChromia(bytes32 to, uint256 value) public {
376         _burn(msg.sender, value);
377         emit TransferToChromia(msg.sender, to, value);
378     }
379 
380     /**
381      * @dev Function to mint tokens
382      * @param to The address that will receive the minted tokens.
383      * @param value The amount of tokens to mint.
384      * @return A boolean that indicates if the operation was successful.
385      */
386     function transferFromChromia(address to, uint256 value, bytes32 refID) public onlyMinter returns (bool) {
387         _mint(to, value);
388         emit TransferFromChromia(to, refID, value);
389         return true;
390     }
391     
392     function _mint(address account, uint256 value) internal {
393         require(totalSupply().add(value) <= cap(), "ERC20Capped: cap exceeded");
394         super._mint(account, value);
395     }
396 
397     function isMinter(address account) public view returns (bool) {
398         return _minter == account;
399     }
400 
401     function _setMinter(address account) internal {
402         _minter = account;
403         emit MinterSet(account);
404     }
405     
406     function changeMinter(address newMinter) public onlyMinter {
407         _setMinter(newMinter);
408     }
409 }