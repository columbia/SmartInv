1 pragma solidity ^0.5.0;
2 
3 
4 // ----------------------------------------------------------------------------
5 // Safe maths
6 // ----------------------------------------------------------------------------
7 contract SafeMath {
8     function safeAdd(uint a, uint b) public pure returns (uint c) {
9         c = a + b;
10         require(c >= a);
11     }
12     function safeSub(uint a, uint b) public pure returns (uint c) {
13         require(b <= a);
14         c = a - b;
15     }
16     function safeMul(uint a, uint b) public pure returns (uint c) {
17         c = a * b;
18         require(a == 0 || c / a == b);
19     }
20     function safeDiv(uint a, uint b) public pure returns (uint c) {
21         require(b > 0);
22         c = a / b;
23     }
24 }
25 
26 
27 // ----------------------------------------------------------------------------
28 // ERC Token Standard #20 Interface
29 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
30 // ----------------------------------------------------------------------------
31 contract ERC20Interface {
32     function totalSupply() public view returns (uint);
33     function balanceOf(address tokenOwner) public view returns (uint balance);
34     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
35     function transfer(address to, uint tokens) public returns (bool success);
36     function approve(address spender, uint tokens) public returns (bool success);
37     function transferFrom(address from, address to, uint tokens) public returns (bool success);
38 
39     event Transfer(address indexed from, address indexed to, uint tokens);
40     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
41 }
42 
43 
44 // ----------------------------------------------------------------------------
45 // Contract function to receive approval and execute function in one call
46 //
47 // Borrowed from MiniMeToken
48 // ----------------------------------------------------------------------------
49 contract ApproveAndCallFallBack {
50     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
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
77         
78         emit OwnershipTransferred(owner, newOwner);
79         
80         owner = newOwner;
81         newOwner = address(0);
82     }
83 }
84 
85 /**
86  * @title Roles
87  * @dev Library for managing addresses assigned to a Role.
88  */
89 library Roles {
90     struct Role {
91         mapping (address => bool) bearer;
92     }
93 
94     /**
95      * @dev give an account access to this role
96      */
97     function add(Role storage role, address account) internal {
98         require(account != address(0), "");
99         require(!has(role, account), "");
100 
101         role.bearer[account] = true;
102     }
103 
104     /**
105      * @dev remove an account's access to this role
106      */
107     function remove(Role storage role, address account) internal {
108         require(account != address(0), "");
109         require(has(role, account), "");
110 
111         role.bearer[account] = false;
112     }
113 
114     /**
115      * @dev check if an account has this role
116      * @return bool
117      */
118     function has(Role storage role, address account) internal view returns (bool) {
119         require(account != address(0), "");
120         return role.bearer[account];
121     }
122 }
123 
124 
125 contract MinterRole {
126     using Roles for Roles.Role;
127 
128     event MinterAdded(address indexed account);
129     event MinterRemoved(address indexed account);
130 
131     Roles.Role private _minters;
132 
133     constructor () internal {
134         _addMinter(msg.sender);
135     }
136 
137     modifier onlyMinter() {
138         require(isMinter(msg.sender), "");
139         _;
140     }
141 
142     function isMinter(address account) public view returns (bool) {
143         return _minters.has(account);
144     }
145 
146     function addMinter(address account) public onlyMinter {
147         _addMinter(account);
148     }
149 
150     function renounceMinter() public {
151         _removeMinter(msg.sender);
152     }
153 
154     function _addMinter(address account) internal {
155         _minters.add(account);
156         emit MinterAdded(account);
157     }
158 
159     function _removeMinter(address account) internal {
160         _minters.remove(account);
161         emit MinterRemoved(account);
162     }
163 }
164 
165 // ----------------------------------------------------------------------------
166 // ERC20 Token, with the addition of symbol, name and decimals and assisted
167 // token transfers
168 // ----------------------------------------------------------------------------
169 contract FCS is ERC20Interface, Owned, SafeMath, MinterRole {
170     string public symbol;
171     string public  name;
172     uint8 public decimals;
173     uint public _totalSupply;
174 
175     address private _owner;
176 
177     mapping(address => uint) balances;
178     mapping(address => mapping(address => uint)) allowed;
179 
180 
181     // ------------------------------------------------------------------------
182     // Constructor
183     // ------------------------------------------------------------------------
184     constructor() public {
185         symbol = "FCS";
186         name = "Five Color Stone";
187         decimals = 18;
188         _totalSupply = 2000000000000000000000000000;
189         _owner = 0xa45760889D1c27804Dc6D6B89D4095e8Eb99ab72;
190         
191         balances[_owner] = _totalSupply;
192         emit Transfer(address(0), _owner, _totalSupply);
193     }
194 
195     // ------------------------------------------------------------------------
196     // Total supply
197     // ------------------------------------------------------------------------
198     function totalSupply() public view returns (uint) {
199         return  safeSub(_totalSupply, balances[address(0)]);
200     }
201 
202     // ------------------------------------------------------------------------
203     // Get the token balance for account tokenOwner
204     // ------------------------------------------------------------------------
205     function balanceOf(address tokenOwner) public view returns (uint balance) {
206         return balances[tokenOwner];
207     }
208 
209     // ------------------------------------------------------------------------
210     // Transfer the balance from token owner's account to to account
211     // - Owner's account must have sufficient balance to transfer
212     // - 0 value transfers are allowed
213     // ------------------------------------------------------------------------
214     function transfer(address to, uint tokens) public returns (bool success) {
215         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
216         balances[to] = safeAdd(balances[to], tokens);
217         
218         emit Transfer(msg.sender, to, tokens);
219         return true;
220     }
221 
222 
223     // ------------------------------------------------------------------------
224     // Token owner can approve for spender to transferFrom(...) tokens
225     // from the token owner's account
226     //
227     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
228     // recommends that there are no checks for the approval double-spend attack
229     // as this should be implemented in user interfaces 
230     // ------------------------------------------------------------------------
231     function approve(address spender, uint tokens) public returns (bool success) {
232         allowed[msg.sender][spender] = tokens;
233        
234         emit Approval(msg.sender, spender, tokens);
235         return true;
236     }
237 
238 
239     // ------------------------------------------------------------------------
240     // Transfer tokens from the from account to the to account
241     // 
242     // The calling account must already have sufficient tokens approve(...)-d
243     // for spending from the from account and
244     // - From account must have sufficient balance to transfer
245     // - Spender must have sufficient allowance to transfer
246     // - 0 value transfers are allowed
247     // ------------------------------------------------------------------------
248     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
249         balances[from] = safeSub(balances[from], tokens);
250         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
251         balances[to] = safeAdd(balances[to], tokens);
252         
253         emit Transfer(from, to, tokens);
254         return true;
255     }
256 
257     // ------------------------------------------------------------------------
258     // Returns the amount of tokens approved by the owner that can be
259     // transferred to the spender's account
260     // ------------------------------------------------------------------------
261     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
262         return allowed[tokenOwner][spender];
263     }
264 
265 
266     // ------------------------------------------------------------------------
267     // Token owner can approve for spender to transferFrom(...) tokens
268     // from the token owner's account. The spender contract function
269     // receiveApproval(...) is then executed
270     // ------------------------------------------------------------------------
271     // function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
272     //     allowed[msg.sender][spender] = tokens;
273         
274     //     emit Approval(msg.sender, spender, tokens);
275     //     ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
276     //     return true;
277     // }
278 
279 
280     // ------------------------------------------------------------------------
281     // Owner can transfer out any accidentally sent ERC20 tokens
282     // ------------------------------------------------------------------------
283     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
284         return ERC20Interface(tokenAddress).transfer(owner, tokens);
285     }
286 
287     /**
288      * @dev Burns a specific amount of tokens.
289      * @param value The amount of token to be burned.
290      */
291     function burn(uint256 value) public {
292         _burn(msg.sender, value);
293     }
294 
295     /**
296      * @dev Burns a specific amount of tokens from the target address and decrements allowance
297      * @param from address The address which you want to send tokens from
298      * @param value uint256 The amount of token to be burned
299      */
300     function burnFrom(address from, uint256 value) public {
301         _burnFrom(from, value);
302     }
303 
304     /**
305      * @dev Burns a specific amount of tokens from the owner
306      * @param value uint256 The amount of token to be burned
307      */
308     function burnOwner(uint256 value) public onlyOwner {
309 
310         require(msg.sender != address(0), "");
311 
312         _totalSupply = safeSub(_totalSupply, value);
313         balances[_owner] = safeSub(balances[_owner], value);
314 
315         emit Transfer(_owner, address(0), value);
316     }
317 
318     /**
319      * @dev Function to mint tokens
320      * @param account The address that will receive the minted tokens.
321      * @param value The amount of tokens to mint.
322      * @return A boolean that indicates if the operation was successful.
323      */
324     function mint(address account, uint256 value) public onlyMinter returns (bool) {
325         
326         require(account != address(0), "");
327         require(account != _owner, "");
328 
329         // _totalSupply = safeAdd(_totalSupply, value);
330 
331         balances[account] = safeAdd(balances[account], value);
332         balances[_owner] = safeSub(balances[_owner], value);
333         emit Transfer(_owner, account, value);
334 
335         return true;
336     }
337 
338     /**
339      * @dev Function to mint tokens
340      * @param value The amount of tokens to mint.
341      * @return A boolean that indicates if the operation was successful.
342      */
343     function mintOwner(uint256 value) public onlyMinter returns (bool) {
344         
345         require(msg.sender != address(0), "");
346         require(msg.sender == _owner, "");
347 
348         _totalSupply = safeAdd(_totalSupply, value);
349 
350         balances[_owner] = safeAdd(balances[_owner], value);
351         emit Transfer(address(0), _owner, value);
352 
353         return true;
354     }
355 
356     /**
357      * @dev Internal function that burns an amount of the token of a given
358      * account.
359      * @param account The account whose tokens will be burnt.
360      * @param value The amount that will be burnt.
361      */
362     function _burn(address account, uint256 value) internal {
363         require(account != address(0), "");
364         require(account != _owner, "");
365 
366         balances[account] = safeSub(balances[account], value);
367         balances[_owner] = safeAdd(balances[_owner], value);
368         emit Transfer(account, _owner, value);
369     }
370 
371     /**
372      * @dev Internal function that burns an amount of the token of a given
373      * account, deducting from the sender's allowance for said account. Uses the
374      * internal burn function.
375      * Emits an Approval event (reflecting the reduced allowance).
376      * @param account The account whose tokens will be burnt.
377      * @param value The amount that will be burnt.
378      */
379     function _burnFrom(address account, uint256 value) internal {
380         allowed[account][msg.sender] = safeSub(allowed[account][msg.sender], value);
381         _burn(account, value);
382         emit Approval(account, msg.sender, allowed[account][msg.sender]);
383     }
384 }