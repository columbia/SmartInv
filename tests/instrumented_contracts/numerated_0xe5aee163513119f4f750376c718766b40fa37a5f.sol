1 pragma solidity ^0.4.25;
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
32 contract Fzcoin is SafeMath {
33     string public name;
34     string public symbol;
35     uint8 public decimals = 18;
36 
37     uint256 public totalSupply = 77777777 * (10 ** uint256(decimals));
38     uint256 public airdropSupply = 7777777 * (10 ** uint256(decimals));
39 
40     uint256 public airdropCount;
41     mapping(address => bool) airdropTouched;
42 
43     uint256 public constant airdropCountLimit1 = 20000;
44     uint256 public constant airdropCountLimit2 = 20000;
45 
46     uint256 public constant airdropNum1 = 30 * (10 ** uint256(decimals));
47     uint256 public constant airdropNum2 = 15 * (10 ** uint256(decimals));
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
69     function Fzcoin(
70         uint256 initialSupply,
71         string tokenName,
72         string tokenSymbol
73     ) public {
74         airdropCount = 0;
75         balanceOf[address(this)] = airdropSupply;
76         balanceOf[msg.sender] = totalSupply - airdropSupply;
77         name = tokenName;                                   // Set the name for display purposes
78         symbol = tokenSymbol;                               // Set the symbol for display purposes
79     }
80 
81     /* Send coins */
82     function transfer(address _to, uint256 _value) public {
83         require(_to != 0x0);
84         require(_value > 0);
85         require(balanceOf[msg.sender] >= _value);
86         require(balanceOf[_to] + _value > balanceOf[_to]);
87         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
88         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
89         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
90     }
91 
92     /* Allow another contract to spend some tokens in your behalf */
93     function approve(address _spender, uint256 _value) public
94     returns (bool success) {
95         require(_value > 0);
96         allowance[msg.sender][_spender] = _value;
97         return true;
98     }
99 
100 
101     /* A contract attempts to get the coins */
102     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
103         require(_to != 0x0);
104         require(_value > 0);
105         require(balanceOf[_from] >= _value);
106         require(balanceOf[_to] + _value > balanceOf[_to]);
107         require(_value <= allowance[_from][msg.sender]);
108         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
109         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
110         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
111         Transfer(_from, _to, _value);
112         return true;
113     }
114 
115     function burn(uint256 _value) public returns (bool success) {
116         require(balanceOf[msg.sender] >= _value);
117         require(_value > 0);
118         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
119         totalSupply = SafeMath.safeSub(totalSupply, _value);                                // Updates totalSupply
120         Burn(msg.sender, _value);
121         return true;
122     }
123 
124     function freeze(uint256 _value) public returns (bool success) {
125         require(balanceOf[msg.sender] >= _value);
126         require(_value > 0);
127         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
128         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
129         Freeze(msg.sender, _value);
130         return true;
131     }
132 
133     function unfreeze(uint256 _value) public returns (bool success) {
134         require(freezeOf[msg.sender] >= _value);
135         require(_value > 0);
136         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
137         balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
138         Unfreeze(msg.sender, _value);
139         return true;
140     }
141 
142     // transfer balance to owner
143     function withdrawEther(uint256 amount) public {
144         require(msg.sender == owner);
145         owner.transfer(amount);
146     }
147 
148     function () external payable {
149         require(balanceOf[address(this)] > 0);
150         require(!airdropTouched[msg.sender]);
151         require(airdropCount < airdropCountLimit1 + airdropCountLimit2);
152 
153         airdropTouched[msg.sender] = true;
154         airdropCount = SafeMath.safeAdd(airdropCount, 1);
155 
156         if (airdropCount <= airdropCountLimit1) {
157             _transfer(address(this), msg.sender, airdropNum1);
158         } else if (airdropCount <= airdropCountLimit1 + airdropCountLimit2) {
159             _transfer(address(this), msg.sender, airdropNum2); 
160         }
161     }
162 
163     function _transfer(address _from, address _to, uint _value) internal {     
164         require(balanceOf[_from] >= _value);               // Check if the sender has enough
165         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
166    
167         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                         // Subtract from the sender
168         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
169          
170         Transfer(_from, _to, _value);
171     }
172 }