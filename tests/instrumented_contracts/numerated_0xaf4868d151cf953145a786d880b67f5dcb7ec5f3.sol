1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public constant returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a * b;
33     assert(a == 0 || c / a == b);
34     return c;
35   }
36 
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return c;
42   }
43 
44   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45     assert(b <= a);
46     return a - b;
47   }
48 
49   function add(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 
56 /**
57  * @title Basic token
58  * @dev Basic version of StandardToken, with no allowances.
59  */
60 contract BasicToken is ERC20Basic {
61   using SafeMath for uint256;
62 
63   mapping(address => uint256) balances;
64 
65   /**
66   * @dev transfer token for a specified address
67   * @param _to The address to transfer to.
68   * @param _value The amount to be transferred.
69   */
70   function transfer(address _to, uint256 _value) public returns (bool) {
71     require(_to != address(0));
72     require(_value <= balances[msg.sender]);
73 
74     // SafeMath.sub will throw if there is not enough balance.
75     balances[msg.sender] = balances[msg.sender].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     emit Transfer(msg.sender, _to, _value);
78     return true;
79   }
80 
81   /**
82   * @dev Gets the balance of the specified address.
83   * @param _owner The address to query the the balance of.
84   * @return An uint256 representing the amount owned by the passed address.
85   */
86   function balanceOf(address _owner) public constant returns (uint256 balance) {
87     return balances[_owner];
88   }
89 
90 }
91 
92 /**
93  * @title Standard ERC20 token
94  *
95  * @dev Implementation of the basic standard token.
96  * @dev https://github.com/ethereum/EIPs/issues/20
97  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
98  */
99 contract StandardToken is ERC20, BasicToken {
100 
101   mapping (address => mapping (address => uint256)) internal allowed;
102 
103 
104   /**
105    * @dev Transfer tokens from one address to another
106    * @param _from address The address which you want to send tokens from
107    * @param _to address The address which you want to transfer to
108    * @param _value uint256 the amount of tokens to be transferred
109    */
110   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
111     require(_to != address(0));
112     require(_value <= balances[_from]);
113     require(_value <= allowed[_from][msg.sender]);
114 
115     balances[_from] = balances[_from].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
118     emit Transfer(_from, _to, _value);
119     return true;
120   }
121 
122   /**
123    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
124    *
125    * Beware that changing an allowance with this method brings the risk that someone may use both the old
126    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
127    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
128    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
129    * @param _spender The address which will spend the funds.
130    * @param _value The amount of tokens to be spent.
131    */
132   function approve(address _spender, uint256 _value) public returns (bool) {
133     allowed[msg.sender][_spender] = _value;
134     emit Approval(msg.sender, _spender, _value);
135     return true;
136   }
137 
138   /**
139    * @dev Function to check the amount of tokens that an owner allowed to a spender.
140    * @param _owner address The address which owns the funds.
141    * @param _spender address The address which will spend the funds.
142    * @return A uint256 specifying the amount of tokens still available for the spender.
143    */
144   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
145     return allowed[_owner][_spender];
146   }
147 
148   /**
149    * approve should be called when allowed[_spender] == 0. To increment
150    * allowed value is better to use this function to avoid 2 calls (and wait until
151    * the first transaction is mined)
152    * From MonolithDAO Token.sol
153    */
154   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
155     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
156     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
157     return true;
158   }
159 
160   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
161     uint oldValue = allowed[msg.sender][_spender];
162     if (_subtractedValue > oldValue) {
163       allowed[msg.sender][_spender] = 0;
164     } else {
165       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
166     }
167     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
168     return true;
169   }
170 
171   function () public payable {
172     revert();
173   }
174 }
175 
176 /**
177  * @title Ownable
178  * @dev The Ownable contract has an owner address, and provides basic authorization control
179  * functions, this simplifies the implementation of "user permissions".
180  */
181 contract Ownable {
182   address public owner;
183 
184   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
185 
186   /**
187    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
188    * account.
189    */
190   function Ownable() public {
191     owner = msg.sender;
192   }
193 
194 
195   /**
196    * @dev Throws if called by any account other than the owner.
197    */
198   modifier onlyOwner() {
199     require(msg.sender == owner);
200     _;
201   }
202 
203 
204   /**
205    * @dev Allows the current owner to transfer control of the contract to a newOwner.
206    * @param newOwner The address to transfer ownership to.
207    */
208   function transferOwnership(address newOwner) onlyOwner public {
209     require(newOwner != address(0));
210     emit OwnershipTransferred(owner, newOwner);
211     owner = newOwner;
212   }
213 
214 }
215 
216 contract PausableToken is Ownable, StandardToken {
217   event Pause();
218   event Unpause();
219 
220   bool public paused = false;
221 
222 
223   /**
224    * @dev Modifier to make a function callable only when the contract is not paused.
225    */
226   modifier whenNotPaused() {
227     require(!paused);
228     _;
229   }
230 
231   /**
232    * @dev Modifier to make a function callable only when the contract is paused.
233    */
234   modifier whenPaused() {
235     require(paused);
236     _;
237   }
238 
239   /**
240    * @dev called by the owner to pause, triggers stopped state
241    */
242   function pause() onlyOwner whenNotPaused public {
243     paused = true;
244     emit Pause();
245   }
246 
247   /**
248    * @dev called by the owner to unpause, returns to normal state
249    */
250   function unpause() onlyOwner whenPaused public {
251     paused = false;
252     emit Unpause();
253   }
254 
255   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
256     return super.transfer(_to, _value);
257   }
258 
259   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
260     return super.transferFrom(_from, _to, _value);
261   }
262 }
263 
264 contract Configurable {
265   uint256 public constant totalSaleLimit = 70000000;
266   uint256 public constant privateSaleLimit = 27300000;
267   uint256 public constant preSaleLimit = 38500000;
268   uint256 public constant saleLimit = 4200000;
269   uint256 public creationDate = now;
270   uint256 public constant teamLimit = 8000000;
271   uint256 teamReleased;
272   address public constant teamAddress = 0x7a615d4158202318750478432743cA615d0D83aF;
273 }
274 
275 contract Staged is Ownable, Configurable {
276   using SafeMath for uint256;
277   enum Stages {PrivateSale, PreSale, Sale}
278   Stages currentStage;
279   uint256 privateSale;
280   uint256 preSale;
281   uint256 sale;
282 
283   function Staged() public {
284     currentStage = Stages.PrivateSale;
285   }
286 
287   function setPrivateSale() public onlyOwner returns (bool) {
288     currentStage = Stages.PrivateSale;
289     return true;
290   }
291 
292   function setPreSale() public onlyOwner returns (bool) {
293     currentStage = Stages.PreSale;
294     return true;
295   }
296 
297   function setSale() public onlyOwner returns (bool) {
298     currentStage = Stages.Sale;
299     return true;
300   }
301 
302   function tokensAmount(uint256 _wei) public view returns (uint256) {
303     if (_wei < 100000000000000000) return 0;
304     uint256 amount = _wei.mul(14005).div(1 ether);
305     if (currentStage == Stages.PrivateSale) {
306       if (_wei < 50000000000000000000) return 0;
307       if (_wei > 3000000000000000000000) return 0;
308       amount = amount.mul(130).div(100);
309       if (amount > privateSaleLimit.sub(privateSale)) return 0;
310     }
311     if (currentStage == Stages.PreSale) {
312       if (_wei > 30000000000000000000) return 0;
313       amount = amount.mul(110).div(100);
314       if (amount > preSaleLimit.sub(preSale)) return 0;
315     }
316     if (currentStage == Stages.Sale) {
317       if (amount > saleLimit.sub(sale)) return 0;
318     }
319     return amount;
320   }
321 
322   function addStageAmount(uint256 _amount) public {
323     if (currentStage == Stages.PrivateSale) {
324       require(_amount < privateSaleLimit.sub(privateSale)); 
325       privateSale = privateSale.add(_amount);
326     }
327     if (currentStage == Stages.PreSale) {
328       require(_amount < preSaleLimit.sub(preSale));
329       privateSale = privateSale.add(_amount);
330     }
331     if (currentStage == Stages.Sale) {
332       require(_amount < saleLimit.sub(sale));
333       sale = sale.add(_amount);
334     }
335   }
336 }
337 
338 contract MintableToken is PausableToken, Configurable {
339    function mint(address _to, uint256 _amount) public onlyOwner returns (bool) {
340     require(totalSaleLimit.add(30000000) > totalSupply.add(_amount));
341     totalSupply = totalSupply.add(_amount);
342     balances[_to] = balances[_to].add(_amount);
343     emit Transfer(address(this), _to, _amount);
344     return true;
345   }  
346 }
347 
348 contract CrowdsaleToken is MintableToken, Staged {
349   function CrowdsaleToken() internal {
350     balances[owner] = 22000000; // bounty and marketing
351     totalSupply.add(22000000);
352   }
353   
354   function() public payable {
355     uint256 tokens = tokensAmount(msg.value);
356     require (tokens > 0);
357     addStageAmount(tokens);
358     owner.transfer(msg.value);
359     balances[msg.sender] = balances[msg.sender].add(tokens);
360     emit Transfer(address(this), msg.sender, tokens);
361   }
362 
363   function releaseTeamTokens() public {
364     uint256 timeSinceCreation = now.sub(creationDate);
365     uint256 teamTokens = timeSinceCreation.div(7776000).mul(1000000);
366     require (teamReleased < teamTokens);
367     teamTokens = teamTokens.sub(teamReleased);
368     if (teamReleased.add(teamTokens) > teamLimit) {
369       teamTokens = teamLimit.sub(teamReleased);
370     }
371     require (teamTokens > 0);
372     teamReleased = teamReleased.add(teamTokens);
373     balances[teamAddress] = balances[teamAddress].add(teamTokens);
374     totalSupply = totalSupply.add(teamTokens);
375     emit Transfer(address(this), teamAddress, teamTokens);
376   }
377 }
378 
379 contract WorkChain is CrowdsaleToken {   
380   string public constant name = "WorkChain";
381   string public constant symbol = "WCH";
382   uint32 public constant decimals = 0;
383 }