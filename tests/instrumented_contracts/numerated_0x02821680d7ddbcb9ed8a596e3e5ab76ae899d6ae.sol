1 pragma solidity ^ 0.4 .9;
2 library SafeMath {
3     function mul(uint256 a, uint256 b) internal constant returns(uint256) {
4         uint256 c = a * b;
5         assert(a == 0 || c / a == b);
6         return c;
7     }
8 
9     function div(uint256 a, uint256 b) internal constant returns(uint256) {
10         uint256 c = a / b;
11         return c;
12     }
13 
14     function sub(uint256 a, uint256 b) internal constant returns(uint256) {
15         assert(b <= a);
16         return a - b;
17     }
18 
19     function add(uint256 a, uint256 b) internal constant returns(uint256) {
20         uint256 c = a + b;
21         assert(c >= a);
22         return c;
23     }
24 }
25    
26 
27 
28 contract TokenSilver {
29     /* Public variables of the token */
30     string public standard = 'Token 0.1';
31     string public name;
32     string public symbol;
33     uint8 public decimals;
34     uint256 public initialSupply;
35     uint256 public totalSupply;
36 
37     /* This creates an array with all balances */
38     mapping (address => uint256) public balanceOf;
39     mapping (address => mapping (address => uint256)) public allowance;
40 
41   
42     /* Initializes contract with initial supply tokens to the creator of the contract */
43     function TokenSilver() {
44 
45          initialSupply = 750000000;
46          name ="tokensilver";
47         decimals = 18;
48          symbol = "ethes";
49         
50         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
51         totalSupply = initialSupply;                        // Update total supply
52                                    
53     }
54 
55     /* Send coins */
56     function transfer(address _to, uint256 _value) {
57         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
58         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
59         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
60         balanceOf[_to] += _value;                            // Add the same to the recipient
61       
62     }
63 
64    
65 
66     
67 
68    
69 
70     /* This unnamed function is called whenever someone tries to send ether to it */
71     function () {
72         throw;     // Prevents accidental sending of ether
73     }
74 }