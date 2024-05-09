1 pragma solidity ^0.4.2;
2 
3 contract Token {
4     /* Public variables of the token */
5     string public standard;
6     string public name;
7     string public symbol;
8     uint8 public decimals;
9     uint256 public _totalSupply;
10 
11     /* This creates an array with all balances */
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14 
15     /* ERC20 Events */
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Approval(address indexed from, address indexed spender, uint256 value);
18 
19     /* Initializes contract with initial supply tokens to the creator of the contract */
20     function Token(uint256 initialSupply, string _standard, string _name, string _symbol, uint8 _decimals) {
21         _totalSupply = initialSupply;
22         balanceOf[this] = initialSupply;
23         standard = _standard;
24         name = _name;
25         symbol = _symbol;
26         decimals = _decimals;
27     }
28 
29     /* Get burnable total supply */
30     function totalSupply() constant returns(uint256 supply) {
31         return _totalSupply;
32     }
33 
34     /**
35      * Transfer token logic
36      * @param _from The address to transfer from.
37      * @param _to The address to transfer to.
38      * @param _value The amount to be transferred.
39      */
40     function transferInternal(address _from, address _to, uint256 _value) internal returns (bool success) {
41         require(balanceOf[_from] >= _value);
42 
43         // Check for overflows
44         require(balanceOf[_to] + _value >= balanceOf[_to]);
45 
46         balanceOf[_from] -= _value;
47 
48         balanceOf[_to] += _value;
49 
50         Transfer(_from, _to, _value);
51 
52         return true;
53     }
54 
55     /**
56      * Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
57      * @param _spender The address which will spend the funds.
58      * @param _value The amount of tokens to be spent.
59      */
60     function approve(address _spender, uint256 _value) returns (bool success) {
61         allowance[msg.sender][_spender] = _value;
62 
63         return true;
64     }
65 
66     /**
67      * Transfer tokens from one address to another
68      * @param _from address The address which you want to send tokens from
69      * @param _to address The address which you want to transfer to
70      * @param _value uint256 the amout of tokens to be transfered
71      */
72     function transferFromInternal(address _from, address _to, uint256 _value) internal returns (bool success) {
73         require(_value >= allowance[_from][msg.sender]);   // Check allowance
74 
75         allowance[_from][msg.sender] -= _value;
76 
77         return transferInternal(_from, _to, _value);
78     }
79 }
80 
81 contract ICO {
82     uint256 public PRE_ICO_SINCE = 1500303600;                     // 07/17/2017 @ 15:00 (UTC)
83     uint256 public PRE_ICO_TILL = 1500476400;                      // 07/19/2017 @ 15:00 (UTC)
84     uint256 public constant PRE_ICO_BONUS_RATE = 70;
85     uint256 public constant PRE_ICO_SLGN_LESS = 5000 ether;                 // upper limit for pre ico is 5k ether
86 
87     uint256 public ICO_SINCE = 1500994800;                         // 07/25/2017 @ 9:00am (UTC)
88     uint256 public ICO_TILL = 1502809200;                          // 08/15/2017 @ 9:00am (UTC)
89     uint256 public constant ICO_BONUS1_SLGN_LESS = 20000 ether;                // bonus 1 will work only if 20000 eth were collected during first phase of ico
90     uint256 public constant ICO_BONUS1_RATE = 30;                           // bonus 1 rate
91     uint256 public constant ICO_BONUS2_SLGN_LESS = 50000 ether;                // bonus 1 will work only if 50000 eth were collected during second phase of ico
92     uint256 public constant ICO_BONUS2_RATE = 15; // bonus 2 rate
93 
94     uint256 public totalSoldSlogns;
95 
96     /* This generates a public event on the blockchain that will notify clients */
97     event BonusEarned(address target, uint256 bonus);
98 
99     /**
100      * Calculate amount of premium bonuses
101      * @param icoStep identifies is it pre-ico (equals 0) or ico (equals 1)
102      * @param totalSoldSlogns total amount of already sold slogn tokens.
103      * @param soldSlogns total amount sold slogns in current transaction.
104      */
105     function calculateBonus(uint8 icoStep, uint256 totalSoldSlogns, uint256 soldSlogns) returns (uint256) {
106         if(icoStep == 1) {
107             // pre ico
108             return soldSlogns / 100 * PRE_ICO_BONUS_RATE;
109         }
110         else if(icoStep == 2) {
111             // ico
112             if(totalSoldSlogns > ICO_BONUS1_SLGN_LESS + ICO_BONUS2_SLGN_LESS) {
113                 return 0;
114             }
115 
116             uint256 availableForBonus1 = ICO_BONUS1_SLGN_LESS - totalSoldSlogns;
117 
118             uint256 tmp = soldSlogns;
119             uint256 bonus = 0;
120 
121             uint256 tokensForBonus1 = 0;
122 
123             if(availableForBonus1 > 0 && availableForBonus1 <= ICO_BONUS1_SLGN_LESS) {
124                 tokensForBonus1 = tmp > availableForBonus1 ? availableForBonus1 : tmp;
125 
126                 bonus += tokensForBonus1 / 100 * ICO_BONUS1_RATE;
127                 tmp -= tokensForBonus1;
128             }
129 
130             uint256 availableForBonus2 = (ICO_BONUS2_SLGN_LESS + ICO_BONUS1_SLGN_LESS) - totalSoldSlogns - tokensForBonus1;
131 
132             uint256 tokensForBonus2 = 0;
133 
134             if(availableForBonus2 > 0 && availableForBonus2 <= ICO_BONUS2_SLGN_LESS) {
135                 tokensForBonus2 = tmp > availableForBonus2 ? availableForBonus2 : tmp;
136 
137                 bonus += tokensForBonus2 / 100 * ICO_BONUS2_RATE;
138                 tmp -= tokensForBonus2;
139             }
140 
141             return bonus;
142         }
143 
144         return 0;
145     }
146 }
147 
148 contract EscrowICO is Token, ICO {
149     uint256 public constant MIN_PRE_ICO_SLOGN_COLLECTED = 1000 ether;       // PRE ICO is successful only if sold 10.000.000 slogns
150     uint256 public constant MIN_ICO_SLOGN_COLLECTED = 1000 ether;          // ICO is successful only if sold 100.000.000 slogns
151 
152     bool public isTransactionsAllowed;
153 
154     uint256 public totalSoldSlogns;
155 
156     mapping (address => uint256) public preIcoEthers;
157     mapping (address => uint256) public icoEthers;
158 
159     event RefundEth(address indexed owner, uint256 value);
160     event IcoFinished();
161 
162     function EscrowICO() {
163         isTransactionsAllowed = false;
164     }
165 
166     function getIcoStep(uint256 time) returns (uint8 step) {
167         if(time >=  PRE_ICO_SINCE && time <= PRE_ICO_TILL) {
168             return 1;
169         }
170         else if(time >= ICO_SINCE && time <= ICO_TILL) {
171             // ico shoud fail if collected less than 1000 slogns during pre ico
172             if(totalSoldSlogns >= MIN_PRE_ICO_SLOGN_COLLECTED) {
173                 return 2;
174             }
175         }
176 
177         return 0;
178     }
179 
180     /**
181      * officially finish ICO, only allowed after ICO is ended
182      */
183     function icoFinishInternal(uint256 time) internal returns (bool) {
184         if(time <= ICO_TILL) {
185             return false;
186         }
187 
188         if(totalSoldSlogns >= MIN_ICO_SLOGN_COLLECTED) {
189             // burn tokens assigned to smart contract
190 
191             _totalSupply = _totalSupply - balanceOf[this];
192 
193             balanceOf[this] = 0;
194 
195             // allow transactions for everyone
196             isTransactionsAllowed = true;
197 
198             IcoFinished();
199 
200             return true;
201         }
202 
203         return false;
204     }
205 
206     /**
207      * refund ico method
208      */
209     function refundInternal(uint256 time) internal returns (bool) {
210         if(time <= PRE_ICO_TILL) {
211             return false;
212         }
213 
214         if(totalSoldSlogns >= MIN_PRE_ICO_SLOGN_COLLECTED) {
215             return false;
216         }
217 
218         uint256 transferedEthers;
219 
220         transferedEthers = preIcoEthers[msg.sender];
221 
222         if(transferedEthers > 0) {
223             preIcoEthers[msg.sender] = 0;
224 
225             balanceOf[msg.sender] = 0;
226 
227             msg.sender.transfer(transferedEthers);
228 
229             RefundEth(msg.sender, transferedEthers);
230 
231             return true;
232         }
233 
234         return false;
235     }
236 }
237 
238 contract SlognToken is Token, EscrowICO {
239     string public constant STANDARD = 'Slogn v0.1';
240     string public constant NAME = 'SLOGN';
241     string public constant SYMBOL = 'SLGN';
242     uint8 public constant PRECISION = 14;
243 
244     uint256 public constant TOTAL_SUPPLY = 800000 ether; // initial total supply equals to 8.000.000.000 slogns or 800.000 eths
245 
246     uint256 public constant CORE_TEAM_TOKENS = TOTAL_SUPPLY / 100 * 15;       // 15%
247     uint256 public constant ADVISORY_BOARD_TOKENS = TOTAL_SUPPLY / 1000 * 15;       // 1.5%
248     uint256 public constant OPENSOURCE_TOKENS = TOTAL_SUPPLY / 1000 * 75;     // 7.5%
249     uint256 public constant RESERVE_TOKENS = TOTAL_SUPPLY / 100 * 5;          // 5%
250     uint256 public constant BOUNTY_TOKENS = TOTAL_SUPPLY / 100;               // 1%
251 
252     address public advisoryBoardFundManager;
253     address public opensourceFundManager;
254     address public reserveFundManager;
255     address public bountyFundManager;
256     address public ethFundManager;
257     address public owner;
258 
259     /* This generates a public event on the blockchain that will notify clients */
260     event BonusEarned(address target, uint256 bonus);
261 
262     /* Modifiers */
263     modifier onlyOwner() {
264         require(owner == msg.sender);
265 
266         _;
267     }
268 
269     /* Initializes contract with initial supply tokens to the creator of the contract */
270     function SlognToken(
271     address [] coreTeam,
272     address _advisoryBoardFundManager,
273     address _opensourceFundManager,
274     address _reserveFundManager,
275     address _bountyFundManager,
276     address _ethFundManager
277     )
278     Token (TOTAL_SUPPLY, STANDARD, NAME, SYMBOL, PRECISION)
279     EscrowICO()
280     {
281         owner = msg.sender;
282 
283         advisoryBoardFundManager = _advisoryBoardFundManager;
284         opensourceFundManager = _opensourceFundManager;
285         reserveFundManager = _reserveFundManager;
286         bountyFundManager = _bountyFundManager;
287         ethFundManager = _ethFundManager;
288 
289         // transfer tokens to core team
290         uint256 tokensPerMember = CORE_TEAM_TOKENS / coreTeam.length;
291 
292         for(uint8 i = 0; i < coreTeam.length; i++) {
293             transferInternal(this, coreTeam[i], tokensPerMember);
294         }
295 
296         // Advisory board fund
297         transferInternal(this, advisoryBoardFundManager, ADVISORY_BOARD_TOKENS);
298 
299         // Opensource fund
300         transferInternal(this, opensourceFundManager, OPENSOURCE_TOKENS);
301 
302         // Reserve fund
303         transferInternal(this, reserveFundManager, RESERVE_TOKENS);
304 
305         // Bounty fund
306         transferInternal(this, bountyFundManager, BOUNTY_TOKENS);
307     }
308 
309     function buyFor(address _user, uint256 ethers, uint time) internal returns (bool success) {
310         require(ethers > 0);
311 
312         uint8 icoStep = getIcoStep(time);
313 
314         require(icoStep == 1 || icoStep == 2);
315 
316         // maximum collected amount for preico is 5000 ether
317         if(icoStep == 1 && (totalSoldSlogns + ethers) > 5000 ether) {
318             throw;
319         }
320 
321         uint256 slognAmount = ethers; // calculates the amount
322 
323         uint256 bonus = calculateBonus(icoStep, totalSoldSlogns, slognAmount);
324 
325         // check for available slogns
326         require(balanceOf[this] >= slognAmount + bonus);
327 
328         if(bonus > 0) {
329             BonusEarned(_user, bonus);
330         }
331 
332         transferInternal(this, _user, slognAmount + bonus);
333 
334         totalSoldSlogns += slognAmount;
335 
336         if(icoStep == 1) {
337             preIcoEthers[_user] += ethers;      // fill ethereum used for refund if goal not reached
338         }
339         if(icoStep == 2) {
340             icoEthers[_user] += ethers;      // fill ethereum used for refund if goal not reached
341         }
342 
343         return true;
344     }
345 
346     /**
347      * Buy Slogn tokens
348      */
349     function buy() payable {
350         buyFor(msg.sender, msg.value, block.timestamp);
351     }
352 
353     /**
354      * Manage ethereum balance
355      * @param to The address to transfer to.
356      * @param value The amount to be transferred.
357      */
358     function transferEther(address to, uint256 value) returns (bool success) {
359         if(msg.sender != ethFundManager) {
360             return false;
361         }
362 
363         if(totalSoldSlogns < MIN_PRE_ICO_SLOGN_COLLECTED) {
364             return false;
365         }
366 
367         if(this.balance < value) {
368             return false;
369         }
370 
371         to.transfer(value);
372 
373         return true;
374     }
375 
376     /**
377      * Transfer token for a specified address
378      * @param _to The address to transfer to.
379      * @param _value The amount to be transferred.
380      */
381     function transfer(address _to, uint256 _value) returns (bool success) {
382         if(isTransactionsAllowed == false) {
383             if(msg.sender != bountyFundManager) {
384                 return false;
385             }
386         }
387 
388         return transferInternal(msg.sender, _to, _value);
389     }
390 
391     /**
392      * Transfer tokens from one address to another
393      * @param _from address The address which you want to send tokens from
394      * @param _to address The address which you want to transfer to
395      * @param _value uint256 the amout of tokens to be transfered
396      */
397     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
398         if(isTransactionsAllowed == false) {
399             if(_from != bountyFundManager) {
400                 return false;
401             }
402         }
403 
404         return transferFromInternal(_from, _to, _value);
405     }
406 
407     function refund() returns (bool) {
408         return refundInternal(block.timestamp);
409     }
410 
411     function icoFinish() returns (bool) {
412         return icoFinishInternal(block.timestamp);
413     }
414 
415     function setPreIcoDates(uint256 since, uint256 till) onlyOwner {
416         PRE_ICO_SINCE = since;
417         PRE_ICO_TILL = till;
418     }
419 
420     function setIcoDates(uint256 since, uint256 till) onlyOwner {
421         ICO_SINCE = since;
422         ICO_TILL = till;
423     }
424 
425     function setTransactionsAllowed(bool enabled) onlyOwner {
426         isTransactionsAllowed = enabled;
427     }
428 
429     function () payable {
430         throw;
431     }
432 }