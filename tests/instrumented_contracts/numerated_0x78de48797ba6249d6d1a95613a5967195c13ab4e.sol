1 pragma solidity ^0.4.4;
2 
3 contract Token {
4     function totalSupply() constant returns (uint256 supply) {}
5     function balanceOf(address _owner) constant returns (uint256 balance) {}
6     function transfer(address _to, uint256 _value) returns (bool success) {}
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
8     function approve(address _spender, uint256 _value) returns (bool success) {}
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 contract StandardToken is Token {
15     function transfer(address _to, uint256 _value) returns (bool success) {
16         if (balances[msg.sender] >= _value && _value > 0) {
17             balances[msg.sender] -= _value;
18             balances[_to] += _value;
19             Transfer(msg.sender, _to, _value);
20             return true;
21         } else { return false; }
22     }
23     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
24         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
25             balances[_to] += _value;
26             balances[_from] -= _value;
27             allowed[_from][msg.sender] -= _value;
28             Transfer(_from, _to, _value);
29             return true;
30         } else { return false; }
31     }
32     function balanceOf(address _owner) constant returns (uint256 balance) {
33         return balances[_owner];
34     }
35 
36     function approve(address _spender, uint256 _value) returns (bool success) {
37         allowed[msg.sender][_spender] = _value;
38         Approval(msg.sender, _spender, _value);
39         return true;
40     }
41     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
42       return allowed[_owner][_spender];
43     }
44     mapping (address => uint256) balances;
45     mapping (address => mapping (address => uint256)) allowed;
46     uint256 public totalSupply;
47 }
48 
49 
50 contract DarchNetwork is StandardToken {
51     //http://remix.ethereum.org/#optimize=false&version=soljson-v0.4.13+commit.fb4cb1a.js
52     string public name;
53     uint8 public decimals;
54     string public symbol;
55     string public version = 'H1.0';
56     uint256 public firstcaplimit = 0;
57     uint256 public secondcaplimit = 0;
58     uint256 public thirdcaplimit = 0;
59     uint256 public lastcaplimit = 0;
60     address public fundsWallet;
61 
62 
63     function DarchNetwork() {
64         balances[msg.sender] = 1000000000000000000000000000;
65         totalSupply = 1000000000000000000000000000;
66         name = "Darch Network";
67         decimals = 18;
68         symbol = "DARCH";
69         fundsWallet = msg.sender;
70     }
71 
72     function() payable{
73 
74       uint256 yirmimart = 1553040000;
75       uint256 onnisan = 1554854400;
76       uint256 birmayis = 1556668800;
77       uint256 yirmimayis = 1558310400;
78       uint256 onhaziran = 1560124800;
79 
80 
81 
82 
83 
84       if(yirmimart > now) {
85         require(balances[fundsWallet] >= msg.value * 100);
86         balances[fundsWallet] = balances[fundsWallet] - msg.value * 100;
87         balances[msg.sender] = balances[msg.sender] + msg.value * 100;
88         Transfer(fundsWallet, msg.sender, msg.value * 100); // Broadcast a message to the blockchain
89         fundsWallet.transfer(msg.value);
90       } else if(yirmimart < now && onnisan > now) {
91 
92         if(firstcaplimit < 75000000){
93         require(balances[fundsWallet] >= msg.value * 15000);
94         balances[fundsWallet] = balances[fundsWallet] - msg.value * 15000;
95         balances[msg.sender] = balances[msg.sender] + msg.value * 15000;
96         firstcaplimit = firstcaplimit +  msg.value * 15000;
97         Transfer(fundsWallet, msg.sender, msg.value * 15000);
98         fundsWallet.transfer(msg.value);
99         } else {
100           throw;
101         }
102       } else if(onnisan < now && birmayis > now) {
103 
104         if(secondcaplimit < 75000000){
105         require(balances[fundsWallet] >= msg.value * 12000);
106         balances[fundsWallet] = balances[fundsWallet] - msg.value * 12000;
107         balances[msg.sender] = balances[msg.sender] + msg.value * 12000;
108         secondcaplimit = firstcaplimit +  msg.value * 12000;
109         Transfer(fundsWallet, msg.sender, msg.value * 12000);
110         fundsWallet.transfer(msg.value);
111         } else {
112           throw;
113         }
114       }else if(birmayis < now && yirmimayis > now) {
115        if(thirdcaplimit < 75000000){
116         require(balances[fundsWallet] >= msg.value * 10000);
117         balances[fundsWallet] = balances[fundsWallet] - msg.value * 10000;
118         balances[msg.sender] = balances[msg.sender] + msg.value * 10000;
119         thirdcaplimit = firstcaplimit +  msg.value * 10000;
120         Transfer(fundsWallet, msg.sender, msg.value * 10000); // Broadcast a message to the blockchain
121         fundsWallet.transfer(msg.value);
122         } else {
123           throw;
124         }
125       }else if(yirmimayis < now && onhaziran > now) {
126       if(lastcaplimit < 75000000){
127         require(balances[fundsWallet] >= msg.value * 7500);
128         balances[fundsWallet] = balances[fundsWallet] - msg.value * 7500;
129         balances[msg.sender] = balances[msg.sender] + msg.value * 7500;
130         lastcaplimit = firstcaplimit +  msg.value * 7500;
131         Transfer(fundsWallet, msg.sender, msg.value * 7500);
132         fundsWallet.transfer(msg.value);
133         } else {
134           throw;
135         }
136       } else {
137         throw;
138       }
139     }
140 
141 
142     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
143         allowed[msg.sender][_spender] = _value;
144         Approval(msg.sender, _spender, _value);
145         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
146         return true;
147     }
148 }