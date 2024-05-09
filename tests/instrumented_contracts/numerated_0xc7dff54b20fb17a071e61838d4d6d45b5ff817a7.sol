1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
11     assert(b > 0);
12     uint256 c = a / b;
13     assert(a == b * c + a % b);
14     return c;
15   }
16 
17   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c>=a && c>=b);
25     return c;
26   }
27 }
28 
29 contract Token {
30 
31     uint256 public totalSupply;
32 
33     function balanceOf(address _owner) constant public returns (uint256 balance);
34 
35     function transfer(address _to, uint256 _value) public returns (bool success);
36 
37     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
38 
39     function approve(address _spender, uint256 _value) public returns (bool success);
40 
41     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
42 
43     event Transfer(address indexed _from, address indexed _to, uint256 _value);
44     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45 }
46 
47 contract StandardToken is Token {
48 
49     mapping (address => uint256) public balanceOf;
50     mapping (address => mapping (address => uint256)) allowed;
51 
52     function transfer(address _to, uint256 _value) public returns (bool success) {
53         require(_to != address(0));
54         require(_value <= balanceOf[msg.sender]);
55         require(balanceOf[_to] + _value > balanceOf[_to]);
56         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
57         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
58         Transfer(msg.sender, _to, _value);
59         return true;
60     }
61 
62     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
63         require(_to != address(0));
64         require(_value <= balanceOf[_from]);
65         require(_value <= allowed[_from][msg.sender]);
66         require(balanceOf[_to] + _value > balanceOf[_to]);
67         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
68         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);
69         allowed[_from][msg.sender] = SafeMath.safeSub(allowed[_from][msg.sender], _value);
70         Transfer(_from, _to, _value);
71         return true;
72     }
73 
74     function balanceOf(address _owner) constant public returns (uint256 balance) {
75         return balanceOf[_owner];
76     }
77 
78     function approve(address _spender, uint256 _value) public returns (bool success) {
79         allowed[msg.sender][_spender] = _value;
80         Approval(msg.sender, _spender, _value);
81         return true;
82     }
83 
84     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
85         return allowed[_owner][_spender];
86     }
87 }
88 
89 contract NLL is StandardToken {
90 
91     function () public {
92         revert();
93     }
94 
95     string public name = "NLLCOIN";
96     uint8 public decimals = 18;
97     string public symbol = "NLL";
98     string public version = 'v0.1';
99     uint256 public totalSupply = 0;
100 
101     function NLL () {
102         totalSupply = 100000000 * 10 ** uint256(decimals);
103         balanceOf[msg.sender] = totalSupply;
104     }
105 }