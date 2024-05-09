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
30     address public liquidityOwner;
31     address public teamOwner;
32     address public marketingOwner;
33     address public platformOwner;
34 
35     event OwnershipTransferred(address indexed _from, address indexed _to);
36 
37     constructor() public {
38         owner = 0x8f75E4E6110F5112E37B260B3644473cc2085d71;
39         liquidityOwner = 0x38676A1d8C2Be34a80BF030C8D5b559a662893C3;
40         teamOwner = 0xd44123dBa5068ca9f43475ec623Fe1E58909844C;
41         marketingOwner = 0xD68A6eC85ed26Ab35849a2030Af6566be1dec30A;
42         platformOwner = 0xeB1E1a490c973Df9f9e2B925cD0f75Dcb33Af40d;
43 
44     }
45 
46     modifier onlyOwner {
47         require(msg.sender == owner);
48         _;
49     }
50 
51     // transfer Ownership to other address
52     function transferOwnership(address _newOwner) public onlyOwner {
53         require(_newOwner != address(0x0));
54         emit OwnershipTransferred(owner,_newOwner);
55         owner = _newOwner;
56     }
57     
58 }
59 
60 
61 // ----------------------------------------------------------------------------
62 // ERC Token Standard #20 Interface
63 // ----------------------------------------------------------------------------
64 contract ERC20Interface {
65     function totalSupply() public constant returns (uint);
66     function balanceOf(address tokenOwner) public constant returns (uint balance);
67     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
68     function transfer(address to, uint tokens) public returns (bool success);
69     function approve(address spender, uint tokens) public returns (bool success);
70     function transferFrom(address from, address to, uint tokens) public returns (bool success);
71 
72     event Transfer(address indexed from, address indexed to, uint tokens);
73     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
74 }
75 
76 // ----------------------------------------------------------------------------
77 // ERC20 Token, with the addition of symbol, name and decimals and an
78 // initial fixed supply
79 // Max Supply:  390000000
80 // ICO : 150000000 
81 // Liquidity : 70000000
82 // Team : 20000000  
83 // Marketing: 10000000
84 // Platform :  140000000   
85 
86 // ----------------------------------------------------------------------------
87 contract SatoPay is ERC20Interface, Owned {
88     
89     using SafeMath for uint;
90 
91     string public symbol;
92     string public  name;
93     uint8 public decimals;
94     uint public _totalSupply;
95     uint public icoSupply;
96 	uint public liquiditySupply;
97     uint public teamSupply;
98     uint public marketingSupply;
99     uint public platformSupply;
100     uint public RATE;
101     bool public isStopped = false;
102 
103     mapping(address => uint) balances;
104 	mapping(address => uint) buylimit;
105     mapping(address => mapping(address => uint)) allowed;
106     
107     event Mint(address indexed to, uint256 amount);
108     event ChangeRate(uint256 amount);
109     
110     modifier onlyWhenRunning {
111         require(!isStopped);
112         _;
113     }
114 
115 
116     // ------------------------------------------------------------------------
117     // Constructor
118     // ------------------------------------------------------------------------
119     constructor() public {
120         symbol = "STOP";
121         name = "SatoPay";
122         decimals = 18;
123         _totalSupply = 390000000 * 10**uint(decimals);
124         icoSupply = 150000000 * 10**uint(decimals);
125 		liquiditySupply = 70000000 * 10**uint(decimals);
126         teamSupply = 20000000 * 10**uint(decimals);
127         marketingSupply = 10000000 * 10**uint(decimals);
128         platformSupply = 140000000 * 10**uint(decimals);
129 
130         
131         balances[owner] = icoSupply;
132         balances[liquidityOwner] = liquiditySupply;
133         balances[teamOwner] = teamSupply;
134         balances[marketingOwner] = marketingSupply;
135         balances[platformOwner] = platformSupply;
136 
137       
138         RATE = 100000; // 1 ETH = 100000 STOP 
139         
140         emit Transfer(address(0), owner, icoSupply);
141         emit Transfer(address(0), liquidityOwner, liquiditySupply);
142         emit Transfer(address(0), teamOwner, teamSupply);
143         emit Transfer(address(0), marketingOwner, marketingSupply);
144         emit Transfer(address(0), platformOwner, platformSupply);
145 
146     }
147     
148     
149     // ----------------------------------------------------------------------------
150     // It invokes when someone sends ETH to this contract address
151     // requires enough gas for execution
152     // ----------------------------------------------------------------------------
153     function() public payable {
154         
155         buyTokens();
156     }
157     
158     
159     // ----------------------------------------------------------------------------
160     // Function to handle eth and token transfers
161     // tokens are transferred to user
162     // ETH are transferred to current owner
163     // ----------------------------------------------------------------------------
164     function buyTokens() onlyWhenRunning public payable {
165         require(msg.value > 0);
166         
167         uint tokens = msg.value.mul(RATE);
168         require(balances[owner] >= tokens);
169         require(buylimit[msg.sender].add(msg.value) <= 25 ether, "Maximum 25 eth allowed for Buy");
170        
171 		
172         balances[msg.sender] = balances[msg.sender].add(tokens);
173         balances[owner] = balances[owner].sub(tokens);
174         buylimit[msg.sender]=buylimit[msg.sender].add(msg.value);
175         emit Transfer(owner, msg.sender, tokens);
176         
177         owner.transfer(msg.value);
178     }
179     
180     
181     // ------------------------------------------------------------------------
182     // Total supply
183     // ------------------------------------------------------------------------
184     function totalSupply() public view returns (uint) {
185         return _totalSupply;
186     }
187 
188 
189     // ------------------------------------------------------------------------
190     // Get the token balance for account `tokenOwner`
191     // ------------------------------------------------------------------------
192     function balanceOf(address tokenOwner) public view returns (uint balance) {
193         return balances[tokenOwner];
194     }
195 
196 
197     // ------------------------------------------------------------------------
198     // Transfer the balance from token owner's account to `to` account
199     // - Owner's account must have sufficient balance to transfer
200     // - 0 value transfers are allowed
201     // ------------------------------------------------------------------------
202     function transfer(address to, uint tokens) public returns (bool success) {
203         require(to != address(0));
204         require(tokens > 0);
205         require(balances[msg.sender] >= tokens);
206         
207         balances[msg.sender] = balances[msg.sender].sub(tokens);
208         balances[to] = balances[to].add(tokens);
209         emit Transfer(msg.sender, to, tokens);
210         return true;
211     }
212 
213 
214     // ------------------------------------------------------------------------
215     // Token owner can approve for `spender` to transferFrom(...) `tokens`
216     // from the token owner's account
217     //
218     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
219     // recommends that there are no checks for the approval double-spend attack
220     // as this should be implemented in user interfaces 
221     // ------------------------------------------------------------------------
222     function approve(address spender, uint tokens) public returns (bool success) {
223         require(spender != address(0));
224         require(tokens > 0);
225         
226         allowed[msg.sender][spender] = tokens;
227         emit Approval(msg.sender, spender, tokens);
228         return true;
229     }
230 
231 
232     // ------------------------------------------------------------------------
233     // Transfer `tokens` from the `from` account to the `to` account
234     // 
235     // The calling account must already have sufficient tokens approve(...)-d
236     // for spending from the `from` account and
237     // - From account must have sufficient balance to transfer
238     // - Spender must have sufficient allowance to transfer
239     // ------------------------------------------------------------------------
240     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
241         require(from != address(0));
242         require(to != address(0));
243         require(tokens > 0);
244         require(balances[from] >= tokens);
245         require(allowed[from][msg.sender] >= tokens);
246         
247         balances[from] = balances[from].sub(tokens);
248         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
249         balances[to] = balances[to].add(tokens);
250         emit Transfer(from, to, tokens);
251         return true;
252     }
253 
254 
255     // ------------------------------------------------------------------------
256     // Returns the amount of tokens approved by the owner that can be
257     // transferred to the spender's account
258     // ------------------------------------------------------------------------
259     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
260         return allowed[tokenOwner][spender];
261     }
262     
263     
264     // ------------------------------------------------------------------------
265     // Increase the amount of tokens that an owner allowed to a spender.
266     //
267     // approve should be called when allowed[_spender] == 0. To increment
268     // allowed value is better to use this function to avoid 2 calls (and wait until
269     // the first transaction is mined)
270     // _spender The address which will spend the funds.
271     // _addedValue The amount of tokens to increase the allowance by.
272     // ------------------------------------------------------------------------
273     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
274         require(_spender != address(0));
275         
276         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
277         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
278         return true;
279     }
280     
281     
282     // ------------------------------------------------------------------------
283     // Decrease the amount of tokens that an owner allowed to a spender.
284     //
285     // approve should be called when allowed[_spender] == 0. To decrement
286     // allowed value is better to use this function to avoid 2 calls (and wait until
287     // the first transaction is mined)
288     // _spender The address which will spend the funds.
289     // _subtractedValue The amount of tokens to decrease the allowance by.
290     // ------------------------------------------------------------------------
291     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
292         require(_spender != address(0));
293         
294         uint oldValue = allowed[msg.sender][_spender];
295         if (_subtractedValue > oldValue) {
296             allowed[msg.sender][_spender] = 0;
297         } else {
298             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
299         }
300         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
301         return true;
302     }
303     
304     
305     // ------------------------------------------------------------------------
306     // Change the ETH to IO rate
307     // ------------------------------------------------------------------------
308     function changeRate(uint256 _rate) public onlyOwner {
309         require(_rate > 0);
310         
311         RATE =_rate;
312         emit ChangeRate(_rate);
313     }
314     
315     
316     // ------------------------------------------------------------------------
317     // Function to mint tokens
318     // _to The address that will receive the minted tokens.
319     // _amount The amount of tokens to mint.
320     // A boolean that indicates if the operation was successful.
321     // ------------------------------------------------------------------------
322     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
323         require(_to != address(0));
324         require(_amount > 0);
325         
326         uint newamount = _amount * 10**uint(decimals);
327         _totalSupply = _totalSupply.add(newamount);
328         balances[_to] = balances[_to].add(newamount);
329         
330         emit Mint(_to, newamount);
331         emit Transfer(address(0), _to, newamount);
332         return true;
333     }
334     
335     
336     // ------------------------------------------------------------------------
337     // function to stop the ICO
338     // ------------------------------------------------------------------------
339     function stopICO() onlyOwner public {
340         isStopped = true;
341     }
342     
343     
344     // ------------------------------------------------------------------------
345     // function to resume ICO
346     // ------------------------------------------------------------------------
347     function resumeICO() onlyOwner public {
348         isStopped = false;
349     }
350 
351 }