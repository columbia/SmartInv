1 pragma solidity ^0.5.0;
2 pragma experimental ABIEncoderV2;
3 
4 
5 library ECStructs {
6 
7     struct ECDSASig {
8         uint8 v;
9         bytes32 r;
10         bytes32 s;
11     }
12 }
13 
14 contract ILotteryForCoke {
15     struct Ticket {
16         address payable ticketAddress;
17         uint256 period;
18         address payable buyer;
19         uint256 amount;
20         uint256 salt;
21     }
22 
23     function buy(Ticket memory ticket, ECStructs.ECDSASig memory serverSig) public returns (bool);
24 
25     function calcTicketPrice(Ticket memory ticket) public view returns (uint256 cokeAmount);
26 }
27 
28 contract IPledgeForCoke {
29 
30     struct DepositRequest {
31         address payable depositAddress;
32         address payable from;
33         uint256 cokeAmount;
34         uint256 endBlock;
35         bytes32 billSeq;
36         bytes32 salt;
37     }
38 
39     //the buyer should approve enough coke and then call this function
40     //or use 'approveAndCall' in Coke.sol in 1 request
41     function deposit(DepositRequest memory request, ECStructs.ECDSASig memory ecdsaSig) payable public returns (bool);
42 
43     function depositCheck(DepositRequest memory request, ECStructs.ECDSASig memory ecdsaSig) public view returns (uint256);
44 }
45 
46 
47 library SafeMath {
48 
49     /**
50     * @dev Multiplies two numbers, reverts on overflow.
51     */
52     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
54         // benefit is lost if 'b' is also tested.
55         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
56         if (a == 0) {
57             return 0;
58         }
59 
60         uint256 c = a * b;
61         require(c / a == b, "SafeMath, mul");
62 
63         return c;
64     }
65 
66     /**
67     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
68     */
69     function div(uint256 a, uint256 b) internal pure returns (uint256) {
70         require(b > 0, "SafeMath, div");
71         // Solidity only automatically asserts when dividing by 0
72         uint256 c = a / b;
73         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74 
75         return c;
76     }
77 
78     /**
79     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
80     */
81     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
82         require(b <= a, "SafeMath, sub");
83         uint256 c = a - b;
84 
85         return c;
86     }
87 
88     /**
89     * @dev Adds two numbers, reverts on overflow.
90     */
91     function add(uint256 a, uint256 b) internal pure returns (uint256) {
92         uint256 c = a + b;
93         require(c >= a, "SafeMath, add");
94 
95         return c;
96     }
97 
98     /**
99     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
100     * reverts when dividing by zero.
101     */
102     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
103         require(b != 0, "SafeMath, mod");
104         return a % b;
105     }
106 }
107 
108 contract IRequireUtils {
109     function requireCode(uint256 code) external pure;
110 
111     function interpret(uint256 code) public pure returns (string memory);
112 }
113 
114 
115 
116 interface IERC20 {
117     function totalSupply() external view returns (uint256);
118 
119     function balanceOf(address who) external view returns (uint256);
120 
121     function allowance(address owner, address spender) external view returns (uint256);
122 
123     function transfer(address to, uint256 value) external returns (bool);
124 
125     function approve(address spender, uint256 value) external returns (bool);
126 
127     function transferFrom(address from, address to, uint256 value) external returns (bool);
128 
129     event Transfer(
130         address indexed from,
131         address indexed to,
132         uint256 value
133     );
134 
135     event Approval(
136         address indexed owner,
137         address indexed spender,
138         uint256 value
139     );
140 }
141 
142 contract ReentrancyGuard {
143 
144     /// @dev counter to allow mutex lock with only one SSTORE operation
145     uint256 private _guardCounter;
146 
147     constructor() internal {
148         // The counter starts at one to prevent changing it from zero to a non-zero
149         // value, which is a more expensive operation.
150         _guardCounter = 1;
151     }
152 
153     /**
154      * @dev Prevents a contract from calling itself, directly or indirectly.
155      * Calling a `nonReentrant` function from another `nonReentrant`
156      * function is not supported. It is possible to prevent this from happening
157      * by making the `nonReentrant` function external, and make it call a
158      * `private` function that does the actual work.
159      */
160     modifier nonReentrant() {
161         _guardCounter += 1;
162         uint256 localCounter = _guardCounter;
163         _;
164         require(localCounter == _guardCounter, "nonReentrant");
165     }
166 
167 }
168 
169 contract ERC20 is IERC20, ReentrancyGuard {
170     using SafeMath for uint256;
171 
172     mapping(address => uint256) private _balances;
173 
174     mapping(address => mapping(address => uint256)) private _allowed;
175 
176     uint256 private _totalSupply;
177 
178     /**
179     * @dev Total number of tokens in existence
180     */
181     function totalSupply() public view returns (uint256) {
182         return _totalSupply;
183     }
184 
185     /**
186     * @dev Gets the balance of the specified address.
187     * @param owner The address to query the balance of.
188     * @return An uint256 representing the amount owned by the passed address.
189     */
190     function balanceOf(address owner) public view returns (uint256) {
191         return _balances[owner];
192     }
193 
194     /**
195      * @dev Function to check the amount of tokens that an owner allowed to a spender.
196      * @param owner address The address which owns the funds.
197      * @param spender address The address which will spend the funds.
198      * @return A uint256 specifying the amount of tokens still available for the spender.
199      */
200     function allowance(
201         address owner,
202         address spender
203     )
204     public
205     view
206     returns (uint256)
207     {
208         return _allowed[owner][spender];
209     }
210 
211     /**
212     * @dev Transfer token for a specified address
213     * @param to The address to transfer to.
214     * @param value The amount to be transferred.
215     */
216     function transfer(address to, uint256 value) public returns (bool) {
217         _transfer(msg.sender, to, value);
218         return true;
219     }
220 
221     /**
222      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
223      * Beware that changing an allowance with this method brings the risk that someone may use both the old
224      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
225      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
226      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
227      * @param spender The address which will spend the funds.
228      * @param value The amount of tokens to be spent.
229      */
230     function approve(address spender, uint256 value) public returns (bool) {
231         require(spender != address(0), "ERC20 approve, spender can not be 0x00");
232 
233         _allowed[msg.sender][spender] = value;
234         emit Approval(msg.sender, spender, value);
235         return true;
236     }
237 
238     //be careful, this is 'internal' function,
239     //you must add control permission to manipulate this function
240     function approveFrom(address owner, address spender, uint256 value) internal returns (bool) {
241         require(spender != address(0), "ERC20 approveFrom, spender can not be 0x00");
242 
243         _allowed[owner][spender] = value;
244         emit Approval(owner, spender, value);
245         return true;
246     }
247 
248     /**
249      * @dev Transfer tokens from one address to another
250      * @param from address The address which you want to send tokens from
251      * @param to address The address which you want to transfer to
252      * @param value uint256 the amount of tokens to be transferred
253      */
254     function transferFrom(
255         address from,
256         address to,
257         uint256 value
258     )
259     public
260     returns (bool)
261     {
262         require(value <= _allowed[from][msg.sender], "ERC20 transferFrom, allowance not enough");
263 
264         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
265         _transfer(from, to, value);
266         return true;
267     }
268 
269     /**
270      * @dev Increase the amount of tokens that an owner allowed to a spender.
271      * approve should be called when allowed_[_spender] == 0. To increment
272      * allowed value is better to use this function to avoid 2 calls (and wait until
273      * the first transaction is mined)
274      * From MonolithDAO Token.sol
275      * @param spender The address which will spend the funds.
276      * @param addedValue The amount of tokens to increase the allowance by.
277      */
278     function increaseAllowance(
279         address spender,
280         uint256 addedValue
281     )
282     public
283     returns (bool)
284     {
285         require(spender != address(0), "ERC20 increaseAllowance, spender can not be 0x00");
286 
287         _allowed[msg.sender][spender] = (
288         _allowed[msg.sender][spender].add(addedValue));
289         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
290         return true;
291     }
292 
293 
294     /**
295      * @dev Decrease the amount of tokens that an owner allowed to a spender.
296      * approve should be called when allowed_[_spender] == 0. To decrement
297      * allowed value is better to use this function to avoid 2 calls (and wait until
298      * the first transaction is mined)
299      * From MonolithDAO Token.sol
300      * @param spender The address which will spend the funds.
301      * @param subtractedValue The amount of tokens to decrease the allowance by.
302      */
303     function decreaseAllowance(
304         address spender,
305         uint256 subtractedValue
306     )
307     public
308     returns (bool)
309     {
310         require(spender != address(0), "ERC20 decreaseAllowance, spender can not be 0x00");
311 
312         _allowed[msg.sender][spender] = (
313         _allowed[msg.sender][spender].sub(subtractedValue));
314         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
315         return true;
316     }
317 
318     /**
319     * @dev Transfer token for a specified addresses
320     * @param from The address to transfer from.
321     * @param to The address to transfer to.
322     * @param value The amount to be transferred.
323     */
324     function _transfer(address from, address to, uint256 value) internal {
325         require(value <= _balances[from], "ERC20 _transfer, not enough balance");
326         require(to != address(0), "ERC20 _transfer, to address can not be 0x00");
327 
328         _balances[from] = _balances[from].sub(value);
329         _balances[to] = _balances[to].add(value);
330         emit Transfer(from, to, value);
331     }
332 
333     /**
334      * @dev Internal function that mints an amount of the token and assigns it to
335      * an account. This encapsulates the modification of balances such that the
336      * proper events are emitted.
337      * @param account The account that will receive the created tokens.
338      * @param value The amount that will be created.
339      */
340     function _mint(address account, uint256 value) internal {
341         require(account != address(0), "ERC20 _mint, account can not be 0x00");
342         _totalSupply = _totalSupply.add(value);
343         _balances[account] = _balances[account].add(value);
344         emit Transfer(address(0), account, value);
345     }
346 
347     /**
348      * @dev Internal function that burns an amount of the token of a given
349      * account.
350      * @param account The account whose tokens will be burnt.
351      * @param value The amount that will be burnt.
352      */
353     function _burn(address account, uint256 value) internal {
354         require(account != address(0), "ERC20 _burn, account can not be 0x00");
355         require(value <= _balances[account], "ERC20 _burn, not enough balance");
356 
357         _totalSupply = _totalSupply.sub(value);
358         _balances[account] = _balances[account].sub(value);
359         emit Transfer(account, address(0), value);
360     }
361 
362     /**
363      * @dev Internal function that burns an amount of the token of a given
364      * account, deducting from the sender's allowance for said account. Uses the
365      * internal burn function.
366      * @param account The account whose tokens will be burnt.
367      * @param value The amount that will be burnt.
368      */
369     function _burnFrom(address account, uint256 value) internal {
370         require(value <= _allowed[account][msg.sender], "ERC20 _burnFrom, allowance not enough");
371 
372         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
373         // this function needs to emit an event with the updated approval.
374         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
375             value);
376         _burn(account, value);
377     }
378 }
379 
380 contract Coke is ERC20{
381     using SafeMath for uint256;
382 
383     IRequireUtils rUtils;
384 
385     //1 Coke = 10^18 Tin
386     string public name = "COKE";
387     string public symbol = "COKE";
388     uint256 public decimals = 18; //1:1
389 
390     address public cokeAdmin;// admin has rights to mint and burn and etc.
391     mapping(address => bool) public gameMachineRecords;// game machine has permission to mint coke
392 
393 
394     uint256 public stagePercent;
395     uint256 public step;
396     uint256 public remain;
397     uint256 public currentDifficulty;//starts from 0
398     uint256 public currentStageEnd;
399 
400     address team;
401     uint256 public teamRemain;
402     uint256 public unlockAllBlockNumber;
403     uint256 unlockNumerator;
404     uint256 unlockDenominator;
405 
406     event Reward(address indexed account, uint256 amount, uint256 rawAmount);
407     event UnlockToTeam(address indexed account, uint256 amount, uint256 rawReward);
408 
409     constructor (IRequireUtils _rUtils, address _cokeAdmin, uint256 _cap, address _team, uint256 _toTeam,
410         uint256 _unlockAllBlockNumber, address _bounty, uint256 _toBounty, uint256 _stagePercent,
411         uint256 _unlockNumerator, uint256 _unlockDenominator) /*ERC20Capped(_cap) */public {
412         rUtils = _rUtils;
413         cokeAdmin = _cokeAdmin;
414         unlockAllBlockNumber = _unlockAllBlockNumber;
415 
416         team = _team;
417         teamRemain = _toTeam;
418 
419         _mint(address(this), _toTeam);
420 
421         _mint(_bounty, _toBounty);
422 
423         stagePercent = _stagePercent;
424         step = _cap * _stagePercent / 100;
425         remain = _cap.sub(_toTeam).sub(_toBounty);
426 
427         _mint(address(this), remain);
428 
429         unlockNumerator = _unlockNumerator;
430         unlockDenominator=_unlockDenominator;
431         if (remain - step > 0) {
432             currentStageEnd = remain - step;
433         } else {
434             currentStageEnd = 0;
435         }
436         currentDifficulty = 0;
437     }
438 
439     function approveAndCall(address spender, uint256 value, bytes memory data) public nonReentrant returns (bool) {
440         require(approve(spender, value));
441 
442         (bool success, bytes memory returnData) = spender.call(data);
443         rUtils.requireCode(success ? 0 : 501);
444 
445         return true;
446     }
447 
448     function approveAndBuyLottery(ILotteryForCoke.Ticket memory ticket, ECStructs.ECDSASig memory serverSig) public nonReentrant returns (bool){
449         rUtils.requireCode(approve(ticket.ticketAddress, ILotteryForCoke(ticket.ticketAddress).calcTicketPrice(ticket)) ? 0 : 506);
450         rUtils.requireCode(ILotteryForCoke(ticket.ticketAddress).buy(ticket, serverSig) ? 0 : 507);
451         return true;
452     }
453 
454     function approveAndPledgeCoke(IPledgeForCoke.DepositRequest memory depositRequest, ECStructs.ECDSASig memory serverSig) public nonReentrant returns (bool){
455         rUtils.requireCode(approve(depositRequest.depositAddress, depositRequest.cokeAmount) ? 0 : 508);
456         rUtils.requireCode(IPledgeForCoke(depositRequest.depositAddress).deposit(depositRequest, serverSig) ? 0 : 509);
457         return true;
458     }
459 
460     function betReward(address _account, uint256 _amount) public mintPermission returns (uint256 minted){
461         uint256 input = _amount;
462         uint256 totalMint = 0;
463         while (input > 0) {
464 
465             uint256 factor = 2 ** currentDifficulty;
466             uint256 discount = input / factor;
467             if (input % factor != 0) {
468                 discount ++;
469             }
470 
471             if (discount > remain - currentStageEnd) {
472                 uint256 toMint = remain - currentStageEnd;
473                 totalMint += toMint;
474                 input = input - toMint * factor;
475                 remain = currentStageEnd;
476             } else {
477                 totalMint += discount;
478                 input = 0;
479                 remain = remain - discount;
480             }
481 
482             //update to next stage
483             if (remain == currentStageEnd) {
484                 if (currentStageEnd != 0) {
485                     currentDifficulty = currentDifficulty + 1;
486                     if (remain - step > 0) {
487                         currentStageEnd = remain - step;
488                     } else {
489                         currentStageEnd = 0;
490                     }
491                 } else {
492                     input = 0;
493                 }
494             }
495         }
496         _transfer(address(this), _account, totalMint);
497         emit Reward(_account, totalMint, _amount);
498 
499         uint256 mintToTeam = totalMint * unlockDenominator / unlockNumerator;
500         if (teamRemain >= mintToTeam) {
501             teamRemain = teamRemain - mintToTeam;
502             _transfer(address(this), team, mintToTeam);
503             emit UnlockToTeam(team, mintToTeam, totalMint);
504         }
505 
506         return totalMint;
507     }
508 
509     
510     function setGameMachineRecords(address _input, bool _isActivated) public onlyCokeAdmin {
511         gameMachineRecords[_input] = _isActivated;
512     }
513 
514     function unlockAllTeamCoke() public onlyCokeAdmin {
515         if (block.number > unlockAllBlockNumber) {
516             _transfer(address(this), team, teamRemain);
517             teamRemain = 0;
518             emit UnlockToTeam(team, teamRemain, 0);
519         }
520     }
521 
522     modifier onlyCokeAdmin(){
523         rUtils.requireCode(msg.sender == cokeAdmin ? 0 : 503);
524         _;
525     }
526 
527 
528     modifier mintPermission(){
529         rUtils.requireCode(gameMachineRecords[msg.sender] == true ? 0 : 505);
530         _;
531     }
532 }