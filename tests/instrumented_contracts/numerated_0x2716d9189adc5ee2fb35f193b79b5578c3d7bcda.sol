1 pragma solidity ^0.4.18;
2 
3 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
4 
5 //ERC20 Token
6 contract token {
7     /* Public variables of the token */
8     string public standard = "LEGIT 1.0";
9     string public name;
10     string public symbol;
11     uint8 public decimals;
12     uint256 public totalSupply;
13 
14     /* This creates an array with all balances */
15     mapping (address => uint256) public balanceOf;
16     mapping (address => mapping (address => uint256)) public allowance;
17 
18     /* This generates a public event on the blockchain that will notify clients */
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     /* Initializes contract with initial supply tokens to the creator of the contract */
22     function token(
23         uint256 initialSupply,
24         string tokenName,
25         uint8 decimalUnits,
26         string tokenSymbol
27         ) {
28         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
29         totalSupply = initialSupply;                        // Update total supply
30         name = tokenName;                                   // Set the name for display purposes
31         symbol = tokenSymbol;                               // Set the symbol for display purposes
32         decimals = decimalUnits;                            // Amount of decimals for display purposes
33     }
34 
35     /* Send coins */
36     function transfer(address _to, uint256 _value) {
37         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
38         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
39         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
40         balanceOf[_to] += _value;                            // Add the same to the recipient
41         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
42     }
43 
44     /* Allow another contract to spend some tokens in your behalf */
45     function approve(address _spender, uint256 _value)
46         returns (bool success) {
47         allowance[msg.sender][_spender] = _value;
48         return true;
49     }
50 
51     /* Approve and then communicate the approved contract in a single tx */
52     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
53         returns (bool success) {
54         tokenRecipient spender = tokenRecipient(_spender);
55         if (approve(_spender, _value)) {
56             spender.receiveApproval(msg.sender, _value, this, _extraData);
57             return true;
58         }
59     }
60 
61     /* A contract attempts _ to get the coins */
62     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
63         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
64         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
65         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
66         balanceOf[_from] -= _value;                          // Subtract from the sender
67         balanceOf[_to] += _value;                            // Add the same to the recipient
68         allowance[_from][msg.sender] -= _value;
69         Transfer(_from, _to, _value);
70         return true;
71     }
72 
73     /* This unnamed function is called whenever someone tries to send ether to it */
74     function () {
75         throw;     // Prevents accidental sending of ether
76     }
77 }
78 
79 
80 contract Ownable {
81   address public owner;
82   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
83   /**
84    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
85    * account.
86    */
87   function Ownable() {
88     owner = msg.sender;
89   }
90   /**
91    * @dev Throws if called by any account other than the owner.
92    */
93   modifier onlyOwner() {
94     require(msg.sender == owner);
95     _;
96   }
97   /**
98    * @dev Allows the current owner to transfer control of the contract to a newOwner.
99    * @param newOwner The address to transfer ownership to.
100    */
101   function transferOwnership(address newOwner) onlyOwner public {
102     require(newOwner != address(0));
103     OwnershipTransferred(owner, newOwner);
104     owner = newOwner;
105   }
106 }
107 
108 contract EthereumLegitAirDrop is Ownable {
109   uint public numDrops;
110   uint public dropAmount;
111   token myToken;
112 
113   function EthereumLegitAirDrop(address dropper, address tokenContractAddress) {
114     myToken = token(tokenContractAddress);
115     transferOwnership(dropper);
116   }
117 
118   event TokenDrop( address receiver, uint amount );
119 
120   function airDrop( address[] recipients,
121                     uint amount) onlyOwner {
122     require( amount > 0);
123 
124     for( uint i = 0 ; i < recipients.length ; i++ ) {
125         myToken.transfer( recipients[i], amount);
126         TokenDrop( recipients[i], amount );
127     }
128 
129     numDrops += recipients.length;
130     dropAmount += recipients.length * amount;
131   }
132 
133 
134   function emergencyDrain( uint amount ) onlyOwner {
135       myToken.transfer( owner, amount );
136   }
137 }