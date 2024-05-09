1 pragma solidity ^0.4.11;
2 
3 /**
4  * Различные валидаторы
5  */
6 
7 contract ValidationUtil {
8     function requireValidAddress(address value){
9         require(isAddressNotEmpty(value));
10     }
11 
12     function isAddressNotEmpty(address value) internal returns (bool result){
13         return value != 0;
14     }
15 }
16 
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a * b;
24     assert(a == 0 || c / a == b);
25     return c;
26   }
27 
28   function div(uint256 a, uint256 b) internal constant returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint256 a, uint256 b) internal constant returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 /**
48  * @title Ownable
49  * @dev The Ownable contract has an owner address, and provides basic authorization control
50  * functions, this simplifies the implementation of "user permissions".
51  */
52 contract Ownable {
53   address public owner;
54 
55 
56   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58 
59   /**
60    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
61    * account.
62    */
63   function Ownable() {
64     owner = msg.sender;
65   }
66 
67 
68   /**
69    * @dev Throws if called by any account other than the owner.
70    */
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) onlyOwner {
82     require(newOwner != address(0));      
83     OwnershipTransferred(owner, newOwner);
84     owner = newOwner;
85   }
86 
87 }
88 
89 /**
90  * @title ERC20Basic
91  * @dev Simpler version of ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/179
93  */
94 contract ERC20Basic {
95   uint256 public totalSupply;
96   function balanceOf(address who) constant returns (uint256);
97   function transfer(address to, uint256 value) returns (bool);
98   event Transfer(address indexed from, address indexed to, uint256 value);
99 }
100 
101 /**
102  * @title Basic token
103  * @dev Basic version of StandardToken, with no allowances. 
104  */
105 contract BasicToken is ERC20Basic {
106   using SafeMath for uint256;
107 
108   mapping(address => uint256) balances;
109 
110   /**
111   * @dev transfer token for a specified address
112   * @param _to The address to transfer to.
113   * @param _value The amount to be transferred.
114   */
115   function transfer(address _to, uint256 _value) returns (bool) {
116     require(_to != address(0));
117 
118     // SafeMath.sub will throw if there is not enough balance.
119     balances[msg.sender] = balances[msg.sender].sub(_value);
120     balances[_to] = balances[_to].add(_value);
121     Transfer(msg.sender, _to, _value);
122     return true;
123   }
124 
125   /**
126   * @dev Gets the balance of the specified address.
127   * @param _owner The address to query the the balance of. 
128   * @return An uint256 representing the amount owned by the passed address.
129   */
130   function balanceOf(address _owner) constant returns (uint256 balance) {
131     return balances[_owner];
132   }
133 
134 }
135 
136 /**
137  * @title ERC20 interface
138  * @dev see https://github.com/ethereum/EIPs/issues/20
139  */
140 contract ERC20 is ERC20Basic {
141   function allowance(address owner, address spender) constant returns (uint256);
142   function transferFrom(address from, address to, uint256 value) returns (bool);
143   function approve(address spender, uint256 value) returns (bool);
144   event Approval(address indexed owner, address indexed spender, uint256 value);
145 }
146 
147 /**
148  * @title Standard ERC20 token
149  *
150  * @dev Implementation of the basic standard token.
151  * @dev https://github.com/ethereum/EIPs/issues/20
152  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
153  */
154 contract StandardToken is ERC20, BasicToken {
155 
156   mapping (address => mapping (address => uint256)) allowed;
157 
158 
159   /**
160    * @dev Transfer tokens from one address to another
161    * @param _from address The address which you want to send tokens from
162    * @param _to address The address which you want to transfer to
163    * @param _value uint256 the amount of tokens to be transferred
164    */
165   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
166     require(_to != address(0));
167 
168     var _allowance = allowed[_from][msg.sender];
169 
170     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
171     // require (_value <= _allowance);
172 
173     balances[_from] = balances[_from].sub(_value);
174     balances[_to] = balances[_to].add(_value);
175     allowed[_from][msg.sender] = _allowance.sub(_value);
176     Transfer(_from, _to, _value);
177     return true;
178   }
179 
180   /**
181    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
182    * @param _spender The address which will spend the funds.
183    * @param _value The amount of tokens to be spent.
184    */
185   function approve(address _spender, uint256 _value) returns (bool) {
186 
187     // To change the approve amount you first have to reduce the addresses`
188     //  allowance to zero by calling `approve(_spender, 0)` if it is not
189     //  already 0 to mitigate the race condition described here:
190     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
192 
193     allowed[msg.sender][_spender] = _value;
194     Approval(msg.sender, _spender, _value);
195     return true;
196   }
197 
198   /**
199    * @dev Function to check the amount of tokens that an owner allowed to a spender.
200    * @param _owner address The address which owns the funds.
201    * @param _spender address The address which will spend the funds.
202    * @return A uint256 specifying the amount of tokens still available for the spender.
203    */
204   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
205     return allowed[_owner][_spender];
206   }
207   
208   /**
209    * approve should be called when allowed[_spender] == 0. To increment
210    * allowed value is better to use this function to avoid 2 calls (and wait until 
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    */
214   function increaseApproval (address _spender, uint _addedValue) 
215     returns (bool success) {
216     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
217     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221   function decreaseApproval (address _spender, uint _subtractedValue) 
222     returns (bool success) {
223     uint oldValue = allowed[msg.sender][_spender];
224     if (_subtractedValue > oldValue) {
225       allowed[msg.sender][_spender] = 0;
226     } else {
227       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
228     }
229     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230     return true;
231   }
232 
233 }
234 
235 /**
236  * Шаблон для токена, который можно сжечь
237  *
238  */
239 
240 contract BurnableToken is StandardToken, Ownable, ValidationUtil {
241     using SafeMath for uint;
242 
243     address public tokenOwnerBurner;
244 
245     /** Событие, сколько токенов мы сожгли */
246     event Burned(address burner, uint burnedAmount);
247 
248     function setOwnerBurner(address _tokenOwnerBurner) public onlyOwner invalidOwnerBurner{
249         // Проверка, что адрес не пустой
250         requireValidAddress(_tokenOwnerBurner);
251 
252         tokenOwnerBurner = _tokenOwnerBurner;
253     }
254 
255     /**
256      * Сжигаем токены на балансе burner'а
257      */
258     function internalBurnTokens(address burner, uint burnAmount) internal {
259         balances[burner] = balances[burner].sub(burnAmount);
260         totalSupply = totalSupply.sub(burnAmount);
261 
262         // Вызываем событие
263         Burned(burner, burnAmount);
264     }
265 
266     /**
267      * Сжигаем токены на балансе владельца токенов может только адрес tokenOwnerBurner
268      */
269     function burnOwnerTokens(uint burnAmount) public onlyTokenOwnerBurner validOwnerBurner{
270         internalBurnTokens(tokenOwnerBurner, burnAmount);
271     }
272 
273     /** Модификаторы
274      */
275     modifier onlyTokenOwnerBurner() {
276         require(msg.sender == tokenOwnerBurner);
277 
278         _;
279     }
280 
281     modifier validOwnerBurner() {
282         // Проверка, что адрес не пустой
283         requireValidAddress(tokenOwnerBurner);
284 
285         _;
286     }
287 
288     modifier invalidOwnerBurner() {
289         // Проверка, что адрес не пустой
290         require(!isAddressNotEmpty(tokenOwnerBurner));
291 
292         _;
293     }
294 }
295 
296 /**
297  * Токен продаж
298  *
299  * ERC-20 токен, для ICO
300  *
301  * - Токен может быть с верхним лимитом или без него
302  *
303  */
304 
305 contract CrowdsaleToken is StandardToken, Ownable {
306 
307     /* Описание см. в конструкторе */
308     string public name;
309     string public symbol;
310     uint public decimals;
311 
312     bool public isInitialSupplied = false;
313 
314     /** Событие обновления токена (имя и символ) */
315     event UpdatedTokenInformation(string name, string symbol);
316 
317     /**
318      * Конструктор
319      *
320      * Токен должен быть создан только владельцем через кошелек (либо с мультиподписью, либо без нее)
321      *
322      * @param _name - имя токена
323      * @param _symbol - символ токена
324      * @param _initialSupply - со сколькими токенами мы стартуем
325      * @param _decimals - кол-во знаков после запятой
326      */
327     function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals) {
328         require(_initialSupply != 0);
329 
330         name = _name;
331         symbol = _symbol;
332         decimals = _decimals;
333 
334         totalSupply = _initialSupply;
335     }
336 
337     /**
338      * Владелец должен вызвать эту функцию, чтобы присвоить начальный баланс
339      */
340     function initialSupply(address _toAddress) external onlyOwner {
341         require(!isInitialSupplied);
342 
343         // Создаем начальный баланс токенов на кошельке
344         balances[_toAddress] = totalSupply;
345 
346         isInitialSupplied = true;
347     }
348 
349     /**
350      * Владелец может обновить инфу по токену
351      */
352     function setTokenInformation(string _name, string _symbol) external onlyOwner {
353         name = _name;
354         symbol = _symbol;
355 
356         // Вызываем событие
357         UpdatedTokenInformation(name, symbol);
358     }
359 
360 }
361 
362 /**
363  * Шаблон для продаж токена, который можно сжечь
364  *
365  */
366 contract BurnableCrowdsaleToken is BurnableToken, CrowdsaleToken {
367 
368     function BurnableCrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals) CrowdsaleToken(_name, _symbol, _initialSupply, _decimals) BurnableToken(){
369 
370     }
371 
372 }