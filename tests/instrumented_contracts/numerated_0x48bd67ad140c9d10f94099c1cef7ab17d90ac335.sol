1 pragma solidity ^0.4.16;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
8         uint256 c = a * b;
9         assert(a == 0 || c / a == b);
10         return c;
11     }
12 
13     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
14         assert(b > 0);
15         uint256 c = a / b;
16         assert(a == b * c + a % b);
17         return c;
18     }
19 
20     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c>=a && c>=b);
28         return c;
29     }
30 }
31 
32 contract LBN is SafeMath {
33     string public constant name = "Leber Network";
34     string public constant symbol = "LBN";
35     uint8 public constant decimals = 18;
36 
37     uint256 public totalSupply = 100000000 * (10 ** uint256(decimals));
38     uint256 public airdropSupply = 9000000 * (10 ** uint256(decimals));
39 
40     uint256 public airdropCount;
41     mapping(address => bool) airdropTouched;
42 
43     uint256 public constant airdropCountLimit1 = 20000;
44     uint256 public constant airdropCountLimit2 = 20000;
45 
46     uint256 public constant airdropNum1 = 300 * (10 ** uint256(decimals));
47     uint256 public constant airdropNum2 = 150 * (10 ** uint256(decimals));
48 
49     address public owner;
50 
51     /* This creates an array with all balances */
52     mapping (address => uint256) public balanceOf;
53     mapping (address => uint256) public freezeOf;
54     mapping (address => mapping (address => uint256)) public allowance;
55 
56     /* This generates a public event on the blockchain that will notify clients */
57     event Transfer(address indexed from, address indexed to, uint256 value);
58 
59     /* This notifies clients about the amount burnt */
60     event Burn(address indexed from, uint256 value);
61 
62     /* This notifies clients about the amount frozen */
63     event Freeze(address indexed from, uint256 value);
64 
65     /* This notifies clients about the amount unfrozen */
66     event Unfreeze(address indexed from, uint256 value);
67 
68     /* Initializes contract with initial supply tokens to the creator of the contract */
69     function LBN() public {
70         owner = msg.sender;
71 
72         airdropCount = 0;
73         balanceOf[address(this)] = airdropSupply;
74         balanceOf[msg.sender] = totalSupply - airdropSupply;
75     }
76 
77     /* Send coins */
78     function transfer(address _to, uint256 _value) public {
79         require(_to != 0x0);
80         require(_value > 0);
81         require(balanceOf[msg.sender] >= _value);
82         require(balanceOf[_to] + _value > balanceOf[_to]);
83         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
84         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
85         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
86     }
87 
88     /* Allow another contract to spend some tokens in your behalf */
89     function approve(address _spender, uint256 _value) public
90     returns (bool success) {
91         require(_value > 0);
92         allowance[msg.sender][_spender] = _value;
93         return true;
94     }
95 
96 
97     /* A contract attempts to get the coins */
98     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
99         require(_to != 0x0);
100         require(_value > 0);
101         require(balanceOf[_from] >= _value);
102         require(balanceOf[_to] + _value > balanceOf[_to]);
103         require(_value <= allowance[_from][msg.sender]);
104         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
105         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
106         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
107         Transfer(_from, _to, _value);
108         return true;
109     }
110 
111     function burn(uint256 _value) public returns (bool success) {
112         require(balanceOf[msg.sender] >= _value);
113         require(_value > 0);
114         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
115         totalSupply = SafeMath.safeSub(totalSupply, _value);                                // Updates totalSupply
116         Burn(msg.sender, _value);
117         return true;
118     }
119 
120     function freeze(uint256 _value) public returns (bool success) {
121         require(balanceOf[msg.sender] >= _value);
122         require(_value > 0);
123         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
124         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
125         Freeze(msg.sender, _value);
126         return true;
127     }
128 
129     function unfreeze(uint256 _value) public returns (bool success) {
130         require(freezeOf[msg.sender] >= _value);
131         require(_value > 0);
132         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
133         balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
134         Unfreeze(msg.sender, _value);
135         return true;
136     }
137 
138     // transfer balance to owner
139     function withdrawEther(uint256 amount) public {
140         require(msg.sender == owner);
141         owner.transfer(amount);
142     }
143 
144     function () external payable {
145         require(balanceOf[address(this)] > 0);
146         require(!airdropTouched[msg.sender]);
147         require(airdropCount < airdropCountLimit1 + airdropCountLimit2);
148 
149         airdropTouched[msg.sender] = true;
150         airdropCount = SafeMath.safeAdd(airdropCount, 1);
151 
152         if (airdropCount <= airdropCountLimit1) {
153             _transfer(address(this), msg.sender, airdropNum1);
154         } else if (airdropCount <= airdropCountLimit1 + airdropCountLimit2) {
155             _transfer(address(this), msg.sender, airdropNum2); 
156         }
157     }
158 
159     function _transfer(address _from, address _to, uint _value) internal {     
160         require(balanceOf[_from] >= _value);               // Check if the sender has enough
161         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
162    
163         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                         // Subtract from the sender
164         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
165          
166         Transfer(_from, _to, _value);
167     }
168 }