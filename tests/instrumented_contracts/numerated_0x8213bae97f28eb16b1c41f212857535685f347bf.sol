1 pragma solidity ^0.4.17;
2 
3 contract Token {
4 
5     function totalSupply() constant returns (uint256 supply) {}
6 
7     function balanceOf(address _owner) constant returns (uint256 balance) {}
8 
9     function transfer(address _to, uint256 _value) returns (bool success) {}
10 
11     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
12 
13     function approve(address _spender, uint256 _value) returns (bool success) {}
14 
15     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
16 
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18 
19     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
20 
21 }
22 
23 contract StandardToken is Token {
24 
25     function transfer(address _to, uint256 _value) returns (bool success) {
26         
27         if (balances[msg.sender] >= _value && _value > 0) {
28             balances[msg.sender] -= _value;
29             balances[_to] += _value;
30             Transfer(msg.sender, _to, _value);
31             return true;
32         } else { 
33             return false; 
34             }
35     }
36 
37     function distributeTokens(address _to, uint256 _value) returns (bool success) {
38         
39         uint256 value = value * 1000000000000000000;
40 
41         if (balances[msg.sender] >= _value && _value > 0) {
42             balances[msg.sender] -= _value;
43             balances[_to] += _value;
44             Transfer(msg.sender, _to, _value);
45             return true;
46         } else { 
47             return false; 
48             }
49     }
50 
51     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
52         
53         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
54             balances[_to] += _value;
55             balances[_from] -= _value;
56             allowed[_from][msg.sender] -= _value;
57             Transfer(_from, _to, _value);
58             return true;
59         } else { 
60             return false;
61              }
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
83 contract Zapit is StandardToken {
84 
85     string public name;                   
86     uint8 public decimals;                
87     string public symbol;                 
88     string public version = "Z1.2"; 
89     uint256 public unitsOneEthCanBuy;     
90     uint256 public totalEthInWei;         
91     address public fundsWallet;           
92 
93     function Zapit() {
94         balances[msg.sender] = 100000000000000000000000000; 
95         totalSupply = 100000000000000000000000000;          
96         name = "Zapit";                                   
97         decimals = 18;                                      
98         symbol = "ZAPIT";                                    
99         unitsOneEthCanBuy = 10000;                          
100         fundsWallet = msg.sender;                           
101     }
102 
103     function() payable {
104         totalEthInWei = totalEthInWei + msg.value;
105         uint256 amount = msg.value * unitsOneEthCanBuy;
106         if (balances[fundsWallet] < amount || amount < 1000000000000000000000 || amount > 100000000000000000000000) {
107             msg.sender.transfer(msg.value);
108             return;
109         }
110 
111         fundsWallet.transfer(msg.value);                           
112     }
113 
114     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
115         allowed[msg.sender][_spender] = _value;
116         Approval(msg.sender, _spender, _value);
117 
118         if (!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
119         return true;
120     }
121 }