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
32     // if (!assertion) {
33     //   throw;
34     // }
35     require(assertion);
36   }
37 }
38 contract Tsoc is SafeMath{
39     string public name;
40     string public symbol;
41     uint8 public decimals;
42     uint256 public totalSupply;
43 	address public owner;
44 
45     /* This creates an array with all balances */
46     mapping (address => uint256) public balanceOf;
47     mapping (address => mapping (address => uint256)) public allowance;
48 
49     /* This generates a public event on the blockchain that will notify clients */
50     event Transfer(address indexed from, address indexed to, uint256 value);
51 
52     /* This notifies clients about the amount burnt */
53     event Burn(address indexed from, uint256 value);
54 	
55 
56     /* Initializes contract with initial supply tokens to the creator of the contract */
57     constructor() public {
58         totalSupply = 5*10**27 ;
59         balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens
60         name = "Angle ore circle";                               // Set the name for display purposes
61         symbol = "Tsoc" ;                             // Set the symbol for display purposes
62         decimals = 18 ;                            // Amount of decimals for display purposes
63 		owner = msg.sender;
64     }
65 
66     /* Send coins */
67     function transfer(address _to, uint256 _value) public {
68         require(_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
69 		require(_value > 0) ; 
70         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
71         require(balanceOf[_to] + _value >= balanceOf[_to]) ; // Check for overflows
72         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
73         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
74         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
75     }
76 
77     /* Allow another contract to spend some tokens in your behalf */
78     function approve(address _spender, uint256 _value) public returns (bool success) {
79 		require (_value > 0) ; 
80         allowance[msg.sender][_spender] = _value;
81         return true;
82     }
83        
84 
85     /* A contract attempts to get the coins */
86     function transferFrom(address _from, address _to, uint256 _value)public returns (bool success) {
87         require(_to!=0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
88 		require(_value>0); 
89         require(balanceOf[_from] >= _value);                 // Check if the sender has enough
90         require(balanceOf[_to] + _value >= balanceOf[_to]);  // Check for overflows
91         require(_value <= allowance[_from][msg.sender]) ;     // Check allowance
92         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
93         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
94         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
95         emit Transfer(_from, _to, _value);
96         return true;
97     }
98 
99     function burn(uint256 _value) public returns (bool success) {
100         require(balanceOf[msg.sender] >= _value);            // Check if the sender has enough
101 		require (_value > 0) ; 
102         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
103         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
104         emit Burn(msg.sender, _value);
105         return true;
106     }
107 	// transfer balance to owner
108 	function withdrawEther(uint256 amount) public {
109 		require(msg.sender == owner);
110 		owner.transfer(amount);
111 	}
112 	
113 	// can accept ether
114     function() public payable
115     {
116     }
117 }