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
121     require(_wallet != address(0));
122     require(_preICOStartDate >= now);
123     require(_preICOEndDate > _preICOStartDate);
124     require(_ICOStartDate > _preICOEndDate);
125     require(_ICOEndDate > _ICOStartDate);
126 
127     wallet = _wallet;
128     preICOStartDate = _preICOStartDate;
129     preICOEndDate = _preICOEndDate;
130     ICOStartDate = _ICOStartDate;
131     ICOStartDate = _ICOStartDate;
132     ETHUSD = _ETHUSD;
133   }
134 
135   /* Публичные методы */
136 
137   // Установить стоимость токена
138   function setRate (uint16 _rate) public onlyOwner {
139     require(_rate > 0);
140     rate = _rate;
141   }
142 
143   // Установить адрес кошелька для сбора средств
144   function setWallet (address _wallet) public onlyOwner {
145     require (_wallet != 0x0);
146     wallet = _wallet;
147       
148   }
149   
150 
151   // Установить торгуемый токен
152   function setToken (ERC20 _token) public onlyOwner {
153     token = _token;
154   }
155   
156   // Установить дату начала PreICO
157   function setPreICOStartDate (uint256 _preICOStartDate) public onlyOwner {
158     require(_preICOStartDate < preICOEndDate);
159     preICOStartDate = _preICOStartDate;
160   }
161 
162   // Установить дату окончания PreICO
163   function setPreICOEndDate (uint256 _preICOEndDate) public onlyOwner {
164     require(_preICOEndDate > preICOStartDate);
165     preICOEndDate = _preICOEndDate;
166   }
167 
168   // Установить дату начала ICO
169   function setICOStartDate (uint256 _ICOStartDate) public onlyOwner {
170     require(_ICOStartDate < ICOEndDate);
171     ICOStartDate = _ICOStartDate;
172   }
173 
174   // Установить дату окончания PreICO
175   function setICOEndDate (uint256 _ICOEndDate) public onlyOwner {
176     require(_ICOEndDate > ICOStartDate);
177     ICOEndDate = _ICOEndDate;
178   }
179 
180   // Установить стоимость эфира в центах
181   function setETHUSD (uint256 _ETHUSD) public onlyOwner {
182     ETHUSD = _ETHUSD;
183   }
184 
185   function () external payable {
186     buyTokens();
187   }
188 
189   // Покупка токенов
190   function buyTokens() public onlyWhileOpen payable {
191     address beneficiary = msg.sender;
192     uint256 weiAmount = msg.value;
193 
194     _preValidatePurchase(beneficiary, weiAmount);
195 
196     uint256 tokens;
197 
198     // Считаем сколько токенов перевести в зависимости от этапа продажи
199     if(_isPreICO()){
200         tokens = weiAmount.mul(rate.add(rate.mul(30).div(100)));
201         preICOWeiRaised = preICOWeiRaised.add(weiAmount);
202         wallet.transfer(weiAmount);
203     } else {
204         tokens = _getTokenAmountWithBonus(weiAmount);
205         ICOWeiRaised = ICOWeiRaised.add(weiAmount);
206     }
207     
208     investors[beneficiary] = weiAmount;
209 
210     _deliverTokens(beneficiary, tokens);
211 
212     emit TokenPurchase(beneficiary, weiAmount, tokens);
213   }
214 
215     // Покупка токенов с реферальным бонусом
216   function buyTokensWithReferal(address _referal) public onlyWhileICOOpen payable {
217     address beneficiary = msg.sender;    
218     uint256 weiAmount = msg.value;
219 
220     _preValidatePurchase(beneficiary, weiAmount);
221 
222     uint256 tokens = _getTokenAmountWithBonus(weiAmount).add(_getTokenAmountWithReferal(weiAmount, 2));
223     uint256 referalTokens = _getTokenAmountWithReferal(weiAmount, 3);
224 
225     ICOWeiRaised = ICOWeiRaised.add(weiAmount);
226     investors[beneficiary] = weiAmount;
227 
228     _deliverTokens(beneficiary, tokens);
229     _deliverTokens(_referal, referalTokens);
230 
231     emit TokenPurchase(beneficiary, weiAmount, tokens);
232   }
233 
234   // Добавить адрес в whitelist
235   function addToWhitelist(address _beneficiary) public onlyOwner {
236     whitelist[_beneficiary] = true;
237   }
238 
239   // Добавить несколько адресов в whitelist
240   function addManyToWhitelist(address[] _beneficiaries) public onlyOwner {
241     for (uint256 i = 0; i < _beneficiaries.length; i++) {
242       whitelist[_beneficiaries[i]] = true;
243     }
244   }
245 
246   // Исключить адрес из whitelist
247   function removeFromWhitelist(address _beneficiary) public onlyOwner {
248     whitelist[_beneficiary] = false;
249   }
250 
251   // Узнать истек ли срок проведения PreICO
252   function hasPreICOClosed() public view returns (bool) {
253     return now > preICOEndDate;
254   }
255 
256   // Узнать истек ли срок проведения ICO
257   function hasICOClosed() public view returns (bool) {
258     return now > ICOEndDate;
259   }
260 
261   // Перевести собранные средства на кошелек для сбора
262   function forwardFunds () public onlyOwner {
263     require(now > ICOEndDate);
264     require((preICOWeiRaised.add(ICOWeiRaised)).mul(ETHUSD).div(10**18) >= softcap);
265 
266     wallet.transfer(ICOWeiRaised);
267   }
268 
269   // Вернуть проинвестированные средства, если не был достигнут softcap
270   function refund() public {
271     require(now > ICOEndDate);
272     require(preICOWeiRaised.add(ICOWeiRaised).mul(ETHUSD).div(10**18) < softcap);
273     require(investors[msg.sender] > 0);
274     
275     address investor = msg.sender;
276     investor.transfer(investors[investor]);
277   }
278   
279 
280   /* Внутренние методы */
281 
282    // Проверка актуальности PreICO
283    function _isPreICO() internal view returns(bool) {
284        return now >= preICOStartDate && now < preICOEndDate;
285    }
286    
287    // Проверка актуальности ICO
288    function _isICO() internal view returns(bool) {
289        return now >= ICOStartDate && now < ICOEndDate;
290    }
291 
292    // Валидация перед покупкой токенов
293   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view onlyWhileOpen {
294     require(_weiAmount != 0);
295     require((preICOWeiRaised.add(ICOWeiRaised).add(_weiAmount)).mul(ETHUSD).div(10**18) <= hardcap);
296     require((_isPreICO() && whitelist[_beneficiary]) || _isICO());
297   }
298 
299   // Подсчет бонусов с учетом бонусов за этап ICO и объем инвестиций
300   function _getTokenAmountWithBonus(uint256 _weiAmount) internal view returns(uint256) {
301     uint256 baseTokenAmount = _weiAmount.mul(rate);
302     uint256 tokenAmount = baseTokenAmount;
303     uint256 usdAmount = _weiAmount.mul(ETHUSD).div(10**18);
304 
305     // Считаем бонусы за объем инвестиций
306     if(usdAmount >= 10000000){
307         tokenAmount = tokenAmount.add(baseTokenAmount.mul(7).div(100));
308     } else if(usdAmount >= 5000000){
309         tokenAmount = tokenAmount.add(baseTokenAmount.mul(5).div(100));
310     } else if(usdAmount >= 1000000){
311         tokenAmount = tokenAmount.add(baseTokenAmount.mul(3).div(100));
312     }
313     
314     // Считаем бонусы за этап ICO
315     if(now < ICOStartDate + 15 days) {
316         tokenAmount = tokenAmount.add(baseTokenAmount.mul(20).div(100));
317     } else if(now < ICOStartDate + 28 days) {
318         tokenAmount = tokenAmount.add(baseTokenAmount.mul(15).div(100));
319     } else if(now < ICOStartDate + 42 days) {
320         tokenAmount = tokenAmount.add(baseTokenAmount.mul(10).div(100));
321     } else {
322         tokenAmount = tokenAmount.add(baseTokenAmount.mul(5).div(100));
323     }
324 
325     return tokenAmount;
326   }
327 
328   // Подсчет бонусов с учетом бонусов реферальной системы
329   function _getTokenAmountWithReferal(uint256 _weiAmount, uint8 _percent) internal view returns(uint256) {
330     return _weiAmount.mul(rate).mul(_percent).div(100);
331   }
332 
333   // Перевод токенов
334   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
335     token.mint(_beneficiary, _tokenAmount);
336   }
337 }