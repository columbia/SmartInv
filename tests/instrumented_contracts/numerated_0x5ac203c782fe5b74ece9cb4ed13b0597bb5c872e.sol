1 pragma solidity 0.5.8;
2 
3 //TODO: third party auditory
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Unsigned math operations with safety checks that revert on error.
9  */
10 library SafeMath {
11     /**
12      * @dev Returns the addition of two unsigned integers, reverting on
13      * overflow.
14      */
15     function add(uint256 a, uint256 b) internal pure returns(uint256) {
16         uint256 c = a + b;
17         require(c >= a, "SafeMath: addition overflow");
18         return c;
19     }
20 
21     /**
22      * @dev Returns the subtraction of two unsigned integers, reverting on
23      * overflow (when the result is negative).
24      */
25     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
26         require(b <= a, "SafeMath: subtraction overflow");
27         uint256 c = a - b;
28         return c;
29     }
30 
31     /**
32      * @dev Returns the multiplication of two unsigned integers, reverting on
33      * overflow.
34      */
35     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
36         if (a == 0) {
37             return 0;
38         }
39 
40         uint256 c = a * b;
41         require(c / a == b, "SafeMath: multiplication overflow");
42 
43         return c;
44     }
45 
46     /**
47      * @dev Returns the integer division of two unsigned integers. Reverts on
48      * division by zero. The result is rounded towards zero.
49      */
50     function div(uint256 a, uint256 b) internal pure returns(uint256) {
51         require(b > 0, "SafeMath: division by zero");
52         uint256 c = a / b;
53 
54         return c;
55     }
56 
57     /**
58      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
59      * Reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns(uint256) {
62         require(b != 0, "SafeMath: modulo by zero");
63         return a % b;
64     }
65 }
66 
67 
68 // ----------------------------------------------------------------------------
69 // ERC20 Token Standard Interface
70 // ----------------------------------------------------------------------------
71 interface ERC20Interface {
72     function totalSupply() external returns(uint);
73     function balanceOf(address tokenOwner) external returns(uint balance);
74     function allowance(address tokenOwner, address spender) external returns(uint remaining);
75     function transfer(address to, uint tokens) external returns(bool success);
76     function approve(address spender, uint tokens) external returns(bool success);
77     function transferFrom(address from, address to, uint tokens) external returns(bool success);
78     event Transfer(address indexed from, address indexed to, uint tokens);
79     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
80 }
81 
82 /**
83  * @title admined
84  * @notice This contract is administered
85  */
86 contract admined {
87     //mapping to user levels
88     mapping(address => uint8) public level;
89     //0 normal user
90     //1 basic admin
91     //2 master admin
92 
93     constructor() internal {
94         level[0x7a3a57c620fA468b304b5d1826CDcDe28E2b2b98] = 2; //Set initial admin to contract creator
95         emit AdminshipUpdated(0x7a3a57c620fA468b304b5d1826CDcDe28E2b2b98, 2); //Log the admin set
96     }
97 
98     /**
99      * @dev This modifier limits function execution to the admin
100      */
101     modifier onlyAdmin(uint8 _level) { //A modifier to define admin-only functions
102         //It require the user level to be more or equal than _level
103         require(level[msg.sender] >= _level, "You dont have rights for this transaction");
104         _;
105     }
106 
107     /**
108      * @notice This function transfer the adminship of the contract to _newAdmin
109      * @param _newAdmin The new admin of the contract
110      * @param _level Level to assign to the new admin of the contract
111      */
112     function adminshipLevel(address _newAdmin, uint8 _level) public onlyAdmin(2) {//Admin can be set
113         require(_newAdmin != address(0), "Address cannot be zero"); //The new admin must not be zero address
114         level[_newAdmin] = _level; //New level is set
115         emit AdminshipUpdated(_newAdmin, _level); //Log the admin set
116     }
117 
118     /**
119      * @dev Log Events
120      */
121     event AdminshipUpdated(address _newAdmin, uint8 _level);
122 
123 }
124 
125 // ----------------------------------------------------------------------------
126 // Main Contract definition
127 // ----------------------------------------------------------------------------
128 contract ICO is admined {
129 
130     using SafeMath for uint256;
131 
132     enum State {
133         //This ico have these states
134         OnSale,
135         Successful
136     }
137 
138     //public variables
139 
140     //state related
141     State public state = State.OnSale; //Set initial stage
142 
143     //time related
144     uint256 public SaleStartTime = now;
145     uint256 public completedAt;
146 
147     //token related
148     ERC20Interface public tokenReward;
149 
150     //funding related
151     uint256 public totalRaised; //eth in wei
152     uint256 public totalDistributed; //tokens distributed
153     uint256 public totalBonusDistributed; //bonus tokens distributed
154     uint256 public constant rate = 2941; //Rate
155     uint256 public constant trancheSize = 52500000 * 1e18;
156     uint256 public constant hardCap = 420000000 * 1e18;
157     uint256 public constant softCap = 3000000 * 1e18;
158     mapping(address => uint256) public invested;
159     mapping(address => uint256) public received;
160     mapping(address => uint256) public bonusReceived;
161 
162     //info
163     address public owner;
164     address payable public beneficiary;
165     string public version = '1';
166 
167     //events for log
168     event LogFundingInitialized(address _owner);
169     event LogFundingReceived(address _addr, uint _amount, uint _currentTotal);
170     event LogContributorsPayout(address _addr, uint _amount);
171     event LogBeneficiaryPaid(address _beneficiaryAddress);
172     event LogFundingSuccessful(uint _totalRaised);
173 
174     modifier notFinished() {
175         require(state != State.Successful, "Sale have finished");
176         _;
177     }
178 
179     /**
180      * @notice ICO constructor
181      * @param _addressOfTokenUsedAsReward is the token to distributed
182      */
183     constructor(ERC20Interface _addressOfTokenUsedAsReward) public {
184 
185         tokenReward = _addressOfTokenUsedAsReward;
186         owner = 0x7a3a57c620fA468b304b5d1826CDcDe28E2b2b98;
187         beneficiary = 0x8605409D35f707714A83410BE9C8025dcefa9faC;
188 
189         emit LogFundingInitialized(owner);
190 
191     }
192 
193     /**
194      * @notice contribution handler
195      */
196     function contribute(address _target, uint256 _value) public notFinished payable {
197 
198         address user;
199         uint valueHandler;
200 
201         uint tokenBought;
202         uint tokenBonus;
203 
204         uint bonusStack;
205         uint trancheLeft;
206         uint remaining;
207 
208         if (_target != address(0) && level[msg.sender] >= 1) {
209             user = _target;
210             valueHandler = _value;
211         } else {
212             user = msg.sender;
213             valueHandler = msg.value;
214             //Refund through contract for eth contributors only
215             invested[msg.sender] = invested[msg.sender].add(msg.value);
216         }
217 
218         require(valueHandler >= 0.1 ether, "Not enough value for this transaction");
219 
220         totalRaised = totalRaised.add(valueHandler); //ether received updated
221 
222         //This keep the tokens bought
223         tokenBought = valueHandler.mul(rate);
224         //This keep the tokens to be bonus-analized
225         remaining = valueHandler.mul(rate);
226 
227         //First Tranche Handler
228         if (remaining > 0 &&
229             totalDistributed < trancheSize
230         ) {
231             trancheLeft = trancheSize.sub(totalDistributed);
232 
233             if (remaining < trancheLeft) {
234                 bonusStack = remaining.mul(4);
235                 tokenBonus = bonusStack.div(10);
236 
237                 totalDistributed = totalDistributed.add(remaining);
238 
239                 remaining = 0;
240                 bonusStack = 0;
241                 trancheLeft = 0;
242             } else {
243                 bonusStack = trancheLeft.mul(4);
244                 tokenBonus = bonusStack.div(10);
245 
246                 totalDistributed = totalDistributed.add(trancheLeft);
247 
248                 remaining = remaining.sub(trancheLeft);
249                 bonusStack = 0;
250                 trancheLeft = 0;
251             }
252         }
253 
254         //Second Tranche Handler
255         if (remaining > 0 &&
256             totalDistributed >= trancheSize &&
257             totalDistributed < trancheSize.mul(2)
258         ) {
259             trancheLeft = trancheSize.mul(2).sub(totalDistributed);
260 
261             if (remaining < trancheLeft) {
262                 bonusStack = remaining.mul(35);
263                 tokenBonus = tokenBonus.add(bonusStack.div(100));
264 
265                 totalDistributed = totalDistributed.add(remaining);
266 
267                 remaining = 0;
268                 bonusStack = 0;
269                 trancheLeft = 0;
270             } else {
271                 bonusStack = trancheLeft.mul(35);
272                 tokenBonus = tokenBonus.add(bonusStack.div(100));
273 
274                 totalDistributed = totalDistributed.add(trancheLeft);
275 
276                 remaining = remaining.sub(trancheLeft);
277                 bonusStack = 0;
278                 trancheLeft = 0;
279             }
280         }
281 
282         //Third Tranche Handler
283         if (remaining > 0 &&
284             totalDistributed >= trancheSize.mul(2) &&
285             totalDistributed < trancheSize.mul(3)
286         ) {
287             trancheLeft = trancheSize.mul(3).sub(totalDistributed);
288 
289             if (remaining < trancheLeft) {
290                 bonusStack = remaining.mul(3);
291                 tokenBonus = tokenBonus.add(bonusStack.div(10));
292 
293                 totalDistributed = totalDistributed.add(remaining);
294 
295                 remaining = 0;
296                 bonusStack = 0;
297                 trancheLeft = 0;
298             } else {
299                 bonusStack = trancheLeft.mul(3);
300                 tokenBonus = tokenBonus.add(bonusStack.div(10));
301 
302                 totalDistributed = totalDistributed.add(trancheLeft);
303 
304                 remaining = remaining.sub(trancheLeft);
305                 bonusStack = 0;
306                 trancheLeft = 0;
307             }
308         }
309 
310         //Fourth Tranche Handler
311         if (remaining > 0 &&
312             totalDistributed >= trancheSize.mul(3) &&
313             totalDistributed < trancheSize.mul(4)
314         ) {
315             trancheLeft = trancheSize.mul(4).sub(totalDistributed);
316 
317             if (remaining < trancheLeft) {
318                 bonusStack = remaining.mul(2);
319                 tokenBonus = tokenBonus.add(bonusStack.div(10));
320 
321                 totalDistributed = totalDistributed.add(remaining);
322 
323                 remaining = 0;
324                 bonusStack = 0;
325                 trancheLeft = 0;
326             } else {
327                 bonusStack = trancheLeft.mul(2);
328                 tokenBonus = tokenBonus.add(bonusStack.div(10));
329 
330                 totalDistributed = totalDistributed.add(trancheLeft);
331 
332                 remaining = remaining.sub(trancheLeft);
333                 bonusStack = 0;
334                 trancheLeft = 0;
335             }
336         }
337 
338         //Fifth Tranche Handler
339         if (remaining > 0 &&
340             totalDistributed >= trancheSize.mul(4) &&
341             totalDistributed < trancheSize.mul(5)
342         ) {
343             trancheLeft = trancheSize.mul(5).sub(totalDistributed);
344 
345             if (remaining < trancheLeft) {
346                 tokenBonus = tokenBonus.add(remaining.div(10));
347 
348                 totalDistributed = totalDistributed.add(remaining);
349 
350                 remaining = 0;
351                 bonusStack = 0;
352                 trancheLeft = 0;
353             } else {
354                 tokenBonus = tokenBonus.add(trancheLeft.div(10));
355 
356                 totalDistributed = totalDistributed.add(trancheLeft);
357 
358                 remaining = remaining.sub(trancheLeft);
359                 bonusStack = 0;
360                 trancheLeft = 0;
361             }
362         }
363 
364         //Sixth Tranche Handler
365         if (remaining > 0 &&
366             totalDistributed >= trancheSize.mul(5) &&
367             totalDistributed < trancheSize.mul(6)
368         ) {
369             trancheLeft = trancheSize.mul(6).sub(totalDistributed);
370 
371             if (remaining < trancheLeft) {
372                 bonusStack = remaining.mul(5);
373                 tokenBonus = tokenBonus.add(bonusStack.div(100));
374 
375                 totalDistributed = totalDistributed.add(remaining);
376 
377                 remaining = 0;
378                 bonusStack = 0;
379                 trancheLeft = 0;
380             } else {
381                 bonusStack = trancheLeft.mul(5);
382                 tokenBonus = tokenBonus.add(bonusStack.div(100));
383 
384                 totalDistributed = totalDistributed.add(trancheLeft);
385 
386                 remaining = remaining.sub(trancheLeft);
387                 bonusStack = 0;
388                 trancheLeft = 0;
389             }
390         }
391 
392         totalDistributed = totalDistributed.add(remaining);
393         totalBonusDistributed = totalBonusDistributed.add(tokenBonus);
394 
395         tokenReward.transfer(user, tokenBought.add(tokenBonus));
396         received[user] = received[user].add(tokenBought);
397         bonusReceived[user] = bonusReceived[user].add(tokenBonus);
398 
399         emit LogFundingReceived(user, valueHandler, totalRaised); //Log the purchase
400 
401         checkIfFundingCompleteOrExpired(); //Execute state checks
402     }
403 
404     /**
405      * @notice check status
406      */
407     function checkIfFundingCompleteOrExpired() public {
408 
409         if (totalDistributed.add(totalBonusDistributed) > hardCap.sub(rate)) { //If we reach the PubSale deadline
410 
411             state = State.Successful; //ico becomes Successful
412 
413             completedAt = now; //ICO is complete
414 
415             emit LogFundingSuccessful(totalRaised); //we log the finish
416             finished(); //and execute closure
417 
418         }
419     }
420 
421     function withdrawEth() public onlyAdmin(2) {
422         require(totalDistributed >= softCap, "Too early to retrieve funds");
423         beneficiary.transfer(address(this).balance);
424     }
425 
426     function getRefund() public notFinished {
427         require(totalDistributed >= softCap, "Too early to retrieve funds");
428         require(invested[msg.sender] > 0, "No eth to refund");
429         require(
430             tokenReward.transferFrom(
431                 msg.sender,
432                 address(this),
433                 received[msg.sender].add(bonusReceived[msg.sender])
434             ),
435             "Cannot retrieve tokens"
436         );
437 
438         totalDistributed = totalDistributed.sub(received[msg.sender]);
439         totalBonusDistributed = totalBonusDistributed.sub(bonusReceived[msg.sender]);
440         received[msg.sender] = 0;
441         bonusReceived[msg.sender] = 0;
442         uint toTransfer = invested[msg.sender];
443         invested[msg.sender] = 0;
444         msg.sender.transfer(toTransfer);
445     }
446 
447     /**
448      * @notice closure handler
449      */
450     function finished() public { //When finished, eth are transfered to beneficiary
451         //Only on sucess
452         require(state == State.Successful, "Wrong Stage");
453 
454         uint256 remanent = tokenReward.balanceOf(address(this));
455 
456         require(tokenReward.transfer(beneficiary, remanent), "Transfer could not be made");
457 
458         beneficiary.transfer(address(this).balance);
459         emit LogBeneficiaryPaid(beneficiary);
460     }
461 
462     /*
463      * @notice direct payments handler
464      */
465     function () external payable {
466         contribute(address(0), 0);
467     }
468 }