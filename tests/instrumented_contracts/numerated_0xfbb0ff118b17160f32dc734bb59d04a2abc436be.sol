1 /*! ppmt.sol | (c) 2018 Develop by BelovITLab LLC (smartcontract.ru), author @stupidlovejoy | License: MIT */
2 
3 pragma solidity 0.4.18;
4 
5 library SafeMath {
6     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
7         if(a == 0) {
8             return 0;
9         }
10         uint256 c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns(uint256) {
16         uint256 c = a / b;
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns(uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 contract Ownable {
33     address public owner;
34 
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37     modifier onlyOwner() { require(msg.sender == owner); _; }
38 
39     function Ownable() public {
40         owner = msg.sender;
41     }
42 
43     function transferOwnership(address newOwner) public onlyOwner {
44         require(newOwner != address(0));
45         owner = newOwner;
46         OwnershipTransferred(owner, newOwner);
47     }
48 }
49 
50 contract Pausable is Ownable {
51     bool public paused = false;
52 
53     event Pause();
54     event Unpause();
55 
56     modifier whenNotPaused() { require(!paused); _; }
57     modifier whenPaused() { require(paused); _; }
58 
59     function pause() onlyOwner whenNotPaused public {
60         paused = true;
61         Pause();
62     }
63 
64     function unpause() onlyOwner whenPaused public {
65         paused = false;
66         Unpause();
67     }
68 }
69 
70 contract ERC20 {
71     uint256 public totalSupply;
72 
73     event Transfer(address indexed from, address indexed to, uint256 value);
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 
76     function balanceOf(address who) public view returns(uint256);
77     function transfer(address to, uint256 value) public returns(bool);
78     function transferFrom(address from, address to, uint256 value) public returns(bool);
79     function allowance(address owner, address spender) public view returns(uint256);
80     function approve(address spender, uint256 value) public returns(bool);
81 }
82 
83 contract StandardToken is ERC20 {
84     using SafeMath for uint256;
85 
86     string public name;
87     string public symbol;
88     uint8 public decimals;
89 
90     mapping(address => uint256) balances;
91     mapping (address => mapping (address => uint256)) internal allowed;
92 
93     function StandardToken(string _name, string _symbol, uint8 _decimals) public {
94         name = _name;
95         symbol = _symbol;
96         decimals = _decimals;
97     }
98 
99     function balanceOf(address _owner) public view returns(uint256 balance) {
100         return balances[_owner];
101     }
102 
103     function transfer(address _to, uint256 _value) public returns(bool) {
104         require(_to != address(0));
105         require(_value <= balances[msg.sender]);
106 
107         balances[msg.sender] = balances[msg.sender].sub(_value);
108         balances[_to] = balances[_to].add(_value);
109 
110         Transfer(msg.sender, _to, _value);
111 
112         return true;
113     }
114     
115     function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {
116         require(_to.length == _value.length);
117 
118         for(uint i = 0; i < _to.length; i++) {
119             transfer(_to[i], _value[i]);
120         }
121 
122         return true;
123     }
124 
125     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
126         require(_to != address(0));
127         require(_value <= balances[_from]);
128         require(_value <= allowed[_from][msg.sender]);
129 
130         balances[_from] = balances[_from].sub(_value);
131         balances[_to] = balances[_to].add(_value);
132         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
133 
134         Transfer(_from, _to, _value);
135 
136         return true;
137     }
138 
139     function allowance(address _owner, address _spender) public view returns(uint256) {
140         return allowed[_owner][_spender];
141     }
142 
143     function approve(address _spender, uint256 _value) public returns(bool) {
144         allowed[msg.sender][_spender] = _value;
145 
146         Approval(msg.sender, _spender, _value);
147 
148         return true;
149     }
150 
151     function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
152         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
153 
154         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
155 
156         return true;
157     }
158 
159     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
160         uint oldValue = allowed[msg.sender][_spender];
161 
162         if(_subtractedValue > oldValue) {
163             allowed[msg.sender][_spender] = 0;
164         } else {
165             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
166         }
167 
168         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169 
170         return true;
171     }
172 }
173 
174 contract MintableToken is StandardToken, Ownable {
175     event Mint(address indexed to, uint256 amount);
176     event MintFinished();
177 
178     bool public mintingFinished = false;
179 
180     modifier canMint() { require(!mintingFinished); _; }
181     modifier notMint() { require(mintingFinished); _; }
182 
183     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
184         totalSupply = totalSupply.add(_amount);
185         balances[_to] = balances[_to].add(_amount);
186 
187         Mint(_to, _amount);
188         Transfer(address(0), _to, _amount);
189 
190         return true;
191     }
192 
193     function finishMinting() onlyOwner canMint public returns(bool) {
194         mintingFinished = true;
195 
196         MintFinished();
197 
198         return true;
199     }
200 }
201 
202 contract CappedToken is MintableToken {
203     uint256 public cap;
204 
205     function CappedToken(uint256 _cap) public {
206         require(_cap > 0);
207         cap = _cap;
208     }
209 
210     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
211         require(totalSupply.add(_amount) <= cap);
212 
213         return super.mint(_to, _amount);
214     }
215 }
216 
217 contract BurnableToken is StandardToken {
218     event Burn(address indexed burner, uint256 value);
219 
220     function burn(uint256 _value) public {
221         require(_value <= balances[msg.sender]);
222 
223         address burner = msg.sender;
224 
225         balances[burner] = balances[burner].sub(_value);
226         totalSupply = totalSupply.sub(_value);
227 
228         Burn(burner, _value);
229     }
230 }
231 
232 /*
233     ICO Gap
234     - Crowdsale идет в 4 шага:
235     - 1-ый шаг PreSale 0: администратор может выдавать токены; покупка и продажа закрыты; макс. токенов 5 000 000
236     - 2-ый шаг PreSale 1: администратор НЕ может выдавать токены; продажа открыта; покупка закрыта; макс. токенов 5 000 000 + 10 000 000
237     - 3-ый шаг PreSale 2: администратор НЕ может выдавать токены; продажа открыта; покупка закрыта; макс. токенов 5 000 000 + 10 000 000 + 15 000 000
238     - 4-ый шаг ICO: администратор НЕ может выдавать токены; продажа открыта; покупка открыта; макс. токенов 5 000 000 + 10 000 000 + 15 000 000 + 30 000 000
239     - Дополнение:
240     - общая эмиссия ограничена: 100 000 000 токенов
241     - на каждом шаге возможно изменить цену токена
242     - шаги не ограничены по времени и переключение шага происходит администратором `nextStep`
243     - средства акумулируются на контракте
244     - в любое время может быть вызван `closeCrowdsale`: средства и управление токеном передаются бенефициару; происходит выпуск +65% токенов на бенефициара; минтинг закрывается
245     - в любое время может быть вызван `refundCrowdsale`: средства остаются на контракте; withdraw становится недоступным; открывается возможность забрать вложения `refund`
246     - перевод токенов до `closeCrowdsale` недоступен 
247     - на 1 кошель можно купить не более 500 000 токенов
248 */
249 contract Token is CappedToken, BurnableToken {
250     function Token() CappedToken(100000000 * 1 ether) StandardToken("GAP Token", "GAP", 18) public {
251         
252     }
253     
254     function transfer(address _to, uint256 _value) notMint public returns(bool) {
255         return super.transfer(_to, _value);
256     }
257     
258     function multiTransfer(address[] _to, uint256[] _value) notMint public returns(bool) {
259         return super.multiTransfer(_to, _value);
260     }
261 
262     function transferFrom(address _from, address _to, uint256 _value) notMint public returns(bool) {
263         return super.transferFrom(_from, _to, _value);
264     }
265 
266     function burnOwner(address _from, uint256 _value) onlyOwner canMint public {
267         require(_value <= balances[_from]);
268 
269         balances[_from] = balances[_from].sub(_value);
270         totalSupply = totalSupply.sub(_value);
271 
272         Burn(_from, _value);
273     }
274 }
275 
276 contract Crowdsale is Pausable {
277     using SafeMath for uint;
278 
279     struct Step {
280         uint priceTokenWei;
281         uint tokensForSale;
282         uint tokensSold;
283         uint collectedWei;
284 
285         bool purchase;
286         bool issue;
287         bool sale;
288     }
289 
290     Token public token;
291     address public beneficiary = 0x4B97b2938844A775538eF0b75F08648C4BD6fFFA;
292 
293     Step[] public steps;
294     uint8 public currentStep = 0;
295 
296     bool public crowdsaleClosed = false;
297     bool public crowdsaleRefund = false;
298     uint public refundedWei;
299 
300     mapping(address => uint256) public canSell;
301     mapping(address => uint256) public purchaseBalances; 
302 
303     event Purchase(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
304     event Sell(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
305     event Issue(address indexed holder, uint256 tokenAmount);
306     event Refund(address indexed holder, uint256 etherAmount);
307     event NextStep(uint8 step);
308     event CrowdsaleClose();
309     event CrowdsaleRefund();
310 
311     function Crowdsale() public {
312         token = new Token();
313 
314         steps.push(Step(1 ether / 1000, 5000000 * 1 ether, 0, 0, false, true, false));
315         steps.push(Step(1 ether / 1000, 10000000 * 1 ether, 0, 0, true, false, false));
316         steps.push(Step(1 ether / 500, 15000000 * 1 ether, 0, 0, true, false, false));
317         steps.push(Step(1 ether / 100, 30000000 * 1 ether, 0, 0, true, false, true));
318     }
319 
320     function() payable public {
321         purchase();
322     }
323 
324     function setTokenRate(uint _value) onlyOwner whenPaused public {
325         require(!crowdsaleClosed);
326         steps[currentStep].priceTokenWei = 1 ether / _value;
327     }
328     
329     function purchase() whenNotPaused payable public {
330         require(!crowdsaleClosed);
331         require(msg.value >= 0.001 ether);
332 
333         Step memory step = steps[currentStep];
334 
335         require(step.purchase);
336         require(step.tokensSold < step.tokensForSale);
337         require(token.balanceOf(msg.sender) < 500000 ether);
338 
339         uint sum = msg.value;
340         uint amount = sum.mul(1 ether).div(step.priceTokenWei);
341         uint retSum = 0;
342         uint retAmount;
343         
344         if(step.tokensSold.add(amount) > step.tokensForSale) {
345             retAmount = step.tokensSold.add(amount).sub(step.tokensForSale);
346             retSum = retAmount.mul(step.priceTokenWei).div(1 ether);
347 
348             amount = amount.sub(retAmount);
349             sum = sum.sub(retSum);
350         }
351 
352         if(token.balanceOf(msg.sender).add(amount) > 500000 ether) {
353             retAmount = token.balanceOf(msg.sender).add(amount).sub(500000 ether);
354             retSum = retAmount.mul(step.priceTokenWei).div(1 ether);
355 
356             amount = amount.sub(retAmount);
357             sum = sum.sub(retSum);
358         }
359 
360         steps[currentStep].tokensSold = step.tokensSold.add(amount);
361         steps[currentStep].collectedWei = step.collectedWei.add(sum);
362         purchaseBalances[msg.sender] = purchaseBalances[msg.sender].add(sum);
363 
364         token.mint(msg.sender, amount);
365 
366         if(retSum > 0) {
367             msg.sender.transfer(retSum);
368         }
369 
370         Purchase(msg.sender, amount, sum);
371     }
372 
373     function issue(address _to, uint256 _value) onlyOwner whenNotPaused public {
374         require(!crowdsaleClosed);
375 
376         Step memory step = steps[currentStep];
377         
378         require(step.issue);
379         require(step.tokensSold.add(_value) <= step.tokensForSale);
380 
381         steps[currentStep].tokensSold = step.tokensSold.add(_value);
382         canSell[_to] = canSell[_to].add(_value).div(100).mul(20);
383 
384         token.mint(_to, _value);
385 
386         Issue(_to, _value);
387     }
388 
389     function sell(uint256 _value) whenNotPaused public {
390         require(!crowdsaleClosed);
391 
392         require(canSell[msg.sender] >= _value);
393         require(token.balanceOf(msg.sender) >= _value);
394 
395         Step memory step = steps[currentStep];
396         
397         require(step.sale);
398 
399         canSell[msg.sender] = canSell[msg.sender].sub(_value);
400         token.burnOwner(msg.sender, _value);
401 
402         uint sum = _value.mul(step.priceTokenWei).div(1 ether);
403 
404         msg.sender.transfer(sum);
405 
406         Sell(msg.sender, _value, sum);
407     }
408     
409     function refund() public {
410         require(crowdsaleRefund);
411         require(purchaseBalances[msg.sender] > 0);
412 
413         uint sum = purchaseBalances[msg.sender];
414 
415         purchaseBalances[msg.sender] = 0;
416         refundedWei = refundedWei.add(sum);
417 
418         msg.sender.transfer(sum);
419         
420         Refund(msg.sender, sum);
421     }
422 
423     function nextStep() onlyOwner public {
424         require(!crowdsaleClosed);
425         require(steps.length - 1 > currentStep);
426         
427         currentStep += 1;
428 
429         NextStep(currentStep);
430     }
431 
432     function closeCrowdsale() onlyOwner public {
433         require(!crowdsaleClosed);
434         
435         beneficiary.transfer(this.balance);
436         token.mint(beneficiary, token.totalSupply().div(100).mul(65));
437         token.finishMinting();
438         token.transferOwnership(beneficiary);
439 
440         crowdsaleClosed = true;
441 
442         CrowdsaleClose();
443     }
444 
445     function refundCrowdsale() onlyOwner public {
446         require(!crowdsaleClosed);
447 
448         crowdsaleRefund = true;
449         crowdsaleClosed = true;
450 
451         CrowdsaleRefund();
452     }
453 }