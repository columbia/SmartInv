1 pragma solidity ^0.4.8;
2 
3 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
4 
5 contract MyToken {
6     /* Public variables of the token */
7     string public name;
8     string public symbol;
9     uint8 public decimals;
10     uint256 public totalSupply;
11     
12     struct locked_balances_info{
13         uint amount;
14         uint time;
15     }
16     mapping(address => locked_balances_info[]) public lockedBalanceOf;
17 
18     /* This creates an array with all balances */
19     mapping (address => uint256) public balanceOf;
20     mapping (address => mapping (address => uint256)) public allowance;
21 
22     /* This generates a public event on the blockchain that will notify clients */
23     event Transfer(address indexed from, address indexed to, uint256 value);
24 
25     /* This generates a public event on the blockchain that will notify clients */
26     event TransferAndLock(address indexed from, address indexed to, uint256 value, uint256 time);
27 
28     /* This notifies clients about the amount burnt */
29     event Burn(address indexed from, uint256 value);
30 
31     /* Initializes contract with initial supply tokens to the creator of the contract */
32     function MyToken(
33         uint256 initialSupply,
34         string tokenName,
35         uint8 decimalUnits,
36         string tokenSymbol
37         ) {
38         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
39         totalSupply = initialSupply;                        // Update total supply
40         name = tokenName;                                   // Set the name for display purposes
41         symbol = tokenSymbol;                               // Set the symbol for display purposes
42         decimals = decimalUnits;                            // Amount of decimals for display purposes
43     }
44 
45     /* Internal transfer, only can be called by this contract */
46     function _transfer(address _from, address _to, uint _value) internal {
47         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
48         
49 	if(balanceOf[_from] < _value) {
50         	uint length = lockedBalanceOf[_from].length;
51         	uint index = 0;
52         	if(length > 0){
53             		for (uint i = 0; i < length; i++) {
54                 		if(now > lockedBalanceOf[_from][i].time){
55                     			balanceOf[_from] += lockedBalanceOf[_from][i].amount;
56                     			index++;
57                 		}else{
58                     			break;
59                 		}
60             		}
61         
62             		if(index == length){
63                 		delete lockedBalanceOf[_from];
64             		} else {
65                 		for (uint j = 0; j < length - index; j++) {
66                     			lockedBalanceOf[_from][j] = lockedBalanceOf[_from][j + index];
67                 		}
68                 		lockedBalanceOf[_from].length = length - index;
69                 		index = lockedBalanceOf[_from].length;
70             		}
71         	}
72 	}
73 
74         
75         require (balanceOf[_from] >= _value);                // Check if the sender has enough
76         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
77         balanceOf[_from] -= _value;                         // Subtract from the sender
78         balanceOf[_to] += _value;                            // Add the same to the recipient
79         Transfer(_from, _to, _value);
80     }
81     
82     function balanceOf(address _owner) constant returns (uint256 balance) {
83         balance = balanceOf[_owner];
84         uint length = lockedBalanceOf[_owner].length;
85         for (uint i = 0; i < length; i++) {
86             balance += lockedBalanceOf[_owner][i].amount;
87         }
88     }
89     
90      function balanceOfOld(address _owner) constant returns (uint256 balance) {
91         balance = balanceOf[_owner];
92     }
93     
94     function _transferAndLock(address _from, address _to, uint _value, uint _time) internal {
95         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
96         require (balanceOf[_from] >= _value);                // Check if the sender has enough
97         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
98         balanceOf[_from] -= _value;                         // Subtract from the sender
99         //balanceOf[_to] += _value;                            // Add the same to the recipient
100        
101         lockedBalanceOf[_to].push(locked_balances_info(_value, _time));
102         TransferAndLock(_from, _to, _value, _time);
103     }
104 
105     /// @notice Send `_value` tokens to `_to` from your account
106     /// @param _to The address of the recipient
107     /// @param _value the amount to send
108     function transfer(address _to, uint256 _value) {
109         _transfer(msg.sender, _to, _value);
110     }
111     
112     function transferAndLock(address _to, uint256 _value, uint _time){
113         _transferAndLock(msg.sender, _to, _value, _time + now);
114     }
115 
116     /// @notice Send `_value` tokens to `_to` in behalf of `_from`
117     /// @param _from The address of the sender
118     /// @param _to The address of the recipient
119     /// @param _value the amount to send
120     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
121         require (_value < allowance[_from][msg.sender]);     // Check allowance
122         allowance[_from][msg.sender] -= _value;
123         _transfer(_from, _to, _value);
124         return true;
125     }
126 
127     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf
128     /// @param _spender The address authorized to spend
129     /// @param _value the max amount they can spend
130     function approve(address _spender, uint256 _value)
131         returns (bool success) {
132         allowance[msg.sender][_spender] = _value;
133         return true;
134     }
135 
136     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
137     /// @param _spender The address authorized to spend
138     /// @param _value the max amount they can spend
139     /// @param _extraData some extra information to send to the approved contract
140     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
141         returns (bool success) {
142         tokenRecipient spender = tokenRecipient(_spender);
143         if (approve(_spender, _value)) {
144             spender.receiveApproval(msg.sender, _value, this, _extraData);
145             return true;
146         }
147     }        
148 
149     /// @notice Remove `_value` tokens from the system irreversibly
150     /// @param _value the amount of money to burn
151     function burn(uint256 _value) returns (bool success) {
152         require (balanceOf[msg.sender] > _value);            // Check if the sender has enough
153         balanceOf[msg.sender] -= _value;                      // Subtract from the sender
154         totalSupply -= _value;                                // Updates totalSupply
155         Burn(msg.sender, _value);
156         return true;
157     }
158 
159     function burnFrom(address _from, uint256 _value) returns (bool success) {
160         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
161         require(_value <= allowance[_from][msg.sender]);    // Check allowance
162         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
163         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
164         totalSupply -= _value;                              // Update totalSupply
165         Burn(_from, _value);
166         return true;
167     }
168 }