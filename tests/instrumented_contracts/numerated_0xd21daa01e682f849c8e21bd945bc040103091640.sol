1 pragma solidity ^0.4.19;
2 contract ERC20 {
3     function totalSupply() public view returns (uint supply);
4     function balanceOf( address _owner ) public view returns (uint balance);
5     function allowance( address _owner, address _spender ) public view returns (uint allowance_);
6 
7     function transfer( address _to, uint _value)public returns (bool success);
8     function transferFrom( address _from, address _to, uint _value)public returns (bool success);
9     function approve( address _spender, uint _value )public returns (bool success);
10 
11     event Transfer( address indexed from, address indexed to, uint value);
12     event Approval( address indexed _owner, address indexed _spender, uint value);
13 }
14 
15 
16 contract UTEMIS is ERC20{            
17 
18         uint8 public constant TOKEN_DECIMAL     = 18;        
19         uint256 public constant TOKEN_ESCALE    = 1 * 10 ** uint256(TOKEN_DECIMAL); 
20                                               
21         uint256 public constant TOTAL_SUPPLY    = 1000000000000 * TOKEN_ESCALE; // 1000000000000000000000000 Smart contract UNITS | 1.000.000.000.000,000000000000 Ethereum representation
22         uint256 public constant ICO_SUPPLY      = 250000000000 * TOKEN_ESCALE;  // 250000000000000000000000 Smart contract UNITS  | 200.000.000.000,000000000000 Ethereum representation
23 
24         uint public constant MIN_ACCEPTED_VALUE = 50000000000000000 wei;
25         uint public constant VALUE_OF_UTS       = 666666599999 wei;
26 
27         uint public constant START_ICO          = 1518714000; // 15 Feb 2018 17:00:00 GMT | 15 Feb 2018 18:00:00 GMT+1
28 
29         string public constant TOKEN_NAME       = "UTEMIS";
30         string public constant TOKEN_SYMBOL     = "UTS";
31 
32     /*------------------- Finish public constants -------------------*/
33 
34 
35     /******************** Start private NO-Constants variables ********************/
36     
37         uint[4]  private bonusTime             = [14 days , 45 days , 74 days];        
38         uint8[4] private bonusBenefit          = [uint8(50)  , uint8(30)   , uint8(10)];
39         uint8[4] private bonusPerInvestion_10  = [uint8(25)  , uint8(15)   , uint8(5)];
40         uint8[4] private bonusPerInvestion_50  = [uint8(50)  , uint8(30)   , uint8(20)];
41     
42     /*------------------- Finish private NO-Constants variables -------------------*/
43 
44 
45     /******************** Start public NO-Constants variables ********************/        
46        
47         address public owner;
48         address public beneficiary;            
49         uint public ethersCollecteds;
50         uint public tokensSold;
51         uint256 public totalSupply = TOTAL_SUPPLY;
52         bool public icoStarted;            
53         mapping(address => uint256) public balances;    
54         mapping(address => Investors) public investorsList;
55         mapping(address => mapping (address => uint256)) public allowed;
56         address[] public investorsAddress;    
57         string public name     = TOKEN_NAME;
58         uint8 public decimals  = TOKEN_DECIMAL;
59         string public symbol   = TOKEN_SYMBOL;
60    
61     /*------------------- Finish public NO-Constants variables -------------------*/    
62 
63     struct Investors{
64         uint256 amount;
65         uint when;
66     }
67 
68     event Transfer(address indexed from , address indexed to , uint256 value);
69     event Approval(address indexed _owner , address indexed _spender , uint256 _value);
70     event Burn(address indexed from, uint256 value);
71     event FundTransfer(address backer , uint amount , address investor);
72 
73     //Safe math
74     function safeSub(uint a , uint b) internal pure returns (uint){assert(b <= a);return a - b;}  
75     function safeAdd(uint a , uint b) internal pure returns (uint){uint c = a + b;assert(c>=a && c>=b);return c;}
76     
77     modifier onlyOwner() {
78         require(msg.sender == owner);
79         _;
80     }
81     
82     modifier icoIsStarted(){
83         require(icoStarted == true);        
84         require(now >= START_ICO);      
85         _;
86     }
87 
88     modifier icoIsStopped(){
89         require(icoStarted == false); 
90         _;
91     }
92 
93     modifier minValue(){
94         require(msg.value >= MIN_ACCEPTED_VALUE);
95         _;
96     }
97 
98     function UTEMIS() public{
99         balances[msg.sender] = totalSupply;
100         owner               = msg.sender;        
101     }
102 
103 
104     /**
105      * ERC20
106      */
107     function balanceOf(address _owner) public view returns(uint256 balance){
108         return balances[_owner];
109     }
110 
111     /**
112      * ERC20
113      */
114     function totalSupply() constant public returns(uint256 supply){
115         return totalSupply;
116     }
117 
118 
119 
120     /**
121      * For transfer tokens. Internal use, only can executed by this contract ERC20
122      * ERC20
123      * @param  _from         Source address
124      * @param  _to           Destination address
125      * @param  _value        Amount of tokens to send
126      */
127     function _transfer(address _from , address _to , uint _value) internal{        
128         require(_to != 0x0);                                                          //Prevent send tokens to 0x0 address        
129         require(balances[_from] >= _value);                                           //Check if the sender have enough tokens        
130         require(balances[_to] + _value > balances[_to]);                              //Check for overflows        
131         balances[_from]         = safeSub(balances[_from] , _value);                  //Subtract from the source ( sender )        
132         balances[_to]           = safeAdd(balances[_to]   , _value);                  //Add tokens to destination        
133         uint previousBalance    = balances[_from] + balances[_to];                    //To make assert        
134         Transfer(_from , _to , _value);                                               //Fire event for clients        
135         assert(balances[_from] + balances[_to] == previousBalance);                   //Check the assert
136     }
137 
138 
139     /**
140      * Commonly transfer tokens 
141      * ERC20
142      * @param  _to           Destination address
143      * @param  _value        Amount of tokens to send
144      */
145     function transfer(address _to , uint _value) public returns (bool success){        
146         _transfer(msg.sender , _to , _value);
147         return true;
148     }
149 
150 
151     /**
152      * Transfer token from address to another address that's allowed to. 
153      * ERC20
154      * @param _from          Source address
155      * @param _to            Destination address
156      * @param _value         Amount of tokens to send
157      */   
158     function transferFrom(address _from , address _to , uint256 _value) public returns (bool success){
159         if(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
160             _transfer(_from , _to , _value);
161             allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender] , _value);
162             return true;
163         }else{
164             return false;
165         }
166     }
167 
168     /**
169      * Approve spender to transfer amount of tokens from your address ERC20
170      * ERC20
171      * @param _spender       Address that can transfer tokens from your address
172      * @param _value         Amount of tokens that can be sended by spender
173      */   
174     function approve(address _spender , uint256 _value) public returns (bool success){
175         allowed[msg.sender][_spender] = _value;
176         Approval(msg.sender , _spender , _value);
177         return true;
178     }
179 
180     /**
181      * Returns the amount of tokens allowed by owner to spender ERC20
182      * ERC20
183      * @param _owner         Source address that allow's spend tokens
184      * @param _spender       Address that can transfer tokens form allowed     
185      */   
186     function allowance(address _owner , address _spender) public view returns(uint256 allowance_){
187         return allowed[_owner][_spender];
188     }
189 
190 
191     /**
192      * Get investors info
193      *
194      * @return []                Returns an array with address of investors, amount invested and when invested
195      */
196     function getInvestors() constant public returns(address[] , uint[] , uint[]){
197         uint length = investorsAddress.length;                                             //Length of array
198         address[] memory addr = new address[](length);
199         uint[] memory amount  = new uint[](length);
200         uint[] memory when    = new uint[](length);
201         for(uint i = 0; i < length; i++){
202             address key = investorsAddress[i];
203             addr[i]     = key;
204             amount[i]   = investorsList[key].amount;
205             when[i]     = investorsList[key].when;
206         }
207         return (addr , amount , when);        
208     }
209 
210 
211     /**
212      * Get amount of bonus to apply
213      *
214      * @param _ethers              Amount of ethers invested, for calculation the bonus     
215      * @return uint                Returns a % of bonification to apply
216      */
217     function getBonus(uint _ethers) public view returns(uint8){        
218         uint8 _bonus  = 0;                                                          //Assign bonus to 
219         uint8 _bonusPerInvestion = 0;
220         uint  starter = now - START_ICO;                                            //To control end time of bonus
221         for(uint i = 0; i < bonusTime.length; i++){                                 //For loop
222             if(starter <= bonusTime[i]){                                            //If the starter are greater than bonusTime, the bonus will be 0                
223                 if(_ethers > 10 ether && _ethers <= 50 ether){
224                     _bonusPerInvestion = bonusPerInvestion_10[i];
225                 }
226                 if(_ethers > 50 ether){
227                     _bonusPerInvestion = bonusPerInvestion_50[i];
228                 }
229                 _bonus = bonusBenefit[i];                                           //Asign amount of bonus to bonus_ variable                                
230                 break;                                                              //Break the loop
231 
232             }
233         }        
234         return _bonus + _bonusPerInvestion;
235     }
236 
237     /**
238      * Calculate the amount of tokens to sends depeding on the amount of ethers received
239      *
240      * @param  _ethers              Amount of ethers for convert to tokens
241      * @return uint                 Returns the amount of tokens to send
242      */
243     function getTokensToSend(uint _ethers) public view returns (uint){
244         uint tokensToSend  = 0;                                                     //Assign tokens to send to 0                                            
245         uint8 bonus        = getBonus(_ethers);                                     //Get amount of bonification                                    
246         uint ethToTokens   = (_ethers * 10 ** uint256(TOKEN_DECIMAL)) / VALUE_OF_UTS;                                //Make the conversion, divide amount of ethers by value of each UTS                
247         uint amountBonus   = ethToTokens / 100 * bonus;
248              tokensToSend  = ethToTokens + amountBonus;
249         return tokensToSend;
250     }
251 
252     /**
253      * Fallback when the contract receives ethers
254      *
255      */
256     function () payable public icoIsStarted minValue{                              
257         uint amount_actually_invested = investorsList[msg.sender].amount;           //Get the actually amount invested
258         
259         if(amount_actually_invested == 0){                                          //If amount invested are equal to 0, will add like new investor
260             uint index                = investorsAddress.length++;
261             investorsAddress[index]   = msg.sender;
262             investorsList[msg.sender] = Investors(msg.value , now);                 //Store investors info        
263         }
264         
265         if(amount_actually_invested > 0){                                           //If amount invested are greater than 0
266             investorsList[msg.sender].amount += msg.value;                          //Increase the amount invested
267             investorsList[msg.sender].when    = now;                                //Change the last time invested
268         }
269 
270         
271         uint tokensToSend = getTokensToSend(msg.value);                             //Calc the tokens to send depending on ethers received
272         tokensSold += tokensToSend;        
273         require(balances[owner] >= tokensToSend);
274         
275         _transfer(owner , msg.sender , tokensToSend);                               //Transfer tokens to investor                                
276         ethersCollecteds   += msg.value;
277 
278         if(beneficiary == address(0)){
279             beneficiary = owner;
280         }
281         beneficiary.transfer(msg.value);
282         FundTransfer(owner , msg.value , msg.sender);                               //Fire events for clients
283     }
284 
285 
286     /**
287      * Start the ico manually
288      *     
289      */
290     function startIco() public onlyOwner{
291         icoStarted = true;                                                         //Set the ico started
292     }
293 
294     /**
295      * Stop the ico manually
296      *
297      */
298     function stopIco() public onlyOwner{
299         icoStarted = false;                                                        //Set the ico stopped
300     }
301 
302 
303     function setBeneficiary(address _beneficiary) public onlyOwner{
304         beneficiary = _beneficiary;
305     }
306     
307     function destroyContract()external onlyOwner{
308         selfdestruct(owner);
309     }
310     
311 }