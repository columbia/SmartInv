1 pragma solidity ^0.4.4;
2 
3 contract ERC20Basic {
4     uint256 public totalSupply;
5     function balanceOf(address who) public constant returns (uint256 balance);
6     function transfer(address to, uint256 value) public returns (bool success);
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 } 
9 
10 contract ERC20 is ERC20Basic {
11     function allowance(address owner, address spender) public constant returns (uint256 remaining);
12     function transferFrom(address from, address to, uint256 value) public returns (bool success);
13     function approve(address spender, uint256 value) public returns (bool success);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22     
23     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
24         uint256 c = a * b;
25         assert(a == 0 || c / a == b);
26         return c;
27     }
28 
29     function div(uint256 a, uint256 b) internal constant returns (uint256) {
30         // assert(b > 0); // Solidity automatically throws when dividing by 0
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33         return c;
34     }
35 
36     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
37         assert(b <= a);
38         return a - b;
39     }
40 
41     function add(uint256 a, uint256 b) internal constant returns (uint256) {
42         uint256 c = a + b;
43         assert(c >= a);
44         return c;
45     }
46   
47 }
48 
49 /**
50  * @title Basic token
51  * @dev Basic version of StandardToken, with no allowances. 
52  */
53 contract BasicToken is ERC20Basic {
54     
55     using SafeMath for uint256;
56 
57     mapping(address => uint256) public balances;
58 
59     /**
60     * @dev transfer token for a specified address
61     * @param _to The address to transfer to.
62     * @param _value The amount to be transferred.
63     */
64     function transfer(address _to, uint256 _value) public returns (bool success)  {
65         balances[msg.sender] = balances[msg.sender].sub(_value);
66         balances[_to] = balances[_to].add(_value);
67         Transfer(msg.sender, _to, _value);
68         return true;
69     }
70 
71     /**
72     * @dev Gets the balance of the specified address.
73     * @param _owner The address to query the the balance of. 
74     * @return An uint256 representing the amount owned by the passed address.
75     */
76     function balanceOf(address _owner) public constant returns (uint256 balance)  {
77         return balances[_owner];
78     }
79  
80 }
81  
82 /**
83  * @title Standard ERC20 token
84  *
85  * @dev Implementation of the basic standard token.
86  */
87 contract StandardToken is ERC20, BasicToken {
88  
89     mapping (address => mapping (address => uint256)) allowed;
90 
91     /**
92     * @dev Transfer tokens from one address to another
93     * @param _from address The address which you want to send tokens from
94     * @param _to address The address which you want to transfer to
95     * @param _value uint256 the amout of tokens to be transfered
96     */
97     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)  {
98         uint256 _allowance = allowed[_from][msg.sender];
99 
100         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
101         // require (_value <= _allowance);
102 
103         balances[_to] = balances[_to].add(_value);
104         balances[_from] = balances[_from].sub(_value);
105         allowed[_from][msg.sender] = _allowance.sub(_value);
106         Transfer(_from, _to, _value);
107         return true;
108     }
109 
110     /**
111     * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
112     * @param _spender The address which will spend the funds.
113     * @param _value The amount of tokens to be spent.
114     */
115     function approve(address _spender, uint256 _value) public returns (bool success)  {
116 
117         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
118 
119         allowed[msg.sender][_spender] = _value;
120         Approval(msg.sender, _spender, _value);
121         return true;
122     }
123 
124     /**
125     * @dev Function to check the amount of tokens that an owner allowed to a spender.
126     * @param _owner address The address which owns the funds.
127     * @param _spender address The address which will spend the funds.
128     * @return A uint256 specifing the amount of tokens still available for the spender.
129     */
130     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
131         return allowed[_owner][_spender];
132     }
133  
134 }
135  
136 /**
137  * @title Ownable
138  * @dev The Ownable contract has an owner address, and provides basic authorization control
139  * functions, this simplifies the implementation of "user permissions".
140  */
141 contract Ownable {
142     
143     address public owner;
144 
145     /**
146     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
147     * account.
148     */
149     function Ownable()  public {
150         owner = msg.sender;
151     }
152 
153     /**
154     * @dev Throws if called by any account other than the owner.
155     */
156     modifier onlyOwner() {
157         require(msg.sender == owner);
158         _;
159     }
160 
161     /**
162     * @dev Allows the current owner to transfer control of the contract to a newOwner.
163     * @param newOwner The address to transfer ownership to.
164     */
165     function transferOwnership(address newOwner) onlyOwner  public {
166         require(newOwner != address(0));      
167         owner = newOwner;
168     }
169  
170 }
171  
172 /**
173  * @title Mintable token
174  * @dev Simple ERC20 Token example, with mintable token creation
175  */
176  
177 contract MintableToken is StandardToken, Ownable {
178     
179     event Mint(address indexed to, uint256 amount);
180 
181     event MintFinished();
182 
183     bool public mintingFinished = false;
184 
185     modifier canMint() {
186         require(!mintingFinished);
187         _;
188     }
189 
190     /**
191     * @dev Function to mint tokens
192     * @param _to The address that will recieve the minted tokens.
193     * @param _amount The amount of tokens to mint.
194     * @return A boolean that indicates if the operation was successful.
195     */
196     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
197         totalSupply = totalSupply.add(_amount);
198         balances[_to] = balances[_to].add(_amount);
199         Mint(_to, _amount);
200         Transfer(address(0), _to, _amount); 
201         return true;
202     }
203 
204     /**
205     * @dev Function to stop minting new tokens.
206     * @return True if the operation was successful.
207     */
208     function finishMinting() public onlyOwner returns (bool)  {
209         mintingFinished = true;
210         MintFinished();
211         return true;
212     }
213   
214 }
215 
216 
217 // Токен 
218 contract GWTToken is MintableToken {
219     
220     string public constant name = "Global Wind Token";
221     
222     string public constant symbol = "GWT";
223     
224     uint32 public constant decimals = 18; 
225 
226 }
227 
228 // Контракт краудсейла
229 contract GWTCrowdsale is Ownable {
230     using SafeMath for uint;
231 
232     uint public supplyLimit;         // Лимит выпуска токенов
233 
234     address ethAddress;              // Адрес получателя эфира
235     uint saleStartTimestamp;         // Таймштамп запуска контракта
236 
237     uint public currentStageNumber;  // Номер периода
238     uint currentStageStartTimestamp; // Таймштамп старта периода
239     uint currentStageEndTimestamp;   // Таймштамп окончания периода
240     uint currentStagePeriodDays;     // Кол-во дней (в тестовом минут) проведения периода краудсейла
241     uint public baseExchangeRate;    // Курс обмена на токены
242     uint currentStageMultiplier;     // Множитель для разных этапов:     bcostReal = baseExchangeRate * currentStageMultiplier
243 
244     uint constant M = 1000000000000000000;  // 1 GWT = 10^18 GWTunits (wei)
245 
246     uint[] _percs = [40, 30, 25, 20, 15, 10, 5, 0, 0];  // Бонусные проценты
247     uint[] _days  = [42, 1, 27, 1, 7, 7, 7, 14, 0];      // Продолжительность в днях
248 
249     // Лимиты на выпуск токенов
250     uint PrivateSaleLimit = M.mul(420000000);
251     uint PreSaleLimit = M.mul(1300000000);
252     uint TokenSaleLimit = M.mul(8400000000);
253     uint RetailLimit = M.mul(22490000000);
254 
255     // Курсы обмена токенов на эфир
256     uint TokensaleRate = M.mul(160000);
257     uint RetailRate = M.mul(16000);
258 
259     GWTToken public token = new GWTToken(); // Токен
260 
261     // Активен ли краудсейл
262     modifier isActive() {
263         require(isInActiveStage());
264         _;
265     }
266 
267     function isInActiveStage() private returns(bool) {
268         if (currentStageNumber == 8) return true;
269         if (now >= currentStageStartTimestamp && now <= currentStageEndTimestamp){
270             return true;
271         }else if (now < currentStageStartTimestamp) {
272             return false;
273         }else if (now > currentStageEndTimestamp){
274             if (currentStageNumber == 0 || currentStageNumber == 2 || currentStageNumber == 7) return false;
275             switchPeriod();
276             // It is not possible for stage to be finished after straight the start
277             // Also new set currentStageStartTimestamp and currentStageEndTimestamp should be valid by definition
278             //return isInActiveStage();
279             return true;
280         }
281         // That will never get reached
282         return false;
283     }
284 
285     // Перейти к следующему периоду
286     function switchPeriod() private onlyOwner {
287         if (currentStageNumber == 8) return;
288 
289         currentStageNumber++;
290         currentStageStartTimestamp = currentStageEndTimestamp; // Запуск производится от конца прошлого периода, если нужно запустить с текущего момента поменяйте на now
291         currentStagePeriodDays = _days[currentStageNumber];
292         currentStageEndTimestamp = currentStageStartTimestamp + currentStagePeriodDays * 1 days;
293         currentStageMultiplier = _percs[currentStageNumber];
294 
295         if(currentStageNumber == 0 ){
296             supplyLimit = PrivateSaleLimit;
297         } else if(currentStageNumber < 3){
298             supplyLimit = PreSaleLimit;
299         } else if(currentStageNumber < 8){
300             supplyLimit = TokenSaleLimit;
301         } else {
302             // Base rate for phase 8 should update exchange rate
303             baseExchangeRate = RetailRate;
304             supplyLimit = RetailLimit;
305         }
306     }
307 
308     function setStage(uint _index) public onlyOwner {
309         require(_index >= 0 && _index < 9);
310         
311         if (_index == 0) return startPrivateSale();
312         currentStageNumber = _index - 1;
313         currentStageEndTimestamp = now;
314         switchPeriod();
315     }
316 
317     // Установить курс обмена
318     function setRate(uint _rate) public onlyOwner {
319         baseExchangeRate = _rate;
320     }
321 
322     // Установить можитель
323     function setBonus(uint _bonus) public onlyOwner {
324         currentStageMultiplier = _bonus;
325     }
326 
327     function setTokenOwner(address _newTokenOwner) public onlyOwner {
328         token.transferOwnership(_newTokenOwner);
329     }
330 
331     // Установить продолжительность текущего периода в днях
332     function setPeriodLength(uint _length) public onlyOwner {
333         // require(now < currentStageStartTimestamp + _length * 1 days);
334         currentStagePeriodDays = _length;
335         currentStageEndTimestamp = currentStageStartTimestamp + currentStagePeriodDays * 1 days;
336     }
337 
338     // Изменить лимит выпуска токенов
339     function modifySupplyLimit(uint _new) public onlyOwner {
340         if (_new >= token.totalSupply()){
341             supplyLimit = _new;
342         }
343     }
344 
345     // Выпустить токены на кошелек
346     function mintFor(address _to, uint _val) public onlyOwner isActive payable {
347         require(token.totalSupply() + _val <= supplyLimit);
348         token.mint(_to, _val);
349     }
350 
351     // Прекратить выпуск токенов
352     // ВНИМАНИЕ! После вызова этой функции перезапуск будет невозможен!
353     function closeMinting() public onlyOwner {
354         token.finishMinting();
355     }
356 
357     // Запуск прив. сейла
358     function startPrivateSale() public onlyOwner {
359         currentStageNumber = 0;
360         currentStageStartTimestamp = now;
361         currentStagePeriodDays = _days[0];
362         currentStageMultiplier = _percs[0];
363         supplyLimit = PrivateSaleLimit;
364         currentStageEndTimestamp = currentStageStartTimestamp + currentStagePeriodDays * 1 days;
365         baseExchangeRate = TokensaleRate;
366     }
367 
368     function startPreSale() public onlyOwner {
369         currentStageNumber = 0;
370         currentStageEndTimestamp = now;
371         switchPeriod();
372     }
373 
374     function startTokenSale() public onlyOwner {
375         currentStageNumber = 2;
376         currentStageEndTimestamp = now;
377         switchPeriod();
378     }
379 
380     function endTokenSale() public onlyOwner {
381         currentStageNumber = 7;
382         currentStageEndTimestamp = now;
383         switchPeriod();
384     }
385 
386     // 000000000000000000 - 18 нулей, добавить к сумме в целых GWT
387     // Старт
388     function GWTCrowdsale() public {
389         // Init
390         ethAddress = 0xB93B2be636e39340f074F0c7823427557941Be42;  // Записываем адрес, на который будет пересылаться эфир
391         // ethAddress = 0x16a49c8af25b3c2ff315934bf38a4cf645813844; // Dev
392         saleStartTimestamp = now;                                       // Записываем дату деплоя
393         startPrivateSale();
394     }
395 
396     function changeEthAddress(address _newAddress) public onlyOwner {
397         ethAddress = _newAddress;
398     }
399 
400     // Автоматическая покупка токенов
401     function createTokens() public isActive payable {
402         uint tokens = baseExchangeRate.mul(msg.value).div(1 ether); // Переводим ETH в GWT
403 
404         if (currentStageMultiplier > 0 && currentStageEndTimestamp > now) {            // Начисляем бонус
405             tokens = tokens + tokens.div(100).mul(currentStageMultiplier);
406         }
407         // require(tokens > minLimit && tokens < buyLimit);
408         require(token.totalSupply() + tokens <= supplyLimit);
409         ethAddress.transfer(msg.value);   // переводим на основной кошелек
410         token.mint(msg.sender, tokens); // Начисляем
411     }
412 
413     // Если кто-то перевел эфир на контракт
414     function() external payable {
415         createTokens(); // Вызываем функцию начисления токенов
416     }
417 
418 }