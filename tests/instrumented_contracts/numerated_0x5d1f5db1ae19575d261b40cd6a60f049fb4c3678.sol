1 pragma solidity ^0.4.10;
2 
3 
4 contract tokenRecipient {function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);}
5 
6 
7 contract Sponsify {
8     /* Public variables of the token */
9     string public standard = 'SPO1.0';
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
30     function Sponsify(
31     ) {
32         balanceOf[msg.sender] = 50000000000;
33         // Give the creator all initial tokens
34         totalSupply = 50000000000;
35         // Update total supply
36         name = "SPONSIFY";
37         // Set the name for display purposes
38         symbol = "SPO";
39         // Set the symbol for display purposes
40         decimals = 2;
41         // Amount of decimals for display purposes
42 
43         owner=msg.sender;
44     }
45 
46     modifier onlyOwner {
47         if (msg.sender != owner) throw;
48         _;
49     }
50     /* Send coins */
51     function transfer(address _to, uint256 _value) {
52         if (_to == 0x0) revert();
53         // Prevent transfer to 0x0 address
54         if (balanceOf[msg.sender] < _value) revert();
55         // Check if the sender has enough
56         if (balanceOf[_to] + _value < balanceOf[_to]) revert();
57         // Check for overflows
58         balanceOf[msg.sender] -= _value;
59         // Subtract from the sender
60         balanceOf[_to] += _value;
61         // Add the same to the recipient
62         Transfer(msg.sender, _to, _value);
63         // Notify anyone listening that this transfer took place
64     }
65 
66     /* Allow another contract to spend some tokens in your behalf */
67     function approve(address _spender, uint256 _value)
68     returns (bool success) {
69         allowance[msg.sender][_spender] = _value;
70         return true;
71     }
72 
73     /* Approve and then comunicate the approved contract in a single tx */
74     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
75     returns (bool success) {
76         tokenRecipient spender = tokenRecipient(_spender);
77         if (approve(_spender, _value)) {
78             spender.receiveApproval(msg.sender, _value, this, _extraData);
79             return true;
80         }
81     }
82 
83     /* A contract attempts to get the coins */
84     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
85         if (_to == 0x0) revert();
86         // Prevent transfer to 0x0 address
87         if (balanceOf[_from] < _value) revert();
88         // Check if the sender has enough
89         if (balanceOf[_to] + _value < balanceOf[_to]) revert();
90         // Check for overflows
91         if (_value > allowance[_from][msg.sender]) revert();
92         // Check allowance
93         balanceOf[_from] -= _value;
94         // Subtract from the sender
95         balanceOf[_to] += _value;
96         // Add the same to the recipient
97         allowance[_from][msg.sender] -= _value;
98         Transfer(_from, _to, _value);
99         return true;
100     }
101 
102 }