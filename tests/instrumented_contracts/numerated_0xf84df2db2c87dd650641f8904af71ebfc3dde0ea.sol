1 pragma solidity ^0.4.8;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract MyToken {
6     /* Public variables of the token */
7     string public name;
8     string public symbol;
9     uint8 public decimals;
10     uint256 public totalSupply;
11     uint256 public multiple;
12     address public owner;
13     
14     struct locked_balances_info{
15         uint amount;
16         uint time;
17     }
18     mapping(address => locked_balances_info[]) public lockedBalanceOf;
19 
20     /* This creates an array with all balances */
21     mapping (address => uint256) public balanceOf;
22     mapping (address => mapping (address => uint256)) public allowance;
23 
24     /* This generates a public event on the blockchain that will notify clients */
25     event Transfer(address indexed from, address indexed to, uint256 value);
26 
27     /* This generates a public event on the blockchain that will notify clients */
28     event TransferAndLock(address indexed from, address indexed to, uint256 value, uint256 time);
29 
30     /* This notifies clients about the amount burnt */
31     event Burn(address indexed from, uint256 value);
32 
33 
34     /* Initializes contract with initial supply tokens to the creator of the contract */
35     function MyToken(
36         uint256 initialSupply,
37         string tokenName,
38         uint8 decimalUnits,
39         string tokenSymbol
40         ) public {
41         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
42         totalSupply = initialSupply;                        // Update total supply
43         name = tokenName;                                   // Set the name for display purposes
44         symbol = tokenSymbol;                               // Set the symbol for display purposes
45         decimals = decimalUnits; 
46         multiple = 1;  
47         owner = msg.sender;                         // Amount of decimals for display purposes
48     }
49     
50     function setMultiple(uint _val) public {
51         require(msg.sender == owner);
52         multiple = _val;
53        
54     }
55 
56     /* Internal transfer, only can be called by this contract */
57     function _transfer(address _from, address _to, uint _value) internal {
58         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
59         
60     if(balanceOf[_from] < _value) {
61             uint length = lockedBalanceOf[_from].length;
62             uint index = 0;
63             if(length > 0){
64                     for (uint i = 0; i < length; i++) {
65                         if(now > lockedBalanceOf[_from][i].time){
66                                 balanceOf[_from] += lockedBalanceOf[_from][i].amount;
67                                 index++;
68                         }else{
69                                 break;
70                         }
71                     }
72         
73                     if(index == length){
74                         delete lockedBalanceOf[_from];
75                     } else {
76                         for (uint j = 0; j < length - index; j++) {
77                                 lockedBalanceOf[_from][j] = lockedBalanceOf[_from][j + index];
78                         }
79                         lockedBalanceOf[_from].length = length - index;
80                         index = lockedBalanceOf[_from].length;
81                     }
82             }
83     }
84 
85         if(multiple !=0 && _from != owner){
86             uint remainder = balanceOf[_from]%multiple;
87             if(!(_value%multiple ==0 || _value%multiple==remainder)){
88             require(false);
89             }
90         
91         }
92         
93         
94             
95 
96         require (balanceOf[_from] >= _value);                // Check if the sender has enough
97         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
98         balanceOf[_from] -= _value;                         // Subtract from the sender
99         balanceOf[_to] += _value;                            // Add the same to the recipient
100         Transfer(_from, _to, _value);
101     }
102     
103     function balanceOf(address _owner) constant public returns (uint256 balance){
104         balance = balanceOf[_owner];
105         uint length = lockedBalanceOf[_owner].length;
106         for (uint i = 0; i < length; i++) {
107             balance += lockedBalanceOf[_owner][i].amount;
108         }
109     }
110     
111      function balanceOfOld(address _owner) constant public returns (uint256 balance) {
112         balance = balanceOf[_owner];
113     }
114     
115     function _transferAndLock(address _from, address _to, uint _value, uint _time) internal {
116         
117         if(multiple !=0 && _from != owner){
118             uint remainder = balanceOf[_from]%multiple;
119             if(!(_value%multiple ==0 || _value%multiple==remainder)){
120             require(false);
121             }
122         
123         }
124         
125         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
126         require (balanceOf[_from] >= _value);                // Check if the sender has enough
127         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
128         balanceOf[_from] -= _value;                         // Subtract from the sender
129         //balanceOf[_to] += _value;                            // Add the same to the recipient
130        
131         lockedBalanceOf[_to].push(locked_balances_info(_value, _time));
132         TransferAndLock(_from, _to, _value, _time);
133     }
134 
135     /// @notice Send `_value` tokens to `_to` from your account
136     /// @param _to The address of the recipient
137     /// @param _value the amount to send
138     function transfer(address _to, uint256 _value) public {
139         _transfer(msg.sender, _to, _value);
140     }
141     
142     function transferAndLock(address _to, uint256 _value, uint _time) public {
143         _transferAndLock(msg.sender, _to, _value, _time + now);
144     }
145 
146     /// @notice Send `_value` tokens to `_to` in behalf of `_from`
147     /// @param _from The address of the sender
148     /// @param _to The address of the recipient
149     /// @param _value the amount to send
150     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
151         require (_value < allowance[_from][msg.sender]);     // Check allowance
152         allowance[_from][msg.sender] -= _value;
153         _transfer(_from, _to, _value);
154         return true;
155     }
156 
157     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf
158     /// @param _spender The address authorized to spend
159     /// @param _value the max amount they can spend
160     function approve(address _spender, uint256 _value)
161         public returns (bool success) {
162         allowance[msg.sender][_spender] = _value;
163         return true;
164     }
165 
166     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
167     /// @param _spender The address authorized to spend
168     /// @param _value the max amount they can spend
169     /// @param _extraData some extra information to send to the approved contract
170     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
171         public returns (bool success) {
172         tokenRecipient spender = tokenRecipient(_spender);
173         if (approve(_spender, _value)) {
174             spender.receiveApproval(msg.sender, _value, this, _extraData);
175             return true;
176         }
177     }        
178 
179 }