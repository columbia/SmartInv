1 // ----------------------------------------------------------------------------
2 // ERC Token Standard #20 Interface
3 //
4 // ----------------------------------------------------------------------------
5 contract ERC20Interface {
6     function totalSupply() public view returns (uint);
7     function balanceOf(address tokenOwner) public view returns (uint balance);
8     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
9     function transfer(address to, uint tokens) public returns (bool success);
10     function approve(address spender, uint tokens) public returns (bool success);
11     function transferFrom(address from, address to, uint tokens) public returns (bool success);
12 
13     event Transfer(address indexed from, address indexed to, uint tokens);
14     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
15 }
16 
17 // ----------------------------------------------------------------------------
18 // Safe Math Library
19 // ----------------------------------------------------------------------------
20 contract safeMath {
21     function safeAdd(uint a, uint b) public pure returns (uint c) {
22         c = a + b;
23         require(c >= a);
24     }
25     function safeSub(uint a, uint b) public pure returns (uint c) {
26         require(b <= a); c = a - b; } function safeMul(uint a, uint b) public pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); } function safeDiv(uint a, uint b) public pure returns (uint c) { require(b > 0);
27         c = a / b;
28     }
29 }
30 
31 
32 contract Bazaars is ERC20Interface, safeMath {    
33     string public name;
34     string public symbol;
35     uint8 public decimals; 
36     uint256 public _totalSupply;
37 
38     mapping(address => uint) balances;
39     mapping(address => mapping(address => uint)) allowed;
40 
41     /**
42      * Constrctor function
43      *
44      * Initializes contract with initial supply tokens to the creator of the contract
45      */
46     constructor() public {
47         name = "BAZAARS";
48         symbol = "BZR";
49         decimals = 18;
50         _totalSupply = 555555555555555555555555555;
51 
52         balances[msg.sender] = _totalSupply;
53         emit Transfer(address(0xa8d4B20245a0B4237BB6814BbF5fBfa702Ae4C77), msg.sender, _totalSupply);
54     }
55 
56     function totalSupply() public view returns (uint) {
57         return _totalSupply  - balances[address(0xa8d4B20245a0B4237BB6814BbF5fBfa702Ae4C77)];
58     }
59 
60     function balanceOf(address tokenOwner) public view returns (uint balance) {
61         return balances[tokenOwner];
62     }
63 
64     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
65         return allowed[tokenOwner][spender];
66     }
67 
68     function approve(address spender, uint tokens) public returns (bool success) {
69         allowed[msg.sender][spender] = tokens;
70         emit Approval(msg.sender, spender, tokens);
71         return true;
72     }
73 
74     function transfer(address to, uint tokens) public returns (bool success) {
75         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
76         balances[to] = safeAdd(balances[to], tokens);
77         emit Transfer(msg.sender, to, tokens);
78         return true;
79     }
80 
81     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
82         balances[from] = safeSub(balances[from], tokens);
83         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
84         balances[to] = safeAdd(balances[to], tokens);
85         emit Transfer(from, to, tokens);
86         return true;
87     }
88 }