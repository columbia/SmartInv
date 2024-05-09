1 pragma solidity ^0.4.4;
2 
3 contract Token {
4     function totalSupply() constant returns (uint256 supply) {}
5     function balanceOf(address _owner) constant returns (uint256 balance) {}
6     function transfer(address _to, uint256 _value) returns (bool success) {}
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
8     function approve(address _spender, uint256 _value) returns (bool success) {}
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
10 
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13 }
14 
15 contract StandardToken is Token {
16 
17     function transfer(address _to, uint256 _value) returns (bool success) {
18         if (balances[msg.sender] >= _value && _value > 0) {
19             balances[msg.sender] -= _value;
20             balances[_to] += _value;
21             Transfer(msg.sender, _to, _value);
22             return true;
23         } else { return false; }
24     }
25 
26     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
27         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
28             balances[_to] += _value;
29             balances[_from] -= _value;
30             allowed[_from][msg.sender] -= _value;
31             Transfer(_from, _to, _value);
32             return true;
33         } else { return false; }
34     }
35 
36     function balanceOf(address _owner) constant returns (uint256 balance) {
37         return balances[_owner];
38     }
39 
40     function approve(address _spender, uint256 _value) returns (bool success) {
41         allowed[msg.sender][_spender] = _value;
42         Approval(msg.sender, _spender, _value);
43         return true;
44     }
45 
46     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
47       return allowed[_owner][_spender];
48     }
49 
50     mapping (address => uint256) balances;
51     mapping (address => mapping (address => uint256)) allowed;
52     uint256 public totalSupply;
53 }
54 
55 contract DapToken is StandardToken { 
56     string public name;                   
57     uint8 public decimals;                
58     string public symbol;                 
59     string public version = 'H1.0'; 
60     uint256 public unitsOneEthCanBuy;     
61     uint256 public totalEthInWei;         
62     address public fundsWallet;           
63 
64     function DapToken() {
65         balances[msg.sender] = 4116251521;               
66         totalSupply = 4116251521;                        
67         name = "DapToken";                                   
68         decimals = 0;                                               
69         symbol = "DAP";                                             
70         unitsOneEthCanBuy = 5000;                                      
71         fundsWallet = msg.sender;                                    
72     }
73 
74     function() payable{
75         totalEthInWei = totalEthInWei + msg.value;
76         uint256 amount = msg.value * unitsOneEthCanBuy;
77         if (balances[fundsWallet] < amount) {
78             return;
79         }
80 
81         balances[fundsWallet] = balances[fundsWallet] - amount;
82         balances[msg.sender] = balances[msg.sender] + amount;
83         Transfer(fundsWallet, msg.sender, amount); 
84         fundsWallet.transfer(msg.value);                               
85     }
86 
87     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
88         allowed[msg.sender][_spender] = _value;
89         Approval(msg.sender, _spender, _value);
90         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
91         return true;
92     }
93 }