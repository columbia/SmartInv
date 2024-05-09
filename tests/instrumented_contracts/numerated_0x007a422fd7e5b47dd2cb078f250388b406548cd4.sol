1 pragma solidity ^0.4.16;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
6     uint256 c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function div(uint256 a, uint256 b) internal constant returns (uint256) {
12     // assert(b > 0); // Solidity automatically throws when dividing by 0
13     uint256 c = a / b;
14     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal constant returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract ERC20Basic {
31   uint256 public totalSupply;
32   function balanceOf(address who) constant returns (uint256);
33   function transfer(address to, uint256 value) returns (bool);
34   event Transfer(address indexed from, address indexed to, uint256 value);
35 }
36 
37 contract ERC20 is ERC20Basic {
38   function allowance(address owner, address spender) constant returns (uint256);
39   function transferFrom(address from, address to, uint256 value) returns (bool);
40   function approve(address spender, uint256 value) returns (bool);
41   event Approval(address indexed owner, address indexed spender, uint256 value);
42 }
43 
44 contract BasicToken is ERC20Basic {
45   using SafeMath for uint256;
46 
47   mapping(address => uint256) balances;
48 
49   
50    //@dev transfer token for a specified address
51   // @param _to The address to transfer to.
52    //@param _value The amount to be transferred.
53    
54   function transfer(address _to, uint256 _value) returns (bool) {
55     require(_to != address(0));
56 
57     // SafeMath.sub will throw if there is not enough balance.
58     balances[msg.sender] = balances[msg.sender].sub(_value);
59     balances[_to] = balances[_to].add(_value);
60     Transfer(msg.sender, _to, _value);
61     return true;
62   }
63 
64   
65    //@dev Gets the balance of the specified address.
66    //@param _owner The address to query the the balance of. 
67   // @return An uint256 representing the amount owned by the passed address.
68   
69   function balanceOf(address _owner) constant returns (uint256 balance) {
70     return balances[_owner];
71   }
72 
73 }
74 
75 contract StandardToken is ERC20, BasicToken {
76 
77   mapping (address => mapping (address => uint256)) allowed;
78 
79 
80   /**
81    * @dev Transfer tokens from one address to another
82    * @param _from address The address which you want to send tokens from
83    * @param _to address The address which you want to transfer to
84    * @param _value uint256 the amount of tokens to be transferred
85    */
86   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
87     require(_to != address(0));
88 
89     var _allowance = allowed[_from][msg.sender];
90 
91     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
92     // require (_value <= _allowance);
93 
94     balances[_from] = balances[_from].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     allowed[_from][msg.sender] = _allowance.sub(_value);
97     Transfer(_from, _to, _value);
98     return true;
99   }
100 
101   /**
102    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
103    * @param _spender The address which will spend the funds.
104    * @param _value The amount of tokens to be spent.
105    */
106   function approve(address _spender, uint256 _value) returns (bool) {
107 
108     // To change the approve amount you first have to reduce the addresses`
109     //  allowance to zero by calling `approve(_spender, 0)` if it is not
110     //  already 0 to mitigate the race condition described here:
111     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
112     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
113 
114     allowed[msg.sender][_spender] = _value;
115     Approval(msg.sender, _spender, _value);
116     return true;
117   }
118 
119   /**
120    * @dev Function to check the amount of tokens that an owner allowed to a spender.
121    * @param _owner address The address which owns the funds.
122    * @param _spender address The address which will spend the funds.
123    * @return A uint256 specifying the amount of tokens still available for the spender.
124    */
125   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
126     return allowed[_owner][_spender];
127   }
128   
129   /**
130    * approve should be called when allowed[_spender] == 0. To increment
131    * allowed value is better to use this function to avoid 2 calls (and wait until 
132    * the first transaction is mined)
133    * From MonolithDAO Token.sol
134    */
135   function increaseApproval (address _spender, uint256 _addedValue) 
136     returns (bool success) 
137     {
138     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
139     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
140     return true;
141   }
142 
143   function decreaseApproval (address _spender, uint256 _subtractedValue) 
144     returns (bool success) 
145     {
146     uint256 oldValue = allowed[msg.sender][_spender];
147     if (_subtractedValue > oldValue) {
148       allowed[msg.sender][_spender] = 0;
149     } else {
150       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
151     }
152     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
153     return true;
154   }
155 
156 }
157 
158 
159 contract Ownable {
160   address public owner;
161 
162     //@dev The Ownable constructor sets the original `owner` of the contract to the sender account.
163    function Ownable() {
164     owner = msg.sender;
165   }
166 
167     //@dev Throws if called by any account other than the owner.
168    modifier onlyOwner() {
169     require(msg.sender == owner);
170     _;
171   }
172 
173     //@dev Allows the current owner to transfer control of the contract to a newOwner.
174     //@param newOwner The address to transfer ownership to.
175   function transferOwnership(address newOwner) onlyOwner {
176     require(newOwner != address(0));      
177     owner = newOwner;
178   }
179 
180 }
181 
182     //@title Pausable
183     //@dev Base contract which allows children to implement an emergency stop mechanism for trading.
184 contract Pausable is Ownable {
185   event Pause();
186   event Unpause();
187 
188   bool public paused = false;
189 
190     //@dev Modifier to make a function callable only when the contract is not paused.
191   modifier whenNotPaused() {
192     require(!paused);
193     _;
194   }
195 
196     //@dev Modifier to make a function callable only when the contract is paused.
197   modifier whenPaused() {
198     require(paused);
199     _;
200   }
201 
202     //@dev called by the owner to pause, triggers stopped state
203   function pause() onlyOwner whenNotPaused {
204     paused = true;
205     Pause();
206   }
207     //@dev called by the owner to unpause, returns to normal state
208   function unpause() onlyOwner whenPaused {
209     paused = false;
210     Unpause();
211   }
212 }
213 
214     //@title Pausable
215     //@dev Base contract which allows children to implement an emergency stop mechanism for crowdsale.
216 contract SalePausable is Ownable {
217   event SalePause();
218   event SaleUnpause();
219 
220   bool public salePaused = false;
221 
222     //@dev Modifier to make a function callable only when the contract is not paused.
223   modifier saleWhenNotPaused() {
224     require(!salePaused);
225     _;
226   }
227 
228     //@dev Modifier to make a function callable only when the contract is paused.
229   modifier saleWhenPaused() {
230     require(salePaused);
231     _;
232   }
233 
234     //@dev called by the owner to pause, triggers stopped state
235   function salePause() onlyOwner saleWhenNotPaused {
236     salePaused = true;
237     SalePause();
238   }
239     //@dev called by the owner to unpause, returns to normal state
240   function saleUnpause() onlyOwner saleWhenPaused {
241     salePaused = false;
242     SaleUnpause();
243   }
244 }
245 
246 contract PriceUpdate is Ownable {
247   uint256 public price;
248 
249     //@dev The Ownable constructor sets the original `price` of the BLT token to the sender account.
250    function PriceUpdate() {
251     price = 400;
252   }
253 
254     //@dev Allows the current owner to change the price of the token per ether.
255   function newPrice(uint256 _newPrice) onlyOwner {
256     require(_newPrice > 0);
257     price = _newPrice;
258   }
259 
260 }
261 
262 contract BLTToken is StandardToken, Ownable, PriceUpdate, Pausable, SalePausable {
263 	using SafeMath for uint256;
264 	mapping(address => uint256) balances;
265 	uint256 public totalSupply;
266     uint256 public totalCap = 100000000000000000000000000;
267     string 	public constant name = "BitLifeAndTrust";
268 	string 	public constant symbol = "BLT";
269 	uint256	public constant decimals = 18;
270 	//uint256 public price = 400;  moved to price setting contract
271     
272     address public bltRetainedAcc = 0x48259a35030c8dA6aaA1710fD31068D30bfc716C;  //holds blt company retained
273     address public bltOwnedAcc =    0x1CA33C197952B8D9dd0eDC9EFa20018D6B3dcF5F;  //holds blt company owned
274     address public bltMasterAcc =   0xACc2be4D782d472cf4f928b116054904e5513346; //master account to hold BLT
275 
276     uint256 public bltRetained = 15000000000000000000000000;
277     uint256 public bltOwned =    15000000000000000000000000;
278     uint256 public bltMaster =   70000000000000000000000000;
279 
280 
281 	function balanceOf(address _owner) constant returns (uint256 balance) {
282 	    return balances[_owner];
283 	}
284 
285 
286 	function transfer(address _to, uint256 _value) whenNotPaused returns (bool success) {
287 	    balances[msg.sender] = balances[msg.sender].sub(_value);
288 	    balances[_to] = balances[_to].add(_value);
289 	    Transfer(msg.sender, _to, _value);
290 	    return true;
291 	}
292 
293 
294 	function transferFrom(address _from, address _to, uint256 _value) whenNotPaused returns (bool success) {
295 	    
296 	    var allowance = allowed[_from][msg.sender];
297 	    
298 	    balances[_to] = balances[_to].add(_value);
299 	    balances[_from] = balances[_from].sub(_value);
300 	    allowed[_from][msg.sender] = allowance.sub(_value);
301 	    Transfer(_from, _to, _value);
302 	    return true;
303 	}
304 
305 
306 	function approve(address _spender, uint256 _value) returns (bool success) {
307 	    allowed[msg.sender][_spender] = _value;
308 	    Approval(msg.sender, _spender, _value);
309 	    return true;
310 	}
311 
312 
313 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
314 	    return allowed[_owner][_spender];
315 	}
316 
317 
318 	function BLTToken() {
319 		balances[bltRetainedAcc] = bltRetained;             // fund BLT Retained account
320         balances[bltOwnedAcc] = bltOwned;                   // fund BLT Owned account
321         balances[bltMasterAcc] = bltMaster;                 // fund BLT master account
322         
323         allowed[bltMasterAcc][msg.sender] = bltMaster;
324 
325         totalSupply = bltRetained + bltOwned + bltMaster;
326 
327         Transfer(0x0,bltRetainedAcc,bltRetained);
328         Transfer(0x0,bltOwnedAcc,bltOwned);
329         Transfer(0x0,bltMasterAcc,bltMaster);
330 
331 	}
332 
333 }
334 
335 
336 contract BLTTokenSale is BLTToken {
337     using SafeMath for uint256;    
338 
339     BLTToken public token;
340     uint256 public etherRaised;
341     uint256 public saleStartTime = now;
342     //uint256 public saleEndTime = now + 1 weeks;
343     address public ethDeposits = 0x50c19a8D73134F8e649bB7110F2E8860e4f6cfB6;        //ether goes to this account
344     address public bltMasterToSale = 0xACc2be4D782d472cf4f928b116054904e5513346;    //BLT available for sale
345 
346     event MintedToken(address from, address to, uint256 value1);                    //event that Tokens were sent
347     event RecievedEther(address from, uint256 value1);                               //event that ether received function ran     
348 
349     function () payable {
350 		createTokens(msg.sender,msg.value);
351 	}
352 
353         //initiates the sale of the token
354 	function createTokens(address _recipient, uint256 _value) saleWhenNotPaused {
355         
356         require (_value != 0);                                                      //value must be greater than zero
357         require (now >= saleStartTime);                                             //only works during token sale
358         require (_recipient != 0x0);                                                //not a contract validation
359 		uint256 tokens = _value.mul(PriceUpdate.price);                             //calculate the number of tokens from the ether sent
360         uint256 remainingTokenSuppy = balanceOf(bltMasterToSale);
361 
362         if (remainingTokenSuppy >= tokens) {                                        //only works if there is still a supply in the master account
363             require(mint(_recipient, tokens));                                      //execute the movement of tokens
364             etherRaised = etherRaised.add(_value);
365             forwardFunds();
366             RecievedEther(msg.sender,_value);
367         }                                        
368 
369 	}
370     
371      //transfers BLT from storage account into the purchasers account   
372     function mint(address _to, uint256 _tokens) internal saleWhenNotPaused returns (bool success) {
373         
374         address _from = bltMasterToSale;
375 	    var allowance = allowed[_from][owner];
376 	    
377 	    balances[_to] = balances[_to].add(_tokens);
378 	    balances[_from] = balances[_from].sub(_tokens);
379 	    allowed[_from][owner] = allowance.sub(_tokens);
380         Transfer(_from, _to, _tokens);                                               //capture event in logs
381 	    MintedToken(_from,_to, _tokens); 
382       return true;
383 	}    
384       //forwards ether to storage wallet  
385       function forwardFunds() internal {
386         ethDeposits.transfer(msg.value);
387         
388         }
389 }