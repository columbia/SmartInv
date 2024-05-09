1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'AGRI' - AgriChain Utility Token Contract
5 //
6 // Symbol           : AGRI
7 // Name             : AgriChain Utility Token
8 // Max Total supply : 1,000,000,000.000000000000000000 (1 billion)
9 // Decimals         : 18
10 //
11 // Company          : AgriChain Pty Ltd 
12 //                  : https://agrichain.com
13 // Version          : 2.0
14 // Author           : Martin Halford <cto@agrichain.com>
15 // Published        : 13 Aug 2018
16 //
17 // ----------------------------------------------------------------------------
18 
19 
20 // ----------------------------------------------------------------------------
21 // Safe maths
22 // ----------------------------------------------------------------------------
23 library SafeMath {
24     uint256 constant public MAX_UINT256 =
25     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
26 
27     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
28         if (x > MAX_UINT256 - y) revert();
29         return x + y;
30     }
31 
32     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
33         if (x < y) revert();
34         return x - y;
35     }
36 
37     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
38         if (y == 0) return 0;
39         if (x > MAX_UINT256 / y) revert();
40         return x * y;
41     }
42 }
43 
44 
45 // ----------------------------------------------------------------------------
46 // ERC Token Standard #20 Interface
47 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
48 // ----------------------------------------------------------------------------
49 contract ERC20Interface {
50     function totalSupply() public view returns (uint);
51     function balanceOf(address tokenOwner) public view returns (uint balance);
52     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
53     function transfer(address to, uint tokens) public returns (bool success);
54     function approve(address spender, uint tokens) public returns (bool success);
55     function transferFrom(address from, address to, uint tokens) public returns (bool success);
56 
57     event Transfer(address indexed from, address indexed to, uint tokens);
58     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
59 }
60 
61 // ----------------------------------------------------------------------------
62 // Contract function to receive approval and execute function in one call
63 // ----------------------------------------------------------------------------
64 contract ApproveAndCallFallBack {
65     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
66 }
67 
68 
69 // ----------------------------------------------------------------------------
70 // Owned contract
71 // ----------------------------------------------------------------------------
72 contract Owned {
73 
74     address public owner;
75     address public newOwner;
76 
77     event OwnershipTransferred(address indexed _from, address indexed _to);
78 
79     constructor() public {
80         owner = msg.sender;
81     }
82 
83     modifier onlyOwner {
84         require(msg.sender == owner);
85         _;
86     }
87 
88     function transferOwnership(address _newOwner) public onlyOwner {
89         newOwner = _newOwner;
90     }
91     function acceptOwnership() public {
92         require(msg.sender == newOwner);
93         emit OwnershipTransferred(owner, newOwner);
94         owner = newOwner;
95         newOwner = address(0);
96     }
97 }
98 
99 // ----------------------------------------------------------------------------
100 // Agri Token
101 // ----------------------------------------------------------------------------
102 contract AgriToken is ERC20Interface, Owned {
103     using SafeMath for uint;
104 
105     uint256 constant public MAX_SUPPLY = 1000000000000000000000000000; // 1 billion Agri 
106 
107     string public symbol;
108     string public  name;
109     uint8 public decimals;
110     uint256 _totalSupply;
111 
112     mapping(address => uint) balances;
113     mapping(address => mapping(address => uint)) allowed;
114 
115     // Flag to allow or disallow transfers
116     bool public isAllowingTransfers;
117 
118     // List of admins who can mint, burn and allow transfers of tokens
119     mapping (address => bool) public administrators;
120 
121     // modifier to check if transfers being allowed
122     modifier allowingTransfers() {
123         require(isAllowingTransfers);
124         _;
125     }
126 
127     // modifier to check admin status
128     modifier onlyAdmin() {
129         require(administrators[msg.sender]);
130         _;
131     }
132 
133     // This notifies clients about the amount burnt , only owner is able to burn tokens
134     event Burn(address indexed burner, uint256 value); 
135 
136     // This notifies clients about the transfers being allowed or disallowed
137     event AllowTransfers ();
138     event DisallowTransfers ();
139 
140     // ------------------------------------------------------------------------
141     // Constructor
142     // ------------------------------------------------------------------------
143     constructor(uint initialTokenSupply) public {
144         symbol = "AGRI";
145         name = "AgriChain";
146         decimals = 18;
147         _totalSupply = initialTokenSupply * 10**uint(decimals);
148 
149         balances[owner] = _totalSupply;
150         emit Transfer(address(0), owner, _totalSupply);
151     }
152 
153     // ------------------------------------------------------------------------
154     // Total supply
155     // ------------------------------------------------------------------------
156     function totalSupply() public view returns (uint) {
157         return _totalSupply.sub(balances[address(0)]);
158     }
159 
160     // ------------------------------------------------------------------------
161     // Get the token balance for account `tokenOwner`
162     // ------------------------------------------------------------------------
163     function balanceOf(address tokenOwner) public view returns (uint balance) {
164         return balances[tokenOwner];
165     }
166 
167     // ------------------------------------------------------------------------
168     // Transfer the balance from token owner's account to `to` account
169     // - Owner's account must have sufficient balance to transfer
170     // - 0 value transfers are allowed
171     // ------------------------------------------------------------------------
172     function transfer(address to, uint tokens) public allowingTransfers returns (bool success) {
173         balances[msg.sender] = balances[msg.sender].sub(tokens);
174         balances[to] = balances[to].add(tokens);
175         emit Transfer(msg.sender, to, tokens);
176         return true;
177     }
178 
179     // ------------------------------------------------------------------------
180     // Token owner can approve for `spender` to transferFrom(...) `tokens`
181     // from the token owner's account
182     //
183     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
184     // recommends that there are no checks for the approval double-spend attack
185     // as this should be implemented in user interfaces 
186     // ------------------------------------------------------------------------
187     function approve(address spender, uint tokens) public returns (bool success) {
188         allowed[msg.sender][spender] = tokens;
189         emit Approval(msg.sender, spender, tokens);
190         return true;
191     }
192 
193     // ------------------------------------------------------------------------
194     // Transfer `tokens` from the `from` account to the `to` account
195     // 
196     // The calling account must already have sufficient tokens approve(...)-d
197     // for spending from the `from` account and
198     // - From account must have sufficient balance to transfer
199     // - Spender must have sufficient allowance to transfer
200     // - 0 value transfers are allowed
201     // ------------------------------------------------------------------------
202     function transferFrom(address from, address to, uint tokens) public allowingTransfers returns (bool success) {
203         balances[from] = balances[from].sub(tokens);
204         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
205         balances[to] = balances[to].add(tokens);
206         emit Transfer(from, to, tokens);
207         return true;
208     }
209 
210     // ------------------------------------------------------------------------
211     // Returns the amount of tokens approved by the owner that can be
212     // transferred to the spender's account
213     // ------------------------------------------------------------------------
214     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
215         return allowed[tokenOwner][spender];
216     }
217 
218     // ------------------------------------------------------------------------
219     // Token owner can approve for `spender` to transferFrom(...) `tokens`
220     // from the token owner's account. The `spender` contract function
221     // `receiveApproval(...)` is then executed
222     // ------------------------------------------------------------------------
223     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
224         allowed[msg.sender][spender] = tokens;
225         emit Approval(msg.sender, spender, tokens);
226         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
227         return true;
228     }
229 
230 
231     // ------------------------------------------------------------------------
232     // Don't accept ETH
233     // ------------------------------------------------------------------------
234     function () public payable {
235         revert();
236     }
237 
238 
239     // ------------------------------------------------------------------------
240     // Owner can transfer out any accidentally sent ERC20 tokens
241     // ------------------------------------------------------------------------
242     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyAdmin returns (bool success) {
243         return ERC20Interface(tokenAddress).transfer(owner, tokens);
244     }
245 
246     // ------------------------------------------------------------------------
247     // Administrator can mint additional tokens 
248     // Do ** NOT ** let totalSupply exceed MAX_SUPPLY
249     // ------------------------------------------------------------------------
250     function mintTokens(uint256 _value) public onlyAdmin {
251         require(_totalSupply.add(_value) <= MAX_SUPPLY);
252         balances[msg.sender] = balances[msg.sender].add(_value);
253         _totalSupply = _totalSupply.add(_value);
254         emit Transfer(0, msg.sender, _value);      
255     }    
256 
257     // ------------------------------------------------------------------------
258     // Administrator can burn tokens
259     // ------------------------------------------------------------------------
260     function burn(uint256 _value) public onlyAdmin {
261         require(_value <= balances[msg.sender]);
262         address burner = msg.sender;
263         balances[burner] = balances[burner].sub(_value);
264         _totalSupply = _totalSupply.sub(_value);
265         emit Burn(burner, _value);
266     }
267 
268     // ------------------------------------------------------------------------
269     // Administrator can allow transfer of tokens
270     // ------------------------------------------------------------------------
271     function allowTransfers() public onlyAdmin {
272         isAllowingTransfers = true;
273         emit AllowTransfers();
274     }
275 
276     // ------------------------------------------------------------------------
277     // Administrator can disallow transfer of tokens
278     // ------------------------------------------------------------------------
279     function disallowTransfers() public onlyAdmin {
280         isAllowingTransfers = false;
281         emit DisallowTransfers();
282     }
283 
284     // ------------------------------------------------------------------------
285     // Owner can add administrators of tokens
286     // ------------------------------------------------------------------------
287     function addAdministrator(address _admin) public onlyOwner {
288         administrators[_admin] = true;
289     }
290 
291     // ------------------------------------------------------------------------
292     // Owner can remove administrators of tokens
293     // ------------------------------------------------------------------------
294     function removeAdministrator(address _admin) public onlyOwner {
295         administrators[_admin] = false;
296     }
297 
298 }