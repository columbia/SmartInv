1 pragma solidity ^0.4.24;
2 
3 contract SafeMath {
4     function safeAdd(uint a, uint b) public pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function safeSub(uint a, uint b) public pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function safeMul(uint a, uint b) public pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function safeDiv(uint a, uint b) public pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 // ----------------------------------------------------------------------------
23 // ERC Token Standard #20 Interface
24 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
25 // ----------------------------------------------------------------------------
26 contract ERC20Interface {
27     function totalSupply() public view returns (uint);
28     function balanceOf(address tokenOwner) public view returns (uint balance);
29     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
30     function transfer(address to, uint tokens) public returns (bool success);
31     function approve(address spender, uint tokens) public returns (bool success);
32     function transferFrom(address from, address to, uint tokens) public returns (bool success);
33 
34     event Transfer(address indexed from, address indexed to, uint tokens);
35     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
36 }
37 
38 
39 // ----------------------------------------------------------------------------
40 // Contract function to receive approval and execute function in one call
41 //
42 // Borrowed from MiniMeToken
43 // ----------------------------------------------------------------------------
44 contract ApproveAndCallFallBack {
45     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
46 }
47 
48 
49 contract Owned {
50     address public owner;
51 
52     event OwnershipTransferred(address indexed _from, address indexed _to);
53 
54     constructor() public {
55         owner = msg.sender;
56     }
57 
58     modifier onlyOwner {
59         require(msg.sender == owner);
60         _;
61     }
62 
63     function transferOwnership(address _newOwner) public onlyOwner {
64         address oldOwner = owner;
65         owner = _newOwner;
66         emit OwnershipTransferred(oldOwner, _newOwner);
67     }
68 }
69 
70 
71 contract SBIO is ERC20Interface, Owned, SafeMath {
72     string public symbol;
73     string public name;
74     uint8 public decimals;
75     uint public totalSupply;
76 
77     mapping(address => uint) balances;
78     mapping(address => mapping(address => uint)) allowed;
79 
80     constructor() public {
81         symbol = "SBIO";
82         name = "Vector Space Biosciences, Inc.";
83         decimals = 18;
84         totalSupply = 100000000 * 10 ** uint256(decimals);
85         balances[owner] = totalSupply;
86         emit Transfer(address(0), owner, totalSupply);
87     }
88 
89     function totalSupply() public view returns (uint) {
90         return totalSupply - balances[address(0)];
91     }
92 
93     function balanceOf(address tokenOwner) public view returns (uint balance) {
94         return balances[tokenOwner];
95     }
96 
97     modifier validTo(address to) {
98         require(to != address(0));
99         require(to != address(this));
100         _;
101     }
102 
103     function transferInternal(address from, address to, uint tokens) internal {
104         balances[from] = safeSub(balances[from], tokens);
105         balances[to] = safeAdd(balances[to], tokens);
106         emit Transfer(from, to, tokens);
107     }
108 
109     function transfer(address to, uint tokens) public validTo(to) returns (bool success) {
110         transferInternal(msg.sender, to, tokens);
111         return true;
112     }
113 
114     // ------------------------------------------------------------------------
115     // Transfer `tokens` from the `from` account to the `to` account
116     //
117     // The calling account must already have sufficient tokens approve(...)-d
118     // for spending from the `from` account and
119     // - From account must have sufficient balance to transfer
120     // - Spender must have sufficient allowance to transfer
121     // - 0 value transfers are allowed
122     // ------------------------------------------------------------------------
123     function transferFrom(address from, address to, uint tokens) public validTo(to) returns (bool success) {
124         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
125         transferInternal(from, to, tokens);
126         return true;
127     }
128 
129     // ------------------------------------------------------------------------
130     // Token owner can approve for `spender` to transferFrom(...) `tokens`
131     // from the token owner's account
132     //
133     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
134     // recommends that there are no checks for the approval double-spend attack
135     // as this should be implemented in user interfaces
136     // ------------------------------------------------------------------------
137     function approve(address spender, uint tokens) public returns (bool success) {
138         allowed[msg.sender][spender] = tokens;
139         emit Approval(msg.sender, spender, tokens);
140         return true;
141     }
142 
143     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
144         return allowed[tokenOwner][spender];
145     }
146 
147     // ------------------------------------------------------------------------
148     // Token owner can approve for `spender` to transferFrom(...) `tokens`
149     // from the token owner's account. The `spender` contract function
150     // `receiveApproval(...)` is then executed
151     // ------------------------------------------------------------------------
152     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
153         if (approve(spender, tokens)) {
154             ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
155             return true;
156         }
157     }
158 
159     function () public payable {
160         revert();
161     }
162 }