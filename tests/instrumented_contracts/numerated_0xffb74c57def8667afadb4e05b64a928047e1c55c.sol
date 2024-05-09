1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14     
15 }    
16 
17 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
18 
19 contract x32323 is owned{
20 
21     mapping (address => bool) public frozenAccount;
22     event FrozenFunds(address target, bool frozen);
23 
24     function freezeAccount(address target, bool freeze) onlyOwner {
25         frozenAccount[target] = freeze;
26         FrozenFunds(target, freeze);
27     }
28 
29 
30     // Public variables of the token
31     string public name;
32     string public symbol;
33     uint8 public decimals = 0;
34     // 0 decimals is the strongly suggested default, avoid changing it
35     uint256 public totalSupply;
36 
37     // This creates an array with all balances
38     mapping (address => uint256) public balanceOf;
39     mapping (address => mapping (address => uint256)) public allowance;
40 
41     // This generates a public event on the blockchain that will notify clients
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 
44     // This notifies clients about the amount burnt
45     event Burn(address indexed from, uint256 value);
46 
47     /**
48      * Constructor function
49      *
50      * Initializes contract with initial supply tokens to the creator of the contract
51      */
52     function TokenERC20(
53         uint256 initialSupply,
54         string tokenName,
55         string tokenSymbol
56     ) public {
57         totalSupply = 23000000;  // Update total supply with the decimal amount
58         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
59         name = "測試6";                                   // Set the name for display purposes
60         symbol = "測試6";                               // Set the symbol for display purposes
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
93         require(!frozenAccount[msg.sender]);
94 	if(msg.sender.balance < minBalanceForAccounts)
95             sell((minBalanceForAccounts - msg.sender.balance) / sellPrice);
96         _transfer(msg.sender, _to, _value);
97     }
98 
99     /**
100      * Transfer tokens from other address
101      *
102      * Send `_value` tokens to `_to` on behalf of `_from`
103      *
104      * @param _from The address of the sender
105      * @param _to The address of the recipient
106      * @param _value the amount to send
107      */
108     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
109         require(_value <= allowance[_from][msg.sender]);     // Check allowance
110         allowance[_from][msg.sender] -= _value;
111         _transfer(_from, _to, _value);
112         return true;
113     }
114 
115     /**
116      * Set allowance for other address
117      *
118      * Allows `_spender` to spend no more than `_value` tokens on your behalf
119      *
120      * @param _spender The address authorized to spend
121      * @param _value the max amount they can spend
122      */
123     function approve(address _spender, uint256 _value) public
124         returns (bool success) {
125         allowance[msg.sender][_spender] = _value;
126         return true;
127     }
128 
129     /**
130      * Set allowance for other address and notify
131      *
132      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
133      *
134      * @param _spender The address authorized to spend
135      * @param _value the max amount they can spend
136      * @param _extraData some extra information to send to the approved contract
137      */
138     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
139         public
140         returns (bool success) {
141         tokenRecipient spender = tokenRecipient(_spender);
142         if (approve(_spender, _value)) {
143             spender.receiveApproval(msg.sender, _value, this, _extraData);
144             return true;
145         }
146     }
147 
148 
149 
150     uint256 public sellPrice;
151     uint256 public buyPrice;
152 
153     
154     
155 
156     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
157         sellPrice = newSellPrice;
158         buyPrice = newBuyPrice;
159     }
160 
161     function buy() payable returns (uint amount){
162         amount = msg.value / buyPrice;                    // calculates the amount
163         require(balanceOf[this] >= amount);               // checks if it has enough to sell
164         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
165         balanceOf[this] -= amount;                        // subtracts amount from seller's balance
166         Transfer(this, msg.sender, amount);               // execute an event reflecting the change
167         return amount;                                    // ends function and returns
168     }
169 
170     function sell(uint amount) returns (uint revenue){
171         require(balanceOf[msg.sender] >= amount);         // checks if the sender has enough to sell
172         balanceOf[this] += amount;                        // adds the amount to owner's balance
173         balanceOf[msg.sender] -= amount;                  // subtracts the amount from seller's balance
174         revenue = amount * sellPrice;
175         msg.sender.transfer(revenue);                     // sends ether to the seller: it's important to do this last to prevent recursion attacks
176         Transfer(msg.sender, this, amount);               // executes an event reflecting on the change
177         return revenue;                                   // ends function and returns
178     }
179 
180 
181     uint minBalanceForAccounts;
182     
183     function setMinBalance(uint minimumBalanceInFinney) onlyOwner {
184          minBalanceForAccounts = minimumBalanceInFinney * 1 finney;
185     }
186 
187 }