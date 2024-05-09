1 /**
2  *Submitted for verification at Etherscan.io on 2019-05-25
3 */
4 
5 pragma solidity ^0.4.18;
6 
7 // ----------------------------------------------------------------------------
8 // Safe maths
9 // ----------------------------------------------------------------------------
10 library SafeMath {
11     function add(uint a, uint b) internal pure returns (uint c) {
12         c = a + b;
13         require(c >= a);
14     }
15     function sub(uint a, uint b) internal pure returns (uint c) {
16         require(b <= a);
17         c = a - b;
18     }
19     function mul(uint a, uint b) internal pure returns (uint c) {
20         c = a * b;
21         require(a == 0 || c / a == b);
22     }
23     function div(uint a, uint b) internal pure returns (uint c) {
24         require(b > 0);
25         c = a / b;
26     }
27 }
28 
29 
30 // ----------------------------------------------------------------------------
31 // ERC Token Standard #20 Interface
32 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
33 // ----------------------------------------------------------------------------
34 contract ERC20Interface {
35     function totalSupply() public constant returns (uint);
36     function balanceOf(address tokenOwner) public constant returns (uint balance);
37     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
38     function transfer(address to, uint tokens) public returns (bool success);
39     function approve(address spender, uint tokens) public returns (bool success);
40     function transferFrom(address from, address to, uint tokens) public returns (bool success);
41 
42     event Transfer(address indexed from, address indexed to, uint tokens);
43     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
44 }
45 
46 
47 // ----------------------------------------------------------------------------
48 // Owned contract
49 // ----------------------------------------------------------------------------
50 contract Owned {
51     address public owner;
52     address public newOwner;
53 
54     event OwnershipTransferred(address indexed _from, address indexed _to);
55 
56     function Owned() public {
57         owner = msg.sender;
58     }
59 
60     modifier onlyOwner {
61         require(msg.sender == owner);
62         _;
63     }
64 
65     function transferOwnership(address _newOwner) public onlyOwner {
66         newOwner = _newOwner;
67     }
68     function acceptOwnership() public {
69         require(msg.sender == newOwner);
70         OwnershipTransferred(owner, newOwner);
71         owner = newOwner;
72         newOwner = address(0);
73     }
74 }
75 
76 
77 // ----------------------------------------------------------------------------
78 // ERC20 Token, with the addition of symbol, name and decimals and an
79 // initial fixed supply
80 // ----------------------------------------------------------------------------
81 contract QQGF is ERC20Interface, Owned {
82     using SafeMath for uint;
83 
84     string public symbol;
85     string public  name;
86     uint8 public decimals;
87     uint public _totalSupply;
88 
89     mapping(address => uint) balances;
90     mapping(address => mapping(address => uint)) allowed;
91 
92 
93     // ------------------------------------------------------------------------
94     // Constructor
95     // ------------------------------------------------------------------------
96     function QQGF() public {
97         symbol = "QQGF";
98         name = "Decentralized Fund Service Platform";
99         decimals = 18;
100         _totalSupply = 2100 * 10000 * 10**uint(decimals);
101         balances[owner] = _totalSupply;
102         Transfer(address(0), owner, _totalSupply);
103     }
104 
105 
106     // ------------------------------------------------------------------------
107     // Total supply
108     // ------------------------------------------------------------------------
109     function totalSupply() public constant returns (uint) {
110         return _totalSupply  - balances[address(0)];
111     }
112 
113 
114     // ------------------------------------------------------------------------
115     // Get the token balance for account `tokenOwner`
116     // ------------------------------------------------------------------------
117     function balanceOf(address tokenOwner) public constant returns (uint balance) {
118         return balances[tokenOwner];
119     }
120 
121 
122     // ------------------------------------------------------------------------
123     // Transfer the balance from token owner's account to `to` account
124     // - Owner's account must have sufficient balance to transfer
125     // - 0 value transfers are allowed
126     // ------------------------------------------------------------------------
127     function transfer(address to, uint tokens) public returns (bool success) {
128         balances[msg.sender] = balances[msg.sender].sub(tokens);
129         balances[to] = balances[to].add(tokens);
130         Transfer(msg.sender, to, tokens);
131         return true;
132     }
133 
134 
135     // ------------------------------------------------------------------------
136     // Token owner can approve for `spender` to transferFrom(...) `tokens`
137     // from the token owner's account
138     //
139     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
140     // recommends that there are no checks for the approval double-spend attack
141     // as this should be implemented in user interfaces 
142     // ------------------------------------------------------------------------
143     function approve(address spender, uint tokens) public returns (bool success) {
144         allowed[msg.sender][spender] = tokens;
145         Approval(msg.sender, spender, tokens);
146         return true;
147     }
148 
149 
150     // ------------------------------------------------------------------------
151     // Transfer `tokens` from the `from` account to the `to` account
152     // 
153     // The calling account must already have sufficient tokens approve(...)-d
154     // for spending from the `from` account and
155     // - From account must have sufficient balance to transfer
156     // - Spender must have sufficient allowance to transfer
157     // - 0 value transfers are allowed
158     // ------------------------------------------------------------------------
159     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
160         balances[from] = balances[from].sub(tokens);
161         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
162         balances[to] = balances[to].add(tokens);
163         Transfer(from, to, tokens);
164         return true;
165     }
166 
167 
168     // ------------------------------------------------------------------------
169     // Returns the amount of tokens approved by the owner that can be
170     // transferred to the spender's account
171     // ------------------------------------------------------------------------
172     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
173         return allowed[tokenOwner][spender];
174     }
175 
176     // ------------------------------------------------------------------------
177     // Don't accept ETH
178     // ------------------------------------------------------------------------
179     function () public payable {
180         revert();
181     }
182 
183 }