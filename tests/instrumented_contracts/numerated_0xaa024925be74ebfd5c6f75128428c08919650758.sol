1 pragma solidity ^0.4.4;
2  /**
3 Ethereum Titan TOKENSALE
4 
5 ***TOKEN INFORMATION***
6 Name: EthereumTitan
7 Symbol: ETT 
8 Total Supply: 1,000,000,000
9 
10 Prices as follows
11 
12 0.001 ETH = 50000
13 0.01 ETH = 50,000
14 0.1 ETH = 500,000 + 25% Bonus
15 1 ETH = 5,000,000 + 50% Bonus
16 
17 */
18 contract Token {
19  
20     /// @return total amount of tokens
21     function totalSupply() constant returns (uint256 supply) {}
22  
23     /// @param _owner The address from which the balance will be retrieved
24     /// @return The balance
25     function balanceOf(address _owner) constant returns (uint256 balance) {}
26  
27     /// @notice send `_value` token to `_to` from `msg.sender`
28     /// @param _to The address of the recipient
29     /// @param _value The amount of token to be transferred
30     /// @return Whether the transfer was successful or not
31     function transfer(address _to, uint256 _value) returns (bool success) {}
32  
33     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
34     /// @param _from The address of the sender
35     /// @param _to The address of the recipient
36     /// @param _value The amount of token to be transferred
37     /// @return Whether the transfer was successful or not
38     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
39  
40     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
41     /// @param _spender The address of the account able to transfer the tokens
42     /// @param _value The amount of wei to be approved for transfer
43     /// @return Whether the approval was successful or not
44     function approve(address _spender, uint256 _value) returns (bool success) {}
45  
46     /// @param _owner The address of the account owning tokens
47     /// @param _spender The address of the account able to transfer the tokens
48     /// @return Amount of remaining tokens allowed to spent
49     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
50  
51     event Transfer(address indexed _from, address indexed _to, uint256 _value);
52     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
53    
54 }
55  
56  
57  
58 contract StandardToken is Token {
59  
60     function transfer(address _to, uint256 _value) returns (bool success) {
61         //Default assumes totalSupply can't be over max (2^256 - 1).
62         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
63         //Replace the if with this one instead.
64         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
65         if (balances[msg.sender] >= _value && _value > 0) {
66             balances[msg.sender] -= _value;
67             balances[_to] += _value;
68             Transfer(msg.sender, _to, _value);
69             return true;
70         } else { return false; }
71     }
72  
73     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
74         //same as above. Replace this line with the following if you want to protect against wrapping uints.
75         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
76         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
77             balances[_to] += _value;
78             balances[_from] -= _value;
79             allowed[_from][msg.sender] -= _value;
80             Transfer(_from, _to, _value);
81             return true;
82         } else { return false; }
83     }
84  
85     function balanceOf(address _owner) constant returns (uint256 balance) {
86         return balances[_owner];
87     }
88  
89     function approve(address _spender, uint256 _value) returns (bool success) {
90         allowed[msg.sender][_spender] = _value;
91         Approval(msg.sender, _spender, _value);
92         return true;
93     }
94  
95     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
96       return allowed[_owner][_spender];
97     }
98  
99     mapping (address => uint256) balances;
100     mapping (address => mapping (address => uint256)) allowed;
101     uint256 public totalSupply;
102 }
103  
104  
105 contract EthereumTitan is StandardToken { // CHANGE THIS. Update the contract name.
106 
107     /* Public variables of the token */
108 
109     /*
110     NOTE:
111     The following variables are OPTIONAL vanities. One does not have to include them.
112     They allow one to customise the token contract & in no way influences the core functionality.
113     Some wallets/interfaces might not even bother to look at this information.
114     */
115     string public name;                   // Token Name
116     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
117     string public symbol;                 // An identifier: eg SBX, XPR etc..
118     string public version = 'H1.0'; 
119     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
120     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
121     address public fundsWallet;           // Where should the raised ETH go?
122 
123     // This is a constructor function 
124     // which means the following function name has to match the contract name declared above
125     function EthereumTitan() {
126         balances[msg.sender] = 1000000000000000000000000000;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
127         totalSupply = 1000000000000000000000000000;                        // Update total supply (1000 for example) (CHANGE THIS)
128         name = "EthereumTitan";                                   // Set the name for display purposes (CHANGE THIS)
129         decimals = 8;                                               // Amount of decimals for display purposes (CHANGE THIS)
130         symbol = "ETT";                                             // Set the symbol for display purposes (CHANGE THIS)
131         unitsOneEthCanBuy = 5000000;                                      // Set the price of your token for the ICO (CHANGE THIS)
132         fundsWallet = msg.sender;                                  // The owner of the contract gets ETH
133     }
134 
135     function() payable{
136         totalEthInWei = totalEthInWei + msg.value;
137         uint256 amount = msg.value * unitsOneEthCanBuy;
138         require(balances[fundsWallet] >= amount);
139 
140         balances[fundsWallet] = balances[fundsWallet] - amount;
141         balances[msg.sender] = balances[msg.sender] + amount;
142 
143         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
144 
145         //Transfer ether to fundsWallet
146         fundsWallet.transfer(msg.value);                               
147     }
148 
149     /* Approves and then calls the receiving contract */
150     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
151         allowed[msg.sender][_spender] = _value;
152         Approval(msg.sender, _spender, _value);
153 
154         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
155         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
156         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
157         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
158         return true;
159     }
160 }