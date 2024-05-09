1 pragma solidity ^0.4.18;
2 
3  
4  
5 /**
6  * SafeMath library to support basic mathematical operations 
7  * Used for security of the contract
8  **/ 
9  
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     uint256 c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17  function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /**
37  * Ownable contract  
38  * Makes an address the owner of a contract
39  * Used so that onlyOwner modifier can be Used
40  * onlyOwner modifier is used so that some functions can only be called by the contract owner
41  **/
42 
43 contract Ownable {
44   address public owner;
45 
46   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48 
49   /**
50    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51    * account.
52    */
53   function Ownable() public {
54     owner = msg.sender;
55   }
56 
57 
58   /**
59    * @dev Throws if called by any account other than the owner.
60    */
61   modifier onlyOwner() {
62     require(msg.sender == owner);
63     _;
64   }
65 
66 
67   /**
68    * @dev Allows the current owner to transfer control of the contract to a newOwner.
69    * @param newOwner The address to transfer ownership to.
70    */
71   function transferOwnership(address newOwner) onlyOwner public {
72     require(newOwner != address(0));
73     OwnershipTransferred(owner, newOwner);
74     owner = newOwner;
75   }
76 
77 }
78 
79 interface Arm {
80     function transfer(address receiver, uint amount) public;
81     function balanceOf(address _owner) public returns (uint256 balance);
82     function showMyTokenBalance(address addr) public;
83 }
84 
85 contract newCrowdsale is Ownable {
86     
87     // safe math library 
88     using SafeMath for uint256;
89     
90     // start and end timestamps of ICO (both inclusive)
91     uint256 public startTime;
92     uint256 public endTime;
93   
94     // to maintain a list of owners and their specific equity percentages
95     mapping(address=>uint256) public ownerAddresses;  //note that the first one would always be the major owner
96     
97     address[] owners;
98     
99     uint256 public majorOwnerShares = 100;
100     uint256 public minorOwnerShares = 10;
101     uint256 public coinPercentage = 5;
102     uint256 share  = 10;
103     // how many token units a buyer gets per eth
104     uint256 public rate = 650;
105 
106     // amount of raised money in wei
107     uint256 public weiRaised;
108   
109     bool public isCrowdsaleStopped = false;
110   
111     bool public isCrowdsalePaused = false;
112     
113     /**
114     * event for token purchase logging
115     * @param purchaser who paid for the tokens
116     * @param beneficiary who got the tokens
117     * @param value weis paid for purchase
118     * @param amount amount of tokens purchased
119     */
120     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
121 
122   
123     // The token that would be sold using this contract(Arm here)
124     Arm public token;
125     
126     
127     function newCrowdsale(address _walletMajorOwner) public 
128     {
129         token = Arm(0x387890e71A8B7D79114e5843D6a712ea474BA91c); 
130         
131         //_daysToStart = _daysToStart * 1 days;
132         
133         startTime = now;   
134         endTime = startTime + 90 days;
135         
136         require(endTime >= startTime);
137         require(_walletMajorOwner != 0x0);
138         
139         ownerAddresses[_walletMajorOwner] = majorOwnerShares;
140         
141         owners.push(_walletMajorOwner);
142         
143         owner = _walletMajorOwner;
144     }
145     
146     // fallback function can be used to buy tokens
147     function () public payable {
148     buy(msg.sender);
149     }
150     
151     function buy(address beneficiary) public payable
152     {
153         require (isCrowdsaleStopped != true);
154         require (isCrowdsalePaused != true);
155         require ((msg.value) <= 2 ether);
156         require(beneficiary != 0x0);
157         require(validPurchase());
158 
159         uint256 weiAmount = msg.value;
160         uint256 tokens = weiAmount.mul(rate);
161 
162         // update state
163         weiRaised = weiRaised.add(weiAmount);
164 
165         token.transfer(beneficiary,tokens);
166          uint partnerCoins = tokens.mul(coinPercentage);
167         partnerCoins = partnerCoins.div(100);
168         
169         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
170 
171         forwardFunds(partnerCoins);
172     }
173     
174      // send ether to the fund collection wallet(s)
175     function forwardFunds(uint256 partnerTokenAmount) internal {
176       for (uint i=0;i<owners.length;i++)
177       {
178          uint percent = ownerAddresses[owners[i]];
179          uint amountToBeSent = msg.value.mul(percent);
180          amountToBeSent = amountToBeSent.div(100);
181          owners[i].transfer(amountToBeSent);
182          
183          if (owners[i]!=owner &&  ownerAddresses[owners[i]]>0)
184          {
185              token.transfer(owners[i],partnerTokenAmount);
186          }
187       }
188     }
189    
190      /**
191      * function to add a partner
192      * can only be called by the major/actual owner wallet
193      **/  
194     function addPartner(address partner, uint share) public onlyOwner {
195 
196         require(partner != 0x0);
197         require(ownerAddresses[owner] >=20);
198         require(ownerAddresses[partner] == 0);
199         owners.push(partner);
200         ownerAddresses[partner] = share;
201         uint majorOwnerShare = ownerAddresses[owner];
202         ownerAddresses[owner] = majorOwnerShare.sub(share);
203     }
204     
205     /**
206      * function to remove a partner
207      * can only be called by the major/actual owner wallet
208      **/ 
209     function removePartner(address partner) public onlyOwner  {
210         require(partner != 0x0);
211         require(ownerAddresses[partner] > 0);
212         require(ownerAddresses[owner] <= 90);
213         uint share_remove = ownerAddresses[partner];
214         ownerAddresses[partner] = 0;
215         uint majorOwnerShare = ownerAddresses[owner];
216         ownerAddresses[owner] = majorOwnerShare.add(share_remove);
217     }
218 
219     // @return true if the transaction can buy tokens
220     function validPurchase() internal constant returns (bool) {
221         bool withinPeriod = now >= startTime && now <= endTime;
222         bool nonZeroPurchase = msg.value != 0;
223         return withinPeriod && nonZeroPurchase;
224     }
225 
226     // @return true if crowdsale event has ended
227     function hasEnded() public constant returns (bool) {
228         return now > endTime;
229     }
230   
231     function showMyTokenBalance(address myAddress) public returns (uint256 tokenBalance) {
232        tokenBalance = token.balanceOf(myAddress);
233     }
234 
235     /**
236      * function to change the end date of the ICO
237      **/ 
238     function setEndDate(uint256 daysToEndFromToday) public onlyOwner returns(bool) {
239         daysToEndFromToday = daysToEndFromToday * 1 days;
240         endTime = now + daysToEndFromToday;
241     }
242 
243     /**
244      * function to set the new price 
245      * can only be called from owner wallet
246      **/ 
247     function setPriceRate(uint256 newPrice) public onlyOwner returns (bool) {
248         rate = newPrice;
249     }
250     
251     /**
252      * function to pause the crowdsale 
253      * can only be called from owner wallet
254      **/
255      
256     function pauseCrowdsale() public onlyOwner returns(bool) {
257         isCrowdsalePaused = true;
258     }
259 
260     /**
261      * function to resume the crowdsale if it is paused
262      * can only be called from owner wallet
263      * if the crowdsale has been stopped, this function would not resume it
264      **/ 
265     function resumeCrowdsale() public onlyOwner returns (bool) {
266         isCrowdsalePaused = false;
267     }
268     
269     /**
270      * function to stop the crowdsale
271      * can only be called from the owner wallet
272      **/
273     function stopCrowdsale() public onlyOwner returns (bool) {
274         isCrowdsaleStopped = true;
275     }
276     
277     /**
278      * function to start the crowdsale manually
279      * can only be called from the owner wallet
280      * this function can be used if the owner wants to start the ICO before the specified start date
281      * this function can also be used to undo the stopcrowdsale, in case the crowdsale is stopped due to human error
282      **/
283     function startCrowdsale() public onlyOwner returns (bool) {
284         isCrowdsaleStopped = false;
285         startTime = now; 
286     }
287     
288     /**
289      * Shows the remaining tokens in the contract i.e. tokens remaining for sale
290      **/ 
291     function tokensRemainingForSale(address contractAddress) public returns (uint balance) {
292         balance = token.balanceOf(contractAddress);
293     }
294     
295     /**
296      * function to show the equity percentage of an owner - major or minor
297      * can only be called from the owner wallet
298      **/
299   /** function checkOwnerShare (address owner) public onlyOwner constant returns (uint share) {
300         share = ownerAddresses[owner];
301     }**/
302 
303     /**
304      * function to change the coin percentage awarded to the partners
305      * can only be called from the owner wallet
306      **/
307     function changePartnerCoinPercentage(uint percentage) public onlyOwner {
308         coinPercentage = percentage;
309     }
310     /*function changePartnerShare(address partner, uint new_share) public onlyOwner {
311         if
312         ownerAddresses[partner] = new_share;
313         ownerAddresses[owner]=
314     }*/
315     function destroy() onlyOwner public {
316     // Transfer tokens back to owner
317     uint256 balance = token.balanceOf(this);
318     assert(balance > 0);
319     token.transfer(owner, balance);
320 
321     // There should be no ether in the contract but just in case
322     selfdestruct(owner);
323   }
324 }