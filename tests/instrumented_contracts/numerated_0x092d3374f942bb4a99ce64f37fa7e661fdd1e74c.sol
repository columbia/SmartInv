1 pragma solidity ^0.4.17;
2 
3 //Developed by Zenos Pavlakou
4 
5 library SafeMath {
6     
7     function mul(uint256 a, uint256 b) internal pure  returns (uint256) {
8         uint256 c = a * b;
9         assert(a == 0 || c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a / b;
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 
31 contract Ownable {
32     
33     address public owner;
34 
35     /**
36      * The address whcih deploys this contrcat is automatically assgined ownership.
37      * */
38     function Ownable() public {
39         owner = msg.sender;
40     }
41 
42     /**
43      * Functions with this modifier can only be executed by the owner of the contract. 
44      * */
45     modifier onlyOwner {
46         require(msg.sender == owner);
47         _;
48     }
49 }
50 
51 
52 contract ERC20Basic {
53     uint256 public totalSupply;
54     function balanceOf(address who) constant public returns (uint256);
55     function transfer(address to, uint256 value) public returns (bool);
56     event Transfer(address indexed from, address indexed to, uint256 value);
57 }
58 
59 
60 contract ERC20 is ERC20Basic {
61     function allowance(address owner, address spender) constant public returns (uint256);
62     function transferFrom(address from, address to, uint256 value) public  returns (bool);
63     function approve(address spender, uint256 value) public returns (bool);
64     event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 
68 contract BasicToken is ERC20Basic, Ownable {
69 
70     using SafeMath for uint256;
71 
72     mapping (address => uint256) balances;
73 
74     modifier onlyPayloadSize(uint size) {
75         if (msg.data.length < size + 4) {
76         revert();
77         }
78         _;
79     }
80 
81     /**
82      * Transfers ACO tokens from the sender's account to another given account.
83      * 
84      * @param _to The address of the recipient.
85      * @param _amount The amount of tokens to send.
86      * */
87     function transfer(address _to, uint256 _amount) public onlyPayloadSize(2 * 32) returns (bool) {
88         require(balances[msg.sender] >= _amount);
89         balances[msg.sender] = balances[msg.sender].sub(_amount);
90         balances[_to] = balances[_to].add(_amount);
91         Transfer(msg.sender, _to, _amount);
92         return true;
93     }
94 
95     /**
96      * Returns the balance of a given address.
97      * 
98      * @param _addr The address of the balance to query.
99      **/
100     function balanceOf(address _addr) public constant returns (uint256) {
101         return balances[_addr];
102     }
103 }
104 
105 
106 contract AdvancedToken is BasicToken, ERC20 {
107 
108     mapping (address => mapping (address => uint256)) allowances;
109 
110     /**
111      * Transfers tokens from the account of the owner by an approved spender. 
112      * The spender cannot spend more than the approved amount. 
113      * 
114      * @param _from The address of the owners account.
115      * @param _amount The amount of tokens to transfer.
116      * */
117     function transferFrom(address _from, address _to, uint256 _amount) public onlyPayloadSize(3 * 32) returns (bool) {
118         require(allowances[_from][msg.sender] >= _amount && balances[_from] >= _amount);
119         allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_amount);
120         balances[_from] = balances[_from].sub(_amount);
121         balances[_to] = balances[_to].add(_amount);
122         Transfer(_from, _to, _amount);
123         return true;
124     }
125 
126     /**
127      * Allows another account to spend a given amount of tokens on behalf of the 
128      * owner's account. If the owner has previously allowed a spender to spend
129      * tokens on his or her behalf and would like to change the approval amount,
130      * he or she will first have to set the allowance back to 0 and then update
131      * the allowance.
132      * 
133      * @param _spender The address of the spenders account.
134      * @param _amount The amount of tokens the spender is allowed to spend.
135      * */
136     function approve(address _spender, uint256 _amount) public returns (bool) {
137         require((_amount == 0) || (allowances[msg.sender][_spender] == 0));
138         allowances[msg.sender][_spender] = _amount;
139         Approval(msg.sender, _spender, _amount);
140         return true;
141     }
142 
143 
144     /**
145      * Returns the approved allowance from an owners account to a spenders account.
146      * 
147      * @param _owner The address of the owners account.
148      * @param _spender The address of the spenders account.
149      **/
150     function allowance(address _owner, address _spender) public constant returns (uint256) {
151         return allowances[_owner][_spender];
152     }
153 }
154 
155 
156 contract MintableToken is AdvancedToken {
157 
158     bool public mintingFinished;
159 
160     event TokensMinted(address indexed to, uint256 amount);
161     event MintingFinished();
162 
163     /**
164      * Generates new ACO tokens during the ICO, after which the minting period 
165      * will terminate permenantly. This function can only be called by the ICO 
166      * contract.
167      * 
168      * @param _to The address of the account to mint new tokens to.
169      * @param _amount The amount of tokens to mint. 
170      * */
171     function mint(address _to, uint256 _amount) external onlyOwner onlyPayloadSize(2 * 32) returns (bool) {
172         require(_to != 0x0 && _amount > 0 && !mintingFinished);
173         balances[_to] = balances[_to].add(_amount);
174         totalSupply = totalSupply.add(_amount);
175         Transfer(0x0, _to, _amount);
176         TokensMinted(_to, _amount);
177         return true;
178     }
179 
180     /**
181      * Terminates the minting period permenantly. This function can only be called
182      * by the ICO contract only when the duration of the ICO has ended. 
183      * */
184     function finishMinting() external onlyOwner {
185         require(!mintingFinished);
186         mintingFinished = true;
187         MintingFinished();
188     }
189     
190     /**
191      * Returns true if the minting period has ended, false otherwhise.
192      * */
193     function mintingFinished() public constant returns (bool) {
194         return mintingFinished;
195     }
196 }
197 
198 
199 contract ACO is MintableToken {
200 
201     uint8 public decimals;
202     string public name;
203     string public symbol;
204 
205     function ACO() public {
206         totalSupply = 0;
207         decimals = 18;
208         name = "ACO";
209         symbol = "ACO";
210     }
211 }
212 
213 
214 contract MultiOwnable {
215     
216     address[2] public owners;
217 
218     event OwnershipTransferred(address from, address to);
219     event OwnershipGranted(address to);
220 
221     function MultiOwnable() public {
222         owners[0] = 0x1d554c421182a94E2f4cBD833f24682BBe1eeFe8; //R1
223         owners[1] = 0x0D7a2716466332Fc5a256FF0d20555A44c099453; //R2
224     }
225 
226     /**
227      * Functions with this modifier will only execute if the the function is called by the 
228      * owners of the contract.
229      * */ 
230     modifier onlyOwners {
231         require(msg.sender == owners[0] || msg.sender == owners[1]);
232         _;
233     }
234 
235     /**
236      * Trasfers ownership from the owner who executes the function to another given address.
237      * 
238      * @param _newOwner The address which will be granted ownership.
239      * */
240     function transferOwnership(address _newOwner) public onlyOwners {
241         require(_newOwner != 0x0 && _newOwner != owners[0] && _newOwner != owners[1]);
242         if (msg.sender == owners[0]) {
243             OwnershipTransferred(owners[0], _newOwner);
244             owners[0] = _newOwner;
245         } else {
246             OwnershipTransferred(owners[1], _newOwner);
247             owners[1] = _newOwner;
248         }
249     }
250 }
251 
252 
253 contract Crowdsale is MultiOwnable {
254 
255     using SafeMath for uint256;
256 
257     ACO public ACO_Token;
258 
259     address public constant MULTI_SIG = 0x3Ee28dA5eFe653402C5192054064F12a42EA709e;
260 
261     bool public success;
262     uint256 public rate;
263     uint256 public rateWithBonus;
264     uint256 public tokensSold;
265     uint256 public startTime;
266     uint256 public endTime;
267     uint256 public minimumGoal;
268     uint256 public cap;
269     uint256[4] private bonusStages;
270 
271     mapping (address => uint256) investments;
272     mapping (address => bool) hasAuthorizedWithdrawal;
273 
274     event TokensPurchased(address indexed by, uint256 amount);
275     event RefundIssued(address indexed by, uint256 amount);
276     event FundsWithdrawn(address indexed by, uint256 amount);
277     event IcoSuccess();
278     event CapReached();
279 
280     function Crowdsale() public {
281         ACO_Token = new ACO();
282         minimumGoal = 3000 ether;
283         cap = 87500 ether;
284         rate = 4000;
285         startTime = now.add(3 days);
286         endTime = startTime.add(90 days);
287         bonusStages[0] = startTime.add(14 days);
288 
289         for (uint i = 1; i < bonusStages.length; i++) {
290             bonusStages[i] = bonusStages[i - 1].add(14 days);
291         }
292     }
293 
294     /**
295      * Fallback function calls the buyTokens function when ETH is sent to this 
296      * contact.
297      * */
298     function() public payable {
299         buyTokens(msg.sender);
300     }
301 
302     /**
303      * Allows investors to buy ACO tokens. Once ETH is sent to this contract, 
304      * the investor will automatically receive tokens. 
305      * 
306      * @param _beneficiary The address the newly minted tokens will be sent to.
307      * */
308     function buyTokens(address _beneficiary) public payable {
309         require(_beneficiary != 0x0 && validPurchase() && weiRaised().sub(msg.value) < cap);
310         if (this.balance >= minimumGoal && !success) {
311             success = true;
312             IcoSuccess();
313         }
314         uint256 weiAmount = msg.value;
315         if (this.balance > cap) {
316             CapReached();
317             uint256 toRefund = this.balance.sub(cap);
318             msg.sender.transfer(toRefund);
319             weiAmount = weiAmount.sub(toRefund);
320         }
321         uint256 tokens = weiAmount.mul(getCurrentRateWithBonus());
322         ACO_Token.mint(_beneficiary, tokens);
323         tokensSold = tokensSold.add(tokens);
324         investments[_beneficiary] = investments[_beneficiary].add(weiAmount);
325         TokensPurchased(_beneficiary, tokens);
326     }
327 
328     /**
329      * Returns the amount of tokens 1 ETH equates to with the bonus percentage.
330      * */
331     function getCurrentRateWithBonus() public returns (uint256) {
332         rateWithBonus = (rate.mul(getBonusPercentage()).div(100)).add(rate);
333         return rateWithBonus;
334     }
335 
336     /**
337      * Calculates and returns the bonus percentage based on how early an investment
338      * is made. If ETH is sent to the contract after the bonus period, the bonus 
339      * percentage will default to 0
340      * */
341     function getBonusPercentage() internal view returns (uint256 bonusPercentage) {
342         uint256 timeStamp = now;
343         if (timeStamp > bonusStages[3]) {
344             bonusPercentage = 0;
345         } else { 
346             bonusPercentage = 25;
347             for (uint i = 0; i < bonusStages.length; i++) {
348                 if (timeStamp <= bonusStages[i]) {
349                     break;
350                 } else {
351                     bonusPercentage = bonusPercentage.sub(5);
352                 }
353             }
354         }
355         return bonusPercentage;
356     }
357 
358     /**
359      * Returns the current rate 1 ETH equates to including the bonus amount. 
360      * */
361     function currentRate() public constant returns (uint256) {
362         return rateWithBonus;
363     }
364 
365     /**
366      * Checks whether an incoming transaction from the buyTokens function is 
367      * valid or not. For a purchase to be valid, investors have to buy tokens
368      * only during the ICO period and the value being transferred must be greater
369      * than 0.
370      * */
371     function validPurchase() internal constant returns (bool) {
372         bool withinPeriod = now >= startTime && now <= endTime;
373         bool nonZeroPurchase = msg.value != 0;
374         return withinPeriod && nonZeroPurchase;
375     }
376     
377     /**
378      * Issues a refund to a given address. This function can only be called if
379      * the duration of the ICO has ended and the minimum goal has not been reached.
380      * 
381      * @param _addr The address that will receive a refund. 
382      * */
383     function getRefund(address _addr) public {
384         if (_addr == 0x0) {
385             _addr = msg.sender;
386         }
387         require(!isSuccess() && hasEnded() && investments[_addr] > 0);
388         uint256 toRefund = investments[_addr];
389         investments[_addr] = 0;
390         _addr.transfer(toRefund);
391         RefundIssued(_addr, toRefund);
392     }
393 
394     /**
395      * This function can only be called by the onwers of the ICO contract. There 
396      * needs to be 2 approvals, one from each owner. Once two approvals have been 
397      * made, the funds raised will be sent to a multi signature wallet. This 
398      * function cannot be called if the ICO is not a success.
399      * */
400     function authorizeWithdrawal() public onlyOwners {
401         require(hasEnded() && isSuccess() && !hasAuthorizedWithdrawal[msg.sender]);
402         hasAuthorizedWithdrawal[msg.sender] = true;
403         if (hasAuthorizedWithdrawal[owners[0]] && hasAuthorizedWithdrawal[owners[1]]) {
404             FundsWithdrawn(owners[0], this.balance);
405             MULTI_SIG.transfer(this.balance);
406         }
407     }
408     
409     /**
410      * Generates newly minted ACO tokens and sends them to a given address. This 
411      * function can only be called by the owners of the ICO contract during the 
412      * minting period.
413      * 
414      * @param _to The address to mint new tokens to.
415      * @param _amount The amount of tokens to mint.
416      * */
417     function issueBounty(address _to, uint256 _amount) public onlyOwners {
418         require(_to != 0x0 && _amount > 0);
419         ACO_Token.mint(_to, _amount);
420     }
421     
422     /**
423      * Terminates the minting period permanently. This function can only be 
424      * executed by the owners of the ICO contract. 
425      * */
426     function finishMinting() public onlyOwners {
427         require(hasEnded());
428         ACO_Token.finishMinting();
429     }
430 
431     /**
432      * Returns the minimum goal of the ICO.
433      * */
434     function minimumGoal() public constant returns (uint256) {
435         return minimumGoal;
436     }
437 
438     /**
439      * Returns the maximum amount of funds the ICO can receive.
440      * */
441     function cap() public constant returns (uint256) {
442         return cap;
443     }
444 
445     /**
446      * Returns the time that the ICO duration will end.
447      * */
448     function endTime() public constant returns (uint256) {
449         return endTime;
450     }
451 
452     /**
453      * Returns the amount of ETH a given address has invested.
454      * 
455      * @param _addr The address to query the investment of. 
456      * */
457     function investmentOf(address _addr) public constant returns (uint256) {
458         return investments[_addr];
459     }
460 
461     /**
462      * Returns true if the duration of the ICO is over.
463      * */
464     function hasEnded() public constant returns (bool) {
465         return now > endTime;
466     }
467 
468     /**
469      * Returns true if the ICO is a success.
470      * */
471     function isSuccess() public constant returns (bool) {
472         return success;
473     }
474 
475     /**
476      * Returns the amount of ETH raised in wei.
477      * */
478     function weiRaised() public constant returns (uint256) {
479         return this.balance;
480     }
481 }