1 pragma solidity ^0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 // input  /home/zoom/prg/melon-token/contracts/Melon.sol
6 // flattened :  Friday, 18-Jan-19 18:22:38 UTC
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
25 library SafeMath {
26     int256 constant private INT256_MIN = -2**255;
27 
28     /**
29     * @dev Multiplies two unsigned integers, reverts on overflow.
30     */
31     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
33         // benefit is lost if 'b' is also tested.
34         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
35         if (a == 0) {
36             return 0;
37         }
38 
39         uint256 c = a * b;
40         require(c / a == b);
41 
42         return c;
43     }
44 
45     /**
46     * @dev Multiplies two signed integers, reverts on overflow.
47     */
48     function mul(int256 a, int256 b) internal pure returns (int256) {
49         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
50         // benefit is lost if 'b' is also tested.
51         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
52         if (a == 0) {
53             return 0;
54         }
55 
56         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
57 
58         int256 c = a * b;
59         require(c / a == b);
60 
61         return c;
62     }
63 
64     /**
65     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
66     */
67     function div(uint256 a, uint256 b) internal pure returns (uint256) {
68         // Solidity only automatically asserts when dividing by 0
69         require(b > 0);
70         uint256 c = a / b;
71         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72 
73         return c;
74     }
75 
76     /**
77     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
78     */
79     function div(int256 a, int256 b) internal pure returns (int256) {
80         require(b != 0); // Solidity only automatically asserts when dividing by 0
81         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
82 
83         int256 c = a / b;
84 
85         return c;
86     }
87 
88     /**
89     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
90     */
91     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
92         require(b <= a);
93         uint256 c = a - b;
94 
95         return c;
96     }
97 
98     /**
99     * @dev Subtracts two signed integers, reverts on overflow.
100     */
101     function sub(int256 a, int256 b) internal pure returns (int256) {
102         int256 c = a - b;
103         require((b >= 0 && c <= a) || (b < 0 && c > a));
104 
105         return c;
106     }
107 
108     /**
109     * @dev Adds two unsigned integers, reverts on overflow.
110     */
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         uint256 c = a + b;
113         require(c >= a);
114 
115         return c;
116     }
117 
118     /**
119     * @dev Adds two signed integers, reverts on overflow.
120     */
121     function add(int256 a, int256 b) internal pure returns (int256) {
122         int256 c = a + b;
123         require((b >= 0 && c >= a) || (b < 0 && c < a));
124 
125         return c;
126     }
127 
128     /**
129     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
130     * reverts when dividing by zero.
131     */
132     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
133         require(b != 0);
134         return a % b;
135     }
136 }
137 
138 contract ERC20Detailed is IERC20 {
139     string private _name;
140     string private _symbol;
141     uint8 private _decimals;
142 
143     constructor (string name, string symbol, uint8 decimals) public {
144         _name = name;
145         _symbol = symbol;
146         _decimals = decimals;
147     }
148 
149     /**
150      * @return the name of the token.
151      */
152     function name() public view returns (string) {
153         return _name;
154     }
155 
156     /**
157      * @return the symbol of the token.
158      */
159     function symbol() public view returns (string) {
160         return _symbol;
161     }
162 
163     /**
164      * @return the number of decimals of the token.
165      */
166     function decimals() public view returns (uint8) {
167         return _decimals;
168     }
169 }
170 
171 contract ERC20 is IERC20 {
172     using SafeMath for uint256;
173 
174     mapping (address => uint256) private _balances;
175 
176     mapping (address => mapping (address => uint256)) private _allowed;
177 
178     uint256 private _totalSupply;
179 
180     /**
181     * @dev Total number of tokens in existence
182     */
183     function totalSupply() public view returns (uint256) {
184         return _totalSupply;
185     }
186 
187     /**
188     * @dev Gets the balance of the specified address.
189     * @param owner The address to query the balance of.
190     * @return An uint256 representing the amount owned by the passed address.
191     */
192     function balanceOf(address owner) public view returns (uint256) {
193         return _balances[owner];
194     }
195 
196     /**
197      * @dev Function to check the amount of tokens that an owner allowed to a spender.
198      * @param owner address The address which owns the funds.
199      * @param spender address The address which will spend the funds.
200      * @return A uint256 specifying the amount of tokens still available for the spender.
201      */
202     function allowance(address owner, address spender) public view returns (uint256) {
203         return _allowed[owner][spender];
204     }
205 
206     /**
207     * @dev Transfer token for a specified address
208     * @param to The address to transfer to.
209     * @param value The amount to be transferred.
210     */
211     function transfer(address to, uint256 value) public returns (bool) {
212         _transfer(msg.sender, to, value);
213         return true;
214     }
215 
216     /**
217      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
218      * Beware that changing an allowance with this method brings the risk that someone may use both the old
219      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
220      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
221      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
222      * @param spender The address which will spend the funds.
223      * @param value The amount of tokens to be spent.
224      */
225     function approve(address spender, uint256 value) public returns (bool) {
226         require(spender != address(0));
227 
228         _allowed[msg.sender][spender] = value;
229         emit Approval(msg.sender, spender, value);
230         return true;
231     }
232 
233     /**
234      * @dev Transfer tokens from one address to another.
235      * Note that while this function emits an Approval event, this is not required as per the specification,
236      * and other compliant implementations may not emit the event.
237      * @param from address The address which you want to send tokens from
238      * @param to address The address which you want to transfer to
239      * @param value uint256 the amount of tokens to be transferred
240      */
241     function transferFrom(address from, address to, uint256 value) public returns (bool) {
242         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
243         _transfer(from, to, value);
244         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
245         return true;
246     }
247 
248     /**
249      * @dev Increase the amount of tokens that an owner allowed to a spender.
250      * approve should be called when allowed_[_spender] == 0. To increment
251      * allowed value is better to use this function to avoid 2 calls (and wait until
252      * the first transaction is mined)
253      * From MonolithDAO Token.sol
254      * Emits an Approval event.
255      * @param spender The address which will spend the funds.
256      * @param addedValue The amount of tokens to increase the allowance by.
257      */
258     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
259         require(spender != address(0));
260 
261         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
262         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
263         return true;
264     }
265 
266     /**
267      * @dev Decrease the amount of tokens that an owner allowed to a spender.
268      * approve should be called when allowed_[_spender] == 0. To decrement
269      * allowed value is better to use this function to avoid 2 calls (and wait until
270      * the first transaction is mined)
271      * From MonolithDAO Token.sol
272      * Emits an Approval event.
273      * @param spender The address which will spend the funds.
274      * @param subtractedValue The amount of tokens to decrease the allowance by.
275      */
276     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
277         require(spender != address(0));
278 
279         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
280         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
281         return true;
282     }
283 
284     /**
285     * @dev Transfer token for a specified addresses
286     * @param from The address to transfer from.
287     * @param to The address to transfer to.
288     * @param value The amount to be transferred.
289     */
290     function _transfer(address from, address to, uint256 value) internal {
291         require(to != address(0));
292 
293         _balances[from] = _balances[from].sub(value);
294         _balances[to] = _balances[to].add(value);
295         emit Transfer(from, to, value);
296     }
297 
298     /**
299      * @dev Internal function that mints an amount of the token and assigns it to
300      * an account. This encapsulates the modification of balances such that the
301      * proper events are emitted.
302      * @param account The account that will receive the created tokens.
303      * @param value The amount that will be created.
304      */
305     function _mint(address account, uint256 value) internal {
306         require(account != address(0));
307 
308         _totalSupply = _totalSupply.add(value);
309         _balances[account] = _balances[account].add(value);
310         emit Transfer(address(0), account, value);
311     }
312 
313     /**
314      * @dev Internal function that burns an amount of the token of a given
315      * account.
316      * @param account The account whose tokens will be burnt.
317      * @param value The amount that will be burnt.
318      */
319     function _burn(address account, uint256 value) internal {
320         require(account != address(0));
321 
322         _totalSupply = _totalSupply.sub(value);
323         _balances[account] = _balances[account].sub(value);
324         emit Transfer(account, address(0), value);
325     }
326 
327     /**
328      * @dev Internal function that burns an amount of the token of a given
329      * account, deducting from the sender's allowance for said account. Uses the
330      * internal burn function.
331      * Emits an Approval event (reflecting the reduced allowance).
332      * @param account The account whose tokens will be burnt.
333      * @param value The amount that will be burnt.
334      */
335     function _burnFrom(address account, uint256 value) internal {
336         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
337         _burn(account, value);
338         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
339     }
340 }
341 
342 contract ERC20Burnable is ERC20 {
343     /**
344      * @dev Burns a specific amount of tokens.
345      * @param value The amount of token to be burned.
346      */
347     function burn(uint256 value) public {
348         _burn(msg.sender, value);
349     }
350 
351     /**
352      * @dev Burns a specific amount of tokens from the target address and decrements allowance
353      * @param from address The address which you want to send tokens from
354      * @param value uint256 The amount of token to be burned
355      */
356     function burnFrom(address from, uint256 value) public {
357         _burnFrom(from, value);
358     }
359 }
360 
361 contract Melon is ERC20Burnable, ERC20Detailed {
362     using SafeMath for uint;
363 
364     uint public constant BASE_UNITS = 10 ** 18;
365     uint public constant INFLATION_ENABLE_DATE = 1551398400;
366     uint public constant INITIAL_TOTAL_SUPPLY = uint(932613).mul(BASE_UNITS);
367     uint public constant YEARLY_MINTABLE_AMOUNT = uint(300600).mul(BASE_UNITS);
368     uint public constant MINTING_INTERVAL = 365 days;
369 
370     address public council;
371     address public deployer;
372     uint public lastMinting;
373     bool public initialSupplyMinted;
374 
375     modifier onlyDeployer {
376         require(msg.sender == deployer, "Only deployer can call this");
377         _;
378     }
379 
380     modifier onlyCouncil {
381         require(msg.sender == council, "Only council can call this");
382         _;
383     }
384 
385     modifier anIntervalHasPassed {
386         require(
387             block.timestamp >= uint(lastMinting).add(MINTING_INTERVAL),
388             "Please wait until an interval has passed"
389         );
390         _;
391     }
392 
393     modifier inflationEnabled {
394         require(
395             block.timestamp >= INFLATION_ENABLE_DATE,
396             "Inflation is not enabled yet"
397         );
398         _;
399     }
400 
401     constructor(
402         string _name,
403         string _symbol,
404         uint8 _decimals,
405         address _council
406     ) ERC20Detailed(_name, _symbol, _decimals) {
407         deployer = msg.sender;
408         council = _council;
409     }
410 
411     function changeCouncil(address _newCouncil) public onlyCouncil {
412         council = _newCouncil;
413     }
414 
415     function mintInitialSupply(address _initialReceiver) public onlyDeployer {
416         require(!initialSupplyMinted, "Initial minting already complete");
417         _mint(_initialReceiver, INITIAL_TOTAL_SUPPLY);
418         initialSupplyMinted = true;
419     }
420 
421     function mintInflation() public anIntervalHasPassed inflationEnabled {
422         require(initialSupplyMinted, "Initial minting not complete");
423         lastMinting = block.timestamp;
424         _mint(council, YEARLY_MINTABLE_AMOUNT);
425     }
426 }