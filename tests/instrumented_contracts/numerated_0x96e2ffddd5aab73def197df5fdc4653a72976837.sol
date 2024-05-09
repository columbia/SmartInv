1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'LEIA' 'Save Princess Leia Peach Rainbow Vomit Cat ICO Token' token contract
5 //
6 // Princess Leia Peach Rainbow Vomit Cat #52
7 //   http://cryptocats.thetwentysix.io/#cbp=cats/52.html
8 // has been catnapped by
9 //   https://etherscan.io/address/0x4532874375f2417abadbde9003a7a468d4b926bd
10 // 
11 // A 10 ETH ransom demand has been made by @Ajent007 aka  @AJoobandi .
12 //
13 // * Help save Princess Leia Peach Rainbow Vomit Cat #52
14 // * Send your ETH to this crowdsale contract at
15 //   0x96E2fFDdd5aaB73dEf197df5fDC4653a72976837
16 // * A friendly reminder not to send your ETH anywhere else
17 // * 75% of raised funds will be used to:
18 //   * Blacklist 0x4532874375f2417abadbde9003a7a468d4b926bd in `geth`, Parity
19 //     and crypto-exchanges worldwide like the 13 million Tether hack
20 //     https://github.com/tetherto/omnicore/blob/0e43bc4734cae29fa99d287c51619ffc9ae0019a/src/omnicore/omnicore.cpp#L831-L834
21 //   * Add 0x4532874375f2417abadbde9003a7a468d4b926bd to https://etherscamdb.info/
22 //     for feline extortion
23 // * 25% of raised ETH to fund the founder's lifestyle
24 // * Crowdsale period 4 weeks
25 // * 20% bonus in the first week
26 // * 1,000 tokens per 1 ETH.
27 // * Nice work Team CryptoCats @CryptoCats26 http://cryptocats.thetwentysix.io/
28 // * Nice work @bitfwdxyz bitfwd.xyz for the MCIC blockathon 2017
29 //   https://twitter.com/bitfwdxyz/status/933105474228011008
30 // * Best of luck for the hackathon teams!!!
31 //
32 // ICO & token  : 0x96E2fFDdd5aaB73dEf197df5fDC4653a72976837
33 // SafeMath lib : 0x7c9801326a2A8394e45dBAcC115c975381A693aE
34 // Symbol       : LEIA
35 // Name         : Save Princess Leia Peach Rainbow Vomit Cat ICO Token
36 // Total supply : many
37 // Decimals     : 18
38 //
39 // https://github.com/bokkypoobah/Tokens/blob/master/contracts/SavePrincessLeiaPeachRainbowVomitCatICOToken.sol
40 //
41 // Enjoy.
42 //
43 // (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
44 // ----------------------------------------------------------------------------
45 
46 
47 // ----------------------------------------------------------------------------
48 // Safe maths
49 // ----------------------------------------------------------------------------
50 library SafeMath {
51     function add(uint a, uint b) public pure returns (uint c) {
52         c = a + b;
53         require(c >= a);
54     }
55     function sub(uint a, uint b) public pure returns (uint c) {
56         require(b <= a);
57         c = a - b;
58     }
59     function mul(uint a, uint b) public pure returns (uint c) {
60         c = a * b;
61         require(a == 0 || c / a == b);
62     }
63     function div(uint a, uint b) public pure returns (uint c) {
64         require(b > 0);
65         c = a / b;
66     }
67 }
68 
69 
70 // ----------------------------------------------------------------------------
71 // ERC Token Standard #20 Interface
72 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
73 // ----------------------------------------------------------------------------
74 contract ERC20Interface {
75     function totalSupply() public constant returns (uint);
76     function balanceOf(address tokenOwner) public constant returns (uint balance);
77     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
78     function transfer(address to, uint tokens) public returns (bool success);
79     function approve(address spender, uint tokens) public returns (bool success);
80     function transferFrom(address from, address to, uint tokens) public returns (bool success);
81 
82     event Transfer(address indexed from, address indexed to, uint tokens);
83     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
84 }
85 
86 
87 // ----------------------------------------------------------------------------
88 // Contract function to receive approval and execute function in one call
89 //
90 // Borrowed from MiniMeToken
91 // ----------------------------------------------------------------------------
92 contract ApproveAndCallFallBack {
93     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
94 }
95 
96 
97 // ----------------------------------------------------------------------------
98 // Owned contract
99 // ----------------------------------------------------------------------------
100 contract Owned {
101     address public owner;
102     address public newOwner;
103 
104     event OwnershipTransferred(address indexed _from, address indexed _to);
105 
106     function Owned() public {
107         owner = msg.sender;
108     }
109 
110     modifier onlyOwner {
111         require(msg.sender == owner);
112         _;
113     }
114 
115     function transferOwnership(address _newOwner) public onlyOwner {
116         newOwner = _newOwner;
117     }
118     function acceptOwnership() public {
119         require(msg.sender == newOwner);
120         OwnershipTransferred(owner, newOwner);
121         owner = newOwner;
122         newOwner = address(0);
123     }
124 }
125 
126 
127 // ----------------------------------------------------------------------------
128 // ERC20 Token, with the addition of symbol, name and decimals and assisted
129 // token transfers
130 // ----------------------------------------------------------------------------
131 contract SavePrincessLeiaPeachRainbowVomitCatICOToken is ERC20Interface, Owned {
132     using SafeMath for uint;
133 
134     string public symbol;
135     string public  name;
136     uint8 public decimals;
137     uint public _totalSupply;
138     uint public startDate;
139     uint public bonusEnds;
140     uint public endDate;
141 
142     mapping(address => uint) balances;
143     mapping(address => mapping(address => uint)) allowed;
144 
145 
146     // ------------------------------------------------------------------------
147     // Constructor
148     // ------------------------------------------------------------------------
149     function SavePrincessLeiaPeachRainbowVomitCatICOToken() public {
150         symbol = "LEIA";
151         name = "Save Princess Leia Peach Rainbow Vomit Cat ICO Token";
152         decimals = 18;
153         startDate = now;
154         bonusEnds = now + 1 weeks;
155         endDate = now + 4 weeks;
156     }
157 
158 
159     // ------------------------------------------------------------------------
160     // Total supply
161     // ------------------------------------------------------------------------
162     function totalSupply() public constant returns (uint) {
163         return _totalSupply  - balances[address(0)];
164     }
165 
166 
167     // ------------------------------------------------------------------------
168     // Get the token balance for account `tokenOwner`
169     // ------------------------------------------------------------------------
170     function balanceOf(address tokenOwner) public constant returns (uint balance) {
171         return balances[tokenOwner];
172     }
173 
174 
175     // ------------------------------------------------------------------------
176     // Transfer the balance from token owner's account to `to` account
177     // - Owner's account must have sufficient balance to transfer
178     // - 0 value transfers are allowed
179     // ------------------------------------------------------------------------
180     function transfer(address to, uint tokens) public returns (bool success) {
181         balances[msg.sender] = balances[msg.sender].sub(tokens);
182         balances[to] = balances[to].add(tokens);
183         Transfer(msg.sender, to, tokens);
184         return true;
185     }
186 
187 
188     // ------------------------------------------------------------------------
189     // Token owner can approve for `spender` to transferFrom(...) `tokens`
190     // from the token owner's account
191     //
192     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
193     // recommends that there are no checks for the approval double-spend attack
194     // as this should be implemented in user interfaces 
195     // ------------------------------------------------------------------------
196     function approve(address spender, uint tokens) public returns (bool success) {
197         allowed[msg.sender][spender] = tokens;
198         Approval(msg.sender, spender, tokens);
199         return true;
200     }
201 
202 
203     // ------------------------------------------------------------------------
204     // Transfer `tokens` from the `from` account to the `to` account
205     // 
206     // The calling account must already have sufficient tokens approve(...)-d
207     // for spending from the `from` account and
208     // - From account must have sufficient balance to transfer
209     // - Spender must have sufficient allowance to transfer
210     // - 0 value transfers are allowed
211     // ------------------------------------------------------------------------
212     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
213         balances[from] = balances[from].sub(tokens);
214         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
215         balances[to] = balances[to].add(tokens);
216         Transfer(from, to, tokens);
217         return true;
218     }
219 
220 
221     // ------------------------------------------------------------------------
222     // Returns the amount of tokens approved by the owner that can be
223     // transferred to the spender's account
224     // ------------------------------------------------------------------------
225     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
226         return allowed[tokenOwner][spender];
227     }
228 
229 
230     // ------------------------------------------------------------------------
231     // Token owner can approve for `spender` to transferFrom(...) `tokens`
232     // from the token owner's account. The `spender` contract function
233     // `receiveApproval(...)` is then executed
234     // ------------------------------------------------------------------------
235     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
236         allowed[msg.sender][spender] = tokens;
237         Approval(msg.sender, spender, tokens);
238         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
239         return true;
240     }
241 
242 
243     // ------------------------------------------------------------------------
244     // 1,000 LEIA per 1 ETH
245     // ------------------------------------------------------------------------
246     function () public payable {
247         require(now >= startDate && now <= endDate);
248         uint tokens;
249         if (now <= bonusEnds) {
250             tokens = msg.value * 1200;
251         } else {
252             tokens = msg.value * 1000;
253         }
254         balances[msg.sender] = balances[msg.sender].add(tokens);
255         _totalSupply = _totalSupply.add(tokens);
256         Transfer(address(0), msg.sender, tokens);
257         msg.sender.transfer(msg.value);
258     }
259 
260 
261     // ------------------------------------------------------------------------
262     // Owner can transfer out any accidentally sent ERC20 tokens
263     // ------------------------------------------------------------------------
264     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
265         return ERC20Interface(tokenAddress).transfer(owner, tokens);
266     }
267 }