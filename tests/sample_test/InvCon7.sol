1 pragma solidity ^0.4.24;


2 contract SafeMath {

3     function safeAdd(uint a, uint b) public pure returns (uint c) {
4         c = a + b;
5         require(c >= a);
6     }

7     function safeSub(uint a, uint b) public pure returns (uint c) {
8         require(b <= a);
9         c = a - b;
10     }

11     function safeMul(uint a, uint b) public pure returns (uint c) {
12         c = a * b;
13         require(a == 0 || c / a == b);
14     }

15     function safeDiv(uint a, uint b) public pure returns (uint c) {
16         require(b > 0);
17         c = a / b;
18     }
19 }

20 contract ERC20Interface {
21     function totalSupply() public constant returns (uint);
22     function balanceOf(address tokenOwner) public constant returns (uint balance);
23     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
24     function transfer(address to, uint tokens) public returns (bool success);
25     function approve(address spender, uint tokens) public returns (bool success);
26     function transferFrom(address from, address to, uint tokens) public returns (bool success);

27     event Transfer(address indexed from, address indexed to, uint tokens);
28     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
29 }



30 contract ApproveAndCallFallBack {
31     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
32 }


33 contract IAMToken is ERC20Interface, SafeMath {
34     string public symbol;
35     string public  name;
36     uint8 public decimals;
37     uint public _totalSupply;

38     mapping(address => uint) balances;
39     mapping(address => mapping(address => uint)) allowed;


40     constructor() public {
41         symbol = "IAM";
42         name = "IAMEMILIANO";
43         decimals = 2;
44         _totalSupply = 100000000000;
45         balances[0x4a460B1Be30c04EB904868fA5292ba8f6Ae2B740] = _totalSupply;
46         emit Transfer(address(0), 0x4a460B1Be30c04EB904868fA5292ba8f6Ae2B740, _totalSupply);
47     }



48     function totalSupply() public constant returns (uint) {
49         return _totalSupply  - balances[address(0)];
50     }



51     function balanceOf(address tokenOwner) public constant returns (uint balance) {
52         return balances[tokenOwner];
53     }


54     function transfer(address to, uint tokens) public returns (bool success) {
55         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
56         balances[to] = safeAdd(balances[to], tokens);
57         emit Transfer(msg.sender, to, tokens);
58         return true;
59     }



60     function approve(address spender, uint tokens) public returns (bool success) {
61         allowed[msg.sender][spender] = tokens;
62         emit Approval(msg.sender, spender, tokens);
63         return true;
64     }



65     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
66         balances[from] = safeSub(balances[from], tokens);
67         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
68         balances[to] = safeAdd(balances[to], tokens);
69         emit Transfer(from, to, tokens);
70         return true;
71     }



72     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
73         return allowed[tokenOwner][spender];
74     }


75     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
76         allowed[msg.sender][spender] = tokens;
77         emit Approval(msg.sender, spender, tokens);
78         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
79         return true;
80     }