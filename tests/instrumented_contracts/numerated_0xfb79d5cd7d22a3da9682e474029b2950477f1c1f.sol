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
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
21 
22 contract TokenERC20 {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 0;
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
40     // This notifies clients about the amount burnt
41     event Burn(address indexed from, uint256 value);
42 
43     /**
44      * Constrctor function
45      *
46      * Initializes contract with initial supply tokens to the creator of the contract
47      */
48     function TokenERC20(
49         uint256 initialSupply,
50         string tokenName,
51         string tokenSymbol
52     ) public {
53         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
54         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
55         name = tokenName;                                   // Set the name for display purposes
56         symbol = tokenSymbol;                               // Set the symbol for display purposes
57     }
58 
59     /**
60      * Internal transfer, only can be called by this contract
61      */
62     function _transfer(address _from, address _to, uint _value) internal {
63         // Prevent transfer to 0x0 address. Use burn() instead
64         require(_to != 0x0);
65         // Check if the sender has enough
66         require(balanceOf[_from] >= _value);
67         // Check for overflows
68         require(balanceOf[_to] + _value > balanceOf[_to]);
69         // Save this for an assertion in the future
70         uint previousBalances = balanceOf[_from] + balanceOf[_to];
71         // Subtract from the sender
72         balanceOf[_from] -= _value;
73         // Add the same to the recipient
74         balanceOf[_to] += _value;
75        // event Transfer(_from, _to, _value);
76         // Asserts are used to use static analysis to find bugs in your code. They should never fail
77         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
78     }
79 
80     /**
81      * Transfer tokens
82      *
83      * Send `_value` tokens to `_to` from your account
84      *
85      * @param _to The address of the recipient
86      * @param _value the amount to send
87      */
88     function transfer(address _to, uint256 _value) public returns (bool success) {
89         _transfer(msg.sender, _to, _value);
90         return true;
91     }
92 
93   
94     
95     /**
96      * Destroy tokens
97      *
98      * Remove `_value` tokens from the system irreversibly
99      *
100      * @param _value the amount of money to burn
101      */
102     function burn(uint256 _value) public returns (bool success) {
103         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
104         balanceOf[msg.sender] -= _value;            // Subtract from the sender
105         totalSupply -= _value;                      // Updates totalSupply
106         emit Burn(msg.sender, _value);
107         return true;
108     }
109 
110 }
111 
112 contract Bittrees is owned, TokenERC20 {
113 
114     
115     uint256 public buyPrice = 0.01 ether;
116     uint256 public tokensSold;
117 
118     //mapping (address => bool) public frozenAccount;
119 
120     /* This generates a public event on the blockchain that will notify clients */
121     //event FrozenFunds(address target, bool frozen);
122 
123     /* Initializes contract with initial supply tokens to the creator of the contract */
124     function Bittrees(
125         uint256 initialSupply,
126         string tokenName,
127         string tokenSymbol
128     ) TokenERC20 (initialSupply, tokenName, tokenSymbol) public {}
129 
130     /* Internal transfer, only can be called by this contract */
131     function _transfer(address _from, address _to, uint _value) internal {
132         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
133         require (balanceOf[_from] >= _value);               // Check if the sender has enough
134         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
135       //  require(!frozenAccount[_from]);                     // Check if sender is frozen
136      //   require(!frozenAccount[_to]);                       // Check if recipient is frozen
137         balanceOf[_from] -= _value;                         // Subtract from the sender
138         balanceOf[_to] += _value;                           // Add the same to the recipient
139         emit Transfer(_from, _to, _value);
140     }
141 
142     /// @notice Create `mintedAmount` tokens and send it to `target`
143     /// @param target Address to receive the tokens
144     /// @param mintedAmount the amount of tokens it will receive
145     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
146         balanceOf[target] += mintedAmount;
147         totalSupply += mintedAmount;
148         emit Transfer(0, this, mintedAmount);
149         emit Transfer(this, target, mintedAmount);
150     }
151 
152     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
153    /// @param newBuyPrice Price users can buy from the contract
154     function setPrice(uint256 newBuyPrice) onlyOwner public {
155         
156         buyPrice = newBuyPrice;
157     }
158 
159     /// @notice Buy tokens from contract by sending ether
160     function buy() payable public {
161         uint amount = msg.value / buyPrice;               // calculates the amount
162         _transfer(this, msg.sender, amount);              // makes the transfers
163         tokensSold += amount;
164     }
165 
166     
167     function withdraw() public onlyOwner {
168         address myAddress = this;
169         // makes the transfers
170         msg.sender.transfer(myAddress.balance);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
171     }
172 
173 
174     
175 }