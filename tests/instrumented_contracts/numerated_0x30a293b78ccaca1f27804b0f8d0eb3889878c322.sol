1 pragma solidity ^0.4.4;
2 
3 
4 contract Token {
5 
6 
7     /// @return total amount of tokens
8     function totalSupply() constant returns (uint256 supply) {}
9 
10 
11     /// @param _owner The address from which the balance will be retrieved
12     /// @return The balance
13     function balanceOf(address _owner) constant returns (uint256 balance) {}
14 
15 
16     /// @notice send `_value` token to `_to` from `msg.sender`
17     /// @param _to The address of the recipient
18     /// @param _value The amount of token to be transferred
19     /// @return Whether the transfer was successful or not
20     function transfer(address _to, uint256 _value) returns (bool success) {}
21 
22 
23     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
24     /// @param _from The address of the sender
25     /// @param _to The address of the recipient
26     /// @param _value The amount of token to be transferred
27     /// @return Whether the transfer was successful or not
28     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
29 
30 
31     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @param _value The amount of wei to be approved for transfer
34     /// @return Whether the approval was successful or not
35     function approve(address _spender, uint256 _value) returns (bool success) {}
36 
37 
38     /// @param _owner The address of the account owning tokens
39     /// @param _spender The address of the account able to transfer the tokens
40     /// @return Amount of remaining tokens allowed to spent
41     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
42 
43 
44     event Transfer(address indexed _from, address indexed _to, uint256 _value);
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46 
47 
48 }
49 
50 
51 contract StandardToken is Token {
52 
53 
54     function transfer(address _to, uint256 _value) returns (bool success) {
55         //Default assumes totalSupply can't be over max (2^256 - 1).
56         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
57         //Replace the if with this one instead.
58         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
59         if (balances[msg.sender] >= _value && _value > 0) {
60             balances[msg.sender] -= _value;
61             balances[_to] += _value;
62             Transfer(msg.sender, _to, _value);
63             return true;
64         } else { return false; }
65     }
66 
67 
68     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
69         //same as above. Replace this line with the following if you want to protect against wrapping uints.
70         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
71         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
72             balances[_to] += _value;
73             balances[_from] -= _value;
74             allowed[_from][msg.sender] -= _value;
75             Transfer(_from, _to, _value);
76             return true;
77         } else { return false; }
78     }
79 
80 
81     function balanceOf(address _owner) constant returns (uint256 balance) {
82         return balances[_owner];
83     }
84 
85 
86     function approve(address _spender, uint256 _value) returns (bool success) {
87         allowed[msg.sender][_spender] = _value;
88         Approval(msg.sender, _spender, _value);
89         return true;
90     }
91 
92 
93     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
94       return allowed[_owner][_spender];
95     }
96 
97 
98     mapping (address => uint256) balances;
99     mapping (address => mapping (address => uint256)) allowed;
100     uint256 public totalSupply;
101 }
102 
103 
104 contract NKN  is StandardToken { // CHANGE THIS. Update the contract name.
105 
106 
107     /* Public variables of the token */
108 
109 
110     /*
111     NOTE:
112     The following variables are OPTIONAL vanities. One does not have to include them.
113     They allow one to customise the token contract & in no way influences the core functionality.
114     Some wallets/interfaces might not even bother to look at this information.
115     */
116     string public name;                   // Token Name
117     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
118     string public symbol;                 // An identifier: eg SBX, XPR etc..
119     string public version = 'H1.0'; 
120     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
121     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
122     address public fundsWallet;           // Where should the raised ETH go?
123 
124 
125     // This is a constructor function 
126     // which means the following function name has to match the contract name declared above
127     function NKN() {
128         balances[msg.sender] = 1000000000 ;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
129         totalSupply = 1000000000000000000000000000;                        // Update total supply (1000 for example) (CHANGE THIS)
130         name = "NKN";                                   // Set the name for display purposes (CHANGE THIS)
131         decimals = 18;                                               // Amount of decimals for display purposes (CHANGE THIS)
132         symbol = "NKN";                                           // Set the symbol for display purposes (CHANGE THIS)
133         unitsOneEthCanBuy =6100;                                      // Set the price of your token for the ICO (CHANGE THIS)
134         fundsWallet = msg.sender;                                    // The owner of the contract gets ETH
135     }
136 
137 
138     function() payable{
139         totalEthInWei = totalEthInWei + msg.value;
140         uint256 amount = msg.value * unitsOneEthCanBuy;
141         require(balances[fundsWallet] >= amount);
142 
143 
144         balances[fundsWallet] = balances[fundsWallet] - amount;
145         balances[msg.sender] = balances[msg.sender] + amount;
146 
147 
148         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
149 
150 
151         //Transfer ether to fundsWallet
152         fundsWallet.transfer(msg.value);                               
153     }
154 
155 
156     /* Approves and then calls the receiving contract */
157     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
158         allowed[msg.sender][_spender] = _value;
159         Approval(msg.sender, _spender, _value);
160 
161 
162         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
163         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
164         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
165         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
166         return true;
167     }
168 }