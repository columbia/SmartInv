1 pragma solidity ^0.4.24;
2 
3 /*
4  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
5  *
6  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
7  */
8 
9 
10 /*
11  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
12  *
13  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
14  */
15 
16 
17 /*
18  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
19  *
20  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
21  */
22 
23 
24 /*
25  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
26  *
27  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
28  */
29 
30 
31 // ----------------------------------------------------------------------------
32 // Safe maths
33 // ----------------------------------------------------------------------------
34 contract SafeMath {
35     function safeAdd(uint a, uint b) public pure returns (uint c) {
36         c = a + b;
37         require(c >= a);
38     }
39     function safeSub(uint a, uint b) public pure returns (uint c) {
40         require(b <= a);
41         c = a - b;
42     }
43     function safeMul(uint a, uint b) public pure returns (uint c) {
44         c = a * b;
45         require(a == 0 || c / a == b);
46     }
47     function safeDiv(uint a, uint b) public pure returns (uint c) {
48         require(b > 0);
49         c = a / b;
50     }
51 }
52 
53 
54 // ----------------------------------------------------------------------------
55 // ERC Token Standard #20 Interface
56 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
57 // ----------------------------------------------------------------------------
58 contract ERC20Interface {
59     function totalSupply() public constant returns (uint);
60     function balanceOf(address tokenOwner) public constant returns (uint balance);
61     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
62     function transfer(address to, uint tokens) public returns (bool success);
63     function approve(address spender, uint tokens) public returns (bool success);
64     function transferFrom(address from, address to, uint tokens) public returns (bool success);
65 
66     event Transfer(address indexed from, address indexed to, uint tokens);
67     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
68 }
69 
70 
71 // ----------------------------------------------------------------------------
72 // Contract function to receive approval and execute function in one call
73 //
74 // Borrowed from MiniMeToken
75 // ----------------------------------------------------------------------------
76 contract ApproveAndCallFallBack {
77     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
78 }
79 
80 
81 // ----------------------------------------------------------------------------
82 // Owned contract
83 // ----------------------------------------------------------------------------
84 contract Owned {
85     address internal owner;
86     address public newOwner;
87 
88     event OwnershipTransferred(address indexed _from, address indexed _to);
89 
90     constructor() public {
91         owner = msg.sender;
92     }
93 
94     modifier onlyOwner {
95         require(msg.sender == owner);
96         _;
97     }
98 
99     function transferOwnership(address _newOwner) public onlyOwner {
100         newOwner = _newOwner;
101     }
102     function acceptOwnership() public {
103         require(msg.sender == newOwner);
104         emit OwnershipTransferred(owner, newOwner);
105         owner = newOwner;
106         newOwner = address(0);
107     }
108 }
109 
110 
111 // ----------------------------------------------------------------------------
112 // ERC20 Token, with the addition of symbol, name and decimals and assisted
113 // token transfers
114 // ----------------------------------------------------------------------------
115 contract AMLToken is ERC20Interface, Owned, SafeMath {
116     string public symbol;
117     string public  name;
118     uint8 public decimals;
119     uint public _totalSupply;
120 
121     mapping(address => uint) balances;
122     mapping(address => mapping(address => uint)) allowed;
123 
124 
125     // ------------------------------------------------------------------------
126     // Constructor
127     // ------------------------------------------------------------------------
128     constructor() public {
129         symbol = "FET";
130         name = "Fetch";
131         decimals = 18;
132         _totalSupply = 1152997575000000000000000000;
133         balances[0x7c0F473Ac62f7445D4f5Ce4b54cA5AB6B7c2C2Ff] = _totalSupply;
134         emit Transfer(address(0), 0x7c0F473Ac62f7445D4f5Ce4b54cA5AB6B7c2C2Ff, _totalSupply);
135     }
136 
137 
138     // ------------------------------------------------------------------------
139     // Total supply
140     // ------------------------------------------------------------------------
141     function totalSupply() public constant returns (uint) {
142         return _totalSupply  - balances[address(0)];
143     }
144 
145 
146     // ------------------------------------------------------------------------
147     // Get the token balance for account tokenOwner
148     // ------------------------------------------------------------------------
149     function balanceOf(address tokenOwner) public constant returns (uint balance) {
150         return balances[tokenOwner];
151     }
152 
153 
154     // ------------------------------------------------------------------------
155     // Transfer the balance from token owner's account to to account
156     // - Owner's account must have sufficient balance to transfer
157     // - 0 value transfers are allowed
158     // ------------------------------------------------------------------------
159     function transfer(address to, uint tokens) public returns (bool success) {
160         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
161         balances[to] = safeAdd(balances[to], tokens);
162         emit Transfer(msg.sender, to, tokens);
163         return true;
164     }
165 
166 
167     // ------------------------------------------------------------------------
168     // Token owner can approve for spender to transferFrom(...) tokens
169     // from the token owner's account
170     //
171     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
172     // recommends that there are no checks for the approval double-spend attack
173     // as this should be implemented in user interfaces 
174     // ------------------------------------------------------------------------
175     function approve(address spender, uint tokens) public returns (bool success) {
176         allowed[msg.sender][spender] = tokens;
177         emit Approval(msg.sender, spender, tokens);
178         return true;
179     }
180 
181 
182     // ------------------------------------------------------------------------
183     // Transfer tokens from the from account to the to account
184     // 
185     // The calling account must already have sufficient tokens approve(...)-d
186     // for spending from the from account and
187     // - From account must have sufficient balance to transfer
188     // - Spender must have sufficient allowance to transfer
189     // - 0 value transfers are allowed
190     // ------------------------------------------------------------------------
191     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
192         balances[from] = safeSub(balances[from], tokens);
193         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
194         balances[to] = safeAdd(balances[to], tokens);
195         emit Transfer(from, to, tokens);
196         return true;
197     }
198 
199 
200     // ------------------------------------------------------------------------
201     // Returns the amount of tokens approved by the owner that can be
202     // transferred to the spender's account
203     // ------------------------------------------------------------------------
204     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
205         return allowed[tokenOwner][spender];
206     }
207 
208 
209     // ------------------------------------------------------------------------
210     // Token owner can approve for spender to transferFrom(...) tokens
211     // from the token owner's account. The spender contract function
212     // receiveApproval(...) is then executed
213     // ------------------------------------------------------------------------
214     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
215         allowed[msg.sender][spender] = tokens;
216         emit Approval(msg.sender, spender, tokens);
217         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
218         return true;
219     }
220 
221 
222     // ------------------------------------------------------------------------
223     // Don't accept ETH
224     // ------------------------------------------------------------------------
225     function () public payable {
226         revert();
227     }
228 
229 
230     // ------------------------------------------------------------------------
231     // Owner can transfer out any accidentally sent ERC20 tokens
232     // ------------------------------------------------------------------------
233     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
234         return ERC20Interface(tokenAddress).transfer(owner, tokens);
235     }
236 }