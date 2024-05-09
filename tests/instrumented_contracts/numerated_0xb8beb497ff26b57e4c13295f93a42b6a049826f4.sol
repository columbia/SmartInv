1 pragma solidity ^0.5.0;
2 
3 interface IERC20 {
4   function totalSupply() external view returns (uint256);
5 
6   function balanceOf(address who) external view returns (uint256);
7 
8   function allowance(address owner, address spender)
9     external view returns (uint256);
10 
11   function transfer(address to, uint256 value) external returns (bool);
12 
13   function approve(address spender, uint256 value)
14     external returns (bool);
15 
16   function transferFrom(address from, address to, uint256 value)
17     external returns (bool);
18 
19   event Transfer(
20     address indexed from,
21     address indexed to,
22     uint256 value
23   );
24 
25   event Approval(
26     address indexed owner,
27     address indexed spender,
28     uint256 value
29   );
30 }
31 
32 contract ERC20 is IERC20 {
33   using SafeMath for uint256;
34 
35   mapping (address => uint256) private _balances;
36 
37   mapping (address => mapping (address => uint256)) private _allowed;
38 
39   uint256 private _totalSupply;
40 
41   /**
42   * @dev Total number of tokens in existence
43   */
44   function totalSupply() public view returns (uint256) {
45     return _totalSupply;
46   }
47 
48   /**
49   * @dev Gets the balance of the specified address.
50   * @param owner The address to query the balance of.
51   * @return An uint256 representing the amount owned by the passed address.
52   */
53   function balanceOf(address owner) public view returns (uint256) {
54     return _balances[owner];
55   }
56 
57   /**
58    * @dev Function to check the amount of tokens that an owner allowed to a spender.
59    * @param owner address The address which owns the funds.
60    * @param spender address The address which will spend the funds.
61    * @return A uint256 specifying the amount of tokens still available for the spender.
62    */
63   function allowance(
64     address owner,
65     address spender
66    )
67     public
68     view
69     returns (uint256)
70   {
71     return _allowed[owner][spender];
72   }
73 
74   /**
75   * @dev Transfer token for a specified address
76   * @param to The address to transfer to.
77   * @param value The amount to be transferred.
78   */
79   function transfer(address to, uint256 value) public returns (bool) {
80     _transfer(msg.sender, to, value);
81     return true;
82   }
83 
84   /**
85    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
86    * Beware that changing an allowance with this method brings the risk that someone may use both the old
87    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
88    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
89    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
90    * @param spender The address which will spend the funds.
91    * @param value The amount of tokens to be spent.
92    */
93   function approve(address spender, uint256 value) public returns (bool) {
94     require(spender != address(0));
95 
96     _allowed[msg.sender][spender] = value;
97     emit Approval(msg.sender, spender, value);
98     return true;
99   }
100 
101   /**
102    * @dev Transfer tokens from one address to another
103    * @param from address The address which you want to send tokens from
104    * @param to address The address which you want to transfer to
105    * @param value uint256 the amount of tokens to be transferred
106    */
107   function transferFrom(
108     address from,
109     address to,
110     uint256 value
111   )
112     public
113     returns (bool)
114   {
115     require(value <= _allowed[from][msg.sender]);
116 
117     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
118     _transfer(from, to, value);
119     return true;
120   }
121 
122   /**
123    * @dev Increase the amount of tokens that an owner allowed to a spender.
124    * approve should be called when allowed_[_spender] == 0. To increment
125    * allowed value is better to use this function to avoid 2 calls (and wait until
126    * the first transaction is mined)
127    * From MonolithDAO Token.sol
128    * @param spender The address which will spend the funds.
129    * @param addedValue The amount of tokens to increase the allowance by.
130    */
131   function increaseAllowance(
132     address spender,
133     uint256 addedValue
134   )
135     public
136     returns (bool)
137   {
138     require(spender != address(0));
139 
140     _allowed[msg.sender][spender] = (
141       _allowed[msg.sender][spender].add(addedValue));
142     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
143     return true;
144   }
145 
146   /**
147    * @dev Decrease the amount of tokens that an owner allowed to a spender.
148    * approve should be called when allowed_[_spender] == 0. To decrement
149    * allowed value is better to use this function to avoid 2 calls (and wait until
150    * the first transaction is mined)
151    * From MonolithDAO Token.sol
152    * @param spender The address which will spend the funds.
153    * @param subtractedValue The amount of tokens to decrease the allowance by.
154    */
155   function decreaseAllowance(
156     address spender,
157     uint256 subtractedValue
158   )
159     public
160     returns (bool)
161   {
162     require(spender != address(0));
163 
164     _allowed[msg.sender][spender] = (
165       _allowed[msg.sender][spender].sub(subtractedValue));
166     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
167     return true;
168   }
169 
170   /**
171   * @dev Transfer token for a specified addresses
172   * @param from The address to transfer from.
173   * @param to The address to transfer to.
174   * @param value The amount to be transferred.
175   */
176   function _transfer(address from, address to, uint256 value) internal {
177     require(value <= _balances[from]);
178     require(to != address(0));
179 
180     _balances[from] = _balances[from].sub(value);
181     _balances[to] = _balances[to].add(value);
182     emit Transfer(from, to, value);
183   }
184 
185   /**
186    * @dev Internal function that mints an amount of the token and assigns it to
187    * an account. This encapsulates the modification of balances such that the
188    * proper events are emitted.
189    * @param account The account that will receive the created tokens.
190    * @param value The amount that will be created.
191    */
192   function _mint(address account, uint256 value) internal {
193     require(account != address(0), 'account is null');
194     _totalSupply = _totalSupply.add(value);
195     _balances[account] = _balances[account].add(value);
196     emit Transfer(address(0), account, value);
197   }
198 
199   /**
200    * @dev Internal function that burns an amount of the token of a given
201    * account.
202    * @param account The account whose tokens will be burnt.
203    * @param value The amount that will be burnt.
204    */
205   function _burn(address account, uint256 value) internal {
206     require(account != address(0));
207     require(value <= _balances[account]);
208 
209     _totalSupply = _totalSupply.sub(value);
210     _balances[account] = _balances[account].sub(value);
211     emit Transfer(account, address(0), value);
212   }
213 
214   /**
215    * @dev Internal function that burns an amount of the token of a given
216    * account, deducting from the sender's allowance for said account. Uses the
217    * internal burn function.
218    * @param account The account whose tokens will be burnt.
219    * @param value The amount that will be burnt.
220    */
221   function _burnFrom(address account, uint256 value) internal {
222     require(value <= _allowed[account][msg.sender]);
223 
224     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
225     // this function needs to emit an event with the updated approval.
226     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
227       value);
228     _burn(account, value);
229   }
230 }
231 
232 library SafeMath {
233 
234   /**
235   * @dev Multiplies two numbers, reverts on overflow.
236   */
237   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
238     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
239     // benefit is lost if 'b' is also tested.
240     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
241     if (a == 0) {
242       return 0;
243     }
244 
245     uint256 c = a * b;
246     require(c / a == b);
247 
248     return c;
249   }
250 
251   /**
252   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
253   */
254   function div(uint256 a, uint256 b) internal pure returns (uint256) {
255     require(b > 0); // Solidity only automatically asserts when dividing by 0
256     uint256 c = a / b;
257     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
258 
259     return c;
260   }
261 
262   /**
263   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
264   */
265   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
266     require(b <= a);
267     uint256 c = a - b;
268 
269     return c;
270   }
271 
272   /**
273   * @dev Adds two numbers, reverts on overflow.
274   */
275   function add(uint256 a, uint256 b) internal pure returns (uint256) {
276     uint256 c = a + b;
277     require(c >= a);
278 
279     return c;
280   }
281 
282   /**
283   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
284   * reverts when dividing by zero.
285   */
286   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
287     require(b != 0);
288     return a % b;
289   }
290 }
291 
292 contract ERC20Detailed is IERC20 {
293   string private _name;
294   string private _symbol;
295   uint8 private _decimals;
296 
297   constructor(string memory name, string memory symbol, uint8 decimals) public {
298     _name = name;
299     _symbol = symbol;
300     _decimals = decimals;
301   }
302 
303   /**
304    * @return the name of the token.
305    */
306   function name() public view returns(string memory) {
307     return _name;
308   }
309 
310   /**
311    * @return the symbol of the token.
312    */
313   function symbol() public view returns(string memory) {
314     return _symbol;
315   }
316 
317   /**
318    * @return the number of decimals of the token.
319    */
320   function decimals() public view returns(uint8) {
321     return _decimals;
322   }
323 }
324 
325 contract CraftBeerCoin is ERC20, ERC20Detailed {
326 
327     mapping (address => mapping (address => uint256)) public _confirmations;
328     mapping (address => bool) public _isOwner;
329     address[] public _owners;
330     uint public _required;
331     uint256 multiplier;
332 
333     modifier notConfirmed(address owner, address to) {
334         require(_confirmations[to][owner] == 0);
335         _;
336     }
337 
338     modifier ownerExists(address owner) {
339         require(_isOwner[owner]);
340         _;
341     }
342 
343     event Confirmation(address indexed sender, address indexed to, uint256 value);
344     event Minted(address indexed to, uint256 value);
345     event ConfirmationRevoked(address indexed sender, address indexed to);
346 
347     constructor(
348         string memory name,
349         string memory symbol,
350         uint8 decimals
351     )
352 
353     ERC20Detailed(name, symbol, decimals)
354     ERC20() public {
355 
356         _owners = [0x460f0cc4e0fE5576b03abC1C1632EeFb5ed77fc2,
357         0x5E9a0E1acd44fbC49A14bBEae88f74593e0C0f56,
358         0x4B7C1eA71A85eCe00b231F6C1C31fb1Fa6910297,
359         0xf03523Fe4cEebA6E28Aea8F0a5ca293FC3E787c9];
360 
361         _required = 2;
362 
363         for (uint i=0; i<_owners.length; i++) {
364             _isOwner[_owners[i]] = true;
365         }
366 
367         multiplier = 10 ** uint256(decimals);
368     }
369 
370 
371     function confirmMint(address to, uint256 value)
372     public
373     notConfirmed(msg.sender, to)
374     ownerExists(msg.sender)
375     {
376         uint256 _value = value*multiplier;
377         _confirmations[to][msg.sender] = _value;
378         emit Confirmation(msg.sender, to, _value);
379         executeMint(to, _value);
380     }
381 
382 
383     function executeMint(address to, uint256 value)
384     internal
385     returns (bool) {
386 
387         if (isConfirmed(to, value)) {
388 
389             if (resetConfirmations(to)) {
390 
391                 _mint(to, value);
392                 emit Minted(to, value);
393                 return true;
394             }
395 
396         }
397     }
398 
399 
400     function resetConfirmations(address to)
401     internal
402     returns (bool) {
403 
404         for (uint i=0; i<_owners.length; i++) {
405 
406             if (_confirmations[to][_owners[i]] != 0)
407                 _confirmations[to][_owners[i]] = 0;
408 
409         }
410 
411         return true;
412     }
413 
414 
415     function revokeConfirmations(address to)
416     public
417     ownerExists(msg.sender)
418     returns (bool) {
419 
420         _confirmations[to][msg.sender] = 0;
421         emit ConfirmationRevoked(msg.sender, to);
422         return true;
423     }
424 
425     function getConfirmation(address to)
426     public
427     view
428     returns (uint256)
429     {
430 
431         return _confirmations[to][msg.sender];
432     }
433 
434 
435     function isConfirmed(address to, uint256 value)
436     internal view
437     returns (bool)
438     {
439         uint count = 0;
440         for (uint i=0; i<_owners.length; i++) {
441             if (_confirmations[to][_owners[i]] == value)
442                 count += 1;
443             if (count == _required)
444                 return true;
445         }
446     }
447 
448     function() external payable {
449         revert();
450     }
451 }