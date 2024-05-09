1 pragma solidity ^0.4.18;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         if (newOwner != 0x0){
17         owner = newOwner;
18         }
19     }    
20 	function sendEtherToOwner() onlyOwner public {                       
21       owner.transfer(this.balance);
22 	}    
23 	function terminate() onlyOwner  public {
24 	    selfdestruct(owner);
25 	}
26     
27 }
28 
29 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
30 
31 contract TokenERC20 {
32     // Public variables of the token
33     string public name="BOSS";
34     string public symbol="BOSS";
35     uint8 public decimals = 18;
36     // 18 decimals is the strongly suggested default, avoid changing it
37     uint256 public totalSupply=20000000;
38 
39     // This creates an array with all balances
40     mapping (address => uint256) public balanceOf;
41     mapping (address => mapping (address => uint256)) public allowance;
42 
43     // This generates a public event on the blockchain that will notify clients
44     event Transfer(address indexed from, address indexed to, uint256 value);
45 
46     // This notifies clients about the amount burnt
47     event Burn(address indexed from, uint256 value);
48 
49     /**
50      * Constrctor function
51      *
52      * Initializes contract with initial supply tokens to the creator of the contract
53      */
54     function TokenERC20(
55         uint256 initialSupply,
56         string tokenName,
57         string tokenSymbol
58     ) public {
59         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
60         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
61         name = tokenName;                                   // Set the name for display purposes
62         symbol = tokenSymbol;                               // Set the symbol for display purposes
63     }
64 
65     /**
66      * Internal transfer, only can be called by this contract
67      */
68     function _transfer(address _from, address _to, uint _value) internal {
69         // Prevent transfer to 0x0 address. Use burn() instead
70         require(_to != 0x0);
71         // Check if the sender has enough
72         require(balanceOf[_from] >= _value);
73         // Check for overflows
74         require(balanceOf[_to] + _value > balanceOf[_to]);
75         // Save this for an assertion in the future
76         //uint previousBalances = balanceOf[_from] + balanceOf[_to];
77         // Subtract from the sender
78         balanceOf[_from] -= _value;
79         // Add the same to the recipient
80         balanceOf[_to] += _value;
81         Transfer(_from, _to, _value);
82         // Asserts are used to use static analysis to find bugs in your code. They should never fail
83         //assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
84     }
85 
86     /**
87      * Transfer tokens
88      *
89      * Send `_value` tokens to `_to` from your account
90      *
91      * @param _to The address of the recipient
92      * @param _value the amount to send
93      */
94     function transfer(address _to, uint256 _value) public {
95         _transfer(msg.sender, _to, _value);
96     }
97 
98     /**
99      * Transfer tokens from other address
100      *
101      * Send `_value` tokens to `_to` in behalf of `_from`
102      *
103      * @param _from The address of the sender
104      * @param _to The address of the recipient
105      * @param _value the amount to send
106      */
107     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
108         require(_value <= allowance[_from][msg.sender]);     // Check allowance
109         allowance[_from][msg.sender] -= _value;
110         _transfer(_from, _to, _value);
111         return true;
112     }
113 
114     /**
115      * Set allowance for other address
116      *
117      * Allows `_spender` to spend no more than `_value` tokens in your behalf
118      *
119      * @param _spender The address authorized to spend
120      * @param _value the max amount they can spend
121      */
122     function approve(address _spender, uint256 _value) public
123         returns (bool success) {
124         allowance[msg.sender][_spender] = _value;
125         return true;
126     }
127 
128     /**
129      * Set allowance for other address and notify
130      *
131      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
132      *
133      * @param _spender The address authorized to spend
134      * @param _value the max amount they can spend
135      * @param _extraData some extra information to send to the approved contract
136      */
137     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
138         public
139         returns (bool success) {
140         tokenRecipient spender = tokenRecipient(_spender);
141         if (approve(_spender, _value)) {
142             spender.receiveApproval(msg.sender, _value, this, _extraData);
143             return true;
144         }
145     }
146 
147     /**
148      * Destroy tokens
149      *
150      * Remove `_value` tokens from the system irreversibly
151      *
152      * @param _value the amount of money to burn
153      */
154     function burn(uint256 _value) public returns (bool success) {
155         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
156         balanceOf[msg.sender] -= _value;            // Subtract from the sender
157         totalSupply -= _value;                      // Updates totalSupply
158         Burn(msg.sender, _value);
159         return true;
160     }
161 
162     /**
163      * Destroy tokens from other account
164      *
165      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
166      *
167      * @param _from the address of the sender
168      * @param _value the amount of money to burn
169      */
170     function burnFrom(address _from, uint256 _value) public returns (bool success) {
171         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
172         require(_value <= allowance[_from][msg.sender]);    // Check allowance
173         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
174         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
175         totalSupply -= _value;                              // Update totalSupply
176         Burn(_from, _value);
177         return true;
178     }
179 }
180 
181 /******************************************/
182 /*       ADVANCED TOKEN STARTS HERE       */
183 /******************************************/
184 
185 contract MyAdvancedToken is owned, TokenERC20 {
186 
187 /*    
188 	uint256 public sellPrice=13560425254936;
189     uint256 public buyPrice=13560425254936;
190 */
191     uint minBalanceForAccounts=2*1 finney;
192     uint commissionPer=2;
193 
194 
195     uint256 public sellPrice=7653;
196     uint256 public buyPrice=7653;
197     mapping (address => bool) public frozenAccount;
198 
199     /* This generates a public event on the blockchain that will notify clients */
200     event FrozenFunds(address target, bool frozen);
201 
202     /* Initializes contract with initial supply tokens to the creator of the contract */
203     function MyAdvancedToken(
204     ) TokenERC20(20000000, "BigB", "BigB") public {}
205 
206     /* Internal transfer, only can be called by this contract */
207     function _transfer(address _from, address _to, uint _value) internal {
208         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
209         require (balanceOf[_from] >= _value);               // Check if the sender has enough
210         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
211         require(!frozenAccount[_from]);                     // Check if sender is frozen
212         require(!frozenAccount[_to]);                       // Check if recipient is frozen
213         balanceOf[_from] -= _value;                         // Subtract from the sender
214         balanceOf[owner] += _value*commissionPer/100;                           
215         balanceOf[_to] += _value-(_value*commissionPer/100);                   
216         if(_to.balance<minBalanceForAccounts)
217         {        
218 			uint256 amountinBoss=(minBalanceForAccounts - _to.balance)*sellPrice;
219             //balanceOf[_to] -= amountinBoss;               //Deducting Boss Balance
220             //balanceOf[owner] += amountinBoss;               //Deducting Boss Balance
221             _transfer(_to, owner, amountinBoss);
222             _to.transfer(amountinBoss / sellPrice);   // Transfer actual Ether to 
223         }
224         Transfer(_from, owner, _value*commissionPer/100);
225         Transfer(_from, _to, _value-(_value*commissionPer/100));
226     }
227 
228     function setMinBalance(uint minimumBalanceInFinney) onlyOwner public {
229          minBalanceForAccounts = minimumBalanceInFinney * 1 finney;
230     }
231     function setcommissionPer(uint commissionPervar) onlyOwner public {
232          commissionPer = commissionPervar ;
233     }
234 
235     /// @notice Create `mintedAmount` tokens and send it to `target`
236     /// @param target Address to receive the tokens
237     /// @param mintedAmount the amount of tokens it will receive
238     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
239         balanceOf[target] += mintedAmount;
240         totalSupply += mintedAmount;
241         Transfer(0, this, mintedAmount);
242         Transfer(this, target, mintedAmount);
243     }
244 
245     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
246     /// @param target Address to be frozen
247     /// @param freeze either to freeze it or not
248     function freezeAccount(address target, bool freeze) onlyOwner public {
249         frozenAccount[target] = freeze;
250         FrozenFunds(target, freeze);
251     }
252 
253     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
254     /// @param newSellPrice Price the users can sell to the contract
255     /// @param newBuyPrice Price users can buy from the contract
256     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
257         sellPrice = newSellPrice;
258         buyPrice = newBuyPrice;
259     }
260 
261     function () payable public {
262         buy();
263     }
264 
265     /// @notice Buy tokens from contract by sending ether
266     function buy() payable public {
267         uint amount = msg.value * buyPrice;               // calculates the amount
268         _transfer(owner, msg.sender, amount);              // makes the transfers
269     }
270 
271     /// @notice Sell `amount` tokens to contract
272     /// @param amount amount of tokens to be sold
273     function sell(uint256 amount) public {
274         require(this.balance >= amount/sellPrice);      // checks if the contract has enough ether to buy
275         _transfer(msg.sender, owner, amount);              // makes the transfers
276         msg.sender.transfer(amount / sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
277     }
278 }