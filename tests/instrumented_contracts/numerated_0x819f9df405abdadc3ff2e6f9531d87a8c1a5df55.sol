1 pragma solidity ^0.4.0;
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
15     function transfer(address _to, uint256 _value) returns (bool success) {
16         if (balances[msg.sender] >= _value && _value > 0) {
17             balances[msg.sender] -= _value;
18             balances[_to] += _value;
19             Transfer(msg.sender, _to, _value);
20             return true;
21         } else {
22             return false;
23         }
24     }
25 
26     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
27         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
28             balances[_to] += _value;
29             balances[_from] -= _value;
30             allowed[_from][msg.sender] -= _value;
31             Transfer(_from, _to, _value);
32             return true;
33         } else {
34             return false;
35         }
36     }
37 
38     function balanceOf(address _owner) constant returns (uint256 balance) {
39         return balances[_owner];
40     }
41 
42     function approve(address _spender, uint256 _value) returns (bool success) {
43         allowed[msg.sender][_spender] = _value;
44         Approval(msg.sender, _spender, _value);
45         return true;
46     }
47 
48     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
49         return allowed[_owner][_spender];
50     }
51 
52     mapping (address => uint256) balances;
53     mapping (address => mapping (address => uint256)) allowed;
54     uint256 public totalSupply;
55 }
56 
57 contract HumanStandardToken is StandardToken {
58     function () { 
59         throw;
60     }
61 
62     uint8 public decimals;
63     string public name;
64     string public symbol;
65 
66     function HumanStandardToken(
67         uint256 _initialAmount,
68         uint8 _decimalUnits,
69         string _tokenName,
70         string _tokenSymbol
71     ) {
72         decimals = _decimalUnits;                            
73         totalSupply = _initialAmount * 10 ** uint256(decimals);                        
74         balances[msg.sender] = totalSupply;               
75         name = _tokenName;                                   
76         symbol = _tokenSymbol;                               
77     }
78 
79     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
80         allowed[msg.sender][_spender] = _value;
81         Approval(msg.sender, _spender, _value);
82         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) {
83             throw;
84         }
85         return true;
86     }
87 }