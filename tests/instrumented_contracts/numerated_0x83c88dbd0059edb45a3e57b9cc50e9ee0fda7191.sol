1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5     function totalSupply() constant returns (uint256 supply) {}
6 
7     function balanceOf(address _owner) constant returns (uint256 balance) {}
8 
9     function transfer(address _to, uint256 _value) returns (bool success) {}
10 
11     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
12 
13     function approve(address _spender, uint256 _value) returns (bool success) {}
14 
15     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
16 
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19     
20 }
21 
22 contract StandardToken is Token {
23 
24     function transfer(address _to, uint256 _value) returns (bool success) {
25         
26         if (balances[msg.sender] >= _value && _value > 0) {
27             balances[msg.sender] -= _value;
28             balances[_to] += _value;
29             Transfer(msg.sender, _to, _value);
30             return true;
31         } else { return false; }
32     }
33 
34     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
35        
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
64 contract ERC20Token is StandardToken {
65 
66     function () {
67         throw;
68     }
69 
70     string public name;                  
71     uint8 public decimals;                
72     string public symbol;                 
73     string public version = 'H1.0';       
74 
75     function ERC20Token(
76         ) {
77         balances[msg.sender] = 21000000000000000000000000;              
78         totalSupply = 21000000000000000000000000;                       
79         name = "Planet BlockChain";                                  
80         decimals = 18;                           
81         symbol = "PBC";                         
82     }
83 
84     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
85         allowed[msg.sender][_spender] = _value;
86         Approval(msg.sender, _spender, _value);
87 
88         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
89         return true;
90     }
91 }