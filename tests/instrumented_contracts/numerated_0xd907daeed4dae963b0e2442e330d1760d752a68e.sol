1 /**
2  *Submitted for verification at Etherscan.io on 2018-12-03
3 */
4 
5 pragma solidity ^0.4.25;
6 
7 contract Token {
8 
9     /// @return total amount of tokens
10     function totalSupply() constant returns (uint256 supply) {}
11 
12     /// @param _owner The address from which the balance will be retrieved
13     /// @return The balance
14     function balanceOf(address _owner) constant returns (uint256 balance) {}
15 
16     /// @notice send `_value` token to `_to` from `msg.sender`
17     /// @param _to The address of the recipient
18     /// @param _value The amount of token to be transferred
19     /// @return Whether the transfer was successful or not
20     function transfer(address _to, uint256 _value) returns (bool success) {}
21 
22     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
23     /// @param _from The address of the sender
24     /// @param _to The address of the recipient
25     /// @param _value The amount of token to be transferred
26     /// @return Whether the transfer was successful or not
27     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
28 
29     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
30     /// @param _spender The address of the account able to transfer the tokens
31     /// @param _value The amount of wei to be approved for transfer
32     /// @return Whether the approval was successful or not
33     function approve(address _spender, uint256 _value) returns (bool success) {}
34 
35     /// @param _owner The address of the account owning tokens
36     /// @param _spender The address of the account able to transfer the tokens
37     /// @return Amount of remaining tokens allowed to spent
38     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
39 
40     event Transfer(address indexed _from, address indexed _to, uint256 _value);
41     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
42 
43 }
44 
45 contract StandardToken is Token {
46 
47     function transfer(address _to, uint256 _value) returns (bool success) {
48     
49         if (balances[msg.sender] >= _value && _value > 0) {
50             balances[msg.sender] -= _value;
51             balances[_to] += _value;
52             Transfer(msg.sender, _to, _value);
53             return true;
54         } else { return false; }
55     }
56 
57     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
58      
59         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
60             balances[_to] += _value;
61             balances[_from] -= _value;
62             allowed[_from][msg.sender] -= _value;
63             Transfer(_from, _to, _value);
64             return true;
65         } else { return false; }
66     }
67 
68     function balanceOf(address _owner) constant returns (uint256 balance) {
69         return balances[_owner];
70     }
71 
72     function approve(address _spender, uint256 _value) returns (bool success) {
73         allowed[msg.sender][_spender] = _value;
74         Approval(msg.sender, _spender, _value);
75         return true;
76     }
77 
78     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
79       return allowed[_owner][_spender];
80     }
81 
82     mapping (address => uint256) balances;
83     mapping (address => mapping (address => uint256)) allowed;
84     uint256 public totalSupply;
85 }
86 
87 contract SEEDOFLOVE is StandardToken { 
88 
89     /* Public variables of the token */
90 
91     /*
92     NOTE:
93     The following variables are OPTIONAL vanities. One does not have to include them.
94     They allow one to customise the token contract & in no way influences the core functionality.
95     Some wallets/interfaces might not even bother to look at this information.
96     */
97     string public name;                  
98     uint8 public decimals;                
99     string public symbol;                 
100     string public version = 'SEOL1.0'; 
101     uint256 public unitsOneEthCanBuy;     
102     uint256 public totalEthInWei;         
103     address public fundsWallet;           
104 
105    
106     function SEEDOFLOVE() {
107         balances[msg.sender] = 1855000000000000000000000000;               
108         totalSupply = 1855000000000000000000000000;
109         name = "SEEDOFLOVE";
110         decimals = 18;                                               
111         symbol = "SEOL";                                             
112         unitsOneEthCanBuy = 54000;          //5% bonus= OneEth//                           
113         fundsWallet = msg.sender;                                    
114     }
115 
116     function() payable{
117         totalEthInWei = totalEthInWei + msg.value;
118         uint256 amount = msg.value * unitsOneEthCanBuy;
119         require(balances[fundsWallet] >= amount);
120 
121         balances[fundsWallet] = balances[fundsWallet] - amount;
122         balances[msg.sender] = balances[msg.sender] + amount;
123 
124         Transfer(fundsWallet, msg.sender, amount); 
125 
126         fundsWallet.transfer(msg.value);                               
127     }
128 
129     /* Approves and then calls the receiving contract */
130     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
131         allowed[msg.sender][_spender] = _value;
132         Approval(msg.sender, _spender, _value);
133 
134        
135         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
136         return true;
137     }
138 }