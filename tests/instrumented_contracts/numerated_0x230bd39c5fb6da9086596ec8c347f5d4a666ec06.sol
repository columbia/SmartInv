1 pragma solidity ^0.5.5;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
14     assert(b > 0);
15     uint256 c = a / b;
16     assert(a == b * c + a % b);
17     return c;
18   }
19 
20   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c>=a && c>=b);
28     return c;
29   }
30 }
31 contract LGB is SafeMath{
32     string public name;
33     string public symbol;
34     uint8 public decimals;
35     uint256 public totalSupply;
36 	address payable public owner;
37 
38     /* This creates an array with all balances */
39     mapping (address => uint256) public balanceOf;
40     mapping (address => mapping (address => uint256)) public allowance;
41 
42     /* This generates a public event on the blockchain that will notify clients */
43     event Transfer(address indexed from, address indexed to, uint256 value);
44 
45     /* This notifies clients about the amount burnt */
46     event Burn(address indexed from, uint256 value);
47 
48     /* Initializes contract with initial supply tokens to the creator of the contract */
49     constructor (
50         uint256 initialSupply,
51         string memory tokenName,
52         uint8 decimalUnits,
53         string memory tokenSymbol
54         ) public{
55         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
56         totalSupply = initialSupply;                        // Update total supply
57         name = tokenName;                                   // Set the name for display purposes
58         symbol = tokenSymbol;                               // Set the symbol for display purposes
59         decimals = decimalUnits;                            // Amount of decimals for display purposes
60 		owner = msg.sender;
61     }
62 
63     /* Send coins */
64     function transfer(address _to, uint256 _value) public
65     returns (bool success){
66         require (_to != address(0x0));                               // Prevent transfer to 0x0 address. Use burn() instead
67 		require (_value > 0) ; 
68         require (balanceOf[msg.sender] >= _value) ;           // Check if the sender has enough
69         require (balanceOf[_to] + _value >= balanceOf[_to]) ; // Check for overflows
70         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
71         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
72         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
73         return true;
74     }
75 
76     /* Allow another contract to spend some tokens in your behalf */
77     function approve(address _spender, uint256 _value) public
78         returns (bool success) {
79 		require(_value > 0) ; 
80         allowance[msg.sender][_spender] = _value;
81         return true;
82     }
83        
84 
85     /* A contract attempts to get the coins */
86     function transferFrom(address _from, address _to, uint256 _value)public returns (bool success) {
87         require (_to != address(0x0)) ;                                // Prevent transfer to 0x0 address. Use burn() instead
88 		require (_value > 0) ; 
89         require (balanceOf[_from] >= _value) ;                 // Check if the sender has enough
90         require (balanceOf[_to] + _value >= balanceOf[_to]) ;  // Check for overflows
91         require (_value <= allowance[_from][msg.sender]) ;     // Check allowance
92         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
93         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
94         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
95         emit Transfer(_from, _to, _value);
96         return true;
97     }
98 
99     function burn(uint256 _value)public returns (bool success) {
100         require (balanceOf[msg.sender] >= _value) ;            // Check if the sender has enough
101 		require (_value > 0) ; 
102         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
103         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
104         emit Burn(msg.sender, _value);
105         return true;
106     }
107 	
108 	// transfer balance to owner
109 	function withdrawEther(uint256 amount) public {
110 		require(msg.sender == owner);
111 		owner.transfer(amount);
112 	}
113 	
114 	// can accept ether
115 	function() external payable  {
116     }
117 }