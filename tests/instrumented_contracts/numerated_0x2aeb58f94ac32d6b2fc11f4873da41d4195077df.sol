1 pragma solidity ^0.4.18;
2 ////////////////////////////////////////////////////////////
3 // Rimdeika Consulting and Coaching AB (RC&C AB)
4 // Alingsas SWEDEN
5 ////////////////////////////////////////////////////////////
6 // 'RCCToken' token contract
7 // Deployed to : 0x504474e3c6BCacfFbF85693F44D050007b9C5257
8 // Symbol      : Ʀ (Lattin Letter Yr)
9 // Name        : RCC
10 // Total supply: 1000000
11 // Decimals    : 18
12 ////////////////////////////////////////////////////////////
13 // Safe maths
14 ////////////////////////////////////////////////////////////
15 contract SafeMath {
16     function safeAdd(uint a, uint b) public pure returns (uint c) {
17         c = a + b;
18         require(c >= a);
19     }
20     function safeSub(uint a, uint b) public pure returns (uint c) {
21         require(b <= a);
22         c = a - b;
23     }
24     function safeMul(uint a, uint b) public pure returns (uint c) {
25         c = a * b;
26         require(a == 0 || c / a == b);
27     }
28     function safeDiv(uint a, uint b) public pure returns (uint c) {
29         require(b > 0);
30         c = a / b;
31     }
32 }
33 ////////////////////////////////////////////////////////////
34 // RCCToken Standard ERC20Interface
35 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
36 ////////////////////////////////////////////////////////////
37 contract ERC20Interface {
38     function totalSupply() public constant returns (uint);
39     function balanceOf(address tokenOwner) public constant returns (uint balance);
40     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
41     function transfer(address to, uint tokens) public returns (bool success);
42     function approve(address spender, uint tokens) public returns (bool success);
43     function transferFrom(address from, address to, uint tokens) public returns (bool success);
44     event Transfer(address indexed from, address indexed to, uint tokens);
45     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
46 }
47 ////////////////////////////////////////////////////////////
48 // Contract function to receive approval and execute function in one call
49 ////////////////////////////////////////////////////////////
50 contract ApproveAndCallFallBack {
51     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
52 }
53 ////////////////////////////////////////////////////////////
54 // Owned contract
55 ////////////////////////////////////////////////////////////
56 contract Owned {
57     address public owner;
58     address public newOwner;
59     event OwnershipTransferred(address indexed _from, address indexed _to);
60     constructor() public {
61         owner = msg.sender;
62     }
63     modifier onlyOwner {
64         require(msg.sender == owner);
65         _;
66     }
67     function transferOwnership(address _newOwner) public onlyOwner {
68         newOwner = _newOwner;
69     }
70     function acceptOwnership() public {
71         require(msg.sender == newOwner);
72         emit OwnershipTransferred(owner, newOwner);
73         owner = newOwner;
74         newOwner = address(0);
75     }
76 }
77 ////////////////////////////////////////////////////////////
78 // ERC20 Token, with the addition of symbol, name and decimals and assisted token transfers
79 ////////////////////////////////////////////////////////////
80 contract RCCToken is ERC20Interface, Owned, SafeMath {
81     string public symbol;
82     string public  name;
83     uint8 public decimals;
84     uint public _totalSupply;
85     mapping(address => uint) balances;
86     mapping(address => mapping(address => uint)) allowed;
87     /////////////////////////////////////////////////////////////
88     // Constructor
89     /////////////////////////////////////////////////////////////
90     constructor() public {
91         symbol = "Ʀ";
92         name = "RCC";
93         decimals = 18;
94         _totalSupply = 1000000000000000000000000;
95         balances[0x504474e3c6BCacfFbF85693F44D050007b9C5257] = _totalSupply;
96         emit Transfer(address(0), 0x504474e3c6BCacfFbF85693F44D050007b9C5257, _totalSupply);
97     }
98     /////////////////////////////////////////////////////////////
99     // Total supply
100     /////////////////////////////////////////////////////////////
101     function totalSupply() public constant returns (uint) {
102         return _totalSupply  - balances[address(0)];
103     }
104     /////////////////////////////////////////////////////////////
105     // Get the token balance for account tokenOwner
106     /////////////////////////////////////////////////////////////
107     function balanceOf(address tokenOwner) public constant returns (uint balance) {
108         return balances[tokenOwner];
109     }
110     ////////////////////////////////////////////////////////////
111     // Transfer the balance from token owner's account to to account
112     // - Owner's account must have sufficient balance to transfer
113     // - 0 value transfers are allowed
114     ////////////////////////////////////////////////////////////
115     function transfer(address to, uint tokens) public returns (bool success) {
116         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
117         balances[to] = safeAdd(balances[to], tokens);
118         emit Transfer(msg.sender, to, tokens);
119         return true;
120     }
121     ////////////////////////////////////////////////////////////
122     // Token owner can approve for spender to transferFrom(...) tokens
123     // from the token owner's account
124     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
125     // recommends that there are no checks for the approval double-spend attack
126     // as this should be implemented in user interfaces 
127     ////////////////////////////////////////////////////////////
128     function approve(address spender, uint tokens) public returns (bool success) {
129         allowed[msg.sender][spender] = tokens;
130         emit Approval(msg.sender, spender, tokens);
131         return true;
132     }
133     ////////////////////////////////////////////////////////////
134     // Transfer tokens from the from account to the to account
135     // The calling account must already have sufficient tokens approve(...)-d
136     // for spending from the from account and
137     // - From account must have sufficient balance to transfer
138     // - Spender must have sufficient allowance to transfer
139     // - 0 value transfers are allowed
140     ////////////////////////////////////////////////////////////
141     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
142         balances[from] = safeSub(balances[from], tokens);
143         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
144         balances[to] = safeAdd(balances[to], tokens);
145         emit Transfer(from, to, tokens);
146         return true;
147     }
148     ////////////////////////////////////////////////////////////
149     // Returns the amount of tokens approved by the owner that can be
150     // transferred to the spender's account
151     ////////////////////////////////////////////////////////////
152     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
153         return allowed[tokenOwner][spender];
154     }
155     ////////////////////////////////////////////////////////////
156     // Token owner can approve for spender to transferFrom(...) tokens
157     // from the token owner's account. The spender contract function
158     // receiveApproval(...) is then executed
159     ////////////////////////////////////////////////////////////
160     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
161         allowed[msg.sender][spender] = tokens;
162         emit Approval(msg.sender, spender, tokens);
163         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
164         return true;
165     }
166     ////////////////////////////////////////////////////////////
167     // Don't accept ETH
168     ////////////////////////////////////////////////////////////
169     function () public payable {
170         revert();
171     }
172     ////////////////////////////////////////////////////////////
173     // Owner can transfer out any accidentally sent ERC20 tokens
174     ////////////////////////////////////////////////////////////
175     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
176         return ERC20Interface(tokenAddress).transfer(owner, tokens);
177     }
178 }