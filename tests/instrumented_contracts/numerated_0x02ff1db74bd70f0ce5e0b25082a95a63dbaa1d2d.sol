1 /**
2  *Submitted for verification at Etherscan.io on 2020-05-20
3 */
4 
5 pragma solidity ^0.4.26;
6 
7 /**
8  * Math operations with safety checks
9  */
10 contract SafeMath {
11   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
12     uint256 c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b > 0);
19     uint256 c = a / b;
20     assert(a == b * c + a % b);
21     return c;
22   }
23 
24   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c>=a && c>=b);
32     return c;
33   }
34 
35 }
36 contract KB is SafeMath{
37     string public name;
38     string public symbol;
39     uint8 public decimals;
40     uint256 public totalSupply;
41     address public owner;
42 
43     /* This creates an array with all balances */
44     mapping (address => uint256) public balanceOf;
45     mapping (address => uint256) public freezeOf;
46     mapping (address => mapping (address => uint256)) public allowance;
47 
48     /* This generates a public event on the blockchain that will notify clients */
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 
51     /* This notifies clients about the amount burnt */
52     event Burn(address indexed from, uint256 value);
53 
54 	/* This notifies clients about the amount frozen */
55     event Freeze(address indexed from, uint256 value);
56 
57 	/* This notifies clients about the amount unfrozen */
58     event Unfreeze(address indexed from, uint256 value);
59 
60 
61     /* Initializes contract with initial supply tokens to the creator of the contract */
62     constructor(
63         uint256 initialSupply,
64         string tokenName,
65         uint8 decimalUnits,
66         string tokenSymbol
67         ) public{
68         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
69         totalSupply = initialSupply;                        // Update total supply
70         name = tokenName;                                   // Set the name for display purposes
71         symbol = tokenSymbol;                               // Set the symbol for display purposes
72         decimals = decimalUnits;                            // Amount of decimals for display purposes
73 	      owner = msg.sender;
74     }
75 
76     /* Send coins */
77     function transfer(address _to, uint256 _value) public returns (bool success) {
78         require(_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
79         require(_value > 0);
80         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
81         require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
82         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
83         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
84         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
85         return true;
86     }
87 
88     /* Allow another contract to spend some tokens in your behalf */
89     function approve(address _spender, uint256 _value) public returns (bool success){
90 		    require(_value > 0);
91         allowance[msg.sender][_spender] = _value;
92         return true;
93     }
94 
95 
96     /* A contract attempts to get the coins */
97     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
98         require(_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
99         require(_value > 0);
100         require(balanceOf[_from] >= _value);                // Check if the sender has enough
101         require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
102         require(_value <= allowance[_from][msg.sender]);    // Check allowance
103         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
104         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
105         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
106         emit Transfer(_from, _to, _value);
107         return true;
108     }
109 
110     function burn(uint256 _value) public returns (bool success) {
111         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
112         require(_value > 0);
113         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
114         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
115         emit Burn(msg.sender, _value);
116         return true;
117     }
118 
119     function burnFrom(address _from, uint256 _value) public returns (bool success) {
120         require(balanceOf[_from] >= _value);                // Check if the sender has enough
121         require(_value > 0);
122         require(_value <= allowance[_from][msg.sender]);    // Check allowance
123         balanceOf[_from] -= _value;                         // Subtract from the sender
124         totalSupply -= _value;                              // Updates totalSupply
125         emit Burn(_from, _value);
126         return true;
127     }
128 
129     function freeze(uint256 _value) public returns (bool success) {
130         require(balanceOf[msg.sender] >= _value);            // Check if the sender has enough
131         require(_value > 0);
132         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
133         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
134         emit Freeze(msg.sender, _value);
135         return true;
136     }
137 
138     function unfreeze(uint256 _value) public returns (bool success) {
139         require(freezeOf[msg.sender] >= _value);            // Check if the sender has enough
140         require(_value > 0);
141         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
142         balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
143         emit Unfreeze(msg.sender, _value);
144         return true;
145     }
146 
147     function withdrawEther(uint256 amount) public {
148       require(msg.sender == owner);
149       owner.transfer(amount);
150     }
151 
152     function transferOwnership(address newOwner) public returns (bool success) {
153       require(msg.sender == owner );
154       owner = newOwner;
155       return true;
156     }
157 
158     function () public payable {
159       revert();
160     }
161 }