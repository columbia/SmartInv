1 pragma solidity ^0.4.18;
2 // @notice TOKEN CONTRACT
3 // @dev ERC-20 with ERC223 protection Token Standard Compliant
4 // @author Geoffrey Tipton at AEN
5 // creditTo Ethereum Commonwealth founder. dexaran@ethereumclassic.org for the 223 Standard
6 
7 // ----------------------------------------------------------------------------
8 // 'AEN' token contract
9 //
10 // Deployed by : 
11 // Symbol      : AEN
12 // Name        : AEN Coin
13 // Total supply: 4,000,000,000
14 // Decimals    : 8
15 //
16 // (c) AENCOIN. The MIT Licence.
17 // ----------------------------------------------------------------------------
18 
19 
20 // ----------------------------------------------------------------------------
21 // Safe maths
22 library SafeMath {
23     function add(uint a, uint b) internal pure returns (uint c) {
24         c = a + b; require(c >= a); }
25     function sub(uint a, uint b) internal pure returns (uint c) {
26         require(b <= a); c = a - b;  }
27     function mul(uint a, uint b) internal pure returns (uint c) {
28         c = a * b; require(a == 0 || c / a == b); }
29     function div(uint a, uint b) internal pure returns (uint c) {
30         require(b > 0); c = a / b; }
31 }
32 
33 
34 // ----------------------------------------------------------------------------
35 // ERC Token Standard #20 Interface
36 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
37 // ----------------------------------------------------------------------------
38 contract ERC20Interface {
39     function totalSupply() public constant returns (uint);
40     function balanceOf(address tokenOwner) public constant returns (uint balance);
41     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
42     function transfer(address to, uint tokens) public returns (bool success);
43     function approve(address spender, uint tokens) public returns (bool success);
44     function transferFrom(address from, address to, uint tokens) public returns (bool success);
45 
46     event Transfer(address indexed from, address indexed to, uint tokens);
47     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
48 }
49 
50 
51 // ----------------------------------------------------------------------------
52 // Contract function to receive approval and execute function in one call
53 //
54 // Borrowed from MiniMeToken
55 // ----------------------------------------------------------------------------
56 contract ApproveAndCallFallBack {
57     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
58 }
59 
60 
61 // ----------------------------------------------------------------------------
62 // Owned contract
63 // ----------------------------------------------------------------------------
64 contract Owned {
65     address public owner;
66     address public newOwner;
67 
68     event OwnershipTransferred(address indexed _from, address indexed _to);
69 
70     constructor() public {
71         owner = msg.sender;
72     }
73 
74     modifier onlyOwner {
75         require(msg.sender == owner);
76         _;
77     }
78 
79     function transferOwnership(address _newOwner) public onlyOwner {
80         newOwner = _newOwner;
81     }
82     function acceptOwnership() public {
83         require(msg.sender == newOwner);
84         emit OwnershipTransferred(owner, newOwner);
85         owner = newOwner;
86         newOwner = address(0);
87     }
88 }
89 
90 
91 // ----------------------------------------------------------------------------
92 // ERC20 Token, with the addition of symbol, name and decimals and an
93 // initial fixed supply
94 contract AENToken is ERC20Interface, Owned {
95     using SafeMath for uint;
96 
97     string public symbol;
98     string public  name;
99     uint8 public decimals;
100     uint public _totalSupply;
101 
102     mapping(address => uint) balances;
103     mapping(address => mapping(address => uint)) allowed;
104 
105 
106     // ------------------------------------------------------------------------
107     // Constructor
108     constructor() public {
109         symbol = "AEN";
110         name = "AEN.";
111         decimals = 8;
112         _totalSupply = 4000000000 * 10**uint(decimals);
113         balances[owner] = _totalSupply;
114         emit Transfer(address(0), owner, _totalSupply);
115     }
116 
117 
118     // ------------------------------------------------------------------------
119     // Total supply
120     function totalSupply() public constant returns (uint) {
121         return _totalSupply  - balances[address(0)];
122     }
123 
124 
125     // ------------------------------------------------------------------------
126     // Get the token balance for account `tokenOwner`
127     function balanceOf(address tokenOwner) public constant returns (uint balance) {
128         return balances[tokenOwner];
129     }
130 
131 
132     // ------------------------------------------------------------------------
133     // Transfer the balance from token owner's account to `to` account
134     // - Owner's account must have sufficient balance to transfer
135     // - 0 value transfers are allowed
136     function transfer(address to, uint tokens) public returns (bool success) {
137         balances[msg.sender] = balances[msg.sender].sub(tokens);
138         balances[to] = balances[to].add(tokens);
139         emit Transfer(msg.sender, to, tokens);
140         return true;
141     }
142 
143 
144     // ------------------------------------------------------------------------
145     // Token owner can approve for `spender` to transferFrom(...) `tokens`
146     // from the token owner's account
147     function approve(address spender, uint tokens) public returns (bool success) {
148         allowed[msg.sender][spender] = tokens;
149         emit Approval(msg.sender, spender, tokens);
150         return true;
151     }
152 
153 
154     // ------------------------------------------------------------------------
155     // Transfer `tokens` from the `from` account to the `to` account
156     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
157         balances[from] = balances[from].sub(tokens);
158         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
159         balances[to] = balances[to].add(tokens);
160         emit Transfer(from, to, tokens);
161         return true;
162     }
163 
164 
165     // ------------------------------------------------------------------------
166     // Returns the amount of tokens approved by the owner that can be
167     // transferred to the spender's account
168     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
169         return allowed[tokenOwner][spender];
170     }
171 
172 
173     // ------------------------------------------------------------------------
174     // Token owner can approve for `spender` to transferFrom(...) `tokens`
175     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
176         allowed[msg.sender][spender] = tokens;
177         emit Approval(msg.sender, spender, tokens);
178         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
179         return true;
180     }
181 
182 
183     // ------------------------------------------------------------------------
184     // Don't accept ETH
185     function () public payable {
186         revert();
187     }
188 
189 
190     // ------------------------------------------------------------------------
191     // Owner can transfer out any accidentally sent ERC20 tokens
192     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
193         return ERC20Interface(tokenAddress).transfer(owner, tokens);
194     }
195 }