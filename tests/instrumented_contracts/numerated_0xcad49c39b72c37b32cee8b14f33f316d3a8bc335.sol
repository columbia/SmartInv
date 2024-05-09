1 pragma solidity ^0.4.24;
2 //asdfasdf
3 contract SafeMath {
4     function safeAdd(uint a, uint b) public pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function safeSub(uint a, uint b) public pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function safeMul(uint a, uint b) public pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function safeDiv(uint a, uint b) public pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 
23 // ----------------------------------------------------------------------------
24 // ERC Token Standard #20 Interface
25 // ----------------------------------------------------------------------------
26 contract ERC20Interface {
27     function totalSupply() public constant returns (uint);
28     function balanceOf(address tokenOwner) public constant returns (uint balance);
29     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
30     function transfer(address to, uint tokens) public returns (bool success);
31     function approve(address spender, uint tokens) public returns (bool success);
32     function checkRate() public constant returns (uint rate_);
33 
34     event Transfer(address indexed from, address indexed to, uint tokens);
35     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
36     event Blacklisted(address indexed target);
37 	event DeleteFromBlacklist(address indexed target);
38 	event RejectedPaymentToBlacklistedAddr(address indexed from, address indexed to, uint value);
39 	event RejectedPaymentFromBlacklistedAddr(address indexed from, address indexed to, uint value);
40 	event RejectedPaymentFromLockedAddr(address indexed from, address indexed to, uint value, uint lackdatetime, uint now_);
41 	event RejectedPaymentMaximunFromLockedAddr(address indexed from, address indexed to, uint value);
42 	event test1(uint rate, uint a, uint now );
43 }
44 
45 
46 // ----------------------------------------------------------------------------
47 // Contract function to receive approval and execute function in one call
48 // ----------------------------------------------------------------------------
49 contract ApproveAndCallFallBack {
50     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
51 }
52 
53 
54 // ----------------------------------------------------------------------------
55 // Owned contract
56 // ----------------------------------------------------------------------------
57 contract Owned {
58     address public owner;
59     address public newOwner;
60 
61     event OwnershipTransferred(address indexed _from, address indexed _to);
62 
63     constructor() public {
64         owner = msg.sender;
65     }
66 
67     modifier onlyOwner {
68         require(msg.sender == owner);
69         _;
70     }
71 
72     function transferOwnership(address _newOwner) public onlyOwner {
73         newOwner = _newOwner;
74     }
75     function acceptOwnership() public {
76         require(msg.sender == newOwner);
77         emit OwnershipTransferred(owner, newOwner);
78         owner = newOwner;
79         newOwner = address(0);
80     }
81 }
82 
83 
84 // ----------------------------------------------------------------------------
85 // ERC20 Token, with the addition of symbol, name and decimals and assisted
86 // token transfers
87 // ----------------------------------------------------------------------------
88 contract SodaCoin is ERC20Interface, Owned, SafeMath {
89     string public symbol;
90     string public  name;
91     uint8 public decimals;
92     uint public _totalSupply;
93     uint public start;
94     address founderAddr = 0x625f7Ae05DC8c22dA56F47CaDc8c647137a6B4D9;
95     address advisorAddr = 0x45F6a7D7903D3A02bef15826eBCA44aB5eD11758;
96 
97     mapping(address => uint) balances;
98     mapping(address => mapping(address => uint)) allowed;
99     mapping(address => int8) public blacklist;
100     UnlockDateModel[] public unlockdate;
101 
102     struct UnlockDateModel {
103 		//string date;
104 		uint256 datetime;
105 		uint rate;
106 	}
107     
108     // ------------------------------------------------------------------------
109     // Constructor
110     // ------------------------------------------------------------------------
111     constructor() public {
112         symbol = "SOC";
113         name = "SODA Coin";
114         decimals = 18;
115         _totalSupply = 2000000000000000000000000000;
116         balances[msg.sender] = 1400000000000000000000000000;
117         emit Transfer(address(0), 0x1E7A12b193D18027E33cd3Ff0eef2Af31cbBF9ef, 1400000000000000000000000000); // owner wallet (70%) 1,400,000,000
118         // Founder & Team wallet (15%) 300,000,000
119         // Vesting over 2 years and 10 months (10% monthly release after 2 years)
120         balances[founderAddr] = 300000000000000000000000000;
121         emit Transfer(address(0), founderAddr, 300000000000000000000000000); 
122         // Advisor & Partner wallet (15%) 300,000,000
123         // Vesting over 2 years and 10 months (10% monthly release after 2 years)
124         balances[advisorAddr] = 300000000000000000000000000;
125         emit Transfer(address(0), advisorAddr, 300000000000000000000000000);
126         
127         start = now;
128         unlockdate.push(UnlockDateModel({datetime : 1610237400,rate : 10}));
129         unlockdate.push(UnlockDateModel({datetime : 1612915800,rate : 10}));
130         unlockdate.push(UnlockDateModel({datetime : 1615335000,rate : 10}));
131         unlockdate.push(UnlockDateModel({datetime : 1618013400,rate : 10}));
132         unlockdate.push(UnlockDateModel({datetime : 1620605400,rate : 10}));
133         unlockdate.push(UnlockDateModel({datetime : 1623283800,rate : 10}));
134         unlockdate.push(UnlockDateModel({datetime : 1625875800,rate : 10}));
135         unlockdate.push(UnlockDateModel({datetime : 1628554200,rate : 10}));
136         unlockdate.push(UnlockDateModel({datetime : 1631232600,rate : 10}));
137         unlockdate.push(UnlockDateModel({datetime : 1633824600,rate : 10}));
138     }
139     
140     function now_() public constant returns (uint){
141         return now;
142     }
143 
144     // ------------------------------------------------------------------------
145     // Total supply
146     // ------------------------------------------------------------------------
147     function totalSupply() public constant returns (uint) {
148         return _totalSupply  - balances[address(0)];
149     }
150 
151 
152     // ------------------------------------------------------------------------
153     // Get the token balance for account tokenOwner
154     // ------------------------------------------------------------------------
155     function balanceOf(address tokenOwner) public constant returns (uint balance) {
156         return balances[tokenOwner];
157     }
158 
159     function checkRate() public constant returns (uint rate_){
160         uint rate = 0;
161         for (uint i = 0; i<unlockdate.length; i++) {
162             if (unlockdate[i].datetime < now) {
163                 rate = rate + unlockdate[i].rate; 
164             }
165         }
166         return rate;
167     }
168     
169     // ------------------------------------------------------------------------
170     // Transfer the balance from token owner's account to to account
171     // - Owner's account must have sufficient balance to transfer
172     // - 0 value transfers are allowed
173     // ------------------------------------------------------------------------
174   
175     function transfer(address to, uint tokens) public returns (bool success) {
176         if (msg.sender == founderAddr || msg.sender == advisorAddr){
177             if (unlockdate[0].datetime > now) {
178                 emit RejectedPaymentFromLockedAddr(msg.sender, to, tokens, unlockdate[0].datetime, now);
179 			    return false;
180             } else {
181                 uint rate = checkRate();
182                 
183                 uint maximum = 300000000000000000000000000 - (300000000000000000000000000 * 0.01) * rate;
184                 if (maximum > (balances[msg.sender] - tokens)){
185                     emit RejectedPaymentMaximunFromLockedAddr(msg.sender, to, tokens);
186 			        return false;
187                 }
188             }
189         }
190         
191         if (blacklist[msg.sender] > 0) { // Accounts in the blacklist can not be withdrawn
192 			emit RejectedPaymentFromBlacklistedAddr(msg.sender, to, tokens);
193 			return false;
194 		} else if (blacklist[to] > 0) { // Accounts in the blacklist can not be withdrawn
195 			emit RejectedPaymentToBlacklistedAddr(msg.sender, to, tokens);
196 			return false;
197 		} else {
198 			balances[msg.sender] = safeSub(balances[msg.sender], tokens);
199             balances[to] = safeAdd(balances[to], tokens);
200             emit Transfer(msg.sender, to, tokens);
201             return true;
202 		}
203 		
204     }
205 
206     // ------------------------------------------------------------------------
207     // Token owner can approve for spender to transferFrom(...) tokens
208     // from the token owner's account
209     // ------------------------------------------------------------------------
210     function approve(address spender, uint tokens) public returns (bool success) {
211         allowed[msg.sender][spender] = tokens;
212         emit Approval(msg.sender, spender, tokens);
213         return true;
214     }
215 
216 
217 
218     // ------------------------------------------------------------------------
219     // Returns the amount of tokens approved by the owner that can be
220     // transferred to the spender's account
221     // ------------------------------------------------------------------------
222     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
223         return allowed[tokenOwner][spender];
224     }
225 
226 
227     // ------------------------------------------------------------------------
228     // Token owner can approve for spender to transferFrom(...) tokens
229     // from the token owner's account. The spender contract function
230     // receiveApproval(...) is then executed
231     // ------------------------------------------------------------------------
232     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
233         allowed[msg.sender][spender] = tokens;
234         emit Approval(msg.sender, spender, tokens);
235         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
236         return true;
237     }
238 
239 
240     // ------------------------------------------------------------------------
241     // Don't accept ETH
242     // ------------------------------------------------------------------------
243     function () public payable {
244         revert();
245     }
246 
247     // ------------------------------------------------------------------------
248     // Owner can transfer out any accidentally sent ERC20 tokens
249     // ------------------------------------------------------------------------
250     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
251         return ERC20Interface(tokenAddress).transfer(owner, tokens);
252     }
253     
254     // ------------------------------------------------------------------------
255     // Owner can add an increase total supply.
256     // ------------------------------------------------------------------------
257 	function totalSupplyIncrease(uint256 _supply) public onlyOwner{
258 		_totalSupply = _totalSupply + _supply;
259 		balances[msg.sender] = balances[msg.sender] + _supply;
260 	}
261 	
262 	// ------------------------------------------------------------------------
263     // Owner can add blacklist the wallet address.
264     // ------------------------------------------------------------------------
265 	function blacklisting(address _addr) public onlyOwner{
266 		blacklist[_addr] = 1;
267 		emit Blacklisted(_addr);
268 	}
269 	
270 	
271 	// ------------------------------------------------------------------------
272     // Owner can delete from blacklist the wallet address.
273     // ------------------------------------------------------------------------
274 	function deleteFromBlacklist(address _addr) public onlyOwner{
275 		blacklist[_addr] = -1;
276 		emit DeleteFromBlacklist(_addr);
277 	}
278 	
279 }