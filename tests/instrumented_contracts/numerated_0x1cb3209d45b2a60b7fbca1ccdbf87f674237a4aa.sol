1 pragma solidity ^0.4.4;
2 
3 contract Token {
4     function totalSupply() constant returns (uint256 supply) {}
5 
6     function balanceOf(address _owner) constant returns (uint256 balance) {}
7 
8     function transfer(address _to, uint256 _value) returns (bool success) {}
9 
10     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
11 
12     function approve(address _spender, uint256 _value) returns (bool success) {}
13 
14     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
15 
16     event Transfer(address indexed _from, address indexed _to, uint256 _value);
17     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
18     
19 }
20 
21 
22 
23 contract StandardToken is Token {
24 
25     function transfer(address _to, uint256 _value) returns (bool success) {
26         if (balances[msg.sender] >= _value && _value > 0) {
27             balances[msg.sender] -= _value;
28             balances[_to] += _value;
29             Transfer(msg.sender, _to, _value);
30             return true;
31         } else { return false; }
32     }
33 
34     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
35         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
36             balances[_to] += _value;
37             balances[_from] -= _value;
38             allowed[_from][msg.sender] -= _value;
39             Transfer(_from, _to, _value);
40             return true;
41         } else { return false; }
42     }
43 
44     function balanceOf(address _owner) constant returns (uint256 balance) {
45         return balances[_owner];
46     }
47 
48     function approve(address _spender, uint256 _value) returns (bool success) {
49         allowed[msg.sender][_spender] = _value;
50         Approval(msg.sender, _spender, _value);
51         return true;
52     }
53 
54     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
55       return allowed[_owner][_spender];
56     }
57 
58     mapping (address => uint256) balances;
59     mapping (address => mapping (address => uint256)) allowed;
60     uint256 public totalSupply;
61 }
62 
63 contract ThoreCoin is StandardToken {
64 
65     function () {
66         //if ether is sent to this address, send it back.
67         throw;
68     }
69 
70     
71     string public name;                   
72     uint8 public decimals;                
73     string public symbol;                 
74     string public version = 'THC1.0';       
75 
76 
77     function ThoreCoin(
78         ) {
79         balances[msg.sender] = 1000000000;               
80         totalSupply = 1000000000;                        
81         name = "ThoreCoin";                                   
82         decimals = 4;                            
83         symbol = "THR";                               
84     }
85 
86     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
87         allowed[msg.sender][_spender] = _value;
88         Approval(msg.sender, _spender, _value);
89         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
90         return true;
91     }
92 }