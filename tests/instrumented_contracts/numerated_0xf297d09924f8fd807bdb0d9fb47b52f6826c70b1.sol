1 pragma solidity ^0.5.7;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7   function safeMul(uint256 a, uint256 b)pure internal returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function safeDiv(uint256 a, uint256 b)pure internal returns (uint256) {
14     assert(b > 0);
15     uint256 c = a / b;
16     assert(a == b * c + a % b);
17     return c;
18   }
19 
20   function safeSub(uint256 a, uint256 b)pure internal returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function safeAdd(uint256 a, uint256 b)pure internal returns (uint256) {
26     uint256 c = a + b;
27     assert(c>=a && c>=b);
28     return c;
29   }
30 
31 }
32 contract PAPP is SafeMath{
33     string  public  constant name = "PolyAlpha";
34     string  public  constant symbol = "PAPP";
35     uint8   public  constant decimals = 18;
36     uint256 public totalSupply = 10**9;
37     uint256 public unsetCoin;
38 	address public owner = 0xcb194c3127A9728907EeF53c7078A7052f6F23CA;
39     
40     /* This creates an array with all balances */
41     mapping (address => uint256) public balanceOf;
42 	mapping (address => uint256) public freezeOf;
43     mapping (address => mapping (address => uint256)) public allowance;
44 
45     /* This generates a public event on the blockchain that will notify clients */
46     event Transfer(address indexed from, address indexed to, uint256 value);
47 
48     /* This notifies clients about the amount burnt */
49     event Burn(address indexed from, uint256 value);
50 	
51 	/* This notifies clients about the amount frozen */
52     event Freeze(address indexed from, uint256 value);
53 	
54 	/* This notifies clients about the amount unfrozen */
55     event Unfreeze(address indexed from, uint256 value);
56 
57     modifier onlyOwner() {
58         require(msg.sender == owner);
59         _;
60     }
61     event FounderUnlock(address _sender, uint256 _amount);
62     struct founderLock {
63         uint256 amount;
64         uint256 startTime;
65         uint remainRound;
66         uint totalRound;
67         uint256 period;
68     }
69     mapping (address => founderLock) public founderLockance;
70     address address1 = 0xDD35f75513E6265b57EcE5CC587A09768969525d;
71     address address2 = 0x51909b2623d90fF2B04aC503F40C51F12Fc7aB49;
72     address address3 = 0x1893A8f045e2eC40498f254D6978A349c53dF2D3;
73     address address4 = 0x7BEE83C5103B1734e315Cc0C247E7D98492c193f;
74     address address5 = 0xEB759Dd32Fc9454BF5d0C3AFD9C739840987A84f;
75     
76     /* Initializes contract with initial supply tokens to the creator of the contract */
77     constructor(
78         ) public {
79         setFounderLock(address1, totalSupply/10, 4, 180 days);
80         setFounderLock(address2, totalSupply/10, 4, 180 days);
81         setFounderLock(address3, totalSupply/20, 4, 180 days);
82         setFounderLock(address4, totalSupply/20, 4, 180 days);
83         balanceOf[address5] = totalSupply*6/10;
84         unsetCoin = totalSupply/10;
85     }
86 
87     /* Send coins */
88     function transfer(address _to, uint256 _value) public{
89         if (_to == address(0x0)) revert();                               // Prevent transfer to 0x0 address. Use burn() instead
90 		if (_value <= 0) revert(); 
91         if (balanceOf[msg.sender] < _value) revert();           // Check if the sender has enough
92         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows
93         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
94         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
95         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
96     }
97 
98     /* Allow another contract to spend some tokens in your behalf */
99     function approve(address _spender, uint256 _value) public
100         returns (bool success) {
101 		if (_value <= 0) revert(); 
102         allowance[msg.sender][_spender] = _value;
103         return true;
104     }
105        
106 
107     /* A contract attempts to get the coins */
108     function transferFrom(address _from, address _to, uint256 _value)public returns (bool success) {
109         if (_to == address(0x0)) revert();                                // Prevent transfer to 0x0 address. Use burn() instead
110 		if (_value <= 0) revert(); 
111         if (balanceOf[_from] < _value) revert();                 // Check if the sender has enough
112         if (balanceOf[_to] + _value < balanceOf[_to]) revert();  // Check for overflows
113         if (_value > allowance[_from][msg.sender]) revert();     // Check allowance
114         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
115         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
116         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
117         emit Transfer(_from, _to, _value);
118         return true;
119     }
120 
121     function burn(uint256 _value)public returns (bool success) {
122         if (balanceOf[msg.sender] < _value) revert();            // Check if the sender has enough
123 		if (_value <= 0) revert(); 
124         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
125         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
126         emit Burn(msg.sender, _value);
127         return true;
128     }
129 	
130 	function freeze(uint256 _value)public returns (bool success) {
131         if (balanceOf[msg.sender] < _value) revert();            // Check if the sender has enough
132 		if (_value <= 0) revert(); 
133         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
134         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
135         emit Freeze(msg.sender, _value);
136         return true;
137     }
138 	
139 	function unfreeze(uint256 _value)public returns (bool success) {
140         if (freezeOf[msg.sender] < _value) revert();            // Check if the sender has enough
141 		if (_value <= 0) revert(); 
142         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
143 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
144         emit Unfreeze(msg.sender, _value);
145         return true;
146     }
147 	
148 	function setFounderLock(address _address, uint256 _value, uint _round, uint256 _period)  internal{
149         founderLockance[_address].amount = _value;
150         founderLockance[_address].startTime = now;
151         founderLockance[_address].remainRound = _round;
152         founderLockance[_address].totalRound = _round;
153         founderLockance[_address].period = _period;
154     }
155     function ownerSetFounderLock(address _address, uint256 _value, uint _round, uint256 _period) public onlyOwner{
156         require(_value <= unsetCoin);
157         setFounderLock( _address,  _value,  _round,  _period);
158         unsetCoin = SafeMath.safeSub(unsetCoin, _value);
159     }
160     function unlockFounder () public{
161         require(now >= founderLockance[msg.sender].startTime + (founderLockance[msg.sender].totalRound - founderLockance[msg.sender].remainRound + 1) * founderLockance[msg.sender].period);
162         require(founderLockance[msg.sender].remainRound > 0);
163         uint256 changeAmount = SafeMath.safeDiv(founderLockance[msg.sender].amount,founderLockance[msg.sender].remainRound);
164         balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender],changeAmount);
165         founderLockance[msg.sender].amount = SafeMath.safeSub(founderLockance[msg.sender].amount,changeAmount);
166         founderLockance[msg.sender].remainRound --;
167         emit FounderUnlock(msg.sender, changeAmount);
168     }
169 }