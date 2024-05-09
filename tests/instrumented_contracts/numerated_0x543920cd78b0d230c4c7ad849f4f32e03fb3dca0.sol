1 pragma solidity ^0.5.1;
2 
3 contract ERC223Receiver {
4     function tokenFallback(address, uint256) public returns (bool);
5     function tokenFallback(address, uint256, bytes memory) public returns (bool);
6 }
7 
8 interface IERC20 {
9     function totalSupply() external view returns (uint256);
10 
11     function balanceOf(address who) external view returns (uint256);
12 
13     function allowance(address owner, address spender) external view returns (uint256);
14 
15     function transfer(address to, uint256 value) external returns (bool);
16 
17     function approve(address spender, uint256 value) external returns (bool);
18 
19     function transferFrom(address from, address to, uint256 value) external returns (bool);
20 
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 contract ERC20 is IERC20 {
27     using SafeMath for uint256;
28 
29     mapping (address => uint256) private _balances;
30 
31     mapping (address => mapping (address => uint256)) private _allowed;
32 
33     uint256 private _totalSupply;
34 
35     /**
36     * @dev Total number of tokens in existence
37     */
38     function totalSupply() public view returns (uint256) {
39         return _totalSupply;
40     }
41 
42     /**
43     * @dev Gets the balance of the specified address.
44     * @param owner The address to query the balance of.
45     * @return An uint256 representing the amount owned by the passed address.
46     */
47     function balanceOf(address owner) public view returns (uint256) {
48         return _balances[owner];
49     }
50 
51     /**
52      * @dev Function to check the amount of tokens that an owner allowed to a spender.
53      * @param owner address The address which owns the funds.
54      * @param spender address The address which will spend the funds.
55      * @return A uint256 specifying the amount of tokens still available for the spender.
56      */
57     function allowance(address owner, address spender) public view returns (uint256) {
58         return _allowed[owner][spender];
59     }
60 
61     /**
62     * @dev Transfer token for a specified address
63     * @param to The address to transfer to.
64     * @param value The amount to be transferred.
65     */
66     function transfer(address to, uint256 value) public returns (bool) {
67         _transfer(msg.sender, to, value);
68         return true;
69     }
70 
71     /**
72      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
73      * Beware that changing an allowance with this method brings the risk that someone may use both the old
74      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
75      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
76      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77      * @param spender The address which will spend the funds.
78      * @param value The amount of tokens to be spent.
79      */
80     function approve(address spender, uint256 value) public returns (bool) {
81         require(spender != address(0));
82 
83         _allowed[msg.sender][spender] = value;
84         emit Approval(msg.sender, spender, value);
85         return true;
86     }
87 
88     /**
89      * @dev Transfer tokens from one address to another.
90      * Note that while this function emits an Approval event, this is not required as per the specification,
91      * and other compliant implementations may not emit the event.
92      * @param from address The address which you want to send tokens from
93      * @param to address The address which you want to transfer to
94      * @param value uint256 the amount of tokens to be transferred
95      */
96     function transferFrom(address from, address to, uint256 value) public returns (bool) {
97         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
98         _transfer(from, to, value);
99         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
100         return true;
101     }
102 
103     /**
104      * @dev Increase the amount of tokens that an owner allowed to a spender.
105      * approve should be called when allowed_[_spender] == 0. To increment
106      * allowed value is better to use this function to avoid 2 calls (and wait until
107      * the first transaction is mined)
108      * From MonolithDAO Token.sol
109      * Emits an Approval event.
110      * @param spender The address which will spend the funds.
111      * @param addedValue The amount of tokens to increase the allowance by.
112      */
113     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
114         require(spender != address(0));
115 
116         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
117         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
118         return true;
119     }
120 
121     /**
122      * @dev Decrease the amount of tokens that an owner allowed to a spender.
123      * approve should be called when allowed_[_spender] == 0. To decrement
124      * allowed value is better to use this function to avoid 2 calls (and wait until
125      * the first transaction is mined)
126      * From MonolithDAO Token.sol
127      * Emits an Approval event.
128      * @param spender The address which will spend the funds.
129      * @param subtractedValue The amount of tokens to decrease the allowance by.
130      */
131     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
132         require(spender != address(0));
133 
134         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
135         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
136         return true;
137     }
138 
139     /**
140     * @dev Transfer token for a specified addresses
141     * @param from The address to transfer from.
142     * @param to The address to transfer to.
143     * @param value The amount to be transferred.
144     */
145     function _transfer(address from, address to, uint256 value) internal {
146         require(to != address(0));
147 
148         _balances[from] = _balances[from].sub(value);
149         _balances[to] = _balances[to].add(value);
150         emit Transfer(from, to, value);
151     }
152 
153     /**
154      * @dev Internal function that mints an amount of the token and assigns it to
155      * an account. This encapsulates the modification of balances such that the
156      * proper events are emitted.
157      * @param account The account that will receive the created tokens.
158      * @param value The amount that will be created.
159      */
160     function _mint(address account, uint256 value) internal {
161         require(account != address(0));
162 
163         _totalSupply = _totalSupply.add(value);
164         _balances[account] = _balances[account].add(value);
165         emit Transfer(address(0), account, value);
166     }
167 
168     /**
169      * @dev Internal function that burns an amount of the token of a given
170      * account.
171      * @param account The account whose tokens will be burnt.
172      * @param value The amount that will be burnt.
173      */
174     function _burn(address account, uint256 value) internal {
175         require(account != address(0));
176 
177         _totalSupply = _totalSupply.sub(value);
178         _balances[account] = _balances[account].sub(value);
179         emit Transfer(account, address(0), value);
180     }
181 
182     /**
183      * @dev Internal function that burns an amount of the token of a given
184      * account, deducting from the sender's allowance for said account. Uses the
185      * internal burn function.
186      * Emits an Approval event (reflecting the reduced allowance).
187      * @param account The account whose tokens will be burnt.
188      * @param value The amount that will be burnt.
189      */
190     function _burnFrom(address account, uint256 value) internal {
191         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
192         _burn(account, value);
193         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
194     }
195 }
196 
197 contract ERC20Detailed is IERC20 {
198     string private _name;
199     string private _symbol;
200     uint8 private _decimals;
201 
202     constructor (string memory name, string memory symbol, uint8 decimals) public {
203         _name = name;
204         _symbol = symbol;
205         _decimals = decimals;
206     }
207 
208     /**
209      * @return the name of the token.
210      */
211     function name() public view returns (string memory) {
212         return _name;
213     }
214 
215     /**
216      * @return the symbol of the token.
217      */
218     function symbol() public view returns (string memory) {
219         return _symbol;
220     }
221 
222     /**
223      * @return the number of decimals of the token.
224      */
225     function decimals() public view returns (uint8) {
226         return _decimals;
227     }
228 }
229 
230 contract ERC223 is ERC20, ERC20Detailed {
231   using SafeMath for uint256;
232 
233   constructor(
234       string memory name,
235       string memory symbol,
236       uint8 decimals,
237       address owner,
238       uint256 totalSupply
239   )
240       ERC20()
241       ERC20Detailed(name, symbol, decimals)
242       public
243   {
244       _mint(owner, (totalSupply * 1 ether));
245   }
246 
247   function transfer(
248       address to,
249       uint256 value
250   ) public returns (bool) {
251       require(super.transfer(to, value));
252 
253       uint256 codeLength;
254       assembly {
255           codeLength := extcodesize(to)
256       }
257 
258       if (codeLength > 0) {
259           ERC223Receiver receiver = ERC223Receiver(to);
260           if (!receiver.tokenFallback(msg.sender, value)) {
261               revert("Missing Token Receiver");
262           }
263       }
264       return true;
265   }
266 
267   function transfer(
268       address to,
269       uint256 value,
270       bytes memory data
271   ) public returns (bool) {
272       require(super.transfer(to, value));
273 
274       uint256 codeLength;
275       assembly {
276           codeLength := extcodesize(to)
277       }
278 
279       if (codeLength > 0) {
280           ERC223Receiver receiver = ERC223Receiver(to);
281           if (!receiver.tokenFallback(msg.sender, value, data)) {
282               revert("Missing Token Receiver");
283           }
284       }
285       return true;
286   }
287 
288   function transferFrom(
289       address from,
290       address to,
291       uint256 value
292   ) public returns (bool) {
293       require(super.transferFrom(from, to, value));
294 
295       uint256 codeLength;
296       assembly {
297           codeLength := extcodesize(to)
298       }
299 
300       if (codeLength > 0) {
301           ERC223Receiver receiver = ERC223Receiver(to);
302           if (!receiver.tokenFallback(msg.sender, value)) {
303               revert("Missing Token Receiver");
304           }
305       }
306       return true;
307   }
308 
309   function transferFrom(
310       address from,
311       address to,
312       uint256 value,
313       bytes memory data
314   ) public returns (bool) {
315       require(super.transferFrom(from, to, value));
316 
317       uint256 codeLength;
318       assembly {
319           codeLength := extcodesize(to)
320       }
321 
322       if (codeLength > 0) {
323           ERC223Receiver receiver = ERC223Receiver(to);
324           if (!receiver.tokenFallback(msg.sender, value, data)) {
325               revert("Missing Token Receiver");
326           }
327       }
328       return true;
329   }
330 }
331 
332 library SafeMath {
333     int256 constant private INT256_MIN = -2**255;
334 
335     /**
336     * @dev Multiplies two unsigned integers, reverts on overflow.
337     */
338     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
339         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
340         // benefit is lost if 'b' is also tested.
341         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
342         if (a == 0) {
343             return 0;
344         }
345 
346         uint256 c = a * b;
347         require(c / a == b);
348 
349         return c;
350     }
351 
352     /**
353     * @dev Multiplies two signed integers, reverts on overflow.
354     */
355     function mul(int256 a, int256 b) internal pure returns (int256) {
356         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
357         // benefit is lost if 'b' is also tested.
358         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
359         if (a == 0) {
360             return 0;
361         }
362 
363         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
364 
365         int256 c = a * b;
366         require(c / a == b);
367 
368         return c;
369     }
370 
371     /**
372     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
373     */
374     function div(uint256 a, uint256 b) internal pure returns (uint256) {
375         // Solidity only automatically asserts when dividing by 0
376         require(b > 0);
377         uint256 c = a / b;
378         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
379 
380         return c;
381     }
382 
383     /**
384     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
385     */
386     function div(int256 a, int256 b) internal pure returns (int256) {
387         require(b != 0); // Solidity only automatically asserts when dividing by 0
388         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
389 
390         int256 c = a / b;
391 
392         return c;
393     }
394 
395     /**
396     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
397     */
398     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
399         require(b <= a);
400         uint256 c = a - b;
401 
402         return c;
403     }
404 
405     /**
406     * @dev Subtracts two signed integers, reverts on overflow.
407     */
408     function sub(int256 a, int256 b) internal pure returns (int256) {
409         int256 c = a - b;
410         require((b >= 0 && c <= a) || (b < 0 && c > a));
411 
412         return c;
413     }
414 
415     /**
416     * @dev Adds two unsigned integers, reverts on overflow.
417     */
418     function add(uint256 a, uint256 b) internal pure returns (uint256) {
419         uint256 c = a + b;
420         require(c >= a);
421 
422         return c;
423     }
424 
425     /**
426     * @dev Adds two signed integers, reverts on overflow.
427     */
428     function add(int256 a, int256 b) internal pure returns (int256) {
429         int256 c = a + b;
430         require((b >= 0 && c >= a) || (b < 0 && c < a));
431 
432         return c;
433     }
434 
435     /**
436     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
437     * reverts when dividing by zero.
438     */
439     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
440         require(b != 0);
441         return a % b;
442     }
443 }
444 
445 contract VIM_ERC20 is ERC223  {
446     constructor(
447         string memory name,
448         string memory symbol,
449         uint8 decimals,
450         address owner,
451         uint256 totalSupply
452     )
453         ERC223(name, symbol, decimals, owner, totalSupply)
454         public
455     {
456     }
457 }