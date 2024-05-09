1 pragma solidity ^0.4.21;
2 
3 
4 contract Platform
5 {
6     address public platform = 0x709a0A8deB88A2d19DAB2492F669ef26Fd176f6C;
7 
8     modifier onlyPlatform() {
9         require(msg.sender == platform);
10         _;
11     }
12 
13     function isPlatform() public view returns (bool) {
14         return platform == msg.sender;
15     }
16 }
17 
18 
19 contract ERC20Basic {
20   uint256 public totalSupply;
21   function balanceOf(address who) public constant returns (uint256);
22   function transfer(address to, uint256 value) public returns (bool);
23   event Transfer(address indexed from, address indexed to, uint256 value);
24 }
25 
26 
27 contract ERC20 is ERC20Basic {
28   function allowance(address owner, address spender) public constant returns (uint256);
29   function transferFrom(address from, address to, uint256 value) public returns (bool);
30   function approve(address spender, uint256 value) public returns (bool);
31   event Approval(address indexed owner, address indexed spender, uint256 value);
32 }
33 
34 /**
35  * @title SafeMath
36  * @dev Math operations with safety checks that throw on error
37  */
38 library SafeMath {
39   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40     if (a == 0) {
41       return 0;
42     }
43     uint256 c = a * b;
44     assert(c / a == b);
45     return c;
46   }
47 
48   function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     // assert(b > 0); // Solidity automatically throws when dividing by 0
50     uint256 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52     return c;
53   }
54 
55   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56     assert(b <= a);
57     return a - b;
58   }
59 
60   function add(uint256 a, uint256 b) internal pure returns (uint256) {
61     uint256 c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 }
66 
67 
68 
69 contract BeneficiaryInterface
70 {
71     function getAvailableWithdrawInvestmentsForBeneficiary() public view returns (uint);
72     function withdrawInvestmentsBeneficiary(address withdraw_address) public returns (bool);
73 }
74 
75 
76 //Интерфейс для ICO контрактов, чтобы те могли говорить CNRToken-у
77 //о том что ему перевели бабки
78 contract CNRAddBalanceInterface
79 {
80     function addTokenBalance(address, uint) public;
81 }
82 
83 
84 //Интерфейс для фабрики, чтобы она могла добавлять токены
85 contract CNRAddTokenInterface
86 {
87     function addTokenAddress(address) public;
88 }
89 
90 //TODO: может сделать класс TokensCollection, куда вынести всю функциональность из  tokens_map, tokens_arr итд
91 contract CNRToken is ERC20, CNRAddBalanceInterface, CNRAddTokenInterface, Platform
92 {
93     using SafeMath for uint256;
94 
95 
96     //Токен  ERC20
97     string public constant name = "ICO Constructor token";
98     string public constant symbol = "CNR";
99     uint256 public constant decimals = 18;
100 
101 
102     //-------------------------ERC20 interface----------------------------------
103     mapping(address => mapping(address => uint256)) internal allowed;
104     mapping(address => uint256) balances;
105     ////////////////////////////ERC20 interface/////////////////////////////////
106 
107     //Адрес гранд фабрики
108     address public grand_factory = address(0);
109 
110     //Мапа и массив добавленнх токенов. Нулевой элемент  зарезервирован для
111     //эфира. Остальные для токенов
112     mapping(address => uint256) public  tokens_map;
113     TokenInfo[] public                  tokens_arr;
114 
115     //Мапа с забранными сущностями (эфиром, токенами). (адрес кошелька клиента => (индекс токена => сколько уже забрал))
116     //По индексу 0 - всегда эфир.
117     mapping(address => mapping(uint => uint)) withdrawns;
118 
119     function CNRToken() public
120     {
121         totalSupply = 10*1000*1000*(10**decimals); // 10 mln
122         balances[msg.sender] = totalSupply;
123 
124         //На нулевом индексе находится эфир
125         tokens_arr.push(
126             TokenInfo(
127                 address(0),
128                 0));
129     }
130 
131 
132     //Функция получения адресов всех добавленных токенов
133     function getRegisteredTokens()
134     public view
135     returns (address[])
136     {
137         // ситуация, когда не добавлены токены. <= чтобы убрать пред mythril,
138         // который не понимает что в конструкторе забит первый элемент
139         if (tokens_arr.length <= 1)
140             return;
141 
142         address[] memory token_addresses = new address[](tokens_arr.length-1);
143         for (uint i = 1; i < tokens_arr.length; i++)
144         {
145             token_addresses[i-1] = tokens_arr[i].contract_address;
146         }
147 
148         return token_addresses;
149     }
150 
151     //Функиця получения данных о всех доступных доходах в ether со всех
152     //зарегистрированных контрактов токенов. Чтобы воспользоваться этими
153     //доходами нужно для кажжого токена вызвать takeICOInvestmentsEtherCommission
154     function getAvailableEtherCommissions()
155     public view
156     returns(
157         address[],
158         uint[]
159     )
160     {
161         // ситуация, когда не добавлены токены. <= чтобы убрать пред mythril,
162         // который не понимает что в конструкторе забит первый элемент
163         if (tokens_arr.length <= 1)
164             return;
165 
166         address[] memory token_addresses = new address[](tokens_arr.length-1);
167         uint[] memory available_withdraws = new uint[](tokens_arr.length-1);
168         //Здесь должно быть от 1-го, потому что на 0-ом - эфир
169         for (uint i = 1; i < tokens_arr.length; i++)
170         {
171             token_addresses[i-1] = tokens_arr[i].contract_address;
172             available_withdraws[i-1] =
173                 BeneficiaryInterface(tokens_arr[i].contract_address).getAvailableWithdrawInvestmentsForBeneficiary();
174         }
175 
176         return (token_addresses, available_withdraws);
177     }
178 
179 
180     //Функция, которую может дергнуть кто угодно, чтобы на данный  контракт были переведен
181     //комиссии с инвестиций в эфире
182     function takeICOInvestmentsEtherCommission(address ico_token_address)
183     public
184     {
185         //Проверяем что ранее был! добавлен такой токен
186         require(tokens_map[ico_token_address] != 0);
187 
188         //Узнаем сколько мы можем вывести бабла
189         uint available_investments_commission =
190             BeneficiaryInterface(ico_token_address).getAvailableWithdrawInvestmentsForBeneficiary();
191 
192         //Запоминаем что бабки забрали
193         //запоминаем до перевода, так как потом дергаем external contract method
194         tokens_arr[0].ever_added = tokens_arr[0].ever_added.add(available_investments_commission);
195 
196         //Переводим бабло на адрес этого контракта
197         BeneficiaryInterface(ico_token_address).withdrawInvestmentsBeneficiary(
198             address(this));
199     }
200 
201 
202     //Специально разрешаем получение бабла
203     function()
204     public payable
205     {
206 
207     }
208 
209 
210     //Метод установки адреса grandFactory, который будет использован
211     function setGrandFactory(address _grand_factory)
212     public
213         onlyPlatform
214     {
215         //Проверяем чтобы адрес был передан нормальный
216         require(_grand_factory != address(0));
217 
218         grand_factory = _grand_factory;
219     }
220 
221     // баланс рассчитывается по формуле:
222     // общее количество токенов контракта _token_address, которым владеет контракт CNR
223     // умножаем на количество токенов CNR у _owner, делим на totalSupply (получаем долю)
224     // и отнимаем уже выведенную _owner'ом сумму токенов
225     //Доступный к выводу баланс в токенах некоторого ICO
226     function balanceOfToken(address _owner, address _token_address)
227     public view
228     returns (uint256 balance)
229     {
230         //Проверка наличия такого токена
231         require(tokens_map[_token_address] != 0);
232 
233         uint idx = tokens_map[_token_address];
234         balance =
235             tokens_arr[idx].ever_added
236             .mul(balances[_owner])
237             .div(totalSupply)
238             .sub(withdrawns[_owner][idx]);
239         }
240 
241     // все как и в balanceOfToken, только используем 0 элемент в tokens_arr и withdrawns[_owner]
242     //Доступный к выводу баланс в эфирах
243     function balanceOfETH(address _owner)
244     public view
245     returns (uint256 balance)
246     {
247         balance =
248             tokens_arr[0].ever_added
249             .mul(balances[_owner])
250             .div(totalSupply)
251             .sub(withdrawns[_owner][0]);
252     }
253 
254     //Функция перевода доступных токенов некоторого ICO на указанный кошелек
255     function withdrawTokens(address _token_address, address _destination_address)
256     public
257     {
258         //Проверка наличия такого токена
259         require(tokens_map[_token_address] != 0);
260 
261         uint token_balance = balanceOfToken(msg.sender, _token_address);
262         uint token_idx = tokens_map[_token_address];
263         withdrawns[msg.sender][token_idx] = withdrawns[msg.sender][token_idx].add(token_balance);
264         ERC20Basic(_token_address).transfer(_destination_address, token_balance);
265     }
266 
267     //Функиця забирания доступного эфира на указанный кошелек
268     function withdrawETH(address _destination_address)
269     public
270     {
271         uint value_in_wei = balanceOfETH(msg.sender);
272         withdrawns[msg.sender][0] = withdrawns[msg.sender][0].add(value_in_wei);
273         _destination_address.transfer(value_in_wei);
274     }
275 
276 
277     //Данная функция дложна вызываться из контрактов-токенов, в тот момент когда бенефициару
278     //(на контракт бенефициара) переводятся токены
279     function addTokenBalance(address _token_contract, uint amount)
280     public
281     {
282         //Проверяем что функция вызывается из ранее добавленноно! контракта токена
283         require(tokens_map[msg.sender] != 0);
284 
285         //ДОбавление данных обо всех токенах, переведенных бенефициару
286         tokens_arr[tokens_map[_token_contract]].ever_added = tokens_arr[tokens_map[_token_contract]].ever_added.add(amount);
287     }
288 
289     //Функиця добавления нового токена. Данная функция должна вызываться
290     //только GrandFactory при создании нового ICO токена
291     function addTokenAddress(address ico_token_address)
292     public
293     {
294         //Проверяем чтобы это был вызов из grand_factory
295         require(grand_factory == msg.sender);
296 
297         //Проверяем что ранее не был доавлен такой токен
298         require(tokens_map[ico_token_address] == 0);
299 
300         tokens_arr.push(
301             TokenInfo(
302                 ico_token_address,
303                 0));
304         tokens_map[ico_token_address] = tokens_arr.length - 1;
305     }
306 
307 
308 
309     //------------------------------ERC20---------------------------------------
310 
311     //Баланс в токенах
312     function balanceOf(address _owner)
313     public view
314     returns (uint256 balance)
315     {
316         return balances[_owner];
317     }
318 
319 
320     function transfer(address _to, uint256 _value) public returns (bool) {
321         require(_to != address(0));
322         require(_value <= balances[msg.sender]);
323 
324         //        uint withdraw_to_transfer = withdrawn[msg.sender] *  _value / balances[msg.sender];
325 
326         for (uint i = 0; i < tokens_arr.length; i++)
327         {
328             //Сколько забранных сущностей переместить на другой аккаунт
329             uint withdraw_to_transfer = withdrawns[msg.sender][i].mul(_value).div(balances[msg.sender]);
330 
331             //Перводим забранный доход
332             withdrawns[msg.sender][i] = withdrawns[msg.sender][i].sub(withdraw_to_transfer);
333             withdrawns[_to][i] = withdrawns[_to][i].add(withdraw_to_transfer);
334         }
335 
336 
337         //Переводим токены
338         balances[msg.sender] = balances[msg.sender].sub(_value);
339         balances[_to] = balances[_to].add(_value);
340 
341 
342         //Генерим событие
343         emit Transfer(msg.sender, _to, _value);
344         return true;
345     }
346 
347 
348     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
349         require(_to != address(0));
350         require(_value <= balances[_from]);
351         require(_value <= allowed[_from][msg.sender]);
352 
353         for (uint i = 0; i < tokens_arr.length; i++)
354         {
355             //Сколько забранных сущностей переместить на другой аккаунт
356             uint withdraw_to_transfer = withdrawns[_from][i].mul(_value).div(balances[_from]);
357 
358             //Перводим забранный доход
359             withdrawns[_from][i] = withdrawns[_from][i].sub(withdraw_to_transfer);
360             withdrawns[_to][i] = withdrawns[_to][i].add(withdraw_to_transfer);
361         }
362 
363 
364         balances[_from] = balances[_from].sub(_value);
365         balances[_to] = balances[_to].add(_value);
366         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
367 
368 
369         emit Transfer(_from, _to, _value);
370         return true;
371     }
372 
373 
374     function approve(address _spender, uint256 _value) public returns (bool) {
375         allowed[msg.sender][_spender] = _value;
376         emit Approval(msg.sender, _spender, _value);
377         return true;
378     }
379 
380 
381     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
382         return allowed[_owner][_spender];
383     }
384 
385 
386     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
387         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
388         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
389         return true;
390     }
391 
392     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
393         uint oldValue = allowed[msg.sender][_spender];
394         if (_subtractedValue > oldValue) {
395             allowed[msg.sender][_spender] = 0;
396         } else {
397             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
398         }
399         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
400         return true;
401     }
402     ///////////////////////////////////ERC20////////////////////////////////////
403 
404     struct TokenInfo
405     {
406         //Адрес контракта токена (может выплить потом?)
407         address contract_address;
408 
409         //Весь доход, переведенный на адрес данного контракта вызовом
410         //функции addTokenBalance
411         uint256 ever_added;
412     }
413 }