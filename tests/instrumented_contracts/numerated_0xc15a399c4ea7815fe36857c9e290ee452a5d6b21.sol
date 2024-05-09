1 pragma solidity ^0.4.13;
2 
3 /**
4  * Различные валидаторы
5  */
6 
7 contract ValidationUtil {
8     function requireNotEmptyAddress(address value) internal{
9         require(isAddressValid(value));
10     }
11 
12     function isAddressValid(address value) internal constant returns (bool result){
13         return value != 0;
14     }
15 }
16 
17 // File: contracts\zeppelin\contracts\math\SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
25     uint256 c = a * b;
26     assert(a == 0 || c / a == b);
27     return c;
28   }
29 
30   function div(uint256 a, uint256 b) internal constant returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return c;
35   }
36 
37   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   function add(uint256 a, uint256 b) internal constant returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57 
58   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   function Ownable() {
66     owner = msg.sender;
67   }
68 
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78   function getOwner() returns(address){
79     return owner;
80   }
81 
82   /**
83    * @dev Allows the current owner to transfer control of the contract to a newOwner.
84    * @param newOwner The address to transfer ownership to.
85    */
86   function transferOwnership(address newOwner) onlyOwner {
87     require(newOwner != address(0));      
88     OwnershipTransferred(owner, newOwner);
89     owner = newOwner;
90   }
91 
92 }
93 
94 /**
95  * @title ERC20Basic
96  * @dev Simpler version of ERC20 interface
97  * @dev see https://github.com/ethereum/EIPs/issues/179
98  */
99 contract ERC20Basic {
100   uint256 public totalSupply;
101   function balanceOf(address who) constant returns (uint256);
102   function transfer(address to, uint256 value) returns (bool);
103   event Transfer(address indexed from, address indexed to, uint256 value);
104 }
105 
106 /**
107  * @title Basic token
108  * @dev Basic version of StandardToken, with no allowances. 
109  */
110 contract BasicToken is ERC20Basic {
111   using SafeMath for uint256;
112 
113   mapping(address => uint256) balances;
114 
115   /**
116   * @dev transfer token for a specified address
117   * @param _to The address to transfer to.
118   * @param _value The amount to be transferred.
119   */
120   function transfer(address _to, uint256 _value) returns (bool) {
121     require(_to != address(0));
122 
123     // SafeMath.sub will throw if there is not enough balance.
124     balances[msg.sender] = balances[msg.sender].sub(_value);
125     balances[_to] = balances[_to].add(_value);
126     Transfer(msg.sender, _to, _value);
127     return true;
128   }
129 
130   /**
131   * @dev Gets the balance of the specified address.
132   * @param _owner The address to query the the balance of. 
133   * @return An uint256 representing the amount owned by the passed address.
134   */
135   function balanceOf(address _owner) constant returns (uint256 balance) {
136     return balances[_owner];
137   }
138 
139 }
140 
141 /**
142  * @title ERC20 interface
143  * @dev see https://github.com/ethereum/EIPs/issues/20
144  */
145 contract ERC20 is ERC20Basic {
146   function allowance(address owner, address spender) constant returns (uint256);
147   function transferFrom(address from, address to, uint256 value) returns (bool);
148   function approve(address spender, uint256 value) returns (bool);
149   event Approval(address indexed owner, address indexed spender, uint256 value);
150 }
151 
152 /**
153  * @title Standard ERC20 token
154  *
155  * @dev Implementation of the basic standard token.
156  * @dev https://github.com/ethereum/EIPs/issues/20
157  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
158  */
159 contract StandardToken is ERC20, BasicToken {
160 
161   mapping (address => mapping (address => uint256)) allowed;
162 
163 
164   /**
165    * @dev Transfer tokens from one address to another
166    * @param _from address The address which you want to send tokens from
167    * @param _to address The address which you want to transfer to
168    * @param _value uint256 the amount of tokens to be transferred
169    */
170   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
171     require(_to != address(0));
172 
173     var _allowance = allowed[_from][msg.sender];
174 
175     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
176     // require (_value <= _allowance);
177 
178     balances[_from] = balances[_from].sub(_value);
179     balances[_to] = balances[_to].add(_value);
180     allowed[_from][msg.sender] = _allowance.sub(_value);
181     Transfer(_from, _to, _value);
182     return true;
183   }
184 
185   /**
186    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
187    * @param _spender The address which will spend the funds.
188    * @param _value The amount of tokens to be spent.
189    */
190   function approve(address _spender, uint256 _value) returns (bool) {
191 
192     // To change the approve amount you first have to reduce the addresses`
193     //  allowance to zero by calling `approve(_spender, 0)` if it is not
194     //  already 0 to mitigate the race condition described here:
195     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
196     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
197 
198     allowed[msg.sender][_spender] = _value;
199     Approval(msg.sender, _spender, _value);
200     return true;
201   }
202 
203   /**
204    * @dev Function to check the amount of tokens that an owner allowed to a spender.
205    * @param _owner address The address which owns the funds.
206    * @param _spender address The address which will spend the funds.
207    * @return A uint256 specifying the amount of tokens still available for the spender.
208    */
209   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
210     return allowed[_owner][_spender];
211   }
212   
213   /**
214    * approve should be called when allowed[_spender] == 0. To increment
215    * allowed value is better to use this function to avoid 2 calls (and wait until 
216    * the first transaction is mined)
217    * From MonolithDAO Token.sol
218    */
219   function increaseApproval (address _spender, uint _addedValue) 
220     returns (bool success) {
221     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
222     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223     return true;
224   }
225 
226   function decreaseApproval (address _spender, uint _subtractedValue) 
227     returns (bool success) {
228     uint oldValue = allowed[msg.sender][_spender];
229     if (_subtractedValue > oldValue) {
230       allowed[msg.sender][_spender] = 0;
231     } else {
232       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
233     }
234     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
235     return true;
236   }
237 
238 }
239 
240 /**
241  * Шаблон для токена, который можно сжечь
242 */
243 contract BurnableToken is StandardToken, Ownable, ValidationUtil {
244     using SafeMath for uint;
245 
246     address public tokenOwnerBurner;
247 
248     /** Событие, сколько токенов мы сожгли */
249     event Burned(address burner, uint burnedAmount);
250 
251     function setOwnerBurner(address _tokenOwnerBurner) public onlyOwner invalidOwnerBurner{
252         // Проверка, что адрес не пустой
253         requireNotEmptyAddress(_tokenOwnerBurner);
254 
255         tokenOwnerBurner = _tokenOwnerBurner;
256     }
257 
258     /**
259      * Сжигаем токены на балансе владельца токенов, вызвать может только tokenOwnerBurner
260      */
261     function burnOwnerTokens(uint burnAmount) public onlyTokenOwnerBurner validOwnerBurner{
262         burnTokens(tokenOwnerBurner, burnAmount);
263     }
264 
265     /**
266      * Сжигаем токены на балансе адреса токенов, вызвать может только tokenOwnerBurner
267      */
268     function burnTokens(address _address, uint burnAmount) public onlyTokenOwnerBurner validOwnerBurner{
269         balances[_address] = balances[_address].sub(burnAmount);
270 
271         // Вызываем событие
272         Burned(_address, burnAmount);
273     }
274 
275     /**
276      * Сжигаем все токены на балансе владельца
277      */
278     function burnAllOwnerTokens() public onlyTokenOwnerBurner validOwnerBurner{
279         uint burnAmount = balances[tokenOwnerBurner];
280         burnTokens(tokenOwnerBurner, burnAmount);
281     }
282 
283     /** Модификаторы
284      */
285     modifier onlyTokenOwnerBurner() {
286         require(msg.sender == tokenOwnerBurner);
287 
288         _;
289     }
290 
291     modifier validOwnerBurner() {
292         // Проверка, что адрес не пустой
293         requireNotEmptyAddress(tokenOwnerBurner);
294 
295         _;
296     }
297 
298     modifier invalidOwnerBurner() {
299         // Проверка, что адрес не пустой
300         require(!isAddressValid(tokenOwnerBurner));
301 
302         _;
303     }
304 }
305 
306 /**
307  * Токен продаж
308  *
309  * ERC-20 токен, для ICO
310  *
311  */
312 
313 contract CrowdsaleToken is StandardToken, Ownable {
314 
315     /* Описание см. в конструкторе */
316     string public name;
317 
318     string public symbol;
319 
320     uint public decimals;
321 
322     address public mintAgent;
323 
324     /** Событие обновления токена (имя и символ) */
325     event UpdatedTokenInformation(string newName, string newSymbol);
326 
327     /** Событие выпуска токенов */
328     event TokenMinted(uint amount, address toAddress);
329 
330     /**
331      * Конструктор
332      *
333      * Токен должен быть создан только владельцем через кошелек (либо с мультиподписью, либо без нее)
334      *
335      * @param _name - имя токена
336      * @param _symbol - символ токена
337      * @param _decimals - кол-во знаков после запятой
338      */
339     function CrowdsaleToken(string _name, string _symbol, uint _decimals) {
340         owner = msg.sender;
341 
342         name = _name;
343         symbol = _symbol;
344 
345         decimals = _decimals;
346     }
347 
348     /**
349      * Владелец должен вызвать эту функцию, чтобы выпустить токены на адрес
350      */
351     function mintToAddress(uint amount, address toAddress) onlyMintAgent{
352         // перевод токенов на аккаунт
353         balances[toAddress] = amount;
354 
355         // вызываем событие
356         TokenMinted(amount, toAddress);
357     }
358 
359     /**
360      * Владелец может обновить инфу по токену
361      */
362     function setTokenInformation(string _name, string _symbol) onlyOwner {
363         name = _name;
364         symbol = _symbol;
365 
366         // Вызываем событие
367         UpdatedTokenInformation(name, symbol);
368     }
369 
370     /**
371      * Только владелец может обновить агента для создания токенов
372      */
373     function setMintAgent(address _address) onlyOwner {
374         mintAgent =  _address;
375     }
376 
377     modifier onlyMintAgent(){
378         require(msg.sender == mintAgent);
379 
380         _;
381     }
382 }
383 
384 /**
385  * Шаблон для продаж токена, который можно сжечь
386  *
387  */
388 contract BurnableCrowdsaleToken is BurnableToken, CrowdsaleToken {
389 
390     function BurnableCrowdsaleToken(string _name, string _symbol, uint _decimals) CrowdsaleToken(_name, _symbol, _decimals) BurnableToken(){
391 
392     }
393 }