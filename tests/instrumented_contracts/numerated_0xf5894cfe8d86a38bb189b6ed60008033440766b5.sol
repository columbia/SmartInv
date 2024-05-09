1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract owned {
4     address public owner;
5 
6     constructor() public {
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
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata_extraData) external; }
21 
22 contract TokenERC20 {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     // 18 decimals is the strongly suggested default, avoid changing it
28     uint256 public totalSupply;
29 
30     // This creates an array with all balances
31     mapping (address => uint256) public balanceOf;
32     mapping (address => mapping (address => uint256)) public allowance;
33 
34     // This generates a public event on the blockchain that will notify clients
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     
37     // This generates a public event on the blockchain that will notify clients
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 
40     /**
41      * Constrctor function
42      *
43      * Initializes contract with initial supply tokens to the creator of the contract
44      */
45     constructor(
46         uint256 initialSupply,
47         string memory tokenName,
48         string memory tokenSymbol
49     ) public {
50         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
51         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
52         name = tokenName;                                       // Set the name for display purposes
53         symbol = tokenSymbol;                                   // Set the symbol for display purposes
54     }
55 
56     /**
57      * Internal transfer, only can be called by this contract
58      */
59     function _transfer(address _from, address _to, uint _value) internal {
60         // Prevent transfer to 0x0 address. Use burn() instead
61         require(_to != address(0x0));
62         // Check if the sender has enough
63         require(balanceOf[_from] >= _value);
64         // Check for overflows
65         require(balanceOf[_to] + _value > balanceOf[_to]);
66         // Save this for an assertion in the future
67         uint previousBalances = balanceOf[_from] + balanceOf[_to];
68         // Subtract from the sender
69         balanceOf[_from] -= _value;
70         // Add the same to the recipient
71         balanceOf[_to] += _value;
72         emit Transfer(_from, _to, _value);
73         // Asserts are used to use static analysis to find bugs in your code. They should never fail
74         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
75     }
76 
77     /**
78      * Transfer tokens
79      *
80      * Send `_value` tokens to `_to` from your account
81      *
82      * @param _to The address of the recipient
83      * @param _value the amount to send
84      */
85     function transfer(address _to, uint256 _value) public returns (bool success) {
86         _transfer(msg.sender, _to, _value);
87         return true;
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
117         emit Approval(msg.sender, _spender, _value);
118         return true;
119     }
120 
121     /**
122      * Set allowance for other address and notify
123      *
124      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
125      *
126      * @param _spender The address authorized to spend
127      * @param _value the max amount they can spend
128      * @param _extraData some extra information to send to the approved contract
129      */
130     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
131         public
132         returns (bool success) {
133         tokenRecipient spender = tokenRecipient(_spender);
134         if (approve(_spender, _value)) {
135             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
136             return true;
137         }
138     }
139 }
140 
141 /******************************************/
142 /*       ADVANCED TOKEN STARTS HERE       */
143 /******************************************/
144 
145 contract WBBTToken is owned, TokenERC20 {
146 
147     uint256 public sellPrice;
148     uint256 public buyPrice;
149 
150     mapping (address => bool) public frozenAccount;
151 
152     /* This generates a public event on the blockchain that will notify clients */
153     event FrozenFunds(address target, bool frozen);
154 
155     /* Initializes contract with initial supply tokens to the creator of the contract */
156     constructor(
157         uint256 initialSupply,
158         string memory tokenName,
159         string memory tokenSymbol
160     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
161 
162     /* Internal transfer, only can be called by this contract */
163     function _transfer(address _from, address _to, uint _value) internal {
164         require (_to != address(0x0));                          // Prevent transfer to 0x0 address. Use burn() instead
165         require (balanceOf[_from] >= _value);                   // Check if the sender has enough
166         require (balanceOf[_to] + _value >= balanceOf[_to]);    // Check for overflows
167         require(!frozenAccount[_from]);                         // Check if sender is frozen
168         require(!frozenAccount[_to]);                           // Check if recipient is frozen
169         balanceOf[_from] -= _value;                             // Subtract from the sender
170         balanceOf[_to] += _value;                               // Add the same to the recipient
171         emit Transfer(_from, _to, _value);
172     }
173 
174     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
175     /// @param target Address to be frozen
176     /// @param freeze either to freeze it or not
177     function freezeAccount(address target, bool freeze) onlyOwner public {
178         frozenAccount[target] = freeze;
179         emit FrozenFunds(target, freeze);
180     }
181 
182     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
183     /// @param newSellPrice Price the users can sell to the contract
184     /// @param newBuyPrice Price users can buy from the contract
185     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
186         sellPrice = newSellPrice;
187         buyPrice = newBuyPrice;
188     }
189 
190     /// @notice Buy tokens from contract by sending ether
191     function buy() payable public {
192         uint amount = msg.value / buyPrice;                 // calculates the amount
193         _transfer(address(this), msg.sender, amount);       // makes the transfers
194     }
195 
196     /// @notice Sell `amount` tokens to contract
197     /// @param amount amount of tokens to be sold
198     function sell(uint256 amount) public {
199         address myAddress = address(this);
200         require(myAddress.balance >= amount * sellPrice);   // checks if the contract has enough ether to buy
201         _transfer(msg.sender, address(this), amount);       // makes the transfers
202         msg.sender.transfer(amount * sellPrice);            // sends ether to the seller. It's important to do this last to avoid recursion attacks
203     }
204 }