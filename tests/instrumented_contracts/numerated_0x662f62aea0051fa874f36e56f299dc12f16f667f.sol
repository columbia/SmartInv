1 pragma solidity ^0.4.24;
2 
3 /**
4  * @dev Library that helps prevent integer overflows and underflows,
5  * inspired by https://github.com/OpenZeppelin/zeppelin-solidity
6  */
7 library SafeMath {
8     function add(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a + b;
10         assert(c >= a);
11 
12         return c;
13     }
14 
15     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16         assert(b <= a);
17 
18         return a - b;
19     }
20 
21     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a * b;
23         assert(a == 0 || c / a == b);
24 
25         return c;
26     }
27 
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         require(b > 0);
30         uint256 c = a / b;
31 
32         return c;
33     }
34 }
35 
36 /**
37  * @title HasOwner
38  *
39  * @dev Allows for exclusive access to certain functionality.
40  */
41 contract HasOwner {
42     // Current owner.
43     address public owner;
44 
45     // Conditionally the new owner.
46     address public newOwner;
47 
48     /**
49      * @dev The constructor.
50      *
51      * @param _owner The address of the owner.
52      */
53     constructor (address _owner) internal {
54         owner = _owner;
55     }
56 
57     /**
58      * @dev Access control modifier that allows only the current owner to call the function.
59      */
60     modifier onlyOwner {
61         require(msg.sender == owner);
62         _;
63     }
64 
65     /**
66      * @dev The event is fired when the current owner is changed.
67      *
68      * @param _oldOwner The address of the previous owner.
69      * @param _newOwner The address of the new owner.
70      */
71     event OwnershipTransfer(address indexed _oldOwner, address indexed _newOwner);
72 
73     /**
74      * @dev Transfering the ownership is a two-step process, as we prepare
75      * for the transfer by setting `newOwner` and requiring `newOwner` to accept
76      * the transfer. This prevents accidental lock-out if something goes wrong
77      * when passing the `newOwner` address.
78      *
79      * @param _newOwner The address of the proposed new owner.
80      */
81     function transferOwnership(address _newOwner) public onlyOwner {
82         newOwner = _newOwner;
83     }
84 
85     /**
86      * @dev The `newOwner` finishes the ownership transfer process by accepting the
87      * ownership.
88      */
89     function acceptOwnership() public {
90         require(msg.sender == newOwner);
91 
92         emit OwnershipTransfer(owner, newOwner);
93 
94         owner = newOwner;
95     }
96 }
97 
98 /**
99  * @dev The standard ERC20 Token interface.
100  */
101 contract ERC20TokenInterface {
102     uint256 public totalSupply;  /* shorthand for public function and a property */
103     event Transfer(address indexed _from, address indexed _to, uint256 _value);
104     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
105     function balanceOf(address _owner) public constant returns (uint256 balance);
106     function transfer(address _to, uint256 _value) public returns (bool success);
107     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
108     function approve(address _spender, uint256 _value) public returns (bool success);
109     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
110 }
111 
112 /**
113  * @title ERC20Token
114  *
115  * @dev Implements the operations declared in the `ERC20TokenInterface`.
116  */
117 contract ERC20Token is ERC20TokenInterface {
118     using SafeMath for uint256;
119 
120     // Token account balances.
121     mapping (address => uint256) balances;
122 
123     // Delegated number of tokens to transfer.
124     mapping (address => mapping (address => uint256)) allowed;
125 
126     /**
127      * @dev Checks the balance of a certain address.
128      *
129      * @param _account The address which's balance will be checked.
130      *
131      * @return Returns the balance of the `_account` address.
132      */
133     function balanceOf(address _account) public constant returns (uint256 balance) {
134         return balances[_account];
135     }
136 
137     /**
138      * @dev Transfers tokens from one address to another.
139      *
140      * @param _to The target address to which the `_value` number of tokens will be sent.
141      * @param _value The number of tokens to send.
142      *
143      * @return Whether the transfer was successful or not.
144      */
145     function transfer(address _to, uint256 _value) public returns (bool success) {
146         if (balances[msg.sender] < _value || _value == 0) {
147 
148             return false;
149         }
150 
151         balances[msg.sender] = balances[msg.sender].sub(_value);
152         balances[_to] = balances[_to].add(_value);
153 
154         emit Transfer(msg.sender, _to, _value);
155 
156         return true;
157     }
158 
159     /**
160      * @dev Send `_value` tokens to `_to` from `_from` if `_from` has approved the process.
161      *
162      * @param _from The address of the sender.
163      * @param _to The address of the recipient.
164      * @param _value The number of tokens to be transferred.
165      *
166      * @return Whether the transfer was successful or not.
167      */
168     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
169         if (balances[_from] < _value || allowed[_from][msg.sender] < _value || _value == 0) {
170             return false;
171         }
172 
173         balances[_from] = balances[_from].sub(_value);
174         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
175         balances[_to] = balances[_to].add(_value);
176 
177         emit Transfer(_from, _to, _value);
178 
179         return true;
180     }
181 
182     /**
183      * @dev Allows another contract to spend some tokens on your behalf.
184      *
185      * @param _spender The address of the account which will be approved for transfer of tokens.
186      * @param _value The number of tokens to be approved for transfer.
187      *
188      * @return Whether the approval was successful or not.
189      */
190     function approve(address _spender, uint256 _value) public returns (bool success) {
191         allowed[msg.sender][_spender] = _value;
192 
193         emit Approval(msg.sender, _spender, _value);
194 
195         return true;
196     }
197 
198     /**
199      * @dev Shows the number of tokens approved by `_owner` that are allowed to be transferred by `_spender`.
200      *
201      * @param _owner The account which allowed the transfer.
202      * @param _spender The account which will spend the tokens.
203      *
204      * @return The number of tokens to be transferred.
205      */
206     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
207         return allowed[_owner][_spender];
208     }
209 
210     /**
211      * Don't accept ETH
212      */
213     function () public payable {
214         revert();
215     }
216 }
217 
218 /**
219  * @title BonusCloudTokenConfig
220  *
221  * @dev The static configuration for the Bonus Cloud Token.
222  */
223 contract BonusCloudTokenConfig {
224     // The name of the token.
225     string constant NAME = "BATTest";
226 
227     // The symbol of the token.
228     string constant SYMBOL = "BATTest";
229 
230     // The number of decimals for the token.
231     uint8 constant DECIMALS = 18;
232 
233     // Decimal factor for multiplication purposes.
234     uint256 constant DECIMALS_FACTOR = 10 ** uint(DECIMALS);
235 
236     // TotalSupply
237     uint256 constant TOTAL_SUPPLY = 7000000000 * DECIMALS_FACTOR;
238 
239     // The start date of the fundraiser: 2018-09-04 0:00:00 UTC.
240     uint constant START_DATE = 1536019200;
241 
242     // Total number of tokens locked for the BxC core team.
243     uint256 constant TOKENS_LOCKED_CORE_TEAM = 1400 * (10**6) * DECIMALS_FACTOR;
244 
245     // Total number of tokens for BxC advisors.
246     uint256 constant TOKENS_LOCKED_ADVISORS = 2100 * (10**6) * DECIMALS_FACTOR;
247 
248     // Total number of tokens for BxC advisors A.
249     uint256 constant TOKENS_LOCKED_ADVISORS_A = 350 * (10**6) * DECIMALS_FACTOR;
250 
251     // Total number of tokens for BxC advisors B.
252     uint256 constant TOKENS_LOCKED_ADVISORS_B = 350 * (10**6) * DECIMALS_FACTOR;
253 
254     // Total number of tokens for BxC advisors C.
255     uint256 constant TOKENS_LOCKED_ADVISORS_C = 700 * (10**6) * DECIMALS_FACTOR;
256 
257     // Total number of tokens for BxC advisors D.
258     uint256 constant TOKENS_LOCKED_ADVISORS_D = 700 * (10**6) * DECIMALS_FACTOR;
259 
260     // Total number of tokens locked for bxc foundation.
261     uint256 constant TOKEN_FOUNDATION = 700 * (10**6) * DECIMALS_FACTOR;
262 
263     // Total number of tokens locked for bounty program.
264     uint256 constant TOKENS_BOUNTY_PROGRAM = 2800 * (10**6) * DECIMALS_FACTOR;
265 }
266 
267 /**
268  * @title Bonus Cloud Token
269  *
270  * @dev A standard token implementation of the ERC20 token standard with added
271  *      HasOwner trait and initialized using the configuration constants.
272  */
273 contract BonusCloudToken is BonusCloudTokenConfig, HasOwner, ERC20Token {
274     // The name of the token.
275     string public name;
276 
277     // The symbol for the token.
278     string public symbol;
279 
280     // The decimals of the token.
281     uint8 public decimals;
282 
283     /**
284      * @dev The constructor.
285      *
286      */
287     constructor() public HasOwner(msg.sender) {
288         name = NAME;
289         symbol = SYMBOL;
290         decimals = DECIMALS;
291         totalSupply = TOTAL_SUPPLY;
292         balances[owner] = TOTAL_SUPPLY;
293     }
294 }
295 
296 /**
297  * @title TokenSafeVesting
298  *
299  * @dev A multi-bundle token safe contract
300  */
301 contract TokenSafeVesting is HasOwner {
302     using SafeMath for uint256;
303 
304     // The Total number of tokens locked.
305     uint256 total;
306     uint256 lapsedTotal;
307     address account;
308 
309     uint[] vestingCommencementDates;
310     uint[] vestingPercents;
311 
312     bool revocable;
313     bool revoked;
314 
315     // The `ERC20TokenInterface` contract.
316     ERC20TokenInterface token;
317 
318     /**
319      * @dev constructor new account with locked token balance
320      *
321      * @param _token The erc20 token address.
322      * @param _account The address of th account.
323      * @param _balanceTotal The number of tokens to be locked.
324      * @param _vestingCommencementDates The vesting commenement date list.
325      * @param _vestingPercents The vesting percents list.
326      * @param _revocable Whether the vesting is revocable
327      */
328      constructor (
329         address _token,
330         address _account,
331         uint256 _balanceTotal,
332         uint[] _vestingCommencementDates,
333         uint[] _vestingPercents,
334         bool _revocable) public HasOwner(msg.sender) {
335 
336         // check _vestingCommencementDates and _vestingPercents
337         require(_vestingPercents.length > 0);
338         require(_vestingCommencementDates.length == _vestingPercents.length);
339         uint percentSum;
340         for (uint32 i = 0; i < _vestingPercents.length; i++) {
341             require(_vestingPercents[i]>=0);
342             require(_vestingPercents[i]<=100);
343             percentSum = percentSum.add(_vestingPercents[i]);
344             require(_vestingCommencementDates[i]>0);
345             if (i > 0) {
346                 require(_vestingCommencementDates[i] > _vestingCommencementDates[i-1]);
347             }
348         }
349         require(percentSum==100);
350 
351         token = ERC20TokenInterface(_token);
352         account = _account;
353         total = _balanceTotal;
354         vestingCommencementDates = _vestingCommencementDates;
355         vestingPercents = _vestingPercents;
356         revocable = _revocable;
357     }
358 
359     /**
360      * @dev Allow the account to be released some token if it meets some vesting commencement date.
361      * TODO: public -> internal ?
362      */
363     function release() public {
364         require(!revoked);
365 
366         uint256 grant;
367         uint percent;
368         for (uint32 i = 0; i < vestingCommencementDates.length; i++) {
369             if (block.timestamp < vestingCommencementDates[i]) {
370             } else {
371                 percent += vestingPercents[i];
372             }
373         }
374         grant = total.mul(percent).div(100);
375 
376         if (grant > lapsedTotal) {
377             uint256 tokens = grant.sub(lapsedTotal);
378             lapsedTotal = lapsedTotal.add(tokens);
379             if (!token.transfer(account, tokens)) {
380                 revert();
381             } else {
382             }
383         }
384     }
385 
386     /**
387      * @dev Revoke token
388      */
389     function revoke() public onlyOwner {
390         require(revocable);
391         require(!revoked);
392 
393         release();
394         revoked = true;
395     }
396 }
397 
398 contract BonusCloudTokenFoundation is BonusCloudToken {
399 
400     // Vesting Token Pools
401     mapping (address => TokenSafeVesting) vestingTokenPools;
402 
403     function addLockedAccount(
404         address _account,
405         uint256 _balanceTotal,
406         uint[] _vestingCommencementDates,
407         uint[] _vestingPercents,
408         bool _revocable) internal onlyOwner {
409 
410         TokenSafeVesting vestingToken = new TokenSafeVesting(
411             this,
412             _account,
413             _balanceTotal,
414             _vestingCommencementDates,
415             _vestingPercents,
416             _revocable);
417 
418         vestingTokenPools[_account] = vestingToken;
419         transfer(vestingToken, _balanceTotal);
420     }
421 
422     function releaseAccount(address _account) public {
423         TokenSafeVesting vestingToken;
424         vestingToken = vestingTokenPools[_account];
425         vestingToken.release();
426     }
427 
428     function revokeAccount(address _account) public onlyOwner {
429         TokenSafeVesting vestingToken;
430         vestingToken = vestingTokenPools[_account];
431         vestingToken.revoke();
432     }
433 
434     constructor() public {
435         // bxc foundation
436         uint[] memory DFoundation = new uint[](1);
437         DFoundation[0] = START_DATE;
438         uint[] memory PFoundation = new uint[](1);
439         PFoundation[0] = 100;
440         addLockedAccount(0x4eE4F2A51EFf3DDDe7d7be6Da37Bb7f3F08771f7, TOKEN_FOUNDATION, DFoundation, PFoundation, false);
441 
442         uint[] memory DAdvisorA = new uint[](5);
443         DAdvisorA[0] = START_DATE;
444         DAdvisorA[1] = START_DATE + 90 days;
445         DAdvisorA[2] = START_DATE + 180 days;
446         DAdvisorA[3] = START_DATE + 270 days;
447         DAdvisorA[4] = START_DATE + 365 days;
448         uint[] memory PAdvisorA = new uint[](5);
449         PAdvisorA[0] = 35;
450         PAdvisorA[1] = 17;
451         PAdvisorA[2] = 16;
452         PAdvisorA[3] = 16;
453         PAdvisorA[4] = 16;
454         addLockedAccount(0x67a25099C3958b884687663C17d22e88C83e9F9A, TOKENS_LOCKED_ADVISORS_A, DAdvisorA, PAdvisorA, false);
455 
456         // advisor b
457         uint[] memory DAdvisorB = new uint[](5);
458         DAdvisorB[0] = START_DATE;
459         DAdvisorB[1] = START_DATE + 90 days;
460         DAdvisorB[2] = START_DATE + 180 days;
461         DAdvisorB[3] = START_DATE + 270 days;
462         DAdvisorB[4] = START_DATE + 365 days;
463         uint[] memory PAdvisorB = new uint[](5);
464         PAdvisorB[0] = 35;
465         PAdvisorB[1] = 17;
466         PAdvisorB[2] = 16;
467         PAdvisorB[3] = 16;
468         PAdvisorB[4] = 16;
469         addLockedAccount(0x3F756EA6F3a9d0e24f9857506D0E76cCCbAcFd59, TOKENS_LOCKED_ADVISORS_B, DAdvisorB, PAdvisorB, false);
470 
471         // advisor c
472         uint[] memory DAdvisorC = new uint[](4);
473         DAdvisorC[0] = START_DATE + 90 days;
474         DAdvisorC[1] = START_DATE + 180 days;
475         DAdvisorC[2] = START_DATE + 270 days;
476         DAdvisorC[3] = START_DATE + 365 days;
477         uint[] memory PAdvisorC = new uint[](4);
478         PAdvisorC[0] = 25;
479         PAdvisorC[1] = 25;
480         PAdvisorC[2] = 25;
481         PAdvisorC[3] = 25;
482         addLockedAccount(0x0022F267eb8A8463C241e3bd23184e0C7DC783F3, TOKENS_LOCKED_ADVISORS_C, DAdvisorC, PAdvisorC, false);
483 
484         // bxc core team
485         uint[] memory DCoreTeam = new uint[](12);
486         DCoreTeam[0] = START_DATE + 90 days;
487         DCoreTeam[1] = START_DATE + 180 days;
488         DCoreTeam[2] = START_DATE + 270 days;
489         DCoreTeam[3] = START_DATE + 365 days;
490         DCoreTeam[4] = START_DATE + 365 days + 90 days;
491         DCoreTeam[5] = START_DATE + 365 days + 180 days;
492         DCoreTeam[6] = START_DATE + 365 days + 270 days;
493         DCoreTeam[7] = START_DATE + 365 days + 365 days;
494         DCoreTeam[8] = START_DATE + 730 days + 90 days;
495         DCoreTeam[9] = START_DATE + 730 days + 180 days;
496         DCoreTeam[10] = START_DATE + 730 days + 270 days;
497         DCoreTeam[11] = START_DATE + 730 days + 365 days;
498         uint[] memory PCoreTeam = new uint[](12);
499         PCoreTeam[0] = 8;
500         PCoreTeam[1] = 8;
501         PCoreTeam[2] = 8;
502         PCoreTeam[3] = 9;
503         PCoreTeam[4] = 8;
504         PCoreTeam[5] = 8;
505         PCoreTeam[6] = 9;
506         PCoreTeam[7] = 9;
507         PCoreTeam[8] = 8;
508         PCoreTeam[9] = 8;
509         PCoreTeam[10] = 8;
510         PCoreTeam[11] = 9;
511         addLockedAccount(0xaEF494C6Af26ef6D9551E91A36b0502A216fF276, TOKENS_LOCKED_CORE_TEAM, DCoreTeam, PCoreTeam, false);
512 
513         // bxc test dev
514         uint[] memory DTest = new uint[](2);
515         DTest[0] = START_DATE + 12 hours;
516         DTest[1] = START_DATE + 16 hours;
517         uint[] memory PTest = new uint[](2);
518         PTest[0] = 50;
519         PTest[1] = 50;
520         addLockedAccount(0x67a25099C3958b884687663C17d22e88C83e9F9A, 10 * (10**6) * DECIMALS_FACTOR, DTest, PTest, false);
521     }
522 }