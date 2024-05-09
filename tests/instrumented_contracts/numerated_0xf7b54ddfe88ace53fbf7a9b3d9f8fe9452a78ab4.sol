1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39     address public owner;
40 
41     /**
42     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
43     * account.
44     */
45     function Ownable() {
46         owner = msg.sender;
47     }
48 
49     /**
50     * @dev Throws if called by any account other than the owner.
51     */
52     modifier onlyOwner() {
53         require(msg.sender == owner);
54         _;
55     }
56 
57     /**
58     * @dev Allows the current owner to transfer control of the contract to a newOwner.
59     * @param newOwner The address to transfer ownership to.
60     */
61     function transferOwnership(address newOwner) onlyOwner {
62         if (newOwner != address(0)) {
63             owner = newOwner;
64         }
65     }
66 
67 }
68 
69 contract Fund is Ownable  {
70     using SafeMath for uint256;
71     
72     string public name = "Slot Token";
73     uint8 public decimals = 0;
74     string public symbol = "SLOT";
75     string public version = "0.7";
76     
77     uint8 constant TOKENS = 0;
78     uint8 constant BALANCE = 1;
79     
80     uint256 totalWithdrawn;     // of Ether
81     uint256 public totalSupply; // of Tokens
82     
83     mapping(address => uint256[2][]) balances;
84     mapping(address => uint256) withdrawals;
85     
86     event Withdrawn(
87             address indexed investor, 
88             address indexed beneficiary, 
89             uint256 weiAmount);
90     event Mint(
91             address indexed to, 
92             uint256 amount);
93     event MintFinished();
94     event Transfer(
95             address indexed from, 
96             address indexed to, 
97             uint256 value);
98     event Approval(
99             address indexed owner, 
100             address indexed spender, 
101             uint256 value);
102             
103     mapping (address => mapping (address => uint256)) allowed;
104 
105     bool public mintingFinished = false;
106 
107     modifier canMint() {
108         require(!mintingFinished);
109         _;
110     }
111     
112     function Fund() payable {}
113     function() payable {}
114     
115     function getEtherBalance(address _owner) constant public returns (uint256 _balance) {
116         uint256[2][] memory snapshots = balances[_owner];
117         
118         if (snapshots.length == 0) { return 0; } // no data
119 
120         uint256 balance = 0;
121         uint256 previousSnapTotalStake = 0;
122         
123         // add up all snapshots
124         for (uint256 i = 0 ; i < snapshots.length ; i++) {
125             // each snapshot has amount of tokens and totalBalance at the time except last, which should be calculated with current stake
126             
127             if (i == snapshots.length-1) {
128                 // add current data
129                 uint256 currentTokens = snapshots[i][TOKENS];
130                 uint256 b = currentTokens.mul( getTotalStake().sub(previousSnapTotalStake) ).div(totalSupply);
131                 balance = balance.add(b);
132         
133                 // reduce withdrawals
134                 return balance.sub(withdrawals[_owner]);
135             }
136             
137             uint256 snapTotalStake = snapshots[i][BALANCE];
138             // if it's the first element, nothing is substracted from snapshot's total stake, hence previous stake will be 0
139             uint256 spanBalance = snapshots[i][TOKENS].mul(snapTotalStake.sub(previousSnapTotalStake)).div(totalSupply);
140             balance = balance.add(spanBalance);
141             
142             previousSnapTotalStake = previousSnapTotalStake.add(snapTotalStake); // for the next loop and next code, needs to be += 
143         }
144     }
145 
146     function balanceOf(address _owner) constant returns (uint256 balance) {
147         uint256[2][] memory snapshots = balances[_owner];
148         if (snapshots.length == 0) { return 0; }
149         
150         return snapshots[snapshots.length-1][TOKENS];
151     }
152     
153     function getTotalStake() constant public returns (uint256 _totalStake) {
154         // the total size of the pie, unaffected by withdrawals
155         return this.balance + totalWithdrawn;
156     }
157     
158     function withdrawBalance(address _to, uint256 _value) public {
159         require(getEtherBalance(msg.sender) >= _value);
160         
161         withdrawals[msg.sender] = withdrawals[msg.sender].add(_value);
162         totalWithdrawn = totalWithdrawn.add(_value);
163         
164         _to.transfer(_value);
165         Withdrawn(msg.sender, _to, _value);
166     }
167     
168     function transfer(address _to, uint256 _value) returns (bool) {
169         return transferFromPrivate(msg.sender, _to, _value);
170     }
171     
172     function transferFromPrivate(address _from, address _to, uint256 _value) private returns (bool) {
173         require(balanceOf(msg.sender) >= _value);
174         
175         uint256 fromTokens = balanceOf(msg.sender);
176         pushSnapshot(msg.sender, fromTokens-_value);
177         
178         uint256 toTokens = balanceOf(_to);
179         pushSnapshot(_to, toTokens+_value);
180         
181         Transfer(_from, _to, _value);
182         return true;
183     }
184     
185     function pushSnapshot(address _beneficiary, uint256 _amount) private {
186         balances[_beneficiary].push([_amount, 0]);
187         
188         if (balances[_beneficiary].length > 1) {
189             // update previous snapshot balance
190             uint256 lastIndex = balances[msg.sender].length-1;
191             balances[_beneficiary][lastIndex-1][BALANCE] = getTotalStake();
192         }
193     }
194 
195     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
196         pushSnapshot(_to, _amount.add(balanceOf(_to)));
197         totalSupply = totalSupply.add(_amount);
198         Mint(_to, _amount);
199         Transfer(0x0, _to, _amount); // so it is displayed properly on EtherScan
200         return true;
201     }
202     
203 
204     function finishMinting() onlyOwner returns (bool) {
205         mintingFinished = true;
206         MintFinished();
207         return true;
208     }
209     
210     
211     function approve(address _spender, uint256 _value) returns (bool) {
212 
213         // To change the approve amount you first have to reduce the addresses`
214         //  allowance to zero by calling `approve(_spender, 0)` if it is not
215         //  already 0 to mitigate the race condition described here:
216         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
217         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
218 
219         allowed[msg.sender][_spender] = _value;
220         Approval(msg.sender, _spender, _value);
221         return true;
222     }
223 
224     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
225         return allowed[_owner][_spender];
226     }
227     
228     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
229         uint256 _allowance = allowed[_from][msg.sender];
230 
231         transferFromPrivate(_from, _to, _value);
232         
233         allowed[_from][msg.sender] = _allowance.sub(_value);
234         return true;
235     }
236     
237 }
238 
239 /**
240  * @title Pausable
241  * @dev Base contract which allows children to implement an emergency stop mechanism.
242  */
243 contract Pausable is Ownable {
244   event Pause();
245   event Unpause();
246 
247   bool public paused = false;
248 
249   /**
250    * @dev modifier to allow actions only when the contract IS paused
251    */
252   modifier whenNotPaused() {
253     require(!paused);
254     _;
255   }
256 
257   /**
258    * @dev modifier to allow actions only when the contract IS NOT paused
259    */
260   modifier whenPaused {
261     require(paused);
262     _;
263   }
264 
265   /**
266    * @dev called by the owner to pause, triggers stopped state
267    */
268   function pause() onlyOwner whenNotPaused returns (bool) {
269     paused = true;
270     Pause();
271     return true;
272   }
273 
274   /**
275    * @dev called by the owner to unpause, returns to normal state
276    */
277   function unpause() onlyOwner whenPaused returns (bool) {
278     paused = false;
279     Unpause();
280     return true;
281   }
282 }
283 
284 
285 /**
286 * @title SlotCrowdsale
287 */
288 contract SlotCrowdsale is Ownable, Pausable {
289     using SafeMath for uint256;
290 
291     Fund public fund;
292 
293     uint256 constant ETHER_CAP   = 4715 ether;   // ether
294     uint256 constant TOKEN_CAP   = 10000000;     // tokens
295     uint256 constant PRICE       = 1 ether;      // ether
296     uint256 constant BOUNTY      = 250000;       // tokens
297     uint256 constant OWNERS_STAKE = 3750000;     // tokens
298     uint256 constant OWNERS_LOCK = 200000;       // blocks
299     address public bountyWallet;
300     address public ownersWallet;
301     uint256 public lockBegunAtBlock;
302     
303     bool public bountyDistributed = false;
304     bool public ownershipDistributed = false;
305     
306     uint256[10] outcomes = [1000000,    // 0
307                              250000,    // 1
308                              100000,    // 2 
309                               20000,    // 3
310                               10000,    // 4
311                                4000,    // 5
312                                2000,    // 6
313                                1250,    // 7
314                                1000,    // 8
315                                 500];   // 9
316                                
317                             //   0  1   2   3    4    5    6     7     8     9  
318     uint16[10] chances =        [1, 4, 10, 50, 100, 250, 500,  800, 1000, 2000];
319     uint16[10] addedUpChances = [1, 5, 15, 65, 165, 415, 915, 1715, 2715, 4715];
320     
321     event OwnershipDistributed();
322     event BountyDistributed();
323 
324     function SlotCrowdsale() payable {
325         // fund = Fund(_fundAddress); // still need to change ownership
326         fund = new Fund();
327         bountyWallet = 0x00deF93928A3aAD581F39049a3BbCaaB9BbE36C8;
328         ownersWallet = 0x0001619153d8FE15B3FA70605859265cb0033c1a;
329     }
330 
331     function() payable {
332         // fallback function to buy tickets
333         buyTokenFor(msg.sender);
334     }
335     
336     function correctedIndex(uint8 _index) constant private returns (uint8 _newIndex) {
337         require(_index < chances.length);
338         // if the chance is 0, return the next index
339         
340         if (chances[_index] != 0) {
341             return _index;
342         } else {
343             return correctedIndex(uint8((_index + 1) % chances.length));
344         }
345     }
346     
347     function getRateIndex(uint256 _randomNumber) constant private returns (uint8 _rateIndex) {
348         for (uint8 i = 0 ; i < uint8(chances.length) ; i++) {
349             if (_randomNumber < addedUpChances[i]) { 
350                 return correctedIndex(i); 
351             }
352         }
353     }
354 
355     function buyTokenFor(address _beneficiary) whenNotPaused() payable {
356         require(_beneficiary != 0x0);
357         require(msg.value >= PRICE);
358         
359         uint256 change = msg.value%PRICE;
360         uint256 numberOfTokens = msg.value.sub(change).div(PRICE);
361         
362         mintTokens(_beneficiary, numberOfTokens);
363         
364         // Return change to msg.sender
365         msg.sender.transfer(change);
366     }
367     
368     function mintTokens(address _beneficiary, uint256 _numberOfTokens) private {
369         uint16 totalChances = addedUpChances[9];
370 
371         for (uint16 i=1 ; i <= _numberOfTokens; i++) {
372             
373             uint256 randomNumber = uint256(keccak256(block.blockhash(block.number-1)))%totalChances;
374             uint8 rateIndex = getRateIndex(randomNumber);
375             
376             // rate shouldn't be 0 because of correctedIndex function
377             assert(chances[rateIndex] != 0);
378             chances[rateIndex]--;
379             
380             uint256 amount = outcomes[rateIndex];
381             fund.mint(_beneficiary, amount);
382         }
383     }
384     
385     function crowdsaleEnded() constant private returns (bool ended) {
386         if (fund.totalSupply() >= TOKEN_CAP) { 
387             return true;
388         } else {
389             return false; 
390         }
391     }
392     
393     function lockEnded() constant private returns (bool ended) {
394         if (block.number.sub(lockBegunAtBlock) > OWNERS_LOCK) {
395             return true; 
396         } else {
397             return false;
398         }
399         
400     }
401     
402     /* public onlyOwner */
403     
404     function distributeBounty() public onlyOwner {
405         require(!bountyDistributed);
406         require(crowdsaleEnded());
407         
408         bountyDistributed = true;
409         bountyWallet.transfer(BOUNTY);
410         lockBegunAtBlock = block.number;
411         BountyDistributed();
412     }
413     
414     function distributeOwnership() public onlyOwner {
415         require(!ownershipDistributed);
416         require(crowdsaleEnded());
417         require(lockEnded());
418         
419         ownershipDistributed = true;
420         ownersWallet.transfer(OWNERS_STAKE);
421         
422         OwnershipDistributed();
423     }
424     
425     function changeOwnersWallet(address _newWallet) public onlyOwner {
426         require(_newWallet != 0x0);
427         ownersWallet = _newWallet;
428     }
429     
430     function changeBountyWallet(address _newWallet) public onlyOwner {
431         require(_newWallet != 0x0);
432         bountyWallet = _newWallet;
433     }
434     
435     function changeFundOwner(address _newOwner) {
436         require(_newOwner != 0x0);
437         fund.transferOwnership(_newOwner);
438     }
439 
440 }