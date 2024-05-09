1 pragma solidity ^0.4.21;
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
30     function transfer (address _beneficiary, uint256 _tokenAmount) external returns (bool);
31     function mint (address _to, uint256 _amount) external returns (bool);
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
48     using SafeMath for uint256;
49 
50     modifier onlyWhileOpen {
51         require(
52             (now >= preICOStartDate && now < preICOEndDate) ||
53             (now >= ICOStartDate && now < ICOEndDate)
54         );
55         _;
56     }
57 
58     modifier onlyWhileICOOpen {
59         require(now >= ICOStartDate && now < ICOEndDate);
60         _;
61     }
62 
63     // The token being sold
64     ERC20 public token;
65 
66     // Address where funds are collected
67     address public wallet;
68 
69     // Адрес оператора бекЭнда для управления вайтлистом
70     address public backendOperator = 0xd2420C5fDdA15B26AC3E13522e5cCD62CEB50e5F;
71 
72     // Сколько токенов покупатель получает за 1 эфир
73     uint256 public rate = 100;
74 
75     // Сколько эфиров привлечено в ходе PreICO, wei
76     uint256 public preICOWeiRaised = 1850570000000000000000;
77 
78     // Сколько эфиров привлечено в ходе ICO, wei
79     uint256 public ICOWeiRaised;
80 
81     // Цена ETH в центах
82     uint256 public ETHUSD;
83 
84     // Дата начала PreICO
85     uint256 public preICOStartDate;
86 
87     // Дата окончания PreICO
88     uint256 public preICOEndDate;
89 
90     // Дата начала ICO
91     uint256 public ICOStartDate;
92 
93     // Дата окончания ICO
94     uint256 public ICOEndDate;
95 
96     // Минимальный объем привлечения средств в ходе ICO в центах
97     uint256 public softcap = 300000000;
98 
99     // Потолок привлечения средств в ходе ICO в центах
100     uint256 public hardcap = 2500000000;
101 
102     // Бонус реферала, %
103     uint8 public referalBonus = 3;
104 
105     // Бонус приглашенного рефералом, %
106     uint8 public invitedByReferalBonus = 2;
107 
108     // Whitelist
109     mapping(address => bool) public whitelist;
110 
111     // Инвесторы, которые купили токен
112     mapping (address => uint256) public investors;
113 
114     event TokenPurchase(address indexed buyer, uint256 value, uint256 amount);
115 
116     function Crowdsale(
117         address _wallet,
118         uint256 _preICOStartDate,
119         uint256 _preICOEndDate,
120         uint256 _ICOStartDate,
121         uint256 _ICOEndDate,
122         uint256 _ETHUSD
123     ) public {
124         require(_preICOEndDate > _preICOStartDate);
125         require(_ICOStartDate > _preICOEndDate);
126         require(_ICOEndDate > _ICOStartDate);
127 
128         wallet = _wallet;
129         preICOStartDate = _preICOStartDate;
130         preICOEndDate = _preICOEndDate;
131         ICOStartDate = _ICOStartDate;
132         ICOEndDate = _ICOEndDate;
133         ETHUSD = _ETHUSD;
134     }
135 
136     modifier backEnd() {
137         require(msg.sender == backendOperator || msg.sender == owner);
138         _;
139     }
140 
141     /* Публичные методы */
142 
143     // Установить стоимость токена
144     function setRate (uint16 _rate) public onlyOwner {
145         require(_rate > 0);
146         rate = _rate;
147     }
148 
149     // Установить адрес кошелька для сбора средств
150     function setWallet (address _wallet) public onlyOwner {
151         require (_wallet != 0x0);
152         wallet = _wallet;
153     }
154 
155     // Установить торгуемый токен
156     function setToken (ERC20 _token) public onlyOwner {
157         token = _token;
158     }
159 
160     // Установить дату начала PreICO
161     function setPreICOStartDate (uint256 _preICOStartDate) public onlyOwner {
162         require(_preICOStartDate < preICOEndDate);
163         preICOStartDate = _preICOStartDate;
164     }
165 
166     // Установить дату окончания PreICO
167     function setPreICOEndDate (uint256 _preICOEndDate) public onlyOwner {
168         require(_preICOEndDate > preICOStartDate);
169         preICOEndDate = _preICOEndDate;
170     }
171 
172     // Установить дату начала ICO
173     function setICOStartDate (uint256 _ICOStartDate) public onlyOwner {
174         require(_ICOStartDate < ICOEndDate);
175         ICOStartDate = _ICOStartDate;
176     }
177 
178     // Установить дату окончания PreICO
179     function setICOEndDate (uint256 _ICOEndDate) public onlyOwner {
180         require(_ICOEndDate > ICOStartDate);
181         ICOEndDate = _ICOEndDate;
182     }
183 
184     // Установить стоимость эфира в центах
185     function setETHUSD (uint256 _ETHUSD) public onlyOwner {
186         ETHUSD = _ETHUSD;
187     }
188 
189     // Установить оператора БекЭнда для управления вайтлистом
190     function setBackendOperator(address newOperator) public onlyOwner {
191         backendOperator = newOperator;
192     }
193 
194     function () external payable {
195         address beneficiary = msg.sender;
196         uint256 weiAmount = msg.value;
197         uint256 tokens;
198 
199         if(_isPreICO()){
200 
201             _preValidatePreICOPurchase(beneficiary, weiAmount);
202             tokens = weiAmount.mul(rate.add(rate.mul(30).div(100)));
203             preICOWeiRaised = preICOWeiRaised.add(weiAmount);
204             wallet.transfer(weiAmount);
205             investors[beneficiary] = weiAmount;
206             _deliverTokens(beneficiary, tokens);
207             emit TokenPurchase(beneficiary, weiAmount, tokens);
208 
209         } else if(_isICO()){
210 
211             _preValidateICOPurchase(beneficiary, weiAmount);
212             tokens = _getTokenAmountWithBonus(weiAmount);
213             ICOWeiRaised = ICOWeiRaised.add(weiAmount);
214             investors[beneficiary] = weiAmount;
215             _deliverTokens(beneficiary, tokens);
216             emit TokenPurchase(beneficiary, weiAmount, tokens);
217 
218         }
219     }
220 
221     // Покупка токенов с реферальным бонусом
222     function buyTokensWithReferal(address _referal) public onlyWhileICOOpen payable {
223         address beneficiary = msg.sender;
224         uint256 weiAmount = msg.value;
225 
226         _preValidateICOPurchase(beneficiary, weiAmount);
227 
228         uint256 tokens = _getTokenAmountWithBonus(weiAmount).add(_getTokenAmountWithReferal(weiAmount, 2));
229         uint256 referalTokens = _getTokenAmountWithReferal(weiAmount, 3);
230 
231         ICOWeiRaised = ICOWeiRaised.add(weiAmount);
232         investors[beneficiary] = weiAmount;
233 
234         _deliverTokens(beneficiary, tokens);
235         _deliverTokens(_referal, referalTokens);
236 
237         emit TokenPurchase(beneficiary, weiAmount, tokens);
238     }
239 
240     // Добавить адрес в whitelist
241     function addToWhitelist(address _beneficiary) public backEnd {
242         whitelist[_beneficiary] = true;
243     }
244 
245     // Добавить несколько адресов в whitelist
246     function addManyToWhitelist(address[] _beneficiaries) public backEnd {
247         for (uint256 i = 0; i < _beneficiaries.length; i++) {
248             whitelist[_beneficiaries[i]] = true;
249         }
250     }
251 
252     // Исключить адрес из whitelist
253     function removeFromWhitelist(address _beneficiary) public backEnd {
254         whitelist[_beneficiary] = false;
255     }
256 
257     // Узнать истек ли срок проведения PreICO
258     function hasPreICOClosed() public view returns (bool) {
259         return now > preICOEndDate;
260     }
261 
262     // Узнать истек ли срок проведения ICO
263     function hasICOClosed() public view returns (bool) {
264         return now > ICOEndDate;
265     }
266 
267     // Перевести собранные средства на кошелек для сбора
268     function forwardFunds () public onlyOwner {
269         require(now > ICOEndDate);
270         require((preICOWeiRaised.add(ICOWeiRaised)).mul(ETHUSD).div(10**18) >= softcap);
271 
272         wallet.transfer(ICOWeiRaised);
273     }
274 
275     // Вернуть проинвестированные средства, если не был достигнут softcap
276     function refund() public {
277         require(now > ICOEndDate);
278         require(preICOWeiRaised.add(ICOWeiRaised).mul(ETHUSD).div(10**18) < softcap);
279         require(investors[msg.sender] > 0);
280 
281         address investor = msg.sender;
282         investor.transfer(investors[investor]);
283     }
284 
285 
286     /* Внутренние методы */
287 
288     // Проверка актуальности PreICO
289     function _isPreICO() internal view returns(bool) {
290         return now >= preICOStartDate && now < preICOEndDate;
291     }
292 
293     // Проверка актуальности ICO
294     function _isICO() internal view returns(bool) {
295         return now >= ICOStartDate && now < ICOEndDate;
296     }
297 
298     // Валидация перед покупкой токенов
299 
300     function _preValidatePreICOPurchase(address _beneficiary, uint256 _weiAmount) internal view {
301         require(_weiAmount != 0);
302         require(whitelist[_beneficiary]);
303         require(now >= preICOStartDate && now <= preICOEndDate);
304     }
305 
306     function _preValidateICOPurchase(address _beneficiary, uint256 _weiAmount) internal view {
307         require(_weiAmount != 0);
308         require(whitelist[_beneficiary]);
309         require((preICOWeiRaised + ICOWeiRaised + _weiAmount).mul(ETHUSD).div(10**18) <= hardcap);
310         require(now >= ICOStartDate && now <= ICOEndDate);
311     }
312 
313     // Подсчет бонусов с учетом бонусов за этап ICO и объем инвестиций
314     function _getTokenAmountWithBonus(uint256 _weiAmount) internal view returns(uint256) {
315         uint256 baseTokenAmount = _weiAmount.mul(rate);
316         uint256 tokenAmount = baseTokenAmount;
317         uint256 usdAmount = _weiAmount.mul(ETHUSD).div(10**18);
318 
319         // Считаем бонусы за объем инвестиций
320         if(usdAmount >= 10000000){
321             tokenAmount = tokenAmount.add(baseTokenAmount.mul(7).div(100));
322         } else if(usdAmount >= 5000000){
323             tokenAmount = tokenAmount.add(baseTokenAmount.mul(5).div(100));
324         } else if(usdAmount >= 1000000){
325             tokenAmount = tokenAmount.add(baseTokenAmount.mul(3).div(100));
326         }
327 
328         // Считаем бонусы за этап ICO
329         if(now < ICOStartDate + 30 days) {
330             tokenAmount = tokenAmount.add(baseTokenAmount.mul(20).div(100));
331         } else if(now < ICOStartDate + 60 days) {
332             tokenAmount = tokenAmount.add(baseTokenAmount.mul(15).div(100));
333         } else if(now < ICOStartDate + 90 days) {
334             tokenAmount = tokenAmount.add(baseTokenAmount.mul(10).div(100));
335         } else {
336             tokenAmount = tokenAmount.add(baseTokenAmount.mul(5).div(100));
337         }
338 
339         return tokenAmount;
340     }
341 
342     // Подсчет бонусов с учетом бонусов реферальной системы
343     function _getTokenAmountWithReferal(uint256 _weiAmount, uint8 _percent) internal view returns(uint256) {
344         return _weiAmount.mul(rate).mul(_percent).div(100);
345     }
346 
347     // Перевод токенов
348     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
349         token.mint(_beneficiary, _tokenAmount);
350     }
351 }