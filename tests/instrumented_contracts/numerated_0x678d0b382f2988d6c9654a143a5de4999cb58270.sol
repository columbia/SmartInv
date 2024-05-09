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
22 contract RajTest is owned {
23     // Public variables of the token
24     string public name = "RajTest";
25     string public symbol = "RT";
26     uint8 public decimals = 18;
27     uint256 public totalSupply = 0;
28     
29     uint256 public sellPrice = 1045;
30     uint256 public buyPrice = 1045;
31 
32     bool public released = false;
33     
34     /// contract that is allowed to create new tokens and allows unlift the transfer limits on this token
35     address public crowdsaleAgent;
36 
37     // This creates an array with all balances
38     mapping (address => uint256) public balanceOf;
39     mapping (address => mapping (address => uint256)) public allowance;
40     mapping (address => bool) public frozenAccount;
41    
42     // This generates a public event on the blockchain that will notify clients
43     event Transfer(address indexed from, address indexed to, uint256 value);
44 
45     /* This generates a public event on the blockchain that will notify clients */
46     event FrozenFunds(address target, bool frozen);
47 
48     /**
49      * Constrctor function
50      *
51      * Initializes contract with initial supply tokens to the creator of the contract
52      */
53     function RajTest() public {
54     }
55     modifier canTransfer() {
56         require(released);
57        _;
58      }
59 
60     modifier onlyCrowdsaleAgent() {
61         require(msg.sender == crowdsaleAgent);
62         _;
63     }
64 
65     function releaseTokenTransfer() public onlyCrowdsaleAgent {
66         released = true;
67     }
68     /**
69      * Internal transfer, only can be called by this contract
70      */
71     function _transfer(address _from, address _to, uint _value) canTransfer internal {
72         // Prevent transfer to 0x0 address. Use burn() instead
73         require(_to != 0x0);
74         // Check if the sender has enough
75         require(balanceOf[_from] >= _value);
76         // Check for overflows
77         require(balanceOf[_to] + _value > balanceOf[_to]);
78         // Check if sender is frozen
79         require(!frozenAccount[_from]);
80         // Check if recipient is frozen
81         require(!frozenAccount[_to]);
82         // Save this for an assertion in the future
83         uint previousBalances = balanceOf[_from] + balanceOf[_to];
84         // Subtract from the sender
85         balanceOf[_from] -= _value;
86         // Add the same to the recipient
87         balanceOf[_to] += _value;
88         Transfer(_from, _to, _value);
89         // Asserts are used to use static analysis to find bugs in your code. They should never fail
90         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
91     }
92 
93     /**
94      * Transfer tokens
95      *
96      * Send `_value` tokens to `_to` from your account
97      *
98      * @param _to The address of the recipient
99      * @param _value the amount to send
100      */
101     function transfer(address _to, uint256 _value) public {
102         _transfer(msg.sender, _to, _value);
103     }
104 
105     /**
106      * Transfer tokens from other address
107      *
108      * Send `_value` tokens to `_to` in behalf of `_from`
109      *
110      * @param _from The address of the sender
111      * @param _to The address of the recipient
112      * @param _value the amount to send
113      */
114     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
115         require(_value <= allowance[_from][msg.sender]);     // Check allowance
116         allowance[_from][msg.sender] -= _value;
117         _transfer(_from, _to, _value);
118         return true;
119     }
120 
121     /**
122      * Set allowance for other address
123      *
124      * Allows `_spender` to spend no more than `_value` tokens in your behalf
125      *
126      * @param _spender The address authorized to spend
127      * @param _value the max amount they can spend
128      */
129     function approve(address _spender, uint256 _value) public
130         returns (bool success) {
131         allowance[msg.sender][_spender] = _value;
132         return true;
133     }
134 
135     /**
136      * Set allowance for other address and notify
137      *
138      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
139      *
140      * @param _spender The address authorized to spend
141      * @param _value the max amount they can spend
142      * @param _extraData some extra information to send to the approved contract
143      */
144     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
145         public
146         returns (bool success) {
147         tokenRecipient spender = tokenRecipient(_spender);
148         if (approve(_spender, _value)) {
149             spender.receiveApproval(msg.sender, _value, this, _extraData);
150             return true;
151         }
152     }
153 
154     /// @notice Create `mintedAmount` tokens and send it to `target`
155     /// @param target Address to receive the tokens
156     /// @param mintedAmount the amount of tokens it will receive
157     function mintToken(address target, uint256 mintedAmount) onlyCrowdsaleAgent public {
158         balanceOf[target] += mintedAmount;
159         totalSupply += mintedAmount;
160         Transfer(this, target, mintedAmount);
161     }
162 
163     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
164     /// @param target Address to be frozen
165     /// @param freeze either to freeze it or not
166     function freezeAccount(address target, bool freeze) onlyOwner public {
167         frozenAccount[target] = freeze;
168         FrozenFunds(target, freeze);
169     }
170 
171     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
172     /// @param newSellPrice Price the users can sell to the contract
173     /// @param newBuyPrice Price users can buy from the contract
174     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
175         sellPrice = newSellPrice;
176         buyPrice = newBuyPrice;
177     }
178 
179     /// @notice Buy tokens from contract by sending ether
180     function buy() payable public {
181         uint amount = msg.value / buyPrice;               // calculates the amount
182         _transfer(this, msg.sender, amount);              // makes the transfers
183     }
184 
185     /// @notice Sell `amount` tokens to contract
186     /// @param amount amount of tokens to be sold
187     function sell(uint256 amount) canTransfer public {
188         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
189         _transfer(msg.sender, this, amount);              // makes the transfers
190         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
191     }
192 
193     /// @dev Set the contract that can call release and make the token transferable.
194     /// @param _crowdsaleAgent crowdsale contract address
195     function setCrowdsaleAgent(address _crowdsaleAgent) onlyOwner public {
196         crowdsaleAgent = _crowdsaleAgent;
197     }
198 }