1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-09
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2019-05-31
7 */
8 
9 /**
10  * Source Code first verified at https://etherscan.io on Friday, March 8, 2019
11  (UTC) */
12 
13 pragma solidity ^0.4.12;
14 
15 contract Token {
16 
17     /// @return total amount of tokens
18     function totalSupply() constant returns (uint256 supply) {}
19 
20     /// @param _owner The address from which the balance will be retrieved
21     
22     /// @return The balance
23     function balanceOf(address _owner) constant returns (uint256 balance) {}
24 
25     /// @notice send `_value` token to `_to` from `msg.sender`
26     /// @param _to The address of the recipient
27     /// @param _value The amount of token to be transferred
28     /// @return Whether the transfer was successful or not
29     function transfer(address _to, uint256 _value) returns (bool success) {}
30 
31     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
32     /// @param _from The address of the sender
33     /// @param _to The address of the recipient
34     /// @param _value The amount of token to be transferred
35     /// @return Whether the transfer was successful or not
36     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
37 
38     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
39     /// @param _spender The address of the account able to transfer the tokens
40     /// @param _value The amount of wei to be approved for transfer
41     /// @return Whether the approval was successful or not
42     function approve(address _spender, uint256 _value) returns (bool success) {}
43 
44     /// @param _owner The address of the account owning tokens
45     /// @param _spender The address of the account able to transfer the tokens
46     /// @return Amount of remaining tokens allowed to spent
47     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
48 
49     event Transfer(address indexed _from, address indexed _to, uint256 _value);
50     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
51 
52 }
53 
54 contract StandardToken is Token {
55 
56     function transfer(address _to, uint256 _value) returns (bool success) {
57         //Default assumes totalSupply can't be over max (2^256 - 1).
58         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
59         //Replace the if with this one instead.
60         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
61         if (balances[msg.sender] >= _value && _value > 0) {
62             balances[msg.sender] -= _value;
63             balances[_to] += _value;
64             Transfer(msg.sender, _to, _value);
65             return true;
66         } else { return false; }
67     }
68 
69     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
70         //same as above. Replace this line with the following if you want to protect against wrapping uints.
71         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
72         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
73             balances[_to] += _value;
74             balances[_from] -= _value;
75             allowed[_from][msg.sender] -= _value;
76             Transfer(_from, _to, _value);
77             return true;
78         } else { return false; }
79     }
80 
81     function balanceOf(address _owner) constant returns (uint256 balance) {
82         return balances[_owner];
83     }
84 
85     function approve(address _spender, uint256 _value) returns (bool success) {
86         allowed[msg.sender][_spender] = _value;
87         Approval(msg.sender, _spender, _value);
88         return true;
89     }
90 
91     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
92       return allowed[_owner][_spender];
93     }
94 
95     mapping (address => uint256) balances;
96     mapping (address => mapping (address => uint256)) allowed;
97     uint256 public totalSupply;
98 }
99 
100 contract CentHungary is StandardToken { // CHANGE THIS. Update the contract name.
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
120     function CentHungary() {
121         balances[msg.sender] = 99999999999999999999999999999;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
122         totalSupply =          99999999999999999999999999999;                        // Update total supply (1000 for example) (CHANGE THIS)
123         name = "CentHungary";                                   // Set the name for display purposes (CHANGE THIS)
124         decimals = 2;                                               // Amount of decimals for display purposes (CHANGE THIS)
125         symbol = "CHU";                                             // Set the symbol for display purposes (CHANGE THIS)
126         unitsOneEthCanBuy = 10;                                      // Set the price of your token for the ICO (CHANGE THIS)
127         fundsWallet = msg.sender;                                    // The owner of the contract gets ETH
128     }
129 
130     function() payable{
131         totalEthInWei = totalEthInWei + msg.value;
132         uint256 amount = msg.value * unitsOneEthCanBuy;
133         (balances[fundsWallet] >= amount);
134 
135         balances[fundsWallet] = balances[fundsWallet] - amount;
136         balances[msg.sender] = balances[msg.sender] + amount;
137 
138         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
139 
140         //Transfer ether to fundsWallet
141                                       
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