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
232 contract Leaxcoin is StandardToken {
233     using SafeMath for uint256;
234 
235     //Information coin
236     string public name = "Leaxcoin";
237     string public symbol = "LEAX";
238     uint256 public decimals = 18;
239     uint256 public totalSupply = 2000000000 * (10 ** decimals); //2 000 000 000 LEAX
240 
241     //Adress informated in white paper 
242     address public walletETH;               //Wallet ETH
243     address public contractAddress = this;  //12%  Team
244     address public tokenSale;               //50%  ICO    
245     address public bounty;                  //15%  bounty
246     address public awardsReservations;      //23%  awards plataforma view in whitepaper  
247     
248 
249     //Utils ICO   
250     uint256 public tokensSold = 0;          //total number of tokens sold
251     uint256 public totalRaised = 0;         //total amount of money raised in wei
252     uint256 public totalTokenToSale = 0;
253     uint256 public rate = 10000;             //LEAX/ETH rate
254     bool public pauseEmergence = false;     //the owner address can set this to true to halt the crowdsale due to emergency
255     
256 
257     //Time Start and Time end
258     uint256 public icoStartTimestampStage = 1532563200;             //07/26/2018 @ 12:00am (UTC)
259     uint256 public icoEndTimestampStage = 1540598399;               //10/26/2018 @ 11:59pm (UTC)
260     uint256 public tokensTeamBlockedTimestamp = 1572134399;         //10/26/2019 @ 11:59pm (UTC)
261 
262 // =================================== Events ================================================
263 
264     event Burn(address indexed burner, uint256 value);  
265 
266 
267 // =================================== Constructor =============================================
268        
269     constructor() public {         
270       walletETH = 0x4B8353Df6F3a0775C4a428453eCF5289867005c2;
271       tokenSale = 0x9eEb17dcC7494A40876b5e91a97Ec7BdFD1eb83D;                 //50%     
272       bounty = 0x16F96C97487e27003cE1Ce37d7C95ab3E11BD6fe;                    //15%
273       awardsReservations = 0x9Be9a6bA9Bc24c87DbC97F01594E81Ec4cFC5008;        //23% 
274 
275       //Distribution Token  
276       balances[tokenSale] = totalSupply.mul(50).div(100);             //totalSupply * 50%  
277       balances[bounty] = totalSupply.mul(15).div(100);                //totalSupply * 15%
278       balances[contractAddress] = totalSupply.mul(12).div(100);       //totalSupply * 12%
279       balances[awardsReservations] = totalSupply.mul(23).div(100);    //totalSupply * 23% 
280      
281       //set token to sale
282       totalTokenToSale = balances[tokenSale];           
283     }
284 
285  // ======================================== Modifier ==================================================
286 
287     modifier acceptsFunds() {   
288         require(now >= icoStartTimestampStage);          
289         require(now <= icoEndTimestampStage); 
290         _;
291     }    
292 
293     modifier nonZeroBuy() {
294         require(msg.value > 0);
295         _;
296 
297     }
298 
299     modifier PauseEmergence {
300         require(!pauseEmergence);
301        _;
302     } 
303 
304 //========================================== Functions ===========================================================================
305 
306     /// fallback function to buy tokens
307     function () PauseEmergence nonZeroBuy acceptsFunds payable public {  
308         uint256 amount = msg.value.mul(rate);
309         
310         assignTokens(msg.sender, amount);
311         totalRaised = totalRaised.add(msg.value);
312         forwardFundsToWallet();
313     } 
314 
315     function forwardFundsToWallet() internal {
316         // immediately send Ether to wallet address, propagates exception if execution fails        
317         walletETH.transfer(msg.value); 
318     }
319 
320     function assignTokens(address recipient, uint256 amount) internal {
321         uint256 amountTotal = amount;       
322         
323         balances[tokenSale] = balances[tokenSale].sub(amountTotal);   
324         balances[recipient] = balances[recipient].add(amountTotal);
325         tokensSold = tokensSold.add(amountTotal);        
326        
327         //test token sold, if it was sold more than the total available right total token total
328         if (tokensSold > totalTokenToSale) {
329             uint256 diferenceTotalSale = totalTokenToSale.sub(tokensSold);
330             totalTokenToSale = tokensSold;
331             totalSupply = tokensSold.add(diferenceTotalSale);
332         }
333         
334         emit Transfer(0x0, recipient, amountTotal);
335     }  
336 
337     function manuallyAssignTokens(address recipient, uint256 amount) public onlyOwner {
338         require(tokensSold < totalSupply);
339         assignTokens(recipient, amount);
340     }
341 
342     function setRate(uint256 _rate) public onlyOwner { 
343         require(_rate > 0);               
344         rate = _rate;        
345     }
346 
347     function setPauseEmergence() public onlyOwner {        
348         pauseEmergence = true;
349     }
350 
351     function setUnPauseEmergence() public onlyOwner {        
352         pauseEmergence = false;
353     }   
354 
355     function sendTokenTeamAdvisor(address walletTeam) public onlyOwner {
356         //test deadline to request token
357         require(now >= tokensTeamBlockedTimestamp);
358         require(walletTeam != 0x0);       
359         
360         uint256 amount = 240000000 * (10 ** decimals);
361         
362         //send tokens 
363         balances[contractAddress] = 0;
364         balances[walletTeam] = balances[walletTeam].add(amount);       
365         
366         emit Transfer(contractAddress, walletTeam, amount);
367     }
368 
369     function burn(uint256 _value) public whenNotPaused {
370         require(_value > 0);
371 
372         address burner = msg.sender;
373         balances[burner] = balances[burner].sub(_value);
374         totalSupply = totalSupply.sub(_value);
375         emit Burn(burner, _value);
376     }   
377     
378 }