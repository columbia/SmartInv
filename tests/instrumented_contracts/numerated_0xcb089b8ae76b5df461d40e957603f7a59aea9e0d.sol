1 pragma solidity 0.5.0;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9     * @dev Multiplies two numbers, reverts on overflow.
10     */
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
26     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
27     */
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
38     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48     * @dev Adds two numbers, reverts on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59     * reverts when dividing by zero.
60     */
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
71 interface IERC20 {
72     function totalSupply() external view returns (uint256);
73 
74     function balanceOf(address who) external view returns (uint256);
75 
76     function allowance(address owner, address spender) external view returns (uint256);
77 
78     function transfer(address to, uint256 value) external returns (bool);
79 
80     function approve(address spender, uint256 value) external returns (bool);
81 
82     function transferFrom(address from, address to, uint256 value) external returns (bool);
83 
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 /**
90  * @title Standard ERC20 token
91  *
92  * @dev Implementation of the basic standard token.
93  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
94  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
95  */
96 contract ERC20 is IERC20 {
97     using SafeMath for uint256;
98 
99     mapping (address => uint256) internal _balances;
100 
101     mapping (address => mapping (address => uint256)) private _allowed;
102 
103     uint256 internal _totalSupply;
104 
105     /**
106     * @dev Total number of tokens in existence
107     */
108     function totalSupply() public view returns (uint256) {
109         return _totalSupply;
110     }
111 
112     /**
113     * @dev Gets the balance of the specified address.
114     * @param owner The address to query the balance of.
115     * @return An uint256 representing the amount owned by the passed address.
116     */
117     function balanceOf(address owner) public view returns (uint256) {
118         return _balances[owner];
119     }
120 
121     /**
122      * @dev Function to check the amount of tokens that an owner allowed to a spender.
123      * @param owner address The address which owns the funds.
124      * @param spender address The address which will spend the funds.
125      * @return A uint256 specifying the amount of tokens still available for the spender.
126      */
127     function allowance(address owner, address spender) public view returns (uint256) {
128         return _allowed[owner][spender];
129     }
130 
131     /**
132     * @dev Transfer token for a specified address
133     * @param to The address to transfer to.
134     * @param value The amount to be transferred.
135     */
136     function transfer(address to, uint256 value) public returns (bool) {
137         _transfer(msg.sender, to, value);
138         return true;
139     }
140 
141     /**
142      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
143      * Beware that changing an allowance with this method brings the risk that someone may use both the old
144      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
145      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
146      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
147      * @param spender The address which will spend the funds.
148      * @param value The amount of tokens to be spent.
149      */
150     function approve(address spender, uint256 value) public returns (bool) {
151         require(spender != address(0));
152 
153         _allowed[msg.sender][spender] = value;
154         emit Approval(msg.sender, spender, value);
155         return true;
156     }
157 
158     /**
159      * @dev Transfer tokens from one address to another
160      * @param from address The address which you want to send tokens from
161      * @param to address The address which you want to transfer to
162      * @param value uint256 the amount of tokens to be transferred
163      */
164     function transferFrom(address from, address to, uint256 value) public returns (bool) {
165         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
166         _transfer(from, to, value);
167         return true;
168     }
169 
170     /**
171      * @dev Increase the amount of tokens that an owner allowed to a spender.
172      * approve should be called when allowed_[_spender] == 0. To increment
173      * allowed value is better to use this function to avoid 2 calls (and wait until
174      * the first transaction is mined)
175      * From MonolithDAO Token.sol
176      * @param spender The address which will spend the funds.
177      * @param addedValue The amount of tokens to increase the allowance by.
178      */
179     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
180         require(spender != address(0));
181 
182         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
183         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
184         return true;
185     }
186 
187     /**
188      * @dev Decrease the amount of tokens that an owner allowed to a spender.
189      * approve should be called when allowed_[_spender] == 0. To decrement
190      * allowed value is better to use this function to avoid 2 calls (and wait until
191      * the first transaction is mined)
192      * From MonolithDAO Token.sol
193      * @param spender The address which will spend the funds.
194      * @param subtractedValue The amount of tokens to decrease the allowance by.
195      */
196     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
197         require(spender != address(0));
198 
199         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
200         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
201         return true;
202     }
203 
204     /**
205     * @dev Transfer token for a specified addresses
206     * @param from The address to transfer from.
207     * @param to The address to transfer to.
208     * @param value The amount to be transferred.
209     */
210     function _transfer(address from, address to, uint256 value) internal {
211         require(to != address(0));
212 
213         _balances[from] = _balances[from].sub(value);
214         _balances[to] = _balances[to].add(value);
215         emit Transfer(from, to, value);
216     }
217 
218 }
219 
220 
221 /**
222  * @title Ownable
223  * @dev The Ownable contract has an owner address, and provides basic authorization control
224  * functions, this simplifies the implementation of "user permissions".
225  */
226 contract Ownable {
227     address public owner;
228 
229 
230     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
231 
232 
233     /**
234     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
235     * account.
236     */
237     constructor() public {
238         owner = msg.sender;
239     }
240 
241     /**
242      * @dev Throws if called by any account other than the owner.
243      */
244     modifier onlyOwner() {
245         require(msg.sender == owner);
246     _;
247     }
248 
249 }
250 
251 contract Claimable is Ownable {
252     address public pendingOwner;
253 
254     /**
255      * @dev Modifier throws if called by any account other than the pendingOwner.
256      */
257     modifier onlyPendingOwner() {
258         require(msg.sender == pendingOwner);
259         _;
260     }
261 
262     /**
263      * @dev Allows the current owner to set the pendingOwner address.
264      * @param newOwner The address to transfer ownership to.
265      */
266     function transferOwnership(address newOwner) onlyOwner public {
267         pendingOwner = newOwner;
268     }
269 
270     /**
271      * @dev Allows the pendingOwner address to finalize the transfer.
272      */
273     function claimOwnership() onlyPendingOwner public {
274         emit OwnershipTransferred(owner, pendingOwner);
275         owner = pendingOwner;
276         pendingOwner = address(0);
277     }
278 }
279 
280 /**
281  * @title Arroundtoken
282  * @dev The Arroundtoken contract is ERC20-compatible token processing contract
283  * with additional  features like multiTransfer and reclaimTokens
284  *
285  */
286 contract Arroundtoken is ERC20, Claimable {
287     using SafeMath for uint256;
288 
289     uint64 public constant TDE_FINISH = 1542326400;//!!!!Check before deploy
290     // 1542326400  GMT: 16 November 2018 г., 00:00:00
291     // 1542326399  GMT: 15 November 2018 г., 23:59:59
292 
293 
294     //////////////////////
295     // State var       ///
296     //////////////////////
297     string  public name;
298     string  public symbol;
299     uint8   public decimals;
300     address public accTDE;
301     address public accFoundCDF;
302     address public accFoundNDF1;
303     address public accFoundNDF2;
304     address public accFoundNDF3;
305     address public accTeam;
306     address public accBounty;
307   
308     // Implementation of frozen funds
309     mapping(address => uint64) public frozenAccounts;
310 
311     //////////////
312     // EVENTS    //
313     ///////////////
314     event NewFreeze(address _acc, uint64 _timestamp);
315     event BatchDistrib(uint8 cnt, uint256 batchAmount);
316     
317     /**
318      * @param _accTDE - main address for token distribution
319      * @param _accFoundCDF  - address for CDF Found tokens (WP)
320      * @param _accFoundNDF1 - address for NDF Found tokens (WP)
321      * @param _accFoundNDF2 - address for NDF Found tokens (WP)
322      * @param _accFoundNDF3 - address for NDF Found tokens (WP)
323      * @param _accTeam - address for team tokens, will frozzen by one year
324      * @param _accBounty - address for bounty tokens 
325      * @param _initialSupply - subj
326      */  
327     constructor (
328         address _accTDE, 
329         address _accFoundCDF,
330         address _accFoundNDF1,
331         address _accFoundNDF2,
332         address _accFoundNDF3,
333         address _accTeam,
334         address _accBounty, 
335         uint256 _initialSupply
336     )
337     public 
338     {
339         require(_accTDE       != address(0));
340         require(_accFoundCDF  != address(0));
341         require(_accFoundNDF1 != address(0));
342         require(_accFoundNDF2 != address(0));
343         require(_accFoundNDF3 != address(0));
344         require(_accTeam      != address(0));
345         require(_accBounty    != address(0));
346         require(_initialSupply > 0);
347         name           = "Arround";
348         symbol         = "ARR";
349         decimals       = 18;
350         accTDE         = _accTDE;
351         accFoundCDF    = _accFoundCDF;
352         accFoundNDF1   = _accFoundNDF1;
353         accFoundNDF2   = _accFoundNDF2;
354         accFoundNDF3   = _accFoundNDF3;
355         
356         accTeam        = _accTeam;
357         accBounty      = _accBounty;
358         _totalSupply   = _initialSupply * (10 ** uint256(decimals));// All ARR tokens in the world
359         
360        //Initial token distribution
361         _balances[_accTDE]       = 1104000000 * (10 ** uint256(decimals)); // TDE,      36.8%=28.6+8.2 
362         _balances[_accFoundCDF]  = 1251000000 * (10 ** uint256(decimals)); // CDF,      41.7%
363         _balances[_accFoundNDF1] =  150000000 * (10 ** uint256(decimals)); // 0.50*NDF, 10.0%
364         _balances[_accFoundNDF2] =  105000000 * (10 ** uint256(decimals)); // 0.35*NDF, 10.0%
365         _balances[_accFoundNDF3] =   45000000 * (10 ** uint256(decimals)); // 0.15*NDF, 10.0%
366         _balances[_accTeam]      =  300000000 * (10 ** uint256(decimals)); // team,     10.0%
367         _balances[_accBounty]    =   45000000 * (10 ** uint256(decimals)); // Bounty,    1.5%
368         require(  _totalSupply ==  3000000000 * (10 ** uint256(decimals)), "Total Supply exceeded!!!");
369         emit Transfer(address(0), _accTDE,       1104000000 * (10 ** uint256(decimals)));
370         emit Transfer(address(0), _accFoundCDF,  1251000000 * (10 ** uint256(decimals)));
371         emit Transfer(address(0), _accFoundNDF1,  150000000 * (10 ** uint256(decimals)));
372         emit Transfer(address(0), _accFoundNDF2,  105000000 * (10 ** uint256(decimals)));
373         emit Transfer(address(0), _accFoundNDF3,   45000000 * (10 ** uint256(decimals)));
374         emit Transfer(address(0), _accTeam,       300000000 * (10 ** uint256(decimals)));
375         emit Transfer(address(0), _accBounty,      45000000 * (10 ** uint256(decimals)));
376         //initisl freeze
377         frozenAccounts[_accTeam]      = TDE_FINISH + 31536000; //+3600*24*365 sec
378         frozenAccounts[_accFoundNDF2] = TDE_FINISH + 31536000; //+3600*24*365 sec
379         frozenAccounts[_accFoundNDF3] = TDE_FINISH + 63158400; //+(3600*24*365)*2 +3600*24(leap year 2020)
380         emit NewFreeze(_accTeam,        TDE_FINISH + 31536000);
381         emit NewFreeze(_accFoundNDF2,   TDE_FINISH + 31536000);
382         emit NewFreeze(_accFoundNDF3,   TDE_FINISH + 63158400);
383 
384     }
385     
386     modifier onlyTokenKeeper() {
387         require(
388             msg.sender == accTDE || 
389             msg.sender == accFoundCDF ||
390             msg.sender == accFoundNDF1 ||
391             msg.sender == accBounty
392         );
393         _;
394     }
395 
396     function() external { } 
397 
398     /**
399      * @dev Returns standart ERC20 result with frozen accounts check
400      */
401     function transfer(address _to, uint256 _value) public  returns (bool) {
402         require(frozenAccounts[msg.sender] < now);
403         return super.transfer(_to, _value);
404     }
405 
406     /**
407      * @dev Returns standart ERC20 result with frozen accounts check
408      */
409     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool) {
410         require(frozenAccounts[_from] < now);
411         return super.transferFrom(_from, _to, _value);
412     }
413 
414     /**
415      * @dev Returns standart ERC20 result with frozen accounts check
416      */
417     function approve(address _spender, uint256 _value) public  returns (bool) {
418         require(frozenAccounts[msg.sender] < now);
419         return super.approve(_spender, _value);
420     }
421 
422     /**
423      * @dev Returns standart ERC20 result with frozen accounts check
424      */
425     function increaseAllowance(address _spender, uint _addedValue) public  returns (bool success) {
426         require(frozenAccounts[msg.sender] < now);
427         return super.increaseAllowance(_spender, _addedValue);
428     }
429     
430     /**
431      * @dev Returns standart ERC20 result with frozen accounts check
432      */
433     function decreaseAllowance(address _spender, uint _subtractedValue) public  returns (bool success) {
434         require(frozenAccounts[msg.sender] < now);
435         return super.decreaseAllowance(_spender, _subtractedValue);
436     }
437 
438     
439     /**
440      * @dev Batch transfer function. Allow to save up 50% of gas
441      */
442     function multiTransfer(address[] calldata  _investors, uint256[] calldata   _value )  
443         external 
444         onlyTokenKeeper 
445         returns (uint256 _batchAmount)
446     {
447         require(_investors.length <= 255); //audit recommendation
448         require(_value.length == _investors.length);
449         uint8      cnt = uint8(_investors.length);
450         uint256 amount = 0;
451         for (uint i=0; i<cnt; i++){
452             amount = amount.add(_value[i]);
453             require(_investors[i] != address(0));
454             _balances[_investors[i]] = _balances[_investors[i]].add(_value[i]);
455             emit Transfer(msg.sender, _investors[i], _value[i]);
456         }
457         require(amount <= _balances[msg.sender]);
458         _balances[msg.sender] = _balances[msg.sender].sub(amount);
459         emit BatchDistrib(cnt, amount);
460         return amount;
461     }
462   
463     /**
464      * @dev Owner can claim any tokens that transfered to this contract address
465      */
466     function reclaimToken(ERC20 token) external onlyOwner {
467         require(address(token) != address(0));
468         uint256 balance = token.balanceOf(address(this));
469         token.transfer(owner, balance);
470     }
471 }
472   //***************************************************************
473   // Based on best practice of https://github.com/Open Zeppelin/zeppelin-solidity
474   // Adapted and amended by IBERGroup; 
475   // Code released under the MIT License(see git root).
476   ////**************************************************************