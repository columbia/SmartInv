1 pragma solidity ^0.4.18;
2 
3 contract SafeMath {
4 
5     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
6         uint256 z = x + y;
7         assert((z >= x) && (z >= y));
8         return z;
9     }
10 
11     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
12         assert(x >= y);
13         uint256 z = x - y;
14         return z;
15     }
16 
17     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
18         uint256 z = x * y;
19         assert((x == 0)||(z/x == y));
20         return z;
21     }
22 }
23 
24 contract Token {
25     uint256 public totalSupply;
26 
27     function balanceOf(address _owner) constant returns (uint256 balance);
28     function transfer(address _to, uint256 _value) returns (bool success);
29     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
30     function approve(address _spender, uint256 _value) returns (bool success);
31     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
32 
33     event Transfer(address indexed _from, address indexed _to, uint256 _value);
34     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
35 }
36 
37 /*  ERC 20 token */
38 contract StandardToken is Token, SafeMath {
39 
40     mapping (address => uint256) balances;
41     mapping (address => mapping (address => uint256)) allowed;
42 
43     modifier onlyPayloadSize(uint numwords) {
44         assert(msg.data.length == numwords * 32 + 4);
45         _;
46     }
47 
48     function transfer(address _to, uint256 _value)
49     returns (bool success)
50     {
51         if (balances[msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
52             balances[msg.sender] = safeSubtract(balances[msg.sender], _value);
53             balances[_to] = safeAdd(balances[_to], _value);
54             Transfer(msg.sender, _to, _value);
55             return true;
56         } else {
57             return false;
58         }
59     }
60 
61     function transferFrom(address _from, address _to, uint256 _value)
62     returns (bool success)
63     {
64         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
65             balances[_to] = safeAdd(balances[_to], _value);
66             balances[_from] = safeSubtract(balances[_from], _value);
67             allowed[_from][msg.sender] = safeSubtract(allowed[_from][msg.sender], _value);
68             Transfer(_from, _to, _value);
69             return true;
70         } else {
71             return false;
72         }
73     }
74 
75     function balanceOf(address _owner) constant returns (uint256 balance) {
76         return balances[_owner];
77     }
78 
79     function approve(address _spender, uint256 _value)
80     onlyPayloadSize(2)
81     returns (bool success)
82     {
83         allowed[msg.sender][_spender] = _value;
84         Approval(msg.sender, _spender, _value);
85         return true;
86     }
87 
88     function allowance(address _owner, address _spender)
89     constant
90     onlyPayloadSize(2)
91     returns (uint256 remaining)
92     {
93         return allowed[_owner][_spender];
94     }
95 }
96 /**
97  * @title NitroCoins
98  * @dev ERC20 Token, where all tokens are pre-assigned to the creator.
99  * Note they can later distribute these tokens as they wish using `transfer` and other
100  * `StandardToken` functions.
101  */
102 contract NitroCoins is StandardToken {
103 
104   string public name = "Nitro Coins";
105   string public symbol = "NRC";
106   uint256 public decimals = 18;
107   uint256 public INITIAL_SUPPLY = 25000000 * 1 ether;
108 
109   /**
110    * @dev Contructor that gives msg.sender all of existing tokens.
111    */
112   function NitroCoins() {
113     totalSupply = INITIAL_SUPPLY;
114     balances[msg.sender] = INITIAL_SUPPLY;
115   }
116 
117 }