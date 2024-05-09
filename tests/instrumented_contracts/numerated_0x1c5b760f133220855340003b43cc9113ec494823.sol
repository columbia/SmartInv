1 pragma solidity 0.4.25; /*
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
12  ██████╗ ██████╗ ██╗███╗   ██╗████████╗ ██████╗ ██████╗  ██████╗ ██╗  ██╗
13 ██╔════╝██╔═══██╗██║████╗  ██║╚══██╔══╝██╔═══██╗██╔══██╗██╔═══██╗╚██╗██╔╝
14 ██║     ██║   ██║██║██╔██╗ ██║   ██║   ██║   ██║██████╔╝██║   ██║ ╚███╔╝ 
15 ██║     ██║   ██║██║██║╚██╗██║   ██║   ██║   ██║██╔══██╗██║   ██║ ██╔██╗ 
16 ╚██████╗╚██████╔╝██║██║ ╚████║   ██║   ╚██████╔╝██║  ██║╚██████╔╝██╔╝ ██╗
17  ╚═════╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝
18                                                                          
19 
20 // ----------------------------------------------------------------------------
21 // 'Cointorox' Token contract with following features
22 //      => ERC20 Compliance
23 //      => Higher control of ICO by owner
24 //      => selfdestruct ability by owner
25 //      => SafeMath implementation 
26 //      => User whitelisting
27 //      => Burnable and no minting
28 //
29 // Name        : Cointorox
30 // Symbol      : OROX
31 // Total supply: 10,000,000 (10 Million)
32 // Decimals    : 18
33 //
34 // Copyright (c) 2018 Cointorox Inc. ( https://cointorox.com )
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
82         address public owner;
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
93         function transferOwnership(address newOwner) onlyOwner public {
94             owner = newOwner;
95         }
96     }
97     
98     interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes  _extraData) external; }
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
134             totalSupply = initialSupply.mul(1 ether);       // Update total supply with the decimal amount
135             balanceOf[msg.sender] = totalSupply;            // All the tokens will be sent to owner
136             name = tokenName;                               // Set the name for display purposes
137             symbol = tokenSymbol;                           // Set the symbol for display purposes
138         }
139     
140         /**
141          * Internal transfer, only can be called by this contract
142          */
143         function _transfer(address _from, address _to, uint _value) internal {
144             require(!safeguard);
145             // Prevent transfer to 0x0 address. Use burn() instead
146             require(_to != address(0x0));
147             // Check if the sender has enough
148             require(balanceOf[_from] >= _value);
149             // Check for overflows
150             require(balanceOf[_to].add(_value) > balanceOf[_to]);
151             // Save this for an assertion in the future
152             uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
153             // Subtract from the sender
154             balanceOf[_from] = balanceOf[_from].sub(_value);
155             // Add the same to the recipient
156             balanceOf[_to] = balanceOf[_to].add(_value);
157             emit Transfer(_from, _to, _value);
158             // Asserts are used to use static analysis to find bugs in your code. They should never fail
159             assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
160         }
161     
162         /**
163          * Transfer tokens
164          *
165          * Send `_value` tokens to `_to` from your account
166          *
167          * @param _to The address of the recipient
168          * @param _value the amount to send
169          */
170         function transfer(address _to, uint256 _value) public returns (bool success) {
171             _transfer(msg.sender, _to, _value);
172             return true;
173         }
174     
175         /**
176          * Transfer tokens from other address
177          *
178          * Send `_value` tokens to `_to` in behalf of `_from`
179          *
180          * @param _from The address of the sender
181          * @param _to The address of the recipient
182          * @param _value the amount to send
183          */
184         function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
185             require(!safeguard);
186             require(_value <= allowance[_from][msg.sender]);     // Check allowance
187             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
188             _transfer(_from, _to, _value);
189             return true;
190         }
191     
192         /**
193          * Set allowance for other address
194          *
195          * Allows `_spender` to spend no more than `_value` tokens in your behalf
196          *
197          * @param _spender The address authorized to spend
198          * @param _value the max amount they can spend
199          */
200         function approve(address _spender, uint256 _value) public
201             returns (bool success) {
202             require(!safeguard);
203             allowance[msg.sender][_spender] = _value;
204             return true;
205         }
206     
207         /**
208          * Set allowance for other address and notify
209          *
210          * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
211          *
212          * @param _spender The address authorized to spend
213          * @param _value the max amount they can spend
214          * @param _extraData some extra information to send to the approved contract
215          */
216         function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
217             public
218             returns (bool success) {
219             require(!safeguard);
220             tokenRecipient spender = tokenRecipient(_spender);
221             if (approve(_spender, _value)) {
222                 spender.receiveApproval(msg.sender, _value, address(this), _extraData);
223                 return true;
224             }
225         }
226     
227         /**
228          * Destroy tokens
229          *
230          * Remove `_value` tokens from the system irreversibly
231          *
232          * @param _value the amount of money to burn
233          */
234         function burn(uint256 _value) public returns (bool success) {
235             require(!safeguard);
236             require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
237             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
238             totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
239             emit Burn(msg.sender, _value);
240             return true;
241         }
242     
243         /**
244          * Destroy tokens from other account
245          *
246          * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
247          *
248          * @param _from the address of the sender
249          * @param _value the amount of money to burn
250          */
251         function burnFrom(address _from, uint256 _value) public returns (bool success) {
252             require(!safeguard);
253             require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
254             require(_value <= allowance[_from][msg.sender]);    // Check allowance
255             balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
256             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
257             totalSupply = totalSupply.sub(_value);                              // Update totalSupply
258             emit  Burn(_from, _value);
259             return true;
260         }
261         
262     }
263     
264 //****************************************************************************//
265 //---------------------  COINTOROX MAIN CODE STARTS HERE ---------------------//
266 //****************************************************************************//
267     
268     contract Cointorox is owned, TokenERC20 {
269         
270         /*************************************/
271         /*  User whitelisting functionality  */
272         /*************************************/
273         bool public whitelistingStatus = false;
274         mapping (address => bool) public whitelisted;
275         
276         /**
277          * Change whitelisting status on or off
278          *
279          * When whitelisting is true, then crowdsale will only accept investors who are whitelisted.
280          */
281         function changeWhitelistingStatus() onlyOwner public{
282             if (whitelistingStatus == false){
283                 whitelistingStatus = true;
284             }
285             else{
286                 whitelistingStatus = false;    
287             }
288         }
289         
290         /**
291          * Whitelist any user address - only Owner can do this
292          *
293          * It will add user address in whitelisted mapping
294          */
295         function whitelistUser(address userAddress) onlyOwner public{
296             require(whitelistingStatus == true);
297             require(userAddress != address(0x0));
298             whitelisted[userAddress] = true;
299         }
300         
301         /**
302          * Whitelist Many user address at once - only Owner can do this
303          * It will require maximum of 150 addresses to prevent block gas limit max-out and DoS attack
304          * It will add user address in whitelisted mapping
305          */
306         function whitelistManyUsers(address[] memory userAddresses) onlyOwner public{
307             require(whitelistingStatus == true);
308             uint256 addressCount = userAddresses.length;
309             require(addressCount <= 150);
310             for(uint256 i = 0; i < addressCount; i++){
311                 require(userAddresses[i] != address(0x0));
312                 whitelisted[userAddresses[i]] = true;
313             }
314         }
315         
316         
317         
318         /*********************************/
319         /* Code for the ERC20 OROX Token */
320         /*********************************/
321     
322         /* Public variables of the token */
323         string private tokenName = "Cointorox";
324         string private tokenSymbol = "OROX";
325         uint256 private initialSupply = 10000000;  //10 Million
326         
327         
328         /* Records for the fronzen accounts */
329         mapping (address => bool) public frozenAccount;
330         
331         /* This generates a public event on the blockchain that will notify clients */
332         event FrozenFunds(address target, bool frozen);
333     
334         /* Initializes contract with initial supply tokens to the creator of the contract */
335         constructor () TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
336 
337         /* Internal transfer, only can be called by this contract */
338         function _transfer(address _from, address _to, uint _value) internal {
339             require(!safeguard);
340             require (_to != address(0x0));                      // Prevent transfer to 0x0 address. Use burn() instead
341             require (balanceOf[_from] >= _value);               // Check if the sender has enough
342             require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
343             require(!frozenAccount[_from]);                     // Check if sender is frozen
344             require(!frozenAccount[_to]);                       // Check if recipient is frozen
345             balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the sender
346             balanceOf[_to] = balanceOf[_to].add(_value);        // Add the same to the recipient
347             emit Transfer(_from, _to, _value);
348         }
349         
350         /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
351         /// @param target Address to be frozen
352         /// @param freeze either to freeze it or not
353         function freezeAccount(address target, bool freeze) onlyOwner public {
354                 frozenAccount[target] = freeze;
355             emit  FrozenFunds(target, freeze);
356         }
357 
358           
359         //Just in rare case, owner wants to transfer Ether from contract to owner address
360         function manualWithdrawEther()onlyOwner public{
361             address(owner).transfer(address(this).balance);
362         }
363         
364         //selfdestruct function. just in case owner decided to destruct this contract.
365         function destructContract()onlyOwner public{
366             selfdestruct(owner);
367         }
368         
369         /**
370          * Change safeguard status on or off
371          *
372          * When safeguard is true, then all the non-owner functions will stop working.
373          * When safeguard is false, then all the functions will resume working back again!
374          */
375         function changeSafeguardStatus() onlyOwner public{
376             if (safeguard == false){
377                 safeguard = true;
378             }
379             else{
380                 safeguard = false;    
381             }
382         }
383 
384 }