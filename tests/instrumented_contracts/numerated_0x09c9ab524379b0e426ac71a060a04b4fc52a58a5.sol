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
119     uint256 private _totalEthWithdraw;
120 
121     /**
122      * @dev Total number of tokens in existence
123      */
124     function totalSupply() public view returns (uint256) {
125         return _totalSupply;
126     }
127 
128     function totalEthWithdraw() public view returns (uint256) {
129         return _totalEthWithdraw;
130     }
131 
132     /**
133      * @dev Gets the balance of the specified address.
134      * @param owner The address to query the balance of.
135      * @return An uint256 representing the amount owned by the passed address.
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
152      * @dev Transfer token for a specified address
153      * @param to The address to transfer to.
154      * @param value The amount to be transferred.
155      */
156     function transfer(address to, uint256 value) public returns (bool) {
157         _transfer(msg.sender, to, value);
158         update(msg.sender);
159         updateNewOwner(to);
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
185     function transferFrom(address from, address to, uint256 value) public returns (bool) {
186         _transfer(from, to, value);
187         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
188         update(from);
189         updateNewOwner(to);
190         return true;
191     }
192 
193     /**
194      * @dev Increase the amount of tokens that an owner allowed to a spender.
195      * approve should be called when allowed_[_spender] == 0. To increment
196      * allowed value is better to use this function to avoid 2 calls (and wait until
197      * the first transaction is mined)
198      * From MonolithDAO Token.sol
199      * Emits an Approval event.
200      * @param spender The address which will spend the funds.
201      * @param addedValue The amount of tokens to increase the allowance by.
202      */
203     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
204         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
205         return true;
206     }
207 
208     /**
209      * @dev Decrease the amount of tokens that an owner allowed to a spender.
210      * approve should be called when allowed_[_spender] == 0. To decrement
211      * allowed value is better to use this function to avoid 2 calls (and wait until
212      * the first transaction is mined)
213      * From MonolithDAO Token.sol
214      * Emits an Approval event.
215      * @param spender The address which will spend the funds.
216      * @param subtractedValue The amount of tokens to decrease the allowance by.
217      */
218     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
219         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
220         return true;
221     }
222 
223     function viewMyDividend() public view  returns (uint256) {
224         return dividendBalanceOf[msg.sender];
225     }
226 
227     function withdraw() public payable {
228         update(msg.sender);
229         uint256 amount = dividendBalanceOf[msg.sender];
230         if (amount <= address(this).balance) {
231             dividendBalanceOf[msg.sender] = 0;
232             emit Withdraw(msg.sender, amount);
233             msg.sender.transfer(amount);
234             _totalEthWithdraw = _totalEthWithdraw.add(amount);
235         }
236     }
237 
238     function dividendPerToken() public view returns (uint256) {
239         return _dividendPerToken;
240     }
241 
242     function update(address account) public {
243         uint256 newBalance = address(this).balance.add(_totalEthWithdraw);
244         _dividendPerToken = newBalance.div(_totalSupply);
245         uint256 owed = _dividendPerToken.sub(dividendCreditedTo[account]);
246         dividendBalanceOf[account] = balanceOf(account).mul(owed);
247         dividendCreditedTo[account] = _dividendPerToken;
248     }
249 
250     function updateNewOwner(address account) internal {
251         dividendCreditedTo[account] = _dividendPerToken;
252     }
253 
254     function dividendCreditedOf(address owner) public view returns (uint256) {
255         return dividendCreditedTo[owner];
256     }
257 
258     /**
259      * @dev Transfer token for a specified addresses
260      * @param from The address to transfer from.
261      * @param to The address to transfer to.
262      * @param value The amount to be transferred.
263      */
264     function _transfer(address from, address to, uint256 value) internal {
265         require(to != address(0));
266 
267         _balances[from] = _balances[from].sub(value);
268         _balances[to] = _balances[to].add(value);
269         emit Transfer(from, to, value);
270     }
271 
272     /**
273      * @dev Internal function that mints an amount of the token and assigns it to
274      * an account. This encapsulates the modification of balances such that the
275      * proper events are emitted.
276      * @param account The account that will receive the created tokens.
277      * @param value The amount that will be created.
278      */
279     function _mint(address account, uint256 value) internal {
280         require(account != address(0));
281 
282         _totalSupply = _totalSupply.add(value);
283         _balances[account] = _balances[account].add(value);
284         emit Transfer(address(0), account, value);
285     }
286 
287     /**
288      * @dev Internal function that burns an amount of the token of a given
289      * account.
290      * @param account The account whose tokens will be burnt.
291      * @param value The amount that will be burnt.
292      */
293     function _burn(address account, uint256 value) internal {
294         require(account != address(0));
295 
296         _totalSupply = _totalSupply.sub(value);
297         _balances[account] = _balances[account].sub(value);
298         emit Transfer(account, address(0), value);
299     }
300 
301     /**
302      * @dev Approve an address to spend another addresses' tokens.
303      * @param owner The address that owns the tokens.
304      * @param spender The address that will spend the tokens.
305      * @param value The number of tokens that can be spent.
306      */
307     function _approve(address owner, address spender, uint256 value) internal {
308         require(spender != address(0));
309         require(owner != address(0));
310 
311         _allowed[owner][spender] = value;
312         emit Approval(owner, spender, value);
313     }
314 
315     /**
316      * @dev Internal function that burns an amount of the token of a given
317      * account, deducting from the sender's allowance for said account. Uses the
318      * internal burn function.
319      * Emits an Approval event (reflecting the reduced allowance).
320      * @param account The account whose tokens will be burnt.
321      * @param value The amount that will be burnt.
322      */
323     function _burnFrom(address account, uint256 value) internal {
324         _burn(account, value);
325         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
326     }
327 
328 }
329 
330 /**
331  * @title ERC20Detailed token
332  * @dev The decimals are only for visualization purposes.
333  * All the operations are done using the smallest and indivisible token unit,
334  * just as on Ethereum all the operations are done in wei.
335  */
336 contract ERC20Detailed is IERC20 {
337     string private _name;
338     string private _symbol;
339     uint8 private _decimals;
340 
341     constructor (string memory name, string memory symbol, uint8 decimals) public {
342         _name = name;
343         _symbol = symbol;
344         _decimals = decimals;
345     }
346 
347     /**
348      * @return the name of the token.
349      */
350     function name() public view returns (string memory) {
351         return _name;
352     }
353 
354     /**
355      * @return the symbol of the token.
356      */
357     function symbol() public view returns (string memory) {
358         return _symbol;
359     }
360 
361     /**
362      * @return the number of decimals of the token.
363      */
364     function decimals() public view returns (uint8) {
365         return _decimals;
366     }
367 }
368 
369 contract Token is ERC20, ERC20Detailed {
370     using SafeMath for uint256;
371 
372     uint8 public constant DECIMALS = 0;
373 
374     uint256 public constant INITIAL_SUPPLY = 100 * (10 ** uint256(DECIMALS));
375 
376     /**
377      * @dev Constructor that gives msg.sender all of existing tokens.
378      */
379     constructor (address owner) public ERC20Detailed("Sunday Lottery", "SNDL", DECIMALS) {
380         require(owner != address(0));
381         owner = msg.sender; // for test's
382         _mint(owner, INITIAL_SUPPLY);
383     }
384 
385     function() payable external {
386     }
387 
388     function balanceETH() public view returns(uint256) {
389         return address(this).balance;
390     }
391 
392 }