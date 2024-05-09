1 pragma solidity ^0.4.25;
2 
3 contract SafeMath {
4   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
5     assert(b <= a);
6     return a - b;
7   }
8 
9   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
10     uint256 c = a + b;
11     assert(c>=a && c>=b);
12     return c;
13   }
14 
15   function assert(bool assertion) internal {
16     if (!assertion) throw;
17   }
18 }
19 
20 contract SCE is SafeMath {
21     // Public variables of the token
22     string public name;
23     string public symbol;
24     uint8 public decimals = 18;
25     // 18 decimals is the strongly suggested default, avoid changing it
26     uint256 public totalSupply;
27 
28     // This creates an array with all balances
29     mapping (address => uint256) public balanceOf;
30     mapping (address => mapping (address => uint256)) public allowance;
31 
32     // This generates a public event on the blockchain that will notify clients
33     event Transfer(address indexed from, address indexed to, uint256 value);
34 
35     // This notifies clients about the amount burnt
36     event Burn(address indexed from, uint256 value);
37 
38     /**
39      * Constructor function
40      *
41      * Initializes contract with initial supply tokens to the creator of the contract
42      */
43     function SCE (
44         uint256 initialSupply,
45         string tokenName,
46         string tokenSymbol
47     ) public {
48         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
49         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
50         name = tokenName;                                   // Set the name for display purposes
51         symbol = tokenSymbol;                               // Set the symbol for display purposes
52     }
53 
54     /* Send coins */
55     function transfer(address _to, uint256 _value) public {
56         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
57 		if (_value <= 0) throw; 
58         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
59         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
60         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
61         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
62         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
63     }
64 
65     /* Allow another contract to spend some tokens in your behalf */
66     function approve(address _spender, uint256 _value) public returns (bool success) {
67 		if (_value <= 0) throw; 
68         allowance[msg.sender][_spender] = _value;
69         return true;
70     }
71     
72     /* A contract attempts to get the coins */
73     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
74         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
75 		if (_value <= 0) throw; 
76         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
77         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
78         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
79         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
80         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
81         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
82         emit Transfer(_from, _to, _value);
83         return true;
84     }
85 
86     /* Destroy tokens */
87     function burn(uint256 _value) public returns (bool success) {
88         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
89 		if (_value <= 0) throw; 
90         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
91         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
92         emit Burn(msg.sender, _value);
93         return true;
94     }
95 }