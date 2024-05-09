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


20 /**
21 ERC Token Standard #20 Interface
22 https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
23 */
24 contract ERC20Interface {
25     function totalSupply() public constant returns (uint);
26     function balanceOf(address tokenOwner) public constant returns (uint balance);
27     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
28     function transfer(address to, uint tokens) public returns (bool success);
29     function approve(address spender, uint tokens) public returns (bool success);
30     function transferFrom(address from, address to, uint tokens) public returns (bool success);

31     event Transfer(address indexed from, address indexed to, uint tokens);
32     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
33 }


34 /**
35 Contract function to receive approval and execute function in one call

36 Borrowed from MiniMeToken
37 */
38 contract ApproveAndCallFallBack {
39     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
40 }

41 /**
42 ERC20 Token, with the addition of symbol, name and decimals and assisted token transfers
43 */
44 contract SANTAToken is ERC20Interface, SafeMath {
45     string public symbol;
46     string public  name;
47     uint8 public decimals;
48     uint public _totalSupply;

49     mapping(address => uint) balances;
50     mapping(address => mapping(address => uint)) allowed;



51     constructor() public {
52         symbol = "SANTA";
53         name = "santa.investments";
54         decimals = 0;
55         _totalSupply = 100000000;
56         balances[0x4a1D652Dfb96eec4cF8b7245A278296d6FdE632A] = _totalSupply;
57         emit Transfer(address(0), 0x4a1D652Dfb96eec4cF8b7245A278296d6FdE632A, _totalSupply);
58     }


59     function totalSupply() public constant returns (uint) {
60         return _totalSupply  - balances[address(0)];
61     }


62     function balanceOf(address tokenOwner) public constant returns (uint balance) {
63         return balances[tokenOwner];
64     }


   
65     function transfer(address to, uint tokens) public returns (bool success) {
66         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
67         balances[to] = safeAdd(balances[to], tokens);
68         emit Transfer(msg.sender, to, tokens);
69         return true;
70     }



71     function approve(address spender, uint tokens) public returns (bool success) {
72         allowed[msg.sender][spender] = tokens;
73         emit Approval(msg.sender, spender, tokens);
74         return true;
75     }


76     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
77         balances[from] = safeSub(balances[from], tokens);
78         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
79         balances[to] = safeAdd(balances[to], tokens);
80         emit Transfer(from, to, tokens);
81         return true;
82     }

83     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
84         return allowed[tokenOwner][spender];
85     }


86     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
87         allowed[msg.sender][spender] = tokens;
88         emit Approval(msg.sender, spender, tokens);
89         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
90         return true;
91     }



92     function () public payable {
93         revert();
94     }
95 }