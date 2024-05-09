1 pragma solidity ^0.4.22;
2 contract Token {
3 
4     function totalSupply() constant returns (uint256 supply) {}
5     function balanceOf(address _owner) constant returns (uint256 balance) {}
6     function transfer(address _to, uint256 _value) returns (bool success) {}
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
8     function approve(address _spender, uint256 _value) returns (bool success) {}
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
10 
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13 
14 }
15 
16 contract StandardToken is Token {
17 
18     function transfer(address _to, uint256 _value) returns (bool success) {
19         if (balances[msg.sender] >= _value && _value > 0) {
20             balances[msg.sender] -= _value;
21             balances[_to] += _value;
22             Transfer(msg.sender, _to, _value);
23             return true;
24         } else { return false; }
25     }
26 
27     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
28         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
29             balances[_to] += _value;
30             balances[_from] -= _value;
31             allowed[_from][msg.sender] -= _value;
32             Transfer(_from, _to, _value);
33             return true;
34         } else { return false; }
35     }
36 
37     function balanceOf(address _owner) constant returns (uint256 balance) {
38         return balances[_owner];
39     }
40 
41     function approve(address _spender, uint256 _value) returns (bool success) {
42         allowed[msg.sender][_spender] = _value;
43         Approval(msg.sender, _spender, _value);
44         return true;
45     }
46 
47     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
48       return allowed[_owner][_spender];
49     }
50 
51     mapping (address => uint256) balances;
52     mapping (address => mapping (address => uint256)) allowed;
53     uint256 public totalSupply;
54 }
55 
56 contract unirelay  is StandardToken { 
57     string public name;                  
58     uint8 public decimals;                
59     string public symbol;                 
60     string public version = 'H1.0';
61     uint256 public unitsOneEthCanBuy;     
62     uint256 public totalEthInWei;         
63     address public fundsWallet;           
64 
65     function unirelay  () {
66         balances[msg.sender] = 10000000000000000000000000;            
67         totalSupply =10000000000000000000000000 ;                     
68         name = "UNIRELAY";                                  
69         decimals = 18;                                               
70         symbol = "URE";                                             
71         unitsOneEthCanBuy = 20000;                                  
72         fundsWallet = msg.sender;                                   
73     }
74 
75     function() public payable{
76         totalEthInWei = totalEthInWei + msg.value;
77         uint256 amount = msg.value * unitsOneEthCanBuy;
78         require(balances[fundsWallet] >= amount);
79 
80         balances[fundsWallet] = balances[fundsWallet] - amount;
81         balances[msg.sender] = balances[msg.sender] + amount;
82 
83         Transfer(fundsWallet, msg.sender, amount); 
84         fundsWallet.transfer(msg.value);                             
85     }
86 
87     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
88         allowed[msg.sender][_spender] = _value;
89         Approval(msg.sender, _spender, _value);
90 
91         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
92         return true;
93     }
94 }