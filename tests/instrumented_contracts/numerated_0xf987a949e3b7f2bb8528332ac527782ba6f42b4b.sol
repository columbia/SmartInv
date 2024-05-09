1 pragma solidity 0.4.25;
2 // ----------------------------------------------------------------------------
3 // 'PAYTOKEN' contract with following features
4 //      => In-built ICO functionality - Infinite duration
5 //      => ERC20 Compliance
6 //      => Higher control of ICO by admin/owner
7 //      => selfdestruct functionality
8 //      => SafeMath implementation 
9 //
10 // Deployed to : 0x6A51a1415ED5e6156D4A6046C890e2f2a4Cfd0B9
11 // Symbol      : PAYTK
12 // Name        : PAYTOKEN
13 // Total supply: 1,000,000,000  (1 Billion)
14 // Decimals    : 18
15 //
16 // Copyright (c) 2018 Payou Ltd, Malta (https://paytoken.co)
17 // ----------------------------------------------------------------------------
18    
19     /**
20      * @title SafeMath
21      * @dev Math operations with safety checks that throw on error
22      */
23     library SafeMath {
24       function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25         if (a == 0) {
26           return 0;
27         }
28         uint256 c = a * b;
29         assert(c / a == b);
30         return c;
31       }
32     
33       function div(uint256 a, uint256 b) internal pure returns (uint256) {
34         // assert(b > 0); // Solidity automatically throws when dividing by 0
35         uint256 c = a / b;
36         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37         return c;
38       }
39     
40       function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         assert(b <= a);
42         return a - b;
43       }
44     
45       function add(uint256 a, uint256 b) internal pure returns (uint256) {
46         uint256 c = a + b;
47         assert(c >= a);
48         return c;
49       }
50     }
51     
52     contract owned {
53         address public owner;
54     	using SafeMath for uint256;
55     	
56          constructor () public {
57             owner = msg.sender;
58         }
59     
60         modifier onlyOwner {
61             require(msg.sender == owner);
62             _;
63         }
64     
65         function transferOwnership(address newOwner) onlyOwner public {
66             owner = newOwner;
67         }
68     }
69     
70     interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
71     
72     contract TokenERC20 {
73         // Public variables of the token
74         using SafeMath for uint256;
75     	string public name;
76         string public symbol;
77         uint8 public decimals = 18; // 18 decimals is the strongly suggested default, avoid changing it
78         uint256 public totalSupply;
79         bool public safeguard = false;  //putting safeguard on will halt all non-owner functions
80     
81         // This creates an array with all balances
82         mapping (address => uint256) public balanceOf;
83         mapping (address => mapping (address => uint256)) public allowance;
84     
85         // This generates a public event on the blockchain that will notify clients
86         event Transfer(address indexed from, address indexed to, uint256 value);
87     
88         // This notifies clients about the amount burnt
89         event Burn(address indexed from, uint256 value);
90     
91         /**
92          * Constrctor function
93          *
94          * Initializes contract with initial supply tokens to the creator of the contract
95          */
96         constructor (
97             uint256 initialSupply,
98             string tokenName,
99             string tokenSymbol
100         ) public {
101             totalSupply = initialSupply.mul(1 ether);           // Update total supply with the decimal amount
102             balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
103             name = tokenName;                                   // Set the name for display purposes
104             symbol = tokenSymbol;                               // Set the symbol for display purposes
105         }
106     
107         /**
108          * Internal transfer, only can be called by this contract
109          */
110         function _transfer(address _from, address _to, uint _value) internal {
111             require(!safeguard);
112             // Prevent transfer to 0x0 address. Use burn() instead
113             require(_to != 0x0);
114             // Check if the sender has enough
115             require(balanceOf[_from] >= _value);
116             // Check for overflows
117             require(balanceOf[_to].add(_value) > balanceOf[_to]);
118             // Save this for an assertion in the future
119             uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
120             // Subtract from the sender
121             balanceOf[_from] = balanceOf[_from].sub(_value);
122             // Add the same to the recipient
123             balanceOf[_to] = balanceOf[_to].add(_value);
124             emit Transfer(_from, _to, _value);
125             // Asserts are used to use static analysis to find bugs in your code. They should never fail
126             assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
127         }
128     
129         /**
130          * Transfer tokens
131          *
132          * Send `_value` tokens to `_to` from your account
133          *
134          * @param _to The address of the recipient
135          * @param _value the amount to send
136          */
137         function transfer(address _to, uint256 _value) public {
138             _transfer(msg.sender, _to, _value);
139         }
140     
141         /**
142          * Transfer tokens from other address
143          *
144          * Send `_value` tokens to `_to` in behalf of `_from`
145          *
146          * @param _from The address of the sender
147          * @param _to The address of the recipient
148          * @param _value the amount to send
149          */
150         function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
151             require(!safeguard);
152             require(_value <= allowance[_from][msg.sender]);     // Check allowance
153             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
154             _transfer(_from, _to, _value);
155             return true;
156         }
157     
158         /**
159          * Set allowance for other address
160          *
161          * Allows `_spender` to spend no more than `_value` tokens in your behalf
162          *
163          * @param _spender The address authorized to spend
164          * @param _value the max amount they can spend
165          */
166         function approve(address _spender, uint256 _value) public
167             returns (bool success) {
168             require(!safeguard);
169             allowance[msg.sender][_spender] = _value;
170             return true;
171         }
172     
173         /**
174          * Set allowance for other address and notify
175          *
176          * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
177          *
178          * @param _spender The address authorized to spend
179          * @param _value the max amount they can spend
180          * @param _extraData some extra information to send to the approved contract
181          */
182         function approveAndCall(address _spender, uint256 _value, bytes _extraData)
183             public
184             returns (bool success) {
185             require(!safeguard);
186             tokenRecipient spender = tokenRecipient(_spender);
187             if (approve(_spender, _value)) {
188                 spender.receiveApproval(msg.sender, _value, this, _extraData);
189                 return true;
190             }
191         }
192     
193         /**
194          * Destroy tokens
195          *
196          * Remove `_value` tokens from the system irreversibly
197          *
198          * @param _value the amount of money to burn
199          */
200         function burn(uint256 _value) public returns (bool success) {
201             require(!safeguard);
202             require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
203             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
204             totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
205            	emit Burn(msg.sender, _value);
206             return true;
207         }
208     
209         /**
210          * Destroy tokens from other account
211          *
212          * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
213          *
214          * @param _from the address of the sender
215          * @param _value the amount of money to burn
216          */
217         function burnFrom(address _from, uint256 _value) public returns (bool success) {
218             require(!safeguard);
219             require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
220             require(_value <= allowance[_from][msg.sender]);    // Check allowance
221             balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
222             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
223             totalSupply = totalSupply.sub(_value);                              // Update totalSupply
224           	emit  Burn(_from, _value);
225             return true;
226         }
227         
228     }
229     
230     //*******************************************************//
231     //-------------  ADVANCED TOKEN STARTS HERE -------------//
232     //*******************************************************//
233     
234     contract PAYTOKEN is owned, TokenERC20 {
235     	using SafeMath for uint256;
236     	
237     	/**********************************/
238         /* Code for the ERC20 PAYTOKEN */
239         /**********************************/
240     
241     	// Public variables of the token
242     	string private tokenName = "PAYTOKEN";
243         string private tokenSymbol = "PAYTK";
244         uint256 private initialSupply = 1000000000; 	// Initial supply of the tokens   
245 
246 		// Records for the fronzen accounts 
247         mapping (address => bool) public frozenAccount;
248         
249         /* This generates a public event on the blockchain that will notify clients */
250         event FrozenFunds(address target, bool frozen);
251     
252         /* Initializes contract with initial supply tokens to the creator of the contract */
253         constructor () TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
254 
255         /* Internal transfer, only can be called by this contract */
256         function _transfer(address _from, address _to, uint _value) internal {
257             require(!safeguard);
258 			require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
259 			require (balanceOf[_from] >= _value);               // Check if the sender has enough
260 			require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
261 			require(!frozenAccount[_from]);                     // Check if sender is frozen
262 			require(!frozenAccount[_to]);                       // Check if recipient is frozen
263 			balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
264 			balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient
265 			emit Transfer(_from, _to, _value);
266         }
267         
268 		/// @notice Create `mintedAmount` tokens and send it to `target`
269 		/// @param target Address to receive the tokens
270 		/// @param mintedAmount the amount of tokens it will receive
271 		function mintToken(address target, uint256 mintedAmount) onlyOwner public {
272 			balanceOf[target] = balanceOf[target].add(mintedAmount);
273 			totalSupply = totalSupply.add(mintedAmount);
274 		 	emit Transfer(0, this, mintedAmount);
275 		 	emit Transfer(this, target, mintedAmount);
276 		}
277 
278 		/// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
279 		/// @param target Address to be frozen
280 		/// @param freeze either to freeze it or not
281 		function freezeAccount(address target, bool freeze) onlyOwner public {
282 				frozenAccount[target] = freeze;
283 			emit  FrozenFunds(target, freeze);
284 		}
285 
286 		/**************************/
287 		/* Code for the Crowdsale */
288 		/**************************/
289 
290 		//public variables for the Crowdsale
291 		uint256 public icoStartDate = 999 ;  // Any past timestamp
292 		uint256 public icoEndDate = 9999999999999999 ;    // Infinite end date.
293 		uint256 public exchangeRate = 10000;         // 1 ETH = 10000 Tokens 
294 		uint256 public tokensSold = 0;              // how many tokens sold through crowdsale
295 
296 		//@dev fallback function, only accepts ether if ICO is running or Reject
297 		function () payable public {
298 			require(icoEndDate > now);
299 			require(icoStartDate < now);
300             require(!safeguard);
301 			uint ethervalueWEI=msg.value;
302 			// calculate token amount to be sent
303 			uint256 token = ethervalueWEI.mul(exchangeRate); //weiamount * price
304 			tokensSold = tokensSold.add(token);
305 			_transfer(this, msg.sender, token);              // makes the transfers
306 			forwardEherToOwner();
307 		}
308 
309 		//Automatocally forwards ether from smart contract to owner address
310 		function forwardEherToOwner() internal {
311 			owner.transfer(msg.value); 
312 		}
313 
314 		//function to start an ICO.
315 		//It requires: timestamp of start and end date, exchange rate (1 ETH = ? Tokens), and token amounts to allocate for the ICO
316 		//It will transfer allocated amount to the smart contract from Owner
317 		function startIco(uint256 start,uint256 end, uint256 exchangeRateNew, uint256 TokensAllocationForICO) onlyOwner public {
318 			require(start < end);
319 			uint256 tokenAmount = TokensAllocationForICO.mul(1 ether);
320 			require(balanceOf[msg.sender] > tokenAmount);
321 			icoStartDate=start;
322 			icoEndDate=end;
323 			exchangeRate = exchangeRateNew;
324 			approve(this,tokenAmount);
325 			transfer(this,tokenAmount);
326         }
327         
328         //Stops an ICO.
329         //It will also transfer remaining tokens to owner
330 		function stopICO() onlyOwner public{
331             icoEndDate = 0;
332             uint256 tokenAmount=balanceOf[this];
333             _transfer(this, msg.sender, tokenAmount);
334         }
335         
336         //function to check wheter ICO is running or not.
337         function isICORunning() public view returns(bool){
338             if(icoEndDate > now && icoStartDate < now){
339                 return true;                
340             }else{
341                 return false;
342             }
343         }
344         
345         //Function to set ICO Exchange rate. 
346     	function setICOExchangeRate(uint256 newExchangeRate) onlyOwner public {
347 			exchangeRate=newExchangeRate;
348         }
349         
350         //Just in case, owner wants to transfer Tokens from contract to owner address
351         function manualWithdrawToken(uint256 _amount) onlyOwner public {
352       		uint256 tokenAmount = _amount.mul(1 ether);
353             _transfer(this, msg.sender, tokenAmount);
354         }
355           
356         //Just in case, owner wants to transfer Ether from contract to owner address
357         function manualWithdrawEther()onlyOwner public{
358 			uint256 amount=address(this).balance;
359 			owner.transfer(amount);
360 		}
361 		
362 		//selfdestruct function. just in case owner decided to destruct this contract.
363 		function destructContract()onlyOwner public{
364 			selfdestruct(owner);
365 		}
366 		
367 		/**
368          * Change safeguard status on or off
369          *
370          * When safeguard is true, then all the non-owner functions will stop working.
371          */
372         function changeSafeguardStatus() onlyOwner public{
373             if (safeguard == false){
374 			    safeguard = true;
375             }
376             else{
377                 safeguard = false;    
378             }
379 		}
380 }