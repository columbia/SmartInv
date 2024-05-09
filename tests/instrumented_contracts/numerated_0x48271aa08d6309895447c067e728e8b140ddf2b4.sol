1 pragma solidity ^0.5.8;
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
16         require(c / a == b, "SafeMath: multiplication overflow");
17 
18         return c;
19     }
20 
21     /**
22      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
23      */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // Solidity only automatically asserts when dividing by 0
26         require(b > 0, "SafeMath: division by zero");
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
37         require(b <= a, "SafeMath: subtraction overflow");
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
48         require(c >= a, "SafeMath: addition overflow");
49 
50         return c;
51     }
52 }
53 
54 contract Ownable {
55     address private _owner;
56 
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59     /**
60      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
61      * account.
62      */
63     constructor () internal {
64         _owner = 0xfc0281163cFeDA9FbB3B18A72A27310B1725fD65;
65         emit OwnershipTransferred(address(0), _owner);
66     }
67 
68     /**
69      * @return the address of the owner.
70      */
71     function owner() public view returns (address) {
72         return _owner;
73     }
74 
75     /**
76      * @dev Throws if called by any account other than the owner.
77      */
78     modifier onlyOwner() {
79         require(isOwner(), "Ownable: caller is not the owner");
80         _;
81     }
82 
83     /**
84      * @return true if `msg.sender` is the owner of the contract.
85      */
86     function isOwner() public view returns (bool) {
87         return msg.sender == _owner;
88     }
89 
90     /**
91      * @dev Allows the current owner to relinquish control of the contract.
92      * It will not be possible to call the functions with the `onlyOwner`
93      * modifier anymore.
94      * @notice Renouncing ownership will leave the contract without an owner,
95      * thereby removing any functionality that is only available to the owner.
96      */
97     function renounceOwnership() public onlyOwner {
98         emit OwnershipTransferred(_owner, address(0));
99         _owner = address(0);
100     }
101 
102     /**
103      * @dev Allows the current owner to transfer control of the contract to a newOwner.
104      * @param newOwner The address to transfer ownership to.
105      */
106     function transferOwnership(address newOwner) public onlyOwner {
107         _transferOwnership(newOwner);
108     }
109 
110     /**
111      * @dev Transfers control of the contract to a newOwner.
112      * @param newOwner The address to transfer ownership to.
113      */
114     function _transferOwnership(address newOwner) internal {
115         require(newOwner != address(0), "Ownable: new owner is the zero address");
116         emit OwnershipTransferred(_owner, newOwner);
117         _owner = newOwner;
118     }
119 }
120 
121 interface IERC20 {
122     function transfer(address to, uint256 value) external returns (bool);
123     function approve(address spender, uint256 value) external returns (bool);
124     function transferFrom(address from, address to, uint256 value) external returns (bool);
125     function totalSupply() external view returns (uint256);
126     function balanceOf(address who) external view returns (uint256);
127     function allowance(address owner, address spender) external view returns (uint256);
128     event Transfer(address indexed from, address indexed to, uint256 value);
129     event Approval(address indexed owner, address indexed spender, uint256 value);
130 }
131 
132 contract ERC20 is IERC20 {
133     using SafeMath for uint256;
134 
135     mapping (address => uint256) private _balances;
136     mapping (address => mapping (address => uint256)) private _allowances;
137     uint256 private _totalSupply;
138 
139     /**
140      * @dev Total number of tokens in existence.
141      */
142     function totalSupply() public view returns (uint256) {
143         return _totalSupply;
144     }
145 
146     /**
147      * @dev Gets the balance of the specified address.
148      * @param owner The address to query the balance of.
149      * @return A uint256 representing the amount owned by the passed address.
150      */
151     function balanceOf(address owner) public view returns (uint256) {
152         return _balances[owner];
153     }
154 
155     /**
156      * @dev Function to check the amount of tokens that an owner allowed to a spender.
157      * @param owner address The address which owns the funds.
158      * @param spender address The address which will spend the funds.
159      * @return A uint256 specifying the amount of tokens still available for the spender.
160      */
161     function allowance(address owner, address spender) public view returns (uint256) {
162         return _allowances[owner][spender];
163     }
164 
165     /**
166      * @dev Transfer token to a specified address.
167      * @param to The address to transfer to.
168      * @param value The amount to be transferred.
169      */
170     function transfer(address to, uint256 value) public returns (bool) {
171         _transfer(msg.sender, to, value);
172         return true;
173     }
174 
175     /**
176      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177      * Beware that changing an allowance with this method brings the risk that someone may use both the old
178      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181      * @param spender The address which will spend the funds.
182      * @param value The amount of tokens to be spent.
183      */
184     function approve(address spender, uint256 value) public returns (bool) {
185         _approve(msg.sender, spender, value);
186         return true;
187     }
188 
189     /**
190      * @dev Transfer tokens from one address to another.
191      * Note that while this function emits an Approval event, this is not required as per the specification,
192      * and other compliant implementations may not emit the event.
193      * @param from address The address which you want to send tokens from
194      * @param to address The address which you want to transfer to
195      * @param value uint256 the amount of tokens to be transferred
196      */
197     function transferFrom(address from, address to, uint256 value) public returns (bool) {
198         _transfer(from, to, value);
199         _approve(from, msg.sender, _allowances[from][msg.sender].sub(value));
200         return true;
201     }
202 
203     /**
204      * @dev Increase the amount of tokens that an owner allowed to a spender.
205      * approve should be called when _allowances[msg.sender][spender] == 0. To increment
206      * allowed value is better to use this function to avoid 2 calls (and wait until
207      * the first transaction is mined)
208      * From MonolithDAO Token.sol
209      * Emits an Approval event.
210      * @param spender The address which will spend the funds.
211      * @param addedValue The amount of tokens to increase the allowance by.
212      */
213     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
214         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
215         return true;
216     }
217 
218     /**
219      * @dev Decrease the amount of tokens that an owner allowed to a spender.
220      * approve should be called when _allowances[msg.sender][spender] == 0. To decrement
221      * allowed value is better to use this function to avoid 2 calls (and wait until
222      * the first transaction is mined)
223      * From MonolithDAO Token.sol
224      * Emits an Approval event.
225      * @param spender The address which will spend the funds.
226      * @param subtractedValue The amount of tokens to decrease the allowance by.
227      */
228     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
229         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
230         return true;
231     }
232 
233     /**
234      * @dev Transfer token for a specified addresses.
235      * @param from The address to transfer from.
236      * @param to The address to transfer to.
237      * @param value The amount to be transferred.
238      */
239     function _transfer(address from, address to, uint256 value) internal {
240         require(from != address(0), "ERC20: transfer from the zero address");
241         require(to != address(0), "ERC20: transfer to the zero address");
242 
243         _balances[from] = _balances[from].sub(value);
244         _balances[to] = _balances[to].add(value);
245         emit Transfer(from, to, value);
246     }
247 
248     /**
249      * @dev Internal function that mints an amount of the token and assigns it to
250      * an account. This encapsulates the modification of balances such that the
251      * proper events are emitted.
252      * @param account The account that will receive the created tokens.
253      * @param value The amount that will be created.
254      */
255     function _mint(address account, uint256 value) internal {
256         require(account != address(0), "ERC20: mint to the zero address");
257 
258         _totalSupply = _totalSupply.add(value);
259         _balances[account] = _balances[account].add(value);
260         emit Transfer(address(0), account, value);
261     }
262     
263     /**
264      * @dev Approve an address to spend another addresses' tokens.
265      * @param owner The address that owns the tokens.
266      * @param spender The address that will spend the tokens.
267      * @param value The number of tokens that can be spent.
268      */
269     function _approve(address owner, address spender, uint256 value) internal {
270         require(owner != address(0), "ERC20: approve from the zero address");
271         require(spender != address(0), "ERC20: approve to the zero address");
272 
273         _allowances[owner][spender] = value;
274         emit Approval(owner, spender, value);
275     }
276 }
277 
278 contract CSCToken is ERC20, Ownable {
279     using SafeMath for uint256;
280 
281     string public constant name     = "Crypto Service Capital Token";
282     string public constant symbol   = "CSCT";
283     uint8  public constant decimals = 18;
284     
285     bool public mintingFinished = false;
286     mapping (address => bool) private _minters;
287     event Mint(address indexed to, uint256 amount);
288     event MintFinished();
289     
290     modifier canMint() {
291         require(!mintingFinished);
292         _;
293     }
294     
295     function isMinter(address minter) public view returns (bool) {
296         if (owner() == minter) {
297             return true;
298         }
299         return _minters[minter];
300     }
301     
302     modifier onlyMinter() {
303         require(isMinter(msg.sender), "Minter: caller is not the minter");
304         _;
305     }
306     
307     function addMinter(address _minter) external onlyOwner returns (bool) {
308         require(_minter != address(0));
309         _minters[_minter] = true;
310         return true;
311     }
312     
313     function removeMinter(address _minter) external onlyOwner returns (bool) {
314         require(_minter != address(0));
315         _minters[_minter] = false;
316         return true;
317     }
318     
319     function mint(address to, uint256 value) public onlyMinter returns (bool) {
320         _mint(to, value);
321         emit Mint(to, value);
322         return true;
323     }
324     
325     function finishMinting() onlyOwner canMint external returns (bool) {
326         mintingFinished = true;
327         emit MintFinished();
328         return true;
329     }
330 }
331 
332 contract Crowdsale is Ownable {
333     using SafeMath for uint256;
334 
335     uint256 public constant rate = 1000;                                           // How many token units a buyer gets per wei
336     uint256 public constant cap = 10000 ether;                                     // Maximum amount of funds
337 
338     bool public isFinalized = false;                                               // End timestamps where investments are allowed
339     uint256 public startTime = 1559347199;                                         // 31-May-19 23:59:59 UTC
340     uint256 public endTime = 1577836799;                                           // 30-Dec-19 23:59:59 UTC
341 
342     CSCToken public token;                                                         // CSCT token itself
343     address payable public wallet = 0x1524Aa69ef4BA327576FcF548f7dD14aEaC8CA18;    // Wallet of funds
344     uint256 public weiRaised;                                                      // Amount of raised money in wei
345 
346     uint256 public firstBonus = 30;                                                // 1st bonus percentage
347     uint256 public secondBonus = 50;                                               // 2nd bonus percentage
348 
349     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
350     event Finalized();
351 
352     constructor (CSCToken _CSCT) public {
353         assert(address(_CSCT) != address(0));
354         token = _CSCT;
355     }
356 
357     function () external payable {
358         buyTokens(msg.sender);
359     }
360 
361     // @return true if the transaction can buy tokens
362     function validPurchase() internal view returns (bool) {
363         require(!token.mintingFinished());
364         require(weiRaised <= cap);
365         require(now >= startTime);
366         require(now <= endTime);
367         require(msg.value >= 0.001 ether);
368 
369         return true;
370     }
371     
372     function tokensForWei(uint weiAmount) public view returns (uint tokens) {
373         tokens = weiAmount.mul(rate);
374         tokens = tokens.add(getBonus(tokens, weiAmount));
375     }
376     
377     function getBonus(uint256 _tokens, uint256 _weiAmount) public view returns (uint256) {
378         if (_weiAmount >= 30 ether) {
379             return _tokens.mul(secondBonus).div(100);
380         }
381         return _tokens.mul(firstBonus).div(100);
382     }
383 
384     function buyTokens(address beneficiary) public payable {
385         require(beneficiary != address(0));
386         require(validPurchase());
387 
388         uint256 weiAmount = msg.value;
389         uint256 tokens = tokensForWei(weiAmount);
390         weiRaised = weiRaised.add(weiAmount);
391 
392         token.mint(beneficiary, tokens);
393         emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
394 
395         wallet.transfer(msg.value);
396     }
397 
398     function setFirstBonus(uint256 _newBonus) onlyOwner external {
399         firstBonus = _newBonus;
400     }
401 
402     function setSecondBonus(uint256 _newBonus) onlyOwner external {
403         secondBonus = _newBonus;
404     }
405 
406     function changeEndTime(uint256 _newTime) onlyOwner external {
407         require(endTime >= now);
408         endTime = _newTime;
409     }
410 
411     // Calls the contract's finalization function.
412     function finalize() onlyOwner external {
413         require(!isFinalized);
414 
415         endTime = now;
416         isFinalized = true;
417         emit Finalized();
418     }
419 
420     // @return true if crowdsale event has ended
421     function hasEnded() external view returns (bool) {
422         return now > endTime;
423     }
424 }