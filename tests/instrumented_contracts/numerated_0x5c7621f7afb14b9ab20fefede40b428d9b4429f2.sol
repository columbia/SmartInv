1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 /**
35  * @title ERC20Basic
36  * @dev Simpler version of ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/179
38  */
39 contract ERC20Basic {
40   uint256 public totalSupply;
41   function balanceOf(address who) public constant returns (uint256);
42   function transfer(address to, uint256 value) public returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 /**
47  * @title ERC20 interface
48  * @dev see https://github.com/ethereum/EIPs/issues/20
49  */
50 contract ERC20 is ERC20Basic {
51   function allowance(address owner, address spender) public constant returns (uint256);
52   function transferFrom(address from, address to, uint256 value) public returns (bool);
53   function approve(address spender, uint256 value) public returns (bool);
54   event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 contract Pausable is ERC20Basic {
58 
59     uint public constant startPreICO = 1516525200;
60     uint public constant endPreICO = startPreICO + 30 days;
61     
62     uint public constant startICOStage1 = 1520931600;
63     uint public constant endICOStage1 = startICOStage1 + 15 days;
64     
65     uint public constant startICOStage2 = endICOStage1;
66     uint public constant endICOStage2 = startICOStage2 + 15 days;
67     
68     uint public constant startICOStage3 = endICOStage2;
69     uint public constant endICOStage3 = startICOStage3 + 15 days;
70     
71     uint public constant startICOStage4 = endICOStage3;
72     uint public constant endICOStage4 = startICOStage4 + 15 days;
73 
74   /**
75    * @dev modifier to allow actions only when the contract IS not paused
76    */
77   modifier whenNotPaused() {
78     require(now < startPreICO || now > endICOStage4);
79     _;
80   }
81 
82 }
83 
84 /**
85  * @title Basic token
86  * @dev Basic version of StandardToken, with no allowances.
87  */
88 contract BasicToken is Pausable {
89   using SafeMath for uint256;
90 
91   mapping(address => uint256) balances;
92 
93   /**
94   * @dev transfer token for a specified address
95   * @param _to The address to transfer to.
96   * @param _value The amount to be transferred.
97   */
98   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
99     require(_to != address(0));
100     require(_value <= balances[msg.sender]);
101 
102     // SafeMath.sub will throw if there is not enough balance.
103     balances[msg.sender] = balances[msg.sender].sub(_value);
104     balances[_to] = balances[_to].add(_value);
105     Transfer(msg.sender, _to, _value);
106     return true;
107   }
108 
109   /**
110   * @dev Gets the balance of the specified address.
111   * @param _owner The address to query the the balance of.
112   * @return An uint256 representing the amount owned by the passed address.
113   */
114   function balanceOf(address _owner) public constant returns (uint256 balance) {
115     return balances[_owner];
116   }
117 
118 }
119 
120 /**
121  * @title Standard ERC20 token
122  *
123  * @dev Implementation of the basic standard token.
124  * @dev https://github.com/ethereum/EIPs/issues/20
125  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
126  */
127 contract StandardToken is ERC20, BasicToken {
128 
129   mapping (address => mapping (address => uint256)) internal allowed;
130 
131   /**
132    * @dev Transfer tokens from one address to another
133    * @param _from address The address which you want to send tokens from
134    * @param _to address The address which you want to transfer to
135    * @param _value uint256 the amount of tokens to be transferred
136    */
137   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
138     require(_to != address(0));
139     require(_value <= balances[_from]);
140     require(_value <= allowed[_from][msg.sender]);
141 
142     balances[_from] = balances[_from].sub(_value);
143     balances[_to] = balances[_to].add(_value);
144     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
145     Transfer(_from, _to, _value);
146     return true;
147   }
148 
149   /**
150    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
151    *
152    * Beware that changing an allowance with this method brings the risk that someone may use both the old
153    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
154    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
155    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156    * @param _spender The address which will spend the funds.
157    * @param _value The amount of tokens to be spent.
158    */
159   function approve(address _spender, uint256 _value) public returns (bool) {
160     allowed[msg.sender][_spender] = _value;
161     Approval(msg.sender, _spender, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Function to check the amount of tokens that an owner allowed to a spender.
167    * @param _owner address The address which owns the funds.
168    * @param _spender address The address which will spend the funds.
169    * @return A uint256 specifying the amount of tokens still available for the spender.
170    */
171   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
172     return allowed[_owner][_spender];
173   }
174 
175   /**
176    * approve should be called when allowed[_spender] == 0. To increment
177    * allowed value is better to use this function to avoid 2 calls (and wait until
178    * the first transaction is mined)
179    * From MonolithDAO Token.sol
180    */
181   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
182     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
183     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
184     return true;
185   }
186 
187   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
188     uint oldValue = allowed[msg.sender][_spender];
189     if (_subtractedValue > oldValue) {
190       allowed[msg.sender][_spender] = 0;
191     } else {
192       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
193     }
194     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195     return true;
196   }
197 
198 }
199 
200 /**
201  * @title Ownable
202  * @dev The Ownable contract has an owner address, and provides basic authorization control
203  * functions, this simplifies the implementation of "user permissions".
204  */
205 contract Ownable {
206   address public owner;
207 
208   /**
209    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
210    * account.
211    */
212   function Ownable() {
213     owner = msg.sender;
214   }
215 
216   /**
217    * @dev Throws if called by any account other than the owner.
218    */
219   modifier onlyOwner() {
220     require(msg.sender == owner);
221     _;
222   }
223 
224   /**
225    * @dev Allows the current owner to transfer control of the contract to a newOwner.
226    * @param newOwner The address to transfer ownership to.
227    */
228   function transferOwnership(address newOwner) onlyOwner {
229     require(newOwner != address(0));
230     owner = newOwner;
231   }
232   
233 }
234 
235 contract Gelios is Ownable, StandardToken {
236     using SafeMath for uint256;
237 
238     string public constant name = "Gelios Token";
239     string public constant symbol = "GLS";
240     uint256 public constant decimals = 18;
241 
242     uint256 public constant INITIAL_SUPPLY = 16808824 ether;
243     address public tokenWallet;
244     address public multiSig;
245 
246     uint256 public tokenRate = 1000; // tokens per 1 ether
247 
248     function Gelios(address _tokenWallet, address _multiSig) {
249         tokenWallet = _tokenWallet;
250         multiSig = _multiSig;
251         totalSupply = INITIAL_SUPPLY;
252         balances[_tokenWallet] = INITIAL_SUPPLY;
253     }
254 
255     function () payable public {
256         require(now >= startPreICO);
257         buyTokens(msg.value);
258     }
259 
260     function buyTokensBonus(address bonusAddress) public payable {
261         require(now >= startPreICO && now < endICOStage4);
262         if (bonusAddress != 0x0 && msg.sender != bonusAddress) {
263             uint bonus = msg.value.mul(tokenRate).div(100).mul(5);
264             if(buyTokens(msg.value)) {
265                sendTokensRef(bonusAddress, bonus);
266             }
267         }
268     }
269 
270     uint preIcoCap = 1300000 ether;
271     uint icoStage1Cap = 600000 ether;
272     uint icoStage2Cap = 862500 ether;
273     uint icoStage3Cap = 810000 ether;
274     uint icoStage4Cap = 5000000 ether;
275     
276     struct Stats {
277         uint preICO;
278         uint preICOETHRaised;
279         
280         uint ICOStage1;
281         uint ICOStage1ETHRaised;
282         
283         uint ICOStage2;
284         uint ICOStage2ETHRaised;
285         
286         uint ICOStage3;
287         uint ICOStage3ETHRaised;
288         
289         uint ICOStage4;
290         uint ICOStage4ETHRaised;
291         
292         uint RefBonusese;
293     }
294     
295     event Burn(address indexed burner, uint256 value);
296     
297     Stats public stats;
298     uint public burnAmount = preIcoCap;
299     bool[] public burnStage = [true, true, true, true];
300 
301     function buyTokens(uint amount) private returns (bool){
302         // PreICO - 30% 1516525200 01/21/2018 @ 9:00am (UTC) 30 days 1300000
303         // Ico 1 - 20% 1520931600 03/13/2018 @ 9:00am (UTC) cap or 15 days 600000
304         // ico 2 - 15% cap or 15 days  862500
305         // ico 3 - 8% cap or 15 days 810000
306         // ico 4 - 0% cap or 15 days 5000000
307         
308         uint tokens = amount.mul(tokenRate);
309         if(now >= startPreICO && now < endPreICO && stats.preICO < preIcoCap) {
310             tokens = tokens.add(tokens.div(100).mul(30));
311             tokens = safeSend(tokens, preIcoCap.sub(stats.preICO));
312             stats.preICO = stats.preICO.add(tokens);
313             stats.preICOETHRaised = stats.preICOETHRaised.add(amount);
314             burnAmount = burnAmount.sub(tokens);
315             
316             return true;
317         } else if (now >= startICOStage1 && now < endICOStage1 && stats.ICOStage1 < icoStage1Cap) {
318             if (burnAmount > 0 && burnStage[0]) {
319                 burnTokens();
320                 burnStage[0] = false;
321                 burnAmount = icoStage1Cap;
322             }
323             
324             tokens = tokens.add(tokens.div(100).mul(20));
325             tokens = safeSend(tokens, icoStage1Cap.sub(stats.ICOStage1));
326             stats.ICOStage1 = stats.ICOStage1.add(tokens);
327             stats.ICOStage1ETHRaised = stats.ICOStage1ETHRaised.add(amount);
328             burnAmount = burnAmount.sub(tokens);
329 
330             return true;
331         } else if ( now < endICOStage2 && stats.ICOStage2 < icoStage2Cap ) {
332             if (burnAmount > 0 && burnStage[1]) {
333                 burnTokens();
334                 burnStage[1] = false;
335                 burnAmount = icoStage2Cap;
336             }
337             
338             tokens = tokens.add(tokens.div(100).mul(15));
339             tokens = safeSend(tokens, icoStage2Cap.sub(stats.ICOStage2));
340             stats.ICOStage2 = stats.ICOStage2.add(tokens);
341             stats.ICOStage2ETHRaised = stats.ICOStage2ETHRaised.add(amount);
342             burnAmount = burnAmount.sub(tokens);
343             
344             return true;
345         } else if ( now < endICOStage3 && stats.ICOStage3 < icoStage3Cap ) {
346             if (burnAmount > 0 && burnStage[2]) {
347                 burnTokens();
348                 burnStage[2] = false;
349                 burnAmount = icoStage3Cap;
350             }
351             
352             tokens = tokens.add(tokens.div(100).mul(8));
353             tokens = safeSend(tokens, icoStage3Cap.sub(stats.ICOStage3));
354             stats.ICOStage3 = stats.ICOStage3.add(tokens);
355             stats.ICOStage3ETHRaised = stats.ICOStage3ETHRaised.add(amount);
356             burnAmount = burnAmount.sub(tokens);
357             
358             return true;
359         } else if ( now < endICOStage4 && stats.ICOStage4 < icoStage4Cap ) {
360             if (burnAmount > 0 && burnStage[3]) {
361                 burnTokens();
362                 burnStage[3] = false;
363                 burnAmount = icoStage4Cap;
364             }
365             
366             tokens = safeSend(tokens, icoStage4Cap.sub(stats.ICOStage4));
367             stats.ICOStage4 = stats.ICOStage4.add(tokens);
368             stats.ICOStage4ETHRaised = stats.ICOStage4ETHRaised.add(amount);
369             burnAmount = burnAmount.sub(tokens);
370             
371             return true;
372         } else if (now > endICOStage4 && burnAmount > 0) {
373             burnTokens();
374             msg.sender.transfer(msg.value);
375             burnAmount = 0;
376         } else {
377             revert();
378         }
379     }
380     
381     /**
382      * Burn tokens which are not sold on previous stage
383      **/
384     function burnTokens() private {
385         balances[tokenWallet] = balances[tokenWallet].sub(burnAmount);
386         totalSupply = totalSupply.sub(burnAmount);
387         Burn(tokenWallet, burnAmount);
388     }
389 
390     /**
391      * Check last token on sale
392      **/
393     function safeSend(uint tokens, uint stageLimmit) private returns(uint) {
394         if (stageLimmit < tokens) {
395             uint toReturn = tokenRate.mul(tokens.sub(stageLimmit));
396             sendTokens(msg.sender, stageLimmit);
397             msg.sender.transfer(toReturn);
398             return stageLimmit;
399         } else {
400             sendTokens(msg.sender, tokens);
401             return tokens;
402         }
403     }
404 
405     /**
406      * Low-level function for tokens transfer
407      **/
408     function sendTokens(address _to, uint tokens) private {
409         balances[tokenWallet] = balances[tokenWallet].sub(tokens);
410         balances[_to] += tokens;
411         Transfer(tokenWallet, _to, tokens);
412         multiSig.transfer(msg.value);
413     }
414     
415     /**
416      * Burn tokens which are not sold on previous stage
417      **/    
418     function sendTokensRef(address _to, uint tokens) private {
419         balances[tokenWallet] = balances[tokenWallet].sub(tokens);
420         balances[_to] += tokens;
421         Transfer(tokenWallet, _to, tokens);
422         stats.RefBonusese += tokens; 
423     }
424     
425     /**
426      * Update token rate manually
427      **/
428     function updateTokenRate(uint newRate) onlyOwner public {
429         tokenRate = newRate;
430     }
431     
432 }