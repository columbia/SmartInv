1 pragma solidity 0.4.24;
2 
3 
4 contract ERC20 {
5     function totalSupply() constant public returns (uint256 supply);
6     function balanceOf(address _owner) constant public returns (uint256 balance);
7     function transfer(address _to, uint256 _value) public returns (bool success);
8     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
9     function approve(address _spender, uint256 _value) public returns (bool success);
10     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 
15 }
16 
17 contract SafeMath {
18 
19     function safeSub(uint a, uint b) internal pure returns (uint) {
20         assert(b <= a);
21         return a - b;
22     }
23 
24     function safeAdd(uint a, uint b) internal pure returns (uint) {
25         uint c = a + b;
26         assert(c >= a);
27         return c;
28     }
29     
30     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
31         return a >= b ? a : b;
32     }
33 
34     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
35         return a < b ? a : b;
36     }
37 
38     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
39         return a >= b ? a : b;
40     }
41 
42     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
43         return a < b ? a : b;
44 }
45 
46 }
47 
48 
49 contract Rune is ERC20, SafeMath {
50 
51     string public constant name = "Rune";
52     string public constant symbol = "RUNE";
53     uint256 public constant decimals = 18;
54     uint256 public constant totalTokens = 1000000000 * (10 ** decimals);
55 
56     mapping (address => uint256) public balances;
57     mapping (address => mapping (address => uint256)) public allowed;
58 
59      constructor () public {
60         balances[msg.sender] = totalTokens;
61     }
62 
63     function totalSupply() public view returns (uint256) {
64         return totalTokens;
65     }
66 
67     
68     function transfer(address to, uint tokens) public returns (bool success) {
69         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
70         balances[to] = safeAdd(balances[to], tokens);
71         emit Transfer(msg.sender, to, tokens);
72         return true;
73     }
74 
75     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
76         balances[from] = safeSub(balances[from], tokens);
77         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
78         balances[to] = safeAdd(balances[to], tokens);
79         emit Transfer(from, to, tokens);
80         return true;
81     }
82 
83     function balanceOf(address _owner) constant public returns (uint256) {
84         return balances[_owner];
85     }
86     
87 
88     function approve(address _spender, uint256 _value) public returns (bool) {
89         allowed[msg.sender][_spender] = _value;
90         emit Approval(msg.sender, _spender, _value);
91         return true;
92     }
93 
94     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
95         return allowed[_owner][_spender];
96     }
97     
98 
99 
100 }