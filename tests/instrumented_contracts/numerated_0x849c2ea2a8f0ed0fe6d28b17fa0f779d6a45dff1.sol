1 library SafeMath {
2   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
3     uint256 c = a * b;
4     assert(a == 0 || c / a == b);
5     return c;
6   }
7 
8   function div(uint256 a, uint256 b) internal constant returns (uint256) {
9     // assert(b > 0); // Solidity automatically throws when dividing by 0
10     uint256 c = a / b;
11     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal constant returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 
28 contract ERC20Basic {
29   uint256 public totalSupply;
30   function balanceOf(address who) public constant returns (uint256);
31   function transfer(address to, uint256 value) public returns (bool);
32   event Transfer(address indexed from, address indexed to, uint256 value);
33 }
34 
35 
36 contract ERC20 is ERC20Basic {
37   function allowance(address owner, address spender) public constant returns (uint256);
38   function transferFrom(address from, address to, uint256 value) public returns (bool);
39   function approve(address spender, uint256 value) public returns (bool);
40   event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 
44 contract BasicToken is ERC20Basic {
45   using SafeMath for uint256;
46 
47   mapping(address => uint256) balances;
48 
49   function transfer(address _to, uint256 _value) public returns (bool) {
50     require(_to != address(0));
51 
52     balances[msg.sender] = balances[msg.sender].sub(_value);
53     balances[_to] = balances[_to].add(_value);
54     Transfer(msg.sender, _to, _value);
55     return true;
56   }
57 
58   function balanceOf(address _owner) public constant returns (uint256 balance) {
59     return balances[_owner];
60   }
61 }
62 
63 
64 contract StandardToken is ERC20, BasicToken {
65 
66   mapping (address => mapping (address => uint256)) allowed;
67 
68   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
69     require(_to != address(0));
70 
71     uint256 _allowance = allowed[_from][msg.sender];
72 
73     balances[_from] = balances[_from].sub(_value);
74     balances[_to] = balances[_to].add(_value);
75     allowed[_from][msg.sender] = _allowance.sub(_value);
76     Transfer(_from, _to, _value);
77     return true;
78   }
79 
80   function approve(address _spender, uint256 _value) public returns (bool) {
81     allowed[msg.sender][_spender] = _value;
82     Approval(msg.sender, _spender, _value);
83     return true;
84   }
85 
86   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
87     return allowed[_owner][_spender];
88   }
89 
90   function increaseApproval (address _spender, uint _addedValue)
91     returns (bool success) {
92     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
93     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
94     return true;
95   }
96 
97   function decreaseApproval (address _spender, uint _subtractedValue)
98     returns (bool success) {
99     uint oldValue = allowed[msg.sender][_spender];
100     if (_subtractedValue > oldValue) {
101       allowed[msg.sender][_spender] = 0;
102     } else {
103       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
104     }
105     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
106     return true;
107   }
108 
109 }
110 
111 contract Certifier {
112     event Confirmed(address indexed who);
113     event Revoked(address indexed who);
114     function certified(address) public constant returns (bool);
115     function get(address, string) public constant returns (bytes32);
116     function getAddress(address, string) public constant returns (address);
117     function getUint(address, string) public constant returns (uint);
118 }
119 
120 contract EDUToken is StandardToken {
121 
122     using SafeMath for uint256;
123 
124     Certifier public certifier;
125 
126     // EVENTS
127     event CreatedEDU(address indexed _creator, uint256 _amountOfEDU);
128     event Transfer(address indexed _from, address indexed _to, uint _value);
129     event Approval(address indexed _owner, address indexed _spender, uint _value);
130 
131     // GENERAL INFORMATION ABOUT THE TOKEN
132     string public constant name = "EDU Token";
133     string public constant symbol = "EDU";
134     uint256 public constant decimals = 4;
135     string public version = "1.0";
136 
137     // CONSTANTS
138     // Purchase limits
139     uint256 public constant TotalEDUSupply = 48000000*10000;                    // MAX TOTAL EDU TOKENS 48 million
140     uint256 public constant maxEarlyPresaleEDUSupply = 2601600*10000;           // Maximum EDU tokens early presale supply (Presale Stage 1)
141     uint256 public constant maxPresaleEDUSupply = 2198400*10000;                // Maximum EDU tokens presale supply (Presale Stage 2)
142     uint256 public constant OSUniEDUSupply = 8400000*10000;                     // Open Source University EDU tokens supply
143     uint256 public constant SaleEDUSupply = 30000000*10000;                     // Allocated EDU tokens for crowdsale
144     uint256 public constant sigTeamAndAdvisersEDUSupply = 3840000*10000;        // EDU tokens supply allocated for team and advisers
145     uint256 public constant sigBountyProgramEDUSupply = 960000*10000;           // EDU tokens supply allocated for bounty program
146 
147     //ASSIGNED IN INITIALIZATION
148     // Time limits
149     uint256 public preSaleStartTime;                                            // Start presale time
150     uint256 public preSaleEndTime;                                              // End presale time
151     uint256 public saleStartTime;                                               // Start sale time (start crowdsale)
152     uint256 public saleEndTime;                                                 // End crowdsale
153 
154     // Purchase limits
155     uint256 public earlyPresaleEDUSupply;
156     uint256 public PresaleEDUSupply;
157 
158     // Refund in EDU tokens because of the KYC procedure
159     uint256 public EDU_KYC_BONUS = 50*10000;                                    // Bonus 50 EDU tokens for the KYC procedure
160 
161     // Lock EDU tokens
162     uint256 public LockEDUTeam;                                                 // Lock EDU tokens relocated for the team
163 
164     // Token bonuses
165     uint256 public EDU_PER_ETH_EARLY_PRE_SALE = 1350;                           // 1350 EDU = 1 ETH  presale stage 1  until the quantities are exhausted
166     uint256 public EDU_PER_ETH_PRE_SALE = 1200;                                 // 1200 EDU = 1 ETH  presale stage 2
167 
168     // Token sale
169     uint256 public EDU_PER_ETH_SALE;                                            // Crowdsale price which will be anaunced after the alpha version of the OSUni platform
170 
171     // Addresses
172     address public ownerAddress;                                                // Address used by Open Source University
173     address public presaleAddress;                                              // Address used in the presale period
174     address public saleAddress;                                                 // Address used in the crowdsale period
175     address public sigTeamAndAdvisersAddress;                                   // EDU tokens for the team and advisers
176     address public sigBountyProgramAddress;                                     // EDU tokens bounty program
177     address public contributionsAddress;                                        // Address used for contributions
178 
179     // Contribution indicator
180     bool public allowContribution = true;                                       // Flag to change if transfering is allowed
181 
182     // Running totals
183     uint256 public totalWEIInvested = 0;                                        // Total WEI invested
184     uint256 public totalEDUSLeft = 0;                                           // Total EDU left
185     uint256 public totalEDUSAllocated = 0;                                      // Total EDU allocated
186     mapping (address => uint256) public WEIContributed;                         // Total WEI Per Account
187 
188     // Owner of account approves the transfer of an amount to another account
189     mapping(address => mapping (address => uint256)) allowed;
190 
191     // Functions with this modifier can only be executed by the owner of following smart contract
192     modifier onlyOwner() {
193         if (msg.sender != ownerAddress) {
194             revert();
195         }
196         _;
197     }
198 
199     // Minimal contribution which will be processed is 0.5 ETH
200     modifier minimalContribution() {
201         require(500000000000000000 <= msg.value);
202         _;
203     }
204 
205     // Freeze all EDU token transfers during sale period
206     modifier freezeDuringEDUtokenSale() {
207         if ( (msg.sender == ownerAddress) ||
208              (msg.sender == contributionsAddress) ||
209              (msg.sender == presaleAddress) ||
210              (msg.sender == saleAddress) ||
211              (msg.sender == sigBountyProgramAddress) ) {
212             _;
213         } else {
214             if((block.timestamp > preSaleStartTime && block.timestamp < preSaleEndTime) || (block.timestamp > saleStartTime && block.timestamp < saleEndTime)) {
215                 revert();
216             } else {
217                 _;
218             }
219         }
220     }
221 
222     // Freeze EDU tokens for TeamAndAdvisers for 1 year after the end of the presale
223     modifier freezeTeamAndAdvisersEDUTokens(address _address) {
224         if (_address == sigTeamAndAdvisersAddress) {
225             if (LockEDUTeam > block.timestamp) { revert(); }
226         }
227         _;
228     }
229 
230     // INITIALIZATIONS FUNCTION
231     function EDUToken(
232         address _presaleAddress,
233         address _saleAddress,
234         address _sigTeamAndAdvisersAddress,
235         address _sigBountyProgramAddress,
236         address _contributionsAddress
237     ) {
238         certifier = Certifier(0x1e2F058C43ac8965938F6e9CA286685A3E63F24E);
239         ownerAddress = msg.sender;                                                               // Store owners address
240         presaleAddress = _presaleAddress;                                                        // Store presale address
241         saleAddress = _saleAddress;
242         sigTeamAndAdvisersAddress = _sigTeamAndAdvisersAddress;                                  // Store sale address
243         sigBountyProgramAddress = _sigBountyProgramAddress;
244         contributionsAddress = _contributionsAddress;
245 
246         preSaleStartTime = 1511179200;                                                           // Start of presale right after end of early presale period
247         preSaleEndTime = 1514764799;                                                             // End of the presale period 1 week after end of early presale
248         LockEDUTeam = preSaleEndTime + 1 years;                                                  // EDU tokens allocated for the team will be freezed for one year
249 
250         earlyPresaleEDUSupply = maxEarlyPresaleEDUSupply;                                        // MAX TOTAL DURING EARLY PRESALE (2 601 600 EDU Tokens)
251         PresaleEDUSupply = maxPresaleEDUSupply;                                                  // MAX TOTAL DURING PRESALE (2 198 400 EDU Tokens)
252 
253         balances[contributionsAddress] = OSUniEDUSupply;                                         // Allocating EDU tokens for Open Source University             // Allocating EDU tokens for early presale
254         balances[presaleAddress] = SafeMath.add(maxPresaleEDUSupply, maxEarlyPresaleEDUSupply);  // Allocating EDU tokens for presale
255         balances[saleAddress] = SaleEDUSupply;                                                   // Allocating EDU tokens for sale
256         balances[sigTeamAndAdvisersAddress] = sigTeamAndAdvisersEDUSupply;                       // Allocating EDU tokens for team and advisers
257         balances[sigBountyProgramAddress] = sigBountyProgramEDUSupply;                           // Bounty program address
258 
259 
260         totalEDUSAllocated = OSUniEDUSupply + sigTeamAndAdvisersEDUSupply + sigBountyProgramEDUSupply;
261         totalEDUSLeft = SafeMath.sub(TotalEDUSupply, totalEDUSAllocated);                        // EDU Tokens left for sale
262 
263         totalSupply = TotalEDUSupply;                                                            // Total EDU Token supply
264     }
265 
266     // FALL BACK FUNCTION TO ALLOW ETHER CONTRIBUTIONS
267     function()
268         payable
269         minimalContribution
270     {
271         require(allowContribution);
272 
273         // Only PICOPS certified addresses will be allowed to participate
274         if (!certifier.certified(msg.sender)) {
275             revert();
276         }
277 
278         // Transaction value in Wei
279         uint256 amountInWei = msg.value;
280 
281         // Initial amounts
282         uint256 amountOfEDU = 0;
283 
284         if (block.timestamp > preSaleStartTime && block.timestamp < preSaleEndTime) {
285             amountOfEDU = amountInWei.mul(EDU_PER_ETH_EARLY_PRE_SALE).div(100000000000000);
286             if(!(WEIContributed[msg.sender] > 0)) {
287                 amountOfEDU += EDU_KYC_BONUS;  // Bonus for KYC procedure
288             }
289             if (earlyPresaleEDUSupply > 0 && earlyPresaleEDUSupply >= amountOfEDU) {
290                 require(updateEDUBalanceFunc(presaleAddress, amountOfEDU));
291                 earlyPresaleEDUSupply = earlyPresaleEDUSupply.sub(amountOfEDU);
292             } else if (PresaleEDUSupply > 0) {
293                 if (earlyPresaleEDUSupply != 0) {
294                     PresaleEDUSupply = PresaleEDUSupply.add(earlyPresaleEDUSupply);
295                     earlyPresaleEDUSupply = 0;
296                 }
297                 amountOfEDU = amountInWei.mul(EDU_PER_ETH_PRE_SALE).div(100000000000000);
298                 if(!(WEIContributed[msg.sender] > 0)) {
299                     amountOfEDU += EDU_KYC_BONUS;
300                 }
301                 require(PresaleEDUSupply >= amountOfEDU);
302                 require(updateEDUBalanceFunc(presaleAddress, amountOfEDU));
303                 PresaleEDUSupply = PresaleEDUSupply.sub(amountOfEDU);
304             } else {
305                 revert();
306             }
307         } else if (block.timestamp > saleStartTime && block.timestamp < saleEndTime) {
308             // Sale period
309             amountOfEDU = amountInWei.mul(EDU_PER_ETH_SALE).div(100000000000000);
310             require(totalEDUSLeft >= amountOfEDU);
311             require(updateEDUBalanceFunc(saleAddress, amountOfEDU));
312         } else {
313             // Outside contribution period
314             revert();
315         }
316 
317         // Update total WEI Invested
318         totalWEIInvested = totalWEIInvested.add(amountInWei);
319         assert(totalWEIInvested > 0);
320         // Update total WEI Invested by account
321         uint256 contributedSafe = WEIContributed[msg.sender].add(amountInWei);
322         assert(contributedSafe > 0);
323         WEIContributed[msg.sender] = contributedSafe;
324 
325         // Transfer contributions to Open Source University
326         contributionsAddress.transfer(amountInWei);
327 
328         // CREATE EVENT FOR SENDER
329         CreatedEDU(msg.sender, amountOfEDU);
330     }
331 
332     /**
333      * @dev Function for updating the balance and double checks allocated EDU tokens
334      * @param _from The address that will send EDU tokens.
335      * @param _amountOfEDU The amount of tokens which will be send to contributor.
336      * @return A boolean that indicates if the operation was successful.
337      */
338     function updateEDUBalanceFunc(address _from, uint256 _amountOfEDU) internal returns (bool) {
339         // Update total EDU balance
340         totalEDUSLeft = totalEDUSLeft.sub(_amountOfEDU);
341         totalEDUSAllocated += _amountOfEDU;
342 
343         // Validate EDU allocation
344         if (totalEDUSAllocated <= TotalEDUSupply && totalEDUSAllocated > 0) {
345             // Update user EDU balance
346             uint256 balanceSafe = balances[msg.sender].add(_amountOfEDU);
347             assert(balanceSafe > 0);
348             balances[msg.sender] = balanceSafe;
349             uint256 balanceDiv = balances[_from].sub(_amountOfEDU);
350             balances[_from] = balanceDiv;
351             return true;
352         } else {
353             totalEDUSLeft = totalEDUSLeft.add(_amountOfEDU);
354             totalEDUSAllocated -= _amountOfEDU;
355             return false;
356         }
357     }
358 
359     /**
360      * @dev Set contribution flag status
361      * @param _allowContribution This is additional parmition for the contributers
362      * @return A boolean that indicates if the operation was successful.
363      */
364     function setAllowContributionFlag(bool _allowContribution) public returns (bool success) {
365         require(msg.sender == ownerAddress);
366         allowContribution = _allowContribution;
367         return true;
368     }
369 
370     /**
371      * @dev Set the sale period
372      * @param _saleStartTime Sets the starting time of the sale period
373      * @param _saleEndTime Sets the end time of the sale period
374      * @return A boolean that indicates if the operation was successful.
375      */
376     function setSaleTimes(uint256 _saleStartTime, uint256 _saleEndTime) public returns (bool success) {
377         require(msg.sender == ownerAddress);
378         saleStartTime = _saleStartTime;
379         saleEndTime = _saleEndTime;
380         return true;
381     }
382 
383     /**
384      * @dev Set change the presale period if necessary
385      * @param _preSaleStartTime Sets the starting time of the presale period
386      * @param _preSaleEndTime Sets the end time of the presale period
387      * @return A boolean that indicates if the operation was successful.
388      */
389     function setPresaleTime(uint256 _preSaleStartTime, uint256 _preSaleEndTime) public returns (bool success) {
390         require(msg.sender == ownerAddress);
391         preSaleStartTime = _preSaleStartTime;
392         preSaleEndTime = _preSaleEndTime;
393         return true;
394     }
395 
396     function setEDUPrice(
397         uint256 _valEarlyPresale,
398         uint256 _valPresale,
399         uint256 _valSale
400     ) public returns (bool success) {
401         require(msg.sender == ownerAddress);
402         EDU_PER_ETH_EARLY_PRE_SALE = _valEarlyPresale;
403         EDU_PER_ETH_PRE_SALE = _valPresale;
404         EDU_PER_ETH_SALE = _valSale;
405         return true;
406     }
407 
408     function updateCertifier(address _address) public returns (bool success) {
409         certifier = Certifier(_address);
410         return true;
411     }
412 
413     // Balance of a specific account
414     function balanceOf(address _owner) constant returns (uint256 balance) {
415         return balances[_owner];
416     }
417 
418     // Transfer the balance from owner's account to another account
419     function transfer(address _to, uint256 _amount) freezeDuringEDUtokenSale freezeTeamAndAdvisersEDUTokens(msg.sender) returns (bool success) {
420         if (balances[msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {
421             balances[msg.sender] -= _amount;
422             balances[_to] += _amount;
423             Transfer(msg.sender, _to, _amount);
424             return true;
425         } else {
426             return false;
427         }
428     }
429 
430     // Send _value amount of tokens from address _from to address _to
431     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
432     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
433     // fees in sub-currencies; the command should fail unless the _from account has
434     // deliberately authorized the sender of the message via some mechanism; we propose
435     // these standardized APIs for approval:
436     function transferFrom(address _from, address _to, uint256 _amount) freezeDuringEDUtokenSale freezeTeamAndAdvisersEDUTokens(_from) returns (bool success) {
437         if (balances[_from] >= _amount
438              && allowed[_from][msg.sender] >= _amount
439              && _amount > 0
440              && balances[_to] + _amount > balances[_to]) {
441             balances[_from] -= _amount;
442             allowed[_from][msg.sender] -= _amount;
443             balances[_to] += _amount;
444             Transfer(_from, _to, _amount);
445             return true;
446         } else {
447             return false;
448         }
449     }
450 
451     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
452     // If this function is called again it overwrites the current allowance with _value.
453     function approve(address _spender, uint256 _amount) freezeDuringEDUtokenSale freezeTeamAndAdvisersEDUTokens(msg.sender) returns (bool success) {
454         allowed[msg.sender][_spender] = _amount;
455         Approval(msg.sender, _spender, _amount);
456         return true;
457     }
458 
459     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
460         return allowed[_owner][_spender];
461     }
462 
463 }