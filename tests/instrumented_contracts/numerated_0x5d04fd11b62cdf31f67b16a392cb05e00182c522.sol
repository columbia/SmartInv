1 pragma solidity ^0.4.4;
2   //ENG::This code is a part of game on www.fgames.io
3   //ENG::If you found any bug or have an idea, contact us on code@fgames.io
4   //RUS::Этот код является частью игры на сайте www.fgames.io
5   //RUS::Если вы нашли баги или есть идеи, пишите нам code@fgames.io
6 contract playFive {
7   //ENG::Declare variable we use
8   //RUS::Декларируем переменные
9   address private creator;
10   string private message;
11   string private message_details;
12   string private referal;
13   uint private totalBalance; 
14   uint public totalwin;
15   
16   //ENG::Сonstructor
17   //Конструктор
18   /*
19   constructor() public {
20 
21     creator = tx.origin;   
22     message = 'initiated';
23   }
24   */
25 
26 
27   
28 
29 
30   //ENG::Function that show Creator adress
31   //RUS::Функция которая отобразит адресс создателя контракта
32   function getCreator() public constant returns(address) {
33     return creator;
34   }
35 
36   //ENG::Function that show SmarrtContract Balance
37   //Функция которая отобразит Баланс СмартКонтракта
38   function getTotalBalance() public constant returns(uint) {
39     return address(this).balance;
40   }  
41   
42 
43 //ENG::One of the best way to compare two strings converted to bytes
44 //ENG::Function will check length and if bytes length is same then calculate hash of strings and compare it, (a1)
45 //ENG::if strings the same, return true, otherwise return false (a2)
46 //RUS::Один из лучших вариантов сравнения стринг переменных сконвертированные а байты
47 //RUS::Сначала функция сравнивает длинну байткода и послк их хэш (a1)
48 //RUS::Если хэш одинаковый, то возвращает true, иначе - false (a2)
49 
50 function hashCompareWithLengthCheck(string a, string b) internal pure returns (bool) {
51     if(bytes(a).length != bytes(b).length) { //(a1)
52         return false;
53     } else {
54         return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b)); //(a2)
55     }
56 }
57 
58 //ENG::Function that calculate Wining points
59 //ENG::After we get our *play ticket* adress, we take last 5 chars of it and game is on
60 //ENG::sendTXTpsTX - main game function, send to this function *play ticket* code and player entered symbols 
61 //ENG::function starting setted initiated results to nothing (b1)
62 //ENG::Then converting strings to bytes, so we can run throung each symbol (b2)
63 //ENG::Also we set initial winpoint to 0 (b3)
64 //ENG::Then we run throught each symbol in *play ticket* and compare it with player entered symbols
65 //ENG::player entered symbols maximum length also is five
66 //ENG::if function found a match using *hashCompareWithLengthCheck* function, then
67 //ENG::function add to event message details, that shows whats symbols are found whith player entered symbols (b4)
68 //ENG::replace used symbols in *player ticket* and entered symbols on X and Y so they no more used in game process (b5)
69 //ENG::and increase winpoit by 1 (b6)
70 //ENG::after function complete, it return winpoint from 0 - 5 (b7)
71 //RUS::Функция которая высчитывает количество очков
72 //RUS::После получения адреса *билета*, мы берем его последнии 5 символов и игра началась
73 //RUS::sendTXTpsTX - главная функция игры, шлёт этой функции символы билета и символы введеные игроком
74 //RUS::Функция сначало обнуляет детали переменной результата (b1)
75 //RUS::После конвертирует *билет* и символы игрока в байты, чтобы можно было пройти по символам (b2)
76 //RUS::Также ставим начальное количество очков на 0 (b3)
77 //RUS::Далее мы проверяем совпадают ли символы *билета* с символами которые ввел игрок
78 //RUS::Максимальная длинна символов которые вводит игрок, тоже 5.
79 //RUS::Если функция находит совпадение с помощью функции *hashCompareWithLengthCheck*, то
80 //RUS::Функция добавляет к эвэнту детальное сообщение о том, какие символы были найдены (b4)
81 //RUS::Заменяет найденные символы в *билете* и *ключе* на X и Y и они более не участвуют в игре (b5)
82 //RUS::Увеличивает количество баллов winpoint на 1 (b6)
83 //RUS::По звыершению, возвращает значение winpoint от 0 до 5 (b7)
84 function check_result(string ticket, string check) public  returns (uint) {
85   message_details = ""; //(b1)
86     bytes memory ticketBytes = bytes(ticket); //(b2)
87     bytes memory checkBytes = bytes(check);   //(b2) 
88     uint winpoint = 0; //(b3)
89 
90 
91     for (uint i=0; i < 5; i++){
92 
93       for (uint j=0; j < 5; j++){
94 
95         if(hashCompareWithLengthCheck(string(abi.encodePacked(ticketBytes[j])),string(abi.encodePacked(checkBytes[i]))))
96         {
97           message_details = string(abi.encodePacked(message_details,'*',ticketBytes[j],'**',checkBytes[i])); //(b4)
98           ticketBytes[j] ="X"; //(b5)
99           checkBytes[i] = "Y"; //(b5)
100 
101           winpoint = winpoint+1; //(b6)         
102         }
103        
104       }
105 
106     }    
107     return uint(winpoint); //(b7)
108   }
109 
110 //ENG::Function destroy this smartContract
111 //ENG::Thats needed in case if we create new game, to take founds from it and add to new game 
112 //ENG::Or also it need if we see that current game not so actual, and we need to transfer founds to a new game, that more popular
113 //ENG::Or in case if we found any critical bug, to take founds in safe place, while fixing bugs.
114 //RUS::Функция для уничтожения смарт контракта
115 //RUS::Это необходимо, чтобы при создании новых игр, можно было разделить Баланс текущей игры с новой игрой
116 //RUS::Или если при создании новых игр, эта потеряет свою актуальность
117 //RUS::Либо при обнаружении критических багое, перевести средства в безопастное место на время исправления ошибок
118   function resetGame () public {
119     if (msg.sender == creator) { 
120       selfdestruct(0xdC3df52BB1D116471F18B4931895d91eEefdC2B3); 
121       return;
122     }
123   }
124 
125 //ENG::Function to substring provided string from provided start position until end position
126 //ENG::It's need to tak last 5 characters from *ticket* adress
127 //RUS::Функция для обрезания заданной строки с заданной позиции до заданной конечной позиции
128 //RUS::Это надо, чтобы получить последние 5 символов с адресса *билета*
129 function substring(string str, uint startIndex, uint endIndex) public pure returns (string) {
130     bytes memory strBytes = bytes(str);
131     bytes memory result = new bytes(endIndex-startIndex);
132     for(uint i = startIndex; i < endIndex; i++) {
133         result[i-startIndex] = strBytes[i];
134     }
135     return string(result);
136   }
137 
138 //ENG::Also very useful function, to make all symbols in string to lowercase
139 //ENG::That need in case to lowercase *TICKET* adress and Player provided symbols
140 //ENG::Because adress can be 0xasdf...FFDDEE123 and player can provide ACfE4. but we all convert to one format. lowercase
141 //RUS::Тоже очень полезная функция, чтобы перевести все символы в нижний регистр
142 //RUS::Это надо, чтобы привести в единый формат все такие переменные как *Билет* и *Ключ*
143 //RUS::Так как адресс билета может быть 0xasdf...FFDDEE123, а также игрок может ввести ACfE4.
144 	function _toLower(string str) internal pure returns (string) {
145 		bytes memory bStr = bytes(str);
146 		bytes memory bLower = new bytes(bStr.length);
147 		for (uint i = 0; i < bStr.length; i++) {
148 			// Uppercase character...
149 			if ((bStr[i] >= 65) && (bStr[i] <= 90)) {
150 				// So we add 32 to make it lowercase
151 				bLower[i] = bytes1(int(bStr[i]) + 32);
152 			} else {
153 				bLower[i] = bStr[i];
154 			}
155 		}
156 		return string(bLower);
157 	}
158 
159   //ENG::Standart Function to receive founds
160   //RUS::Стандартная функция для приёма средств
161   function () payable public {
162     //RECEIVED    
163   }
164 
165   //ENG::Converts adress type into string
166   //ENG::Used to convert *TICKET* adress into string
167   //RUS::Конвертирует переменную типа adress в строку string
168   //RUS::Используется для конвертации адреса *билета* в строку string
169   
170 function addressToString(address _addr) public pure returns(string) {
171     bytes32 value = bytes32(uint256(_addr));
172     bytes memory alphabet = "0123456789abcdef";
173 
174     bytes memory str = new bytes(42);
175     str[0] = '0';
176     str[1] = 'x';
177     for (uint i = 0; i < 20; i++) {
178         str[2+i*2] = alphabet[uint(value[i + 12] >> 4)];
179         str[3+i*2] = alphabet[uint(value[i + 12] & 0x0f)];
180     }
181     return string(str);
182 }
183 
184 
185   //ENG::Get last blockhash symbols and converts into string
186   //ENG::Used to convert *TICKET* hash into string
187   //RUS::Получаемонвертирует переменную типа adress в строку string
188   //RUS::Используется для конвертации адреса *билета* в строку string
189 
190 function blockhashToString(bytes32 _blockhash_to_decode) public pure returns(string) {
191     bytes32 value = _blockhash_to_decode;
192     bytes memory alphabet = "0123456789abcdef";
193 
194     bytes memory str = new bytes(42);
195     str[0] = '0';
196     str[1] = 'x';
197     for (uint i = 0; i < 20; i++) {
198         str[2+i*2] = alphabet[uint(value[i + 12] >> 4)];
199         str[3+i*2] = alphabet[uint(value[i + 12] & 0x0f)];
200     }
201     return string(str);
202 }
203 
204   //ENG::Converts uint type into STRING to show data in human readable format
205   //RUS::Конвертирует переменную uint в строку string чтобы отобразить данные в понятном для человека формате
206 function uint2str(uint i) internal pure returns (string){
207     if (i == 0) return "0";
208     uint j = i;
209     uint length;
210     while (j != 0){
211         length++;
212         j /= 10;
213     }
214     bytes memory bstr = new bytes(length);
215     uint k = length - 1;
216     while (i != 0){
217         bstr[k--] = byte(48 + i % 10);
218         i /= 10;
219     }
220     return string(bstr);
221 }
222 
223 
224 //ENG::This simple function, clone existing contract into new contract, to gain TOTALLY UNICALLY random string of *TICKET*
225 //RUS::Эта простая функция клонирует текущий контракт в новый контракт, чтобы получить 100% уникальную переменную *БИЛЕТА*
226 
227 function isContract(address _addr) private view returns (bool OKisContract){
228   uint32 size;
229   assembly {
230     size := extcodesize(_addr)
231   }
232   return (size > 0);
233 }
234 
235 
236 
237   //ENG::Event which will be visible in transaction logs in etherscan, and will have result data, whats will be parsed and showed on website
238   //RUS::Эвент который будет виден а логах транзакции, и отобразит строку с полезными данными для анализа и после вывода их на сайте
239   event ok_statusGame(address u_address, string u_key, uint u_bet, uint u_blocknum, string u_ref, string u_blockhash, uint winpoint,uint totalwin);
240 
241   struct EntityStruct {
242     address u_address;
243     string u_key;
244     uint u_bet;
245     uint u_blocknum;
246     string u_ref;
247     uint listPointer;
248   }
249 
250   mapping(address => EntityStruct) public entityStructs;
251   address[] public entityList;
252 
253   function isEntity(address entityAddress) public constant returns(bool isIndeed) {
254     if(entityList.length == 0) return false;
255     return (entityList[entityStructs[entityAddress].listPointer] == entityAddress);
256   }
257 
258 
259 
260 
261 //ENG::Main function whats called from a website.
262 //ENG::To provide best service. performance and support we take DevFee 13.3% of transaction (c1)
263 //ENG::Using of *blockhash* function to get HASH of block in which previous player transaction was maded (c2)
264 //ENG::to generate TOTALLY random symbols which nobody can know until block is mined (c2)
265 //ENG::Used check_result function we get winpoint value (c3)
266 //ENG::If winpoint value is 0 or 1 point - player wins 0 ETH (c4)
267 //ENG::if winpoint value is 2 then player wins 165% from (BET - 13.3%) (c5)
268 //ENG::if winpoint value is 3 then player wins 315% from (BET - 13.3%) (c6)
269 //ENG::if winpoint value is 4 then player wins 515% from (BET - 13.3%) (c7)
270 //ENG::if winpoint value is 5 then player wins 3333% from (BET - 13.3%) (c8)
271 //ENG::If win amount is greater the smartcontract have, then player got 90% of smart contract balance (c9)
272 //ENG::On Website before place bet, player will see smartcontract current balance (maximum to wim)
273 //ENG::when win amount was calculated it automatically sends to player adress (c10)
274 //ENG::After all steps completed, SmartContract will generate message for EVENT,
275 //ENG::EVENT Message will have description of current game, and will have those fields which will be displayed on website:
276 //ENG::Player Address/ Player provided symbols / Player BET / Block Number Transaction played / Partner id / Little ticket / Player score / Player Win amount / 
277 //ENG::Полный адресс *игрока* / Символы введенные игроком / Ставку / Номер блока в котором играли / Ид партнёра / Укороченный билет / Очки игрока / Суммы выйгрыша / 
278 //RUS::Главная функция которая вызывается непосредственно с сайта.
279 //RUS::Чтобы обеспечивать качественный сервис, развивать и создавать новые игры, мы берем комиссию 13,3% от размера ставки (c1)
280 //RUS::Используем функцию *blockhash* для добычи хеша блока в котором была сделана транзакция предыдущего игрока, (c2)
281 //RUS::Для того, чтобы добится 100% УНИКАЛЬНОГО *билета* (c2)
282 //RUS::Используем check_result функцию чтобы узнать значение winpoint (c3)
283 //RUS::Если значение winpoint 0 или 1 - выйгрыш игрока 0 ETH (c4)
284 //RUS::Если значение winpoint 2 - выйгрыш игрока 165% от (СТАВКА - 13.3%) (c5)
285 //RUS::Если значение winpoint 3 - выйгрыш игрока 315% от (СТАВКА - 13.3%) (c6)
286 //RUS::Если значение winpoint 4 - выйгрыш игрока 515% от (СТАВКА - 13.3%) (c7)
287 //RUS::Если значение winpoint 5 - выйгрыш игрока 3333% от (СТАВКА - 13.3%) (c8)
288 //RUS::Если сумма выйгрыша больше баланса смарт контракта, то игрок получает 90% от баланса смарт контракта (c9)
289 //RUS::На сайте игрок заранее видет баланс смарт контракта на текущий момент (максимальный выйгрыш)
290 //RUS::После вычисления суммы выйгрыша, выйгрышь автоматом перечисляется на адресс игрока (c10)
291 //RUS::После завершения всех шагов, смарт контракт генерирует сообщение для ЭВЕНТА
292 //RUS::Сообщение ЭВЕНТА хранит в себе ключевые показатели сыграной игры, и красиво в понятной форме будут отображены на сайте
293 //RUS::Что содержит сообщение ЭВЕНТА:
294 //RUS::Полный адресс *игрока* / Символы введенные игроком / Ставку / Номер блока / Ид партнёра / Укороченный билет / Очки игрока / Суммы выйгрыша / 
295 
296 
297   function PlayFiveChain(string _u_key, string _u_ref ) public payable returns(bool success) {
298     
299     //ENG::AntiRobot Captcha
300     //RUS::Капча против ботов 
301     require(tx.origin == msg.sender);
302     if(isContract(msg.sender))
303     {
304       return;
305     }    
306 
307     if(!isEntity(address(this))) 
308     {
309       //ENG:need to fill array at first init
310       //RUS:необходимо для начального заполнения массива
311       
312       entityStructs[address(this)].u_address = msg.sender;
313       entityStructs[address(this)].u_key = _u_key;
314       entityStructs[address(this)].u_bet = msg.value;      
315       entityStructs[address(this)].u_blocknum = block.number;
316       entityStructs[address(this)].u_ref = _u_ref;                        
317       entityStructs[address(this)].listPointer = entityList.push(address(this)) - 1;
318       return true;
319     }
320     else
321     {
322       address(0xdC3df52BB1D116471F18B4931895d91eEefdC2B3).transfer((msg.value/1000)*133); //(c1)          
323       string memory calculate_userhash = substring(blockhashToString(blockhash(entityStructs[address(this)].u_blocknum)),37,42); //(c2)
324       string memory calculate_userhash_to_log = substring(blockhashToString(blockhash(entityStructs[address(this)].u_blocknum)),37,42);//(c2)
325       uint winpoint = check_result(calculate_userhash,_toLower(entityStructs[address(this)].u_key));//(c3)
326       
327 
328     if(winpoint == 0)
329     {
330       totalwin = 0; //(c4)
331     }
332     if(winpoint == 1)
333     {
334       totalwin = 0; //(c4)
335     }
336     if(winpoint == 2)
337     {
338       totalwin = ((entityStructs[address(this)].u_bet - (entityStructs[address(this)].u_bet/1000)*133)/100)*165; //(c5)
339     }
340     if(winpoint == 3)
341     {
342       totalwin = ((entityStructs[address(this)].u_bet - (entityStructs[address(this)].u_bet/1000)*133)/100)*315; //(c6)
343     }            
344     if(winpoint == 4)
345     {
346       totalwin = ((entityStructs[address(this)].u_bet - (entityStructs[address(this)].u_bet/1000)*133)/100)*515; //(c7)
347     }
348     if(winpoint == 5)
349     {
350       totalwin = ((entityStructs[address(this)].u_bet - (entityStructs[address(this)].u_bet/1000)*133)/100)*3333; //(c8)
351     } 
352 
353     if(totalwin > 0)    
354     {
355       if(totalwin > address(this).balance)
356       {
357         totalwin = ((address(this).balance/100)*90); //(c9)
358       }
359       address(entityStructs[address(this)].u_address).transfer(totalwin); //(c10)         
360     }
361 
362 
363       
364       emit ok_statusGame(entityStructs[address(this)].u_address, entityStructs[address(this)].u_key, entityStructs[address(this)].u_bet, entityStructs[address(this)].u_blocknum, entityStructs[address(this)].u_ref, calculate_userhash_to_log,winpoint,totalwin);      
365       
366       //ENG:: Filling array with current player values
367       //ENG:: In Next time when contract called will be processed previous player data to calculate prize
368       //RUS:: Заполняем массив данными текущего игрока
369       //RUS:: При следующем вызове контракта будут использоватся данные предыдущего игрока для вычисления выйгрыша
370       entityStructs[address(this)].u_address = msg.sender;
371       entityStructs[address(this)].u_key = _u_key;
372       entityStructs[address(this)].u_bet = msg.value;      
373       entityStructs[address(this)].u_blocknum = block.number;
374       entityStructs[address(this)].u_ref = _u_ref;                        
375     }
376     return;
377   }
378 
379 }