1 pragma solidity ^0.4.24;
2 
3 
4 
5 library SafeMath {
6     function add(uint a, uint b) internal pure returns (uint c) {
7         c = a + b;
8         require(c >= a);
9     }
10     function sub(uint a, uint b) internal pure returns (uint c) {
11         require(b <= a);
12         c = a - b;
13     }
14     function mul(uint a, uint b) internal pure returns (uint c) {
15         c = a * b;
16         require(a == 0 || c / a == b);
17     }
18     function div(uint a, uint b) internal pure returns (uint c) {
19         require(b > 0);
20         c = a / b;
21     }
22 }
23 
24 
25 // ----------------------------------------------------------------------------
26 // Ownership contract
27 // _newOwner is address of new owner
28 // ----------------------------------------------------------------------------
29 contract Owned {
30     
31     address public owner;
32 
33     event OwnershipTransferred(address indexed _from, address indexed _to);
34 
35     constructor() public {
36         owner = 0x121812BDD10F26fBe260c3eBb05731F6a679B116;
37     }
38 
39     modifier onlyOwner {
40         require(msg.sender == owner);
41         _;
42     }
43 
44     // transfer Ownership to other address
45     function transferOwnership(address _newOwner) public onlyOwner {
46         require(_newOwner != address(0x0));
47         emit OwnershipTransferred(owner,_newOwner);
48         owner = _newOwner;
49     }
50     
51 }
52 
53 
54 // ----------------------------------------------------------------------------
55 // ERC Token Standard #20 Interface
56 // ----------------------------------------------------------------------------
57 contract ERC20Interface {
58     function totalSupply() public constant returns (uint);
59     function balanceOf(address tokenOwner) public constant returns (uint balance);
60     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
61     function transfer(address to, uint tokens) public returns (bool success);
62     function approve(address spender, uint tokens) public returns (bool success);
63     function transferFrom(address from, address to, uint tokens) public returns (bool success);
64 
65     event Transfer(address indexed from, address indexed to, uint tokens);
66     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
67 }
68 
69 // ----------------------------------------------------------------------------
70 // ERC20 Token, with the addition of symbol, name and decimals and an
71 // initial fixed supply
72 // ----------------------------------------------------------------------------
73 contract Hydra is ERC20Interface, Owned {
74     
75     using SafeMath for uint;
76 
77     string public symbol;
78     string public  name;
79     uint8 public decimals;
80     uint public _totalSupply;
81     uint public RATE;
82     uint public DENOMINATOR;
83     bool public isStopped = false;
84 
85     mapping(address => uint) balances;
86     mapping(address => mapping(address => uint)) allowed;
87     
88     event Mint(address indexed to, uint256 amount);
89     event ChangeRate(uint256 amount);
90     
91     modifier onlyWhenRunning {
92         require(!isStopped);
93         _;
94     }
95 
96 
97     // ------------------------------------------------------------------------
98     // Constructor
99     // ------------------------------------------------------------------------
100     constructor() public {
101         symbol = "HDA";
102         name = "Hydra";
103         decimals = 18;
104         _totalSupply = 21000000000000 * 10**uint(decimals);
105         balances[owner] = _totalSupply;
106         RATE = 5260000; // 1 ETH = 526 HDA // 1 HDA = 0.380 USD
107         DENOMINATOR = 10000;
108         emit Transfer(address(0), owner, _totalSupply);
109     }
110     
111     
112     // ----------------------------------------------------------------------------
113     // It invokes when someone sends ETH to this contract address
114     // requires enough gas for execution
115     // ----------------------------------------------------------------------------
116     function() public payable {
117         buyTokens();
118     }
119     
120     
121     // ----------------------------------------------------------------------------
122     // Function to handle eth and token transfers
123     // tokens are transferred to user
124     // ETH are transferred to current owner
125     // ----------------------------------------------------------------------------
126     function buyTokens() onlyWhenRunning public payable {
127         require(msg.value > 0);
128         
129         uint tokens = msg.value.mul(RATE).div(DENOMINATOR);
130         require(balances[owner] >= tokens);
131         
132         balances[msg.sender] = balances[msg.sender].add(tokens);
133         balances[owner] = balances[owner].sub(tokens);
134         
135         emit Transfer(owner, msg.sender, tokens);
136         
137         owner.transfer(msg.value);
138     }
139     
140     
141     // ------------------------------------------------------------------------
142     // Total supply
143     // ------------------------------------------------------------------------
144     function totalSupply() public view returns (uint) {
145         return _totalSupply;
146     }
147 
148 
149     // ------------------------------------------------------------------------
150     // Get the token balance for account `tokenOwner`
151     // ------------------------------------------------------------------------
152     function balanceOf(address tokenOwner) public view returns (uint balance) {
153         return balances[tokenOwner];
154     }
155 
156 
157     // ------------------------------------------------------------------------
158     // Transfer the balance from token owner's account to `to` account
159     // - Owner's account must have sufficient balance to transfer
160     // - 0 value transfers are allowed
161     // ------------------------------------------------------------------------
162     function transfer(address to, uint tokens) public returns (bool success) {
163         require(to != address(0));
164         require(tokens > 0);
165         require(balances[msg.sender] >= tokens);
166         
167         balances[msg.sender] = balances[msg.sender].sub(tokens);
168         balances[to] = balances[to].add(tokens);
169         emit Transfer(msg.sender, to, tokens);
170         return true;
171     }
172 
173 
174     // ------------------------------------------------------------------------
175     // Token owner can approve for `spender` to transferFrom(...) `tokens`
176     // from the token owner's account
177     //
178     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
179     // recommends that there are no checks for the approval double-spend attack
180     // as this should be implemented in user interfaces 
181     // ------------------------------------------------------------------------
182     function approve(address spender, uint tokens) public returns (bool success) {
183         require(spender != address(0));
184         require(tokens > 0);
185         
186         allowed[msg.sender][spender] = tokens;
187         emit Approval(msg.sender, spender, tokens);
188         return true;
189     }
190 
191 
192     // ------------------------------------------------------------------------
193     // Transfer `tokens` from the `from` account to the `to` account
194     // 
195     // The calling account must already have sufficient tokens approve(...)-d
196     // for spending from the `from` account and
197     // - From account must have sufficient balance to transfer
198     // - Spender must have sufficient allowance to transfer
199     // ------------------------------------------------------------------------
200     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
201         require(from != address(0));
202         require(to != address(0));
203         require(tokens > 0);
204         require(balances[from] >= tokens);
205         require(allowed[from][msg.sender] >= tokens);
206         
207         balances[from] = balances[from].sub(tokens);
208         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
209         balances[to] = balances[to].add(tokens);
210         emit Transfer(from, to, tokens);
211         return true;
212     }
213 
214 
215     // ------------------------------------------------------------------------
216     // Returns the amount of tokens approved by the owner that can be
217     // transferred to the spender's account
218     // ------------------------------------------------------------------------
219     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
220         return allowed[tokenOwner][spender];
221     }
222     
223     
224     // ------------------------------------------------------------------------
225     // Increase the amount of tokens that an owner allowed to a spender.
226     //
227     // approve should be called when allowed[_spender] == 0. To increment
228     // allowed value is better to use this function to avoid 2 calls (and wait until
229     // the first transaction is mined)
230     // _spender The address which will spend the funds.
231     // _addedValue The amount of tokens to increase the allowance by.
232     // ------------------------------------------------------------------------
233     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
234         require(_spender != address(0));
235         
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
248     // _spender The address which will spend the funds.
249     // _subtractedValue The amount of tokens to decrease the allowance by.
250     // ------------------------------------------------------------------------
251     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
252         require(_spender != address(0));
253         
254         uint oldValue = allowed[msg.sender][_spender];
255         if (_subtractedValue > oldValue) {
256             allowed[msg.sender][_spender] = 0;
257         } else {
258             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
259         }
260         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
261         return true;
262     }
263     
264     
265     // ------------------------------------------------------------------------
266     // Change the ETH to IO rate
267     // ------------------------------------------------------------------------
268     function changeRate(uint256 _rate) public onlyOwner {
269         require(_rate > 0);
270         
271         RATE =_rate;
272         emit ChangeRate(_rate);
273     }
274     
275     
276     // ------------------------------------------------------------------------
277     // Function to mint tokens
278     // _to The address that will receive the minted tokens.
279     // _amount The amount of tokens to mint.
280     // A boolean that indicates if the operation was successful.
281     // ------------------------------------------------------------------------
282     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
283         require(_to != address(0));
284         require(_amount > 0);
285         
286         uint newamount = _amount * 10**uint(decimals);
287         _totalSupply = _totalSupply.add(newamount);
288         balances[_to] = balances[_to].add(newamount);
289         
290         emit Mint(_to, newamount);
291         emit Transfer(address(0), _to, newamount);
292         return true;
293     }
294     
295     
296     // ------------------------------------------------------------------------
297     // function to stop the ICO
298     // ------------------------------------------------------------------------
299     function stopICO() onlyOwner public {
300         isStopped = true;
301     }
302     
303     
304     // ------------------------------------------------------------------------
305     // function to resume ICO
306     // ------------------------------------------------------------------------
307     function resumeICO() onlyOwner public {
308         isStopped = false;
309     }
310 
311 }