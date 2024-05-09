1 pragma solidity ^0.4.8;
2 
3 contract Token {
4 
5     uint256 public totalSupply;
6 
7     function balanceOf(address _owner) constant returns (uint256 balance);
8 
9     function transfer(address _to, uint256 _value) returns (bool success);
10 
11     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
12 
13     function approve(address _spender, uint256 _value) returns (bool success);
14 
15     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
16 
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
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
60 }
61 
62 contract PiedPiperCoin is StandardToken {
63 
64     function () {
65         revert();
66     }
67 
68     string public name;
69     uint8 public decimals;
70     string public symbol;
71     string public version = 'PPC1.0';
72 
73     function PiedPiperCoin(
74         uint256 _initialAmount,
75         string _tokenName,
76         uint8 _decimalUnits,
77         string _tokenSymbol
78         ) {
79         balances[msg.sender] = _initialAmount;
80         totalSupply = _initialAmount;
81         name = _tokenName;
82         decimals = _decimalUnits;
83         symbol = _tokenSymbol;
84     }
85 
86 
87     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
88         allowed[msg.sender][_spender] = _value;
89         Approval(msg.sender, _spender, _value);
90 
91         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
92         return true;
93     }
94 }