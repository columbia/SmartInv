1 // ICO Platform Demo smart contract.
2 // Developed by Phenom.Team <info@phenom.team>
3 pragma solidity ^0.4.18;
4 
5 /**
6  *   @title SafeMath
7  *   @dev Math operations with safety checks that throw on error
8  */
9 
10 library SafeMath {
11 
12   function mul(uint a, uint b) internal constant returns (uint) {
13     if (a == 0) {
14       return 0;
15     }
16     uint c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   function div(uint a, uint b) internal constant returns(uint) {
22     assert(b > 0);
23     uint c = a / b;
24     assert(a == b * c + a % b);
25     return c;
26   }
27 
28   function sub(uint a, uint b) internal constant returns(uint) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function add(uint a, uint b) internal constant returns(uint) {
34     uint c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 }
39 
40 /**
41  *   @title ERC20
42  *   @dev Standart ERC20 token interface
43  */
44 
45 contract ERC20 {
46     uint public totalSupply = 0;
47 
48     mapping(address => uint) balances;
49     mapping(address => mapping (address => uint)) allowed;
50 
51     function balanceOf(address _owner) constant returns (uint);
52     function transfer(address _to, uint _value) returns (bool);
53     function transferFrom(address _from, address _to, uint _value) returns (bool);
54     function approve(address _spender, uint _value) returns (bool);
55     function allowance(address _owner, address _spender) constant returns (uint);
56 
57     event Transfer(address indexed _from, address indexed _to, uint _value);
58     event Approval(address indexed _owner, address indexed _spender, uint _value);
59 
60 } 
61 
62 /**
63  *   @title PhenomTeam contract  - takes funds and issues tokens
64  */
65 contract PhenomTeam {
66     // PHN - Phenom Demo Token contract 
67     using SafeMath for uint;
68     PhenomDemoToken public PHN = new PhenomDemoToken(this);
69 
70     
71     // rateEth can be changed only by Oracle
72     uint public rateEth = 878; // Rate USD per ETH
73 
74     // Output ethereum addresses
75     address public Company;
76     address public Manager; // Manager controls contract
77     address public Controller_Address1; // First address that is used to buy tokens for other cryptos
78     address public Controller_Address2; // Second address that is used to buy tokens for other cryptos
79     address public Controller_Address3; // Third address that is used to buy tokens for other cryptos
80     address public Oracle; // Oracle address
81 
82     // Possible ICO statuses
83     enum StatusICO {
84         Created,
85         Started,
86         Paused,
87         Finished
88     }
89     StatusICO statusICO = StatusICO.Created;
90     
91     // Events Log
92     event LogStartICO();
93     event LogPause();
94     event LogFinishICO();
95     event LogBuyForInvestor(address investor, uint DTRCValue, string txHash);
96 
97     // Modifiers
98     // Allows execution by the manager only
99     modifier managerOnly { 
100         require(
101             msg.sender == Manager
102         );
103         _; 
104      }
105 
106     // Allows execution by the oracle only
107     modifier oracleOnly { 
108         require(msg.sender == Oracle);
109         _; 
110      }
111     // Allows execution by the one of controllers only
112     modifier controllersOnly {
113         require(
114             (msg.sender == Controller_Address1)||
115             (msg.sender == Controller_Address2)||
116             (msg.sender == Controller_Address3)
117         );
118         _;
119     }
120 
121    /**
122     *   @dev Contract constructor function
123     */
124     function PhenomTeam(
125         address _Company,
126         address _Manager,
127         address _Controller_Address1,
128         address _Controller_Address2,
129         address _Controller_Address3,
130         address _Oracle
131         ) public {
132         Company = _Company;
133         Manager = _Manager;
134         Controller_Address1 = _Controller_Address1;
135         Controller_Address2 = _Controller_Address2;
136         Controller_Address3 = _Controller_Address3;
137         Oracle = _Oracle;
138     }
139 
140    /**
141     *   @dev Function to set rate of ETH
142     *   @param _rateEth       current ETH rate
143     */
144     function setRate(uint _rateEth) external oracleOnly {
145         rateEth = _rateEth;
146     }
147 
148    /**
149     *   @dev Function to start ICO
150     *   Sets ICO status to Started
151     */
152     function startIco() external managerOnly {
153         require(statusICO == StatusICO.Created || statusICO == StatusICO.Paused);
154         statusICO = StatusICO.Started;
155         LogStartICO();
156     }
157 
158    /**
159     *   @dev Function to pause ICO
160     *   Sets ICO status to Paused
161     */
162     function pauseIco() external managerOnly {
163        require(statusICO == StatusICO.Started);
164        statusICO = StatusICO.Paused;
165        LogPause();
166     }
167 
168    /**
169     *   @dev Function to finish ICO
170     */
171     function finishIco() external managerOnly {
172         require(statusICO == StatusICO.Started || statusICO == StatusICO.Paused);
173         statusICO = StatusICO.Finished;
174         LogFinishICO();
175     }
176 
177    /**
178     *   @dev Fallback function calls buy(address _investor, uint _PHNValue) function to issue tokens
179     *        when investor sends ETH to address of ICO contract
180     */
181     function() external payable {
182         buy(msg.sender, msg.value.mul(rateEth)); 
183     }
184 
185    /**
186     *   @dev Function to issues tokens for investors who made purchases in other cryptocurrencies
187     *   @param _investor     address the tokens will be issued to
188     *   @param _txHash       transaction hash of investor's payment
189     *   @param _PHNValue     number of PHN tokens
190     */
191 
192     function buyForInvestor(
193         address _investor, 
194         uint _PHNValue, 
195         string _txHash
196     ) 
197         external 
198         controllersOnly {
199         buy(_investor, _PHNValue);
200         LogBuyForInvestor(_investor, _PHNValue, _txHash);
201     }
202 
203    /**
204     *   @dev Function to issue tokens for investors who paid in ether
205     *   @param _investor     address which the tokens will be issued tokens
206     *   @param _PHNValue     number of PHN tokens
207     */
208     function buy(address _investor, uint _PHNValue) internal {
209         require(statusICO == StatusICO.Started);
210         PHN.mintTokens(_investor, _PHNValue);
211     }
212 
213    /**
214     *   @dev Function to enable token transfers
215     */
216     function unfreeze() external managerOnly {
217        PHN.defrost();
218     }
219 
220    /**
221     *   @dev Function to disable token transfers
222     */
223     function freeze() external managerOnly {
224        PHN.frost();
225     }
226 
227    /**
228     *   @dev Function to change withdrawal address
229     *   @param _Company     new withdrawal address
230     */   
231     function setWithdrawalAddress(address _Company) external managerOnly {
232         Company = _Company;
233     }
234    
235    /**
236     *   @dev Allows Company withdraw investments
237     */
238     function withdrawEther() external managerOnly {
239         Company.transfer(this.balance);
240     }
241 
242 }
243 
244 /**
245  *   @title PhenomDemoToken
246  *   @dev Phenom Demo Token contract 
247  */
248 contract PhenomDemoToken is ERC20 {
249     using SafeMath for uint;
250     string public name = "ICO Platform Demo | https://Phenom.Team ";
251     string public symbol = "PHN";
252     uint public decimals = 18;
253 
254     // Ico contract address
255     address public ico;
256     
257     // Tokens transfer ability status
258     bool public tokensAreFrozen = true;
259 
260     // Allows execution by the owner only
261     modifier icoOnly { 
262         require(msg.sender == ico); 
263         _; 
264     }
265 
266    /**
267     *   @dev Contract constructor function sets Ico address
268     *   @param _ico          ico address
269     */
270     function PhenomDemoToken(address _ico) public {
271        ico = _ico;
272     }
273 
274    /**
275     *   @dev Function to mint tokens
276     *   @param _holder       beneficiary address the tokens will be issued to
277     *   @param _value        number of tokens to issue
278     */
279     function mintTokens(address _holder, uint _value) external icoOnly {
280        require(_value > 0);
281        balances[_holder] = balances[_holder].add(_value);
282        totalSupply = totalSupply.add(_value);
283        Transfer(0x0, _holder, _value);
284     }
285 
286 
287    /**
288     *   @dev Function to enable token transfers
289     */
290     function defrost() external icoOnly {
291        tokensAreFrozen = false;
292     }
293 
294    /**
295     *   @dev Function to disable token transfers
296     */
297     function frost() external icoOnly {
298        tokensAreFrozen = true;
299     }
300 
301    /**
302     *   @dev Get balance of tokens holder
303     *   @param _holder        holder's address
304     *   @return               balance of investor
305     */
306     function balanceOf(address _holder) constant returns (uint) {
307          return balances[_holder];
308     }
309 
310    /**
311     *   @dev Send coins
312     *   throws on any error rather then return a false flag to minimize
313     *   user errors
314     *   @param _to           target address
315     *   @param _amount       transfer amount
316     *
317     *   @return true if the transfer was successful
318     */
319     function transfer(address _to, uint _amount) public returns (bool) {
320         require(!tokensAreFrozen);
321         balances[msg.sender] = balances[msg.sender].sub(_amount);
322         balances[_to] = balances[_to].add(_amount);
323         Transfer(msg.sender, _to, _amount);
324         return true;
325     }
326 
327    /**
328     *   @dev An account/contract attempts to get the coins
329     *   throws on any error rather then return a false flag to minimize user errors
330     *
331     *   @param _from         source address
332     *   @param _to           target address
333     *   @param _amount       transfer amount
334     *
335     *   @return true if the transfer was successful
336     */
337     function transferFrom(address _from, address _to, uint _amount) public returns (bool) {
338         require(!tokensAreFrozen);
339         balances[_from] = balances[_from].sub(_amount);
340         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
341         balances[_to] = balances[_to].add(_amount);
342         Transfer(_from, _to, _amount);
343         return true;
344      }
345 
346 
347    /**
348     *   @dev Allows another account/contract to spend some tokens on its behalf
349     *   throws on any error rather then return a false flag to minimize user errors
350     *
351     *   also, to minimize the risk of the approve/transferFrom attack vector
352     *   approve has to be called twice in 2 separate transactions - once to
353     *   change the allowance to 0 and secondly to change it to the new allowance
354     *   value
355     *
356     *   @param _spender      approved address
357     *   @param _amount       allowance amount
358     *
359     *   @return true if the approval was successful
360     */
361     function approve(address _spender, uint _amount) public returns (bool) {
362         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
363         allowed[msg.sender][_spender] = _amount;
364         Approval(msg.sender, _spender, _amount);
365         return true;
366     }
367 
368    /**
369     *   @dev Function to check the amount of tokens that an owner allowed to a spender.
370     *
371     *   @param _owner        the address which owns the funds
372     *   @param _spender      the address which will spend the funds
373     *
374     *   @return              the amount of tokens still avaible for the spender
375     */
376     function allowance(address _owner, address _spender) constant returns (uint) {
377         return allowed[_owner][_spender];
378     }
379 }