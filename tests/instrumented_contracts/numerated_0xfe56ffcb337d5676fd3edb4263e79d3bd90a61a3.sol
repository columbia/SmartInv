1 pragma solidity >0.4.99 <0.6.0;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 /**
68  * @title ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71 contract IERC20 {
72     function transfer(address to, uint256 value) public returns (bool);
73 
74     function approve(address spender, uint256 value) public returns (bool);
75 
76     function transferFrom(address from, address to, uint256 value) public returns (bool);
77 
78     function totalSupply() public view returns (uint256);
79 
80     function balanceOf(address who) public view returns (uint256);
81 
82     function allowance(address owner, address spender) public view returns (uint256);
83 
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 
88     event Withdraw(address indexed account, uint256 value);
89 }
90 
91 
92 /**
93  * @title Standard ERC20 token
94  *
95  * @dev Implementation of the basic standard token.
96  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
97  * Originally based on code by FirstBlood:
98  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
99  *
100  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
101  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
102  * compliant implementations may not do it.
103  */
104 contract ERC20 is IERC20 {
105     using SafeMath for uint256;
106 
107     mapping (address => uint256) private _balances;
108 
109     mapping (address => mapping (address => uint256)) private _allowed;
110 
111     mapping(address => uint256) private dividendBalanceOf;
112 
113     mapping(address => uint256) private dividendCreditedTo;
114 
115     uint256 private _dividendPerToken;
116 
117     uint256 private _totalSupply;
118 
119     uint256 private lastBalance;
120 
121     /**
122      * @dev Total number of tokens in existence
123      */
124     function totalSupply() public view returns (uint256) {
125         return _totalSupply;
126     }
127 
128     /**
129      * @dev Gets the balance of the specified address.
130      * @param owner The address to query the balance of.
131      * @return An uint256 representing the amount owned by the passed address.
132      */
133     function balanceOf(address owner) public view returns (uint256) {
134         return _balances[owner];
135     }
136 
137     /**
138      * @dev Function to check the amount of tokens that an owner allowed to a spender.
139      * @param owner address The address which owns the funds.
140      * @param spender address The address which will spend the funds.
141      * @return A uint256 specifying the amount of tokens still available for the spender.
142      */
143     function allowance(address owner, address spender) public view returns (uint256) {
144         return _allowed[owner][spender];
145     }
146 
147     /**
148      * @dev Transfer token for a specified address
149      * @param to The address to transfer to.
150      * @param value The amount to be transferred.
151      */
152     function transfer(address to, uint256 value) public returns (bool) {
153         _transfer(msg.sender, to, value);
154         update(msg.sender);
155         updateNewOwner(to);
156         return true;
157     }
158 
159     /**
160      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
161      * Beware that changing an allowance with this method brings the risk that someone may use both the old
162      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
163      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
164      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165      * @param spender The address which will spend the funds.
166      * @param value The amount of tokens to be spent.
167      */
168     function approve(address spender, uint256 value) public returns (bool) {
169         _approve(msg.sender, spender, value);
170         return true;
171     }
172 
173     /**
174      * @dev Transfer tokens from one address to another.
175      * Note that while this function emits an Approval event, this is not required as per the specification,
176      * and other compliant implementations may not emit the event.
177      * @param from address The address which you want to send tokens from
178      * @param to address The address which you want to transfer to
179      * @param value uint256 the amount of tokens to be transferred
180      */
181     function transferFrom(address from, address to, uint256 value) public returns (bool) {
182         _transfer(from, to, value);
183         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
184         update(from);
185         updateNewOwner(to);
186         return true;
187     }
188 
189     /**
190      * @dev Increase the amount of tokens that an owner allowed to a spender.
191      * approve should be called when allowed_[_spender] == 0. To increment
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
206      * approve should be called when allowed_[_spender] == 0. To decrement
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
219     function updateDividend() public  returns (bool) {
220         uint256 newBalance = address(this).balance;
221         uint256 lastValue = newBalance.sub(lastBalance);
222         _dividendPerToken = _dividendPerToken.add(lastValue.div(_totalSupply));
223         lastBalance = newBalance;
224         return true;
225     }
226 
227     function viewMyDividend() public view  returns (uint256) {
228         return dividendBalanceOf[msg.sender];
229     }
230 
231     function withdraw() public payable {
232         require(msg.value == 0);
233         update(msg.sender);
234         uint256 amount = dividendBalanceOf[msg.sender];
235         if (amount <= address(this).balance) {
236             dividendBalanceOf[msg.sender] = 0;
237             emit Withdraw(msg.sender, amount);
238             msg.sender.transfer(amount);
239         }
240     }
241 
242     function dividendPerToken() public view returns (uint256) {
243         return _dividendPerToken;
244     }
245 
246     function update(address account) public {
247         uint256 owed = _dividendPerToken.sub(dividendCreditedTo[account]);
248         dividendBalanceOf[account] = dividendBalanceOf[account].add(balanceOf(account).mul(owed));
249         dividendCreditedTo[account] = _dividendPerToken;
250     }
251 
252     function updateNewOwner(address account) internal {
253         dividendCreditedTo[account] = _dividendPerToken;
254     }
255 
256     /**
257      * @dev Transfer token for a specified addresses
258      * @param from The address to transfer from.
259      * @param to The address to transfer to.
260      * @param value The amount to be transferred.
261      */
262     function _transfer(address from, address to, uint256 value) internal {
263         require(to != address(0));
264 
265         _balances[from] = _balances[from].sub(value);
266         _balances[to] = _balances[to].add(value);
267         emit Transfer(from, to, value);
268     }
269 
270     /**
271      * @dev Internal function that mints an amount of the token and assigns it to
272      * an account. This encapsulates the modification of balances such that the
273      * proper events are emitted.
274      * @param account The account that will receive the created tokens.
275      * @param value The amount that will be created.
276      */
277     function _mint(address account, uint256 value) internal {
278         require(account != address(0));
279 
280         _totalSupply = _totalSupply.add(value);
281         _balances[account] = _balances[account].add(value);
282         emit Transfer(address(0), account, value);
283     }
284 
285     /**
286      * @dev Internal function that burns an amount of the token of a given
287      * account.
288      * @param account The account whose tokens will be burnt.
289      * @param value The amount that will be burnt.
290      */
291     function _burn(address account, uint256 value) internal {
292         require(account != address(0));
293 
294         _totalSupply = _totalSupply.sub(value);
295         _balances[account] = _balances[account].sub(value);
296         emit Transfer(account, address(0), value);
297     }
298 
299     /**
300      * @dev Approve an address to spend another addresses' tokens.
301      * @param owner The address that owns the tokens.
302      * @param spender The address that will spend the tokens.
303      * @param value The number of tokens that can be spent.
304      */
305     function _approve(address owner, address spender, uint256 value) internal {
306         require(spender != address(0));
307         require(owner != address(0));
308 
309         _allowed[owner][spender] = value;
310         emit Approval(owner, spender, value);
311     }
312 
313     /**
314      * @dev Internal function that burns an amount of the token of a given
315      * account, deducting from the sender's allowance for said account. Uses the
316      * internal burn function.
317      * Emits an Approval event (reflecting the reduced allowance).
318      * @param account The account whose tokens will be burnt.
319      * @param value The amount that will be burnt.
320      */
321     function _burnFrom(address account, uint256 value) internal {
322         _burn(account, value);
323         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
324     }
325 
326 }
327 
328 /**
329  * @title ERC20Detailed token
330  * @dev The decimals are only for visualization purposes.
331  * All the operations are done using the smallest and indivisible token unit,
332  * just as on Ethereum all the operations are done in wei.
333  */
334 contract ERC20Detailed is IERC20 {
335     string private _name;
336     string private _symbol;
337     uint8 private _decimals;
338 
339     constructor (string memory name, string memory symbol, uint8 decimals) public {
340         _name = name;
341         _symbol = symbol;
342         _decimals = decimals;
343     }
344 
345     /**
346      * @return the name of the token.
347      */
348     function name() public view returns (string memory) {
349         return _name;
350     }
351 
352     /**
353      * @return the symbol of the token.
354      */
355     function symbol() public view returns (string memory) {
356         return _symbol;
357     }
358 
359     /**
360      * @return the number of decimals of the token.
361      */
362     function decimals() public view returns (uint8) {
363         return _decimals;
364     }
365 }
366 
367 contract Token is ERC20, ERC20Detailed {
368     using SafeMath for uint256;
369 
370     uint8 public constant DECIMALS = 0;
371 
372     uint256 public constant INITIAL_SUPPLY = 100 * (10 ** uint256(DECIMALS));
373 
374     /**
375      * @dev Constructor that gives msg.sender all of existing tokens.
376      */
377     constructor (address owner) public ERC20Detailed("Sunday Lottery", "HAN1", DECIMALS) {
378         require(owner != address(0));
379         owner = msg.sender; // for test's
380         _mint(owner, INITIAL_SUPPLY);
381     }
382 
383     function() payable external {
384         if (msg.value == 0) {
385             withdraw();
386         }
387     }
388 
389     function balanceETH() public view returns(uint256) {
390         return address(this).balance;
391     }
392 
393 }