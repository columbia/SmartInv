1 /**
2  *Submitted for verification at Etherscan.io on 2022-11-11
3 */
4 
5 pragma solidity ^0.5.0;
6 // ----------------------------------------------------------------------------
7 // 
8 //  Maybe you've been with us since shibainu days or you discovered shibagun yesterday,
9 //  it doesn't matter to us because we are all shibaarmy members welcome to shibagun club
10 //     award distribution address : (0x8f58098791aAf39e4d40c65865DfeB961a17F558)
11 //   ***Total supply: 27,112,012,000 ***
12 //   
13 //    prize and burn  %50
14 //    Marketing %5
15 //    Liquidity %45 ( locked for a year)
16 //    TEAM     :00000000000%
17 //    Shibagun Official Portals -- https://linktr.ee/shytoshikusama
18 //    Website — http://shibagun.com
19 //    Twitter** https://twitter.com/ShibaStrength
20 //    Telegram — https://t.me/shibagun
21 //
22 // ----------------------------------------------------------------------------
23 contract ERC20Interface {
24     function totalSupply() public view returns (uint);
25     function balanceOf(address tokenOwner) public view returns (uint balance);
26     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
27     function transfer(address to, uint tokens) public returns (bool success);
28     function approve(address spender, uint tokens) public returns (bool success);
29     function transferFrom(address from, address to, uint tokens) public returns (bool success);
30 
31     event Transfer(address indexed from, address indexed to, uint tokens);
32     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
33 }
34 
35 // ----------------------------------------------------------------------------
36 // Safe Math Library 
37 // ----------------------------------------------------------------------------
38 contract SafeMath {
39     function safeAdd(uint a, uint b) public pure returns (uint c) {
40         c = a + b;
41         require(c >= a);
42     }
43     function safeSub(uint a, uint b) public pure returns (uint c) {
44         require(b <= a); c = a - b; } function safeMul(uint a, uint b) public pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); } function safeDiv(uint a, uint b) public pure returns (uint c) { require(b > 0);
45         c = a / b;
46     }
47 }
48 
49 
50 contract Shibagun is ERC20Interface, SafeMath {
51     string public name;
52     string public symbol;
53     uint8 public decimals; // 18 decimals is the strongly suggested default, avoid changing it
54     
55     uint256 public _totalSupply;
56     
57     mapping(address => uint) balances;
58     mapping(address => mapping(address => uint)) allowed;
59     
60     /**
61      * Constrctor function
62      *
63      * Initializes contract with initial supply tokens to the creator of the contract
64      */
65     constructor() public {
66         name = "Shibagun";
67         symbol = "Shibgun";
68         decimals = 18;
69         _totalSupply = 27112012000* (uint256(10) ** decimals);
70 
71         
72         balances[msg.sender] = _totalSupply;
73         emit Transfer(address(0xB8f226dDb7bC672E27dffB67e4adAbFa8c0dFA08), msg.sender, _totalSupply);
74     }
75     
76     function totalSupply() public view returns (uint) {
77         return _totalSupply  - balances[address(0xB8f226dDb7bC672E27dffB67e4adAbFa8c0dFA08)];
78     }
79     
80     function balanceOf(address tokenOwner) public view returns (uint balance) {
81         return balances[tokenOwner];
82     }
83     
84     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
85         return allowed[tokenOwner][spender];
86     }
87     
88     function approve(address spender, uint tokens) public returns (bool success) {
89         allowed[msg.sender][spender] = tokens;
90         emit Approval(msg.sender, spender, tokens);
91         return true;
92     }
93     
94     function transfer(address to, uint tokens) public returns (bool success) {
95         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
96         balances[to] = safeAdd(balances[to], tokens);
97         emit Transfer(msg.sender, to, tokens);
98         return true;
99     }
100     
101     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
102         balances[from] = safeSub(balances[from], tokens);
103         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
104         balances[to] = safeAdd(balances[to], tokens);
105         emit Transfer(from, to, tokens);
106         return true;
107     }
108 }