1 pragma solidity 0.5.7; /*
2 
3 ___________________________________________________________________
4   _      _                                        ______           
5   |  |  /          /                                /              
6 --|-/|-/-----__---/----__----__---_--_----__-------/-------__------
7   |/ |/    /___) /   /   ' /   ) / /  ) /___)     /      /   )     
8 __/__|____(___ _/___(___ _(___/_/_/__/_(___ _____/______(___/__o_o_
9 
10 
11 
12  █████╗ ███╗   ██╗██████╗  █████╗ ███╗   ███╗ █████╗ ███╗   ██╗     ██████╗ ██████╗ ██╗███╗   ██╗
13 ██╔══██╗████╗  ██║██╔══██╗██╔══██╗████╗ ████║██╔══██╗████╗  ██║    ██╔════╝██╔═══██╗██║████╗  ██║
14 ███████║██╔██╗ ██║██║  ██║███████║██╔████╔██║███████║██╔██╗ ██║    ██║     ██║   ██║██║██╔██╗ ██║
15 ██╔══██║██║╚██╗██║██║  ██║██╔══██║██║╚██╔╝██║██╔══██║██║╚██╗██║    ██║     ██║   ██║██║██║╚██╗██║
16 ██║  ██║██║ ╚████║██████╔╝██║  ██║██║ ╚═╝ ██║██║  ██║██║ ╚████║    ╚██████╗╚██████╔╝██║██║ ╚████║
17 ╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝     ╚═════╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝
18                                                                                                  
19  
20   
21 // ----------------------------------------------------------------------------
22 // 'ANM' Token contract with following features
23 //      => ERC20 Compliance
24 //      => Higher degree of control by owner - safeguard functionality
25 //      => selfdestruct ability by owner
26 //      => SafeMath implementation 
27 //      => Burnable and minting
28 //      => air drop
29 //
30 // Name        : ANDAMAN coin
31 // Symbol      : ANM
32 // Total supply: 1,000,000,000 (1 Billion)
33 // Decimals    : 18
34 //
35 // Copyright (c) 2019 onwards Andamaner.com. All rights reserved ( http://andamaner.com )
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
83         address payable public owner;
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
94         function transferOwnership(address payable newOwner) onlyOwner public {
95             owner = newOwner;
96         }
97     }
98     
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
110         uint256 public decimals = 18; // 18 decimals is the strongly suggested default, avoid changing it
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
135             totalSupply = initialSupply * (10**decimals);         // Update total supply with the decimal amount
136             balanceOf[msg.sender] = totalSupply;          
137             name = tokenName;                                   // Set the name for display purposes
138             symbol = tokenSymbol;                               // Set the symbol for display purposes
139             emit Transfer(address(0), msg.sender, totalSupply);// Emit event to log this transaction
140             
141         }
142     
143         /**
144          * Internal transfer, only can be called by this contract
145          */
146         function _transfer(address _from, address _to, uint _value) internal {
147             require(!safeguard);
148             // Prevent transfer to 0x0 address. Use burn() instead
149             require(_to != address(0x0));
150             // Check if the sender has enough
151             require(balanceOf[_from] >= _value);
152             // Check for overflows
153             require(balanceOf[_to].add(_value) > balanceOf[_to]);
154             // Save this for an assertion in the future
155             uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
156             // Subtract from the sender
157             balanceOf[_from] = balanceOf[_from].sub(_value);
158             // Add the same to the recipient
159             balanceOf[_to] = balanceOf[_to].add(_value);
160             emit Transfer(_from, _to, _value);
161             // Asserts are used to use static analysis to find bugs in your code. They should never fail
162             assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
163         }
164     
165         /**
166          * Transfer tokens
167          *
168          * Send `_value` tokens to `_to` from your account
169          *
170          * @param _to The address of the recipient
171          * @param _value the amount to send
172          */
173         function transfer(address _to, uint256 _value) public returns (bool success) {
174             _transfer(msg.sender, _to, _value);
175             return true;
176         }
177     
178         /**
179          * Transfer tokens from other address
180          *
181          * Send `_value` tokens to `_to` in behalf of `_from`
182          *
183          * @param _from The address of the sender
184          * @param _to The address of the recipient
185          * @param _value the amount to send
186          */
187         function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
188             require(!safeguard);
189             require(_value <= allowance[_from][msg.sender]);     // Check allowance
190             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
191             _transfer(_from, _to, _value);
192             return true;
193         }
194     
195         /**
196          * Set allowance for other address
197          *
198          * Allows `_spender` to spend no more than `_value` tokens in your behalf
199          *
200          * @param _spender The address authorized to spend
201          * @param _value the max amount they can spend
202          */
203         function approve(address _spender, uint256 _value) public
204             returns (bool success) {
205             require(!safeguard);
206             allowance[msg.sender][_spender] = _value;
207             return true;
208         }
209     
210     
211         /**
212          * Destroy tokens
213          *
214          * Remove `_value` tokens from the system irreversibly
215          *
216          * @param _value the amount of money to burn
217          */
218         function burn(uint256 _value) public returns (bool success) {
219             require(!safeguard);
220             require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
221             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
222             totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
223             emit Burn(msg.sender, _value);
224             return true;
225         }
226     
227         /**
228          * Destroy tokens from other account
229          *
230          * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
231          *
232          * @param _from the address of the sender
233          * @param _value the amount of money to burn
234          */
235         function burnFrom(address _from, uint256 _value) public returns (bool success) {
236             require(!safeguard);
237             require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
238             require(_value <= allowance[_from][msg.sender]);    // Check allowance
239             balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
240             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
241             totalSupply = totalSupply.sub(_value);                              // Update totalSupply
242             emit  Burn(_from, _value);
243             return true;
244         }
245         
246     }
247     
248 //****************************************************************************//
249 //---------------------  ANM MAIN CODE STARTS HERE ---------------------//
250 //****************************************************************************//
251     
252     contract AndamanCoin is owned, TokenERC20 {
253         
254 
255         /*********************************/
256         /* Code for the ERC20 ANM Token */
257         /*********************************/
258     
259         /* Public variables of the token */
260         string private tokenName = "Andaman coin";
261         string private tokenSymbol = "ANM";
262         uint256 private initialSupply = 1000000000;  //1 Billion
263         
264         
265         
266         /* Records for the fronzen accounts */
267         mapping (address => bool) public frozenAccount;
268         
269         /* This generates a public event on the blockchain that will notify clients */
270         event FrozenFunds(address target, bool frozen);
271     
272         /* Initializes contract with initial supply tokens to the creator of the contract */
273         constructor () TokenERC20(initialSupply, tokenName, tokenSymbol) public {
274             
275         }
276 
277         /* Internal transfer, only can be called by this contract */
278         function _transfer(address _from, address _to, uint _value) internal {
279             require(!safeguard);
280             require (_to != address(0x0));                      // Prevent transfer to 0x0 address. Use burn() instead
281             require (balanceOf[_from] >= _value);               // Check if the sender has enough
282             require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
283             require(!frozenAccount[_from]);                     // Check if sender is frozen
284             require(!frozenAccount[_to]);                       // Check if recipient is frozen
285             balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the sender
286             balanceOf[_to] = balanceOf[_to].add(_value);        // Add the same to the recipient
287             emit Transfer(_from, _to, _value);
288         }
289         
290         /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
291         /// @param target Address to be frozen
292         /// @param freeze either to freeze it or not
293         function freezeAccount(address target, bool freeze) onlyOwner public {
294                 frozenAccount[target] = freeze;
295             emit  FrozenFunds(target, freeze);
296         }
297         
298         /// @notice Create `mintedAmount` tokens and send it to `target`
299         /// @param target Address to receive the tokens
300         /// @param mintedAmount the amount of tokens it will receive
301         function mintToken(address target, uint256 mintedAmount) onlyOwner public {
302             balanceOf[target] = balanceOf[target].add(mintedAmount);
303             totalSupply = totalSupply.add(mintedAmount);
304             emit Transfer(address(0), target, mintedAmount);
305         }
306 
307           
308         //Just in rare case, owner wants to transfer Ether from contract to owner address
309         function manualWithdrawEther()onlyOwner public{
310             address(owner).transfer(address(this).balance);
311         }
312         
313         function manualWithdrawTokens(uint256 tokenAmount) public onlyOwner{
314             // no need for overflow checking as that will be done in transfer function
315             _transfer(address(this), owner, tokenAmount);
316         }
317         
318         //selfdestruct function. just in case owner decided to destruct this contract.
319         function destructContract()onlyOwner public{
320             selfdestruct(owner);
321         }
322         
323         /**
324          * Change safeguard status on or off
325          *
326          * When safeguard is true, then all the non-owner functions will stop working.
327          * When safeguard is false, then all the functions will resume working back again!
328          */
329         function changeSafeguardStatus() onlyOwner public{
330             if (safeguard == false){
331                 safeguard = true;
332             }
333             else{
334                 safeguard = false;    
335             }
336         }
337         
338         /********************************/
339         /*    Code for the Air drop     */
340         /********************************/
341         
342         /**
343          * Run an Air-Drop
344          *
345          * It requires an array of all the addresses and amount of tokens to distribute
346          * It will only process first 150 recipients. That limit is fixed to prevent gas limit
347          */
348         function airdrop(address[] memory recipients,uint tokenAmount) public onlyOwner {
349             uint256 addressCount = recipients.length;
350             require(addressCount <= 150);
351             for(uint i = 0; i < addressCount; i++)
352             {
353                   //This will loop through all the recipients and send them the specified tokens
354                   _transfer(address(this), recipients[i], tokenAmount);
355             }
356         }
357 
358 }