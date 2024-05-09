1 pragma solidity ^0.4.11;
2 
3 contract owned {
4 
5         address public owner;
6 
7         function owned() {
8                 owner = msg.sender;
9         }
10 
11         modifier onlyOwner {
12                 if (msg.sender == owner)
13                 _;
14         }
15 
16 
17 }
18 
19 contract tokenRecipient {
20         function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
21 }
22 
23 contract IERC20Token {
24 
25         /// @return total amount of tokens
26         function totalSupply() constant returns (uint256 totalSupply);
27 
28         /// @param _owner The address from which the balance will be retrieved
29         /// @return The balance
30         function balanceOf(address _owner) constant returns (uint256 balance);
31 
32         /// @notice send `_value` token to `_to` from `msg.sender`
33         /// @param _to The address of the recipient
34         /// @param _value The amount of token to be transferred
35         /// @return Whether the transfer was successful or not
36         function transfer(address _to, uint256 _value) returns (bool success);
37 
38         /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
39         /// @param _from The address of the sender
40         /// @param _to The address of the recipient
41         /// @param _value The amount of token to be transferred
42         /// @return Whether the transfer was successful or not
43         function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
44 
45         /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
46         /// @param _spender The address of the account able to transfer the tokens
47         /// @param _value The amount of wei to be approved for transfer
48         /// @return Whether the approval was successful or not
49         function approve(address _spender, uint256 _value) returns (bool success);
50 
51         /// @param _owner The address of the account owning tokens
52         /// @param _spender The address of the account able to transfer the tokens
53         /// @return Amount of remaining tokens allowed to spent
54         function allowance(address _owner, address _spender) constant returns (uint256 remaining);
55 
56         event Transfer(address indexed _from, address indexed _to, uint256 _value);
57         event Approval(address indexed _owner, address indexed _spender, uint256 _value);
58         event Burn(address indexed from, uint256 value);
59 }
60 
61 contract TESTH is IERC20Token, owned{
62 
63         /* Public variables of the token */
64         string public standard = "TESTH v1.0";
65         string public name = "TESTH";
66         string public symbol = "TESTH";
67         uint8 public decimals = 18;
68         uint256 public initialSupply = 50000000 *  10 ** 18;
69         uint256 public tokenFrozenUntilBlock;
70         uint256 public timeLock = block.timestamp + 2 days; //cofounders time lock
71 
72         /* Private variables of the token */
73         uint256 supply = initialSupply;
74         mapping (address => uint256) balances;
75         mapping (address => mapping (address => uint256)) allowances;
76         mapping (address => bool) rAddresses;
77 
78 
79         event TokenFrozen(uint256 _frozenUntilBlock, string _reason);
80 
81         /* Initializes contract and  sets restricted addresses */
82         function TESTH() {
83                 rAddresses[0x0] = true;                        // Users cannot send tokens to 0x0 address
84                 rAddresses[address(this)] = true;      // Users cannot sent tokens to this contracts address
85         }
86 
87         /* Get total supply of issued coins */
88         function totalSupply() constant returns (uint256 totalSupply) {
89                 return supply;
90         }
91 
92         /* Get balance of specific address */
93         function balanceOf(address _owner) constant returns (uint256 balance) {
94                 return balances[_owner];
95         }
96 
97          function transferOwnership(address newOwner) onlyOwner {
98                 require(transfer(newOwner, balances[msg.sender]));
99                 owner = newOwner;
100         }
101 
102         /* Send coins */
103         function transfer(address _to, uint256 _value) returns (bool success) {
104                 require (block.number >= tokenFrozenUntilBlock) ;       // Throw is token is frozen in case of emergency
105                 require (!rAddresses[_to]) ;                // Prevent transfer to restricted addresses
106                 require (balances[msg.sender] >= _value);           // Check if the sender has enough
107                 require (balances[_to] + _value >= balances[_to]) ;  // Check for overflows
108                 require (!(msg.sender == owner && block.timestamp < timeLock && (balances[msg.sender]-_value) < 10000000 * 10 ** 18));
109 
110                 balances[msg.sender] -= _value;                     // Subtract from the sender
111                 balances[_to] += _value;                            // Add the same to the recipient
112                 Transfer(msg.sender, _to, _value);                  // Notify anyone listening that this transfer took place
113                 return true;
114         }
115 
116         /* Allow another contract to spend some tokens in your behalf */
117         function approve(address _spender, uint256 _value) returns (bool success) {
118                 require (block.number > tokenFrozenUntilBlock); // Throw is token is frozen in case of emergency
119                 allowances[msg.sender][_spender] = _value;          // Set allowance
120                 Approval(msg.sender, _spender, _value);             // Raise Approval event
121                 return true;
122         }
123 
124         /* Approve and then communicate the approved contract in a single tx */
125         function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
126                 tokenRecipient spender = tokenRecipient(_spender);              // Cast spender to tokenRecipient contract
127                 approve(_spender, _value);                                      // Set approval to contract for _value
128                 spender.receiveApproval(msg.sender, _value, this, _extraData);  // Raise method on _spender contract
129                 return true;
130         }
131 
132         /* A contract attempts to get the coins */
133         function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
134                 require (block.number > tokenFrozenUntilBlock); // Throw is token is frozen in case of emergency
135                 require (!rAddresses[_to]);                // Prevent transfer to restricted addresses
136                 require(balances[_from] >= _value);                // Check if the sender has enough
137                 require (balances[_to] + _value >= balances[_to]);  // Check for overflows
138                 require (_value <= allowances[_from][msg.sender]);  // Check allowance
139                 require (!(_from == owner && block.timestamp < timeLock && (balances[_from]-_value) < 10000000 * 10 ** 18));
140                 balances[_from] -= _value;                          // Subtract from the sender
141                 balances[_to] += _value;                            // Add the same to the recipient
142                 allowances[_from][msg.sender] -= _value;            // Deduct allowance for this address
143                 Transfer(_from, _to, _value);                       // Notify anyone listening that this transfer took place
144                 return true;
145         }
146 
147         function burn(uint256 _value) returns (bool success) {
148                 require(balances[msg.sender] >= _value);                 // Check if the sender has enough
149                 balances[msg.sender] -= _value;                          // Subtract from the sender
150                 supply-=_value;
151                 Burn(msg.sender, _value);
152                 return true;
153         }
154 
155         function burnFrom(address _from, uint256 _value) returns (bool success) {
156                 require(balances[_from] >= _value);                // Check if the targeted balance is enough
157                 require(_value <= allowances[_from][msg.sender]);    // Check allowance
158                 balances[_from] -= _value;                         // Subtract from the targeted balance
159                 allowances[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
160                 supply -= _value;                              // Update totalSupply
161                 Burn(_from, _value);
162                 return true;
163         }
164 
165         /* Get the amount of remaining tokens to spend */
166         function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
167                 return allowances[_owner][_spender];
168         }
169 
170 
171 
172         /* Stops all token transfers in case of emergency */
173         function freezeTransfersUntil(uint256 _frozenUntilBlock, string _reason) onlyOwner {
174                 tokenFrozenUntilBlock = _frozenUntilBlock;
175                 TokenFrozen(_frozenUntilBlock, _reason);
176         }
177 
178         function unfreezeTransfersUntil(string _reason) onlyOwner {
179                 tokenFrozenUntilBlock = 0;
180                 TokenFrozen(0, _reason);
181         }
182 
183         /* Owner can add new restricted address or removes one */
184         function editRestrictedAddress(address _newRestrictedAddress) onlyOwner {
185                 rAddresses[_newRestrictedAddress] = !rAddresses[_newRestrictedAddress];
186         }
187 
188         function isRestrictedAddress(address _queryAddress) constant returns (bool answer){
189                 return rAddresses[_queryAddress];
190         }
191 }