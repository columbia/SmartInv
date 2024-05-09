1 pragma solidity ^0.4.24;
2 
3 
4 // 'CAIZCOIN' Smart Contract
5 //
6 // OwnerAddress : 0xfd413f4BC3A72907Bc829Da1622F087b4E5B038d
7 // Symbol       : CAIZ
8 // Name         : CAIZCOIN
9 // Total Supply : 99,999,999 CAIZ
10 // Decimals     : 18
11 //
12 // Copyrights of 'CAIZCOIN' With 'CAIZ' Symbol JANUARY 06, 2021.
13 // The MIT Licence.
14 // 
15 // Prepared and Compiled by: https://bit.ly/3ixlO2e
16 //
17 // ----------------------------------------------------------------------------
18 
19 library SafeMath {
20     function add(uint a, uint b) internal pure returns (uint c) {
21         c = a + b;
22         require(c >= a);
23     }
24     function sub(uint a, uint b) internal pure returns (uint c) {
25         require(b <= a);
26         c = a - b;
27     }
28     function mul(uint a, uint b) internal pure returns (uint c) {
29         c = a * b;
30         require(a == 0 || c / a == b);
31     }
32     function div(uint a, uint b) internal pure returns (uint c) {
33         require(b > 0);
34         c = a / b;
35     }
36 }
37 
38 
39 // ----------------------------------------------------------------------------
40 // Ownership contract
41 // _newOwner is address of new owner
42 // ----------------------------------------------------------------------------
43 contract Owned {
44     
45     address public owner;
46 
47     event OwnershipTransferred(address indexed _from, address indexed _to);
48 
49     constructor() public {
50         owner = 0xfd413f4BC3A72907Bc829Da1622F087b4E5B038d;
51     }
52 
53     modifier onlyOwner {
54         require(msg.sender == owner);
55         _;
56     }
57 
58     // transfer Ownership to other address
59     function transferOwnership(address _newOwner) public onlyOwner {
60         require(_newOwner != address(0x0));
61         emit OwnershipTransferred(owner,_newOwner);
62         owner = _newOwner;
63     }
64     
65 }
66 
67 
68 // ----------------------------------------------------------------------------
69 // ERC Token Standard #20 Interface
70 // ----------------------------------------------------------------------------
71 contract ERC20Interface {
72     function totalSupply() public constant returns (uint);
73     function balanceOf(address tokenOwner) public constant returns (uint balance);
74     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
75     function transfer(address to, uint tokens) public returns (bool success);
76     function approve(address spender, uint tokens) public returns (bool success);
77     function transferFrom(address from, address to, uint tokens) public returns (bool success);
78 
79     event Transfer(address indexed from, address indexed to, uint tokens);
80     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
81 }
82 
83 // ----------------------------------------------------------------------------
84 // ERC20 Token, with the addition of symbol, name and decimals and an
85 // initial fixed supply
86 // ----------------------------------------------------------------------------
87 contract CAIZCOIN is ERC20Interface, Owned {
88     
89     using SafeMath for uint;
90 
91     string public symbol;
92     string public  name;
93     uint8 public decimals;
94     uint public _totalSupply;
95     uint public RATE;
96     uint public DENOMINATOR;
97     bool public isStopped = false;
98 
99     mapping(address => uint) balances;
100     mapping(address => mapping(address => uint)) allowed;
101     
102     event Mint(address indexed to, uint256 amount);
103     event ChangeRate(uint256 amount);
104     
105     modifier onlyWhenRunning {
106         require(!isStopped);
107         _;
108     }
109 
110 
111     // ------------------------------------------------------------------------
112     // Constructor
113     // ------------------------------------------------------------------------
114     constructor() public {
115         symbol = "CAIZ";
116         name = "CAIZCOIN";
117         decimals = 18;
118         _totalSupply = 99999999 * 10**uint(decimals);
119         balances[owner] = _totalSupply;
120         RATE = 1200000000; // 1 ETH = 120000 CAIZ 
121         DENOMINATOR = 10000;
122         emit Transfer(address(0), owner, _totalSupply);
123     }
124     
125     
126     // ----------------------------------------------------------------------------
127     // requires enough gas for execution
128     // ----------------------------------------------------------------------------
129     function() public payable {
130         buyTokens();
131     }
132     
133     
134     // ----------------------------------------------------------------------------
135     // Function to handle eth and token transfers
136     // tokens are transferred to user
137     // ETH are transferred to current owner
138     // ----------------------------------------------------------------------------
139     function buyTokens() onlyWhenRunning public payable {
140         require(msg.value > 0);
141         
142         uint tokens = msg.value.mul(RATE).div(DENOMINATOR);
143         require(balances[owner] >= tokens);
144         
145         balances[msg.sender] = balances[msg.sender].add(tokens);
146         balances[owner] = balances[owner].sub(tokens);
147         
148         emit Transfer(owner, msg.sender, tokens);
149         
150         owner.transfer(msg.value);
151     }
152     
153     
154     // ------------------------------------------------------------------------
155     // Total supply
156     // ------------------------------------------------------------------------
157     function totalSupply() public view returns (uint) {
158         return _totalSupply;
159     }
160 
161 
162     // ------------------------------------------------------------------------
163     // Get the token balance for account `tokenOwner`
164     // ------------------------------------------------------------------------
165     function balanceOf(address tokenOwner) public view returns (uint balance) {
166         return balances[tokenOwner];
167     }
168 
169 
170     // ------------------------------------------------------------------------
171     // Transfer the balance from token owner's account to `to` account
172     // - Owner's account must have sufficient balance to transfer
173     // - 0 value transfers are allowed
174     // ------------------------------------------------------------------------
175     function transfer(address to, uint tokens) public returns (bool success) {
176         require(to != address(0));
177         require(tokens > 0);
178         require(balances[msg.sender] >= tokens);
179         
180         balances[msg.sender] = balances[msg.sender].sub(tokens);
181         balances[to] = balances[to].add(tokens);
182         emit Transfer(msg.sender, to, tokens);
183         return true;
184     }
185 
186 
187     // ------------------------------------------------------------------------
188     // Token owner can approve for `spender` to transferFrom(...) `tokens`
189     // from the token owner's account
190     //
191     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
192     // recommends that there are no checks for the approval double-spend attack
193     // as this should be implemented in user interfaces 
194     // ------------------------------------------------------------------------
195     function approve(address spender, uint tokens) public returns (bool success) {
196         require(spender != address(0));
197         require(tokens > 0);
198         
199         allowed[msg.sender][spender] = tokens;
200         emit Approval(msg.sender, spender, tokens);
201         return true;
202     }
203 
204 
205     // ------------------------------------------------------------------------
206     // Transfer `tokens` from the `from` account to the `to` account
207     // 
208     // The calling account must already have sufficient tokens approve(...)-d
209     // for spending from the `from` account and
210     // - From account must have sufficient balance to transfer
211     // - Spender must have sufficient allowance to transfer
212     // ------------------------------------------------------------------------
213     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
214         require(from != address(0));
215         require(to != address(0));
216         require(tokens > 0);
217         require(balances[from] >= tokens);
218         require(allowed[from][msg.sender] >= tokens);
219         
220         balances[from] = balances[from].sub(tokens);
221         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
222         balances[to] = balances[to].add(tokens);
223         emit Transfer(from, to, tokens);
224         return true;
225     }
226 
227 
228     // ------------------------------------------------------------------------
229     // Returns the amount of tokens approved by the owner that can be
230     // transferred to the spender's account
231     // ------------------------------------------------------------------------
232     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
233         return allowed[tokenOwner][spender];
234     }
235     
236     
237     // ------------------------------------------------------------------------
238     // Increase the amount of tokens that an owner allowed to a spender.
239     //
240     // approve should be called when allowed[_spender] == 0. To increment
241     // allowed value is better to use this function to avoid 2 calls (and wait until
242     // the first transaction is mined)
243     // _spender The address which will spend the funds.
244     // _addedValue The amount of tokens to increase the allowance by.
245     // ------------------------------------------------------------------------
246     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
247         require(_spender != address(0));
248         
249         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
250         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251         return true;
252     }
253     
254     
255     // ------------------------------------------------------------------------
256     // Decrease the amount of tokens that an owner allowed to a spender.
257     //
258     // approve should be called when allowed[_spender] == 0. To decrement
259     // allowed value is better to use this function to avoid 2 calls (and wait until
260     // the first transaction is mined)
261     // _spender The address which will spend the funds.
262     // _subtractedValue The amount of tokens to decrease the allowance by.
263     // ------------------------------------------------------------------------
264     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
265         require(_spender != address(0));
266         
267         uint oldValue = allowed[msg.sender][_spender];
268         if (_subtractedValue > oldValue) {
269             allowed[msg.sender][_spender] = 0;
270         } else {
271             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
272         }
273         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
274         return true;
275     }
276     
277     
278     // ------------------------------------------------------------------------
279     // Change the ETH to IO rate
280     // ------------------------------------------------------------------------
281     function changeRate(uint256 _rate) public onlyOwner {
282         require(_rate > 0);
283         
284         RATE =_rate;
285         emit ChangeRate(_rate);
286     }
287     
288     
289     // ------------------------------------------------------------------------
290     // _to The address that will receive the minted tokens.
291     // _amount The amount of tokens to mint.
292     // A boolean that indicates if the operation was successful.
293     // ------------------------------------------------------------------------
294     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
295         require(_to != address(0));
296         require(_amount > 0);
297         
298         uint newamount = _amount * 10**uint(decimals);
299         _totalSupply = _totalSupply.add(newamount);
300         balances[_to] = balances[_to].add(newamount);
301         
302         emit Mint(_to, newamount);
303         emit Transfer(address(0), _to, newamount);
304         return true;
305     }
306     
307     
308     // ------------------------------------------------------------------------
309     // function to stop the ICO
310     // ------------------------------------------------------------------------
311     function stopICO() onlyOwner public {
312         isStopped = true;
313     }
314     
315     
316     // ------------------------------------------------------------------------
317     // function to resume ICO
318     // ------------------------------------------------------------------------
319     function resumeICO() onlyOwner public {
320         isStopped = false;
321     }
322 
323 }