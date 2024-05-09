1 pragma solidity ^0.4.8;
2 contract Token{
3     uint256 public totalSupply;
4 
5     function balanceOf(address _owner) constant returns (uint256 balance);
6 
7     function transfer(address _to, uint256 _value) returns (bool success);
8 
9     function transferFrom(address _from, address _to, uint256 _value) returns   
10     (bool success);
11 
12     function approve(address _spender, uint256 _value) returns (bool success);
13 
14     function allowance(address _owner, address _spender) constant returns 
15     (uint256 remaining);
16 
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18 
19     event Approval(address indexed _owner, address indexed _spender, uint256 
20     _value);
21 }
22 
23 contract StandardToken is Token {
24     function transfer(address _to, uint256 _value) returns (bool success) {
25         require(balances[msg.sender] >= _value);
26         balances[msg.sender] -= _value;
27         balances[_to] += _value;
28         Transfer(msg.sender, _to, _value);
29         return true;
30     }
31 
32     function transferFrom(address _from, address _to, uint256 _value) returns 
33     (bool success) {
34         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
35         balances[_to] += _value;
36         balances[_from] -= _value;
37         allowed[_from][msg.sender] -= _value;
38         Transfer(_from, _to, _value);
39         return true;
40     }
41     function balanceOf(address _owner) constant returns (uint256 balance) {
42         return balances[_owner];
43     }
44 
45     function approve(address _spender, uint256 _value) returns (bool success)   
46     {
47         allowed[msg.sender][_spender] = _value;
48         Approval(msg.sender, _spender, _value);
49         return true;
50     }
51 
52     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
53         return allowed[_owner][_spender];
54     }
55     mapping (address => uint256) balances;
56     mapping (address => mapping (address => uint256)) allowed;
57 }
58 
59 contract V91Token is StandardToken { 
60 
61     string public name;
62     uint8 public decimals;
63     string public symbol;
64     string public version = 'H0.1';
65 
66     function V91Token(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) {
67         balances[msg.sender] = _initialAmount;
68         totalSupply = _initialAmount;
69         name = _tokenName;
70         decimals = _decimalUnits;
71         symbol = _tokenSymbol;
72     }
73     
74     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
75         allowed[msg.sender][_spender] = _value;
76         Approval(msg.sender, _spender, _value);
77         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
78         return true;
79     }
80 
81 }