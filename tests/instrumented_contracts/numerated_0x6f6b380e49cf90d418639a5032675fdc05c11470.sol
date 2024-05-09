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
19 // SCE
20 contract TB is SafeMath {
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
34     // This notifies clients about the amount burnt
35     event Burn(address indexed from, uint256 value);
36 
37     /**
38      * Constructor function
39      *
40      * Initializes contract with initial supply tokens to the creator of the contract
41      */
42     function TB (
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
53     /* Send coins */
54     function transfer(address _to, uint256 _value) public {
55         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
56 		if (_value <= 0) throw; 
57         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
58         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
59         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
60         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
61         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
62     }
63 
64     /* Allow another contract to spend some tokens in your behalf */
65     function approve(address _spender, uint256 _value) public returns (bool success) {
66 		if (_value <= 0) throw; 
67         allowance[msg.sender][_spender] = _value;
68         return true;
69     }
70     
71     /* A contract attempts to get the coins */
72     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
73         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
74 		if (_value <= 0) throw; 
75         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
76         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
77         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
78         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
79         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
80         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
81         emit Transfer(_from, _to, _value);
82         return true;
83     }
84 
85     /* Destroy tokens */
86     function burn(uint256 _value) public returns (bool success) {
87         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
88 		if (_value <= 0) throw; 
89         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
90         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
91         emit Burn(msg.sender, _value);
92         return true;
93     }
94 }