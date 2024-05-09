1 pragma solidity 0.5.1; /*
2 
3 
4 ___________________________________________________________________
5   _      _                                        ______           
6   |  |  /          /                                /              
7 --|-/|-/-----__---/----__----__---_--_----__-------/-------__------
8   |/ |/    /___) /   /   ' /   ) / /  ) /___)     /      /   )     
9 __/__|____(___ _/___(___ _(___/_/_/__/_(___ _____/______(___/__o_o_
10 
11 
12 
13 ██████╗  ██████╗ ██╗   ██╗██████╗ ██╗     ███████╗    ███████╗████████╗██╗  ██╗███████╗██████╗ 
14 ██╔══██╗██╔═══██╗██║   ██║██╔══██╗██║     ██╔════╝    ██╔════╝╚══██╔══╝██║  ██║██╔════╝██╔══██╗
15 ██║  ██║██║   ██║██║   ██║██████╔╝██║     █████╗      █████╗     ██║   ███████║█████╗  ██████╔╝
16 ██║  ██║██║   ██║██║   ██║██╔══██╗██║     ██╔══╝      ██╔══╝     ██║   ██╔══██║██╔══╝  ██╔══██╗
17 ██████╔╝╚██████╔╝╚██████╔╝██████╔╝███████╗███████╗    ███████╗   ██║   ██║  ██║███████╗██║  ██║
18 ╚═════╝  ╚═════╝  ╚═════╝ ╚═════╝ ╚══════╝╚══════╝    ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
19                                                                                                
20                                                                                                
21 // ----------------------------------------------------------------------------
22 // 'Double Ether' Token contract with following features
23 //      => ERC20 Compliance
24 //      => Safeguard functionality 
25 //      => selfdestruct ability by owner
26 //      => SafeMath implementation 
27 //      => Burnable and no minting
28 //
29 // Name        : Double Ether
30 // Symbol      : DET
31 // Total supply: 100,000,000 (100 Million)
32 // Decimals    : 18
33 //
34 // Copyright (c) 2018 Deteth Inc. ( https://deteth.com )
35 // Contract designed by EtherAuthority ( https://EtherAuthority.io )
36 // ----------------------------------------------------------------------------
37   
38 */ 
39 
40 //*******************************************************************//
41 //------------------------ SafeMath Library -------------------------//
42 //*******************************************************************//
43     /**
44      * @title SafeMath
45      * @dev Math operations with safety checks that throw on error
46      */
47     library SafeMath {
48       function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49         if (a == 0) {
50           return 0;
51         }
52         uint256 c = a * b;
53         assert(c / a == b);
54         return c;
55       }
56     
57       function div(uint256 a, uint256 b) internal pure returns (uint256) {
58         // assert(b > 0); // Solidity automatically throws when dividing by 0
59         uint256 c = a / b;
60         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61         return c;
62       }
63     
64       function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65         assert(b <= a);
66         return a - b;
67       }
68     
69       function add(uint256 a, uint256 b) internal pure returns (uint256) {
70         uint256 c = a + b;
71         assert(c >= a);
72         return c;
73       }
74     }
75 
76 
77 //*******************************************************************//
78 //------------------ Contract to Manage Ownership -------------------//
79 //*******************************************************************//
80     
81     contract owned {
82         address payable public owner;
83         
84          constructor () public {
85             owner = msg.sender;
86         }
87     
88         modifier onlyOwner {
89             require(msg.sender == owner);
90             _;
91         }
92     
93         function transferOwnership(address payable newOwner) onlyOwner public {
94             owner = newOwner;
95         }
96     }
97     
98     interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata  _extraData) external; }
99 
100 
101 //***************************************************************//
102 //------------------ ERC20 Standard Template -------------------//
103 //***************************************************************//
104     
105     contract TokenERC20 {
106         // Public variables of the token
107         using SafeMath for uint256;
108         string public name;
109         string public symbol;
110         uint8 public decimals = 18; // 18 decimals is the strongly suggested default, avoid changing it
111         uint256 public totalSupply;
112         bool public safeguard = false;  //putting safeguard on will halt all non-owner functions
113     
114         // This creates an array with all balances
115         mapping (address => uint256) public balanceOf;
116         mapping (address => mapping (address => uint256)) public allowance;
117     
118         // This generates a public event on the blockchain that will notify clients
119         event Transfer(address indexed from, address indexed to, uint256 value);
120     
121         // This notifies clients about the amount burnt
122         event Burn(address indexed from, uint256 value);
123     
124         /**
125          * Constrctor function
126          *
127          * Initializes contract with initial supply tokens to the creator of the contract
128          */
129         constructor (
130             uint256 initialSupply,
131             string memory tokenName,
132             string memory tokenSymbol
133         ) public {
134             
135             totalSupply = initialSupply * 1 ether;      // Update total supply with the decimal amount
136             uint256 halfTotalSupply = totalSupply / 2;  // Half of the totalSupply
137             
138             balanceOf[msg.sender] = halfTotalSupply;    // 50 Million tokens sent to owner
139             balanceOf[address(this)] = halfTotalSupply; // 50 Million tokens sent to smart contract
140             name = tokenName;                           // Set the name for display purposes
141             symbol = tokenSymbol;                       // Set the symbol for display purposes
142             
143             emit Transfer(address(0x0), msg.sender, halfTotalSupply);   // Transfer event
144             emit Transfer(address(0x0), address(this), halfTotalSupply);// Transfer event
145         }
146     
147         /**
148          * Internal transfer, only can be called by this contract
149          */
150         function _transfer(address _from, address _to, uint _value) internal {
151             require(!safeguard);
152             // Prevent transfer to 0x0 address. Use burn() instead
153             require(_to != address(0x0));
154             // Check if the sender has enough
155             require(balanceOf[_from] >= _value);
156             // Check for overflows
157             require(balanceOf[_to].add(_value) > balanceOf[_to]);
158             // Save this for an assertion in the future
159             uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
160             // Subtract from the sender
161             balanceOf[_from] = balanceOf[_from].sub(_value);
162             // Add the same to the recipient
163             balanceOf[_to] = balanceOf[_to].add(_value);
164             emit Transfer(_from, _to, _value);
165             // Asserts are used to use static analysis to find bugs in your code. They should never fail
166             assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
167         }
168     
169         /**
170          * Transfer tokens
171          *
172          * Send `_value` tokens to `_to` from your account
173          *
174          * @param _to The address of the recipient
175          * @param _value the amount to send
176          */
177         function transfer(address _to, uint256 _value) public returns (bool success) {
178             _transfer(msg.sender, _to, _value);
179             return true;
180         }
181     
182         /**
183          * Transfer tokens from other address
184          *
185          * Send `_value` tokens to `_to` in behalf of `_from`
186          *
187          * @param _from The address of the sender
188          * @param _to The address of the recipient
189          * @param _value the amount to send
190          */
191         function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
192             require(!safeguard);
193             require(_value <= allowance[_from][msg.sender]);     // Check allowance
194             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
195             _transfer(_from, _to, _value);
196             return true;
197         }
198     
199         /**
200          * Set allowance for other address
201          *
202          * Allows `_spender` to spend no more than `_value` tokens in your behalf
203          *
204          * @param _spender The address authorized to spend
205          * @param _value the max amount they can spend
206          */
207         function approve(address _spender, uint256 _value) public
208             returns (bool success) {
209             require(!safeguard);
210             allowance[msg.sender][_spender] = _value;
211             return true;
212         }
213     
214         /**
215          * Set allowance for other address and notify
216          *
217          * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
218          *
219          * @param _spender The address authorized to spend
220          * @param _value the max amount they can spend
221          * @param _extraData some extra information to send to the approved contract
222          */
223         function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
224             public
225             returns (bool success) {
226             require(!safeguard);
227             tokenRecipient spender = tokenRecipient(_spender);
228             if (approve(_spender, _value)) {
229                 spender.receiveApproval(msg.sender, _value, address(this), _extraData);
230                 return true;
231             }
232         }
233     
234         /**
235          * Destroy tokens
236          *
237          * Remove `_value` tokens from the system irreversibly
238          *
239          * @param _value the amount of money to burn
240          */
241         function burn(uint256 _value) public returns (bool success) {
242             require(!safeguard);
243             require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
244             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
245             totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
246             emit Burn(msg.sender, _value);
247             return true;
248         }
249     
250         /**
251          * Destroy tokens from other account
252          *
253          * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
254          *
255          * @param _from the address of the sender
256          * @param _value the amount of money to burn
257          */
258         function burnFrom(address _from, uint256 _value) public returns (bool success) {
259             require(!safeguard);
260             require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
261             require(_value <= allowance[_from][msg.sender]);    // Check allowance
262             balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
263             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
264             totalSupply = totalSupply.sub(_value);                              // Update totalSupply
265             emit  Burn(_from, _value);
266             return true;
267         }
268         
269     }
270     
271 //*******************************************************************************//
272 //---------------------  DOUBLE ETHER MAIN CODE STARTS HERE ---------------------//
273 //*******************************************************************************//
274     
275     contract DoubleEther is owned, TokenERC20 {
276         
277         
278         /********************************/
279         /* Code for the ERC20 DET Token */
280         /********************************/
281     
282         /* Public variables of the token */
283         string internal tokenName = "Double Ether";
284         string internal tokenSymbol = "DET";
285         uint256 internal initialSupply = 100000000;  //100 Million
286         
287         
288         /* Records for the fronzen accounts */
289         mapping (address => bool) public frozenAccount;
290         
291         /* This generates a public event on the blockchain that will notify clients */
292         event FrozenFunds(address target, bool frozen);
293     
294         /* Initializes contract with initial supply tokens to the creator of the contract */
295         constructor () TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
296 
297         /* Internal transfer, only can be called by this contract */
298         function _transfer(address _from, address _to, uint _value) internal {
299             require(!safeguard);
300             require (_to != address(0x0));                      // Prevent transfer to 0x0 address. Use burn() instead
301             require (balanceOf[_from] >= _value);               // Check if the sender has enough
302             require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
303             require(!frozenAccount[_from]);                     // Check if sender is frozen
304             require(!frozenAccount[_to]);                       // Check if recipient is frozen
305             balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the sender
306             balanceOf[_to] = balanceOf[_to].add(_value);        // Add the same to the recipient
307             emit Transfer(_from, _to, _value);
308         }
309         
310         /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
311         /// @param target Address to be frozen
312         /// @param freeze either to freeze it or not
313         function freezeAccount(address target, bool freeze) onlyOwner public {
314                 frozenAccount[target] = freeze;
315             emit  FrozenFunds(target, freeze);
316         }
317         
318         /**
319          * Change safeguard status on or off
320          *
321          * When safeguard is true, then all the non-owner functions will stop working.
322          * When safeguard is false, then all the functions will resume working back again!
323          */
324         function changeSafeguardStatus() onlyOwner public{
325             if (safeguard == false){
326                 safeguard = true;
327             }
328             else{
329                 safeguard = false;    
330             }
331         }
332 
333 
334 
335         /*******************************************/
336         /* Code for the Double Ether Functionality */
337         /*******************************************/
338 
339         
340         uint256 public returnPercentage = 150;  // 150% return, which is 1.5 times the amount deposited 
341         uint256 public additionalFund = 0;
342         address payable[] public winnerQueueAddresses;
343         uint256[] public winnerQueueAmount;
344         
345         // This will log for all the deposits made by users
346         event Deposit(address indexed depositor, uint256 depositAmount);
347         
348         // This will log for any ether paid to users
349         event RewardPaid(address indexed rewardPayee, uint256 rewardAmount);
350         
351         function showPeopleInQueue() public view returns(uint256) {
352             return winnerQueueAmount.length;
353         }
354         
355         //@dev fallback function, which accepts ether
356         function () payable external {
357             require(!safeguard);
358             require(!frozenAccount[msg.sender]);
359             require(msg.value >= 0.5 ether);
360             
361             //If users send more than 3 ether, then it will consider only 3 ether, and rest goes to owner as service fee
362             uint256 _depositedEther;
363             if(msg.value >= 3 ether){
364                 _depositedEther = 3 ether;
365                 additionalFund += msg.value - 3 ether; 
366             }
367             else{
368                 _depositedEther = msg.value;
369             }
370             
371             
372             //following loop will send reward to one or more addresses
373             uint256 TotalPeopleInQueue = winnerQueueAmount.length;
374             for(uint256 index = 0; index < TotalPeopleInQueue; index++){
375                 
376                 if(winnerQueueAmount[0] <= (address(this).balance - additionalFund) ){
377                     
378                     //transfer the ether and token to leader / first position
379                     winnerQueueAddresses[0].transfer(winnerQueueAmount[0]);
380                     _transfer(address(this), winnerQueueAddresses[0], winnerQueueAmount[0]*100/returnPercentage);
381                     
382                     //this will shift one index up in both arrays, removing the person who is paid
383                     for (uint256 i = 0; i<winnerQueueAmount.length-1; i++){
384                         winnerQueueAmount[i] = winnerQueueAmount[i+1];
385                         winnerQueueAddresses[i] = winnerQueueAddresses[i+1];
386                     }
387                     winnerQueueAmount.length--;
388                     winnerQueueAddresses.length--;
389                 }
390                 else{
391                     //because there is not enough ether in contract to pay for leader, so break.
392                     break;
393                 }
394             }
395             
396             //Putting depositor in the queue
397             winnerQueueAddresses.push(msg.sender); 
398             winnerQueueAmount.push(_depositedEther * returnPercentage / 100);
399             emit Deposit(msg.sender, msg.value);
400         }
401 
402     
403 
404         //Just in rare case, owner wants to transfer Ether from contract to owner address.Like owner decided to destruct this contract.
405         function manualWithdrawEtherAll() onlyOwner public{
406             address(owner).transfer(address(this).balance);
407         }
408         
409         //It is useful when owner wants to transfer additionalFund, which is fund sent by users more than 3 ether, or after removing any stuck address.
410         function manualWithdrawEtherAdditionalOnly() onlyOwner public{
411             additionalFund = 0;
412             address(owner).transfer(additionalFund);
413         }
414         
415         //Just in rare case, owner wants to transfer Tokens from contract to owner address
416         function manualWithdrawTokens(uint tokenAmount) onlyOwner public{
417             //no need to validate the input amount as transfer function automatically throws for invalid amounts
418             _transfer(address(this), address(owner), tokenAmount);
419         }
420         
421         //selfdestruct function. just in case owner decided to destruct this contract.
422         function destructContract()onlyOwner public{
423             selfdestruct(owner);
424         }
425         
426         //To remove any stuck address and un-stuck the queue. 
427         //This often happen if user have put contract address, and contract does not receive ether.
428         function removeAddressFromQueue(uint256 index) onlyOwner public {
429             require(index <= winnerQueueAmount.length);
430             additionalFund +=  winnerQueueAmount[index];
431             //this will shift one index up in both arrays, removing the address owner specified
432             for (uint256 i = index; i<winnerQueueAmount.length-1; i++){
433                 winnerQueueAmount[i] = winnerQueueAmount[i+1];
434                 winnerQueueAddresses[i] = winnerQueueAddresses[i+1];
435             }
436             winnerQueueAmount.length--;
437             winnerQueueAddresses.length--;
438         } 
439 
440         /**
441          * This function removes the 35 queues. And restart the game again.
442          * Those people who did not get the ETH will recieve tokens multiplied by 200
443          * Which is: Ether amount * 200 tokens
444          *
445          * 
446          * Ether will remained in the contract will be used toward the next round
447          */
448         function restartTheQueue() onlyOwner public {
449             //To become more gas cost effective, we want to process it differently when addresses are more or less than 35
450             uint256 arrayLength = winnerQueueAmount.length;
451             if(arrayLength < 35){
452                 //if addresses are less than 35 then we will just loop through it and send tokens
453                 for(uint256 i = 0; i < arrayLength; i++){
454                     _transfer(address(this), winnerQueueAddresses[i], winnerQueueAmount[i]*200*100/returnPercentage);
455                 }
456                 //then empty the array, and so the game will begin fresh
457                 winnerQueueAddresses = new address payable[](0);
458                 winnerQueueAmount = new uint256[](0);
459             }
460             else{
461                 //if there are more than 35 addresses, then we will process it differently
462                 //sending tokens to first 35 addresses
463                 for(uint256 i = 0; i < 35; i++){
464                     //doing token transfer
465                     _transfer(address(this), winnerQueueAddresses[i], winnerQueueAmount[i]*200*100/returnPercentage);
466                     
467                     //shifting index one by one
468                     for (uint256 j = 0; j<arrayLength-i-1; j++){
469                         winnerQueueAmount[j] = winnerQueueAmount[j+1];
470                         winnerQueueAddresses[j] = winnerQueueAddresses[j+1];
471                     }
472                 }
473                 //removing total array length by 35
474                 winnerQueueAmount.length -= 35;
475                 winnerQueueAddresses.length -= 35;
476             }
477         }
478 
479 }