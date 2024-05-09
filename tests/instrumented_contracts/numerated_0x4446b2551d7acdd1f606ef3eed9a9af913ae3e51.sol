1 pragma solidity ^0.4.8;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
14     assert(b > 0);
15     uint256 c = a / b;
16     assert(a == b * c + a % b);
17     return c;
18   }
19 
20   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
26     uint256 c = a + b;
27     assert(c>=a && c>=b);
28     return c;
29   }
30 
31   function assert(bool assertion) internal {
32     if (!assertion) {
33       revert();
34     }
35   }
36 }
37 contract CCC is SafeMath{
38     string public name;
39     string public symbol;
40     uint8 public decimals;
41     uint256 public totalSupply;
42 	address public owner;
43 
44     /* This creates an array with all balances */
45     mapping (address => uint256) public balanceOf;
46     mapping (address => mapping (address => uint256)) public allowance;
47 
48     /* This generates a public event on the blockchain that will notify clients */
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 
51     /* This notifies clients about the amount burnt */
52     event Burn(address indexed from, uint256 value);
53 	
54 
55     /* Initializes contract with initial supply tokens to the creator of the contract */
56     constructor() public {
57         balanceOf[msg.sender] = 250000000 * 10 ** 18;              // Give the creator all initial tokens
58         totalSupply = 250000000 * 10 ** 18;                        // Update total supply
59         name = "CryptoCocktailCoin";                                   // Set the name for display purposes
60         symbol = "CCC";                               // Set the symbol for display purposes
61         decimals = 18;                            // Amount of decimals for display purposes
62 		owner = msg.sender;
63     }
64 
65     /* Send coins */
66     function transfer(address _to, uint256 _value) public {
67         if (_to == 0x0) revert();                               // Prevent transfer to 0x0 address. Use burn() instead
68 		if (_value <= 0) revert(); 
69         if (balanceOf[msg.sender] < _value) revert();           // Check if the sender has enough
70         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows
71         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
72         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
73         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
74     }
75 
76     /* Allow another contract to spend some tokens in your behalf */
77     function approve(address _spender, uint256 _value) public
78         returns (bool success) {
79 		if (_value <= 0) revert(); 
80         allowance[msg.sender][_spender] = _value;
81         return true;
82     }
83        
84 
85     /* A contract attempts to get the coins */
86     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
87         if (_to == 0x0) revert();                                // Prevent transfer to 0x0 address. Use burn() instead
88 		if (_value <= 0) revert(); 
89         if (balanceOf[_from] < _value) revert();                 // Check if the sender has enough
90         if (balanceOf[_to] + _value < balanceOf[_to]) revert();  // Check for overflows
91         if (_value > allowance[_from][msg.sender]) revert();     // Check allowance
92         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
93         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
94         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
95         emit Transfer(_from, _to, _value);
96         return true;
97     }
98 
99     function burn(uint256 _value) public returns (bool success) {
100         if (balanceOf[msg.sender] < _value) revert();            // Check if the sender has enough
101 		if (_value <= 0) revert(); 
102         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
103         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
104         emit Burn(msg.sender, _value);
105         return true;
106     }
107 }