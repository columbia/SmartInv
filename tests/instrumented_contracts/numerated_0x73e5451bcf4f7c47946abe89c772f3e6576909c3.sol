1 pragma solidity ^0.4.18;
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
32 /**
33  * @title Ownable
34  * @dev The Ownable contract has an owner address, and provides basic authorization control
35  * functions, this simplifies the implementation of "user permissions".
36  */
37 contract Ownable {
38   address public owner;
39 
40 
41   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43 
44   /**
45    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46    * account.
47    */
48   function Ownable() public {
49     owner = msg.sender;
50   }
51 
52 
53   /**
54    * @dev Throws if called by any account other than the owner.
55    */
56   modifier onlyOwner() {
57     require(msg.sender == owner);
58     _;
59   }
60 
61 
62   /**
63    * @dev Allows the current owner to transfer control of the contract to a newOwner.
64    * @param newOwner The address to transfer ownership to.
65    */
66   function transferOwnership(address newOwner) public onlyOwner {
67     require(newOwner != address(0));
68     OwnershipTransferred(owner, newOwner);
69     owner = newOwner;
70   }
71 
72 }
73 
74 
75 
76 
77 contract DragonPricing is Ownable {
78     
79    
80     
81     DragonCrowdsaleCore dragoncrowdsalecore;
82     uint public firstroundprice  = .000000000083333333 ether;
83     uint public secondroundprice = .000000000100000000 ether;
84     uint public thirdroundprice  = .000000000116686114 ether;
85     
86     uint public price;
87     
88     
89     function DragonPricing() {
90         
91         
92         price = firstroundprice;
93         
94         
95     }
96     
97     
98     
99     
100     function crowdsalepricing( address tokenholder, uint amount, uint crowdsaleCounter )  returns ( uint , uint ) {
101         
102         uint award;
103         uint donation = 0;
104         return ( DragonAward ( amount, crowdsaleCounter ) ,donation );
105         
106     }
107     
108     
109     function precrowdsalepricing( address tokenholder, uint amount )   returns ( uint, uint )  {
110         
111        
112         uint award;
113         uint donation;
114         require ( presalePackage( amount ) == true );
115         ( award, donation ) = DragonAwardPresale ( amount );
116         
117         return ( award, donation );
118         
119     }
120     
121     
122     function presalePackage ( uint amount ) internal returns ( bool )  {
123         
124         if( amount != .3333333 ether && amount != 3.3333333 ether && amount != 33.3333333 ether  ) return false;
125         return true;
126    }
127     
128     
129     function DragonAwardPresale ( uint amount ) internal returns ( uint , uint ){
130         
131         if ( amount ==   .3333333 ether ) return   (   10800000000 ,   800000000 );
132         if ( amount ==  3.3333333 ether ) return   (  108800000000 ,  8800000000 );
133         if ( amount == 33.3333333 ether ) return   ( 1088800000000 , 88800000000 );
134     
135     }
136     
137     
138     
139     function DragonAward ( uint amount, uint crowdsaleCounter ) internal returns ( uint  ){
140         
141        
142         //uint crowdsaleCounter  = dragoncrowdsalecore.crowdsaleCounter();
143         if ( crowdsaleCounter > 1000000000000000 &&  crowdsaleCounter < 2500000000000000 ) price = secondroundprice;
144         if ( crowdsaleCounter >= 2500000000000000 ) price = thirdroundprice;
145           
146         return ( amount / price );
147           
148     
149     }
150     
151   
152     
153     function setFirstRoundPricing ( uint _pricing ) onlyOwner {
154         
155         firstroundprice = _pricing;
156         
157     }
158     
159     function setSecondRoundPricing ( uint _pricing ) onlyOwner {
160         
161         secondroundprice = _pricing;
162         
163     }
164     
165     function setThirdRoundPricing ( uint _pricing ) onlyOwner {
166         
167         thirdroundprice = _pricing;
168         
169     }
170     
171     
172 }
173 
174 contract Dragon {
175     function transfer(address receiver, uint amount)returns(bool ok);
176     function balanceOf( address _address )returns(uint256);
177 }
178 
179 
180 
181 
182 
183 contract DragonCrowdsaleCore is Ownable, DragonPricing {
184     
185     using SafeMath for uint;
186     
187    // address public owner;
188     address public beneficiary;
189     address public charity;
190     address public advisor;
191     address public front;
192     bool public advisorset;
193     
194     uint public tokensSold;
195     uint public etherRaised;
196     uint public presold;
197     uint public presoldMax;
198     
199     uint public crowdsaleCounter;
200     
201    
202     uint public advisorTotal;
203     uint public advisorCut;
204     
205     Dragon public tokenReward;
206     
207    
208     
209     mapping ( address => bool ) public alreadyParticipated;
210     
211     
212     
213     modifier onlyFront() {
214         if (msg.sender != front) {
215             throw;
216         }
217         _;
218     }
219 
220 
221     
222     
223     
224     function DragonCrowdsaleCore(){
225         
226         tokenReward = Dragon( 0x814f67fa286f7572b041d041b1d99b432c9155ee ); // Dragon Token Address
227         owner = msg.sender;
228         beneficiary = msg.sender;
229         charity = msg.sender;
230         advisor = msg.sender;
231        
232         advisorset = false;
233        
234         presold = 0;
235         presoldMax = 3500000000000000;
236         crowdsaleCounter = 0;
237         
238         advisorCut = 0;
239         advisorTotal = 1667 ether;
240         
241         
242     }
243     
244    
245     // runs during precrowdsale - can only be called by main crowdsale contract
246     function precrowdsale ( address tokenholder ) onlyFront payable {
247         
248         
249         require ( presold < presoldMax );
250         uint award;  // amount of dragons to credit to tokenholder
251         uint donation; // donation to charity
252         require ( alreadyParticipated[ tokenholder ]  != true ) ;  
253         alreadyParticipated[ tokenholder ] = true;
254         
255         DragonPricing pricingstructure = new DragonPricing();
256         ( award, donation ) = pricingstructure.precrowdsalepricing( tokenholder , msg.value ); 
257         
258         tokenReward.transfer ( charity , donation ); // send dragons to charity
259         presold = presold.add( award ); //add number of tokens sold in presale
260         presold = presold.add( donation ); //add number of tokens sent via charity
261         
262         tokensSold = tokensSold.add(donation);  //add charity donation to total number of tokens sold 
263         tokenReward.transfer ( tokenholder , award ); // immediate transfer of dragons to token buyer
264         
265         if ( advisorCut < advisorTotal ) { advisorSiphon();} 
266        
267         else 
268           { beneficiary.transfer ( msg.value ); } //send ether to beneficiary
269           
270        
271         etherRaised = etherRaised.add( msg.value ); // tallies ether raised
272         tokensSold = tokensSold.add(award); // tallies total dragons sold
273         
274     }
275     
276     // runs when crowdsale is active - can only be called by main crowdsale contract
277     function crowdsale ( address tokenholder  ) onlyFront payable {
278         
279         
280         uint award;  // amount of dragons to send to tokenholder
281         uint donation; // donation to charity
282         DragonPricing pricingstructure = new DragonPricing();
283         ( award , donation ) = pricingstructure.crowdsalepricing( tokenholder, msg.value, crowdsaleCounter ); 
284          crowdsaleCounter += award;
285         
286         tokenReward.transfer ( tokenholder , award ); // immediate transfer to token holders
287        
288         if ( advisorCut < advisorTotal ) { advisorSiphon();} // send advisor his share
289        
290         else 
291           { beneficiary.transfer ( msg.value ); } //send all ether to beneficiary
292         
293         etherRaised = etherRaised.add( msg.value );  //etherRaised += msg.value; // tallies ether raised
294         tokensSold = tokensSold.add(award); //tokensSold  += award; // tallies total dragons sold
295        
296         
297         
298     }
299     
300     
301     // pays the advisor part of the incoming ether
302     function advisorSiphon() internal {
303         
304          uint share = msg.value/10;
305          uint foradvisor = share;
306              
307            if ( (advisorCut + share) > advisorTotal ) foradvisor = advisorTotal.sub( advisorCut ); 
308              
309            advisor.transfer ( foradvisor );  // advisor gets 10% of the incoming ether
310             
311            advisorCut = advisorCut.add( foradvisor );
312            beneficiary.transfer( share * 9 ); // the ether balance goes to the benfeciary
313            if ( foradvisor != share ) beneficiary.transfer( share.sub(foradvisor) ); // if 10% of the incoming ether exceeds the total advisor is supposed to get , then this gives them a smaller share to not exceed max
314         
315         
316         
317     }
318     
319    
320 
321     
322     // use this to set the crowdsale beneficiary address
323     function transferBeneficiary ( address _newbeneficiary ) onlyOwner {
324         
325         beneficiary = _newbeneficiary;
326         
327     }
328     
329     // use this to set the charity address
330     function transferCharity ( address _charity ) onlyOwner {
331         
332         charity = _charity;
333         
334     }
335     
336     // sets crowdsale address
337     function setFront ( address _front ) onlyOwner {
338         
339         front = _front;
340         
341     }
342     // sets advisors address
343     function setAdvisor ( address _advisor ) onlyOwner {
344         
345         require ( advisorset == false );
346         advisorset = true;
347         advisor = _advisor;
348         
349     }
350     
351    
352         
353     //empty the crowdsale contract of Dragons and forward balance to beneficiary
354     function withdrawCrowdsaleDragons() onlyOwner{
355         
356         uint256 balance = tokenReward.balanceOf( address( this ) );
357         tokenReward.transfer( beneficiary, balance );
358         
359         
360     }
361     
362     //manually send different dragon packages
363     function manualSend ( address tokenholder, uint packagenumber ) onlyOwner {
364         
365         
366           if ( packagenumber != 1 &&  packagenumber != 2 &&  packagenumber != 3 ) revert();
367         
368           uint award;
369           uint donation;
370           
371           if ( packagenumber == 1 )  { award =   10800000000; donation =   800000000; }
372           if ( packagenumber == 2 )  { award =  108800000000; donation =  8800000000; }
373           if ( packagenumber == 3 )  { award = 1088800000000; donation = 88800000000; }
374           
375           
376           tokenReward.transfer ( tokenholder , award ); 
377           tokenReward.transfer ( charity , donation ); 
378           
379           presold = presold.add( award ); //add number of tokens sold in presale
380           presold = presold.add( donation ); //add number of tokens sent via charity
381           tokensSold = tokensSold.add(award); // tallies total dragons sold
382           tokensSold = tokensSold.add(donation); // tallies total dragons sold
383         
384     }
385    
386    
387     
388     
389     
390 }