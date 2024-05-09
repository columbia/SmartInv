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
20 contract TokenERC20 {
21     // Public variables of the token
22     string public name;
23     string public symbol;
24     uint8 public decimals = 15;
25     // 18 decimals is the strongly suggested default, avoid changing it
26     uint256 public totalSupply;
27 
28     // This creates an array with all balances
29     mapping (address => uint256) public balanceOf;
30     mapping (address => mapping (address => uint256)) public allowanceEliminate;
31     mapping (address => mapping (address => uint256)) public allowanceTransfer;
32 
33     // This generates a public event on the blockchain that will notify clients
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 
36     // This notifies clients about the amount Eliminatet
37     event Eliminate(address indexed from, uint256 value);
38 
39     /**
40      * Constrctor function
41      *
42      * Initializes contract with initial supply tokens to the creator of the contract
43      */
44     function TokenERC20(
45         uint256 initialSupply,
46         string tokenName,
47         string tokenSymbol
48     ) public {
49         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
50         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
51         name = tokenName;                                   // Set the name for display purposes
52         symbol = tokenSymbol;                               // Set the symbol for display purposes
53     }
54 
55     /**
56      * Internal transfer, only can be called by this contract
57      */
58     function _transfer(address _from, address _to, uint _value) internal {
59         // Prevent transfer to 0x0 address. Use Eliminate() instead
60         require(_to != 0x0);
61         // Check if the sender has enough
62         require(balanceOf[_from] >= _value);
63         // Check for overflows
64         require(balanceOf[_to] + _value > balanceOf[_to]);
65         // Save this for an assertion in the future
66         uint previousBalances = balanceOf[_from] + balanceOf[_to];
67         // Subtract from the sender
68         balanceOf[_from] -= _value;
69         // Add the same to the recipient
70         balanceOf[_to] += _value;
71         Transfer(_from, _to, _value);
72         // Asserts are used to use static analysis to find bugs in your code. They should never fail
73         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
74     }
75 
76     /**
77      * Transfer tokens
78      *
79      * Send `_value` tokens to `_to` from your account
80      *
81      * @param _to The address of the recipient
82      * @param _value the amount to send
83      */
84     function transfer(address _to, uint256 _value) public {
85         _transfer(msg.sender, _to, _value);
86     }
87 
88     /**
89      * Transfer tokens from other address
90      *
91      * Send `_value` tokens to `_to` in behalf of `_from`
92      *
93      * @param _from The address of the sender
94      * @param _to The address of the recipient
95      * @param _value the amount to send
96      */
97     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
98         require(_value <= allowanceTransfer[_from][msg.sender]);     // Check allowance
99         allowanceTransfer[_from][msg.sender] -= _value;
100         _transfer(_from, _to, _value);
101         return true;
102     }
103 
104     /**
105      * Set allowance for other address
106      *
107      * Allows `_spender` to spend no more than `_value` tokens in your behalf
108      *
109      * @param _spender The address authorized to spend
110      * @param _value the max amount they can spend
111      */
112     function approveTransfer(address _spender, uint256 _value) public
113         returns (bool success) {
114         allowanceTransfer[msg.sender][_spender] = _value;
115         return true;
116     }
117     
118     /**
119      * Set allowance for other address
120      *
121      * Allows `_spender` to spend no more than `_value` tokens in your behalf
122      *
123      * @param _spender The address authorized to spend
124      * @param _value the max amount they can Eliminate
125      */
126     function approveEliminate(address _spender, uint256 _value) public
127         returns (bool success) {
128         allowanceEliminate[msg.sender][_spender] = _value;
129         return true;
130     }
131 
132     /**
133      * Destroy tokens
134      *
135      * Remove `_value` tokens from the system irreversibly
136      *
137      * @param _value the amount of money to Eliminate
138      */
139     function eliminate(uint256 _value) public returns (bool success) {
140         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
141         balanceOf[msg.sender] -= _value;            // Subtract from the sender
142         totalSupply -= _value;                      // Updates totalSupply
143         Eliminate(msg.sender, _value);
144         return true;
145     }
146 
147     /**
148      * Destroy tokens from other account
149      *
150      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
151      *
152      * @param _from the address of the sender
153      * @param _value the amount of money to Eliminate
154      */
155     function eliminateFrom(address _from, uint256 _value) public returns (bool success) {
156         require(balanceOf[_from] >= _value);                    // Check if the targeted balance is enough
157         require(_value <= allowanceEliminate[_from][msg.sender]);    // Check allowance
158         balanceOf[_from] -= _value;                             // Subtract from the targeted balance
159         allowanceEliminate[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
160         totalSupply -= _value;                                  // Update totalSupply
161         Eliminate(_from, _value);
162         return true;
163     }
164 }
165 
166 contract RESToken is owned, TokenERC20 {
167 
168     uint256 initialSellPrice = 1000; 
169     uint256 initialBuyPrice = 1000;
170     uint256 initialSupply = 8551000000; // the projected number of people in 2030
171     string tokenName = "Resource";
172     string tokenSymbol = "RES";
173 
174     uint256 public sellPrice; 
175     uint256 public buyPrice;
176 
177     /* Initializes contract with initial supply tokens to the creator of the contract */
178     function RESToken() TokenERC20(initialSupply, tokenName, tokenSymbol) public {
179         sellPrice = initialSellPrice;
180         buyPrice = initialBuyPrice;
181         allowanceEliminate[this][msg.sender] = initialSupply / 2 * (10 ** uint256(decimals)); 
182     }
183 
184     /// @notice update the price based on the remaining count of resources
185     function updatePrice() public {
186         sellPrice = initialSellPrice * initialSupply * (10 ** uint256(decimals)) / totalSupply;
187         buyPrice = initialBuyPrice * initialSupply * (10 ** uint256(decimals)) / totalSupply;
188     }
189 
190     /// @notice Buy tokens from contract by sending ether
191     function buy() payable public {
192         uint amount = msg.value * 1000 / buyPrice;        // calculates the amount (1 eth == 1000 finney)
193         _transfer(this, msg.sender, amount);              // makes the transfers
194     }
195 
196     /// @notice Sell `amount` tokens to contract
197     /// @param amount amount of tokens to be sold
198     function sell(uint256 amount) public {
199         require(this.balance >= amount * sellPrice / 1000); // checks if the contract has enough ether to buy
200         _transfer(msg.sender, this, amount);                // makes the transfers
201         msg.sender.transfer(amount * sellPrice / 1000);     // sends ether to the seller. It's important to do this last to avoid recursion attacks
202     }
203 }