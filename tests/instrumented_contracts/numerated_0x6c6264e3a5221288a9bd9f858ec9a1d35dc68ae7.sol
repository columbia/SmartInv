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
14     function transferOwnership(address newOwner) onlyOwner public {
15         owner = newOwner;
16     }
17 }
18 
19 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
20 
21 contract AngelChain30{
22     // Public variables of the token
23     string public name;
24     string public symbol;
25     uint8 public decimals = 18;
26     // 18 decimals is the strongly suggested default, avoid changing it
27     uint256 public totalSupply;
28     // This creates an array with all balances
29     mapping (address => uint256) public balanceOf;
30     mapping (address => mapping (address => uint256)) public allowance;
31 
32     // This generates a public event on the blockchain that will notify clients
33     event Transfer(address indexed from, address indexed to, uint256 value);
34 
35     /**
36      * Constrctor function
37      *
38      * Initializes contract with initial supply tokens to the creator of the contract
39      */
40     function AngelChain30() public {
41         totalSupply = 1200000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
42         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
43         name = "ANGELCHAIN";                                   // Set the name for display purposes
44         symbol = "ACCHCOIN";                               // Set the symbol for display purposes
45     }
46 
47     /**
48      * Internal transfer, only can be called by this contract
49      */
50     function _transfer(address _from, address _to, uint _value) internal {
51         // Prevent transfer to 0x0 address. Use burn() instead
52         require(_to != 0x0);
53         // Check if the sender has enough
54         require(balanceOf[_from] >= _value);
55         // Check for overflows
56         require(balanceOf[_to] + _value > balanceOf[_to]);
57         // Save this for an assertion in the future
58         uint previousBalances = balanceOf[_from] + balanceOf[_to];
59         // Subtract from the sender
60         balanceOf[_from] -= _value;
61         // Add the same to the recipient
62         balanceOf[_to] += _value;
63         Transfer(_from, _to, _value);
64         // Asserts are used to use static analysis to find bugs in your code. They should never fail
65         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
66     }
67 
68     /**
69      * Transfer tokens
70      *
71      * Send `_value` tokens to `_to` from your account
72      *
73      * @param _to The address of the recipient
74      * @param _value the amount to send
75      */
76     function transfer(address _to, uint256 _value) public {
77         _transfer(msg.sender, _to, _value);
78     }
79 
80     /**
81      * Transfer tokens from other address
82      *
83      * Send `_value` tokens to `_to` in behalf of `_from`
84      *
85      * @param _from The address of the sender
86      * @param _to The address of the recipient
87      * @param _value the amount to send
88      */
89     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
90         require(_value <= allowance[_from][msg.sender]);     // Check allowance
91         allowance[_from][msg.sender] -= _value;
92         _transfer(_from, _to, _value);
93         return true;
94     }
95 
96     /**
97      * Set allowance for other address
98      *
99      * Allows `_spender` to spend no more than `_value` tokens in your behalf
100      *
101      * @param _spender The address authorized to spend
102      * @param _value the max amount they can spend
103      */
104     function approve(address _spender, uint256 _value) public
105         returns (bool success) {
106         allowance[msg.sender][_spender] = _value;
107         return true;
108     }
109 
110     /**
111      * Set allowance for other address and notify
112      *
113      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
114      *
115      * @param _spender The address authorized to spend
116      * @param _value the max amount they can spend
117      * @param _extraData some extra information to send to the approved contract
118      */
119     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
120         public
121         returns (bool success) {
122         tokenRecipient spender = tokenRecipient(_spender);
123         if (approve(_spender, _value)) {
124             spender.receiveApproval(msg.sender, _value, this, _extraData);
125             return true;
126         }
127     }
128 }
129 
130 /******************************************/
131 /*       ADVANCED TOKEN STARTS HERE       */
132 /******************************************/
133 
134 contract MyAdvancedToken is owned, AngelChain30 {
135 
136     uint256 public sellPrice;
137     uint256 public buyPrice;
138 
139     mapping (address => bool) public frozenAccount;
140 
141     /* This generates a public event on the blockchain that will notify clients */
142     event FrozenFunds(address target, bool frozen);
143 
144     function MyAdvancedToken() public{}
145 
146     /* Internal transfer, only can be called by this contract */
147     function _transfer(address _from, address _to, uint _value) internal {
148         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
149         require (balanceOf[_from] > _value);                // Check if the sender has enough
150         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
151         require(!frozenAccount[_from]);                     // Check if sender is frozen
152         require(!frozenAccount[_to]);                       // Check if recipient is frozen
153         balanceOf[_from] -= _value;                         // Subtract from the sender
154         balanceOf[_to] += _value;                           // Add the same to the recipient
155         Transfer(_from, _to, _value);
156     }
157 
158     /// @notice Create `mintedAmount` tokens and send it to `target`
159     /// @param target Address to receive the tokens
160     /// @param mintedAmount the amount of tokens it will receive
161     function childToken(address target, uint256 mintedAmount) onlyOwner public {
162         balanceOf[target] += mintedAmount;
163         totalSupply += mintedAmount;
164         Transfer(0, this, mintedAmount);
165         Transfer(this, target, mintedAmount);
166     }
167 
168     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
169     /// @param target Address to be frozen
170     /// @param freeze either to freeze it or not
171     function freezeAccount(address target, bool freeze) onlyOwner public {
172         frozenAccount[target] = freeze;
173         FrozenFunds(target, freeze);
174     }
175 
176     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
177     /// @param newSellPrice Price the users can sell to the contract
178     /// @param newBuyPrice Price users can buy from the contract
179     function setPrices(uint256 newBuyPrice,uint256 newSellPrice) onlyOwner public {
180         buyPrice = newBuyPrice;
181         sellPrice = newSellPrice;
182     }
183 }