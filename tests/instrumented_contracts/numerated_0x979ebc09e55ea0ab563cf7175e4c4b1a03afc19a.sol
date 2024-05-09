1 pragma solidity ^0.4.24;
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
21         uint256 public constant INITIAL_SUPPLY  = 1000000000 * TOKEN_ESCALE; // 1000000000000000000000 Smart contract UNITS | 1.000.000.000,000000000000 Ethereum representation
22         uint256 public constant TGE_SUPPLY      = 1000000000 * TOKEN_ESCALE;  // 1000000000000000000000 Smart contract UNITS  |  1.000.000.000,000000000000 Ethereum representation
23 
24         uint public constant MIN_ACCEPTED_VALUE = 250000000000000000 wei;
25         uint public constant VALUE_OF_UTS       = 25000000000000 wei;        // 0.000025 ETH = 1 UTS
26 
27         uint public constant START_TGE          = 1537110000; // 16 SEPT 2018 15:00:00 GMT | 16 SEPT 2018 17:00:00 GMT+2
28 
29         string public constant TOKEN_NAME       = "UTEMIS";
30         string public constant TOKEN_SYMBOL     = "UTS";
31 
32     /*------------------- Finish public constants -------------------*/
33 
34 
35     /******************** Start private NO-Constants variables ********************/
36     
37         uint[4]  private bonusTime             = [7 days     , 14 days     , 21 days   , 28 days];        
38         uint8[4] private bonusBenefit          = [uint8(25)  , uint8(15)   , uint8(10) , uint8(5)];
39         uint8[4] private bonusPerInvestion_10  = [uint8(2)   , uint8(2)    , uint8(2)  , uint8(2)];
40         uint8[4] private bonusPerInvestion_20  = [uint8(4)   , uint8(4)    , uint8(4)  , uint8(4)];
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
51         uint256 public totalSupply = INITIAL_SUPPLY;
52         bool public tgeStarted;            
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
82     modifier tgeIsStarted(){
83         require(tgeStarted == true);        
84         require(now >= START_TGE);      
85         _;
86     }
87 
88     modifier tgeIsStopped(){
89         require(tgeStarted == false); 
90         _;
91     }
92 
93     modifier minValue(){
94         require(msg.value >= MIN_ACCEPTED_VALUE);
95         _;
96     }
97 
98     constructor() public{
99         balances[msg.sender] = totalSupply;
100         owner                = msg.sender;        
101         tgeStarted           = true;
102         beneficiary          = 0x1F3fd98152f978f74349Fe2a25730Fe73e431BD8;
103     }
104 
105 
106     /**
107      * ERC20
108      */
109     function balanceOf(address _owner) public view returns(uint256 balance){
110         return balances[_owner];
111     }
112 
113     /**
114      * ERC20
115      */
116     function totalSupply() constant public returns(uint256 supply){
117         return totalSupply;
118     }
119 
120 
121 
122     /**
123      * For transfer tokens. Internal use, only can executed by this contract ERC20
124      * ERC20
125      * @param  _from         Source address
126      * @param  _to           Destination address
127      * @param  _value        Amount of tokens to send
128      */
129     function _transfer(address _from , address _to , uint _value) internal{        
130         require(_to != 0x0);                                                          //Prevent send tokens to 0x0 address        
131         require(balances[_from] >= _value);                                           //Check if the sender have enough tokens        
132         require(balances[_to] + _value > balances[_to]);                              //Check for overflows        
133         balances[_from]         = safeSub(balances[_from] , _value);                  //Subtract from the source ( sender )        
134         balances[_to]           = safeAdd(balances[_to]   , _value);                  //Add tokens to destination        
135         uint previousBalance    = balances[_from] + balances[_to];                    //To make assert        
136         emit Transfer(_from , _to , _value);                                               //Fire event for clients        
137         assert(balances[_from] + balances[_to] == previousBalance);                   //Check the assert
138     }
139 
140 
141     /**
142      * Commonly transfer tokens 
143      * ERC20
144      * @param  _to           Destination address
145      * @param  _value        Amount of tokens to send
146      */
147     function transfer(address _to , uint _value) public returns (bool success){        
148         _transfer(msg.sender , _to , _value);
149         return true;
150     }
151 
152 
153     /**
154      * Transfer token from address to another address that's allowed to. 
155      * ERC20
156      * @param _from          Source address
157      * @param _to            Destination address
158      * @param _value         Amount of tokens to send
159      */   
160     function transferFrom(address _from , address _to , uint256 _value) public returns (bool success){
161         if(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
162             _transfer(_from , _to , _value);
163             allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender] , _value);
164             return true;
165         }else{
166             return false;
167         }
168     }
169 
170     /**
171      * Approve spender to transfer amount of tokens from your address ERC20
172      * ERC20
173      * @param _spender       Address that can transfer tokens from your address
174      * @param _value         Amount of tokens that can be sended by spender
175      */   
176     function approve(address _spender , uint256 _value) public returns (bool success){
177         allowed[msg.sender][_spender] = _value;
178         emit Approval(msg.sender , _spender , _value);
179         return true;
180     }
181 
182     /**
183      * Returns the amount of tokens allowed by owner to spender ERC20
184      * ERC20
185      * @param _owner         Source address that allow's spend tokens
186      * @param _spender       Address that can transfer tokens form allowed     
187      */   
188     function allowance(address _owner , address _spender) public view returns(uint256 allowance_){
189         return allowed[_owner][_spender];
190     }
191 
192 
193     /**
194      * Get investors info
195      *
196      * @return []                Returns an array with address of investors, amount invested and when invested
197      */
198     function getInvestors() constant public returns(address[] , uint[] , uint[]){
199         uint length = investorsAddress.length;                                             //Length of array
200         address[] memory addr = new address[](length);
201         uint[] memory amount  = new uint[](length);
202         uint[] memory when    = new uint[](length);
203         for(uint i = 0; i < length; i++){
204             address key = investorsAddress[i];
205             addr[i]     = key;
206             amount[i]   = investorsList[key].amount;
207             when[i]     = investorsList[key].when;
208         }
209         return (addr , amount , when);        
210     }
211 
212 
213     /**
214      * Get amount of bonus to apply
215      *
216      * @param _ethers              Amount of ethers invested, for calculation the bonus     
217      * @return uint                Returns a % of bonification to apply
218      */
219     function getBonus(uint _ethers) public view returns(uint8){        
220         uint8 _bonus  = 0;                                                          //Assign bonus to 
221         uint8 _bonusPerInvestion = 0;
222         uint  starter = now - START_TGE;                                            //To control end time of bonus
223         for(uint i = 0; i < bonusTime.length; i++){                                 //For loop
224             if(starter <= bonusTime[i]){                                            //If the starter are greater than bonusTime, the bonus will be 0                
225                 if(_ethers > 10 ether && _ethers <= 20 ether){
226                     _bonusPerInvestion = bonusPerInvestion_10[i];
227                 }
228                 if(_ethers > 20 ether){
229                     _bonusPerInvestion = bonusPerInvestion_20[i];
230                 }
231                 _bonus = bonusBenefit[i];                                           //Asign amount of bonus to bonus_ variable                                
232                 break;                                                              //Break the loop
233 
234             }
235         }        
236         return _bonus + _bonusPerInvestion;
237     }
238 
239     /**
240      * Calculate the amount of tokens to sends depeding on the amount of ethers received
241      *
242      * @param  _ethers              Amount of ethers for convert to tokens
243      * @return uint                 Returns the amount of tokens to send
244      */
245     function getTokensToSend(uint _ethers) public view returns (uint){
246         uint tokensToSend  = 0;                                                     //Assign tokens to send to 0                                            
247         uint8 bonus        = getBonus(_ethers);                                     //Get amount of bonification                                    
248         uint ethToTokens   = (_ethers * 10 ** uint256(TOKEN_DECIMAL)) / VALUE_OF_UTS;                                //Make the conversion, divide amount of ethers by value of each UTS                
249         uint amountBonus   = ethToTokens / 100 * bonus;
250              tokensToSend  = ethToTokens + amountBonus;
251         return tokensToSend;
252     }
253     
254     /**
255      * Increase the total supply of tokens
256      *
257      * @param amount                Amount of tokens to add
258      */
259     function inflateSupply(uint amount) public onlyOwner returns (bool success){
260         require(amount > 0);        
261         totalSupply+= amount;        
262         balances[owner] = safeAdd(balances[owner]   , amount);                  //Add tokens to destination               
263         emit Transfer(0x0 , owner , amount);                                    //Fire event for clients        
264         return true;
265     }
266 
267     /**
268      * Destroy amount of tokens
269      *
270      * @param amount                Amount of tokens to destroy
271      */
272     function burn(uint amount) public onlyOwner returns (bool success){
273         require(balances[owner] >= amount);
274         totalSupply-= amount;
275         balances[owner] = safeSub(balances[owner] , amount);
276         emit Burn(owner , amount);
277         emit Transfer(owner , 0x0 , amount);
278         return true;
279     }
280 
281     /**
282      * Fallback when the contract receives ethers
283      *
284      */
285     function () payable public tgeIsStarted minValue{                              
286         uint amount_actually_invested = investorsList[msg.sender].amount;           //Get the actually amount invested
287         
288         if(amount_actually_invested == 0){                                          //If amount invested are equal to 0, will add like new investor
289             uint index                = investorsAddress.length++;
290             investorsAddress[index]   = msg.sender;
291             investorsList[msg.sender] = Investors(msg.value , now);                 //Store investors info        
292         }
293         
294         if(amount_actually_invested > 0){                                           //If amount invested are greater than 0
295             investorsList[msg.sender].amount += msg.value;                          //Increase the amount invested
296             investorsList[msg.sender].when    = now;                                //Change the last time invested
297         }
298         
299         uint tokensToSend = getTokensToSend(msg.value);                             //Calc the tokens to send depending on ethers received
300         tokensSold += tokensToSend;             
301 
302         require(balances[owner] >= tokensToSend);
303         _transfer(owner , msg.sender , tokensToSend);        
304         ethersCollecteds   += msg.value;
305         if(beneficiary == address(0)){
306             beneficiary = owner;
307         }
308         beneficiary.transfer(msg.value);            
309         emit FundTransfer(owner , msg.value , msg.sender);                          //Fire events for clients
310     }
311 
312 
313     /**
314      * Start the TGE manually
315      *     
316      */
317     function startTge() public onlyOwner{
318         tgeStarted = true;                                                         //Set the TGE started
319     }
320 
321     /**
322      * Stop the TGE manually
323      *
324      */
325     function stopTge() public onlyOwner{
326         tgeStarted = false;                                                        //Set the TGE stopped
327     }
328 
329 
330     function setBeneficiary(address _beneficiary) public onlyOwner{
331         beneficiary = _beneficiary;
332     }
333     
334     function destroyContract()external onlyOwner{
335         selfdestruct(owner);
336     }
337     
338 }