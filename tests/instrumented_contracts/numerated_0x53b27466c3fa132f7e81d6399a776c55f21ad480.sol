1 pragma solidity ^0.4.18;
2 
3 /* -------------- CAC  ISSUE ----------
4 createdate : 2019.06 
5 Token name : CAC TOKEN
6 Symbol name : CAC
7 ----------------------------------------------------------*/
8 
9 contract Token {
10 
11 
12     function totalSupply() constant returns (uint256 supply) {}
13 
14     function balanceOf(address _owner) constant returns (uint256 balance) {}
15 
16 
17     function transfer(address _to, uint256 _value) returns (bool success) {}
18 
19 
20     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
21 
22  
23     function approve(address _spender, uint256 _value) returns (bool success) {}
24 
25 
26     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
27 
28     event Transfer(address indexed _from, address indexed _to, uint256 _value);
29     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
30 
31 }
32 
33 contract StandardToken is Token {
34 
35     function transfer(address _to, uint256 _value) returns (bool success) {
36         //Default assumes totalSupply can't be over max (2^256 - 1).
37         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
38         //Replace the if with this one instead.
39         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
40         if (balances[msg.sender] >= _value && _value > 0) {
41             balances[msg.sender] -= _value;
42             balances[_to] += _value;
43             Transfer(msg.sender, _to, _value);
44             return true;
45         } else { return false; }
46     }
47 
48     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
49         //same as above. Replace this line with the following if you want to protect against wrapping uints.
50         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
51         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
52             balances[_to] += _value;
53             balances[_from] -= _value;
54             allowed[_from][msg.sender] -= _value;
55             Transfer(_from, _to, _value);
56             return true;
57         } else { return false; }
58     }
59 
60     function balanceOf(address _owner) constant returns (uint256 balance) {
61         return balances[_owner];
62     }
63 
64     function approve(address _spender, uint256 _value) returns (bool success) {
65         allowed[msg.sender][_spender] = _value;
66         Approval(msg.sender, _spender, _value);
67         return true;
68     }
69 
70     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
71       return allowed[_owner][_spender];
72     }
73 
74     mapping (address => uint256) balances;
75     mapping (address => mapping (address => uint256)) allowed;
76     uint256 public totalSupply;
77 }
78 
79 contract CACTOKEN  is StandardToken { //  **the contract name.
80 
81     /* Public variables of the token */
82 
83     /*
84     NOTE:
85     The following variables are choice vanities. One does not have to include them.
86     */
87     string public name;                   // Token Name 
88     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
89     string public symbol;                 // An identifier: eg SBX, XPR etc..
90     string public version = 'C1.0'; 
91     uint256 public unitsOneEthCanBuy;     
92     uint256 public totalEthInWei;         
93     address public fundsWallet;           
94 
95     // This is a constructor function 
96     // which means the following function name has to match the contract name declared above
97 
98     function CACTOKEN() {                                      //** funtion name **/
99         balances[msg.sender] = 1000000000000000;      
100         totalSupply = 1000000000000000;     
101         name = "CACTOKEN";                              
102         decimals = 6;                                  
103         symbol = "CAC";                                 
104         unitsOneEthCanBuy = 10;                         
105         fundsWallet = msg.sender;                       
106     }
107 
108     function() payable{
109         totalEthInWei = totalEthInWei + msg.value;
110         uint256 amount = msg.value * unitsOneEthCanBuy;
111         require(balances[fundsWallet] >= amount);
112 
113         balances[fundsWallet] = balances[fundsWallet] - amount;
114         balances[msg.sender] = balances[msg.sender] + amount;
115 
116         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
117 
118         //Transfer ether to fundsWallet
119         fundsWallet.transfer(msg.value);                               
120     }
121 
122     /* Approves and then calls the receiving contract */
123     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
124         allowed[msg.sender][_spender] = _value;
125         Approval(msg.sender, _spender, _value);
126 
127         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
128         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
129         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
130         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
131         return true;
132     }
133 }