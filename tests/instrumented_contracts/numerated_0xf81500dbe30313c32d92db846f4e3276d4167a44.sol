1 pragma solidity ^0.4.0;pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'TipSmart' token contract
5 //
6 // Deployed to : 0xA733b413043F32861863A6094AeC7b5D8B318985
7 // Symbol      : TPS
8 // Name        : Tip Smart Token
9 // Total supply: 100000000
10 // Decimals    : 18
11 //
12 // Enjoy.
13 //
14 // (c) by Moritz Neto with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
15 // ----------------------------------------------------------------------------
16 
17 
18 // ----------------------------------------------------------------------------
19 // Safe maths
20 // ----------------------------------------------------------------------------
21 contract SafeMath {
22     function safeAdd(uint a, uint b) public pure returns (uint c) {
23         c = a + b;
24         require(c >= a);
25     }
26     function safeSub(uint a, uint b) public pure returns (uint c) {
27         require(b <= a);
28         c = a - b;
29     }
30     function safeMul(uint a, uint b) public pure returns (uint c) {
31         c = a * b;
32         require(a == 0 || c / a == b);
33     }
34     function safeDiv(uint a, uint b) public pure returns (uint c) {
35         require(b > 0);
36         c = a / b;
37     }
38 }
39 
40 
41 // ----------------------------------------------------------------------------
42 // ERC Token Standard #20 Interface
43 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
44 // ----------------------------------------------------------------------------
45 contract ERC20Interface {
46     function totalSupply() public constant returns (uint);
47     function balanceOf(address tokenOwner) public constant returns (uint balance);
48     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
49     function transfer(address to, uint tokens) public returns (bool success);
50     function approve(address spender, uint tokens) public returns (bool success);
51     function transferFrom(address from, address to, uint tokens) public returns (bool success);
52 
53     event Transfer(address indexed from, address indexed to, uint tokens);
54     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
55 }
56 
57 
58 // ----------------------------------------------------------------------------
59 // Contract function to receive approval and execute function in one call
60 //
61 // Borrowed from MiniMeToken
62 // ----------------------------------------------------------------------------
63 contract ApproveAndCallFallBack {
64     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
65 }
66 
67 
68 // ----------------------------------------------------------------------------
69 // Owned contract
70 // ----------------------------------------------------------------------------
71 contract Owned {
72     address public owner;
73     address public newOwner;
74 
75     event OwnershipTransferred(address indexed _from, address indexed _to);
76 
77     function Owned() public {
78         owner = msg.sender;
79     }
80 
81     modifier onlyOwner {
82         require(msg.sender == owner);
83         _;
84     }
85 
86     function transferOwnership(address _newOwner) public onlyOwner {
87         newOwner = _newOwner;
88     }
89     function acceptOwnership() public {
90         require(msg.sender == newOwner);
91         OwnershipTransferred(owner, newOwner);
92         owner = newOwner;
93         newOwner = address(0);
94     }
95 }
96 
97 
98 // ----------------------------------------------------------------------------
99 // ERC20 Token, with the addition of symbol, name and decimals and assisted
100 // token transfers
101 // ----------------------------------------------------------------------------
102 contract TipSmart is ERC20Interface, Owned, SafeMath {
103     string public symbol;
104     string public  name;
105     uint8 public decimals;
106     uint public _totalSupply;
107 
108     mapping(address => uint) balances;
109     mapping(address => mapping(address => uint)) allowed;
110 
111 
112     // ------------------------------------------------------------------------
113     // Constructor
114     // ------------------------------------------------------------------------
115     function TipSmart() public {
116         symbol = "TPS";
117         name = "Tip Smart Token";
118         decimals = 18;
119         _totalSupply = 100000000000000000000000000;
120         balances[0xA733b413043F32861863A6094AeC7b5D8B318985] = _totalSupply;
121         Transfer(address(0), 0xA733b413043F32861863A6094AeC7b5D8B318985, _totalSupply);
122     }
123 
124 
125     // ------------------------------------------------------------------------
126     // Total supply
127     // ------------------------------------------------------------------------
128     function totalSupply() public constant returns (uint) {
129         return _totalSupply  - balances[address(0)];
130     }
131 
132 
133     // ------------------------------------------------------------------------
134     // Get the token balance for account tokenOwner
135     // ------------------------------------------------------------------------
136     function balanceOf(address tokenOwner) public constant returns (uint balance) {
137         return balances[tokenOwner];
138     }
139 
140 
141     // ------------------------------------------------------------------------
142     // Transfer the balance from token owner's account to to account
143     // - Owner's account must have sufficient balance to transfer
144     // - 0 value transfers are allowed
145     // ------------------------------------------------------------------------
146     function transfer(address to, uint tokens) public returns (bool success) {
147         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
148         balances[to] = safeAdd(balances[to], tokens);
149         Transfer(msg.sender, to, tokens);
150         return true;
151     }
152 
153 
154     // ------------------------------------------------------------------------
155     // Token owner can approve for spender to transferFrom(...) tokens
156     // from the token owner's account
157     //
158     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
159     // recommends that there are no checks for the approval double-spend attack
160     // as this should be implemented in user interfaces 
161     // ------------------------------------------------------------------------
162     function approve(address spender, uint tokens) public returns (bool success) {
163         allowed[msg.sender][spender] = tokens;
164         Approval(msg.sender, spender, tokens);
165         return true;
166     }
167 
168 
169     // ------------------------------------------------------------------------
170     // Transfer tokens from the from account to the to account
171     // 
172     // The calling account must already have sufficient tokens approve(...)-d
173     // for spending from the from account and
174     // - From account must have sufficient balance to transfer
175     // - Spender must have sufficient allowance to transfer
176     // - 0 value transfers are allowed
177     // ------------------------------------------------------------------------
178     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
179         balances[from] = safeSub(balances[from], tokens);
180         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
181         balances[to] = safeAdd(balances[to], tokens);
182         Transfer(from, to, tokens);
183         return true;
184     }
185 
186 
187     // ------------------------------------------------------------------------
188     // Returns the amount of tokens approved by the owner that can be
189     // transferred to the spender's account
190     // ------------------------------------------------------------------------
191     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
192         return allowed[tokenOwner][spender];
193     }
194 
195 
196     // ------------------------------------------------------------------------
197     // Token owner can approve for spender to transferFrom(...) tokens
198     // from the token owner's account. The spender contract function
199     // receiveApproval(...) is then executed
200     // ------------------------------------------------------------------------
201     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
202         allowed[msg.sender][spender] = tokens;
203         Approval(msg.sender, spender, tokens);
204         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
205         return true;
206     }
207 
208 
209     // ------------------------------------------------------------------------
210     // Don't accept ETH
211     // ------------------------------------------------------------------------
212     function () public payable {
213         revert();
214     }
215 
216 
217     // ------------------------------------------------------------------------
218     // Owner can transfer out any accidentally sent ERC20 tokens
219     // ------------------------------------------------------------------------
220     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
221         return ERC20Interface(tokenAddress).transfer(owner, tokens);
222     }
223 }
224 contract Ballot {
225 
226     struct Voter {
227         uint weight;
228         bool voted;
229         uint8 vote;
230         address delegate;
231     }
232     struct Proposal {
233         uint voteCount;
234     }
235 
236     address chairperson;
237     mapping(address => Voter) voters;
238     Proposal[] proposals;
239 
240     /// Create a new ballot with $(_numProposals) different proposals.
241     function Ballot(uint8 _numProposals) public {
242         chairperson = msg.sender;
243         voters[chairperson].weight = 1;
244         proposals.length = _numProposals;
245     }
246 
247     /// Give $(toVoter) the right to vote on this ballot.
248     /// May only be called by $(chairperson).
249     function giveRightToVote(address toVoter) public {
250         if (msg.sender != chairperson || voters[toVoter].voted) return;
251         voters[toVoter].weight = 1;
252     }
253 
254     /// Delegate your vote to the voter $(to).
255     function delegate(address to) public {
256         Voter storage sender = voters[msg.sender]; // assigns reference
257         if (sender.voted) return;
258         while (voters[to].delegate != address(0) && voters[to].delegate != msg.sender)
259             to = voters[to].delegate;
260         if (to == msg.sender) return;
261         sender.voted = true;
262         sender.delegate = to;
263         Voter storage delegateTo = voters[to];
264         if (delegateTo.voted)
265             proposals[delegateTo.vote].voteCount += sender.weight;
266         else
267             delegateTo.weight += sender.weight;
268     }
269 
270     /// Give a single vote to proposal $(toProposal).
271     function vote(uint8 toProposal) public {
272         Voter storage sender = voters[msg.sender];
273         if (sender.voted || toProposal >= proposals.length) return;
274         sender.voted = true;
275         sender.vote = toProposal;
276         proposals[toProposal].voteCount += sender.weight;
277     }
278 
279     function winningProposal() public constant returns (uint8 _winningProposal) {
280         uint256 winningVoteCount = 0;
281         for (uint8 prop = 0; prop < proposals.length; prop++)
282             if (proposals[prop].voteCount > winningVoteCount) {
283                 winningVoteCount = proposals[prop].voteCount;
284                 _winningProposal = prop;
285             }
286     }
287 }