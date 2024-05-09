1 /**
2  * Welcome to FrogDAO
3  * 
4  * FrogDAO is a decentralized incubator that helps promising projects achieve their full potential 
5  * by leveraging the investment power and buzz making potential of our community. 
6  * 
7  * Unlike other decentralized incubators, FrogDAO specializes 
8  * in projects who are looking to build on Cardano (ADA). 
9  * 
10  * FrogDAO especially values the safety brought to users and developers on Cardano (ADA).
11  * 
12  * Join the Frogs at: 
13  * 
14  * https://frogdao.com
15  * 
16  * https://t.me/FrogDAO
17  * 
18  * https://twitter.com/frogdao
19  *
20 */
21 
22 pragma solidity ^0.5.0;
23 
24 contract ERC20Interface {
25     function totalSupply() public view returns (uint);
26     function balanceOf(address tokenOwner) public view returns (uint balance);
27     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
28     function transfer(address to, uint tokens) public returns (bool success);
29     function approve(address spender, uint tokens) public returns (bool success);
30     function transferFrom(address from, address to, uint tokens) public returns (bool success);
31 
32     event Transfer(address indexed from, address indexed to, uint tokens);
33     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
34 }
35 
36 contract SafeMath {
37     function safeAdd(uint a, uint b) public pure returns (uint c) {
38         c = a + b;
39         require(c >= a);
40     }
41     function safeSub(uint a, uint b) public pure returns (uint c) {
42         require(b <= a); c = a - b; } function safeMul(uint a, uint b) public pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); } function safeDiv(uint a, uint b) public pure returns (uint c) { require(b > 0);
43         c = a / b;
44     }
45 }
46 
47 contract FrogDAO is ERC20Interface, SafeMath {
48     string public name;
49     string public symbol;
50     uint8 public decimals;
51     
52     uint256 public _totalSupply;
53     
54     mapping(address => uint) balances;
55     mapping(address => mapping(address => uint)) allowed;
56     
57     constructor() public {
58         name = "FrogDAO Dime";
59         symbol = "$FDD";
60         decimals = 18;
61         _totalSupply = 1000000000000000000000000;
62         
63         balances[msg.sender] = _totalSupply;
64         emit Transfer(address(0), msg.sender, _totalSupply);
65     }
66     
67     function totalSupply() public view returns (uint) {
68         return _totalSupply  - balances[address(0)];
69     }
70     
71     function balanceOf(address tokenOwner) public view returns (uint balance) {
72         return balances[tokenOwner];
73     }
74     
75     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
76         return allowed[tokenOwner][spender];
77     }
78     
79     function approve(address spender, uint tokens) public returns (bool success) {
80         allowed[msg.sender][spender] = tokens;
81         emit Approval(msg.sender, spender, tokens);
82         return true;
83     }
84     
85     function transfer(address to, uint tokens) public returns (bool success) {
86         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
87         balances[to] = safeAdd(balances[to], tokens);
88         emit Transfer(msg.sender, to, tokens);
89         return true;
90     }
91     
92     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
93         balances[from] = safeSub(balances[from], tokens);
94         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
95         balances[to] = safeAdd(balances[to], tokens);
96         emit Transfer(from, to, tokens);
97         return true;
98     }
99 }