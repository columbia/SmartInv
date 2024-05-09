1 pragma solidity 0.4.25;
2 
3 /*
4  __      __          ___                                          ______                     
5 /\ \  __/\ \        /\_ \                                        /\__  _\                    
6 \ \ \/\ \ \ \     __\//\ \     ___    ___     ___ ___      __    \/_/\ \/   ___              
7  \ \ \ \ \ \ \  /'__`\\ \ \   /'___\ / __`\ /' __` __`\  /'__`\     \ \ \  / __`\            
8   \ \ \_/ \_\ \/\  __/ \_\ \_/\ \__//\ \L\ \/\ \/\ \/\ \/\  __/      \ \ \/\ \L\ \__  __  __ 
9    \ `\___x___/\ \____\/\____\ \____\ \____/\ \_\ \_\ \_\ \____\      \ \_\ \____/\_\/\_\/\_\
10     '\/__//__/  \/____/\/____/\/____/\/___/  \/_/\/_/\/_/\/____/       \/_/\/___/\/_/\/_/\/_/
11                                                                                              
12 
13 
14 __/\\\\\\\\\\\\\\\__/\\\\\\\\\\\\\\\__/\\\________/\\\_____/\\\\\\\\\____        
15  _\/\\\///////////__\///////\\\/////__\/\\\_____/\\\//____/\\\\\\\\\\\\\__       
16   _\/\\\___________________\/\\\_______\/\\\__/\\\//______/\\\/////////\\\_      
17    _\/\\\\\\\\\\\___________\/\\\_______\/\\\\\\//\\\_____\/\\\_______\/\\\_     
18     _\/\\\///////____________\/\\\_______\/\\\//_\//\\\____\/\\\\\\\\\\\\\\\_    
19      _\/\\\___________________\/\\\_______\/\\\____\//\\\___\/\\\/////////\\\_   
20       _\/\\\___________________\/\\\_______\/\\\_____\//\\\__\/\\\_______\/\\\_  
21        _\/\\\___________________\/\\\_______\/\\\______\//\\\_\/\\\_______\/\\\_ 
22         _\///____________________\///________\///________\///__\///________\///__                                                                                             
23                                                                                              
24                                
25                                                                                              
26 // ----------------------------------------------------------------------------
27 // 'FTKA' token contract, having Crowdsale and Reward functionality
28 //
29 // Contract Owner : 0xef9EcD8a0A2E4b31d80B33E243761f4D93c990a8
30 // Symbol      	  : FTKA
31 // Name           : FTKA
32 // Total supply   : 1,000,000,000  (1 Billion)
33 // Tokens for ICO : 800,000,000   (800 Million)
34 // Tokens to Owner: 200,000,000   (200 Million)
35 // Decimals       : 8
36 //
37 // Copyright © 2018 onwards FTKA. (https://ftka.io)
38 // Contract designed by EtherAuthority (https://EtherAuthority.io)
39 // ----------------------------------------------------------------------------
40     
41     /**
42      * @title SafeMath
43      * @dev Math operations with safety checks that throw on error
44      */
45     library SafeMath {
46       function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47         if (a == 0) {
48           return 0;
49         }
50         uint256 c = a * b;
51         assert(c / a == b);
52         return c;
53       }
54     
55       function div(uint256 a, uint256 b) internal pure returns (uint256) {
56         // assert(b > 0); // Solidity automatically throws when dividing by 0
57         uint256 c = a / b;
58         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59         return c;
60       }
61     
62       function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         assert(b <= a);
64         return a - b;
65       }
66     
67       function add(uint256 a, uint256 b) internal pure returns (uint256) {
68         uint256 c = a + b;
69         assert(c >= a);
70         return c;
71       }
72     }
73     
74     contract owned {
75         address public owner;
76     	
77          constructor () public {
78             owner = msg.sender;
79         }
80     
81         modifier onlyOwner {
82             require(msg.sender == owner);
83             _;
84         }
85     
86         function transferOwnership(address newOwner) onlyOwner public {
87             owner = newOwner;
88         }
89     }
90     
91     interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
92     
93     contract TokenERC20 {
94         // Public variables of the token
95         using SafeMath for uint256;
96     	string public name;
97         string public symbol;
98         uint8 public decimals = 8;      // 18 decimals is the strongly suggested default, avoid changing it
99         uint256 public totalSupply;
100         uint256 public reservedForICO;
101     
102         // This creates an array with all balances
103         mapping (address => uint256) public balanceOf;
104         mapping (address => mapping (address => uint256)) public allowance;
105     
106         // This generates a public event on the blockchain that will notify clients
107         event Transfer(address indexed from, address indexed to, uint256 value);
108     
109         // This notifies clients about the amount burnt
110         event Burn(address indexed from, uint256 value);
111     
112         /**
113          * Constrctor function
114          *
115          * Initializes contract with initial supply tokens to the creator of the contract
116          */
117         constructor (
118             uint256 initialSupply,
119             uint256 allocatedForICO,
120             string tokenName,
121             string tokenSymbol
122         ) public {
123             totalSupply = initialSupply.mul(1e8);               // Update total supply with the decimal amount
124             reservedForICO = allocatedForICO.mul(1e8);          // Tokens reserved For ICO
125             balanceOf[this] = reservedForICO;                   // 800 Million Tokens will remain in the contract
126             balanceOf[msg.sender]=totalSupply.sub(reservedForICO); // Rest of tokens will be sent to owner
127             name = tokenName;                                   // Set the name for display purposes
128             symbol = tokenSymbol;                               // Set the symbol for display purposes
129         }
130     
131         /**
132          * Internal transfer, only can be called by this contract
133          */
134         function _transfer(address _from, address _to, uint _value) internal {
135             // Prevent transfer to 0x0 address. Use burn() instead
136             require(_to != 0x0);
137             // Check if the sender has enough
138             require(balanceOf[_from] >= _value);
139             // Check for overflows
140             require(balanceOf[_to].add(_value) > balanceOf[_to]);
141             // Save this for an assertion in the future
142             uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
143             // Subtract from the sender
144             balanceOf[_from] = balanceOf[_from].sub(_value);
145             // Add the same to the recipient
146             balanceOf[_to] = balanceOf[_to].add(_value);
147             emit Transfer(_from, _to, _value);
148             // Asserts are used to use static analysis to find bugs in your code. They should never fail
149             assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
150         }
151     
152         /**
153          * Transfer tokens
154          *
155          * Send `_value` tokens to `_to` from your account
156          *
157          * @param _to The address of the recipient
158          * @param _value the amount to send
159          */
160         function transfer(address _to, uint256 _value) public {
161             _transfer(msg.sender, _to, _value);
162         }
163     
164         /**
165          * Transfer tokens from other address
166          *
167          * Send `_value` tokens to `_to` in behalf of `_from`
168          *
169          * @param _from The address of the sender
170          * @param _to The address of the recipient
171          * @param _value the amount to send
172          */
173         function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
174             require(_value <= allowance[_from][msg.sender]);     // Check allowance
175             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
176             _transfer(_from, _to, _value);
177             return true;
178         }
179     
180         /**
181          * Set allowance for other address
182          *
183          * Allows `_spender` to spend no more than `_value` tokens in your behalf
184          *
185          * @param _spender The address authorized to spend
186          * @param _value the max amount they can spend
187          */
188         function approve(address _spender, uint256 _value) public
189             returns (bool success) {
190             allowance[msg.sender][_spender] = _value;
191             return true;
192         }
193     
194         /**
195          * Set allowance for other address and notify
196          *
197          * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
198          *
199          * @param _spender The address authorized to spend
200          * @param _value the max amount they can spend
201          * @param _extraData some extra information to send to the approved contract
202          */
203         function approveAndCall(address _spender, uint256 _value, bytes _extraData)
204             public
205             returns (bool success) {
206             tokenRecipient spender = tokenRecipient(_spender);
207             if (approve(_spender, _value)) {
208                 spender.receiveApproval(msg.sender, _value, this, _extraData);
209                 return true;
210             }
211         }
212     
213         /**
214          * Destroy tokens
215          *
216          * Remove `_value` tokens from the system irreversibly
217          *
218          * @param _value the amount of money to burn
219          */
220         function burn(uint256 _value) public returns (bool success) {
221             require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
222             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
223             totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
224            emit Burn(msg.sender, _value);
225             return true;
226         }
227     
228         /**
229          * Destroy tokens from other account
230          *
231          * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
232          *
233          * @param _from the address of the sender
234          * @param _value the amount of money to burn
235          */
236         function burnFrom(address _from, uint256 _value) public returns (bool success) {
237             require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
238             require(_value <= allowance[_from][msg.sender]);    // Check allowance
239             balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
240             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
241             totalSupply = totalSupply.sub(_value);                              // Update totalSupply
242           emit  Burn(_from, _value);
243             return true;
244         }
245     }
246     
247     /****************************************************/
248     /*       MAIN FTKA TOKEN CONTRACT STARTS HERE       */
249     /****************************************************/
250     
251     contract FTKA is owned, TokenERC20 {
252         
253         //**************************************************//
254         //------------- Code for the FTKA Token -------------//
255         //**************************************************//
256         
257         // Public variables of the token
258     	string internal tokenName = "FTKA";
259         string internal tokenSymbol = "FTKA";
260         uint256 internal initialSupply = 1000000000; 	 // 1 Billion   
261         uint256 private allocatedForICO = 800000000;     // 800 Million
262 	
263     	// Records for the fronzen accounts 
264         mapping (address => bool) public frozenAccount;
265     
266         // This generates a public event on the blockchain that will notify clients 
267         event FrozenFunds(address target, bool frozen);
268     
269         // Initializes contract with initial supply of tokens sent to the creator as well as contract 
270         constructor () TokenERC20(initialSupply, allocatedForICO, tokenName, tokenSymbol) public { }
271     
272          
273         /**
274          * Transfer tokens - Internal transfer, only can be called by this contract
275          * 
276          * This checks if the sender or recipient is not fronzen
277          * 
278          * This keeps the track of total token holders and adds new holders as well.
279          *
280          * Send `_value` tokens to `_to` from your account
281          *
282          * @param _from The address of the sender
283          * @param _to The address of the recipient
284          * @param _value the amount of tokens to send
285          */
286         function _transfer(address _from, address _to, uint _value) internal {
287             require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
288             require (balanceOf[_from] >= _value);               // Check if the sender has enough
289             require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
290             require(!frozenAccount[_from]);                     // Check if sender is frozen
291             require(!frozenAccount[_to]);                       // Check if recipient is frozen
292             balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the sender
293             balanceOf[_to] = balanceOf[_to].add(_value);        // Add the same to the recipient
294             emit Transfer(_from, _to, _value);
295         }
296     
297         /**
298          * @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
299          * 
300          * @param target Address to be frozen
301          * @param freeze either to freeze it or not
302          */
303         function freezeAccount(address target, bool freeze) onlyOwner public {
304             frozenAccount[target] = freeze;
305           emit  FrozenFunds(target, freeze);
306         }
307     
308         //**************************************************//
309         //------------- Code for the Crowdsale -------------//
310         //**************************************************//
311     
312         //public variables for the Crowdsale
313         uint256 public icoStartDate = 1542326400 ;      // 16 November 2018 00:00:00 - GMT
314         uint256 public icoEndDate   = 1554076799 ;      // 31 March 2019 23:59:59 - GMT
315         uint256 public exchangeRate = 5000;             // 1 ETH = 5000 Tokens
316         uint256 public tokensSold = 0;                  // How many tokens sold in crowdsale
317         bool internal withdrawTokensOnlyOnce = true;    // Admin can withdraw unsold tokens after ICO only once
318         
319         //public variables of reward distribution 
320         mapping(address => uint256) public investorContribution; //Track record whether token holder exist or not
321         address[] public icoContributors;                   //Array of addresses of ICO contributors
322         uint256 public tokenHolderIndex = 0;                //To split the iterations of For Loop
323         uint256 public totalContributors = 0;               //Total number of ICO contributors
324         
325         
326         /**
327          * @dev Fallback function, it accepts Ether from owner address as well as non-owner address
328          * @dev If ether came from owner address, then it will consider as reward payment to ICO contributors
329          * @dev If ether came from non-owner address, then it will consider as ICO investment contribution
330          */
331 		function () payable public {
332 		    if(msg.sender == owner && msg.value > 0){
333     		    processRewards();   //This function will process reward distribution
334 		    }
335 		    else{
336 		        processICO();       //This function will process ICO and sends tokens to contributor
337 		    }
338 		}
339         
340         /**
341          * @dev Function which processes ICO contributions
342          * @dev It calcualtes token amount from exchangeRate and also adds Bonuses if applicable
343          * @dev Ether will be forwarded to owner immidiately.
344          */
345          function processICO() internal {
346             require(icoEndDate > now);
347     		require(icoStartDate < now);
348     		uint ethervalueWEI=msg.value;
349     		uint256 token = ethervalueWEI.div(1e10).mul(exchangeRate);// token amount = weiamount * price
350     		uint256 totalTokens = token.add(purchaseBonus(token));    // token + bonus
351     		tokensSold = tokensSold.add(totalTokens);
352     		_transfer(this, msg.sender, totalTokens);                 // makes the token transfer
353     		forwardEherToOwner();                                     // send ether to owner
354     		//if contributor does not exist in tokenHolderExist mapping, then add into it as well as add in tokenHolders array
355             if(investorContribution[msg.sender] == 0){
356                 icoContributors.push(msg.sender);
357                 totalContributors++;
358             }
359             investorContribution[msg.sender] = investorContribution[msg.sender].add(totalTokens);
360             
361          }
362          
363          /**
364          * @dev Function which processes ICO contributions
365          * @dev It calcualtes token amount from exchangeRate and also adds Bonuses if applicable
366          * @dev Ether will be forwarded to owner immidiately.
367          */
368          function processRewards() internal {
369              for(uint256 i = 0; i < 150; i++){
370                     if(tokenHolderIndex < totalContributors){
371                         uint256 userContribution = investorContribution[icoContributors[tokenHolderIndex]];
372                         if(userContribution > 0){
373                             uint256 rewardPercentage =  userContribution.mul(1000).div(tokensSold);
374                             uint256 reward = msg.value.mul(rewardPercentage).div(1000);
375                             icoContributors[tokenHolderIndex].transfer(reward);
376                             tokenHolderIndex++;
377                         }
378                     }else{
379                         //this code will run only when all the dividend/reward has been paid
380                         tokenHolderIndex = 0;
381                        break;
382                     }
383                 }
384          }
385         
386         /**
387          * Automatocally forwards ether from smart contract to owner address.
388          */
389 		function forwardEherToOwner() internal {
390 			owner.transfer(msg.value); 
391 		}
392 		
393 		/**
394          * @dev Calculates purchase bonus according to the schedule.
395          * @dev SafeMath at some place is not used intentionally as overflow is impossible, and that saves gas cost
396          * 
397          * @param _tokenAmount calculating tokens from amount of tokens 
398          * 
399          * @return bonus amount in wei
400          * 
401          */
402 		function purchaseBonus(uint256 _tokenAmount) public view returns(uint256){
403 		    uint256 week1 = icoStartDate + 604800;    //25% token bonus
404 		    uint256 week2 = week1 + 604800;           //20% token bonus
405 		    uint256 week3 = week2 + 604800;           //15% token bonus
406 		    uint256 week4 = week3 + 604800;           //10% token bonus
407 		    uint256 week5 = week4 + 604800;           //5% token bonus
408 
409 		    if(now > icoStartDate && now < week1){
410 		        return _tokenAmount.mul(25).div(100);   //25% bonus
411 		    }
412 		    else if(now > week1 && now < week2){
413 		        return _tokenAmount.mul(20).div(100);   //20% bonus
414 		    }
415 		    else if(now > week2 && now < week3){
416 		        return _tokenAmount.mul(15).div(100);   //15% bonus
417 		    }
418 		    else if(now > week3 && now < week4){
419 		        return _tokenAmount.mul(10).div(100);   //10% bonus
420 		    }
421 		    else if(now > week4 && now < week5){
422 		        return _tokenAmount.mul(5).div(100);   //5% bonus
423 		    }
424 		    else{
425 		        return 0;
426 		    }
427 		}
428         
429         
430         /**
431          * Function to check wheter ICO is running or not. 
432          * 
433          * @return bool for whether ICO is running or not
434          */
435         function isICORunning() public view returns(bool){
436             if(icoEndDate > now && icoStartDate < now){
437                 return true;                
438             }else{
439                 return false;
440             }
441         }
442         
443         
444         /**
445          * Just in case, owner wants to transfer Tokens from contract to owner address
446          */
447         function manualWithdrawToken(uint256 _amount) onlyOwner public {
448             uint256 tokenAmount = _amount.mul(1 ether);
449             _transfer(this, msg.sender, tokenAmount);
450         }
451           
452         /**
453          * Just in case, owner wants to transfer Ether from contract to owner address
454          */
455         function manualWithdrawEther()onlyOwner public{
456             address(owner).transfer(address(this).balance);
457         }
458         
459     }