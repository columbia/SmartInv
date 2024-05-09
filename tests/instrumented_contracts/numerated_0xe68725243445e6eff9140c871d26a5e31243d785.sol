1 pragma solidity ^0.4.4;
2 
3 /* Egyptian Pound Token Contract 
4     A decentralized alternative to the national Egyptian currency to help resolve the economic crisis in Egypt
5 */
6 
7 contract Token {
8 
9     function totalSupply() constant returns (uint256 supply) {}
10 
11     
12     function balanceOf(address _owner) constant returns (uint256 balance) {}
13 
14     
15     function transfer(address _to, uint256 _value) returns (bool success) {}
16 
17     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
18 
19   
20     function approve(address _spender, uint256 _value) returns (bool success) {}
21 
22     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
23 
24     event Transfer(address indexed _from, address indexed _to, uint256 _value);
25     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
26     
27 }
28 
29 
30 
31 contract StandardToken is Token {
32 
33     function transfer(address _to, uint256 _value) returns (bool success) {
34         if (balances[msg.sender] >= _value && _value > 0) {
35             balances[msg.sender] -= _value;
36             balances[_to] += _value;
37             Transfer(msg.sender, _to, _value);
38             return true;
39         } else { return false; }
40     }
41 
42     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
43         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
44             balances[_to] += _value;
45             balances[_from] -= _value;
46             allowed[_from][msg.sender] -= _value;
47             Transfer(_from, _to, _value);
48             return true;
49         } else { return false; }
50     }
51 
52     function balanceOf(address _owner) constant returns (uint256 balance) {
53         return balances[_owner];
54     }
55 
56     function approve(address _spender, uint256 _value) returns (bool success) {
57         allowed[msg.sender][_spender] = _value;
58         Approval(msg.sender, _spender, _value);
59         return true;
60     }
61 
62     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
63       return allowed[_owner][_spender];
64     }
65 
66     mapping (address => uint256) balances;
67     mapping (address => mapping (address => uint256)) allowed;
68     uint256 public totalSupply;
69 }
70 
71 
72 contract EgyptianPound is StandardToken {
73 
74     function () {
75         throw;
76     }
77 
78     
79     string public name;                   
80     uint8 public decimals;                
81     string public symbol;                 
82     string public version = 'H1.0';       
83 
84     function EgyptianPound(
85         ) {
86         balances[msg.sender] = 10000000000000000000000000000;
87         totalSupply = 10000000000000000000000000000;                        
88         name = "Egyptian Pound";                                   
89         decimals = 18;                            
90         symbol = "EGP";                            
91     }
92 
93     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
94         allowed[msg.sender][_spender] = _value;
95         Approval(msg.sender, _spender, _value);
96 
97         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
98         return true;
99     }
100 }