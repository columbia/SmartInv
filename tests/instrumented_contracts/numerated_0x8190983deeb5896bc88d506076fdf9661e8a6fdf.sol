1 pragma solidity ^0.4.16;
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
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract COSMOTokenERC20 {
23     string public constant _myTokeName = 'Cosmo';//
24     string public constant _mySymbol = 'COSMO';//
25     uint public constant _myinitialSupply = 21000000;//
26     uint8 public constant _myDecimal = 18;//
27     // Public variables of the token
28     string public name;
29     string public symbol;
30     uint8 public decimals;
31     // 18 decimals is the strongly suggested default, avoid changing it
32     uint256 public totalSupply;
33 
34     // This creates an array with all balances
35     mapping (address => uint256) public balanceOf;
36     mapping (address => mapping (address => uint256)) public allowance;
37 
38     // This generates a public event on the blockchain that will notify clients
39     event Transfer(address indexed from, address indexed to, uint256 value);
40 
41     // This notifies clients about the amount burnt
42     event Burn(address indexed from, uint256 value);
43 
44     /**
45      * Constructor function
46      *
47      * Initializes contract with initial supply tokens to the creator of the contract
48      */
49     function COSMOTokenERC20(
50        uint256 initialSupply,
51         string tokenName,
52         string tokenSymbol
53     )
54         
55      public {
56         decimals = _myDecimal;
57         totalSupply = _myinitialSupply * (10 ** uint256(_myDecimal));  // Update total supply with the decimal amount
58         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
59         name = _myTokeName;                                   // Set the name for display purposes
60         symbol = _mySymbol;                               // Set the symbol for display purposes
61     }
62     
63     /**
64      * Internal transfer, only can be called by this contract
65      */
66     function _transfer(address _from, address _to, uint _value) internal {
67         // Prevent transfer to 0x0 address. Use burn() instead
68         require(_to != 0x0);
69         // Check if the sender has enough
70         require(balanceOf[_from] >= _value);
71         // Check for overflows
72         require(balanceOf[_to] + _value > balanceOf[_to]);
73         // Save this for an assertion in the future
74         uint previousBalances = balanceOf[_from] + balanceOf[_to];
75         // Subtract from the sender
76         balanceOf[_from] -= _value;
77         // Add the same to the recipient
78         balanceOf[_to] += _value;
79         Transfer(_from, _to, _value);
80         // Asserts are used to use static analysis to find bugs in your code. They should never fail
81         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
82     }
83 
84     /**
85      * Transfer tokens
86      *
87      * Send `_value` tokens to `_to` from your account
88      *
89      * @param _to The address of the recipient
90      * @param _value the amount to send
91      */
92     function transfer(address _to, uint256 _value) public {
93         _transfer(msg.sender, _to, _value);
94     }
95 
96     /**
97      * Transfer tokens from other address
98      *
99      * Send `_value` tokens to `_to` in behalf of `_from`
100      *
101      * @param _from The address of the sender
102      * @param _to The address of the recipient
103      * @param _value the amount to send
104      */
105     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
106         require(_value <= allowance[_from][msg.sender]);     // Check allowance
107         allowance[_from][msg.sender] -= _value;
108         _transfer(_from, _to, _value);
109         return true;
110     }
111 
112     /**
113      * Set allowance for other address
114      *
115      * Allows `_spender` to spend no more than `_value` tokens in your behalf
116      *
117      * @param _spender The address authorized to spend
118      * @param _value the max amount they can spend
119      */
120     function approve(address _spender, uint256 _value) public
121         returns (bool success) {
122         allowance[msg.sender][_spender] = _value;
123         return true;
124     }
125 
126     /**
127      * Set allowance for other address and notify
128      *
129      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
130      *
131      * @param _spender The address authorized to spend
132      * @param _value the max amount they can spend
133      * @param _extraData some extra information to send to the approved contract
134      */
135     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
136         public
137         returns (bool success) {
138         tokenRecipient spender = tokenRecipient(_spender);
139         if (approve(_spender, _value)) {
140             spender.receiveApproval(msg.sender, _value, this, _extraData);
141             return true;
142         }
143     }
144 
145     /**
146      * Destroy tokens
147      *
148      * Remove `_value` tokens from the system irreversibly
149      *
150      * @param _value the amount of money to burn
151      */
152     function burn(uint256 _value) public returns (bool success) {
153         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
154         balanceOf[msg.sender] -= _value;            // Subtract from the sender
155         totalSupply -= _value;                      // Updates totalSupply
156         Burn(msg.sender, _value);
157         return true;
158     }
159 
160     /**
161      * Destroy tokens from other account
162      *
163      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
164      *
165      * @param _from the address of the sender
166      * @param _value the amount of money to burn
167      */
168     function burnFrom(address _from, uint256 _value) public returns (bool success) {
169         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
170         require(_value <= allowance[_from][msg.sender]);    // Check allowance
171         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
172         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
173         totalSupply -= _value;                              // Update totalSupply
174         Burn(_from, _value);
175         return true;
176     }
177 }
178 
179 /******************************************/
180 /*       ADVANCED TOKEN STARTS HERE       */
181 /******************************************/
182 
183 contract MyAdvancedToken is owned, COSMOTokenERC20 {
184 
185 
186 
187     uint256 public sellPrice;
188     uint256 public buyPrice;
189 
190     mapping (address => bool) public frozenAccount;
191 
192     /* This generates a public event on the blockchain that will notify clients */
193     event FrozenFunds(address target, bool frozen);
194 
195     /* Initializes contract with initial supply tokens to the creator of the contract */
196     function MyAdvancedToken(
197         uint256 initialSupply,
198         string tokenName,
199         string tokenSymbol
200     ) COSMOTokenERC20(initialSupply, tokenName, tokenSymbol) public {}
201 
202     /* Internal transfer, only can be called by this contract */
203     function _transfer(address _from, address _to, uint _value) internal {
204         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
205         require (balanceOf[_from] >= _value);               // Check if the sender has enough
206         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
207         require(!frozenAccount[_from]);                     // Check if sender is frozen
208         require(!frozenAccount[_to]);                       // Check if recipient is frozen
209         balanceOf[_from] -= _value;                         // Subtract from the sender
210         balanceOf[_to] += _value;                           // Add the same to the recipient
211         Transfer(_from, _to, _value);
212     }
213 
214     /// @notice Create `mintedAmount` tokens and send it to `target`
215     /// @param target Address to receive the tokens
216     /// @param mintedAmount the amount of tokens it will receive
217     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
218         balanceOf[target] += mintedAmount;
219         totalSupply += mintedAmount;
220         Transfer(0, this, mintedAmount);
221         Transfer(this, target, mintedAmount);
222     }
223 
224     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
225     /// @param target Address to be frozen
226     /// @param freeze either to freeze it or not
227     function freezeAccount(address target, bool freeze) onlyOwner public {
228         frozenAccount[target] = freeze;
229         FrozenFunds(target, freeze);
230     }
231 
232     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
233     /// @param newSellPrice Price the users can sell to the contract
234     /// @param newBuyPrice Price users can buy from the contract
235     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
236         sellPrice = newSellPrice;
237         buyPrice = newBuyPrice;
238     }
239 
240     /// @notice Buy tokens from contract by sending ether
241     function buy() payable public {
242         uint amount = msg.value / buyPrice;               // calculates the amount
243         _transfer(this, msg.sender, amount);              // makes the transfers
244     }
245 
246     /// @notice Sell `amount` tokens to contract
247     /// @param amount amount of tokens to be sold
248     function sell(uint256 amount) public {
249         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
250         _transfer(msg.sender, this, amount);              // makes the transfers
251         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
252     }
253 }