1 pragma solidity ^0.4.21;
2 
3 
4 contract ERC20Basic {
5     uint256 public totalSupply;
6     function balanceOf(address who) public constant returns (uint256);
7     function transfer(address to, uint256 value) public returns (bool);
8     event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 
11 
12 /**
13  * @title Ownable
14  * @dev The Ownable contract has an owner address, and provides basic authorization control
15  * functions, this simplifies the implementation of "user permissions".
16  */
17 contract Ownable {
18     address public owner;
19 
20 
21     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23 
24   /**
25    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
26    * account.
27    */
28     constructor() public {
29     owner = msg.sender;
30     }
31 
32   /**
33    * @dev Throws if called by any account other than the owner.
34    */
35   modifier onlyOwner() {
36     require(msg.sender == owner);
37     _;
38   }
39 
40   /**
41    * @dev Allows the current owner to transfer control of the contract to a newOwner.
42    * @param newOwner The address to transfer ownership to.
43    */
44   function transferOwnership(address newOwner) public onlyOwner {
45     require(newOwner != address(0));
46     emit OwnershipTransferred(owner, newOwner);
47     owner = newOwner;
48   }
49 
50 }
51 /**
52  * @title Pausable
53  * @dev Base contract which allows children to implement an emergency stop mechanism.
54  */
55 contract Pausable is Ownable {
56   event Pause();
57   event Unpause();
58 
59   bool public paused = false;
60 
61 
62   /**
63    * @dev Modifier to make a function callable only when the contract is not paused.
64    */
65   modifier whenNotPaused() {
66     require(!paused);
67     _;
68   }
69 
70   /**
71    * @dev Modifier to make a function callable only when the contract is paused.
72    */
73   modifier whenPaused() {
74     require(paused);
75     _;
76   }
77 
78   /**
79    * @dev called by the owner to pause, triggers stopped state
80    */
81   function pause() onlyOwner whenNotPaused public {
82     paused = true;
83     emit Pause();
84   }
85 
86   /**
87    * @dev called by the owner to unpause, returns to normal state
88    */
89   function unpause() onlyOwner whenPaused public {
90     paused = false;
91     emit Unpause();
92   }
93 }
94 
95 /**
96  * @title ERC20 interface
97  * @dev see https://github.com/ethereum/EIPs/issues/20
98  */
99 contract ERC20 is ERC20Basic {
100   function allowance(address owner, address spender) public constant returns (uint256);
101   function transferFrom(address from, address to, uint256 value) public returns (bool);
102   function approve(address spender, uint256 value) public returns (bool);
103   event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 library SafeMath {
107   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
108     uint256 c = a * b;
109     assert(a == 0 || c / a == b);
110     return c;
111   }
112 
113   function div(uint256 a, uint256 b) internal pure returns (uint256) {
114     // assert(b > 0); // Solidity automatically throws when dividing by 0
115     uint256 c = a / b;
116     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
117     return c;
118   }
119 
120   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121     assert(b <= a);
122     return a - b;
123   }
124 
125   function add(uint256 a, uint256 b) internal pure returns (uint256) {
126     uint256 c = a + b;
127     assert(c >= a);
128     return c;
129   }
130 }
131 
132 /**
133  * @title Basic token
134  * @dev Basic version of StandardToken, with no allowances.
135  */
136 contract BasicToken is ERC20Basic {
137   using SafeMath for uint256;
138 
139   mapping(address => uint256) balances;
140 
141   /**
142   * @dev transfer token for a specified address
143   * @param _to The address to transfer to.
144   * @param _value The amount to be transferred.
145   */
146   function transfer(address _to, uint256 _value) public returns (bool) {
147     require(_to != address(0x0));
148 
149     // SafeMath.sub will throw if there is not enough balance.
150     balances[msg.sender] = balances[msg.sender].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     emit Transfer(msg.sender, _to, _value);
153     return true;
154   }
155 
156   /**
157   * @dev Gets the balance of the specified address.
158   * @param _owner The address to query the the balance of.
159   * @return An uint256 representing the amount owned by the passed address.
160   */
161   function balanceOf(address _owner) public constant returns (uint256 balance) {
162     return balances[_owner];
163   }
164 
165 }
166 
167 
168 /**
169  * @title Standard ERC20 token
170  *
171  * @dev Implementation of the basic standard token.
172  * @dev https://github.com/ethereum/EIPs/issues/20
173  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
174  */
175 contract StandardToken is ERC20, BasicToken, Pausable {
176 
177   mapping (address => mapping (address => uint256)) allowed;
178 
179 
180   /**
181    * @dev Transfer tokens from one address to another
182    * @param _from address The address which you want to send tokens from
183    * @param _to address The address which you want to transfer to
184    * @param _value uint256 the amount of tokens to be transferred
185    */
186   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
187     require(_to != address(0x0));
188 
189     uint256 _allowance = allowed[_from][msg.sender];
190 
191     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
192     // require (_value <= _allowance);
193 
194     balances[_from] = balances[_from].sub(_value);
195     balances[_to] = balances[_to].add(_value);
196     allowed[_from][msg.sender] = _allowance.sub(_value);
197     emit Transfer(_from, _to, _value);
198     return true;
199   }
200 
201   
202   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
203     allowed[msg.sender][_spender] = _value;
204     emit Approval(msg.sender, _spender, _value);
205     return true;
206   }
207 
208   function allowance(address _owner, address _spender) public constant whenNotPaused returns (uint256 remaining) {
209     return allowed[_owner][_spender];
210   }
211 
212   
213   function increaseApproval (address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
214     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
215     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219   function decreaseApproval (address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
220     uint oldValue = allowed[msg.sender][_spender];
221     if (_subtractedValue > oldValue) {
222       allowed[msg.sender][_spender] = 0;
223     } else {
224       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
225     }
226     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
227     return true;
228   }
229 
230 }
231 
232 contract Ludcoin is StandardToken {
233     using SafeMath for uint256;
234 
235     //Information coin
236     string public name = "Ludcoin";
237     string public symbol = "LUD";
238     uint256 public decimals = 18;
239     uint256 public totalSupply = 800000000 * (10 ** decimals); //800 000 000 LUD
240 
241     //Adress informated in white paper 
242     address public walletETH;               //Wallet ETH
243     address public contractAddress = this;  //6%
244     address public tokenSale;               //67%
245     address public company;                 //20%
246     address public bounty;                  //2%
247     address public gamesFund;               //5%       
248 
249     //Utils ICO   
250     uint256 public icoStage = 0;        
251     uint256 public tokensSold = 0;          //total number of tokens sold
252     uint256 public totalRaised = 0;         //total amount of money raised in wei
253     uint256 public totalTokenToSale = 0;
254     uint256 public rate = 2700;             //LUD/ETH rate / initial 50%
255     bool public pauseEmergence = false;     //the owner address can set this to true to halt the crowdsale due to emergency
256     
257 
258     //Time Start and Time end
259     uint256 public icoStartTimestampStage = 1525132800;       //05/01/2018 @ 00:00am (UTC)
260     uint256 public icoEndTimestampStage = 1543622399;         //11/30/2018 @ 11:59pm (UTC)
261 
262 // =================================== Events ================================================
263 
264     event Burn(address indexed burner, uint256 value);  
265 
266 
267 // =================================== Constructor =============================================
268        
269     constructor() public {         
270       walletETH = 0x7573791105bfB3c0329A3a1DDa7Eb2D01B61Fb7D;
271       tokenSale = 0x21f8784cA7065ad252e1401208B153d5b7a740d1;        //67% (total sale + bonus)
272       company = 0x8185ae2Da7891557C622Fb23C431A9cf7DF6E457;          //20%
273       bounty = 0x80c4933a9a614e7671D52Fd218d2EB29412bf584;           //2%
274       gamesFund = 0x413cF71fB3E7dAf8c8Af21E40429E7315196E3d1;        //5% 
275 
276       //Distribution Token  
277       balances[tokenSale] = totalSupply.mul(67).div(100);            //totalSupply * 67%
278       balances[company] = totalSupply.mul(20).div(100);              //totalSupply * 20%
279       balances[gamesFund] = totalSupply.mul(5).div(100);             //totalSupply * 5%   
280       balances[bounty] = totalSupply.mul(2).div(100);                //totalSupply * 2%
281       balances[contractAddress] = totalSupply.mul(6).div(100);       //totalSupply * 6%(3% team + 3% advisors)
282       
283      
284       //set token to sale
285       totalTokenToSale = balances[tokenSale];           
286     }
287 
288  // ======================================== Modifier ==================================================
289 
290     modifier acceptsFunds() {   
291         require(now >= icoStartTimestampStage);          
292         require(now <= icoEndTimestampStage); 
293         _;
294     }    
295 
296     modifier nonZeroBuy() {
297         require(msg.value > 0);
298         _;
299 
300     }
301 
302     modifier PauseEmergence {
303         require(!pauseEmergence);
304        _;
305     } 
306 
307 //========================================== Functions ===========================================================================
308 
309     /// fallback function to buy tokens
310     function () PauseEmergence nonZeroBuy acceptsFunds payable public {  
311         uint256 amount = msg.value.mul(rate);
312         
313         assignTokens(msg.sender, amount);
314         totalRaised = totalRaised.add(msg.value);
315         forwardFundsToWallet();
316     } 
317 
318     function forwardFundsToWallet() internal {
319         // immediately send Ether to wallet address, propagates exception if execution fails        
320         walletETH.transfer(msg.value); 
321     }
322 
323     function assignTokens(address recipient, uint256 amount) internal {
324         uint256 amountTotal = amount;
325         
326         if (icoStage > 0) {
327             amountTotal = amountTotal + amountTotal.mul(2).div(100);    
328         }
329         
330         balances[tokenSale] = balances[tokenSale].sub(amountTotal);   
331         balances[recipient] = balances[recipient].add(amountTotal);
332         tokensSold = tokensSold.add(amountTotal);        
333        
334         //test token sold, if it was sold more than the total available right total token total
335         if (tokensSold > totalTokenToSale) {
336             uint256 diferenceTotalSale = totalTokenToSale.sub(tokensSold);
337             totalTokenToSale = tokensSold;
338             totalSupply = tokensSold.add(diferenceTotalSale);
339         }
340         
341         emit Transfer(0x0, recipient, amountTotal);
342     }  
343 
344     function manuallyAssignTokens(address recipient, uint256 amount) public onlyOwner {
345         require(tokensSold < totalSupply);
346         assignTokens(recipient, amount);
347     }
348 
349     function setRate(uint256 _rate) public onlyOwner { 
350         require(_rate > 0);               
351         rate = _rate;        
352     }
353 
354     function setIcoStage(uint256 _icoStage) public onlyOwner {    
355         require(_icoStage >= 0); 
356         require(_icoStage <= 4);             
357         icoStage = _icoStage;        
358     }
359 
360     function setPauseEmergence() public onlyOwner {        
361         pauseEmergence = true;
362     }
363 
364     function setUnPauseEmergence() public onlyOwner {        
365         pauseEmergence = false;
366     }   
367 
368     function sendTokenTeamAdvisor(address walletTeam, address walletAdvisors ) public onlyOwner {
369         //test deadline to request token
370         require(now >= icoEndTimestampStage);
371         require(walletTeam != 0x0);
372         require(walletAdvisors != 0x0);
373         
374         uint256 amount = 24000000 * (10 ** decimals);
375         
376         //send tokens 
377         balances[contractAddress] = 0;
378         balances[walletTeam] = balances[walletTeam].add(amount);
379         balances[walletAdvisors] = balances[walletAdvisors].add(amount);
380         
381         emit Transfer(contractAddress, walletTeam, amount);
382         emit Transfer(contractAddress, walletAdvisors, amount);
383     }
384 
385     function burn(uint256 _value) public whenNotPaused {
386         require(_value > 0);
387 
388         address burner = msg.sender;
389         balances[burner] = balances[burner].sub(_value);
390         totalSupply = totalSupply.sub(_value);
391         emit Burn(burner, _value);
392     }   
393     
394 }