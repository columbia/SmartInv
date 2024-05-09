1 pragma solidity ^0.4.13;
2 
3 contract SafeMath {
4     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
5       uint256 z = x + y;
6       assert((z >= x) && (z >= y));
7       return z;
8     }
9 
10     function safeSubtrCPCE(uint256 x, uint256 y) internal returns(uint256) {
11       assert(x >= y);
12       uint256 z = x - y;
13       return z;
14     }
15 
16     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
17       uint256 z = x * y;
18       assert((x == 0)||(z/x == y));
19       return z;
20     }
21 
22 }
23 
24 contract Token {
25     uint256 public totalSupply;
26     function balanceOf(address _owner) constant returns (uint256 balance);
27     function transfer(address _to, uint256 _value) returns (bool success);
28     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
29     function approve(address _spender, uint256 _value) returns (bool success);
30     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
31     event Transfer(address indexed _from, address indexed _to, uint256 _value);
32     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
33 }
34 
35 
36 /*  ERC 20 token */
37 contract StandardToken is Token {
38 
39     function transfer(address _to, uint256 _value) returns (bool success) {
40       if (balances[msg.sender] >= _value && _value > 0) {
41         balances[msg.sender] -= _value;
42         balances[_to] += _value;
43         Transfer(msg.sender, _to, _value);
44         return true;
45       } else {
46         return false;
47       }
48     }
49 
50     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
51       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
52         balances[_to] += _value;
53         balances[_from] -= _value;
54         allowed[_from][msg.sender] -= _value;
55         Transfer(_from, _to, _value);
56         return true;
57       } else {
58         return false;
59       }
60     }
61 
62     function balanceOf(address _owner) constant returns (uint256 balance) {
63         return balances[_owner];
64     }
65 
66     function approve(address _spender, uint256 _value) returns (bool success) {
67         allowed[msg.sender][_spender] = _value;
68         Approval(msg.sender, _spender, _value);
69         return true;
70     }
71 
72     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
73       return allowed[_owner][_spender];
74     }
75 
76     mapping (address => uint256) balances;
77     mapping (address => mapping (address => uint256)) allowed;
78 }
79 
80 contract CPCE is StandardToken, SafeMath {
81 
82     string public constant name = "CPC";
83     string public constant symbol = "CPC";
84     uint256 public constant decimals = 18;
85     string public version = "1.0";
86 
87     address public CPCEPrivateDeposit;
88     address public CPCEIcoDeposit;
89     address public CPCEFundDeposit;
90 
91     uint256 public constant factorial = 6;
92     uint256 public constant CPCEPrivate = 150 * (10**factorial) * 10**decimals; //150m私募代币数量，共计1.5亿代币
93     uint256 public constant CPCEIco = 150 * (10**factorial) * 10**decimals; //150m的ico代币数量，共计1.5亿代币
94     uint256 public constant CPCEFund = 380 * (10**factorial) * 10**decimals; //380m的ico代币数量，共计3.8亿代币
95   
96 
97     // constructor
98     function CPCE()
99     {
100       CPCEPrivateDeposit = 0x335B73c9054eBa7652484B5dA36dB45dB92de4c3;
101       CPCEIcoDeposit = 0x84d9E8671DaF07CEb5fa35137636B93dc395f118;
102       CPCEFundDeposit = 0xd7BAD068E961cCBe95e318c7aC118833A613c762;
103 
104       balances[CPCEPrivateDeposit] = CPCEPrivate;
105       balances[CPCEIcoDeposit] = CPCEIco;
106       balances[CPCEFundDeposit] = CPCEFund;
107     }
108 }