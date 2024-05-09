1 pragma solidity ^0.4.24;
2 
3 // ****************************************************************************
4 //
5 // Symbol          : BECC
6 // Name            : Beechain Exchange Cross-chain Coin
7 // Decimals        : 18
8 // Total supply    : 500,000,000.000000000000000000
9 // Initial release : 70 percent (350,000,000.000000000000000000)
10 // Initial Locked  : 30 percent (150,000,000.000000000000000000)
11 // Contract start  : 2018-08-15 00:00:00 (UTC timestamp: 1534233600)
12 // Lock duration   : 180 days
13 // Release rate    : 10 percent / 30 days (15,000,000.000000000000000000)
14 // Release duration: 300 days.
15 //
16 // ****************************************************************************
17 
18 
19 // ****************************************************************************
20 // Safe math
21 // ****************************************************************************
22 
23 library SafeMath {
24     
25   function mul(uint _a, uint _b) internal pure returns (uint c) {
26     if (_a == 0) {
27       return 0;
28     }
29     c = _a * _b;
30     assert(c / _a == _b);
31     return c;
32   }
33 
34   function div(uint _a, uint _b) internal pure returns (uint) {
35     return _a / _b;
36   }
37 
38   function sub(uint _a, uint _b) internal pure returns (uint) {
39     assert(_b <= _a);
40     return _a - _b;
41   }
42 
43   function add(uint _a, uint _b) internal pure returns (uint c) {
44     c = _a + _b;
45     assert(c >= _a);
46     return c;
47   }
48 }
49 
50 // ****************************************************************************
51 // ERC Token Standard #20 Interface
52 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
53 // ****************************************************************************
54 contract ERC20 {
55     function totalSupply() public constant returns (uint);
56     function balanceOf(address tokenOwner) public constant returns (uint balance);
57     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
58     function transfer(address to, uint tokens) public returns (bool success);
59     function approve(address spender, uint tokens) public returns (bool success);
60     function transferFrom(address from, address to, uint tokens) public returns (bool success);
61 
62     event Transfer(address indexed from, address indexed to, uint tokens);
63     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
64 }
65 
66 // ****************************************************************************
67 // Contract function to receive approval and execute function
68 // ****************************************************************************
69 contract ApproveAndCallFallBack {
70     function receiveApproval(address from, uint tokens, address token, bytes data) public;
71 }
72 
73 // ****************************************************************************
74 // Owned contract
75 // ****************************************************************************
76 contract Owned {
77     
78     address public owner;
79     address public newOwner;
80 
81     event OwnershipTransferred(address indexed _from, address indexed _to);
82 
83     constructor() public {
84         owner = msg.sender;
85     }
86 
87     modifier onlyOwner {
88         require(msg.sender == owner);
89         _;
90     }
91 
92     function transferOwnership(address _newOwner) public onlyOwner {
93         newOwner = _newOwner;
94     }
95     
96     function acceptOwnership() public {
97         require(msg.sender == newOwner);
98         emit OwnershipTransferred(owner, newOwner);
99         owner = newOwner;
100         newOwner = address(0);
101     }
102 }
103 
104 // ****************************************************************************
105 // BECC Token, with the addition of symbol, name and decimals and a fixed supply
106 // ****************************************************************************
107 contract BECCToken is ERC20, Owned {
108     using SafeMath for uint;
109     
110     event Pause();
111     event Unpause();
112     event ReleasedTokens(uint tokens);
113     event AllocateTokens(address to, uint tokens);
114     
115     bool public paused = false;
116 
117     string public symbol;
118     string public name;
119     uint8 public decimals;
120     
121     uint private _totalSupply;              //total supply
122     uint private _initialRelease;           //initial release
123     uint private _locked;                   //locked tokens
124     uint private _released = 0;             //alloced tokens
125     uint private _allocated = 0;
126     uint private _startTime = 1534233600 + 180 days;    //release start time:2018-08-15 00:00:00(UTC) + 180 days
127 
128     mapping(address => uint) balances;
129     mapping(address => mapping(address => uint)) allowed;
130 
131     // ************************************************************************
132     // Modifier to make a function callable only when the contract is not paused.
133     // ************************************************************************
134     modifier whenNotPaused() {
135         require(!paused);
136         _;
137     }
138 
139     // ************************************************************************
140     // Modifier to make a function callable only when the contract is paused.
141     // ************************************************************************
142     modifier whenPaused() {
143         require(paused);
144         _;
145     }
146   
147     // ************************************************************************
148     // Constructor
149     // ************************************************************************
150     constructor() public {
151         symbol = "BECC";
152         name = "Beechain Exchange Cross-chain Coin";
153         decimals = 18;
154         _totalSupply = 500000000 * 10**uint(decimals);
155         _initialRelease = _totalSupply * 7 / 10;
156         _locked = _totalSupply * 3 / 10;
157         balances[owner] = _initialRelease;
158         emit Transfer(address(0), owner, _initialRelease);
159     }
160 
161     // ************************************************************************
162     // Total supply
163     // ************************************************************************
164     function totalSupply() public view returns (uint) {
165         return _totalSupply.sub(balances[address(0)]);
166     }
167 
168     // ************************************************************************
169     // Get the token balance for account `tokenOwner`
170     // ************************************************************************
171     function balanceOf(address tokenOwner) public view returns (uint balance) {
172         return balances[tokenOwner];
173     }
174 
175     // ************************************************************************
176     // Transfer the balance from token owner's account to `to` account
177     // - Owner's account must have sufficient balance to transfer
178     // - 0 value transfers are allowed
179     // ************************************************************************
180     function transfer(address to, uint tokens) public whenNotPaused returns (bool success) {
181         require(address(0) != to && tokens <= balances[msg.sender] && 0 <= tokens);
182         balances[msg.sender] = balances[msg.sender].sub(tokens);
183         balances[to] = balances[to].add(tokens);
184         emit Transfer(msg.sender, to, tokens);
185         return true;
186     }
187 
188     // ************************************************************************
189     // Token owner can approve for `spender` to transferFrom(...) `tokens`
190     // from the token owner's account
191     // ************************************************************************
192     function approve(address spender, uint tokens) public whenNotPaused returns (bool success) {
193         require(address(0) != spender && 0 <= tokens);
194         allowed[msg.sender][spender] = tokens;
195         emit Approval(msg.sender, spender, tokens);
196         return true;
197     }
198 
199 
200     // ************************************************************************
201     // Transfer `tokens` from the `from` account to the `to` account
202     // 
203     // The calling account must already have sufficient tokens approve(...)-d
204     // for spending from the `from` account and
205     // - From account must have sufficient balance to transfer
206     // - Spender must have sufficient allowance to transfer
207     // - 0 value transfers are allowed
208     // ************************************************************************
209     function transferFrom(address from, address to, uint tokens) public whenNotPaused returns (bool success) {
210         require(address(0) != to && tokens <= balances[msg.sender] && tokens <= allowed[from][msg.sender] && 0 <= tokens);
211         balances[from] = balances[from].sub(tokens);
212         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
213         balances[to] = balances[to].add(tokens);
214         emit Transfer(from, to, tokens);
215         return true;
216     }
217 
218 
219     // ************************************************************************
220     // Returns the amount of tokens approved by the owner that can be
221     // transferred to the spender's account
222     // ************************************************************************
223     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
224         return allowed[tokenOwner][spender];
225     }
226 
227     // ************************************************************************
228     // Token owner can approve for `spender` to transferFrom(...) `tokens`
229     // from the token owner's account. The `spender` contract function
230     // `receiveApproval(...)` is then executed
231     // ************************************************************************
232     function approveAndCall(address spender, uint tokens, bytes data) public whenNotPaused returns (bool success) {
233         allowed[msg.sender][spender] = tokens;
234         emit Approval(msg.sender, spender, tokens);
235         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
236         return true;
237     }
238 
239     // ************************************************************************
240     // Don't accept ETH
241     // ************************************************************************
242     function () public payable {
243         revert();
244     }
245 
246     // ************************************************************************
247     // Owner can transfer out any accidentally sent ERC20 tokens
248     // ************************************************************************
249     function transferERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
250         return ERC20(tokenAddress).transfer(owner, tokens);
251     }
252     
253     // ************************************************************************
254     // called by the owner to pause, triggers stopped state
255     // ************************************************************************
256     function pause() public onlyOwner whenNotPaused {
257         paused = true;
258         emit Pause();
259     }
260 
261     // ************************************************************************
262     // called by the owner to unpause, returns to normal state
263     // ************************************************************************
264     function unpause() public onlyOwner whenPaused {
265         paused = false;
266         emit Unpause();
267     }
268     
269     // ************************************************************************
270     // return free Tokens
271     // ************************************************************************
272     function freeBalance() public view returns (uint tokens) {
273         return _released.sub(_allocated);
274     }
275 
276     // ************************************************************************
277     // return released Tokens
278     // ************************************************************************
279     function releasedBalance() public view returns (uint tokens) {
280         return _released;
281     }
282 
283     // ************************************************************************
284     // return allocated Tokens
285     // ************************************************************************
286     function allocatedBalance() public view returns (uint tokens) {
287         return _allocated;
288     }
289     
290     // ************************************************************************
291     // calculate released Tokens by the owner
292     // ************************************************************************
293     function calculateReleased() public onlyOwner returns (uint tokens) {
294         require(now > _startTime);
295         uint _monthDiff = (now.sub(_startTime)).div(30 days);
296 
297         if (_monthDiff >= 10 ) {
298             _released = _locked;
299         } else {
300             _released = _monthDiff.mul(_locked.div(10));
301         }
302         emit ReleasedTokens(_released);
303         return _released;
304     }
305 
306     // ************************************************************************
307     // called by the owner to alloc the released tokens
308     // ************************************************************************     
309     function allocateTokens(address to, uint tokens) public onlyOwner returns (bool success){
310         require(address(0) != to && 0 <= tokens && tokens <= _released.sub(_allocated));
311         balances[to] = balances[to].add(tokens);
312         _allocated = _allocated.add(tokens);
313         emit AllocateTokens(to, tokens);
314         return true;
315     }
316 }