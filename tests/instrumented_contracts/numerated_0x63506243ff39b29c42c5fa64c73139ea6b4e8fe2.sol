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
101 // partner address is 0x8Cd68F4F20F73960AA1C3BAeA39a827C03e2532C
102 
103 contract newCrowdsale is Ownable {
104     
105     // safe math library imported for safe mathematical operations
106     using SafeMath for uint256;
107     
108     // start and end timestamps where investments are allowed (both inclusive)
109     uint256 public startTime;
110     uint256 public endTime;
111   
112     // to maintain a list of owners and their specific equity percentages
113     mapping(address=>uint256) public ownerAddresses;  //the first one would always be the major owner
114     
115     address[] owners;
116     
117     uint256 public majorOwnerShares = 90;
118     uint256 public minorOwnerShares = 10;
119   
120     // how many token units a buyer gets per wei
121     uint256 public rate = 650;
122 
123     // amount of raised money in wei
124     uint256 public weiRaised;
125   
126     bool public isCrowdsaleStopped = false;
127   
128     bool public isCrowdsalePaused = false;
129     
130     /**
131     * event for token purchase logging
132     * @param purchaser who paid for the tokens
133     * @param beneficiary who got the tokens
134     * @param value weis paid for purchase
135     * @param amount amount of tokens purchased
136     */
137     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
138 
139   
140     // The token that would be sold using this contract 
141     XRPCToken public token;
142     
143     
144     function newCrowdsale(uint _daysToStart, address _walletMajorOwner) public 
145     {
146         token = XRPCToken(0xAdb41FCD3DF9FF681680203A074271D3b3Dae526);  
147         
148         _daysToStart = _daysToStart * 1 days;
149         
150         startTime = now + _daysToStart;   
151         endTime = startTime + 90 days;
152         
153         require(endTime >= startTime);
154         require(_walletMajorOwner != 0x0);
155         
156         ownerAddresses[_walletMajorOwner] = majorOwnerShares;
157         
158         owners.push(_walletMajorOwner);
159         
160         owner = _walletMajorOwner;
161     }
162     
163     // fallback function can be used to buy tokens
164     function () public payable {
165     buy(msg.sender);
166     }
167     
168     function buy(address beneficiary) public payable
169     {
170         require (isCrowdsaleStopped != true);
171         require (isCrowdsalePaused != true);
172         
173         require(beneficiary != 0x0);
174         require(validPurchase());
175 
176         uint256 weiAmount = msg.value;
177         uint256 tokens = weiAmount.mul(rate);
178 
179         // update state
180         weiRaised = weiRaised.add(weiAmount);
181 
182         token.transfer(beneficiary,tokens); 
183         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
184 
185         forwardFunds();
186     }
187     
188      // send ether to the fund collection wallet(s)
189     function forwardFunds() internal {
190       for (uint i=0;i<owners.length;i++)
191       {
192          uint percent = ownerAddresses[owners[i]];
193          uint amountToBeSent = msg.value.mul(percent);
194          amountToBeSent = amountToBeSent.div(100);
195          owners[i].transfer(amountToBeSent);
196       }
197     }
198    
199      /**
200      * function to add a minor owner
201      * can only be called by the major/actual owner wallet
202      **/  
203     function addMinorOwner(address minorOwner) public onlyOwner {
204 
205         require(minorOwner != 0x0);
206         require(ownerAddresses[owner] >=20);
207         require(ownerAddresses[minorOwner] == 0);
208         owners.push(minorOwner);
209         ownerAddresses[minorOwner] = 10;
210         uint majorOwnerShare = ownerAddresses[owner];
211         ownerAddresses[owner] = majorOwnerShare.sub(10);
212     }
213     
214     /**
215      * function to remove a minor owner
216      * can only be called by the major/actual owner wallet
217      **/ 
218     function removeMinorOwner(address minorOwner) public onlyOwner  {
219         require(minorOwner != 0x0);
220         require(ownerAddresses[minorOwner] > 0);
221         require(ownerAddresses[owner] <= 90);
222         ownerAddresses[minorOwner] = 0;
223         uint majorOwnerShare = ownerAddresses[owner];
224         ownerAddresses[owner] = majorOwnerShare.add(10);
225     }
226 
227     // @return true if the transaction can buy tokens
228     function validPurchase() internal constant returns (bool) {
229         bool withinPeriod = now >= startTime && now <= endTime;
230         bool nonZeroPurchase = msg.value != 0;
231         return withinPeriod && nonZeroPurchase;
232     }
233 
234     // @return true if crowdsale event has ended
235     function hasEnded() public constant returns (bool) {
236         return now > endTime;
237     }
238   
239     function showMyTokenBalance(address myAddress) public returns (uint256 tokenBalance) {
240        tokenBalance = token.balanceOf(myAddress);
241     }
242 
243     /**
244      * function to change the end date of the ICO
245      **/ 
246     function setEndDate(uint256 daysToEndFromToday) public onlyOwner returns(bool) {
247         daysToEndFromToday = daysToEndFromToday * 1 days;
248         endTime = now + daysToEndFromToday;
249     }
250 
251     /**
252      * function to set the new price 
253      * can only be called from owner wallet
254      **/ 
255     function setPriceRate(uint256 newPrice) public onlyOwner returns (bool) {
256         rate = newPrice;
257     }
258     
259     /**
260      * function to pause the crowdsale 
261      * can only be called from owner wallet
262      **/
263      
264     function pauseCrowdsale() public onlyOwner returns(bool) {
265         isCrowdsalePaused = true;
266     }
267 
268     /**
269      * function to resume the crowdsale if it is paused
270      * can only be called from owner wallet
271      * if the crowdsale has been stopped, this function would not resume it
272      **/ 
273     function resumeCrowdsale() public onlyOwner returns (bool) {
274         isCrowdsalePaused = false;
275     }
276     
277     /**
278      * function to stop the crowdsale
279      * can only be called from the owner wallet
280      **/
281     function stopCrowdsale() public onlyOwner returns (bool) {
282         isCrowdsaleStopped = true;
283     }
284     
285     /**
286      * function to start the crowdsale manually
287      * can only be called from the owner wallet
288      * this function can be used if the owner wants to start the ICO before the specified start date
289      * this function can also be used to undo the stopcrowdsale, in case the crowdsale is stopped due to human error
290      **/
291     function startCrowdsale() public onlyOwner returns (bool) {
292         isCrowdsaleStopped = false;
293         startTime = now; 
294     }
295     
296     /**
297      * Shows the remaining tokens in the contract i.e. tokens remaining for sale
298      **/ 
299     function tokensRemainingForSale(address contractAddress) public returns (uint balance) {
300         balance = token.balanceOf(contractAddress);
301     }
302     
303     /**
304      * function to show the equity percentage of an owner - major or minor
305      * can only be called from the owner wallet
306      **/
307     function checkOwnerShare (address owner) public onlyOwner constant returns (uint share) {
308         share = ownerAddresses[owner];
309     }
310 }