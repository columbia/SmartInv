1 pragma solidity ^0.4.4;
2 
3 contract Token {
4     /// code by Jan Jehl
5 
6     function totalSupply() constant returns (uint256 supply) {}
7 
8 
9     function balanceOf(address _owner) constant returns (uint256 balance) {}
10 
11     function transfer(address _to, uint256 _value) returns (bool success) {}
12 
13     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
14 
15     function approve(address _spender, uint256 _value) returns (bool success) {}
16 
17 
18     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
19 
20     event Transfer(address indexed _from, address indexed _to, uint256 _value);
21     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
22     
23 }
24 
25 
26 
27 contract StandardToken is Token {
28 
29     function transfer(address _to, uint256 _value) returns (bool success) {
30 
31         if (balances[msg.sender] >= _value && _value > 0) {
32             balances[msg.sender] -= _value;
33             balances[_to] += _value;
34             Transfer(msg.sender, _to, _value);
35             return true;
36         } else { return false; }
37     }
38 
39     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
40 
41         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
42             balances[_to] += _value;
43             balances[_from] -= _value;
44             allowed[_from][msg.sender] -= _value;
45             Transfer(_from, _to, _value);
46             return true;
47         } else { return false; }
48     }
49 
50     function balanceOf(address _owner) constant returns (uint256 balance) {
51         return balances[_owner];
52     }
53 
54     function approve(address _spender, uint256 _value) returns (bool success) {
55         allowed[msg.sender][_spender] = _value;
56         Approval(msg.sender, _spender, _value);
57         return true;
58     }
59 
60     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
61       return allowed[_owner][_spender];
62     }
63 
64     mapping (address => uint256) balances;
65     mapping (address => mapping (address => uint256)) allowed;
66     uint256 public totalSupply;
67 }
68 
69 
70 
71 contract SilverStar is StandardToken {
72 
73     function () {
74        
75         throw;
76     }
77 
78     string public name;                   
79     uint8 public decimals;                
80     string public symbol;                 
81     string public version = 'H1.0';      
82 
83 
84     function SilverStar(
85         ) {
86         balances[msg.sender] = 100000000000000000000000000;               
87         totalSupply = 100000000000000000000000000;                        
88         name = "SilverStar";                                   
89         decimals = 18;                            
90         symbol = "SSC";                               
91     }
92 
93     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
94         allowed[msg.sender][_spender] = _value;
95         Approval(msg.sender, _spender, _value);
96 
97 
98         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
99         return true;
100     }
101 }