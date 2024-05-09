1 pragma solidity 0.5.4; /*
2 
3 ___________________________________________________________________
4   _      _                                        ______           
5   |  |  /          /                                /              
6 --|-/|-/-----__---/----__----__---_--_----__-------/-------__------
7   |/ |/    /___) /   /   ' /   ) / /  ) /___)     /      /   )     
8 __/__|____(___ _/___(___ _(___/_/_/__/_(___ _____/______(___/__o_o_
9 
10 
11  .----------------.   .----------------.   .----------------.   .----------------. 
12 | .--------------. | | .--------------. | | .--------------. | | .--------------. |
13 | |     _____    | | | |   ______     | | | | _____  _____ | | | |  ____  ____  | |
14 | |    |_   _|   | | | |  |_   __ \   | | | ||_   _||_   _|| | | | |_  _||_  _| | |
15 | |      | |     | | | |    | |__) |  | | | |  | |    | |  | | | |   \ \  / /   | |
16 | |      | |     | | | |    |  ___/   | | | |  | '    ' |  | | | |    > `' <    | |
17 | |     _| |_    | | | |   _| |_      | | | |   \ `--' /   | | | |  _/ /'`\ \_  | |
18 | |    |_____|   | | | |  |_____|     | | | |    `.__.'    | | | | |____||____| | |
19 | |              | | | |              | | | |              | | | |              | |
20 | '--------------' | | '--------------' | | '--------------' | | '--------------' |
21  '----------------'   '----------------'   '----------------'   '----------------' 
22 
23   
24 // ----------------------------------------------------------------------------
25 // 'IPUX' Token contract with following features
26 //      => ERC20 Compliance
27 //      => Higher degree of control by owner - safeguard functionality
28 //      => selfdestruct ability by owner
29 //      => SafeMath implementation 
30 //      => Burnable and minting
31 //      => air drop
32 //
33 // Name        : IPUX token
34 // Symbol      : IPUX
35 // Total supply: 1,000,000,000 (1 Billion)
36 // Decimals    : 18
37 //
38 // Copyright (c) 2019 TradeWeIPUX Limited ( https://ipux.io )
39 // Contract designed by EtherAuthority ( https://EtherAuthority.io )
40 // ----------------------------------------------------------------------------
41   
42 */ 
43 
44 //*******************************************************************//
45 //------------------------ SafeMath Library -------------------------//
46 //*******************************************************************//
47     /**
48      * @title SafeMath
49      * @dev Math operations with safety checks that throw on error
50      */
51     library SafeMath {
52       function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53         if (a == 0) {
54           return 0;
55         }
56         uint256 c = a * b;
57         assert(c / a == b);
58         return c;
59       }
60     
61       function div(uint256 a, uint256 b) internal pure returns (uint256) {
62         // assert(b > 0); // Solidity automatically throws when dividing by 0
63         uint256 c = a / b;
64         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
65         return c;
66       }
67     
68       function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         assert(b <= a);
70         return a - b;
71       }
72     
73       function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         uint256 c = a + b;
75         assert(c >= a);
76         return c;
77       }
78     }
79 
80 
81 //*******************************************************************//
82 //------------------ Contract to Manage Ownership -------------------//
83 //*******************************************************************//
84     
85     contract owned {
86         address payable public owner;
87         
88          constructor () public {
89             owner = msg.sender;
90         }
91     
92         modifier onlyOwner {
93             require(msg.sender == owner);
94             _;
95         }
96     
97         function transferOwnership(address payable newOwner) onlyOwner public {
98             owner = newOwner;
99         }
100     }
101     
102  
103 
104 //***************************************************************//
105 //------------------ ERC20 Standard Template -------------------//
106 //***************************************************************//
107     
108     contract TokenERC20 {
109         // Public variables of the token
110         using SafeMath for uint256;
111         string public name;
112         string public symbol;
113         uint256 public decimals = 18; // 18 decimals is the strongly suggested default, avoid changing it
114         uint256 public totalSupply;
115         bool public safeguard = false;  //putting safeguard on will halt all non-owner functions
116         address public icoContractAddress;
117     
118         // This creates an array with all balances
119         mapping (address => uint256) public balanceOf;
120         mapping (address => mapping (address => uint256)) public allowance;
121     
122         // This generates a public event on the blockchain that will notify clients
123         event Transfer(address indexed from, address indexed to, uint256 value);
124     
125         // This notifies clients about the amount burnt
126         event Burn(address indexed from, uint256 value);
127     
128         /**
129          * Constrctor function
130          *
131          * Initializes contract with initial supply tokens to the creator of the contract
132          */
133         constructor (
134             uint256 initialSupply,
135             string memory tokenName,
136             string memory tokenSymbol,
137             address _icoContractAddress
138         ) public {
139             
140             totalSupply = initialSupply * (10**decimals);         // Update total supply with the decimal amount
141             uint256 tokensReserved  = 800000000 * (10**decimals); // 800 Million tokens will remain in the contract
142             uint256 tokensCrowdsale = 200000000 * (10**decimals); // 200 million tokens will be sent to ICO contract for public ICO
143             
144             balanceOf[address(this)] = tokensReserved;          
145             balanceOf[_icoContractAddress] = tokensCrowdsale;
146             
147             name = tokenName;                                   // Set the name for display purposes
148             symbol = tokenSymbol;                               // Set the symbol for display purposes
149             icoContractAddress = _icoContractAddress;           // set ICO contract address
150             
151             emit Transfer(address(0), address(this), tokensReserved);// Emit event to log this transaction
152             emit Transfer(address(0), _icoContractAddress, tokensCrowdsale);// Emit event to log this transaction
153     
154         }
155     
156         /**
157          * Internal transfer, only can be called by this contract
158          */
159         function _transfer(address _from, address _to, uint _value) internal {
160             require(!safeguard);
161             // Prevent transfer to 0x0 address. Use burn() instead
162             require(_to != address(0x0));
163             // Check if the sender has enough
164             require(balanceOf[_from] >= _value);
165             // Check for overflows
166             require(balanceOf[_to].add(_value) > balanceOf[_to]);
167             // Save this for an assertion in the future
168             uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
169             // Subtract from the sender
170             balanceOf[_from] = balanceOf[_from].sub(_value);
171             // Add the same to the recipient
172             balanceOf[_to] = balanceOf[_to].add(_value);
173             emit Transfer(_from, _to, _value);
174             // Asserts are used to use static analysis to find bugs in your code. They should never fail
175             assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
176         }
177     
178         /**
179          * Transfer tokens
180          *
181          * Send `_value` tokens to `_to` from your account
182          *
183          * @param _to The address of the recipient
184          * @param _value the amount to send
185          */
186         function transfer(address _to, uint256 _value) public returns (bool success) {
187             _transfer(msg.sender, _to, _value);
188             return true;
189         }
190     
191         /**
192          * Transfer tokens from other address
193          *
194          * Send `_value` tokens to `_to` in behalf of `_from`
195          *
196          * @param _from The address of the sender
197          * @param _to The address of the recipient
198          * @param _value the amount to send
199          */
200         function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
201             require(!safeguard);
202             require(_value <= allowance[_from][msg.sender]);     // Check allowance
203             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
204             _transfer(_from, _to, _value);
205             return true;
206         }
207     
208         /**
209          * Set allowance for other address
210          *
211          * Allows `_spender` to spend no more than `_value` tokens in your behalf
212          *
213          * @param _spender The address authorized to spend
214          * @param _value the max amount they can spend
215          */
216         function approve(address _spender, uint256 _value) public
217             returns (bool success) {
218             require(!safeguard);
219             allowance[msg.sender][_spender] = _value;
220             return true;
221         }
222     
223     
224         /**
225          * Destroy tokens
226          *
227          * Remove `_value` tokens from the system irreversibly
228          *
229          * @param _value the amount of money to burn
230          */
231         function burn(uint256 _value) public returns (bool success) {
232             require(!safeguard);
233             require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
234             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
235             totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
236             emit Burn(msg.sender, _value);
237             return true;
238         }
239     
240         /**
241          * Destroy tokens from other account
242          *
243          * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
244          *
245          * @param _from the address of the sender
246          * @param _value the amount of money to burn
247          */
248         function burnFrom(address _from, uint256 _value) public returns (bool success) {
249             require(!safeguard);
250             require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
251             require(_value <= allowance[_from][msg.sender]);    // Check allowance
252             balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
253             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
254             totalSupply = totalSupply.sub(_value);                              // Update totalSupply
255             emit  Burn(_from, _value);
256             return true;
257         }
258         
259     }
260     
261 //****************************************************************************//
262 //---------------------  IPUX MAIN CODE STARTS HERE ---------------------//
263 //****************************************************************************//
264     
265     contract IPUXtoken is owned, TokenERC20 {
266         
267 
268         /*********************************/
269         /* Code for the ERC20 IPUX Token */
270         /*********************************/
271     
272         /* Public variables of the token */
273         string private tokenName = "IPUX Token";
274         string private tokenSymbol = "IPUX";
275         uint256 private initialSupply = 1000000000;  //1 Billion
276         
277         
278         
279         /* Records for the fronzen accounts */
280         mapping (address => bool) public frozenAccount;
281         
282         /* This generates a public event on the blockchain that will notify clients */
283         event FrozenFunds(address target, bool frozen);
284     
285         /* Initializes contract with initial supply tokens to the creator of the contract */
286         constructor (address icoContractAddress) TokenERC20(initialSupply, tokenName, tokenSymbol, icoContractAddress) public {
287             
288         }
289 
290         /* Internal transfer, only can be called by this contract */
291         function _transfer(address _from, address _to, uint _value) internal {
292             require(!safeguard);
293             require (_to != address(0x0));                      // Prevent transfer to 0x0 address. Use burn() instead
294             require (balanceOf[_from] >= _value);               // Check if the sender has enough
295             require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
296             require(!frozenAccount[_from]);                     // Check if sender is frozen
297             require(!frozenAccount[_to]);                       // Check if recipient is frozen
298             balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the sender
299             balanceOf[_to] = balanceOf[_to].add(_value);        // Add the same to the recipient
300             emit Transfer(_from, _to, _value);
301         }
302         
303         /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
304         /// @param target Address to be frozen
305         /// @param freeze either to freeze it or not
306         function freezeAccount(address target, bool freeze) onlyOwner public {
307                 frozenAccount[target] = freeze;
308             emit  FrozenFunds(target, freeze);
309         }
310         
311         /// @notice Create `mintedAmount` tokens and send it to `target`
312         /// @param target Address to receive the tokens
313         /// @param mintedAmount the amount of tokens it will receive
314         function mintToken(address target, uint256 mintedAmount) onlyOwner public {
315             balanceOf[target] = balanceOf[target].add(mintedAmount);
316             totalSupply = totalSupply.add(mintedAmount);
317             emit Transfer(address(0), target, mintedAmount);
318         }
319 
320           
321         //Just in rare case, owner wants to transfer Ether from contract to owner address
322         function manualWithdrawEther()onlyOwner public{
323             address(owner).transfer(address(this).balance);
324         }
325         
326         function manualWithdrawTokens(uint256 tokenAmount) public onlyOwner{
327             // no need for overflow checking as that will be done in transfer function
328             _transfer(address(this), owner, tokenAmount);
329         }
330         
331         //selfdestruct function. just in case owner decided to destruct this contract.
332         function destructContract()onlyOwner public{
333             selfdestruct(owner);
334         }
335         
336         /**
337          * Change safeguard status on or off
338          *
339          * When safeguard is true, then all the non-owner functions will stop working.
340          * When safeguard is false, then all the functions will resume working back again!
341          */
342         function changeSafeguardStatus() onlyOwner public{
343             if (safeguard == false){
344                 safeguard = true;
345             }
346             else{
347                 safeguard = false;    
348             }
349         }
350         
351         /********************************/
352         /*    Code for the Air drop     */
353         /********************************/
354         
355         /**
356          * Run an Air-Drop
357          *
358          * It requires an array of all the addresses and amount of tokens to distribute
359          * It will only process first 150 recipients. That limit is fixed to prevent gas limit
360          */
361         function airdrop(address[] memory recipients,uint tokenAmount) public onlyOwner {
362             uint256 addressCount = recipients.length;
363             require(addressCount <= 150);
364             for(uint i = 0; i < addressCount; i++)
365             {
366                   //This will loop through all the recipients and send them the specified tokens
367                   _transfer(address(this), recipients[i], tokenAmount);
368             }
369         }
370 
371 }