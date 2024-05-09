1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract Ownable {
33   address public owner;
34 
35 
36   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38 
39   /**
40    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41    * account.
42    */
43   function Ownable() public {
44     owner = msg.sender;
45   }
46 
47 
48   /**
49    * @dev Throws if called by any account other than the owner.
50    */
51   modifier onlyOwner() {
52     require(msg.sender == owner);
53     _;
54   }
55 
56 
57   /**
58    * @dev Allows the current owner to transfer control of the contract to a newOwner.
59    * @param newOwner The address to transfer ownership to.
60    */
61   function transferOwnership(address newOwner) public onlyOwner {
62     require(newOwner != address(0));
63     OwnershipTransferred(owner, newOwner);
64     owner = newOwner;
65   }
66 
67 }
68 
69 contract Contactable is Ownable{
70 
71     string public contactInformation;
72 
73     /**
74      * @dev Allows the owner to set a string with their contact information.
75      * @param info The contact information to attach to the contract.
76      */
77     function setContactInformation(string info) onlyOwner public {
78          contactInformation = info;
79      }
80 }
81 
82 contract ERC20Basic {
83   uint256 public totalSupply;
84   function balanceOf(address who) public view returns (uint256);
85   function transfer(address to, uint256 value) public returns (bool);
86   event Transfer(address indexed from, address indexed to, uint256 value);
87 }
88 
89 contract BasicToken is ERC20Basic {
90   using SafeMath for uint256;
91 
92   mapping(address => uint256) balances;
93 
94   /**
95   * @dev transfer token for a specified address
96   * @param _to The address to transfer to.
97   * @param _value The amount to be transferred.
98   */
99   function transfer(address _to, uint256 _value) public returns (bool) {
100     require(_to != address(0));
101     require(_value <= balances[msg.sender]);
102 
103     // SafeMath.sub will throw if there is not enough balance.
104     balances[msg.sender] = balances[msg.sender].sub(_value);
105     balances[_to] = balances[_to].add(_value);
106     Transfer(msg.sender, _to, _value);
107     return true;
108   }
109 
110   /**
111   * @dev Gets the balance of the specified address.
112   * @param _owner The address to query the the balance of.
113   * @return An uint256 representing the amount owned by the passed address.
114   */
115   function balanceOf(address _owner) public view returns (uint256 balance) {
116     return balances[_owner];
117   }
118 
119 }
120 
121 contract ERC20 is ERC20Basic {
122   function allowance(address owner, address spender) public view returns (uint256);
123   function transferFrom(address from, address to, uint256 value) public returns (bool);
124   function approve(address spender, uint256 value) public returns (bool);
125   event Approval(address indexed owner, address indexed spender, uint256 value);
126 }
127 
128 contract StandardToken is ERC20, BasicToken {
129 
130   mapping (address => mapping (address => uint256)) internal allowed;
131 
132 
133   /**
134    * @dev Transfer tokens from one address to another
135    * @param _from address The address which you want to send tokens from
136    * @param _to address The address which you want to transfer to
137    * @param _value uint256 the amount of tokens to be transferred
138    */
139   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
140     require(_to != address(0));
141     require(_value <= balances[_from]);
142     require(_value <= allowed[_from][msg.sender]);
143 
144     balances[_from] = balances[_from].sub(_value);
145     balances[_to] = balances[_to].add(_value);
146     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
147     Transfer(_from, _to, _value);
148     return true;
149   }
150 
151   /**
152    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
153    *
154    * Beware that changing an allowance with this method brings the risk that someone may use both the old
155    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
156    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
157    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158    * @param _spender The address which will spend the funds.
159    * @param _value The amount of tokens to be spent.
160    */
161   function approve(address _spender, uint256 _value) public returns (bool) {
162     allowed[msg.sender][_spender] = _value;
163     Approval(msg.sender, _spender, _value);
164     return true;
165   }
166 
167   /**
168    * @dev Function to check the amount of tokens that an owner allowed to a spender.
169    * @param _owner address The address which owns the funds.
170    * @param _spender address The address which will spend the funds.
171    * @return A uint256 specifying the amount of tokens still available for the spender.
172    */
173   function allowance(address _owner, address _spender) public view returns (uint256) {
174     return allowed[_owner][_spender];
175   }
176 
177   /**
178    * approve should be called when allowed[_spender] == 0. To increment
179    * allowed value is better to use this function to avoid 2 calls (and wait until
180    * the first transaction is mined)
181    * From MonolithDAO Token.sol
182    */
183   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
184     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
185     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
186     return true;
187   }
188 
189   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
190     uint oldValue = allowed[msg.sender][_spender];
191     if (_subtractedValue > oldValue) {
192       allowed[msg.sender][_spender] = 0;
193     } else {
194       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
195     }
196     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197     return true;
198   }
199 
200 }
201 
202 contract GigaToken is StandardToken, Contactable {
203 
204   string public constant name = "Giga";
205   string public constant symbol = "GIGA";
206   uint8 public constant decimals = 18;
207 
208   uint256 public constant INITIAL_SUPPLY = 10000000 * (10 ** uint256(decimals)); 
209  
210   event IncreaseSupply(uint256 increaseByAmount, uint256 oldAmount, uint256 newAmount);  
211   
212 
213   /**
214    * @dev Constructor that gives msg.sender all of existing tokens.
215    */
216   function GigaToken() public {
217    // * (10 ** uint256(decimals));  
218  
219     totalSupply = INITIAL_SUPPLY; 
220     balances[msg.sender] = INITIAL_SUPPLY; 
221   }
222 
223   function increaseSupply(uint256 _increaseByAmount) external onlyOwner {
224     require(_increaseByAmount > 0);
225     uint256 oldSupply = totalSupply;
226     totalSupply = totalSupply.add(_increaseByAmount);
227     balances[owner] = balances[owner].add(_increaseByAmount);
228     IncreaseSupply(_increaseByAmount, oldSupply, totalSupply);
229 
230   }
231 
232 }
233 
234 contract GigaCrowdsale is  Contactable {
235   using SafeMath for uint256;
236 
237   // The token being sold
238   GigaToken public token;
239 
240   // start and end timestamps where investments are allowed (both inclusive)
241   uint256 public startTime;
242   uint256 public endTime;
243 
244   // address where funds are collected
245   address public wallet;
246 
247   // how many token units a buyer gets per wei
248   uint256 public rate;
249 
250   // amount of raised money in wei
251   uint256 public weiRaised;
252   uint256 public tokensPurchased;
253 
254 
255   /**
256    * event for token purchase logging
257    * @param purchaser who paid for the tokens
258    * @param beneficiary who got the tokens
259    * @param value weis paid for purchase
260    * @param amount amount of tokens purchased
261    */
262   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
263   //event DebugOut(string msg);
264   
265   event SetRate(uint256 oldRate, uint256 newRate);
266   event SetEndTime(uint256 oldEndTime, uint256 newEndTime);
267 
268   function GigaCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet,string _contactInformation) public {
269     require(_startTime >= now);
270     require(_endTime >= _startTime);
271     require(_rate > 0);
272     require(_wallet != 0x0);
273     
274     contactInformation = _contactInformation;
275     token = createTokenContract();
276     token.setContactInformation(_contactInformation);
277     startTime = _startTime;
278     endTime = _endTime;
279     rate = _rate;
280     wallet = _wallet;
281     
282    
283   }
284 
285   // creates the token to be sold.
286   function createTokenContract() internal returns (GigaToken) {
287     return new GigaToken();
288   }
289 
290 
291   // fallback function can be used to buy tokens
292   function () public payable {
293     buyTokens(msg.sender);
294   }
295 
296   // low level token purchase function
297   function buyTokens(address beneficiary) public payable {
298     require(beneficiary != 0x0);
299     require(validPurchase());
300 
301     uint256 weiAmount = msg.value;
302 
303     // calculate token amount to be created
304     uint256 tokens = weiAmount.mul(rate);
305     
306     // update state
307     weiRaised = weiRaised.add(weiAmount);
308     tokensPurchased = tokensPurchased.add(tokens);
309 
310     token.transfer(beneficiary, tokens);
311     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
312 
313     forwardFunds();
314   }
315 
316   function transferTokens (address _beneficiary, uint256 _tokens) onlyOwner external {
317       token.transfer(_beneficiary, _tokens);
318   }
319 
320   function transferTokenContractOwnership(address _newOwner) onlyOwner external {
321      token.transferOwnership(_newOwner);
322   }
323 
324   // send ether to the fund collection wallet
325   // override to create custom fund forwarding mechanisms
326   function forwardFunds() internal {
327     wallet.transfer(msg.value);
328   }
329 
330   // @return true if the transaction can buy tokens
331   function validPurchase() internal constant returns (bool) {
332     bool withinPeriod = now >= startTime && now <= endTime;
333     bool nonZeroPurchase = msg.value != 0;
334     return withinPeriod && nonZeroPurchase;
335   }
336 
337   // @return true if crowdsale event has ended
338   function hasEnded() public constant returns (bool) {
339     return now > endTime;
340   }
341 
342   function  setEndTime(uint256 _endTime) external onlyOwner {
343     require(_endTime >= startTime);
344     SetEndTime(endTime, _endTime);
345     endTime = _endTime;
346 
347   }
348 
349   function setRate(uint256 _rate) external onlyOwner {
350     require(_rate > 0);
351     SetRate(rate, _rate);
352     rate = _rate;
353 
354   }
355 
356   function increaseSupply(uint256 _increaseByAmount) external onlyOwner {
357     require(_increaseByAmount > 0);
358       
359     token.increaseSupply(_increaseByAmount);
360    
361   }
362 
363   function setTokenContactInformation(string _info) external onlyOwner {
364     token.setContactInformation(_info);
365   }
366   
367 }