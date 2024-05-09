1 pragma solidity 0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
5         if(a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns(uint256) {
14         uint256 c = a / b;
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns(uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 contract Ownable {
31     address public owner;
32 
33     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35     modifier onlyOwner() { require(msg.sender == owner); _; }
36 
37     function Ownable() public {
38         owner = msg.sender;
39     }
40 
41     function transferOwnership(address newOwner) public onlyOwner {
42         require(newOwner != address(0));
43         owner = newOwner;
44         OwnershipTransferred(owner, newOwner);
45     }
46 }
47 
48 contract Pausable is Ownable {
49     bool public paused = false;
50 
51     event Pause();
52     event Unpause();
53 
54     modifier whenNotPaused() { require(!paused); _; }
55     modifier whenPaused() { require(paused); _; }
56 
57     function pause() onlyOwner whenNotPaused public {
58         paused = true;
59         Pause();
60     }
61 
62     function unpause() onlyOwner whenPaused public {
63         paused = false;
64         Unpause();
65     }
66 }
67 
68 contract ERC20 {
69     uint256 public totalSupply;
70 
71     event Transfer(address indexed from, address indexed to, uint256 value);
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 
74     function balanceOf(address who) public view returns(uint256);
75     function transfer(address to, uint256 value) public returns(bool);
76     function transferFrom(address from, address to, uint256 value) public returns(bool);
77     function allowance(address owner, address spender) public view returns(uint256);
78     function approve(address spender, uint256 value) public returns(bool);
79 }
80 
81 contract StandardToken is ERC20 {
82     using SafeMath for uint256;
83 
84     string public name;
85     string public symbol;
86     uint8 public decimals;
87 
88     mapping(address => uint256) balances;
89     mapping (address => mapping (address => uint256)) internal allowed;
90 
91     function StandardToken(string _name, string _symbol, uint8 _decimals) public {
92         name = _name;
93         symbol = _symbol;
94         decimals = _decimals;
95     }
96 
97     function balanceOf(address _owner) public view returns(uint256 balance) {
98         return balances[_owner];
99     }
100 
101     function transfer(address _to, uint256 _value) public returns(bool) {
102         require(_to != address(0));
103         require(_value <= balances[msg.sender]);
104 
105         balances[msg.sender] = balances[msg.sender].sub(_value);
106         balances[_to] = balances[_to].add(_value);
107 
108         Transfer(msg.sender, _to, _value);
109 
110         return true;
111     }
112     
113     function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {
114         require(_to.length == _value.length);
115 
116         for(uint i = 0; i < _to.length; i++) {
117             transfer(_to[i], _value[i]);
118         }
119 
120         return true;
121     }
122 
123     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
124         require(_to != address(0));
125         require(_value <= balances[_from]);
126         require(_value <= allowed[_from][msg.sender]);
127 
128         balances[_from] = balances[_from].sub(_value);
129         balances[_to] = balances[_to].add(_value);
130         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
131 
132         Transfer(_from, _to, _value);
133 
134         return true;
135     }
136 
137     function allowance(address _owner, address _spender) public view returns(uint256) {
138         return allowed[_owner][_spender];
139     }
140 
141     function approve(address _spender, uint256 _value) public returns(bool) {
142         allowed[msg.sender][_spender] = _value;
143 
144         Approval(msg.sender, _spender, _value);
145 
146         return true;
147     }
148 
149     function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
150         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
151 
152         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
153 
154         return true;
155     }
156 
157     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
158         uint oldValue = allowed[msg.sender][_spender];
159 
160         if(_subtractedValue > oldValue) {
161             allowed[msg.sender][_spender] = 0;
162         } else {
163             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
164         }
165 
166         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
167 
168         return true;
169     }
170 }
171 
172 contract MintableToken is StandardToken, Ownable {
173     event Mint(address indexed to, uint256 amount);
174     event MintFinished();
175 
176     bool public mintingFinished = false;
177 
178     modifier canMint() { require(!mintingFinished); _; }
179     modifier notMint() { require(mintingFinished); _; }
180 
181     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
182         totalSupply = totalSupply.add(_amount);
183         balances[_to] = balances[_to].add(_amount);
184 
185         Mint(_to, _amount);
186         Transfer(address(0), _to, _amount);
187 
188         return true;
189     }
190 
191     function finishMinting() onlyOwner canMint public returns(bool) {
192         mintingFinished = true;
193 
194         MintFinished();
195 
196         return true;
197     }
198 }
199 
200 contract CappedToken is MintableToken {
201     uint256 public cap;
202 
203     function CappedToken(uint256 _cap) public {
204         require(_cap > 0);
205         cap = _cap;
206     }
207 
208     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
209         require(totalSupply.add(_amount) <= cap);
210 
211         return super.mint(_to, _amount);
212     }
213 }
214 
215 contract BurnableToken is StandardToken {
216     event Burn(address indexed burner, uint256 value);
217 
218     function burn(uint256 _value) public {
219         require(_value <= balances[msg.sender]);
220 
221         address burner = msg.sender;
222 
223         balances[burner] = balances[burner].sub(_value);
224         totalSupply = totalSupply.sub(_value);
225 
226         Burn(burner, _value);
227     }
228 }
229 
230 /*
231 
232 ICO Gap
233 
234     - Crowdsale goes in 4 steps:
235     - 1st step PreSale 0: the administrator can issue tokens; purchase and sale are closed; Max. tokens 5 000 000
236     - 2nd step PreSale 1: the administrator can not issue tokens; the sale is open; purchase is closed; Max. tokens 5 000 000 + 10 000 000
237     - The third step of PreSale 2: the administrator can not issue tokens; the sale is open; purchase is closed; Max. tokens 5 000 000 + 10 000 000 + 15 000 000
238     - 4th step ICO: administrator can not issue tokens; the sale is open; the purchase is open; Max. tokens 5 000 000 + 10 000 000 + 15 000 000 + 30 000 000
239 
240     Addition:
241     - Total emissions are limited: 100,000,000 tokens
242     - at each step it is possible to change the price of the token
243     - the steps are not limited in time and the step change is made by the nextStep administrator
244     - funds are accumulated on a contract basis
245     - at any time closeCrowdsale can be called: the funds and management of the token are transferred to the beneficiary; the release of + 65% of tokens to the beneficiary; minting closes
246     - at any time, refundCrowdsale can be called: funds remain on the contract; withdraw becomes unavailable; there is an opportunity to get refund 
247     - transfer of tokens before closeCrowdsale is unavailable
248     - you can buy no more than 500 000 tokens for 1 purse.
249 */
250 
251 contract Token is CappedToken, BurnableToken {
252     function Token() CappedToken(100000000 * 1 ether) StandardToken("GAP Token", "GAP", 18) public {
253         
254     }
255     
256     function transfer(address _to, uint256 _value) notMint public returns(bool) {
257         return super.transfer(_to, _value);
258     }
259     
260     function multiTransfer(address[] _to, uint256[] _value) notMint public returns(bool) {
261         return super.multiTransfer(_to, _value);
262     }
263 
264     function transferFrom(address _from, address _to, uint256 _value) notMint public returns(bool) {
265         return super.transferFrom(_from, _to, _value);
266     }
267 
268     function burnOwner(address _from, uint256 _value) onlyOwner canMint public {
269         require(_value <= balances[_from]);
270 
271         balances[_from] = balances[_from].sub(_value);
272         totalSupply = totalSupply.sub(_value);
273 
274         Burn(_from, _value);
275     }
276 }
277 
278 contract Crowdsale is Pausable {
279     using SafeMath for uint;
280 
281     struct Step {
282         uint priceTokenWei;
283         uint tokensForSale;
284         uint tokensSold;
285         uint collectedWei;
286 
287         bool purchase;
288         bool issue;
289         bool sale;
290     }
291 
292     Token public token;
293     address public beneficiary = 0x4B97b2938844A775538eF0b75F08648C4BD6fFFA;
294 
295     Step[] public steps;
296     uint8 public currentStep = 0;
297 
298     bool public crowdsaleClosed = false;
299     bool public crowdsaleRefund = false;
300     uint public refundedWei;
301 
302     mapping(address => uint256) public canSell;
303     mapping(address => uint256) public purchaseBalances; 
304 
305     event Purchase(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
306     event Sell(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
307     event Issue(address indexed holder, uint256 tokenAmount);
308     event Refund(address indexed holder, uint256 etherAmount);
309     event NextStep(uint8 step);
310     event CrowdsaleClose();
311     event CrowdsaleRefund();
312 
313     function Crowdsale() public {
314         token = new Token();
315 
316         steps.push(Step(1 ether / 1000, 5000000 * 1 ether, 0, 0, false, true, false));
317         steps.push(Step(1 ether / 1000, 10000000 * 1 ether, 0, 0, true, false, false));
318         steps.push(Step(1 ether / 500, 15000000 * 1 ether, 0, 0, true, false, false));
319         steps.push(Step(1 ether / 100, 30000000 * 1 ether, 0, 0, true, false, true));
320     }
321 
322     function() payable public {
323         purchase();
324     }
325 
326     function setTokenRate(uint _value) onlyOwner whenPaused public {
327         require(!crowdsaleClosed);
328         steps[currentStep].priceTokenWei = 1 ether / _value;
329     }
330     
331     function purchase() whenNotPaused payable public {
332         require(!crowdsaleClosed);
333         require(msg.value >= 0.001 ether);
334 
335         Step memory step = steps[currentStep];
336 
337         require(step.purchase);
338         require(step.tokensSold < step.tokensForSale);
339         require(token.balanceOf(msg.sender) < 500000 ether);
340 
341         uint sum = msg.value;
342         uint amount = sum.mul(1 ether).div(step.priceTokenWei);
343         uint retSum = 0;
344         uint retAmount;
345         
346         if(step.tokensSold.add(amount) > step.tokensForSale) {
347             retAmount = step.tokensSold.add(amount).sub(step.tokensForSale);
348             retSum = retAmount.mul(step.priceTokenWei).div(1 ether);
349 
350             amount = amount.sub(retAmount);
351             sum = sum.sub(retSum);
352         }
353 
354         if(token.balanceOf(msg.sender).add(amount) > 500000 ether) {
355             retAmount = token.balanceOf(msg.sender).add(amount).sub(500000 ether);
356             retSum = retAmount.mul(step.priceTokenWei).div(1 ether);
357 
358             amount = amount.sub(retAmount);
359             sum = sum.sub(retSum);
360         }
361 
362         steps[currentStep].tokensSold = step.tokensSold.add(amount);
363         steps[currentStep].collectedWei = step.collectedWei.add(sum);
364         purchaseBalances[msg.sender] = purchaseBalances[msg.sender].add(sum);
365 
366         token.mint(msg.sender, amount);
367 
368         if(retSum > 0) {
369             msg.sender.transfer(retSum);
370         }
371 
372         Purchase(msg.sender, amount, sum);
373     }
374 
375     function issue(address _to, uint256 _value) onlyOwner whenNotPaused public {
376         require(!crowdsaleClosed);
377 
378         Step memory step = steps[currentStep];
379         
380         require(step.issue);
381         require(step.tokensSold.add(_value) <= step.tokensForSale);
382 
383         steps[currentStep].tokensSold = step.tokensSold.add(_value);
384         canSell[_to] = canSell[_to].add(_value).div(100).mul(20);
385 
386         token.mint(_to, _value);
387 
388         Issue(_to, _value);
389     }
390 
391     function sell(uint256 _value) whenNotPaused public {
392         require(!crowdsaleClosed);
393 
394         require(canSell[msg.sender] >= _value);
395         require(token.balanceOf(msg.sender) >= _value);
396 
397         Step memory step = steps[currentStep];
398         
399         require(step.sale);
400 
401         canSell[msg.sender] = canSell[msg.sender].sub(_value);
402         token.burnOwner(msg.sender, _value);
403 
404         uint sum = _value.mul(step.priceTokenWei).div(1 ether);
405 
406         msg.sender.transfer(sum);
407 
408         Sell(msg.sender, _value, sum);
409     }
410     
411     function refund() public {
412         require(crowdsaleRefund);
413         require(purchaseBalances[msg.sender] > 0);
414 
415         uint sum = purchaseBalances[msg.sender];
416 
417         purchaseBalances[msg.sender] = 0;
418         refundedWei = refundedWei.add(sum);
419 
420         msg.sender.transfer(sum);
421         
422         Refund(msg.sender, sum);
423     }
424 
425     function nextStep() onlyOwner public {
426         require(!crowdsaleClosed);
427         require(steps.length - 1 > currentStep);
428         
429         currentStep += 1;
430 
431         NextStep(currentStep);
432     }
433 
434     function closeCrowdsale() onlyOwner public {
435         require(!crowdsaleClosed);
436         
437         beneficiary.transfer(this.balance);
438         token.mint(beneficiary, token.totalSupply().div(100).mul(65));
439         token.finishMinting();
440         token.transferOwnership(beneficiary);
441 
442         crowdsaleClosed = true;
443 
444         CrowdsaleClose();
445     }
446 
447     function refundCrowdsale() onlyOwner public {
448         require(!crowdsaleClosed);
449 
450         crowdsaleRefund = true;
451         crowdsaleClosed = true;
452 
453         CrowdsaleRefund();
454     }
455 }