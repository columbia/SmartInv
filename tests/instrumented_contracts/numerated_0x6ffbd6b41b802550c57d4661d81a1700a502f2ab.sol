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
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract TokenERC20 {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 9;
27     
28     uint256 public totalSupply;
29 
30     // This creates an array with all balances
31     mapping (address => uint256) public balanceOf;
32     mapping (address => mapping (address => uint256)) public allowance;
33 
34     // This generates a public event on the blockchain that will notify clients
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     // This notifies clients about the amount burnt
38     event Burn(address indexed from, uint256 value);
39     
40 
41     /**
42      * Constrctor function
43      *
44      * Initializes contract with initial supply tokens to the creator of the contract
45      */
46     function TokenERC20(
47         uint256 initialSupply,
48         string tokenName,
49         string tokenSymbol
50     ) public {
51         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
52         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
53         name = tokenName;                                   // Set the name for display purposes
54         symbol = tokenSymbol;                               // Set the symbol for display purposes
55     }
56 
57     /**
58      * Internal transfer, only can be called by this contract
59      */
60     function _transfer(address _from, address _to, uint _value) internal {
61         // Prevent transfer to 0x0 address. Use burn() instead
62         require(_to != 0x0);
63         // Check if the sender has enough
64         require(balanceOf[_from] >= _value);
65         // Check for overflows
66         require(balanceOf[_to] + _value > balanceOf[_to]);
67         // Save this for an assertion in the future
68         uint previousBalances = balanceOf[_from] + balanceOf[_to];
69         // Subtract from the sender
70         balanceOf[_from] -= _value;
71         // Add the same to the recipient
72         balanceOf[_to] += _value;
73         Transfer(_from, _to, _value);
74         // Asserts are used to use static analysis to find bugs in your code. They should never fail
75         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
76     }
77 
78     /**
79      * Transfer tokens
80      *
81      * Send `_value` tokens to `_to` from your account
82      *
83      * @param _to The address of the recipient
84      * @param _value the amount to send
85      */
86     function transfer(address _to, uint256 _value) public {
87         _transfer(msg.sender, _to, _value);
88     }
89 
90     /**
91      * Transfer tokens from other address
92      *
93      * Send `_value` tokens to `_to` in behalf of `_from`
94      *
95      * @param _from The address of the sender
96      * @param _to The address of the recipient
97      * @param _value the amount to send
98      */
99     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
100         require(_value <= allowance[_from][msg.sender]);     // Check allowance
101         allowance[_from][msg.sender] -= _value;
102         _transfer(_from, _to, _value);
103         return true;
104     }
105 
106     /**
107      * Set allowance for other address
108      *
109      * Allows `_spender` to spend no more than `_value` tokens in your behalf
110      *
111      * @param _spender The address authorized to spend
112      * @param _value the max amount they can spend
113      */
114     function approve(address _spender, uint256 _value) public
115         returns (bool success) {
116         allowance[msg.sender][_spender] = _value;
117         return true;
118     }
119 
120     /**
121      * Set allowance for other address and notify
122      *
123      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
124      *
125      * @param _spender The address authorized to spend
126      * @param _value the max amount they can spend
127      * @param _extraData some extra information to send to the approved contract
128      */
129     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
130         public
131         returns (bool success) {
132         tokenRecipient spender = tokenRecipient(_spender);
133         if (approve(_spender, _value)) {
134             spender.receiveApproval(msg.sender, _value, this, _extraData);
135             return true;
136         }
137     }
138 
139     /**
140      * Destroy tokens
141      *
142      * Remove `_value` tokens from the system irreversibly
143      *
144      * @param _value the amount of money to burn
145      */
146     function burn(uint256 _value) public returns (bool success) {
147         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
148         balanceOf[msg.sender] -= _value;            // Subtract from the sender
149         totalSupply -= _value;                      // Updates totalSupply
150         Burn(msg.sender, _value);
151         return true;
152     }
153 
154     /**
155      * Destroy tokens from other account
156      *
157      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
158      *
159      * @param _from the address of the sender
160      * @param _value the amount of money to burn
161      */
162     function burnFrom(address _from, uint256 _value) public returns (bool success) {
163         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
164         require(_value <= allowance[_from][msg.sender]);    // Check allowance
165         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
166         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
167         totalSupply -= _value;                              // Update totalSupply
168         Burn(_from, _value);
169         return true;
170     }
171 }
172 
173 /******************************************/
174 /*              PoliticoinToken            */
175 /******************************************/
176 
177 contract PoliticoinToken is owned, TokenERC20 {
178 
179     uint256 public sellPrice = 63770;  //0.000063770000000000ETH = 1 token
180     uint256 public buyPrice = 63800;  
181 
182     mapping (address => bool) public frozenAccount;
183 
184     /* This generates a public event on the blockchain that will notify clients */
185     event FrozenFunds(address target, bool frozen);
186 
187     /* Initializes contract with initial supply tokens to the creator of the contract */
188     function PoliticoinToken( ) TokenERC20(31000000000, 'Politicoin', 'PBLC') public {}
189 
190     /* Internal transfer, only can be called by this contract */
191     function _transfer(address _from, address _to, uint _value) internal {
192         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
193         require (balanceOf[_from] >= _value);               // Check if the sender has enough
194         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
195         require(!frozenAccount[_from]);                     // Check if sender is frozen
196         require(!frozenAccount[_to]);                       // Check if recipient is frozen
197         balanceOf[_from] -= _value;                         // Subtract from the sender
198         balanceOf[_to] += _value;                           // Add the same to the recipient
199         Transfer(_from, _to, _value);
200     }
201 
202     /// @notice Create `mintedAmount` tokens and send it to `target`
203     /// @param target Address to receive the tokens
204     /// @param mintedAmount the amount of tokens it will receive
205     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
206         balanceOf[target] += mintedAmount;
207         totalSupply += mintedAmount;
208         Transfer(0, this, mintedAmount);
209         Transfer(this, target, mintedAmount);
210     }
211 
212     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
213     /// @param target Address to be frozen
214     /// @param freeze either to freeze it or not
215     function freezeAccount(address target, bool freeze) onlyOwner public {
216         frozenAccount[target] = freeze;
217         FrozenFunds(target, freeze);
218     }
219 
220     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
221     /// @param newSellPrice Price the users can sell to the contract
222     /// @param newBuyPrice Price users can buy from the contract
223     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
224         sellPrice = newSellPrice;
225         buyPrice = newBuyPrice;
226     }
227 
228     /// Default fallback function to buy tokens
229     function () payable public {
230         buy();
231     }
232 
233     /// @notice Buy tokens from contract by sending ether
234     function buy() payable public {
235         uint amount = msg.value / buyPrice;               // calculates the amount
236         _transfer(this, msg.sender, amount);              // makes the transfers
237     }
238 
239     /// @notice Sell `amount` tokens to contract
240     /// @param amount amount of tokens to be sold
241     function sell(uint256 amount) public {
242         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
243         _transfer(msg.sender, this, amount);              // makes the transfers
244         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
245     }
246 }