1 pragma solidity 0.4.21;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 // ----------------------------------------------------------------------------
26 // ERC Token Standard #20 Interface
27 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
28 // ----------------------------------------------------------------------------
29 contract ERC20Interface {
30     function totalSupply() public constant returns (uint);
31     function balanceOf(address tokenOwner) public constant returns (uint balance);
32     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
33     function transfer(address to, uint tokens) public returns (bool success);
34     function approve(address spender, uint tokens) public returns (bool success);
35     function transferFrom(address from, address to, uint tokens) public returns (bool success);
36     
37     event Transfer(address indexed from, address indexed to, uint tokens);
38     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
39 }
40 
41 // ----------------------------------------------------------------------------
42 // Owned contract
43 // ----------------------------------------------------------------------------
44 contract Owned {
45     address public owner;
46     
47     function Owned() public{
48         owner = msg.sender;
49     }
50     
51     modifier onlyOwner() {
52         require(msg.sender == owner);
53         _;
54     }
55 }
56 
57 contract Honolulu is ERC20Interface, Owned{
58     using SafeMath for uint256;
59     
60     string public symbol;
61     string public name;
62     uint8 public decimals;
63     uint256 _totalSupply;
64 
65     mapping(address => uint256) balances;
66     mapping(address => mapping(address => uint256)) allowed;
67     
68     // ------------------------------------------------------------------------
69     // Constructor
70     // ------------------------------------------------------------------------
71 
72     function Honolulu() public {
73         symbol = "HNL";
74         name = "Honolulu is coming!";
75         decimals = 10;
76         _totalSupply = 500000000 * 10**uint256(decimals);
77         balances[owner] = _totalSupply;
78         emit Transfer(address(0), owner, _totalSupply);
79     }
80     
81     // ------------------------------------------------------------------------
82     // Total supply
83     // ------------------------------------------------------------------------
84     function totalSupply() public constant returns (uint256) {
85         return _totalSupply;
86     }
87     
88     // ------------------------------------------------------------------------
89     // Get the token balance for account `tokenOwner`
90     // ------------------------------------------------------------------------
91     function balanceOf(address tokenOwner) public constant returns (uint256 balance) {
92         return balances[tokenOwner];
93     }
94 
95     // ------------------------------------------------------------------------
96     // Transfer the balance from token owner's account to `to` account
97     // - Owner's account must have sufficient balance to transfer
98     // - 0 value transfers are allowed
99     // ------------------------------------------------------------------------
100     function transfer(address to, uint256 tokens) public returns (bool success){
101         balances[msg.sender] = balances[msg.sender].sub(tokens);
102         balances[to] = balances[to].add(tokens);
103         emit Transfer(msg.sender, to, tokens);
104         return true;
105     }
106 
107     // ------------------------------------------------------------------------
108     // Token owner can approve for `spender` to transferFrom(...) `tokens`
109     // from the token owner's account
110     //
111     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
112     // recommends that there are no checks for the approval double-spend attack
113     // as this should be implemented in user interfaces 
114     // ------------------------------------------------------------------------
115     function approve(address spender, uint256 tokens) public returns (bool success) {
116         allowed[msg.sender][spender] = tokens;
117         emit Approval(msg.sender, spender, tokens);
118         return true;
119     }
120 
121     // ------------------------------------------------------------------------
122     // Transfer `tokens` from the `from` account to the `to` account
123     // 
124     // The calling account must already have sufficient tokens approve(...)-d
125     // for spending from the `from` account and
126     // - From account must have sufficient balance to transfer
127     // - Spender must have sufficient allowance to transfer
128     // - 0 value transfers are allowed
129     // ------------------------------------------------------------------------
130     function transferFrom(address from, address to, uint256 tokens) public returns (bool success) {
131         balances[from] = balances[from].sub(tokens);
132         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
133         balances[to] = balances[to].add(tokens);
134         emit Transfer(from, to, tokens);
135         return true;
136     }
137 
138     // ------------------------------------------------------------------------
139     // Returns the amount of tokens approved by the owner that can be
140     // transferred to the spender's account
141     // ------------------------------------------------------------------------
142     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
143         return allowed[tokenOwner][spender];
144     }
145     
146     // ------------------------------------------------------------------------
147     // Don't accept ETH
148     // ------------------------------------------------------------------------
149     function () public payable {
150         revert();
151     }
152 
153 }