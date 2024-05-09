1 pragma solidity ^0.4.4;
2 
3 /* Contract Name: PEXCASH
4    Created by: Pexcash.com Team
5    Description: P2P money transfer and crypto exchange using GPS mobile location
6 */
7 
8 contract Token {
9 
10     function totalSupply() constant returns (uint256 supply) {}
11 
12     
13     function balanceOf(address _owner) constant returns (uint256 balance) {}
14 
15     
16     function transfer(address _to, uint256 _value) returns (bool success) {}
17 
18     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
19 
20   
21     function approve(address _spender, uint256 _value) returns (bool success) {}
22 
23     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
24 
25     event Transfer(address indexed _from, address indexed _to, uint256 _value);
26     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
27     
28 }
29 
30 
31 
32 contract StandardToken is Token {
33 
34     function transfer(address _to, uint256 _value) returns (bool success) {
35         if (balances[msg.sender] >= _value && _value > 0) {
36             balances[msg.sender] -= _value;
37             balances[_to] += _value;
38             Transfer(msg.sender, _to, _value);
39             return true;
40         } else { return false; }
41     }
42 
43     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
44         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
45             balances[_to] += _value;
46             balances[_from] -= _value;
47             allowed[_from][msg.sender] -= _value;
48             Transfer(_from, _to, _value);
49             return true;
50         } else { return false; }
51     }
52 
53     function balanceOf(address _owner) constant returns (uint256 balance) {
54         return balances[_owner];
55     }
56 
57     function approve(address _spender, uint256 _value) returns (bool success) {
58         allowed[msg.sender][_spender] = _value;
59         Approval(msg.sender, _spender, _value);
60         return true;
61     }
62 
63     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
64       return allowed[_owner][_spender];
65     }
66 
67     mapping (address => uint256) balances;
68     mapping (address => mapping (address => uint256)) allowed;
69     uint256 public totalSupply;
70 }
71 
72 
73 contract PexCash is StandardToken {
74 
75     function () {
76         throw;
77     }
78 
79     
80     string public name;                   
81     uint8 public decimals;                
82     string public symbol;                 
83     string public version = 'H1.0';       
84 
85     function PexCash(
86         ) {
87         balances[msg.sender] = 2000000000000000000000000;
88         totalSupply = 2000000000000000000000000;                        
89         name = "PexCash";                                   
90         decimals = 18;                            
91         symbol = "PEXC";                            
92     }
93 
94     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
95         allowed[msg.sender][_spender] = _value;
96         Approval(msg.sender, _spender, _value);
97 
98         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
99         return true;
100     }
101 }