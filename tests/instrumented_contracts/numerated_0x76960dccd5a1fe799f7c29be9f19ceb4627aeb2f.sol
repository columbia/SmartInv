1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 /**
38  * @title Ownable
39  * @dev The Ownable contract has an owner address, and provides basic authorization control
40  * functions, this simplifies the implementation of "user permissions".
41  */
42 contract Ownable {
43   address public owner;
44 
45 
46   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48 
49   /**
50    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51    * account.
52    */
53   function Ownable() public {
54     owner = msg.sender;
55   }
56 
57 
58   /**
59    * @dev Throws if called by any account other than the owner.
60    */
61   modifier onlyOwner() {
62     require(msg.sender == owner);
63     _;
64   }
65 
66 
67   /**
68    * @dev Allows the current owner to transfer control of the contract to a newOwner.
69    * @param newOwner The address to transfer ownership to.
70    */
71   function transferOwnership(address newOwner) public onlyOwner {
72     require(newOwner != address(0));
73     OwnershipTransferred(owner, newOwner);
74     owner = newOwner;
75   }
76 
77 }
78 
79 /**
80  * @title ERC20Basic
81  * @dev Simpler version of ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/179
83  */
84 contract ERC20Basic {
85   uint256 public totalSupply;
86   function balanceOf(address who) public view returns (uint256);
87   function transfer(address to, uint256 value) public returns (bool);
88   event Transfer(address indexed from, address indexed to, uint256 value);
89 }
90 
91 /**
92  * @title ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/20
94  */
95 contract ERC20 is ERC20Basic {
96   function allowance(address owner, address spender) public view returns (uint256);
97   function transferFrom(address from, address to, uint256 value) public returns (bool);
98   function approve(address spender, uint256 value) public returns (bool);
99   event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 
103 contract REDToken is ERC20, Ownable {
104 
105     using SafeMath for uint;
106 
107 /*----------------- Token Information -----------------*/
108 
109     string public constant name = "Red Community Token";
110     string public constant symbol = "RED";
111 
112     uint8 public decimals = 18;                            // (ERC20 API) Decimal precision, factor is 1e18
113 
114     mapping (address => uint256) angels;                   // Angels accounts table (during locking period only)
115     mapping (address => uint256) accounts;                 // User's accounts table
116     mapping (address => mapping (address => uint256)) allowed; // User's allowances table
117 
118 /*----------------- ICO Information -----------------*/
119 
120     uint256 public angelSupply;                            // Angels sale supply
121     uint256 public earlyBirdsSupply;                       // Early birds supply
122     uint256 public publicSupply;                           // Open round supply
123     uint256 public foundationSupply;                       // Red Foundation/Community supply
124     uint256 public redTeamSupply;                          // Red team supply
125     uint256 public marketingSupply;                        // Marketing & strategic supply
126 
127     uint256 public angelAmountRemaining;                   // Amount of private angels tokens remaining at a given time
128     uint256 public icoStartsAt;                            // Crowdsale ending timestamp
129     uint256 public icoEndsAt;                              // Crowdsale ending timestamp
130     uint256 public redTeamLockingPeriod;                   // Locking period for Red team's supply
131     uint256 public angelLockingPeriod;                     // Locking period for Angel's supply
132 
133     address public crowdfundAddress;                       // Crowdfunding contract address
134     address public redTeamAddress;                         // Red team address
135     address public foundationAddress;                      // Foundation address
136     address public marketingAddress;                       // Private equity address
137 
138     bool public unlock20Done = false;                      // Allows the 20% unlocking for angels only once
139 
140     enum icoStages {
141         Ready,                                             // Initial state on contract's creation
142         EarlyBirds,                                        // Early birds state
143         PublicSale,                                        // Public crowdsale state
144         Done                                               // Ending state after ICO
145     }
146     icoStages stage;                                       // Crowdfunding current state
147 
148 /*----------------- Events -----------------*/
149 
150     event EarlyBirdsFinalized(uint tokensRemaining);       // Event called when early birds round is done
151     event CrowdfundFinalized(uint tokensRemaining);        // Event called when crowdfund is done
152 
153 /*----------------- Modifiers -----------------*/
154 
155     modifier nonZeroAddress(address _to) {                 // Ensures an address is provided
156         require(_to != 0x0);
157         _;
158     }
159 
160     modifier nonZeroAmount(uint _amount) {                 // Ensures a non-zero amount
161         require(_amount > 0);
162         _;
163     }
164 
165     modifier nonZeroValue() {                              // Ensures a non-zero value is passed
166         require(msg.value > 0);
167         _;
168     }
169 
170     modifier onlyDuringCrowdfund(){                   // Ensures actions can only happen after crowdfund ends
171         require((now >= icoStartsAt) && (now < icoEndsAt));
172         _;
173     }
174 
175     modifier notBeforeCrowdfundEnds(){                     // Ensures actions can only happen after crowdfund ends
176         require(now >= icoEndsAt);
177         _;
178     }
179 
180     modifier checkRedTeamLockingPeriod() {                 // Ensures locking period is over
181         require(now >= redTeamLockingPeriod);
182         _;
183     }
184 
185     modifier checkAngelsLockingPeriod() {                  // Ensures locking period is over
186         require(now >= angelLockingPeriod);
187         _;
188     }
189 
190     modifier onlyCrowdfund() {                             // Ensures only crowdfund can call the function
191         require(msg.sender == crowdfundAddress);
192         _;
193     }
194 
195 /*----------------- ERC20 API -----------------*/
196 
197     // -------------------------------------------------
198     // Transfers amount to address
199     // -------------------------------------------------
200     function transfer(address _to, uint256 _amount) public notBeforeCrowdfundEnds returns (bool success) {
201         require(accounts[msg.sender] >= _amount);         // check amount of balance can be tranfered
202         addToBalance(_to, _amount);
203         decrementBalance(msg.sender, _amount);
204         Transfer(msg.sender, _to, _amount);
205         return true;
206     }
207 
208     // -------------------------------------------------
209     // Transfers from one address to another (need allowance to be called first)
210     // -------------------------------------------------
211     function transferFrom(address _from, address _to, uint256 _amount) public notBeforeCrowdfundEnds returns (bool success) {
212         require(allowance(_from, msg.sender) >= _amount);
213         decrementBalance(_from, _amount);
214         addToBalance(_to, _amount);
215         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
216         Transfer(_from, _to, _amount);
217         return true;
218     }
219 
220     // -------------------------------------------------
221     // Approves another address a certain amount of RED
222     // -------------------------------------------------
223     function approve(address _spender, uint256 _value) public returns (bool success) {
224         require((_value == 0) || (allowance(msg.sender, _spender) == 0));
225         allowed[msg.sender][_spender] = _value;
226         Approval(msg.sender, _spender, _value);
227         return true;
228     }
229 
230     // -------------------------------------------------
231     // Gets an address's RED allowance
232     // -------------------------------------------------
233     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
234         return allowed[_owner][_spender];
235     }
236 
237     // -------------------------------------------------
238     // Gets the RED balance of any address
239     // -------------------------------------------------
240     function balanceOf(address _owner) public constant returns (uint256 balance) {
241         return accounts[_owner] + angels[_owner];
242     }
243 
244 
245 /*----------------- Token API -----------------*/
246 
247     // -------------------------------------------------
248     // Contract's constructor
249     // -------------------------------------------------
250     function REDToken() public {
251         totalSupply         = 200000000 * 1e18;             // 100% - 200 million total RED with 18 decimals
252 
253         angelSupply         =  20000000 * 1e18;             //  10% -  20 million RED for private angels sale
254         earlyBirdsSupply    =  48000000 * 1e18;             //  24% -  48 million RED for early-bird sale
255         publicSupply        =  12000000 * 1e18;             //   6% -  12 million RED for the public crowdsale
256         redTeamSupply       =  30000000 * 1e18;             //  15% -  30 million RED for Red team
257         foundationSupply    =  70000000 * 1e18;             //  35% -  70 million RED for foundation/incentivising efforts
258         marketingSupply     =  20000000 * 1e18;             //  10% -  20 million RED for covering marketing and strategic expenses
259 
260         angelAmountRemaining = angelSupply;                 // Decreased over the course of the private angel sale
261         redTeamAddress       = 0x31aa507c140E012d0DcAf041d482e04F36323B03;       // Red Team address
262         foundationAddress    = 0x93e3AF42939C163Ee4146F63646Fb4C286CDbFeC;       // Foundation/Community address
263         marketingAddress     = 0x0;                         // Marketing/Strategic address
264 
265         icoStartsAt          = 1515398400;                  // Jan 8th 2018, 16:00, GMT+8
266         icoEndsAt            = 1517385600;                  // Jan 31th 2018, 16:00, GMT+8
267         angelLockingPeriod   = icoEndsAt.add(90 days);      //  3 months locking period
268         redTeamLockingPeriod = icoEndsAt.add(365 days);     // 12 months locking period
269 
270         addToBalance(foundationAddress, foundationSupply);
271 
272         stage = icoStages.Ready;                            // Initializes state
273     }
274 
275     // -------------------------------------------------
276     // Opens early birds sale
277     // -------------------------------------------------
278     function startCrowdfund() external onlyCrowdfund onlyDuringCrowdfund returns(bool) {
279         require(stage == icoStages.Ready);
280         stage = icoStages.EarlyBirds;
281         addToBalance(crowdfundAddress, earlyBirdsSupply);
282         return true;
283     }
284 
285     // -------------------------------------------------
286     // Returns TRUE if early birds round is currently going on
287     // -------------------------------------------------
288     function isEarlyBirdsStage() external view returns(bool) {
289         return (stage == icoStages.EarlyBirds);
290     }
291 
292     // -------------------------------------------------
293     // Sets the crowdfund address, can only be done once
294     // -------------------------------------------------
295     function setCrowdfundAddress(address _crowdfundAddress) external onlyOwner nonZeroAddress(_crowdfundAddress) {
296         require(crowdfundAddress == 0x0);
297         crowdfundAddress = _crowdfundAddress;
298     }
299 
300     // -------------------------------------------------
301     // Function for the Crowdfund to transfer tokens
302     // -------------------------------------------------
303     function transferFromCrowdfund(address _to, uint256 _amount) external onlyCrowdfund nonZeroAmount(_amount) nonZeroAddress(_to) returns (bool success) {
304         require(balanceOf(crowdfundAddress) >= _amount);
305         decrementBalance(crowdfundAddress, _amount);
306         addToBalance(_to, _amount);
307         Transfer(0x0, _to, _amount);
308         return true;
309     }
310 
311     // -------------------------------------------------
312     // Releases Red team supply after locking period is passed
313     // -------------------------------------------------
314     function releaseRedTeamTokens() external checkRedTeamLockingPeriod onlyOwner returns(bool success) {
315         require(redTeamSupply > 0);
316         addToBalance(redTeamAddress, redTeamSupply);
317         Transfer(0x0, redTeamAddress, redTeamSupply);
318         redTeamSupply = 0;
319         return true;
320     }
321 
322     // -------------------------------------------------
323     // Releases Marketing & strategic supply
324     // -------------------------------------------------
325     function releaseMarketingTokens() external onlyOwner returns(bool success) {
326         require(marketingSupply > 0);
327         addToBalance(marketingAddress, marketingSupply);
328         Transfer(0x0, marketingAddress, marketingSupply);
329         marketingSupply = 0;
330         return true;
331     }
332 
333     // -------------------------------------------------
334     // Finalizes early birds round. If some RED are left, let them overflow to the crowdfund
335     // -------------------------------------------------
336     function finalizeEarlyBirds() external onlyOwner returns (bool success) {
337         require(stage == icoStages.EarlyBirds);
338         uint256 amount = balanceOf(crowdfundAddress);
339         addToBalance(crowdfundAddress, publicSupply);
340         stage = icoStages.PublicSale;
341         EarlyBirdsFinalized(amount);                       // event log
342         return true;
343     }
344 
345     // -------------------------------------------------
346     // Finalizes crowdfund. If there are leftover RED, let them overflow to foundation
347     // -------------------------------------------------
348     function finalizeCrowdfund() external onlyCrowdfund {
349         require(stage == icoStages.PublicSale);
350         uint256 amount = balanceOf(crowdfundAddress);
351         if (amount > 0) {
352             accounts[crowdfundAddress] = 0;
353             addToBalance(foundationAddress, amount);
354             Transfer(crowdfundAddress, foundationAddress, amount);
355         }
356         stage = icoStages.Done;
357         CrowdfundFinalized(amount);                        // event log
358     }
359 
360     // -------------------------------------------------
361     // Changes Red Team wallet
362     // -------------------------------------------------
363     function changeRedTeamAddress(address _wallet) external onlyOwner {
364         redTeamAddress = _wallet;
365     }
366 
367     // -------------------------------------------------
368     // Changes Marketing&Strategic wallet
369     // -------------------------------------------------
370     function changeMarketingAddress(address _wallet) external onlyOwner {
371         marketingAddress = _wallet;
372     }
373 
374     // -------------------------------------------------
375     // Function to unlock 20% RED to private angels investors
376     // -------------------------------------------------
377     function partialUnlockAngelsAccounts(address[] _batchOfAddresses) external onlyOwner notBeforeCrowdfundEnds returns (bool success) {
378         require(unlock20Done == false);
379         uint256 amount;
380         address holder;
381         for (uint256 i = 0; i < _batchOfAddresses.length; i++) {
382             holder = _batchOfAddresses[i];
383             amount = angels[holder].mul(20).div(100);
384             angels[holder] = angels[holder].sub(amount);
385             addToBalance(holder, amount);
386         }
387         unlock20Done = true;
388         return true;
389     }
390 
391     // -------------------------------------------------
392     // Function to unlock all remaining RED to private angels investors (after 3 months)
393     // -------------------------------------------------
394     function fullUnlockAngelsAccounts(address[] _batchOfAddresses) external onlyOwner checkAngelsLockingPeriod returns (bool success) {
395         uint256 amount;
396         address holder;
397         for (uint256 i = 0; i < _batchOfAddresses.length; i++) {
398             holder = _batchOfAddresses[i];
399             amount = angels[holder];
400             angels[holder] = 0;
401             addToBalance(holder, amount);
402         }
403         return true;
404     }
405 
406     // -------------------------------------------------
407     // Function to reserve RED to private angels investors (initially locked)
408     // the amount of RED is in Wei
409     // -------------------------------------------------
410     function deliverAngelsREDAccounts(address[] _batchOfAddresses, uint[] _amountOfRED) external onlyOwner onlyDuringCrowdfund returns (bool success) {
411         for (uint256 i = 0; i < _batchOfAddresses.length; i++) {
412             deliverAngelsREDBalance(_batchOfAddresses[i], _amountOfRED[i]);
413         }
414         return true;
415     }
416 /*----------------- Helper functions -----------------*/
417     // -------------------------------------------------
418     // If one address has contributed more than once,
419     // the contributions will be aggregated
420     // -------------------------------------------------
421     function deliverAngelsREDBalance(address _accountHolder, uint _amountOfBoughtRED) internal onlyOwner {
422         require(angelAmountRemaining > 0);
423         angels[_accountHolder] = angels[_accountHolder].add(_amountOfBoughtRED);
424         Transfer(0x0, _accountHolder, _amountOfBoughtRED);
425         angelAmountRemaining = angelAmountRemaining.sub(_amountOfBoughtRED);
426     }
427 
428     // -------------------------------------------------
429     // Adds to balance
430     // -------------------------------------------------
431     function addToBalance(address _address, uint _amount) internal {
432         accounts[_address] = accounts[_address].add(_amount);
433     }
434 
435     // -------------------------------------------------
436     // Removes from balance
437     // -------------------------------------------------
438     function decrementBalance(address _address, uint _amount) internal {
439         accounts[_address] = accounts[_address].sub(_amount);
440     }
441 }