1 pragma solidity ^0.4.8;
2 
3 ///////////////
4 // SAFE MATH //
5 ///////////////
6 
7 contract SafeMath {
8 
9     function assert(bool assertion) internal {
10         if (!assertion) {
11             throw;
12         }
13     }      // assert no longer needed once solidity is on 0.4.10
14 
15     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
16       uint256 z = x + y;
17       assert((z >= x) && (z >= y));
18       return z;
19     }
20 
21     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
22       assert(x >= y);
23       uint256 z = x - y;
24       return z;
25     }
26 
27     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
28       uint256 z = x * y;
29       assert((x == 0)||(z/x == y));
30       return z;
31     }
32 
33 }
34 
35 ////////////////////
36 // STANDARD TOKEN //
37 ////////////////////
38 
39 contract Token {
40     uint256 public totalSupply;
41     function balanceOf(address _owner) constant returns (uint256 balance);
42     function transfer(address _to, uint256 _value) returns (bool success);
43     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
44     function approve(address _spender, uint256 _value) returns (bool success);
45     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
46     event Transfer(address indexed _from, address indexed _to, uint256 _value);
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 }
49 
50 /*  ERC 20 token */
51 contract StandardToken is Token {
52 
53     function transfer(address _to, uint256 _value) returns (bool success) {
54       if (balances[msg.sender] >= _value && _value > 0) {
55         balances[msg.sender] -= _value;
56         balances[_to] += _value;
57         Transfer(msg.sender, _to, _value);
58         return true;
59       } else {
60         return false;
61       }
62     }
63 
64     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
65       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
66         balances[_to] += _value;
67         balances[_from] -= _value;
68         allowed[_from][msg.sender] -= _value;
69         Transfer(_from, _to, _value);
70         return true;
71       } else {
72         return false;
73       }
74     }
75 
76     function balanceOf(address _owner) constant returns (uint256 balance) {
77         return balances[_owner];
78     }
79 
80     function approve(address _spender, uint256 _value) returns (bool success) {
81         allowed[msg.sender][_spender] = _value;
82         Approval(msg.sender, _spender, _value);
83         return true;
84     }
85 
86     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
87       return allowed[_owner][_spender];
88     }
89 
90     mapping (address => uint256) balances;
91     mapping (address => mapping (address => uint256)) allowed;
92 }
93 
94 /////////////////////
95 // HOT CHAIN TOKEN //
96 /////////////////////
97 
98 contract Ccc is StandardToken, SafeMath {
99     // Descriptive properties
100     string public constant name = "Coin Controller Cash";
101     string public constant symbol = "CCC";
102     uint256 public constant decimals = 18; 
103     uint256 public totalSupply = 2000000000 * 10**decimals;
104     string public version = "1.0";
105 
106     // Account for ether proceed.
107     address public etherProceedsAccount;
108 
109     uint256 public constant CAP =  2000000000 * 10**decimals;
110 
111     // constructor
112     function Ccc(address _etherProceedsAccount) {
113       etherProceedsAccount = _etherProceedsAccount;
114       balances[etherProceedsAccount] += CAP;
115       Transfer(this, etherProceedsAccount, CAP);
116     }
117 
118     function () payable public {
119       require(msg.value == 0);
120     }
121 }