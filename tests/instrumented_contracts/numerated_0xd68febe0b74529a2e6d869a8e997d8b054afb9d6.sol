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
22 
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
64 
65 contract TORQToken is StandardToken {
66 
67     function () {
68         throw;
69     }
70     string public name;                   
71     uint8 public decimals;                
72     string public symbol;                 
73     string public version = 'H1.0';       
74 
75     function TORQToken(
76         ) {
77         decimals = 8;
78         balances[msg.sender] = 25000000* (10 ** uint256(decimals));
79         name = "TORQToken";                      
80         symbol = "TORQ";                         
81         totalSupply = 25000000 * (10 ** uint256(decimals));
82     }
83     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
84         allowed[msg.sender][_spender] = _value;
85         Approval(msg.sender, _spender, _value);
86         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
87         return true;
88     }
89 }