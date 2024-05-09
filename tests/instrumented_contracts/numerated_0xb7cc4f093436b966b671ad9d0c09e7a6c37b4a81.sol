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
29     uint256 public buyPrice = 1045;
30 
31     bool public released = false;
32     
33     /// contract that is allowed to create new tokens and allows unlift the transfer limits on this token
34     address public crowdsaleAgent;
35 
36     // This creates an array with all balances
37     mapping (address => uint256) public balanceOf;
38     mapping (address => mapping (address => uint256)) public allowance;
39     mapping (address => bool) public frozenAccount;
40    
41     // This generates a public event on the blockchain that will notify clients
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 
44     /* This generates a public event on the blockchain that will notify clients */
45     event FrozenFunds(address target, bool frozen);
46 
47     /**
48      * Constrctor function
49      *
50      * Initializes contract with initial supply tokens to the creator of the contract
51      */
52     function RajTest() public {
53     }
54     modifier canTransfer() {
55         require(released);
56        _;
57      }
58 
59     modifier onlyCrowdsaleAgent() {
60         require(msg.sender == crowdsaleAgent);
61         _;
62     }
63 
64     function releaseTokenTransfer() public onlyCrowdsaleAgent {
65         released = true;
66     }
67     /**
68      * Internal transfer, only can be called by this contract
69      */
70     function _transfer(address _from, address _to, uint _value) canTransfer internal {
71         // Prevent transfer to 0x0 address. Use burn() instead
72         require(_to != 0x0);
73         // Check if the sender has enough
74         require(balanceOf[_from] >= _value);
75         // Check for overflows
76         require(balanceOf[_to] + _value > balanceOf[_to]);
77         // Check if sender is frozen
78         require(!frozenAccount[_from]);
79         // Check if recipient is frozen
80         require(!frozenAccount[_to]);
81         // Save this for an assertion in the future
82         uint previousBalances = balanceOf[_from] + balanceOf[_to];
83         // Subtract from the sender
84         balanceOf[_from] -= _value;
85         // Add the same to the recipient
86         balanceOf[_to] += _value;
87         Transfer(_from, _to, _value);
88         // Asserts are used to use static analysis to find bugs in your code. They should never fail
89         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
90     }
91 
92     /**
93      * Transfer tokens
94      *
95      * Send `_value` tokens to `_to` from your account
96      *
97      * @param _to The address of the recipient
98      * @param _value the amount to send
99      */
100     function transfer(address _to, uint256 _value) public {
101         _transfer(msg.sender, _to, _value);
102     }
103 
104     /**
105      * Transfer tokens from other address
106      *
107      * Send `_value` tokens to `_to` in behalf of `_from`
108      *
109      * @param _from The address of the sender
110      * @param _to The address of the recipient
111      * @param _value the amount to send
112      */
113     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
114         require(_value <= allowance[_from][msg.sender]);     // Check allowance
115         allowance[_from][msg.sender] -= _value;
116         _transfer(_from, _to, _value);
117         return true;
118     }
119 
120     /**
121      * Set allowance for other address
122      *
123      * Allows `_spender` to spend no more than `_value` tokens in your behalf
124      *
125      * @param _spender The address authorized to spend
126      * @param _value the max amount they can spend
127      */
128     function approve(address _spender, uint256 _value) public
129         returns (bool success) {
130         allowance[msg.sender][_spender] = _value;
131         return true;
132     }
133 
134     /**
135      * Set allowance for other address and notify
136      *
137      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
138      *
139      * @param _spender The address authorized to spend
140      * @param _value the max amount they can spend
141      * @param _extraData some extra information to send to the approved contract
142      */
143     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
144         public
145         returns (bool success) {
146         tokenRecipient spender = tokenRecipient(_spender);
147         if (approve(_spender, _value)) {
148             spender.receiveApproval(msg.sender, _value, this, _extraData);
149             return true;
150         }
151     }
152 
153     /// @notice Create `mintedAmount` tokens and send it to `target`
154     /// @param target Address to receive the tokens
155     /// @param mintedAmount the amount of tokens it will receive
156     function mintToken(address target, uint256 mintedAmount) onlyCrowdsaleAgent public {
157         balanceOf[target] += mintedAmount;
158         totalSupply += mintedAmount;
159         Transfer(0, this, mintedAmount);
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
172     /// @param newBuyPrice Price users can buy from the contract
173     function setPrices(uint256 newBuyPrice) onlyOwner public {
174         buyPrice = newBuyPrice;
175     }
176 
177     /// @notice Buy tokens from contract by sending ether
178     function buy() payable public {
179         uint amount = msg.value * buyPrice;               // calculates the amount
180         _transfer(this, msg.sender, amount);              // makes the transfers
181     }
182 
183     /// @dev Set the contract that can call release and make the token transferable.
184     /// @param _crowdsaleAgent crowdsale contract address
185     function setCrowdsaleAgent(address _crowdsaleAgent) onlyOwner public {
186         crowdsaleAgent = _crowdsaleAgent;
187     }
188 }