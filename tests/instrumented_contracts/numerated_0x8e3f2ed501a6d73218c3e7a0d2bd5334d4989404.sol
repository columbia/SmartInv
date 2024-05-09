1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract TokenERC20 {
6     /* Public variables of the token */
7     string public name;
8     string public symbol;
9     uint8 public decimals;
10     uint256 public totalSupply;
11     address public owner;
12     
13     struct locked_balances_info{
14         uint amount;
15         uint time;
16     }
17     mapping(address => locked_balances_info[]) public lockedBalanceOf;
18 
19     /* This creates an array with all balances */
20     mapping (address => uint256) public balanceOf;
21     mapping (address => mapping (address => uint256)) public allowance;
22 
23     /* This generates a public event on the blockchain that will notify clients */
24     event Transfer(address indexed from, address indexed to, uint256 value);
25 
26     /* This generates a public event on the blockchain that will notify clients */
27     event TransferAndLock(address indexed from, address indexed to, uint256 value, uint256 time);
28 
29     /* This notifies clients about the amount burnt */
30     event Burn(address indexed from, uint256 value);
31 
32 
33     /* Initializes contract with initial supply tokens to the creator of the contract */
34     function TokenERC20(
35         uint256 initialSupply,
36         string tokenName,
37         uint8 decimalUnits,
38         string tokenSymbol
39         ) public {
40         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
41         totalSupply = initialSupply;                        // Update total supply
42         name = tokenName;                                   // Set the name for display purposes
43         symbol = tokenSymbol;                               // Set the symbol for display purposes
44         decimals = decimalUnits; 
45         owner = msg.sender;                                 // Amount of decimals for display purposes
46     }
47     
48     /* Internal transfer, only can be called by this contract */
49     function _transfer(address _from, address _to, uint _value) internal {
50         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
51         
52     if(balanceOf[_from] < _value) {
53             uint length = lockedBalanceOf[_from].length;
54             uint index = 0;
55             if(length > 0){
56                     for (uint i = 0; i < length; i++) {
57                         if(now > lockedBalanceOf[_from][i].time){
58                                 balanceOf[_from] += lockedBalanceOf[_from][i].amount;
59                                 index++;
60                         }else{
61                                 break;
62                         }
63                     }
64                     if(index == length){
65                         delete lockedBalanceOf[_from];
66                     } else {
67                         for (uint j = 0; j < length - index; j++) {
68                                 lockedBalanceOf[_from][j] = lockedBalanceOf[_from][j + index];
69                         }
70                         lockedBalanceOf[_from].length = length - index;
71                         index = lockedBalanceOf[_from].length;
72                     }
73             }
74     }
75 
76         require (balanceOf[_from] >= _value);                // Check if the sender has enough
77         require (balanceOf[_to] + _value > balanceOf[_to]);  // Check for overflows
78         balanceOf[_from] -= _value;                          // Subtract from the sender
79         balanceOf[_to] += _value;                            // Add the same to the recipient
80         Transfer(_from, _to, _value);
81     }
82     
83     function balanceOf(address _owner) constant public returns (uint256 balance){
84         balance = balanceOf[_owner];
85         uint length = lockedBalanceOf[_owner].length;
86         for (uint i = 0; i < length; i++) {
87             balance += lockedBalanceOf[_owner][i].amount;
88         }
89     }
90     
91      function balanceOfOld(address _owner) constant public returns (uint256 balance) {
92         balance = balanceOf[_owner];
93     }
94     
95     function _transferAndLock(address _from, address _to, uint _value, uint _time) internal {
96         require (_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
97         require (balanceOf[_from] >= _value);                // Check if the sender has enough
98         require (balanceOf[_to] + _value > balanceOf[_to]);  // Check for overflows
99         balanceOf[_from] -= _value;                          // Subtract from the sender
100      
101         lockedBalanceOf[_to].push(locked_balances_info(_value, _time));
102         TransferAndLock(_from, _to, _value, _time);
103     }
104 
105     /// @notice Send `_value` tokens to `_to` from your account
106     /// @param _to The address of the recipient
107     /// @param _value the amount to send
108     function transfer(address _to, uint256 _value) public {
109         _transfer(msg.sender, _to, _value);
110     }
111     
112     function transferAndLock(address _to, uint256 _value, uint _time) public {
113         _transferAndLock(msg.sender, _to, _value, _time + now);
114     }
115 
116     /// @notice Send `_value` tokens to `_to` in behalf of `_from`
117     /// @param _from The address of the sender
118     /// @param _to The address of the recipient
119     /// @param _value the amount to send
120     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
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
131         public returns (bool success) {
132         allowance[msg.sender][_spender] = _value;
133         return true;
134     }
135 
136     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
137     /// @param _spender The address authorized to spend
138     /// @param _value the max amount they can spend
139     /// @param _extraData some extra information to send to the approved contract
140     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
141         public returns (bool success) {
142         tokenRecipient spender = tokenRecipient(_spender);
143         if (approve(_spender, _value)) {
144             spender.receiveApproval(msg.sender, _value, this, _extraData);
145             return true;
146         }
147     }        
148 
149 }