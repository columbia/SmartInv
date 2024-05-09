1 pragma solidity ^0.4.2;
2 //This project is beta stage and might contain unknown bugs.
3 //I am not responsible for any consequences of any use of the code or protocol that is suggested here.
4 contract SimpleMixer {
5     
6     struct Deal{
7         mapping(address=>uint) deposit;
8         uint                   depositSum;
9         mapping(address=>bool) claims;
10 	    uint 		           numClaims;
11         uint                   claimSum;
12 
13         uint                   startTime;
14         uint                   depositDurationInSec;
15         uint                   claimDurationInSec;
16         uint                   claimDepositInWei;
17         uint                   claimValueInWei;
18      	uint                   minNumClaims;
19         
20         bool                   active;
21         bool                   fullyFunded;
22     }
23     
24     Deal[]  _deals;
25      
26     event NewDeal( address indexed user, uint indexed _dealId, uint _startTime, uint _depositDurationInHours, uint _claimDurationInHours, uint _claimUnitValueInWei, uint _claimDepositInWei, uint _minNumClaims, bool _success, string _err );
27     event Claim( address indexed _claimer, uint indexed _dealId, bool _success, string _err );
28     event Deposit( address indexed _depositor, uint indexed _dealId, uint _value, bool _success, string _err );
29     event Withdraw( address indexed _withdrawer, uint indexed _dealId, uint _value, bool _public, bool _success, string _err );
30 
31     event EnoughClaims( uint indexed _dealId );
32     event DealFullyFunded( uint indexed _dealId );
33     
34     enum ReturnValue { Ok, Error }
35 
36     function SimpleMixer(){
37     }
38     
39     function newDeal( uint _depositDurationInHours, uint _claimDurationInHours, uint _claimUnitValueInWei, uint _claimDepositInWei, uint _minNumClaims ) returns(ReturnValue){
40         uint dealId = _deals.length;        
41         if( _depositDurationInHours == 0 || _claimDurationInHours == 0 ){
42         	NewDeal( msg.sender,
43         	         dealId,
44         	         now,
45         	         _depositDurationInHours,
46         	         _claimDurationInHours,
47         	         _claimUnitValueInWei,
48         	         _claimDepositInWei,
49         	         _minNumClaims,
50         	         false,
51         	         "_depositDurationInHours and _claimDurationInHours must be positive" );
52             return ReturnValue.Error;
53         }
54         _deals.length++;
55         _deals[dealId].depositSum = 0;
56 	    _deals[dealId].numClaims = 0;
57         _deals[dealId].claimSum = 0;
58         _deals[dealId].startTime = now;
59         _deals[dealId].depositDurationInSec = _depositDurationInHours * 1 hours;
60         _deals[dealId].claimDurationInSec = _claimDurationInHours * 1 hours;
61         _deals[dealId].claimDepositInWei = _claimDepositInWei;
62         _deals[dealId].claimValueInWei = _claimUnitValueInWei;
63 	    _deals[dealId].minNumClaims = _minNumClaims;
64         _deals[dealId].fullyFunded = false;
65         _deals[dealId].active = true;
66     	NewDeal( msg.sender,
67     	         dealId,
68     	         now,
69     	         _depositDurationInHours,
70     	         _claimDurationInHours,
71     	         _claimUnitValueInWei,
72     	         _claimDepositInWei,
73     	         _minNumClaims,
74     	         true,
75     	         "all good" );
76         return ReturnValue.Ok;
77     }
78     
79     function makeClaim( uint dealId ) payable returns(ReturnValue){
80         Deal deal = _deals[dealId];        
81         bool errorDetected = false;
82         string memory error;
83     	// validations
84     	if( !_deals[dealId].active ){
85     	    error = "deal is not active";
86     	    //ErrorLog( msg.sender, dealId, "makeClaim: deal is not active");
87     	    errorDetected = true;
88     	}
89         if( deal.startTime + deal.claimDurationInSec < now ){
90             error = "claim phase already ended";            
91             //ErrorLog( msg.sender, dealId, "makeClaim: claim phase already ended" );
92             errorDetected = true;
93         }
94         if( msg.value != deal.claimDepositInWei ){
95             error = "msg.value must be equal to claim deposit unit";            
96             //ErrorLog( msg.sender, dealId, "makeClaim: msg.value must be equal to claim deposit unit" );
97             errorDetected = true;
98         }
99     	if( deal.claims[msg.sender] ){
100     	    error = "cannot claim twice with the same address";
101             //ErrorLog( msg.sender, dealId, "makeClaim: cannot claim twice with the same address" );
102             errorDetected = true;
103     	}
104     	
105     	if( errorDetected ){
106     	    Claim( msg.sender, dealId, false, error );
107     	    if( ! msg.sender.send(msg.value) ) throw; // send money back
108     	    return ReturnValue.Error;
109     	}
110 
111 	    // actual claim
112         deal.claimSum += deal.claimValueInWei;
113         deal.claims[msg.sender] = true;
114 	    deal.numClaims++;
115 
116 	    Claim( msg.sender, dealId, true, "all good" );
117 	    
118 	    if( deal.numClaims == deal.minNumClaims ) EnoughClaims( dealId );
119 	    
120     	return ReturnValue.Ok;
121     }
122 
123     function makeDeposit( uint dealId ) payable returns(ReturnValue){
124         bool errorDetected = false;
125         string memory error;
126     	// validations
127         if( msg.value == 0 ){
128             error = "deposit value must be positive";
129             //ErrorLog( msg.sender, dealId, "makeDeposit: deposit value must be positive");
130             errorDetected = true;
131         }
132     	if( !_deals[dealId].active ){
133     	    error = "deal is not active";
134     	    //ErrorLog( msg.sender, dealId, "makeDeposit: deal is not active");
135     	    errorDetected = true;
136     	}
137         Deal deal = _deals[dealId];
138         if( deal.startTime + deal.claimDurationInSec > now ){
139             error = "contract is still in claim phase";
140     	    //ErrorLog( msg.sender, dealId, "makeDeposit: contract is still in claim phase");
141     	    errorDetected = true;
142         }
143         if( deal.startTime + deal.claimDurationInSec + deal.depositDurationInSec < now ){
144             error = "deposit phase is over";
145     	    //ErrorLog( msg.sender, dealId, "makeDeposit: deposit phase is over");
146     	    errorDetected = true;
147         }
148         if( ( msg.value % deal.claimValueInWei ) > 0 ){
149             error = "deposit value must be a multiple of claim value";
150     	    //ErrorLog( msg.sender, dealId, "makeDeposit: deposit value must be a multiple of claim value");
151     	    errorDetected = true;
152         }
153     	if( deal.deposit[msg.sender] > 0 ){
154     	    error = "cannot deposit twice with the same address";
155     	    //ErrorLog( msg.sender, dealId, "makeDeposit: cannot deposit twice with the same address");
156     	    errorDetected = true;
157     	}
158     	if( deal.numClaims < deal.minNumClaims ){
159     	    error = "deal is off as there are not enough claims. Call withdraw with you claimer address";
160     	    /*ErrorLog( msg.sender,
161     	              dealId,
162     	              "makeDeposit: deal is off as there are not enough claims. Call withdraw with you claimer address");*/
163     	    errorDetected = true;
164     	}
165     	
166     	if( errorDetected ){
167     	    Deposit( msg.sender, dealId, msg.value, false, error );
168     	    if( ! msg.sender.send(msg.value) ) throw; // send money back
169     	    return ReturnValue.Error;
170     	}
171         
172 	    // actual deposit
173         deal.depositSum += msg.value;
174         deal.deposit[msg.sender] = msg.value;
175 
176     	if( deal.depositSum >= deal.claimSum ){
177     	    deal.fullyFunded = true;
178     	    DealFullyFunded( dealId );
179     	}
180     
181     	Deposit( msg.sender, dealId, msg.value, true, "all good" );
182 	    return ReturnValue.Ok;    	
183     }
184         
185     function withdraw( uint dealId ) returns(ReturnValue){
186     	// validation
187         bool errorDetected = false;
188         string memory error;
189         Deal deal = _deals[dealId];
190     	bool enoughClaims = deal.numClaims >= deal.minNumClaims;
191     	if( ! enoughClaims ){
192     	    if( deal.startTime + deal.claimDurationInSec > now ){
193     	        error = "claim phase not over yet";
194     	        //ErrorLog( msg.sender, dealId, "withdraw: claim phase not over yet");
195     	        errorDetected = true;
196     	    }
197     	}
198     	else{
199     	    if( deal.startTime + deal.depositDurationInSec + deal.claimDurationInSec > now ){
200     	        error = "deposit phase not over yet";
201     	        //ErrorLog( msg.sender, dealId, "withdraw: deposit phase not over yet");
202     	        errorDetected = true;
203     	    }
204     	}
205     	
206     	if( errorDetected ){
207     	    Withdraw( msg.sender, dealId, 0, false, false, error );
208         	return ReturnValue.Error; // note that function is not payable    	    
209     	}
210 
211 
212 	    // actual withdraw
213 	    bool publicWithdraw;
214     	uint withdrawedValue = 0;
215         if( (! deal.fullyFunded) && enoughClaims ){
216 	        publicWithdraw = true;
217             uint depositValue = deal.deposit[msg.sender];
218             if( depositValue == 0 ){
219                 Withdraw( msg.sender, dealId, 0, publicWithdraw, false, "address made no deposit. Note that this should be called with the public address" );
220     	        //ErrorLog( msg.sender, dealId, "withdraw: address made no deposit. Note that this should be called with the public address");
221     	        return ReturnValue.Error; // function non payable
222             }
223             
224             uint effectiveNumDeposits = deal.depositSum / deal.claimValueInWei;
225             uint userEffectiveNumDeposits = depositValue / deal.claimValueInWei;
226             uint extraBalance = ( deal.numClaims - effectiveNumDeposits ) * deal.claimDepositInWei;
227             uint userExtraBalance = userEffectiveNumDeposits * extraBalance / effectiveNumDeposits;
228 
229             deal.deposit[msg.sender] = 0; // invalidate user
230             // give only half of extra balance. otherwise dishonest party could obtain 99% of the extra balance and lose almost nothing
231 	        withdrawedValue = depositValue + deal.claimDepositInWei * userEffectiveNumDeposits + ( userExtraBalance / 2 );
232             if( ! msg.sender.send(withdrawedValue) ) throw;
233         }
234         else{
235     	    publicWithdraw = false;
236             if( ! deal.claims[msg.sender] ){
237                 Withdraw( msg.sender, dealId, 0, publicWithdraw, false, "address made no claims. Note that this should be called with the secret address" );
238     	        //ErrorLog( msg.sender, dealId, "withdraw: address made no claims. Note that this should be called with the secret address");
239     	        return ReturnValue.Error; // function non payable
240             }
241 	        if( enoughClaims ) withdrawedValue = deal.claimDepositInWei + deal.claimValueInWei;
242 	        else withdrawedValue = deal.claimDepositInWei;
243 		
244             deal.claims[msg.sender] = false; // invalidate claim
245             if( ! msg.sender.send(withdrawedValue) ) throw;
246         }
247 	    
248         Withdraw( msg.sender, dealId, withdrawedValue, publicWithdraw, true, "all good" );
249         return ReturnValue.Ok;
250     }    
251 
252     ////////////////////////////////////////////////////////////////////////////////////////
253     
254     function dealStatus(uint _dealId) constant returns(uint[4]){
255         // returns (active, num claims, claim sum, deposit sum) all as integers
256         uint active = _deals[_dealId].active ? 1 : 0;
257         uint numClaims = _deals[_dealId].numClaims;
258         uint claimSum = _deals[_dealId].claimSum;
259 	    uint depositSum = _deals[_dealId].depositSum;
260         
261         return [active, numClaims, claimSum, depositSum];
262     }
263 
264 }