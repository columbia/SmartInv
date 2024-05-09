1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5     function totalSupply() constant returns (uint256 supply) {}
6     function balanceOf(address _owner) constant returns (uint256 balance) {}
7     function transfer(address _to, uint256 _value) returns (bool success) {}
8     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
9     function approve(address _spender, uint256 _value) returns (bool success) {}
10     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
11 
12     event Transfer(address indexed _from, address indexed _to, uint256 _value);
13     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
14 
15 }
16 
17 contract StandardToken is Token {
18 
19     function transfer(address _to, uint256 _value) returns (bool success) {
20         if (balances[msg.sender] >= _value && _value > 0) {
21             balances[msg.sender] -= _value;
22             balances[_to] += _value;
23             Transfer(msg.sender, _to, _value);
24             return true;
25         } else { return false; }
26     }
27 
28     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
29         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
30             balances[_to] += _value;
31             balances[_from] -= _value;
32             allowed[_from][msg.sender] -= _value;
33             Transfer(_from, _to, _value);
34             return true;
35         } else { return false; }
36     }
37 
38     function balanceOf(address _owner) constant returns (uint256 balance) {
39         return balances[_owner];
40     }
41 
42     function approve(address _spender, uint256 _value) returns (bool success) {
43         allowed[msg.sender][_spender] = _value;
44         Approval(msg.sender, _spender, _value);
45         return true;
46     }
47 
48     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
49       return allowed[_owner][_spender];
50     }
51 
52     mapping (address => uint256) balances;
53     mapping (address => mapping (address => uint256)) allowed;
54     uint256 public totalSupply;
55 }
56 
57 contract PumpND is StandardToken { 
58 
59     string public name;
60     uint8 public decimals;
61     string public symbol;
62     string public version = 'H1.0'; 
63     uint256 public unitsOneEthCanBuy;
64     uint256 public totalEthInWei;  
65     address public fundsWallet;
66 
67     function PumpND() {
68         balances[msg.sender] = 400000000000000000000000;
69         totalSupply = 400000000000000000000000;
70         name = "Pump and Dump";
71         decimals = 18;
72         symbol = "PUMPND";
73         unitsOneEthCanBuy = 200;
74         fundsWallet = msg.sender;
75     }
76 
77     function() payable{
78         totalEthInWei = totalEthInWei + msg.value;
79         uint256 amount = msg.value * unitsOneEthCanBuy;
80         if (balances[fundsWallet] < amount) {
81             return;
82         }
83 
84         balances[fundsWallet] = balances[fundsWallet] - amount;
85         balances[msg.sender] = balances[msg.sender] + amount;
86 
87         Transfer(fundsWallet, msg.sender, amount);
88 
89         fundsWallet.transfer(msg.value);                               
90     }
91 
92     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
93         allowed[msg.sender][_spender] = _value;
94         Approval(msg.sender, _spender, _value);
95 
96         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
97         return true;
98     }
99 }