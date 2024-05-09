1 pragma solidity ^0.5.0;
2 
3 
4 library SafeMath {
5     function add(uint a, uint b) internal pure returns (uint c) {
6         c = a + b;
7         require(c >= a);
8     }
9     function sub(uint a, uint b) internal pure returns (uint c) {
10         require(b <= a);
11         c = a - b;
12     }
13     function mul(uint a, uint b) internal pure returns (uint c) {
14         c = a * b;
15         require(a == 0 || c / a == b);
16     }
17     function div(uint a, uint b) internal pure returns (uint c) {
18         require(b > 0);
19         c = a / b;
20     }
21 }
22 
23 contract ERC20Interface {
24     function totalSupply() public view returns (uint);
25     function balanceOf(address tokenOwner) public view returns (uint balance);
26     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
27     function transfer(address to, uint tokens) public returns (bool success);
28     function approve(address spender, uint tokens) public returns (bool success);
29     function transferFrom(address from, address to, uint tokens) public returns (bool success);
30 
31     event Transfer(address indexed from, address indexed to, uint tokens);
32     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
33 }
34 
35 
36 contract ApproveAndCallFallBack {
37     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
38 }
39 
40 
41 contract Owned {
42     address public owner;
43     address public newOwner;
44 
45     event OwnershipTransferred(address indexed _from, address indexed _to);
46 
47     constructor() public {
48         owner = msg.sender;
49     }
50 
51     modifier onlyOwner {
52         require(msg.sender == owner);
53         _;
54     }
55 
56     function transferOwnership(address _newOwner) public onlyOwner {
57         newOwner = _newOwner;
58     }
59     function acceptOwnership() public {
60         require(msg.sender == newOwner);
61         emit OwnershipTransferred(owner, newOwner);
62         owner = newOwner;
63         newOwner = address(0);
64     }
65 }
66 
67 
68 contract MidasToken is ERC20Interface, Owned {
69     using SafeMath for uint;
70 
71     string public symbol;
72     string public  name;
73     uint _totalSupply;
74 
75     mapping(address => uint) balances;
76     mapping(address => mapping(address => uint)) allowed;
77 
78 
79     // ------------------------------------------------------------------------
80     // Constructor
81     // ------------------------------------------------------------------------
82     constructor() public {
83         symbol = "MIDAS";
84         name = "MIDASCOIN";
85         _totalSupply = 500000000;
86         balances[owner] = _totalSupply;
87         emit Transfer(address(0), owner, _totalSupply);
88         
89     }
90 
91 
92     // ------------------------------------------------------------------------
93     // Total supply
94     // ------------------------------------------------------------------------
95     function totalSupply() public view returns (uint) {
96         return _totalSupply.sub(balances[address(0)]);
97     }
98 
99 
100     // ------------------------------------------------------------------------
101     // Get the token balance for account `tokenOwner`
102     // ------------------------------------------------------------------------
103     function balanceOf(address tokenOwner) public view returns (uint balance) {
104         return balances[tokenOwner];
105     }
106 
107 
108     // ------------------------------------------------------------------------
109     // Transfer the balance from token owner's account to `to` account
110     // - Owner's account must have sufficient balance to transfer
111     // - 0 value transfers are allowed
112     // ------------------------------------------------------------------------
113     function transfer(address to, uint tokens) public returns (bool success) {
114         balances[msg.sender] = balances[msg.sender].sub(tokens);
115         balances[to] = balances[to].add(tokens);
116         emit Transfer(msg.sender, to, tokens);
117         return true;
118     }
119 
120 
121     // ------------------------------------------------------------------------
122     // Token owner can approve for `spender` to transferFrom(...) `tokens`
123     // from the token owner's account
124     //
125     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
126     // recommends that there are no checks for the approval double-spend attack
127     // as this should be implemented in user interfaces
128     // ------------------------------------------------------------------------
129     function approve(address spender, uint tokens) public returns (bool success) {
130         allowed[msg.sender][spender] = tokens;
131         emit Approval(msg.sender, spender, tokens);
132         return true;
133     }
134 
135 
136     // ------------------------------------------------------------------------
137     // Transfer `tokens` from the `from` account to the `to` account
138     //
139     // The calling account must already have sufficient tokens approve(...)-d
140     // for spending from the `from` account and
141     // - From account must have sufficient balance to transfer
142     // - Spender must have sufficient allowance to transfer
143     // - 0 value transfers are allowed
144     // ------------------------------------------------------------------------
145     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
146         balances[from] = balances[from].sub(tokens);
147         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
148         balances[to] = balances[to].add(tokens);
149         emit Transfer(from, to, tokens);
150         return true;
151     }
152 
153 
154     // ------------------------------------------------------------------------
155     // Returns the amount of tokens approved by the owner that can be
156     // transferred to the spender's account
157     // ------------------------------------------------------------------------
158     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
159         return allowed[tokenOwner][spender];
160     }
161 
162 
163     // ------------------------------------------------------------------------
164     // Token owner can approve for `spender` to transferFrom(...) `tokens`
165     // from the token owner's account. The `spender` contract function
166     // `receiveApproval(...)` is then executed
167     // ------------------------------------------------------------------------
168     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
169         allowed[msg.sender][spender] = tokens;
170         emit Approval(msg.sender, spender, tokens);
171         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
172         return true;
173     }
174 
175 
176     // ------------------------------------------------------------------------
177     // Don't accept ETH
178     // ------------------------------------------------------------------------
179     function () external payable {
180         revert();
181     }
182 
183 
184     // ------------------------------------------------------------------------
185     // Owner can transfer out any accidentally sent ERC20 tokens
186     // ------------------------------------------------------------------------
187     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
188         return ERC20Interface(tokenAddress).transfer(owner, tokens);
189     }
190 }