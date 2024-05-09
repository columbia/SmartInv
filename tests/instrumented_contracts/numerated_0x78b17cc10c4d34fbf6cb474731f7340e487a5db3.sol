1 pragma solidity ^0.4.19;
2 
3 contract UTEMIS{    
4     /******************** Public constants ********************/
5     
6     // Days of ico since it is deployed
7     uint                                            public constant ICO_DAYS             = 59;
8 
9     // Minimum value accepted for investors. n wei / 10 ^ 18 = n Ethers
10     uint                                            public constant MIN_ACCEPTED_VALUE   = 50000000000000000 wei;
11 
12     // Value for each UTS
13     uint                                            public constant VALUE_OF_UTS         = 666666599999 wei;
14 
15     // Token name
16     string                                          public constant TOKEN_NAME           = "UTEMIS";
17     
18     // Symbol token
19     string                                          public constant TOKEN_SYMBOL         = "UTS";
20 
21     // Total supply of tokens
22     uint256                                         public constant TOTAL_SUPPLY         = 1 * 10 ** 12;    
23 
24     // The amount of tokens that will be offered during the ico
25     uint256                                         public constant ICO_SUPPLY           = 2 * 10 ** 11;
26 
27     // Minimum objective
28     uint256                                         public constant SOFT_CAP             = 10000 ether; // 10000 ETH
29 
30     // When the ico Starts - GMT Monday, January 8 , 2018 5:00:00 PM //1515430800;
31     uint                                            public constant START_ICO            = 1515430800;
32     
33     /******************** Public variables ********************/
34 
35     //Owner of the contract
36     address                                         public owner;    
37 
38     //Date of end ico
39     uint                                            public deadLine;        
40 
41     //Date of start ico
42     uint                                            public startTime;
43 
44     //Balances
45     mapping(address => uint256)                     public balance_;
46 
47     //Remaining tokens to offer during the ico
48     uint                                            public remaining;    
49 
50     //Time of bonus application, could be n minutes , n hours , n days , n weeks , n years 
51     uint[4]                                         private bonusTime                  = [3 days    , 17 days    , 31 days   , 59 days];
52 
53     //Amount of bonus applicated
54     uint8[4]                                        private bonusBenefit               = [uint8(40) , uint8(25)  , uint8(20) , uint8(15)];
55     uint8[4]                                        private bonusPerInvestion_5        = [uint8(0)  , uint8(5)   , uint8(3)  , uint8(2)];
56     uint8[4]                                        private bonusPerInvestion_10       = [uint8(0)  , uint8(10)  , uint8(5)  , uint8(3)];    
57 
58     //The accound that receives the ether when the ico is succesful. If not defined, the beneficiary will be the owner
59     address                                         private beneficiary;    
60 
61     //State of ico
62     bool                                            private ico_started;
63 
64     //Ethers collected during the ico
65     uint256                                         public ethers_collected;
66     
67     //ETH Balance of contract
68     uint256                                         private ethers_balance;
69         
70 
71     //Struct data for store investors
72     struct Investors{
73         uint256 amount;
74         uint when;        
75     }
76 
77     //Array for investors
78     mapping(address => Investors) private investorsList;     
79     address[] private investorsAddress;
80 
81     //Events
82     event Transfer(address indexed from , address indexed to , uint256 value);
83     event Burn(address indexed from, uint256 value);
84     event FundTransfer(address backer , uint amount , address investor);
85 
86     //Safe math
87     function safeSub(uint a , uint b) internal pure returns (uint){assert(b <= a);return a - b;}  
88     function safeAdd(uint a , uint b) internal pure returns (uint){uint c = a + b;assert(c>=a && c>=b);return c;}
89 
90     modifier onlyOwner() {
91         require(msg.sender == owner);
92         _;
93     }
94     
95     modifier icoStarted(){
96         require(ico_started == true);
97         require(now <= deadLine);
98         require(now >= START_ICO);
99         _;
100     }
101 
102     modifier icoStopped(){
103         require(ico_started == false);
104         require(now > deadLine);
105         _;        
106     }
107 
108     modifier minValue(){
109         require(msg.value >= MIN_ACCEPTED_VALUE);
110         _;
111     }
112 
113     //Contract constructor
114     function UTEMIS() public{          
115         balance_[msg.sender] = TOTAL_SUPPLY;                                         //Transfer all tokens to main account        
116         owner               = msg.sender;                                           //Set the variable owner to creator of contract                
117         deadLine            = START_ICO + ICO_DAYS * 1 days;                        //Declare deadLine        
118         startTime           = now;                                                  //Declare startTime of contract
119         remaining           = ICO_SUPPLY;                                           //The remaining tokens to sell
120         ico_started         = false;                                                //State of ico            
121     }
122 
123     /**
124      * For transfer tokens. Internal use, only can executed by this contract
125      *
126      * @param  _from         Source address
127      * @param  _to           Destination address
128      * @param  _value        Amount of tokens to send
129      */
130     function _transfer(address _from , address _to , uint _value) internal{        
131         require(_to != 0x0);                                                        //Prevent send tokens to 0x0 address        
132         require(balance_[_from] >= _value);                                          //Check if the sender have enough tokens        
133         require(balance_[_to] + _value > balance_[_to]);                              //Check for overflows        
134         balance_[_from]         = safeSub(balance_[_from] , _value);                 //Subtract from the source ( sender )        
135         balance_[_to]           = safeAdd(balance_[_to]   , _value);                 //Add tokens to destination        
136         uint previousBalance    = balance_[_from] + balance_[_to];                    //To make assert        
137         Transfer(_from , _to , _value);                                             //Fire event for clients        
138         assert(balance_[_from] + balance_[_to] == previousBalance);                   //Check the assert
139     }
140 
141     /**
142      * For transfer tokens from owner of contract
143      *
144      * @param  _to           Destination address
145      * @param  _value        Amount of tokens to send
146      */
147     function transfer(address _to , uint _value) public onlyOwner{                                             
148         _transfer(msg.sender , _to , _value);                                       //Internal transfer
149     }
150     
151     /**
152      * ERC20 Function to know's the balances
153      *
154      * @param  _owner           Address to check
155      * @return uint             Returns the balance of indicated address
156      */
157     function balanceOf(address _owner) constant public returns(uint balances){
158         return balance_[_owner];
159     }    
160 
161     /**
162      * Get investors info
163      *
164      * @return []                Returns an array with address of investors, amount invested and when invested
165      */
166     function getInvestors() constant public returns(address[] , uint[] , uint[]){
167         uint length = investorsAddress.length;                                             //Length of array
168         address[] memory addr = new address[](length);
169         uint[] memory amount  = new uint[](length);
170         uint[] memory when    = new uint[](length);
171         for(uint i = 0; i < length; i++){
172             address key = investorsAddress[i];
173             addr[i]     = key;
174             amount[i]   = investorsList[key].amount;
175             when[i]     = investorsList[key].when;
176         }
177         return (addr , amount , when);        
178     }
179 
180     /**
181      * Get total tokens distributeds
182      *
183      * @return uint              Returns total tokens distributeds
184      */
185     function getTokensDistributeds() constant public returns(uint){
186         return ICO_SUPPLY - remaining;
187     }
188 
189     /**
190      * Get amount of bonus to apply
191      *
192      * @param _ethers              Amount of ethers invested, for calculation the bonus     
193      * @return uint                Returns a % of bonification to apply
194      */
195     function getBonus(uint _ethers) public view returns(uint8){        
196         uint8 _bonus  = 0;                                                          //Assign bonus to 
197         uint8 _bonusPerInvestion = 0;
198         uint  starter = now - START_ICO;                                            //To control end time of bonus
199         for(uint i = 0; i < bonusTime.length; i++){                                 //For loop
200             if(starter <= bonusTime[i]){                                            //If the starter are greater than bonusTime, the bonus will be 0                
201                 if(_ethers >= 5 ether && _ethers < 10 ether){
202                     _bonusPerInvestion = bonusPerInvestion_5[i];
203                 }
204                 if(_ethers > 10 ether){
205                     _bonusPerInvestion = bonusPerInvestion_10[i];
206                 }
207                 _bonus = bonusBenefit[i];                                           //Asign amount of bonus to bonus_ variable                                
208                 break;                                                              //Break the loop
209 
210             }
211         }        
212         return _bonus + _bonusPerInvestion;
213     }
214     
215     /**
216      * Escale any value to n * 10 ^ 18
217      *
218      * @param  _value        Value to escale
219      * @return uint          Returns a escaled value
220      */
221     function escale(uint _value) private pure returns(uint){
222         return _value * 10 ** 18;
223     }
224 
225     /**
226      * Calculate the amount of tokens to sends depeding on the amount of ethers received
227      *
228      * @param  _ethers              Amount of ethers for convert to tokens
229      * @return uint                 Returns the amount of tokens to send
230      */
231     function getTokensToSend(uint _ethers) public view returns (uint){
232         uint tokensToSend  = 0;                                                     //Assign tokens to send to 0                                            
233         uint8 bonus        = getBonus(_ethers);                                     //Get amount of bonification        
234         uint ethToTokens   = _ethers / VALUE_OF_UTS;                                //Make the conversion, divide amount of ethers by value of each UTS                
235         uint amountBonus   = escale(ethToTokens) / 100 * escale(bonus);
236         uint _amountBonus  = amountBonus / 10 ** 36;
237              tokensToSend  = ethToTokens + _amountBonus;
238         return tokensToSend;
239     }
240 
241     /**
242      * Set the beneficiary of the contract, who receives Ethers
243      *
244      * @param _beneficiary          Address that will be who receives Ethers
245      */
246     function setBeneficiary(address _beneficiary) public onlyOwner{
247         require(msg.sender == owner);                                               //Prevents the execution of another than the owner
248         beneficiary = _beneficiary;                                                 //Set beneficiary
249     }
250 
251 
252     /**
253      * Start the ico manually
254      *     
255      */
256     function startIco() public onlyOwner{
257         ico_started = true;                                                         //Set the ico started
258     }
259 
260     /**
261      * Stop the ico manually
262      *
263      */
264     function stopIco() public onlyOwner{
265         ico_started = false;                                                        //Set the ico stopped
266     }
267 
268     /**
269      * Give back ethers to investors if soft cap is not reached
270      * 
271      */
272     function giveBackEthers() public onlyOwner icoStopped{
273         require(this.balance >= ethers_collected);                                         //Require that the contract have ethers 
274         uint length = investorsAddress.length;                                             //Length of array    
275         for(uint i = 0; i < length; i++){
276             address investorA = investorsAddress[i];            
277             uint amount       = investorsList[investorA].amount;
278             if(address(beneficiary) == 0){
279                 beneficiary = owner;
280             }
281             _transfer(investorA , beneficiary , balanceOf(investorA));
282             investorA.transfer(amount);
283         }
284     }
285 
286     
287     /**
288      * Fallback when the contract receives ethers
289      *
290      */
291     function () payable public icoStarted minValue{                              
292         uint amount_actually_invested = investorsList[msg.sender].amount;           //Get the actually amount invested
293         
294         if(amount_actually_invested == 0){                                          //If amount invested are equal to 0, will add like new investor
295             uint index                = investorsAddress.length++;
296             investorsAddress[index]   = msg.sender;
297             investorsList[msg.sender] = Investors(msg.value , now);                 //Store investors info        
298         }
299         
300         if(amount_actually_invested > 0){                                           //If amount invested are greater than 0
301             investorsList[msg.sender].amount += msg.value;                          //Increase the amount invested
302             investorsList[msg.sender].when    = now;                                //Change the last time invested
303         }
304 
305         uint tokensToSend = getTokensToSend(msg.value);                             //Calc the tokens to send depending on ethers received
306         remaining -= tokensToSend;                                                  //Subtract the tokens to send to remaining tokens        
307         _transfer(owner , msg.sender , tokensToSend);                               //Transfer tokens to investor
308         
309         require(balance_[owner] >= (TOTAL_SUPPLY - ICO_SUPPLY));                     //Requires not selling more tokens than those proposed in the ico        
310         require(balance_[owner] >= tokensToSend);
311         
312         if(address(beneficiary) == 0){                                              //Check if beneficiary is not setted
313             beneficiary = owner;                                                    //If not, set the beneficiary to owner
314         }    
315         ethers_collected += msg.value;                                              //Increase ethers_collected   
316         ethers_balance   += msg.value;
317         if(!beneficiary.send(msg.value)){
318             revert();
319         }                                                //Send ethers to beneficiary
320 
321         FundTransfer(owner , msg.value , msg.sender);                               //Fire events for clients
322     }
323 
324     /**
325      * Extend ICO time
326      *
327      * @param  timetoextend  Time in miliseconds to extend ico     
328      */
329     function extendICO(uint timetoextend) onlyOwner external{
330         require(timetoextend > 0);
331         deadLine+= timetoextend;
332     }
333     
334     /**
335      * Destroy contract and send ethers to owner
336      * 
337      */
338     function destroyContract() onlyOwner external{
339         selfdestruct(owner);
340     }
341 
342 
343 }