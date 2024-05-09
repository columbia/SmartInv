1 pragma solidity ^0.4.24;
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
32       require(assertion);
33   }
34 }
35 
36 contract FBR is SafeMath{
37     string public name = "FBR";
38     string public symbol = "FBR";
39     uint8 public decimals = 18;
40     uint256 public totalSupply = 10**26;
41 	address public owner;
42 
43     /* This creates an array with all balances */
44     mapping (address => uint256) public balanceOf;
45     mapping (address => mapping (address => uint256)) public allowance;
46 
47     /* This generates a public event on the blockchain that will notify clients */
48     event Transfer(address indexed from, address indexed to, uint256 value);
49 
50     /* This notifies clients about the amount burnt */
51     event Burn(address indexed from, uint256 value);
52 
53     /* Initializes contract with initial supply tokens to the creator of the contract */
54     function FBR() {
55         balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens
56 		owner = msg.sender;
57     }
58 
59     /* Send coins */
60     function transfer(address _to, uint256 _value) {
61         require(_to != 0x0);                              // Prevent transfer to 0x0 address. Use burn() instead
62 		require(_value > 0); 
63         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
64         require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
65         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
66         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
67         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
68     }
69 
70     /* Allow another contract to spend some tokens in your behalf */
71     function approve(address _spender, uint256 _value)
72         returns (bool success) {
73 		require(_value > 0); 
74         allowance[msg.sender][_spender] = _value;
75         return true;
76     }
77        
78     /* A contract attempts to get the coins */
79     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
80         require(_to != 0x0);                              // Prevent transfer to 0x0 address. Use burn() instead
81 		require(_value > 0); 
82         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
83         require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
84         require(_value <= allowance[_from][msg.sender]);     // Check allowance
85         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
86         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
87         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
88         Transfer(_from, _to, _value);
89         return true;
90     }
91 }