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
15 
16     function transfer(address _to, uint256 _value) returns (bool success) {
17         if (balances[msg.sender] >= _value && _value > 0) {
18             balances[msg.sender] -= _value;
19             balances[_to] += _value;
20             Transfer(msg.sender, _to, _value);
21             return true;
22         } else { return false; }
23     }
24 	
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
55 
56 contract FEAL is StandardToken {
57 
58     function () {
59         throw;
60     }
61     string public name;                   
62     uint8 public decimals;               
63     string public symbol;                
64     string public version = 'H1.0';       
65 
66     function FEAL() {
67         balances[msg.sender] = 20000000000000000000000000;               
68         totalSupply = 20000000000000000000000000;                        
69         name = "FEAL Token";                                  
70         decimals = 18;                            
71         symbol = "FEAL";                               
72     }
73 
74     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
75         allowed[msg.sender][_spender] = _value;
76         Approval(msg.sender, _spender, _value);
77        if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
78         return true;
79     }
80 }