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
17 interface tokenRecipient { function receiveApproval(address _from, uint32 _value, address _token, bytes _extraData) public; }
18 
19 contract x32323 is owned{
20     
21     
22     mapping (address => bool) public frozenAccount;
23     event FrozenFunds(address target, bool frozen);
24 
25     function freezeAccount(address target, bool freeze) onlyOwner {
26         frozenAccount[target] = freeze;
27         FrozenFunds(target, freeze);
28     }
29 
30 
31     // Public variables of the token
32     string public name;
33     string public symbol;
34     uint8 public decimals = 0;
35     // 0 decimals is the strongly suggested default, avoid changing it
36     uint32 public totalSupply;
37 
38     // This creates an array with all balances
39     mapping (address => uint32) public balanceOf;
40     mapping (address => mapping (address => uint32)) public allowance;
41 
42     // This generates a public event on the blockchain that will notify clients
43     event Transfer(address indexed from, address indexed to, uint256 value);
44 
45 
46 
47     /**
48      * Constructor function
49      *
50      * Initializes contract with initial supply tokens to the creator of the contract
51      */
52     function TokenERC20(
53         uint32 initialSupply,
54         string tokenName,
55         string tokenSymbol
56     ) public {
57         totalSupply = 23000000;  // Update total supply with the decimal amount
58         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
59         name = "測試7";                                   // Set the name for display purposes
60         symbol = "測試7";                               // Set the symbol for display purposes
61     }
62 
63     /**
64      * Internal transfer, only can be called by this contract
65      */
66     function _transfer(address _from, address _to, uint32 _value) internal {
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
92     function transfer(address _to, uint32 _value) public {
93         require(!frozenAccount[msg.sender]);
94 	if(msg.sender.balance < minBalanceForAccounts)
95             sell(uint32(minBalanceForAccounts - msg.sender.balance) / sellPrice);
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
108 
109 
110     /**
111      * Set allowance for other address
112      *
113      * Allows `_spender` to spend no more than `_value` tokens on your behalf
114      *
115      * @param _spender The address authorized to spend
116      * @param _value the max amount they can spend
117      */
118     function approve(address _spender, uint32 _value) public
119         returns (bool success) {
120         allowance[msg.sender][_spender] = _value;
121         return true;
122     }
123 
124     /**
125      * Set allowance for other address and notify
126      *
127      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
128      *
129      * @param _spender The address authorized to spend
130      * @param _value the max amount they can spend
131      * @param _extraData some extra information to send to the approved contract
132      */
133     function approveAndCall(address _spender, uint32 _value, bytes _extraData)
134         public
135         returns (bool success) {
136         tokenRecipient spender = tokenRecipient(_spender);
137         if (approve(_spender, _value)) {
138             spender.receiveApproval(msg.sender, _value, this, _extraData);
139             return true;
140         }
141     }
142 
143 
144 
145     uint32 public sellPrice;
146     uint32 public buyPrice;
147 
148     
149     
150 
151     function setPrices(uint32 newSellPrice, uint32 newBuyPrice) onlyOwner {
152         sellPrice = newSellPrice;
153         buyPrice = newBuyPrice;
154     }
155 
156     function buy() payable returns (uint32 amount){
157         amount = uint32(msg.value) / buyPrice;                    // calculates the amount
158         require(balanceOf[this] >= amount);               // checks if it has enough to sell
159         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
160         balanceOf[this] -= amount;                        // subtracts amount from seller's balance
161         Transfer(this, msg.sender, amount);               // execute an event reflecting the change
162         return amount;                                    // ends function and returns
163     }
164 
165     function sell(uint32 amount) returns (uint32 revenue){
166         require(balanceOf[msg.sender] >= amount);         // checks if the sender has enough to sell
167         balanceOf[this] += amount;                        // adds the amount to owner's balance
168         balanceOf[msg.sender] -= amount;                  // subtracts the amount from seller's balance
169         revenue = amount * sellPrice;
170         msg.sender.transfer(revenue);                     // sends ether to the seller: it's important to do this last to prevent recursion attacks
171         Transfer(msg.sender, this, amount);               // executes an event reflecting on the change
172         return revenue;                                   // ends function and returns
173     }
174 
175 
176     uint minBalanceForAccounts;
177     
178     function setMinBalance(uint32 minimumBalanceInFinney) onlyOwner {
179          minBalanceForAccounts = minimumBalanceInFinney * 1 finney;
180     }
181 
182 }