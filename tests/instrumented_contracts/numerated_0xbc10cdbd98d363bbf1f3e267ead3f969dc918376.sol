1 /**
2  * Math operations with safety checks
3  */
4 library SafeMath {
5   function mul(uint a, uint b) internal returns (uint) {
6     uint c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function div(uint a, uint b) internal returns (uint) {
12     // assert(b > 0); // Solidity automatically throws when dividing by 0
13     uint c = a / b;
14     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15     return c;
16   }
17 
18   function sub(uint a, uint b) internal returns (uint) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint a, uint b) internal returns (uint) {
24     uint c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 
29   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
30     return a >= b ? a : b;
31   }
32 
33   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
34     return a < b ? a : b;
35   }
36 
37   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
38     return a >= b ? a : b;
39   }
40 
41   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
42     return a < b ? a : b;
43   }
44 
45   function assert(bool assertion) internal {
46     if (!assertion) {
47       throw;
48     }
49   }
50 }
51 
52 
53 contract ERC223Interface {
54     uint public totalSupply;
55     function balanceOf(address who) constant returns (uint);
56     function transfer(address to, uint value);
57     function transfer(address to, uint value, bytes data);
58     event Transfer(address indexed from, address indexed to, uint value, bytes data);
59 }
60 
61 
62  /**
63  * @title Contract that will work with ERC223 tokens.
64  */
65  
66 contract ERC223ReceivingContract { 
67 /**
68  * @dev Standard ERC223 function that will handle incoming token transfers.
69  *
70  * @param _from  Token sender address.
71  * @param _value Amount of tokens.
72  * @param _data  Transaction metadata.
73  */
74     function tokenFallback(address _from, uint _value, bytes _data);
75 }
76 /**
77  * @title Ownable
78  * @dev The Ownable contract has an owner address, and provides basic authorization control
79  * functions, this simplifies the implementation of "user permissions".
80  */
81 contract Ownable {
82   address public owner;
83 
84 
85   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
86 
87 
88   /**
89    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
90    * account.
91    */
92   function Ownable() public {
93     owner = msg.sender;
94   }
95 
96   /**
97    * @dev Throws if called by any account other than the owner.
98    */
99   modifier onlyOwner() {
100     require(msg.sender == owner);
101     _;
102   }
103 
104   /**
105    * @dev Allows the current owner to transfer control of the contract to a newOwner.
106    * @param newOwner The address to transfer ownership to.
107    */
108   function transferOwnership(address newOwner) public onlyOwner {
109     require(newOwner != address(0));
110     OwnershipTransferred(owner, newOwner);
111     owner = newOwner;
112   }
113 
114 }
115 
116 
117 
118 
119 contract ERC223Token is ERC223Interface {
120     using SafeMath for uint;
121 
122     mapping(address => uint) balances; // List of user balances.
123     
124     /**
125      * @dev Transfer the specified amount of tokens to the specified address.
126      *      Invokes the `tokenFallback` function if the recipient is a contract.
127      *      The token transfer fails if the recipient is a contract
128      *      but does not implement the `tokenFallback` function
129      *      or the fallback function to receive funds.
130      *
131      * @param _to    Receiver address.
132      * @param _value Amount of tokens that will be transferred.
133      * @param _data  Transaction metadata.
134      */
135     function transfer(address _to, uint _value, bytes _data) {
136         // Standard function transfer similar to ERC20 transfer with no _data .
137         // Added due to backwards compatibility reasons .
138         uint codeLength;
139 
140         assembly {
141             // Retrieve the size of the code on target address, this needs assembly .
142             codeLength := extcodesize(_to)
143         }
144 
145         balances[msg.sender] = balances[msg.sender].sub(_value);
146         balances[_to] = balances[_to].add(_value);
147         if(codeLength>0) {
148             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
149             receiver.tokenFallback(msg.sender, _value, _data);
150         }
151         Transfer(msg.sender, _to, _value, _data);
152     }
153     
154     /**
155      * @dev Transfer the specified amount of tokens to the specified address.
156      *      This function works the same with the previous one
157      *      but doesn't contain `_data` param.
158      *      Added due to backwards compatibility reasons.
159      *
160      * @param _to    Receiver address.
161      * @param _value Amount of tokens that will be transferred.
162      */
163     function transfer(address _to, uint _value) {
164         uint codeLength;
165         bytes memory empty;
166 
167         assembly {
168             // Retrieve the size of the code on target address, this needs assembly .
169             codeLength := extcodesize(_to)
170         }
171 
172         balances[msg.sender] = balances[msg.sender].sub(_value);
173         balances[_to] = balances[_to].add(_value);
174         if(codeLength>0) {
175             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
176             receiver.tokenFallback(msg.sender, _value, empty);
177         }
178         Transfer(msg.sender, _to, _value, empty);
179     }
180 
181     
182     /**
183      * @dev Returns balance of the `_owner`.
184      *
185      * @param _owner   The address whose balance will be returned.
186      * @return balance Balance of the `_owner`.
187      */
188     function balanceOf(address _owner) constant returns (uint balance) {
189         return balances[_owner];
190     }
191 }
192 
193 
194 contract PajCoin223 is ERC223Token {
195 
196     string public constant name = "PajCoin";
197     bytes32 public constant symbol = "PJC";
198     uint8 public constant decimals = 18;
199 
200     function PajCoin223() public {
201         bytes memory empty;
202         totalSupply = 150000000e18;
203         balances[msg.sender] = totalSupply;
204         Transfer(0x0, msg.sender, totalSupply, empty);
205     }
206 }
207 
208 
209 
210 contract Exchanger is ERC223ReceivingContract, Ownable {
211 
212     uint public rate = 30*1000000000;
213     uint public fee = 100000*3e9;
214 
215     PajCoin223 public token = PajCoin223(0x1a85180ce3012e7715b913dd585afdf1a10f3025);
216 
217     // event DataEvent(string comment);
218     event DataEvent(uint value, string comment);
219     // event DataEvent(bytes32 value, string comment);
220     // event DataEvent(bool value, string comment);
221     // event DataEvent(address addr, string comment);
222 
223     // структ с юзером и суммой, которую он переслал
224     struct Deal {
225         address user;
226         uint money;
227     }
228     // очередь "забронированных" переводов на покупку токенов
229     mapping(uint => Deal) ethSended;
230     mapping(uint => Deal) coinSended;
231 
232     // Счетчик людей, "забронировавших" токены.
233     // "Бронирование" значит, что человек прислал деньги на покупку, но курс еще
234     // не установлен. Соответственно, перевод средств добавляется в очередь и при
235     // следующем обновлении курса будет обработан
236     uint ethSendedNumber = 0;
237     uint coinSendedNumber = 0;
238 
239     modifier allDealsArePaid {
240         require(ethSendedNumber == 0);
241         require(coinSendedNumber == 0);
242         _;
243     }
244 
245     event LogPriceUpdated(uint price);
246 
247     function Exchanger() public payable {
248         updater = msg.sender;
249     }
250 
251     function needUpdate() public view returns (bool) {
252         return ethSendedNumber + coinSendedNumber > 0;
253     }
254 
255 
256 
257     /**
258      * @dev We use a single lock for the whole contract.
259      */
260     bool private reentrancy_lock = false;
261 
262     /**
263      * @dev Prevents a contract from calling itself, directly or indirectly.
264      * @notice If you mark a function `nonReentrant`, you should also
265      * mark it `external`. Calling one nonReentrant function from
266      * another is not supported. Instead, you can implement a
267      * `private` function doing the actual work, and a `external`
268      * wrapper marked as `nonReentrant`.
269      */
270     modifier nonReentrant() {
271         require(!reentrancy_lock);
272         reentrancy_lock = true;
273         _;
274         reentrancy_lock = false;
275     }
276 
277     /**
278      * @dev An account that commands to change a rate
279      */
280     address updater;
281 
282     modifier onlyUpdater() {
283         require(msg.sender == updater);
284         _;
285     }
286 
287     function setUpdater(address _updater) public onlyOwner() {
288         updater = _updater;
289     }
290 
291     function setFee(uint _fee) public onlyOwner() {
292         fee = _fee;
293     }
294 
295     function setToken(address addr) public onlyOwner {
296         token = PajCoin223(addr);
297     }
298 
299     function getEth(uint amount) public onlyOwner allDealsArePaid {
300         owner.transfer(amount);
301     }
302 
303     function getTokens(uint amount) public onlyOwner allDealsArePaid {
304         token.transfer(owner, amount);
305     }
306 
307     function() public payable {
308         if (msg.sender != owner) {
309             require(fee <= msg.value);
310             DataEvent(msg.value, "Someone sent ether: amount");
311             ethSended[ethSendedNumber++] = Deal({user: msg.sender, money: msg.value});
312         }
313     }
314 
315     function tokenFallback(address _from, uint _value, bytes _data) {
316         // DataEvent(msg.sender, "from");
317 
318         require(msg.sender == address(token));
319         if (_from != owner) {
320             require(fee <= _value * 1e9 / rate);
321             DataEvent(_value, "Someone sent coin: amount");
322             coinSended[coinSendedNumber++] = Deal({user: _from, money: _value});
323         }
324     }
325 
326     function updateRate(uint _rate) public onlyUpdater nonReentrant{
327 
328         rate = _rate;
329         LogPriceUpdated(rate);
330 
331         uint personalFee = fee / (ethSendedNumber + coinSendedNumber);
332         DataEvent(personalFee, "Personal fee");
333 
334         proceedEtherDeals(personalFee);
335         proceedTokenDeals(personalFee);
336 
337     }
338 
339     function proceedEtherDeals(uint personalFee) internal {
340         for (uint8 i = 0; i < ethSendedNumber; i++) {
341             address user = ethSended[i].user;
342             DataEvent(ethSended[i].money, "Someone sent ether: amount");
343             DataEvent(personalFee, "Fee: amount");
344             uint money = ethSended[i].money - personalFee;
345 
346             DataEvent(money, "Discounted amount: amount");
347             uint value = money * rate / 1e9;
348             DataEvent(value, "Ether to tokens: amount");
349             if (money < 0) {
350                 // Скинуто эфира меньше, чем комиссия
351             } else if (token.balanceOf(this) < value) {
352                 DataEvent(token.balanceOf(this), "Not enough tokens: owner balance");
353                 // Вернуть деньги, если токенов не осталось
354                 user.transfer(money);
355             } else {
356                 token.transfer(user, value);
357                 DataEvent(value, "Tokens were sent to customer: amount");
358             }
359         }
360         ethSendedNumber = 0;
361     }
362 
363     function proceedTokenDeals(uint personalFee) internal {
364         for (uint8 j = 0; j < coinSendedNumber; j++) {
365             address user = coinSended[j].user;
366             uint coin = coinSended[j].money;
367 
368             DataEvent(coin, "Someone sent tokens: amount");
369             DataEvent(coin * 1e9 / rate, "Tokens to ether: amount");
370             uint value = coin * 1e9 / rate - personalFee;
371             DataEvent(personalFee, "Fee: amount");
372             DataEvent(value, "Tokens to discounted ether: amount");
373 
374             if (value < 0) {
375                 // Скинуто токенов меньше, чем комиссия
376             } else if (this.balance < value) {
377                 // Вернуть токены, если денег не осталось
378                 DataEvent(this.balance, "Not enough ether: contract balance");
379 
380                 token.transfer(user, coin);
381             } else {
382                 user.transfer(value);
383                 DataEvent(value, "Ether was sent to customer: amount");
384             }
385         }
386         coinSendedNumber = 0;
387     }
388 }