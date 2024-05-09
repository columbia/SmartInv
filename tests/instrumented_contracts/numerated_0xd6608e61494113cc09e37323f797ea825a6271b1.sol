1 pragma solidity ^0.4.4;
2 
3     /*
4     Ẓ is a project by Carlo Zanni. 2018 - http://zanni.org
5     */
6     
7     /*
8     This is an artwork. Buy at your own risk.
9     No warranties of any type are provided.
10     */
11     
12     /*
13     When the price is the artwork,
14     the artist becomes the unit of currency.
15     Then the rats come and eat them all.
16     */
17 
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
56 contract StandardToken is Token {
57 
58     function transfer(address _to, uint256 _value) returns (bool success) {
59         //Default assumes totalSupply can't be over max (2^256 - 1).
60         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
61         //Replace the if with this one instead.
62         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
63         if (balances[msg.sender] >= _value && _value > 0) {
64             balances[msg.sender] -= _value;
65             balances[_to] += _value;
66             Transfer(msg.sender, _to, _value);
67             return true;
68         } else { return false; }
69     }
70 
71     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
72         //same as above. Replace this line with the following if you want to protect against wrapping uints.
73         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
74         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
75             balances[_to] += _value;
76             balances[_from] -= _value;
77             allowed[_from][msg.sender] -= _value;
78             Transfer(_from, _to, _value);
79             return true;
80         } else { return false; }
81     }
82 
83     function balanceOf(address _owner) constant returns (uint256 balance) {
84         return balances[_owner];
85     }
86 
87     function approve(address _spender, uint256 _value) returns (bool success) {
88         allowed[msg.sender][_spender] = _value;
89         Approval(msg.sender, _spender, _value);
90         return true;
91     }
92 
93     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
94       return allowed[_owner][_spender];
95     }
96 
97     mapping (address => uint256) balances;
98     mapping (address => mapping (address => uint256)) allowed;
99     uint256 public totalSupply;
100 }
101 
102 contract ZANNI is StandardToken { // Update the contract name.
103 
104     /* Public variables of the token */
105 
106     /*
107     NOTE:
108     The following variables are OPTIONAL vanities. One does not have to include them.
109     They allow one to customise the token contract & in no way influences the core functionality.
110     Some wallets/interfaces might not even bother to look at this information.
111     */
112     string public name;                   // Token Name
113     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
114     string public symbol;                 // An identifier: eg SBX, XPR etc..
115     string public version = 'H1.0'; 
116     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
117     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH. We'll store the total ETH raised via our ICO here.  
118     address public fundsWallet;           // Where should the raised ETH go?
119 
120     // This is a constructor function 
121     // which means the following function name has to match the contract name declared above
122     function ZANNI() {
123         balances[msg.sender] = 1000000000000000000000;               // Give the creator all initial tokens.
124         totalSupply = 1000000000000000000000;                        // Update total supply 
125         name = "ZANNI";                                              // The name for display purposes 
126         decimals = 18;                                               // Amount of decimals for display purposes 
127         symbol = "ZANNI";                                            // Symbol for display purposes 
128         unitsOneEthCanBuy = 10;                                      // The price of your token 
129         fundsWallet = msg.sender;                                    // The owner of the contract gets ETH
130     }
131 
132     function() payable{
133         totalEthInWei = totalEthInWei + msg.value;
134         uint256 amount = msg.value * unitsOneEthCanBuy;
135         if (balances[fundsWallet] < amount) {
136             return;
137         }
138 
139         balances[fundsWallet] = balances[fundsWallet] - amount;
140         balances[msg.sender] = balances[msg.sender] + amount;
141 
142         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
143 
144         //Transfer ether to fundsWallet
145         fundsWallet.transfer(msg.value);                               
146     }
147 
148     /* Approves and then calls the receiving contract */
149     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
150         allowed[msg.sender][_spender] = _value;
151         Approval(msg.sender, _spender, _value);
152 
153         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
154         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
155         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
156         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
157         return true;
158     }
159 }