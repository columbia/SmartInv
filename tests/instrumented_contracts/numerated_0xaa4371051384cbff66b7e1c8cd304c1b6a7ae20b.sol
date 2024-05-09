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
34 
35 contract LEASToken is SafeMath{
36     string public name = "Linked Ecological Available System";
37     string public symbol = "LEAS";
38     uint8 public decimals = 18;
39     uint256 public totalSupply = 200 * 10 ** 8 * 10 ** uint256(decimals);
40 
41     /* This creates an array with all balances */
42     mapping (address => uint256) public balanceOf;
43     mapping (address => mapping (address => uint256)) public allowance;
44 
45     /* This generates a public event on the blockchain that will notify clients */
46     event Transfer(address indexed from, address indexed to, uint256 value);
47 
48     constructor() public{
49         balanceOf[msg.sender] = totalSupply;    // Give the creator all initial tokens
50     }
51 
52     /* Send coins */
53     function transfer(address _to, uint256 _value) public returns (bool success){
54         if (_to == 0x0000000000000000000000000000000000000000) revert();                                               // Prevent transfer to 0x0 address
55         if (_value <= 0) revert(); 
56         if (balanceOf[msg.sender] < _value) revert();                           // Check if the sender has enough
57         if (balanceOf[_to] + _value < balanceOf[_to]) revert();                 // Check for overflows
58         balanceOf[msg.sender] = SafeMath.sub(balanceOf[msg.sender], _value);    // Subtract from the sender
59         balanceOf[_to] = SafeMath.add(balanceOf[_to], _value);                  // Add the same to the recipient
60         emit Transfer(msg.sender, _to, _value);     // Notify anyone listening that this transfer took place
61         return true;
62     }
63 
64     /* Allow another contract to spend some tokens in your behalf */
65     function approve(address _spender, uint256 _value) public returns (bool success) {
66         if (_value <= 0) revert();
67         allowance[msg.sender][_spender] = _value;
68         return true;
69     }
70        
71     /* A contract attempts to get the coins */
72     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
73         if (_to == 0x0000000000000000000000000000000000000000) revert();                                   // Prevent transfer to 0x0 address
74         if (_value <= 0) revert();
75         if (balanceOf[_from] < _value) revert();                    // Check if the sender has enough
76         if (balanceOf[_to] + _value < balanceOf[_to]) revert();     // Check for overflows
77         if (_value > allowance[_from][msg.sender]) revert();        // Check allowance
78         balanceOf[_from] = SafeMath.sub(balanceOf[_from], _value);  // Subtract from the sender
79         balanceOf[_to] = SafeMath.add(balanceOf[_to], _value);      // Add the same to the recipient
80         allowance[_from][msg.sender] = SafeMath.sub(allowance[_from][msg.sender], _value);
81         emit Transfer(_from, _to, _value);      // Notify anyone listening that this transfer took place
82         return true;
83     }
84 }