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
30 }
31 contract SCT is SafeMath{
32     string public name;
33     string public symbol;
34     address public owner;
35     uint8 public decimals;
36     uint256 public totalSupply;
37     address public icoContractAddress;
38     uint256 public  tokensTotalSupply =  3100 * (10**6) * 10**18;
39     mapping (address => bool) restrictedAddresses;
40     uint256 constant initialSupply = 3100 * (10**6) * 10**18;
41     string constant  tokenName = 'SCT';
42     uint8 constant decimalUnits = 18;
43     string constant tokenSymbol = 'SCT';
44 
45 
46     /* This creates an array with all balances */
47     mapping (address => uint256) public balanceOf;
48    mapping (address => uint256) public freezeOf;
49     mapping (address => mapping (address => uint256)) public allowance;
50 
51     /* This generates a public event on the blockchain that will notify clients */
52     event Transfer(address indexed from, address indexed to, uint256 value);
53 
54     /* This notifies clients about the amount burnt */
55     event Burn(address indexed from, uint256 value);
56 
57  /* This notifies clients about the amount frozen */
58     event Freeze(address indexed from, uint256 value);
59 
60  /* This notifies clients about the amount unfrozen */
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
73     function SCT() {
74         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
75         totalSupply = initialSupply;                        // Update total supply
76         name = tokenName;                                   // Set the name for display purposes
77         symbol = tokenSymbol;                               // Set the symbol for display purposes
78         decimals = decimalUnits;                            // Amount of decimals for display purposes
79         owner = msg.sender;
80     }
81 
82     /* Send coins */
83     function transfer(address _to, uint256 _value) {
84       require (_value > 0) ;
85         require (balanceOf[msg.sender] >= _value);           // Check if the sender has enough
86         require (balanceOf[_to] + _value >= balanceOf[_to]) ;     // Check for overflows
87         require (!restrictedAddresses[_to]);
88         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
89         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
90         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
91     }
92 
93     /* Allow another contract to spend some tokens in your behalf */
94     function approve(address _spender, uint256 _value)
95         returns (bool success) {
96           allowance[msg.sender][_spender] = _value;          // Set allowance
97         Approval(msg.sender, _spender, _value);             // Raise Approval event
98         return true;
99     }
100 
101     function prodTokens(address _to, uint256 _amount)
102     onlyOwner {
103       require (_amount != 0 ) ;   // Check if values are not null;
104       require (balanceOf[_to] + _amount > balanceOf[_to]) ;     // Check for overflows
105       require (totalSupply <=tokensTotalSupply);
106       //require (!restrictedAddresses[_to]);
107       totalSupply += _amount;                                      // Update total supply
108       balanceOf[_to] += _amount;                          // Set minted coins to target
109       Mint(_to, _amount);                                // Create Mint event
110       Transfer(0x0, _to, _amount);                            // Create Transfer event from 0x
111     }
112 
113     /* A contract attempts to get the coins */
114     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
115         require (balanceOf[_from] >= _value);                 // Check if the sender has enough
116         require (balanceOf[_to] + _value >= balanceOf[_to]) ;  // Check for overflows
117         require (_value <= allowance[_from][msg.sender]) ;     // Check allowance
118         require (!restrictedAddresses[_to]);
119         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
120         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
121         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
122         Transfer(_from, _to, _value);
123         return true;
124     }
125 
126     function burn(uint256 _value) returns (bool success) {
127         require (balanceOf[msg.sender] >= _value) ;            // Check if the sender has enough
128       require (_value > 0) ;
129         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
130         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
131         Burn(msg.sender, _value);
132         return true;
133     }
134 
135  function freeze(uint256 _value) returns (bool success) {
136         require (balanceOf[msg.sender] >= _value) ;            // Check if the sender has enough
137       require (_value > 0) ;
138         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
139         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
140         Freeze(msg.sender, _value);
141         return true;
142     }
143 
144  function unfreeze(uint256 _value) returns (bool success) {
145         require (balanceOf[msg.sender] >= _value) ;            // Check if the sender has enough
146         require (_value > 0) ;
147         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
148       balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
149         Unfreeze(msg.sender, _value);
150         return true;
151     }
152 
153  // transfer balance to owner
154  function withdrawEther(uint256 amount)
155   onlyOwner {
156   owner.transfer(amount);
157  }
158 
159   function totalSupply() constant returns (uint256 Supply) {
160   return totalSupply;
161  }
162 
163  /* Get balance of specific address */
164  function balanceOf(address _owner) constant returns (uint256 balance) {
165   return balanceOf[_owner];
166  }
167 
168 
169  function() payable {
170     revert();
171     }
172 
173     /* Owner can add new restricted address or removes one */
174  function editRestrictedAddress(address _newRestrictedAddress) onlyOwner {
175   restrictedAddresses[_newRestrictedAddress] = !restrictedAddresses[_newRestrictedAddress];
176  }
177 
178  function isRestrictedAddress(address _querryAddress) constant returns (bool answer){
179   return restrictedAddresses[_querryAddress];
180  }
181 }