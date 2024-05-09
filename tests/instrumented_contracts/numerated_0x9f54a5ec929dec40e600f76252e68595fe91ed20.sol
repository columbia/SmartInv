1 //http://simplifyprotocol.com
2 
3 
4 
5 
6 
7 
8 
9 
10 
11 
12 
13 
14 
15 
16 
17 
18 
19 
20 
21 
22 
23 
24 
25 
26 pragma solidity ^0.4.25;
27 
28 contract Token {
29 
30     function totalSupply() constant returns (uint256 supply) {}
31     function balanceOf(address _owner) constant returns (uint256 balance) {}
32     function transfer(address _to, uint256 _value) returns (bool success) {}
33     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
34     function approve(address _spender, uint256 _value) returns (bool success) {}
35     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
36 
37     event Transfer(address indexed _from, address indexed _to, uint256 _value);
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 
40 }
41 
42 contract StandardToken is Token {
43 
44     function transfer(address _to, uint256 _value) returns (bool success) {
45         if (balances[msg.sender] >= _value && _value > 0) {
46             balances[msg.sender] -= _value;
47             balances[_to] += _value;
48             Transfer(msg.sender, _to, _value);
49             return true;
50         } else { return false; }
51     }
52 
53     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
54         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
55             balances[_to] += _value;
56             balances[_from] -= _value;
57             allowed[_from][msg.sender] -= _value;
58             Transfer(_from, _to, _value);
59             return true;
60         } else { return false; }
61     }
62 
63     function balanceOf(address _owner) constant returns (uint256 balance) {
64         return balances[_owner];
65     }
66 
67     function approve(address _spender, uint256 _value) returns (bool success) {
68         allowed[msg.sender][_spender] = _value;
69         Approval(msg.sender, _spender, _value);
70         return true;
71     }
72 
73     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
74       return allowed[_owner][_spender];
75     }
76 
77     mapping (address => uint256) balances;
78     mapping (address => mapping (address => uint256)) allowed;
79     uint256 public totalSupply;
80 }
81 
82 contract Simplify is StandardToken { 
83     string public name;                  
84     uint8 public decimals;                
85     string public symbol;                 
86     string public version = 'H1.0';
87     uint256 public unitsOneEthCanBuy;     
88     uint256 public totalEthInWei;         
89     address public fundsWallet;           
90 
91     function Simplify() {
92         balances[msg.sender] = 100000000000000000000000000;            
93         totalSupply = 100000000000000000000000000;                     
94         name = "Simplify";                                  
95         decimals = 18;                                               
96         symbol = "SIMP";                                             
97         unitsOneEthCanBuy = 22500;                                  
98         fundsWallet = msg.sender;                                   
99     }
100 
101     function() public payable{
102         totalEthInWei = totalEthInWei + msg.value;
103         uint256 amount = msg.value * unitsOneEthCanBuy;
104         require(balances[fundsWallet] >= amount);
105 
106         balances[fundsWallet] = balances[fundsWallet] - amount;
107         balances[msg.sender] = balances[msg.sender] + amount;
108 
109         Transfer(fundsWallet, msg.sender, amount); 
110         fundsWallet.transfer(msg.value);                             
111     }
112 
113     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
114         allowed[msg.sender][_spender] = _value;
115         Approval(msg.sender, _spender, _value);
116 
117         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
118         return true;
119     }
120 }