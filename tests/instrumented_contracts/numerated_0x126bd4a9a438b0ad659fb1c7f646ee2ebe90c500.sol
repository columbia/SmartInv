1 pragma solidity ^0.4.19;
2 
3 
4 /**
5  * PIEXGO TEAM
6  */
7  
8 contract SafeMath {
9   function mul(uint256 a, uint256 b) internal returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal returns (uint256) {
16     assert(b > 0);
17     uint256 c = a / b;
18     assert(a == b * c + a % b);
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal returns (uint256) {
28     uint256 c = a + b;
29     assert(c>=a && c>=b);
30     return c;
31   }
32 
33   function assert(bool assertion) internal {
34     if (!assertion) {
35       throw;
36     }
37   }
38 }
39 
40 contract Token {
41 
42     function totalSupply() constant returns (uint256 supply) {}
43     function balanceOf(address _owner) constant returns (uint256 balance) {}
44     function transfer(address _to, uint256 _value) returns (bool success) {}
45     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
46     function approve(address _spender, uint256 _value) returns (bool success) {}
47     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
48 
49     event Transfer(address indexed _from, address indexed _to, uint256 _value);
50     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
51 }
52 
53 contract RegularToken is Token, SafeMath {
54 
55     function transfer(address _to, uint256 _value) returns (bool) {
56         require(balances[msg.sender] >= _value);
57         require(balances[_to] + _value >= balances[_to]);
58         balances[msg.sender] = sub(balances[msg.sender], _value);
59         balances[_to] = add(balances[_to], _value);
60         emit Transfer(msg.sender, _to, _value);
61         return true;
62     }
63 
64     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
65         require(balances[_from] >= _value);
66         require(balances[_to] + _value >= balances[_to]);
67         require(allowed[_from][msg.sender] >= _value);
68         balances[_from] = sub(balances[_from], _value);
69         balances[_to] = add(balances[_to], _value);
70         allowed[_from][msg.sender] = sub(allowed[_from][msg.sender], _value);
71         emit Transfer(_from, _to, _value);
72         return true;
73     }
74 
75     function balanceOf(address _owner) constant returns (uint256) {
76         return balances[_owner];
77     }
78 
79     function approve(address _spender, uint256 _value) returns (bool) {
80         allowed[msg.sender][_spender] = _value;
81         emit Approval(msg.sender, _spender, _value);
82         return true;
83     }
84 
85     function allowance(address _owner, address _spender) constant returns (uint256) {
86         return allowed[_owner][_spender];
87     }
88 
89     mapping (address => uint256) balances;
90     mapping (address => mapping (address => uint256)) allowed;
91     uint256 public totalSupply;
92 }
93 
94 
95 contract PXGToken is RegularToken {
96 
97     uint256 public totalSupply = 100*10**(18+8);
98     uint8 constant public decimals = 18;
99     string constant public name = "PIEXGO";
100     string constant public symbol = "PXG";
101 
102     function PXGToken() {
103         balances[msg.sender] = totalSupply;
104         emit Transfer(address(0), msg.sender, totalSupply);
105     }
106 }