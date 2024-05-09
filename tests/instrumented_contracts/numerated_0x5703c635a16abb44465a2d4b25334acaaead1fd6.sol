1 pragma solidity ^0.4.13;
2 contract SafeMath {
3 
4     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
5         uint256 z = x + y;
6         assert((z >= x) && (z >= y));
7         return z;
8     }
9 
10     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
11         assert(x >= y);
12         uint256 z = x - y;
13         return z;
14     }
15 
16     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
17         uint256 z = x * y;
18         assert((x == 0)||(z/x == y));
19         return z;
20     }
21 }
22 
23 contract Token {
24     uint256 public totalSupply;
25 
26     function balanceOf(address _owner) constant returns (uint256 balance);
27     function transfer(address _to, uint256 _value) returns (bool success);
28     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
29     function approve(address _spender, uint256 _value) returns (bool success);
30     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
31 
32     event Transfer(address indexed _from, address indexed _to, uint256 _value);
33     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
34 }
35 
36 /*  ERC 20 token */
37 contract StandardToken is Token, SafeMath {
38 
39     mapping (address => uint256) balances;
40     mapping (address => mapping (address => uint256)) allowed;
41 
42     modifier onlyPayloadSize(uint numwords) {
43         assert(msg.data.length == numwords * 32 + 4);
44         _;
45     }
46 
47     function transfer(address _to, uint256 _value)
48     returns (bool success)
49     {
50         if (balances[msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
51             balances[msg.sender] = safeSubtract(balances[msg.sender], _value);
52             balances[_to] = safeAdd(balances[_to], _value);
53             Transfer(msg.sender, _to, _value);
54             return true;
55         } else {
56             return false;
57         }
58     }
59 
60     function transferFrom(address _from, address _to, uint256 _value)
61     returns (bool success)
62     {
63         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
64             balances[_to] = safeAdd(balances[_to], _value);
65             balances[_from] = safeSubtract(balances[_from], _value);
66             allowed[_from][msg.sender] = safeSubtract(allowed[_from][msg.sender], _value);
67             Transfer(_from, _to, _value);
68             return true;
69         } else {
70             return false;
71         }
72     }
73 
74     function balanceOf(address _owner) constant returns (uint256 balance) {
75         return balances[_owner];
76     }
77 
78     function approve(address _spender, uint256 _value)
79     onlyPayloadSize(2)
80     returns (bool success)
81     {
82         allowed[msg.sender][_spender] = _value;
83         Approval(msg.sender, _spender, _value);
84         return true;
85     }
86 
87     function allowance(address _owner, address _spender)
88     constant
89     onlyPayloadSize(2)
90     returns (uint256 remaining)
91     {
92         return allowed[_owner][_spender];
93     }
94 }
95 /**
96  * @title VIBECoin
97  * @dev ERC20 Token, where all tokens are pre-assigned to the creator.
98  * Note they can later distribute these tokens as they wish using `transfer` and other
99  * `StandardToken` functions.
100  */
101 contract HubiiNetworkTokens is StandardToken {
102 
103 
104   string public name = "Hubii network tokens";
105   string public symbol = "HNBT";
106   uint256 public decimals = 18;
107   uint256 public INITIAL_SUPPLY = 267000000 * 1 ether;
108 
109   /**
110    * @dev Contructor that gives msg.sender all of existing tokens.
111    */
112   function HubiiNetworkTokens() {
113     totalSupply = INITIAL_SUPPLY;
114     balances[msg.sender] = INITIAL_SUPPLY;
115   }
116 
117 }