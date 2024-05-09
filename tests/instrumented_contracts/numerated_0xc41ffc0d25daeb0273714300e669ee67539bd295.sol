1 /**
2  *Submitted for verification at Etherscan.io on 2020-05-26
3 */
4 
5 pragma solidity ^0.5.0;
6 
7 // ----------------------------------------------------------------------------
8 //
9 // Symbol      : AVF
10 // Name        : Adult Video Fans Vip
11 // Total supply: 6000,000,000.00000000
12 // Decimals    : 8
13 //
14 // Borrowed and Edited from
15 //
16 // (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
17 // ----------------------------------------------------------------------------
18 
19 
20 // ----------------------------------------------------------------------------
21 // Safe maths
22 // ----------------------------------------------------------------------------
23 library SafeMath {
24     function add(uint a, uint b) internal pure returns (uint c) {
25         c = a + b;
26         require(c >= a);
27     }
28     function sub(uint a, uint b) internal pure returns (uint c) {
29         require(b <= a);
30         c = a - b;
31     }
32     function mul(uint a, uint b) internal pure returns (uint c) {
33         c = a * b;
34         require(a == 0 || c / a == b);
35     }
36     function div(uint a, uint b) internal pure returns (uint c) {
37         require(b > 0);
38         c = a / b;
39     }
40 }
41 
42 
43 // ----------------------------------------------------------------------------
44 // ERC Token Standard #20 Interface
45 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
46 // ----------------------------------------------------------------------------
47 contract ERC20Interface {
48     function totalSupply() public view returns (uint);
49     function balanceOf(address tokenOwner) public view returns (uint balance);
50     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
51     function transfer(address to, uint tokens) public returns (bool success);
52     function approve(address spender, uint tokens) public returns (bool success);
53     function transferFrom(address from, address to, uint tokens) public returns (bool success);
54 
55     event Transfer(address indexed from, address indexed to, uint tokens);
56     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
57     event Burn(address indexed tokenOwner, uint tokens);
58     event FrozenFunds(address indexed target, bool freeze);
59 }
60 
61 
62 // ----------------------------------------------------------------------------
63 // Contract function to receive approval and execute function in one call
64 //
65 // Borrowed from MiniMeToken
66 // ----------------------------------------------------------------------------
67 contract ApproveAndCallFallBack {
68     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
69 }
70 
71 
72 // ----------------------------------------------------------------------------
73 // Owned contract
74 // ----------------------------------------------------------------------------
75 contract Owned {
76     address public owner;
77     address public newOwner;
78 
79     event OwnershipTransferred(address indexed _from, address indexed _to);
80 
81     constructor() public {
82         owner = msg.sender;
83     }
84 
85     modifier onlyOwner {
86         require(msg.sender == owner);
87         _;
88     }
89 
90     function transferOwnership(address _newOwner) public onlyOwner {
91         newOwner = _newOwner;
92     }
93     function acceptOwnership() public {
94         require(msg.sender == newOwner);
95         emit OwnershipTransferred(owner, newOwner);
96         owner = newOwner;
97         newOwner = address(0);
98     }
99 }
100 
101 
102 // ----------------------------------------------------------------------------
103 // ERC20 Token, with the addition of symbol, name and decimals and a
104 // 
105 // ----------------------------------------------------------------------------
106 contract AVF is ERC20Interface, Owned {
107     using SafeMath for uint;
108 
109     string public symbol;
110     string public  name;
111     uint8 public decimals;
112     uint _totalSupply;
113 
114     mapping(address => uint) balances;
115     mapping(address => mapping(address => uint)) allowed;
116     mapping(address => bool) public frozenAccount;
117  
118  
119     // ------------------------------------------------------------------------
120     // Constructor
121     // ------------------------------------------------------------------------
122     constructor() public {
123         symbol = "AVF";
124         name = "Adult Video Fans Vip";
125         decimals = 8;
126         _totalSupply = 6000000000 * 10**uint(decimals);
127         balances[owner] = _totalSupply;
128         emit Transfer(address(0), owner, _totalSupply);
129     }
130 
131 
132     // ------------------------------------------------------------------------
133     // Total supply
134     // ------------------------------------------------------------------------
135     function totalSupply() public view returns (uint) {
136         return _totalSupply.sub(balances[address(0)]);
137     }
138 
139 
140     // ------------------------------------------------------------------------
141     // Get the token balance for account `tokenOwner`
142     // ------------------------------------------------------------------------
143     function balanceOf(address tokenOwner) public view returns (uint balance) {
144         return balances[tokenOwner];
145     }
146 
147 
148     // ------------------------------------------------------------------------
149     // Transfer the balance from token owner's account to `to` account
150     // - Owner's account must have sufficient balance to transfer
151     // - 0 value transfers are allowed
152     // ------------------------------------------------------------------------
153     function transfer(address to, uint tokens) public returns (bool success) {
154         require(!frozenAccount[msg.sender]);
155         require(!frozenAccount[to]);
156         balances[msg.sender] = balances[msg.sender].sub(tokens);
157         balances[to] = balances[to].add(tokens);
158         emit Transfer(msg.sender, to, tokens);
159         return true;
160     }
161 
162 
163     // ------------------------------------------------------------------------
164     // Token owner can approve for `spender` to transferFrom(...) `tokens`
165     // from the token owner's account
166     //
167     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
168     // recommends that there are no checks for the approval double-spend attack
169     // as this should be implemented in user interfaces
170     // ------------------------------------------------------------------------
171     function approve(address spender, uint tokens) public returns (bool success) {
172         allowed[msg.sender][spender] = tokens;
173         emit Approval(msg.sender, spender, tokens);
174         return true;
175     }
176 
177 
178     // ------------------------------------------------------------------------
179     // Transfer `tokens` from the `from` account to the `to` account
180     //
181     // The calling account must already have sufficient tokens approve(...)-d
182     // for spending from the `from` account and
183     // - From account must have sufficient balance to transfer
184     // - Spender must have sufficient allowance to transfer
185     // - 0 value transfers are allowed
186     // ------------------------------------------------------------------------
187     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
188         require(!frozenAccount[from]);
189         require(!frozenAccount[to]);
190         require(!frozenAccount[msg.sender]);
191         balances[from] = balances[from].sub(tokens);
192         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
193         balances[to] = balances[to].add(tokens);
194         emit Transfer(from, to, tokens);
195         return true;
196     }
197 
198 
199     // ------------------------------------------------------------------------
200     // Returns the amount of tokens approved by the owner that can be
201     // transferred to the spender's account
202     // ------------------------------------------------------------------------
203     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
204         return allowed[tokenOwner][spender];
205     }
206 
207 
208     // ------------------------------------------------------------------------
209     // Token owner can approve for `spender` to transferFrom(...) `tokens`
210     // from the token owner's account. The `spender` contract function
211     // `receiveApproval(...)` is then executed
212     // ------------------------------------------------------------------------
213     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
214         allowed[msg.sender][spender] = tokens;
215         emit Approval(msg.sender, spender, tokens);
216         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
217         return true;
218     }
219 
220 
221     // ------------------------------------------------------------------------
222     // Don't accept ETH
223     // ------------------------------------------------------------------------
224     function () external payable {
225         revert();
226     }
227 
228     // ------------------------------------------------------------------------
229     // Owner can transfer out any accidentally sent ERC20 tokens
230     // ------------------------------------------------------------------------
231     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
232         return ERC20Interface(tokenAddress).transfer(owner, tokens);
233     }
234     
235     // ------------------------------------------------------------------------
236     // Burn
237     // ------------------------------------------------------------------------
238     function burn(uint value)public returns(bool success){
239         require(balances[msg.sender]>=value);
240     
241         balances[msg.sender]=balances[msg.sender].sub(value);
242         _totalSupply=_totalSupply.sub(value);
243         emit Burn(msg.sender,value);
244         return true;
245         
246     }
247     
248 
249     function burnFrom(address from, uint value)public returns(bool success){
250         require(balances[from]>=value);
251         require(allowed[from][msg.sender] >= value);
252         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
253         balances[from]=balances[from].sub(value);
254         _totalSupply=_totalSupply.sub(value);
255         emit Burn(from,value);
256         return true;
257         
258     }
259     
260     // ------------------------------------------------------------------------
261     // Freeze
262     // ------------------------------------------------------------------------
263     function freezeAccount(address target, bool freeze) onlyOwner public{
264         frozenAccount[target] = freeze;
265         emit FrozenFunds(target, freeze);
266     }
267 
268 }