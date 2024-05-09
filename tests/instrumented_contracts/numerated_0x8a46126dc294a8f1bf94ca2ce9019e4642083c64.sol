1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal constant returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract Token {
28   uint256 public totalSupply;
29   function balanceOf(address who) public constant returns (uint256);
30   function transfer(address to, uint256 value) public returns (bool);
31   function allowance(address owner, address spender) public constant returns (uint256);
32   function transferFrom(address from, address to, uint256 value) public returns (bool);
33   function approve(address spender, uint256 value) public returns (bool);
34   event Transfer(address indexed from, address indexed to, uint256 value);
35   event Approval(address indexed owner, address indexed spender, uint256 value);
36 }
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44   address public owner;
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   function Ownable() public {
51     owner = msg.sender;
52   }
53 
54   /**
55    * @dev Throws if called by any account other than the owner.
56    */
57   modifier onlyOwner() {
58     require(msg.sender == owner);
59     _;
60   }
61 
62   /**
63    * @dev Allows the current owner to transfer control of the contract to a newOwner.
64    * @param newOwner The address to transfer ownership to.
65    */
66   function transferOwnership(address newOwner) onlyOwner public {
67     require(newOwner != address(0));      
68     owner = newOwner;
69   }
70 }
71 
72 contract Pausable is Ownable {
73     
74   uint public constant startPreICO = 1521072000; // 15'th March
75   uint public constant endPreICO = startPreICO + 31 days;
76 
77   uint public constant startICOStage1 = 1526342400; // 15'th May
78   uint public constant endICOStage1 = startICOStage1 + 3 days;
79 
80   uint public constant startICOStage2 = 1526688000; // 19'th May
81   uint public constant endICOStage2 = startICOStage2 + 5 days;
82 
83   uint public constant startICOStage3 = 1527206400; // 25'th May
84   uint public constant endICOStage3 = endICOStage2 + 6 days;
85 
86   uint public constant startICOStage4 = 1527811200; // 1'st June
87   uint public constant endICOStage4 = startICOStage4 + 7 days;
88 
89   uint public constant startICOStage5 = 1528502400;
90   uint public endICOStage5 = startICOStage5 + 11 days;
91 
92   /**
93    * @dev modifier to allow actions only when the contract IS not paused
94    */
95   modifier whenNotPaused() {
96     require(now < startPreICO || now > endICOStage5);
97     _;
98   }
99 
100 }
101 
102 contract StandardToken is Token, Pausable {
103   using SafeMath for uint256;
104   mapping (address => mapping (address => uint256)) internal allowed;
105 
106   mapping(address => uint256) balances;
107 
108   /**
109   * @dev transfer token for a specified address
110   * @param _to The address to transfer to.
111   * @param _value The amount to be transferred.
112   */
113   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
114     require(_to != address(0));
115     balances[msg.sender] = balances[msg.sender].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     Transfer(msg.sender, _to, _value);
118     return true;
119   }
120 
121   /**
122   * @dev Gets the balance of the specified address.
123   * @param _owner The address to query the the balance of.
124   * @return An uint256 representing the amount owned by the passed address.
125   */
126   function balanceOf(address _owner) public constant returns (uint256 balance) {
127     return balances[_owner];
128   }
129 
130   /**
131    * @dev Transfer tokens from one address to another
132    * @param _from address The address which you want to send tokens from
133    * @param _to address The address which you want to transfer to
134    * @param _value uint256 the amount of tokens to be transferred
135    */
136   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
137     require(_to != address(0));
138     require(_value <= allowed[_from][msg.sender]);
139 
140     balances[_from] = balances[_from].sub(_value);
141     balances[_to] = balances[_to].add(_value);
142     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
143     Transfer(_from, _to, _value);
144     return true;
145   }
146 
147   /**
148    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
149    *
150    * Beware that changing an allowance with this method brings the risk that someone may use both the old
151    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
152    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
153    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154    * @param _spender The address which will spend the funds.
155    * @param _value The amount of tokens to be spent.
156    */
157   function approve(address _spender, uint256 _value) public returns (bool) {
158     allowed[msg.sender][_spender] = _value;
159     Approval(msg.sender, _spender, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Function to check the amount of tokens that an owner allowed to a spender.
165    * @param _owner address The address which owns the funds.
166    * @param _spender address The address which will spend the funds.
167    * @return A uint256 specifying the amount of tokens still available for the spender.
168    */
169   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
170     return allowed[_owner][_spender];
171   }
172 
173   /**
174    * approve should be called when allowed[_spender] == 0. To increment
175    * allowed value is better to use this function to avoid 2 calls (and wait until
176    * the first transaction is mined)
177    * From MonolithDAO Token.sol
178    */
179   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
180     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
181     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182     return true;
183   }
184 
185   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
186     uint oldValue = allowed[msg.sender][_spender];
187     if (_subtractedValue > oldValue) {
188       allowed[msg.sender][_spender] = 0;
189     } else {
190       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
191     }
192     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
193     return true;
194   }
195 }
196 
197 /**
198  * @title Burnable Token
199  * @dev Token that can be irreversibly burned (destroyed).
200  */
201 contract BurnableToken is StandardToken {
202 
203   event Burn(address indexed burner, uint256 value);
204 
205   /**
206     * @dev Burns a specific amount of tokens.
207     * @param _value The amount of token to be burned.
208     */
209   function burn(uint256 _value) public {
210       require(_value > 0);
211       require(_value <= balances[msg.sender]);
212 
213       address burner = msg.sender;
214       balances[burner] = balances[burner].sub(_value);
215       totalSupply = totalSupply.sub(_value);
216       Burn(burner, _value);
217   }
218 }
219 
220 contract MBEToken is BurnableToken {
221   string public constant name = "MoBee";
222   string public constant symbol = "MBE";
223   uint8 public constant decimals = 18;
224   address public tokenWallet;
225   address public founderWallet;
226   address public bountyWallet;
227   address public multisig=0xa74246dc71c0849accd564976b3093b0b2a522c3;
228   uint public currentFundrise = 0;
229   uint public raisedEthers = 0;
230 
231   uint public constant INITIAL_SUPPLY = 20000000 ether;
232   
233   uint256 constant THOUSAND = 1000;
234   uint256 constant TEN_THOUSAND = 10000;
235   uint public tokenRate = THOUSAND.div(9); // tokens per 1 ether ( 1 ETH / 0.009 ETH = 111.11 MBE )
236   uint public tokenRate30 = tokenRate.mul(100).div(70); // tokens per 1 ether with 30% discount
237   uint public tokenRate20 = tokenRate.mul(100).div(80); // tokens per 1 ether with 20% discount
238   uint public tokenRate15 = tokenRate.mul(100).div(85); // tokens per 1 ether with 15% discount
239   uint public tokenRate10 = tokenRate.mul(100).div(90); // tokens per 1 ether with 10% discount
240   uint public tokenRate5 = tokenRate.mul(100).div(95); // tokens per 1 ether with 5% discount
241 
242   /**
243     * @dev Constructor that gives msg.sender all of existing tokens.
244     */
245   function MBEToken(address tokenOwner, address founder, address bounty) public {
246     totalSupply = INITIAL_SUPPLY;
247     balances[tokenOwner] += INITIAL_SUPPLY / 100 * 85;
248     balances[founder] += INITIAL_SUPPLY / 100 * 10;
249     balances[bounty] += INITIAL_SUPPLY / 100 * 5;
250     tokenWallet = tokenOwner;
251     founderWallet = founder;
252     bountyWallet = bounty;
253     Transfer(0x0, tokenOwner, balances[tokenOwner]);
254     Transfer(0x0, founder, balances[founder]);
255     Transfer(0x0, bounty, balances[bounty]);
256   }
257   
258   function setupTokenRate(uint newTokenRate) public onlyOwner {
259     tokenRate = newTokenRate;
260     tokenRate30 = tokenRate.mul(100).div(70); // tokens per 1 ether with 30% discount
261     tokenRate20 = tokenRate.mul(100).div(80); // tokens per 1 ether with 20% discount
262     tokenRate15 = tokenRate.mul(100).div(85); // tokens per 1 ether with 15% discount
263     tokenRate10 = tokenRate.mul(100).div(90); // tokens per 1 ether with 10% discount
264     tokenRate5 = tokenRate.mul(100).div(95); // tokens per 1 ether with 5% discount
265   }
266   
267   function setupFinal(uint finalDate) public onlyOwner returns(bool) {
268     endICOStage5 = finalDate;
269     return true;
270   }
271 
272   function sellManually(address _to, uint amount) public onlyOwner returns(bool) {
273     uint tokens = calcTokens(amount);
274     uint256 balance = balanceOf(owner);
275     if (balance < tokens) {
276       sendTokens(_to, balance);
277     } else {
278       sendTokens(_to, tokens);
279     }
280     return true;
281   }
282 
283   function () payable public {
284     if (!isTokenSale()) revert();
285     buyTokens(msg.value);
286   }
287   
288   function isTokenSale() public view returns (bool) {
289     if (now >= startPreICO && now < endICOStage5) {
290       return true;
291     } else {
292       return false;
293     }
294   }
295 
296   function buyTokens(uint amount) internal {
297     uint tokens = calcTokens(amount);  
298     safeSend(tokens);
299   }
300   
301   function calcTokens(uint amount) public view returns(uint) {
302     uint rate = extraRate(amount, tokenRate);
303     uint tokens = amount.mul(rate);
304     if (now >= startPreICO && now < endPreICO) {
305       rate = extraRate(amount, tokenRate30);
306       tokens = amount.mul(rate);
307       return tokens;
308     } else if (now >= startICOStage1 && now < endICOStage1) {
309       rate = extraRate(amount, tokenRate20);
310       tokens = amount.mul(rate);
311       return tokens;
312     } else if (now >= startICOStage2 && now < endICOStage2) {
313       rate = extraRate(amount, tokenRate15);
314       tokens = amount.mul(rate);
315       return tokens;
316     } else if (now >= startICOStage3 && now < endICOStage3) {
317       rate = extraRate(amount, tokenRate10);
318       tokens = amount.mul(rate);
319       return tokens;
320     } else if (now >= startICOStage4 && now < endICOStage4) {
321       rate = extraRate(amount, tokenRate5);
322       tokens = amount.mul(rate);
323       return tokens;
324     } else if (now >= startICOStage5 && now < endICOStage5) {
325       return tokens;
326     }
327   }
328 
329   function extraRate(uint amount, uint rate) public pure returns (uint) {
330     return ( ( rate * 10 ** 20 ) / ( 100 - extraDiscount(amount) ) ) / ( 10 ** 18 );
331   }
332 
333   function extraDiscount(uint amount) public pure returns(uint) {
334     if ( 3 ether <= amount && amount <= 5 ether ) {
335       return 5;
336     } else if ( 5 ether < amount && amount <= 10 ether ) {
337       return 7;
338     } else if ( 10 ether < amount && amount <= 20 ether ) {
339       return 10;
340     } else if ( 20 ether < amount ) {
341       return 15;
342     }
343     return 0;
344   }
345 
346   function safeSend(uint tokens) private {
347     uint256 balance = balanceOf(owner);
348     if (balance < tokens) {
349       uint toReturn = tokenRate.mul(tokens.sub(balance));
350       sendTokens(msg.sender, balance);
351       msg.sender.transfer(toReturn);
352       multisig.transfer(msg.value.sub(toReturn));
353       raisedEthers += msg.value.sub(toReturn);
354     } else {
355       sendTokens(msg.sender, tokens);
356       multisig.transfer(msg.value);
357       raisedEthers += msg.value;
358     }
359   }
360 
361   function sendTokens(address _to, uint tokens) private {
362     balances[owner] = balances[owner].sub(tokens);
363     balances[_to] += tokens;
364     Transfer(owner, _to, tokens);
365     currentFundrise += tokens;
366   }
367 }