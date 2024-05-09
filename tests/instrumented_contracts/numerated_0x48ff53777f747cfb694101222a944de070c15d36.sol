1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 library ECRecovery {
34 
35   /**
36    * @dev Recover signer address from a message by using his signature
37    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
38    * @param sig bytes signature, the signature is generated using web3.eth.sign()
39    */
40   function recover(bytes32 hash, bytes sig) constant returns (address) {
41     bytes32 r;
42     bytes32 s;
43     uint8 v;
44 
45     //Check the signature length
46     if (sig.length != 65) {
47       return (address(0));
48     }
49 
50     // Divide the signature in r, s and v variables
51     assembly {
52       r := mload(add(sig, 32))
53       s := mload(add(sig, 64))
54       v := byte(0, mload(add(sig, 96)))
55     }
56 
57     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
58     if (v < 27) {
59       v += 27;
60     }
61 
62     // If the version is correct return the signer address
63     if (v != 27 && v != 28) {
64       return (address(0));
65     } else {
66       /* prefix might be needed for geth and parity
67       * https://github.com/ethereum/go-ethereum/issues/3731
68       */
69       bytes memory prefix = "\x19Ethereum Signed Message:\n32";
70       hash = sha3(prefix, hash);
71       return ecrecover(hash, v, r, s);
72     }
73   }
74 
75 }
76 
77 
78 /**
79  * @title Ownable
80  * @dev The Ownable contract has an owner address, and provides basic authorization control
81  * functions, this simplifies the implementation of "user permissions".
82  */
83 contract Ownable {
84   address public owner;
85 
86 
87   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
88 
89 
90   /**
91    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
92    * account.
93    */
94   function Ownable() {
95     owner = msg.sender;
96   }
97 
98 
99   /**
100    * @dev Throws if called by any account other than the owner.
101    */
102   modifier onlyOwner() {
103     require(msg.sender == owner);
104     _;
105   }
106 
107 
108   /**
109    * @dev Allows the current owner to transfer control of the contract to a newOwner.
110    * @param newOwner The address to transfer ownership to.
111    */
112   function transferOwnership(address newOwner) onlyOwner {
113     require(newOwner != address(0));      
114     OwnershipTransferred(owner, newOwner);
115     owner = newOwner;
116   }
117 
118 }
119 
120 
121 
122 
123 contract ERC20Basic {
124   uint256 public totalSupply;
125   function balanceOf(address who) constant returns (uint256);
126   function transfer(address to, uint256 value) returns (bool);
127   event Transfer(address indexed from, address indexed to, uint256 value);
128 }
129 
130 
131 
132 contract ERC20 is ERC20Basic {
133   function allowance(address owner, address spender) constant returns (uint256);
134   function transferFrom(address from, address to, uint256 value) returns (bool);
135   function approve(address spender, uint256 value) returns (bool);
136   event Approval(address indexed owner, address indexed spender, uint256 value);
137 }
138 
139 
140 contract BasicToken is ERC20Basic {
141   using SafeMath for uint256;
142 
143   mapping(address => uint256) balances;
144 
145   /**
146   * @dev transfer token for a specified address
147   * @param _to The address to transfer to.
148   * @param _value The amount to be transferred.
149   */
150   function transfer(address _to, uint256 _value) returns (bool) {
151     require(_to != address(0));
152 
153     // SafeMath.sub will throw if there is not enough balance.
154     balances[msg.sender] = balances[msg.sender].sub(_value);
155     balances[_to] = balances[_to].add(_value);
156     Transfer(msg.sender, _to, _value);
157     return true;
158   }
159 
160   /**
161   * @dev Gets the balance of the specified address.
162   * @param _owner The address to query the the balance of. 
163   * @return An uint256 representing the amount owned by the passed address.
164   */
165   function balanceOf(address _owner) constant returns (uint256 balance) {
166     return balances[_owner];
167   }
168 
169 }
170 
171 
172 
173 contract StandardToken is ERC20, BasicToken {
174 
175   mapping (address => mapping (address => uint256)) allowed;
176 
177 
178   /**
179    * @dev Transfer tokens from one address to another
180    * @param _from address The address which you want to send tokens from
181    * @param _to address The address which you want to transfer to
182    * @param _value uint256 the amount of tokens to be transferred
183    */
184   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
185     require(_to != address(0));
186 
187     var _allowance = allowed[_from][msg.sender];
188 
189     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
190     // require (_value <= _allowance);
191 
192     balances[_from] = balances[_from].sub(_value);
193     balances[_to] = balances[_to].add(_value);
194     allowed[_from][msg.sender] = _allowance.sub(_value);
195     Transfer(_from, _to, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
201    * @param _spender The address which will spend the funds.
202    * @param _value The amount of tokens to be spent.
203    */
204   function approve(address _spender, uint256 _value) returns (bool) {
205 
206     // To change the approve amount you first have to reduce the addresses`
207     //  allowance to zero by calling `approve(_spender, 0)` if it is not
208     //  already 0 to mitigate the race condition described here:
209     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
210     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
211 
212     allowed[msg.sender][_spender] = _value;
213     Approval(msg.sender, _spender, _value);
214     return true;
215   }
216 
217   /**
218    * @dev Function to check the amount of tokens that an owner allowed to a spender.
219    * @param _owner address The address which owns the funds.
220    * @param _spender address The address which will spend the funds.
221    * @return A uint256 specifying the amount of tokens still available for the spender.
222    */
223   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
224     return allowed[_owner][_spender];
225   }
226   
227   /**
228    * approve should be called when allowed[_spender] == 0. To increment
229    * allowed value is better to use this function to avoid 2 calls (and wait until 
230    * the first transaction is mined)
231    * From MonolithDAO ImpToken.sol
232    */
233   function increaseApproval (address _spender, uint _addedValue) 
234     returns (bool success) {
235     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
236     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237     return true;
238   }
239 
240   function decreaseApproval (address _spender, uint _subtractedValue) 
241     returns (bool success) {
242     uint oldValue = allowed[msg.sender][_spender];
243     if (_subtractedValue > oldValue) {
244       allowed[msg.sender][_spender] = 0;
245     } else {
246       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
247     }
248     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
249     return true;
250   }
251 
252 }
253 
254 
255 
256 
257 
258 
259 
260 
261 
262 
263 
264 
265 
266 contract ValidationUtil {
267     function requireNotEmptyAddress(address value){
268         require(isAddressNotEmpty(value));
269     }
270 
271     function isAddressNotEmpty(address value) internal returns (bool result){
272         return value != 0;
273     }
274 }
275 
276 
277 
278 
279 
280 
281 
282 
283 
284 
285 
286 
287 /**
288  * Контракт ERC-20 токена
289  */
290 
291 contract ImpToken is StandardToken, Ownable {
292     using SafeMath for uint;
293 
294     string public name;
295     string public symbol;
296     uint public decimals;
297     bool public isDistributed;
298     uint public distributedAmount;
299 
300     event UpdatedTokenInformation(string name, string symbol);
301 
302     /**
303      * Конструктор
304      *
305      * @param _name - имя токена
306      * @param _symbol - символ токена
307      * @param _totalSupply - со сколькими токенами мы стартуем
308      * @param _decimals - кол-во знаков после запятой
309      */
310     function ImpToken(string _name, string _symbol, uint _totalSupply, uint _decimals) {
311         require(_totalSupply != 0);
312 
313         name = _name;
314         symbol = _symbol;
315         decimals = _decimals;
316 
317         totalSupply = _totalSupply;
318     }
319 
320     /**
321      * Владелец должен вызвать эту функцию, чтобы сделать начальное распределение токенов
322      */
323     function distribute(address toAddress, uint tokenAmount) external onlyOwner {
324         require(!isDistributed);
325 
326         balances[toAddress] = tokenAmount;
327 
328         distributedAmount = distributedAmount.add(tokenAmount);
329 
330         require(distributedAmount <= totalSupply);
331     }
332 
333     function closeDistribution() external onlyOwner {
334         require(!isDistributed);
335 
336         isDistributed = true;
337     }
338 
339     /**
340      * Владелец может обновить инфу по токену
341      */
342     function setTokenInformation(string newName, string newSymbol) external onlyOwner {
343         name = newName;
344         symbol = newSymbol;
345 
346         // Вызываем событие
347         UpdatedTokenInformation(name, symbol);
348     }
349 
350     /**
351      * Владелец может поменять decimals
352      */
353     function setDecimals(uint newDecimals) external onlyOwner {
354         decimals = newDecimals;
355     }
356 }
357 
358 
359 
360 
361 
362 
363 contract ImpCore is Ownable, ValidationUtil {
364     using SafeMath for uint;
365     using ECRecovery for bytes32;
366 
367     /* Токен, с которым работаем */
368     ImpToken public token;
369 
370     /* Мапа адрес получателя токенов - nonce, нужно для того, чтобы нельзя было повторно запросить withdraw */
371     mapping (address => uint) private withdrawalsNonce;
372 
373     event Withdraw(address receiver, uint tokenAmount);
374     event WithdrawCanceled(address receiver);
375 
376     function ImpCore(address _token) {
377         requireNotEmptyAddress(_token);
378 
379         token = ImpToken(_token);
380     }
381 
382     function withdraw(uint tokenAmount, bytes signedData) external {
383         uint256 nonce = withdrawalsNonce[msg.sender] + 1;
384 
385         bytes32 validatingHash = keccak256(msg.sender, tokenAmount, nonce);
386 
387         // Подписывать все транзакции должен owner
388         address addressRecovered = validatingHash.recover(signedData);
389 
390         require(addressRecovered == owner);
391 
392         // Делаем перевод получателю
393         require(token.transfer(msg.sender, tokenAmount));
394 
395         withdrawalsNonce[msg.sender] = nonce;
396 
397         Withdraw(msg.sender, tokenAmount);
398     }
399 
400     function cancelWithdraw() external {
401         withdrawalsNonce[msg.sender]++;
402 
403         WithdrawCanceled(msg.sender);
404     }
405 
406 
407 }