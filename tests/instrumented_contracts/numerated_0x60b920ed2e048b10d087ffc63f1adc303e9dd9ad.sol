1 pragma solidity ^0.4.10;
2 
3 
4 contract SafeMath {
5 
6 
7 
8     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
9       uint256 z = x + y;
10       assert((z >= x) && (z >= y));
11       return z;
12     }
13 
14     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
15       assert(x >= y);
16       uint256 z = x - y;
17       return z;
18     }
19 
20     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
21       uint256 z = x * y;
22       assert((x == 0)||(z/x == y));
23       return z;
24     }
25 
26 }
27 
28 contract Token {
29     uint256 public totalSupply;
30     function balanceOf(address _owner) constant returns  (uint256 balance);
31     function transfer(address _to, uint256 _value) returns (bool success);
32     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
33     function approve(address _spender, uint256 _value) returns (bool success);
34     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
35     event Transfer(address indexed _from, address indexed _to, uint256 _value);
36     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37 
38 }
39 
40 
41 
42 contract StandardToken is Token , SafeMath {
43 
44     bool public status = true;
45     modifier on() {
46         require(status == true);
47         _;
48       }
49 
50     function transfer(address _to, uint256 _value) on returns (bool success) {
51       if (balances[msg.sender] >= _value && _value > 0 && _to != 0X0) {
52         balances[msg.sender] -= _value;
53         balances[_to] = safeAdd(balances[_to],_value);
54         Transfer(msg.sender, _to, _value);
55         return true;
56       } else {
57         return false;
58       }
59     }
60 
61     function transferFrom(address _from, address _to, uint256 _value) on returns (bool success) {
62       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
63         balances[_to] = safeAdd(balances[_to],_value);
64         balances[_from] = safeSubtract(balances[_from],_value);
65         allowed[_from][msg.sender] = safeSubtract(allowed[_from][msg.sender],_value);
66         Transfer(_from, _to, _value);
67         return true;
68       } else {
69         return false;
70       }
71     }
72 
73     function balanceOf(address _owner) on constant returns (uint256 balance) {
74         return balances[_owner];
75     }
76 
77     function approve(address _spender, uint256 _value) on returns (bool success) {
78         allowed[msg.sender][_spender] = _value;
79         Approval(msg.sender, _spender, _value);
80         return true;
81     }
82 
83     function allowance(address _owner, address _spender) on constant returns (uint256 remaining) {
84       return allowed[_owner][_spender];
85     }
86 
87     mapping (address => uint256) balances;
88     mapping (address => mapping (address => uint256)) allowed;
89 }
90 
91 
92 
93 
94     contract HCTToken is StandardToken {
95       string public name = "HuobiChatToken";
96       uint8 public decimals = 18;
97       string public symbol = "HCT";
98       bool private init =true;
99       function turnon() controller {
100         status = true;
101       }
102       function turnoff() controller {
103         status = false;
104       }
105       function HCTToken() {
106         require(init==true);
107         totalSupply = 10000000000*10**18;
108         balances[0x3567cafb8bf2a83bbea4e79f3591142fb4ebe86d] = totalSupply;
109         Transfer(0x0000000000000000000000000000000000000000, 0x3567cafb8bf2a83bbea4e79f3591142fb4ebe86d, totalSupply);
110         init = false;
111 
112       }
113       address public controller1 =0x14de73a5602ee3769fb7a968daAFF23A4A6D4Bb5;
114 address public controller2 =0x3567cafb8bf2a83bbea4e79f3591142fb4ebe86d;
115 
116       modifier controller () {
117 
118         require(msg.sender == controller1||msg.sender == controller2);
119         _;
120       }
121     }