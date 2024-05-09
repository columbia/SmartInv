1 pragma solidity ^0.4.18;
2 
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a / b;
15         return c;
16     }
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21     function add(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a + b;
23         assert(c >= a);
24         return c;
25     }
26 }
27 
28 
29 interface ERC20 {
30   function transfer (address _beneficiary, uint256 _tokenAmount) external returns (bool);  
31   function mint (address _to, uint256 _amount) external returns (bool);
32 }
33 
34 
35 contract Ownable {
36     address public owner;
37     function Ownable() public {
38         owner = msg.sender;
39     }
40     modifier onlyOwner() {
41         require(msg.sender == owner);
42         _;
43     }
44 }
45 
46 
47 contract Crowdsale is Ownable {
48   using SafeMath for uint256;
49 
50   modifier onlyWhileOpen {
51       require(
52         (now >= preICOStartDate && now < preICOEndDate) || 
53         (now >= ICOStartDate && now < ICOEndDate)
54       );
55       _;
56   }
57 
58   modifier onlyWhileICOOpen {
59       require(now >= ICOStartDate && now < ICOEndDate);
60       _;
61   }
62 
63   // The token being sold
64   ERC20 public token;
65 
66   // Address where funds are collected
67   address public wallet;
68 
69   // Сколько токенов покупатель получает за 1 эфир
70   uint256 public rate = 1000;
71 
72   // Сколько эфиров привлечено в ходе PreICO, wei
73   uint256 public preICOWeiRaised;
74 
75   // Сколько эфиров привлечено в ходе ICO, wei
76   uint256 public ICOWeiRaised;
77 
78   // Цена ETH в центах
79   uint256 public ETHUSD;
80 
81   // Дата начала PreICO
82   uint256 public preICOStartDate;
83 
84   // Дата окончания PreICO
85   uint256 public preICOEndDate;
86 
87   // Дата начала ICO
88   uint256 public ICOStartDate;
89 
90   // Дата окончания ICO
91   uint256 public ICOEndDate;
92 
93   // Минимальный объем привлечения средств в ходе ICO в центах
94   uint256 public softcap = 300000000;
95 
96   // Потолок привлечения средств в ходе ICO в центах
97   uint256 public hardcap = 2500000000;
98 
99   // Бонус реферала, %
100   uint8 public referalBonus = 3;
101 
102   // Бонус приглашенного рефералом, %
103   uint8 public invitedByReferalBonus = 2; 
104 
105   // Whitelist
106   mapping(address => bool) public whitelist;
107 
108   // Инвесторы, которые купили токен
109   mapping (address => uint256) public investors;
110 
111   event TokenPurchase(address indexed buyer, uint256 value, uint256 amount);
112 
113   function Crowdsale( 
114     address _wallet, 
115     uint256 _preICOStartDate, 
116     uint256 _preICOEndDate,
117     uint256 _ICOStartDate, 
118     uint256 _ICOEndDate,
119     uint256 _ETHUSD
120   ) public {
121     require(_preICOEndDate > _preICOStartDate);
122     require(_ICOStartDate > _preICOEndDate);
123     require(_ICOEndDate > _ICOStartDate);
124 
125     wallet = _wallet;
126     preICOStartDate = _preICOStartDate;
127     preICOEndDate = _preICOEndDate;
128     ICOStartDate = _ICOStartDate;
129     ICOEndDate = _ICOEndDate;
130     ETHUSD = _ETHUSD;
131   }
132 
133   /* Публичные методы */
134 
135   // Установить стоимость токена
136   function setRate (uint16 _rate) public onlyOwner {
137     require(_rate > 0);
138     rate = _rate;
139   }
140 
141   // Установить адрес кошелька для сбора средств
142   function setWallet (address _wallet) public onlyOwner {
143     require (_wallet != 0x0);
144     wallet = _wallet;
145       
146   }
147   
148 
149   // Установить торгуемый токен
150   function setToken (ERC20 _token) public onlyOwner {
151     token = _token;
152   }
153   
154   // Установить дату начала PreICO
155   function setPreICOStartDate (uint256 _preICOStartDate) public onlyOwner {
156     require(_preICOStartDate < preICOEndDate);
157     preICOStartDate = _preICOStartDate;
158   }
159 
160   // Установить дату окончания PreICO
161   function setPreICOEndDate (uint256 _preICOEndDate) public onlyOwner {
162     require(_preICOEndDate > preICOStartDate);
163     preICOEndDate = _preICOEndDate;
164   }
165 
166   // Установить дату начала ICO
167   function setICOStartDate (uint256 _ICOStartDate) public onlyOwner {
168     require(_ICOStartDate < ICOEndDate);
169     ICOStartDate = _ICOStartDate;
170   }
171 
172   // Установить дату окончания PreICO
173   function setICOEndDate (uint256 _ICOEndDate) public onlyOwner {
174     require(_ICOEndDate > ICOStartDate);
175     ICOEndDate = _ICOEndDate;
176   }
177 
178   // Установить стоимость эфира в центах
179   function setETHUSD (uint256 _ETHUSD) public onlyOwner {
180     ETHUSD = _ETHUSD;
181   }
182 
183   function () external payable {
184     address beneficiary = msg.sender;
185     uint256 weiAmount = msg.value;
186     uint256 tokens;
187 
188     if(_isPreICO()){
189 
190         _preValidatePreICOPurchase(beneficiary, weiAmount);
191         tokens = weiAmount.mul(rate.add(rate.mul(30).div(100)));
192         preICOWeiRaised = preICOWeiRaised.add(weiAmount);
193         wallet.transfer(weiAmount);
194         investors[beneficiary] = weiAmount;
195         _deliverTokens(beneficiary, tokens);
196         TokenPurchase(beneficiary, weiAmount, tokens);
197 
198     } else if(_isICO()){
199 
200         _preValidateICOPurchase(beneficiary, weiAmount);
201         tokens = _getTokenAmountWithBonus(weiAmount);
202         ICOWeiRaised = ICOWeiRaised.add(weiAmount);
203         investors[beneficiary] = weiAmount;
204         _deliverTokens(beneficiary, tokens);
205         TokenPurchase(beneficiary, weiAmount, tokens);
206 
207     }
208   }
209 
210 /*   function buyPreICO() public payable {
211     address beneficiary = msg.sender;
212     uint256 weiAmount = msg.value;
213 
214     _preValidatePreICOPurchase(beneficiary, weiAmount);
215 
216     uint256 tokens = weiAmount.mul(rate.add(rate.mul(30).div(100)));
217     preICOWeiRaised = preICOWeiRaised.add(weiAmount);
218     wallet.transfer(weiAmount);
219     investors[beneficiary] = weiAmount;
220     _deliverTokens(beneficiary, tokens);
221 
222     TokenPurchase(beneficiary, weiAmount, tokens);
223   }
224 
225   function buyICO() public payable {
226     address beneficiary = msg.sender;
227     uint256 weiAmount = msg.value;
228 
229     _preValidateICOPurchase(beneficiary, weiAmount);
230 
231     uint256 tokens = _getTokenAmountWithBonus(weiAmount);
232     ICOWeiRaised = ICOWeiRaised.add(weiAmount);
233 
234     investors[beneficiary] = weiAmount;
235     _deliverTokens(beneficiary, tokens);
236 
237     TokenPurchase(beneficiary, weiAmount, tokens);
238   } */
239 
240     // Покупка токенов с реферальным бонусом
241   function buyTokensWithReferal(address _referal) public onlyWhileICOOpen payable {
242     address beneficiary = msg.sender;    
243     uint256 weiAmount = msg.value;
244 
245     _preValidateICOPurchase(beneficiary, weiAmount);
246 
247     uint256 tokens = _getTokenAmountWithBonus(weiAmount).add(_getTokenAmountWithReferal(weiAmount, 2));
248     uint256 referalTokens = _getTokenAmountWithReferal(weiAmount, 3);
249 
250     ICOWeiRaised = ICOWeiRaised.add(weiAmount);
251     investors[beneficiary] = weiAmount;
252 
253     _deliverTokens(beneficiary, tokens);
254     _deliverTokens(_referal, referalTokens);
255 
256     TokenPurchase(beneficiary, weiAmount, tokens);
257   }
258 
259   // Добавить адрес в whitelist
260   function addToWhitelist(address _beneficiary) public onlyOwner {
261     whitelist[_beneficiary] = true;
262   }
263 
264   // Добавить несколько адресов в whitelist
265   function addManyToWhitelist(address[] _beneficiaries) public onlyOwner {
266     for (uint256 i = 0; i < _beneficiaries.length; i++) {
267       whitelist[_beneficiaries[i]] = true;
268     }
269   }
270 
271   // Исключить адрес из whitelist
272   function removeFromWhitelist(address _beneficiary) public onlyOwner {
273     whitelist[_beneficiary] = false;
274   }
275 
276   // Узнать истек ли срок проведения PreICO
277   function hasPreICOClosed() public view returns (bool) {
278     return now > preICOEndDate;
279   }
280 
281   // Узнать истек ли срок проведения ICO
282   function hasICOClosed() public view returns (bool) {
283     return now > ICOEndDate;
284   }
285 
286   // Перевести собранные средства на кошелек для сбора
287   function forwardFunds () public onlyOwner {
288     require(now > ICOEndDate);
289     require((preICOWeiRaised.add(ICOWeiRaised)).mul(ETHUSD).div(10**18) >= softcap);
290 
291     wallet.transfer(ICOWeiRaised);
292   }
293 
294   // Вернуть проинвестированные средства, если не был достигнут softcap
295   function refund() public {
296     require(now > ICOEndDate);
297     require(preICOWeiRaised.add(ICOWeiRaised).mul(ETHUSD).div(10**18) < softcap);
298     require(investors[msg.sender] > 0);
299     
300     address investor = msg.sender;
301     investor.transfer(investors[investor]);
302   }
303   
304 
305   /* Внутренние методы */
306 
307    // Проверка актуальности PreICO
308    function _isPreICO() internal view returns(bool) {
309        return now >= preICOStartDate && now < preICOEndDate;
310    }
311    
312    // Проверка актуальности ICO
313    function _isICO() internal view returns(bool) {
314        return now >= ICOStartDate && now < ICOEndDate;
315    }
316 
317    // Валидация перед покупкой токенов
318 
319   function _preValidatePreICOPurchase(address _beneficiary, uint256 _weiAmount) internal view {
320     require(_weiAmount != 0);
321     require(whitelist[_beneficiary]);
322     require(now >= preICOStartDate && now <= preICOEndDate);
323   }
324 
325   function _preValidateICOPurchase(address _beneficiary, uint256 _weiAmount) internal view {
326     require(_weiAmount != 0);
327     require((preICOWeiRaised + ICOWeiRaised + _weiAmount).mul(ETHUSD).div(10**18) <= hardcap);
328     require(now >= ICOStartDate && now <= ICOEndDate);
329   }
330 
331   // Подсчет бонусов с учетом бонусов за этап ICO и объем инвестиций
332   function _getTokenAmountWithBonus(uint256 _weiAmount) internal view returns(uint256) {
333     uint256 baseTokenAmount = _weiAmount.mul(rate);
334     uint256 tokenAmount = baseTokenAmount;
335     uint256 usdAmount = _weiAmount.mul(ETHUSD).div(10**18);
336 
337     // Считаем бонусы за объем инвестиций
338     if(usdAmount >= 10000000){
339         tokenAmount = tokenAmount.add(baseTokenAmount.mul(7).div(100));
340     } else if(usdAmount >= 5000000){
341         tokenAmount = tokenAmount.add(baseTokenAmount.mul(5).div(100));
342     } else if(usdAmount >= 1000000){
343         tokenAmount = tokenAmount.add(baseTokenAmount.mul(3).div(100));
344     }
345     
346     // Считаем бонусы за этап ICO
347     if(now < ICOStartDate + 15 days) {
348         tokenAmount = tokenAmount.add(baseTokenAmount.mul(20).div(100));
349     } else if(now < ICOStartDate + 28 days) {
350         tokenAmount = tokenAmount.add(baseTokenAmount.mul(15).div(100));
351     } else if(now < ICOStartDate + 42 days) {
352         tokenAmount = tokenAmount.add(baseTokenAmount.mul(10).div(100));
353     } else {
354         tokenAmount = tokenAmount.add(baseTokenAmount.mul(5).div(100));
355     }
356 
357     return tokenAmount;
358   }
359 
360   // Подсчет бонусов с учетом бонусов реферальной системы
361   function _getTokenAmountWithReferal(uint256 _weiAmount, uint8 _percent) internal view returns(uint256) {
362     return _weiAmount.mul(rate).mul(_percent).div(100);
363   }
364 
365   // Перевод токенов
366   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
367     token.mint(_beneficiary, _tokenAmount);
368   }
369 }