1 pragma solidity ^0.5.0;
2 
3 /**
4  *
5  * @author Alejandro Diaz <Alejandro.Diaz.666@protonmail.com>
6  *
7  * Overview:
8  * This is an implimentation of a dividend-paying token, with a special transfer from a holding address.
9  * A fixed number of tokens are minted in the constructor, with some amount initially owned by the contract
10  * owner; and some amount owned by a reserve address. The reserve address cannot transfer tokens to any
11  * other address, except as directed by a trusted partner-contract.
12  *
13  * Dividends are awarded token holders following the technique outlined by Nick Johnson in
14  *  https://medium.com/ @ weka/dividend-bearing-tokens-on-ethereum-42d01c710657
15  *
16  * The technique is:
17  *   previous_due + [ p(x) * t(x)/N ] + [ p(x+1) * t(x+1)/N ] + ...
18  *   where p(x) is the x'th income payment received by the contract
19  *         t(x) is the number of tokens held by the token-holder at the time of p(x)
20  *         N    is the total number of tokens, which never changes
21  *
22  * assume that t(x) takes on 3 values, t(a), t(b) and t(c), at times a, b, and c;
23  * and that there are multiple payments at times between a and b: x, x+1, x+2...
24  * and multiple payments at times between b and c: y, x+y, y+2...
25  * and multiple payments at times greater than c: z, z+y, z+2...
26  * then factoring:
27  *
28  *   current_due = { (t(a) * [p(x) + p(x+1)]) ... + (t(a) * [p(x) + p(y-1)]) ... +
29  *                   (t(b) * [p(y) + p(y+1)]) ... + (t(b) * [p(y) + p(z-1)]) ... +
30  *                   (t(c) * [p(z) + p(z+1)]) ... + (t(c) * [p(z) + p(now)]) } / N
31  *
32  * or
33  *
34  *   current_due = { (t(a) * period_a_income) +
35  *                   (t(b) * period_b_income) +
36  *                   (t(c) * period_c_income) } / N
37  *
38  * if we designate current_due * N as current-points, then
39  *
40  *   currentPoints = {  (t(a) * period_a_income) +
41  *                      (t(b) * period_b_income) +
42  *                      (t(c) * period_c_income) }
43  *
44  * or more succictly, if we recompute current points before a token-holder's number of
45  * tokens, T, is about to change:
46  *
47  *   currentPoints = previous_points + (T * current-period-income)
48  *
49  * when we want to do a payout, we'll calculate:
50  *  current_due = current-points / N
51  *
52  * we'll keep track of a token-holder's current-period-points, which is:
53  *   T * current-period-income
54  * by taking a snapshot of income collected exactly when the current period began; that is, the when the
55  * number of tokens last changed. that is, we keep a running count of total income received
56  *
57  *   totalIncomeReceived = p(x) + p(x+1) + p(x+2)
58  *
59  * (which happily is the same for all token holders) then, before any token holder changes their number of
60  * tokens we compute (for that token holder):
61  *
62  *  function calcCurPointsForAcct(acct) {
63  *    currentPoints[acct] += (totalIncomeReceived - lastSnapshot[acct]) * T[acct]
64  *    lastSnapshot[acct] = totalIncomeReceived
65  *  }
66  *
67  * in the withdraw fcn, all we need is:
68  *
69  *  function withdraw(acct) {
70  *    calcCurPointsForAcct(acct);
71  *    current_amount_due = currentPoints[acct] / N
72  *    currentPoints[acct] = 0;
73  *    send(current_amount_due);
74  *  }
75  *
76  */
77 //import './SafeMath.sol';
78 /*
79     Overflow protected math functions
80 */
81 contract SafeMath {
82     /**
83         constructor
84     */
85     constructor() public {
86     }
87 
88     /**
89         @dev returns the sum of _x and _y, asserts if the calculation overflows
90 
91         @param _x   value 1
92         @param _y   value 2
93 
94         @return sum
95     */
96     function safeAdd(uint256 _x, uint256 _y) pure internal returns (uint256) {
97         uint256 z = _x + _y;
98         assert(z >= _x);
99         return z;
100     }
101 
102     /**
103         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
104 
105         @param _x   minuend
106         @param _y   subtrahend
107 
108         @return difference
109     */
110     function safeSub(uint256 _x, uint256 _y) pure internal returns (uint256) {
111         assert(_x >= _y);
112         return _x - _y;
113     }
114 
115     /**
116         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
117 
118         @param _x   factor 1
119         @param _y   factor 2
120 
121         @return product
122     */
123     function safeMul(uint256 _x, uint256 _y) pure internal returns (uint256) {
124         uint256 z = _x * _y;
125         assert(_x == 0 || z / _x == _y);
126         return z;
127     }
128 }
129 
130 //import './iERC20Token.sol';
131 // Token standard API
132 // https://github.com/ethereum/EIPs/issues/20
133 contract iERC20Token {
134   function balanceOf( address who ) public view returns (uint value);
135   function allowance( address owner, address spender ) public view returns (uint remaining);
136 
137   function transfer( address to, uint value) public returns (bool ok);
138   function transferFrom( address from, address to, uint value) public returns (bool ok);
139   function approve( address spender, uint value ) public returns (bool ok);
140 
141   event Transfer( address indexed from, address indexed to, uint value);
142   event Approval( address indexed owner, address indexed spender, uint value);
143 
144   //these are implimented via automatic getters
145   //function name() public view returns (string _name);
146   //function symbol() public view returns (string _symbol);
147   //function decimals() public view returns (uint8 _decimals);
148   //function totalSupply() public view returns (uint256 _totalSupply);
149 }
150 
151 //import './iDividendToken.sol';
152 // simple interface for withdrawing dividends
153 contract iDividendToken {
154   function checkDividends(address _addr) view public returns(uint _ethAmount);
155   function withdrawDividends() public returns (uint _amount);
156 }
157 
158 //import './iPlpPointsRedeemer.sol';
159 // interface for redeeming PLP Points
160 contract iPlpPointsRedeemer {
161   function reserveTokens() public view returns (uint remaining);
162   function transferFromReserve(address _to, uint _value) public;
163 }
164 
165 contract PirateLotteryProfitToken is iERC20Token, iDividendToken, iPlpPointsRedeemer, SafeMath {
166 
167   event PaymentEvent(address indexed from, uint amount);
168   event TransferEvent(address indexed from, address indexed to, uint amount);
169   event ApprovalEvent(address indexed from, address indexed to, uint amount);
170 
171   struct tokenHolder {
172     uint tokens;           // num tokens currently held in this acct, aka balance
173     uint currentPoints;    // updated before token balance changes, or before a withdrawal. credit for owning tokens
174     uint lastSnapshot;     // snapshot of global TotalPoints, last time we updated this acct's currentPoints
175   }
176 
177   bool    public isLocked;
178   uint8   public decimals;
179   string  public symbol;
180   string  public name;
181   address payable public owner;
182   address payable public reserve;            // reserve account
183   uint256 public  totalSupply;               // total token supply. never changes
184   uint256 public  holdoverBalance;           // funds received, but not yet distributed
185   uint256 public  totalReceived;
186 
187   mapping (address => mapping (address => uint)) approvals;  //transfer approvals, from -> to
188   mapping (address => tokenHolder) public tokenHolders;
189   mapping (address => bool) public trusted;
190 
191 
192   //
193   // modifiers
194   //
195   modifier ownerOnly {
196     require(msg.sender == owner, "owner only");
197     _;
198   }
199   modifier unlockedOnly {
200     require(!isLocked, "unlocked only");
201     _;
202   }
203   modifier notReserve {
204     require(msg.sender != reserve, "reserve is barred");
205     _;
206   }
207   modifier trustedOnly {
208     require(trusted[msg.sender] == true, "trusted only");
209     _;
210   }
211   //this is to protect from short-address attack. use this to verify size of args, especially when an address arg preceeds
212   //a value arg. see: https://www.reddit.com/r/ethereum/comments/63s917/worrysome_bug_exploit_with_erc20_token/dfwmhc3/
213   modifier onlyPayloadSize(uint256 size) {
214     assert(msg.data.length >= size + 4);
215     _;
216   }
217 
218   //
219   //constructor
220   //
221   constructor(uint256 _totalSupply, uint256 _reserveSupply, address payable _reserve, uint8 _decimals, string memory _name, string memory _symbol) public {
222     totalSupply = _totalSupply;
223     reserve = _reserve;
224     decimals = _decimals;
225     name = _name;
226     symbol = _symbol;
227     owner = msg.sender;
228     tokenHolders[reserve].tokens = _reserveSupply;
229     tokenHolders[owner].tokens = safeSub(totalSupply, _reserveSupply);
230   }
231 
232   function setTrust(address _trustedAddr, bool _trust) public ownerOnly unlockedOnly {
233     trusted[_trustedAddr] = _trust;
234   }
235 
236   function lock() public ownerOnly {
237     isLocked = true;
238   }
239 
240 
241   //
242   // ERC-20
243   //
244   function transfer(address _to, uint _value) public onlyPayloadSize(2*32) notReserve returns (bool success) {
245     if (tokenHolders[msg.sender].tokens >= _value) {
246       //first credit sender with points accrued so far.. must do this before number of held tokens changes
247       calcCurPointsForAcct(msg.sender);
248       tokenHolders[msg.sender].tokens = safeSub(tokenHolders[msg.sender].tokens, _value);
249       //if destination is a new tokenholder then we are setting his "last" snapshot to the current totalPoints
250       if (tokenHolders[_to].lastSnapshot == 0)
251         tokenHolders[_to].lastSnapshot = totalReceived;
252       //credit destination acct with points accrued so far.. must do this before number of held tokens changes
253       calcCurPointsForAcct(_to);
254       tokenHolders[_to].tokens = safeAdd(tokenHolders[_to].tokens, _value);
255       emit TransferEvent(msg.sender, _to, _value);
256       return true;
257     } else {
258       return false;
259     }
260   }
261 
262 
263   // transfer from reserve is prevented by preventing reserve from generating approval
264   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3*32) public returns (bool success) {
265     //prevent wrap:
266     if (tokenHolders[_from].tokens >= _value && approvals[_from][msg.sender] >= _value) {
267       //first credit source acct with points accrued so far.. must do this before number of held tokens changes
268       calcCurPointsForAcct(_from);
269       tokenHolders[_from].tokens = safeSub(tokenHolders[_from].tokens, _value);
270       //if destination is a new tokenreserve then we are setting his "last" snapshot to the current totalPoints
271       if (tokenHolders[_to].lastSnapshot == 0)
272         tokenHolders[_to].lastSnapshot = totalReceived;
273       //credit destination acct with points accrued so far.. must do this before number of held tokens changes
274       calcCurPointsForAcct(_to);
275       tokenHolders[_to].tokens = safeAdd(tokenHolders[_to].tokens, _value);
276       approvals[_from][msg.sender] = safeSub(approvals[_from][msg.sender], _value);
277       emit TransferEvent(_from, _to, _value);
278       return true;
279     } else {
280       return false;
281     }
282   }
283 
284 
285   function balanceOf(address _owner) public view returns (uint balance) {
286     balance = tokenHolders[_owner].tokens;
287   }
288 
289 
290   function approve(address _spender, uint _value) public onlyPayloadSize(2*32) notReserve returns (bool success) {
291     approvals[msg.sender][_spender] = _value;
292     emit ApprovalEvent(msg.sender, _spender, _value);
293     return true;
294   }
295 
296 
297   function allowance(address _owner, address _spender) public view returns (uint remaining) {
298     return approvals[_owner][_spender];
299   }
300 
301   //
302   // END ERC20
303   //
304 
305 
306   //
307   // iTransferPointsRedeemer
308   //
309   function reserveTokens() public view returns (uint remaining) {
310     return tokenHolders[reserve].tokens;
311   }
312 
313 
314   //
315   // transfer from reserve, initiated from a trusted partner-contract
316   //
317   function transferFromReserve(address _to, uint _value) onlyPayloadSize(2*32) public trustedOnly {
318     require(_value >= 10 || tokenHolders[reserve].tokens < 10, "minimum redmption is 10 tokens");
319     require(tokenHolders[reserve].tokens >= _value, "reserve has insufficient tokens");
320     //first credit source acct with points accrued so far.. must do this before number of held tokens changes
321     calcCurPointsForAcct(reserve);
322     tokenHolders[reserve].tokens = safeSub(tokenHolders[reserve].tokens, _value);
323     //if destination is a new tokenholder then we are setting his "last" snapshot to the current totalPoints
324     if (tokenHolders[_to].lastSnapshot == 0)
325       tokenHolders[_to].lastSnapshot = totalReceived;
326     //credit destination acct with points accrued so far.. must do this before number of held tokens changes
327     calcCurPointsForAcct(_to);
328     tokenHolders[_to].tokens = safeAdd(tokenHolders[_to].tokens, _value);
329     emit TransferEvent(reserve, _to, _value);
330   }
331 
332 
333   //
334   // calc current points for a token holder; that is, points that are due to this token holder for all dividends
335   // received by the contract during the current "period". the period began the last time this fcn was called, at which
336   // time we updated the account's snapshot of the running point count, totalReceived. during the period the account's
337   // number of tokens must not have changed. so always call this fcn before changing the number of tokens.
338   //
339   function calcCurPointsForAcct(address _acct) internal {
340     uint256 _newPoints = safeMul(safeSub(totalReceived, tokenHolders[_acct].lastSnapshot), tokenHolders[_acct].tokens);
341     tokenHolders[_acct].currentPoints = safeAdd(tokenHolders[_acct].currentPoints, _newPoints);
342     tokenHolders[_acct].lastSnapshot = totalReceived;
343   }
344 
345 
346   //
347   // default payable function. funds receieved here become dividends.
348   //
349   function () external payable {
350     holdoverBalance = safeAdd(holdoverBalance, msg.value);
351     totalReceived = safeAdd(totalReceived, msg.value);
352   }
353 
354 
355   //
356   // check my dividends
357   //
358   function checkDividends(address _addr) view public returns(uint _amount) {
359     //don't call calcCurPointsForAcct here, cuz this is a constant fcn
360     uint _currentPoints = tokenHolders[_addr].currentPoints +
361       ((totalReceived - tokenHolders[_addr].lastSnapshot) * tokenHolders[_addr].tokens);
362     _amount = _currentPoints / totalSupply;
363   }
364 
365 
366   //
367   // withdraw my dividends
368   //
369   function withdrawDividends() public returns (uint _amount) {
370     calcCurPointsForAcct(msg.sender);
371     _amount = tokenHolders[msg.sender].currentPoints / totalSupply;
372     uint _pointsUsed = safeMul(_amount, totalSupply);
373     tokenHolders[msg.sender].currentPoints = safeSub(tokenHolders[msg.sender].currentPoints, _pointsUsed);
374     holdoverBalance = safeSub(holdoverBalance, _amount);
375     msg.sender.transfer(_amount);
376   }
377 
378 
379   //only available before the contract is locked
380   function killContract() public ownerOnly unlockedOnly {
381     selfdestruct(owner);
382   }
383 
384 }