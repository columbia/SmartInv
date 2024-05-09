1 pragma solidity ^0.4.16;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8   uint256 public totalSupply;
9   function balanceOf(address who) public constant returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 /**
14  * @title Ownable
15  * @dev The Ownable contract has an owner address, and provides basic authorization control
16  * functions, this simplifies the implementation of "user permissions".
17  */
18 contract Ownable {
19   address public owner;
20   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22 
23   /**
24    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
25    * account.
26    */
27   function Ownable() internal {
28     owner = msg.sender;
29   }
30 
31 
32   /**
33    * @dev Throws if called by any account other than the owner.
34    */
35   modifier onlyOwner() {
36     require(msg.sender == owner);
37     _;
38   }
39 
40 
41   /**
42    * @dev Allows the current owner to transfer control of the contract to a newOwner.
43    * @param newOwner The address to transfer ownership to.
44    */
45   function transferOwnership(address newOwner) onlyOwner public {
46     require(newOwner != address(0));
47     OwnershipTransferred(owner, newOwner);
48     owner = newOwner;
49   }
50 
51 }
52 /**
53  * @title Pausable
54  * @dev Base contract which allows children to implement an emergency stop mechanism.
55  */
56 contract Pausable is Ownable {
57   event Pause();
58   event Unpause();
59 
60   bool public paused = false;
61 
62 
63   /**
64    * @dev Modifier to make a function callable only when the contract is not paused.
65    */
66   modifier whenNotPaused() {
67     require(!paused);
68     _;
69   }
70 
71   /**
72    * @dev Modifier to make a function callable only when the contract is paused.
73    */
74   modifier whenPaused() {
75     require(paused);
76     _;
77   }
78 
79   /**
80    * @dev called by the owner to pause, triggers stopped state
81    */
82   function pause() onlyOwner whenNotPaused public {
83     paused = true;
84     Pause();
85   }
86 
87   /**
88    * @dev called by the owner to unpause, returns to normal state
89    */
90   function unpause() onlyOwner whenPaused public {
91     paused = false;
92     Unpause();
93   }
94 }
95 
96 /**
97  * @title ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/20
99  */
100 contract ERC20 is ERC20Basic {
101   function allowance(address owner, address spender) public constant returns (uint256);
102   function transferFrom(address from, address to, uint256 value) public returns (bool);
103   function approve(address spender, uint256 value) public returns (bool);
104   event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 library SafeMath {
108   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
109     uint256 c = a * b;
110     assert(a == 0 || c / a == b);
111     return c;
112   }
113 
114   function div(uint256 a, uint256 b) internal pure returns (uint256) {
115     // assert(b > 0); // Solidity automatically throws when dividing by 0
116     uint256 c = a / b;
117     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118     return c;
119   }
120 
121   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122     assert(b <= a);
123     return a - b;
124   }
125 
126   function add(uint256 a, uint256 b) internal pure returns (uint256) {
127     uint256 c = a + b;
128     assert(c >= a);
129     return c;
130   }
131 }
132 
133 /**
134  * @title Basic token
135  * @dev Basic version of StandardToken, with no allowances.
136  */
137 contract BasicToken is ERC20Basic {
138   using SafeMath for uint256;
139 
140   mapping(address => uint256) balances;
141 
142   /**
143   * @dev transfer token for a specified address
144   * @param _to The address to transfer to.
145   * @param _value The amount to be transferred.
146   */
147   function transfer(address _to, uint256 _value) public returns (bool) {
148     require(_to != address(0x0));
149 
150     // SafeMath.sub will throw if there is not enough balance.
151     balances[msg.sender] = balances[msg.sender].sub(_value);
152     balances[_to] = balances[_to].add(_value);
153     Transfer(msg.sender, _to, _value);
154     return true;
155   }
156 
157   /**
158   * @dev Gets the balance of the specified address.
159   * @param _owner The address to query the the balance of.
160   * @return An uint256 representing the amount owned by the passed address.
161   */
162   function balanceOf(address _owner) public constant returns (uint256 balance) {
163     return balances[_owner];
164   }
165 
166 }
167 
168 
169 /**
170  * @title Standard ERC20 token
171  *
172  * @dev Implementation of the basic standard token.
173  * @dev https://github.com/ethereum/EIPs/issues/20
174  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
175  */
176 contract StandardToken is ERC20, BasicToken, Pausable {
177 
178   mapping (address => mapping (address => uint256)) allowed;
179 
180 
181   /**
182    * @dev Transfer tokens from one address to another
183    * @param _from address The address which you want to send tokens from
184    * @param _to address The address which you want to transfer to
185    * @param _value uint256 the amount of tokens to be transferred
186    */
187   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
188     require(_to != address(0x0));
189 
190     uint256 _allowance = allowed[_from][msg.sender];
191 
192     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
193     // require (_value <= _allowance);
194 
195     balances[_from] = balances[_from].sub(_value);
196     balances[_to] = balances[_to].add(_value);
197     allowed[_from][msg.sender] = _allowance.sub(_value);
198     Transfer(_from, _to, _value);
199     return true;
200   }
201 
202   
203   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
204     allowed[msg.sender][_spender] = _value;
205     Approval(msg.sender, _spender, _value);
206     return true;
207   }
208 
209   function allowance(address _owner, address _spender) public constant whenNotPaused returns (uint256 remaining) {
210     return allowed[_owner][_spender];
211   }
212 
213   
214   function increaseApproval (address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
215     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
216     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217     return true;
218   }
219 
220   function decreaseApproval (address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
221     uint oldValue = allowed[msg.sender][_spender];
222     if (_subtractedValue > oldValue) {
223       allowed[msg.sender][_spender] = 0;
224     } else {
225       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
226     }
227     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228     return true;
229   }
230 
231 }
232 
233 contract JubsICO is StandardToken {
234     using SafeMath for uint256;
235 
236     //Information coin
237     string public name = "Honor";
238     string public symbol = "HNR";
239     uint256 public decimals = 18;
240     uint256 public totalSupply = 100000000 * (10 ** decimals); //100 000 000 HNR
241 
242     //Adress informated in white paper 
243     address public walletETH;                           //Wallet ETH
244     address public icoWallet;                           //63%
245     address public preIcoWallet;                        //7%
246     address public teamWallet;                          //10%
247     address public bountyMktWallet;                     //7%
248     address public arbitrationWallet;                   //5%
249     address public rewardsWallet;                       //5%
250     address public advisorsWallet;                      //2%
251     address public operationWallet;                     //1%       
252 
253     //Utils ICO   
254     uint256 public icoStage = 0;        
255     uint256 public tokensSold = 0;                      // total number of tokens sold
256     uint256 public totalRaised = 0;                     // total amount of money raised in wei
257     uint256 public totalTokenToSale = 0;
258     uint256 public rate = 8500;                         // HNR/ETH rate / initial 50%
259     bool public pauseEmergence = false;                 //the owner address can set this to true to halt the crowdsale due to emergency
260     
261 
262     //Time Start and Time end
263     //Stage pre sale 
264                                                                 
265  
266     uint256 public icoStartTimestampStage = 1515974400;         //15/01/2018 @ 00:00am (UTC)
267     uint256 public icoEndTimestampStage = 1518998399;           //18/02/2018 @ 11:59pm (UTC)
268 
269     //Stage 1                                                   //25%
270     uint256 public icoStartTimestampStage1 = 1518998400;        //19/02/2018 @ 00:00am (UTC)
271     uint256 public icoEndTimestampStage1 = 1519603199;          //25/02/2018 @ 11:59pm (UTC)
272 
273     //Stage 2                                                   //20%
274     uint256 public icoStartTimestampStage2 = 1519603200;        //26/02/2018 @ 00:00am (UTC)
275     uint256 public icoEndTimestampStage2 = 1520207999;          //04/03/2018 @ 11:59pm (UTC)
276 
277     //Stage 3                                                   //15%
278     uint256 public icoStartTimestampStage3 = 1520208000;        //05/03/2018 @ 00:00am (UTC)
279     uint256 public icoEndTimestampStage3 = 1520812799;          //11/03/2018 @ 11:59pm (UTC)
280 
281     //Stage 4                                                   //10%
282     uint256 public icoStartTimestampStage4 = 1520812800;        //12/03/2018 @ 00:00am (UTC)
283     uint256 public icoEndTimestampStage4 = 1521417599;          //18/03/2018 @ 11:59pm (UTC)
284 
285     //end of the waiting time for the team to withdraw 
286     uint256 public teamEndTimestamp = 1579046400;               //01/15/2020 @ 12:00am (UTC) 
287                                                                 
288 
289 // =================================== Events ================================================
290 
291     event Burn(address indexed burner, uint256 value);  
292 
293 
294 // =================================== Constructor =============================================
295        
296     function JubsICO ()public {                 
297       //Address
298       walletETH = 0x6eA3ec9339839924a520ff57a0B44211450A8910;
299       icoWallet = 0x357ace6312BF8B519424cD3FfdBB9990634B8d3E;
300       preIcoWallet = 0x7c54dC4F3328197AC89a53d4b8cDbE35a56656f7;
301       teamWallet = 0x06BC5305016E9972F4cB3F6a3Ef2C734D417788a;
302       bountyMktWallet = 0x6f67b977859deE77fE85cBCAD5b5bd5aD58bF068;
303       arbitrationWallet = 0xdE9DE3267Cbd21cd64B40516fD2Aaeb5D77fb001;
304       rewardsWallet = 0x232f7CaA500DCAd6598cAE4D90548a009dd49e6f;
305       advisorsWallet = 0xA6B898B2Ab02C277Ae7242b244FB5FD55cAfB2B7;
306       operationWallet = 0x96819778cC853488D3e37D630d94A337aBd527A8;
307 
308       //Distribution Token  
309       balances[icoWallet] = totalSupply.mul(63).div(100);                 //totalSupply * 63%
310       balances[preIcoWallet] = totalSupply.mul(7).div(100);               //totalSupply * 7%
311       balances[teamWallet] = totalSupply.mul(10).div(100);                //totalSupply * 10%
312       balances[bountyMktWallet] = totalSupply.mul(7).div(100);            //totalSupply * 7%
313       balances[arbitrationWallet] = totalSupply.mul(5).div(100);          //totalSupply * 5%
314       balances[rewardsWallet] = totalSupply.mul(5).div(100);              //totalSupply * 5%
315       balances[advisorsWallet] = totalSupply.mul(2).div(100);             //totalSupply * 2%
316       balances[operationWallet] = totalSupply.mul(1).div(100);            //totalSupply * 1%      
317 
318       //set pause
319       pause();
320 
321       //set token to sale
322       totalTokenToSale = balances[icoWallet].add(balances[preIcoWallet]);           
323     }
324 
325  // ======================================== Modifier ==================================================
326 
327     modifier acceptsFunds() {   
328         if (icoStage == 0) {
329             require(msg.value >= 1 ether);
330             require(now >= icoStartTimestampStage);          
331             require(now <= icoEndTimestampStage); 
332         }
333 
334         if (icoStage == 1) {
335             require(now >= icoStartTimestampStage1);          
336             require(now <= icoEndTimestampStage1);            
337         }
338 
339         if (icoStage == 2) {
340             require(now >= icoStartTimestampStage2);          
341             require(now <= icoEndTimestampStage2);            
342         }
343 
344         if (icoStage == 3) {
345             require(now >= icoStartTimestampStage3);          
346             require(now <= icoEndTimestampStage3);            
347         }
348 
349         if (icoStage == 4) {
350             require(now >= icoStartTimestampStage4);          
351             require(now <= icoEndTimestampStage4);            
352         }             
353                
354         _;
355     }    
356 
357     modifier nonZeroBuy() {
358         require(msg.value > 0);
359         _;
360 
361     }
362 
363     modifier PauseEmergence {
364         require(!pauseEmergence);
365        _;
366     } 
367 
368 
369 //========================================== Functions ===========================================================================
370 
371     /// fallback function to buy tokens
372     function () PauseEmergence nonZeroBuy acceptsFunds payable public {  
373         uint256 amount = msg.value.mul(rate);
374 
375         assignTokens(msg.sender, amount);
376         totalRaised = totalRaised.add(msg.value);
377 
378         forwardFundsToWallet();
379     } 
380 
381     function forwardFundsToWallet() internal {        
382         walletETH.transfer(msg.value);              // immediately send Ether to wallet address, propagates exception if execution fails
383     }
384 
385     function assignTokens(address recipient, uint256 amount) internal {
386         if (icoStage == 0) {
387           balances[preIcoWallet] = balances[preIcoWallet].sub(amount);               
388         }
389         if (icoStage > 0) {
390           balances[icoWallet] = balances[icoWallet].sub(amount);               
391         }
392 
393         balances[recipient] = balances[recipient].add(amount);
394         tokensSold = tokensSold.add(amount);        
395        
396         //test token sold, if it was sold more than the total available right total token total
397         if (tokensSold > totalTokenToSale) {
398             uint256 diferenceTotalSale = totalTokenToSale.sub(tokensSold);
399             totalTokenToSale = tokensSold;
400             totalSupply = tokensSold.add(diferenceTotalSale);
401         }
402         
403         Transfer(0x0, recipient, amount);
404     }  
405     
406 
407     function manuallyAssignTokens(address recipient, uint256 amount) public onlyOwner {
408         require(tokensSold < totalSupply);
409         assignTokens(recipient, amount);
410     }
411 
412     function setRate(uint256 _rate) public onlyOwner { 
413         require(_rate > 0);               
414         rate = _rate;        
415     }
416 
417     function setIcoStage(uint256 _icoStage) public onlyOwner {    
418         require(_icoStage >= 0); 
419         require(_icoStage <= 4);             
420         icoStage = _icoStage;        
421     }
422 
423     function setPauseEmergence() public onlyOwner {        
424         pauseEmergence = true;
425     }
426 
427     function setUnPauseEmergence() public onlyOwner {        
428         pauseEmergence = false;
429     }   
430 
431     function sendTokenTeam(address _to, uint256 amount) public onlyOwner {
432         require(_to != 0x0);
433 
434         //test deadline to request token
435         require(now >= teamEndTimestamp);
436         assignTokens(_to, amount);
437     }
438 
439     function burn(uint256 _value) public whenNotPaused {
440         require(_value > 0);
441 
442         address burner = msg.sender;
443         balances[burner] = balances[burner].sub(_value);
444         totalSupply = totalSupply.sub(_value);
445         Burn(burner, _value);
446     }   
447     
448 }