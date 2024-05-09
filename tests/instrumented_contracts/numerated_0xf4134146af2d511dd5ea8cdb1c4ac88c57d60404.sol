1 //
2 /* SunContract Token Smart Contract v1.0 */   
3 //
4 
5 contract owned {
6 
7   address public owner;
8 
9   function owned() {
10     owner = msg.sender;
11   }
12 
13   modifier onlyOwner {
14     if (msg.sender != owner) throw;
15     _;
16   }
17 
18   function transferOwnership(address newOwner) onlyOwner {
19     owner = newOwner;
20   }
21 }
22 
23 contract tokenRecipient { 
24   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
25 } 
26 
27 contract IERC20Token {
28 
29   /// @return total amount of tokens
30   function totalSupply() constant returns (uint256 totalSupply);
31 
32   /// @param _owner The address from which the balance will be retrieved
33   /// @return The balance
34   function balanceOf(address _owner) constant returns (uint256 balance) {}
35 
36   /// @notice send `_value` token to `_to` from `msg.sender`
37   /// @param _to The address of the recipient
38   /// @param _value The amount of tokens to be transferred
39   /// @return Whether the transfer was successful or not
40   function transfer(address _to, uint256 _value) returns (bool success) {}
41 
42   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
43   /// @param _from The address of the sender
44   /// @param _to The address of the recipient
45   /// @param _value The amount of token to be transferred
46   /// @return Whether the transfer was successful or not
47   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
48 
49   /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
50   /// @param _spender The address of the account able to transfer the tokens
51   /// @param _value The amount of wei to be approved for transfer
52   /// @return Whether the approval was successful or not
53   function approve(address _spender, uint256 _value) returns (bool success) {}
54 
55   /// @param _owner The address of the account owning tokens
56   /// @param _spender The address of the account able to transfer the tokens
57   /// @return Amount of remaining tokens allowed to spent
58   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
59 
60   event Transfer(address indexed _from, address indexed _to, uint256 _value);
61   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
62 } 
63 
64 contract SunContractToken is IERC20Token, owned{
65 
66   /* Public variables of the token */
67   string public standard = "SunContract token v1.0";
68   string public name = "SunContract";
69   string public symbol = "SNC";
70   uint8 public decimals = 18;
71   address public icoContractAddress;
72   uint256 public tokenFrozenUntilBlock;
73 
74   /* Private variables of the token */
75   uint256 supply = 0;
76   mapping (address => uint256) balances;
77   mapping (address => mapping (address => uint256)) allowances;
78   mapping (address => bool) restrictedAddresses;
79 
80   /* Events */
81   event Mint(address indexed _to, uint256 _value);
82   event Burn(address indexed _from, uint256 _value);
83   event TokenFrozen(uint256 _frozenUntilBlock, string _reason);
84 
85   /* Initializes contract and  sets restricted addresses */
86   function SunContractToken(address _icoAddress) {
87     restrictedAddresses[0x0] = true;
88     restrictedAddresses[_icoAddress] = true;
89     restrictedAddresses[address(this)] = true;
90     icoContractAddress = _icoAddress;
91   }
92 
93   /* Returns total supply of issued tokens */
94   function totalSupply() constant returns (uint256 totalSupply) {
95     return supply;
96   }
97 
98   /* Returns balance of address */
99   function balanceOf(address _owner) constant returns (uint256 balance) {
100     return balances[_owner];
101   }
102 
103   /* Transfers tokens from your address to other */
104   function transfer(address _to, uint256 _value) returns (bool success) {
105     if (block.number < tokenFrozenUntilBlock) throw;    // Throw if token is frozen
106     if (restrictedAddresses[_to]) throw;                // Throw if recipient is restricted address
107     if (balances[msg.sender] < _value) throw;           // Throw if sender has insufficient balance
108     if (balances[_to] + _value < balances[_to]) throw;  // Throw if owerflow detected
109     balances[msg.sender] -= _value;                     // Deduct senders balance
110     balances[_to] += _value;                            // Add recivers blaance 
111     Transfer(msg.sender, _to, _value);                  // Raise Transfer event
112     return true;
113   }
114 
115   /* Approve other address to spend tokens on your account */
116   function approve(address _spender, uint256 _value) returns (bool success) {
117     if (block.number < tokenFrozenUntilBlock) throw;    // Throw if token is frozen        
118     allowances[msg.sender][_spender] = _value;          // Set allowance         
119     Approval(msg.sender, _spender, _value);             // Raise Approval event         
120     return true;
121   }
122 
123   /* Approve and then communicate the approved contract in a single tx */ 
124   function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {            
125     tokenRecipient spender = tokenRecipient(_spender);              // Cast spender to tokenRecipient contract         
126     approve(_spender, _value);                                      // Set approval to contract for _value         
127     spender.receiveApproval(msg.sender, _value, this, _extraData);  // Raise method on _spender contract         
128     return true;     
129   }     
130 
131   /* A contract attempts to get the coins */
132   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {      
133     if (block.number < tokenFrozenUntilBlock) throw;    // Throw if token is frozen
134     if (restrictedAddresses[_to]) throw;                // Throw if recipient is restricted address  
135     if (balances[_from] < _value) throw;                // Throw if sender does not have enough balance     
136     if (balances[_to] + _value < balances[_to]) throw;  // Throw if overflow detected    
137     if (_value > allowances[_from][msg.sender]) throw;  // Throw if you do not have allowance       
138     balances[_from] -= _value;                          // Deduct senders balance    
139     balances[_to] += _value;                            // Add recipient blaance         
140     allowances[_from][msg.sender] -= _value;            // Deduct allowance for this address         
141     Transfer(_from, _to, _value);                       // Raise Transfer event
142     return true;     
143   }         
144 
145   /* Get the amount of allowed tokens to spend */     
146   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {         
147     return allowances[_owner][_spender];
148   }         
149 
150   /* Issue new tokens */     
151   function mintTokens(address _to, uint256 _amount) {         
152     if (msg.sender != icoContractAddress) throw;            // Only ICO address can mint tokens        
153     if (restrictedAddresses[_to]) throw;                    // Throw if user wants to send to restricted address       
154     if (balances[_to] + _amount < balances[_to]) throw;     // Check for overflows
155     supply += _amount;                                      // Update total supply
156     balances[_to] += _amount;                               // Set minted coins to target
157     Mint(_to, _amount);                                     // Create Mint event       
158     Transfer(0x0, _to, _amount);                            // Create Transfer event from 0x
159   }     
160   
161   /* Destroy tokens from owners account */
162   function burnTokens(uint256 _amount) onlyOwner {
163     if(balances[msg.sender] < _amount) throw;               // Throw if you do not have enough balance
164     if(supply < _amount) throw;                             // Throw if overflow detected
165 
166     supply -= _amount;                                      // Deduct totalSupply
167     balances[msg.sender] -= _amount;                        // Destroy coins on senders wallet
168     Burn(msg.sender, _amount);                              // Raise Burn event
169     Transfer(msg.sender, 0x0, _amount);                     // Raise transfer to 0x0
170   }
171 
172   /* Stops all token transfers in case of emergency */
173   function freezeTransfersUntil(uint256 _frozenUntilBlock, string _reason) onlyOwner {      
174     tokenFrozenUntilBlock = _frozenUntilBlock;
175     TokenFrozen(_frozenUntilBlock, _reason);
176   }
177 
178   function isRestrictedAddress(address _querryAddress) constant returns (bool answer){
179     return restrictedAddresses[_querryAddress];
180   }
181 
182   //
183   /* This part is here only for testing and will not be included into final version */
184   //
185 
186   //function changeICOAddress(address _newAddress) onlyOwner{
187   //  icoContractAddress = _newAddress;
188   //  restrictedAddresses[_newAddress] = true;   
189   //}
190 
191   //function killContract() onlyOwner{
192   //  selfdestruct(msg.sender);
193   //}
194 }