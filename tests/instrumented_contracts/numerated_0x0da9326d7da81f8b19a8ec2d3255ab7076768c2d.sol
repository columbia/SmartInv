1 pragma solidity 0.4.23;
2 /*
3  This issue is covered by
4 INTERNATIONAL BILL OF EXCHANGE (IBOE), REGISTRATION NUMBER: 99-279-0080 and SERIAL
5 NUMBER: 062014 PARTIAL ASSIGNMENT /
6 RELEASE IN THE AMOUNT OF $ 500,000,000,000.00 USD in words;
7 FIVE HUNDRED BILLION and No / I00 USD, submitted to and in accordance with FINAL ARTICLES OF
8 (UNICITRAL Convention 1988) ratified Articles 1-7, 11-13.46-3, 47-4 (c), 51, House Joint Resolution 192 of June 5.1933,
9 UCC 1-104, 10-104. Reserved RELASED BY SECRETARY OF THE TRESAURY OF THE UNITED STATES OF AMERICA
10  */
11 
12 /**
13  * @title SafeMath
14  * @dev Math operations with safety checks that throw on error
15  */
16 library SafeMath {
17     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
18         if (a == 0) {
19             return 0;
20         }
21         uint256 c = a * b;
22         assert(c / a == b);
23         return c;
24     }
25 
26     function div(uint256 a, uint256 b) internal pure returns(uint256) {
27         // assert(b > 0); // Solidity automatically throws when dividing by 0
28         uint256 c = a / b;
29         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30         return c;
31     }
32 
33     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     function add(uint256 a, uint256 b) internal pure returns(uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 contract ERC20 {
46     function totalSupply()public view returns(uint total_Supply);
47     function balanceOf(address who)public view returns(uint256);
48     function allowance(address owner, address spender)public view returns(uint);
49     function transferFrom(address from, address to, uint value)public returns(bool ok);
50     function approve(address spender, uint value)public returns(bool ok);
51     function transfer(address to, uint value)public returns(bool ok);
52     event Transfer(address indexed from, address indexed to, uint value);
53     event Approval(address indexed owner, address indexed spender, uint value);
54 }
55 
56 
57 contract FENIX is ERC20
58 {
59     using SafeMath for uint256;
60         // Name of the token
61     string public constant name = "FENIX";
62 
63     // Symbol of token
64     string public constant symbol = "FNX";
65     uint8 public constant decimals = 18;
66     uint public _totalsupply = 1000000000 * 10 ** 18; // 1 Billion FNX Coins
67     address public owner;
68     uint256 public _price_tokn = 100;  //1 USD in cents
69     uint256 no_of_tokens;
70     uint256 total_token;
71     bool stopped = false;
72     uint256 public ico_startdate;
73     uint256 public ico_enddate;
74     uint256 public preico_startdate;
75     uint256 public preico_enddate;
76     bool public icoRunningStatus;
77     bool public lockstatus; 
78   
79     mapping(address => uint) balances;
80     mapping(address => mapping(address => uint)) allowed;
81     address public ethFundMain = 0xBe80a978364649422708470c979435f43e027209; // address to receive ether from smart contract
82     uint256 public ethreceived;
83     uint bonusCalculationFactor;
84     uint256 public pre_minContribution = 100000;// 1000 USD in cents for pre sale
85     uint256 ContributionAmount;
86     address public admin;  // admin address used to do transaction through the wallet on behalf of owner
87  
88  
89     uint public priceFactor;
90     mapping(address => uint256) availTokens;
91 
92     enum Stages {
93         NOTSTARTED,
94         PREICO,
95         ICO,
96         ENDED
97     }
98     Stages public stage;
99 
100     modifier atStage(Stages _stage) {
101         require (stage == _stage);
102         _;
103     }
104 
105     modifier onlyOwner(){
106         require (msg.sender == owner);
107      _;
108     }
109 
110   
111     constructor(uint256 EtherPriceFactor) public
112     {
113         require(EtherPriceFactor != 0);
114         owner = msg.sender;
115         balances[owner] = 890000000 * 10 ** 18;  // 890 Million given to owner
116         stage = Stages.NOTSTARTED;
117         icoRunningStatus =true;
118         lockstatus = true;
119         priceFactor = EtherPriceFactor;
120         emit Transfer(0, owner, balances[owner]);
121     }
122 
123     function () public payable
124     {
125         require(stage != Stages.ENDED);
126         require(!stopped && msg.sender != owner);
127         if (stage == Stages.PREICO && now <= preico_enddate){
128              require((msg.value).mul(priceFactor.mul(100)) >= (pre_minContribution.mul(10 ** 18)));
129 
130           y();
131 
132     }
133     else  if (stage == Stages.ICO && now <= ico_enddate){
134   
135           _price_tokn= getCurrentTokenPrice();
136        
137           y();
138 
139     }
140     else {
141         revert();
142     }
143     }
144     
145    
146 
147   function getCurrentTokenPrice() private returns (uint)
148         {
149         uint price_tokn;
150         bonusCalculationFactor = (block.timestamp.sub(ico_startdate)).div(3600); //time period in seconds
151         if (bonusCalculationFactor== 0) 
152             price_tokn = 70;                     //30 % Discount
153         else if (bonusCalculationFactor >= 1 && bonusCalculationFactor < 24) 
154             price_tokn = 75;                     //25 % Discount
155         else if (bonusCalculationFactor >= 24 && bonusCalculationFactor < 168) 
156             price_tokn = 80;                      //20 % Discount
157         else if (bonusCalculationFactor >= 168 && bonusCalculationFactor < 336) 
158             price_tokn = 90;                     //10 % Discount
159         else if (bonusCalculationFactor >= 336) 
160             price_tokn = 100;                  //0 % Discount
161             
162             return price_tokn;
163      
164         }
165         
166          function y() private {
167             
168              no_of_tokens = ((msg.value).mul(priceFactor.mul(100))).div(_price_tokn);
169              if(_price_tokn >=80){
170                  availTokens[msg.sender] = availTokens[msg.sender].add(no_of_tokens);
171              }
172              ethreceived = ethreceived.add(msg.value);
173              balances[address(this)] = (balances[address(this)]).sub(no_of_tokens);
174              balances[msg.sender] = balances[msg.sender].add(no_of_tokens);
175              emit  Transfer(address(this), msg.sender, no_of_tokens);
176     }
177 
178    
179     // called by the owner, pause ICO
180     function StopICO() external onlyOwner  {
181         stopped = true;
182 
183     }
184 
185     // called by the owner , resumes ICO
186     function releaseICO() external onlyOwner
187     {
188         stopped = false;
189 
190     }
191     
192     // to change price of Ether in USD, in case price increases or decreases
193      function setpricefactor(uint256 newPricefactor) external onlyOwner
194     {
195         priceFactor = newPricefactor;
196         
197     }
198     
199      function setEthmainAddress(address newEthfundaddress) external onlyOwner
200     {
201         ethFundMain = newEthfundaddress;
202     }
203     
204      function setAdminAddress(address newAdminaddress) external onlyOwner
205     {
206         admin = newAdminaddress;
207     }
208     
209      function start_PREICO() external onlyOwner atStage(Stages.NOTSTARTED)
210       {
211           stage = Stages.PREICO;
212           stopped = false;
213           _price_tokn = 70;     //30 % dicount
214           balances[address(this)] =10000000 * 10 ** 18 ; //10 million in preICO
215          preico_startdate = now;
216          preico_enddate = now + 7 days; //time for preICO
217        emit Transfer(0, address(this), balances[address(this)]);
218           }
219     
220     function start_ICO() external onlyOwner atStage(Stages.PREICO)
221       {
222           stage = Stages.ICO;
223           stopped = false;
224           balances[address(this)] =balances[address(this)].add(100000000 * 10 ** 18); //100 million in ICO
225          ico_startdate = now;
226          ico_enddate = now + 21 days; //time for ICO
227        emit Transfer(0, address(this), 100000000 * 10 ** 18);
228           }
229 
230     function end_ICO() external onlyOwner atStage(Stages.ICO)
231     {
232         require(now > ico_enddate);
233         stage = Stages.ENDED;
234         icoRunningStatus = false;
235         uint256 x = balances[address(this)];
236         balances[owner] = (balances[owner]).add( balances[address(this)]);
237         balances[address(this)] = 0;
238        emit  Transfer(address(this), owner , x);
239         
240     }
241     
242     // This function can be used by owner in emergency to update running status parameter
243     function fixSpecications(bool RunningStatusICO) external onlyOwner
244     {
245         icoRunningStatus = RunningStatusICO;
246     }
247     
248     // function to remove locking period after 12 months, can be called only be owner
249     function removeLocking(bool RunningStatusLock) external onlyOwner
250     {
251         lockstatus = RunningStatusLock;
252     }
253 
254 
255    function balanceDetails(address investor)
256         constant
257         public
258         returns (uint256,uint256)
259     {
260         return (availTokens[investor], balances[investor]) ;
261     }
262     
263     // what is the total supply of the ech tokens
264     function totalSupply() public view returns(uint256 total_Supply) {
265         total_Supply = _totalsupply;
266     }
267 
268     // What is the balance of a particular account?
269     function balanceOf(address _owner)public view returns(uint256 balance) {
270         return balances[_owner];
271     }
272 
273     // Send _value amount of tokens from address _from to address _to
274     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
275     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
276     // fees in sub-currencies; the command should fail unless the _from account has
277     // deliberately authorized the sender of the message via some mechanism; we propose
278     // these standardized APIs for approval:
279     function transferFrom(address _from, address _to, uint256 _amount)public returns(bool success) {
280         require(_to != 0x0);
281         require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
282         balances[_from] = (balances[_from]).sub(_amount);
283         allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
284         balances[_to] = (balances[_to]).add(_amount);
285         emit Transfer(_from, _to, _amount);
286         return true;
287     }
288 
289     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
290     // If this function is called again it overwrites the current allowance with _value.
291     function approve(address _spender, uint256 _amount)public returns(bool success) {
292         require(_spender != 0x0);
293         if (!icoRunningStatus && lockstatus) {
294             require(_amount <= availTokens[msg.sender]);
295         }
296         allowed[msg.sender][_spender] = _amount;
297         emit Approval(msg.sender, _spender, _amount);
298         return true;
299     }
300 
301     function allowance(address _owner, address _spender)public view returns(uint256 remaining) {
302         require(_owner != 0x0 && _spender != 0x0);
303         return allowed[_owner][_spender];
304     }
305     // Transfer the balance from owner's account to another account
306     function transfer(address _to, uint256 _amount) public returns(bool success) {
307        
308        if ( msg.sender == owner || msg.sender == admin) {
309             require(balances[msg.sender] >= _amount && _amount >= 0);
310             balances[msg.sender] = balances[msg.sender].sub(_amount);
311             balances[_to] += _amount;
312             availTokens[_to] += _amount;
313             emit Transfer(msg.sender, _to, _amount);
314             return true;
315         }
316         else
317         if (!icoRunningStatus && lockstatus && msg.sender != owner) {
318             require(availTokens[msg.sender] >= _amount);
319             availTokens[msg.sender] -= _amount;
320             balances[msg.sender] -= _amount;
321             availTokens[_to] += _amount;
322             balances[_to] += _amount;
323             emit Transfer(msg.sender, _to, _amount);
324             return true;
325         }
326 
327           else if(!lockstatus)
328          {
329            require(balances[msg.sender] >= _amount && _amount >= 0);
330            balances[msg.sender] = (balances[msg.sender]).sub(_amount);
331            balances[_to] = (balances[_to]).add(_amount);
332            emit Transfer(msg.sender, _to, _amount);
333            return true;
334           }
335 
336         else{
337             revert();
338         }
339     }
340 
341 
342     //In case the ownership needs to be transferred
343 	function transferOwnership(address newOwner)public onlyOwner
344 	{
345 	    require( newOwner != 0x0);
346 	    balances[newOwner] = (balances[newOwner]).add(balances[owner]);
347 	    balances[owner] = 0;
348 	    owner = newOwner;
349 	    emit Transfer(msg.sender, newOwner, balances[newOwner]);
350 	}
351 
352 
353     function drain() external onlyOwner {
354         address myAddress = this;
355         ethFundMain.transfer(myAddress.balance);
356     }
357 
358 }