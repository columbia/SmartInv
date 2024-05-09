1 pragma solidity ^0.4.20;
2 
3 
4 contract ERC20 {
5     uint public totalSupply;
6     function balanceOf(address who) public constant returns (uint);
7     function allowance(address owner, address spender) public constant returns (uint);
8     function transfer(address to, uint value) public returns (bool ok);
9     function transferFrom(address from, address to, uint value) public returns (bool ok);
10     function approve(address spender, uint value) public returns (bool ok);
11     event Transfer(address indexed from, address indexed to, uint value);
12     event Approval(address indexed owner, address indexed spender, uint value);
13 }
14 
15 contract SafeMath {
16     function safeMul(uint a, uint b) internal pure returns (uint) {
17         uint c = a * b;
18         assert1(a == 0 || c / a == b);
19         return c;
20     }
21 
22     function safeDiv(uint a, uint b) internal pure returns (uint) {
23         assert1(b > 0);
24         uint c = a / b;
25         assert1(a == b * c + a % b);
26         return c;
27     }
28 
29     function safeSub(uint a, uint b) internal pure returns (uint) {
30         assert1(b <= a);
31         return a - b;
32     }
33 
34     function safeAdd(uint a, uint b) internal pure returns (uint) {
35         uint c = a + b;
36         assert1(c >= a && c >= b);
37         return c;
38     }
39 
40     function assert1(bool assertion) internal pure {
41         require(assertion);
42     }
43 }
44 
45 contract ZionToken is SafeMath, ERC20 {
46     string public constant name = "Zion - The Next Generation Communication Paradigm";
47     string public constant symbol = "Zion";
48     uint256 public constant decimals = 18;  
49 
50     mapping (address => uint256) balances;
51     mapping (address => mapping (address => uint256)) allowed;
52 
53     function ZionToken() public {
54         totalSupply = 5000000000 * 10 ** uint256(decimals);
55         balances[msg.sender] = totalSupply;
56     }
57 
58     function balanceOf(address who) public constant returns (uint) {
59         return balances[who];
60     }
61 
62     function transfer(address to, uint256 value) public returns (bool) {
63         uint256 senderBalance = balances[msg.sender];
64         if (senderBalance >= value && value > 0) {
65             senderBalance = safeSub(senderBalance, value);
66             balances[msg.sender] = senderBalance;
67             balances[to] = safeAdd(balances[to], value);
68             emit Transfer(msg.sender, to, value);
69             return true;
70         } else {
71             revert();
72         }
73     }
74 
75 
76     function transferFrom(address from, address to, uint256 value) public returns (bool) {
77         if (balances[from] >= value &&
78         allowed[from][msg.sender] >= value &&
79         safeAdd(balances[to], value) > balances[to])
80         {
81             balances[to] = safeAdd(balances[to], value);
82             balances[from] = safeSub(balances[from], value);
83             allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], value);
84             emit Transfer(from, to, value);
85             return true;
86         } else {
87             revert();
88         }
89     }
90 
91     function approve(address spender, uint256 value) public returns (bool) {
92         allowed[msg.sender][spender] = value;
93         emit Approval(msg.sender, spender, value);
94         return true;
95     }
96 
97 
98     function allowance(address owner, address spender) public constant returns (uint) {
99         uint allow = allowed[owner][spender];
100         return allow;
101     }
102 }