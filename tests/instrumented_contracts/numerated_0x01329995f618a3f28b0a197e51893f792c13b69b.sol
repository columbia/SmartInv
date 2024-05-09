1 pragma solidity 0.4.25;
2 // ----------------------------------------------------------------------------
3 // 'Easy Life Coin' contract with following features
4 //      => In-built ICO functionality
5 //      => ERC20 Compliance
6 //      => Higher control of ICO by owner
7 //      => selfdestruct functionality
8 //      => SafeMath implementation 
9 //      => Air-drop
10 //      => User whitelisting
11 //      => Minting new tokens by owner
12 //
13 // Deployed to : 0xb36c38Bfe4BD56C780EEa5010aBE93A669c57098
14 // Symbol      : ELC
15 // Name        : Easy Life Coin
16 // Total supply: 100,000,000,000,000  (100 Trillion)
17 // Reserved coins for ICO: 2,500,000,000 ELC (2.5 Billion)
18 // Decimals    : 2
19 //
20 // Copyright (c) 2018 Human Ecological Business Holding International Inc., USA (https://easylifecommunity.com)
21 // Contract designed by Ether Authority (https://EtherAuthority.io)
22 // ----------------------------------------------------------------------------
23    
24 
25 //*******************************************************************//
26 //------------------------ SafeMath Library -------------------------//
27 //*******************************************************************//
28     /**
29      * @title SafeMath
30      * @dev Math operations with safety checks that throw on error
31      */
32     library SafeMath {
33       function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34         if (a == 0) {
35           return 0;
36         }
37         uint256 c = a * b;
38         assert(c / a == b);
39         return c;
40       }
41     
42       function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         // assert(b > 0); // Solidity automatically throws when dividing by 0
44         uint256 c = a / b;
45         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46         return c;
47       }
48     
49       function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         assert(b <= a);
51         return a - b;
52       }
53     
54       function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56         assert(c >= a);
57         return c;
58       }
59     }
60 
61 
62 //*******************************************************************//
63 //------------------ Contract to Manage Ownership -------------------//
64 //*******************************************************************//
65     
66     contract owned {
67         address public owner;
68     	using SafeMath for uint256;
69     	
70          constructor () public {
71             owner = msg.sender;
72         }
73     
74         modifier onlyOwner {
75             require(msg.sender == owner);
76             _;
77         }
78     
79         function transferOwnership(address newOwner) onlyOwner public {
80             owner = newOwner;
81         }
82     }
83     
84     interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
85 
86 
87 //***************************************************************//
88 //------------------ ERC20 Standard Template -------------------//
89 //***************************************************************//
90     
91     contract TokenERC20 {
92         // Public variables of the token
93         using SafeMath for uint256;
94     	string public name;
95         string public symbol;
96         uint8 public decimals = 2; // 18 decimals is the strongly suggested default, avoid changing it
97         uint256 public totalSupply;
98         uint256 public reservedForICO;
99         bool public safeguard = false;  //putting safeguard on will halt all non-owner functions
100     
101         // This creates an array with all balances
102         mapping (address => uint256) public balanceOf;
103         mapping (address => mapping (address => uint256)) public allowance;
104     
105         // This generates a public event on the blockchain that will notify clients
106         event Transfer(address indexed from, address indexed to, uint256 value);
107     
108         // This notifies clients about the amount burnt
109         event Burn(address indexed from, uint256 value);
110     
111         /**
112          * Constrctor function
113          *
114          * Initializes contract with initial supply tokens to the creator of the contract
115          */
116         constructor (
117             uint256 initialSupply,
118             uint256 allocatedForICO,
119             string tokenName,
120             string tokenSymbol
121         ) public {
122             totalSupply = initialSupply.mul(100);       // Update total supply with the decimal amount
123             reservedForICO = allocatedForICO.mul(100);  // Tokens reserved For ICO
124             balanceOf[this] = reservedForICO;           // 2.5 Billion ELC will remain in the contract
125             balanceOf[msg.sender]=totalSupply.sub(reservedForICO); // Rest of tokens will be sent to owner
126             name = tokenName;                           // Set the name for display purposes
127             symbol = tokenSymbol;                       // Set the symbol for display purposes
128         }
129     
130         /**
131          * Internal transfer, only can be called by this contract
132          */
133         function _transfer(address _from, address _to, uint _value) internal {
134             require(!safeguard);
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
160         function transfer(address _to, uint256 _value) public returns (bool success) {
161             _transfer(msg.sender, _to, _value);
162             return true;
163         }
164     
165         /**
166          * Transfer tokens from other address
167          *
168          * Send `_value` tokens to `_to` in behalf of `_from`
169          *
170          * @param _from The address of the sender
171          * @param _to The address of the recipient
172          * @param _value the amount to send
173          */
174         function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
175             require(!safeguard);
176             require(_value <= allowance[_from][msg.sender]);     // Check allowance
177             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
178             _transfer(_from, _to, _value);
179             return true;
180         }
181     
182         /**
183          * Set allowance for other address
184          *
185          * Allows `_spender` to spend no more than `_value` tokens in your behalf
186          *
187          * @param _spender The address authorized to spend
188          * @param _value the max amount they can spend
189          */
190         function approve(address _spender, uint256 _value) public
191             returns (bool success) {
192             require(!safeguard);
193             allowance[msg.sender][_spender] = _value;
194             return true;
195         }
196     
197         /**
198          * Set allowance for other address and notify
199          *
200          * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
201          *
202          * @param _spender The address authorized to spend
203          * @param _value the max amount they can spend
204          * @param _extraData some extra information to send to the approved contract
205          */
206         function approveAndCall(address _spender, uint256 _value, bytes _extraData)
207             public
208             returns (bool success) {
209             require(!safeguard);
210             tokenRecipient spender = tokenRecipient(_spender);
211             if (approve(_spender, _value)) {
212                 spender.receiveApproval(msg.sender, _value, this, _extraData);
213                 return true;
214             }
215         }
216     
217         /**
218          * Destroy tokens
219          *
220          * Remove `_value` tokens from the system irreversibly
221          *
222          * @param _value the amount of money to burn
223          */
224         function burn(uint256 _value) public returns (bool success) {
225             require(!safeguard);
226             require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
227             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
228             totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
229            	emit Burn(msg.sender, _value);
230             return true;
231         }
232     
233         /**
234          * Destroy tokens from other account
235          *
236          * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
237          *
238          * @param _from the address of the sender
239          * @param _value the amount of money to burn
240          */
241         function burnFrom(address _from, uint256 _value) public returns (bool success) {
242             require(!safeguard);
243             require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
244             require(_value <= allowance[_from][msg.sender]);    // Check allowance
245             balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
246             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
247             totalSupply = totalSupply.sub(_value);                              // Update totalSupply
248           	emit  Burn(_from, _value);
249             return true;
250         }
251         
252     }
253     
254 //**********************************************************************//
255 //---------------------  EASY LIFE COIN STARTS HERE --------------------//
256 //**********************************************************************//
257     
258     contract EasyLifeCoin is owned, TokenERC20 {
259     	using SafeMath for uint256;
260     	
261     	/*************************************/
262         /*  User whitelisting functionality  */
263         /*************************************/
264         bool public whitelistingStatus = false;
265         mapping (address => bool) public whitelisted;
266         
267         /**
268          * Change whitelisting status on or off
269          *
270          * When whitelisting is true, then crowdsale will only accept investors who are whitelisted.
271          */
272         function changeWhitelistingStatus() onlyOwner public{
273             if (whitelistingStatus == false){
274 			    whitelistingStatus = true;
275             }
276             else{
277                 whitelistingStatus = false;    
278             }
279 		}
280 		
281 		/**
282          * Whitelist any user address - only Owner can do this
283          *
284          * It will add user address in whitelisted mapping
285          */
286         function whitelistUser(address userAddress) onlyOwner public{
287             require(whitelistingStatus == true);
288             require(userAddress != 0x0);
289             whitelisted[userAddress] = true;
290 		}
291 		
292         
293     	
294     	/*************************************/
295         /* Code for the ERC20 Easy Life Coin */
296         /*************************************/
297     
298     	/* Public variables of the token */
299     	string private tokenName = "Easy Life Coin";
300         string private tokenSymbol = "ELC";
301         uint256 private initialSupply = 100000000000000;    // 100 Trillion
302         uint256 private allocatedForICO = 2500000000;       // 2.5 Billion
303         
304 		
305 		/* Records for the fronzen accounts */
306         mapping (address => bool) public frozenAccount;
307         
308         /* This generates a public event on the blockchain that will notify clients */
309         event FrozenFunds(address target, bool frozen);
310     
311         /* Initializes contract with initial supply tokens to the creator of the contract */
312         constructor () TokenERC20(initialSupply, allocatedForICO, tokenName, tokenSymbol) public {}
313 
314         /* Internal transfer, only can be called by this contract */
315         function _transfer(address _from, address _to, uint _value) internal {
316             require(!safeguard);
317 			require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
318 			require (balanceOf[_from] >= _value);               // Check if the sender has enough
319 			require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
320 			require(!frozenAccount[_from]);                     // Check if sender is frozen
321 			require(!frozenAccount[_to]);                       // Check if recipient is frozen
322 			balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the sender
323 			balanceOf[_to] = balanceOf[_to].add(_value);        // Add the same to the recipient
324 			emit Transfer(_from, _to, _value);
325         }
326         
327 		/// @notice Create `mintedAmount` tokens and send it to `target`
328 		/// @param target Address to receive the tokens
329 		/// @param mintedAmount the amount of tokens it will receive
330 		function mintToken(address target, uint256 mintedAmount) onlyOwner public {
331 			balanceOf[target] = balanceOf[target].add(mintedAmount);
332 			totalSupply = totalSupply.add(mintedAmount);
333 		 	emit Transfer(0, this, mintedAmount);
334 		 	emit Transfer(this, target, mintedAmount);
335 		}
336 
337 		/// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
338 		/// @param target Address to be frozen
339 		/// @param freeze either to freeze it or not
340 		function freezeAccount(address target, bool freeze) onlyOwner public {
341 				frozenAccount[target] = freeze;
342 			emit  FrozenFunds(target, freeze);
343 		}
344 
345 		/******************************/
346 		/* Code for the ELC Crowdsale */
347 		/******************************/
348 		
349 		/* TECHNICAL SPECIFICATIONS:
350 		
351 		=> Pre-sale starts  :  November 01st, 2018
352 		=> ICO will starts  :  January 01st, 2019
353 		=> ICO Ends         :  December 31st, 2019
354 		=> Pre-sale Bonus   :  50%
355 		=> Main ICO Bonuses 
356 		    January 2019    :  40%
357 		    February 2019   :  30%
358 		    March 2019      :  20%
359 		=> Coins reserved for ICO : 2.5 Billion
360 		=> Minimum Contribution: 0.5 ETH (Pre-sale and Main-sale)
361 		=> Token Exchange Rate: 1 ETH = 200 ELC (which equals to 1 Token = ~ $1 at time of deployment)
362 		
363 		*/
364 
365 		//public variables for the Crowdsale
366 		uint256 public preSaleStartDate = 1541059200 ;  // November 1, 2018 8:00:00 AM - GMT
367 		uint256 public icoJanuaryDate = 1546329600 ;    // January 1, 2019 8:00:00 AM - GMT
368 		uint256 public icoFabruaryDate = 1549008000 ;   // Fabruary 1, 2019 8:00:00 AM - GMT
369 		uint256 public icoMarchDate = 1551427200 ;      // March 1, 2019 8:00:00 AM - GMT
370 		uint256 public icoAprilDate = 1554076800 ;      // April 1, 2019 0:00:00 AM - GMT - End of the bonus
371 		uint256 public icoEndDate = 1577836740 ;        // December 31, 2019 11:59:00 PM - GMT
372 		uint256 public exchangeRate = 200;              // 1 ETH = 200 Tokens 
373 		uint256 public tokensSold = 0;                  // how many tokens sold through crowdsale
374 		uint256 public minimumContribution = 50;        // Minimum amount to invest - 0.5 ETH (in 2 decimal format)
375 
376 		//@dev fallback function, only accepts ether if pre-sale or ICO is running or Reject
377 		function () payable public {
378 		    require(!safeguard);
379 		    require(!frozenAccount[msg.sender]);
380 		    if(whitelistingStatus == true) { require(whitelisted[msg.sender]); }
381 			require(preSaleStartDate < now);
382 			require(icoEndDate > now);
383             require(msg.value.mul(100).div(1 ether)  >= minimumContribution);   //converting msg.value wei into 2 decimal format
384 			// calculate token amount to be sent
385 			uint256 token = msg.value.mul(100).div(1 ether).mul(exchangeRate);  //weiamount * exchangeRate
386 			uint256 finalTokens = token.add(calculatePurchaseBonus(token));     //add bonus if available
387 			tokensSold = tokensSold.add(finalTokens);
388 			_transfer(this, msg.sender, finalTokens);                           //makes the transfers
389 			forwardEherToOwner();                                               //send Ether to owner
390 		}
391 
392         
393 		//calculating purchase bonus
394 		function calculatePurchaseBonus(uint256 token) internal view returns(uint256){
395 		    if(preSaleStartDate < now && icoJanuaryDate > now){
396 		        return token.mul(50).div(100);  //50% bonus if pre-sale is on
397 		    }
398 		    else if(icoJanuaryDate < now && icoFabruaryDate > now){
399 		        return token.mul(40).div(100);  //40% bonus in January 2019
400 		    }
401 		    else if(icoFabruaryDate < now && icoMarchDate > now){
402 		        return token.mul(30).div(100);  //30% bonus in Fabruary 2019
403 		    }
404 		    else if(icoMarchDate < now && icoAprilDate > now){
405 		        return token.mul(20).div(100);  //20% bonus in March 2019
406 		    }
407 		    else{
408 		        return 0;                       // No bonus from April 2019
409 		    }
410 		}
411 
412 		//Automatocally forwards ether from smart contract to owner address
413 		function forwardEherToOwner() internal {
414 			owner.transfer(msg.value); 
415 		}
416 
417 		//Function to update an ICO parameter.
418 		//It requires: timestamp of start and end date, exchange rate (1 ETH = ? Tokens)
419 		//Owner need to make sure the contract has enough tokens for ICO. 
420 		//If not enough, then he needs to transfer some tokens into contract addresss from his wallet
421 		//If there are no tokens in smart contract address, then ICO will not work.
422 		function updateCrowdsale(uint256 preSaleStart, uint256 icoJanuary, uint256 icoFabruary, uint256 icoMarch, uint256 icoApril, uint256 icoEnd) onlyOwner public {
423 			require(preSaleStart < icoEnd);
424 			preSaleStartDate = preSaleStart;
425 			icoJanuaryDate = icoJanuary;
426 			icoFabruaryDate = icoFabruary;
427 			icoMarchDate = icoMarch;
428 			icoAprilDate = icoApril;
429 			icoEndDate=icoEnd;
430         }
431         
432         //Stops an ICO.
433         //It will just set the ICO end date to zero and thus it will stop an ICO
434 		function stopICO() onlyOwner public{
435             icoEndDate = 0;
436         }
437         
438         //function to check wheter ICO is running or not. 
439         //It will return current state of the crowdsale
440         function icoStatus() public view returns(string){
441             if(icoEndDate < now ){
442                 return "ICO is over";
443             }else if(preSaleStartDate < now && icoJanuaryDate > now ){
444                 return "Pre-sale is running";
445             }else if(icoJanuaryDate < now && icoEndDate > now){
446                 return "ICO is running";                
447             }else if(preSaleStartDate > now){
448                 return "Pre-sale will start on November 1, 2018";
449             }else{
450                 return "ICO is over";
451             }
452         }
453         
454         //Function to set ICO Exchange rate. 
455     	function setICOExchangeRate(uint256 newExchangeRate) onlyOwner public {
456 			exchangeRate=newExchangeRate;
457         }
458         
459         //Just in case, owner wants to transfer Tokens from contract to owner address
460         function manualWithdrawToken(uint256 _amount) onlyOwner public {
461       		uint256 tokenAmount = _amount.mul(100);
462             _transfer(this, msg.sender, tokenAmount);
463         }
464           
465         //Just in case, owner wants to transfer Ether from contract to owner address
466         function manualWithdrawEther()onlyOwner public{
467 			uint256 amount=address(this).balance;
468 			owner.transfer(amount);
469 		}
470 		
471 		//selfdestruct function. just in case owner decided to destruct this contract.
472 		function destructContract()onlyOwner public{
473 			selfdestruct(owner);
474 		}
475 		
476 		/**
477          * Change safeguard status on or off
478          *
479          * When safeguard is true, then all the non-owner functions will stop working.
480          * When safeguard is false, then all the functions will resume working back again!
481          */
482         function changeSafeguardStatus() onlyOwner public{
483             if (safeguard == false){
484 			    safeguard = true;
485             }
486             else{
487                 safeguard = false;    
488             }
489 		}
490 		
491 		
492 		/********************************/
493 		/* Code for the Air drop of ELC */
494 		/********************************/
495 		
496 		/**
497          * Run an Air-Drop
498          *
499          * It requires an array of all the addresses and amount of tokens to distribute
500          * It will only process first 150 recipients. That limit is fixed to prevent gas limit
501          */
502         function airdrop(address[] recipients,uint tokenAmount) public onlyOwner {
503             require(recipients.length <= 150);
504             for(uint i = 0; i < recipients.length; i++)
505             {
506                   //This will loop through all the recipients and send them the specified tokens
507                   _transfer(this, recipients[i], tokenAmount.mul(100));
508             }
509         }
510 }