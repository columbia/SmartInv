1 pragma solidity ^0.4.18;
2 
3 // Corrently CAPEX token
4 // Modified for https://corrently.de/token
5 //
6 // Leveraged by STROMDAO (https://stromdao.de/)
7 // Changes:
8 //   - embedded SafeMath due to missing utilization in some functions
9 //
10 // ----------------------------------------------------------------------------
11 // Based on FWD 'BitFwd' token contract
12 //
13 // FWD tokens are mintable by the owner until the `disableMinting()` function
14 // is executed. Tokens can be burnt by sending them to address 0x0
15 //
16 // Deployed to : 0xe199C41103020a325Ee17Fd87934dfe7Ac747AD4
17 // Symbol      : FWD
18 // Name        : BitFwd
19 // Total supply: mintable
20 // Decimals    : 18
21 //
22 // http://www.bitfwd.xyz
23 // https://github.com/bokkypoobah/Tokens/blob/master/contracts/BitFwdToken.sol
24 //
25 // Enjoy.
26 //
27 // (c) BokkyPooBah / Bok Consulting Pty Ltd for BitFwd 2017. The MIT Licence.
28 // ----------------------------------------------------------------------------
29 
30 
31 
32 // ----------------------------------------------------------------------------
33 // ERC Token Standard #20 Interface
34 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
35 // ----------------------------------------------------------------------------
36 contract ERC20Interface {
37     function totalSupply() public view returns (uint);
38     function balanceOf(address tokenOwner) public view returns (uint balance);
39     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
40     function transfer(address to, uint tokens) public returns (bool success);
41     function approve(address spender, uint tokens) public returns (bool success);
42     function transferFrom(address from, address to, uint tokens) public returns (bool success);
43 
44     event Transfer(address indexed from, address indexed to, uint tokens);
45     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
46 }
47 
48 
49 // ----------------------------------------------------------------------------
50 // Contract function to receive approval and execute function in one call
51 //
52 // Borrowed from MiniMeToken
53 // ----------------------------------------------------------------------------
54 contract ApproveAndCallFallBack {
55     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
56 }
57 
58 
59 // ----------------------------------------------------------------------------
60 // Owned contract
61 // ----------------------------------------------------------------------------
62 contract Owned {
63     address public owner;
64     address public newOwner;
65 
66     event OwnershipTransferred(address indexed _from, address indexed _to);
67 
68     constructor() public {
69         owner = msg.sender;
70     }
71 
72     modifier onlyOwner {
73         require(msg.sender == owner);
74         _;
75     }
76 
77     function transferOwnership(address _newOwner) public onlyOwner {
78         newOwner = _newOwner;
79     }
80 
81     function acceptOwnership() public {
82         require(msg.sender == newOwner);
83         emit OwnershipTransferred(owner, newOwner);
84         owner = newOwner;
85         newOwner = address(0);
86     }
87 }
88 
89 
90 // ----------------------------------------------------------------------------
91 // ERC20 Token, with the addition of symbol, name and decimals and assisted
92 // token transfers
93 // ----------------------------------------------------------------------------
94 contract CorrentlyInvest is ERC20Interface, Owned {
95 
96 
97     string public symbol;
98     string public  name;
99     uint8 public decimals;
100     uint public _totalSupply;
101     bool public mintable;
102 
103     mapping(address => uint) balances;
104     mapping(address => mapping(address => uint)) allowed;
105 
106     event MintingDisabled();
107 
108 
109     // ------------------------------------------------------------------------
110     // Constructor
111     // ------------------------------------------------------------------------
112     constructor() public {
113         symbol = "CORI";
114         name = "Corrently Invest";
115         decimals = 2;
116         mintable = true;
117     }
118 
119 
120     // ------------------------------------------------------------------------
121     // Total supply
122     // ------------------------------------------------------------------------
123     function totalSupply() public view returns (uint) {
124         return _totalSupply  - balances[address(0)];
125     }
126 
127 
128     // ------------------------------------------------------------------------
129     // Disable minting
130     // ------------------------------------------------------------------------
131     function disableMinting() public onlyOwner {
132         require(mintable);
133         mintable = false;
134         emit MintingDisabled();
135     }
136 
137 
138     // ------------------------------------------------------------------------
139     // Get the token balance for account `tokenOwner`
140     // ------------------------------------------------------------------------
141     function balanceOf(address tokenOwner) public view returns (uint balance) {
142         return balances[tokenOwner];
143     }
144 
145 
146     // ------------------------------------------------------------------------
147     // Transfer the balance from token owner's account to `to` account
148     // - Owner's account must have sufficient balance to transfer
149     // - 0 value transfers are allowed
150     // ------------------------------------------------------------------------
151     function transfer(address to, uint tokens) public returns (bool success) {
152         require(tokens <= balances[msg.sender]);
153         balances[msg.sender] -= tokens;
154         require( balances[to]+tokens >=  balances[to]);
155         balances[to] += tokens;
156         emit Transfer(msg.sender, to, tokens);
157         return true;
158     }
159 
160 
161     // ------------------------------------------------------------------------
162     // Token owner can approve for `spender` to transferFrom(...) `tokens`
163     // from the token owner's account
164     //
165     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
166     // recommends that there are no checks for the approval double-spend attack
167     // as this should be implemented in user interfaces
168     // ------------------------------------------------------------------------
169     function approve(address spender, uint tokens) public returns (bool success) {
170         allowed[msg.sender][spender] = tokens;
171         emit Approval(msg.sender, spender, tokens);
172         return true;
173     }
174 
175 
176     // ------------------------------------------------------------------------
177     // Transfer `tokens` from the `from` account to the `to` account
178     //
179     // The calling account must already have sufficient tokens approve(...)-d
180     // for spending from the `from` account and
181     // - From account must have sufficient balance to transfer
182     // - Spender must have sufficient allowance to transfer
183     // - 0 value transfers are allowed
184     // ------------------------------------------------------------------------
185     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
186         require(tokens <= balances[msg.sender]);
187         balances[from] -= tokens;
188         allowed[from][msg.sender] -= tokens;
189         require( balances[to]+tokens >=  balances[to]);
190         balances[to] += tokens;
191         emit Transfer(from, to, tokens);
192         return true;
193     }
194 
195 
196     // ------------------------------------------------------------------------
197     // Returns the amount of tokens approved by the owner that can be
198     // transferred to the spender's account
199     // ------------------------------------------------------------------------
200     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
201         return allowed[tokenOwner][spender];
202     }
203 
204 
205     // ------------------------------------------------------------------------
206     // Token owner can approve for `spender` to transferFrom(...) `tokens`
207     // from the token owner's account. The `spender` contract function
208     // `receiveApproval(...)` is then executed
209     // ------------------------------------------------------------------------
210     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
211         allowed[msg.sender][spender] = tokens;
212         emit Approval(msg.sender, spender, tokens);
213         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
214         return true;
215     }
216 
217 
218     // ------------------------------------------------------------------------
219     // Mint tokens
220     // ------------------------------------------------------------------------
221     function mint(address tokenOwner, uint tokens) public onlyOwner returns (bool success) {
222         require(mintable);
223         require( balances[tokenOwner]+tokens >=  balances[tokenOwner]);
224         balances[tokenOwner] += tokens;
225         require(_totalSupply+tokens>=_totalSupply);
226         _totalSupply += tokens;
227 
228         emit Transfer(address(0), tokenOwner, tokens);
229         return true;
230     }
231 
232 
233     // ------------------------------------------------------------------------
234     // Don't accept ethers
235     // ------------------------------------------------------------------------
236     function ()  external  {
237          revert();
238     }
239 
240 
241     // ------------------------------------------------------------------------
242     // Owner can transfer out any accidentally sent ERC20 tokens
243     // ------------------------------------------------------------------------
244     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
245         return ERC20Interface(tokenAddress).transfer(owner, tokens);
246     }
247 }
248 
249 contract exD is  Owned {
250 
251     ERC20Interface public token;
252 
253     uint public totalDividend = 0;
254     uint public totalSupply = 0;
255     uint public divMultiplier =0;
256     uint public totalClaimed=0;
257 
258     mapping(address => uint) claimed;
259     event Dividend(uint _value);
260     event Payed(address account,uint _value);
261     event Withdraw(uint _value);
262     
263     // ------------------------------------------------------------------------
264     // Constructor
265     // ------------------------------------------------------------------------
266     constructor(ERC20Interface _token) public {
267         token=_token;
268     }
269 
270 
271     function balanceOf(address _account) public view returns (uint) {
272         return (token.balanceOf(_account)*divMultiplier)-claimed[_account];
273     }
274     
275     // ------------------------------------------------------------------------
276     // As a holder of token, withdraw your dvidend
277     // ------------------------------------------------------------------------
278     function withdrawDividend() payable public {
279         uint due=(token.balanceOf(msg.sender)*divMultiplier)-claimed[msg.sender];
280         if(due+claimed[msg.sender]<claimed[msg.sender]) revert();        
281         claimed[msg.sender]+=due;
282         totalClaimed+=due;
283         msg.sender.transfer(due);
284         emit Payed(msg.sender,due);
285     }
286     
287     function withdrawBonds(uint value) onlyOwner public {
288         totalDividend-=value;
289         owner.transfer(value);
290         emit Withdraw(value);
291     }
292     
293     // ------------------------------------------------------------------------
294     // All ethers send via standard will become part of our dividend payments
295     // ------------------------------------------------------------------------
296     function () public payable  {
297       if(msg.value<1) revert();
298       if(totalDividend+msg.value<totalDividend) revert();
299       if(token.totalSupply()+totalSupply<totalSupply) revert();
300       totalDividend+=msg.value;
301       totalSupply+=token.totalSupply();
302       divMultiplier=totalDividend/totalSupply;
303       emit Dividend(msg.value);
304     }
305 
306 
307     // ------------------------------------------------------------------------
308     // Owner can transfer out any accidentally sent ERC20 tokens
309     // ------------------------------------------------------------------------
310     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
311         return ERC20Interface(tokenAddress).transfer(owner, tokens);
312     }
313 }