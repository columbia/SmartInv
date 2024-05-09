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
143   // Установить торгуемый токен
144   function setToken (ERC20 _token) public onlyOwner {
145     token = _token;
146   }
147   
148   // Установить дату начала PreICO
149   function setPreICOStartDate (uint256 _preICOStartDate) public onlyOwner {
150     require(_preICOStartDate < preICOEndDate);
151     preICOStartDate = _preICOStartDate;
152   }
153 
154   // Установить дату окончания PreICO
155   function setPreICOEndDate (uint256 _preICOEndDate) public onlyOwner {
156     require(_preICOEndDate > preICOStartDate);
157     preICOEndDate = _preICOEndDate;
158   }
159 
160   // Установить дату начала ICO
161   function setICOStartDate (uint256 _ICOStartDate) public onlyOwner {
162     require(_ICOStartDate < ICOEndDate);
163     ICOStartDate = _ICOStartDate;
164   }
165 
166   // Установить дату окончания PreICO
167   function setICOEndDate (uint256 _ICOEndDate) public onlyOwner {
168     require(_ICOEndDate > ICOStartDate);
169     ICOEndDate = _ICOEndDate;
170   }
171 
172   // Установить стоимость эфира в центах
173   function setETHUSD (uint256 _ETHUSD) public onlyOwner {
174     ETHUSD = _ETHUSD;
175   }
176 
177   function () external payable {
178     buyTokens();
179   }
180 
181   // Покупка токенов
182   function buyTokens() public onlyWhileOpen payable {
183     address beneficiary = msg.sender;
184     uint256 weiAmount = msg.value;
185 
186     _preValidatePurchase(beneficiary, weiAmount);
187 
188     uint256 tokens;
189 
190     // Считаем сколько токенов перевести в зависимости от этапа продажи
191     if(_isPreICO()){
192         tokens = weiAmount.mul(rate.add(rate.mul(30).div(100)));
193         preICOWeiRaised = preICOWeiRaised.add(weiAmount);
194         wallet.transfer(weiAmount);
195     } else {
196         tokens = _getTokenAmountWithBonus(weiAmount);
197         ICOWeiRaised = ICOWeiRaised.add(weiAmount);
198     }
199     
200     investors[beneficiary] = weiAmount;
201 
202     _deliverTokens(beneficiary, tokens);
203 
204     emit TokenPurchase(beneficiary, weiAmount, tokens);
205   }
206 
207     // Покупка токенов с реферальным бонусом
208   function buyTokensWithReferal(address _referal) public onlyWhileICOOpen payable {
209     address beneficiary = msg.sender;    
210     uint256 weiAmount = msg.value;
211 
212     _preValidatePurchase(beneficiary, weiAmount);
213 
214     uint256 tokens = _getTokenAmountWithBonus(weiAmount).add(_getTokenAmountWithReferal(weiAmount, 2));
215     uint256 referalTokens = _getTokenAmountWithReferal(weiAmount, 3);
216 
217     ICOWeiRaised = ICOWeiRaised.add(weiAmount);
218     investors[beneficiary] = weiAmount;
219 
220     _deliverTokens(beneficiary, tokens);
221     _deliverTokens(_referal, referalTokens);
222 
223     emit TokenPurchase(beneficiary, weiAmount, tokens);
224   }
225 
226   // Добавить адрес в whitelist
227   function addToWhitelist(address _beneficiary) public onlyOwner {
228     whitelist[_beneficiary] = true;
229   }
230 
231   // Добавить несколько адресов в whitelist
232   function addManyToWhitelist(address[] _beneficiaries) public onlyOwner {
233     for (uint256 i = 0; i < _beneficiaries.length; i++) {
234       whitelist[_beneficiaries[i]] = true;
235     }
236   }
237 
238   // Исключить адрес из whitelist
239   function removeFromWhitelist(address _beneficiary) public onlyOwner {
240     whitelist[_beneficiary] = false;
241   }
242 
243   // Узнать истек ли срок проведения PreICO
244   function hasPreICOClosed() public view returns (bool) {
245     return now > preICOEndDate;
246   }
247 
248   // Узнать истек ли срок проведения ICO
249   function hasICOClosed() public view returns (bool) {
250     return now > ICOEndDate;
251   }
252 
253   // Перевести собранные средства на кошелек для сбора
254   function forwardFunds () public onlyOwner {
255     require(now > ICOEndDate);
256     require((preICOWeiRaised.add(ICOWeiRaised)).mul(ETHUSD).div(10**18) >= softcap);
257 
258     wallet.transfer(ICOWeiRaised);
259   }
260 
261   // Вернуть проинвестированные средства, если не был достигнут softcap
262   function refund() public {
263     require(now > ICOEndDate);
264     require(preICOWeiRaised.add(ICOWeiRaised).mul(ETHUSD).div(10**18) < softcap);
265     require(investors[msg.sender] > 0);
266     
267     address investor = msg.sender;
268     investor.transfer(investors[investor]);
269   }
270   
271 
272   /* Внутренние методы */
273 
274    // Проверка актуальности PreICO
275    function _isPreICO() internal view returns(bool) {
276        return now >= preICOStartDate && now < preICOEndDate;
277    }
278    
279    // Проверка актуальности ICO
280    function _isICO() internal view returns(bool) {
281        return now >= ICOStartDate && now < ICOEndDate;
282    }
283 
284    // Валидация перед покупкой токенов
285   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view onlyWhileOpen {
286     require(_weiAmount != 0);
287     require((preICOWeiRaised.add(ICOWeiRaised).add(_weiAmount)).mul(ETHUSD).div(10**18) <= hardcap);
288     require((_isPreICO() && whitelist[_beneficiary]) || _isICO());
289   }
290 
291   // Подсчет бонусов с учетом бонусов за этап ICO и объем инвестиций
292   function _getTokenAmountWithBonus(uint256 _weiAmount) internal view returns(uint256) {
293     uint256 baseTokenAmount = _weiAmount.mul(rate);
294     uint256 tokenAmount = baseTokenAmount;
295     uint256 usdAmount = _weiAmount.mul(ETHUSD).div(10**18);
296 
297     // Считаем бонусы за объем инвестиций
298     if(usdAmount >= 10000000){
299         tokenAmount = tokenAmount.add(baseTokenAmount.mul(7).div(100));
300     } else if(usdAmount >= 5000000){
301         tokenAmount = tokenAmount.add(baseTokenAmount.mul(5).div(100));
302     } else if(usdAmount >= 1000000){
303         tokenAmount = tokenAmount.add(baseTokenAmount.mul(3).div(100));
304     }
305     
306     // Считаем бонусы за этап ICO
307     if(now < ICOStartDate + 15 days) {
308         tokenAmount = tokenAmount.add(baseTokenAmount.mul(20).div(100));
309     } else if(now < ICOStartDate + 28 days) {
310         tokenAmount = tokenAmount.add(baseTokenAmount.mul(15).div(100));
311     } else if(now < ICOStartDate + 42 days) {
312         tokenAmount = tokenAmount.add(baseTokenAmount.mul(10).div(100));
313     } else {
314         tokenAmount = tokenAmount.add(baseTokenAmount.mul(5).div(100));
315     }
316 
317     return tokenAmount;
318   }
319 
320   // Подсчет бонусов с учетом бонусов реферальной системы
321   function _getTokenAmountWithReferal(uint256 _weiAmount, uint8 _percent) internal view returns(uint256) {
322     return _weiAmount.mul(rate).mul(_percent).div(100);
323   }
324 
325   // Перевод токенов
326   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
327     token.mint(_beneficiary, _tokenAmount);
328   }
329 }