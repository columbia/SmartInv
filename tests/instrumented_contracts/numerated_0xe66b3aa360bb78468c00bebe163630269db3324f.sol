1 pragma solidity ^0.5.0;
2 
3 
4 contract ERC20Interface {
5     function totalSupply() public view returns (uint);
6     function balanceOf(address tokenOwner) public view returns (uint balance);
7     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
8     function transfer(address to, uint tokens) public returns (bool success);
9     function approve(address spender, uint tokens) public returns (bool success);
10     function transferFrom(address from, address to, uint tokens) public returns (bool success);
11 
12     event Transfer(address indexed from, address indexed to, uint tokens);
13     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
14 }
15 
16 
17 contract SafeMath {
18     function safeAdd(uint a, uint b) public pure returns (uint c) {
19         c = a + b;
20         require(c >= a);
21     }
22     function safeSub(uint a, uint b) public pure returns (uint c) {
23         require(b <= a); c = a - b; } function safeMul(uint a, uint b) public pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); } function safeDiv(uint a, uint b) public pure returns (uint c) { require(b > 0);
24         c = a / b;
25     }
26 }
27 
28 
29 contract MerchantToken is ERC20Interface, SafeMath {
30     string constant public name = "Merchant Token";
31     string constant public symbol = "MTO";
32     uint8 constant public decimals = 18;
33     uint256 constant public _totalSupply = 100000000000000000000000000;
34     
35     mapping(address => uint) public balances;
36     mapping(address => mapping(address => uint)) public allowed;
37 
38     constructor() public {
39         balances[msg.sender] = _totalSupply;
40         emit Transfer(address(0), msg.sender, _totalSupply);
41     }
42 
43     function totalSupply() public view returns (uint) {
44         return _totalSupply  - balances[address(0)];
45     }
46 
47     function balanceOf(address tokenOwner) public view returns (uint balance) {
48         return balances[tokenOwner];
49     }
50 
51     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
52         return allowed[tokenOwner][spender];
53     }
54 
55     function approve(address spender, uint tokens) public returns (bool success) {
56         allowed[msg.sender][spender] = tokens;
57         emit Approval(msg.sender, spender, tokens);
58         return true;
59     }
60     
61     function increaseApproval(address spender, uint tokens) public returns (bool success) {
62         allowed[msg.sender][spender] = safeAdd(allowed[msg.sender][spender], tokens);
63         return true;
64     }
65     
66     function decreaseApproval(address spender, uint tokens) public returns (bool success) {
67         allowed[msg.sender][spender] = safeSub(allowed[msg.sender][spender], tokens);
68         return true;
69     }
70 
71     function transfer(address to, uint tokens) public returns (bool success) {
72         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
73         balances[to] = safeAdd(balances[to], tokens);
74         emit Transfer(msg.sender, to, tokens);
75         return true;
76     }
77 
78     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
79         balances[from] = safeSub(balances[from], tokens);
80         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
81         balances[to] = safeAdd(balances[to], tokens);
82         emit Transfer(from, to, tokens);
83         return true;
84     }
85 }