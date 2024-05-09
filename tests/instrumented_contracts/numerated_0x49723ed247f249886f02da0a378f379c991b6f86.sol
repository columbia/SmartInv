1 pragma solidity 0.4.25;
2 // ----------------------------------------------------------------------------
3 // 'Artcoin' contract with following features
4 //      => In-built ICO functionality - Infinite duration
5 //      => ERC20 Compliance
6 //      => Higher control of ICO by admin/owner
7 //      => selfdestruct functionality
8 //      => SafeMath implementation 
9 //
10 // Deployed to : 0x6A51a1415ED5e6156D4A6046C890e2f2a4Cfd0B9
11 // Symbol      : ARS
12 // Name        : Artcoin
13 // Total supply: 100,000,000,000  (100 Billion)
14 // ICO reserve : 30,000,000,000   (30 Billion)
15 // Decimals    : 18
16 //
17 // Copyright (c) 2018 ARTCOIN.ai, Malta (https://www.artcoin.ai)
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
103             uint256 reservedForICO = 30000000000 * (1 ether);   // Reserved for ICO - 30 Billion
104             balanceOf[this] = reservedForICO;
105             balanceOf[msg.sender] = totalSupply.sub(reservedForICO); // Give the creator initial tokens
106             name = tokenName;                                   // Set the name for display purposes
107             symbol = tokenSymbol;                               // Set the symbol for display purposes
108         }
109     
110         /**
111          * Internal transfer, only can be called by this contract
112          */
113         function _transfer(address _from, address _to, uint _value) internal {
114             require(!safeguard);
115             // Prevent transfer to 0x0 address. Use burn() instead
116             require(_to != 0x0);
117             // Check if the sender has enough
118             require(balanceOf[_from] >= _value);
119             // Check for overflows
120             require(balanceOf[_to].add(_value) > balanceOf[_to]);
121             // Save this for an assertion in the future
122             uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
123             // Subtract from the sender
124             balanceOf[_from] = balanceOf[_from].sub(_value);
125             // Add the same to the recipient
126             balanceOf[_to] = balanceOf[_to].add(_value);
127             emit Transfer(_from, _to, _value);
128             // Asserts are used to use static analysis to find bugs in your code. They should never fail
129             assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
130         }
131     
132         /**
133          * Transfer tokens
134          *
135          * Send `_value` tokens to `_to` from your account
136          *
137          * @param _to The address of the recipient
138          * @param _value the amount to send
139          */
140         function transfer(address _to, uint256 _value) public {
141             _transfer(msg.sender, _to, _value);
142         }
143     
144         /**
145          * Transfer tokens from other address
146          *
147          * Send `_value` tokens to `_to` in behalf of `_from`
148          *
149          * @param _from The address of the sender
150          * @param _to The address of the recipient
151          * @param _value the amount to send
152          */
153         function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
154             require(!safeguard);
155             require(_value <= allowance[_from][msg.sender]);     // Check allowance
156             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
157             _transfer(_from, _to, _value);
158             return true;
159         }
160     
161         /**
162          * Set allowance for other address
163          *
164          * Allows `_spender` to spend no more than `_value` tokens in your behalf
165          *
166          * @param _spender The address authorized to spend
167          * @param _value the max amount they can spend
168          */
169         function approve(address _spender, uint256 _value) public
170             returns (bool success) {
171             require(!safeguard);
172             allowance[msg.sender][_spender] = _value;
173             return true;
174         }
175     
176         /**
177          * Set allowance for other address and notify
178          *
179          * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
180          *
181          * @param _spender The address authorized to spend
182          * @param _value the max amount they can spend
183          * @param _extraData some extra information to send to the approved contract
184          */
185         function approveAndCall(address _spender, uint256 _value, bytes _extraData)
186             public
187             returns (bool success) {
188             require(!safeguard);
189             tokenRecipient spender = tokenRecipient(_spender);
190             if (approve(_spender, _value)) {
191                 spender.receiveApproval(msg.sender, _value, this, _extraData);
192                 return true;
193             }
194         }
195     
196         /**
197          * Destroy tokens
198          *
199          * Remove `_value` tokens from the system irreversibly
200          *
201          * @param _value the amount of money to burn
202          */
203         function burn(uint256 _value) public returns (bool success) {
204             require(!safeguard);
205             require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
206             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
207             totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
208            	emit Burn(msg.sender, _value);
209             return true;
210         }
211     
212         /**
213          * Destroy tokens from other account
214          *
215          * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
216          *
217          * @param _from the address of the sender
218          * @param _value the amount of money to burn
219          */
220         function burnFrom(address _from, uint256 _value) public returns (bool success) {
221             require(!safeguard);
222             require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
223             require(_value <= allowance[_from][msg.sender]);    // Check allowance
224             balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
225             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
226             totalSupply = totalSupply.sub(_value);                              // Update totalSupply
227           	emit  Burn(_from, _value);
228             return true;
229         }
230         
231     }
232     
233     //*******************************************************//
234     //-------------  ADVANCED TOKEN STARTS HERE -------------//
235     //*******************************************************//
236     
237     contract Artcoin is owned, TokenERC20 {
238     	using SafeMath for uint256;
239     	
240     	/**********************************/
241         /* Code for the ERC20 Artcoin */
242         /**********************************/
243     
244     	// Public variables of the token
245     	string private tokenName = "Artcoin";
246         string private tokenSymbol = "ARS";
247         uint256 private initialSupply = 100000000000; 	// Initial supply of the tokens - 100 Billion   
248 
249 		// Records for the fronzen accounts 
250         mapping (address => bool) public frozenAccount;
251         
252         /* This generates a public event on the blockchain that will notify clients */
253         event FrozenFunds(address target, bool frozen);
254     
255         /* Initializes contract with initial supply tokens to the creator of the contract */
256         constructor () TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
257 
258         /* Internal transfer, only can be called by this contract */
259         function _transfer(address _from, address _to, uint _value) internal {
260             require(!safeguard);
261 			require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
262 			require (balanceOf[_from] >= _value);               // Check if the sender has enough
263 			require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
264 			require(!frozenAccount[_from]);                     // Check if sender is frozen
265 			require(!frozenAccount[_to]);                       // Check if recipient is frozen
266 			balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the sender
267 			balanceOf[_to] = balanceOf[_to].add(_value);        // Add the same to the recipient
268 			emit Transfer(_from, _to, _value);
269         }
270         
271 		/// @notice Create `mintedAmount` tokens and send it to `target`
272 		/// @param target Address to receive the tokens
273 		/// @param mintedAmount the amount of tokens it will receive
274 		function mintToken(address target, uint256 mintedAmount) onlyOwner public {
275 			balanceOf[target] = balanceOf[target].add(mintedAmount);
276 			totalSupply = totalSupply.add(mintedAmount);
277 		 	emit Transfer(0, this, mintedAmount);
278 		 	emit Transfer(this, target, mintedAmount);
279 		}
280 
281 		/// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
282 		/// @param target Address to be frozen
283 		/// @param freeze either to freeze it or not
284 		function freezeAccount(address target, bool freeze) onlyOwner public {
285 				frozenAccount[target] = freeze;
286 			emit  FrozenFunds(target, freeze);
287 		}
288 
289 		/**************************/
290 		/* Code for the Crowdsale */
291 		/**************************/
292 
293 		//public variables for the Crowdsale
294 		uint256 public icoStartDate = 999 ;  // Any past timestamp
295 		uint256 public icoEndDate = 9999999999999999 ;    // Infinite end date.
296 		uint256 public exchangeRate = 10000;         // 1 ETH = 10000 Tokens 
297 		uint256 public tokensSold = 0;              // how many tokens sold through crowdsale
298 
299 		//@dev fallback function, only accepts ether if ICO is running or Reject
300 		function () payable public {
301 			require(icoEndDate > now);
302 			require(icoStartDate < now);
303             require(!safeguard);
304 			uint ethervalueWEI=msg.value;
305 			// calculate token amount to be sent
306 			uint256 token = ethervalueWEI.mul(exchangeRate); //weiamount * price
307 			tokensSold = tokensSold.add(token);
308 			_transfer(this, msg.sender, token);              // makes the transfers
309 			forwardEherToOwner();
310 		}
311 
312 		//Automatocally forwards ether from smart contract to owner address
313 		function forwardEherToOwner() internal {
314 			owner.transfer(msg.value); 
315 		}
316 
317 		//function to start an ICO.
318 		//It requires: timestamp of start and end date, exchange rate (1 ETH = ? Tokens), and token amounts to allocate for the ICO
319 		//It will transfer allocated amount to the smart contract from Owner
320 		function startIco(uint256 start,uint256 end, uint256 exchangeRateNew, uint256 TokensAllocationForICO) onlyOwner public {
321 			require(start < end);
322 			uint256 tokenAmount = TokensAllocationForICO.mul(1 ether);
323 			require(balanceOf[msg.sender] > tokenAmount);
324 			icoStartDate=start;
325 			icoEndDate=end;
326 			exchangeRate = exchangeRateNew;
327 			approve(this,tokenAmount);
328 			transfer(this,tokenAmount);
329         }
330         
331         //Stops an ICO.
332         //It will also transfer remaining tokens to owner
333 		function stopICO() onlyOwner public{
334             icoEndDate = 0;
335             uint256 tokenAmount=balanceOf[this];
336             _transfer(this, msg.sender, tokenAmount);
337         }
338         
339         //function to check wheter ICO is running or not.
340         function isICORunning() public view returns(bool){
341             if(icoEndDate > now && icoStartDate < now){
342                 return true;                
343             }else{
344                 return false;
345             }
346         }
347         
348         //Function to set ICO Exchange rate. 
349     	function setICOExchangeRate(uint256 newExchangeRate) onlyOwner public {
350 			exchangeRate=newExchangeRate;
351         }
352         
353         //Just in case, owner wants to transfer Tokens from contract to owner address
354         function manualWithdrawToken(uint256 _amount) onlyOwner public {
355       		uint256 tokenAmount = _amount.mul(1 ether);
356             _transfer(this, msg.sender, tokenAmount);
357         }
358           
359         //Just in case, owner wants to transfer Ether from contract to owner address
360         function manualWithdrawEther()onlyOwner public{
361 			uint256 amount=address(this).balance;
362 			owner.transfer(amount);
363 		}
364 		
365 		//selfdestruct function. just in case owner decided to destruct this contract.
366 		function destructContract()onlyOwner public{
367 			selfdestruct(owner);
368 		}
369 		
370 		/**
371          * Change safeguard status on or off
372          *
373          * When safeguard is true, then all the non-owner functions will stop working.
374          */
375         function changeSafeguardStatus() onlyOwner public{
376             if (safeguard == false){
377 			    safeguard = true;
378             }
379             else{
380                 safeguard = false;    
381             }
382 		}
383 }