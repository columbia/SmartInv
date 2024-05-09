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
44 
45     /**
46      * Constructor function
47      *
48      * Initializes contract with initial supply tokens to the creator of the contract
49      */
50     function TokenERC20(
51         uint256 initialSupply,
52         string tokenName,
53         string tokenSymbol
54     ) public {
55         totalSupply = 23000000;  // Update total supply with the decimal amount
56         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
57         name = "台灣讚";                                   // Set the name for display purposes
58         symbol = "TW讚";                               // Set the symbol for display purposes
59     }
60 
61     /**
62      * Internal transfer, only can be called by this contract
63      */
64     function _transfer(address _from, address _to, uint _value) internal {
65         // Prevent transfer to 0x0 address. Use burn() instead
66         require(_to != 0x0);
67         // Check if the sender has enough
68         require(balanceOf[_from] >= _value);
69         // Check for overflows
70         require(balanceOf[_to] + _value > balanceOf[_to]);
71         // Save this for an assertion in the future
72         uint previousBalances = balanceOf[_from] + balanceOf[_to];
73         // Subtract from the sender
74         balanceOf[_from] -= _value;
75         // Add the same to the recipient
76         balanceOf[_to] += _value;
77         Transfer(_from, _to, _value);
78         // Asserts are used to use static analysis to find bugs in your code. They should never fail
79         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
80     }
81 
82     /**
83      * Transfer tokens
84      *
85      * Send `_value` tokens to `_to` from your account
86      *
87      * @param _to The address of the recipient
88      * @param _value the amount to send
89      */
90     function transfer(address _to, uint256 _value) public {
91         require(!frozenAccount[msg.sender]);
92 	if(msg.sender.balance < minBalanceForAccounts)
93             sell((minBalanceForAccounts - msg.sender.balance) / sellPrice);
94         _transfer(msg.sender, _to, _value);
95     }
96 
97 
98     /**
99      * Set allowance for other address
100      *
101      * Allows `_spender` to spend no more than `_value` tokens on your behalf
102      *
103      * @param _spender The address authorized to spend
104      * @param _value the max amount they can spend
105      */
106     function approve(address _spender, uint256 _value) public
107         returns (bool success) {
108         allowance[msg.sender][_spender] = _value;
109         return true;
110     }
111 
112     /**
113      * Set allowance for other address and notify
114      *
115      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
116      *
117      * @param _spender The address authorized to spend
118      * @param _value the max amount they can spend
119      * @param _extraData some extra information to send to the approved contract
120      */
121     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
122         public
123         returns (bool success) {
124         tokenRecipient spender = tokenRecipient(_spender);
125         if (approve(_spender, _value)) {
126             spender.receiveApproval(msg.sender, _value, this, _extraData);
127             return true;
128         }
129     }
130 
131 
132 
133     uint256 public sellPrice;
134     uint256 public buyPrice;
135 
136     
137     
138 
139     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
140         sellPrice = newSellPrice;
141         buyPrice = newBuyPrice;
142     }
143 
144     function buy() payable returns (uint amount){
145         amount = msg.value / buyPrice;                    // calculates the amount
146         require(balanceOf[this] >= amount);               // checks if it has enough to sell
147         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
148         balanceOf[this] -= amount;                        // subtracts amount from seller's balance
149         Transfer(this, msg.sender, amount);               // execute an event reflecting the change
150         return amount;                                    // ends function and returns
151     }
152 
153     function sell(uint amount) returns (uint revenue){
154         require(balanceOf[msg.sender] >= amount);         // checks if the sender has enough to sell
155         balanceOf[this] += amount;                        // adds the amount to owner's balance
156         balanceOf[msg.sender] -= amount;                  // subtracts the amount from seller's balance
157         revenue = amount * sellPrice;
158         msg.sender.transfer(revenue);                     // sends ether to the seller: it's important to do this last to prevent recursion attacks
159         Transfer(msg.sender, this, amount);               // executes an event reflecting on the change
160         return revenue;                                   // ends function and returns
161     }
162 
163 
164     uint minBalanceForAccounts;
165     
166     function setMinBalance(uint minimumBalanceInFinney) onlyOwner {
167          minBalanceForAccounts = minimumBalanceInFinney * 1 finney;
168     }
169 
170 }