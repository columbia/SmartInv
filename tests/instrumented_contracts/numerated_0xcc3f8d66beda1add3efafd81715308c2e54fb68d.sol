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
22 contract ReimburseToken {
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
37     /**
38      * Constrctor function
39      *
40      * Initializes contract with initial supply tokens to the creator of the contract
41      */
42     function ReimburseToken(
43         uint256 initialSupply,
44         string tokenName,
45         string tokenSymbol
46     ) public {
47         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
48         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
49         name = tokenName;                                   // Set the name for display purposes
50         symbol = tokenSymbol;                               // Set the symbol for display purposes
51     }
52 
53     /**
54      * Internal transfer, only can be called by this contract
55      */
56     function _transfer(address _from, address _to, uint _value) internal {
57         // Prevent transfer to 0x0 address. Use burn() instead
58         require(_to != 0x0);
59         // Check if the sender has enough
60         require(balanceOf[_from] >= _value);
61         // Check for overflows
62         require(balanceOf[_to] + _value > balanceOf[_to]);
63         // Save this for an assertion in the future
64         uint previousBalances = balanceOf[_from] + balanceOf[_to];
65         // Subtract from the sender
66         balanceOf[_from] -= _value;
67         // Add the same to the recipient
68         balanceOf[_to] += _value;
69         Transfer(_from, _to, _value);
70         // Asserts are used to use static analysis to find bugs in your code. They should never fail
71         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
72     }
73 
74     /**
75      * Transfer tokens
76      *
77      * Send `_value` tokens to `_to` from your account
78      *
79      * @param _to The address of the recipient
80      * @param _value the amount to send
81      */
82     function transfer(address _to, uint256 _value) public {
83         _transfer(msg.sender, _to, _value);
84     }
85 
86     /**
87      * Transfer tokens from other address
88      *
89      * Send `_value` tokens to `_to` in behalf of `_from`
90      *
91      * @param _from The address of the sender
92      * @param _to The address of the recipient
93      * @param _value the amount to send
94      */
95     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
96         require(_value <= allowance[_from][msg.sender]);     // Check allowance
97         allowance[_from][msg.sender] -= _value;
98         _transfer(_from, _to, _value);
99         return true;
100     }
101 
102 }
103 
104 contract MyAdvancedReimburseToken is owned, ReimburseToken {
105 
106     mapping (address => bool) public frozenAccount;
107 
108     /* This generates a public event on the blockchain that will notify clients */
109     event FrozenFunds(address target, bool frozen);
110 
111     /* Initializes contract with initial supply tokens to the creator of the contract */
112     function MyAdvancedReimburseToken(
113         uint256 initialSupply,
114         string tokenName,
115         string tokenSymbol
116     ) ReimburseToken(initialSupply, tokenName, tokenSymbol) public {}
117 
118     /* Internal transfer, only can be called by this contract */
119     function _transfer(address _from, address _to, uint _value) internal {
120         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
121         require (balanceOf[_from] >= _value);               // Check if the sender has enough
122         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
123         require(!frozenAccount[_from]);                     // Check if sender is frozen
124         require(!frozenAccount[_to]);                       // Check if recipient is frozen
125         balanceOf[_from] -= _value;                         // Subtract from the sender
126         balanceOf[_to] += _value;                           // Add the same to the recipient
127         Transfer(_from, _to, _value);
128     }
129 
130     /// @notice Create `mintedAmount` tokens and send it to `target`
131     /// @param target Address to receive the tokens
132     /// @param mintedAmount the amount of tokens it will receive
133     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
134         balanceOf[target] += mintedAmount;
135         totalSupply += mintedAmount;
136         Transfer(0, this, mintedAmount);
137         Transfer(this, target, mintedAmount);
138     }
139 
140 
141 }