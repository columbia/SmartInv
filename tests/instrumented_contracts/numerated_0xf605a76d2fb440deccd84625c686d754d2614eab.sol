1 pragma solidity ^0.4.18;
2 
3 /**
4  *Owner address = 0x6BFAf995ffce7Be6e3073dC8AAf45E445cf234e2
5  *Parts of this code have been modified from code by BokkyPooBah:
6  *(c) by Moritz Neto with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
7  */
8  
9 contract SafeMath {
10     function safeAdd(uint a, uint b) public pure returns (uint c) {
11         c = a + b;
12         require(c >= a);
13     }
14     function safeSub(uint a, uint b) public pure returns (uint c) {
15         require(b <= a);
16         c = a - b;
17     }
18     function safeMul(uint a, uint b) public pure returns (uint c) {
19         c = a * b;
20         require(a == 0 || c / a == b);
21     }
22     function safeDiv(uint a, uint b) public pure returns (uint c) {
23         require(b > 0);
24         c = a / b;
25     }
26 }
27 
28 // ----------------------------------------------------------------------------
29 // ERC Token Standard #20 Interface
30 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
31 // ----------------------------------------------------------------------------
32 contract ERC20 {
33     function totalSupply() public constant returns (uint);
34     function balanceOf(address tokenOwner) public constant returns (uint balance);
35     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
36     function transfer(address to, uint tokens) public returns (bool success);
37     function approve(address spender, uint tokens) public returns (bool success);
38     function transferFrom(address from, address to, uint tokens) public returns (bool success);
39 
40     event Transfer(address indexed from, address indexed to, uint tokens);
41     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
42 }
43 
44 
45 // ----------------------------------------------------------------------------
46 // Contract function to receive approval and execute function in one call
47 //
48 // Borrowed from MiniMeToken
49 // ----------------------------------------------------------------------------
50 contract ApproveAndCallFallBack {
51     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
52 }
53 
54 
55 // ----------------------------------------------------------------------------
56 // Owned contract
57 // ----------------------------------------------------------------------------
58 contract Owned {
59     address public owner;
60     address public newOwner;
61 
62     event OwnershipTransferred(address indexed _from, address indexed _to);
63 
64     function Owned() public {
65         owner = msg.sender;
66     }
67 
68     modifier onlyOwner {
69         require(msg.sender == owner);
70         _;
71     }
72 
73     function transferOwnership(address _newOwner) public onlyOwner {
74         newOwner = _newOwner;
75     }
76     function acceptOwnership() public {
77         require(msg.sender == newOwner);
78         OwnershipTransferred(owner, newOwner);
79         owner = newOwner;
80         newOwner = address(0);
81     }
82 }
83 
84 
85 // ----------------------------------------------------------------------------
86 // ERC20 Token, with the addition of symbol, name and decimals and assisted
87 // token transfers
88 // ----------------------------------------------------------------------------
89 contract HeliosToken is ERC20, Owned, SafeMath {
90 	/*
91     NOTE:
92     The following variables are OPTIONAL vanities. One does not have to include them.
93     They allow one to customise the token contract & in no way influences the core functionality.
94     Some wallets/interfaces might not even bother to look at this information.
95     */
96     string public symbol;
97     string public  name;
98     uint8 public decimals;
99     uint public _totalSupply;
100 	uint public _yearTwoSupply;
101 	uint public _yearThreeSupply;
102 	bool public _yearTwoClaimed;
103 	bool public _yearThreeClaimed;
104 	//March 1, 2018
105 	uint256 public startTime = 1519862400;
106 	
107     mapping(address => uint) balances;
108     mapping(address => mapping(address => uint)) allowed;
109 
110 
111     // ------------------------------------------------------------------------
112     // Constructor
113     // ------------------------------------------------------------------------
114     function HeliosToken() public {
115         symbol = "HLS";
116         name = "Helios Token";
117         decimals = 18;
118         _totalSupply = 350000000000000000000000000;
119 		_yearTwoSupply = 30000000000000000000000000;
120 		_yearThreeSupply = 20000000000000000000000000;
121         
122 		//send 1st year team tokens, exchange tokens, incubator tokens
123 		balances[0x6BFAf995ffce7Be6e3073dC8AAf45E445cf234e2] = (_totalSupply - _yearTwoSupply - _yearThreeSupply);
124         Transfer(address(0), 0x6BFAf995ffce7Be6e3073dC8AAf45E445cf234e2, (_totalSupply - _yearTwoSupply - _yearThreeSupply));
125 		
126 		_yearTwoClaimed = false;
127 		_yearThreeClaimed = false;
128     }
129 
130 	// ------------------------------------------------------------------------
131     // Team can claim their tokens after lock up period
132     // ------------------------------------------------------------------------
133 	function teamClaim(uint year) public onlyOwner returns (bool success) {
134 		if(year == 2)
135 		{
136 			require (now > (startTime + 31536000)  && _yearTwoClaimed == false);
137 			balances[0x6BFAf995ffce7Be6e3073dC8AAf45E445cf234e2] = safeAdd(balances[0x6BFAf995ffce7Be6e3073dC8AAf45E445cf234e2], _yearTwoSupply);
138 			Transfer(address(0), 0x6BFAf995ffce7Be6e3073dC8AAf45E445cf234e2, _yearTwoSupply);
139 			_yearTwoClaimed = true;
140 			
141 		}
142 		if(year == 3)
143 		{
144 			require (now > (startTime + 63072000) && _yearThreeClaimed == false);
145 			balances[0x6BFAf995ffce7Be6e3073dC8AAf45E445cf234e2] = safeAdd(balances[0x6BFAf995ffce7Be6e3073dC8AAf45E445cf234e2], _yearThreeSupply);
146 			Transfer(address(0), 0x6BFAf995ffce7Be6e3073dC8AAf45E445cf234e2, _yearThreeSupply);
147 			_yearThreeClaimed = true;
148 		}
149 		return true;
150 	}
151 	
152 	
153     // ------------------------------------------------------------------------
154     // Total supply
155     // ------------------------------------------------------------------------
156     function totalSupply() public constant returns (uint) {
157         return _totalSupply  - balances[address(0)];
158     }
159 
160   
161     // ------------------------------------------------------------------------
162     // Get the token balance for account tokenOwner
163     // ------------------------------------------------------------------------
164     function balanceOf(address tokenOwner) public constant returns (uint balance) {
165         return balances[tokenOwner];
166     }
167 
168 
169     // ------------------------------------------------------------------------
170     // Transfer the balance from token owner's account to to account
171     // - Owner's account must have sufficient balance to transfer
172     // - 0 value transfers are allowed
173 	// - If the sender is a locked token storage address then do not allow
174     // ------------------------------------------------------------------------
175     function transfer(address to, uint tokens) public returns (bool success) {
176         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
177         balances[to] = safeAdd(balances[to], tokens);
178         Transfer(msg.sender, to, tokens);
179         return true;
180     }
181 
182 
183     // ------------------------------------------------------------------------
184     // Token owner can approve for spender to transferFrom(...) tokens
185     // from the token owner's account
186     //
187     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
188     // recommends that there are no checks for the approval double-spend attack
189     // as this should be implemented in user interfaces 
190     // ------------------------------------------------------------------------
191     function approve(address spender, uint tokens) public returns (bool success) {
192         allowed[msg.sender][spender] = tokens;
193         Approval(msg.sender, spender, tokens);
194         return true;
195     }
196 
197 
198     // ------------------------------------------------------------------------
199     // Transfer tokens from the from account to the to account
200     // 
201     // The calling account must already have sufficient tokens approve(...)-d
202     // for spending from the from account and
203     // - From account must have sufficient balance to transfer
204     // - Spender must have sufficient allowance to transfer
205     // - 0 value transfers are allowed
206     // ------------------------------------------------------------------------
207     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
208         balances[from] = safeSub(balances[from], tokens);
209         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
210         balances[to] = safeAdd(balances[to], tokens);
211         Transfer(from, to, tokens);
212         return true;
213     }
214 
215 
216     // ------------------------------------------------------------------------
217     // Returns the amount of tokens approved by the owner that can be
218     // transferred to the spender's account
219     // ------------------------------------------------------------------------
220     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
221         return allowed[tokenOwner][spender];
222     }
223 
224 
225     // ------------------------------------------------------------------------
226     // Token owner can approve for spender to transferFrom(...) tokens
227     // from the token owner's account. The spender contract function
228     // receiveApproval(...) is then executed
229     // ------------------------------------------------------------------------
230     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
231         allowed[msg.sender][spender] = tokens;
232         Approval(msg.sender, spender, tokens);
233         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
234         return true;
235     }
236 
237 
238     // ------------------------------------------------------------------------
239     // Don't accept ETH
240     // ------------------------------------------------------------------------
241     function () public payable {
242         revert();
243     }
244 
245 
246     // ------------------------------------------------------------------------
247     // Owner can transfer out any accidentally sent ERC20 tokens
248     // ------------------------------------------------------------------------
249     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
250         return ERC20(tokenAddress).transfer(owner, tokens);
251     }
252 }