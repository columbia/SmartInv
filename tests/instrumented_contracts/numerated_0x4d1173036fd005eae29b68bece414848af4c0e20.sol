1 /*! gbcoin.sol | (c) 2017 Develop by BelovITLab, autor my.life.cookie | License: MIT */
2 
3 /*
4 
5     Russian
6 
7     Что такое GB Systems:
8     Это Geo Blockchain система, которая не привязывается ни к одной стране и банкам. У нас есть свой 
9     процессинговый центр, эквайринг и платежная система GBPay - аналог Visa, MasterCard, UnionPay. 
10     Все транзакции которые будут проходить внутри системы и банков партнеров моментально. Так же, 
11     подключающиеся компании партнеров и банки, имеют возможность использовать всю систему для своего 
12     бизнеса, путем интеграции API кода и использовать все возможности нашей системы для своих клиентов. 
13     Каждому партнеру выгодно сотрудничать с нашей системой, что позволить увеличить количество клиентов 
14     во всем мире. В нашей системе скоро будет холодный кошелек GB Wallet, где можно хранить криптовалюту 
15     и национальную валюту любой страны. Компания GB Network позволит каждому клиенту приобрести виртуальный 
16     счет, где можно хранить средства, и совершать покупку путем приложения NFC, одним касанием к Пост 
17     Терминалу, а также покупать и оплачивать услуги и товары через онлайн систему. Так же компания дает 
18     возможность зарабатывать на партнерской программе. Мы не забыли и о благотворительном фонде, который 
19     будет межуднародный и не привязываться к одной стране. Часть средств от нашей системы будет поступать 
20     в этот фонд.
21     
22     Банкам партнерам разрешается по мимо нашей системы, имитировать пластиковые карты для своих и наших 
23     клиентов  всей системы, в национальной валюте, с применением нашей платежной системой с нашим логотипом 
24     GBPay, и с использованием  нашей платформы Blockchain, куда входит эквайринг, процессинговый центр и 
25     платежная система, все это за 1,2%. Границ между странами в нашей системе нет, что позволяет совершать 
26     платежи и переводы за секунду в любою точку земного шара. Для работы в системе, мы создали токен GBCoin, 
27     который будет отвечать за весь функционал финансовой системы GB Systems, как внутренняя международная 
28     транзакционная валюта системы, которой будут привязаны все наши компании и банки. 
29     
30     К нашей системе GB Systems подключены: Grande Bank, Grande Finance, GB Network, GBMarkets, GB Wallet, 
31     Charity Foundation, GBPay.
32     
33     Мы так же будем предоставлять потребительские кредиты, автокредитование, ипотечное кредитование, 
34     под минимальные проценты, открываеть депозитные и инвестиционные вклады, вклады на доверительное 
35     управление, страхование с большими возможностями, обменник валют, платежная система, так же можно 
36     будет  оплачивать нашей криптовалютой GBCoin услуги такси в разных странах, оплачивать за 
37     туристические путевки у туроператоров,  По системе лояльности иметь возможность получать скидки 
38     и cash back в продуктовых магазинах партнеров и многое другое. 
39     
40     С нами вы будете иметь все в одной системе и не нужно будет обращаться в сторонние структуры. 
41     Удобство и Качество для всех клиентов.
42 
43 
44 
45     English
46 
47     What is GB Systems:
48     It is Geo Blockchain system which does not become attached to one country and banks. 
49     We have the processing center, acquiring and GBPay payment provider - this analog  Visa, MasterCard, 
50     UnionPay. All transactions which will take place in system and banks of partners instantly. Also, 
51     the connected partner companies and banks, have an opportunity to use all system for the business, 
52     by integration of an API code and to use all opportunities of our system for the clients. It is 
53     profitable to each partner to cooperate with our system what to allow to increase the number of 
54     clients around the world. In our system there will be soon a cold purse of GB Wallet where it is 
55     possible to keep cryptocurrency and national currency of any country. The GB Network company will 
56     allow each client to purchase the virtual account where it is possible to store means and to make 
57     purchase by the application NFC, one contact to the Post to the Terminal and also to buy and pay 
58     services and goods through online system. Also the company gives the chance to earn on the partner 
59     program. We did not forget also about charity foundation which will be mezhudnarodny and not to 
60     become attached to one country. A part of means from our system will come to this fund. To partners 
61     it is allowed to banks on by our system, to imitate plastic cards for the and our clients of all 
62     system, in national currency, using our payment service provider with our GBPay logo, and with use 
63     of our Blockchain platform where acquiring, a processing center and a payment service provider, 
64     all this for 1,2% enters. There are no borders between the countries in our system that allows 
65     to make payments and transfers for second in any a globe point. For work in system, we created 
66     a token of GBCoin which will be responsible for all functionality of the GB Systems financial 
67     system as internal world transactional currency of system which will attach all our companies 
68     and banks.
69 
70     Our system is already connected Grande Bank, Grande Finance, GB Network, GBMarkets, GB Wallet, 
71     Charity Foundation, GBPay.
72 
73 */
74 
75 pragma solidity 0.4.18;
76 
77 library SafeMath {
78     function mul(uint256 a, uint256 b) internal constant returns(uint256) {
79         uint256 c = a * b;
80         assert(a == 0 || c / a == b);
81         return c;
82     }
83 
84     function div(uint256 a, uint256 b) internal constant returns(uint256) {
85         uint256 c = a / b;
86         return c;
87     }
88 
89     function sub(uint256 a, uint256 b) internal constant returns(uint256) {
90         assert(b <= a);
91         return a - b;
92     }
93 
94     function add(uint256 a, uint256 b) internal constant returns(uint256) {
95         uint256 c = a + b;
96         assert(c >= a);
97         return c;
98     }
99 }
100 
101 contract Ownable {
102     address public owner;
103 
104     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
105 
106     modifier onlyOwner() { require(msg.sender == owner); _; }
107 
108     function Ownable() {
109         owner = msg.sender;
110     }
111 
112     function transferOwnership(address newOwner) onlyOwner {
113         require(newOwner != address(0));
114         OwnershipTransferred(owner, newOwner);
115         owner = newOwner;
116     }
117 }
118 
119 contract Pausable is Ownable {
120     bool public paused = false;
121 
122     event Pause();
123     event Unpause();
124 
125     modifier whenNotPaused() { require(!paused); _; }
126     modifier whenPaused() { require(paused); _; }
127 
128     function pause() onlyOwner whenNotPaused {
129         paused = true;
130         Pause();
131     }
132     
133     function unpause() onlyOwner whenPaused {
134         paused = false;
135         Unpause();
136     }
137 }
138 
139 contract ERC20 {
140     uint256 public totalSupply;
141 
142     event Transfer(address indexed from, address indexed to, uint256 value);
143     event Approval(address indexed owner, address indexed spender, uint256 value);
144 
145     function balanceOf(address who) constant returns (uint256);
146     function transfer(address to, uint256 value) returns (bool);
147     function transferFrom(address from, address to, uint256 value) returns (bool);
148     function allowance(address owner, address spender) constant returns (uint256);
149     function approve(address spender, uint256 value) returns (bool);
150 }
151 
152 contract StandardToken is ERC20 {
153     using SafeMath for uint256;
154 
155     mapping(address => uint256) balances;
156     mapping(address => mapping(address => uint256)) allowed;
157 
158     function balanceOf(address _owner) constant returns(uint256 balance) {
159         return balances[_owner];
160     }
161 
162     function transfer(address _to, uint256 _value) returns(bool success) {
163         require(_to != address(0));
164 
165         balances[msg.sender] = balances[msg.sender].sub(_value);
166         balances[_to] = balances[_to].add(_value);
167 
168         Transfer(msg.sender, _to, _value);
169 
170         return true;
171     }
172 
173     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
174         require(_to != address(0));
175 
176         var _allowance = allowed[_from][msg.sender];
177 
178         balances[_from] = balances[_from].sub(_value);
179         balances[_to] = balances[_to].add(_value);
180         allowed[_from][msg.sender] = _allowance.sub(_value);
181 
182         Transfer(_from, _to, _value);
183 
184         return true;
185     }
186 
187     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
188         return allowed[_owner][_spender];
189     }
190 
191     function approve(address _spender, uint256 _value) returns(bool success) {
192         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
193 
194         allowed[msg.sender][_spender] = _value;
195 
196         Approval(msg.sender, _spender, _value);
197 
198         return true;
199     }
200 
201     function increaseApproval(address _spender, uint _addedValue) returns(bool success) {
202         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
203 
204         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
205 
206         return true;
207     }
208 
209     function decreaseApproval(address _spender, uint _subtractedValue) returns(bool success) {
210         uint oldValue = allowed[msg.sender][_spender];
211 
212         if(_subtractedValue > oldValue) {
213             allowed[msg.sender][_spender] = 0;
214         } else {
215             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
216         }
217 
218         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
219         
220         return true;
221     }
222 }
223 
224 contract BurnableToken is StandardToken {
225     event Burn(address indexed burner, uint256 value);
226 
227     function burn(uint256 _value) public {
228         require(_value > 0);
229 
230         address burner = msg.sender;
231 
232         balances[burner] = balances[burner].sub(_value);
233         totalSupply = totalSupply.sub(_value);
234 
235         Burn(burner, _value);
236     }
237 }
238 
239 contract MintableToken is StandardToken, Ownable {
240     event Mint(address indexed to, uint256 amount);
241     event MintFinished();
242 
243     bool public mintingFinished = false;
244     uint public MAX_SUPPLY;
245 
246     modifier canMint() { require(!mintingFinished); _; }
247 
248     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool success) {
249         require(totalSupply.add(_amount) <= MAX_SUPPLY);
250 
251         totalSupply = totalSupply.add(_amount);
252         balances[_to] = balances[_to].add(_amount);
253 
254         Mint(_to, _amount);
255         Transfer(address(0), _to, _amount);
256 
257         return true;
258     }
259 
260     function finishMinting() onlyOwner public returns(bool success) {
261         mintingFinished = true;
262 
263         MintFinished();
264 
265         return true;
266     }
267 }
268 
269 /*
270     ICO GBCoin
271     - Эмиссия токенов ограничена (всего 40 000 000 токенов, токены выпускаются во время Crowdsale)
272     - Цена токена во время старта: 1 ETH = 20 токенов (1 Eth (~500$) / 20 = ~25$) (цену можно изменить во время ICO)
273     - Минимальная и максимальная сумма покупки: 1 ETH и 10 000 ETH
274     - Токенов на продажу 20 000 000 (50%)
275     - 20 000 000 (50%) токенов передается бенефициару во время создания токена
276     - Средства от покупки токенов передаются бенефициару
277     - Закрытие Crowdsale происходит с помощью функции `withdraw()`:нераскупленные токены и управление токеном передаётся бенефициару, выпуск токенов закрывается
278     - Измение цены токена происходет функцией `setTokenPrice(_value)`, где `_value` - кол-во токенов покумаемое за 1 Ether, смена стоимости токена доступно только во время паузы администратору, после завершения Crowdsale функция становится недоступной
279 */
280 
281 contract Token is BurnableToken, MintableToken {
282     string public name = "GBCoin";
283     string public symbol = "GBCN";
284     uint256 public decimals = 18;
285 
286     function Token() {
287         MAX_SUPPLY = 40000000 * 1 ether;                                            // Maximum amount tokens
288         mint(0xb942E28245d39ab4482e7C9972E07325B5653642, 20000000 * 1 ether);       
289     }
290 }
291 
292 contract Crowdsale is Pausable {
293     using SafeMath for uint;
294 
295     Token public token;
296     address public beneficiary = 0xb942E28245d39ab4482e7C9972E07325B5653642;        
297 
298     uint public collectedWei;
299     uint public tokensSold;
300 
301     uint public tokensForSale = 20000000 * 1 ether;                                 // Amount tokens for sale
302     uint public priceTokenWei = 1 ether / 25;                                       // 1 Eth (~875$) / 25 = ~35$
303 
304     bool public crowdsaleFinished = false;
305 
306     event NewContribution(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
307     event Withdraw();
308 
309     function Crowdsale() {
310         token = new Token();
311     }
312 
313     function() payable {
314         purchase();
315     }
316 
317     function setTokenPrice(uint _value) onlyOwner whenPaused {
318         require(!crowdsaleFinished);
319         priceTokenWei = 1 ether / _value;
320     }
321     
322     function purchase() whenNotPaused payable {
323         require(!crowdsaleFinished);
324         require(tokensSold < tokensForSale);
325         require(msg.value >= 0.01 ether && msg.value <= 10000 * 1 ether);
326 
327         uint sum = msg.value;
328         uint amount = sum.div(priceTokenWei).mul(1 ether);
329         uint retSum = 0;
330         
331         if(tokensSold.add(amount) > tokensForSale) {
332             uint retAmount = tokensSold.add(amount).sub(tokensForSale);
333             retSum = retAmount.mul(priceTokenWei).div(1 ether);
334 
335             amount = amount.sub(retAmount);
336             sum = sum.sub(retSum);
337         }
338 
339         tokensSold = tokensSold.add(amount);
340         collectedWei = collectedWei.add(sum);
341 
342         beneficiary.transfer(sum);
343         token.mint(msg.sender, amount);
344 
345         if(retSum > 0) {
346             msg.sender.transfer(retSum);
347         }
348 
349         NewContribution(msg.sender, amount, sum);
350     }
351 
352     function withdraw() onlyOwner {
353         require(!crowdsaleFinished);
354         
355         if(tokensForSale.sub(tokensSold) > 0) {
356             token.mint(beneficiary, tokensForSale.sub(tokensSold));
357         }
358 
359         token.finishMinting();
360         token.transferOwnership(beneficiary);
361 
362         crowdsaleFinished = true;
363 
364         Withdraw();
365     }
366 
367     function balanceOf(address _owner) constant returns(uint256 balance) {
368         return token.balanceOf(_owner);
369     }
370 }