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
19 contract SCE is SafeMath {
20     // Public variables of the token
21     string public name;
22     string public symbol;
23     uint8 public decimals = 18;
24     // 18 decimals is the strongly suggested default, avoid changing it
25     uint256 public totalSupply;
26 
27     // This creates an array with all balances
28     mapping (address => uint256) public balanceOf;
29     mapping (address => mapping (address => uint256)) public allowance;
30 
31     // This generates a public event on the blockchain that will notify clients
32     event Transfer(address indexed from, address indexed to, uint256 value);
33     // This notifies clients about the amount burnt
34     event Burn(address indexed from, uint256 value);
35 
36     /**
37      * Constructor function
38      *
39      * Initializes contract with initial supply tokens to the creator of the contract
40      */
41     function SCE (
42         uint256 initialSupply,
43         string tokenName,
44         string tokenSymbol
45     ) public {
46         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
47         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
48         name = tokenName;                                   // Set the name for display purposes
49         symbol = tokenSymbol;                               // Set the symbol for display purposes
50     }
51 
52     /* Send coins */
53     function transfer(address _to, uint256 _value) public {
54         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
55 		if (_value <= 0) throw; 
56         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
57         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
58         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
59         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
60         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
61     }
62 
63     /* Allow another contract to spend some tokens in your behalf */
64     function approve(address _spender, uint256 _value) public returns (bool success) {
65 		if (_value <= 0) throw; 
66         allowance[msg.sender][_spender] = _value;
67         return true;
68     }
69     
70     /* A contract attempts to get the coins */
71     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
72         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
73 		if (_value <= 0) throw; 
74         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
75         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
76         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
77         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
78         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
79         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
80         emit Transfer(_from, _to, _value);
81         return true;
82     }
83 
84     /* Destroy tokens */
85     function burn(uint256 _value) public returns (bool success) {
86         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
87 		if (_value <= 0) throw; 
88         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
89         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
90         emit Burn(msg.sender, _value);
91         return true;
92     }
93 }