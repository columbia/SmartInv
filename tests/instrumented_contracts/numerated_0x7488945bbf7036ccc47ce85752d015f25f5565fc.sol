1 pragma solidity 0.4.25;
2 // ----------------------------------------------------------------------------
3 // 'Medica Token' contract with following features
4 //      => In-built ICO functionality - Infinite duration
5 //      => ERC20 Compliance
6 //      => Higher control of ICO by admin/owner
7 //      => selfdestruct functionality
8 //      => SafeMath implementation 
9 //
10 // Deployed to : 0x6A51a1415ED5e6156D4A6046C890e2f2a4Cfd0B9
11 // Symbol      : MEDTK
12 // Name        : Medica Token
13 // Total supply: 10,000,000,000  (10 Billion)
14 // Decimals    : 18
15 //
16 // Copyright (c) 2018 Medica Ltd, Belize (https://www.medica.ai)
17 // Contract designed by Ether Authority (https://EtherAuthority.io)
18 // ----------------------------------------------------------------------------
19    
20     /**
21      * @title SafeMath
22      * @dev Math operations with safety checks that throw on error
23      */
24     library SafeMath {
25       function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26         if (a == 0) {
27           return 0;
28         }
29         uint256 c = a * b;
30         assert(c / a == b);
31         return c;
32       }
33     
34       function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         // assert(b > 0); // Solidity automatically throws when dividing by 0
36         uint256 c = a / b;
37         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38         return c;
39       }
40     
41       function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         assert(b <= a);
43         return a - b;
44       }
45     
46       function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         assert(c >= a);
49         return c;
50       }
51     }
52     
53     contract owned {
54         address public owner;
55     	using SafeMath for uint256;
56     	
57          constructor () public {
58             owner = msg.sender;
59         }
60     
61         modifier onlyOwner {
62             require(msg.sender == owner);
63             _;
64         }
65     
66         function transferOwnership(address newOwner) onlyOwner public {
67             owner = newOwner;
68         }
69     }
70     
71     interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
72     
73     contract TokenERC20 {
74         // Public variables of the token
75         using SafeMath for uint256;
76     	string public name;
77         string public symbol;
78         uint8 public decimals = 18; // 18 decimals is the strongly suggested default, avoid changing it
79         uint256 public totalSupply;
80         bool public safeguard = false;  //putting safeguard on will halt all non-owner functions
81     
82         // This creates an array with all balances
83         mapping (address => uint256) public balanceOf;
84         mapping (address => mapping (address => uint256)) public allowance;
85     
86         // This generates a public event on the blockchain that will notify clients
87         event Transfer(address indexed from, address indexed to, uint256 value);
88     
89         // This notifies clients about the amount burnt
90         event Burn(address indexed from, uint256 value);
91     
92         /**
93          * Constrctor function
94          *
95          * Initializes contract with initial supply tokens to the creator of the contract
96          */
97         constructor (
98             uint256 initialSupply,
99             string tokenName,
100             string tokenSymbol
101         ) public {
102             totalSupply = initialSupply.mul(1 ether);           // Update total supply with the decimal amount
103             balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
104             name = tokenName;                                   // Set the name for display purposes
105             symbol = tokenSymbol;                               // Set the symbol for display purposes
106         }
107     
108         /**
109          * Internal transfer, only can be called by this contract
110          */
111         function _transfer(address _from, address _to, uint _value) internal {
112             require(!safeguard);
113             // Prevent transfer to 0x0 address. Use burn() instead
114             require(_to != 0x0);
115             // Check if the sender has enough
116             require(balanceOf[_from] >= _value);
117             // Check for overflows
118             require(balanceOf[_to].add(_value) > balanceOf[_to]);
119             // Save this for an assertion in the future
120             uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
121             // Subtract from the sender
122             balanceOf[_from] = balanceOf[_from].sub(_value);
123             // Add the same to the recipient
124             balanceOf[_to] = balanceOf[_to].add(_value);
125             emit Transfer(_from, _to, _value);
126             // Asserts are used to use static analysis to find bugs in your code. They should never fail
127             assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
128         }
129     
130         /**
131          * Transfer tokens
132          *
133          * Send `_value` tokens to `_to` from your account
134          *
135          * @param _to The address of the recipient
136          * @param _value the amount to send
137          */
138         function transfer(address _to, uint256 _value) public {
139             _transfer(msg.sender, _to, _value);
140         }
141     
142         /**
143          * Transfer tokens from other address
144          *
145          * Send `_value` tokens to `_to` in behalf of `_from`
146          *
147          * @param _from The address of the sender
148          * @param _to The address of the recipient
149          * @param _value the amount to send
150          */
151         function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
152             require(!safeguard);
153             require(_value <= allowance[_from][msg.sender]);     // Check allowance
154             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
155             _transfer(_from, _to, _value);
156             return true;
157         }
158     
159         /**
160          * Set allowance for other address
161          *
162          * Allows `_spender` to spend no more than `_value` tokens in your behalf
163          *
164          * @param _spender The address authorized to spend
165          * @param _value the max amount they can spend
166          */
167         function approve(address _spender, uint256 _value) public
168             returns (bool success) {
169             require(!safeguard);
170             allowance[msg.sender][_spender] = _value;
171             return true;
172         }
173     
174         /**
175          * Set allowance for other address and notify
176          *
177          * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
178          *
179          * @param _spender The address authorized to spend
180          * @param _value the max amount they can spend
181          * @param _extraData some extra information to send to the approved contract
182          */
183         function approveAndCall(address _spender, uint256 _value, bytes _extraData)
184             public
185             returns (bool success) {
186             require(!safeguard);
187             tokenRecipient spender = tokenRecipient(_spender);
188             if (approve(_spender, _value)) {
189                 spender.receiveApproval(msg.sender, _value, this, _extraData);
190                 return true;
191             }
192         }
193     
194         /**
195          * Destroy tokens
196          *
197          * Remove `_value` tokens from the system irreversibly
198          *
199          * @param _value the amount of money to burn
200          */
201         function burn(uint256 _value) public returns (bool success) {
202             require(!safeguard);
203             require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
204             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
205             totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
206            	emit Burn(msg.sender, _value);
207             return true;
208         }
209     
210         /**
211          * Destroy tokens from other account
212          *
213          * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
214          *
215          * @param _from the address of the sender
216          * @param _value the amount of money to burn
217          */
218         function burnFrom(address _from, uint256 _value) public returns (bool success) {
219             require(!safeguard);
220             require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
221             require(_value <= allowance[_from][msg.sender]);    // Check allowance
222             balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
223             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
224             totalSupply = totalSupply.sub(_value);                              // Update totalSupply
225           	emit  Burn(_from, _value);
226             return true;
227         }
228         
229     }
230     
231     //*******************************************************//
232     //-------------  ADVANCED TOKEN STARTS HERE -------------//
233     //*******************************************************//
234     
235     contract MedicaToken is owned, TokenERC20 {
236     	using SafeMath for uint256;
237     	
238     	/**********************************/
239         /* Code for the ERC20 MedicaToken */
240         /**********************************/
241     
242     	// Public variables of the token
243     	string private tokenName = "Medica Token";
244         string private tokenSymbol = "MEDTK";
245         uint256 private initialSupply = 10000000000; 	// Initial supply of the tokens   
246 
247 		// Records for the fronzen accounts 
248         mapping (address => bool) public frozenAccount;
249         
250         /* This generates a public event on the blockchain that will notify clients */
251         event FrozenFunds(address target, bool frozen);
252     
253         /* Initializes contract with initial supply tokens to the creator of the contract */
254         constructor () TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
255 
256         /* Internal transfer, only can be called by this contract */
257         function _transfer(address _from, address _to, uint _value) internal {
258             require(!safeguard);
259 			require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
260 			require (balanceOf[_from] >= _value);               // Check if the sender has enough
261 			require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
262 			require(!frozenAccount[_from]);                     // Check if sender is frozen
263 			require(!frozenAccount[_to]);                       // Check if recipient is frozen
264 			balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
265 			balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient
266 			emit Transfer(_from, _to, _value);
267         }
268         
269 		/// @notice Create `mintedAmount` tokens and send it to `target`
270 		/// @param target Address to receive the tokens
271 		/// @param mintedAmount the amount of tokens it will receive
272 		function mintToken(address target, uint256 mintedAmount) onlyOwner public {
273 			balanceOf[target] = balanceOf[target].add(mintedAmount);
274 			totalSupply = totalSupply.add(mintedAmount);
275 		 	emit Transfer(0, this, mintedAmount);
276 		 	emit Transfer(this, target, mintedAmount);
277 		}
278 
279 		/// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
280 		/// @param target Address to be frozen
281 		/// @param freeze either to freeze it or not
282 		function freezeAccount(address target, bool freeze) onlyOwner public {
283 				frozenAccount[target] = freeze;
284 			emit  FrozenFunds(target, freeze);
285 		}
286 
287 		/**************************/
288 		/* Code for the Crowdsale */
289 		/**************************/
290 
291 		//public variables for the Crowdsale
292 		uint256 public icoStartDate = 999 ;  // Any past timestamp
293 		uint256 public icoEndDate = 9999999999999999 ;    // Infinite end date.
294 		uint256 public exchangeRate = 10000;         // 1 ETH = 10000 Tokens 
295 		uint256 public tokensSold = 0;              // how many tokens sold through crowdsale
296 
297 		//@dev fallback function, only accepts ether if ICO is running or Reject
298 		function () payable public {
299 			require(icoEndDate > now);
300 			require(icoStartDate < now);
301             require(!safeguard);
302 			uint ethervalueWEI=msg.value;
303 			// calculate token amount to be sent
304 			uint256 token = ethervalueWEI.mul(exchangeRate); //weiamount * price
305 			tokensSold = tokensSold.add(token);
306 			_transfer(this, msg.sender, token);              // makes the transfers
307 			forwardEherToOwner();
308 		}
309 
310 		//Automatocally forwards ether from smart contract to owner address
311 		function forwardEherToOwner() internal {
312 			owner.transfer(msg.value); 
313 		}
314 
315 		//function to start an ICO.
316 		//It requires: timestamp of start and end date, exchange rate (1 ETH = ? Tokens), and token amounts to allocate for the ICO
317 		//It will transfer allocated amount to the smart contract from Owner
318 		function startIco(uint256 start,uint256 end, uint256 exchangeRateNew, uint256 TokensAllocationForICO) onlyOwner public {
319 			require(start < end);
320 			uint256 tokenAmount = TokensAllocationForICO.mul(1 ether);
321 			require(balanceOf[msg.sender] > tokenAmount);
322 			icoStartDate=start;
323 			icoEndDate=end;
324 			exchangeRate = exchangeRateNew;
325 			approve(this,tokenAmount);
326 			transfer(this,tokenAmount);
327         }
328         
329         //Stops an ICO.
330         //It will also transfer remaining tokens to owner
331 		function stopICO() onlyOwner public{
332             icoEndDate = 0;
333             uint256 tokenAmount=balanceOf[this];
334             _transfer(this, msg.sender, tokenAmount);
335         }
336         
337         //function to check wheter ICO is running or not.
338         function isICORunning() public view returns(bool){
339             if(icoEndDate > now && icoStartDate < now){
340                 return true;                
341             }else{
342                 return false;
343             }
344         }
345         
346         //Function to set ICO Exchange rate. 
347     	function setICOExchangeRate(uint256 newExchangeRate) onlyOwner public {
348 			exchangeRate=newExchangeRate;
349         }
350         
351         //Just in case, owner wants to transfer Tokens from contract to owner address
352         function manualWithdrawToken(uint256 _amount) onlyOwner public {
353       		uint256 tokenAmount = _amount.mul(1 ether);
354             _transfer(this, msg.sender, tokenAmount);
355         }
356           
357         //Just in case, owner wants to transfer Ether from contract to owner address
358         function manualWithdrawEther()onlyOwner public{
359 			uint256 amount=address(this).balance;
360 			owner.transfer(amount);
361 		}
362 		
363 		//selfdestruct function. just in case owner decided to destruct this contract.
364 		function destructContract()onlyOwner public{
365 			selfdestruct(owner);
366 		}
367 		
368 		/**
369          * Change safeguard status on or off
370          *
371          * When safeguard is true, then all the non-owner functions will stop working.
372          */
373         function changeSafeguardStatus() onlyOwner public{
374             if (safeguard == false){
375 			    safeguard = true;
376             }
377             else{
378                 safeguard = false;    
379             }
380 		}
381 }