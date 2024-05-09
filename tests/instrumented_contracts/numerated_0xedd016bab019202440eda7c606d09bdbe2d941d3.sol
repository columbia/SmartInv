1 pragma solidity ^0.4.4;
2 
3 // ----------------------------------------------------------------------------
4 //
5 // Symbol      : ETR
6 // Name        : ETHERION
7 // Total supply: 15000000000
8 // Decimals    : 18
9 //
10 //
11 // (c) EHERION Limited  
12 
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
51 contract StandardToken is Token {
52 
53     function transfer(address _to, uint256 _value) returns (bool success) {
54         //Default assumes totalSupply can't be over max (2^256 - 1).
55         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
56         //Replace the if with this one instead.
57         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
58         if (balances[msg.sender] >= _value && _value > 0) {
59             balances[msg.sender] -= _value;
60             balances[_to] += _value;
61             Transfer(msg.sender, _to, _value);
62             return true;
63         } else { return false; }
64     }
65 
66     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
67         //same as above. Replace this line with the following if you want to protect against wrapping uints.
68         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
69         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
70             balances[_to] += _value;
71             balances[_from] -= _value;
72             allowed[_from][msg.sender] -= _value;
73             Transfer(_from, _to, _value);
74             return true;
75         } else { return false; }
76     }
77 
78     function balanceOf(address _owner) constant returns (uint256 balance) {
79         return balances[_owner];
80     }
81 
82     function approve(address _spender, uint256 _value) returns (bool success) {
83         allowed[msg.sender][_spender] = _value;
84         Approval(msg.sender, _spender, _value);
85         return true;
86     }
87 
88     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
89       return allowed[_owner][_spender];
90     }
91 
92     mapping (address => uint256) balances;
93     mapping (address => mapping (address => uint256)) allowed;
94     uint256 public totalSupply;
95 }
96 
97 contract ETHERION is StandardToken { // CHANGE THIS. Update the contract name.
98 
99     /* Public variables of the token */
100 
101     /*
102     NOTE:
103     The following variables are OPTIONAL vanities. One does not have to include them.
104     They allow one to customise the token contract & in no way influences the core functionality.
105     Some wallets/interfaces might not even bother to look at this information.
106     */
107     string public name;                  
108     uint8 public decimals;               
109     string public symbol;                 
110     string public version = 'H1.0'; 
111     uint256 public unitsOneEthCanBuy;     
112     uint256 public totalEthInWei;         
113     address public fundsWallet;           
114 
115     // This is a constructor function 
116     // which means the following function name has to match the contract name declared above
117     function ETHERION() {
118         balances[msg.sender] = 15000000000000000000000000000;             
119         totalSupply = 15000000000000000000000000000;                        
120         name = "ETHERION";                                   
121         decimals = 18;                                               
122         symbol = "ETR";                                             
123         unitsOneEthCanBuy = 100000000;                                    
124         fundsWallet = msg.sender;                                   
125     }
126 
127     function() payable{
128         totalEthInWei = totalEthInWei + msg.value;
129         uint256 amount = msg.value * unitsOneEthCanBuy;
130         require(balances[fundsWallet] >= amount);
131 
132         balances[fundsWallet] = balances[fundsWallet] - amount;
133         balances[msg.sender] = balances[msg.sender] + amount;
134 
135         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
136 
137         //Transfer ether to fundsWallet
138         fundsWallet.transfer(msg.value);                               
139     }
140 
141     /* Approves and then calls the receiving contract */
142     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
143         allowed[msg.sender][_spender] = _value;
144         Approval(msg.sender, _spender, _value);
145 
146         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
147         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
148         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
149         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
150         return true;
151     }
152 }