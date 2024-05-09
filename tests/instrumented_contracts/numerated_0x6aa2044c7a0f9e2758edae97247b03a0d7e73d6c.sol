1 pragma solidity ^0.4.8;
2 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
3 contract owned {
4     address public owner;
5 
6     function owned() {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         if (msg.sender != owner) throw;
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner {
16         owner = newOwner;
17     }
18 }
19 
20 
21 contract CardToken is owned {
22     string public standard = 'Token 0.1';
23     string public name;
24     string public symbol;
25     string public ipfs_hash;
26     string public description;
27     bool public isLocked;
28     uint8 public decimals;
29     uint256 public totalSupply;
30 
31     /* This creates an array with all balances */
32     mapping (address => uint256) public balanceOf;
33     mapping (address => mapping (address => uint256)) public allowance;
34 
35     /* This generates a public event on the blockchain that will notify clients */
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 
38     /* Initializes contract with initial supply tokens to the creator of the contract */
39     function CardToken(
40         uint256 initialSupply,
41         string tokenName,
42         string tokenSymbol,
43         string tokenDescription,
44         string ipfsHash
45         ) {
46         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
47         totalSupply = initialSupply;                        // Update total supply
48         name = tokenName;                                   // Set the name for display purposes
49         symbol = tokenSymbol;   // Set the symbol for display purposes (first three as name or three char combo)
50         description = tokenDescription; //Description in gallery
51         ipfs_hash = ipfsHash;
52         decimals = 0;                            // Amount of decimals for display purposes
53     }
54     /* Send coins */
55     function transfer(address _to, uint256 _value) {
56         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
57         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
58         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
59         balanceOf[_to] += _value;                            // Add the same to the recipient
60     }
61 
62     /* Allow another contract to spend some tokens in your behalf */
63     function approve(address _spender, uint256 _value)
64         returns (bool success) {
65         allowance[msg.sender][_spender] = _value;
66         return true;
67     }
68 
69     /* Approve and then comunicate the approved contract in a single tx */
70     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
71         returns (bool success) {
72         tokenRecipient spender = tokenRecipient(_spender);
73         if (approve(_spender, _value)) {
74             spender.receiveApproval(msg.sender, _value, this, _extraData);
75             return true;
76         }
77     }
78 
79     /* A contract attempts to get the coins */
80     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
81         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
82         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
83         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
84         balanceOf[_from] -= _value;                          // Subtract from the sender
85         balanceOf[_to] += _value;                            // Add the same to the recipient
86         allowance[_from][msg.sender] -= _value;
87         Transfer(_from, _to, _value);
88         return true;
89     }
90 
91     function mintToken(address target, uint256 mintedAmount) onlyOwner {
92         if (isLocked) { throw; }
93 
94         balanceOf[target] += mintedAmount;
95         totalSupply += mintedAmount;
96         Transfer(0, this, mintedAmount);
97         Transfer(this, target, mintedAmount);
98     }
99 
100     function lock() onlyOwner  {
101         isLocked = true;
102 
103     }
104 
105     function setDescription(string desc) onlyOwner {
106          description = desc;
107     }
108 
109     /* This unnamed function is called whenever someone tries to send ether to it */
110     function () {
111         throw;     // Prevents accidental sending of ether
112     }
113 }
114 
115 contract CardFactory {
116     address[] public Cards;
117     uint256 public CardCount;
118    function CardFactory() {
119        CardCount = 0;
120    }
121    function CreateCard(uint256 _initialAmount, string _name, string _symbol, string _desc,string _ipfshash) returns (address) {
122 
123         CardToken newToken = (new CardToken(_initialAmount, _name,_symbol, _desc,_ipfshash));
124         Cards.push(address(newToken));
125         CardCount++;
126         newToken.transferOwnership(msg.sender);
127         newToken.transfer(msg.sender, _initialAmount); //the factory will own the created tokens. You must transfer them.
128         return address(newToken);
129     }
130 
131       function () {
132         throw;     // Prevents accidental sending of ether
133     }
134 }