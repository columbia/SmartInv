1 pragma solidity ^0.5.0;
2 
3 
4 // ----------------------------------------------------------------------------
5 // Safe maths
6 // ----------------------------------------------------------------------------
7 library SafeMath {
8     function add(uint a, uint b) internal pure returns (uint c) {
9         c = a + b;
10         require(c >= a);
11     }
12     function sub(uint a, uint b) internal pure returns (uint c) {
13         require(b <= a);
14         c = a - b;
15     }
16     function mul(uint a, uint b) internal pure returns (uint c) {
17         c = a * b;
18         require(a == 0 || c / a == b);
19     }
20     function div(uint a, uint b) internal pure returns (uint c) {
21         require(b > 0);
22         c = a / b;
23     }
24 } 
25 
26 
27 // ----------------------------------------------------------------------------
28 // ERC Toke n Standard #20 Interface
29 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
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
58     address payable owner;
59     address payable newOwner;
60 
61     event OwnershipTransferred(address indexed _from, address indexed _to);
62 
63     constructor() public {
64         owner = 0x8dDd950AFd7F21e59198049bb98d0BB2897508D9;
65     }
66 
67     modifier onlyOwner {
68         require(msg.sender == owner);
69         _;
70     }
71     /*
72     function transferOwnership(address _newOwner) public onlyOwner {
73         newOwner = _newOwner;
74     }
75     */
76     function acceptOwnership() public {
77         require(msg.sender == newOwner);
78         emit OwnershipTransferred(owner, newOwner);
79         owner = newOwner;
80         newOwner = address(0);
81     }
82 }
83 
84 
85 // ----------------------------------------------------------------------------
86 // ERC20 Token, with the addition of symbol, name and decimals and a
87 // fixed supply
88 // ----------------------------------------------------------------------------
89 contract Token is ERC20Interface, Owned {
90     using SafeMath for uint;
91 
92     string public symbol;
93     string public  name;
94     uint8 public decimals;
95     uint256 _totalSupply;
96     uint256 sale;
97     uint256 reserve;
98     uint public phase;
99 
100     mapping(address => uint) public balances;
101     mapping(address => mapping(address => uint)) allowed;
102     
103 
104 
105     // ------------------------------------------------------------------------
106     // Constructor
107     // ------------------------------------------------------------------------
108     constructor() public {
109         name = "4um.io";
110         symbol = "4UM";
111         decimals = 18;
112         phase = 1;
113         
114         _totalSupply = 20000000 * 10**uint(decimals);
115         sale = 10000000 * 10**uint(decimals);
116         reserve = 10000000 * 10**uint(decimals);
117         
118         balances[owner] = reserve;
119         emit Transfer(address(0), owner, reserve);
120         
121         
122         balances[address(this)] = sale;
123         emit Transfer(address(0), address(this), sale);
124     }
125     // ------------------------------------------------------------------------
126     
127   
128     
129     function phasechange(uint256 number) onlyOwner public{
130         //require(msg.sender==owner,"Only Owner Can Change Phase!");
131         phase = number ;
132     } 
133     
134     function() external payable {
135         buyTokens(address(0));
136     }
137     
138     
139     function buyTokens(address payable reffer) public payable {
140         //require(beneficiary != address(0),"Invalid Address!");
141         //require(amount >= 1*1e17 && amount <= 50*1e18 , "Invalid Amount!");
142         uint256 tokens;
143         uint256 refpercent;
144         uint256 weiAmount = msg.value;
145         
146        
147         if(phase == 1){
148             tokens = weiAmount * 2355;
149             refpercent = 5;
150         }
151         else if(phase == 2){
152             tokens = weiAmount * 1175;
153             refpercent = 5;
154         }
155         else if(phase ==3){
156             tokens = weiAmount * 588;
157             refpercent = 5;
158         }
159         else{
160             revert("Sale Not Started!");
161         }
162             
163         require(balances[address(this)] >=tokens , "Tokens Not Available!");
164         
165             
166         balances[msg.sender] = balances[msg.sender] + tokens;
167         balances[address(this)] = balances[address(this)] - tokens;
168         emit Transfer(address(this), msg.sender , tokens);
169         
170        if(reffer != address(0) && reffer != msg.sender){
171            uint256 am = (msg.value*refpercent)/100;
172            reffer.transfer(am);
173            
174            uint256 rt = (tokens*refpercent)/100;
175            balances[reffer] = balances[reffer] + rt;
176            balances[address(this)] = balances[address(this)] - rt;
177            emit Transfer(address(this), reffer , rt);
178        }
179        
180        
181        //
182         
183         forwardFunds();
184     }
185     
186     function forwardFunds() internal {
187         owner.transfer(address(this).balance);
188         
189     }
190     
191     
192     //-------------------------------------------------------------------------
193 
194 
195     // ------------------------------------------------------------------------
196     // Total supply
197     // ------------------------------------------------------------------------
198     function totalSupply() public view returns (uint) {
199         return _totalSupply.sub(balances[address(0)]);
200     }
201 
202 
203     // ------------------------------------------------------------------------
204     // Get the token balance for account `tokenOwner`
205     // ------------------------------------------------------------------------
206     function balanceOf(address tokenOwner) public view returns (uint balance) {
207         return balances[tokenOwner];
208     }
209 
210 
211     // ------------------------------------------------------------------------
212     // Transfer the balance from token owner's account to `to` account
213     // - Owner's account must have sufficient balance to transfer
214     // - 0 value transfers are allowed
215     // ------------------------------------------------------------------------
216     function transfer(address to, uint tokens) public returns (bool success) {
217         balances[msg.sender] = balances[msg.sender].sub(tokens);
218         balances[to] = balances[to].add(tokens);
219         emit Transfer(msg.sender, to, tokens);
220         return true;
221     }
222 
223 
224     // ------------------------------------------------------------------------
225     // Token owner can approve for `spender` to transferFrom(...) `tokens`
226     // from the token owner's account
227     //
228     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
229     // recommends that there are no checks for the approval double-spend attack
230     // as this should be implemented in user interfaces
231     // ------------------------------------------------------------------------
232     function approve(address spender, uint tokens) public returns (bool success) {
233         allowed[msg.sender][spender] = tokens;
234         emit Approval(msg.sender, spender, tokens);
235         return true;
236     }
237 
238 
239     // ------------------------------------------------------------------------  
240     // Transfer `tokens` from the `from` account to the `to` account
241     //
242     // The calling account must already have sufficient tokens approve(...)-d
243     // for spending from the `from` account and
244     // - From account must have sufficient balance to transfer
245     // - Spender must have sufficient allowance to transfer
246     // - 0 value transfers are allowed
247     // ------------------------------------------------------------------------
248     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
249         balances[from] = balances[from].sub(tokens);
250         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
251         balances[to] = balances[to].add(tokens);
252         emit Transfer(from, to, tokens);
253         return true;
254     }
255 
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
267     // Token owner can approve for `spender` to transferFrom(...) `tokens`
268     // from the token owner's account. The `spender` contract function
269     // `receiveApproval(...)` is then executed
270     // ------------------------------------------------------------------------
271     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
272         allowed[msg.sender][spender] = tokens;
273         emit Approval(msg.sender, spender, tokens);
274         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
275         return true;
276     }
277 
278 
279     // ------------------------------------------------------------------------
280     // Don't accept ETH
281     // ------------------------------------------------------------------------
282 /*    function () external payable {
283         revert();
284     }
285 */
286 
287     // ------------------------------------------------------------------------
288     // Owner can transfer out any accidentally sent ERC20 tokens
289     // ------------------------------------------------------------------------
290     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
291         return ERC20Interface(tokenAddress).transfer(owner, tokens);
292     }
293     
294     
295      function mint(address account, uint256 amount) onlyOwner public returns (bool) {
296         require(account != address(0), "ERC20: mint to the zero address");
297         _totalSupply = _totalSupply.add(amount);
298         balances[account] = balances[account].add(amount);
299         emit Transfer(address(0), account, amount);
300     }
301     
302     /**
303      * @dev Destroys `amount` tokens from `account`, reducing the
304      * total supply.
305      *
306      * Emits a {Transfer} event with `to` set to the zero address.
307      *
308      * Requirements
309      *
310      * - `account` cannot be the zero address.
311      * - `account` must have at least `amount` tokens.
312      */
313      
314     function burn(address account, uint256 amount) onlyOwner public returns (bool) {
315         require(account != address(0), "ERC20: burn from the zero address");
316         balances[account] = balances[account].sub(amount);
317         _totalSupply = _totalSupply.sub(amount);
318         emit Transfer(account, address(0), amount);
319     }
320    
321     
322     
323 
324 }