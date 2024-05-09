1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
4     function add(uint a, uint b) internal pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function sub(uint a, uint b) internal pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function mul(uint a, uint b) internal pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function div(uint a, uint b) internal pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 contract ERC20Interface {
23     function totalSupply() public view returns (uint);
24     function balanceOf(address tokenOwner) public view returns (uint balance);
25     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
26     function transfer(address to, uint tokens) public returns (bool success);
27     function approve(address spender, uint tokens) public returns (bool success);
28     function transferFrom(address from, address to, uint tokens) public returns (bool success);
29 
30     event Transfer(address indexed from, address indexed to, uint tokens);
31     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
32 }
33 
34 
35 contract ApproveAndCallFallBack {
36     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
37 }
38 
39 contract Owned {
40     address public owner;
41     address public newOwner;
42 
43     event OwnershipTransferred(address indexed _from, address indexed _to);
44 
45     constructor() public {
46         owner = msg.sender;
47     }
48 
49     modifier onlyOwner {
50         require(msg.sender == owner);
51         _;
52     }
53 
54     function transferOwnership(address _newOwner) public onlyOwner {
55         newOwner = _newOwner;
56     }
57     function acceptOwnership() public {
58         require(msg.sender == newOwner);
59         emit OwnershipTransferred(owner, newOwner);
60         owner = newOwner;
61         newOwner = address(0);
62     }
63 }
64 
65 contract FixedSupplyToken is ERC20Interface, Owned {
66     using SafeMath for uint;
67 
68     string public symbol;
69     string public  name;
70     uint8 public decimals;
71     uint _totalSupply;
72 
73     mapping(address => uint) balances;
74     mapping(address => mapping(address => uint)) allowed;
75 
76 
77     // ------------------------------------------------------------------------
78     // Constructor
79     // ------------------------------------------------------------------------
80     constructor() public {
81         symbol = "EBTB";
82         name = "Electronic Business Token";
83         decimals = 18;
84         _totalSupply = 630000000 * 10**uint(decimals);
85         balances[owner] = _totalSupply;
86         emit Transfer(address(0), owner, _totalSupply);
87     }
88 
89 
90     // ------------------------------------------------------------------------
91     // Total supply
92     // ------------------------------------------------------------------------
93     function totalSupply() public view returns (uint) {
94         return _totalSupply.sub(balances[address(0)]);
95     }
96 
97 
98     // ------------------------------------------------------------------------
99     // Get the token balance for account `tokenOwner`
100     // ------------------------------------------------------------------------
101     function balanceOf(address tokenOwner) public view returns (uint balance) {
102         return balances[tokenOwner];
103     }
104 
105 
106     // ------------------------------------------------------------------------
107     // Transfer the balance from token owner's account to `to` account
108     // - Owner's account must have sufficient balance to transfer
109     // - 0 value transfers are allowed
110     // ------------------------------------------------------------------------
111     function transfer(address to, uint tokens) public returns (bool success) {
112         balances[msg.sender] = balances[msg.sender].sub(tokens);
113         balances[to] = balances[to].add(tokens);
114         emit Transfer(msg.sender, to, tokens);
115         return true;
116     }
117 
118 
119     // ------------------------------------------------------------------------
120     // Token owner can approve for `spender` to transferFrom(...) `tokens`
121     // from the token owner's account
122     //
123     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
124     // recommends that there are no checks for the approval double-spend attack
125     // as this should be implemented in user interfaces
126     // ------------------------------------------------------------------------
127     function approve(address spender, uint tokens) public returns (bool success) {
128         allowed[msg.sender][spender] = tokens;
129         emit Approval(msg.sender, spender, tokens);
130         return true;
131     }
132 
133 
134     // ------------------------------------------------------------------------
135     // Transfer `tokens` from the `from` account to the `to` account
136     //
137     // The calling account must already have sufficient tokens approve(...)-d
138     // for spending from the `from` account and
139     // - From account must have sufficient balance to transfer
140     // - Spender must have sufficient allowance to transfer
141     // - 0 value transfers are allowed
142     // ------------------------------------------------------------------------
143     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
144         balances[from] = balances[from].sub(tokens);
145         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
146         balances[to] = balances[to].add(tokens);
147         emit Transfer(from, to, tokens);
148         return true;
149     }
150 
151 
152     // ------------------------------------------------------------------------
153     // Returns the amount of tokens approved by the owner that can be
154     // transferred to the spender's account
155     // ------------------------------------------------------------------------
156     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
157         return allowed[tokenOwner][spender];
158     }
159 
160 
161     // ------------------------------------------------------------------------
162     // Token owner can approve for `spender` to transferFrom(...) `tokens`
163     // from the token owner's account. The `spender` contract function
164     // `receiveApproval(...)` is then executed
165     // ------------------------------------------------------------------------
166     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
167         allowed[msg.sender][spender] = tokens;
168         emit Approval(msg.sender, spender, tokens);
169         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
170         return true;
171     }
172 
173 
174     // ------------------------------------------------------------------------
175     // Don't accept ETH
176     // ------------------------------------------------------------------------
177     function () external payable {
178         revert();
179     }
180 
181 
182     // ------------------------------------------------------------------------
183     // Owner can transfer out any accidentally sent ERC20 tokens
184     // ------------------------------------------------------------------------
185     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
186         return ERC20Interface(tokenAddress).transfer(owner, tokens);
187     }
188 }