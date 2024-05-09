1 pragma solidity 0.4.25; /*
2 
3 ___________________________________________________________________
4   _      _                                        ______           
5   |  |  /          /                                /              
6 --|-/|-/-----__---/----__----__---_--_----__-------/-------__------
7   |/ |/    /___) /   /   ' /   ) / /  ) /___)     /      /   )     
8 __/__|____(___ _/___(___ _(___/_/_/__/_(___ _____/______(___/__o_o_
9 
10 
11 ███████╗████████╗ ██████╗ ██████╗  █████╗  ██████╗      ██████╗ ██████╗ ██╗███╗   ██╗
12 ██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗██╔══██╗██╔════╝     ██╔════╝██╔═══██╗██║████╗  ██║
13 ███████╗   ██║   ██║   ██║██████╔╝███████║██║  ███╗    ██║     ██║   ██║██║██╔██╗ ██║
14 ╚════██║   ██║   ██║   ██║██╔══██╗██╔══██║██║   ██║    ██║     ██║   ██║██║██║╚██╗██║
15 ███████║   ██║   ╚██████╔╝██║  ██║██║  ██║╚██████╔╝    ╚██████╗╚██████╔╝██║██║ ╚████║
16 ╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝      ╚═════╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝
17                                                                                      
18 
19 
20 // ----------------------------------------------------------------------------
21 // 'Storag Coin' contract with following features
22 //      => In-built ICO functionality - receive tokens when sent ether to contract address
23 //      => ERC20 Compliance
24 //      => Higher control of ICO by owner
25 //      => selfdestruct functionality
26 //      => SafeMath implementation 
27 //      => User whitelisting
28 //      => Minting new tokens by owner
29 //
30 // Name        : Storag Coin
31 // Symbol      : STG
32 // Decimals    : 8
33 // Total supply: 1,000,000,000  (1 Billion)
34 //
35 // Copyright (c) 2018 Storag Coin Inc. The MIT Licence.
36 // Contract designed by EtherAuthority ( https://EtherAuthority.io )
37 // ----------------------------------------------------------------------------
38   
39 */ 
40 
41 //*******************************************************************//
42 //------------------------ SafeMath Library -------------------------//
43 //*******************************************************************//
44     /**
45      * @title SafeMath
46      * @dev Math operations with safety checks that throw on error
47      */
48     library SafeMath {
49       function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50         if (a == 0) {
51           return 0;
52         }
53         uint256 c = a * b;
54         assert(c / a == b);
55         return c;
56       }
57     
58       function div(uint256 a, uint256 b) internal pure returns (uint256) {
59         // assert(b > 0); // Solidity automatically throws when dividing by 0
60         uint256 c = a / b;
61         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62         return c;
63       }
64     
65       function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66         assert(b <= a);
67         return a - b;
68       }
69     
70       function add(uint256 a, uint256 b) internal pure returns (uint256) {
71         uint256 c = a + b;
72         assert(c >= a);
73         return c;
74       }
75     }
76 
77 
78 //*******************************************************************//
79 //------------------ Contract to Manage Ownership -------------------//
80 //*******************************************************************//
81     
82     contract owned {
83         address public owner;
84         
85          constructor () public {
86             owner = msg.sender;
87         }
88     
89         modifier onlyOwner {
90             require(msg.sender == owner);
91             _;
92         }
93     
94         function transferOwnership(address newOwner) onlyOwner public {
95             owner = newOwner;
96         }
97     }
98     
99     interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
100 
101 
102 //***************************************************************//
103 //------------------ ERC20 Standard Template -------------------//
104 //***************************************************************//
105     
106     contract TokenERC20 {
107         // Public variables of the token
108         using SafeMath for uint256;
109         string public name;
110         string public symbol;
111         uint256 public decimals = 8; 
112         uint256 public totalSupply;
113         uint256 public reservedForICO;
114         bool public safeguard = false;  //putting safeguard on will halt all non-owner functions
115     
116         // This creates an array with all balances
117         mapping (address => uint256) public balanceOf;
118         mapping (address => mapping (address => uint256)) public allowance;
119     
120         // This generates a public event on the blockchain that will notify clients
121         event Transfer(address indexed from, address indexed to, uint256 value);
122     
123         // This notifies clients about the amount burnt
124         event Burn(address indexed from, uint256 value);
125     
126         /**
127          * Constrctor function
128          *
129          * Initializes contract with initial supply tokens to the creator of the contract
130          */
131         constructor (
132             uint256 initialSupply,
133             uint256 allocatedForICO,
134             string tokenName,
135             string tokenSymbol
136         ) public {
137             totalSupply = initialSupply.mul(1e8);       // Update total supply with the decimal amount
138             reservedForICO = allocatedForICO.mul(1e8);  // Tokens reserved For ICO
139             balanceOf[this] = reservedForICO;           // 250 Million Tokens will remain in the contract
140             balanceOf[msg.sender]=totalSupply.sub(reservedForICO); // Rest of tokens will be sent to owner
141             name = tokenName;                           // Set the name for display purposes
142             symbol = tokenSymbol;                       // Set the symbol for display purposes
143         }
144     
145         /**
146          * Internal transfer, only can be called by this contract
147          */
148         function _transfer(address _from, address _to, uint _value) internal {
149             require(!safeguard);
150             // Prevent transfer to 0x0 address. Use burn() instead
151             require(_to != 0x0);
152             // Check if the sender has enough
153             require(balanceOf[_from] >= _value);
154             // Check for overflows
155             require(balanceOf[_to].add(_value) > balanceOf[_to]);
156             // Save this for an assertion in the future
157             uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
158             // Subtract from the sender
159             balanceOf[_from] = balanceOf[_from].sub(_value);
160             // Add the same to the recipient
161             balanceOf[_to] = balanceOf[_to].add(_value);
162             emit Transfer(_from, _to, _value);
163             // Asserts are used to use static analysis to find bugs in your code. They should never fail
164             assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
165         }
166     
167         /**
168          * Transfer tokens
169          *
170          * Send `_value` tokens to `_to` from your account
171          *
172          * @param _to The address of the recipient
173          * @param _value the amount to send
174          */
175         function transfer(address _to, uint256 _value) public returns (bool success) {
176             _transfer(msg.sender, _to, _value);
177             return true;
178         }
179     
180         /**
181          * Transfer tokens from other address
182          *
183          * Send `_value` tokens to `_to` in behalf of `_from`
184          *
185          * @param _from The address of the sender
186          * @param _to The address of the recipient
187          * @param _value the amount to send
188          */
189         function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
190             require(!safeguard);
191             require(_value <= allowance[_from][msg.sender]);     // Check allowance
192             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
193             _transfer(_from, _to, _value);
194             return true;
195         }
196     
197         /**
198          * Set allowance for other address
199          *
200          * Allows `_spender` to spend no more than `_value` tokens in your behalf
201          *
202          * @param _spender The address authorized to spend
203          * @param _value the max amount they can spend
204          */
205         function approve(address _spender, uint256 _value) public
206             returns (bool success) {
207             require(!safeguard);
208             allowance[msg.sender][_spender] = _value;
209             return true;
210         }
211     
212         /**
213          * Set allowance for other address and notify
214          *
215          * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
216          *
217          * @param _spender The address authorized to spend
218          * @param _value the max amount they can spend
219          * @param _extraData some extra information to send to the approved contract
220          */
221         function approveAndCall(address _spender, uint256 _value, bytes _extraData)
222             public
223             returns (bool success) {
224             require(!safeguard);
225             tokenRecipient spender = tokenRecipient(_spender);
226             if (approve(_spender, _value)) {
227                 spender.receiveApproval(msg.sender, _value, this, _extraData);
228                 return true;
229             }
230         }
231     
232         /**
233          * Destroy tokens
234          *
235          * Remove `_value` tokens from the system irreversibly
236          *
237          * @param _value the amount of money to burn
238          */
239         function burn(uint256 _value) public returns (bool success) {
240             require(!safeguard);
241             require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
242             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
243             totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
244             emit Burn(msg.sender, _value);
245             return true;
246         }
247     
248         /**
249          * Destroy tokens from other account
250          *
251          * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
252          *
253          * @param _from the address of the sender
254          * @param _value the amount of money to burn
255          */
256         function burnFrom(address _from, uint256 _value) public returns (bool success) {
257             require(!safeguard);
258             require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
259             require(_value <= allowance[_from][msg.sender]);    // Check allowance
260             balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
261             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
262             totalSupply = totalSupply.sub(_value);                              // Update totalSupply
263             emit  Burn(_from, _value);
264             return true;
265         }
266         
267     }
268     
269 //******************************************************************************//
270 //---------------------  STORAG COIN MAIN CODE STARTS HERE --------------------//
271 //******************************************************************************//
272     
273     contract StoragCoin is owned, TokenERC20 {
274         
275         /*************************************/
276         /*  User whitelisting functionality  */
277         /*************************************/
278         bool public whitelistingStatus = false;
279         mapping (address => bool) public whitelisted;
280         
281         /**
282          * Change whitelisting status on or off
283          *
284          * When whitelisting is true, then crowdsale will only accept investors who are whitelisted.
285          */
286         function changeWhitelistingStatus() onlyOwner public{
287             if (whitelistingStatus == false){
288                 whitelistingStatus = true;
289             }
290             else{
291                 whitelistingStatus = false;    
292             }
293         }
294         
295         /**
296          * Whitelist any user address - only Owner can do this
297          *
298          * It will add user address in whitelisted mapping
299          */
300         function whitelistUser(address userAddress) onlyOwner public{
301             require(whitelistingStatus == true);
302             require(userAddress != 0x0);
303             whitelisted[userAddress] = true;
304         }
305         
306         /**
307          * Whitelist Many user address at once - only Owner can do this
308          * It will require maximum of 150 addresses to prevent block gas limit max-out and DoS attack
309          * It will add user address in whitelisted mapping
310          */
311         function whitelistManyUsers(address[] userAddresses) onlyOwner public{
312             require(whitelistingStatus == true);
313             uint256 addressCount = userAddresses.length;
314             require(addressCount <= 150);
315             for(uint256 i = 0; i < addressCount; i++){
316                 require(userAddresses[i] != 0x0);
317                 whitelisted[userAddresses[i]] = true;
318             }
319         }
320         
321         
322         
323         /********************************/
324         /* Code for the ERC20 STG Token */
325         /********************************/
326     
327         /* Public variables of the token */
328         string private tokenName = "Storag Coin";
329         string private tokenSymbol = "STG";
330         uint256 private initialSupply = 1000000000;     // 1 Billion
331         uint256 private allocatedForICO = 250000000;    // 250 Million
332         
333         
334         /* Records for the fronzen accounts */
335         mapping (address => bool) public frozenAccount;
336         
337         /* This generates a public event on the blockchain that will notify clients */
338         event FrozenFunds(address target, bool frozen);
339     
340         /* Initializes contract with initial supply tokens to the creator of the contract */
341         constructor () TokenERC20(initialSupply, allocatedForICO, tokenName, tokenSymbol) public {}
342 
343         /* Internal transfer, only can be called by this contract */
344         function _transfer(address _from, address _to, uint _value) internal {
345             require(!safeguard);
346             require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
347             require (balanceOf[_from] >= _value);               // Check if the sender has enough
348             require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
349             require(!frozenAccount[_from]);                     // Check if sender is frozen
350             require(!frozenAccount[_to]);                       // Check if recipient is frozen
351             balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the sender
352             balanceOf[_to] = balanceOf[_to].add(_value);        // Add the same to the recipient
353             emit Transfer(_from, _to, _value);
354         }
355         
356         /// @notice Create `mintedAmount` tokens and send it to `target`
357         /// @param target Address to receive the tokens
358         /// @param mintedAmount the amount of tokens it will receive
359         function mintToken(address target, uint256 mintedAmount) onlyOwner public {
360             balanceOf[target] = balanceOf[target].add(mintedAmount);
361             totalSupply = totalSupply.add(mintedAmount);
362             emit Transfer(0, this, mintedAmount);
363             emit Transfer(this, target, mintedAmount);
364         }
365 
366         /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
367         /// @param target Address to be frozen
368         /// @param freeze either to freeze it or not
369         function freezeAccount(address target, bool freeze) onlyOwner public {
370                 frozenAccount[target] = freeze;
371             emit  FrozenFunds(target, freeze);
372         }
373 
374         
375         //public variables for the Crowdsale
376         uint256 public exchangeRate = 9672;            // 1 ETH = 9672 Tokens 
377         uint256 public tokensSold = 0;                  // how many tokens sold through crowdsale
378         
379         //@dev fallback function, only accepts ether if pre-sale or ICO is running or Reject
380         function () payable external {
381             require(!safeguard);
382             require(!frozenAccount[msg.sender]);
383             if(whitelistingStatus == true) { require(whitelisted[msg.sender]); }
384             // calculate token amount to be sent
385             uint256 finalTokens = msg.value.mul(exchangeRate).div(1e10);        //weiamount * exchangeRate
386             tokensSold = tokensSold.add(finalTokens);
387             _transfer(this, msg.sender, finalTokens);                           //makes the transfers
388             forwardEherToOwner();                                               //send Ether to owner
389         }
390 
391         //Automatocally forwards ether from smart contract to owner address
392         function forwardEherToOwner() internal {
393             address(owner).transfer(msg.value); 
394         }
395         
396         //Function to set ICO Exchange rate. 
397         //1 ETH = How many Tokens ?
398         function setICOExchangeRate(uint256 newExchangeRate) onlyOwner public {
399             exchangeRate=newExchangeRate;
400         }
401         
402         //Just in case, owner wants to transfer Tokens from contract to owner address
403         function manualWithdrawToken(uint256 _amount) onlyOwner public {
404             uint256 tokenAmount = _amount.mul(1e8);
405             _transfer(this, msg.sender, tokenAmount);
406         }
407           
408         //Just in case, owner wants to transfer Ether from contract to owner address
409         function manualWithdrawEther()onlyOwner public{
410             uint256 amount=address(this).balance;
411             address(owner).transfer(amount);
412         }
413         
414         //selfdestruct function. just in case owner decided to destruct this contract.
415         function destructContract()onlyOwner public{
416             selfdestruct(owner);
417         }
418         
419         /**
420          * Change safeguard status on or off
421          *
422          * When safeguard is true, then all the non-owner functions will stop working.
423          * When safeguard is false, then all the functions will resume working back again!
424          */
425         function changeSafeguardStatus() onlyOwner public{
426             if (safeguard == false){
427                 safeguard = true;
428             }
429             else{
430                 safeguard = false;    
431             }
432         }
433         
434 }