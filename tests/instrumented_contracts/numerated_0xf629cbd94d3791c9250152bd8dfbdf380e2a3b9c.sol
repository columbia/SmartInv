1 pragma solidity ^0.4.15;
2 /*
3     Utilities & Common Modifiers
4 */
5 contract Utils {
6     /**
7         constructor
8     */
9     function Utils() {
10     }
11 
12     // validates an address - currently only checks that it isn't null
13     modifier validAddress(address _address) {
14         require(_address != 0x0);
15         _;
16     }
17 
18     // verifies that the address is different than this contract address
19     modifier notThis(address _address) {
20         require(_address != address(this));
21         _;
22     }
23 
24     // Overflow protected math functions
25 
26     /**
27         @dev returns the sum of _x and _y, asserts if the calculation overflows
28 
29         @param _x   value 1
30         @param _y   value 2
31 
32         @return sum
33     */
34     function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
35         uint256 z = _x + _y;
36         assert(z >= _x);
37         return z;
38     }
39 
40     /**
41         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
42 
43         @param _x   minuend
44         @param _y   subtrahend
45 
46         @return difference
47     */
48     function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
49         assert(_x >= _y);
50         return _x - _y;
51     }
52 
53     /**
54         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
55 
56         @param _x   factor 1
57         @param _y   factor 2
58 
59         @return product
60     */
61     function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {
62         uint256 z = _x * _y;
63         assert(_x == 0 || z / _x == _y);
64         return z;
65     }
66 }
67 
68 /*
69     ERC20 Standard Token interface
70 */
71 contract IERC20Token {
72     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
73     function name() public constant returns (string) { name; }
74     function symbol() public constant returns (string) { symbol; }
75     function decimals() public constant returns (uint8) { decimals; }
76     function totalSupply() public constant returns (uint256) { totalSupply; }
77     function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }
78     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }
79 
80     function transfer(address _to, uint256 _value) public returns (bool success);
81     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
82     function approve(address _spender, uint256 _value) public returns (bool success);
83 }
84 
85 
86 /**
87     ERC20 Standard Token implementation
88 */
89 contract ERC20Token is IERC20Token, Utils {
90     string public standard = "Token 0.1";
91     string public name = "";
92     string public symbol = "";
93     uint8 public decimals = 0;
94     uint256 public totalSupply = 0;
95     mapping (address => uint256) public balanceOf;
96     mapping (address => mapping (address => uint256)) public allowance;
97 
98     event Transfer(address indexed _from, address indexed _to, uint256 _value);
99     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
100 
101     /**
102         @dev constructor
103 
104         @param _name        token name
105         @param _symbol      token symbol
106         @param _decimals    decimal points, for display purposes
107     */
108     function ERC20Token(string _name, string _symbol, uint8 _decimals) {
109         require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
110 
111         name = _name;
112         symbol = _symbol;
113         decimals = _decimals;
114     }
115 
116     /**
117         @dev send coins
118         throws on any error rather then return a false flag to minimize user errors
119 
120         @param _to      target address
121         @param _value   transfer amount
122 
123         @return true if the transfer was successful, false if it wasn't
124     */
125     function transfer(address _to, uint256 _value)
126         public
127         validAddress(_to)
128         returns (bool success)
129     {
130         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
131         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
132         Transfer(msg.sender, _to, _value);
133         return true;
134     }
135 
136     /**
137         @dev an account/contract attempts to get the coins
138         throws on any error rather then return a false flag to minimize user errors
139 
140         @param _from    source address
141         @param _to      target address
142         @param _value   transfer amount
143 
144         @return true if the transfer was successful, false if it wasn't
145     */
146     function transferFrom(address _from, address _to, uint256 _value)
147         public
148         validAddress(_from)
149         validAddress(_to)
150         returns (bool success)
151     {
152         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
153         balanceOf[_from] = safeSub(balanceOf[_from], _value);
154         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
155         Transfer(_from, _to, _value);
156         return true;
157     }
158 
159     /**
160         @dev allow another account/contract to spend some tokens on your behalf
161         throws on any error rather then return a false flag to minimize user errors
162 
163         also, to minimize the risk of the approve/transferFrom attack vector
164         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
165         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
166 
167         @param _spender approved address
168         @param _value   allowance amount
169 
170         @return true if the approval was successful, false if it wasn't
171     */
172     function approve(address _spender, uint256 _value)
173         public
174         validAddress(_spender)
175         returns (bool success)
176     {
177         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
178         require(_value == 0 || allowance[msg.sender][_spender] == 0);
179 
180         allowance[msg.sender][_spender] = _value;
181         Approval(msg.sender, _spender, _value);
182         return true;
183     }
184 }
185 
186 /*
187     Owned contract interface
188 */
189 contract IOwned {
190     // this function isn't abstract since the compiler emits automatically generated getter functions as external
191     function owner() public constant returns (address) { owner; }
192 
193     function transferOwnership(address _newOwner) public;
194     function acceptOwnership() public;
195 }
196 
197 /*
198     Provides support and utilities for contract ownership
199 */
200 contract Owned is IOwned {
201     address public owner;
202     address public newOwner;
203 
204     event OwnerUpdate(address _prevOwner, address _newOwner);
205 
206     /**
207         @dev constructor
208     */
209     function Owned() {
210         owner = msg.sender;
211     }
212 
213     // allows execution by the owner only
214     modifier ownerOnly {
215         assert(msg.sender == owner);
216         _;
217     }
218 
219     /**
220         @dev allows transferring the contract ownership
221         the new owner still needs to accept the transfer
222         can only be called by the contract owner
223 
224         @param _newOwner    new contract owner
225     */
226     function transferOwnership(address _newOwner) public ownerOnly {
227         require(_newOwner != owner);
228         newOwner = _newOwner;
229     }
230 
231     /**
232         @dev used by a new owner to accept an ownership transfer
233     */
234     function acceptOwnership() public {
235         require(msg.sender == newOwner);
236         OwnerUpdate(owner, newOwner);
237         owner = newOwner;
238         newOwner = 0x0;
239     }
240 }
241 
242 /*
243     Token Holder interface
244 */
245 contract ITokenHolder is IOwned {
246     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
247 }
248 
249 /*
250     We consider every contract to be a 'token holder' since it's currently not possible
251     for a contract to deny receiving tokens.
252 
253     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
254     the owner to send tokens that were sent to the contract by mistake back to their sender.
255 */
256 contract TokenHolder is ITokenHolder, Owned, Utils {
257     /**
258         @dev constructor
259     */
260     function TokenHolder() {
261     }
262 
263     /**
264         @dev withdraws tokens held by the contract and sends them to an account
265         can only be called by the owner
266 
267         @param _token   ERC20 token contract address
268         @param _to      account to receive the new amount
269         @param _amount  amount to withdraw
270     */
271     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
272         public
273         ownerOnly
274         validAddress(_token)
275         validAddress(_to)
276         notThis(_to)
277     {
278         assert(_token.transfer(_to, _amount));
279     }
280 }
281 
282 
283 contract ENJToken is ERC20Token, TokenHolder {
284 
285 ///////////////////////////////////////// VARIABLE INITIALIZATION /////////////////////////////////////////
286 
287     uint256 constant public ENJ_UNIT = 10 ** 18;
288     uint256 public totalSupply = 1 * (10**9) * ENJ_UNIT;
289 
290     //  Constants 
291     uint256 constant public maxPresaleSupply = 600 * 10**6 * ENJ_UNIT;           // Total presale supply at max bonus
292     uint256 constant public minCrowdsaleAllocation = 200 * 10**6 * ENJ_UNIT;     // Min amount for crowdsale
293     uint256 constant public incentivisationAllocation = 100 * 10**6 * ENJ_UNIT;  // Incentivisation Allocation
294     uint256 constant public advisorsAllocation = 26 * 10**6 * ENJ_UNIT;          // Advisors Allocation
295     uint256 constant public enjinTeamAllocation = 74 * 10**6 * ENJ_UNIT;         // Enjin Team allocation
296 
297     address public crowdFundAddress;                                             // Address of the crowdfund
298     address public advisorAddress;                                               // Enjin advisor's address
299     address public incentivisationFundAddress;                                   // Address that holds the incentivization funds
300     address public enjinTeamAddress;                                             // Enjin Team address
301 
302     //  Variables
303 
304     uint256 public totalAllocatedToAdvisors = 0;                                 // Counter to keep track of advisor token allocation
305     uint256 public totalAllocatedToTeam = 0;                                     // Counter to keep track of team token allocation
306     uint256 public totalAllocated = 0;                                           // Counter to keep track of overall token allocation
307     uint256 constant public endTime = 1509494340;                                // 10/31/2017 @ 11:59pm (UTC) crowdsale end time (in seconds)
308 
309     bool internal isReleasedToPublic = false;                         // Flag to allow transfer/transferFrom before the end of the crowdfund
310 
311     uint256 internal teamTranchesReleased = 0;                          // Track how many tranches (allocations of 12.5% team tokens) have been released
312     uint256 internal maxTeamTranches = 8;                               // The number of tranches allowed to the team until depleted
313 
314 ///////////////////////////////////////// MODIFIERS /////////////////////////////////////////
315 
316     // Enjin Team timelock    
317     modifier safeTimelock() {
318         require(now >= endTime + 6 * 4 weeks);
319         _;
320     }
321 
322     // Advisor Team timelock    
323     modifier advisorTimelock() {
324         require(now >= endTime + 2 * 4 weeks);
325         _;
326     }
327 
328     // Function only accessible by the Crowdfund contract
329     modifier crowdfundOnly() {
330         require(msg.sender == crowdFundAddress);
331         _;
332     }
333 
334     ///////////////////////////////////////// CONSTRUCTOR /////////////////////////////////////////
335 
336     /**
337         @dev constructor
338         @param _crowdFundAddress   Crowdfund address
339         @param _advisorAddress     Advisor address
340     */
341     function ENJToken(address _crowdFundAddress, address _advisorAddress, address _incentivisationFundAddress, address _enjinTeamAddress)
342     ERC20Token("Enjin Coin", "ENJ", 18)
343      {
344         crowdFundAddress = _crowdFundAddress;
345         advisorAddress = _advisorAddress;
346         enjinTeamAddress = _enjinTeamAddress;
347         incentivisationFundAddress = _incentivisationFundAddress;
348         balanceOf[_crowdFundAddress] = minCrowdsaleAllocation + maxPresaleSupply; // Total presale + crowdfund tokens
349         balanceOf[_incentivisationFundAddress] = incentivisationAllocation;       // 10% Allocated for Marketing and Incentivisation
350         totalAllocated += incentivisationAllocation;                              // Add to total Allocated funds
351     }
352 
353 ///////////////////////////////////////// ERC20 OVERRIDE /////////////////////////////////////////
354 
355     /**
356         @dev send coins
357         throws on any error rather then return a false flag to minimize user errors
358         in addition to the standard checks, the function throws if transfers are disabled
359 
360         @param _to      target address
361         @param _value   transfer amount
362 
363         @return true if the transfer was successful, throws if it wasn't
364     */
365     function transfer(address _to, uint256 _value) public returns (bool success) {
366         if (isTransferAllowed() == true || msg.sender == crowdFundAddress || msg.sender == incentivisationFundAddress) {
367             assert(super.transfer(_to, _value));
368             return true;
369         }
370         revert();        
371     }
372 
373     /**
374         @dev an account/contract attempts to get the coins
375         throws on any error rather then return a false flag to minimize user errors
376         in addition to the standard checks, the function throws if transfers are disabled
377 
378         @param _from    source address
379         @param _to      target address
380         @param _value   transfer amount
381 
382         @return true if the transfer was successful, throws if it wasn't
383     */
384     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
385         if (isTransferAllowed() == true || msg.sender == crowdFundAddress || msg.sender == incentivisationFundAddress) {        
386             assert(super.transferFrom(_from, _to, _value));
387             return true;
388         }
389         revert();
390     }
391 
392 ///////////////////////////////////////// ALLOCATION FUNCTIONS /////////////////////////////////////////
393 
394     /**
395         @dev Release one single tranche of the Enjin Team Token allocation
396         throws if before timelock (6 months) ends and if not initiated by the owner of the contract
397         returns true if valid
398         Schedule goes as follows:
399         3 months: 12.5% (this tranche can only be released after the initial 6 months has passed)
400         6 months: 12.5%
401         9 months: 12.5%
402         12 months: 12.5%
403         15 months: 12.5%
404         18 months: 12.5%
405         21 months: 12.5%
406         24 months: 12.5%
407         @return true if successful, throws if not
408     */
409     function releaseEnjinTeamTokens() safeTimelock ownerOnly returns(bool success) {
410         require(totalAllocatedToTeam < enjinTeamAllocation);
411 
412         uint256 enjinTeamAlloc = enjinTeamAllocation / 1000;
413         uint256 currentTranche = uint256(now - endTime) / 12 weeks;     // "months" after crowdsale end time (division floored)
414 
415         if(teamTranchesReleased < maxTeamTranches && currentTranche > teamTranchesReleased) {
416             teamTranchesReleased++;
417 
418             uint256 amount = safeMul(enjinTeamAlloc, 125);
419             balanceOf[enjinTeamAddress] = safeAdd(balanceOf[enjinTeamAddress], amount);
420             Transfer(0x0, enjinTeamAddress, amount);
421             totalAllocated = safeAdd(totalAllocated, amount);
422             totalAllocatedToTeam = safeAdd(totalAllocatedToTeam, amount);
423             return true;
424         }
425         revert();
426     }
427 
428     /**
429         @dev release Advisors Token allocation
430         throws if before timelock (2 months) ends or if no initiated by the advisors address
431         or if there is no more allocation to give out
432         returns true if valid
433 
434         @return true if successful, throws if not
435     */
436     function releaseAdvisorTokens() advisorTimelock ownerOnly returns(bool success) {
437         require(totalAllocatedToAdvisors == 0);
438         balanceOf[advisorAddress] = safeAdd(balanceOf[advisorAddress], advisorsAllocation);
439         totalAllocated = safeAdd(totalAllocated, advisorsAllocation);
440         totalAllocatedToAdvisors = advisorsAllocation;
441         Transfer(0x0, advisorAddress, advisorsAllocation);
442         return true;
443     }
444 
445     /**
446         @dev Retrieve unsold tokens from the crowdfund
447         throws if before timelock (6 months from end of Crowdfund) ends and if no initiated by the owner of the contract
448         returns true if valid
449 
450         @return true if successful, throws if not
451     */
452     function retrieveUnsoldTokens() safeTimelock ownerOnly returns(bool success) {
453         uint256 amountOfTokens = balanceOf[crowdFundAddress];
454         balanceOf[crowdFundAddress] = 0;
455         balanceOf[incentivisationFundAddress] = safeAdd(balanceOf[incentivisationFundAddress], amountOfTokens);
456         totalAllocated = safeAdd(totalAllocated, amountOfTokens);
457         Transfer(crowdFundAddress, incentivisationFundAddress, amountOfTokens);
458         return true;
459     }
460 
461     /**
462         @dev Keep track of token allocations
463         can only be called by the crowdfund contract
464     */
465     function addToAllocation(uint256 _amount) crowdfundOnly {
466         totalAllocated = safeAdd(totalAllocated, _amount);
467     }
468 
469     /**
470         @dev Function to allow transfers
471         can only be called by the owner of the contract
472         Transfers will be allowed regardless after the crowdfund end time.
473     */
474     function allowTransfers() ownerOnly {
475         isReleasedToPublic = true;
476     } 
477 
478     /**
479         @dev User transfers are allowed/rejected
480         Transfers are forbidden before the end of the crowdfund
481     */
482     function isTransferAllowed() internal constant returns(bool) {
483         if (now > endTime || isReleasedToPublic == true) {
484             return true;
485         }
486         return false;
487     }
488 }