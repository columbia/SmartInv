1 pragma solidity 0.4.24;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract ERC20 {
33   function totalSupply()public view returns (uint total_Supply);
34   function balanceOf(address who)public view returns (uint256);
35   function allowance(address owner, address spender)public view returns (uint);
36   function transferFrom(address from, address to, uint value)public returns (bool ok);
37   function approve(address spender, uint value)public returns (bool ok);
38   function transfer(address to, uint value)public returns (bool ok);
39   event Transfer(address indexed from, address indexed to, uint value);
40   event Approval(address indexed owner, address indexed spender, uint value);
41 }
42 
43 contract KNOWToken is ERC20
44 {
45     using SafeMath for uint256;
46     // Name of the token
47     string public constant name = "KNOW Token";
48 
49     // Symbol of token
50     string public constant symbol = "KNOW";
51     uint8 public constant decimals = 18;
52     uint public _totalsupply = 18300000000 * 10 ** 18; // 18 billion total supply // muliplies dues to decimal precision
53     address public owner;                    // Owner of this contract
54     uint256 no_of_tokens;
55     uint256 total_token;
56     bool stopped = false;
57     bool checkTransfer = false;
58     uint256 public lockup_startdate;
59     uint256 public lockup_enddate;
60     uint256 public eth_received; // total ether received in the contract
61     uint256 transferPercent;
62     uint256 transferPercentTotal;
63     uint256 transferDays;
64     uint256 transferDaysTotal;
65     uint256 transferLastTransaction;
66     uint256 transferTotalSpent;
67     uint256 transferPostDate;
68     mapping(address => uint) balances;
69     mapping(address => mapping(address => uint)) allowed;
70     
71     mapping(address => bool) addOfPrivateSale;
72     mapping(address => bool) addOfContributors;
73     mapping(address => bool) addOfContributors2;
74     mapping(address => bool) addOfTechOperation;
75     mapping(address => bool) addOfMarketingBusinessDev;
76     mapping(address => bool) addOfEarlyInvestor;
77     mapping(address => bool) addOfOwners;
78     
79     event EventPrivateSale(address indexed _PrivateSale, bool _status);
80     event EventContributors(address indexed _Contributors, bool _status);
81     event EventContributors2(address indexed _Contributors2, bool _status);
82     event EventTechOperation(address indexed _TechOperation, bool _status);
83     event EventMarketingBusinessDev(address indexed _MarketingBusinessDev, bool _status);
84     event EventEarlyInvestor(address indexed _EarlyInvestor, bool _status);
85     
86     mapping(address => LockupHolderDetails) lockupHolderMap;
87     
88     struct LockupHolderDetails{
89       uint transferPercent;
90       uint transferDays;
91       uint transferPercentTotal;
92       uint transferDaysTotal;
93       uint transferLastTransaction;
94       uint transferTotalSpent;
95       uint transferPostDate;
96       bool reset;
97     }
98         
99     enum Stages {
100         LOCKUPNOTSTARTED,
101         LOCKUPSTARTED,
102         LOCKUPENDED
103     }
104     
105     Stages public stage;
106     
107     modifier atStage(Stages _stage) {
108         if (stage != _stage)
109             // Contract not in expected state
110             revert();
111         _;
112     }
113     modifier onlyOwner() {
114         if (msg.sender != owner) {
115             revert();
116         }
117         _;
118     }
119 
120 
121     function KNOWToken() public
122     {
123         owner = msg.sender;
124         stage = Stages.LOCKUPNOTSTARTED;
125         
126         uint256 _transfertoPrivateSale = 2745000000 * 10 ** 18; // 15% to Private Sale
127         uint256 _transfertoContributors = 10980000000 * 10 ** 18; // 60% to Contributors
128         uint256 _transfertoContributors2 = 1830000000 * 10 ** 18; // 10% to Contributors 2
129         uint256 _transfertoTechOperationExpenses = 915000000 * 10 ** 18; // 5% to Tech & Operation Expenses
130         uint256 _transfertoMarketingBusinessDev = 915000000 * 10 ** 18; // 5% to Marketing & Business Development
131         uint256 _transfertoEarlyInvestors = 915000000 * 10 ** 18; // 5% to Early Investors
132         
133         // 15% to Private Sale
134         balances[0x8eeC67a193B6B90A4B0047769De8F17a7ee87eB9] = _transfertoPrivateSale;
135         Transfer(address(0), 0x8eeC67a193B6B90A4B0047769De8F17a7ee87eB9, _transfertoPrivateSale);
136         
137         // 60% to Contributors
138         balances[0xc7991555F9F2E731bb2013cfB0ac2dcf6dc4A236] = _transfertoContributors;
139         Transfer(address(0), 0xc7991555F9F2E731bb2013cfB0ac2dcf6dc4A236, _transfertoContributors);
140         
141         // 10% to Contributors 2
142         balances[0xf26511984b53bf4b96d85355224E06a06180237F] = _transfertoContributors2;
143         Transfer(address(0), 0xf26511984b53bf4b96d85355224E06a06180237F, _transfertoContributors2);
144         
145         // 5% to Tech & Operation Expenses
146         balances[0xDd695A5b4594ad79e3D9cE5280f0A36fde72C70A] = _transfertoTechOperationExpenses;
147         Transfer(address(0), 0xDd695A5b4594ad79e3D9cE5280f0A36fde72C70A, _transfertoTechOperationExpenses);
148         
149         // 5% to Marketing & Business Development
150         balances[0x84B899f535b7128fEC47e53901cE3242CdC9C06f] = _transfertoMarketingBusinessDev;
151         Transfer(address(0), 0x84B899f535b7128fEC47e53901cE3242CdC9C06f, _transfertoMarketingBusinessDev);
152         
153         // 5% to Early Investors
154         balances[0xeD9200CffFBe17af59D288836a9B25520c6CeFa1] = _transfertoEarlyInvestors;
155         Transfer(address(0), 0xeD9200CffFBe17af59D288836a9B25520c6CeFa1, _transfertoEarlyInvestors);
156     }
157     
158     function () public payable 
159     {
160         revert();
161         //Not Applicable   
162     }
163     
164      // Start lockup periods
165      function start_LOCKUP(uint _lockupEndDate) public onlyOwner atStage(Stages.LOCKUPNOTSTARTED)
166      {
167           stage = Stages.LOCKUPSTARTED;
168           stopped = false;
169           lockup_startdate = now;
170           lockup_enddate = now + _lockupEndDate * 86400;
171      }
172 
173      // End lockup periods
174      function end_LOCKUP() external onlyOwner atStage(Stages.LOCKUPSTARTED)
175      {
176          require(now > lockup_enddate);
177          stage = Stages.LOCKUPENDED;
178      }
179      
180      // Add address to Private Sale
181      function addtoPrivateSale(address _address, uint _transferPercent, uint _transferPercentTotal) public onlyOwner {
182         addOfPrivateSale[_address] = true;
183         emit EventPrivateSale(_address, true);
184         lockupHolderMap[_address] = LockupHolderDetails({
185                 transferPercent: _transferPercent,
186                 transferDays: 1,
187                 transferPercentTotal: _transferPercentTotal,
188                 transferDaysTotal: 365,
189                 transferLastTransaction: 0,
190                 transferTotalSpent: 0,
191                 transferPostDate: now,
192                 reset: true
193                 });
194      }
195      
196      // Add address to Contributors
197      function addtoContributos(address _address, uint _transferPercent, uint _transferPercentTotal) public onlyOwner {
198         addOfContributors[_address] = true;
199         emit EventContributors(_address, true);
200         lockupHolderMap[_address] = LockupHolderDetails({
201                 transferPercent: _transferPercent,
202                 transferDays: 1,
203                 transferPercentTotal: _transferPercentTotal,
204                 transferDaysTotal: 365,
205                 transferLastTransaction: 0,
206                 transferTotalSpent: 0,
207                 transferPostDate: now,
208                 reset: true
209                 });
210      }
211      
212      // Add address to Contributors2
213      function addtoContributos2(address _address, uint _transferPercent, uint _transferPercentTotal) public onlyOwner {
214         addOfContributors2[_address] = true;
215         emit EventContributors2(_address, true);
216         lockupHolderMap[_address] = LockupHolderDetails({
217                 transferPercent: _transferPercent,
218                 transferDays: 1,
219                 transferPercentTotal: _transferPercentTotal,
220                 transferDaysTotal: 365,
221                 transferLastTransaction: 0,
222                 transferTotalSpent: 0,
223                 transferPostDate: now,
224                 reset: true
225                 });
226      }
227      
228      // Add address to Tech & Operation
229      function addtoTechOperation(address _address, uint _transferPercent, uint _transferPercentTotal) public onlyOwner {
230         addOfTechOperation[_address] = true;
231         emit EventTechOperation(_address, true);
232         lockupHolderMap[_address] = LockupHolderDetails({
233                 transferPercent: _transferPercent,
234                 transferDays: 1,
235                 transferPercentTotal: _transferPercentTotal,
236                 transferDaysTotal: 365,
237                 transferLastTransaction: 0,
238                 transferTotalSpent: 0,
239                 transferPostDate: now,
240                 reset: true
241                 });
242      }
243      
244      // Add address to Marketing & Business Development
245      function addtoMarketingBusinessDev(address _address, uint _transferPercent, uint _transferPercentTotal) public onlyOwner {
246         addOfMarketingBusinessDev[_address] = true;
247         emit EventMarketingBusinessDev(_address, true);
248         lockupHolderMap[_address] = LockupHolderDetails({
249                 transferPercent: _transferPercent,
250                 transferDays: 1,
251                 transferPercentTotal: _transferPercentTotal,
252                 transferDaysTotal: 365,
253                 transferLastTransaction: 0,
254                 transferTotalSpent: 0,
255                 transferPostDate: now,
256                 reset: true
257                 });
258      }
259      
260      // Add address to Early Investors
261      function addtoEarlyInvestors(address _address, uint _transferPercent, uint _transferPercentTotal) public onlyOwner{
262         addOfEarlyInvestor[_address] = true;
263         emit EventEarlyInvestor(_address, true);
264         lockupHolderMap[_address] = LockupHolderDetails({
265                 transferPercent: _transferPercent,
266                 transferDays: 1,
267                 transferPercentTotal: _transferPercentTotal,
268                 transferDaysTotal: 365,
269                 transferLastTransaction: 0,
270                 transferTotalSpent: 0,
271                 transferPostDate: now,
272                 reset: true
273                 });
274      }
275      
276      // Add owners
277      function addtoOwners(address _address) public onlyOwner{
278         addOfOwners[_address] = true;
279      }
280    
281      // what is the total supply of the ech tokens
282      function totalSupply() public view returns (uint256 total_Supply) {
283          total_Supply = _totalsupply;
284      }
285     
286      // What is the balance of a particular account?
287      function balanceOf(address _owner)public view returns (uint256 balance) {
288          return balances[_owner];
289      }
290      
291      // Send _value amount of tokens from address _from to address _to
292      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
293      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
294      // fees in sub-currencies; the command should fail unless the _from account has
295      // deliberately authorized the sender of the message via some mechanism; we propose
296      // these standardized APIs for approval:
297      function transferFrom(address _from, address _to, uint256 _amount)public returns (bool success) {
298          require( _to != 0x0);
299          checkTransfer = false;
300          
301          if(addOfOwners[_from]) {
302              checkTransfer = true;
303          } else
304          if(addOfPrivateSale[_from]) {
305              require(checkTransferFunctionPrivateSale(_from, _to, _amount));
306          } else
307          if(addOfContributors[_from]) {
308              checkTransfer = true;
309          } else
310          if(addOfContributors2[_from] || addOfTechOperation[_from] || addOfMarketingBusinessDev[_from] || addOfEarlyInvestor[_from]) {
311              require(checkTransferFunction(_from, _to, _amount));
312          } 
313          
314          require(checkTransfer == true);
315          require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
316          balances[_from] = (balances[_from]).sub(_amount);
317          allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
318          balances[_to] = (balances[_to]).add(_amount);
319          Transfer(_from, _to, _amount);
320          return true;
321      }
322      
323      function checkTransferFunction(address _from, address _to, uint256 _amount) internal returns (bool success) {
324              
325              require(now > lockup_enddate);
326              
327              transferDaysTotal = lockupHolderMap[_from].transferDaysTotal * 86400;
328              transferPostDate = lockupHolderMap[_from].transferPostDate;
329              
330              if(now >= transferPostDate + transferDaysTotal) {
331                  lockupHolderMap[_from].transferPostDate = lockupHolderMap[_from].transferPostDate + transferDaysTotal;
332                  lockupHolderMap[_from].transferTotalSpent = 0;
333              }
334              
335              transferPercent = lockupHolderMap[_from].transferPercent;
336              transferPercentTotal = lockupHolderMap[_from].transferPercentTotal;
337              transferDays = lockupHolderMap[_from].transferDays * 86400;
338              transferDaysTotal = lockupHolderMap[_from].transferDaysTotal * 86400;
339              transferLastTransaction = lockupHolderMap[_from].transferLastTransaction;
340              transferTotalSpent = lockupHolderMap[_from].transferTotalSpent;
341              transferPostDate = lockupHolderMap[_from].transferPostDate;
342              
343              require((_amount * 10 ** 18) <= ((_totalsupply).mul(transferPercent)).div(100));
344              require((_amount * 10 ** 18) <= ((_totalsupply).mul(transferPercentTotal)).div(100));
345              
346              require(now >= transferLastTransaction + transferDays);
347              require((transferTotalSpent * 10 ** 18) <= ((_totalsupply).mul(transferPercentTotal)).div(100));
348              require(now <= transferPostDate + transferDaysTotal);
349              
350              lockupHolderMap[_from].transferLastTransaction = now;
351              lockupHolderMap[_from].transferTotalSpent += _amount;
352              
353              checkTransfer = true;
354              return true;
355      }
356      
357      function checkTransferFunctionPrivateSale(address _from, address _to, uint256 _amount) internal returns (bool success) {
358              
359              require(stage == Stages.LOCKUPENDED);
360              require(now > lockup_enddate);
361             
362              transferPercent = lockupHolderMap[_from].transferPercent;
363              transferDays = lockupHolderMap[_from].transferDays * 86400;
364              transferLastTransaction = lockupHolderMap[_from].transferLastTransaction;
365              transferTotalSpent = lockupHolderMap[_from].transferTotalSpent;
366              
367              require((_amount * 10 ** 18) <= ((_totalsupply).mul(transferPercent)).div(100));
368              
369              require(now >= transferLastTransaction + transferDays);
370              
371              lockupHolderMap[_from].transferLastTransaction = now;
372              
373              checkTransfer = true;
374              return true;
375      }
376      
377     
378      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
379      // If this function is called again it overwrites the current allowance with _value.
380      function approve(address _spender, uint256 _amount)public returns (bool success) {
381          require( _spender != 0x0);
382          allowed[msg.sender][_spender] = _amount;
383          Approval(msg.sender, _spender, _amount);
384          return true;
385      }
386      
387      
388      function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
389          require( _owner != 0x0 && _spender !=0x0);
390          return allowed[_owner][_spender];
391      }
392 
393      // Transfer the balance from owner's account to another account
394      function transfer(address _to, uint256 _amount)public returns (bool success) {
395         require( _to != 0x0);
396         require(balances[msg.sender] >= _amount && _amount >= 0);
397         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
398         balances[_to] = (balances[_to]).add(_amount);
399         Transfer(msg.sender, _to, _amount);
400              return true;
401      }
402     
403      // Transfer the balance from owner's account to another account
404     function transferTokens(address _to, uint256 _amount) private returns(bool success) {
405         require( _to != 0x0);       
406         require(balances[address(this)] >= _amount && _amount > 0);
407         balances[address(this)] = (balances[address(this)]).sub(_amount);
408         balances[_to] = (balances[_to]).add(_amount);
409         Transfer(address(this), _to, _amount);
410         return true;
411      }
412  
413      // Drain all coins 
414      function drain() external onlyOwner {
415         owner.transfer(this.balance);
416      }
417     
418 }