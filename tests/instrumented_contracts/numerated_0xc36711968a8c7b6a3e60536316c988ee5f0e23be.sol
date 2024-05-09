1 pragma solidity ^0.4.4;
2 
3 //Made it simple by Manuel Fajardo, Ty McGuire and Carlos Garcia
4 
5 contract Token {
6 
7     function totalSupply() constant returns (uint256 supply) {}
8 
9     function balanceOf(address _owner) constant returns (uint256 balance) {}
10 
11     function transfer(address _to, uint256 _value) returns (bool success) {}
12 
13     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
14 
15     function approve(address _spender, uint256 _value) returns (bool success) {}
16 
17     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
18 
19     event Transfer(address indexed _from, address indexed _to, uint256 _value);
20     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
21     
22 }
23 
24 contract StandardToken is Token {
25 
26     function transfer(address _to, uint256 _value) returns (bool success) {
27         if (balances[msg.sender] >= _value && _value > 0) {
28             balances[msg.sender] -= _value;
29             balances[_to] += _value;
30             Transfer(msg.sender, _to, _value);
31             return true;
32         } else { return false; }
33     }
34 
35     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
36         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
37             balances[_to] += _value;
38             balances[_from] -= _value;
39             allowed[_from][msg.sender] -= _value;
40             Transfer(_from, _to, _value);
41             return true;
42         } else { return false; }
43     }
44 
45     function balanceOf(address _owner) constant returns (uint256 balance) {
46         return balances[_owner];
47     }
48 
49     function approve(address _spender, uint256 _value) returns (bool success) {
50         allowed[msg.sender][_spender] = _value;
51         Approval(msg.sender, _spender, _value);
52         return true;
53     }
54 
55     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
56       return allowed[_owner][_spender];
57     }
58 
59     mapping (address => uint256) balances;
60     mapping (address => mapping (address => uint256)) allowed;
61     uint256 public totalSupply;
62 }
63 
64 contract CasCoin is StandardToken {
65 
66     function () {
67         throw;
68     }
69 
70     string public name;                  
71     uint8 public decimals;                
72     string public symbol;                 
73     string public version = "1.0";       
74 
75     function CasCoin(
76         ) {
77         balances[msg.sender] = 10000000000000000000000000;               
78         totalSupply = 10000000000000000000000000;                        
79         name = "CasCoin"; 
80         decimals = 18;    
81         symbol = "AITK";                              
82     }
83 
84     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
85         allowed[msg.sender][_spender] = _value;
86         Approval(msg.sender, _spender, _value);
87         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
88         return true;
89     }
90 }