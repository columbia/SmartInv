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
31 contract Dcoin is SafeMath{
32     string public name;
33     string public symbol;
34     address public owner;
35     uint8 public decimals;
36     uint256 public totalSupply;
37     address public icoContractAddress;
38     uint256 public  tokensTotalSupply =  2000 * (10**6) * 10**18;
39     mapping (address => bool) restrictedAddresses;
40     uint256 constant initialSupply = 2000 * (10**6) * 10**18;
41     string constant  tokenName = 'Dcoin';
42     uint8 constant decimalUnits = 18;
43     string constant tokenSymbol = 'DGAS';
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
73     constructor() public {
74         name = tokenName;                                   // Set the name for display purposes
75         symbol = tokenSymbol;                               // Set the symbol for display purposes
76         decimals = decimalUnits;                            // Amount of decimals for display purposes
77 	    owner = msg.sender;
78     }
79 
80     /* Send coins */
81     function transfer(address _to, uint256 _value) public {
82 		require (_value > 0) ;
83         require (balanceOf[msg.sender] >= _value);           // Check if the sender has enough
84         require (balanceOf[_to] + _value >= balanceOf[_to]) ;     // Check for overflows
85         require (!restrictedAddresses[_to]);
86         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
87         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
88         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
89     }
90 
91     /* Allow another contract to spend some tokens in your behalf */
92     function approve(address _spender, uint256 _value) public
93         returns (bool success) {
94         allowance[msg.sender][_spender] = _value;          // Set allowance
95       	emit Approval(msg.sender, _spender, _value);     // Raise Approval event
96       	return true;
97     }
98 
99     function prodTokens(address _to, uint256 _amount) public onlyOwner {
100       require (_amount != 0 ) ;   // Check if values are not null;
101       require (balanceOf[_to] + _amount > balanceOf[_to]) ;     // Check for overflows
102       require (totalSupply <=tokensTotalSupply);
103       //require (!restrictedAddresses[_to]);
104       totalSupply += _amount;                                      // Update total supply
105       balanceOf[_to] += _amount;                    		    // Set minted coins to target
106       emit Mint(_to, _amount);                          		    // Create Mint event
107       emit Transfer(0x0, _to, _amount);                            // Create Transfer event from 0x
108     }
109 
110     /* A contract attempts to get the coins */
111     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
112         require (balanceOf[_from] >= _value);                 // Check if the sender has enough
113         require (balanceOf[_to] + _value >= balanceOf[_to]) ;  // Check for overflows
114         require (_value <= allowance[_from][msg.sender]) ;     // Check allowance
115         require (!restrictedAddresses[_to]);
116         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
117         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
118         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
119         emit Transfer(_from, _to, _value);
120         return true;
121     }
122 
123     function burn(uint256 _value) public returns (bool success) {
124         require (balanceOf[msg.sender] >= _value) ;            // Check if the sender has enough
125 		    require (_value <= 0) ;
126         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
127         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
128         emit Burn(msg.sender, _value);
129         return true;
130     }
131 
132 	function freeze(uint256 _value) public returns (bool success) {
133         require (balanceOf[msg.sender] >= _value) ;            // Check if the sender has enough
134 		    require (_value > 0) ;
135         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
136         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
137         emit Freeze(msg.sender, _value);
138         return true;
139     }
140 
141 	function unfreeze(uint256 _value) public returns (bool success) {
142         require (balanceOf[msg.sender] >= _value) ;            // Check if the sender has enough
143         require (_value > 0) ;
144         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
145 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
146         emit Unfreeze(msg.sender, _value);
147         return true;
148     }
149 
150 	// transfer balance to owner
151 	function withdrawEther(uint256 amount) public onlyOwner {
152 		owner.transfer(amount);
153 	}
154 
155   function totalSupply() public constant returns (uint256 Supply) {
156 		return totalSupply;
157 	}
158 
159 	/* Get balance of specific address */
160 	function balanceOf(address _owner) public constant returns (uint256 balance) {
161 		return balanceOf[_owner];
162 	}
163 
164 
165 	function() public payable {
166     revert();
167     }
168 
169     /* Owner can add new restricted address or removes one */
170 	function editRestrictedAddress(address _newRestrictedAddress) public onlyOwner {
171 		restrictedAddresses[_newRestrictedAddress] = !restrictedAddresses[_newRestrictedAddress];
172 	}
173 
174 	function isRestrictedAddress(address _querryAddress) public constant returns (bool answer){
175 		return restrictedAddresses[_querryAddress];
176 	}
177 }