1 pragma solidity ^0.4.24;
2 
3 
4 // ****************************************************************************
5 // Safe math
6 // ****************************************************************************
7 
8 library SafeMath {
9     
10   function mul(uint _a, uint _b) internal pure returns (uint c) {
11     if (_a == 0) {
12       return 0;
13     }
14     c = _a * _b;
15     assert(c / _a == _b);
16     return c;
17   }
18 
19   function div(uint _a, uint _b) internal pure returns (uint) {
20     return _a / _b;
21   }
22 
23   function sub(uint _a, uint _b) internal pure returns (uint) {
24     assert(_b <= _a);
25     return _a - _b;
26   }
27 
28   function add(uint _a, uint _b) internal pure returns (uint c) {
29     c = _a + _b;
30     assert(c >= _a);
31     return c;
32   }
33 }
34 
35 // ****************************************************************************
36 // ERC Token Standard #20 Interface
37 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
38 // ****************************************************************************
39 contract ERC20 {
40     function totalSupply() public constant returns (uint);
41     function balanceOf(address tokenOwner) public constant returns (uint balance);
42     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
43     function transfer(address to, uint tokens) public returns (bool success);
44     function approve(address spender, uint tokens) public returns (bool success);
45     function transferFrom(address from, address to, uint tokens) public returns (bool success);
46 
47     event Transfer(address indexed from, address indexed to, uint tokens);
48     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
49 }
50 
51 // ****************************************************************************
52 // Contract function to receive approval and execute function
53 // ****************************************************************************
54 contract ApproveAndCallFallBack {
55     function receiveApproval(address from, uint tokens, address token, bytes data) public;
56 }
57 
58 // ****************************************************************************
59 // Owned contract
60 // ****************************************************************************
61 contract Owned {
62     
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
89 // ****************************************************************************
90 // TTTC Token, with the addition of symbol, name and decimals and a fixed supply
91 // ****************************************************************************
92 contract TTTCToken is ERC20, Owned {
93     using SafeMath for uint;
94     
95     event Pause();
96     event Unpause();
97     event ReleasedTokens(uint tokens);
98     event AllocateTokens(address to, uint tokens);
99     
100     bool public paused = false;
101 
102     string public symbol;
103     string public name;
104     uint8 public decimals;
105     
106     uint private _totalSupply;              //total supply
107     uint private _initialRelease;           //initial release
108     uint private _locked;                   //locked tokens
109     uint private _released = 0;             //alloced tokens
110     uint private _allocated = 0;
111     uint private _startTime = 1534233600 + 180 days;    //release start time:2018-08-15 00:00:00(UTC) + 180 days
112 
113     mapping(address => uint) balances;
114     mapping(address => mapping(address => uint)) allowed;
115 
116     // ************************************************************************
117     // Modifier to make a function callable only when the contract is not paused.
118     // ************************************************************************
119     modifier whenNotPaused() {
120         require(!paused);
121         _;
122     }
123 
124     // ************************************************************************
125     // Modifier to make a function callable only when the contract is paused.
126     // ************************************************************************
127     modifier whenPaused() {
128         require(paused);
129         _;
130     }
131   
132     // ************************************************************************
133     // Constructor
134     // ************************************************************************
135     constructor() public {
136         symbol = "TTTC";
137         name = "TTTC";
138         decimals = 18;
139         _totalSupply = 500000000 * 10**uint(decimals);
140         _initialRelease = _totalSupply * 7 / 10;
141         _locked = _totalSupply * 3 / 10;
142         balances[owner] = _initialRelease;
143         emit Transfer(address(0), owner, _initialRelease);
144     }
145 
146     // ************************************************************************
147     // Total supply
148     // ************************************************************************
149     function totalSupply() public view returns (uint) {
150         return _totalSupply.sub(balances[address(0)]);
151     }
152 
153     // ************************************************************************
154     // Get the token balance for account `tokenOwner`
155     // ************************************************************************
156     function balanceOf(address tokenOwner) public view returns (uint balance) {
157         return balances[tokenOwner];
158     }
159 
160     // ************************************************************************
161     // Transfer the balance from token owner's account to `to` account
162     // - Owner's account must have sufficient balance to transfer
163     // - 0 value transfers are allowed
164     // ************************************************************************
165     function transfer(address to, uint tokens) public whenNotPaused returns (bool success) {
166         require(address(0) != to && tokens <= balances[msg.sender] && 0 <= tokens);
167         balances[msg.sender] = balances[msg.sender].sub(tokens);
168         balances[to] = balances[to].add(tokens);
169         emit Transfer(msg.sender, to, tokens);
170         return true;
171     }
172 
173     // ************************************************************************
174     // Token owner can approve for `spender` to transferFrom(...) `tokens`
175     // from the token owner's account
176     // ************************************************************************
177     function approve(address spender, uint tokens) public whenNotPaused returns (bool success) {
178         require(address(0) != spender && 0 <= tokens);
179         allowed[msg.sender][spender] = tokens;
180         emit Approval(msg.sender, spender, tokens);
181         return true;
182     }
183 
184 
185     // ************************************************************************
186     // Transfer `tokens` from the `from` account to the `to` account
187     // 
188     // The calling account must already have sufficient tokens approve(...)-d
189     // for spending from the `from` account and
190     // - From account must have sufficient balance to transfer
191     // - Spender must have sufficient allowance to transfer
192     // - 0 value transfers are allowed
193     // ************************************************************************
194     function transferFrom(address from, address to, uint tokens) public whenNotPaused returns (bool success) {
195         require(address(0) != to && tokens <= balances[from] && tokens <= allowed[from][msg.sender] && 0 <= tokens);
196         balances[from] = balances[from].sub(tokens);
197         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
198         balances[to] = balances[to].add(tokens);
199         emit Transfer(from, to, tokens);
200         return true;
201     }
202 
203 
204     // ************************************************************************
205     // Returns the amount of tokens approved by the owner that can be
206     // transferred to the spender's account
207     // ************************************************************************
208     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
209         return allowed[tokenOwner][spender];
210     }
211 
212     // ************************************************************************
213     // Token owner can approve for `spender` to transferFrom(...) `tokens`
214     // from the token owner's account. The `spender` contract function
215     // `receiveApproval(...)` is then executed
216     // ************************************************************************
217     function approveAndCall(address spender, uint tokens, bytes data) public whenNotPaused returns (bool success) {
218         allowed[msg.sender][spender] = tokens;
219         emit Approval(msg.sender, spender, tokens);
220         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
221         return true;
222     }
223 
224     // ************************************************************************
225     // Don't accept ETH
226     // ************************************************************************
227     function () public payable {
228         revert();
229     }
230 
231     // ************************************************************************
232     // Owner can transfer out any accidentally sent ERC20 tokens
233     // ************************************************************************
234     function transferERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
235         return ERC20(tokenAddress).transfer(owner, tokens);
236     }
237     
238     // ************************************************************************
239     // called by the owner to pause, triggers stopped state
240     // ************************************************************************
241     function pause() public onlyOwner whenNotPaused {
242         paused = true;
243         emit Pause();
244     }
245 
246     // ************************************************************************
247     // called by the owner to unpause, returns to normal state
248     // ************************************************************************
249     function unpause() public onlyOwner whenPaused {
250         paused = false;
251         emit Unpause();
252     }
253     
254     // ************************************************************************
255     // return free Tokens
256     // ************************************************************************
257     function freeBalance() public view returns (uint tokens) {
258         return _released.sub(_allocated);
259     }
260 
261     // ************************************************************************
262     // return released Tokens
263     // ************************************************************************
264     function releasedBalance() public view returns (uint tokens) {
265         return _released;
266     }
267 
268     // ************************************************************************
269     // return allocated Tokens
270     // ************************************************************************
271     function allocatedBalance() public view returns (uint tokens) {
272         return _allocated;
273     }
274     
275     // ************************************************************************
276     // calculate released Tokens by the owner
277     // ************************************************************************
278     function calculateReleased() public onlyOwner returns (uint tokens) {
279         require(now > _startTime);
280         uint _monthDiff = (now.sub(_startTime)).div(30 days);
281 
282         if (_monthDiff >= 10 ) {
283             _released = _locked;
284         } else {
285             _released = _monthDiff.mul(_locked.div(10));
286         }
287         emit ReleasedTokens(_released);
288         return _released;
289     }
290 
291     // ************************************************************************
292     // called by the owner to alloc the released tokens
293     // ************************************************************************     
294     function allocateTokens(address to, uint tokens) public onlyOwner returns (bool success){
295         require(address(0) != to && 0 <= tokens && tokens <= _released.sub(_allocated));
296         balances[to] = balances[to].add(tokens);
297         _allocated = _allocated.add(tokens);
298         emit AllocateTokens(to, tokens);
299         return true;
300     }
301 }