1 pragma solidity ^0.4.24;
2 
3 contract AddressBook {
4 
5     mapping(address => uint32) public uidOf;
6     mapping(uint32 => address) public addrOf;
7 
8     uint32 public topUid;
9 
10     function address_register(address _addr) internal {
11         require(uidOf[_addr] == 0, 'addr exsists');
12         uint32 uid = ++topUid;
13         uidOf[_addr] = uid;
14         addrOf[uid] = _addr;
15     }
16 }
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22 
23     /**
24     * @dev Multiplies two numbers, throws on overflow.
25     */
26     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
27         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
28         // benefit is lost if 'b' is also tested.
29         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
30         if (_a == 0) {
31             return 0;
32         }
33 
34         uint256 c = _a * _b;
35         assert(c / _a == _b);
36 
37         return c;
38     }
39 
40     /**
41     * @dev Integer division of two numbers, truncating the quotient.
42     */
43     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
44         // assert(_b > 0); // Solidity automatically throws when dividing by 0
45         uint256 c = _a / _b;
46         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
47 
48         return c;
49     }
50 
51     /**
52     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53     */
54     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
55         assert(_b <= _a);
56         uint256 c = _a - _b;
57 
58         return c;
59     }
60 
61     /**
62     * @dev Adds two numbers, throws on overflow.
63     */
64     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
65         uint256 c = _a + _b;
66         assert(c >= _a);
67 
68         return c;
69     }
70 }
71 
72 
73 /**
74  * @title Ownable
75  * @dev The Ownable contract has an owner address, and provides basic authorization control
76  * functions, this simplifies the implementation of "user permissions".
77  */
78 contract Ownable {
79     address public owner;
80 
81 
82     event OwnershipRenounced(address indexed previousOwner);
83     event OwnershipTransferred(
84         address indexed previousOwner,
85         address indexed newOwner
86     );
87 
88 
89     /**
90      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
91      * account.
92      */
93     constructor() public {
94         owner = msg.sender;
95     }
96 
97     /**
98      * @dev Throws if called by any account other than the owner.
99      */
100     modifier onlyOwner() {
101         require(msg.sender == owner);
102         _;
103     }
104 
105     /**
106      * @dev Allows the current owner to relinquish control of the contract.
107      * @notice Renouncing to ownership will leave the contract without an owner.
108      * It will not be possible to call the functions with the `onlyOwner`
109      * modifier anymore.
110      */
111     function renounceOwnership() public onlyOwner {
112         emit OwnershipRenounced(owner);
113         owner = address(0);
114     }
115 
116     /**
117      * @dev Allows the current owner to transfer control of the contract to a newOwner.
118      * @param _newOwner The address to transfer ownership to.
119      */
120     function transferOwnership(address _newOwner) public onlyOwner {
121         _transferOwnership(_newOwner);
122     }
123 
124     /**
125      * @dev Transfers control of the contract to a newOwner.
126      * @param _newOwner The address to transfer ownership to.
127      */
128     function _transferOwnership(address _newOwner) internal {
129         require(_newOwner != address(0));
130         emit OwnershipTransferred(owner, _newOwner);
131         owner = _newOwner;
132     }
133 }
134 
135 
136 contract EthBox is Ownable, AddressBook {
137     using SafeMath for uint256;
138 
139     event Deposited(uint indexed pid, uint indexed rid, uint number, address indexed payee, uint256 weiAmount, address inviter, RoundState state);
140     event RoundFinished(uint indexed pid, uint indexed rid, uint indexed number);
141 
142     event NewRound(uint indexed pid, uint indexed rid, uint number, RoundState state);
143 
144 
145     // Events that are issued to make statistic recovery easier.
146     event FailedPayment(uint indexed pid, uint indexed rid, address indexed beneficiary, uint amount, uint count);
147     event Payment(uint indexed pid, uint indexed rid, address indexed beneficiary, uint amount, uint count, RoundState state);
148     event LogDepositReceived(address indexed sender);
149     event InviterRegistered(address indexed inviter, uint value);
150     event InviterWithDraw(address indexed inviter, uint value);
151 
152     uint INVITER_FEE_PERCENT = 30; 
153     uint constant INVITER_MIN_VALUE = 100 finney; 
154 
155     uint public lockedInBets;
156 
157     enum RoundState{READY, RUNNING, REMOVED, FINISHED, WITHDRAWED}
158 
159     struct Round {
160         uint32[] peoples; 
161         uint price;
162         uint min_amount;
163         uint max_amount;
164         uint remainPrice;
165         uint HOUSE_EDGE_PERCENT;
166         RoundState state;
167         bool valid;
168         bool willremove;
169         bytes32 secretEncrypt;
170         uint count;
171     }
172 
173     function() public payable {emit LogDepositReceived(msg.sender);}
174 
175     constructor() public Ownable(){}
176 
177     mapping(uint => mapping(uint => Round)) public bets;
178     mapping(address => uint) public inviters;
179 
180     uint public inviterValues;
181 
182     modifier onlyHuman() {
183         address _addr = msg.sender;
184         uint256 _codeLength;
185 
186         assembly {_codeLength := extcodesize(_addr)}
187         require(_codeLength == 0, "sorry humans only");
188         _;
189     }
190 
191     modifier onlyIfRoundNotFinished(uint pid, uint rid){
192         require(bets[pid][rid].state != RoundState.FINISHED);
193         _;
194     }
195 
196     modifier onlyIfRoundFinished(uint pid, uint rid){
197         require(bets[pid][rid].state == RoundState.FINISHED);
198         _;
199     }
200 
201     modifier onlyIfRoundWithdrawed(uint pid, uint rid){
202         require(bets[pid][rid].state == RoundState.WITHDRAWED);
203         _;
204     }
205 
206     modifier onlyIfBetExist(uint pid, uint rid){
207         require(bets[pid][rid].valid);
208         _;
209     }
210 
211     modifier onlyIfBetNotExist(uint pid, uint rid){
212         require(!bets[pid][rid].valid);
213         _;
214     }
215 
216     function setHouseEdge(uint pid, uint rid, uint _edge) public onlyOwner {
217         if (bets[pid][rid].valid) {
218             bets[pid][rid].HOUSE_EDGE_PERCENT = _edge;
219         }
220     }
221 
222     function setInviterEdge(uint _edge) public onlyOwner {
223         INVITER_FEE_PERCENT = _edge;
224     }
225 
226     function inviterRegister() onlyHuman payable external {
227         require(msg.value == INVITER_MIN_VALUE, "register value must greater than min value");
228 
229         inviters[msg.sender] = inviters[msg.sender].add(msg.value);
230         inviterValues = inviterValues.add(msg.value);
231         emit InviterRegistered(msg.sender, msg.value);
232 
233     }
234 
235     function newRound(uint pid, uint rid, uint _price, uint _min_amount, uint _edge, bytes32 _secretEncrypt, uint count) private {
236         Round storage r = bets[pid][rid];
237         require(!r.valid);
238         r.price = _price;
239         r.min_amount = _min_amount;
240         r.max_amount = _price;
241         r.HOUSE_EDGE_PERCENT = _edge;
242         r.state = RoundState.RUNNING;
243         r.remainPrice = _price;
244         r.valid = true;
245         r.secretEncrypt = _secretEncrypt;
246         // r.firstBlockNum = block.number;
247         r.count = count;
248 
249     }
250 
251 
252     function buyTicket(uint pid, uint rid, address _inviter) public onlyHuman onlyIfBetExist(pid, rid) onlyIfRoundNotFinished(pid, rid) payable {
253         uint256 amount = msg.value;
254 
255         require(msg.sender != address(0x0), "invalid payee address");
256 
257         Round storage round = bets[pid][rid];
258 
259         require(round.remainPrice > 0, "remain price less then zero");
260         require(amount >= round.min_amount && amount <= round.max_amount, "Amount should be within range.");
261         require(amount <= round.remainPrice, "amount can not greater than remain price");
262         require(amount % round.min_amount == 0, "invalid amount");
263 
264         if (uidOf[msg.sender] == 0) {
265             address_register(msg.sender);
266         }
267 
268         for (uint i = 0; i < amount.div(round.min_amount); i++) {
269             round.peoples.push(uidOf[msg.sender]);
270         }
271 
272         // round.blockNum = block.number;
273         round.remainPrice = round.remainPrice.sub(amount);
274         lockedInBets = lockedInBets.add(amount);
275 
276         addInviterValue(amount, round.HOUSE_EDGE_PERCENT, msg.sender, _inviter);
277 
278         if (round.remainPrice == 0) {
279             round.state = RoundState.FINISHED;
280             emit RoundFinished(pid, rid, round.count);
281         }
282 
283         emit Deposited(pid, rid, round.count, msg.sender, amount, _inviter, round.state);
284     }
285 
286     function addInviterValue(uint amount, uint edge, address sender, address _inviter) private {
287         uint fee = amount.mul(edge).div(100);
288         //不计算同一帐号买入的抽成
289         if (sender != _inviter && inviters[_inviter] >= INVITER_MIN_VALUE) {
290             uint _ifee = fee.mul(INVITER_FEE_PERCENT).div(100);
291             inviters[_inviter] = inviters[_inviter].add(_ifee);
292             inviterValues = inviterValues.add(_ifee);
293         }
294     }
295 
296     function payout(uint pid, uint rid, bytes32 _secret, bytes32 _nextSecretEncrypt) external onlyIfBetExist(pid, rid) onlyIfRoundFinished(pid, rid) {
297 
298         Round storage round = bets[pid][rid];
299         require(round.secretEncrypt == keccak256(abi.encodePacked(_secret)), "secret is not valid.");
300 
301         uint result = uint(keccak256(abi.encodePacked(_secret, blockhash(block.number)))) % (round.price.div(round.min_amount));
302         address luckGuy = addrOf[round.peoples[result]];
303         require(luckGuy != address(0x0));
304         uint256 bonus = round.price.sub(round.price.mul(round.HOUSE_EDGE_PERCENT).div(100));
305 
306         if (bonus > 0) {
307             if (withdraw(pid, rid, luckGuy, bonus)) {
308                 round.state = RoundState.WITHDRAWED;
309                 lockedInBets = lockedInBets.sub(round.price);
310 
311                 clearRound(pid, rid, _nextSecretEncrypt, round.willremove, round.price, round.min_amount, round.HOUSE_EDGE_PERCENT, round.count);
312 
313                 emit Payment(pid, rid, luckGuy, bonus, round.count - 1, round.state);
314 
315             } else {
316                 emit FailedPayment(pid, rid, luckGuy, bonus, round.count);
317             }
318         }
319     }
320 
321     function clearRound(uint pid, uint rid, bytes32 _secretEncrypt, bool willremove, uint price, uint min_amount, uint edge, uint count) private onlyIfBetExist(pid, rid) onlyIfRoundWithdrawed(pid, rid) {
322         delete bets[pid][rid];
323         if (!willremove) {
324             newRound(pid, rid, price, min_amount, edge, _secretEncrypt, count + 1);
325             emit NewRound(pid, rid, count + 1, RoundState.RUNNING);
326         } else {
327             emit NewRound(pid, rid, count + 1, RoundState.REMOVED);
328         }
329 
330     }
331 
332     function removeRound(uint pid, uint rid) external onlyOwner onlyIfBetExist(pid, rid) {
333         Round storage r = bets[pid][rid];
334         r.willremove = true;
335     }
336 
337     function addRound(uint pid, uint rid, uint _price, uint _min_amount, uint _edge, bytes32 _secretEncrypt) external onlyOwner onlyIfBetNotExist(pid, rid) {
338         newRound(pid, rid, _price, _min_amount, _edge, _secretEncrypt, 1);
339     }
340 
341 
342     function withdraw(uint pid, uint rid, address beneficiary, uint withdrawAmount) private onlyIfBetExist(pid, rid) returns (bool){
343         Round storage r = bets[pid][rid];
344         require(withdrawAmount < r.price);
345         require(withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
346 
347         return beneficiary.send(withdrawAmount);
348     }
349 
350     // Funds withdrawal to cover costs of operation.
351     function withdrawFunds(address payee) external onlyOwner {
352         uint costvalue = costFunds();
353         require(costvalue > 0, "has no cost funds");
354         payee.transfer(costvalue);
355     }
356 
357     function costFunds() public view returns (uint){
358         return address(this).balance.sub(lockedInBets).sub(inviterValues);
359     }
360 
361     function payToInviter(uint _value) onlyHuman external {
362         _payToInviter(msg.sender, _value);
363     }
364 
365     function _payToInviter(address _inviter, uint _value) private {
366         require(_value > 0 && inviters[_inviter] >= _value, "can not pay back greater then value");
367         require(inviters[_inviter] <= address(this).balance);
368 
369         inviters[_inviter] = inviters[_inviter].sub(_value);
370         inviterValues = inviterValues.sub(_value);
371         _inviter.transfer(_value);
372         emit InviterWithDraw(_inviter, _value);
373     }
374 
375     function forceWithDrawToInviter(address _inviter, uint _value) onlyOwner external {
376         _payToInviter(_inviter, _value);
377     }
378 
379 
380     function kill() external onlyOwner {
381         require(lockedInBets == 0, "All games should be processed settled before self-destruct.");
382         require(inviterValues == 0, "All inviter fee should be withdrawed before self-destruct.");
383         selfdestruct(owner);
384     }
385 
386     function lengthOfKeys(uint pid, uint rid) public onlyIfBetExist(pid, rid) view returns (uint){
387         Round storage r = bets[pid][rid];
388         return r.peoples.length;
389     }
390 
391     function roundCount(uint pid, uint rid) public onlyIfBetExist(pid, rid) view returns (uint){
392         Round storage r = bets[pid][rid];
393         return r.count;
394     }
395 
396     function roundState(uint pid, uint rid) public onlyIfBetExist(pid, rid) view returns (RoundState){
397         Round storage r = bets[pid][rid];
398         return r.state;
399     }
400 }