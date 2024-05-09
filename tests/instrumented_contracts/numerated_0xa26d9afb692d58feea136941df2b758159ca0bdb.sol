1 contract Token {
2 
3 /// @return total amount of tokens
4 function totalSupply() constant returns (uint256 supply) {}
5 
6 /// @param _owner The address from which the balance will be retrieved
7 /// @return The balance
8 function balanceOf(address _owner) constant returns (uint256 balance) {}
9 
10 /// @notice send `_value` token to `_to` from `msg.sender`
11 /// @param _to The address of the recipient
12 /// @param _value The amount of token to be transferred
13 /// @return Whether the transfer was successful or not
14 function transfer(address _to, uint256 _value) returns (bool success) {}
15 
16 /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
17 /// @param _from The address of the sender
18 /// @param _to The address of the recipient
19 /// @param _value The amount of token to be transferred
20 /// @return Whether the transfer was successful or not
21 function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
22 
23 /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
24 /// @param _spender The address of the account able to transfer the tokens
25 /// @param _value The amount of wei to be approved for transfer
26 /// @return Whether the approval was successful or not
27 function approve(address _spender, uint256 _value) returns (bool success) {}
28 
29 /// @param _owner The address of the account owning tokens
30 /// @param _spender The address of the account able to transfer the tokens
31 /// @return Amount of remaining tokens allowed to spent
32 function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
33 
34 event Transfer(address indexed _from, address indexed _to, uint256 _value);
35 event Approval(address indexed _owner, address indexed _spender, uint256 _value);
36 }
37 
38 contract StandardToken is Token {
39 
40 function transfer(address _to, uint256 _value) returns (bool success) {
41     //Default assumes totalSupply can't be over max (2^256 - 1).
42     //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
43     //Replace the if with this one instead.
44     //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
45     if (balances[msg.sender] >= _value && _value > 0) {
46         balances[msg.sender] -= _value;
47         balances[_to] += _value;
48         Transfer(msg.sender, _to, _value);
49         return true;
50     } else { return false; }
51 }
52 
53 function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
54     //same as above. Replace this line with the following if you want to protect against wrapping uints.
55     //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
56     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
57         balances[_to] += _value;
58         balances[_from] -= _value;
59         allowed[_from][msg.sender] -= _value;
60         Transfer(_from, _to, _value);
61         return true;
62     } else { return false; }
63 }
64 
65 function balanceOf(address _owner) constant returns (uint256 balance) {
66     return balances[_owner];
67 }
68 
69 function approve(address _spender, uint256 _value) returns (bool success) {
70     allowed[msg.sender][_spender] = _value;
71     Approval(msg.sender, _spender, _value);
72     return true;
73 }
74 
75 function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
76   return allowed[_owner][_spender];
77 }
78 
79 mapping (address => uint256) balances;
80 mapping (address => mapping (address => uint256)) allowed;
81 uint256 public totalSupply;
82 }
83 
84 contract InfiniteImprobabilityToken is StandardToken { // CHANGE THIS. Update the contract name.
85 
86 /* Public variables of the token */
87 
88 /*
89 NOTE:
90 The following variables are OPTIONAL vanities. One does not have to include them.
91 They allow one to customise the token contract & in no way influences the core functionality.
92 Some wallets/interfaces might not even bother to look at this information.
93 */
94 string public name;                   // Token Name
95 uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
96 string public symbol;                 // An identifier: eg SBX, XPR etc..
97 string public version = 'H1.0'; 
98 uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
99 uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
100 address public fundsWallet;           // Where should the raised ETH go?
101 
102 // This is a constructor function 
103 // which means the following function name has to match the contract name declared above
104 function InfiniteImprobabilityToken() {
105     balances[msg.sender] = 42000000000000000000000000;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
106     totalSupply = 42000000000000000000000000;                        // Update total supply (1000 for example) (CHANGE THIS)
107     name = "Infinite Improbability Token";                                   // Set the name for display purposes (CHANGE THIS)
108     decimals = 18;                                               // Amount of decimals for display purposes (CHANGE THIS)
109     symbol = "IIT";                                             // Set the symbol for display purposes (CHANGE THIS)
110     unitsOneEthCanBuy = 4200;                                      // Set the price of your token for the ICO (CHANGE THIS)
111     fundsWallet = msg.sender;                                    // The owner of the contract gets ETH
112 }
113 
114 function() payable{
115     totalEthInWei = totalEthInWei + msg.value;
116     uint256 amount = msg.value * unitsOneEthCanBuy;
117     if (balances[fundsWallet] < amount) {
118         return;
119     }
120 
121     balances[fundsWallet] = balances[fundsWallet] - amount;
122     balances[msg.sender] = balances[msg.sender] + amount;
123 
124     Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
125 
126     //Transfer ether to fundsWallet
127     fundsWallet.transfer(msg.value);                               
128 }
129 
130 /* Approves and then calls the receiving contract */
131 function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
132     allowed[msg.sender][_spender] = _value;
133     Approval(msg.sender, _spender, _value);
134 
135     //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
136     //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
137     //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
138     if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
139     return true;
140 }
141 }