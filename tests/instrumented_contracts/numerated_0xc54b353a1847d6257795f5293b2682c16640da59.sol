1 /**
2  *Submitted for verification at Etherscan.io on 2021-05-15
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-05-11
7 */
8 
9 pragma solidity ^0.5.0;
10 contract ERC20Interface {
11     function totalSupply() public view returns (uint);
12     function balanceOf(address tokenOwner) public view returns (uint balance);
13     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
14     function transfer(address to, uint tokens) public returns (bool success);
15     function approve(address spender, uint tokens) public returns (bool success);
16     function transferFrom(address from, address to, uint tokens) public returns (bool success);
17     event Transfer(address indexed from, address indexed to, uint tokens);
18     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
19 }
20 // ----------------------------------------------------------------------------
21 // Safe Math Library 
22 // ----------------------------------------------------------------------------
23 contract SafeMath {
24     function safeAdd(uint a, uint b) public pure returns (uint c) {
25         c = a + b;
26         require(c >= a);
27     }
28     function safeSub(uint a, uint b) public pure returns (uint c) {
29         require(b <= a); c = a - b; } function safeMul(uint a, uint b) public pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); } function safeDiv(uint a, uint b) public pure returns (uint c) { require(b > 0);
30         c = a / b;
31     }
32 }
33 contract SafeShibaInu is ERC20Interface, SafeMath {
34     string public name;
35     string public symbol;
36     uint8 public decimals; // 18 decimals is the strongly suggested default, avoid changing it
37     uint256 public _totalSupply;
38     mapping(address => uint) balances;
39     mapping(address => mapping(address => uint)) allowed;
40     constructor() public {
41         name = "Safe Shiba Inu";
42         symbol = "SASH";
43         decimals = 18;
44         _totalSupply = 1000000000000000000000000000000;
45         balances[msg.sender] = 1000000000000000000000000000000;
46         emit Transfer(address(0), msg.sender, _totalSupply);
47     }
48     
49     function totalSupply() public view returns (uint) {
50         return _totalSupply  - balances[address(0)];
51     }
52     
53     function balanceOf(address tokenOwner) public view returns (uint balance) {
54         return balances[tokenOwner];
55     }
56     
57     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
58         return allowed[tokenOwner][spender];
59     }
60     
61     function approve(address spender, uint tokens) public returns (bool success) {
62         allowed[msg.sender][spender] = tokens;
63         emit Approval(msg.sender, spender, tokens);
64         return true;
65     }
66     function transfer(address to, uint tokens) public returns (bool success) {
67         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
68         balances[to] = safeAdd(balances[to], tokens);
69         emit Transfer(msg.sender, to, tokens);
70         return true;
71     }
72     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
73         balances[from] = safeSub(balances[from], tokens);
74         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
75         balances[to] = safeAdd(balances[to], tokens);
76         emit Transfer(from, to, tokens);
77         return true;
78     }
79 }