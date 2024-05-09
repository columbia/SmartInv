1 pragma solidity >0.4.24 <0.6.0;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath{
7     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
8         if (a == 0) {
9             return 0;
10         }
11         c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         assert(b > 0); 
18         uint256 c = a / b;
19         assert(a == b * c + a % b); 
20         return a / b;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         assert(b <= a);
25         return a - b;
26     }
27 
28     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
29         c = a + b;
30         assert(c >= a);
31         return c;
32     }
33 }
34 contract TK is SafeMath{
35     string public name = "TOK Coin";
36     string public symbol = "TK";
37     uint8 public decimals = 18;
38     uint256 public totalSupply =  100 * 10 ** 8 * 10 ** uint256(decimals);
39 
40     /* This creates an array with all balances */
41     mapping (address => uint256) public balanceOf;
42     mapping (address => mapping (address => uint256)) public allowance;
43 
44     /* This generates a public event on the blockchain that will notify clients */
45     event Transfer(address indexed from, address indexed to, uint256 value);
46 
47     /* This notifies clients about the amount burnt */
48     event Burn(address indexed from, uint256 value);
49 	
50     /* Initializes contract with initial supply tokens to the creator of the contract */
51     constructor() public {
52         balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens
53     }
54 
55     /* Send coins */
56     function transfer(address _to, uint256 _value) public returns (bool success){
57         if (_to == 0x0000000000000000000000000000000000000000) revert();                                               // Prevent transfer to 0x0 address
58         if (_value <= 0) revert(); 
59         if (balanceOf[msg.sender] < _value) revert();                           // Check if the sender has enough
60         if (balanceOf[_to] + _value < balanceOf[_to]) revert();                 // Check for overflows
61         balanceOf[msg.sender] = SafeMath.sub(balanceOf[msg.sender], _value);    // Subtract from the sender
62         balanceOf[_to] = SafeMath.add(balanceOf[_to], _value);                  // Add the same to the recipient
63         emit Transfer(msg.sender, _to, _value);     // Notify anyone listening that this transfer took place
64         return true;
65     }
66 
67     /* Allow another contract to spend some tokens in your behalf */
68     function approve(address _spender, uint256 _value) public returns (bool success) {
69         if (_value <= 0) revert();
70         allowance[msg.sender][_spender] = _value;
71         return true;
72     }
73        
74 
75     /* A contract attempts to get the coins */
76     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
77         if (_to == 0x0000000000000000000000000000000000000000) revert();                                   // Prevent transfer to 0x0 address
78         if (_value <= 0) revert();
79         if (balanceOf[_from] < _value) revert();                    // Check if the sender has enough
80         if (balanceOf[_to] + _value < balanceOf[_to]) revert();     // Check for overflows
81         if (_value > allowance[_from][msg.sender]) revert();        // Check allowance
82         balanceOf[_from] = SafeMath.sub(balanceOf[_from], _value);  // Subtract from the sender
83         balanceOf[_to] = SafeMath.add(balanceOf[_to], _value);      // Add the same to the recipient
84         allowance[_from][msg.sender] = SafeMath.sub(allowance[_from][msg.sender], _value);
85         emit Transfer(_from, _to, _value);      // Notify anyone listening that this transfer took place
86         return true;
87     }
88 
89     function burn(uint256 _value) public returns (bool success) {
90         if (balanceOf[msg.sender] < _value) revert();            // Check if the sender has enough
91 		if (_value <= 0) revert(); 
92         balanceOf[msg.sender] = SafeMath.sub(balanceOf[msg.sender], _value);                      // Subtract from the sender
93         totalSupply = SafeMath.sub(totalSupply,_value);                                // Updates totalSupply
94         emit Burn(msg.sender, _value);
95         return true;
96     }
97 }