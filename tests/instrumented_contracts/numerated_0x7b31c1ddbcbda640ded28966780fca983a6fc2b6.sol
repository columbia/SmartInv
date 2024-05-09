1 pragma solidity ^0.4.19;
2 
3 // ----------------------------------------------------------------------------
4 // BLOCKCURR ICO Smart contract
5 //
6 // Symbol      : BLCURR
7 // Name        : BLOCKCURR
8 // Total Supply: 55,000,000
9 // Decimals    : 18
10 // RATE        : 100 (1 ETH = 100 BLCURR)
11 // ----------------------------------------------------------------------------
12 
13 
14 // ----------------------------------------------------------------------------
15 // Safe math
16 // ----------------------------------------------------------------------------
17 library SafeMath {
18     function add(uint a, uint b) internal pure returns (uint c) {
19         c = a + b;
20         require(c >= a);
21     }
22     function sub(uint a, uint b) internal pure returns (uint c) {
23         require(b <= a);
24         c = a - b;
25     }
26     function mul(uint a, uint b) internal pure returns (uint c) {
27         c = a * b;
28         require(a == 0 || c / a == b);
29     }
30     function div(uint a, uint b) internal pure returns (uint c) {
31         require(b > 0);
32         c = a / b;
33     }
34 }
35 
36 
37 // ----------------------------------------------------------------------------
38 // Ownership contract
39 // _newOwner is address of new owner
40 // ----------------------------------------------------------------------------
41 contract Owned {
42     
43     address public owner;
44 
45     event OwnershipTransferred(address indexed _from, address indexed _to);
46 
47     function Owned() public {
48         owner = 0x7F8F854350BFc93CebD7B511f9C63b56A86499F2;
49     }
50 
51     modifier onlyOwner {
52         require(msg.sender == owner);
53         _;
54     }
55 
56     // transfer Ownership to other address
57     function transferOwnership(address _newOwner) public onlyOwner {
58         require(_newOwner != address(0x0));
59         emit OwnershipTransferred(owner,_newOwner);
60         owner = _newOwner;
61     }
62     
63 }
64 
65 
66 // ----------------------------------------------------------------------------
67 // ERC Token Standard #20 Interface
68 // ----------------------------------------------------------------------------
69 contract ERC20Interface {
70     function totalSupply() public constant returns (uint);
71     function balanceOf(address tokenOwner) public constant returns (uint balance);
72     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
73     function transfer(address to, uint tokens) public returns (bool success);
74     function approve(address spender, uint tokens) public returns (bool success);
75     function transferFrom(address from, address to, uint tokens) public returns (bool success);
76 
77     event Transfer(address indexed from, address indexed to, uint tokens);
78     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
79 }
80 
81 // ----------------------------------------------------------------------------
82 // ERC20 Token, with the addition of symbol, name and decimals and an
83 // initial fixed supply
84 // ----------------------------------------------------------------------------
85 contract BLOCKCURRICO is ERC20Interface, Owned {
86     
87     using SafeMath for uint;
88 
89     string public symbol;
90     string public  name;
91     uint8 public decimals;
92     uint public _totalSupply;
93     uint public RATE;
94     bool public isStopped = false;
95 
96     mapping(address => uint) balances;
97     mapping(address => mapping(address => uint)) allowed;
98     
99     event Mint(address indexed to, uint256 amount);
100     event ChangeRate(uint256 amount);
101     
102     modifier onlyWhenRunning {
103         require(!isStopped);
104         _;
105     }
106 
107 
108     // ------------------------------------------------------------------------
109     // Constructor
110     // ------------------------------------------------------------------------
111     function BLOCKCURRICO() public {
112         symbol = "BLCURR";
113         name = "BLOCKCURR";
114         decimals = 18;
115         _totalSupply = 55000000 * 10**uint(decimals);
116         balances[owner] = _totalSupply;
117         RATE = 100; // 1 ETH = 100 BLCURR
118         emit Transfer(address(0), owner, _totalSupply);
119     }
120     
121     
122     // ----------------------------------------------------------------------------
123     // It invokes when someone sends ETH to this contract address
124     // requires enough gas for execution
125     // ----------------------------------------------------------------------------
126     function() public payable {
127         buyTokens();
128     }
129     
130     
131     // ----------------------------------------------------------------------------
132     // Function to handle eth and token transfers
133     // tokens are transferred to user
134     // ETH are transferred to current owner
135     // ----------------------------------------------------------------------------
136     function buyTokens() onlyWhenRunning public payable {
137         require(msg.value > 0);
138         
139         uint tokens = msg.value.mul(RATE);
140         require(balances[owner] >= tokens);
141         
142         balances[msg.sender] = balances[msg.sender].add(tokens);
143         balances[owner] = balances[owner].sub(tokens);
144         
145         emit Transfer(owner, msg.sender, tokens);
146         
147         owner.transfer(msg.value);
148     }
149     
150     
151     // ------------------------------------------------------------------------
152     // Total supply
153     // ------------------------------------------------------------------------
154     function totalSupply() public view returns (uint) {
155         return _totalSupply;
156     }
157 
158 
159     // ------------------------------------------------------------------------
160     // Get the token balance for account `tokenOwner`
161     // ------------------------------------------------------------------------
162     function balanceOf(address tokenOwner) public view returns (uint balance) {
163         return balances[tokenOwner];
164     }
165 
166 
167     // ------------------------------------------------------------------------
168     // Transfer the balance from token owner's account to `to` account
169     // - Owner's account must have sufficient balance to transfer
170     // - 0 value transfers are allowed
171     // ------------------------------------------------------------------------
172     function transfer(address to, uint tokens) public returns (bool success) {
173         require(to != address(0));
174         require(tokens > 0);
175         require(balances[msg.sender] >= tokens);
176         
177         balances[msg.sender] = balances[msg.sender].sub(tokens);
178         balances[to] = balances[to].add(tokens);
179         emit Transfer(msg.sender, to, tokens);
180         return true;
181     }
182 
183 
184     // ------------------------------------------------------------------------
185     // Token owner can approve for `spender` to transferFrom(...) `tokens`
186     // from the token owner's account
187     //
188     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
189     // recommends that there are no checks for the approval double-spend attack
190     // as this should be implemented in user interfaces 
191     // ------------------------------------------------------------------------
192     function approve(address spender, uint tokens) public returns (bool success) {
193         require(spender != address(0));
194         require(tokens > 0);
195         
196         allowed[msg.sender][spender] = tokens;
197         emit Approval(msg.sender, spender, tokens);
198         return true;
199     }
200 
201 
202     // ------------------------------------------------------------------------
203     // Transfer `tokens` from the `from` account to the `to` account
204     // 
205     // The calling account must already have sufficient tokens approve(...)-d
206     // for spending from the `from` account and
207     // - From account must have sufficient balance to transfer
208     // - Spender must have sufficient allowance to transfer
209     // ------------------------------------------------------------------------
210     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
211         require(from != address(0));
212         require(to != address(0));
213         require(tokens > 0);
214         require(balances[from] >= tokens);
215         require(allowed[from][msg.sender] >= tokens);
216         
217         balances[from] = balances[from].sub(tokens);
218         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
219         balances[to] = balances[to].add(tokens);
220         emit Transfer(from, to, tokens);
221         return true;
222     }
223 
224 
225     // ------------------------------------------------------------------------
226     // Returns the amount of tokens approved by the owner that can be
227     // transferred to the spender's account
228     // ------------------------------------------------------------------------
229     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
230         return allowed[tokenOwner][spender];
231     }
232     
233     
234     // ------------------------------------------------------------------------
235     // Increase the amount of tokens that an owner allowed to a spender.
236     //
237     // approve should be called when allowed[_spender] == 0. To increment
238     // allowed value is better to use this function to avoid 2 calls (and wait until
239     // the first transaction is mined)
240     // _spender The address which will spend the funds.
241     // _addedValue The amount of tokens to increase the allowance by.
242     // ------------------------------------------------------------------------
243     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
244         require(_spender != address(0));
245         
246         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
247         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248         return true;
249     }
250     
251     
252     // ------------------------------------------------------------------------
253     // Decrease the amount of tokens that an owner allowed to a spender.
254     //
255     // approve should be called when allowed[_spender] == 0. To decrement
256     // allowed value is better to use this function to avoid 2 calls (and wait until
257     // the first transaction is mined)
258     // _spender The address which will spend the funds.
259     // _subtractedValue The amount of tokens to decrease the allowance by.
260     // ------------------------------------------------------------------------
261     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
262         require(_spender != address(0));
263         
264         uint oldValue = allowed[msg.sender][_spender];
265         if (_subtractedValue > oldValue) {
266             allowed[msg.sender][_spender] = 0;
267         } else {
268             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
269         }
270         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
271         return true;
272     }
273     
274     
275     // ------------------------------------------------------------------------
276     // Change the ETH to BLCURR rate
277     // ------------------------------------------------------------------------
278     function changeRate(uint256 _rate) public onlyOwner {
279         require(_rate > 0);
280         
281         RATE =_rate;
282         emit ChangeRate(_rate);
283     }
284     
285     
286     // ------------------------------------------------------------------------
287     // Function to mint tokens
288     // _to The address that will receive the minted tokens.
289     // _amount The amount of tokens to mint.
290     // A boolean that indicates if the operation was successful.
291     // ------------------------------------------------------------------------
292     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
293         require(_to != address(0));
294         require(_amount > 0);
295         
296         uint newamount = _amount * 10**uint(decimals);
297         _totalSupply = _totalSupply.add(newamount);
298         balances[_to] = balances[_to].add(newamount);
299         
300         emit Mint(_to, newamount);
301         emit Transfer(address(0), _to, newamount);
302         return true;
303     }
304     
305     
306     // ------------------------------------------------------------------------
307     // function to stop the ICO
308     // ------------------------------------------------------------------------
309     function stopICO() onlyOwner public {
310         isStopped = true;
311     }
312     
313     
314     // ------------------------------------------------------------------------
315     // function to resume ICO
316     // ------------------------------------------------------------------------
317     function resumeICO() onlyOwner public {
318         isStopped = false;
319     }
320 
321 }