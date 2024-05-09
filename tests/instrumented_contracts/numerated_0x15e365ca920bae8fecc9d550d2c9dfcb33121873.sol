1 pragma solidity ^0.4.15;
2  
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) constant returns (uint256);
11   function transfer(address to, uint256 value) returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14  
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) returns (bool);
22   function approve(address spender, uint256 value) returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25  
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31     
32   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
33     uint256 c = a * b;
34     assert(a == 0 || c / a == b);
35     return c;
36   }
37  
38   function div(uint256 a, uint256 b) internal constant returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44  
45   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49  
50   function add(uint256 a, uint256 b) internal constant returns (uint256) {
51     uint256 c = a + b;
52     assert(c >= a);
53     return c;
54   }
55   
56 }
57  
58 /**
59  * @title Basic token
60  * @dev Basic version of StandardToken, with no allowances. 
61  */
62 contract BasicToken is ERC20Basic {
63     
64   using SafeMath for uint256;
65  
66   mapping(address => uint256) balances;
67   
68   Crowdsale crowdsale;
69   
70     modifier crowdsaleIsOverOrThisIsContract(){
71       require(crowdsale.isCrowdsaleOver() || msg.sender == crowdsale.getContractAddress());
72       _;
73   }
74  
75   /**
76   * @dev transfer token for a specified address
77   * @param _to The address to transfer to.
78   * @param _value The amount to be transferred.
79   */
80   function transfer(address _to, uint256 _value) crowdsaleIsOverOrThisIsContract returns (bool) {
81     balances[msg.sender] = balances[msg.sender].sub(_value);
82     balances[_to] = balances[_to].add(_value);
83     Transfer(msg.sender, _to, _value);
84     return true;
85   }
86  
87   /**
88   * @dev Gets the balance of the specified address.
89   * @param _owner The address to query the the balance of. 
90   * @return An uint256 representing the amount owned by the passed address.
91   */
92   function balanceOf(address _owner) constant returns (uint256 balance) {
93     return balances[_owner];
94   }
95  
96 }
97  
98 /**
99  * @title Standard ERC20 token
100  *
101  * @dev Implementation of the basic standard token.
102  * @dev https://github.com/ethereum/EIPs/issues/20
103  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
104  */
105 contract StandardToken is ERC20, BasicToken {
106  
107   mapping (address => mapping (address => uint256)) allowed;
108   
109   
110   
111   function StandardToken(Crowdsale x){
112       crowdsale =x;
113   }
114   
115 
116  
117   /**
118    * @dev Transfer tokens from one address to another
119    * @param _from address The address which you want to send tokens from
120    * @param _to address The address which you want to transfer to
121    * @param _value uint256 the amout of tokens to be transfered
122    */
123   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
124     var _allowance = allowed[_from][msg.sender];
125  
126     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
127     // require (_value <= _allowance);
128  
129     balances[_to] = balances[_to].add(_value);
130     balances[_from] = balances[_from].sub(_value);
131     allowed[_from][msg.sender] = _allowance.sub(_value);
132     Transfer(_from, _to, _value);
133     return true;
134   }
135  
136   /**
137    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
138    * @param _spender The address which will spend the funds.
139    * @param _value The amount of tokens to be spent.
140    */
141   function approve(address _spender, uint256 _value) returns (bool) {
142  
143     // To change the approve amount you first have to reduce the addresses`
144     //  allowance to zero by calling `approve(_spender, 0)` if it is not
145     //  already 0 to mitigate the race condition described here:
146     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
147     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
148  
149     allowed[msg.sender][_spender] = _value;
150     Approval(msg.sender, _spender, _value);
151     return true;
152   }
153  
154   /**
155    * @dev Function to check the amount of tokens that an owner allowed to a spender.
156    * @param _owner address The address which owns the funds.
157    * @param _spender address The address which will spend the funds.
158    * @return A uint256 specifing the amount of tokens still available for the spender.
159    */
160   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
161     return allowed[_owner][_spender];
162   }
163  
164 }
165  
166 /**
167  * @title Ownable
168  * @dev The Ownable contract has an owner address, and provides basic authorization control
169  * functions, this simplifies the implementation of "user permissions".
170  */
171 contract Ownable {
172     
173   address public owner;
174  
175   /**
176    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
177    * account.
178    */
179   function Ownable() {
180     owner = msg.sender;
181   }
182  
183   /**
184    * @dev Throws if called by any account other than the owner.
185    */
186   modifier onlyOwner() {
187     require(msg.sender == owner);
188     _;
189   }
190  
191   /**
192    * @dev Allows the current owner to transfer control of the contract to a newOwner.
193    * @param newOwner The address to transfer ownership to.
194    */
195   function transferOwnership(address newOwner) onlyOwner {
196     require(newOwner != address(0));      
197     owner = newOwner;
198   }
199  
200 }
201  
202 /**
203  * @title Mintable token
204  * @dev Simple ERC20 Token example, with mintable token creation
205  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
206  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
207  */
208  
209 contract MintableToken is StandardToken, Ownable {
210     
211      function MintableToken(Crowdsale x) StandardToken(x){
212         
213     }
214     
215   event Mint(address indexed to, uint256 amount);
216   
217   event MintFinished();
218  
219   bool public mintingFinished = false;
220  
221   modifier canMint() {
222     require(!mintingFinished);
223     _;
224   }
225  
226   /**
227    * @dev Function to mint tokens
228    * @param _to The address that will recieve the minted tokens.
229    * @param _amount The amount of tokens to mint.
230    * @return A boolean that indicates if the operation was successful.
231    */
232   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
233     totalSupply = totalSupply.add(_amount);
234     balances[_to] = balances[_to].add(_amount);
235     allowed[_to][_to] =  allowed[_to][_to].add(_amount);
236     Mint(_to, _amount);
237     return true;
238   }
239  
240   /**
241    * @dev Function to stop minting new tokens.
242    * @return True if the operation was successful.
243    */
244   function finishMinting() onlyOwner returns (bool) {
245     mintingFinished = true;
246     MintFinished();
247     return true;
248   }
249   
250 }
251  
252 contract DjohniKrasavchickToken is MintableToken {
253     
254     string public constant name = "DjohniKrasavchickToken";
255     
256     string public constant symbol = "DJKR";
257     
258     uint32 public constant decimals = 2;
259     
260     function DjohniKrasavchickToken(Crowdsale x) MintableToken(x){
261         
262     } 
263     
264 }
265  
266  
267 contract Crowdsale is Ownable {
268     
269     using SafeMath for uint;
270     
271     address public myWalletForETH;
272     
273     uint public bountyPercent;
274     
275     uint public djonniPercent;
276     
277     uint public developerPercent;
278     
279     uint public bountyTokens;
280     
281     uint public djonniTokens;
282     
283     uint public developerTokens;
284     
285     address[] public bountyAdresses;
286  
287     DjohniKrasavchickToken public token = new DjohniKrasavchickToken(this);
288  
289     uint public start;
290     
291     uint public period;
292  
293     uint public hardcap;
294  
295     uint public rate;
296     
297     uint public softcap;
298     
299     bool private isHardCapWasReached = false;
300     
301     bool private isCrowdsaleStoped = false;
302     
303     mapping(address => uint) public balances;
304  
305     function Crowdsale() {
306       myWalletForETH = 0xe4D5b0aECfeFf1A39235f49254a0f37AaA7F6cC0;
307       bountyPercent = 10;
308       djonniPercent = 50;
309       developerPercent = 20;
310       rate = 100000000;
311       start = 1536858000;
312       period = 14;
313       hardcap = 200000000000000000;
314       softcap = 50000000000000000;
315     }
316      
317     function getContractAddress() public returns(address){
318         return this;
319     }
320     
321     function isCrowdsaleOver() public returns(bool){
322         if( isCrowsdaleTimeFinished() || isHardCapReached() || isCrowdsaleStoped){
323             return true;
324         }
325         return false;
326     }
327     
328     function isCrowsdaleTimeFinished() internal returns(bool){
329         if(now > start + period * 1 hours){
330             return true;
331         }
332         return false;
333     }
334     
335     function isHardCapReached() internal returns (bool){
336         if(hardcap==this.balance){
337             isHardCapWasReached = true;
338         }
339         return isHardCapWasReached;
340     }
341     
342     function stopCrowdSaleOnlyForOwner() onlyOwner{
343         if(!isCrowdsaleStoped){
344          stopCrowdSale();
345         }
346     }
347     
348     function stopCrowdSale() internal{
349         if(token.mintingFinished() == false){
350               finishMinting();
351         }
352         isCrowdsaleStoped = true;
353     }
354  
355     modifier saleIsOn() {
356       require(now > start && now < start + period * 1 hours);
357       _;
358     }
359     
360     modifier crowdsaleIsOver() {
361       require(isCrowdsaleOver());
362       _;
363     }
364 
365     modifier isUnderHardCap() {
366       require(this.balance <= hardcap && !isHardCapWasReached );
367       _;
368     }
369     
370     modifier onlyOwnerOrSaleIsOver(){
371         require(owner==msg.sender || isCrowdsaleOver() );
372         _;
373     }
374  
375     function refund() {
376       require(this.balance < softcap && now > start + period * 1 hours);
377       uint value = balances[msg.sender]; 
378       balances[msg.sender] = 0; 
379       msg.sender.transfer(value); 
380     }
381  
382     function finishMinting() public onlyOwnerOrSaleIsOver  {
383       if(this.balance > softcap) {
384         myWalletForETH.transfer(this.balance);
385         uint issuedTokenSupply = token.totalSupply();
386         uint additionalTokens = bountyPercent+developerPercent+djonniPercent;
387         uint tokens = issuedTokenSupply.mul(additionalTokens).div(100 - additionalTokens);
388         token.mint(this, tokens);
389         token.finishMinting();
390         issuedTokenSupply = token.totalSupply();
391         bountyTokens = issuedTokenSupply.div(100).mul(bountyPercent);
392         developerTokens = issuedTokenSupply.div(100).mul(developerPercent);
393         djonniTokens = issuedTokenSupply.div(100).mul(djonniPercent);
394         token.transfer(myWalletForETH, developerTokens);
395       }
396     }
397     
398     function showThisBallance() public returns (uint){
399         return this.balance;
400     }
401 
402  
403    function createTokens() isUnderHardCap saleIsOn payable {
404       uint tokens = rate.mul(msg.value).div(1 ether);
405       token.mint(this, tokens);
406       token.transfer(msg.sender, tokens);
407       balances[msg.sender] = balances[msg.sender].add(msg.value);
408     }
409     
410 
411  
412     function() external payable {
413      if(isCrowsdaleTimeFinished() && !isCrowdsaleStoped){
414        stopCrowdSale();    
415      }
416      createTokens();
417      if(isCrowdsaleOver() && !isCrowdsaleStoped){
418       stopCrowdSale();
419      }
420     }
421     
422     function addBountyAdresses(address[] array) onlyOwner{
423                for (uint i = 0; i < array.length; i++){
424                   bountyAdresses.push(array[i]);
425                }
426     }
427     
428     function distributeBountyTokens() onlyOwner crowdsaleIsOver{
429                uint amountofTokens = bountyTokens/bountyAdresses.length;
430                for (uint i = 0; i < bountyAdresses.length; i++){
431                   token.transfer(bountyAdresses[i], amountofTokens);
432                }
433                bountyTokens = 0;
434     }
435     
436         function distributeDjonniTokens(address addr) onlyOwner crowdsaleIsOver{
437                   token.transfer(addr, djonniTokens);
438                   djonniTokens = 0;
439               
440     }
441     
442     
443     
444 }