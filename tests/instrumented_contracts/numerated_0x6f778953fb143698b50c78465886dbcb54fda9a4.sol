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
33       throw;
34     }
35   }
36 }
37 contract GOC is SafeMath{
38     uint256 public totalSupply;
39 	string public name = "GOC";
40     string public symbol = "GOC";
41 	uint8 public decimals = 8;
42 
43     /* This creates an array with all balances */
44     mapping (address => uint256) public balanceOf;
45     mapping (address => mapping (address => uint256)) public allowance;
46 
47     /* This generates a public event on the blockchain that will notify clients */
48     event Transfer(address indexed from, address indexed to, uint256 value);
49 
50     /* Initializes contract with initial supply tokens to the creator of the contract */
51     function GOC() {
52 		totalSupply = 300000000 * 10 ** 8;                        // Update total supply
53         balanceOf[0xB97f41cc340899DbA210BdCc86a912ef100eFE96] = totalSupply;              // Give the creator all initial tokens
54     }
55 
56     /* Send coins */
57     function transfer(address _to, uint256 _value) {
58         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
59 		if (_value <= 0) throw; 
60         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
61         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
62         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
63         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
64         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
65     }
66 
67     /* Allow another contract to spend some tokens in your behalf */
68     function approve(address _spender, uint256 _value)
69         returns (bool success) {
70 		if (_value <= 0) throw; 
71         allowance[msg.sender][_spender] = _value;
72         return true;
73     }
74        
75 
76     /* A contract attempts to get the coins */
77     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
78         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
79 		if (_value <= 0) throw; 
80         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
81         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
82         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
83         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
84         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
85         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
86         Transfer(_from, _to, _value);
87         return true;
88     }
89 	
90 	// can accept ether
91 	function() payable {
92 		revert();
93     }
94 }