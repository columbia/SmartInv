1 pragma solidity ^0.4.18;
2 ////////////////////////////////////////////////////////////
3 // Rimdeika Consulting and Coaching AB (RC&C AB)
4 // Alingsas SWEDEN
5 ////////////////////////////////////////////////////////////
6 // 'RCCcoin0001' token contract
7 // Deployed to : 0x504474e3c6BCacfFbF85693F44D050007b9C5257
8 // Symbol      : 1st
9 // Name        : RCC-coin
10 // Total supply: 1
11 // Decimals    : 0
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
35 ////////////////////////////////////////////////////////////
36 contract ERC20Interface {
37     function totalSupply() public constant returns (uint);
38     function balanceOf(address tokenOwner) public constant returns (uint balance);
39     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
40     function transfer(address to, uint tokens) public returns (bool success);
41     function approve(address spender, uint tokens) public returns (bool success);
42     function transferFrom(address from, address to, uint tokens) public returns (bool success);
43     event Transfer(address indexed from, address indexed to, uint tokens);
44     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
45 }
46 ////////////////////////////////////////////////////////////
47 // Contract function to receive approval and execute function in one call
48 ////////////////////////////////////////////////////////////
49 contract ApproveAndCallFallBack {
50     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
51 }
52 ////////////////////////////////////////////////////////////
53 // Owned contract
54 ////////////////////////////////////////////////////////////
55 contract Owned {
56     address public owner;
57     address public newOwner;
58     event OwnershipTransferred(address indexed _from, address indexed _to);
59     constructor() public {
60         owner = msg.sender;
61     }
62     modifier onlyOwner {
63         require(msg.sender == owner);
64         _;
65     }
66     function transferOwnership(address _newOwner) public onlyOwner {
67         newOwner = _newOwner;
68     }
69     function acceptOwnership() public {
70         require(msg.sender == newOwner);
71         emit OwnershipTransferred(owner, newOwner);
72         owner = newOwner;
73         newOwner = address(0);
74     }
75 }
76 ////////////////////////////////////////////////////////////
77 // ERC20 Token, with the addition of symbol, name and decimals and assisted token transfers
78 ////////////////////////////////////////////////////////////
79 contract RCCcoin0001 is ERC20Interface, Owned, SafeMath {
80     string public symbol;
81     string public  name;
82     uint8 public decimals;
83     uint public _totalSupply;
84     mapping(address => uint) balances;
85     mapping(address => mapping(address => uint)) allowed;
86     /////////////////////////////////////////////////////////////
87     // Constructor
88     /////////////////////////////////////////////////////////////
89     constructor() public {
90         symbol = "1st";
91         name = "RCC-coin";
92         decimals = 0;
93         _totalSupply = 1;
94         balances[0x504474e3c6BCacfFbF85693F44D050007b9C5257] = _totalSupply;
95         emit Transfer(address(0), 0x504474e3c6BCacfFbF85693F44D050007b9C5257, _totalSupply);
96     }
97     /////////////////////////////////////////////////////////////
98     // Total supply
99     /////////////////////////////////////////////////////////////
100     function totalSupply() public constant returns (uint) {
101         return _totalSupply  - balances[address(0)];
102     }
103     /////////////////////////////////////////////////////////////
104     // Get the token balance for account tokenOwner
105     /////////////////////////////////////////////////////////////
106     function balanceOf(address tokenOwner) public constant returns (uint balance) {
107         return balances[tokenOwner];
108     }
109     ////////////////////////////////////////////////////////////
110     // Transfer the balance from token owner's account to to account
111     // - Owner's account must have sufficient balance to transfer
112     // - 0 value transfers are allowed
113     ////////////////////////////////////////////////////////////
114     function transfer(address to, uint tokens) public returns (bool success) {
115         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
116         balances[to] = safeAdd(balances[to], tokens);
117         emit Transfer(msg.sender, to, tokens);
118         return true;
119     }
120     ////////////////////////////////////////////////////////////
121     // Token owner can approve for spender to transferFrom(...) tokens
122     // from the token owner's account
123     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
124     // recommends that there are no checks for the approval double-spend attack
125     // as this should be implemented in user interfaces 
126     ////////////////////////////////////////////////////////////
127     function approve(address spender, uint tokens) public returns (bool success) {
128         allowed[msg.sender][spender] = tokens;
129         emit Approval(msg.sender, spender, tokens);
130         return true;
131     }
132     ////////////////////////////////////////////////////////////
133     // Transfer tokens from the from account to the to account
134     // The calling account must already have sufficient tokens approve(...)-d
135     // for spending from the from account and
136     // - From account must have sufficient balance to transfer
137     // - Spender must have sufficient allowance to transfer
138     // - 0 value transfers are allowed
139     ////////////////////////////////////////////////////////////
140     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
141         balances[from] = safeSub(balances[from], tokens);
142         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
143         balances[to] = safeAdd(balances[to], tokens);
144         emit Transfer(from, to, tokens);
145         return true;
146     }
147     ////////////////////////////////////////////////////////////
148     // Returns the amount of tokens approved by the owner that can be
149     // transferred to the spender's account
150     ////////////////////////////////////////////////////////////
151     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
152         return allowed[tokenOwner][spender];
153     }
154     ////////////////////////////////////////////////////////////
155     // Token owner can approve for spender to transferFrom(...) tokens
156     // from the token owner's account. The spender contract function
157     // receiveApproval(...) is then executed
158     ////////////////////////////////////////////////////////////
159     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
160         allowed[msg.sender][spender] = tokens;
161         emit Approval(msg.sender, spender, tokens);
162         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
163         return true;
164     }
165     ////////////////////////////////////////////////////////////
166     // Don't accept ETH
167     ////////////////////////////////////////////////////////////
168     function () public payable {
169         revert();
170     }
171     ////////////////////////////////////////////////////////////
172     // Owner can transfer out any accidentally sent ERC20 tokens
173     ////////////////////////////////////////////////////////////
174     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
175         return ERC20Interface(tokenAddress).transfer(owner, tokens);
176     }
177 }