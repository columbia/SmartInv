1 /*! ppmt.sol | (c) 2018 Develop by BelovITLab LLC (smartcontract.ru), author my.life.cookie | License: MIT */
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
181 
182     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
183         totalSupply = totalSupply.add(_amount);
184         balances[_to] = balances[_to].add(_amount);
185 
186         Mint(_to, _amount);
187         Transfer(address(0), _to, _amount);
188 
189         return true;
190     }
191 
192     function finishMinting() onlyOwner canMint public returns(bool) {
193         mintingFinished = true;
194 
195         MintFinished();
196 
197         return true;
198     }
199 }
200 
201 contract CappedToken is MintableToken {
202     uint256 public cap;
203 
204     function CappedToken(uint256 _cap) public {
205         require(_cap > 0);
206         cap = _cap;
207     }
208 
209     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
210         require(totalSupply.add(_amount) <= cap);
211 
212         return super.mint(_to, _amount);
213     }
214 }
215 
216 contract BurnableToken is StandardToken {
217     event Burn(address indexed burner, uint256 value);
218 
219     function burn(uint256 _value) public {
220         require(_value <= balances[msg.sender]);
221 
222         address burner = msg.sender;
223 
224         balances[burner] = balances[burner].sub(_value);
225         totalSupply = totalSupply.sub(_value);
226 
227         Burn(burner, _value);
228     }
229 }
230 
231 contract RewardToken is StandardToken, Ownable {
232     struct Payment {
233         uint time;
234         uint amount;
235     }
236 
237     Payment[] public repayments;
238     mapping(address => Payment[]) public rewards;
239 
240     event Reward(address indexed to, uint256 amount);
241 
242     function repayment() onlyOwner payable public {
243         require(msg.value >= 0.01 * 1 ether);
244 
245         repayments.push(Payment({time : now, amount : msg.value}));
246     }
247 
248     function _reward(address _to) private returns(bool) {
249         if(rewards[_to].length < repayments.length) {
250             uint sum = 0;
251             for(uint i = rewards[_to].length; i < repayments.length; i++) {
252                 uint amount = balances[_to] > 0 ? (repayments[i].amount * balances[_to] / totalSupply) : 0;
253                 rewards[_to].push(Payment({time : now, amount : amount}));
254                 sum += amount;
255             }
256 
257             if(sum > 0) {
258                 _to.transfer(sum);
259                 Reward(_to, sum);
260             }
261 
262             return true;
263         }
264         return false;
265     }
266 
267     function reward() public returns(bool) {
268         return _reward(msg.sender);
269     }
270 
271     function transfer(address _to, uint256 _value) public returns(bool) {
272         _reward(msg.sender);
273         _reward(_to);
274         return super.transfer(_to, _value);
275     }
276 
277     function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {
278         _reward(msg.sender);
279         for(uint i = 0; i < _to.length; i++) {
280             _reward(_to[i]);
281         }
282 
283         return super.multiTransfer(_to, _value);
284     }
285 
286     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
287         _reward(_from);
288         _reward(_to);
289         return super.transferFrom(_from, _to, _value);
290     }
291 }
292 
293 /*
294     ICO Patriot Project Mall
295     - Эмиссия токенов ограничена (всего 1 800 000 токенов, токены выпускаются во время Crowdsale)
296     - Цена токена во время старта: 1 ETH = 140 токенов (цену можно изменить во время ICO)
297     - Минимальная сумма покупки: 0.01 ETH
298     - Токенов на продажу 1 791 000
299     - Средства от покупки токенов остаются на контракте
300     - Закрытие Crowdsale происходит с помощью функции `closeCrowdsale()`: управление токеном и не раскупленные токены передаются бенефициару, средства с контракта передаются бенефициару
301     - Возрат происходит функцией `refundCrowdsale()` Crowdsale закрывается а вкладчики могут вернуть свои вклады функцией `refund()` управление токеном остается Crowdsale
302     - Измение цены токена происходит функцией `setTokenRate(_value)`, где `_value` - кол-во токенов покумаемое за 1 Ether, смена стоимости токена доступно только во время паузы администратору, после завершения Crowdsale функция становится недоступной
303     - Измение размера бонуса происходит функцией `setBonusPercent(_value)`, где `_value` - % начисляемых бонусов при покупке токенов, смена стоимости токена доступно только во время паузы администратору, после завершения Crowdsale функция становится недоступной
304     - На Token могут быть начислены дивиденды функцией `repayment()`
305     - Чтобы забрать дивиденды держателю токенов необходимо вызвать у Token функцию `reward()`
306 */
307 contract Token is CappedToken, BurnableToken, RewardToken {
308     function Token() CappedToken(1800000 * 1 ether) StandardToken("Patriot Project Mall Token", "PPMT", 18) public {
309         
310     }
311 }
312 
313 contract Crowdsale is Pausable {
314     using SafeMath for uint;
315 
316     Token public token;
317     address public beneficiary = 0x9028233131d986484293eEde62507E3d75d6284e;
318 
319     uint public collectedWei;
320     uint public refundedWei;
321     uint public tokensSold;
322 
323     uint public tokensForSale = 1791000 * 1 ether;
324     uint public priceTokenWei = 7142857142857142;
325     uint public bonusPercent = 0;
326 
327     bool public crowdsaleClosed = false;
328     bool public crowdsaleRefund = false;
329 
330     mapping(address => uint256) public purchaseBalances; 
331 
332     event Rurchase(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
333     event Refund(address indexed holder, uint256 etherAmount);
334     event CrowdsaleClose();
335     event CrowdsaleRefund();
336 
337     function Crowdsale() public {
338         token = new Token();
339     }
340 
341     function() payable public {
342         purchase();
343     }
344 
345     function setTokenRate(uint _value) onlyOwner whenPaused public {
346         require(!crowdsaleClosed);
347         priceTokenWei = 1 ether / _value;
348     }
349 
350     function setBonusPercent(uint _value) onlyOwner whenPaused public {
351         require(!crowdsaleClosed);
352         bonusPercent = _value;
353     }
354     
355     function purchase() whenNotPaused payable public {
356         require(!crowdsaleClosed);
357         require(tokensSold < tokensForSale);
358         require(msg.value >= 0.01 ether);
359 
360         uint sum = msg.value;
361         uint amount = sum.mul(1 ether).div(priceTokenWei);
362         uint retSum = 0;
363 
364         if(bonusPercent > 0) {
365             amount = amount.div(100).mul(bonusPercent);
366         }
367         
368         if(tokensSold.add(amount) > tokensForSale) {
369             uint retAmount = tokensSold.add(amount).sub(tokensForSale);
370             retSum = retAmount.mul(priceTokenWei).div(1 ether);
371 
372             amount = amount.sub(retAmount);
373             sum = sum.sub(retSum);
374         }
375 
376         tokensSold = tokensSold.add(amount);
377         collectedWei = collectedWei.add(sum);
378         purchaseBalances[msg.sender] = purchaseBalances[msg.sender].add(sum);
379 
380         token.mint(msg.sender, amount);
381 
382         if(retSum > 0) {
383             msg.sender.transfer(retSum);
384         }
385 
386         Rurchase(msg.sender, amount, sum);
387     }
388 
389     function refund() public {
390         require(crowdsaleRefund);
391         require(purchaseBalances[msg.sender] > 0);
392 
393         uint sum = purchaseBalances[msg.sender];
394 
395         purchaseBalances[msg.sender] = 0;
396         refundedWei = refundedWei.add(sum);
397 
398         msg.sender.transfer(sum);
399         
400         Refund(msg.sender, sum);
401     }
402 
403     function closeCrowdsale() onlyOwner public {
404         require(!crowdsaleClosed);
405         
406         beneficiary.transfer(this.balance);
407         token.mint(beneficiary, token.cap().sub(token.totalSupply()));
408         token.transferOwnership(beneficiary);
409 
410         crowdsaleClosed = true;
411 
412         CrowdsaleClose();
413     }
414 
415     function refundCrowdsale() onlyOwner public {
416         require(!crowdsaleClosed);
417 
418         crowdsaleRefund = true;
419         crowdsaleClosed = true;
420 
421         CrowdsaleRefund();
422     }
423 }