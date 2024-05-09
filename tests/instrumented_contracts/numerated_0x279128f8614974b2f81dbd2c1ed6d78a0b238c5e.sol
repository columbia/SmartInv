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
22 contract StandardToken is Token {
23 
24     function transfer(address _to, uint256 _value) returns (bool success) {
25         if (balances[msg.sender] >= _value && _value > 0) {
26             balances[msg.sender] -= _value;
27             balances[_to] += _value;
28             Transfer(msg.sender, _to, _value);
29             return true;
30         } else { return false; }
31     }
32 
33     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
34         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
35             balances[_to] += _value;
36             balances[_from] -= _value;
37             allowed[_from][msg.sender] -= _value;
38             Transfer(_from, _to, _value);
39             return true;
40         } else { return false; }
41     }
42 
43     function balanceOf(address _owner) constant returns (uint256 balance) {
44         return balances[_owner];
45     }
46 
47     function approve(address _spender, uint256 _value) returns (bool success) {
48         allowed[msg.sender][_spender] = _value;
49         Approval(msg.sender, _spender, _value);
50         return true;
51     }
52 
53     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
54       return allowed[_owner][_spender];
55     }
56 
57     mapping (address => uint256) balances;
58     mapping (address => mapping (address => uint256)) allowed;
59     uint256 public totalSupply;
60 }
61 
62 contract Gov is StandardToken {
63 
64     function () {
65         //if ether is sent to this address, send it back.
66         throw;
67     }
68 
69     /* Public variables of the token */
70 
71     /*
72     NOTE:
73     The following variables are OPTIONAL vanities. One does not have to include them.
74     They allow one to customise the token contract & in no way influences the core functionality.
75     Some wallets/interfaces might not even bother to look at this information.
76     */
77     string public name;                   //token名称: Gov 
78     uint8 public decimals;                //小数位
79     string public symbol;                 //标识
80     string public version = 'H0.1';       //版本号
81 
82     function Gov(
83         uint256 _initialAmount,
84         string _tokenName,
85         uint8 _decimalUnits,
86         string _tokenSymbol
87         ) {
88         balances[msg.sender] = _initialAmount;               // 合约发布者的余额是发行数量
89         totalSupply = _initialAmount;                        // 发行量
90         name = _tokenName;                                   // token名称
91         decimals = _decimalUnits;                            // token小数位
92         symbol = _tokenSymbol;                               // token标识
93     }
94 
95     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
96         allowed[msg.sender][_spender] = _value;
97         Approval(msg.sender, _spender, _value);
98 
99         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
100         return true;
101     }
102 }