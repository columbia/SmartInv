1 pragma solidity ^0.4.17;
2 
3 contract owned {
4 
5     address public owner;
6 
7     function owned() {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         if (msg.sender != owner) throw;
13         _;
14     }
15 
16     function transferOwnership(address newOwner) onlyOwner {
17         owner = newOwner;
18     }
19 }
20 
21 contract tokenRecipient { 
22   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
23 } 
24 
25 contract IERC20Token {
26 
27   // Get the total token supply
28   function totalSupply() constant returns (uint256 totalSupply);
29 
30   // Get the account balance of another account with address _owner
31   function balanceOf(address _owner) constant returns (uint256 balance) {}
32 
33   // Send _value amount of tokens to address _to
34   function transfer(address _to, uint256 _value) returns (bool success) {}
35 
36   // Send _value amount of tokens from address _from to address _to
37   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
38 
39   // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
40   // If this function is called again it overwrites the current allowance with _value.
41   // this function is required for some DEX functionality
42   function approve(address _spender, uint256 _value) returns (bool success) {}
43 
44   // Returns the amount which _spender is still allowed to withdraw from _owner
45   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
46 
47   // Triggered when tokens are transferred
48   event Transfer(address indexed _from, address indexed _to, uint256 _value);
49   
50   // Triggered whenever approve(address _spender, uint256 _value) is called
51   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
52 } 
53 
54 contract ValusToken is IERC20Token, owned{
55 
56   /* Public variables of the token */
57   string public standard = "VALUS token v1.0";
58   string public name = "VALUS";
59   string public symbol = "VLS";
60   uint8 public decimals = 18;
61   address public crowdsaleContractAddress;
62   uint256 public tokenFrozenUntilBlock;
63 
64   /* Private variables of the token */
65   uint256 supply = 0;
66   mapping (address => uint256) balances;
67   mapping (address => mapping (address => uint256)) allowances;
68   mapping (address => bool) restrictedAddresses;
69 
70   /* Events */
71   event Mint(address indexed _to, uint256 _value);
72   event Burn(address indexed _from, uint256 _value);
73   event TokenFrozen(uint256 _frozenUntilBlock, string _reason);
74 
75   /* Initializes contract and  sets restricted addresses */
76   function ValusToken() {
77     restrictedAddresses[0x0] = true;
78     restrictedAddresses[0x8F8e5e6515c3e6088c327257bDcF2c973B1530ad] = true;
79     restrictedAddresses[address(this)] = true;
80     crowdsaleContractAddress = 0x8F8e5e6515c3e6088c327257bDcF2c973B1530ad;
81   }
82 
83   /* Returns total supply of issued tokens */
84   function totalSupply() constant returns (uint256 totalSupply) {
85     return supply;
86   }
87 
88   /* Returns balance of address */
89   function balanceOf(address _owner) constant returns (uint256 balance) {
90     return balances[_owner];
91   }
92 
93   /* Transfers tokens from your address to other */
94   function transfer(address _to, uint256 _value) returns (bool success) {
95     if (block.number < tokenFrozenUntilBlock) throw;    // Throw if token is frozen
96     if (restrictedAddresses[_to]) throw;                // Throw if recipient is restricted address
97     if (balances[msg.sender] < _value) throw;           // Throw if sender has insufficient balance
98     if (balances[_to] + _value < balances[_to]) throw;  // Throw if owerflow detected
99     balances[msg.sender] -= _value;                     // Deduct senders balance
100     balances[_to] += _value;                            // Add recivers blaance 
101     Transfer(msg.sender, _to, _value);                  // Raise Transfer event
102     return true;
103   }
104 
105   /* Approve other address to spend tokens on your account */
106   function approve(address _spender, uint256 _value) returns (bool success) {
107     if (block.number < tokenFrozenUntilBlock) throw;    // Throw if token is frozen        
108     allowances[msg.sender][_spender] = _value;          // Set allowance         
109     Approval(msg.sender, _spender, _value);             // Raise Approval event         
110     return true;
111   }
112 
113   /* Approve and then communicate the approved contract in a single tx */ 
114   function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {            
115     tokenRecipient spender = tokenRecipient(_spender);              // Cast spender to tokenRecipient contract         
116     approve(_spender, _value);                                      // Set approval to contract for _value         
117     spender.receiveApproval(msg.sender, _value, this, _extraData);  // Raise method on _spender contract         
118     return true;     
119   }     
120 
121   /* A contract attempts to get the coins */
122   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {      
123     if (block.number < tokenFrozenUntilBlock) throw;    // Throw if token is frozen
124     if (restrictedAddresses[_to]) throw;                // Throw if recipient is restricted address  
125     if (balances[_from] < _value) throw;                // Throw if sender does not have enough balance     
126     if (balances[_to] + _value < balances[_to]) throw;  // Throw if overflow detected    
127     if (_value > allowances[_from][msg.sender]) throw;  // Throw if you do not have allowance       
128     balances[_from] -= _value;                          // Deduct senders balance    
129     balances[_to] += _value;                            // Add recipient blaance         
130     allowances[_from][msg.sender] -= _value;            // Deduct allowance for this address         
131     Transfer(_from, _to, _value);                       // Raise Transfer event
132     return true;     
133   }         
134 
135   /* Get the amount of allowed tokens to spend */     
136   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {         
137     return allowances[_owner][_spender];
138   }         
139 
140   /* Issue new tokens */     
141   function mintTokens(address _to, uint256 _amount) {         
142     if (msg.sender != crowdsaleContractAddress) throw;            // Only Crowdsale address can mint tokens        
143     if (restrictedAddresses[_to]) throw;                    // Throw if user wants to send to restricted address       
144     if (balances[_to] + _amount < balances[_to]) throw;     // Check for overflows
145     supply += _amount;                                      // Update total supply
146     balances[_to] += _amount;                               // Set minted coins to target
147     Mint(_to, _amount);                                     // Create Mint event       
148     Transfer(0x0, _to, _amount);                            // Create Transfer event from 0x
149   }     
150 
151   /* Stops all token transfers in case of emergency */
152   function freezeTransfersUntil(uint256 _frozenUntilBlock, string _reason) onlyOwner {      
153     tokenFrozenUntilBlock = _frozenUntilBlock;
154     TokenFrozen(_frozenUntilBlock, _reason);
155   }
156 
157   function isRestrictedAddress(address _querryAddress) constant returns (bool answer){
158     return restrictedAddresses[_querryAddress];
159   }
160 }