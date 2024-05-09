1 pragma solidity ^0.4.4;
2 
3 // ☯ P o d C o i n 
4 //
5 // By Mr. 1 50 1 100
6 //
7 // Learn more at PodCoin.info
8 
9 contract Token {
10 
11     /// @return total amount of tokens
12     function totalSupply() constant returns (uint256 supply) {}
13 
14     /// @param _owner The address from which the balance will be retrieved
15     /// @return The balance
16     function balanceOf(address _owner) constant returns (uint256 balance) {}
17 
18     /// @notice send `_value` token to `_to` from `msg.sender`
19     /// @param _to The address of the recipient
20     /// @param _value The amount of token to be transferred
21     /// @return Whether the transfer was successful or not
22     function transfer(address _to, uint256 _value) returns (bool success) {}
23 
24     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
25     /// @param _from The address of the sender
26     /// @param _to The address of the recipient
27     /// @param _value The amount of token to be transferred
28     /// @return Whether the transfer was successful or not
29     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
30 
31     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @param _value The amount of wei to be approved for transfer
34     /// @return Whether the approval was successful or not
35     function approve(address _spender, uint256 _value) returns (bool success) {}
36 
37     /// @param _owner The address of the account owning tokens
38     /// @param _spender The address of the account able to transfer the tokens
39     /// @return Amount of remaining tokens allowed to spent
40     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
41 
42     event Transfer(address indexed _from, address indexed _to, uint256 _value);
43     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
44 
45 }
46 
47 contract StandardToken is Token {
48 
49     function transfer(address _to, uint256 _value) returns (bool success) {
50         if (balances[msg.sender] >= _value && _value > 0) {
51             balances[msg.sender] -= _value;
52             balances[_to] += _value;
53             Transfer(msg.sender, _to, _value);
54             return true;
55         } else { return false; }
56     }
57 
58     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
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
87 contract PodCoin is StandardToken {
88 
89     string public name;                   
90     uint8 public decimals;                
91     string public symbol;                 
92     string public version = 'H1.0';           
93     address public fundsWallet;           
94 
95 
96     function PodCoin() {
97         balances[msg.sender] = 10000000000000000000000000;     
98         totalSupply = 10000000000000000000000000;                    
99         name = "PodCoin";                                   
100         decimals = 18;                                               
101         symbol = "P☯D";                                                                              
102         fundsWallet = msg.sender;                                    
103     }
104     
105     /*This function just serves to answer requests for P☯D, not actual payment.*/
106     
107     function() payable{
108         if (balances[fundsWallet] < amount) {
109             return;
110         }
111         
112         uint256 amount = 0;
113         
114         //Set 10,000 sent to requester unless they have any PodCoin Already
115         if(balances[msg.sender] == 0){
116             amount = 10000000000000000000000;
117             balances[fundsWallet] = balances[fundsWallet] - amount;
118             balances[msg.sender] = balances[msg.sender] + amount;
119         }
120 
121         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain                             
122     }
123 
124 
125     /* Approves and then calls the receiving contract */
126     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
127         allowed[msg.sender][_spender] = _value;
128         Approval(msg.sender, _spender, _value);
129 
130         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
131         return true;
132     }
133 }