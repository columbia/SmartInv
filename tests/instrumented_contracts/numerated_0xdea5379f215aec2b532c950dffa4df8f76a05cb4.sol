1 pragma solidity ^0.4.19;
2 
3 
4 //                 ,;'''''''';,  
5 //               ,'  ________  ',
6 //               ;,;'        ';,'
7 //                 '.________.'  
8 //
9 //    _____           _     _    _____      _       
10 //   / ____|         | |   (_)  / ____|    (_)      
11 //  | (___  _   _ ___| |__  _  | |     ___  _ _ __  
12 //   \___ \| | | / __| '_ \| | | |    / _ \| | '_ \ 
13 //   ____) | |_| \__ \ | | | | | |___| (_) | | | | |
14 //  |_____/ \__,_|___/_| |_|_|  \_____\___/|_|_| |_|
15 
16 // ----------------------------------------------------------------------------
17 // 'Sushi Coin' token contract
18 //
19 // Deployed to : 0xDEa5379f215Aec2b532C950dfFA4DF8F76A05CB4
20 // Symbol      : SUSHI
21 // Name        : Sushi Coin
22 // Total supply: 12345 Gazillion
23 // Decimals    : 18
24 // Website     : https://sushi-coin.com
25 //
26 // Enjoy sushi!
27 // 
28 // (c) sushi coin script by: Founders of Sushi Coin (https://sushi-coin.com). The MIT Licence.
29 // (c) original script by: Moritz Neto & Daniel Bar with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
30 // ----------------------------------------------------------------------------
31 
32 
33 // ----------------------------------------------------------------------------
34 // Safe maths
35 // ----------------------------------------------------------------------------
36 contract SafeMath {
37     function safeAdd(uint a, uint b) internal pure returns (uint c) {
38         c = a + b;
39         require(c >= a);
40     }
41     function safeSub(uint a, uint b) internal pure returns (uint c) {
42         require(b <= a);
43         c = a - b;
44     }
45     function safeMul(uint a, uint b) internal pure returns (uint c) {
46         c = a * b;
47         require(a == 0 || c / a == b);
48     }
49     function safeDiv(uint a, uint b) internal pure returns (uint c) {
50         require(b > 0);
51         c = a / b;
52     }
53 }
54 
55 
56 // ----------------------------------------------------------------------------
57 // ERC Token Standard #20 Interface
58 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
59 // ----------------------------------------------------------------------------
60 contract ERC20Interface {
61     function totalSupply() public constant returns (uint);
62     function balanceOf(address tokenOwner) public constant returns (uint balance);
63     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
64     function transfer(address to, uint tokens) public returns (bool success);
65     function approve(address spender, uint tokens) public returns (bool success);
66     function transferFrom(address from, address to, uint tokens) public returns (bool success);
67 
68     event Transfer(address indexed from, address indexed to, uint tokens);
69     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
70     event Burn(address indexed from, uint256 value);
71 }
72 
73 
74 // ----------------------------------------------------------------------------
75 // Contract function to receive approval and execute function in one call
76 //
77 // Borrowed from MiniMeToken
78 // ----------------------------------------------------------------------------
79 contract ApproveAndCallFallBack {
80     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
81 }
82 
83 
84 // ----------------------------------------------------------------------------
85 // Owned contract
86 // ----------------------------------------------------------------------------
87 contract Owned {
88     address public owner;
89     address public newOwner;
90 
91     event OwnershipTransferred(address indexed _from, address indexed _to);
92 
93     function Owned() public {
94         owner = msg.sender;
95     }
96 
97     modifier onlyOwner {
98         require(msg.sender == owner);
99         _;
100     }
101 
102     function transferOwnership(address _newOwner) public onlyOwner {
103         newOwner = _newOwner;
104     }
105     function acceptOwnership() public {
106         require(msg.sender == newOwner);
107         OwnershipTransferred(owner, newOwner);
108         owner = newOwner;
109         newOwner = address(0);
110     }
111 }
112 
113 
114 // ----------------------------------------------------------------------------
115 // ERC20 Token, with the addition of symbol, name and decimals and assisted
116 // token transfers
117 // ----------------------------------------------------------------------------
118 contract SushiCoin is ERC20Interface, Owned, SafeMath {
119     string public symbol;
120     string public  name;
121     uint8 public decimals;
122     uint public _totalSupply;
123 
124     mapping(address => uint) balances;
125     mapping(address => mapping(address => uint)) allowed;
126 
127 
128     // ------------------------------------------------------------------------
129     // Constructor
130     // ------------------------------------------------------------------------
131     function SushiCoin() public {
132         symbol = "SUSHI";
133         name = "Sushi Coin";
134         decimals = 18;
135         _totalSupply = 12345 * 10**uint(decimals);
136         balances[owner] = _totalSupply;
137         Transfer(address(0), owner, _totalSupply);
138     }
139 
140 
141     // ------------------------------------------------------------------------
142     // Total supply
143     // ------------------------------------------------------------------------
144     function totalSupply() public constant returns (uint) {
145         return _totalSupply  - balances[address(0)];
146     }
147 
148 
149     // ------------------------------------------------------------------------
150     // Get the token balance for account `tokenOwner`
151     // ------------------------------------------------------------------------
152     function balanceOf(address tokenOwner) public constant returns (uint balance) {
153         return balances[tokenOwner];
154     }
155 
156 
157     // ------------------------------------------------------------------------
158     // Transfer the balance from token owner's account to `to` account
159     // - Owner's account must have sufficient balance to transfer
160     // - 0 value transfers are allowed
161     // ------------------------------------------------------------------------
162     function transfer(address to, uint tokens) public returns (bool success) {
163         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
164         balances[to] = safeAdd(balances[to], tokens);
165         Transfer(msg.sender, to, tokens);
166         return true;
167     }
168 
169 
170     // ------------------------------------------------------------------------
171     // Token owner can approve for `spender` to transferFrom(...) `tokens`
172     // from the token owner's account
173     //
174     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
175     // recommends that there are no checks for the approval double-spend attack
176     // as this should be implemented in user interfaces
177     // ------------------------------------------------------------------------
178     function approve(address spender, uint tokens) public returns (bool success) {
179         allowed[msg.sender][spender] = tokens;
180         Approval(msg.sender, spender, tokens);
181         return true;
182     }
183 
184 
185     // ------------------------------------------------------------------------
186     // Transfer `tokens` from the `from` account to the `to` account
187     //
188     // The calling account must already have sufficient tokens approve(...)-d
189     // for spending from the `from` account and
190     // - From account must have sufficient balance to transfer
191     // - Spender must have sufficient allowance to transfer
192     // - 0 value transfers are allowed
193     // ------------------------------------------------------------------------
194     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
195         balances[from] = safeSub(balances[from], tokens);
196         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
197         balances[to] = safeAdd(balances[to], tokens);
198         Transfer(from, to, tokens);
199         return true;
200     }
201 
202 
203     // ------------------------------------------------------------------------
204     // Returns the amount of tokens approved by the owner that can be
205     // transferred to the spender's account
206     // ------------------------------------------------------------------------
207     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
208         return allowed[tokenOwner][spender];
209     }
210 
211 
212     // ------------------------------------------------------------------------
213     // Token owner can approve for `spender` to transferFrom(...) `tokens`
214     // from the token owner's account. The `spender` contract function
215     // `receiveApproval(...)` is then executed
216     // ------------------------------------------------------------------------
217     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
218         allowed[msg.sender][spender] = tokens;
219         Approval(msg.sender, spender, tokens);
220         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
221         return true;
222     }
223 
224 
225     // ------------------------------------------------------------------------
226     // Not possible to receive ETH and convert to SUSHI
227     // ------------------------------------------------------------------------
228     function () public payable {
229         revert();
230     }
231 
232 
233     // ------------------------------------------------------------------------
234     // Owner can transfer out any accidentally sent ERC20 tokens
235     // ------------------------------------------------------------------------
236     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
237         return ERC20Interface(tokenAddress).transfer(owner, tokens);
238     }
239 
240 
241     // ------------------------------------------------------------------------
242     // Owner can create new tokens
243     // ------------------------------------------------------------------------
244     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
245         balances[target] += mintedAmount;
246         _totalSupply += mintedAmount;
247         Transfer(0, owner, mintedAmount);
248         Transfer(owner, target, mintedAmount);
249     }
250 
251 
252     // ------------------------------------------------------------------------
253     // Owner can destroy tokens
254     // ------------------------------------------------------------------------
255     function burn(uint256 destroyAmount) onlyOwner public returns (bool success) {
256         require(balances[msg.sender] >= destroyAmount);
257         balances[msg.sender] -= destroyAmount;
258         _totalSupply -= destroyAmount;
259         Burn(msg.sender, destroyAmount);
260         return true;
261     }
262 
263 
264     // ------------------------------------------------------------------------
265     // Select a random number between 1 and 3
266     // ------------------------------------------------------------------------
267     function random() internal constant returns (uint) {
268         uint randomNumber = uint(now)%3 + 1;
269         return randomNumber;
270     }
271 
272 
273     // ------------------------------------------------------------------------
274     // What is the best food in the world?
275     // ------------------------------------------------------------------------
276     function WhatIsTheBestFoodInTheWorld() public constant returns (string) {
277         uint number = random();
278 
279         if (number == 1){
280             return "Sushi.";
281         } if (number == 2){
282             return "Starting with a 's' and ending with 'ushi'!";
283         } if (number == 3){
284             return "Haha, what an intriguing question. This will, of course, vary around the world. A variety of variables could possibly influence the answer to this question; time, culture, or even hair color. Therefore, we state that it would be naive to say that every single person in the world would like the same thing, let alone food. So considering the preceding text, I can not give you a specific answer. My sincere apologies.";
285         }
286     }
287 }