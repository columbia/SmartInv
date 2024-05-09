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
36 contract QBT is SafeMath{
37     string public name = "QBT";
38     string public symbol = "QBT";
39     uint8 public decimals = 18;
40     uint256 public totalSupply = 100000000 * 10 ** uint(decimals);
41 	address public owner;
42 
43     /* This creates an array with all balances */
44     mapping (address => uint256) public balanceOf;
45     mapping (address => mapping (address => uint256)) public allowance;
46 
47     /* This generates a public event on the blockchain that will notify clients */
48     event Transfer(address indexed from, address indexed to, uint256 value);
49     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
50 
51 
52     /* Initializes contract with initial supply tokens to the creator of the contract */
53     function QBT() {
54         balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens
55 		owner = msg.sender;
56     }
57 
58     /* Send coins */
59     function transfer(address _to, uint256 _value) {
60         require(_to != 0x0);                              // Prevent transfer to 0x0 address. Use burn() instead
61 		require(_value > 0); 
62         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
63         require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
64         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
65         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
66         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
67     }
68 
69     /* Allow another contract to spend some tokens in your behalf */
70     function approve(address _spender, uint256 _value) returns (bool success) {
71 		require(_value > 0); 
72         allowance[msg.sender][_spender] = _value;
73         Approval(msg.sender, _spender, _value);
74         return true;
75     }
76        
77     /* A contract attempts to get the coins */
78     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
79         require(_to != 0x0);                              // Prevent transfer to 0x0 address. Use burn() instead
80 		require(_value > 0); 
81         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
82         require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
83         require(_value <= allowance[_from][msg.sender]);     // Check allowance
84         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
85         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
86         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
87         Transfer(_from, _to, _value);
88         return true;
89     }
90 }