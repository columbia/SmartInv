1 pragma solidity 0.5.6;
2 
3 /**
4  *
5  * @author Alejandro Diaz <Alejandro.Diaz.666@protonmail.com>
6  *
7  * Overview:
8  * This is an implimentation of a multi-dividend-paying token. the token supports income/dividends
9  * of Eth and also Dai. A fixed number of tokens are minted in the constructor, and initially owned
10  * by the contract owner. Dividends are awarded token holders thusly:
11  *
12  *   previous_due + [ p(x) * t(x)/N ] + [ p(x+1) * t(x+1)/N ] + ...
13  *   where p(x) is the x'th income payment received by the contract
14  *         t(x) is the number of tokens held by the token-holder at the time of p(x)
15  *         N    is the total number of tokens, which never changes
16  *
17  * assume that t(x) takes on 3 values, t(a), t(b) and t(c), at times a, b, and c;
18  * and that there are multiple payments at times between a and b: x, x+1, x+2...
19  * and multiple payments at times between b and c: y, x+y, y+2...
20  * and multiple payments at times greater than c: z, z+y, z+2...
21  * then factoring:
22  *
23  *   current_due = { (t(a) * [p(x) + p(x+1)]) ... + (t(a) * [p(x) + p(y-1)]) ... +
24  *                   (t(b) * [p(y) + p(y+1)]) ... + (t(b) * [p(y) + p(z-1)]) ... +
25  *                   (t(c) * [p(z) + p(z+1)]) ... + (t(c) * [p(z) + p(now)]) } / N
26  *
27  * or
28  *
29  *   current_due = { (t(a) * period_a_income) +
30  *                   (t(b) * period_b_income) +
31  *                   (t(c) * period_c_income) } / N
32  *
33  * if we designate current_due * N as current-points, then
34  *
35  *   currentPoints = {  (t(a) * period_a_income) +
36  *                      (t(b) * period_b_income) +
37  *                      (t(c) * period_c_income) }
38  *
39  * or more succictly, if we recompute current points before a token-holder's number of
40  * tokens, T, is about to change:
41  *
42  *   currentPoints = previous_points + (T * current-period-income)
43  *
44  * when we want to do a payout, we'll calculate:
45  *  current_due = current-points / N
46  *
47  * we'll keep track of a token-holder's current-period-points, which is:
48  *   T * current-period-income
49  * by taking a snapshot of income collected exactly when the current period began; that is, the when the
50  * number of tokens last changed. that is, we keep a running count of total income received
51  *
52  *   totalIncomeReceived = p(x) + p(x+1) + p(x+2)
53  *
54  * (which happily is the same for all token holders) then, before any token holder changes their number of
55  * tokens we compute (for that token holder):
56  *
57  *  function calcCurPointsForAcct(acct) {
58  *    currentPoints[acct] += (totalIncomeReceived - lastSnapshot[acct]) * T[acct]
59  *    lastSnapshot[acct] = totalIncomeReceived
60  *  }
61  *
62  * in the withdraw fcn, all we need is:
63  *
64  *  function withdraw(acct) {
65  *    calcCurPointsForAcct(acct);
66  *    current_amount_due = currentPoints[acct] / N
67  *    currentPoints[acct] = 0;
68  *    send(current_amount_due);
69  *  }
70  *
71  */
72 //import './SafeMath.sol';
73 /*
74     Overflow protected math functions
75 */
76 contract SafeMath {
77     /**
78         constructor
79     */
80     constructor() public {
81     }
82 
83     /**
84         @dev returns the sum of _x and _y, asserts if the calculation overflows
85 
86         @param _x   value 1
87         @param _y   value 2
88 
89         @return sum
90     */
91     function safeAdd(uint256 _x, uint256 _y) pure internal returns (uint256) {
92         uint256 z = _x + _y;
93         assert(z >= _x);
94         return z;
95     }
96 
97     /**
98         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
99 
100         @param _x   minuend
101         @param _y   subtrahend
102 
103         @return difference
104     */
105     function safeSub(uint256 _x, uint256 _y) pure internal returns (uint256) {
106         assert(_x >= _y);
107         return _x - _y;
108     }
109 
110     /**
111         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
112 
113         @param _x   factor 1
114         @param _y   factor 2
115 
116         @return product
117     */
118     function safeMul(uint256 _x, uint256 _y) pure internal returns (uint256) {
119         uint256 z = _x * _y;
120         assert(_x == 0 || z / _x == _y);
121         return z;
122     }
123 }
124 
125 //import './iERC20Token.sol';
126 // Token standard API
127 // https://github.com/ethereum/EIPs/issues/20
128 contract iERC20Token {
129   function balanceOf( address who ) public view returns (uint value);
130   function allowance( address owner, address spender ) public view returns (uint remaining);
131   function transfer( address to, uint value) public returns (bool ok);
132   function transferFrom( address from, address to, uint value) public returns (bool ok);
133   function approve( address spender, uint value ) public returns (bool ok);
134   event Transfer( address indexed from, address indexed to, uint value);
135   event Approval( address indexed owner, address indexed spender, uint value);
136   //these are implimented via automatic getters
137   //function name() public view returns (string _name);
138   //function symbol() public view returns (string _symbol);
139   //function decimals() public view returns (uint8 _decimals);
140   //function totalSupply() public view returns (uint256 _totalSupply);
141 }
142 
143 //import './iDividendToken.sol';
144 // simple interface for withdrawing dividends
145 contract iDividendToken {
146   function checkDividends(address _addr) view public returns(uint _ethAmount, uint _daiAmount);
147   function withdrawEthDividends() public returns (uint _amount);
148   function withdrawDaiDividends() public returns (uint _amount);
149 }
150 
151 contract ETT is iERC20Token, iDividendToken, SafeMath {
152 
153   event Transfer(address indexed from, address indexed to, uint amount);
154   event Approval(address indexed from, address indexed to, uint amount);
155 
156   struct tokenHolder {
157     uint tokens;           // num tokens currently held in this acct, aka balance
158     uint currentEthPoints; // updated before token balance changes, or before a withdrawal. credit for owning tokens
159     uint lastEthSnapshot;  // snapshot of global TotalPoints (Eth), last time we updated this acct's currentEthPoints
160     uint currentDaiPoints; // updated before token balance changes, or before a withdrawal. credit for owning tokens
161     uint lastDaiSnapshot;  // snapshot of global TotalPoints (Dai), last time we updated this acct's currentDaiPoints
162   }
163 
164   bool    public isLocked;
165   uint8   public decimals;
166   address public daiToken;
167   string  public symbol;
168   string  public name;
169   uint public    totalSupply;                                       // total token supply. never changes
170   uint public    holdoverEthBalance;                                // funds received, but not yet distributed
171   uint public    totalEthReceived;
172   uint public    holdoverDaiBalance;                                // funds received, but not yet distributed
173   uint public    totalDaiReceived;
174 
175   mapping (address => mapping (address => uint)) private approvals; //transfer approvals, from -> to -> amount
176   mapping (address => tokenHolder) public tokenHolders;
177 
178 
179   //
180   //constructor
181   //
182   constructor(address _daiToken, uint256 _tokenSupply, uint8 _decimals, string memory _name, string memory _symbol) public {
183     daiToken = _daiToken;
184     totalSupply = _tokenSupply;
185     decimals = _decimals;
186     name = _name;
187     symbol = _symbol;
188     tokenHolders[msg.sender].tokens = totalSupply;
189     emit Transfer(address(0), msg.sender, totalSupply);
190   }
191 
192 
193   //
194   // ERC-20
195   //
196 
197 
198   //
199   // transfer tokens to a specified address
200   // @param to the address to transfer to.
201   // @param value the amount to be transferred.
202   // checks for overflow, sufficient tokens to xfer are in internal _transfer fcn
203   //
204   function transfer(address _to, uint _value) public returns (bool success) {
205     _transfer(msg.sender, _to, _value);
206     return true;
207   }
208 
209 
210   //
211   // transfer tokens from one address to another.
212   // note that while this function emits an Approval event, this is not required as per the specification,
213   // and other compliant implementations may not emit the event.
214   // @param from address the address which you want to send tokens from
215   // @param to address the address which you want to transfer to
216   // @param value uint256 the amount of tokens to be transferred
217   // checks for overflow, sufficient tokens to xfer are in internal _transfer fcn
218   // check for sufficient approval in in the safeSub
219   //
220   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
221     _transfer(_from, _to, _value);
222     _approve(_from, msg.sender, safeSub(approvals[_from][msg.sender], _value));
223     return true;
224   }
225 
226 
227   //
228   // internal fcn to execute a transfer. no check/modification of approval here
229   // wrap of token balances is prevented in safe{Add,Sub}
230   //
231   function _transfer(address _from, address _to, uint _value) internal {
232     require(_to != address(0));
233     //first credit source acct with points accrued so far.. must do this before number of held tokens changes
234     calcCurPointsForAcct(_from);
235     tokenHolders[_from].tokens = safeSub(tokenHolders[_from].tokens, _value);
236     //if destination is a new tokenholder then we are setting his "last" snapshot to the current totalPoints
237     if (tokenHolders[_to].lastEthSnapshot == 0)
238       tokenHolders[_to].lastEthSnapshot = totalEthReceived;
239     if (tokenHolders[_to].lastDaiSnapshot == 0)
240       tokenHolders[_to].lastDaiSnapshot = totalDaiReceived;
241     //credit destination acct with points accrued so far.. must do this before number of held tokens changes
242     calcCurPointsForAcct(_to);
243     tokenHolders[_to].tokens = safeAdd(tokenHolders[_to].tokens, _value);
244     emit Transfer(_from, _to, _value);
245   }
246 
247 
248   function balanceOf(address _owner) public view returns (uint balance) {
249     balance = tokenHolders[_owner].tokens;
250   }
251 
252 
253   //
254   // approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
255   // beware that changing an allowance with this method brings the risk that someone may use both the old
256   // and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
257   // race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
258   // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
259   // @param _spender the address which will spend the funds.
260   // @param _value the amount of tokens to be spent.
261   //
262   function approve(address _spender, uint256 _value) public returns (bool) {
263     _approve(msg.sender, _spender, _value);
264     return true;
265   }
266 
267 
268   //
269   // increase the amount of tokens that an owner allows to a spender.
270   // approve should be called when allowed[msg.sender][spender] == 0. to increment
271   // allowed value it is better to use this function to avoid 2 calls (and wait until
272   // the first transaction is mined)
273   // Emits an Approval event.
274   // @param _spender the address which will spend the funds.
275   // @param _addedValue the amount of tokens to increase the allowance by.
276   //
277   function increaseAllowance(address _spender, uint256 _addedValue) public returns (bool) {
278     _approve(msg.sender, _spender, safeAdd(approvals[msg.sender][_spender], _addedValue));
279     return true;
280   }
281 
282   /**
283    * decrease the amount of tokens that an owner allows to a spender.
284    * approve should be called when allowed[msg.sender][spender] == 0. to decrement
285    * allowed value it is better to use this function to avoid 2 calls (and wait until
286    * the first transaction is mined)
287    * from MonolithDAO Token.sol
288    * emits an Approval event.
289    * @param _spender the address which will spend the funds.
290    * @param _subtractedValue the amount of tokens to decrease the allowance by.
291    */
292   function decreaseAllowance(address _spender, uint256 _subtractedValue) public returns (bool) {
293     _approve(msg.sender, _spender, safeSub(approvals[msg.sender][_spender], _subtractedValue));
294     return true;
295   }
296 
297 
298   /*
299    * @dev internal fcn to approve an address to spend another addresses' tokens.
300    * @param _owner the address that owns the tokens.
301    * @param _spender the address that will spend the tokens.
302    * @param _value the number of tokens that can be spent.
303    */
304   function _approve(address _owner, address _spender, uint _value) internal {
305     require(_owner != address(0));
306     require(_spender != address(0));
307     approvals[_owner][_spender] = _value;
308     emit Approval(_owner, _spender, _value);
309   }
310 
311 
312   function allowance(address _owner, address _spender) public view returns (uint remaining) {
313     return approvals[_owner][_spender];
314   }
315 
316   //
317   // END ERC20
318   //
319 
320   //
321   // calc current points for a token holder; that is, points that are due to this token holder for all dividends
322   // received by the contract during the current "period". the period began the last time this fcn was called, at which
323   // time we updated the account's snapshot of the running point count, totalEthReceived. during the period the account's
324   // number of tokens must not have changed. so always call this fcn before changing the number of tokens.
325   //
326   function calcCurPointsForAcct(address _acct) internal {
327     uint256 _newEthPoints = safeMul(safeSub(totalEthReceived, tokenHolders[_acct].lastEthSnapshot), tokenHolders[_acct].tokens);
328     tokenHolders[_acct].currentEthPoints = safeAdd(tokenHolders[_acct].currentEthPoints, _newEthPoints);
329     tokenHolders[_acct].lastEthSnapshot = totalEthReceived;
330     uint256 _newDaiPoints = safeMul(safeSub(totalDaiReceived, tokenHolders[_acct].lastDaiSnapshot), tokenHolders[_acct].tokens);
331     tokenHolders[_acct].currentDaiPoints = safeAdd(tokenHolders[_acct].currentDaiPoints, _newDaiPoints);
332     tokenHolders[_acct].lastDaiSnapshot = totalDaiReceived;
333   }
334 
335 
336   //
337   // default payable function. funds receieved here become dividends.
338   //
339   function () external payable {
340     holdoverEthBalance = safeAdd(holdoverEthBalance, msg.value);
341     totalEthReceived = safeAdd(totalEthReceived, msg.value);
342   }
343 
344 
345   //
346   // this payable function is for payment in Dai
347   // caller must have already approved the Dai transfer
348   //
349   function payDai(uint256 _daiAmount) external {
350     require(iERC20Token(daiToken).transferFrom(msg.sender, address(this), _daiAmount), "failed to transfer dai");
351     holdoverDaiBalance = safeAdd(holdoverDaiBalance, _daiAmount);
352     totalDaiReceived = safeAdd(totalDaiReceived, _daiAmount);
353   }
354 
355 
356   //
357   // updateDaiBalance
358   // update the dia holdover balance, in case someone transfers dai directly
359   // to the contract. anyone can call this.
360   //
361   function updateDaiBalance() public {
362     uint256 _actBalance = iERC20Token(daiToken).balanceOf(address(this));
363     uint256 _daiAmount = safeSub(_actBalance, holdoverDaiBalance);
364     holdoverDaiBalance = safeAdd(holdoverDaiBalance, _daiAmount);
365     totalDaiReceived = safeAdd(totalDaiReceived, _daiAmount);
366   }
367 
368 
369   //
370   // check my dividends
371   //
372   function checkDividends(address _addr) view public returns(uint _ethAmount, uint _daiAmount) {
373     //don't call calcCurPointsForAcct here, cuz this is a constant fcn
374     uint _currentEthPoints = tokenHolders[_addr].currentEthPoints +
375       ((totalEthReceived - tokenHolders[_addr].lastEthSnapshot) * tokenHolders[_addr].tokens);
376     _ethAmount = _currentEthPoints / totalSupply;
377     uint _currentDaiPoints = tokenHolders[_addr].currentDaiPoints +
378       ((totalDaiReceived - tokenHolders[_addr].lastDaiSnapshot) * tokenHolders[_addr].tokens);
379     _daiAmount = _currentDaiPoints / totalSupply;
380   }
381 
382 
383   //
384   // withdraw my dividends
385   //
386   function withdrawEthDividends() public returns (uint _amount) {
387     calcCurPointsForAcct(msg.sender);
388     _amount = tokenHolders[msg.sender].currentEthPoints / totalSupply;
389     uint _pointsUsed = safeMul(_amount, totalSupply);
390     tokenHolders[msg.sender].currentEthPoints = safeSub(tokenHolders[msg.sender].currentEthPoints, _pointsUsed);
391     holdoverEthBalance = safeSub(holdoverEthBalance, _amount);
392     msg.sender.transfer(_amount);
393   }
394 
395   function withdrawDaiDividends() public returns (uint _amount) {
396     calcCurPointsForAcct(msg.sender);
397     _amount = tokenHolders[msg.sender].currentDaiPoints / totalSupply;
398     uint _pointsUsed = safeMul(_amount, totalSupply);
399     tokenHolders[msg.sender].currentDaiPoints = safeSub(tokenHolders[msg.sender].currentDaiPoints, _pointsUsed);
400     holdoverDaiBalance = safeSub(holdoverDaiBalance, _amount);
401     require(iERC20Token(daiToken).transfer(msg.sender, _amount), "failed to transfer dai");
402   }
403 
404 
405 }