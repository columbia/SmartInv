1 pragma solidity 0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns(uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns(uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 contract ERC20 {
37     function totalSupply()public view returns(uint total_Supply);
38     function balanceOf(address who)public view returns(uint256);
39     function allowance(address owner, address spender)public view returns(uint);
40     function transferFrom(address from, address to, uint value)public returns(bool ok);
41     function approve(address spender, uint value)public returns(bool ok);
42     function transfer(address to, uint value)public returns(bool ok);
43     event Transfer(address indexed from, address indexed to, uint value);
44     event Approval(address indexed owner, address indexed spender, uint value);
45 }
46 
47 
48 contract OutCloud is ERC20
49 {
50     using SafeMath for uint256;
51         // Name of the token
52     string public constant name = "OutCloud";
53 
54     // Symbol of token
55     string public constant symbol = "OUT";
56     uint8 public constant decimals = 18;
57     uint public _totalsupply = 1200000000 * 10 ** 18; // 1.2 Billion OUT Coins
58     address public owner;
59     uint256 public _price_token;  // price in cents
60     uint256 no_of_tokens;
61     uint256 total_token;
62     bool stopped = false;
63     uint256 public ico_startdate;
64     // uint256 public ico_enddate;
65     uint256 public preico_startdate;
66     uint256 public preico_enddate;
67     bool public lockstatus; 
68     uint256 constant public ETH_DECIMALS = 10 ** 18;
69     mapping(address => uint) balances;
70     mapping(address => mapping(address => uint)) allowed;
71     address public ethFundMain = 0xbCa409CaD1d339267af01aF0A49002E00e9BE090; // address to receive ether from smart contract
72     uint256 public ethreceived;
73     uint256 public TotalICOSupply = 400000000 * 10 ** 18;
74     uint public bonusCalculationFactor;
75     uint256 public minContribution = 10000; // 10 USD  (1 USD = 1000)
76     uint256 ContributionAmount;
77     uint dis;
78    
79  
80     uint public priceFactor;
81    // mapping(address => uint256) availTokens;
82 
83     enum Stages {
84         NOTSTARTED,
85         PREICO,
86         ICO,
87         ENDED
88     }
89     Stages public stage;
90 
91     modifier atStage(Stages _stage) {
92         require (stage == _stage);
93         _;
94     }
95 
96     modifier onlyOwner(){
97         require (msg.sender == owner);
98      _;
99     }
100 
101   
102     constructor(uint256 EtherPriceFactor) public
103     {
104         require(EtherPriceFactor != 0);
105         owner = msg.sender;
106         balances[owner] = 500000000 * 10 ** 18;  // 500 Million given to owner
107         stage = Stages.NOTSTARTED;
108         lockstatus = true;
109         priceFactor = EtherPriceFactor;
110         emit Transfer(0, owner, balances[owner]);
111        
112     }
113 
114     function () public payable
115     {
116         require(stage != Stages.ENDED);
117         require(msg.value >= minContribution);
118         require(!stopped && msg.sender != owner);
119         ContributionAmount = ((msg.value).mul(priceFactor.mul(1000)));// 1USD = 1000
120         if (stage == Stages.PREICO && now <= preico_enddate){
121             
122              
123            dis= getCurrentTokenPricepreICO(ContributionAmount);
124            _price_token = _price_token.sub(_price_token.mul(dis).div(100));
125           y();
126 
127     }
128     else  if (stage == Stages.ICO ){
129   
130           dis= getCurrentTokenPriceICO(ContributionAmount);
131            _price_token = _price_token.sub(_price_token.mul(dis).div(100));
132           y();
133 
134     }
135     else {
136         revert();
137     }
138     }
139     
140    
141 
142   function getCurrentTokenPricepreICO(uint256 individuallyContributedEtherInWei) private returns (uint)
143         {
144         require(individuallyContributedEtherInWei >= (minContribution.mul(ETH_DECIMALS)));
145         uint disc;
146         bonusCalculationFactor = (block.timestamp.sub(preico_startdate)).div(604800); // 1 week time period in seconds
147         if (bonusCalculationFactor== 0) 
148             disc = 30;                     //30 % Discount
149         else if (bonusCalculationFactor == 1) 
150             disc = 20;                     //20 % Discount
151         else if (bonusCalculationFactor ==2 ) 
152             disc = 10;                      //10 % Discount
153         else if (bonusCalculationFactor == 3) 
154            disc = 5;                     //5 % Discount
155         
156             
157             return disc;
158      
159         }
160         
161         function getCurrentTokenPriceICO(uint256 individuallyContributedEtherInWei) private returns (uint)
162         {
163         require(individuallyContributedEtherInWei >= (minContribution.mul(ETH_DECIMALS)));
164         uint disc;
165         bonusCalculationFactor = (block.timestamp.sub(ico_startdate)).div(604800); // 1 week time period in seconds
166         if (bonusCalculationFactor== 0) 
167             disc = 30;                     //30 % Discount
168         else if (bonusCalculationFactor == 1) 
169             disc = 20;                     //20 % Discount
170         else if (bonusCalculationFactor ==2 ) 
171             disc = 10;                      //10 % Discount
172         else if (bonusCalculationFactor == 3) 
173            disc = 5;                     //5 % Discount
174         else if (bonusCalculationFactor > 3) 
175            disc = 0;                  //0% Discount
176             
177             return disc;
178      
179         }
180         
181          function y() private {
182             
183              no_of_tokens = ((msg.value).mul(priceFactor.mul(1000))).div(_price_token); //(1USD =1000)
184              ethreceived = ethreceived.add(msg.value);
185              balances[address(this)] = (balances[address(this)]).sub(no_of_tokens);
186              balances[msg.sender] = balances[msg.sender].add(no_of_tokens);
187              emit Transfer(address(this), msg.sender, no_of_tokens);
188     }
189 
190    
191     // called by the owner, pause ICO
192     function StopICO() external onlyOwner  {
193         stopped = true;
194 
195     }
196 
197     // called by the owner , resumes ICO
198     function releaseICO() external onlyOwner
199     {
200         stopped = false;
201 
202     }
203     
204     // to change price of Ether in USD, in case price increases or decreases
205      function setpricefactor(uint256 newPricefactor) external onlyOwner
206     {
207         priceFactor = newPricefactor;
208         
209     }
210     
211      function setEthmainAddress(address newEthfundaddress) external onlyOwner
212     {
213         ethFundMain = newEthfundaddress;
214     }
215  
216     
217      function start_PREICO() external onlyOwner atStage(Stages.NOTSTARTED)
218       {
219           stage = Stages.PREICO;
220           stopped = false;
221           _price_token = 100;  // 1 OUT =  10 cents (1USD = 1000)
222         balances[address(this)] = 300000000 * 10 ** 18 ; //300 Million in pre-ICO
223          preico_startdate = now;
224          preico_enddate = now + 28 days; //time period for preICO = 4 weeks
225       emit Transfer(0, address(this), balances[address(this)]);
226           }
227     
228     function start_ICO() external onlyOwner atStage(Stages.PREICO)
229       {
230           stage = Stages.ICO;
231           stopped = false;
232           balances[address(this)] = balances[address(this)].add(TotalICOSupply) ; //400 Million in ICO
233           _price_token = 150;   // 1 OUT =  15 cents (1USD = 1000)
234           ico_startdate = now;
235         //  ico_enddate = now + 28 days; //time period for ICO = 4 weeks
236           emit Transfer(0, address(this), TotalICOSupply);
237       
238           }
239 
240     function end_ICO() external onlyOwner atStage(Stages.ICO)
241     {
242         // require(now > ico_enddate);
243         stage = Stages.ENDED;
244         lockstatus = false;
245         uint256 x = balances[address(this)];
246         balances[owner] = (balances[owner]).add( balances[address(this)]);
247         balances[address(this)] = 0;
248        emit  Transfer(address(this), owner , x);
249         
250     }
251     
252   
253    // This function can be used by owner in emergency to update running status parameter
254     function removeLocking(bool RunningStatusLock) external onlyOwner
255     {
256         lockstatus = RunningStatusLock;
257     }
258 
259 
260   
261     // what is the total supply of the ech tokens
262     function totalSupply() public view returns(uint256 total_Supply) {
263         total_Supply = _totalsupply;
264     }
265 
266     // What is the balance of a particular account?
267     function balanceOf(address _owner)public view returns(uint256 balance) {
268         return balances[_owner];
269     }
270 
271     // Send _value amount of tokens from address _from to address _to
272     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
273     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
274     // fees in sub-currencies; the command should fail unless the _from account has
275     // deliberately authorized the sender of the message via some mechanism; we propose
276     // these standardized APIs for approval:
277     function transferFrom(address _from, address _to, uint256 _amount)public returns(bool success) {
278         require(_to != 0x0);
279         require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
280         balances[_from] = (balances[_from]).sub(_amount);
281         allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
282         balances[_to] = (balances[_to]).add(_amount);
283         emit Transfer(_from, _to, _amount);
284         return true;
285     }
286 
287     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
288     // If this function is called again it overwrites the current allowance with _value.
289     function approve(address _spender, uint256 _amount)public returns(bool success) {
290         require(_spender != 0x0);
291         require( !lockstatus);
292         allowed[msg.sender][_spender] = _amount;
293         emit Approval(msg.sender, _spender, _amount);
294         return true;
295     }
296 
297     function allowance(address _owner, address _spender)public view returns(uint256 remaining) {
298         require(_owner != 0x0 && _spender != 0x0);
299         return allowed[_owner][_spender];
300     }
301     // Transfer the balance from owner's account to another account
302     function transfer(address _to, uint256 _amount) public returns(bool success) {
303        
304        if ( lockstatus && msg.sender == owner) {
305             require(balances[msg.sender] >= _amount && _amount >= 0);
306             balances[msg.sender] = balances[msg.sender].sub(_amount);
307             balances[_to] += _amount;
308             emit Transfer(msg.sender, _to, _amount);
309             return true;
310         }
311       
312           else if(!lockstatus)
313          {
314            require(balances[msg.sender] >= _amount && _amount >= 0);
315            balances[msg.sender] = (balances[msg.sender]).sub(_amount);
316            balances[_to] = (balances[_to]).add(_amount);
317            emit Transfer(msg.sender, _to, _amount);
318            return true;
319           }
320 
321         else{
322             revert();
323         }
324     }
325 
326 
327     //In case the ownership needs to be transferred
328 	function transferOwnership(address newOwner)public onlyOwner
329 	{
330 	    require( newOwner != 0x0);
331 	    balances[newOwner] = (balances[newOwner]).add(balances[owner]);
332 	    balances[owner] = 0;
333 	    owner = newOwner;
334 	    emit Transfer(msg.sender, newOwner, balances[newOwner]);
335 	}
336 
337 
338     function drain() external onlyOwner {
339         address myAddress = this;
340         ethFundMain.transfer(myAddress.balance);
341     }
342 
343 }