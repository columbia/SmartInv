1 pragma solidity ^0.4.4;
2   //ENG::This code is a part of game on www.fgames.io
3   //ENG::If you found any bug or have an idea, contact us on code@fgames.io
4   //RUS::Этот код является частью игры на сайте www.fgames.io
5   //RUS::Если вы нашли баги илм есть идеи, пишите нам code@fgames.io
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
18   constructor() public {
19 
20     creator = tx.origin;   
21     message = 'initiated';
22   }
23   
24   //ENG::Event which will be visible in transaction logs in etherscan, and will have result data, whats will be parsed and showed on website
25   //RUS::Эвент который будет виден а логах транзакции, и отобразит строку с полезными данными для анализа и после вывода их на сайте
26   event statusGame(string message);
27 
28 
29   //ENG::Function that show Creator adress
30   //RUS::Функция которая отобразит адресс создателя контракта
31   function getCreator() public constant returns(address) {
32     return creator;
33   }
34 
35   //ENG::Function that show SmarrtContract Balance
36   //Функция которая отобразит Баланс СмартКонтракта
37   function getTotalBalance() public constant returns(uint) {
38     return address(this).balance;
39   }  
40   
41 
42 //ENG::One of the best way to compare two strings converted to bytes
43 //ENG::Function will check length and if bytes length is same then calculate hash of strings and compare it, (a1)
44 //ENG::if strings the same, return true, otherwise return false (a2)
45 //RUS::Один из лучших вариантов сравнения стринг переменных сконвертированные а байты
46 //RUS::Сначала функция сравнивает длинну байткода и послк их хэш (a1)
47 //RUS::Если хэш одинаковый, то возвращает true, иначе - false (a2)
48 
49 function hashCompareWithLengthCheck(string a, string b) internal pure returns (bool) {
50     if(bytes(a).length != bytes(b).length) { //(a1)
51         return false;
52     } else {
53         return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b)); //(a2)
54     }
55 }
56 
57 //ENG::Function that calculate Wining points
58 //ENG::After we get our *play ticket* adress, we take last 5 chars of it and game is on
59 //ENG::sendTXTpsTX - main game function, send to this function *play ticket* code and player entered symbols 
60 //ENG::function starting setted initiated results to nothing (b1)
61 //ENG::Then converting strings to bytes, so we can run throung each symbol (b2)
62 //ENG::Also we set initial winpoint to 0 (b3)
63 //ENG::Then we run throught each symbol in *play ticket* and compare it with player entered symbols
64 //ENG::player entered symbols maximum length also is five
65 //ENG::if function found a match using *hashCompareWithLengthCheck* function, then
66 //ENG::function add to event message details, that shows whats symbols are found whith player entered symbols (b4)
67 //ENG::replace used symbols in *player ticket* and entered symbols on X and Y so they no more used in game process (b5)
68 //ENG::and increase winpoit by 1 (b6)
69 //ENG::after function complete, it return winpoint from 0 - 5 (b7)
70 //RUS::Функция которая высчитывает количество очков
71 //RUS::После получения адреса *билета*, мы берем его последнии 5 символов и игра началась
72 //RUS::sendTXTpsTX - главная функция игры, шлёт этой функции символы билета и символы введеные игроком
73 //RUS::Функция сначало обнуляет детали переменной результата (b1)
74 //RUS::После конвертирует *билет* и символы игрока в байты, чтобы можно было пройти по символам (b2)
75 //RUS::Также ставим начальное количество очков на 0 (b3)
76 //RUS::Далее мы проверяем совпадают ли символы *билета* с символами которые ввел игрок
77 //RUS::Максимальная длинна символов которые вводит игрок, тоже 5.
78 //RUS::Если функция находит совпадение с помощью функции *hashCompareWithLengthCheck*, то
79 //RUS::Функция добавляет к эвэнту детальное сообщение о том, какие символы были найдены (b4)
80 //RUS::Заменяет найденные символы в *билете* и *ключе* на X и Y и они более не участвуют в игре (b5)
81 //RUS::Увеличивает количество баллов winpoint на 1 (b6)
82 //RUS::По звыершению, возвращает значение winpoint от 0 до 5 (b7)
83 function check_result(string ticket, string check) public  returns (uint) {
84   message_details = ""; //(b1)
85     bytes memory ticketBytes = bytes(ticket); //(b2)
86     bytes memory checkBytes = bytes(check);   //(b2) 
87     uint winpoint = 0; //(b3)
88 
89 
90     for (uint i=0; i < 5; i++){
91 
92       for (uint j=0; j < 5; j++){
93 
94         if(hashCompareWithLengthCheck(string(abi.encodePacked(ticketBytes[j])),string(abi.encodePacked(checkBytes[i]))))
95         {
96           message_details = string(abi.encodePacked(message_details,'*',ticketBytes[j],'**',checkBytes[i])); //(b4)
97           ticketBytes[j] ="X"; //(b5)
98           checkBytes[i] = "Y"; //(b5)
99 
100           winpoint = winpoint+1; //(b6)         
101         }
102        
103       }
104 
105     }    
106     return uint(winpoint); //(b7)
107   }
108 
109 //ENG::Function destroy this smartContract
110 //ENG::Thats needed in case if we create new game, to take founds from it and add to new game 
111 //ENG::Or also it need if we see that current game not so actual, and we need to transfer founds to a new game, that more popular
112 //ENG::Or in case if we found any critical bug, to take founds in safe place, while fixing bugs.
113 //RUS::Функция для уничтожения смарт контракта
114 //RUS::Это необходимо, чтобы при создании новых игр, можно было разделить Баланс текущей игры с новой игрой
115 //RUS::Или если при создании новых игр, эта потеряет свою актуальность
116 //RUS::Либо при обнаружении критических багое, перевести средства в безопастное место на время исправления ошибок
117   function resetGame () public {
118     if (msg.sender == creator) { 
119       selfdestruct(0xdC3df52BB1D116471F18B4931895d91eEefdC2B3); 
120       return;
121     }
122   }
123 
124 //ENG::Function to substring provided string from provided start position until end position
125 //ENG::It's need to tak last 5 characters from *ticket* adress
126 //RUS::Функция для обрезания заданной строки с заданной позиции до заданной конечной позиции
127 //RUS::Это надо, чтобы получить последние 5 символов с адресса *билета*
128 function substring(string str, uint startIndex, uint endIndex) public pure returns (string) {
129     bytes memory strBytes = bytes(str);
130     bytes memory result = new bytes(endIndex-startIndex);
131     for(uint i = startIndex; i < endIndex; i++) {
132         result[i-startIndex] = strBytes[i];
133     }
134     return string(result);
135   }
136 
137 //ENG::Also very useful function, to make all symbols in string to lowercase
138 //ENG::That need in case to lowercase *TICKET* adress and Player provided symbols
139 //ENG::Because adress can be 0xasdf...FFDDEE123 and player can provide ACfE4. but we all convert to one format. lowercase
140 //RUS::Тоже очень полезная функция, чтобы перевести все символы в нижний регистр
141 //RUS::Это надо, чтобы привести в единый формат все такие переменные как *Билет* и *Ключ*
142 //RUS::Так как адресс билета может быть 0xasdf...FFDDEE123, а также игрок может ввести ACfE4.
143 	function _toLower(string str) internal pure returns (string) {
144 		bytes memory bStr = bytes(str);
145 		bytes memory bLower = new bytes(bStr.length);
146 		for (uint i = 0; i < bStr.length; i++) {
147 			// Uppercase character...
148 			if ((bStr[i] >= 65) && (bStr[i] <= 90)) {
149 				// So we add 32 to make it lowercase
150 				bLower[i] = bytes1(int(bStr[i]) + 32);
151 			} else {
152 				bLower[i] = bStr[i];
153 			}
154 		}
155 		return string(bLower);
156 	}
157 
158 
159 //ENG::Main function whats called from a website.
160 //ENG::To provide best service. performance and support we take DevFee 13.3% of transaction (c1)
161 //ENG::Using clone function we create new smartcontract,
162 //ENG::to generate TOTALLY random symbols which nobody can know until transaction not mined (c2)
163 //ENG::Used check_result function we get winpoint value (c3)
164 //ENG::If winpoint value is 0 or 1 point - player wins 0 ETH (c4)
165 //ENG::if winpoint value is 2 then player wins 165% from (BET - 13.3%) (c5)
166 //ENG::if winpoint value is 3 then player wins 315% from (BET - 13.3%) (c6)
167 //ENG::if winpoint value is 4 then player wins 515% from (BET - 13.3%) (c7)
168 //ENG::if winpoint value is 5 then player wins 3333% from (BET - 13.3%) (c8)
169 //ENG::If win amount is greater the smartcontract have, then player got 90% of smart contract balance (c9)
170 //ENG::On Website before place bet, player will see smartcontract current balance (maximum to wim)
171 //ENG::when win amount was calculated it automatically sends to player adress (c10)
172 //ENG::After all steps completed, SmartContract will generate message for EVENT,
173 //ENG::EVENT Message will have description of current game, and will have those fields which will be displayed on website:
174 //ENG::Ticket full adress / Player BET / Player Win amount / Player score / Little ticket / Player provided symbols / Explain of founded symbols / Partner id
175 //RUS::Главная функция которая вызывается непосредственно с сайта.
176 //RUS::Чтобы обеспечивать качественный сервис, развивать и создавать новые игры, мы берем комиссию 13,3% от размера ставки (c1)
177 //RUS::Используем функцию *clone* для создания нового смарт контракта,
178 //RUS::Для того, чтобы добится 100% УНИКАЛЬНОГО *билета* (c2)
179 //RUS::Используем check_result функцию чтобы узнать значение winpoint (c3)
180 //RUS::Если значение winpoint 0 или 1 - выйгрыш игрока 0 ETH (c4)
181 //RUS::Если значение winpoint 2 - выйгрыш игрока 165% от (СТАВКА - 13.3%) (c5)
182 //RUS::Если значение winpoint 3 - выйгрыш игрока 315% от (СТАВКА - 13.3%) (c6)
183 //RUS::Если значение winpoint 4 - выйгрыш игрока 515% от (СТАВКА - 13.3%) (c7)
184 //RUS::Если значение winpoint 5 - выйгрыш игрока 3333% от (СТАВКА - 13.3%) (c8)
185 //RUS::Если сумма выйгрыша больше баланса смарт контракта, то игрок получает 90% от баланса смарт контракта (c9)
186 //RUS::На сайте игрок заранее видет баланс смарт контракта на текущий момент (максимальный выйгрыш)
187 //RUS::После вычисления суммы выйгрыша, выйгрышь автоматом перечисляется на адресс игрока (c10)
188 //RUS::После завершения всех шагов, смарт контракт генерирует сообщение для ЭВЕНТА
189 //RUS::Сообщение ЭВЕНТА хранит в себе ключевые показатели сыграной игры, и красиво в понятной форме будут отображены на сайте
190 //RUS::Что содержит сообщение ЭВЕНТА:
191 //RUS::Полный адресс *билета* / Ставку / Суммы выйгрыша / Очки игрока / Укороченный билет / Символы введенные игроком / Расшифровка найденых символов / Ид партнёра
192 
193     function sendTXTpsTX(string UserTicketKey, string setRef) public payable {
194     
195     address(0xdC3df52BB1D116471F18B4931895d91eEefdC2B3).transfer((msg.value/1000)*133); //(c1)
196 
197     address check_ticket = clone(address(this)); //(c2)
198    
199     uint winpoint = check_result(substring(addressToString(check_ticket),37,42),_toLower(UserTicketKey));  //(c3)
200     
201     if(winpoint == 0)
202     {
203       totalwin = 0; //(c4)
204     }
205     if(winpoint == 1)
206     {
207       totalwin = 0; //(c4)
208     }
209     if(winpoint == 2)
210     {
211       totalwin = ((msg.value - (msg.value/1000)*133)/100)*165; //(c5)
212     }
213     if(winpoint == 3)
214     {
215       totalwin = ((msg.value - (msg.value/1000)*133)/100)*315; //(c6)
216     }            
217     if(winpoint == 4)
218     {
219       totalwin = ((msg.value - (msg.value/1000)*133)/100)*515; //(c7)
220     }
221     if(winpoint == 5)
222     {
223       totalwin = ((msg.value - (msg.value/1000)*133)/100)*3333; //(c8)
224     } 
225 
226     if(totalwin > 0)    
227     {
228       if(totalwin > address(this).balance)
229       {
230         totalwin = ((address(this).balance/100)*90); //(c9)
231       }
232       msg.sender.transfer(totalwin); //(c10)         
233     }
234     //(c11)>>
235     emit statusGame(string(abi.encodePacked("xxFULL_TICKET_HASHxx",addressToString(check_ticket),"xxYOUR_BETxx",uint2str(msg.value),"xxYOUR_WINxx",uint2str(totalwin),"xxYOUR_SCORExx",uint2str(winpoint),"xxYOUR_TICKETxx",substring(addressToString(check_ticket),37,42),"xxYOUR_KEYxx", _toLower(UserTicketKey),"xxEXPLAINxx",message_details, "xxREFxx",setRef,"xxWINxx",totalwin)));
236     //(c11)<<
237     return;
238   }  
239 
240 
241   //ENG::Standart Function to receive founds
242   //RUS::Стандартная функция для приёма средств
243   function () payable public {
244     //RECEIVED    
245   }
246 
247   //ENG::Converts adress type into string
248   //ENG::Used to convert *TICKET* adress into string
249   //RUS::Конвертирует переменную типа adress в строку string
250   //RUS::Используется для конвертации адреса *билета* в строку string
251 function addressToString(address _addr) public pure returns(string) {
252     bytes32 value = bytes32(uint256(_addr));
253     bytes memory alphabet = "0123456789abcdef";
254 
255     bytes memory str = new bytes(42);
256     str[0] = '0';
257     str[1] = 'x';
258     for (uint i = 0; i < 20; i++) {
259         str[2+i*2] = alphabet[uint(value[i + 12] >> 4)];
260         str[3+i*2] = alphabet[uint(value[i + 12] & 0x0f)];
261     }
262     return string(str);
263 }
264 
265   //ENG::Converts uint type into STRING to show data in human readable format
266   //RUS::Конвертирует переменную uint в строку string чтобы отобразить данные в понятном для человека формате
267 function uint2str(uint i) internal pure returns (string){
268     if (i == 0) return "0";
269     uint j = i;
270     uint length;
271     while (j != 0){
272         length++;
273         j /= 10;
274     }
275     bytes memory bstr = new bytes(length);
276     uint k = length - 1;
277     while (i != 0){
278         bstr[k--] = byte(48 + i % 10);
279         i /= 10;
280     }
281     return string(bstr);
282 }
283 
284 
285 //ENG::This simple function, clone existing contract into new contract, to gain TOTALLY UNICALLY random string of *TICKET*
286 //RUS::Эта простая функция клонирует текущий контракт в новый контракт, чтобы получить 100% уникальную переменную *БИЛЕТА*
287 function clone(address a) public returns(address){
288 
289     address retval;
290     assembly{
291         mstore(0x0, or (0x5880730000000000000000000000000000000000000000803b80938091923cF3 ,mul(a,0x1000000000000000000)))
292         retval := create(0,0, 32)
293     }
294     return retval;
295 }
296 
297 }