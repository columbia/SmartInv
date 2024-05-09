1 pragma solidity ^0.5.0;
2 
3 // from OZ
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11     /**
12     * @dev Multiplies two numbers, throws on overflow.
13     */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16         // benefit is lost if 'b' is also tested.
17         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18         if (a == 0) {
19             return 0;
20         }
21 
22         c = a * b;
23         assert(c / a == b);
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two numbers, truncating the quotient.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // assert(b > 0); // Solidity automatically throws when dividing by 0
32         // uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34         return a / b;
35     }
36 
37     /**
38     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         assert(b <= a);
42         return a - b;
43     }
44 
45     /**
46     * @dev Adds two numbers, throws on overflow.
47     */
48     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49         c = a + b;
50         assert(c >= a);
51         return c;
52     }
53 }
54 
55 interface IProcessor {
56 
57     function processPayment(address user, uint cost, uint items, address referrer) external payable returns (uint id);
58     
59 }
60 
61 contract Pack {
62 
63     enum Type {
64         Rare, Epic, Legendary, Shiny
65     }
66 
67 }
68 
69 contract Ownable {
70 
71     address payable public owner;
72 
73     constructor() public {
74         owner = msg.sender;
75     }
76 
77     function setOwner(address payable _owner) public onlyOwner {
78         owner = _owner;
79     }
80 
81     function getOwner() public view returns (address payable) {
82         return owner;
83     }
84 
85     modifier onlyOwner {
86         require(msg.sender == owner, "must be owner to call this function");
87         _;
88     }
89 
90 }
91 
92 contract IERC20 {
93 
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95     event Transfer(address indexed from, address indexed to, uint256 value);
96     
97     function allowance(address owner, address spender) public view returns (uint256);
98     
99     function transferFrom(address from, address to, uint256 value) public returns (bool);
100 
101     function approve(address spender, uint256 value) public returns (bool);
102 
103     function totalSupply() public view returns (uint256);
104 
105     function balanceOf(address who) public view returns (uint256);
106     
107     function transfer(address to, uint256 value) public returns (bool);
108     
109   
110 }
111 
112 /**
113  * @title ERC20Detailed token
114  * @dev The decimals are only for visualization purposes.
115  * All the operations are done using the smallest and indivisible token unit,
116  * just as on Ethereum all the operations are done in wei.
117  */
118 contract ERC20Detailed is IERC20 {
119     string private _name;
120     string private _symbol;
121     uint8 private _decimals;
122 
123     constructor (string memory name, string memory symbol, uint8 decimals) public {
124         _name = name;
125         _symbol = symbol;
126         _decimals = decimals;
127     }
128 
129     /**
130      * @return the name of the token.
131      */
132     function name() public view returns (string memory) {
133         return _name;
134     }
135 
136     /**
137      * @return the symbol of the token.
138      */
139     function symbol() public view returns (string memory) {
140         return _symbol;
141     }
142 
143     /**
144      * @return the number of decimals of the token.
145      */
146     function decimals() public view returns (uint8) {
147         return _decimals;
148     }
149 }
150 
151 interface IPack {
152 
153     function openChest(Pack.Type packType, address user, uint count) external returns (uint);
154 
155 }
156 
157 
158 /**
159  * @title Standard ERC20 token
160  *
161  * @dev Implementation of the basic standard token.
162  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
163  * Originally based on code by FirstBlood:
164  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
165  *
166  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
167  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
168  * compliant implementations may not do it.
169  */
170 contract ERC20 is IERC20 {
171     using SafeMath for uint256;
172 
173     mapping (address => uint256) private _balances;
174 
175     mapping (address => mapping (address => uint256)) private _allowed;
176 
177     uint256 private _totalSupply;
178 
179     /**
180     * @dev Total number of tokens in existence
181     */
182     function totalSupply() public view returns (uint256) {
183         return _totalSupply;
184     }
185 
186     /**
187     * @dev Gets the balance of the specified address.
188     * @param owner The address to query the balance of.
189     * @return An uint256 representing the amount owned by the passed address.
190     */
191     function balanceOf(address owner) public view returns (uint256) {
192         return _balances[owner];
193     }
194 
195     /**
196      * @dev Function to check the amount of tokens that an owner allowed to a spender.
197      * @param owner address The address which owns the funds.
198      * @param spender address The address which will spend the funds.
199      * @return A uint256 specifying the amount of tokens still available for the spender.
200      */
201     function allowance(address owner, address spender) public view returns (uint256) {
202         return _allowed[owner][spender];
203     }
204 
205     /**
206     * @dev Transfer token for a specified address
207     * @param to The address to transfer to.
208     * @param value The amount to be transferred.
209     */
210     function transfer(address to, uint256 value) public returns (bool) {
211         _transfer(msg.sender, to, value);
212         return true;
213     }
214 
215     /**
216      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
217      * Beware that changing an allowance with this method brings the risk that someone may use both the old
218      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
219      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
220      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
221      * @param spender The address which will spend the funds.
222      * @param value The amount of tokens to be spent.
223      */
224     function approve(address spender, uint256 value) public returns (bool) {
225         require(spender != address(0));
226 
227         _allowed[msg.sender][spender] = value;
228         emit Approval(msg.sender, spender, value);
229         return true;
230     }
231 
232     /**
233      * @dev Transfer tokens from one address to another.
234      * Note that while this function emits an Approval event, this is not required as per the specification,
235      * and other compliant implementations may not emit the event.
236      * @param from address The address which you want to send tokens from
237      * @param to address The address which you want to transfer to
238      * @param value uint256 the amount of tokens to be transferred
239      */
240     function transferFrom(address from, address to, uint256 value) public returns (bool) {
241         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
242         _transfer(from, to, value);
243         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
244         return true;
245     }
246 
247     /**
248      * @dev Increase the amount of tokens that an owner allowed to a spender.
249      * approve should be called when allowed_[_spender] == 0. To increment
250      * allowed value is better to use this function to avoid 2 calls (and wait until
251      * the first transaction is mined)
252      * From MonolithDAO Token.sol
253      * Emits an Approval event.
254      * @param spender The address which will spend the funds.
255      * @param addedValue The amount of tokens to increase the allowance by.
256      */
257     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
258         require(spender != address(0));
259 
260         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
261         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
262         return true;
263     }
264 
265     /**
266      * @dev Decrease the amount of tokens that an owner allowed to a spender.
267      * approve should be called when allowed_[_spender] == 0. To decrement
268      * allowed value is better to use this function to avoid 2 calls (and wait until
269      * the first transaction is mined)
270      * From MonolithDAO Token.sol
271      * Emits an Approval event.
272      * @param spender The address which will spend the funds.
273      * @param subtractedValue The amount of tokens to decrease the allowance by.
274      */
275     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
276         require(spender != address(0));
277 
278         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
279         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
280         return true;
281     }
282 
283     /**
284     * @dev Transfer token for a specified addresses
285     * @param from The address to transfer from.
286     * @param to The address to transfer to.
287     * @param value The amount to be transferred.
288     */
289     function _transfer(address from, address to, uint256 value) internal {
290         require(to != address(0));
291 
292         _balances[from] = _balances[from].sub(value);
293         _balances[to] = _balances[to].add(value);
294         emit Transfer(from, to, value);
295     }
296 
297     /**
298      * @dev Internal function that mints an amount of the token and assigns it to
299      * an account. This encapsulates the modification of balances such that the
300      * proper events are emitted.
301      * @param account The account that will receive the created tokens.
302      * @param value The amount that will be created.
303      */
304     function _mint(address account, uint256 value) internal {
305         require(account != address(0));
306 
307         _totalSupply = _totalSupply.add(value);
308         _balances[account] = _balances[account].add(value);
309         emit Transfer(address(0), account, value);
310     }
311 
312     /**
313      * @dev Internal function that burns an amount of the token of a given
314      * account.
315      * @param account The account whose tokens will be burnt.
316      * @param value The amount that will be burnt.
317      */
318     function _burn(address account, uint256 value) internal {
319         require(account != address(0));
320 
321         _totalSupply = _totalSupply.sub(value);
322         _balances[account] = _balances[account].sub(value);
323         emit Transfer(account, address(0), value);
324     }
325 
326     /**
327      * @dev Internal function that burns an amount of the token of a given
328      * account, deducting from the sender's allowance for said account. Uses the
329      * internal burn function.
330      * Emits an Approval event (reflecting the reduced allowance).
331      * @param account The account whose tokens will be burnt.
332      * @param value The amount that will be burnt.
333      */
334     function _burnFrom(address account, uint256 value) internal {
335         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
336         _burn(account, value);
337         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
338     }
339 }
340 
341 /**
342  * @title Burnable Token
343  * @dev Token that can be irreversibly burned (destroyed).
344  */
345 contract ERC20Burnable is ERC20 {
346     /**
347      * @dev Burns a specific amount of tokens.
348      * @param value The amount of token to be burned.
349      */
350     function burn(uint256 value) internal {
351         _burn(msg.sender, value);
352     }
353 
354     /**
355      * @dev Burns a specific amount of tokens from the target address and decrements allowance
356      * @param from address The address which you want to send tokens from
357      * @param value uint256 The amount of token to be burned
358      */
359     function burnFrom(address from, uint256 value) internal {
360         _burnFrom(from, value);
361     }
362 }
363 
364 
365 
366 
367 
368 
369 
370 contract Chest is Ownable, ERC20Detailed, ERC20Burnable {
371 
372     using SafeMath for uint;
373 
374     uint256 public cap;
375     IProcessor public processor;
376     IPack public pack;
377     Pack.Type public packType;
378     uint public price;
379     bool public tradeable;
380     uint256 public sold;
381 
382     event ChestsPurchased(address user, uint count, address referrer, uint paymentID);
383 
384     constructor(
385         IPack _pack, Pack.Type _pt,
386         uint _price, IProcessor _processor, uint _cap,
387         string memory name, string memory sym
388     ) public ERC20Detailed(name, sym, 0) {
389         price = _price;
390         cap = _cap;
391         pack = _pack;
392         packType = _pt;
393         processor = _processor;
394     }
395 
396     function purchase(uint count, address referrer) public payable {
397         return purchaseFor(msg.sender, count, referrer);
398     }
399 
400     function purchaseFor(address user, uint count, address referrer) public payable {
401 
402         _mint(user, count);
403 
404         uint paymentID = processor.processPayment.value(msg.value)(msg.sender, price, count, referrer);
405         emit ChestsPurchased(user, count, referrer, paymentID);
406     }
407 
408     function open(uint value) public payable returns (uint) {
409         return openFor(msg.sender, value);
410     }
411 
412     // can only open uint16 at a time
413     function openFor(address user, uint value) public payable returns (uint) {
414 
415         require(value > 0, "must open at least one chest");
416         // can only be done by those with authority to burn
417         // I would expect burnFrom to work in both cases but doesn't work with Zeppelin implementation
418         if (user == msg.sender) {
419             burn(value);
420         } else {
421             burnFrom(user, value);
422         }
423 
424         require(address(pack) != address(0), "pack must be set");
425    
426         return pack.openChest(packType, user, value);
427     }
428 
429     function makeTradeable() public onlyOwner {
430         tradeable = true;
431     }
432 
433     function transfer(address to, uint256 value) public returns (bool) {
434         require(tradeable, "not currently tradeable");
435         return super.transfer(to, value);
436     }
437 
438     function transferFrom(address from, address to, uint256 value) public returns (bool) {
439         require(tradeable, "not currently tradeable");
440         return super.transferFrom(from, to, value);
441     }
442 
443     function _mint(address account, uint256 value) internal {
444         sold = sold.add(value);
445         if (cap > 0) {
446             require(sold <= cap, "not enough space in cap");
447         }
448         super._mint(account, value);
449     }
450 
451 }