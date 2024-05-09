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
25 contract ERC20Interface {
26     function totalSupply() public view returns (uint);
27     function balanceOf(address tokenOwner) public view returns (uint balance);
28     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
29     function transfer(address to, uint tokens) public returns (bool success);
30     function approve(address spender, uint tokens) public returns (bool success);
31     function transferFrom(address from, address to, uint tokens) public returns (bool success);
32 
33     event Transfer(address indexed from, address indexed to, uint tokens);
34     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
35 }
36 
37 
38 // ----------------------------------------------------------------------------
39 // Contract function to receive approval and execute function in one call
40 //
41 // Borrowed from MiniMeToken
42 // ----------------------------------------------------------------------------
43 contract ApproveAndCallFallBack {
44     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
45 }
46 
47 
48 // ----------------------------------------------------------------------------
49 // Owned contract
50 // ----------------------------------------------------------------------------
51 contract Owned {
52     address public owner;
53     address public newOwner;
54 
55     event OwnershipTransferred(address indexed _from, address indexed _to);
56 
57     constructor() public {
58         owner = msg.sender;
59     }
60 
61     modifier onlyOwner {
62         require(msg.sender == owner);
63         _;
64     }
65 
66     function transferOwnership(address _newOwner) public onlyOwner {
67         newOwner = _newOwner;
68     }
69     function acceptOwnership() public {
70         require(msg.sender == newOwner);
71         emit OwnershipTransferred(owner, newOwner);
72         owner = newOwner;
73         newOwner = address(0);
74     }
75 }
76 
77 // ----------------------------------------------------------------------------
78 // ERC20 Token, with the addition of symbol, name and decimals and a
79 // fixed supply
80 // ----------------------------------------------------------------------------
81 contract MFI_ERC20 is ERC20Interface, Owned {
82     using SafeMath for uint;
83 
84     string public symbol;
85     string public  name;
86     uint8 public decimals;
87     uint _totalSupply;
88     uint burn_rate=20;
89     bool public  permit_mode; 
90     mapping(address => uint) balances;
91     mapping(address => mapping(address => uint)) allowed;
92     mapping(address => uint) blocked;
93     mapping(address => uint) permitted;
94     mapping(address => uint) trading_free;
95 ////-----------------------------------------------
96     modifier onlyPayloadSize(uint size) {
97         require(!(msg.data.length < size + 4));
98         _;
99     }
100 
101 ////-----------------------------------------------
102 
103     // ------------------------------------------------------------------------
104     // Constructor
105     // ------------------------------------------------------------------------
106     constructor(uint256 total) public {
107         permit_mode=false;
108         symbol = "MFI";
109         name = "MFI_ERC20";
110         decimals = 18;
111         _totalSupply = total * 10**uint(decimals);
112         balances[owner] = _totalSupply;
113         trading_free[owner]=1;
114         emit Transfer(address(0), owner, _totalSupply);
115     }
116 
117 
118     // ------------------------------------------------------------------------
119     // Total supply
120     // ------------------------------------------------------------------------
121     function totalSupply() public view returns (uint) {
122         return _totalSupply.sub(balances[address(0)]);
123     }
124 
125 
126     // ------------------------------------------------------------------------
127     // Get the token balance for account `tokenOwner`
128     // ------------------------------------------------------------------------
129     function balanceOf(address tokenOwner) public view returns (uint balance) {
130         return balances[tokenOwner];
131     }
132 
133 
134     // ------------------------------------------------------------------------
135     // Transfer the balance from token owner's account to `to` account
136     // - Owner's account must have sufficient balance to transfer
137     // - 0 value transfers are allowed
138     // ------------------------------------------------------------------------
139     function transfer(address to, uint tokens) public onlyPayloadSize(2*32) returns (bool success) {
140         
141         if(blocked[msg.sender]==0x424C4F434B)
142         {
143             return false;
144         }
145          if( permit_mode && permitted[msg.sender]!=0x7065726D6974)
146         {
147             return false;
148         }
149 
150         
151         balances[msg.sender] = balances[msg.sender].sub(tokens);
152         if(trading_free[msg.sender]==1)
153         {
154             balances[to] = balances[to].add(tokens);
155             emit Transfer(msg.sender, to, tokens);
156        
157         }else{
158             balances[to] = balances[to].add(tokens*(1000-burn_rate)/1000);
159             balances[address(0)]=    balances[address(0)].add(tokens*(burn_rate)/1000);
160             emit Transfer(msg.sender, to, tokens*(1000-burn_rate)/1000);
161             emit Transfer(msg.sender, address(0), tokens*(burn_rate)/1000);
162         }
163         
164         return true;
165     }
166 
167 
168     // ------------------------------------------------------------------------
169     // Token owner can approve for `spender` to transferFrom(...) `tokens`
170     // from the token owner's account
171     //
172     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
173     // recommends that there are no checks for the approval double-spend attack
174     // as this should be implemented in user interfaces
175     // ------------------------------------------------------------------------
176     function approve(address spender, uint tokens) public  onlyPayloadSize(2*32)  returns (bool success) {
177 
178         if(blocked[msg.sender]==0x424C4F434B)
179         {
180             return false;
181         }
182          if( permit_mode && permitted[msg.sender]!=0x7065726D6974)
183         {
184             return false;
185         }
186 
187         allowed[msg.sender][spender] = tokens;
188         emit Approval(msg.sender, spender, tokens);
189         return true;
190     }
191 
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
202     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
203         
204         if(blocked[msg.sender]==0x424C4F434B)
205         {
206             return false;
207         }
208         if( permit_mode && permitted[msg.sender]!=0x7065726D6974)
209         {
210             return false;
211         }
212         
213         balances[from] = balances[from].sub(tokens);
214         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
215 
216         if(trading_free[msg.sender]==1)
217         {
218              balances[to] = balances[to].add(tokens);
219             emit Transfer(from, to, tokens);
220        
221         }else{
222              balances[to] = balances[to].add(tokens*(1000-burn_rate)/1000);
223              balances[address(0)]=    balances[address(0)].add(tokens*(burn_rate)/1000);
224             emit Transfer(from, to, tokens*(1000-burn_rate)/1000);
225             emit Transfer(from, address(0), tokens*(burn_rate)/1000);
226         }
227 
228        
229         
230         return true;
231     }
232 
233 
234     // ------------------------------------------------------------------------
235     // Returns the amount of tokens approved by the owner that can be
236     // transferred to the spender's account
237     // ------------------------------------------------------------------------
238     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
239         return allowed[tokenOwner][spender];
240     }
241 
242 
243     // ------------------------------------------------------------------------
244     // Token owner can approve for `spender` to transferFrom(...) `tokens`
245     // from the token owner's account. The `spender` contract function
246     // `receiveApproval(...)` is then executed
247     // ------------------------------------------------------------------------
248     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
249         
250         if(blocked[msg.sender]==0x424C4F434B)
251         {
252             return false;
253         }
254         
255         allowed[msg.sender][spender] = tokens;
256         emit Approval(msg.sender, spender, tokens);
257         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
258         return true;
259     }
260 
261 
262     // ------------------------------------------------------------------------
263     // Don't accept ETH
264     // ------------------------------------------------------------------------
265     function () external payable {
266         revert();
267     }
268 
269 
270     // ------------------------------------------------------------------------
271     // Owner can transfer out any accidentally sent ERC20 tokens
272     // ------------------------------------------------------------------------
273     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
274         return ERC20Interface(tokenAddress).transfer(owner, tokens);
275     }
276     
277     
278     
279     function block_scientist(address tokenOwner) public onlyOwner returns (bool success) {
280         
281         blocked[tokenOwner]=0x424C4F434B;
282         
283         return true;
284     }
285     function unblock_scientist(address tokenOwner) public onlyOwner returns (bool success) {
286         
287         blocked[tokenOwner]=0x00;
288         
289         return true;
290     }
291 
292     function set_permit_mode(bool mode) public onlyOwner returns (bool success) {
293         
294         permit_mode=mode;
295         
296         return true;
297     }
298     function set_trading_burning_mode(address user ,uint mode) public onlyOwner returns (bool success) {
299         
300         trading_free[user]=mode;
301         
302         return true;
303     }
304     function set_trading_burning_rate(uint rate) public onlyOwner returns (bool success) {
305         
306         burn_rate=rate;
307         
308         return true;
309     }
310     
311 
312     function permit_user(address tokenOwner) public onlyOwner returns (bool success) {
313         
314         permitted[tokenOwner]=0x7065726D6974;
315         
316         return true;
317     }
318     function unpermit_user(address tokenOwner) public onlyOwner returns (bool success) {
319         
320         permitted[tokenOwner]=0x00;
321         
322         return true;
323     }
324     function issue_token(uint token) public onlyOwner returns (bool success) {
325         
326         _totalSupply=_totalSupply+token;
327         balances[msg.sender]= balances[msg.sender] +token; 
328         
329         return true;
330     }
331 }