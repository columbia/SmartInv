1 pragma solidity ^0.5.0;
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
26  * @title ERC20Detailed token
27  * @dev The decimals are only for visualization purposes.
28  * All the operations are done using the smallest and indivisible token unit,
29  * just as on Ethereum all the operations are done in wei.
30  */
31 contract ERC20Detailed is IERC20 {
32     string private _name;
33     string private _symbol;
34     uint8 private _decimals;
35 
36     constructor (string memory name, string memory symbol, uint8 decimals) public {
37         _name = name;
38         _symbol = symbol;
39         _decimals = decimals;
40     }
41 
42     /**
43      * @return the name of the token.
44      */
45     function name() public view returns (string memory) {
46         return _name;
47     }
48 
49     /**
50      * @return the symbol of the token.
51      */
52     function symbol() public view returns (string memory) {
53         return _symbol;
54     }
55 
56     /**
57      * @return the number of decimals of the token.
58      */
59     function decimals() public view returns (uint8) {
60         return _decimals;
61     }
62 }
63 
64 
65 /**
66  * @title SafeMath
67  * @dev Unsigned math operations with safety checks that revert on error
68  */
69 library SafeMath {
70     /**
71      * @dev Multiplies two unsigned integers, reverts on overflow.
72      */
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
75         // benefit is lost if 'b' is also tested.
76         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
77         if (a == 0) {
78             return 0;
79         }
80 
81         uint256 c = a * b;
82         require(c / a == b);
83 
84         return c;
85     }
86 
87     /**
88      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
89      */
90     function div(uint256 a, uint256 b) internal pure returns (uint256) {
91         // Solidity only automatically asserts when dividing by 0
92         require(b > 0);
93         uint256 c = a / b;
94         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
95 
96         return c;
97     }
98 
99     /**
100      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
101      */
102     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
103         require(b <= a);
104         uint256 c = a - b;
105 
106         return c;
107     }
108 
109     /**
110      * @dev Adds two unsigned integers, reverts on overflow.
111      */
112     function add(uint256 a, uint256 b) internal pure returns (uint256) {
113         uint256 c = a + b;
114         require(c >= a);
115 
116         return c;
117     }
118 
119     /**
120      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
121      * reverts when dividing by zero.
122      */
123     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
124         require(b != 0);
125         return a % b;
126     }
127 }
128 
129 
130 /**
131  * @title BrienneCoin - a fun sample ERC20 coin inteneded for learning purposes.
132  * 
133  * For more details please see the following blog post:
134  * https://medium.com/nodesmith-blog/its-that-time-of-year-again-game-of-thrones-is-back-a2f24d44e6d7
135  */
136 contract BrienneCoin is IERC20 {
137     using SafeMath for uint256;
138 
139     mapping (address => uint256) private _balances;
140 
141     mapping (address => mapping (address => uint256)) private _allowed;
142 
143     uint256 private _totalSupply;
144 
145     // Emitted whenever Brienne pledges a new loyalty.
146     event LoyaltyPledged(address pledgedTo, string name, string symbol);
147 
148     uint public endDate;
149 
150     address public currentPledge;
151 
152     string public constant name = "Brienne Coin";
153 
154     string public constant symbol = "BRI";
155 
156     uint8 public constant decimals = 18;
157 
158     // End date represents when you can mint HodorCoin until
159     // This is intended to be the end of Season 8.
160     constructor(uint end, address initialPledge) public {
161       endDate = end;
162       pledgeLoyalty(initialPledge);
163     }
164 
165     /**
166      * @dev Total number of tokens in existence
167      * 
168      * @dev Token supply is unlimitted until last GoT air date.
169      */
170     function totalSupply() public view returns (uint256) {
171         return _totalSupply;
172     }
173 
174     /**
175      * @dev Gets the balance of the specified address.
176      * @param owner The address to query the balance of.
177      * @return A uint256 representing the amount owned by the passed address.
178      */
179     function balanceOf(address owner) public view returns (uint256) {
180         return _balances[owner];
181     }
182 
183     /**
184      * @dev Function to check the amount of tokens that an owner allowed to a spender.
185      * @param owner address The address which owns the funds.
186      * @param spender address The address which will spend the funds.
187      * @return A uint256 specifying the amount of tokens still available for the spender.
188      */
189     function allowance(address owner, address spender) public view returns (uint256) {
190         return _allowed[owner][spender];
191     }
192 
193     /**
194      * @dev Transfer token to a specified address
195      * @param to The address to transfer to.
196      * @param value The amount to be transferred.
197      */
198     function transfer(address to, uint256 value) public returns (bool) {
199         _transfer(msg.sender, to, value);
200         return true;
201     }
202 
203     /**
204      * @dev Transfer token to a specified address
205      * @param pledgeTo The address of the erc20 Brienne pledges her loyalty to.
206      */
207     function pledgeLoyalty(address pledgeTo) public {
208         ERC20Detailed erc20 = ERC20Detailed(pledgeTo);
209         string memory tokenName = erc20.name();
210         require(bytes(tokenName).length > 0, "Name must not be empty");
211 
212         string memory tokenSymbol = erc20.symbol();
213         require(bytes(tokenSymbol).length > 0, "Token Symbol must not be empty");
214         
215         currentPledge = pledgeTo;
216 
217         emit LoyaltyPledged(pledgeTo, tokenName, tokenSymbol);
218     }
219 
220     function pledgedTokenInfo() public view returns(address, string memory, string memory) {
221         ERC20Detailed erc20 = ERC20Detailed(currentPledge);
222         return (currentPledge, erc20.name(), erc20.symbol());
223     }
224 
225     /**
226      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
227      * Beware that changing an allowance with this method brings the risk that someone may use both the old
228      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
229      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
230      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231      * @param spender The address which will spend the funds.
232      * @param value The amount of tokens to be spent.
233      */
234     function approve(address spender, uint256 value) public returns (bool) {
235         _approve(msg.sender, spender, value);
236         return true;
237     }
238 
239     /**
240      * @dev Transfer tokens from one address to another.
241      * Note that while this function emits an Approval event, this is not required as per the specification,
242      * and other compliant implementations may not emit the event.
243      * @param from address The address which you want to send tokens from
244      * @param to address The address which you want to transfer to
245      * @param value uint256 the amount of tokens to be transferred
246      */
247     function transferFrom(address from, address to, uint256 value) public returns (bool) {
248         _transfer(from, to, value);
249         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
250         return true;
251     }
252 
253     /**
254      * @dev Increase the amount of tokens that an owner allowed to a spender.
255      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
256      * allowed value is better to use this function to avoid 2 calls (and wait until
257      * the first transaction is mined)
258      * From MonolithDAO Token.sol
259      * Emits an Approval event.
260      * @param spender The address which will spend the funds.
261      * @param addedValue The amount of tokens to increase the allowance by.
262      */
263     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
264         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
265         return true;
266     }
267 
268     /**
269      * @dev Decrease the amount of tokens that an owner allowed to a spender.
270      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
271      * allowed value is better to use this function to avoid 2 calls (and wait until
272      * the first transaction is mined)
273      * From MonolithDAO Token.sol
274      * Emits an Approval event.
275      * @param spender The address which will spend the funds.
276      * @param subtractedValue The amount of tokens to decrease the allowance by.
277      */
278     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
279         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
280         return true;
281     }
282 
283     /**
284      * @dev Transfer token for a specified addresses
285      * @param from The address to transfer from.
286      * @param to The address to transfer to.
287      * @param value The amount to be transferred.
288      */
289     function _transfer(address from, address to, uint256 value) internal {
290         require(to != address(0));
291 
292         _balances[from] = _balances[from].sub(value);
293         _balances[to] = _balances[to].add(value);
294         emit Transfer(from, to, value);
295     }
296 
297     /**
298      * @dev Allows an address to receive 100 Ned coin.
299      */
300     function getSomeBrienne() public {
301         require(now < endDate, "Cannot mint new coins after the finale");
302         uint256 amountAdded = 100 * 1e18;
303         _mint(msg.sender, amountAdded);
304     }
305 
306     /**
307      * @dev Internal function that mints an amount of the token and assigns it to
308      * an account. This encapsulates the modification of balances such that the
309      * proper events are emitted.
310      * @param account The account that will receive the created tokens.
311      * @param value The amount that will be created.
312      */
313     function _mint(address account, uint256 value) internal {
314         require(account != address(0));
315 
316         _totalSupply = _totalSupply.add(value);
317         _balances[account] = _balances[account].add(value);
318         emit Transfer(address(0), account, value);
319     }
320 
321     /**
322      * @dev Internal function that burns an amount of the token of a given
323      * account.
324      * @param account The account whose tokens will be burnt.
325      * @param value The amount that will be burnt.
326      */
327     function _burn(address account, uint256 value) internal {
328         require(account != address(0));
329 
330         _totalSupply = _totalSupply.sub(value);
331         _balances[account] = _balances[account].sub(value);
332         emit Transfer(account, address(0), value);
333     }
334 
335     /**
336      * @dev Approve an address to spend another addresses' tokens.
337      * @param owner The address that owns the tokens.
338      * @param spender The address that will spend the tokens.
339      * @param value The number of tokens that can be spent.
340      */
341     function _approve(address owner, address spender, uint256 value) internal {
342         require(spender != address(0));
343         require(owner != address(0));
344 
345         _allowed[owner][spender] = value;
346         emit Approval(owner, spender, value);
347     }
348 
349     /**
350      * @dev Internal function that burns an amount of the token of a given
351      * account, deducting from the sender's allowance for said account. Uses the
352      * internal burn function.
353      * Emits an Approval event (reflecting the reduced allowance).
354      * @param account The account whose tokens will be burnt.
355      * @param value The amount that will be burnt.
356      */
357     function _burnFrom(address account, uint256 value) internal {
358         _burn(account, value);
359         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
360     }
361 }