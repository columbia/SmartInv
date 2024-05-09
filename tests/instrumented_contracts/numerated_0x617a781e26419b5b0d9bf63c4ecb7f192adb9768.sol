1 pragma solidity ^0.5.0;
2 
3 contract ERC20Interface {
4     function totalSupply() public view returns (uint);
5     function balanceOf(address tokenOwner) public view returns (uint balance);
6     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
7     function transfer(address to, uint tokens) public returns (bool success);
8     function approve(address spender, uint tokens) public returns (bool success);
9     function transferFrom(address from, address to, uint tokens) public returns (bool success);
10 
11     event Transfer(address indexed from, address indexed to, uint tokens);
12     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
13 }
14 
15 contract SafeMath {
16     function safeAdd(uint a, uint b) public pure returns (uint c) {
17         c = a + b;
18         require(c >= a);
19     }
20     function safeSub(uint a, uint b) public pure returns (uint c) {
21         require(b <= a); c = a - b; } function safeMul(uint a, uint b) public pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); } function safeDiv(uint a, uint b) public pure returns (uint c) { require(b > 0);
22         c = a / b;
23     }
24 }
25 
26 
27 contract DEXPRO is ERC20Interface, SafeMath {
28     string public name;
29     string public symbol;
30     uint8 public decimals; // 18 decimals is the strongly suggested default, avoid changing it
31     
32     uint256 public _totalSupply;
33     
34     mapping(address => uint) balances;
35     mapping(address => mapping(address => uint)) allowed;
36 
37     constructor() public {
38         name = "DEXPRO";
39         symbol = "DPRO";
40         decimals = 18;
41         _totalSupply = 100000000000000000000000000;
42         
43         balances[msg.sender] = _totalSupply;
44         emit Transfer(address(0), msg.sender, _totalSupply);
45     }
46     
47     function totalSupply() public view returns (uint) {
48         return _totalSupply  - balances[address(0)];
49     }
50     
51     function balanceOf(address tokenOwner) public view returns (uint balance) {
52         return balances[tokenOwner];
53     }
54     
55     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
56         return allowed[tokenOwner][spender];
57     }
58     
59     function approve(address spender, uint tokens) public returns (bool success) {
60         allowed[msg.sender][spender] = tokens;
61         emit Approval(msg.sender, spender, tokens);
62         return true;
63     }
64     
65     function transfer(address to, uint tokens) public returns (bool success) {
66         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
67         balances[to] = safeAdd(balances[to], tokens);
68         emit Transfer(msg.sender, to, tokens);
69         return true;
70     }
71     
72     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
73         balances[from] = safeSub(balances[from], tokens);
74         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
75         balances[to] = safeAdd(balances[to], tokens);
76         emit Transfer(from, to, tokens);
77         return true;
78     }
79 }