1 pragma solidity ^0.4.25;
2 
3 contract Token {
4 
5     /// @return total amount of tokens
6     function totalSupply() constant returns (uint256 supply) {}
7 
8     /// @param _owner The address from which the balance will be retrieved
9     /// @return The balance
10     function balanceOf(address _owner) constant returns (uint256 balance) {}
11 
12     /// @notice send _value token to _to from msg.sender
13     /// @param _to The address of the recipient
14     /// @param _value The amount of token to be transferred
15     /// @return Whether the transfer was successful or not
16     function transfer(address _to, uint256 _value) returns (bool success) {}
17 
18     /// @notice send _value token to _to from _from on the condition it is approved by _from
19     /// @param _from The address of the sender
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
24 
25     /// @notice msg.sender approves _addr to spend _value tokens
26     /// @param _spender The address of the account able to transfer the tokens
27     /// @param _value The amount of wei to be approved for transfer
28     /// @return Whether the approval was successful or not
29     function approve(address _spender, uint256 _value) returns (bool success) {}
30 
31     /// @param _owner The address of the account owning tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @return Amount of remaining tokens allowed to spent
34     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
35 
36     event Transfer(address indexed _from, address indexed _to, uint256 _value);
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38 
39 }
40 
41 contract StandardToken is Token {
42 
43     function transfer(address _to, uint256 _value) returns (bool success) {
44     
45         if (balances[msg.sender] >= _value && _value > 0) {
46             balances[msg.sender] -= _value;
47             balances[_to] += _value;
48             Transfer(msg.sender, _to, _value);
49             return true;
50         } else { return false; }
51     }
52 
53     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
54      
55         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
56             balances[_to] += _value;
57             balances[_from] -= _value;
58             allowed[_from][msg.sender] -= _value;
59             Transfer(_from, _to, _value);
60             return true;
61         } else { return false; }
62     }
63 
64     function balanceOf(address _owner) constant returns (uint256 balance) {
65         return balances[_owner];
66     }
67 
68     function approve(address _spender, uint256 _value) returns (bool success) {
69         allowed[msg.sender][_spender] = _value;
70         Approval(msg.sender, _spender, _value);
71         return true;
72     }
73 
74     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
75       return allowed[_owner][_spender];
76     }
77 
78     mapping (address => uint256) balances;
79     mapping (address => mapping (address => uint256)) allowed;
80     uint256 public totalSupply;
81 }
82 
83 contract DiamondCEX is StandardToken { 
84 
85     /* Public variables of the token */
86 
87     /*
88     NOTE:
89     The following variables are OPTIONAL vanities. One does not have to include them.
90     They allow one to customise the token contract & in no way influences the core functionality.
91     Some wallets/interfaces might not even bother to look at this information.
92     */
93     string public name;                  
94     uint8 public decimals;                
95     string public symbol;                 
96     string public version = 'DCEX1.0'; 
97     uint256 public unitsOneEthCanBuy;     
98     uint256 public totalEthInWei;         
99     address public fundsWallet;
100     
101     function DiamondCEX() {
102         balances[msg.sender] = 1111111100000000;               
103         totalSupply = 1111111100000000;
104         name = "Diamond CEX";
105         decimals = 8;                                               
106         symbol = "DCEX";                                             
107         unitsOneEthCanBuy = 0;          //0% bonus= OneEth//                           
108         fundsWallet = msg.sender;                                    
109     }
110 
111     function() payable{
112         totalEthInWei = totalEthInWei + msg.value;
113         uint256 amount = msg.value * unitsOneEthCanBuy;
114         require(balances[fundsWallet] >= amount);
115 
116         balances[fundsWallet] = balances[fundsWallet] - amount;
117         balances[msg.sender] = balances[msg.sender] + amount;
118 
119         Transfer(fundsWallet, msg.sender, amount); 
120 
121         fundsWallet.transfer(msg.value);                               
122     }
123 
124     /* Approves and then calls the receiving contract */
125     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
126         allowed[msg.sender][_spender] = _value;
127         Approval(msg.sender, _spender, _value);
128 
129        
130         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
131         return true;
132     }
133 }