1 pragma solidity ^0.4.16;
2 
3 /**
4  * Math operations with safety checks
5  */
6 
7 contract owned {
8     address public owner;
9 
10     constructor() public {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     function transferOwnership(address newOwner) onlyOwner public {
20         owner = newOwner;
21     }
22 }
23 
24 contract SafeMath {
25     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a * b;
27         require(a == 0 || c / a == b);
28         return c;
29     }
30 
31     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
32         require(b > 0);
33         uint256 c = a / b;
34         require(a == b * c + a % b);
35         return c;
36     }
37 
38     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
39         require(b <= a);
40         return a - b;
41     }
42 
43     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         require(c>=a && c>=b);
46         return c;
47     }
48 }
49 
50 contract CollectionToken is owned, SafeMath {
51     string public name;
52     string public symbol;
53     uint8 public decimals;
54     uint256 public totalSupply;
55 
56     /* This creates an array with all balances */
57     mapping (address => uint256) public balanceOf;
58     mapping (address => mapping (address => uint256)) public allowance;
59 
60 
61     /* This generates a public event on the blockchain that will notify clients */
62     event Transfer(address indexed from, address indexed to, uint256 value);
63 
64     /* This notifies clients about the amount burnt */
65     event Burn(address indexed from, uint256 value);
66 
67     /* Initializes contract with initial supply tokens to the creator of the contract */
68     constructor() public {
69         totalSupply = 0; // Update total supply
70         
71         balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens
72         name = "中国阿曼建交封";                                   // Set the name for display purposes
73         symbol = "F-WJ131";                               // Set the symbol for display purposes
74         decimals = 18;                            // Amount of decimals for display purposes
75     }
76 
77 
78         /**
79          * Internal transfer, only can be called by this contract
80          */
81     function _transfer(address _from, address _to, uint _value) internal {
82         // Prevent transfer to 0x0 address. Use burn() instead
83         require(_to != 0x0);
84         // Check if the sender has enough
85         require(balanceOf[_from] >= _value);
86         // Check for overflows
87         require(balanceOf[_to] + _value > balanceOf[_to]);
88         // Save this for an assertion in the future
89         uint previousBalances = balanceOf[_from] + balanceOf[_to];
90         // Subtract from the sender
91         balanceOf[_from] -= _value;
92         // Add the same to the recipient
93         balanceOf[_to] += _value;
94         // Asserts are used to use static analysis to find bugs in your code. They should never fail
95         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
96     }
97 
98 
99         /* Send coins */
100     function transfer(address _to, uint256 _value) public {
101         _transfer(msg.sender,_to,_value);
102         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
103     }
104 
105     /* Allow another contract to spend some tokens in your behalf */
106     function approve(address _spender, uint256 _value) public returns (bool success) {
107         require(_value==0 || allowance[msg.sender][_spender]==0);
108         allowance[msg.sender][_spender] = _value;
109         return true;
110     }
111 
112     /* A contract attempts to get the coins */
113     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
114         require(_value <= allowance[_from][msg.sender]);  // Check allowance
115         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
116         _transfer(_from, _to, _value);
117         emit Transfer(_from, _to, _value);
118         return true;
119     }
120 
121     function burn(uint256 _value) public onlyOwner returns (bool success) {
122         require(balanceOf[msg.sender] >= _value);
123         require(_value > 0);
124         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);            // Subtract from the sender
125         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
126         emit Burn(msg.sender, _value);
127         return true;
128     }
129             
130     function mintToken(address _target, uint256 _mintedAmount) public onlyOwner returns (bool success) {
131         require(_mintedAmount > 0);
132         balanceOf[_target] = SafeMath.safeAdd(balanceOf[_target], _mintedAmount);
133         totalSupply = SafeMath.safeAdd(totalSupply, _mintedAmount);
134         emit Transfer(0, this, _mintedAmount);
135         emit Transfer(this, _target, _mintedAmount);
136         return true;
137     }
138 
139 }