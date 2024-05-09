1 pragma solidity ^0.4.8;
2 contract Ownable {
3   address public owner;
4   
5 
6   function Ownable() {
7     owner = msg.sender;
8   }
9 
10   modifier onlyOwner() {
11     if (msg.sender != owner) {
12       throw;
13     }
14     _;
15   }
16 
17   function transferOwnership(address newOwner) onlyOwner {
18     if (newOwner != address(0)) {
19       owner = newOwner;
20     }
21   }
22   
23   function kill() onlyOwner {
24      selfdestruct(owner);
25   }
26 }
27 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
28 
29 contract GCSToken is Ownable{
30     /* Public variables of the token */
31     string public name;
32     string public symbol;
33     uint8 public decimals;
34     uint256 public totalSupply;
35 
36     /* This creates an array with all balances */
37     mapping (address => uint256) public balanceOf;
38     mapping (address => mapping (address => uint256)) public allowance;
39 
40     /* This generates a public event on the blockchain that will notify clients */
41     event Transfer(address indexed from, address indexed to, uint256 value);
42 
43     function () {
44         throw;
45     }
46     /* Initializes contract with initial supply tokens to the creator of the contract */
47     function GCSToken(
48         ) {
49         balanceOf[msg.sender] = 210000000000000000;              // Give the creator all initial tokens
50         totalSupply = 210000000000000000;                        // Update total supply
51         name = "Gamechain System";                                   // Set the name for display purposes
52         symbol = "GCS";                              // Set the symbol for display purposes
53         decimals = 8;                            // Amount of decimals for display purposes
54         
55     }
56     
57    
58 
59     /* Send coins */
60     function transfer(address _to, uint256 _value) {
61         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
62         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
63         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
64         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
65         balanceOf[_to] += _value;                            // Add the same to the recipient
66         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
67     }
68 
69     /* Allow another contract to spend some tokens in your behalf */
70     function approve(address _spender, uint256 _value)
71         returns (bool success) {
72         allowance[msg.sender][_spender] = _value;
73         return true;
74     }
75 
76     /* Approve and then communicate the approved contract in a single tx */
77     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
78         returns (bool success) {
79         tokenRecipient spender = tokenRecipient(_spender);
80         if (approve(_spender, _value)) {
81             spender.receiveApproval(msg.sender, _value, this, _extraData);
82             return true;
83         }
84     }        
85 
86     /* A contract attempts to get the coins */
87     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
88         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
89         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
90         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
91         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
92         balanceOf[_from] -= _value;                           // Subtract from the sender
93         balanceOf[_to] += _value;                             // Add the same to the recipient
94         allowance[_from][msg.sender] -= _value;
95         Transfer(_from, _to, _value);
96         return true;
97     }
98 }