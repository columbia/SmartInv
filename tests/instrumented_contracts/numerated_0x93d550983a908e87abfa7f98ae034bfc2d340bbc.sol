1 // ERC Token Standard #20 Interface
2 interface ERC20 {
3     // Get the total token supply
4     function totalSupply() public constant returns (uint _totalSupply);
5     // Get the account balance of another account with address _owner
6     function balanceOf(address _owner) public constant returns (uint balance);
7     // Send _value amount of tokens to address _to
8     function transfer(address _to, uint _value) public returns (bool success);
9     // Send _value amount of tokens from address _from to address _to
10     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
11     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
12     // If this function is called again it overwrites the current allowance with _value.
13     // this function is required for some DEX functionality
14     function approve(address _spender, uint _value) public returns (bool success);
15     // Returns the amount which _spender is still allowed to withdraw from _owner
16     function allowance(address _owner, address _spender) public constant returns (uint remaining);
17     // Triggered when tokens are transferred.
18     event Transfer(address indexed _from, address indexed _to, uint _value);
19     // Triggered whenever approve(address _spender, uint256 _value) is called.
20     event Approval(address indexed _owner, address indexed _spender, uint _value);
21 }
22 
23 library SafeMath {
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a * b;
26         assert(a == 0 || c / a == b);
27         return c;
28     }
29 
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b > 0); // Solidity automatically throws when dividing by 0
32         uint256 c = a / b;
33         assert(a == b * c + a % b); // There is no case in which this doesn't hold
34         return c;
35     }
36 
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         assert(b <= a);
39         return a - b;
40     }
41 
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 contract OnePay is ERC20 {
50 
51     // Ability to call SafeMath functions on uints.
52     using SafeMath for uint256;
53 
54     // Token basic information
55     string public constant name = "OnePay";
56     string public constant symbol = "1PAY";
57     uint256 public constant decimals = 18;
58 
59     // Director address
60     address public director;
61 
62     // Balances for each account
63     mapping(address => uint256) balances;
64 
65     // Owner of account approves the transfer of an amount to another account
66     mapping(address => mapping(address => uint256)) allowed;
67 
68     // Public sale control
69     bool public saleClosed;
70     uint256 public currentSalePhase;
71     uint256 public SALE = 9090;  // Pre-Sale tokens per eth
72     uint256 public PRE_SALE = 16667; // Sale tokens per eth
73 
74     // Total supply of tokens
75     uint256 public totalSupply;
76 
77     // Total funds received
78     uint256 public totalReceived;
79 
80     // Total amount of coins minted
81     uint256 public mintedCoins;
82 
83     // Hard Cap for the sale
84     uint256 public hardCapSale;
85 
86     // Token Cap
87     uint256 public tokenCap;
88 
89     /**
90       * Functions with this modifier can only be executed by the owner
91       */
92     modifier onlyDirector()
93     {
94         assert(msg.sender == director);
95         _;
96     }
97 
98     /**
99       * Constructor
100       */
101     function OnePay() public
102     {
103         // Create the initial director
104         director = msg.sender;
105 
106         // setting the hardCap for sale
107         hardCapSale = 100000000 * 10 ** uint256(decimals);
108 
109         // token Cap
110         tokenCap = 500000000 * 10 ** uint256(decimals);
111 
112         // Set the total supply
113         totalSupply = 0;
114 
115         // Initial sale phase is presale
116         currentSalePhase = PRE_SALE;
117 
118         // total coins minted so far
119         mintedCoins = 0;
120 
121         // total funds raised
122         totalReceived = 0;
123 
124         saleClosed = true;
125     }
126 
127     /**
128       * Fallback function to be invoked when a value is sent without a function call.
129       */
130     function() public payable
131     {
132         // Make sure the sale is active
133         require(!saleClosed);
134 
135         // Minimum amount is 0.02 eth
136         require(msg.value >= 0.02 ether);
137 
138         // If 1400 eth is received switch the sale price
139         if (totalReceived >= 1500 ether) {
140             currentSalePhase = SALE;
141         }
142 
143         // Calculate tokens to mint based on the "current sale phase"
144         uint256 amount = msg.value.mul(currentSalePhase);
145 
146         // Make sure that mintedCoins don't exceed the hardcap sale
147         require(mintedCoins + amount <= hardCapSale);
148 
149         // Check for totalSupply max amount
150         balances[msg.sender] = balances[msg.sender].add(amount);
151 
152         // Increase the number of minted coins
153         mintedCoins += amount;
154 
155         //Increase totalSupply by amount
156         totalSupply += amount;
157 
158         // Track of total value received
159         totalReceived += msg.value;
160 
161         Transfer(this, msg.sender, amount);
162     }
163 
164     /**
165       * Get Tokens for the company
166       */
167     function getCompanyToken(uint256 amount) public onlyDirector returns (bool success)
168     {
169         amount = amount * 10 ** uint256(decimals);
170 
171         require((totalSupply + amount) <= tokenCap);
172 
173         balances[director] = amount;
174 
175         totalSupply += amount;
176 
177         return true;
178     }
179 
180     /**
181 	  * Lock the crowdsale
182 	  */
183     function closeSale() public onlyDirector returns (bool success)
184     {
185         saleClosed = true;
186         return true;
187     }
188 
189     /**
190       * Unlock the crowd sale.
191       */
192     function openSale() public onlyDirector returns (bool success)
193     {
194         saleClosed = false;
195         return true;
196     }
197 
198     /**
199       * Set the price to pre-sale
200       */
201     function setPriceToPreSale() public onlyDirector returns (bool success)
202     {
203         currentSalePhase = PRE_SALE;
204         return true;
205     }
206 
207     /**
208       * Set the price to reg sale.
209       */
210     function setPriceToRegSale() public onlyDirector returns (bool success)
211     {
212         currentSalePhase = SALE;
213         return true;
214     }
215 
216     /**
217       * Withdraw funds from the contract
218       */
219     function withdrawFunds() public onlyDirector
220     {
221         director.transfer(this.balance);
222     }
223 
224     /**
225       * Transfers the director to a new address
226       */
227     function transferDirector(address newDirector) public onlyDirector
228     {
229         director = newDirector;
230     }
231 
232     /**
233       * Returns total
234       */
235     function totalSupply() public view returns (uint256)
236     {
237         return totalSupply;
238     }
239 
240     /**
241       * Balance of a particular account
242       */
243     function balanceOf(address _owner) public constant returns (uint256)
244     {
245         return balances[_owner];
246     }
247 
248     /**
249       * Transfer balance from sender's account to receiver's account
250       */
251     function transfer(address _to, uint256 _value) public returns (bool success)
252     {
253         // Make sure the sender has enough value in their account
254         assert(balances[msg.sender] >= _value && _value > 0);
255         // Subtract value from sender's account
256         balances[msg.sender] = balances[msg.sender].sub(_value);
257         // Add value to receiver's account
258         balances[_to] = balances[_to].add(_value);
259 
260         // Log
261         Transfer(msg.sender, _to, _value);
262         return true;
263     }
264 
265     /**
266       * Allow spender to spend the value amount on your behalf.
267       * If this function is called again it overwrites the current allowance with _value.
268       */
269     function approve(address _spender, uint256 _value) public returns (bool)
270     {
271         allowed[msg.sender][_spender] = _value;
272         Approval(msg.sender, _spender, _value);
273         return true;
274     }
275 
276     /**
277       * Spend value from a different account granted you have allowance to use the value amount.
278       * If this function is called again it overwrites the current allowance with _value.
279       */
280     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)
281     {
282         assert(allowed[_from][msg.sender] >= _value && balances[_from] >= _value && _value > 0);
283         balances[_from] = balances[_from].sub(_value);
284         balances[_to] = balances[_to].add(_value);
285         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
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