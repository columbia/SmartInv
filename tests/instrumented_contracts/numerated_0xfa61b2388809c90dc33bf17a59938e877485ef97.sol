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
18 
19     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
20 }
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
60     uint256 public totalSupply;
61 }
62 
63 
64 contract AllTraceabilitySourceChain is StandardToken {
65 
66     function () {
67         throw;
68     }
69 
70     string public name;                   //token名称: AllTraceabilitySourceChain 
71     uint8 public decimals;                //小数位
72     string public symbol;                 //标识
73     string public version = 'v1.0';       //版本号
74 
75     function AllTraceabilitySourceChain(
76         uint256 _initialAmount,
77         string _tokenName,
78         uint8 _decimalUnits,
79         string _tokenSymbol
80         ) {
81         balances[msg.sender] = _initialAmount;               // 合约发布者的余额是发行数量
82         totalSupply = _initialAmount;                        // 发行量
83         name = _tokenName;                                   // token名称
84         decimals = _decimalUnits;                            // token小数位
85         symbol = _tokenSymbol;                               // token标识
86     }
87 
88 
89     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
90         allowed[msg.sender][_spender] = _value;
91         Approval(msg.sender, _spender, _value);
92 
93         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
94         return true;
95     }
96 }