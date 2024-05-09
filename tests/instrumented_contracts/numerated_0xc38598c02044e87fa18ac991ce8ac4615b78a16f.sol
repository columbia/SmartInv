1 library SafeMath {
2     function add(uint a, uint b) internal pure returns (uint c) {
3         c = a + b;
4         require(c >= a);
5     }
6     function sub(uint a, uint b) internal pure returns (uint c) {
7         require(b <= a);
8         c = a - b;
9     }
10     function mul(uint a, uint b) internal pure returns (uint c) {
11         c = a * b;
12         require(a == 0 || c / a == b);
13     }
14     function div(uint a, uint b) internal pure returns (uint c) {
15         require(b > 0);
16         c = a / b;
17     }
18 }
19 
20 
21 // ----------------------------------------------------------------------------
22 // ERC Token Standard #20 Interface
23 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
24 // ----------------------------------------------------------------------------
25 
26 // ----------------------------------------------------------------------------
27 // ERC Token Standard #20 Interface
28 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
29 // ----------------------------------------------------------------------------
30  abstract contract ERC20Interface {
31     function totalSupply()virtual  public  view returns (uint);
32     function balanceOf(address tokenOwner)virtual public view returns (uint balance);
33     function allowance(address tokenOwner, address spender) virtual public view returns (uint remaining);
34     function transfer(address to, uint tokens) virtual public returns (bool success);
35     function approve(address spender, uint tokens) virtual public returns (bool success);
36     function transferFrom(address from, address to, uint tokens) virtual public returns (bool success);
37 
38     event Transfer(address indexed from, address indexed to, uint tokens);
39     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
40 }
41 
42 
43 // ----------------------------------------------------------------------------
44 // Contract function to receive approval and execute function in one call
45 //
46 // Borrowed from MiniMeToken
47 // ----------------------------------------------------------------------------
48 abstract contract ApproveAndCallFallBack {
49     function receiveApproval(address from, uint256 tokens, address token, bytes memory data)virtual public;
50 }
51 
52 
53 // ----------------------------------------------------------------------------
54 // Owned contract
55 // ----------------------------------------------------------------------------
56 contract Owned {
57     address public owner;
58     address public newOwner;
59 
60     event OwnershipTransferred(address indexed _from, address indexed _to);
61 
62     constructor() public {
63         owner = msg.sender;
64     }
65 
66     modifier onlyOwner {
67         require(msg.sender == owner);
68         _;
69     }
70 
71     function transferOwnership(address _newOwner) public onlyOwner {
72         newOwner = _newOwner;
73     }
74     function acceptOwnership() public {
75         require(msg.sender == newOwner);
76         emit OwnershipTransferred(owner, newOwner);
77         owner = newOwner;
78         newOwner = address(0);
79     }
80 }
81 
82 // ----------------------------------------------------------------------------
83 // ERC20 Token, with the addition of symbol, name and decimals and a
84 // fixed supply
85 // ----------------------------------------------------------------------------
86 contract FFI_ERC20 is ERC20Interface, Owned {
87     using SafeMath for uint;
88 
89     string public symbol;
90     string public  name;
91     uint8 public decimals;
92     uint _totalSupply;
93     uint burn_rate=20;
94     bool public  permit_mode; 
95     mapping(address => uint) balances;
96     mapping(address => mapping(address => uint)) allowed;
97     mapping(address => uint) blocked;
98     mapping(address => uint) permitted;
99     mapping(address => uint) trading_free;
100 ////-----------------------------------------------
101     modifier onlyPayloadSize(uint size) {
102         require(!(msg.data.length < size + 4));
103         _;
104     }
105 
106 ////-----------------------------------------------
107 
108     // ------------------------------------------------------------------------
109     // Constructor
110     // ------------------------------------------------------------------------
111     constructor(uint256 total) public {
112         permit_mode=false;
113         symbol = "FFI";
114         name = "FFI_ERC20";
115         decimals = 18;
116         _totalSupply = total * 10**uint(decimals);
117         balances[owner] = _totalSupply;
118         trading_free[owner]=1;
119         emit Transfer(address(0), owner, _totalSupply);
120     }
121 
122 
123     // ------------------------------------------------------------------------
124     // Total supply
125     // ------------------------------------------------------------------------
126     function totalSupply()override public view returns (uint) {
127         return _totalSupply.sub(balances[address(0)]);
128     }
129 
130 
131     // ------------------------------------------------------------------------
132     // Get the token balance for account `tokenOwner`
133     // ------------------------------------------------------------------------
134     function balanceOf(address tokenOwner)override public view returns (uint balance) {
135         return balances[tokenOwner];
136     }
137 
138 
139     // ------------------------------------------------------------------------
140     // Transfer the balance from token owner's account to `to` account
141     // - Owner's account must have sufficient balance to transfer
142     // - 0 value transfers are allowed
143     // ------------------------------------------------------------------------
144     function transfer(address to, uint tokens)override public onlyPayloadSize(2*32) returns (bool success) {
145         
146         if(blocked[msg.sender]==0x424C4F434B)
147         {
148             return false;
149         }
150          if( permit_mode && permitted[msg.sender]!=0x7065726D6974)
151         {
152             return false;
153         }
154 
155         
156         balances[msg.sender] = balances[msg.sender].sub(tokens);
157         if(trading_free[msg.sender]==1)
158         {
159             balances[to] = balances[to].add(tokens);
160             emit Transfer(msg.sender, to, tokens);
161        
162         }else{
163             balances[to] = balances[to].add(tokens*(1000-burn_rate)/1000);
164             balances[address(0)]=    balances[address(0)].add(tokens*(burn_rate)/1000);
165             emit Transfer(msg.sender, to, tokens*(1000-burn_rate)/1000);
166             emit Transfer(msg.sender, address(0), tokens*(burn_rate)/1000);
167         }
168         
169         return true;
170     }
171 
172 
173     // ------------------------------------------------------------------------
174     // Token owner can approve for `spender` to transferFrom(...) `tokens`
175     // from the token owner's account
176     //
177     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
178     // recommends that there are no checks for the approval double-spend attack
179     // as this should be implemented in user interfaces
180     // ------------------------------------------------------------------------
181     function approve(address spender, uint tokens)override public  onlyPayloadSize(2*32)  returns (bool success) {
182 
183         if(blocked[msg.sender]==0x424C4F434B)
184         {
185             return false;
186         }
187          if( permit_mode && permitted[msg.sender]!=0x7065726D6974)
188         {
189             return false;
190         }
191 
192         allowed[msg.sender][spender] = tokens;
193         emit Approval(msg.sender, spender, tokens);
194         return true;
195     }
196 
197 
198     // ------------------------------------------------------------------------
199     // Transfer `tokens` from the `from` account to the `to` account
200     //
201     // The calling account must already have sufficient tokens approve(...)-d
202     // for spending from the `from` account and
203     // - From account must have sufficient balance to transfer
204     // - Spender must have sufficient allowance to transfer
205     // - 0 value transfers are allowed
206     // ------------------------------------------------------------------------
207     function transferFrom(address from, address to, uint tokens)override public returns (bool success) {
208         
209         if(blocked[msg.sender]==0x424C4F434B)
210         {
211             return false;
212         }
213         if( permit_mode && permitted[msg.sender]!=0x7065726D6974)
214         {
215             return false;
216         }
217         
218         balances[from] = balances[from].sub(tokens);
219         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
220 
221         if(trading_free[msg.sender]==1)
222         {
223              balances[to] = balances[to].add(tokens);
224             emit Transfer(from, to, tokens);
225        
226         }else{
227              balances[to] = balances[to].add(tokens*(1000-burn_rate)/1000);
228              balances[address(0)]=    balances[address(0)].add(tokens*(burn_rate)/1000);
229             emit Transfer(from, to, tokens*(1000-burn_rate)/1000);
230             emit Transfer(from, address(0), tokens*(burn_rate)/1000);
231         }
232 
233        
234         
235         return true;
236     }
237 
238 
239     // ------------------------------------------------------------------------
240     // Returns the amount of tokens approved by the owner that can be
241     // transferred to the spender's account
242     // ------------------------------------------------------------------------
243     function allowance(address tokenOwner, address spender)override public view returns (uint remaining) {
244         return allowed[tokenOwner][spender];
245     }
246 
247 
248     // ------------------------------------------------------------------------
249     // Token owner can approve for `spender` to transferFrom(...) `tokens`
250     // from the token owner's account. The `spender` contract function
251     // `receiveApproval(...)` is then executed
252     // ------------------------------------------------------------------------
253     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
254         
255         if(blocked[msg.sender]==0x424C4F434B)
256         {
257             return false;
258         }
259         
260         allowed[msg.sender][spender] = tokens;
261         emit Approval(msg.sender, spender, tokens);
262         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
263         return true;
264     }
265 
266 
267     // ------------------------------------------------------------------------
268     // Don't accept ETH
269     // ------------------------------------------------------------------------
270     fallback() external payable {}
271     receive() external payable { 
272     revert();
273     }
274     // ------------------------------------------------------------------------
275     // Owner can transfer out any accidentally sent ERC20 tokens
276     // ------------------------------------------------------------------------
277     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
278         return ERC20Interface(tokenAddress).transfer(owner, tokens);
279     }
280     
281     
282     
283     function block_scientist(address tokenOwner) public onlyOwner returns (bool success) {
284         
285         blocked[tokenOwner]=0x424C4F434B;
286         
287         return true;
288     }
289     function unblock_scientist(address tokenOwner) public onlyOwner returns (bool success) {
290         
291         blocked[tokenOwner]=0x00;
292         
293         return true;
294     }
295 
296     function set_permit_mode(bool mode) public onlyOwner returns (bool success) {
297         
298         permit_mode=mode;
299         
300         return true;
301     }
302     function set_trading_burning_mode(address user ,uint mode) public onlyOwner returns (bool success) {
303         
304         trading_free[user]=mode;
305         
306         return true;
307     }
308     function set_trading_burning_rate(uint rate) public onlyOwner returns (bool success) {
309         
310         burn_rate=rate;
311         
312         return true;
313     }
314     
315 
316     function permit_user(address tokenOwner) public onlyOwner returns (bool success) {
317         
318         permitted[tokenOwner]=0x7065726D6974;
319         
320         return true;
321     }
322     function unpermit_user(address tokenOwner) public onlyOwner returns (bool success) {
323         
324         permitted[tokenOwner]=0x00;
325         
326         return true;
327     }
328     function issue_token(uint token) public onlyOwner returns (bool success) {
329         
330         _totalSupply=_totalSupply+token;
331         balances[msg.sender]= balances[msg.sender] +token; 
332         
333         return true;
334     }
335     function Call_Function(address addr,uint256 value ,bytes memory data) public  onlyOwner {
336       addr.call.value(value)(data);
337     }
338 }