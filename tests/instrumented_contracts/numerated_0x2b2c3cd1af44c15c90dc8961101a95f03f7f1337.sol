1 /**
2  *Submitted for verification at Etherscan.io on 2019-01-19
3 */
4 
5 pragma solidity ^0.4.5;
6 
7 contract Token{
8     
9     uint256 public totalSupply;
10 
11     function balanceOf(address _owner) constant returns (uint256 balance);
12 
13     function transfer(address _to, uint256 _value) returns (bool success);
14 
15     function transferFrom(address _from, address _to, uint256 _value) returns   
16     (bool success);
17 
18     function approve(address _spender, uint256 _value) returns (bool success);
19 
20     function allowance(address _owner, address _spender) constant returns 
21     (uint256 remaining);
22 
23     event Transfer(address indexed _from, address indexed _to, uint256 _value);
24 
25     event Approval(address indexed _owner, address indexed _spender, uint256 
26     _value);
27 }
28 
29 contract StandardToken is Token {
30     function transfer(address _to, uint256 _value) returns (bool success) {
31  
32         require(balances[msg.sender] >= _value);
33         balances[msg.sender] -= _value;
34         balances[_to] += _value;
35         Transfer(msg.sender, _to, _value);
36         return true;
37     }
38 
39 
40     function transferFrom(address _from, address _to, uint256 _value) returns 
41     (bool success) {
42 
43         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && (balances[_to]+_value)>balances[_to]);
44         balances[_to] += _value;
45         balances[_from] -= _value;
46         allowed[_from][msg.sender] -= _value;
47         Transfer(_from, _to, _value);
48         return true;
49     }
50     function balanceOf(address _owner) constant returns (uint256 balance) {
51         return balances[_owner];
52     }
53 
54 
55     function approve(address _spender, uint256 _value) returns (bool success)   
56     {
57         allowed[msg.sender][_spender] = _value;
58         Approval(msg.sender, _spender, _value);
59         return true;
60     }
61 
62 
63     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
64         return allowed[_owner][_spender];
65     }
66     mapping (address => uint256) balances;
67     mapping (address => mapping (address => uint256)) allowed;
68 }
69 
70 contract HumanStandardToken is StandardToken { 
71 
72     string public name;             
73     uint8 public decimals;              
74     string public symbol;         
75     string public version = '1.0'; 
76 
77     function HumanStandardToken(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) {
78         balances[msg.sender] = _initialAmount; 
79         totalSupply = _initialAmount; 
80         name = _tokenName;   
81         decimals = _decimalUnits;  
82         symbol = _tokenSymbol;  
83     }
84 
85     
86     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
87         allowed[msg.sender][_spender] = _value;
88         Approval(msg.sender, _spender, _value);
89         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
90         return true;
91     }
92 
93 }