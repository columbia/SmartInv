1 pragma solidity ^0.4.17;
2 
3 // ERC Token Standard #20 Interface
4 interface ERC20 {
5     // Get the total token supply
6     function totalSupply() public constant returns (uint _totalSupply);
7     // Get the account balance of another account with address _owner
8     function balanceOf(address _owner) public constant returns (uint balance);
9     // Send _value amount of tokens to address _to
10     function transfer(address _to, uint _value) public returns (bool success);
11     // Send _value amount of tokens from address _from to address _to
12     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
13     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
14     // If this function is called again it overwrites the current allowance with _value.
15     // this function is required for some DEX functionality
16     function approve(address _spender, uint _value) public returns (bool success);
17     // Returns the amount which _spender is still allowed to withdraw from _owner
18     function allowance(address _owner, address _spender) public constant returns (uint remaining);
19     // Triggered when tokens are transferred.
20     event Transfer(address indexed _from, address indexed _to, uint _value);
21     // Triggered whenever approve(address _spender, uint256 _value) is called.
22     event Approval(address indexed _owner, address indexed _spender, uint _value);
23 }
24 
25 
26 
27 contract OnePay is ERC20 {
28 
29     // Token basic information
30     string public constant name = "OnePay";
31     string public constant symbol = "1PAY";
32     uint256 public constant decimals = 18;
33 
34     // Director address
35     address public director;
36 
37     // Balances for each account
38     mapping(address => uint256) balances;
39 
40     // Owner of account approves the transfer of an amount to another account
41     mapping(address => mapping(address => uint256)) allowed;
42 
43     // Public sale control
44     bool public saleClosed;
45     uint256 public currentSalePhase;
46     uint256 public SALE = 9090;  // Pre-Sale tokens per eth
47     uint256 public PRE_SALE = 16667; // Sale tokens per eth
48 
49     // Total supply of tokens
50     uint256 public totalSupply;
51 
52     // Total funds received
53     uint256 public totalReceived;
54 
55     // Total amount of coins minted
56     uint256 public mintedCoins;
57 
58     // Hard Cap for the sale
59     uint256 public hardCapSale;
60 
61     // Token Cap
62     uint256 public tokenCap;
63 
64     /**
65       * Functions with this modifier can only be executed by the owner
66       */
67     modifier onlyDirector()
68     {
69         assert(msg.sender == director);
70         _;
71     }
72 
73     /**
74       * Constructor
75       */
76     function OnePay() public
77     {
78         // Create the initial director
79         director = msg.sender;
80 
81         // setting the hardCap for sale
82         hardCapSale = 100000000 * 10 ** uint256(decimals);
83 
84         // token Cap
85         tokenCap = 500000000 * 10 ** uint256(decimals);
86 
87         // Set the total supply
88         totalSupply = 0;
89 
90         // Initial sale phase is presale
91         currentSalePhase = PRE_SALE;
92 
93         // total coins minted so far
94         mintedCoins = 0;
95 
96         // total funds raised
97         totalReceived = 0;
98 
99         saleClosed = true;
100     }
101 
102     /**
103       * Fallback function to be invoked when a value is sent without a function call.
104       */
105     function() public payable
106     {
107                 // Make sure the sale is active
108         require(!saleClosed);
109 
110         // Minimum amount is 0.02 eth
111         require(msg.value >= 0.02 ether);
112 
113         // If 1500 eth is received switch the sale price
114         if (totalReceived >= 1500 ether) {
115             currentSalePhase = SALE;
116         }
117 
118         uint256 c = mul(msg.value, currentSalePhase);
119 
120         // Calculate tokens to mint based on the "current sale phase"
121         uint256 amount = c;
122 
123         // Make sure that mintedCoins don't exceed the hardcap sale
124         require(mintedCoins + amount <= hardCapSale);
125 
126         // Check for totalSupply max amount
127         balances[msg.sender] += amount;
128 
129         // Increase the number of minted coins
130         mintedCoins += amount;
131 
132         //Increase totalSupply by amount
133         totalSupply += amount;
134 
135         // Track of total value received
136         totalReceived += msg.value;
137 
138         Transfer(this, msg.sender, amount);
139     }
140 
141     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
142         uint256 c = a * b;
143         require(a == 0 || c / a == b);
144         return c;
145     }
146 
147     function div(uint256 a, uint256 b) internal pure returns (uint256) {
148         assert(b > 0); // Solidity automatically throws when dividing by 0
149         uint256 c = a / b;
150         assert(a == b * c + a % b); // There is no case in which this doesn't hold
151         return c;
152     }
153 
154     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
155         assert(b <= a);
156         return a - b;
157     }
158 
159     function add(uint256 a, uint256 b) internal pure returns (uint256) {
160         uint256 c = a + b;
161         assert(c >= a);
162         return c;
163     }
164 
165     /**
166       * Get Tokens for the company
167       */
168     function getCompanyToken(uint256 amount) public onlyDirector returns (bool success)
169     {
170         amount = amount * 10 ** uint256(decimals);
171 
172         require((totalSupply + amount) <= tokenCap);
173 
174         balances[director] = amount;
175 
176         totalSupply += amount;
177 
178         return true;
179     }
180 
181     /**
182 	  * Lock the crowdsale
183 	  */
184     function closeSale() public onlyDirector returns (bool success)
185     {
186         saleClosed = true;
187         return true;
188     }
189 
190     /**
191       * Unlock the crowd sale.
192       */
193     function openSale() public onlyDirector returns (bool success)
194     {
195         saleClosed = false;
196         return true;
197     }
198 
199     /**
200       * Set the price to pre-sale
201       */
202     function setPriceToPreSale() public onlyDirector returns (bool success)
203     {
204         currentSalePhase = PRE_SALE;
205         return true;
206     }
207 
208     /**
209       * Set the price to reg sale.
210       */
211     function setPriceToRegSale() public onlyDirector returns (bool success)
212     {
213         currentSalePhase = SALE;
214         return true;
215     }
216 
217     /**
218       * Withdraw funds from the contract
219       */
220     function withdrawFunds() public
221     {
222         director.transfer(this.balance);
223     }
224 
225     /**
226       * Transfers the director to a new address
227       */
228     function transferDirector(address newDirector) public onlyDirector
229     {
230         director = newDirector;
231     }
232 
233     /**
234       * Returns total
235       */
236     function totalSupply() public view returns (uint256)
237     {
238         return totalSupply;
239     }
240 
241     /**
242       * Balance of a particular account
243       */
244     function balanceOf(address _owner) public constant returns (uint256)
245     {
246         return balances[_owner];
247     }
248 
249     function transfer(address _to, uint256 _value) public returns (bool success) {
250 
251         // Make sure the sender has enough value in their account
252         require(balances[msg.sender] >= _value && _value > 0);
253         // Subtract value from sender's account
254         balances[msg.sender] = balances[msg.sender] - _value;
255 
256         // Add value to receiver's account
257         balances[_to] = add(balances[_to], _value);
258 
259         // Log
260         Transfer(msg.sender, _to, _value);
261         return true;
262     }
263 
264     /**
265       * Allow spender to spend the value amount on your behalf.
266       * If this function is called again it overwrites the current allowance with _value.
267       */
268     function approve(address _spender, uint256 _value) public returns (bool)
269     {
270         allowed[msg.sender][_spender] = _value;
271         Approval(msg.sender, _spender, _value);
272         return true;
273     }
274 
275     /**
276       * Spend value from a different account granted you have allowance to use the value amount.
277       * If this function is called again it overwrites the current allowance with _value.
278       */
279     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)
280     {
281         require(allowed[_from][msg.sender] >= _value && balances[_from] >= _value && _value > 0);
282         balances[_from] = balances[_from] - _value;
283         balances[_to] = add(balances[_to], _value);
284         allowed[_from][msg.sender] = sub(allowed[_from][msg.sender], _value);
285 
286         Transfer(_from, _to, _value);
287         return true;
288     }
289 
290     /**
291       * Returns the amount which _spender is still allowed to withdraw from _owner
292       */
293     function allowance(address _owner, address _spender) public constant returns (uint256)
294     {
295         return allowed[_owner][_spender];
296     }
297 
298     event Transfer(address indexed _from, address indexed _to, uint256 _value);
299     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
300 }