1 pragma solidity ^0.4.21;
2 
3 contract ERC20 {
4     function balanceOf(address tokenowner) public constant returns (uint);
5     function allowance(address tokenowner, address spender) public constant returns (uint);
6     function transfer(address to, uint tokencount) public returns (bool success);
7     function approve(address spender, uint tokencount) public returns (bool success);
8     function transferFrom(address from, address to, uint tokencount) public returns (bool success);
9     event Transfer(address indexed from, address indexed to, uint tokencount);
10     event Approval(address indexed tokenowner, address indexed spender, uint tokencount);
11 }
12 
13 contract ApproveAndCallFallBack {
14     function receiveApproval(address from, uint256 tokencount, address token, bytes data) public;
15 }
16 
17 contract CursedToken is ERC20 {
18     string public symbol = "CCB";
19     string public name = "Cursed Cornbread";
20     uint8 public decimals = 0;
21     uint public totalSupply = 0;
22     address public owner = 0x55516b579E56C1287f0700eddDa352C2d2c5b3b6;
23 
24     // all funds will go to GiveDirectly charity 
25     // https://web.archive.org/web/20180313215224/https://www.givedirectly.org/give-now?crypto=eth#
26     address public withdrawAddress = 0xa515BDA9869F619fe84357E3e44040Db357832C4;
27 
28     mapping(address => uint) balances;
29     mapping(address => mapping(address => uint)) allowed;
30 
31     function CursedToken() public {
32     }
33 
34     function add(uint a, uint b) internal pure returns (uint) {
35         uint c = a + b;
36         require(c >= a);
37         return c;
38     }
39 
40     function sub(uint a, uint b) internal pure returns (uint) {
41         require(b <= a);
42         return a - b;
43     }
44 
45     function balanceOf(address tokenowner) public constant returns (uint) {
46         return balances[tokenowner];
47     }
48 
49     function allowance(address tokenowner, address spender) public constant returns (uint) {
50         return allowed[tokenowner][spender];
51     }
52 
53     function transfer(address to, uint tokencount) public returns (bool success) {
54         require(msg.sender==to || 0==tokencount);
55         balances[msg.sender] = sub(balances[msg.sender], tokencount);
56         balances[to] = add(balances[to], tokencount);
57         emit Transfer(msg.sender, to, tokencount);
58         return true;
59     }
60 
61     function approve(address spender, uint tokencount) public returns (bool success) {
62         allowed[msg.sender][spender] = tokencount;
63         emit Approval(msg.sender, spender, tokencount);
64         return true;
65     }
66 
67     function issue(address to, uint tokencount) public returns (bool success) {
68         require(msg.sender==owner);
69         balances[to] = add(balances[to], tokencount);
70         totalSupply += tokencount;
71         emit Transfer(address(0), to, tokencount);
72         return true;
73     }
74 
75     function transferFrom(address from, address to, uint tokencount) public returns (bool success) {
76         require(from==to || 0==tokencount);
77         balances[from] = sub(balances[from], tokencount);
78         allowed[from][msg.sender] = sub(allowed[from][msg.sender], tokencount);
79         balances[to] = add(balances[to], tokencount);
80         emit Transfer(from, to, tokencount);
81         return true;
82     }
83 
84     function approveAndCall(address spender, uint tokencount, bytes data) public returns (bool success) {
85         allowed[msg.sender][spender] = tokencount;
86         emit Approval(msg.sender, spender, tokencount);
87         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokencount, this, data);
88         return true;
89     }
90 
91     // Anyone can send the ether in the contract at any time to charity
92     function withdraw() public returns (bool success) {
93         withdrawAddress.transfer(address(this).balance);
94         return true;
95     }
96 
97     function () public payable {
98     }
99 
100 }