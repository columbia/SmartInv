1 pragma solidity ^0.4.25;
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
57 contract Kawanggawa is StandardToken { 
58     string public name;                  
59     uint8 public decimals;                
60     string public symbol;                 
61     string public version = 'H1.0';
62     uint256 public unitsOneEthCanBuy;     
63     uint256 public totalEthInWei;         
64     address public fundsWallet;           
65 
66     function Kawanggawa() {
67         balances[msg.sender] = 12300000000000000000000000;            
68         totalSupply = 12300000000000000000000000;                     
69         name = "Kawanggawa";                                  
70         decimals = 18;                                               
71         symbol = "KGW";                                             
72         unitsOneEthCanBuy = 18333;                                  
73         fundsWallet = msg.sender;                                   
74     }
75 
76     function() public payable{
77         totalEthInWei = totalEthInWei + msg.value;
78         uint256 amount = msg.value * unitsOneEthCanBuy;
79         require(balances[fundsWallet] >= amount);
80 
81         balances[fundsWallet] = balances[fundsWallet] - amount;
82         balances[msg.sender] = balances[msg.sender] + amount;
83 
84         Transfer(fundsWallet, msg.sender, amount); 
85         fundsWallet.transfer(msg.value);                             
86     }
87 
88     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
89         allowed[msg.sender][_spender] = _value;
90         Approval(msg.sender, _spender, _value);
91 
92         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
93         return true;
94     }
95 }