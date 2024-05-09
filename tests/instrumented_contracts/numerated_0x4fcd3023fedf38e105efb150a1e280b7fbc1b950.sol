1 /**
2  * Investors relations: partners@xrpconnect.co
3  * 
4  * Ken Brannon
5  * Contact: ken@xrpconnect.co
6 **/
7 
8 pragma solidity ^0.4.11;
9 
10 /**
11  * @title Crowdsale
12  * @dev Crowdsale is a base contract for managing a token crowdsale.
13  * Crowdsales have a start and end timestamps, where investors can make
14  * token purchases and the crowdsale will assign them tokens based
15  * on a token per ETH rate. Funds collected are forwarded to a wallet
16  * as they arrive.
17  */
18  
19  
20 /**
21  * SafeMath library to support basic mathematical operations 
22  * Used for security of the contract
23  **/ 
24  
25 library SafeMath {
26   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a * b;
28     assert(a == 0 || c / a == b);
29     return c;
30   }
31 
32  function div(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b > 0); // Solidity automatically throws when dividing by 0
34     uint256 c = a / b;
35     assert(a == b * c + a % b); // There is no case in which this doesn't hold
36     return c;
37   }
38 
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 /**
52  * Ownable contract  
53  * Makes an address the owner of a contract
54  * Used so that onlyOwner modifier can be Used
55  * onlyOwner modifier is used so that some functions can only be called by the contract owner
56  **/
57 
58 contract Ownable {
59   address public owner;
60 
61   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63 
64   /**
65    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
66    * account.
67    */
68   function Ownable() public {
69     owner = msg.sender;
70   }
71 
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81 
82   /**
83    * @dev Allows the current owner to transfer control of the contract to a newOwner.
84    * @param newOwner The address to transfer ownership to.
85    */
86   function transferOwnership(address newOwner) onlyOwner public {
87     require(newOwner != address(0));
88     OwnershipTransferred(owner, newOwner);
89     owner = newOwner;
90   }
91 
92 }
93 
94 interface XRPCToken {
95     function transfer(address receiver, uint amount) public;
96     function balanceOf(address _owner) public returns (uint256 balance);
97     function mint(address wallet, address buyer, uint256 tokenAmount) public;
98     function showMyTokenBalance(address addr) public;
99 }
100 
101 contract newCrowdsale is Ownable {
102     
103     // safe math library imported for safe mathematical operations
104     using SafeMath for uint256;
105     
106     // start and end timestamps where investments are allowed (both inclusive)
107     uint256 public startTime;
108     uint256 public endTime;
109   
110     // to maintain a list of owners and their specific equity percentages
111     mapping(address=>uint256) public ownerAddresses;  //the first one would always be the major owner
112     
113     address[] owners;
114     
115     uint256 public majorOwnerShares = 100;
116     uint256 public minorOwnerShares = 10;
117     uint256 public coinPercentage = 5;
118   
119     // how many token units a buyer gets per wei
120     uint256 public rate = 650;
121 
122     // amount of raised money in wei
123     uint256 public weiRaised;
124   
125     bool public isCrowdsaleStopped = false;
126   
127     bool public isCrowdsalePaused = false;
128     
129     /**
130     * event for token purchase logging
131     * @param purchaser who paid for the tokens
132     * @param beneficiary who got the tokens
133     * @param value weis paid for purchase
134     * @param amount amount of tokens purchased
135     */
136     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
137 
138   
139     // The token that would be sold using this contract 
140     XRPCToken public token;
141     
142     
143     function newCrowdsale(uint _daysToStart, address _walletMajorOwner) public 
144     {
145         token = XRPCToken(0xAdb41FCD3DF9FF681680203A074271D3b3Dae526); 
146         
147         _daysToStart = _daysToStart * 1 days;
148         
149         startTime = now + _daysToStart;   
150         endTime = startTime + 90 days;
151         
152         require(endTime >= startTime);
153         require(_walletMajorOwner != 0x0);
154         
155         ownerAddresses[_walletMajorOwner] = majorOwnerShares;
156         
157         owners.push(_walletMajorOwner);
158         
159         owner = _walletMajorOwner;
160     }
161     
162     // fallback function can be used to buy tokens
163     function () public payable {
164     buy(msg.sender);
165     }
166     
167     function buy(address beneficiary) public payable
168     {
169         require (isCrowdsaleStopped != true);
170         require (isCrowdsalePaused != true);
171         
172         require(beneficiary != 0x0);
173         require(validPurchase());
174 
175         uint256 weiAmount = msg.value;
176         uint256 tokens = weiAmount.mul(rate);
177 
178         // update state
179         weiRaised = weiRaised.add(weiAmount);
180 
181         token.transfer(beneficiary,tokens);
182          uint partnerCoins = tokens.mul(coinPercentage);
183         partnerCoins = partnerCoins.div(100);
184         
185         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
186 
187         forwardFunds(partnerCoins);
188     }
189     
190      // send ether to the fund collection wallet(s)
191     function forwardFunds(uint256 partnerTokenAmount) internal {
192       for (uint i=0;i<owners.length;i++)
193       {
194          uint percent = ownerAddresses[owners[i]];
195          uint amountToBeSent = msg.value.mul(percent);
196          amountToBeSent = amountToBeSent.div(100);
197          owners[i].transfer(amountToBeSent);
198          
199          if (owners[i]!=owner &&  ownerAddresses[owners[i]]>0)
200          {
201              token.transfer(owners[i],partnerTokenAmount);
202          }
203       }
204     }
205    
206      /**
207      * function to add a partner
208      * can only be called by the major/actual owner wallet
209      **/  
210     function addPartner(address partner) public onlyOwner {
211 
212         require(partner != 0x0);
213         require(ownerAddresses[owner] >=20);
214         require(ownerAddresses[partner] == 0);
215         owners.push(partner);
216         ownerAddresses[partner] = 10;
217         uint majorOwnerShare = ownerAddresses[owner];
218         ownerAddresses[owner] = majorOwnerShare.sub(10);
219     }
220     
221     /**
222      * function to remove a partner
223      * can only be called by the major/actual owner wallet
224      **/ 
225     function removePartner(address partner) public onlyOwner  {
226         require(partner != 0x0);
227         require(ownerAddresses[partner] > 0);
228         require(ownerAddresses[owner] <= 90);
229         ownerAddresses[partner] = 0;
230         uint majorOwnerShare = ownerAddresses[owner];
231         ownerAddresses[owner] = majorOwnerShare.add(10);
232     }
233 
234     // @return true if the transaction can buy tokens
235     function validPurchase() internal constant returns (bool) {
236         bool withinPeriod = now >= startTime && now <= endTime;
237         bool nonZeroPurchase = msg.value != 0;
238         return withinPeriod && nonZeroPurchase;
239     }
240 
241     // @return true if crowdsale event has ended
242     function hasEnded() public constant returns (bool) {
243         return now > endTime;
244     }
245   
246     function showMyTokenBalance(address myAddress) public returns (uint256 tokenBalance) {
247        tokenBalance = token.balanceOf(myAddress);
248     }
249 
250     /**
251      * function to change the end date of the ICO
252      **/ 
253     function setEndDate(uint256 daysToEndFromToday) public onlyOwner returns(bool) {
254         daysToEndFromToday = daysToEndFromToday * 1 days;
255         endTime = now + daysToEndFromToday;
256     }
257 
258     /**
259      * function to set the new price 
260      * can only be called from owner wallet
261      **/ 
262     function setPriceRate(uint256 newPrice) public onlyOwner returns (bool) {
263         rate = newPrice;
264     }
265     
266     /**
267      * function to pause the crowdsale 
268      * can only be called from owner wallet
269      **/
270      
271     function pauseCrowdsale() public onlyOwner returns(bool) {
272         isCrowdsalePaused = true;
273     }
274 
275     /**
276      * function to resume the crowdsale if it is paused
277      * can only be called from owner wallet
278      * if the crowdsale has been stopped, this function would not resume it
279      **/ 
280     function resumeCrowdsale() public onlyOwner returns (bool) {
281         isCrowdsalePaused = false;
282     }
283     
284     /**
285      * function to stop the crowdsale
286      * can only be called from the owner wallet
287      **/
288     function stopCrowdsale() public onlyOwner returns (bool) {
289         isCrowdsaleStopped = true;
290     }
291     
292     /**
293      * function to start the crowdsale manually
294      * can only be called from the owner wallet
295      * this function can be used if the owner wants to start the ICO before the specified start date
296      * this function can also be used to undo the stopcrowdsale, in case the crowdsale is stopped due to human error
297      **/
298     function startCrowdsale() public onlyOwner returns (bool) {
299         isCrowdsaleStopped = false;
300         startTime = now; 
301     }
302     
303     /**
304      * Shows the remaining tokens in the contract i.e. tokens remaining for sale
305      **/ 
306     function tokensRemainingForSale(address contractAddress) public returns (uint balance) {
307         balance = token.balanceOf(contractAddress);
308     }
309     
310     /**
311      * function to show the equity percentage of an owner - major or minor
312      * can only be called from the owner wallet
313      **/
314     function checkOwnerShare (address owner) public onlyOwner constant returns (uint share) {
315         share = ownerAddresses[owner];
316     }
317 
318     /**
319      * function to change the coin percentage awarded to the partners
320      * can only be called from the owner wallet
321      **/
322     function changePartnerCoinPercentage(uint percentage) public onlyOwner {
323         coinPercentage = percentage;
324     }
325 }