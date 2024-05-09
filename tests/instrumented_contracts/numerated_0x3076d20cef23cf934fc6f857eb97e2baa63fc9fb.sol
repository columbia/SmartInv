1 pragma solidity ^0.4.18;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   string public name;
6   string public symbol;
7   uint8 public decimals;
8   function balanceOf(address who) constant public returns (uint256);
9   function transfer(address to, uint256 value) public returns (bool);
10   event Transfer(address indexed from, address indexed to, uint256 value);
11 }
12 
13 contract ExternalToken {
14     function burn(uint256 _value, bytes _data) public;
15 }
16 
17 library SafeMath {
18     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19         uint256 c = a * b;
20         assert(a == 0 || c / a == b);
21         return c;
22     }
23 
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return c;
29     }
30 
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         assert(b <= a);
33         return a - b;
34     }
35 
36     function add(uint256 a, uint256 b) internal pure returns (uint256) {
37         uint256 c = a + b;
38         assert(c >= a);
39         return c;
40     }
41 }
42 
43 contract BasicToken is ERC20Basic {
44   using SafeMath for uint256;
45 
46   mapping(address => uint256) balances;
47 
48   /**
49   * @dev transfer token for a specified address
50   * @param _to The address to transfer to.
51   * @param _value The amount to be transferred.
52   */
53   function transfer(address _to, uint256 _value) public returns (bool) {
54     require(_to != address(0));
55 
56     // SafeMath.sub will throw if there is not enough balance.
57     balances[msg.sender] = balances[msg.sender].sub(_value);
58     balances[_to] = balances[_to].add(_value);
59     Transfer(msg.sender, _to, _value);
60     return true;
61   }
62 
63   /**
64   * @dev Gets the balance of the specified address.
65   * @param _owner The address to query the the balance of. 
66   * @return An uint256 representing the amount owned by the passed address.
67   */
68   function balanceOf(address _owner) constant public returns (uint256 balance) {
69     return balances[_owner];
70   }
71 
72 }
73 
74 contract TokenReceiver {
75     function onTokenTransfer(address _from, uint256 _value, bytes _data) public;
76 }
77 
78 contract Ownable {
79   address public owner;
80 
81 
82   /**
83    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
84    * account.
85    */
86   function Ownable() public {
87     owner = msg.sender;
88   }
89 
90 
91   /**
92    * @dev Throws if called by any account other than the owner.
93    */
94   modifier onlyOwner() {
95     require(msg.sender == owner);
96     _;
97   }
98 
99 
100   /**
101    * @dev Allows the current owner to transfer control of the contract to a newOwner.
102    * @param newOwner The address to transfer ownership to.
103    */
104   function transferOwnership(address newOwner) onlyOwner public {
105     require(newOwner != address(0));      
106     owner = newOwner;
107   }
108 
109 }
110 
111 contract Pausable is Ownable {
112   event Pause();
113   event Unpause();
114 
115   bool public paused = false;
116 
117 
118   /**
119    * @dev Modifier to make a function callable only when the contract is not paused.
120    */
121   modifier whenNotPaused() {
122     require(!paused);
123     _;
124   }
125 
126   /**
127    * @dev Modifier to make a function callable only when the contract is paused.
128    */
129   modifier whenPaused() {
130     require(paused);
131     _;
132   }
133 
134   /**
135    * @dev called by the owner to pause, triggers stopped state
136    */
137   function pause() onlyOwner whenNotPaused public {
138     paused = true;
139     Pause();
140   }
141 
142   /**
143    * @dev called by the owner to unpause, returns to normal state
144    */
145   function unpause() onlyOwner whenPaused public {
146     paused = false;
147     Unpause();
148   }
149 }
150 
151 contract AbstractSale is TokenReceiver, Pausable {
152     using SafeMath for uint256;
153 
154     event BonusChange(uint256 bonus);
155     event RateChange(address token, uint256 rate);
156     event Purchase(address indexed buyer, address token, uint256 value, uint256 amount);
157     event Withdraw(address token, address to, uint256 value);
158     event Burn(address token, uint256 value, bytes data);
159 
160     mapping (address => uint256) rates;
161     uint256 public bonus;
162 
163     function onTokenTransfer(address _from, uint256 _value, bytes _data) whenNotPaused public {
164         onReceive(msg.sender, _from, _value, _data);
165     }
166 
167     function() payable whenNotPaused public {
168         receiveWithData("");
169     }
170 
171     function receiveWithData(bytes _data) payable whenNotPaused public {
172         onReceive(address(0), msg.sender, msg.value, _data);
173     }
174 
175     function onReceive(address _token, address _from, uint256 _value, bytes _data) internal {
176         uint256 tokens = getAmount(_token, _value);
177         require(tokens > 0);
178         address buyer;
179         if (_data.length == 20) {
180             buyer = address(toBytes20(_data, 0));
181         } else {
182             require(_data.length == 0);
183             buyer = _from;
184         }
185         Purchase(buyer, _token, _value, tokens);
186         doPurchase(buyer, tokens);
187     }
188 
189     function doPurchase(address buyer, uint256 amount) internal;
190 
191     function toBytes20(bytes b, uint256 _start) pure internal returns (bytes20 result) {
192         require(_start + 20 <= b.length);
193         assembly {
194             let from := add(_start, add(b, 0x20))
195             result := mload(from)
196         }
197     }
198 
199     function getAmount(address _token, uint256 _value) constant public returns (uint256) {
200         uint256 rate = getRate(_token);
201         require(rate > 0);
202         uint256 beforeBonus = _value.mul(rate);
203         return beforeBonus.add(beforeBonus.mul(bonus).div(100)).div(10**18);
204     }
205 
206     function getRate(address _token) constant public returns (uint256) {
207         return rates[_token];
208     }
209 
210     function setRate(address _token, uint256 _rate) onlyOwner public {
211         rates[_token] = _rate;
212         RateChange(_token, _rate);
213     }
214 
215     function setBonus(uint256 _bonus) onlyOwner public {
216         bonus = _bonus;
217         BonusChange(_bonus);
218     }
219 
220     function withdraw(address _token, address _to, uint256 _amount) onlyOwner public {
221         require(_to != address(0));
222         verifyCanWithdraw(_token, _to, _amount);
223         if (_token == address(0)) {
224             _to.transfer(_amount);
225         } else {
226             ERC20(_token).transfer(_to, _amount);
227         }
228         Withdraw(_token, _to, _amount);
229     }
230 
231     function burnWithData(address _token, uint256 _amount, bytes _data) onlyOwner public {
232         ExternalToken(_token).burn(_amount, _data);
233         Burn(_token, _amount, _data);
234     }
235 
236     function verifyCanWithdraw(address _token, address _to, uint256 _amount) internal {
237 
238     }
239 }
240 
241 contract Sale is AbstractSale {
242     ERC20 public token;
243 
244     function Sale(address _token) public {
245         token = ERC20(_token);
246     }
247 
248     function doPurchase(address buyer, uint256 amount) internal {
249         token.transfer(buyer, amount);
250     }
251 
252     /**
253      * @dev It should not let owners transfer tokens to protect investors
254      */
255     function verifyCanWithdraw(address _token, address _to, uint256 _amount) internal {
256         require(_token != address(token));
257     }
258 }
259 
260 contract GoldeaSale is Sale {
261     address public btcToken;
262     uint256 public constant end = 1522540800;
263     uint256 public constant total = 200000000000000;
264 
265     function GoldeaSale(address _token, address _btcToken) Sale(_token) public {
266         btcToken = _btcToken;
267     }
268 
269     function changeParameters(uint256 _ethRate, uint256 _btcRate, uint256 _bonus) onlyOwner public {
270         setRate(address(0), _ethRate);
271         setRate(btcToken, _btcRate);
272         setBonus(_bonus);
273     }
274 
275     function setBtcToken(address _btcToken) onlyOwner public {
276         btcToken = _btcToken;
277     }
278 
279     function doPurchase(address buyer, uint256 amount) internal {
280         require(now < end);
281         super.doPurchase(buyer, amount);
282     }
283 
284     function burn() onlyOwner public {
285         require(now >= end);
286         BurnableToken(token).burn(token.balanceOf(this));
287     }
288 }
289 
290 contract ERC20 is ERC20Basic {
291   function allowance(address owner, address spender) constant public returns (uint256);
292   function transferFrom(address from, address to, uint256 value) public returns (bool);
293   function approve(address spender, uint256 value) public returns (bool);
294   event Approval(address indexed owner, address indexed spender, uint256 value);
295 }
296 
297 contract StandardToken is ERC20, BasicToken {
298 
299   mapping (address => mapping (address => uint256)) allowed;
300 
301 
302   /**
303    * @dev Transfer tokens from one address to another
304    * @param _from address The address which you want to send tokens from
305    * @param _to address The address which you want to transfer to
306    * @param _value uint256 the amount of tokens to be transferred
307    */
308   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
309     require(_to != address(0));
310 
311     var _allowance = allowed[_from][msg.sender];
312 
313     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
314     // require (_value <= _allowance);
315 
316     balances[_from] = balances[_from].sub(_value);
317     balances[_to] = balances[_to].add(_value);
318     allowed[_from][msg.sender] = _allowance.sub(_value);
319     Transfer(_from, _to, _value);
320     return true;
321   }
322 
323   /**
324    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
325    * @param _spender The address which will spend the funds.
326    * @param _value The amount of tokens to be spent.
327    */
328   function approve(address _spender, uint256 _value) public returns (bool) {
329 
330     // To change the approve amount you first have to reduce the addresses`
331     //  allowance to zero by calling `approve(_spender, 0)` if it is not
332     //  already 0 to mitigate the race condition described here:
333     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
334     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
335 
336     allowed[msg.sender][_spender] = _value;
337     Approval(msg.sender, _spender, _value);
338     return true;
339   }
340 
341   /**
342    * @dev Function to check the amount of tokens that an owner allowed to a spender.
343    * @param _owner address The address which owns the funds.
344    * @param _spender address The address which will spend the funds.
345    * @return A uint256 specifying the amount of tokens still available for the spender.
346    */
347   function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
348     return allowed[_owner][_spender];
349   }
350   
351   /**
352    * approve should be called when allowed[_spender] == 0. To increment
353    * allowed value is better to use this function to avoid 2 calls (and wait until 
354    * the first transaction is mined)
355    * From MonolithDAO Token.sol
356    */
357   function increaseApproval (address _spender, uint _addedValue) public
358     returns (bool success) {
359     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
360     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
361     return true;
362   }
363 
364   function decreaseApproval (address _spender, uint _subtractedValue) public
365     returns (bool success) {
366     uint oldValue = allowed[msg.sender][_spender];
367     if (_subtractedValue > oldValue) {
368       allowed[msg.sender][_spender] = 0;
369     } else {
370       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
371     }
372     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
373     return true;
374   }
375 
376 }
377 
378 contract BurnableToken is StandardToken {
379 
380     /**
381      * @dev Burns a specific amount of tokens.
382      * @param _value The amount of token to be burned.
383      */
384     function burn(uint _value)
385         public
386     {
387         require(_value > 0);
388 
389         address burner = msg.sender;
390         balances[burner] = balances[burner].sub(_value);
391         totalSupply = totalSupply.sub(_value);
392         Burn(burner, _value);
393     }
394 
395     event Burn(address indexed burner, uint indexed value);
396 }