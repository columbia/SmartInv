1 /*
2  * Token	
3  */
4 
5 pragma solidity ^0.4.4;
6 
7 contract Token {
8   
9     function totalSupply() constant returns (uint256 supply) {}
10 
11     function balanceOf(address _owner) constant returns (uint256 balance) {}
12    
13     function transfer(address _to, uint256 _value) returns (bool success) {}
14    
15     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
16    
17     function approve(address _spender, uint256 _value) returns (bool success) {}
18   
19     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
20  
21     event Transfer(address indexed _from, address indexed _to, uint256 _value);
22 
23     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
24 }
25 
26 contract StandardToken is Token {
27 
28     function transfer(address _to, uint256 _value) returns (bool success) {        
29         if (balances[msg.sender] >= _value && _value > 0) {
30             balances[msg.sender] -= _value;
31             balances[_to] += _value;
32             Transfer(msg.sender, _to, _value);
33             return true;
34         } else { return false; }
35     }
36 
37     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
38         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
39             balances[_to] += _value;
40             balances[_from] -= _value;
41             allowed[_from][msg.sender] -= _value;
42             Transfer(_from, _to, _value);
43             return true;
44         } else { return false; }
45     }
46 
47     function balanceOf(address _owner) constant returns (uint256 balance) {
48         return balances[_owner];
49     }
50 
51     function approve(address _spender, uint256 _value) returns (bool success) {
52         allowed[msg.sender][_spender] = _value;
53         Approval(msg.sender, _spender, _value);
54         return true;
55     }
56 
57     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
58       return allowed[_owner][_spender];
59     }
60 
61     mapping (address => uint256) balances;
62     mapping (address => mapping (address => uint256)) allowed;
63     uint256 public totalSupply;
64 }
65 
66 contract LongBCoin is StandardToken {
67 
68     function () {
69         throw;
70     }
71 
72     string public name;                   
73     uint8 public decimals;               
74     string public symbol;                 
75     string public version = 'H0.1';       
76 
77     function LongBCoin(
78         uint256 _initialAmount,
79         string _tokenName,
80         uint8 _decimalUnits,
81         string _tokenSymbol
82         ) {
83         balances[msg.sender] = _initialAmount;               
84         totalSupply = _initialAmount;                        
85         name = _tokenName;                                   
86         decimals = _decimalUnits;                            
87         symbol = _tokenSymbol;                               
88     }
89 
90     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
91         allowed[msg.sender][_spender] = _value;
92         Approval(msg.sender, _spender, _value);        
93         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
94         return true;
95     }
96 }