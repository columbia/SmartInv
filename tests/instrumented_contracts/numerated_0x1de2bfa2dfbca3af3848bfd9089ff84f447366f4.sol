1 /*! gbcoin.sol | (c) 2017 Develop by BelovITLab, autor my.life.cookie | License: MIT */
2 
3 /*
4     О нас:
5 
6     Наша GB Systems состоит из нескольких банков, расположенных на территории Евросоюза, России, 
7     так же будет открыт банк на территории Соединенных Штатов Америки, а так же в скором времени 
8     наши ряды пополнит банк из Китая. Наша финансовая система постоянно развивается и стремится 
9     для усовершенствования для наших клиентов. Для этого мы воссоединились в одну крупную мировую 
10     финансовую сеть, которая может предоставлять для наших клиентов и людей банковские услуги всех 
11     направлений, свою валюту GBCoin,  криптовалютную фондовую биржу GBMarkets - где каждый человек, 
12     либо профессиональный трейдер, сможет увеличить свой капитал, путем торговли на бирже. 
13     
14     Для удобство так же мы создаем холодный кошелек GB Wallet со всеми услугами платежной системы. 
15     Еще для увеличения капитала для клиентов, мы создаем GB Fund, где по доверительному управлению, 
16     клиенту можно зарабатывать неплохие проценты, начисляемые раз в месяц, над этим будут трудиться 
17     наши профессиональные трейдеры. Наша финансовая система   постоянно  с каждым месяцем 
18     увеличивается, далее в последующем будут открываться  офисы в разных странах, что позволит 
19     воспользоваться  нашими услугами гражданину той или иной страны. Наши услуги лояльны ко всем 
20     нашим клиентам. Мы предоставляем потребительские кредиты, автокредитование, ипотечное 
21     кредитование, под минимальные проценты, открывает депозитные и инвестиционные вклады, вклады 
22     на доверительное управление, страхование с большими возможностями, обменник валют, платежная 
23     система, так же можно будет  оплачивать нашей криптовалютой GBCoin услуги такси в разных странах, 
24     оплачивать за туристические путевки у туроператоров,  По системе лояльности иметь возможность 
25     получать скидки и cash back в продуктовых магазинах партнеров и многое другое. 
26     
27     С нами вы будете иметь все в одной системе и не нужно будет обращаться в сторонние структуры. 
28     Удобство и Качество для всех клиентов. 
29 */
30 
31 pragma solidity ^0.4.18;
32 
33 library SafeMath {
34     function mul(uint256 a, uint256 b) internal constant returns(uint256) {
35         uint256 c = a * b;
36         assert(a == 0 || c / a == b);
37         return c;
38     }
39 
40     function div(uint256 a, uint256 b) internal constant returns(uint256) {
41         uint256 c = a / b;
42         return c;
43     }
44 
45     function sub(uint256 a, uint256 b) internal constant returns(uint256) {
46         assert(b <= a);
47         return a - b;
48     }
49 
50     function add(uint256 a, uint256 b) internal constant returns(uint256) {
51         uint256 c = a + b;
52         assert(c >= a);
53         return c;
54     }
55 }
56 
57 contract Ownable {
58     address public owner;
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62     modifier onlyOwner() { require(msg.sender == owner); _; }
63 
64     function Ownable() {
65         owner = msg.sender;
66     }
67 
68     function transferOwnership(address newOwner) onlyOwner {
69         require(newOwner != address(0));
70         OwnershipTransferred(owner, newOwner);
71         owner = newOwner;
72     }
73 }
74 
75 contract Pausable is Ownable {
76     bool public paused = false;
77 
78     event Pause();
79     event Unpause();
80 
81     modifier whenNotPaused() { require(!paused); _; }
82     modifier whenPaused() { require(paused); _; }
83 
84     function pause() onlyOwner whenNotPaused {
85         paused = true;
86         Pause();
87     }
88     
89     function unpause() onlyOwner whenPaused {
90         paused = false;
91         Unpause();
92     }
93 }
94 
95 contract ERC20 {
96     uint256 public totalSupply;
97 
98     event Transfer(address indexed from, address indexed to, uint256 value);
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 
101     function balanceOf(address who) constant returns (uint256);
102     function transfer(address to, uint256 value) returns (bool);
103     function transferFrom(address from, address to, uint256 value) returns (bool);
104     function allowance(address owner, address spender) constant returns (uint256);
105     function approve(address spender, uint256 value) returns (bool);
106 }
107 
108 contract StandardToken is ERC20 {
109     using SafeMath for uint256;
110 
111     mapping(address => uint256) balances;
112     mapping(address => mapping(address => uint256)) allowed;
113 
114     function balanceOf(address _owner) constant returns(uint256 balance) {
115         return balances[_owner];
116     }
117 
118     function transfer(address _to, uint256 _value) returns(bool success) {
119         require(_to != address(0));
120 
121         balances[msg.sender] = balances[msg.sender].sub(_value);
122         balances[_to] = balances[_to].add(_value);
123 
124         Transfer(msg.sender, _to, _value);
125 
126         return true;
127     }
128 
129     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
130         require(_to != address(0));
131 
132         var _allowance = allowed[_from][msg.sender];
133 
134         balances[_from] = balances[_from].sub(_value);
135         balances[_to] = balances[_to].add(_value);
136         allowed[_from][msg.sender] = _allowance.sub(_value);
137 
138         Transfer(_from, _to, _value);
139 
140         return true;
141     }
142 
143     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
144         return allowed[_owner][_spender];
145     }
146 
147     function approve(address _spender, uint256 _value) returns(bool success) {
148         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
149 
150         allowed[msg.sender][_spender] = _value;
151 
152         Approval(msg.sender, _spender, _value);
153 
154         return true;
155     }
156 
157     function increaseApproval(address _spender, uint _addedValue) returns(bool success) {
158         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
159 
160         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
161 
162         return true;
163     }
164 
165     function decreaseApproval(address _spender, uint _subtractedValue) returns(bool success) {
166         uint oldValue = allowed[msg.sender][_spender];
167 
168         if(_subtractedValue > oldValue) {
169             allowed[msg.sender][_spender] = 0;
170         } else {
171             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
172         }
173 
174         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
175         
176         return true;
177     }
178 }
179 
180 contract BurnableToken is StandardToken {
181     event Burn(address indexed burner, uint256 value);
182 
183     function burn(uint256 _value) public {
184         require(_value > 0);
185 
186         address burner = msg.sender;
187 
188         balances[burner] = balances[burner].sub(_value);
189         totalSupply = totalSupply.sub(_value);
190 
191         Burn(burner, _value);
192     }
193 }
194 
195 contract MintableToken is StandardToken, Ownable {
196     event Mint(address indexed to, uint256 amount);
197     event MintFinished();
198 
199     bool public mintingFinished = false;
200     uint public MAX_SUPPLY;
201 
202     modifier canMint() { require(!mintingFinished); _; }
203 
204     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool success) {
205         require(totalSupply.add(_amount) <= MAX_SUPPLY);
206 
207         totalSupply = totalSupply.add(_amount);
208         balances[_to] = balances[_to].add(_amount);
209 
210         Mint(_to, _amount);
211         Transfer(address(0), _to, _amount);
212 
213         return true;
214     }
215 
216     function finishMinting() onlyOwner public returns(bool success) {
217         mintingFinished = true;
218 
219         MintFinished();
220 
221         return true;
222     }
223 }
224 
225 /*
226     ICO GBCoin
227     - Эмиссия токенов ограничена (всего 40 000 000 токенов, токены выпускаются во время Crowdsale)
228     - Цена токена во время старта: 1 ETH = 20 токенов (1 Eth (~500$) / 20 = ~25$) (цену можно изменить во время ICO)
229     - Минимальная и максимальная сумма покупки: 1 ETH и 10 000 ETH
230     - Токенов на продажу 20 000 000 (50%)
231     - 20 000 000 (50%) токенов передается бенефициару во время создания токена
232     - Средства от покупки токенов передаются бенефициару
233     - Закрытие Crowdsale происходит с помощью функции `withdraw()`:нераскупленные токены и управление токеном передаётся бенефициару, выпуск токенов закрывается
234     - Измение цены токена происходет функцией `setTokenPrice(_value)`, где `_value` - кол-во токенов покумаемое за 1 Ether, смена стоимости токена доступно только во время паузы администратору, после завершения Crowdsale функция становится недоступной
235 */
236 contract Token is BurnableToken, MintableToken {
237     string public name = "GBCoin";
238     string public symbol = "GBCN";
239     uint256 public decimals = 18;
240 
241     function Token() {
242         MAX_SUPPLY = 40000000 * 1 ether;                                            // Maximum amount tokens
243         mint(0xF59125FCB92bBB364e7F3c106E9BAEb8b4bB69B0, 20000000 * 1 ether);       
244     }
245 }
246 
247 contract Crowdsale is Pausable {
248     using SafeMath for uint;
249 
250     Token public token;
251     address public beneficiary = 0xF59125FCB92bBB364e7F3c106E9BAEb8b4bB69B0;        
252 
253     uint public collectedWei;
254     uint public tokensSold;
255 
256     uint public tokensForSale = 20000000 * 1 ether;                                 // Amount tokens for sale
257     uint public priceTokenWei = 1 ether / 20;                                       // 1 Eth (~500$) / 20 = ~25$
258 
259     bool public crowdsaleFinished = false;
260 
261     event NewContribution(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
262     event Withdraw();
263 
264     function Crowdsale() {
265         token = new Token();
266     }
267 
268     function() payable {
269         purchase();
270     }
271 
272     function setTokenPrice(uint _value) onlyOwner whenPaused {
273         require(!crowdsaleFinished);
274         priceTokenWei = 1 ether / _value;
275     }
276     
277     function purchase() whenNotPaused payable {
278         require(!crowdsaleFinished);
279         require(tokensSold < tokensForSale);
280         require(msg.value >= 1 ether && msg.value <= 10000 * 1 ether);
281 
282         uint sum = msg.value;
283         uint amount = sum.div(priceTokenWei).mul(1 ether);
284         uint retSum = 0;
285         
286         if(tokensSold.add(amount) > tokensForSale) {
287             uint retAmount = tokensSold.add(amount).sub(tokensForSale);
288             retSum = retAmount.mul(priceTokenWei).div(1 ether);
289 
290             amount = amount.sub(retAmount);
291             sum = sum.sub(retSum);
292         }
293 
294         tokensSold = tokensSold.add(amount);
295         collectedWei = collectedWei.add(sum);
296 
297         beneficiary.transfer(sum);
298         token.mint(msg.sender, amount);
299 
300         if(retSum > 0) {
301             msg.sender.transfer(retSum);
302         }
303 
304         NewContribution(msg.sender, amount, sum);
305     }
306 
307     function withdraw() onlyOwner {
308         require(!crowdsaleFinished);
309         
310         if(tokensForSale.sub(tokensSold) > 0) {
311             token.mint(beneficiary, tokensForSale.sub(tokensSold));
312         }
313 
314         token.finishMinting();
315         token.transferOwnership(beneficiary);
316 
317         crowdsaleFinished = true;
318 
319         Withdraw();
320     }
321 
322     function balanceOf(address _owner) constant returns(uint256 balance) {
323         return token.balanceOf(_owner);
324     }
325 }