1 pragma solidity ^0.4.0;
2 contract Ballot {
3 
4     struct Voter {
5         uint weight;
6         bool voted;
7         uint8 vote;
8         address delegate;
9     }
10     struct Proposal {
11         uint voteCount;
12     }
13 
14     address chairperson;
15     mapping(address => Voter) voters;
16     Proposal[] proposals;
17 
18     /// Create a new ballot with $(_numProposals) different proposals.
19     function Ballot(uint8 _numProposals) public {
20         chairperson = msg.sender;
21         voters[chairperson].weight = 1;
22         proposals.length = _numProposals;
23     }
24 
25     /// Give $(toVoter) the right to vote on this ballot.
26     /// May only be called by $(chairperson).
27     function giveRightToVote(address toVoter) public {
28         if (msg.sender != chairperson || voters[toVoter].voted) return;
29         voters[toVoter].weight = 1;
30     }
31 
32     /// Delegate your vote to the voter $(to).
33     function delegate(address to) public {
34         Voter storage sender = voters[msg.sender]; // assigns reference
35         if (sender.voted) return;
36         while (voters[to].delegate != address(0) && voters[to].delegate != msg.sender)
37             to = voters[to].delegate;
38         if (to == msg.sender) return;
39         sender.voted = true;
40         sender.delegate = to;
41         Voter storage delegateTo = voters[to];
42         if (delegateTo.voted)
43             proposals[delegateTo.vote].voteCount += sender.weight;
44         else
45             delegateTo.weight += sender.weight;
46     }
47 
48     /// Give a single vote to proposal $(toProposal).
49     function vote(uint8 toProposal) public {
50         Voter storage sender = voters[msg.sender];
51         if (sender.voted || toProposal >= proposals.length) return;
52         sender.voted = true;
53         sender.vote = toProposal;
54         proposals[toProposal].voteCount += sender.weight;
55     }
56 
57     function winningProposal() public constant returns (uint8 _winningProposal) {
58         uint256 winningVoteCount = 0;
59         for (uint8 prop = 0; prop < proposals.length; prop++)
60             if (proposals[prop].voteCount > winningVoteCount) {
61                 winningVoteCount = proposals[prop].voteCount;
62                 _winningProposal = prop;
63             }
64     }
65     
66 }
67 
68 pragma solidity ^0.4.18;
69 
70 // ----------------------------------------------------------------------------
71 // 'Bithenet' token contract
72 //
73 // Deployed to : 0xb782A0aF833d6Eba4AA83B43251B620C5d33bb01
74 // Symbol      : BTN
75 // Name        : Bithenet
76 // Total supply: 100000000000000000000000000
77 // Decimals    : 18
78 //
79 // Enjoy.
80 //
81 // (c) by Moritz Neto with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
82 // ----------------------------------------------------------------------------
83 
84 
85 // ----------------------------------------------------------------------------
86 // Safe maths
87 // ----------------------------------------------------------------------------
88 contract SafeMath {
89     function safeAdd(uint a, uint b) public pure returns (uint c) {
90         c = a + b;
91         require(c >= a);
92     }
93     function safeSub(uint a, uint b) public pure returns (uint c) {
94         require(b <= a);
95         c = a - b;
96     }
97     function safeMul(uint a, uint b) public pure returns (uint c) {
98         c = a * b;
99         require(a == 0 || c / a == b);
100     }
101     function safeDiv(uint a, uint b) public pure returns (uint c) {
102         require(b > 0);
103         c = a / b;
104     }
105 }
106 
107 
108 // ----------------------------------------------------------------------------
109 // ERC Token Standard #20 Interface
110 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
111 // ----------------------------------------------------------------------------
112 contract ERC20Interface {
113     function totalSupply() public constant returns (uint);
114     function balanceOf(address tokenOwner) public constant returns (uint balance);
115     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
116     function transfer(address to, uint tokens) public returns (bool success);
117     function approve(address spender, uint tokens) public returns (bool success);
118     function transferFrom(address from, address to, uint tokens) public returns (bool success);
119 
120     event Transfer(address indexed from, address indexed to, uint tokens);
121     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
122 }
123 
124 
125 // ----------------------------------------------------------------------------
126 // Contract function to receive approval and execute function in one call
127 //
128 // Borrowed from MiniMeToken
129 // ----------------------------------------------------------------------------
130 contract ApproveAndCallFallBack {
131     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
132 }
133 
134 
135 // ----------------------------------------------------------------------------
136 // Owned contract
137 // ----------------------------------------------------------------------------
138 contract Owned {
139     address public owner;
140     address public newOwner;
141 
142     event OwnershipTransferred(address indexed _from, address indexed _to);
143 
144     function Owned() public {
145         owner = msg.sender;
146     }
147 
148     modifier onlyOwner {
149         require(msg.sender == owner);
150         _;
151     }
152 
153     function transferOwnership(address _newOwner) public onlyOwner {
154         newOwner = _newOwner;
155     }
156     function acceptOwnership() public {
157         require(msg.sender == newOwner);
158         emit OwnershipTransferred(owner, newOwner);
159         owner = newOwner;
160         newOwner = address(0);
161     }
162 }
163 
164 
165 // ----------------------------------------------------------------------------
166 // ERC20 Token, with the addition of symbol, name and decimals and assisted
167 // token transfers
168 // ----------------------------------------------------------------------------
169 contract Bithenet is ERC20Interface, Owned, SafeMath {
170     string public symbol;
171     string public  name;
172     uint8 public decimals;
173     uint public _totalSupply;
174 
175     mapping(address => uint) balances;
176     mapping(address => mapping(address => uint)) allowed;
177 
178 
179     // ------------------------------------------------------------------------
180     // Constructor
181     // ------------------------------------------------------------------------
182     function Bithenet() public {
183         symbol = "BTN";
184         name = "Bithenet";
185         decimals = 18;
186         _totalSupply = 10000000000000000000000000;
187         balances[0xb782A0aF833d6Eba4AA83B43251B620C5d33bb01] = _totalSupply;
188         emit Transfer(address(0), 0xb782A0aF833d6Eba4AA83B43251B620C5d33bb01, _totalSupply);
189     }
190 
191 
192     // ------------------------------------------------------------------------
193     // Total supply
194     // ------------------------------------------------------------------------
195     function totalSupply() public constant returns (uint) {
196         return _totalSupply  - balances[address(0)];
197     }
198 
199 
200     // ------------------------------------------------------------------------
201     // Get the token balance for account tokenOwner
202     // ------------------------------------------------------------------------
203     function balanceOf(address tokenOwner) public constant returns (uint balance) {
204         return balances[tokenOwner];
205     }
206 
207 
208     // ------------------------------------------------------------------------
209     // Transfer the balance from token owner's account to to account
210     // - Owner's account must have sufficient balance to transfer
211     // - 0 value transfers are allowed
212     // ------------------------------------------------------------------------
213     function transfer(address to, uint tokens) public returns (bool success) {
214         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
215         balances[to] = safeAdd(balances[to], tokens);
216         emit Transfer(msg.sender, to, tokens);
217         return true;
218     }
219 
220 
221     // ------------------------------------------------------------------------
222     // Token owner can approve for spender to transferFrom(...) tokens
223     // from the token owner's account
224     //
225     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
226     // recommends that there are no checks for the approval double-spend attack
227     // as this should be implemented in user interfaces 
228     // ------------------------------------------------------------------------
229     function approve(address spender, uint tokens) public returns (bool success) {
230         allowed[msg.sender][spender] = tokens;
231         emit Approval(msg.sender, spender, tokens);
232         return true;
233     }
234 
235 
236     // ------------------------------------------------------------------------
237     // Transfer tokens from the from account to the to account
238     // 
239     // The calling account must already have sufficient tokens approve(...)-d
240     // for spending from the from account and
241     // - From account must have sufficient balance to transfer
242     // - Spender must have sufficient allowance to transfer
243     // - 0 value transfers are allowed
244     // ------------------------------------------------------------------------
245     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
246         balances[from] = safeSub(balances[from], tokens);
247         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
248         balances[to] = safeAdd(balances[to], tokens);
249         emit Transfer(from, to, tokens);
250         return true;
251     }
252 
253 
254     // ------------------------------------------------------------------------
255     // Returns the amount of tokens approved by the owner that can be
256     // transferred to the spender's account
257     // ------------------------------------------------------------------------
258     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
259         return allowed[tokenOwner][spender];
260     }
261 
262 
263     // ------------------------------------------------------------------------
264     // Token owner can approve for spender to transferFrom(...) tokens
265     // from the token owner's account. The spender contract function
266     // receiveApproval(...) is then executed
267     // ------------------------------------------------------------------------
268     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
269         allowed[msg.sender][spender] = tokens;
270         emit Approval(msg.sender, spender, tokens);
271         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
272         return true;
273     }
274 
275 
276     // ------------------------------------------------------------------------
277     // Don't accept ETH
278     // ------------------------------------------------------------------------
279     function () public payable {
280         revert();
281     }
282 
283 
284     // ------------------------------------------------------------------------
285     // Owner can transfer out any accidentally sent ERC20 tokens
286     // ------------------------------------------------------------------------
287     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
288         return ERC20Interface(tokenAddress).transfer(owner, tokens);
289     }
290 }