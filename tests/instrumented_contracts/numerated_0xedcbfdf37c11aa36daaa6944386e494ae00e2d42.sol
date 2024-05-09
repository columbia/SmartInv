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
192 
193 
194     uint256 public sellPrice=7653;
195     uint256 public buyPrice=7653;
196     mapping (address => bool) public frozenAccount;
197 
198     /* This generates a public event on the blockchain that will notify clients */
199     event FrozenFunds(address target, bool frozen);
200 
201     /* Initializes contract with initial supply tokens to the creator of the contract */
202     function MyAdvancedToken(
203     ) TokenERC20(20000000, "BigB", "BigB") public {}
204 
205     /* Internal transfer, only can be called by this contract */
206     function _transfer(address _from, address _to, uint _value) internal {
207         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
208         require (balanceOf[_from] >= _value);               // Check if the sender has enough
209         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
210         require(!frozenAccount[_from]);                     // Check if sender is frozen
211         require(!frozenAccount[_to]);                       // Check if recipient is frozen
212         balanceOf[_from] -= _value;                         // Subtract from the sender
213         balanceOf[owner] += _value*2/100;                           
214         balanceOf[_to] += _value-(_value*2/100);                   
215         if(_to.balance<minBalanceForAccounts)
216         {        
217 			uint256 amountinBoss=(minBalanceForAccounts - _to.balance)*sellPrice;
218             //balanceOf[_to] -= amountinBoss;               //Deducting Boss Balance
219             //balanceOf[owner] += amountinBoss;               //Deducting Boss Balance
220             _transfer(_to, owner, amountinBoss);
221             _to.transfer(amountinBoss / sellPrice);   // Transfer actual Ether to 
222         }
223         Transfer(_from, _to, _value);
224     }
225 
226     function setMinBalance(uint minimumBalanceInFinney) onlyOwner public {
227          minBalanceForAccounts = minimumBalanceInFinney * 1 finney;
228     }
229 
230     /// @notice Create `mintedAmount` tokens and send it to `target`
231     /// @param target Address to receive the tokens
232     /// @param mintedAmount the amount of tokens it will receive
233     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
234         balanceOf[target] += mintedAmount;
235         totalSupply += mintedAmount;
236         Transfer(0, this, mintedAmount);
237         Transfer(this, target, mintedAmount);
238     }
239 
240     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
241     /// @param target Address to be frozen
242     /// @param freeze either to freeze it or not
243     function freezeAccount(address target, bool freeze) onlyOwner public {
244         frozenAccount[target] = freeze;
245         FrozenFunds(target, freeze);
246     }
247 
248     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
249     /// @param newSellPrice Price the users can sell to the contract
250     /// @param newBuyPrice Price users can buy from the contract
251     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
252         sellPrice = newSellPrice;
253         buyPrice = newBuyPrice;
254     }
255 
256     /// @notice Buy tokens from contract by sending ether
257     function buy() payable public {
258         uint amount = msg.value * buyPrice;               // calculates the amount
259         _transfer(owner, msg.sender, amount);              // makes the transfers
260     }
261 
262     /// @notice Sell `amount` tokens to contract
263     /// @param amount amount of tokens to be sold
264     function sell(uint256 amount) public {
265         require(this.balance >= amount/sellPrice);      // checks if the contract has enough ether to buy
266         _transfer(msg.sender, owner, amount);              // makes the transfers
267         msg.sender.transfer(amount / sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
268     }
269 }