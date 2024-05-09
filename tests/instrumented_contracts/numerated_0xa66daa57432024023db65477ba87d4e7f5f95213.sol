1 pragma solidity ^0.4.10;
2 
3 
4 contract SafeMath {
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
22 
23 }
24 
25 contract Token {
26     uint256 public totalSupply;
27     function balanceOf(address _owner) constant returns  (uint256 balance);
28     function transfer(address _to, uint256 _value) returns (bool success);
29     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
30     function approve(address _spender, uint256 _value) returns (bool success);
31     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
32     event Transfer(address indexed _from, address indexed _to, uint256 _value);
33     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
34 
35 }
36 
37 
38 
39 contract StandardToken is Token , SafeMath {
40 
41     bool public status = true;
42     modifier on() {
43         require(status == true);
44         _;
45     }
46 
47     function transfer(address _to, uint256 _value) on returns (bool success) {
48         if (balances[msg.sender] >= _value && _value > 0 && _to != 0X0) {
49             balances[msg.sender] -= _value;
50             balances[_to] = safeAdd(balances[_to],_value);
51             Transfer(msg.sender, _to, _value);
52             return true;
53         } else {
54             return false;
55         }
56     }
57 
58     function transferFrom(address _from, address _to, uint256 _value) on returns (bool success) {
59         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
60             balances[_to] = safeAdd(balances[_to],_value);
61             balances[_from] = safeSubtract(balances[_from],_value);
62             allowed[_from][msg.sender] = safeSubtract(allowed[_from][msg.sender],_value);
63             Transfer(_from, _to, _value);
64             return true;
65         } else {
66             return false;
67         }
68     }
69 
70     function balanceOf(address _owner) on constant returns (uint256 balance) {
71         return balances[_owner];
72     }
73 
74     function approve(address _spender, uint256 _value) on returns (bool success) {
75         allowed[msg.sender][_spender] = _value;
76         Approval(msg.sender, _spender, _value);
77         return true;
78     }
79 
80     function allowance(address _owner, address _spender) on constant returns (uint256 remaining) {
81         return allowed[_owner][_spender];
82     }
83 
84     mapping (address => uint256) balances;
85     mapping (address => mapping (address => uint256)) allowed;
86 }
87 
88 
89 
90 
91 contract HuobiPoolToken is StandardToken {
92     string public name = "HuobiPoolToken";
93     uint8 public decimals = 18;
94     string public symbol = "HPT";
95     bool private init =true;
96     function turnon() controller {
97         status = true;
98     }
99     function turnoff() controller {
100         status = false;
101     }
102     function HuobiPoolToken() {
103         require(init==true);
104         totalSupply = 10000000000*10**18;
105         balances[0x3567cafb8bf2a83bbea4e79f3591142fb4ebe86d] = totalSupply;
106         init = false;
107     }
108     address public controller1 =0x14de73a5602ee3769fb7a968daAFF23A4A6D4Bb5;
109     address public controller2 =0x3567cafb8bf2a83bbea4e79f3591142fb4ebe86d;
110 
111     modifier controller () {
112         require(msg.sender == controller1||msg.sender == controller2);
113         _;
114     }
115 }