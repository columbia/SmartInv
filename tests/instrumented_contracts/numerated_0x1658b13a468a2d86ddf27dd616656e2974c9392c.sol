1 pragma solidity ^0.4.24;
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
30 
31  
32 }
33 
34 contract QUC is SafeMath{
35     string  public constant name = "QUCash";
36     string  public constant symbol = "QUC";
37     uint8   public constant decimals = 18;
38 
39     uint256 public totalSupply = 10000000000 * (10 ** uint256(decimals));
40 	address public owner;
41 
42     uint256 public buyPrice = 100000;
43     bool public crowdsaleClosed;
44 
45     /* This creates an array with all balances */
46     mapping (address => uint256) public balanceOf;
47 	mapping (address => uint256) public freezeOf;
48     mapping (address => mapping (address => uint256)) public allowance;
49 
50     /* This generates a public event on the blockchain that will notify clients */
51     event Transfer(address indexed from, address indexed to, uint256 value);
52 
53     /* This notifies clients about the amount burnt */
54     event Burn(address indexed from, uint256 value);
55 	
56 	/* This notifies clients about the amount frozen */
57     event Freeze(address indexed from, uint256 value);
58 	
59 	/* This notifies clients about the amount unfrozen */
60     event Unfreeze(address indexed from, uint256 value);
61 
62     /* Initializes contract with initial supply tokens to the creator of the contract */
63     constructor() public {        
64         balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens
65 		owner = msg.sender;
66         emit Transfer(0x0, msg.sender, totalSupply);
67     }
68 
69     /* Send coins */
70     function transfer(address _to, uint256 _value) public returns (bool) {
71         if (_to == 0x0)  revert();                               // Prevent transfer to 0x0 address. Use burn() instead
72 		if (_value <= 0)  revert(); 
73         if (balanceOf[msg.sender] < _value)  revert();           // Check if the sender has enough
74         if (balanceOf[_to] + _value < balanceOf[_to])  revert(); // Check for overflows
75         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
76         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
77         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
78         return true;
79     }
80 
81     /* Allow another contract to spend some tokens in your behalf */
82     function approve(address _spender, uint256 _value) public returns (bool success) {
83 		if (_value <= 0)  revert(); 
84         allowance[msg.sender][_spender] = _value;
85         return true;
86     }
87        
88 
89     /* A contract attempts to get the coins */
90     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
91         if (_to == 0x0)  revert();                                // Prevent transfer to 0x0 address. Use burn() instead
92 		if (_value <= 0)  revert(); 
93         if (balanceOf[_from] < _value)  revert();                 // Check if the sender has enough
94         if (balanceOf[_to] + _value < balanceOf[_to])  revert();  // Check for overflows
95         if (_value > allowance[_from][msg.sender])  revert();     // Check allowance
96         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
97         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
98         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
99         emit Transfer(_from, _to, _value);
100         return true;
101     }
102 
103     function burn(uint256 _value) public returns (bool success) {
104         if (balanceOf[msg.sender] < _value)  revert();            // Check if the sender has enough
105 		if (_value <= 0)  revert(); 
106         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
107         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
108         emit Burn(msg.sender, _value);
109         return true;
110     }
111 	
112 	function freeze(uint256 _value) public returns (bool success) {
113         if (balanceOf[msg.sender] < _value)  revert();            // Check if the sender has enough
114 		if (_value <= 0)  revert(); 
115         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
116         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
117         emit Freeze(msg.sender, _value);
118         return true;
119     }
120 	
121 	function unfreeze(uint256 _value) public returns (bool success) {
122         if (freezeOf[msg.sender] < _value)  revert();            // Check if the sender has enough
123 		if (_value <= 0)  revert(); 
124         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
125 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
126         emit Unfreeze(msg.sender, _value);
127         return true;
128     }
129 
130     	// transfer balance to owner
131 	function withdrawEther(uint256 amount) public  {
132 		if(msg.sender != owner) revert();
133 		owner.transfer(amount);
134 	}
135 	
136     function setPrices(bool closebuy, uint256 newBuyPrice)  public {
137         if(msg.sender != owner) revert();
138         crowdsaleClosed = closebuy;
139         buyPrice = newBuyPrice;
140     }
141 
142     function () external payable {
143         require(!crowdsaleClosed);
144         uint amount = msg.value ;               // calculates the amount
145  
146         _transfer(owner, msg.sender,  SafeMath.safeMul( amount, buyPrice));
147         owner.transfer(amount);
148     }
149 
150     function _transfer(address _from, address _to, uint _value) internal {     
151         require (balanceOf[_from] >= _value);               // Check if the sender has enough
152         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
153    
154         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
155         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);    
156          
157         emit Transfer(_from, _to, _value);
158     }   
159 }