1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function add(uint a, uint b) internal pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function sub(uint a, uint b) internal pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function mul(uint a, uint b) internal pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function div(uint a, uint b) internal pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 // ----------------------------------------------------------------------------
23 // ERC Token Standard #20 Interface
24 // ----------------------------------------------------------------------------
25 contract ERC20Interface {
26     function totalSupply() public constant returns (uint);
27     function balanceOf(address tokenOwner) public constant returns (uint balance);
28     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
29     function transfer(address to, uint tokens) public returns (bool success);
30     function approve(address spender, uint tokens) public returns (bool success);
31     function transferFrom(address from, address to, uint tokens) public returns (bool success);
32 
33     event Transfer(address indexed from, address indexed to, uint tokens);
34     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
35 }
36 
37 // ----------------------------------------------------------------------------
38 // Ownership contract
39 // ----------------------------------------------------------------------------
40 contract Owned {
41 
42     address public owner;
43 
44     event OwnershipTransferred(address indexed _from, address indexed _to);
45 
46     constructor() public {
47         owner = 0xB4d8F78a9e403E50016623ED11bec00B89411311;
48     }
49 
50     modifier onlyOwner {
51         require(msg.sender == owner);
52         _;
53     }
54 
55     // transfer Ownership to other address
56     function transferOwnership(address _newOwner) public onlyOwner {
57         require(_newOwner != address(0x0));
58         emit OwnershipTransferred(owner,_newOwner);
59         owner = _newOwner;
60     }
61 }
62 
63 // ----------------------------------------------------------------------------
64 // ERC20 Token, with the addition of symbol, name and decimals and an
65 // initial fixed supply
66 // ----------------------------------------------------------------------------
67 contract ElectriqNetwork is ERC20Interface, Owned {
68 
69     using SafeMath for uint;
70 
71     string public symbol;
72     string public  name;
73     uint8 public decimals;
74     uint public _totalSupply;
75     uint public RATE;
76     uint public DENOMINATOR;
77     bool public isStopped = false;
78 
79     mapping(address => uint) balances;
80 
81     mapping(address => mapping(address => uint)) allowed;
82 
83     event Mint(address indexed to, uint256 amount);
84     event ChangeRate(uint256 amount);
85 
86     modifier onlyWhenRunning {
87         require(!isStopped);
88         _;
89     }
90 
91 
92     // ------------------------------------------------------------------------
93     // Constructor
94     // ------------------------------------------------------------------------
95     constructor() public {
96         symbol = "Eleq";
97         name = "Electriq Network";
98         decimals = 18;
99         _totalSupply = 300000000 * 10**uint(decimals);
100         balances[owner] = _totalSupply;
101         RATE = 2500000000; // 250k tokens per 1 ether
102         DENOMINATOR = 10000;
103         emit Transfer(address(0), owner, _totalSupply);
104     }
105 
106 
107     // ----------------------------------------------------------------------------
108     // It invokes when someone sends ETH to this contract address
109     // ----------------------------------------------------------------------------
110     function() public payable {
111         getTokens();
112     }
113 
114     // ----------------------------------------------------------------------------
115     // Low level token purchase function
116     // tokens are transferred to user
117     // ETH are transferred to current owner
118     // ----------------------------------------------------------------------------
119     function getTokens() onlyWhenRunning public payable {
120         require(msg.value > 0);
121 
122         uint tokens = msg.value.mul(RATE).div(DENOMINATOR);
123         require(balances[owner] >= tokens);
124 
125         balances[msg.sender] = balances[msg.sender].add(tokens);
126         balances[owner] = balances[owner].sub(tokens);
127 
128         emit Transfer(owner, msg.sender, tokens);
129 
130         owner.transfer(msg.value);
131     }
132 
133     // ------------------------------------------------------------------------
134     // Total supply
135     // ------------------------------------------------------------------------
136     function totalSupply() public view returns (uint) {
137         return _totalSupply;
138     }
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
154         require(to != address(0));
155         require(tokens > 0);
156         require(balances[msg.sender] >= tokens);
157 
158         balances[msg.sender] = balances[msg.sender].sub(tokens);
159         balances[to] = balances[to].add(tokens);
160         emit Transfer(msg.sender, to, tokens);
161         return true;
162     }
163 
164 
165     // ------------------------------------------------------------------------
166     // Token owner can approve for `spender` to transferFrom(...) `tokens`
167     // from the token owner's account
168     //
169     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
170     // recommends that there are no checks for the approval double-spend attack
171     // as this should be implemented in user interfaces
172     // ------------------------------------------------------------------------
173     function approve(address spender, uint tokens) public returns (bool success) {
174         require(spender != address(0));
175         require(tokens > 0);
176 
177         allowed[msg.sender][spender] = tokens;
178         emit Approval(msg.sender, spender, tokens);
179         return true;
180     }
181 
182 
183     // ------------------------------------------------------------------------
184     // Transfer `tokens` from the `from` account to the `to` account
185     //
186     // The calling account must already have sufficient tokens approve(...)-d
187     // for spending from the `from` account and
188     // - From account must have sufficient balance to transfer
189     // - Spender must have sufficient allowance to transfer
190     // ------------------------------------------------------------------------
191     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
192         require(from != address(0));
193         require(to != address(0));
194         require(tokens > 0);
195         require(balances[from] >= tokens);
196         require(allowed[from][msg.sender] >= tokens);
197 
198         balances[from] = balances[from].sub(tokens);
199         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
200         balances[to] = balances[to].add(tokens);
201         emit Transfer(from, to, tokens);
202         return true;
203     }
204 
205 
206     // ------------------------------------------------------------------------
207     // Returns the amount of tokens approved by the owner that can be
208     // transferred to the spender's account
209     // ------------------------------------------------------------------------
210     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
211         return allowed[tokenOwner][spender];
212     }
213 
214 
215     // ------------------------------------------------------------------------
216     // Increase the amount of tokens that an owner allowed to a spender.
217     //
218     // approve should be called when allowed[_spender] == 0. To increment
219     // allowed value is better to use this function to avoid 2 calls (and wait until
220     // the first transaction is mined)
221     // _spender The address which will spend the funds.
222     // _addedValue The amount of tokens to increase the allowance by.
223     // ------------------------------------------------------------------------
224     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
225         require(_spender != address(0));
226 
227         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
228         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
229         return true;
230     }
231 
232 
233     // ------------------------------------------------------------------------
234     // Decrease the amount of tokens that an owner allowed to a spender.
235     //
236     // approve should be called when allowed[_spender] == 0. To decrement
237     // allowed value is better to use this function to avoid 2 calls (and wait until
238     // the first transaction is mined)
239     // _spender The address which will spend the funds.
240     // _subtractedValue The amount of tokens to decrease the allowance by.
241     // ------------------------------------------------------------------------
242     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
243         require(_spender != address(0));
244 
245         uint oldValue = allowed[msg.sender][_spender];
246         if (_subtractedValue > oldValue) {
247             allowed[msg.sender][_spender] = 0;
248         } else {
249             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250         }
251         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252         return true;
253     }
254 
255 
256     // ------------------------------------------------------------------------
257     // Change the ETH to IO rate
258     // ------------------------------------------------------------------------
259     function changeRate(uint256 _rate) public onlyOwner {
260         require(_rate > 0);
261 
262         RATE =_rate;
263         emit ChangeRate(_rate);
264     }
265 
266 
267     // ------------------------------------------------------------------------
268     // Function to mint tokens
269     // _to The address that will receive the minted tokens.
270     // _amount The amount of tokens to mint.
271     // A boolean that indicates if the operation was successful.
272     // ------------------------------------------------------------------------
273     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
274         require(_to != address(0));
275         require(_amount > 0);
276 
277         uint newamount = _amount * 10**uint(decimals);
278         _totalSupply = _totalSupply.add(newamount);
279         balances[_to] = balances[_to].add(newamount);
280 
281         emit Mint(_to, newamount);
282         emit Transfer(address(0), _to, newamount);
283         return true;
284     }
285 
286 
287     // ------------------------------------------------------------------------
288     // function to stop the ICO
289     // ------------------------------------------------------------------------
290     function stopICO() onlyOwner public {
291         isStopped = true;
292     }
293 
294 
295     // ------------------------------------------------------------------------
296     // function to resume ICO
297     // ------------------------------------------------------------------------
298     function resumeICO() onlyOwner public {
299         isStopped = false;
300     }
301 
302 }