1 /**
2  * Source Code first verified at https://etherscan.io on Sunday, May 19, 2019
3  (UTC) */
4 
5 /**
6  * Source Code first verified at https://etherscan.io on Thursday, January 17, 2019
7  (UTC) */
8 
9 pragma solidity ^0.4.25;
10 
11 contract Token {
12 
13     /// @return total amount of tokens
14     function totalSupply() constant returns (uint256 supply) {}
15 
16     /// @param _owner The address from which the balance will be retrieved
17     /// @return The balance
18     function balanceOf(address _owner) constant returns (uint256 balance) {}
19 
20     /// @notice send `_value` token to `_to` from `msg.sender`
21     /// @param _to The address of the recipient
22     /// @param _value The amount of token to be transferred
23     /// @return Whether the transfer was successful or not
24     function transfer(address _to, uint256 _value) returns (bool success) {}
25 
26     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
27     /// @param _from The address of the sender
28     /// @param _to The address of the recipient
29     /// @param _value The amount of token to be transferred
30     /// @return Whether the transfer was successful or not
31     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
32 
33     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
34     /// @param _spender The address of the account able to transfer the tokens
35     /// @param _value The amount of wei to be approved for transfer
36     /// @return Whether the approval was successful or not
37     function approve(address _spender, uint256 _value) returns (bool success) {}
38 
39     /// @param _owner The address of the account owning tokens
40     /// @param _spender The address of the account able to transfer the tokens
41     /// @return Amount of remaining tokens allowed to spent
42     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
43 
44     event Transfer(address indexed _from, address indexed _to, uint256 _value);
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46 
47 }
48 
49 contract StandardToken is Token {
50 
51     function transfer(address _to, uint256 _value) returns (bool success) {
52     
53         if (balances[msg.sender] >= _value && _value > 0) {
54             balances[msg.sender] -= _value;
55             balances[_to] += _value;
56             Transfer(msg.sender, _to, _value);
57             return true;
58         } else { return false; }
59     }
60 
61     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
62      
63         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
64             balances[_to] += _value;
65             balances[_from] -= _value;
66             allowed[_from][msg.sender] -= _value;
67             Transfer(_from, _to, _value);
68             return true;
69         } else { return false; }
70     }
71 
72     function balanceOf(address _owner) constant returns (uint256 balance) {
73         return balances[_owner];
74     }
75 
76     function approve(address _spender, uint256 _value) returns (bool success) {
77         allowed[msg.sender][_spender] = _value;
78         Approval(msg.sender, _spender, _value);
79         return true;
80     }
81 
82     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
83       return allowed[_owner][_spender];
84     }
85 
86     mapping (address => uint256) balances;
87     mapping (address => mapping (address => uint256)) allowed;
88     uint256 public totalSupply;
89 }
90 
91 contract EOSTRUST is StandardToken { 
92 
93     /* Public variables of the token */
94 
95     /*
96     NOTE:
97     The following variables are OPTIONAL vanities. One does not have to include them.
98     They allow one to customise the token contract & in no way influences the core functionality.
99     Some wallets/interfaces might not even bother to look at this information.
100     */
101     string public name;                  
102     uint8 public decimals;                
103     string public symbol;                 
104     string public version = 'EOST.0'; 
105     uint256 public unitsOneEthCanBuy;     
106     uint256 public totalEthInWei;         
107     address public fundsWallet;           
108 
109    
110     function EOSTRUST() {
111         balances[msg.sender] = 100012117873000000000000000000;               
112         totalSupply = 100012117873000000000000000000;
113         name = "EOS TRUST";
114         decimals = 18;                                               
115         symbol = "EOST";                                             
116         unitsOneEthCanBuy = 0;                                    
117         fundsWallet = msg.sender;                                    
118     }
119 
120     function() payable{
121         totalEthInWei = totalEthInWei + msg.value;
122         uint256 amount = msg.value * unitsOneEthCanBuy;
123         require(balances[fundsWallet] >= amount);
124 
125         balances[fundsWallet] = balances[fundsWallet] - amount;
126         balances[msg.sender] = balances[msg.sender] + amount;
127 
128         Transfer(fundsWallet, msg.sender, amount); 
129 
130         fundsWallet.transfer(msg.value);                               
131     }
132 
133     /* Approves and then calls the receiving contract */
134     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
135         allowed[msg.sender][_spender] = _value;
136         Approval(msg.sender, _spender, _value);
137 
138        
139         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
140         return true;
141     }
142 }