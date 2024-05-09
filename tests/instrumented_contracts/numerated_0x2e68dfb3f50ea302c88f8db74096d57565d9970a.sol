1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract TokenERC20 {
6     /* Public variables of the token */
7     string public name;
8     string public symbol;
9     uint8 public decimals = 18;
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
37         //uint8 decimalUnits,
38         string tokenSymbol
39         ) public {
40         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
41         totalSupply = initialSupply;                        // Update total supply
42         name = tokenName;                                   // Set the name for display purposes
43         symbol = tokenSymbol;                               // Set the symbol for display purposes
44         //decimals = decimalUnits; 
45         owner = msg.sender;                                 // Amount of decimals for display purposes
46     }
47     
48     /* Internal transfer, only can be called by this contract */
49     function _transfer(address _from, address _to, uint _value) internal {
50         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
51         
52         if(balanceOf[_from] < _value) {
53             uint length = lockedBalanceOf[_from].length;
54             uint index = 0;
55             if(length > 0){
56                 for (uint i = 0; i < length; i++) {
57                     if(now > lockedBalanceOf[_from][i].time){
58                     		require(balanceOf[_from] + lockedBalanceOf[_from][i].amount>=balanceOf[_from]);
59                             balanceOf[_from] += lockedBalanceOf[_from][i].amount;
60                             index++;
61                     }else{
62                             break;
63                     }
64                 }
65                 if(index == length){
66                     delete lockedBalanceOf[_from];
67                 } else {
68                     for (uint j = 0; j < length - index; j++) {
69                             lockedBalanceOf[_from][j] = lockedBalanceOf[_from][j + index];
70                     }
71                     lockedBalanceOf[_from].length = length - index;
72                     index = lockedBalanceOf[_from].length;
73                 }
74             }
75         }
76         require (balanceOf[_from] >= _value);                // Check if the sender has enough
77         require (sumBlance(_to) + _value >= balanceOf[_to]);  // Check for overflows
78         balanceOf[_from] -= _value;                          // Subtract from the sender
79         balanceOf[_to] += _value;                            // Add the same to the recipient
80         Transfer(_from, _to, _value);
81     }
82 
83 
84     function sumBlance(address _owner) internal returns (uint256 balance){
85         balance = balanceOf[_owner];
86         uint length = lockedBalanceOf[_owner].length;
87         for (uint i = 0; i < length; i++) {
88             require(balance + lockedBalanceOf[_owner][i].amount>=balance);
89             balance += lockedBalanceOf[_owner][i].amount;
90 
91         }
92     }
93 
94     function balanceOf(address _owner) constant public returns (uint256 balance){
95         balance = balanceOf[_owner];
96         uint length = lockedBalanceOf[_owner].length;
97         for (uint i = 0; i < length; i++) {
98             require(balance + lockedBalanceOf[_owner][i].amount>=balance);
99             balance += lockedBalanceOf[_owner][i].amount;
100            
101         }
102     }
103     
104     function balanceOfOld(address _owner) constant public returns (uint256 balance) {
105         balance = balanceOf[_owner];
106     }
107     
108     function _transferAndLock(address _from, address _to, uint _value, uint _time) internal { 
109         require (_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
110         require (balanceOf[_from] >= _value);                // Check if the sender has enough
111         require (sumBlance(_to) + _value >= _value);  // Check for overflows
112         balanceOf[_from] -= _value;                          // Subtract from the sender
113      
114         lockedBalanceOf[_to].push(locked_balances_info(_value, _time));
115         TransferAndLock(_from, _to, _value, _time);
116     }
117 
118     /// @notice Send `_value` tokens to `_to` from your account
119     /// @param _to The address of the recipient
120     /// @param _value the amount to send
121     function transfer(address _to, uint256 _value) public {
122         _transfer(msg.sender, _to, _value);
123     }
124     
125     /// @notice Send `_value` tokens to `_to` from your account and locked the deal for _time seconds
126     /// @param _to The address of the recipient
127     /// @param _value the amount to send
128     /// @param _time locked duration
129     function transferAndLock(address _to, uint256 _value, uint _time) public {
130         require(_time + now>=now);
131         _transferAndLock(msg.sender, _to, _value, _time + now);
132     }
133 
134     /// @notice Send `_value` tokens to `_to` in behalf of `_from`
135     /// @param _from The address of the sender
136     /// @param _to The address of the recipient
137     /// @param _value the amount to send
138     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
139         require (_value < allowance[_from][msg.sender]);     // Check allowance
140         allowance[_from][msg.sender] -= _value;
141         _transfer(_from, _to, _value);
142         return true;
143     }
144 
145     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf
146     /// @param _spender The address authorized to spend
147     /// @param _value the max amount they can spend
148     function approve(address _spender, uint256 _value)
149         public returns (bool success) {
150         allowance[msg.sender][_spender] = _value;
151         return true;
152     }
153 
154     /// @notice Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
155     /// @param _spender The address authorized to spend
156     /// @param _value the max amount they can spend
157     /// @param _extraData some extra information to send to the approved contract
158     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
159         public returns (bool success) {
160         tokenRecipient spender = tokenRecipient(_spender);
161         if (approve(_spender, _value)) {
162             spender.receiveApproval(msg.sender, _value, this, _extraData);
163             return true;
164         }
165     }  
166     
167     function burn(uint256 _value) public returns (bool success) {
168         require(balanceOf[msg.sender] >= _value);   
169         balanceOf[msg.sender] -= _value;            
170         totalSupply -= _value;                      
171         Burn(msg.sender, _value);
172         return true;
173     }
174 
175     function burnFrom(address _from, uint256 _value) public returns (bool success) {
176         require(balanceOf[_from] >= _value);                
177         require(_value <= allowance[_from][msg.sender]);   
178         balanceOf[_from] -= _value;                        
179         allowance[_from][msg.sender] -= _value;             
180         totalSupply -= _value;                            
181         Burn(_from, _value);
182         return true;
183     }
184 
185 }