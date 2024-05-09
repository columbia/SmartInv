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
22 
23 // ----------------------------------------------------------------------------
24 // Ownership contract
25 // _newOwner is address of new owner
26 // ----------------------------------------------------------------------------
27 contract Owned {
28     
29     address public owner;
30 
31     event OwnershipTransferred(address indexed _from, address indexed _to);
32 
33     constructor() public {
34         owner = 0xF0162004218D873562001aAF6247e800D1701531;
35     }
36 
37     modifier onlyOwner {
38         require(msg.sender == owner);
39         _;
40     }
41 
42     // transfer Ownership to other address
43     function transferOwnership(address _newOwner) public onlyOwner {
44         require(_newOwner != address(0x0));
45         emit OwnershipTransferred(owner,_newOwner);
46         owner = _newOwner;
47     }
48     
49 }
50 
51 
52 // ----------------------------------------------------------------------------
53 // ERC Token Standard #20 Interface
54 // ----------------------------------------------------------------------------
55 contract ERC20Interface {
56     function totalSupply() public constant returns (uint);
57     function balanceOf(address tokenOwner) public constant returns (uint balance);
58     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
59     function transfer(address to, uint tokens) public returns (bool success);
60     function approve(address spender, uint tokens) public returns (bool success);
61     function transferFrom(address from, address to, uint tokens) public returns (bool success);
62 
63     event Transfer(address indexed from, address indexed to, uint tokens);
64     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
65 }
66 
67 // ----------------------------------------------------------------------------
68 // ERC20 Token, with the addition of symbol, name and decimals and an
69 // initial fixed supply
70 // ----------------------------------------------------------------------------
71 contract MNET_Token is ERC20Interface, Owned {
72     
73     using SafeMath for uint;
74 
75     string public symbol;
76     string public  name;
77     uint8 public decimals;
78     uint public _totalSupply;
79     uint public RATE;
80     uint public DENOMINATOR;
81     bool public isStopped = false;
82 
83     mapping(address => uint) balances;
84     mapping(address => mapping(address => uint)) allowed;
85     
86     event Mint(address indexed to, uint256 amount);
87     event ChangeRate(uint256 amount);
88     
89     modifier onlyWhenRunning {
90         require(!isStopped);
91         _;
92     }
93 
94 
95     // ------------------------------------------------------------------------
96     // Constructor
97     // ------------------------------------------------------------------------
98     constructor() public {
99         symbol = "MNET";
100         name = "MNET Token";
101         decimals = 18;
102         _totalSupply = 250000000 * 10**uint(decimals);
103         balances[owner] = _totalSupply;
104          RATE = 1484840000; // 1 ETH = 148484 MNET // 1 MNET = 0.00165 USD
105         DENOMINATOR = 10000;
106         emit Transfer(address(0), owner, _totalSupply);
107     }
108     
109     
110     // ----------------------------------------------------------------------------
111     // It invokes when someone sends ETH to this contract address
112     // requires enough gas for execution
113     // ----------------------------------------------------------------------------
114     function() public payable {
115         
116         buyTokens();
117     }
118     
119     
120     // ----------------------------------------------------------------------------
121     // Function to handle eth and token transfers
122     // tokens are transferred to user
123     // ETH are transferred to current owner
124     // ----------------------------------------------------------------------------
125     function buyTokens() onlyWhenRunning public payable {
126         require(msg.value > 0);
127         
128         uint tokens = msg.value.mul(RATE).div(DENOMINATOR);
129         require(balances[owner] >= tokens);
130         
131         balances[msg.sender] = balances[msg.sender].add(tokens);
132         balances[owner] = balances[owner].sub(tokens);
133         
134         emit Transfer(owner, msg.sender, tokens);
135         
136         owner.transfer(msg.value);
137     }
138     
139     
140     // ------------------------------------------------------------------------
141     // Total supply
142     // ------------------------------------------------------------------------
143     function totalSupply() public view returns (uint) {
144         return _totalSupply;
145     }
146 
147 
148     // ------------------------------------------------------------------------
149     // Get the token balance for account `tokenOwner`
150     // ------------------------------------------------------------------------
151     function balanceOf(address tokenOwner) public view returns (uint balance) {
152         return balances[tokenOwner];
153     }
154 
155 
156     // ------------------------------------------------------------------------
157     // Transfer the balance from token owner's account to `to` account
158     // - Owner's account must have sufficient balance to transfer
159     // - 0 value transfers are allowed
160     // ------------------------------------------------------------------------
161     function transfer(address to, uint tokens) public returns (bool success) {
162         require(to != address(0));
163         require(tokens > 0);
164         require(balances[msg.sender] >= tokens);
165         
166         balances[msg.sender] = balances[msg.sender].sub(tokens);
167         balances[to] = balances[to].add(tokens);
168         emit Transfer(msg.sender, to, tokens);
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
181     function approve(address spender, uint tokens) public returns (bool success) {
182         require(spender != address(0));
183         require(tokens > 0);
184         
185         allowed[msg.sender][spender] = tokens;
186         emit Approval(msg.sender, spender, tokens);
187         return true;
188     }
189 
190 
191     // ------------------------------------------------------------------------
192     // Transfer `tokens` from the `from` account to the `to` account
193     // 
194     // The calling account must already have sufficient tokens approve(...)-d
195     // for spending from the `from` account and
196     // - From account must have sufficient balance to transfer
197     // - Spender must have sufficient allowance to transfer
198     // ------------------------------------------------------------------------
199     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
200         require(from != address(0));
201         require(to != address(0));
202         require(tokens > 0);
203         require(balances[from] >= tokens);
204         require(allowed[from][msg.sender] >= tokens);
205         
206         balances[from] = balances[from].sub(tokens);
207         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
208         balances[to] = balances[to].add(tokens);
209         emit Transfer(from, to, tokens);
210         return true;
211     }
212 
213 
214     // ------------------------------------------------------------------------
215     // Returns the amount of tokens approved by the owner that can be
216     // transferred to the spender's account
217     // ------------------------------------------------------------------------
218     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
219         return allowed[tokenOwner][spender];
220     }
221     
222     
223     // ------------------------------------------------------------------------
224     // Increase the amount of tokens that an owner allowed to a spender.
225     //
226     // approve should be called when allowed[_spender] == 0. To increment
227     // allowed value is better to use this function to avoid 2 calls (and wait until
228     // the first transaction is mined)
229     // _spender The address which will spend the funds.
230     // _addedValue The amount of tokens to increase the allowance by.
231     // ------------------------------------------------------------------------
232     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
233         require(_spender != address(0));
234         
235         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
236         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237         return true;
238     }
239     
240     
241     // ------------------------------------------------------------------------
242     // Decrease the amount of tokens that an owner allowed to a spender.
243     //
244     // approve should be called when allowed[_spender] == 0. To decrement
245     // allowed value is better to use this function to avoid 2 calls (and wait until
246     // the first transaction is mined)
247     // _spender The address which will spend the funds.
248     // _subtractedValue The amount of tokens to decrease the allowance by.
249     // ------------------------------------------------------------------------
250     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
251         require(_spender != address(0));
252         
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
265     // Change the ETH to IO rate
266     // ------------------------------------------------------------------------
267     function changeRate(uint256 _rate) public onlyOwner {
268         require(_rate > 0);
269         
270         RATE =_rate;
271         emit ChangeRate(_rate);
272     }
273     
274     
275     // ------------------------------------------------------------------------
276     // Function to mint tokens
277     // _to The address that will receive the minted tokens.
278     // _amount The amount of tokens to mint.
279     // A boolean that indicates if the operation was successful.
280     // ------------------------------------------------------------------------
281     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
282         require(_to != address(0));
283         require(_amount > 0);
284         
285         uint newamount = _amount * 10**uint(decimals);
286         _totalSupply = _totalSupply.add(newamount);
287         balances[_to] = balances[_to].add(newamount);
288         
289         emit Mint(_to, newamount);
290         emit Transfer(address(0), _to, newamount);
291         return true;
292     }
293     
294     
295     // ------------------------------------------------------------------------
296     // function to stop the ICO
297     // ------------------------------------------------------------------------
298     function stopICO() onlyOwner public {
299         isStopped = true;
300     }
301     
302     
303     // ------------------------------------------------------------------------
304     // function to resume ICO
305     // ------------------------------------------------------------------------
306     function resumeICO() onlyOwner public {
307         isStopped = false;
308     }
309 
310 }