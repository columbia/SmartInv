1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath for performing valid mathematics.
5  */
6 library SafeMath {
7  
8   function Mul(uint a, uint b) internal pure returns (uint) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function Div(uint a, uint b) internal pure returns (uint) {
15     //assert(b > 0); // Solidity automatically throws when Dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function Sub(uint a, uint b) internal pure returns (uint) {
22     assert(b <= a);
23     return a - b;
24   } 
25 
26   function Add(uint a, uint b) internal pure returns (uint) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   } 
31 }
32 
33 /**
34 * @title Contract that will work with ERC223 tokens.
35 */
36 contract ERC223ReceivingContract { 
37     /**
38      * @dev Standard ERC223 function that will handle incoming token transfers.
39      *
40      * @param _from  Token sender address.
41      * @param _value Amount of tokens.
42      * @param _data  Transaction metadata.
43      */
44     function tokenFallback(address _from, uint _value, bytes _data) public;
45 }
46 
47 /**
48  * Contract "Ownable"
49  * Purpose: Defines Owner for contract and provide functionality to transfer ownership to another account
50  */
51 contract Ownable {
52 
53   //owner variable to store contract owner account
54   address public owner;
55   //add another owner
56   address deployer;
57 
58   //Constructor for the contract to store owner's account on deployement
59   function Ownable() public {
60     owner = msg.sender;
61     deployer = msg.sender;
62   }
63 
64   //modifier to check transaction initiator is only owner
65   modifier onlyOwner() {
66     require (msg.sender == owner || msg.sender == deployer);
67       _;
68   }
69 
70   //ownership can be transferred to provided newOwner. Function can only be initiated by contract owner's account
71   function transferOwnership(address _newOwner) public onlyOwner {
72     require (_newOwner != address(0));
73     owner = _newOwner;
74   }
75 
76 }
77 
78 /**
79  * @title Pausable
80  * @dev Base contract which allows children to implement an emergency stop mechanism.
81  */
82 contract Pausable is Ownable {
83   event Pause();
84   event Unpause();
85 
86   bool public paused = false;
87   uint256 public startTime;
88   uint256 public endTime;
89   uint256 private pauseTime;
90 
91 
92   /**
93    * @dev Modifier to make a function callable only when the contract is not paused.
94    */
95   modifier whenNotPaused() {
96     require(!paused);
97     _;
98   }
99 
100   /**
101    * @dev Modifier to make a function callable only when the contract is paused.
102    */
103   modifier whenPaused() {
104     require(paused);
105     _;
106   }
107 
108   /**
109    * @dev called by the owner to pause, triggers stopped state
110    */
111   function pause() onlyOwner whenNotPaused public {
112     paused = true;
113     //Record the pausing time only if any startTime is defined
114     //in other cases, it will work as a toggle switch only
115     if(startTime > 0){
116         pauseTime = now;
117     }
118     emit Pause();
119   }
120 
121   /**
122    * @dev called by the owner to unpause, returns to normal state
123    */
124   function unpause() onlyOwner whenPaused public {
125     paused = false;
126     //if endTime is defined, only then proceed with its updation
127     if(endTime > 0 && pauseTime > startTime){
128         uint256 pauseDuration = pauseTime - startTime;
129         endTime = endTime + pauseDuration;
130     }
131     emit Unpause();
132   }
133 }
134 
135 /**
136  * @title ERC20 interface
137  */
138 contract ERC20 is Pausable {
139     uint256 public totalSupply;
140     function balanceOf(address _owner) public view returns (uint256 value);
141     function transfer(address _to, uint256 _value) public returns (bool _success);
142     function allowance(address owner, address spender) public view returns (uint256 _value);
143     function transferFrom(address from, address to, uint256 value) public returns (bool _success);
144     function approve(address spender, uint256 value) public returns (bool _success);
145     event Approval(address indexed owner, address indexed spender, uint256 value);
146     event Transfer(address indexed _from, address indexed _to, uint _value);
147 }
148 
149 contract ECHO is ERC20 {
150 
151     using SafeMath for uint256;
152     //The name of the  token
153     string public constant name = "ECHO token";
154     //The token symbol
155     string public constant symbol = "ECHO";
156     //To denote the locking on transfer of tokens among token holders
157     bool public locked;
158     //The precision used in the calculations in contract
159     uint8 public constant decimals = 18;
160     //number of tokens available for 1 eth
161     uint256 public constant PRICE=4000;
162     //maximum number of tokens
163     uint256 constant MAXCAP = 322500000e18;
164     //maximum number of tokens available for Sale
165     uint256 constant HARD_CAP = 8e7*1e18;
166     //the account which will receive all balance
167     address ethCollector;
168     //to save total number of ethers received
169     uint256 public totalWeiReceived;
170     //type of sale: 1=presale, 2=ICO
171     uint256 public saleType;
172     
173 
174     //Mapping to relate owner and spender to the tokens allowed to transfer from owner
175     mapping(address => mapping(address => uint256)) allowed;
176     //Mapping to relate number of token to the account
177     mapping(address => uint256) balances;
178     
179     function isSaleRunning() public view returns (bool){
180         bool status = false;
181         // 1522972800 = 6 april 2018
182         // 1525392000 = 4 may 2018
183         // 1527811200 = 1 june 2018
184         // 1531094400 = 9 july 2018
185         
186         //Presale is going on
187         if(now >= startTime  && now <= 1525392000){
188             //Aprill 6 to before 4 may
189             status = true;
190         }
191     
192         //ICO is going on
193         if(now >= 1527811200 && now <= endTime){
194             // june 1 to before july 9
195             status = true;
196         }
197         return status;
198     }
199 
200     function countDownToEndCrowdsale() public view returns(uint256){
201         assert(isSaleRunning());
202         return endTime.Sub(now);
203     }
204     //events
205     event StateChanged(bool);
206 
207     function ECHO() public{
208         totalSupply = 0;
209         startTime = 1522972800; //April 6, 2018 GMT
210         endTime = 1531094400; //9 july, 2018 GMT
211         locked = true;
212         setEthCollector(0xc8522E0444a94Ec9a5A08242765e1196DF1EC6B5);
213     }
214     //To handle ERC20 short address attack
215     modifier onlyPayloadSize(uint size) {
216         require(msg.data.length >= size + 4);
217         _;
218     }
219 
220     modifier onlyUnlocked() { 
221         require (!locked); 
222         _; 
223     }
224 
225     modifier validTimeframe(){
226         require(isSaleRunning());
227         _;
228     }
229     
230     function setEthCollector(address _ethCollector) public onlyOwner{
231         require(_ethCollector != address(0));
232         ethCollector = _ethCollector;
233     }
234 
235     //To enable transfer of tokens
236     function unlockTransfer() external onlyOwner{
237         locked = false;
238     }
239 
240     /**
241     * @dev Check if the address being passed belongs to a contract
242     *
243     * @param _address The address which you want to verify
244     * @return A bool specifying if the address is that of contract or not
245     */
246     function isContract(address _address) private view returns(bool _isContract){
247         assert(_address != address(0) );
248         uint length;
249         //inline assembly code to check the length of address
250         assembly{
251             length := extcodesize(_address)
252         }
253         if(length > 0){
254             return true;
255         }
256         else{
257             return false;
258         }
259     }
260 
261     /**
262     * @dev Check balance of given account address
263     *
264     * @param _owner The address account whose balance you want to know
265     * @return balance of the account
266     */
267     function balanceOf(address _owner) public view returns (uint256 _value){
268         return balances[_owner];
269     }
270 
271     /**
272     * @dev Transfer sender's token to a given address
273     *
274     * @param _to The address which you want to transfer to
275     * @param _value the amount of tokens to be transferred
276     * @return A bool if the transfer was a success or not
277     */
278     function transfer(address _to, uint _value) onlyUnlocked onlyPayloadSize(2 * 32) public returns(bool _success) {
279         require( _to != address(0) );
280         bytes memory _empty;
281         assert((balances[msg.sender] >= _value) && _value > 0 && _to != address(0));
282         balances[msg.sender] = balances[msg.sender].Sub(_value);
283         balances[_to] = balances[_to].Add(_value);
284         if(isContract(_to)){
285             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
286             receiver.tokenFallback(msg.sender, _value, _empty);
287         }
288         emit Transfer(msg.sender, _to, _value);
289         return true;
290     }
291 
292     /**
293     * @dev Transfer tokens to an address given by sender. To make ERC223 compliant
294     *
295     * @param _to The address which you want to transfer to
296     * @param _value the amount of tokens to be transferred
297     * @param _data additional information of account from where to transfer from
298     * @return A bool if the transfer was a success or not
299     */
300     function transfer(address _to, uint _value, bytes _data) onlyUnlocked onlyPayloadSize(3 * 32) public returns(bool _success) {
301         assert((balances[msg.sender] >= _value) && _value > 0 && _to != address(0));
302         balances[msg.sender] = balances[msg.sender].Sub(_value);
303         balances[_to] = balances[_to].Add(_value);
304         if(isContract(_to)){
305             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
306             receiver.tokenFallback(msg.sender, _value, _data);
307         }
308         emit Transfer(msg.sender, _to, _value);
309         return true;
310         
311     }
312 
313     /**
314     * @dev Transfer tokens from one address to another, for ERC20.
315     *
316     * @param _from The address which you want to send tokens from
317     * @param _to The address which you want to transfer to
318     * @param _value the amount of tokens to be transferred
319     * @return A bool if the transfer was a success or not 
320     */
321     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3*32) public onlyUnlocked returns (bool){
322         bytes memory _empty;
323         assert((_value > 0)
324            && (_to != address(0))
325            && (_from != address(0))
326            && (allowed[_from][msg.sender] >= _value ));
327        balances[_from] = balances[_from].Sub(_value);
328        balances[_to] = balances[_to].Add(_value);
329        allowed[_from][msg.sender] = allowed[_from][msg.sender].Sub(_value);
330        if(isContract(_to)){
331            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
332            receiver.tokenFallback(msg.sender, _value, _empty);
333        }
334        emit Transfer(_from, _to, _value);
335        return true;
336     }
337 
338     /**
339     * @dev Function to check the amount of tokens that an owner has allowed a spender to recieve from owner.
340     *
341     * @param _owner address The address which owns the funds.
342     * @param _spender address The address which will spend the funds.
343     * @return A uint256 specifying the amount of tokens still available for the spender to spend.
344     */
345     function allowance(address _owner, address _spender) public view returns (uint256){
346         return allowed[_owner][_spender];
347     }
348 
349     /**
350     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
351     *
352     * @param _spender The address which will spend the funds.
353     * @param _value The amount of tokens to be spent.
354     */
355     function approve(address _spender, uint256 _value) public returns (bool){
356         if( _value > 0 && (balances[msg.sender] >= _value)){
357             allowed[msg.sender][_spender] = _value;
358             emit Approval(msg.sender, _spender, _value);
359             return true;
360         }
361         else{
362             return false;
363         }
364     }
365 
366     function mintAndTransfer(address beneficiary, uint256 tokensToBeTransferred) public validTimeframe onlyOwner {
367         require(totalSupply.Add(tokensToBeTransferred) <= MAXCAP);
368         totalSupply = totalSupply.Add(tokensToBeTransferred);
369         balances[beneficiary] = balances[beneficiary].Add(tokensToBeTransferred);
370         emit Transfer(0x0, beneficiary ,tokensToBeTransferred);
371     }
372 
373     function getBonus(uint256 _tokensBought)public view returns(uint256){
374         uint256 bonus = 0;
375         /*April 6- April 13 -- 20% 
376         April 14- April 21 -- 10% 
377         April 22 - May 3-- 5% 
378         
379         ICO BONUS WEEKS: 
380         June 1 - June 9 -- 20% 
381         June 10 - June 17 -- 10% 
382         June 18 - June 30 -- 5% 
383         July 1 - July 9 -- No bonus 
384         */
385         // 1522972800 = 6 april 2018
386         // 1523577600 = 13 April 2018
387         // 1523664000 = 14 April 2018
388         // 1524268800 = 21 April 2018
389         // 1524355200 = 22 April 2018
390         // 1525305600 = 3 April 2018
391         // 1525392000 = 4 may 2018
392         // 1527811200 = 1 june 2018
393         // 1528502400 = 9 june 2018
394         // 1528588800 = 10 june 2018
395         // 1529193600 = 17 june 2018
396         // 1529280000 = 18 june 2018
397         // 1530316800 = 30 june 2018
398         // 1530403200 = 1 july 2018
399         // 1531094400 = 9 july 2018
400         if(saleType == 1){
401             //Presale is going on
402             if(now >= 1522972800 && now < 1523664000){
403                 //6 april to before 14 april
404                 bonus = _tokensBought*20/100;
405             }
406             else if(now >= 1523664000 && now < 1524355200){
407                 //14 april to before 22 april
408                 bonus = _tokensBought*10/100;
409             }
410             else if(now >= 1524355200 && now < 1525392000){
411                 //Aprill 22 to before 4 may
412                 bonus = _tokensBought*5/100;
413             }
414         }
415         if(saleType == 2){
416             //ICO is going on
417             if(now >= 1527811200 && now < 1528588800){
418                 // 1 june to before 10 june
419                 bonus = _tokensBought*20/100;
420             }
421             else if(now >= 1528588800 && now < 1529280000){
422                 // june 10 to before june 18
423                 bonus = _tokensBought*10/100;
424             }
425             else if(now >= 1529280000 && now < 1530403200){
426                 // june 18 to before july 1
427                 bonus = _tokensBought*5/100;
428             }
429         }
430         return bonus;
431     }
432     function buyTokens(address beneficiary) internal validTimeframe {
433         uint256 tokensBought = msg.value.Mul(PRICE);
434         tokensBought = tokensBought.Add(getBonus(tokensBought));
435         balances[beneficiary] = balances[beneficiary].Add(tokensBought);
436         totalSupply = totalSupply.Add(tokensBought);
437        
438         assert(totalSupply <= HARD_CAP);
439         totalWeiReceived = totalWeiReceived.Add(msg.value);
440         ethCollector.transfer(msg.value);
441         emit Transfer(0x0, beneficiary, tokensBought);
442     }
443 
444     /**
445     * Finalize the crowdsale
446     */
447     function finalize() public onlyUnlocked onlyOwner {
448         //Make sure Sale is not running
449         //If sale is running, then check if the hard cap has been reached or not
450         assert(!isSaleRunning() || (HARD_CAP.Sub(totalSupply)) <= 1e18);
451         endTime = now;
452 
453         //enable transferring of tokens among token holders
454         locked = false;
455         //Emit event when crowdsale state changes
456         emit StateChanged(true);
457     }
458 
459     function () public payable {
460         buyTokens(msg.sender);
461     }
462 
463     /**
464     * Failsafe drain
465     */
466     function drain() public onlyOwner {
467         owner.transfer(address(this).balance);
468     }
469 }