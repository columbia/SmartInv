1 pragma solidity ^0.4.16;
2 
3 contract SafeMath {
4 
5     function safeAdd(uint256 x, uint256 y) view internal returns (uint256) {
6         uint256 z = x + y;
7         assert((z >= x) && (z >= y));
8         return z;
9     }
10 
11     function safeSubtract(uint256 x, uint256 y) view internal returns (uint256) {
12         assert(x >= y);
13         uint256 z = x - y;
14         return z;
15     }
16 
17     function safeMult(uint256 x, uint256 y) view internal returns (uint256) {
18         uint256 z = x * y;
19         assert((x == 0) || (z / x == y));
20         return z;
21     }
22 
23     function safeDiv(uint256 a, uint256 b) view internal returns (uint256) {
24         assert(b > 0);
25         uint c = a / b;
26         assert(a == b * c + a % b);
27         return c;
28     }
29 }
30 
31 contract Owner {
32 	
33 	// Адреса владельцев
34 	mapping ( address => bool ) public ownerAddressMap;
35 	// Соответсвие адреса владельца и его номера
36 	mapping ( address => uint256 ) public ownerAddressNumberMap;
37 	// список менеджеров
38 	mapping ( uint256 => address ) public ownerListMap;
39 	// сколько всего менеджеров
40 	uint256 public ownerCountInt = 0;
41 	
42 	// событие "изменение в контракте"
43 	event ContractManagementUpdate( string _type, address _initiator, address _to, bool _newvalue );
44 
45 	// модификатор - если смотрит владелец
46 	modifier isOwner {
47         require( ownerAddressMap[msg.sender]==true );
48         _;
49     }
50 	
51 	// создание/включение владельца
52 	function ownerOn( address _onOwnerAddress ) external isOwner returns (bool retrnVal) {
53 		// Check if it's a non-zero address
54 		require( _onOwnerAddress != address(0) );
55 		// если такой владелец есть (стартового владельца удалить нельзя)
56 		if ( ownerAddressNumberMap[ _onOwnerAddress ]>0 )
57 		{
58 			// если такой владелец отключен, влючим его обратно
59 			if ( !ownerAddressMap[ _onOwnerAddress ] )
60 			{
61 				ownerAddressMap[ _onOwnerAddress ] = true;
62 				ContractManagementUpdate( "Owner", msg.sender, _onOwnerAddress, true );
63 				retrnVal = true;
64 			}
65 			else
66 			{
67 				retrnVal = false;
68 			}
69 		}
70 		// если такого владеьца нет
71 		else
72 		{
73 			ownerAddressMap[ _onOwnerAddress ] = true;
74 			ownerAddressNumberMap[ _onOwnerAddress ] = ownerCountInt;
75 			ownerListMap[ ownerCountInt ] = _onOwnerAddress;
76 			ownerCountInt++;
77 			ContractManagementUpdate( "Owner", msg.sender, _onOwnerAddress, true );
78 			retrnVal = true;
79 		}
80 	}
81 	
82 	// отключение менеджера
83 	function ownerOff( address _offOwnerAddress ) external isOwner returns (bool retrnVal) {
84 		// если такой менеджер есть и он не 0-вой, а также активен
85 		// 0-вой менеджер не может быть отключен
86 		if ( ownerAddressNumberMap[ _offOwnerAddress ]>0 && ownerAddressMap[ _offOwnerAddress ] )
87 		{
88 			ownerAddressMap[ _offOwnerAddress ] = false;
89 			ContractManagementUpdate( "Owner", msg.sender, _offOwnerAddress, false );
90 			retrnVal = true;
91 		}
92 		else
93 		{
94 			retrnVal = false;
95 		}
96 	}
97 
98 	// конструктор, при создании контракта добалвяет создателя в "неудаляемые" создатели
99 	function Owner() public {
100 		// создаем владельца
101 		ownerAddressMap[ msg.sender ] = true;
102 		ownerAddressNumberMap[ msg.sender ] = ownerCountInt;
103 		ownerListMap[ ownerCountInt ] = msg.sender;
104 		ownerCountInt++;
105 	}
106 }
107 
108 contract SpecialManager is Owner {
109 
110 	// адреса специальных менеджеров
111 	mapping ( address => bool ) public specialManagerAddressMap;
112 	// Соответсвие адреса специального менеджера и его номера
113 	mapping ( address => uint256 ) public specialManagerAddressNumberMap;
114 	// список специальноых менеджеров
115 	mapping ( uint256 => address ) public specialManagerListMap;
116 	// сколько всего специальных менеджеров
117 	uint256 public specialManagerCountInt = 0;
118 	
119 	// модификатор - если смотрит владелец или специальный менеджер
120 	modifier isSpecialManagerOrOwner {
121         require( specialManagerAddressMap[msg.sender]==true || ownerAddressMap[msg.sender]==true );
122         _;
123     }
124 	
125 	// создание/включение специального менеджера
126 	function specialManagerOn( address _onSpecialManagerAddress ) external isOwner returns (bool retrnVal) {
127 		// Check if it's a non-zero address
128 		require( _onSpecialManagerAddress != address(0) );
129 		// если такой менеджер есть
130 		if ( specialManagerAddressNumberMap[ _onSpecialManagerAddress ]>0 )
131 		{
132 			// если такой менеджер отключен, влючим его обратно
133 			if ( !specialManagerAddressMap[ _onSpecialManagerAddress ] )
134 			{
135 				specialManagerAddressMap[ _onSpecialManagerAddress ] = true;
136 				ContractManagementUpdate( "Special Manager", msg.sender, _onSpecialManagerAddress, true );
137 				retrnVal = true;
138 			}
139 			else
140 			{
141 				retrnVal = false;
142 			}
143 		}
144 		// если такого менеджера нет
145 		else
146 		{
147 			specialManagerAddressMap[ _onSpecialManagerAddress ] = true;
148 			specialManagerAddressNumberMap[ _onSpecialManagerAddress ] = specialManagerCountInt;
149 			specialManagerListMap[ specialManagerCountInt ] = _onSpecialManagerAddress;
150 			specialManagerCountInt++;
151 			ContractManagementUpdate( "Special Manager", msg.sender, _onSpecialManagerAddress, true );
152 			retrnVal = true;
153 		}
154 	}
155 	
156 	// отключение менеджера
157 	function specialManagerOff( address _offSpecialManagerAddress ) external isOwner returns (bool retrnVal) {
158 		// если такой менеджер есть и он не 0-вой, а также активен
159 		// 0-вой менеджер не может быть отключен
160 		if ( specialManagerAddressNumberMap[ _offSpecialManagerAddress ]>0 && specialManagerAddressMap[ _offSpecialManagerAddress ] )
161 		{
162 			specialManagerAddressMap[ _offSpecialManagerAddress ] = false;
163 			ContractManagementUpdate( "Special Manager", msg.sender, _offSpecialManagerAddress, false );
164 			retrnVal = true;
165 		}
166 		else
167 		{
168 			retrnVal = false;
169 		}
170 	}
171 
172 
173 	// конструктор, добавляет создателя в суперменеджеры
174 	function SpecialManager() public {
175 		// создаем менеджера
176 		specialManagerAddressMap[ msg.sender ] = true;
177 		specialManagerAddressNumberMap[ msg.sender ] = specialManagerCountInt;
178 		specialManagerListMap[ specialManagerCountInt ] = msg.sender;
179 		specialManagerCountInt++;
180 	}
181 }
182 
183 contract Manager is SpecialManager {
184 	
185 	// адрес менеджеров
186 	mapping ( address => bool ) public managerAddressMap;
187 	// Соответсвие адреса менеджеров и его номера
188 	mapping ( address => uint256 ) public managerAddressNumberMap;
189 	// список менеджеров
190 	mapping ( uint256 => address ) public managerListMap;
191 	// сколько всего менеджеров
192 	uint256 public managerCountInt = 0;
193 	
194 	// модификатор - если смотрит владелец или менеджер
195 	modifier isManagerOrOwner {
196         require( managerAddressMap[msg.sender]==true || ownerAddressMap[msg.sender]==true );
197         _;
198     }
199 	
200 	// создание/включение менеджера
201 	function managerOn( address _onManagerAddress ) external isOwner returns (bool retrnVal) {
202 		// Check if it's a non-zero address
203 		require( _onManagerAddress != address(0) );
204 		// если такой менеджер есть
205 		if ( managerAddressNumberMap[ _onManagerAddress ]>0 )
206 		{
207 			// если такой менеджер отключен, влючим его обратно
208 			if ( !managerAddressMap[ _onManagerAddress ] )
209 			{
210 				managerAddressMap[ _onManagerAddress ] = true;
211 				ContractManagementUpdate( "Manager", msg.sender, _onManagerAddress, true );
212 				retrnVal = true;
213 			}
214 			else
215 			{
216 				retrnVal = false;
217 			}
218 		}
219 		// если такого менеджера нет
220 		else
221 		{
222 			managerAddressMap[ _onManagerAddress ] = true;
223 			managerAddressNumberMap[ _onManagerAddress ] = managerCountInt;
224 			managerListMap[ managerCountInt ] = _onManagerAddress;
225 			managerCountInt++;
226 			ContractManagementUpdate( "Manager", msg.sender, _onManagerAddress, true );
227 			retrnVal = true;
228 		}
229 	}
230 	
231 	// отключение менеджера
232 	function managerOff( address _offManagerAddress ) external isOwner returns (bool retrnVal) {
233 		// если такой менеджер есть и он не 0-вой, а также активен
234 		// 0-вой менеджер не может быть отключен
235 		if ( managerAddressNumberMap[ _offManagerAddress ]>0 && managerAddressMap[ _offManagerAddress ] )
236 		{
237 			managerAddressMap[ _offManagerAddress ] = false;
238 			ContractManagementUpdate( "Manager", msg.sender, _offManagerAddress, false );
239 			retrnVal = true;
240 		}
241 		else
242 		{
243 			retrnVal = false;
244 		}
245 	}
246 
247 
248 	// конструктор, добавляет создателя в менеджеры
249 	function Manager() public {
250 		// создаем менеджера
251 		managerAddressMap[ msg.sender ] = true;
252 		managerAddressNumberMap[ msg.sender ] = managerCountInt;
253 		managerListMap[ managerCountInt ] = msg.sender;
254 		managerCountInt++;
255 	}
256 }
257 
258 contract Management is Manager {
259 	
260 	// текстовое описание контракта
261 	string public description = "";
262 	
263 	// текущий статус разрешения транзакций
264 	// TRUE - транзакции возможны
265 	// FALSE - транзакции не возможны
266 	bool public transactionsOn = false;
267 	
268 	// текущий статус эмиссии
269 	// TRUE - эмиссия возможна, менеджеры могут добавлять в контракт токены
270 	// FALSE - эмиссия невозможна, менеджеры не могут добавлять в контракт токены
271 	bool public emissionOn = true;
272 
273 	// потолок эмиссии
274 	uint256 public tokenCreationCap = 0;
275 	
276 	// модификатор - транзакции возможны
277 	modifier isTransactionsOn{
278         require( transactionsOn );
279         _;
280     }
281 	
282 	// модификатор - эмиссия возможна
283 	modifier isEmissionOn{
284         require( emissionOn );
285         _;
286     }
287 	
288 	// функция изменения статуса транзакций
289 	function transactionsStatusUpdate( bool _on ) external isOwner
290 	{
291 		transactionsOn = _on;
292 	}
293 	
294 	// функция изменения статуса эмиссии
295 	function emissionStatusUpdate( bool _on ) external isOwner
296 	{
297 		emissionOn = _on;
298 	}
299 	
300 	// установка потолка эмиссии
301 	function tokenCreationCapUpdate( uint256 _newVal ) external isOwner
302 	{
303 		tokenCreationCap = _newVal;
304 	}
305 	
306 	// событие, "смена описания"
307 	event DescriptionPublished( string _description, address _initiator);
308 	
309 	// изменение текста
310 	function descriptionUpdate( string _newVal ) external isOwner
311 	{
312 		description = _newVal;
313 		DescriptionPublished( _newVal, msg.sender );
314 	}
315 }
316 
317 // Токен-контракт FoodCoin Ecosystem
318 contract FoodcoinEcosystem is SafeMath, Management {
319 	
320 	// название токена
321 	string public constant name = "FoodCoin EcoSystem";
322 	// короткое название токена
323 	string public constant symbol = "FOOD";
324 	// точность токена (знаков после запятой для вывода в кошельках)
325 	uint256 public constant decimals = 8;
326 	// общее кол-во выпущенных токенов
327 	uint256 public totalSupply = 0;
328 	
329 	// состояние счета
330 	mapping ( address => uint256 ) balances;
331 	// список всех счетов
332 	mapping ( uint256 => address ) public balancesListAddressMap;
333 	// соответсвие счета и его номера
334 	mapping ( address => uint256 ) public balancesListNumberMap;
335 	// текстовое описание счета
336 	mapping ( address => string ) public balancesAddressDescription;
337 	// общее кол-во всех счетов
338 	uint256 balancesCountInt = 1;
339 	
340 	// делегирование на управление счетом на определенную сумму
341 	mapping ( address => mapping ( address => uint256 ) ) allowed;
342 	
343 	
344 	// событие - транзакция
345 	event Transfer(address _from, address _to, uint256 _value, address _initiator);
346 	
347 	// событие делегирование управления счетом
348 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
349 	
350 	// событие - эмиссия
351 	event TokenEmissionEvent( address initiatorAddress, uint256 amount, bool emissionOk );
352 	
353 	// событие - списание средств
354 	event WithdrawEvent( address initiatorAddress, address toAddress, bool withdrawOk, uint256 withdrawValue, uint256 newBalancesValue );
355 	
356 	
357 	// проссмотра баланса счета
358 	function balanceOf( address _owner ) external view returns ( uint256 )
359 	{
360 		return balances[ _owner ];
361 	}
362 	// Check if a given user has been delegated rights to perform transfers on behalf of the account owner
363 	function allowance( address _owner, address _initiator ) external view returns ( uint256 remaining )
364 	{
365 		return allowed[ _owner ][ _initiator ];
366 	}
367 	// общее кол-во счетов
368 	function balancesQuantity() external view returns ( uint256 )
369 	{
370 		return balancesCountInt - 1;
371 	}
372 	
373 	// функция непосредственного перевода токенов. Если это первое получение средств для какого-то счета, то также создается детальная информация по этому счету
374 	function _addClientAddress( address _balancesAddress, uint256 _amount ) internal
375 	{
376 		// check if this address is not on the list yet
377 		if ( balancesListNumberMap[ _balancesAddress ] == 0 )
378 		{
379 			// add it to the list
380 			balancesListAddressMap[ balancesCountInt ] = _balancesAddress;
381 			balancesListNumberMap[ _balancesAddress ] = balancesCountInt;
382 			// increment account counter
383 			balancesCountInt++;
384 		}
385 		// add tokens to the account 
386 		balances[ _balancesAddress ] = safeAdd( balances[ _balancesAddress ], _amount );
387 	}
388 	// Internal function that performs the actual transfer (cannot be called externally)
389 	function _transfer( address _from, address _to, uint256 _value ) internal isTransactionsOn returns ( bool success )
390 	{
391 		// If the amount to transfer is greater than 0, and sender has funds available
392 		if ( _value > 0 && balances[ _from ] >= _value )
393 		{
394 			// Subtract from sender account
395 			balances[ _from ] -= _value;
396 			// Add to receiver's account
397 			_addClientAddress( _to, _value );
398 			// Perform the transfer
399 			Transfer( _from, _to, _value, msg.sender );
400 			// Successfully completed transfer
401 			return true;
402 		}
403 		// Return false if there are problems
404 		else
405 		{
406 			return false;
407 		}
408 	}
409 	// функция перевода токенов
410 	function transfer(address _to, uint256 _value) external isTransactionsOn returns ( bool success )
411 	{
412 		return _transfer( msg.sender, _to, _value );
413 	}
414 	// функция перевода токенов с делегированного счета
415 	function transferFrom(address _from, address _to, uint256 _value) external isTransactionsOn returns ( bool success )
416 	{
417 		// Check if the transfer initiator has permissions to move funds from the sender's account
418 		if ( allowed[_from][msg.sender] >= _value )
419 		{
420 			// If yes - perform transfer 
421 			if ( _transfer( _from, _to, _value ) )
422 			{
423 				// Decrease the total amount that initiator has permissions to access
424 				allowed[_from][msg.sender] = safeSubtract(allowed[_from][msg.sender], _value);
425 				return true;
426 			}
427 			else
428 			{
429 				return false;
430 			}
431 		}
432 		else
433 		{
434 			return false;
435 		}
436 	}
437 	// функция делегирования управления счетом на определенную сумму
438 	function approve( address _initiator, uint256 _value ) external isTransactionsOn returns ( bool success )
439 	{
440 		// Grant the rights for a certain amount of tokens only
441 		allowed[ msg.sender ][ _initiator ] = _value;
442 		// Initiate the Approval event
443 		Approval( msg.sender, _initiator, _value );
444 		return true;
445 	}
446 	
447 	// функция эмиссии (менеджер или владелец контракта создает токены и отправляет их на определенный счет)
448 	function tokenEmission(address _reciever, uint256 _amount) external isManagerOrOwner isEmissionOn returns ( bool returnVal )
449 	{
450 		// Check if it's a non-zero address
451 		require( _reciever != address(0) );
452 		// Calculate number of tokens after generation
453 		uint256 checkedSupply = safeAdd( totalSupply, _amount );
454 		// сумма к эмиссии
455 		uint256 amountTmp = _amount;
456 		// Если потолок эмиссии установлен, то нельзя выпускать больше этого потолка
457 		if ( tokenCreationCap > 0 && tokenCreationCap < checkedSupply )
458 		{
459 			amountTmp = 0;
460 		}
461 		// если попытка добавить больше 0-ля токенов
462 		if ( amountTmp > 0 )
463 		{
464 			// If no error, add generated tokens to a given address
465 			_addClientAddress( _reciever, amountTmp );
466 			// increase total supply of tokens
467 			totalSupply = checkedSupply;
468 			TokenEmissionEvent( msg.sender, _amount, true);
469 		}
470 		else
471 		{
472 			returnVal = false;
473 			TokenEmissionEvent( msg.sender, _amount, false);
474 		}
475 	}
476 	
477 	// функция списания токенов
478 	function withdraw( address _to, uint256 _amount ) external isSpecialManagerOrOwner returns ( bool returnVal, uint256 withdrawValue, uint256 newBalancesValue )
479 	{
480 		// check if this is a valid account
481 		if ( balances[ _to ] > 0 )
482 		{
483 			// сумма к списанию
484 			uint256 amountTmp = _amount;
485 			// нельзя списать больше, чем есть на счету
486 			if ( balances[ _to ] < _amount )
487 			{
488 				amountTmp = balances[ _to ];
489 			}
490 			// проводим списывание
491 			balances[ _to ] = safeSubtract( balances[ _to ], amountTmp );
492 			// меняем текущее общее кол-во токенов
493 			totalSupply = safeSubtract( totalSupply, amountTmp );
494 			// возвращаем ответ
495 			returnVal = true;
496 			withdrawValue = amountTmp;
497 			newBalancesValue = balances[ _to ];
498 			WithdrawEvent( msg.sender, _to, true, amountTmp, balances[ _to ] );
499 		}
500 		else
501 		{
502 			returnVal = false;
503 			withdrawValue = 0;
504 			newBalancesValue = 0;
505 			WithdrawEvent( msg.sender, _to, false, _amount, balances[ _to ] );
506 		}
507 	}
508 	
509 	// добавление описания к счету
510 	function balancesAddressDescriptionUpdate( string _newDescription ) external returns ( bool returnVal )
511 	{
512 		// если такой аккаунт есть или владелец контракта
513 		if ( balancesListNumberMap[ msg.sender ] > 0 || ownerAddressMap[msg.sender]==true )
514 		{
515 			balancesAddressDescription[ msg.sender ] = _newDescription;
516 			returnVal = true;
517 		}
518 		else
519 		{
520 			returnVal = false;
521 		}
522 	}
523 }