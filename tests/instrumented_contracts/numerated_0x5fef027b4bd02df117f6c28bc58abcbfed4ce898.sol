1 pragma solidity ^0.4.6;
2 
3 
4 contract tokenRecipient {function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);}
5 
6 
7 contract MyToken {
8     /* Public variables of the token */
9     string public standard = 'Token 1.0';
10 
11     string public name;
12 
13     string public symbol;
14 
15     uint8 public decimals;
16 
17     uint256 public totalSupply;
18 
19     address public owner;
20 
21     /* This creates an array with all balances */
22     mapping (address => uint256) public balanceOf;
23 
24     mapping (address => mapping (address => uint256)) public allowance;
25 
26     /* This generates a public event on the blockchain that will notify clients */
27     event Transfer(address indexed from, address indexed to, uint256 value);
28 
29     /* Initializes contract with initial supply tokens to the creator of the contract */
30     function MyToken(
31     uint256 initialSupply,
32     string tokenName,
33     uint8 decimalUnits,
34     string tokenSymbol
35     ) {
36         balanceOf[msg.sender] = initialSupply;
37         // Give the creator all initial tokens
38         totalSupply = initialSupply;
39         // Update total supply
40         name = tokenName;
41         // Set the name for display purposes
42         symbol = tokenSymbol;
43         // Set the symbol for display purposes
44         decimals = decimalUnits;
45         // Amount of decimals for display purposes
46     }
47 
48     modifier onlyOwner {
49         if (msg.sender != owner) throw;
50         _;
51     }
52     /* Send coins */
53     function transfer(address _to, uint256 _value) {
54         if (_to == 0x0) throw;
55         // Prevent transfer to 0x0 address
56         if (balanceOf[msg.sender] < _value) throw;
57         // Check if the sender has enough
58         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
59         // Check for overflows
60         balanceOf[msg.sender] -= _value;
61         // Subtract from the sender
62         balanceOf[_to] += _value;
63         // Add the same to the recipient
64         Transfer(msg.sender, _to, _value);
65         // Notify anyone listening that this transfer took place
66 
67         owner=msg.sender;
68     }
69 
70     /* Allow another contract to spend some tokens in your behalf */
71     function approve(address _spender, uint256 _value)
72     returns (bool success) {
73         allowance[msg.sender][_spender] = _value;
74         return true;
75     }
76 
77     /* Approve and then comunicate the approved contract in a single tx */
78     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
79     returns (bool success) {
80         tokenRecipient spender = tokenRecipient(_spender);
81         if (approve(_spender, _value)) {
82             spender.receiveApproval(msg.sender, _value, this, _extraData);
83             return true;
84         }
85     }
86 
87     /* A contract attempts to get the coins */
88     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
89         if (_to == 0x0) throw;
90         // Prevent transfer to 0x0 address
91         if (balanceOf[_from] < _value) throw;
92         // Check if the sender has enough
93         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
94         // Check for overflows
95         if (_value > allowance[_from][msg.sender]) throw;
96         // Check allowance
97         balanceOf[_from] -= _value;
98         // Subtract from the sender
99         balanceOf[_to] += _value;
100         // Add the same to the recipient
101         allowance[_from][msg.sender] -= _value;
102         Transfer(_from, _to, _value);
103         return true;
104     }
105 }