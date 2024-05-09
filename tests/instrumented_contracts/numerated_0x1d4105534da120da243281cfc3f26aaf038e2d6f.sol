1 pragma solidity ^0.4.15;
2 
3 contract Utils {
4     /**
5         constructor
6     */
7     function Utils() internal {
8     }
9 
10     // validates an address - currently only checks that it isn't null
11     modifier validAddress(address _address) {
12         require(_address != 0x0);
13         _;
14     }
15 
16     // verifies that the address is different than this contract address
17     modifier notThis(address _address) {
18         require(_address != address(this));
19         _;
20     }
21 
22     // Overflow protected math functions
23 
24     /**
25         @dev returns the sum of _x and _y, asserts if the calculation overflows
26 
27         @param _x   value 1
28         @param _y   value 2
29 
30         @return sum
31     */
32     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
33         uint256 z = _x + _y;
34         assert(z >= _x);
35         return z;
36     }
37 
38     /**
39         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
40 
41         @param _x   minuend
42         @param _y   subtrahend
43 
44         @return difference
45     */
46     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
47         assert(_x >= _y);
48         return _x - _y;
49     }
50 
51     /**
52         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
53 
54         @param _x   factor 1
55         @param _y   factor 2
56 
57         @return product
58     */
59     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
60         uint256 z = _x * _y;
61         assert(_x == 0 || z / _x == _y);
62         return z;
63     }
64 }
65 
66 /*
67     ERC20 Standard Token interface
68 */
69 contract IERC20Token {
70     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
71     function name() public constant returns (string) { name; }
72     function symbol() public constant returns (string) { symbol; }
73     function decimals() public constant returns (uint8) { decimals; }
74     function totalSupply() public constant returns (uint256) { totalSupply; }
75     function balanceOf(address _owner) public constant returns (uint256 balance);
76     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
77 
78     function transfer(address _to, uint256 _value) public returns (bool success);
79     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
80     function approve(address _spender, uint256 _value) public returns (bool success);
81 }
82 
83 
84 /**
85     ERC20 Standard Token implementation
86 */
87 contract StandardERC20Token is IERC20Token, Utils {
88     string public name = "";
89     string public symbol = "";
90     uint8 public decimals = 0;
91     uint256 public totalSupply = 0;
92     mapping (address => uint256) public balanceOf;
93     mapping (address => mapping (address => uint256)) public allowance;
94 
95     event Transfer(address indexed _from, address indexed _to, uint256 _value);
96     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
97     
98 
99 
100     /**
101         @dev constructor
102 
103         @param _name        token name
104         @param _symbol      token symbol
105         @param _decimals    decimal points, for display purposes
106     */
107     function StandardERC20Token(string _name, string _symbol, uint8 _decimals) public{
108         require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
109 
110         name = _name;
111         symbol = _symbol;
112         decimals = _decimals;
113     }
114 
115      function balanceOf(address _owner) constant returns (uint256) {
116         return balanceOf[_owner];
117     }
118     function allowance(address _owner, address _spender) constant returns (uint256) {
119         return allowance[_owner][_spender];
120     }
121     /**
122         @dev send coins
123         throws on any error rather then return a false flag to minimize user errors
124 
125         @param _to      target address
126         @param _value   transfer amount
127 
128         @return true if the transfer was successful, false if it wasn't
129     */
130     function transfer(address _to, uint256 _value)
131         public
132         validAddress(_to)
133         returns (bool success)
134     {
135         require(balanceOf[msg.sender] >= _value && _value > 0);
136         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
137         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
138         Transfer(msg.sender, _to, _value);
139         return true;
140     }
141 
142     /**
143         @dev an account/contract attempts to get the coins
144         throws on any error rather then return a false flag to minimize user errors
145 
146         @param _from    source address
147         @param _to      target address
148         @param _value   transfer amount
149 
150         @return true if the transfer was successful, false if it wasn't
151     */
152     function transferFrom(address _from, address _to, uint256 _value)
153         public
154         validAddress(_from)
155         validAddress(_to)
156         returns (bool success)
157     {
158         require(balanceOf[_from] >= _value && _value > 0);
159         require(allowance[_from][msg.sender] >= _value);
160         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
161         balanceOf[_from] = safeSub(balanceOf[_from], _value);
162         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
163         Transfer(_from, _to, _value);
164         return true;
165     }
166 
167     /**
168         @dev allow another account/contract to spend some tokens on your behalf
169         throws on any error rather then return a false flag to minimize user errors
170 
171         also, to minimize the risk of the approve/transferFrom attack vector
172         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
173         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
174 
175         @param _spender approved address
176         @param _value   allowance amount
177 
178         @return true if the approval was successful, false if it wasn't
179     */
180     function approve(address _spender, uint256 _value)
181         public
182         validAddress(_spender)
183         returns (bool success)
184     {
185         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
186         require(_value == 0 || allowance[msg.sender][_spender] == 0);
187 
188         allowance[msg.sender][_spender] = _value;
189         Approval(msg.sender, _spender, _value);
190         return true;
191     }
192 }
193 
194 /*
195     Owned contract interface
196 */
197 contract IOwned {
198     // this function isn't abstract since the compiler emits automatically generated getter functions as external
199     function owner() public constant returns (address) { owner; }
200 
201     function transferOwnership(address _newOwner) public;
202     function acceptOwnership() public;
203 }
204 
205 /*
206     Provides support and utilities for contract ownership
207 */
208 contract Owned is IOwned {
209     address public owner;
210     address public newOwner;
211 
212     event OwnerUpdate(address _prevOwner, address _newOwner);
213 
214     /**
215         @dev constructor
216     */
217     function Owned() public {
218         owner = msg.sender;
219     }
220 
221     // allows execution by the owner only
222     modifier ownerOnly {
223         assert(msg.sender == owner);
224         _;
225     }
226 
227     /**
228         @dev allows transferring the contract ownership
229         the new owner still needs to accept the transfer
230         can only be called by the contract owner
231 
232         @param _newOwner    new contract owner
233     */
234     function transferOwnership(address _newOwner) public ownerOnly {
235         require(_newOwner != owner);
236         newOwner = _newOwner;
237     }
238 
239     /**
240         @dev used by a new owner to accept an ownership transfer
241     */
242     function acceptOwnership() public {
243         require(msg.sender == newOwner);
244         OwnerUpdate(owner, newOwner);
245         owner = newOwner;
246         newOwner = 0x0;
247     }
248 }
249 
250 contract YooStop is Owned{
251 
252     bool public stopped = false;
253 
254     modifier stoppable {
255         assert (!stopped);
256         _;
257     }
258     function stop() public ownerOnly{
259         stopped = true;
260     }
261     function start() public ownerOnly{
262         stopped = false;
263     }
264 
265 }
266 
267 
268 contract YOOBAToken is StandardERC20Token, Owned,YooStop {
269 
270 
271 
272     uint256 constant public YOO_UNIT = 10 ** 18;
273     uint256 public totalSupply = 100 * (10**8) * YOO_UNIT;
274 
275     //  Constants 
276     uint256 constant public airdropSupply = 20 * 10**8 * YOO_UNIT;           
277     uint256 constant public earlyInvestorSupply = 5 * 10**8 * YOO_UNIT;    
278     uint256 constant public earlyCommunitySupply = 5 * 10**8 * YOO_UNIT;  
279     uint256 constant public icoReservedSupply = 40 * 10**8 * YOO_UNIT;          // ico Reserved,not for other usages.
280     uint256 constant public teamSupply = 12 * 10**8 * YOO_UNIT;         // Team,Community,Research，etc.
281     uint256 constant public ecosystemSupply = 18 * 10**8 * YOO_UNIT;         // Community,Research，Infrastructure，etc.
282     
283     uint256  public tokensReleasedToIco = 0;  //the tokens has released for ico.
284     uint256  public tokensReleasedToEarlyInvestor = 0;  //the tokens has released for early investor.
285     uint256  public tokensReleasedToTeam = 0;  //the tokens has released to team.
286     uint256  public tokensReleasedToEcosystem = 0;  //the tokens has released to ecosystem.
287     uint256  public currentSupply = 0;  //all tokens released currently.
288 
289     
290     
291     address public airdropAddress;                                           
292     address public yoobaTeamAddress;     
293     address public earlyCommunityAddress;
294     address public ecosystemAddress;// use for community,Research，Infrastructure，etc.
295     address public backupAddress;
296 
297 
298     
299     
300     uint256 internal createTime = 1522261875;                                // will be replace by (UTC) contract create time (in seconds)
301     uint256 internal teamTranchesReleased = 0;                          // Track how many tranches (allocations of 6.25% teamSupply tokens) have been released，about 4 years,teamSupply tokens will be allocate to team.
302     uint256 internal ecosystemTranchesReleased = 0;                          // Track how many tranches (allocations of 6.25% ecosystemSupply tokens) have been released.About 4 years,that will be release all. 
303     uint256 internal maxTranches = 16;       
304     bool internal isInitAirdropAndEarlyAlloc = false;
305 
306 
307     /**
308         @dev constructor
309         
310     */
311     function YOOBAToken(address _airdropAddress, address _ecosystemAddress, address _backupAddress, address _yoobaTeamAddress,address _earlyCommunityAddress)
312     StandardERC20Token("Yooba token", "YOO", 18) public
313      {
314         airdropAddress = _airdropAddress;
315         yoobaTeamAddress = _yoobaTeamAddress;
316         ecosystemAddress = _ecosystemAddress;
317         backupAddress = _backupAddress;
318         earlyCommunityAddress = _earlyCommunityAddress;
319         createTime = now;
320     }
321     
322     
323     /**
324         @dev 
325         the tokens at the airdropAddress will be airdroped before 2018.12.31
326     */
327      function initAirdropAndEarlyAlloc()   public ownerOnly stoppable returns(bool success){
328          require(!isInitAirdropAndEarlyAlloc);
329          require(airdropAddress != 0x0 && earlyCommunityAddress != 0x0);
330          require((currentSupply + earlyCommunitySupply + airdropSupply) <= totalSupply);
331          balanceOf[earlyCommunityAddress] += earlyCommunitySupply; 
332          currentSupply += earlyCommunitySupply;
333          Transfer(0x0, earlyCommunityAddress, earlyCommunitySupply);
334         balanceOf[airdropAddress] += airdropSupply;       
335         currentSupply += airdropSupply;
336         Transfer(0x0, airdropAddress, airdropSupply);
337         isInitAirdropAndEarlyAlloc = true;
338         return true;
339      }
340     
341 
342 
343     /**
344         @dev send tokens
345         throws on any error rather then return a false flag to minimize user errors
346         in addition to the standard checks, the function throws if transfers are disabled
347 
348         @param _to      target address
349         @param _value   transfer amount
350 
351         @return true if the transfer was successful, throws if it wasn't
352     */
353     function transfer(address _to, uint256 _value) public stoppable returns (bool success) {
354         return super.transfer(_to, _value);
355     }
356 
357     /**
358         @dev 
359         throws on any error rather then return a false flag to minimize user errors
360         in addition to the standard checks, the function throws if transfers are disabled
361 
362         @param _from    source address
363         @param _to      target address
364         @param _value   transfer amount
365 
366         @return true if the transfer was successful, throws if it wasn't
367     */
368     function transferFrom(address _from, address _to, uint256 _value) public stoppable returns (bool success) {
369             return super.transferFrom(_from, _to, _value);
370     }
371 
372 
373     /**
374         @dev Release one  tranche of the ecosystemSupply allocation to Yooba team,6.25% every tranche.About 4 years ecosystemSupply release over.
375        
376         @return true if successful, throws if not
377     */
378     function releaseForEcosystem()   public ownerOnly stoppable returns(bool success) {
379         require(now >= createTime + 12 weeks);
380         require(tokensReleasedToEcosystem < ecosystemSupply);
381 
382         uint256 temp = ecosystemSupply / 10000;
383         uint256 allocAmount = safeMul(temp, 625);
384         uint256 currentTranche = uint256(now - createTime) /  12 weeks;
385 
386         if(ecosystemTranchesReleased < maxTranches && currentTranche > ecosystemTranchesReleased && (currentSupply + allocAmount) <= totalSupply) {
387             ecosystemTranchesReleased++;
388             balanceOf[ecosystemAddress] = safeAdd(balanceOf[ecosystemAddress], allocAmount);
389             currentSupply += allocAmount;
390             tokensReleasedToEcosystem = safeAdd(tokensReleasedToEcosystem, allocAmount);
391             Transfer(0x0, ecosystemAddress, allocAmount);
392             return true;
393         }
394         revert();
395     }
396     
397        /**
398         @dev Release one  tranche of the teamSupply allocation to Yooba team,6.25% every tranche.About 4 years Yooba team will get teamSupply Tokens.
399        
400         @return true if successful, throws if not
401     */
402     function releaseForYoobaTeam()   public ownerOnly stoppable returns(bool success) {
403         require(now >= createTime + 12 weeks);
404         require(tokensReleasedToTeam < teamSupply);
405 
406         uint256 temp = teamSupply / 10000;
407         uint256 allocAmount = safeMul(temp, 625);
408         uint256 currentTranche = uint256(now - createTime) / 12 weeks;
409 
410         if(teamTranchesReleased < maxTranches && currentTranche > teamTranchesReleased && (currentSupply + allocAmount) <= totalSupply) {
411             teamTranchesReleased++;
412             balanceOf[yoobaTeamAddress] = safeAdd(balanceOf[yoobaTeamAddress], allocAmount);
413             currentSupply += allocAmount;
414             tokensReleasedToTeam = safeAdd(tokensReleasedToTeam, allocAmount);
415             Transfer(0x0, yoobaTeamAddress, allocAmount);
416             return true;
417         }
418         revert();
419     }
420 
421   
422     
423         /**
424         @dev release ico Tokens 
425 
426         @return true if successful, throws if not
427     */
428     function releaseForIco(address _icoAddress, uint256 _value) public  ownerOnly stoppable returns(bool success) {
429           require(_icoAddress != address(0x0) && _value > 0  && (tokensReleasedToIco + _value) <= icoReservedSupply && (currentSupply + _value) <= totalSupply);
430           balanceOf[_icoAddress] = safeAdd(balanceOf[_icoAddress], _value);
431           currentSupply += _value;
432           tokensReleasedToIco += _value;
433           Transfer(0x0, _icoAddress, _value);
434          return true;
435     }
436 
437         /**
438         @dev release  earlyInvestor Tokens 
439 
440         @return true if successful, throws if not
441     */
442     function releaseForEarlyInvestor(address _investorAddress, uint256 _value) public  ownerOnly  stoppable  returns(bool success) {
443           require(_investorAddress != address(0x0) && _value > 0  && (tokensReleasedToEarlyInvestor + _value) <= earlyInvestorSupply && (currentSupply + _value) <= totalSupply);
444           balanceOf[_investorAddress] = safeAdd(balanceOf[_investorAddress], _value);
445           currentSupply += _value;
446           tokensReleasedToEarlyInvestor += _value;
447           Transfer(0x0, _investorAddress, _value);
448          return true;
449     }
450     /**
451      @dev  This only run for urgent situation.Or Yooba mainnet is run well and all tokens release over. 
452 
453         @return true if successful, throws if not
454     */
455     function processWhenStop() public  ownerOnly   returns(bool success) {
456         require(currentSupply <=  totalSupply && stopped);
457         balanceOf[backupAddress] += (totalSupply - currentSupply);
458         currentSupply = totalSupply;
459        Transfer(0x0, backupAddress, (totalSupply - currentSupply));
460         return true;
461     }
462     
463 
464 }