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
29 contract Kokainutoken is ERC20Interface, SafeMath {
30     string public name;
31     string public symbol;
32     uint8 public decimals; 
33 
34     uint256 public _totalSupply;
35 
36     mapping(address => uint) balances;
37     mapping(address => mapping(address => uint)) allowed;
38 
39     
40     constructor() public {
41         name = "KOKA INU";
42         symbol = "INU";
43         decimals = 18;
44         _totalSupply = 1000000000000000000000000000000;
45 
46         balances[msg.sender] = _totalSupply;
47         emit Transfer(address(0), msg.sender, _totalSupply);
48     }
49 
50     function totalSupply() public view returns (uint) {
51         return _totalSupply  - balances[address(0)];
52     }
53 
54     function balanceOf(address tokenOwner) public view returns (uint balance) {
55         return balances[tokenOwner];
56     }
57 
58     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
59         return allowed[tokenOwner][spender];
60     }
61 
62     function approve(address spender, uint tokens) public returns (bool success) {
63         allowed[msg.sender][spender] = tokens;
64         emit Approval(msg.sender, spender, tokens);
65         return true;
66     }
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
82 }