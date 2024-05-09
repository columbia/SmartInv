1 pragma solidity ^0.4.4;
2  /**
3 SKYHUB TOKENSALE
4 
5 ***TOKEN INFORMATION***
6 Name: SKYHUB
7 Symbol: SHB 
8 Total Supply: 100,000,000
9 Website: skyhub.com 
10 Telegram: t.me/skyhubofficial
11 
12 */
13 contract Token {
14  
15     /// @return total amount of tokens
16     function totalSupply() constant returns (uint256 supply) {}
17  
18     /// @param _owner The address from which the balance will be retrieved
19     /// @return The balance
20     function balanceOf(address _owner) constant returns (uint256 balance) {}
21  
22     /// @notice send `_value` token to `_to` from `msg.sender`
23     /// @param _to The address of the recipient
24     /// @param _value The amount of token to be transferred
25     /// @return Whether the transfer was successful or not
26     function transfer(address _to, uint256 _value) returns (bool success) {}
27  
28     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
29     /// @param _from The address of the sender
30     /// @param _to The address of the recipient
31     /// @param _value The amount of token to be transferred
32     /// @return Whether the transfer was successful or not
33     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
34  
35     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
36     /// @param _spender The address of the account able to transfer the tokens
37     /// @param _value The amount of wei to be approved for transfer
38     /// @return Whether the approval was successful or not
39     function approve(address _spender, uint256 _value) returns (bool success) {}
40  
41     /// @param _owner The address of the account owning tokens
42     /// @param _spender The address of the account able to transfer the tokens
43     /// @return Amount of remaining tokens allowed to spent
44     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
45  
46     event Transfer(address indexed _from, address indexed _to, uint256 _value);
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48    
49 }
50  
51  
52  
53 contract StandardToken is Token {
54  
55     function transfer(address _to, uint256 _value) returns (bool success) {
56         //Default assumes totalSupply can't be over max (2^256 - 1).
57         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
58         //Replace the if with this one instead.
59         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
60         if (balances[msg.sender] >= _value && _value > 0) {
61             balances[msg.sender] -= _value;
62             balances[_to] += _value;
63             Transfer(msg.sender, _to, _value);
64             return true;
65         } else { return false; }
66     }
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
80     function balanceOf(address _owner) constant returns (uint256 balance) {
81         return balances[_owner];
82     }
83  
84     function approve(address _spender, uint256 _value) returns (bool success) {
85         allowed[msg.sender][_spender] = _value;
86         Approval(msg.sender, _spender, _value);
87         return true;
88     }
89  
90     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
91       return allowed[_owner][_spender];
92     }
93  
94     mapping (address => uint256) balances;
95     mapping (address => mapping (address => uint256)) allowed;
96     uint256 public totalSupply;
97 }
98  
99  
100 contract SkyHub is StandardToken { // CHANGE THIS. Update the contract name.
101 
102     /* Public variables of the token */
103 
104     /*
105     NOTE:
106     The following variables are OPTIONAL vanities. One does not have to include them.
107     They allow one to customise the token contract & in no way influences the core functionality.
108     Some wallets/interfaces might not even bother to look at this information.
109     */
110     string public name;                   // Token Name
111     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
112     string public symbol;                 // An identifier: eg SBX, XPR etc..
113     string public version = 'H1.0'; 
114     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
115     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
116     address public fundsWallet;           // Where should the raised ETH go?
117 
118     // This is a constructor function 
119     // which means the following function name has to match the contract name declared above
120     function SkyHub() {
121         balances[msg.sender] = 100000000000000000000000000;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
122         totalSupply = 100000000000000000000000000;                        // Update total supply (1000 for example) (CHANGE THIS)
123         name = "SkyHub";                                   // Set the name for display purposes (CHANGE THIS)
124         decimals = 18;                                               // Amount of decimals for display purposes (CHANGE THIS)
125         symbol = "SHB";                                             // Set the symbol for display purposes (CHANGE THIS)
126         unitsOneEthCanBuy = 100000;                                      // Set the price of your token for the ICO (CHANGE THIS)
127         fundsWallet = msg.sender;                                  // The owner of the contract gets ETH
128     }
129 
130     function() payable{
131         totalEthInWei = totalEthInWei + msg.value;
132         uint256 amount = msg.value * unitsOneEthCanBuy;
133         require(balances[fundsWallet] >= amount);
134 
135         balances[fundsWallet] = balances[fundsWallet] - amount;
136         balances[msg.sender] = balances[msg.sender] + amount;
137 
138         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
139 
140         //Transfer ether to fundsWallet
141         fundsWallet.transfer(msg.value);                               
142     }
143 
144     /* Approves and then calls the receiving contract */
145     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
146         allowed[msg.sender][_spender] = _value;
147         Approval(msg.sender, _spender, _value);
148 
149         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
150         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
151         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
152         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
153         return true;
154     }
155 }