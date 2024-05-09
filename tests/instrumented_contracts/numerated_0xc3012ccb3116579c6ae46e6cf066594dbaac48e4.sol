1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-04
3 */
4 
5 pragma solidity ^0.4.26;
6 
7 library SafeMath {
8   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
15     assert(b > 0);
16     uint256 c = a / b;
17     assert(a == b * c + a % b);
18     return c;
19   }
20 
21   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c>=a && c>=b);
29     return c;
30   }
31 }
32 
33 contract Token {
34 
35     uint256 public totalSupply;
36 
37     function balanceOf(address _owner) constant public returns (uint256 balance);
38 
39     function transfer(address _to, uint256 _value) public returns (bool success);
40 
41     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
42 
43     function approve(address _spender, uint256 _value) public returns (bool success);
44 
45     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
46 
47     event Transfer(address indexed _from, address indexed _to, uint256 _value);
48     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
49 }
50 
51 contract StandardToken is Token {
52 
53     mapping (address => uint256) public balanceOf;
54     mapping (address => mapping (address => uint256)) allowed;
55 
56     function transfer(address _to, uint256 _value) public returns (bool success) {
57         require(_to != address(0));
58         require(_value <= balanceOf[msg.sender]);
59         require(balanceOf[_to] + _value > balanceOf[_to]);
60         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
61         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
62         emit Transfer(msg.sender, _to, _value);
63         return true;
64     }
65 
66     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
67         require(_to != address(0));
68         require(_value <= balanceOf[_from]);
69         require(_value <= allowed[_from][msg.sender]);
70         require(balanceOf[_to] + _value > balanceOf[_to]);
71         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
72         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);
73         allowed[_from][msg.sender] = SafeMath.safeSub(allowed[_from][msg.sender], _value);
74         emit Transfer(_from, _to, _value);
75         return true;
76     }
77 
78     function balanceOf(address _owner) constant public returns (uint256 balance) {
79         return balanceOf[_owner];
80     }
81 
82     function approve(address _spender, uint256 _value) public returns (bool success) {
83         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
84         allowed[msg.sender][_spender] = _value;
85         emit Approval(msg.sender, _spender, _value);
86         return true;
87     }
88 
89     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
90         return allowed[_owner][_spender];
91     }
92 }
93 
94 contract WPT is StandardToken {
95     function () public {
96         revert();
97     }
98 
99     string public name = "WBF Pool Token";
100     uint8 public decimals = 18;
101     string public symbol = "WPT";
102     uint256 public totalSupply = 30*10**26;
103 
104     constructor() public {
105         balanceOf[msg.sender] = totalSupply;
106         emit Transfer(address(0), msg.sender, totalSupply);
107     }
108 }