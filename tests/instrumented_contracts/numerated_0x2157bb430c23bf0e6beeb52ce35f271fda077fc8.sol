1 pragma solidity ^0.4.24;
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
30 }
31 contract AIOTC is SafeMath{
32     string public name;
33     string public symbol;
34     address public owner;
35     uint8 public decimals;
36     uint256 public totalSupply;
37     address public icoContractAddress;
38     uint256 public  tokensTotalSupply =  2000 * (10**6) * 10**18;
39     mapping (address => bool) restrictedAddresses;
40     uint256 constant initialSupply = 900 * (10**6) * 10**18;
41     string constant  tokenName = 'AIOTC';
42     uint8 constant decimalUnits = 18;
43     string constant tokenSymbol = 'AIOTC';
44 
45 
46     /* This creates an array with all balances */
47     mapping (address => uint256) public balanceOf;
48 	mapping (address => uint256) public freezeOf;
49     mapping (address => mapping (address => uint256)) public allowance;
50 
51     /* This generates a public event on the blockchain that will notify clients */
52     event Transfer(address indexed from, address indexed to, uint256 value);
53 
54     /* This notifies clients about the amount burnt */
55     event Burn(address indexed from, uint256 value);
56 
57 	/* This notifies clients about the amount frozen */
58     event Freeze(address indexed from, uint256 value);
59 
60 	/* This notifies clients about the amount unfrozen */
61     event Unfreeze(address indexed from, uint256 value);
62   //  Mint event
63     event Mint(address indexed _to, uint256 _value);
64 
65     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
66 
67     modifier onlyOwner {
68       assert(owner == msg.sender);
69       _;
70     }
71 
72     /* Initializes contract with initial supply tokens to the creator of the contract */
73     constructor(address _addr) public {
74         name = tokenName;                                   // Set the name for display purposes
75         symbol = tokenSymbol;                               // Set the symbol for display purposes
76         decimals = decimalUnits;                            // Amount of decimals for display purposes
77 	    owner = msg.sender;
78 	    balanceOf[_addr] = initialSupply;
79 	    totalSupply = initialSupply;
80     }
81 
82     /* Send coins */
83     function transfer(address _to, uint256 _value) public {
84 		require (_value > 0) ;
85         require (balanceOf[msg.sender] >= _value);           // Check if the sender has enough
86         require (balanceOf[_to] + _value >= balanceOf[_to]) ;     // Check for overflows
87         require (!restrictedAddresses[_to]);
88         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
89         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
90         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
91     }
92 
93     /* Allow another contract to spend some tokens in your behalf */
94     function approve(address _spender, uint256 _value) public
95         returns (bool success) {
96         allowance[msg.sender][_spender] = _value;          // Set allowance
97       	emit Approval(msg.sender, _spender, _value);     // Raise Approval event
98       	return true;
99     }
100 
101     function prodTokens(address _to, uint256 _amount) public onlyOwner {
102       require (_amount != 0 ) ;   // Check if values are not null;
103       require (balanceOf[_to] + _amount > balanceOf[_to]) ;     // Check for overflows
104       require (SafeMath.safeAdd(totalSupply, _amount) <=tokensTotalSupply);
105       //require (!restrictedAddresses[_to]);
106       totalSupply = SafeMath.safeAdd(totalSupply, _amount);                                      // Update total supply
107       balanceOf[_to]=SafeMath.safeAdd(balanceOf[_to], _amount);                    		    // Set minted coins to target
108       emit Mint(_to, _amount);                          		    // Create Mint event
109       emit Transfer(0x0, _to, _amount);                            // Create Transfer event from 0x
110     }
111 
112     /* A contract attempts to get the coins */
113     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
114         require (balanceOf[_from] >= _value);                 // Check if the sender has enough
115         require (balanceOf[_to] + _value >= balanceOf[_to]) ;  // Check for overflows
116         require (_value <= allowance[_from][msg.sender]) ;     // Check allowance
117         require (!restrictedAddresses[_to]);
118         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
119         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
120         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
121         emit Transfer(_from, _to, _value);
122         return true;
123     }
124 
125     function burn(uint256 _value) public returns (bool success) {
126         require (balanceOf[msg.sender] >= _value) ;            // Check if the sender has enough
127 		    require (_value <= 0) ;
128         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
129         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
130         emit Burn(msg.sender, _value);
131         return true;
132     }
133 
134 	function freeze(uint256 _value) public returns (bool success) {
135         require (balanceOf[msg.sender] >= _value) ;            // Check if the sender has enough
136 		    require (_value > 0) ;
137         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
138         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
139         emit Freeze(msg.sender, _value);
140         return true;
141     }
142 
143 	function unfreeze(uint256 _value) public returns (bool success) {
144         require (balanceOf[msg.sender] >= _value) ;            // Check if the sender has enough
145         require (_value > 0) ;
146         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
147 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
148         emit Unfreeze(msg.sender, _value);
149         return true;
150     }
151 
152 
153   function totalSupply() public constant returns (uint256 Supply) {
154 		return totalSupply;
155 	}
156 
157 	/* Get balance of specific address */
158 	function balanceOf(address _owner) public constant returns (uint256 balance) {
159 		return balanceOf[_owner];
160 	}
161 
162 
163 	function() public payable {
164         revert();
165     }
166     
167     function ChangOwner(address _owner) public onlyOwner {
168           owner = _owner;
169     }
170 
171     /* Owner can add new restricted address or removes one */
172 	function editRestrictedAddress(address _newRestrictedAddress) public onlyOwner {
173 		restrictedAddresses[_newRestrictedAddress] = !restrictedAddresses[_newRestrictedAddress];
174 	}
175 
176 	function isRestrictedAddress(address _querryAddress) public constant returns (bool answer){
177 		return restrictedAddresses[_querryAddress];
178 	}
179 }