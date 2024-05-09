1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract owned {
4     address public owner;
5 
6     constructor(address _owner) public {
7         owner = _owner;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner; 
17     } 
18 }
19 
20 
21 contract TPCERC20 {
22     // Public variables of the token
23     string public name;
24     string public symbol;
25     uint8 public decimals = 0;
26     // 18 decimals is the strongly suggested default, avoid changing it
27     uint256 public totalSupply;
28 
29     // This creates an array with all balances
30     mapping (address => uint256) public balanceOf;
31    
32     // This generates a public event on the blockchain that will notify clients
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     
35 
36     // This notifies clients about the amount burnt
37     event Burn(address indexed from, uint256 value);
38 
39     /**
40      * Constrctor function
41      *
42      * Initializes contract with initial supply tokens to the creator of the contract
43      */
44     constructor(
45         uint256 initialSupply,
46         string memory tokenName,
47         string memory tokenSymbol,
48         address _owner
49     ) public {
50         totalSupply = initialSupply;  // Update total supply with the decimal amount
51         balanceOf[_owner] = totalSupply;                    // Give the creator all initial tokens
52         name = tokenName;                                       // Set the name for display purposes
53         symbol = tokenSymbol;                                   // Set the symbol for display purposes
54     }
55 
56     /**
57      * Internal transfer, only can be called by this contract
58      */
59     function _transfer(address _from, address _to, uint _value) internal {
60         // Prevent transfer to 0x0 address. Use burn() instead
61         require(_to != address(0x0));
62         // Check if the sender has enough
63         require(balanceOf[_from] >= _value);
64         // Check for overflows
65         require(balanceOf[_to] + _value > balanceOf[_to]);
66         // Save this for an assertion in the future
67         uint previousBalances = balanceOf[_from] + balanceOf[_to];
68         // Subtract from the sender
69         balanceOf[_from] -= _value;
70         // Add the same to the recipient
71         balanceOf[_to] += _value;
72         emit Transfer(_from, _to, _value);
73         // Asserts are used to use static analysis to find bugs in your code. They should never fail
74         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
75     }
76 
77     /**
78      * Transfer tokens
79      *
80      * Send `_value` tokens to `_to` from your account
81      *
82      * @param _to The address of the recipient
83      * @param _value the amount to send
84      */
85     function transfer(address _to, uint256 _value) public returns (bool success) {
86         _transfer(msg.sender, _to, _value);
87         return true;
88     }
89 
90     /**
91      * Destroy tokens
92      *
93      * Remove `_value` tokens from the system irreversibly
94      *
95      * @param _value the amount of money to burn
96      */
97     function burn(uint256 _value) public returns (bool success) {
98         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
99         balanceOf[msg.sender] -= _value;            // Subtract from the sender
100         totalSupply -= _value;                      // Updates totalSupply
101         emit Burn(msg.sender, _value);
102         return true;
103     }
104 
105   
106 }
107 
108 /******************************************/
109 /*       ADVANCED TOKEN STARTS HERE       */
110 /******************************************/
111 
112 contract TPCToken is owned, TPCERC20 {
113 
114   
115     mapping (address => bool) public frozenAccount;
116 
117     mapping (address => uint256) public frozenOf;
118 
119     /* This generates a public event on the blockchain that will notify clients */
120     event FrozenFunds(address target, bool frozen);
121 
122     event Frozen(address target, uint256 value);
123 
124     event UnFrozen(address target, uint256 value);
125 
126     /* Initializes contract with initial supply tokens to the creator of the contract */
127     constructor(
128         uint256 initialSupply,
129         string memory tokenName,
130         string memory tokenSymbol,
131         address _owner
132      ) owned(_owner) TPCERC20(initialSupply, tokenName, tokenSymbol,_owner) public {}
133 
134     /* Internal transfer, only can be called by this contract */
135     function _transfer(address _from, address _to, uint _value) internal {
136         require (_to != address(0x0));                          // Prevent transfer to 0x0 address. Use burn() instead
137         require (balanceOf[_from] >= _value);                   // Check if the sender has enough
138         require (balanceOf[_to] + _value >= balanceOf[_to]);    // Check for overflows
139         require(!frozenAccount[_from]);                         // Check if sender is frozen
140         require(!frozenAccount[_to]);                           // Check if recipient is frozen
141         balanceOf[_from] -= _value;                             // Subtract from the sender
142         balanceOf[_to] += _value;                               // Add the same to the recipient
143         emit Transfer(_from, _to, _value);
144     }
145 
146     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
147     /// @param target Address to be frozen 
148     /// @param freeze either to freeze it or not
149     function freezeAccount(address target, bool freeze) onlyOwner public {
150         frozenAccount[target] = freeze;
151         emit FrozenFunds(target, freeze);
152     }
153 
154     modifier  freezeCondition(address target){
155         require (target != address(0x0));  
156 	    require(!frozenAccount[target]);
157         _;
158     }
159 
160     function freeze(address target, uint256 _value) freezeCondition(target) onlyOwner public returns(bool success){
161         require (balanceOf[target] >= _value); 
162     	require (frozenOf[target] + _value >= frozenOf[target]);
163     	uint256 beforebalancealance = balanceOf[target];
164     	uint256 beforeFbalance = frozenOf[target];
165     	balanceOf[target] -= _value;                          
166         frozenOf[target] += _value; 
167         require (balanceOf[target] + _value == beforebalancealance); 
168         require (frozenOf[target] == beforeFbalance + _value); 
169         emit Frozen(target, _value);
170         return true;
171     }
172 
173     function unfreeze(address target, uint256 _value)  freezeCondition(target)  onlyOwner public  returns(bool success){
174     	require (frozenOf[target] >= _value); 
175     	require (balanceOf[target] + _value >= balanceOf[target]); 
176     	uint256 beforebalancealance = balanceOf[target];
177     	uint256 beforeFbalance = frozenOf[target];
178     	frozenOf[target] -= _value;                          
179         balanceOf[target] += _value;
180         require (balanceOf[target]  == beforebalancealance + _value); 
181         require (frozenOf[target] + _value == beforeFbalance );
182         emit UnFrozen(target, _value);
183         return true;
184     }
185  
186 }