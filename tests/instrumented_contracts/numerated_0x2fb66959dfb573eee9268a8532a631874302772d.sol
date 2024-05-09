1 pragma solidity ^0.4.4;
2   //ENG::This code is a part of game on www.fgames.io
3   //ENG::If you found any bug or have an idea, contact us on code@fgames.io
4   //RUS::Этот код является частью игры на сайте www.fgames.io
5   //RUS::Если вы нашли баги или есть идеи, пишите нам code@fgames.io
6 contract playFive {
7   //ENG::Declare variable we use
8   //RUS::Декларируем переменные
9   address private creator;
10   string private referal;
11   string private try_userhash;
12   uint private totalBalance; 
13   uint public totalwin;
14   
15   //ENG::Сonstructor
16   //Конструктор
17   
18   constructor() public {
19 
20     creator = tx.origin;   
21   }
22   
23 
24   //ENG::Function that show Creator adress
25   //RUS::Функция которая отобразит адресс создателя контракта
26   function getCreator() public constant returns(address) {
27     return creator;
28   }
29 
30   //ENG::Function that show SmarrtContract Balance
31   //Функция которая отобразит Баланс СмартКонтракта
32   function getTotalBalance() public constant returns(uint) {
33     return address(this).balance;
34   }  
35   
36 
37 //ENG::One of the best way to compare two strings converted to bytes
38 //ENG::Function will check length and if bytes length is same then calculate hash of strings and compare it, (a1)
39 //ENG::if strings the same, return true, otherwise return false (a2)
40 //RUS::Один из лучших вариантов сравнения стринг переменных сконвертированные а байты
41 //RUS::Сначала функция сравнивает длинну байткода и послк их хэш (a1)
42 //RUS::Если хэш одинаковый, то возвращает true, иначе - false (a2)
43 
44 function hashCompareWithLengthCheck(string a, string b) internal pure returns (bool) {
45     if(bytes(a).length != bytes(b).length) { //(a1)
46         return false;
47     } else {
48         return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b)); //(a2)
49     }
50 }
51 
52 //ENG::Function that calculate Wining points
53 //ENG::After we get our *play ticket* hash, we take 5 chars in middle of it and game is on
54 //ENG::PlayFiveChain - main game function, send to this function *play ticket* code and player entered symbols 
55 //ENG::Then converting strings to bytes, so we can run throung each symbol (b2)
56 //ENG::Also we set initial winpoint to 0 (b3)
57 //ENG::Then we run throught each symbol in *play ticket* and compare it with player entered symbols
58 //ENG::player entered symbols maximum length also is five
59 //ENG::if function found a match using *hashCompareWithLengthCheck* function, then
60 //ENG::function add to event message details, that shows whats symbols are found whith player entered symbols (b4)
61 //ENG::replace used symbols in *player ticket* and entered symbols on X and Y so they no more used in game process (b5)
62 //ENG::and increase winpoit by 1 (b6)
63 //ENG::after function complete, it return winpoint from 0 - 5 (b7)
64 //RUS::Функция которая высчитывает количество очков
65 //RUS::После получения адреса *билета*, мы берем его последнии 5 символов и игра началась
66 //RUS::PlayFiveChain - главная функция игры, шлёт этой функции символы билета и символы введеные игроком
67 //RUS::После конвертирует *билет* и символы игрока в байты, чтобы можно было пройти по символам (b2)
68 //RUS::Также ставим начальное количество очков на 0 (b3)
69 //RUS::Далее мы проверяем совпадают ли символы *билета* с символами которые ввел игрок
70 //RUS::Максимальная длинна символов которые вводит игрок, тоже 5.
71 //RUS::Если функция находит совпадение с помощью функции *hashCompareWithLengthCheck*, то
72 //RUS::Функция добавляет к эвэнту детальное сообщение о том, какие символы были найдены (b4)
73 //RUS::Заменяет найденные символы в *билете* и *ключе* на X и Y и они более не участвуют в игре (b5)
74 //RUS::Увеличивает количество баллов winpoint на 1 (b6)
75 //RUS::По звыершению, возвращает значение winpoint от 0 до 5 (b7)
76 function check_result(string ticket, string check) public pure returns (uint) {  
77     bytes memory ticketBytes = bytes(ticket); //(b2)
78     bytes memory checkBytes = bytes(check);   //(b2) 
79     uint winpoint = 0; //(b3)
80 
81 
82     for (uint i=0; i < 5; i++){
83 
84       for (uint j=0; j < 5; j++){
85 
86         if(hashCompareWithLengthCheck(string(abi.encodePacked(ticketBytes[j])),string(abi.encodePacked(checkBytes[i]))))
87         {
88           ticketBytes[j] ="X"; //(b5)
89           checkBytes[i] = "Y"; //(b5)
90 
91           winpoint = winpoint+1; //(b6)         
92         }
93        
94       }
95 
96     }    
97     return uint(winpoint); //(b7)
98   }
99 
100 //ENG::Function destroy this smartContract
101 //ENG::Thats needed in case if we create new game, to take founds from it and add to new game 
102 //ENG::Or also it need if we see that current game not so actual, and we need to transfer founds to a new game, that more popular
103 //ENG::Or in case if we found any critical bug, to take founds in safe place, while fixing bugs.
104 //RUS::Функция для уничтожения смарт контракта
105 //RUS::Это необходимо, чтобы при создании новых игр, можно было разделить Баланс текущей игры с новой игрой
106 //RUS::Или если при создании новых игр, эта потеряет свою актуальность
107 //RUS::Либо при обнаружении критических багое, перевести средства в безопастное место на время исправления ошибок
108   function resetGame () public {
109     if (msg.sender == address(0xdC3df52BB1D116471F18B4931895d91eEefdC2B3)) { 
110       selfdestruct(0xdC3df52BB1D116471F18B4931895d91eEefdC2B3); 
111       return;
112     }
113   }
114 
115 //ENG::Function to substring provided string from provided start position until end position
116 //ENG::It's need to tak last 5 characters from *ticket* adress
117 //RUS::Функция для обрезания заданной строки с заданной позиции до заданной конечной позиции
118 //RUS::Это надо, чтобы получить последние 5 символов с адресса *билета*
119 function substring(string str, uint startIndex, uint endIndex) public pure returns (string) {
120     bytes memory strBytes = bytes(str);
121     bytes memory result = new bytes(endIndex-startIndex);
122     for(uint i = startIndex; i < endIndex; i++) {
123         result[i-startIndex] = strBytes[i];
124     }
125     return string(result);
126   }
127 
128 //ENG::Also very useful function, to make all symbols in string to lowercase
129 //ENG::That need in case to lowercase *TICKET* adress and Player provided symbols
130 //ENG::Because adress can be 0xasdf...FFDDEE123 and player can provide ACfE4. but we all convert to one format. lowercase
131 //RUS::Тоже очень полезная функция, чтобы перевести все символы в нижний регистр
132 //RUS::Это надо, чтобы привести в единый формат все такие переменные как *Билет* и *Ключ*
133 //RUS::Так как адресс билета может быть 0xasdf...FFDDEE123, а также игрок может ввести ACfE4.
134 	function _toLower(string str) internal pure returns (string) {
135 		bytes memory bStr = bytes(str);
136 		bytes memory bLower = new bytes(bStr.length);
137 		for (uint i = 0; i < bStr.length; i++) {
138 			// Uppercase character...
139 			if ((bStr[i] >= 65) && (bStr[i] <= 90)) {
140 				// So we add 32 to make it lowercase
141 				bLower[i] = bytes1(int(bStr[i]) + 32);
142 			} else {
143 				bLower[i] = bStr[i];
144 			}
145 		}
146 		return string(bLower);
147 	}
148 
149   //ENG::Standart Function to receive founds
150   //RUS::Стандартная функция для приёма средств
151   function () payable public {
152     //RECEIVED    
153   }
154 
155   //ENG::Converts adress type into string
156   //ENG::Used to convert *TICKET* adress into string
157   //RUS::Конвертирует переменную типа adress в строку string
158   //RUS::Используется для конвертации адреса *билета* в строку string
159   
160 function addressToString(address _addr) public pure returns(string) {
161     bytes32 value = bytes32(uint256(_addr));
162     bytes memory alphabet = "0123456789abcdef";
163 
164     bytes memory str = new bytes(42);
165     str[0] = '0';
166     str[1] = 'x';
167     for (uint i = 0; i < 20; i++) {
168         str[2+i*2] = alphabet[uint(value[i + 12] >> 4)];
169         str[3+i*2] = alphabet[uint(value[i + 12] & 0x0f)];
170     }
171     return string(str);
172 }
173 
174 
175   //ENG::Get last blockhash symbols and converts into string
176   //ENG::Used to convert *TICKET* hash into string
177   //RUS::Получаемонвертирует переменную типа adress в строку string
178   //RUS::Используется для конвертации адреса *билета* в строку string
179 
180 function blockhashToString(bytes32 _blockhash_to_decode) public pure returns(string) {
181     bytes32 value = _blockhash_to_decode;
182     bytes memory alphabet = "0123456789abcdef";
183 
184     bytes memory str = new bytes(42);
185     str[0] = '0';
186     str[1] = 'x';
187     for (uint i = 0; i < 20; i++) {
188         str[2+i*2] = alphabet[uint(value[i + 12] >> 4)];
189         str[3+i*2] = alphabet[uint(value[i + 12] & 0x0f)];
190     }
191     return string(str);
192 }
193 
194   //ENG::Converts uint type into STRING to show data in human readable format
195   //RUS::Конвертирует переменную uint в строку string чтобы отобразить данные в понятном для человека формате
196 function uint2str(uint i) internal pure returns (string){
197     if (i == 0) return "0";
198     uint j = i;
199     uint length;
200     while (j != 0){
201         length++;
202         j /= 10;
203     }
204     bytes memory bstr = new bytes(length);
205     uint k = length - 1;
206     while (i != 0){
207         bstr[k--] = byte(48 + i % 10);
208         i /= 10;
209     }
210     return string(bstr);
211 }
212 
213 
214 //ENG::This simple function, clone existing contract into new contract, to gain TOTALLY UNICALLY random string of *TICKET*
215 //RUS::Эта простая функция клонирует текущий контракт в новый контракт, чтобы получить 100% уникальную переменную *БИЛЕТА*
216 
217 function isContract(address _addr) private view returns (bool OKisContract){
218   uint32 size;
219   assembly {
220     size := extcodesize(_addr)
221   }
222   return (size > 0);
223 }
224 
225 
226 
227   //ENG::Event which will be visible in transaction logs in etherscan, and will have result data, whats will be parsed and showed on website
228   //RUS::Эвент который будет виден а логах транзакции, и отобразит строку с полезными данными для анализа и после вывода их на сайте
229   event ok_statusGame(address u_address, string u_key, uint u_bet, uint u_blocknum, string u_ref, string u_blockhash, uint winpoint,uint totalwin);
230 
231 //ENG::Main function whats called from a website.
232 //ENG::To provide best service. performance and support we take DevFee 13.3% of transaction (c1)
233 //ENG::Using multiple variables to generate HASH (c2)
234 //ENG::to generate TOTALLY random symbols which nobody can know until block is mined (c2)
235 //ENG::Used check_result function we get winpoint value (c3)
236 //ENG::If winpoint value is 0 or 1 point - player wins 0 ETH (c4)
237 //ENG::if winpoint value is 2 then player wins 165% from (BET - 13.3%) (c5)
238 //ENG::if winpoint value is 3 then player wins 315% from (BET - 13.3%) (c6)
239 //ENG::if winpoint value is 4 then player wins 515% from (BET - 13.3%) (c7)
240 //ENG::if winpoint value is 5 then player wins 3333% from (BET - 13.3%) (c8)
241 //ENG::If win amount is greater the smartcontract have, then player got 90% of smart contract balance (c9)
242 //ENG::On Website before place bet, player will see smartcontract current balance (maximum to wim)
243 //ENG::when win amount was calculated it automatically sends to player adress (c10)
244 //ENG::After all steps completed, SmartContract will generate message for EVENT,
245 //ENG::EVENT Message will have description of current game, and will have those fields which will be displayed on website:
246 //ENG::Player Address/ Player provided symbols / Player BET / Block Number Transaction played / Partner id / Little ticket / Player score / Player Win amount / 
247 //ENG::Полный адресс *игрока* / Символы введенные игроком / Ставку / Номер блока в котором играли / Ид партнёра / Укороченный билет / Очки игрока / Суммы выйгрыша / 
248 //RUS::Главная функция которая вызывается непосредственно с сайта.
249 //RUS::Чтобы обеспечивать качественный сервис, развивать и создавать новые игры, мы берем комиссию 13,3% от размера ставки (c1)
250 //RUS::Используем для добычи хеша несколько переменных, (c2)
251 //RUS::Для того, чтобы добится 100% УНИКАЛЬНОГО *билета* (c2)
252 //RUS::Используем check_result функцию чтобы узнать значение winpoint (c3)
253 //RUS::Если значение winpoint 0 или 1 - выйгрыш игрока 0 ETH (c4)
254 //RUS::Если значение winpoint 2 - выйгрыш игрока 165% от (СТАВКА - 13.3%) (c5)
255 //RUS::Если значение winpoint 3 - выйгрыш игрока 315% от (СТАВКА - 13.3%) (c6)
256 //RUS::Если значение winpoint 4 - выйгрыш игрока 515% от (СТАВКА - 13.3%) (c7)
257 //RUS::Если значение winpoint 5 - выйгрыш игрока 3333% от (СТАВКА - 13.3%) (c8)
258 //RUS::Если сумма выйгрыша больше баланса смарт контракта, то игрок получает 90% от баланса смарт контракта (c9)
259 //RUS::На сайте игрок заранее видет баланс смарт контракта на текущий момент (максимальный выйгрыш)
260 //RUS::После вычисления суммы выйгрыша, выйгрышь автоматом перечисляется на адресс игрока (c10)
261 //RUS::После завершения всех шагов, смарт контракт генерирует сообщение для ЭВЕНТА
262 //RUS::Сообщение ЭВЕНТА хранит в себе ключевые показатели сыграной игры, и красиво в понятной форме будут отображены на сайте
263 //RUS::Что содержит сообщение ЭВЕНТА:
264 //RUS::Полный адресс *игрока* / Символы введенные игроком / Ставку / Номер блока / Ид партнёра / Укороченный билет / Очки игрока / Суммы выйгрыша / 
265 
266 
267   function PlayFiveChain(string _u_key, string _u_ref ) public payable {
268     
269     //ENG::AntiRobot Captcha
270     //RUS::Капча против ботов 
271     require(tx.origin == msg.sender);
272     if(isContract(msg.sender))
273     {
274       return;
275     }    
276 
277 
278       address(0xdC3df52BB1D116471F18B4931895d91eEefdC2B3).transfer((msg.value/1000)*133); //(c1)     
279             
280       try_userhash =       blockhashToString(keccak256(abi.encodePacked(_u_key,"-",now,"-", 
281       blockhashToString(blockhash(block.number-1)),      
282       addressToString(msg.sender),
283       uint2str(gasleft()),
284       address(msg.sender).balance,
285       uint2str(address(0xdC3df52BB1D116471F18B4931895d91eEefdC2B3).balance),
286       uint2str(address(this).balance),
287       uint2str(address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2).balance))));
288 
289       string memory calculate_userhash = substring(try_userhash,2,7); //(c2)
290 
291       
292           
293 
294       uint winpoint = check_result(_toLower(calculate_userhash),_toLower(_u_key));//(c3)
295       
296 
297     if(winpoint == 0)
298     {
299       totalwin = 0; //(c4)
300     }
301     if(winpoint == 1)
302     {
303       totalwin = 0; //(c4)
304     }
305     if(winpoint == 2)
306     {
307       totalwin = ((msg.value - (msg.value/1000)*133)/100)*165; //(c5)
308     }
309     if(winpoint == 3)
310     {
311       totalwin = ((msg.value - (msg.value/1000)*133)/100)*315; //(c6)
312     }            
313     if(winpoint == 4)
314     {
315       totalwin = ((msg.value - (msg.value/1000)*133)/100)*515; //(c7)
316     }
317     if(winpoint == 5)
318     {
319       totalwin = ((msg.value - (msg.value/1000)*133)/100)*3333; //(c8)
320     } 
321 
322     if(totalwin > 0)    
323     {
324       if(totalwin > address(this).balance)
325       {
326         totalwin = ((address(this).balance/100)*90); //(c9)
327       }
328        msg.sender.transfer(totalwin); //(c10)         
329     }
330       emit ok_statusGame(msg.sender, _u_key, msg.value, block.number, _u_ref, calculate_userhash,winpoint,totalwin);                                      
331 
332     return;
333   }
334 
335 }