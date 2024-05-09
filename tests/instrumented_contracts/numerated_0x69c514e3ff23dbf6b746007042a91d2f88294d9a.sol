1 //ziu
2 //Contract Name:            Ziube
3 //Contract info:            ziube.network
4 //Contract website:         ziube.com
5 //Compiler Text:            v0.4.24+commit.e67f0147
6 //Optimization Enabled:     Yes
7 //Runs (Optimiser):         200
8 //ziu
9 
10 pragma solidity ^0.4.23;
11 
12 contract ZiubeToken {
13 
14     function totalSupply() constant returns (uint256 supply) {}
15 
16     function balanceOf(address _owner) constant returns (uint256 balance) {}
17 
18     function transfer(address _to, uint256 _value) returns (bool success) {}
19 
20     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
21 
22     function approve(address _spender, uint256 _value) returns (bool success) {}
23 
24     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
25 
26     event Transfer(address indexed _from, address indexed _to, uint256 _value);
27     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
28 
29 }
30 
31 contract StandardToken is ZiubeToken {
32 
33     function transfer(address _to, uint256 _value) returns (bool success) {
34 
35         if (balances[msg.sender] >= _value && _value > 0) {
36             balances[msg.sender] -= _value;
37             balances[_to] += _value;
38             Transfer(msg.sender, _to, _value);
39             return true;
40         } else { return false; }
41     }
42 
43     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
44 
45         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
46             balances[_to] += _value;
47             balances[_from] -= _value;
48             allowed[_from][msg.sender] -= _value;
49             Transfer(_from, _to, _value);
50             return true;
51         } else { return false; }
52     }
53 
54     function balanceOf(address _owner) constant returns (uint256 balance) {
55         return balances[_owner];
56     }
57 
58     function approve(address _spender, uint256 _value) returns (bool success) {
59         allowed[msg.sender][_spender] = _value;
60         Approval(msg.sender, _spender, _value);
61         return true;
62     }
63 
64     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
65       return allowed[_owner][_spender];
66     }
67 
68     mapping (address => uint256) balances;
69     mapping (address => mapping (address => uint256)) allowed;
70     uint256 public totalSupply;
71 }
72 
73 contract Ziube is StandardToken {
74     
75     string public name;                   
76     uint8 public decimals;              
77     string public symbol;                 
78     string public version = 'V1.012';
79     uint256 public unitsBuy;     
80     uint256 public totalEthInWei;        
81     address public fundsWallet;         
82 
83     function Ziube() {
84         balances[msg.sender] = 92000000000000000000000000000;     
85         totalSupply = 92000000000000000000000000000;    
86         name = "Ziube";                                 
87         decimals = 18;                                           
88         symbol = "XZE";                                             
89         unitsBuy = 200000;                                      
90         fundsWallet = msg.sender;                                  
91     }
92 
93     function() public payable{
94         totalEthInWei = totalEthInWei + msg.value;
95         uint256 amount = msg.value * unitsBuy;
96         require(balances[fundsWallet] >= amount);
97         balances[fundsWallet] = balances[fundsWallet] - amount;
98         balances[msg.sender] = balances[msg.sender] + amount;
99         Transfer(fundsWallet, msg.sender, amount);
100         fundsWallet.transfer(msg.value);                             
101     }
102 
103     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
104         allowed[msg.sender][_spender] = _value;
105         Approval(msg.sender, _spender, _value);
106         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
107         return true;
108     }
109     function MultiTransfer(address[] addrs, uint256 amount) public {
110     for (uint256 i = 0; i < addrs.length; i++) {
111       transfer(addrs[i], amount);
112     }
113     
114   }
115   
116 }