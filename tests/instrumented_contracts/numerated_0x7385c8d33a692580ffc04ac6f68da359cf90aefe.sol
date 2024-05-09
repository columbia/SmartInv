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
37 contract CakeToken is SafeMath{
38     string public name;
39     string public symbol;
40     uint8 public decimals;
41     uint256 public totalSupply;
42 
43     /* This creates an array with all balances */
44     mapping (address => uint256) public balanceOf;
45     mapping (address => mapping (address => uint256)) public allowance;
46 
47     /* This generates a public event on the blockchain that will notify clients */
48     event Transfer(address indexed from, address indexed to, uint256 value);
49 
50     /* Initializes contract with initial supply tokens to the creator of the contract */
51     function CakeToken() public {
52         balanceOf[msg.sender] = 100000000e18;              // Give the creator all initial tokens
53         totalSupply = 100000000e18;                        // Update total supply
54         name = "CakeToken";                                   // Set the name for display purposes
55         symbol = "CakeT";                               // Set the symbol for display purposes
56         decimals = 18;                            // Amount of decimals for display purposes
57     }
58 
59     /* Send coins */
60     function transfer(address _to, uint256 _value) {
61         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
62 		    if (_value <= 0) throw;
63         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
64         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
65         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
66         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
67         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
68     }
69 }