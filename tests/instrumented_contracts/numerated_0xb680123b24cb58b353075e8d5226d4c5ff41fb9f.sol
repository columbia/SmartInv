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
14 }
15 
16 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
17 
18 contract AngleChain30{
19     // Public variables of the token
20     string public name;
21     string public symbol;
22     uint8 public decimals = 18;
23     // 18 decimals is the strongly suggested default, avoid changing it
24     uint256 public totalSupply;
25     // This creates an array with all balances
26     mapping (address => uint256) public balanceOf;
27     mapping (address => mapping (address => uint256)) public allowance;
28 
29     // This generates a public event on the blockchain that will notify clients
30     event Transfer(address indexed from, address indexed to, uint256 value);
31 
32     /**
33      * Constrctor function
34      *
35      * Initializes contract with initial supply tokens to the creator of the contract
36      */
37     function AngleChain30() public {
38         totalSupply = 1200000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
39         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
40         name = "ANGLECHAIN";                                   // Set the name for display purposes
41         symbol = "ACCHCOIN";                               // Set the symbol for display purposes
42     }
43 
44     /**
45      * Internal transfer, only can be called by this contract
46      */
47     function _transfer(address _from, address _to, uint _value) internal {
48         // Prevent transfer to 0x0 address. Use burn() instead
49         require(_to != 0x0);
50         // Check if the sender has enough
51         require(balanceOf[_from] >= _value);
52         // Check for overflows
53         require(balanceOf[_to] + _value > balanceOf[_to]);
54         // Save this for an assertion in the future
55         uint previousBalances = balanceOf[_from] + balanceOf[_to];
56         // Subtract from the sender
57         balanceOf[_from] -= _value;
58         // Add the same to the recipient
59         balanceOf[_to] += _value;
60         Transfer(_from, _to, _value);
61         // Asserts are used to use static analysis to find bugs in your code. They should never fail
62         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
63     }
64 
65     /**
66      * Transfer tokens
67      *
68      * Send `_value` tokens to `_to` from your account
69      *
70      * @param _to The address of the recipient
71      * @param _value the amount to send
72      */
73     function transfer(address _to, uint256 _value) public {
74         _transfer(msg.sender, _to, _value);
75     }
76 
77     /**
78      * Transfer tokens from other address
79      *
80      * Send `_value` tokens to `_to` in behalf of `_from`
81      *
82      * @param _from The address of the sender
83      * @param _to The address of the recipient
84      * @param _value the amount to send
85      */
86     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
87         require(_value <= allowance[_from][msg.sender]);     // Check allowance
88         allowance[_from][msg.sender] -= _value;
89         _transfer(_from, _to, _value);
90         return true;
91     }
92 
93     /**
94      * Set allowance for other address
95      *
96      * Allows `_spender` to spend no more than `_value` tokens in your behalf
97      *
98      * @param _spender The address authorized to spend
99      * @param _value the max amount they can spend
100      */
101     function approve(address _spender, uint256 _value) public
102         returns (bool success) {
103         allowance[msg.sender][_spender] = _value;
104         return true;
105     }
106 
107     /**
108      * Set allowance for other address and notify
109      *
110      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
111      *
112      * @param _spender The address authorized to spend
113      * @param _value the max amount they can spend
114      * @param _extraData some extra information to send to the approved contract
115      */
116     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
117         public
118         returns (bool success) {
119         tokenRecipient spender = tokenRecipient(_spender);
120         if (approve(_spender, _value)) {
121             spender.receiveApproval(msg.sender, _value, this, _extraData);
122             return true;
123         }
124     }
125 }
126 
127 /******************************************/
128 /*       ADVANCED TOKEN STARTS HERE       */
129 /******************************************/
130 
131 contract MyAdvancedToken is owned, AngleChain30 {
132 
133     uint256 public sellPrice;
134     uint256 public buyPrice;
135 
136     mapping (address => bool) public frozenAccount;
137 
138     /* This generates a public event on the blockchain that will notify clients */
139     event FrozenFunds(address target, bool frozen);
140 
141     function MyAdvancedToken() public{}
142 
143     /* Internal transfer, only can be called by this contract */
144     function _transfer(address _from, address _to, uint _value) internal {
145         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
146         require (balanceOf[_from] > _value);                // Check if the sender has enough
147         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
148         require(!frozenAccount[_from]);                     // Check if sender is frozen
149         require(!frozenAccount[_to]);                       // Check if recipient is frozen
150         balanceOf[_from] -= _value;                         // Subtract from the sender
151         balanceOf[_to] += _value;                           // Add the same to the recipient
152         Transfer(_from, _to, _value);
153     }
154 
155     /// @notice Create `mintedAmount` tokens and send it to `target`
156     /// @param target Address to receive the tokens
157     /// @param mintedAmount the amount of tokens it will receive
158     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
159         balanceOf[target] += mintedAmount;
160         totalSupply += mintedAmount;
161         Transfer(0, this, mintedAmount);
162         Transfer(this, target, mintedAmount);
163     }
164 
165     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
166     /// @param target Address to be frozen
167     /// @param freeze either to freeze it or not
168     function freezeAccount(address target, bool freeze) onlyOwner public {
169         frozenAccount[target] = freeze;
170         FrozenFunds(target, freeze);
171     }
172 
173     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
174     /// @param newSellPrice Price the users can sell to the contract
175     /// @param newBuyPrice Price users can buy from the contract
176     function setPrices(uint256 newBuyPrice,uint256 newSellPrice) onlyOwner public {
177         buyPrice = newBuyPrice;
178         sellPrice = newSellPrice;
179     }
180 }