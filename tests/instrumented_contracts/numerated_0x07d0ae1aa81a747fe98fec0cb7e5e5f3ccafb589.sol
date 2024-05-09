1 pragma solidity ^0.4.18;
2 
3 /* -------------- GIFO  ISSUE ----------
4 createdate : 2019.06 
5 Token name : Gene InFOrmation
6 Symbol name : GIFO
7 ISSUED BY GENE INFORMATION FABRIC 
8 ----------------------------------------------------------*/
9 
10 contract Token {
11 
12 
13     function totalSupply() constant returns (uint256 supply) {}
14 
15     function balanceOf(address _owner) constant returns (uint256 balance) {}
16 
17 
18     function transfer(address _to, uint256 _value) returns (bool success) {}
19 
20 
21     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
22 
23  
24     function approve(address _spender, uint256 _value) returns (bool success) {}
25 
26 
27     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
28 
29     event Transfer(address indexed _from, address indexed _to, uint256 _value);
30     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
31 
32 }
33 
34 contract StandardToken is Token {
35 
36     function transfer(address _to, uint256 _value) returns (bool success) {
37         //Default assumes totalSupply can't be over max (2^256 - 1).
38         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
39         //Replace the if with this one instead.
40         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
41         if (balances[msg.sender] >= _value && _value > 0) {
42             balances[msg.sender] -= _value;
43             balances[_to] += _value;
44             Transfer(msg.sender, _to, _value);
45             return true;
46         } else { return false; }
47     }
48 
49     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
50         //same as above. Replace this line with the following if you want to protect against wrapping uints.
51         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
52         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
53             balances[_to] += _value;
54             balances[_from] -= _value;
55             allowed[_from][msg.sender] -= _value;
56             Transfer(_from, _to, _value);
57             return true;
58         } else { return false; }
59     }
60 
61     function balanceOf(address _owner) constant returns (uint256 balance) {
62         return balances[_owner];
63     }
64 
65     function approve(address _spender, uint256 _value) returns (bool success) {
66         allowed[msg.sender][_spender] = _value;
67         Approval(msg.sender, _spender, _value);
68         return true;
69     }
70 
71     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
72       return allowed[_owner][_spender];
73     }
74 
75     mapping (address => uint256) balances;
76     mapping (address => mapping (address => uint256)) allowed;
77     uint256 public totalSupply;
78 }
79 
80 contract GeneInFOrmation  is StandardToken { //  **the contract name.
81 
82     /* Public variables of the token */
83 
84     /*
85     NOTE:
86     The following variables are choice vanities. One does not have to include them.
87     */
88     string public name;                   // Token Name 
89     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
90     string public symbol;                 // An identifier: eg SBX, XPR etc..
91     string public version = 'C1.0'; 
92     uint256 public unitsOneEthCanBuy;     
93     uint256 public totalEthInWei;         
94     address public fundsWallet;           
95 
96     // This is a constructor function 
97     // which means the following function name has to match the contract name declared above
98 
99     function GeneInFOrmation() {                                      
100         balances[msg.sender] = 10000000000000000000000000000;      
101         totalSupply = 10000000000000000000000000000;     
102         name = "GeneInFOrmation";                              
103         decimals = 18;                                  
104         symbol = "GIFO";                                 
105         unitsOneEthCanBuy = 10;                         
106         fundsWallet = msg.sender;                       
107     }
108 
109     function() payable{
110         totalEthInWei = totalEthInWei + msg.value;
111         uint256 amount = msg.value * unitsOneEthCanBuy;
112         require(balances[fundsWallet] >= amount);
113 
114         balances[fundsWallet] = balances[fundsWallet] - amount;
115         balances[msg.sender] = balances[msg.sender] + amount;
116 
117         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
118 
119         //Transfer ether to fundsWallet
120         fundsWallet.transfer(msg.value);                               
121     }
122 
123     /* Approves and then calls the receiving contract */
124     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
125         allowed[msg.sender][_spender] = _value;
126         Approval(msg.sender, _spender, _value);
127 
128         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
129         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
130         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
131         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
132         return true;
133     }
134 }