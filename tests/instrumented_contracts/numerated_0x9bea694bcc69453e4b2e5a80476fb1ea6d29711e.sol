1 pragma solidity ^0.4.19;
2 
3 // ----------------------------------------------------------------------------
4 // Betcoin smart contract
5 //
6 // Symbol      : BETC
7 // Name        : Betcoin
8 // Total supply: 125500000
9 // Decimals    : 18
10 // ----------------------------------------------------------------------------\
11 
12 
13 // ----------------------------------------------------------------------------
14 // Safe math
15 // ----------------------------------------------------------------------------
16 library SafeMath {
17     function add(uint a, uint b) internal pure returns (uint c) {
18         c = a + b;
19         require(c >= a);
20     }
21     function sub(uint a, uint b) internal pure returns (uint c) {
22         require(b <= a);
23         c = a - b;
24     }
25     function mul(uint a, uint b) internal pure returns (uint c) {
26         c = a * b;
27         require(a == 0 || c / a == b);
28     }
29     function div(uint a, uint b) internal pure returns (uint c) {
30         require(b > 0);
31         c = a / b;
32     }
33 }
34 
35 
36 // ----------------------------------------------------------------------------
37 // Ownership contract
38 // _newOwner is address of new owner
39 // ----------------------------------------------------------------------------
40 contract Owned {
41     address public owner;
42 
43     event OwnershipTransferred(address indexed _from, address indexed _to);
44 
45     function Owned() public {
46         owner = msg.sender;
47     }
48 
49     modifier onlyOwner {
50         require(msg.sender == owner);
51         _;
52     }
53 
54     function transferOwnership(address _newOwner) public onlyOwner {
55         require(_newOwner != address(0x0));
56         emit OwnershipTransferred(owner,_newOwner);
57         owner = _newOwner;
58     }
59     
60 }
61 
62 
63 // ----------------------------------------------------------------------------
64 // ERC Token Standard #20 Interface
65 // ----------------------------------------------------------------------------
66 contract ERC20Interface {
67     function totalSupply() public constant returns (uint);
68     function balanceOf(address tokenOwner) public constant returns (uint balance);
69     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
70     function transfer(address to, uint tokens) public returns (bool success);
71     function approve(address spender, uint tokens) public returns (bool success);
72     function transferFrom(address from, address to, uint tokens) public returns (bool success);
73 
74     event Transfer(address indexed from, address indexed to, uint tokens);
75     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
76 }
77 
78 
79 // ----------------------------------------------------------------------------
80 // ERC20 Token, with the addition of symbol, name and decimals and an
81 // initial fixed supply
82 // ----------------------------------------------------------------------------
83 contract BetcoinICO is ERC20Interface, Owned {
84     
85     using SafeMath for uint;
86 
87     string public symbol;
88     string public  name;
89     uint8 public decimals;
90     uint public _totalSupply;
91     uint public RATE;
92     bool public isStopped = false;
93 
94     mapping(address => uint) balances;
95     mapping(address => mapping(address => uint)) allowed;
96     
97     event LogRateChanged(uint256 rate);
98     
99     modifier onlyWhenRunning {
100         require(!isStopped);
101         _;
102     }
103     
104     
105     // ------------------------------------------------------------------------
106     // Constructor
107     // ------------------------------------------------------------------------
108     function BetcoinICO() public {
109         symbol = "BETC";
110         name = "Betcoin";
111         decimals = 18;
112         _totalSupply = 125500000 * 10**uint(decimals);
113         balances[owner] = _totalSupply;
114         RATE = 5000; // 1 ETH = 5000 BETC
115         emit Transfer(address(0), owner, _totalSupply);
116     }
117     
118     
119     // ------------------------------------------------------------------------
120     // executes when someone send ETH
121     // ------------------------------------------------------------------------
122     function() public payable {
123         buyTokens();
124     }
125     
126     
127     // ------------------------------------------------------------------------
128     // Accepts ETH and send equivalent tokens
129     // ------------------------------------------------------------------------
130     function buyTokens() onlyWhenRunning public payable {
131         // investment should be greater than 0
132         require(msg.value > 0);
133         
134         uint tokens = msg.value.mul(RATE);
135         
136         // owner should have enough tokens
137         require(balances[owner] >= tokens);
138         
139         // send tokens to buyer
140         balances[msg.sender] = balances[msg.sender].add(tokens);
141         balances[owner] = balances[owner].sub(tokens);
142         emit Transfer(owner, msg.sender, tokens);
143         
144         // send ETH to owner
145         owner.transfer(msg.value);
146     }
147     
148     
149     // ------------------------------------------------------------------------
150     // Total supply
151     // ------------------------------------------------------------------------
152     function totalSupply() public constant returns (uint) {
153         return _totalSupply;
154     }
155 
156 
157     // ------------------------------------------------------------------------
158     // Get the token balance for account `tokenOwner`
159     // ------------------------------------------------------------------------
160     function balanceOf(address tokenOwner) public constant returns (uint balance) {
161         return balances[tokenOwner];
162     }
163 
164 
165     // ------------------------------------------------------------------------
166     // Transfer the balance from token owner's account to `to` account
167     // - Owner's account must have sufficient balance to transfer
168     // - 0 value transfers are allowed
169     // ------------------------------------------------------------------------
170     function transfer(address to, uint tokens) public returns (bool success) {
171         if(balances[msg.sender] >= tokens && tokens > 0 && to!=address(0)) {
172             balances[msg.sender] = balances[msg.sender].sub(tokens);
173             balances[to] = balances[to].add(tokens);
174             emit Transfer(msg.sender, to, tokens);
175             return true;
176         } else { return false; }
177     }
178 
179 
180     // ------------------------------------------------------------------------
181     // Token owner can approve for `spender` to transferFrom(...) `tokens`
182     // from the token owner's account
183     //
184     // recommends that there are no checks for the approval double-spend attack
185     // as this should be implemented in user interfaces 
186     // ------------------------------------------------------------------------
187     function approve(address spender, uint tokens) public returns (bool success) {
188         if(tokens > 0 && spender != address(0)) {
189             allowed[msg.sender][spender] = tokens;
190             emit Approval(msg.sender, spender, tokens);
191             return true;
192         } else { return false; }
193     }
194 
195 
196     // ------------------------------------------------------------------------
197     // Transfer `tokens` from the `from` account to the `to` account
198     // 
199     // The calling account must already have sufficient tokens approve(...)-d
200     // for spending from the `from` account and
201     // - From account must have sufficient balance to transfer
202     // - Spender must have sufficient allowance to transfer
203     // - 0 value transfers are allowed
204     // ------------------------------------------------------------------------
205     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
206         if (balances[from] >= tokens && allowed[from][msg.sender] >= tokens && tokens > 0) {
207             balances[from] = balances[from].sub(tokens);
208             allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
209             balances[to] = balances[to].add(tokens);
210             emit Transfer(from, to, tokens);
211             return true;
212         } else { return false; }
213     }
214 
215 
216     // ------------------------------------------------------------------------
217     // Returns the amount of tokens approved by the owner that can be
218     // transferred to the spender's account
219     // ------------------------------------------------------------------------
220     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
221         return allowed[tokenOwner][spender];
222     }
223     
224     
225     // ------------------------------------------------------------------------
226     // Increase the amount of tokens that an owner allowed to a spender.
227     //
228     // approve should be called when allowed[_spender] == 0. To increment
229     // allowed value is better to use this function to avoid 2 calls (and wait until
230     // the first transaction is mined)
231     // From MonolithDAO Token.sol
232     // _spender The address which will spend the funds.
233     // _addedValue The amount of tokens to increase the allowance by.
234     // ------------------------------------------------------------------------
235     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
236         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
237         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238         return true;
239     }
240     
241     
242     // ------------------------------------------------------------------------
243     // Decrease the amount of tokens that an owner allowed to a spender.
244     //
245     // approve should be called when allowed[_spender] == 0. To decrement
246     // allowed value is better to use this function to avoid 2 calls (and wait until
247     // the first transaction is mined)
248     // From MonolithDAO Token.sol
249     // _spender The address which will spend the funds.
250     // _subtractedValue The amount of tokens to decrease the allowance by.
251     // ------------------------------------------------------------------------
252     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
253         uint oldValue = allowed[msg.sender][_spender];
254         if (_subtractedValue > oldValue) {
255             allowed[msg.sender][_spender] = 0;
256         } else {
257             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
258         }
259         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260         return true;
261     }
262     
263     
264     // ------------------------------------------------------------------------
265     // To stop the ICO
266     // ------------------------------------------------------------------------
267     function stopICO() onlyOwner public {
268         isStopped = true;
269     }
270     
271     
272     // ------------------------------------------------------------------------
273     // To resume the ICO
274     // ------------------------------------------------------------------------
275     function resumeICO() onlyOwner public {
276         isStopped = false;
277     }
278     
279     
280     // ------------------------------------------------------------------------
281     // To change RATE
282     // ------------------------------------------------------------------------
283     function changeRate(uint256 rate) onlyOwner public {
284         require(rate > 0);
285         
286         RATE = rate;
287         emit LogRateChanged(rate);
288     }
289 
290 }