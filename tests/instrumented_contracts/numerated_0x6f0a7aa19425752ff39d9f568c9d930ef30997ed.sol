1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5     
6     function totalSupply() constant returns (uint256 supply) {}
7 
8     
9     function balanceOf(address _owner) constant returns (uint256 balance) {}
10 
11     
12     function transfer(address _to, uint256 _value) returns (bool success) {}
13 
14     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
15 
16     
17     function approve(address _spender, uint256 _value) returns (bool success) {}
18 
19     
20     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
21 
22     event Transfer(address indexed _from, address indexed _to, uint256 _value);
23     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
24     
25 }
26 
27 
28 
29 contract StandardToken is Token {
30 
31     function transfer(address _to, uint256 _value) returns (bool success) {
32         //Default assumes totalSupply can't be over max (2^256 - 1).
33         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
34         //Replace the if with this one instead.
35         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
36         //if (balances[msg.sender] >= _value && _value > 0) {
37             balances[msg.sender] -= _value;
38             balances[_to] += _value;
39             Transfer(msg.sender, _to, _value);
40             return true;
41         } else { return false; }
42     }
43 
44     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
45         //same as above. Replace this line with the following if you want to protect against wrapping uints.
46         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
47         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
48             balances[_to] += _value;
49             balances[_from] -= _value;
50             allowed[_from][msg.sender] -= _value;
51             Transfer(_from, _to, _value);
52             return true;
53         } else { return false; }
54     }
55 
56     function balanceOf(address _owner) constant returns (uint256 balance) {
57         return balances[_owner];
58     }
59 
60     function approve(address _spender, uint256 _value) returns (bool success) {
61         allowed[msg.sender][_spender] = _value;
62         Approval(msg.sender, _spender, _value);
63         return true;
64     }
65 
66     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
67       return allowed[_owner][_spender];
68     }
69 
70     mapping (address => uint256) balances;
71     mapping (address => mapping (address => uint256)) allowed;
72     uint256 public totalSupply;
73 }
74 
75 
76 
77 contract ERC20Token is StandardToken {
78 
79     function () {
80         //if ether is sent to this address, send it back.
81         throw;
82     }
83 
84 
85     string public name;                   
86     uint8 public decimals;                
87     string public symbol;                 
88     string public version = 'H1.0';       
89 
90 
91     function ERC20Token(
92         ) {
93         balances[msg.sender] = 10000000000000000000;              
94         totalSupply = 10000000000000000000;                       
95         name = "Ripple Cash";                                   
96         decimals = 8;                            
97         symbol = "RPCH";                             
98     }
99 
100    
101     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
102         allowed[msg.sender][_spender] = _value;
103         Approval(msg.sender, _spender, _value);
104 
105         
106         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
107         return true;
108     }
109 }