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
74 contract OsherCrowdsale {
75     
76     function crowdSaleStartTime() returns (uint);
77     function preicostarted() returns (uint);
78     
79 }
80 
81 
82 contract OsherCoinPricing is Ownable {
83     
84    
85     
86     OsherCoinCrowdsaleCore oshercoincrowdsalecore;
87     uint public preicostarted;
88     uint public icostarted;
89     uint public price;
90     address oshercrowdsaleaddress; 
91     
92     
93     
94     function OsherCoinPricing() {
95         
96         
97         price =.00000000001 ether;
98         oshercrowdsaleaddress = 0x2Ef8DcDeCd124660C8CC8E55114f615C2e657da6;  // add crowdsale address
99         
100     }
101     
102     
103     
104     
105     function crowdsalepricing( address tokenholder, uint amount  )  returns ( uint , uint ) {
106         
107         uint award;
108         uint bonus;
109         
110         return ( OsherCoinAward ( amount ) , bonus );
111         
112     }
113     
114     
115     function precrowdsalepricing( address tokenholder, uint amount )   returns ( uint, uint )  {
116         
117        
118         uint award;
119         uint bonus;
120         
121         ( award, bonus ) = OsherCoinPresaleAward ( amount  );
122         
123         return ( award, bonus );
124         
125     }
126     
127     
128     function OsherCoinPresaleAward ( uint amount  ) public constant  returns ( uint, uint  ){
129         
130         
131         uint divisions = (amount / price) / 20;
132         uint bonus =   ( currentpreicobonus()/5 ) * divisions;
133         return ( (amount / price) , bonus );
134        
135     }
136     
137     
138     function currentpreicobonus() public constant returns ( uint) {
139         
140         uint bonus;
141         OsherCrowdsale oshercrowdsale =  OsherCrowdsale ( oshercrowdsaleaddress ); 
142         
143         if ( now < ( oshercrowdsale.preicostarted() +   7 days ) ) bonus =   35; 
144         if ( now > ( oshercrowdsale.preicostarted() +   7 days ) ) bonus =   30;
145         if ( now > ( oshercrowdsale.preicostarted() +  12 days ) ) bonus =   25;
146         if ( now > ( oshercrowdsale.preicostarted() +  17 days ) ) bonus =   20;
147         if ( now > ( oshercrowdsale.preicostarted() +  22 days ) ) bonus =   15;
148         if ( now > ( oshercrowdsale.preicostarted() +  27 days ) ) bonus =   10;
149         
150         return bonus;
151         
152     }
153     
154     function OsherCoinAward ( uint amount ) public constant returns ( uint ){
155         
156         return amount /  OsherCurrentICOPrice();
157        
158     }
159   
160   
161     function OsherCurrentICOPrice() public constant returns ( uint ){
162         
163         uint priceincrease;
164         OsherCrowdsale oshercrowdsale =  OsherCrowdsale ( oshercrowdsaleaddress ); 
165         uint spotprice;
166         uint dayspassed = now - oshercrowdsale.crowdSaleStartTime();
167         uint todays = dayspassed/86400;
168         
169         if ( todays > 20 ) todays = 20;
170         
171         spotprice = (todays * .0000000000005 ether) + price;
172         
173         return spotprice;
174        
175     }  
176     
177     function setFirstRoundPricing ( uint _pricing ) onlyOwner {
178         
179         price = _pricing;
180         
181     }
182     
183     
184     
185 }
186 
187 contract OsherCoin {
188     function transfer(address receiver, uint amount)returns(bool ok);
189     function balanceOf( address _address )returns(uint256);
190 }
191 
192 
193 
194 
195 
196 contract OsherCoinCrowdsaleCore is Ownable, OsherCoinPricing {
197     
198     using SafeMath for uint;
199     
200     address public beneficiary;
201     address public front;
202     uint public tokensSold;
203     uint public etherRaised;
204     uint public presold;
205     
206     
207     OsherCoin public tokenReward;
208     
209     
210     event ShowBool ( bool );
211     
212     
213     
214     
215     modifier onlyFront() {
216         if (msg.sender != front) {
217             throw;
218         }
219         _;
220     }
221 
222 
223     
224     
225     
226     function OsherCoinCrowdsaleCore(){
227         
228         tokenReward = OsherCoin(  0xa8a07e3fa28bd207e405c482ce8d02402cd60d92 ); // OsherCoin Address
229         owner = msg.sender;
230         beneficiary = msg.sender;
231         preicostarted = now;
232         front = 0x2Ef8DcDeCd124660C8CC8E55114f615C2e657da6; // front crowdsale address
233         
234        
235        
236     }
237     
238    
239     // runs during precrowdsale
240     function precrowdsale ( address tokenholder ) onlyFront payable {
241         
242         uint award;  // amount of oshercoins to credit to tokenholder
243         uint bonus;  // amount of oshercoins to credit to tokenholder
244         
245         OsherCoinPricing pricingstructure = new OsherCoinPricing();
246         ( award, bonus ) = pricingstructure.precrowdsalepricing( tokenholder , msg.value ); 
247         
248        
249         presold = presold.add( award + bonus ); //add number of tokens sold in presale
250         tokenReward.transfer ( tokenholder , award + bonus ); // immediate transfer of oshercoins to token buyer
251         
252         beneficiary.transfer ( msg.value ); 
253           
254         etherRaised = etherRaised.add( msg.value ); // tallies ether raised
255         tokensSold = tokensSold.add( award + bonus ); // tallies total osher sold
256         
257     }
258     
259     // runs when crowdsale is active
260     function crowdsale ( address tokenholder  ) onlyFront payable {
261         
262         uint award;  // amount of oshercoins to send to tokenholder
263         uint bonus;  // amount of oshercoin bonus
264      
265         OsherCoinPricing pricingstructure = new OsherCoinPricing();
266         ( award , bonus ) = pricingstructure.crowdsalepricing( tokenholder, msg.value ); 
267     
268         tokenReward.transfer ( tokenholder , award ); // immediate transfer to token holders
269         beneficiary.transfer ( msg.value ); 
270         
271         etherRaised = etherRaised.add( msg.value );  //etherRaised += msg.value; // tallies ether raised
272         tokensSold = tokensSold.add( award ); //tokensSold  += award; // tallies total osher sold
273        
274     }
275     
276     
277     // use this to set the crowdsale beneficiary address
278     function transferBeneficiary ( address _newbeneficiary ) onlyOwner {
279         
280         beneficiary = _newbeneficiary;
281         
282     }
283     
284     // use this to set the charity address
285     
286     // sets crowdsale address
287     function setFront ( address _front ) onlyOwner {
288         
289         front = _front;
290         
291     }
292     
293    
294         
295     //empty the crowdsale contract of Dragons and forward balance to beneficiary
296     function withdrawCrowdsaleOsherCoins() onlyOwner{
297         
298         uint256 balance = tokenReward.balanceOf( address( this ) );
299         tokenReward.transfer( beneficiary, balance );
300         
301         
302     }
303    
304    
305     
306     
307     
308 }