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
22 contract JeansToken {
23     string public constant _myTokeName = 'Jeans Token';//change here
24     string public constant _mySymbol = 'JEANS';//change here
25     uint public constant _myinitialSupply = 10;//leave it
26     uint8 public constant _myDecimal = 8;//leave it
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
45      * Constrctor function
46      *
47      * Initializes contract with initial supply tokens to the creator of the contract
48      */
49     function JeansToken(
50         
51         
52         
53     ) public {
54         totalSupply = _myinitialSupply * (10 ** uint256(_myDecimal));  // Update total supply with the decimal amount
55         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
56         name = _myTokeName;                                   // Set the name for display purposes
57         symbol = _mySymbol;                               // Set the symbol for display purposes
58     }
59 
60     /**
61      * Internal transfer, only can be called by this contract
62      */
63     function _transfer(address _from, address _to, uint _value) internal {
64         // Prevent transfer to 0x0 address. Use burn() instead
65         require(_to != 0x0);
66         // Check if the sender has enough
67         require(balanceOf[_from] >= _value);
68         // Check for overflows
69         require(balanceOf[_to] + _value > balanceOf[_to]);
70         // Save this for an assertion in the future
71         uint previousBalances = balanceOf[_from] + balanceOf[_to];
72         // Subtract from the sender
73         balanceOf[_from] -= _value;
74         // Add the same to the recipient
75         balanceOf[_to] += _value;
76         Transfer(_from, _to, _value);
77         // Asserts are used to use static analysis to find bugs in your code. They should never fail
78         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
79     }
80 
81     /**
82      * Transfer tokens
83      *
84      * Send `_value` tokens to `_to` from your account
85      *
86      * @param _to The address of the recipient
87      * @param _value the amount to send
88      */
89     function transfer(address _to, uint256 _value) public {
90         _transfer(msg.sender, _to, _value);
91     }
92 
93     /**
94      * Transfer tokens from other address
95      *
96      * Send `_value` tokens to `_to` in behalf of `_from`
97      *
98      * @param _from The address of the sender
99      * @param _to The address of the recipient
100      * @param _value the amount to send
101      */
102     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
103         require(_value <= allowance[_from][msg.sender]);     // Check allowance
104         allowance[_from][msg.sender] -= _value;
105         _transfer(_from, _to, _value);
106         return true;
107     }
108 
109     /**
110      * Set allowance for other address
111      *
112      * Allows `_spender` to spend no more than `_value` tokens in your behalf
113      *
114      * @param _spender The address authorized to spend
115      * @param _value the max amount they can spend
116      */
117     function approve(address _spender, uint256 _value) public
118         returns (bool success) {
119         allowance[msg.sender][_spender] = _value;
120         return true;
121     }
122 
123     /**
124      * Set allowance for other address and notify
125      *
126      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
127      *
128      * @param _spender The address authorized to spend
129      * @param _value the max amount they can spend
130      * @param _extraData some extra information to send to the approved contract
131      */
132     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
133         public
134         returns (bool success) {
135         tokenRecipient spender = tokenRecipient(_spender);
136         if (approve(_spender, _value)) {
137             spender.receiveApproval(msg.sender, _value, this, _extraData);
138             return true;
139         }
140     }
141 
142     /**
143      * Destroy tokens
144      *
145      * Remove `_value` tokens from the system irreversibly
146      *
147      * @param _value the amount of money to burn
148      */
149     function burn(uint256 _value) public returns (bool success) {
150         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
151         balanceOf[msg.sender] -= _value;            // Subtract from the sender
152         totalSupply -= _value;                      // Updates totalSupply
153         Burn(msg.sender, _value);
154         return true;
155     }
156 
157     /**
158      * Destroy tokens from other account
159      *
160      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
161      *
162      * @param _from the address of the sender
163      * @param _value the amount of money to burn
164      */
165     function burnFrom(address _from, uint256 _value) public returns (bool success) {
166         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
167         require(_value <= allowance[_from][msg.sender]);    // Check allowance
168         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
169         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
170         totalSupply -= _value;                              // Update totalSupply
171         Burn(_from, _value);
172         return true;
173     }
174 }
175 
176 /******************************************/
177 /*       ADVANCED TOKEN STARTS HERE       */
178 /******************************************/
179 
180 contract MyAdvancedToken is owned, JeansToken {
181 
182 
183 
184     uint256 public sellPrice;
185     uint256 public buyPrice;
186 
187     mapping (address => bool) public frozenAccount;
188 
189     /* This generates a public event on the blockchain that will notify clients */
190     event FrozenFunds(address target, bool frozen);
191 
192     /* Initializes contract with initial supply tokens to the creator of the contract */
193     function MyAdvancedToken(
194          
195         
196         
197     ) public {}
198 
199     /* Internal transfer, only can be called by this contract */
200     function _transfer(address _from, address _to, uint _value) internal {
201         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
202         require (balanceOf[_from] >= _value);               // Check if the sender has enough
203         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
204         require(!frozenAccount[_from]);                     // Check if sender is frozen
205         require(!frozenAccount[_to]);                       // Check if recipient is frozen
206         balanceOf[_from] -= _value;                         // Subtract from the sender
207         balanceOf[_to] += _value;                           // Add the same to the recipient
208         Transfer(_from, _to, _value);
209     }
210 
211     /// @notice Create `mintedAmount` tokens and send it to `target`
212     /// @param target Address to receive the tokens
213     /// @param mintedAmount the amount of tokens it will receive
214     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
215         balanceOf[target] += mintedAmount;
216         totalSupply += mintedAmount;
217         Transfer(0, this, mintedAmount);
218         Transfer(this, target, mintedAmount);
219     }
220 
221     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
222     /// @param target Address to be frozen
223     /// @param freeze either to freeze it or not
224     function freezeAccount(address target, bool freeze) onlyOwner public {
225         frozenAccount[target] = freeze;
226         FrozenFunds(target, freeze);
227     }
228 
229     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
230     /// @param newSellPrice Price the users can sell to the contract
231     /// @param newBuyPrice Price users can buy from the contract
232     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
233         sellPrice = newSellPrice;
234         buyPrice = newBuyPrice;
235     }
236 
237     /// @notice Buy tokens from contract by sending ether
238     function buy() payable public {
239         uint amount = msg.value / buyPrice;               // calculates the amount
240         _transfer(this, msg.sender, amount);              // makes the transfers
241     }
242 
243     /// @notice Sell `amount` tokens to contract
244     /// @param amount amount of tokens to be sold
245     function sell(uint256 amount) public {
246         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
247         _transfer(msg.sender, this, amount);              // makes the transfers
248         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
249     }
250 }