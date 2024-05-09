1 pragma solidity ^0.5.7;
2 pragma experimental ABIEncoderV2;
3 
4 contract IRequireUtils {
5     function requireCode(uint256 code) external pure;
6 
7     //function interpret(uint256 code) public pure returns (string memory);
8 }
9 
10 
11 library SafeMath {
12     /**
13      * @dev Multiplies two unsigned integers, reverts on overflow.
14      */
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
17         // benefit is lost if 'b' is also tested.
18         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19         if (a == 0) {
20             return 0;
21         }
22 
23         uint256 c = a * b;
24         require(c / a == b);
25 
26         return c;
27     }
28 
29     /**
30      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
31      */
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         // Solidity only automatically asserts when dividing by 0
34         require(b > 0);
35         uint256 c = a / b;
36         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37 
38         return c;
39     }
40 
41     /**
42      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b <= a);
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     /**
52      * @dev Adds two unsigned integers, reverts on overflow.
53      */
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56         require(c >= a);
57 
58         return c;
59     }
60 
61     /**
62      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
63      * reverts when dividing by zero.
64      */
65     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
66         require(b != 0);
67         return a % b;
68     }
69 }
70 
71 
72 interface IERC20 {
73     function transfer(address to, uint256 value) external returns (bool);
74 
75     function approve(address spender, uint256 value) external returns (bool);
76 
77     function transferFrom(address from, address to, uint256 value) external returns (bool);
78 
79     function totalSupply() external view returns (uint256);
80 
81     function balanceOf(address who) external view returns (uint256);
82 
83     function allowance(address owner, address spender) external view returns (uint256);
84 
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 contract ERC20 is IERC20 {
91     using SafeMath for uint256;
92 
93     mapping(address => uint256) private _balances;
94 
95     mapping(address => mapping(address => uint256)) private _allowed;
96 
97     uint256 private _totalSupply;
98 
99     /**
100      * @dev Total number of tokens in existence.
101      */
102     function totalSupply() public view returns (uint256) {
103         return _totalSupply;
104     }
105 
106     /**
107      * @dev Gets the balance of the specified address.
108      * @param owner The address to query the balance of.
109      * @return A uint256 representing the amount owned by the passed address.
110      */
111     function balanceOf(address owner) public view returns (uint256) {
112         return _balances[owner];
113     }
114 
115     /**
116      * @dev Function to check the amount of tokens that an owner allowed to a spender.
117      * @param owner address The address which owns the funds.
118      * @param spender address The address which will spend the funds.
119      * @return A uint256 specifying the amount of tokens still available for the spender.
120      */
121     function allowance(address owner, address spender) public view returns (uint256) {
122         return _allowed[owner][spender];
123     }
124 
125     /**
126      * @dev Transfer token to a specified address.
127      * @param to The address to transfer to.
128      * @param value The amount to be transferred.
129      */
130     function transfer(address to, uint256 value) public returns (bool) {
131         _transfer(msg.sender, to, value);
132         return true;
133     }
134 
135     /**
136      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
137      * Beware that changing an allowance with this method brings the risk that someone may use both the old
138      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
139      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
140      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141      * @param spender The address which will spend the funds.
142      * @param value The amount of tokens to be spent.
143      */
144     function approve(address spender, uint256 value) public returns (bool) {
145         _approve(msg.sender, spender, value);
146         return true;
147     }
148 
149     /**
150      * @dev Transfer tokens from one address to another.
151      * Note that while this function emits an Approval event, this is not required as per the specification,
152      * and other compliant implementations may not emit the event.
153      * @param from address The address which you want to send tokens from
154      * @param to address The address which you want to transfer to
155      * @param value uint256 the amount of tokens to be transferred
156      */
157     function transferFrom(address from, address to, uint256 value) public returns (bool) {
158         _transfer(from, to, value);
159         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
160         return true;
161     }
162 
163     /**
164      * @dev Increase the amount of tokens that an owner allowed to a spender.
165      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
166      * allowed value is better to use this function to avoid 2 calls (and wait until
167      * the first transaction is mined)
168      * From MonolithDAO Token.sol
169      * Emits an Approval event.
170      * @param spender The address which will spend the funds.
171      * @param addedValue The amount of tokens to increase the allowance by.
172      */
173     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
174         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
175         return true;
176     }
177 
178     /**
179      * @dev Decrease the amount of tokens that an owner allowed to a spender.
180      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
181      * allowed value is better to use this function to avoid 2 calls (and wait until
182      * the first transaction is mined)
183      * From MonolithDAO Token.sol
184      * Emits an Approval event.
185      * @param spender The address which will spend the funds.
186      * @param subtractedValue The amount of tokens to decrease the allowance by.
187      */
188     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
189         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
190         return true;
191     }
192 
193     /**
194      * @dev Transfer token for a specified addresses.
195      * @param from The address to transfer from.
196      * @param to The address to transfer to.
197      * @param value The amount to be transferred.
198      */
199     function _transfer(address from, address to, uint256 value) internal {
200         require(to != address(0));
201 
202         _balances[from] = _balances[from].sub(value);
203         _balances[to] = _balances[to].add(value);
204         emit Transfer(from, to, value);
205     }
206 
207     /**
208      * @dev Internal function that mints an amount of the token and assigns it to
209      * an account. This encapsulates the modification of balances such that the
210      * proper events are emitted.
211      * @param account The account that will receive the created tokens.
212      * @param value The amount that will be created.
213      */
214     function _mint(address account, uint256 value) internal {
215         require(account != address(0));
216 
217         _totalSupply = _totalSupply.add(value);
218         _balances[account] = _balances[account].add(value);
219         emit Transfer(address(0), account, value);
220     }
221 
222     /**
223      * @dev Internal function that burns an amount of the token of a given
224      * account.
225      * @param account The account whose tokens will be burnt.
226      * @param value The amount that will be burnt.
227      */
228     function _burn(address account, uint256 value) internal {
229         require(account != address(0));
230 
231         _totalSupply = _totalSupply.sub(value);
232         _balances[account] = _balances[account].sub(value);
233         emit Transfer(account, address(0), value);
234     }
235 
236     /**
237      * @dev Approve an address to spend another addresses' tokens.
238      * @param owner The address that owns the tokens.
239      * @param spender The address that will spend the tokens.
240      * @param value The number of tokens that can be spent.
241      */
242     function _approve(address owner, address spender, uint256 value) internal {
243         require(spender != address(0));
244         require(owner != address(0));
245 
246         _allowed[owner][spender] = value;
247         emit Approval(owner, spender, value);
248     }
249 
250     /**
251      * @dev Internal function that burns an amount of the token of a given
252      * account, deducting from the sender's allowance for said account. Uses the
253      * internal burn function.
254      * Emits an Approval event (reflecting the reduced allowance).
255      * @param account The account whose tokens will be burnt.
256      * @param value The amount that will be burnt.
257      */
258     function _burnFrom(address account, uint256 value) internal {
259         _burn(account, value);
260         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
261     }
262 }
263 contract Coke is ERC20 {
264     using SafeMath for uint256;
265 
266     IRequireUtils internal rUtils;
267 
268     //1 Coke = 10^18 Tin
269     string public name = "CB";
270     string public symbol = "CB";
271     uint256 public decimals = 18; //1:1
272 
273     address public cokeAdmin;// admin has rights to mint and burn and etc.
274     mapping(address => bool) public gameMachineRecords;// game machine has permission to mint coke
275 
276     uint256 public step;
277     uint256 public remain;
278     uint256 public currentDifficulty;//starts from 0
279     uint256 public currentStageEnd;
280 
281     address internal team;
282     uint256 public teamRemain;
283     uint256 public unlockAllBlockNumber;
284     //uint256 unlockRate;
285     uint256 internal unlockNumerator;
286     uint256 internal unlockDenominator;
287 
288     event Reward(address indexed account, uint256 amount, uint256 rawAmount);
289     event UnlockToTeam(address indexed account, uint256 amount, uint256 rawReward);
290     event PermitGameMachine(address indexed gameMachineAddress, bool approved);
291 
292 
293     constructor (IRequireUtils _rUtils, address _cokeAdmin, address _team, uint256 _unlockAllBlockNumber, address _bounty) public {
294         rUtils = _rUtils;
295         cokeAdmin = _cokeAdmin;
296 
297         require(_cokeAdmin != address(0));
298         require(_team != address(0));
299         require(_bounty != address(0));
300 
301         unlockAllBlockNumber = _unlockAllBlockNumber;
302         uint256 cap = 8000000000000000000000000000;
303         team = _team;
304         teamRemain = 1600000000000000000000000000;
305 
306         _mint(address(this), 1600000000000000000000000000);
307         _mint(_bounty, 800000000000000000000000000);
308 
309         step = cap.mul(5).div(100);
310         remain = cap.sub(teamRemain).sub(800000000000000000000000000);
311 
312         _mint(address(this), remain);
313 
314         //unlockRate = remain / _toTeam;
315         unlockNumerator = 7;
316         unlockDenominator = 2;
317         if (remain.sub(step) > 0) {
318             currentStageEnd = remain.sub(step);
319         } else {
320             currentStageEnd = 0;
321         }
322         currentDifficulty = 0;
323     }
324 
325     //this reward is for mining COKE by playing game using ETH
326     function betReward(address _account, uint256 _amount) public mintPermission returns (uint256 minted){
327         if (remain == 0) {
328             return 0;
329         }
330 
331         uint256 input = _amount;
332         uint256 totalMint = 0;
333         while (input > 0) {
334 
335             uint256 factor = 2 ** currentDifficulty;
336             uint256 discount = input.div(factor);
337             //we ceil it here
338             if (input.mod(factor) != 0) {
339                 discount = discount.add(1);
340             }
341 
342             if (discount > remain.sub(currentStageEnd)) {
343                 uint256 toMint = remain.sub(currentStageEnd);
344                 totalMint = totalMint.add(toMint);
345                 input = input.sub(toMint.mul(factor));
346                 //remain = remain.sub(toMint);
347                 remain = currentStageEnd;
348             } else {
349                 totalMint = totalMint.add(discount);
350                 input = 0;
351                 remain = remain.sub(discount);
352             }
353 
354             //update to next stage
355             if (remain <= currentStageEnd) {
356                 if (currentStageEnd != 0) {
357                     currentDifficulty = currentDifficulty.add(1);
358                     if (remain.sub(step) > 0) {
359                         currentStageEnd = remain.sub(step);
360                     } else {
361                         currentStageEnd = 0;
362                     }
363                 } else {
364                     //all cokes are minted, we can't do any more further
365                     //set input to 0 to escape
366                     input = 0;
367                 }
368             }
369         }
370         //_mint(_account, totalMint);
371         _transfer(address(this), _account, totalMint);
372         emit Reward(_account, totalMint, _amount);
373 
374         //uint256 mintToTeam = totalMint / unlockRate;
375         uint256 mintToTeam = totalMint.mul(unlockDenominator).div(unlockNumerator);
376         if (teamRemain >= mintToTeam) {
377             teamRemain = teamRemain.sub(mintToTeam);
378             //_mint(team, mintToTeam);
379             _transfer(address(this), team, mintToTeam);
380             emit UnlockToTeam(team, mintToTeam, totalMint);
381         } else {
382             mintToTeam = teamRemain;
383             teamRemain = 0;
384             _transfer(address(this), team, mintToTeam);
385             emit UnlockToTeam(team, mintToTeam, totalMint);
386         }
387 
388         return totalMint;
389     }
390 
391     function activateGameMachine(address _input) public onlyCokeAdmin {
392         gameMachineRecords[_input] = true;
393         emit PermitGameMachine(_input, true);
394     }
395 
396     function deactivateGameMachine(address _input) public onlyCokeAdmin {
397         gameMachineRecords[_input] = false;
398         emit PermitGameMachine(_input, false);
399     }
400 
401     function unlockAllTeamCoke() public onlyCokeAdmin {
402         if (block.number > unlockAllBlockNumber) {
403             _transfer(address(this), team, teamRemain);
404             teamRemain = 0;
405             emit UnlockToTeam(team, teamRemain, 0);
406         }
407     }
408 
409     modifier onlyCokeAdmin(){
410         rUtils.requireCode(msg.sender == cokeAdmin ? 0 : 503);
411         _;
412     }
413 
414     /*modifier burnPermission(){
415         rUtils.requireCode(msg.sender == address(lottery) ? 0 : 504);
416         _;
417     }*/
418 
419     modifier mintPermission(){
420         rUtils.requireCode(gameMachineRecords[msg.sender] == true ? 0 : 505);
421         _;
422     }
423 }