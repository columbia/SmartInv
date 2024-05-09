1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5     
6     function totalSupply() constant returns (uint256 supply) {}
7     function balanceOf(address _owner) constant returns (uint256 balance) {}
8     function transfer(address _to, uint256 _value) returns (bool success) {}
9     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
10     function approve(address _spender, uint256 _value) returns (bool success) {}
11     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
12 
13     event Transfer(address indexed _from, address indexed _to, uint256 _value);
14     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
15     
16 }
17 
18 
19 
20 contract StandardToken is Token {
21 
22     function transfer(address _to, uint256 _value) returns (bool success) {
23         if (balances[msg.sender] >= _value && _value > 0) {
24             balances[msg.sender] -= _value;
25             balances[_to] += _value;
26             Transfer(msg.sender, _to, _value);
27             return true;
28         } else { return false; }
29     }
30 
31     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
32         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
33             balances[_to] += _value;
34             balances[_from] -= _value;
35             allowed[_from][msg.sender] -= _value;
36             Transfer(_from, _to, _value);
37             return true;
38         } else { return false; }
39     }
40 
41     function balanceOf(address _owner) constant returns (uint256 balance) {
42         return balances[_owner];
43     }
44 
45     function approve(address _spender, uint256 _value) returns (bool success) {
46         allowed[msg.sender][_spender] = _value;
47         Approval(msg.sender, _spender, _value);
48         return true;
49     }
50 
51     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
52       return allowed[_owner][_spender];
53     }
54 
55     mapping (address => uint256) balances;
56     mapping (address => mapping (address => uint256)) allowed;
57     uint256 public totalSupply;
58 }
59 
60 
61 
62 contract Redchain is StandardToken {
63 
64     function () {
65         throw;
66     }
67 
68     string public name = "Redchain";                   
69     uint8 public decimals = 0;                
70     string public symbol = "RCH";                 
71     string public version = 'H1.0';       
72 
73 
74     function Redchain(
75         ) {
76         balances[msg.sender] = 32000000;               
77         totalSupply = 32000000;                        
78         name = "Redchain";                                   
79         decimals = 0;                           
80         symbol = "RCH";                               
81     }
82 
83     
84     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
85         allowed[msg.sender][_spender] = _value;
86         Approval(msg.sender, _spender, _value);
87 
88        if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
89         return true;
90     }
91 }