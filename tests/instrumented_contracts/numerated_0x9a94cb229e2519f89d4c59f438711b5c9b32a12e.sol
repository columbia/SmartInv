1 pragma solidity 0.4.21;
2 /*
3  This issue is covered by
4 INTERNATIONAL BILL OF EXCHANGE (IBOE), REGISTRATION NUMBER: 99-279-0080 and SERIAL
5 NUMBER: 092014 PARTIAL ASSIGNMENT /
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
86  
87  
88     uint public priceFactor;
89     mapping(address => uint256) availTokens;
90 
91     enum Stages {
92         NOTSTARTED,
93         PREICO,
94         ICO,
95         ENDED
96     }
97     Stages public stage;
98 
99     modifier atStage(Stages _stage) {
100         require (stage == _stage);
101         _;
102     }
103 
104     modifier onlyOwner(){
105         require (msg.sender == owner);
106      _;
107     }
108 
109   
110     function FENIX(uint256 EtherPriceFactor) public
111     {
112         require(EtherPriceFactor != 0);
113         owner = msg.sender;
114         balances[owner] = 890000000 * 10 ** 18;  // 890 Million given to owner
115         stage = Stages.NOTSTARTED;
116         icoRunningStatus =true;
117         lockstatus = true;
118         priceFactor = EtherPriceFactor;
119         emit Transfer(0, owner, balances[owner]);
120     }
121 
122     function () public payable
123     {
124         require(stage != Stages.ENDED);
125         require(!stopped && msg.sender != owner);
126         if (stage == Stages.PREICO && now <= preico_enddate){
127              require((msg.value).mul(priceFactor.mul(100)) >= (pre_minContribution.mul(10 ** 18)));
128 
129           y();
130 
131     }
132     else  if (stage == Stages.ICO && now <= ico_enddate){
133   
134           _price_tokn= getCurrentTokenPrice();
135        
136           y();
137 
138     }
139     else {
140         revert();
141     }
142     }
143     
144    
145 
146   function getCurrentTokenPrice() private returns (uint)
147         {
148         uint price_tokn;
149         bonusCalculationFactor = (block.timestamp.sub(ico_startdate)).div(3600); //time period in seconds
150         if (bonusCalculationFactor== 0) 
151             price_tokn = 65;                     //35 % Discount
152         else if (bonusCalculationFactor >= 1 && bonusCalculationFactor < 24) 
153             price_tokn = 70;                     //30 % Discount
154         else if (bonusCalculationFactor >= 24 && bonusCalculationFactor < 168) 
155             price_tokn = 80;                      //20 % Discount
156         else if (bonusCalculationFactor >= 168 && bonusCalculationFactor < 336) 
157             price_tokn = 90;                     //10 % Discount
158         else if (bonusCalculationFactor >= 336) 
159             price_tokn = 100;                  //0 % Discount
160             
161             return price_tokn;
162      
163         }
164         
165          function y() private {
166             
167              no_of_tokens = ((msg.value).mul(priceFactor.mul(100))).div(_price_tokn);
168              if(_price_tokn >=80){
169                  availTokens[msg.sender] = availTokens[msg.sender].add(no_of_tokens);
170              }
171              ethreceived = ethreceived.add(msg.value);
172              balances[address(this)] = (balances[address(this)]).sub(no_of_tokens);
173              balances[msg.sender] = balances[msg.sender].add(no_of_tokens);
174              emit  Transfer(address(this), msg.sender, no_of_tokens);
175     }
176 
177    
178     // called by the owner, pause ICO
179     function StopICO() external onlyOwner  {
180         stopped = true;
181 
182     }
183 
184     // called by the owner , resumes ICO
185     function releaseICO() external onlyOwner
186     {
187         stopped = false;
188 
189     }
190     
191     // to change price of Ether in USD, in case price increases or decreases
192      function setpricefactor(uint256 newPricefactor) external onlyOwner
193     {
194         priceFactor = newPricefactor;
195         
196     }
197     
198      function setEthmainAddress(address newEthfundaddress) external onlyOwner
199     {
200         ethFundMain = newEthfundaddress;
201     }
202     
203      function start_PREICO() external onlyOwner atStage(Stages.NOTSTARTED)
204       {
205           stage = Stages.PREICO;
206           stopped = false;
207           _price_tokn = 60;     //40 % dicount
208           balances[address(this)] =10000000 * 10 ** 18 ; //10 million in preICO
209          preico_startdate = now;
210          preico_enddate = now + 7 days; //time for preICO
211        emit Transfer(0, address(this), balances[address(this)]);
212           }
213     
214     function start_ICO() external onlyOwner atStage(Stages.PREICO)
215       {
216           stage = Stages.ICO;
217           stopped = false;
218           balances[address(this)] =balances[address(this)].add(100000000 * 10 ** 18); //100 million in ICO
219          ico_startdate = now;
220          ico_enddate = now + 21 days; //time for ICO
221        emit Transfer(0, address(this), 100000000 * 10 ** 18);
222           }
223 
224     function end_ICO() external onlyOwner atStage(Stages.ICO)
225     {
226         require(now > ico_enddate);
227         stage = Stages.ENDED;
228         icoRunningStatus = false;
229         uint256 x = balances[address(this)];
230         balances[owner] = (balances[owner]).add( balances[address(this)]);
231         balances[address(this)] = 0;
232        emit  Transfer(address(this), owner , x);
233         
234     }
235     
236     // This function can be used by owner in emergency to update running status parameter
237     function fixSpecications(bool RunningStatusICO) external onlyOwner
238     {
239         icoRunningStatus = RunningStatusICO;
240     }
241     
242     // function to remove locking period after 12 months, can be called only be owner
243     function removeLocking(bool RunningStatusLock) external onlyOwner
244     {
245         lockstatus = RunningStatusLock;
246     }
247 
248 
249    function balanceDetails(address investor)
250         constant
251         public
252         returns (uint256,uint256)
253     {
254         return (availTokens[investor], balances[investor]) ;
255     }
256     
257     // what is the total supply of the ech tokens
258     function totalSupply() public view returns(uint256 total_Supply) {
259         total_Supply = _totalsupply;
260     }
261 
262     // What is the balance of a particular account?
263     function balanceOf(address _owner)public view returns(uint256 balance) {
264         return balances[_owner];
265     }
266 
267     // Send _value amount of tokens from address _from to address _to
268     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
269     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
270     // fees in sub-currencies; the command should fail unless the _from account has
271     // deliberately authorized the sender of the message via some mechanism; we propose
272     // these standardized APIs for approval:
273     function transferFrom(address _from, address _to, uint256 _amount)public returns(bool success) {
274         require(_to != 0x0);
275         require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
276         balances[_from] = (balances[_from]).sub(_amount);
277         allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
278         balances[_to] = (balances[_to]).add(_amount);
279         emit Transfer(_from, _to, _amount);
280         return true;
281     }
282 
283     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
284     // If this function is called again it overwrites the current allowance with _value.
285     function approve(address _spender, uint256 _amount)public returns(bool success) {
286         require(_spender != 0x0);
287         if (!icoRunningStatus && lockstatus) {
288             require(_amount <= availTokens[msg.sender]);
289         }
290         allowed[msg.sender][_spender] = _amount;
291         emit Approval(msg.sender, _spender, _amount);
292         return true;
293     }
294 
295     function allowance(address _owner, address _spender)public view returns(uint256 remaining) {
296         require(_owner != 0x0 && _spender != 0x0);
297         return allowed[_owner][_spender];
298     }
299     // Transfer the balance from owner's account to another account
300     function transfer(address _to, uint256 _amount) public returns(bool success) {
301        
302        if ( msg.sender == owner) {
303             require(balances[owner] >= _amount && _amount >= 0);
304             balances[owner] = balances[owner].sub(_amount);
305             balances[_to] += _amount;
306             availTokens[_to] += _amount;
307             emit Transfer(msg.sender, _to, _amount);
308             return true;
309         }
310         else
311         if (!icoRunningStatus && lockstatus && msg.sender != owner) {
312             require(availTokens[msg.sender] >= _amount);
313             availTokens[msg.sender] -= _amount;
314             balances[msg.sender] -= _amount;
315             availTokens[_to] += _amount;
316             balances[_to] += _amount;
317             emit Transfer(msg.sender, _to, _amount);
318             return true;
319         }
320 
321           else if(!lockstatus)
322          {
323            require(balances[msg.sender] >= _amount && _amount >= 0);
324            balances[msg.sender] = (balances[msg.sender]).sub(_amount);
325            balances[_to] = (balances[_to]).add(_amount);
326            emit Transfer(msg.sender, _to, _amount);
327            return true;
328           }
329 
330         else{
331             revert();
332         }
333     }
334 
335 
336     //In case the ownership needs to be transferred
337 	function transferOwnership(address newOwner)public onlyOwner
338 	{
339 	    require( newOwner != 0x0);
340 	    balances[newOwner] = (balances[newOwner]).add(balances[owner]);
341 	    balances[owner] = 0;
342 	    owner = newOwner;
343 	    emit Transfer(msg.sender, newOwner, balances[newOwner]);
344 	}
345 
346 
347     function drain() external onlyOwner {
348         address myAddress = this;
349         ethFundMain.transfer(myAddress.balance);
350     }
351 
352 }