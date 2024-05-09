1 pragma solidity 0.5.6;
2 
3 library SafeMath {
4     /**
5      * @dev Multiplies two unsigned integers, reverts on overflow.
6      */
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
9         // benefit is lost if 'b' is also tested.
10         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
11         if (a == 0) {
12             return 0;
13         }
14 
15         uint256 c = a * b;
16         require(c / a == b);
17 
18         return c;
19     }
20 
21     /**
22      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
23      */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // Solidity only automatically asserts when dividing by 0
26         require(b > 0);
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 
30         return c;
31     }
32 
33     /**
34      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35      */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         require(b <= a);
38         uint256 c = a - b;
39 
40         return c;
41     }
42 
43     /**
44      * @dev Adds two unsigned integers, reverts on overflow.
45      */
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         require(c >= a);
49 
50         return c;
51     }
52 
53     /**
54      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
55      * reverts when dividing by zero.
56      */
57     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58         require(b != 0);
59         return a % b;
60     }
61 }
62 
63 interface IERC20 {
64     function transfer(address to, uint256 value) external returns (bool);
65 
66     function approve(address spender, uint256 value) external returns (bool);
67 
68     function transferFrom(address from, address to, uint256 value) external returns (bool);
69 
70     function totalSupply() external view returns (uint256);
71 
72     function balanceOf(address who) external view returns (uint256);
73 
74     function allowance(address owner, address spender) external view returns (uint256);
75 
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 contract ERC20 is IERC20 {
82     using SafeMath for uint256;
83 
84     mapping (address => uint256) private _balances;
85 
86     mapping (address => mapping (address => uint256)) private _allowed;
87 
88     uint256 private _totalSupply;
89 
90     /**
91      * @dev Total number of tokens in existence
92      */
93     function totalSupply() public view returns (uint256) {
94         return _totalSupply;
95     }
96 
97     /**
98      * @dev Gets the balance of the specified address.
99      * @param owner The address to query the balance of.
100      * @return A uint256 representing the amount owned by the passed address.
101      */
102     function balanceOf(address owner) public view returns (uint256) {
103         return _balances[owner];
104     }
105 
106     /**
107      * @dev Function to check the amount of tokens that an owner allowed to a spender.
108      * @param owner address The address which owns the funds.
109      * @param spender address The address which will spend the funds.
110      * @return A uint256 specifying the amount of tokens still available for the spender.
111      */
112     function allowance(address owner, address spender) public view returns (uint256) {
113         return _allowed[owner][spender];
114     }
115 
116     /**
117      * @dev Transfer token to a specified address
118      * @param to The address to transfer to.
119      * @param value The amount to be transferred.
120      */
121     function transfer(address to, uint256 value) public returns (bool) {
122         _transfer(msg.sender, to, value);
123         return true;
124     }
125 
126     /**
127      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
128      * Beware that changing an allowance with this method brings the risk that someone may use both the old
129      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
130      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
131      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132      * @param spender The address which will spend the funds.
133      * @param value The amount of tokens to be spent.
134      */
135     function approve(address spender, uint256 value) public returns (bool) {
136         _approve(msg.sender, spender, value);
137         return true;
138     }
139 
140     /**
141      * @dev Transfer tokens from one address to another.
142      * Note that while this function emits an Approval event, this is not required as per the specification,
143      * and other compliant implementations may not emit the event.
144      * @param from address The address which you want to send tokens from
145      * @param to address The address which you want to transfer to
146      * @param value uint256 the amount of tokens to be transferred
147      */
148     function transferFrom(address from, address to, uint256 value) public returns (bool) {
149         _transfer(from, to, value);
150         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
151         return true;
152     }
153 
154     /**
155      * @dev Increase the amount of tokens that an owner allowed to a spender.
156      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
157      * allowed value is better to use this function to avoid 2 calls (and wait until
158      * the first transaction is mined)
159      * From MonolithDAO Token.sol
160      * Emits an Approval event.
161      * @param spender The address which will spend the funds.
162      * @param addedValue The amount of tokens to increase the allowance by.
163      */
164     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
165         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
166         return true;
167     }
168 
169     /**
170      * @dev Decrease the amount of tokens that an owner allowed to a spender.
171      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
172      * allowed value is better to use this function to avoid 2 calls (and wait until
173      * the first transaction is mined)
174      * From MonolithDAO Token.sol
175      * Emits an Approval event.
176      * @param spender The address which will spend the funds.
177      * @param subtractedValue The amount of tokens to decrease the allowance by.
178      */
179     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
180         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
181         return true;
182     }
183 
184     /**
185      * @dev Transfer token for a specified addresses
186      * @param from The address to transfer from.
187      * @param to The address to transfer to.
188      * @param value The amount to be transferred.
189      */
190     function _transfer(address from, address to, uint256 value) internal {
191         require(to != address(0));
192 
193         _balances[from] = _balances[from].sub(value);
194         _balances[to] = _balances[to].add(value);
195         emit Transfer(from, to, value);
196     }
197 
198     /**
199      * @dev Internal function that mints an amount of the token and assigns it to
200      * an account. This encapsulates the modification of balances such that the
201      * proper events are emitted.
202      * @param account The account that will receive the created tokens.
203      * @param value The amount that will be created.
204      */
205     function _mint(address account, uint256 value) internal {
206         require(account != address(0));
207 
208         _totalSupply = _totalSupply.add(value);
209         _balances[account] = _balances[account].add(value);
210         emit Transfer(address(0), account, value);
211     }
212 
213     /**
214      * @dev Internal function that burns an amount of the token of a given
215      * account.
216      * @param account The account whose tokens will be burnt.
217      * @param value The amount that will be burnt.
218      */
219     function _burn(address account, uint256 value) internal {
220         require(account != address(0));
221 
222         _totalSupply = _totalSupply.sub(value);
223         _balances[account] = _balances[account].sub(value);
224         emit Transfer(account, address(0), value);
225     }
226 
227     /**
228      * @dev Approve an address to spend another addresses' tokens.
229      * @param owner The address that owns the tokens.
230      * @param spender The address that will spend the tokens.
231      * @param value The number of tokens that can be spent.
232      */
233     function _approve(address owner, address spender, uint256 value) internal {
234         require(spender != address(0));
235         require(owner != address(0));
236 
237         _allowed[owner][spender] = value;
238         emit Approval(owner, spender, value);
239     }
240 
241     /**
242      * @dev Internal function that burns an amount of the token of a given
243      * account, deducting from the sender's allowance for said account. Uses the
244      * internal burn function.
245      * Emits an Approval event (reflecting the reduced allowance).
246      * @param account The account whose tokens will be burnt.
247      * @param value The amount that will be burnt.
248      */
249     function _burnFrom(address account, uint256 value) internal {
250         _burn(account, value);
251         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
252     }
253 }
254 
255 contract IERC20Releasable {
256   function release() public;
257 }
258 
259 contract IOwnable {
260   function isOwner(address who)
261     public view returns(bool);
262 
263   function _isOwner(address)
264     internal view returns(bool);
265 }
266 
267 contract SingleOwner is IOwnable {
268   address public owner;
269 
270   constructor(
271     address _owner
272   )
273     internal
274   {
275     require(_owner != address(0), 'owner_req');
276     owner = _owner;
277 
278     emit OwnershipTransferred(address(0), owner);
279   }
280 
281   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
282 
283   modifier ownerOnly() {
284     require(msg.sender == owner, 'owner_access');
285     _;
286   }
287 
288   function _isOwner(address _sender)
289     internal
290     view
291     returns(bool)
292   {
293     return owner == _sender;
294   }
295 
296   function isOwner(address _sender)
297     public
298     view
299     returns(bool)
300   {
301     return _isOwner(_sender);
302   }
303 
304   function setOwner(address _owner)
305     public
306     ownerOnly
307   {
308     address prevOwner = owner;
309     owner = _owner;
310 
311     emit OwnershipTransferred(owner, prevOwner);
312   }
313 }
314 contract Privileged {
315   /// List of privileged users who can transfer token before release
316   mapping(address => bool) privileged;
317 
318   function isPrivileged(address _addr)
319     public
320     view
321     returns(bool)
322   {
323     return privileged[_addr];
324   }
325 
326   function _setPrivileged(address _addr)
327     internal
328   {
329     require(_addr != address(0), 'addr_req');
330 
331     privileged[_addr] = true;
332   }
333 
334   function _setUnprivileged(address _addr)
335     internal
336   {
337     privileged[_addr] = false;
338   }
339 }
340 
341 contract IToken is IERC20, IERC20Releasable, IOwnable {}
342 
343 contract MBN is IToken, ERC20, SingleOwner, Privileged {
344   string public name = 'Membrana';
345   string public symbol = 'MBN';
346   uint8 public decimals = 18;
347   bool public isReleased;
348   uint public releaseDate;
349 
350   constructor(address _owner)
351     public
352     SingleOwner(_owner)
353   {
354     super._mint(owner, 1000000000 * 10 ** 18);
355   }
356 
357   // Modifiers
358   modifier releasedOnly() {
359     require(isReleased, 'released_only');
360     _;
361   }
362 
363   modifier notReleasedOnly() {
364     require(! isReleased, 'not_released_only');
365     _;
366   }
367 
368   modifier releasedOrPrivilegedOnly() {
369     require(isReleased || isPrivileged(msg.sender), 'released_or_privileged_only');
370     _;
371   }
372 
373   // Methods
374 
375   function transfer(address to, uint256 value)
376     public
377     releasedOrPrivilegedOnly
378     returns (bool)
379   {
380     return super.transfer(to, value);
381   }
382 
383   function transferFrom(address from, address to, uint256 value)
384     public
385     releasedOnly
386     returns (bool)
387   {
388     return super.transferFrom(from, to, value);
389   }
390 
391   function approve(address spender, uint256 value)
392     public
393     releasedOnly
394     returns (bool)
395   {
396     return super.approve(spender, value);
397   }
398 
399   function increaseAllowance(address spender, uint addedValue)
400     public
401     releasedOnly
402     returns (bool)
403   {
404     return super.increaseAllowance(spender, addedValue);
405   }
406 
407   function decreaseAllowance(address spender, uint subtractedValue)
408     public
409     releasedOnly
410     returns (bool)
411   {
412     return super.decreaseAllowance(spender, subtractedValue);
413   }
414 
415   function release()
416     public
417     ownerOnly
418     notReleasedOnly
419   {
420     isReleased = true;
421     releaseDate = now;
422   }
423 
424   function setPrivileged(address _addr)
425     public
426     ownerOnly
427   {
428     _setPrivileged(_addr);
429   }
430 
431   function setUnprivileged(address _addr)
432     public
433     ownerOnly
434   {
435     _setUnprivileged(_addr);
436   }
437 }