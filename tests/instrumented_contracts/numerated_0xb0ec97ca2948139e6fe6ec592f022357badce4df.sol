1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41 
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   function Ownable() {
51     owner = msg.sender;
52   }
53 
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) onlyOwner public {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 
74 }
75 
76 // ----------------------------------------------------------------------------
77 // 'Cosmic Experience Points' token contract
78 //
79 // CXP tokens are mintable by the owner until the `disableMinting()` function
80 // is executed. Tokens can be burnt by sending them to address 0x0
81 //
82 // Deployed to : 
83 // Symbol      : CXP
84 // Name        : Cosmic Experience Points
85 // Total supply: mintable
86 // Decimals    : 0
87 //
88 // Taken from BitFwd
89 // (c) BitFwd was created by BokkyPooBah / Bok Consulting Pty Ltd for BitFwd 2017. The MIT Licence.
90 // ----------------------------------------------------------------------------
91 
92 
93 // ----------------------------------------------------------------------------
94 // ERC Token Standard #20 Interface
95 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
96 // ----------------------------------------------------------------------------
97 contract ERC20Interface {
98     function totalSupply() public constant returns (uint);
99     function balanceOf(address tokenOwner) public constant returns (uint balance);
100     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
101     function transfer(address to, uint tokens) public returns (bool success);
102     function approve(address spender, uint tokens) public returns (bool success);
103     function transferFrom(address from, address to, uint tokens) public returns (bool success);
104 
105     event Transfer(address indexed from, address indexed to, uint tokens);
106     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
107 }
108 
109 
110 // ----------------------------------------------------------------------------
111 // Contract function to receive approval and execute function in one call
112 //
113 // Borrowed from MiniMeToken
114 // ----------------------------------------------------------------------------
115 contract ApproveAndCallFallBack {
116     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
117 }
118 
119 // ----------------------------------------------------------------------------
120 // ERC20 Token, with the addition of symbol, name and decimals and assisted
121 // token transfers
122 // ----------------------------------------------------------------------------
123 contract CosmicExperiencePoints is ERC20Interface, Ownable {
124     using SafeMath for uint;
125 
126     string public symbol;
127     string public  name;
128     uint8 public decimals;
129     uint public _totalSupply;
130     bool public mintable;
131 
132     mapping(address => uint) balances;
133     mapping(address => mapping(address => uint)) allowed;
134 
135     event MintingDisabled();
136 
137 
138     // ------------------------------------------------------------------------
139     // Constructor
140     // ------------------------------------------------------------------------
141     function CosmicExperiencePoints() public {
142         symbol = "CXP";
143         name = "Cosmic Experience Points";
144         decimals = 0;
145         mintable = true;
146     }
147 
148 
149     // ------------------------------------------------------------------------
150     // Total supply
151     // ------------------------------------------------------------------------
152     function totalSupply() public constant returns (uint) {
153         return _totalSupply - balances[address(0)];
154     }
155 
156 
157     // ------------------------------------------------------------------------
158     // Disable minting
159     // ------------------------------------------------------------------------
160     function disableMinting() public onlyOwner {
161         require(mintable);
162         mintable = false;
163         MintingDisabled();
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
244     // Mint tokens
245     // ------------------------------------------------------------------------
246     function mint(address tokenOwner, uint tokens) public onlyOwner returns (bool success) {
247         require(mintable);
248         balances[tokenOwner] = balances[tokenOwner].add(tokens);
249         _totalSupply = _totalSupply.add(tokens);
250         Transfer(address(0), tokenOwner, tokens);
251         return true;
252     }
253 
254 
255     // ------------------------------------------------------------------------
256     // Don't accept ethers
257     // ------------------------------------------------------------------------
258     function () public payable {
259         revert();
260     }
261 
262 
263     // ------------------------------------------------------------------------
264     // Owner can transfer out any accidentally sent ERC20 tokens
265     // ------------------------------------------------------------------------
266     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
267         return ERC20Interface(tokenAddress).transfer(owner, tokens);
268     }
269 }