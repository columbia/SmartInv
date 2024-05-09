1 pragma solidity ^0.4.18;
2 
3 /**
4  * CoinCrowd ICO. More info www.coincrowd.it 
5  */
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     uint256 c = a * b;
14     assert(a == 0 || c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44   address public owner;
45   
46   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48   /**
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   function Ownable() internal {
53     owner = msg.sender;
54   }
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) onlyOwner public {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 }
74 
75 contract tokenInterface {
76 	function balanceOf(address _owner) public constant returns (uint256 balance);
77 	function transfer(address _to, uint256 _value) public returns (bool);
78 }
79 
80 contract Ambassador {
81     using SafeMath for uint256;
82     CoinCrowdICO icoContract;
83     uint256 public startRC;
84     uint256 public endRC;
85     address internal contractOwner; 
86     
87     uint256 public soldTokensWithoutBonus; // wei of XCC sold token without bonuses
88 	function euroRaisedRc() public view returns(uint256 euro) {
89         return icoContract.euroRaised(soldTokensWithoutBonus);
90     }
91     
92     uint256[] public euroThreshold; // array of euro(k) threshold reached - 100K = 100.000€
93     uint256[] public bonusThreshold; // array of bonus of each euroThreshold reached - 20% = 2000
94     
95     mapping(address => uint256) public balanceUser; // address => token amount
96 
97     function Ambassador(address _icoContract, address _ambassadorAddr, uint256[] _euroThreshold, uint256[] _bonusThreshold, uint256 _startRC , uint256 _endRC ) public {
98         require ( _icoContract != 0 );
99         require ( _ambassadorAddr != 0 );
100         require ( _euroThreshold.length != 0 );
101         require ( _euroThreshold.length == _bonusThreshold.length );
102         
103         icoContract = CoinCrowdICO(_icoContract);
104         contractOwner = _icoContract;
105         
106         icoContract.addMeByRC(_ambassadorAddr);
107         
108         bonusThreshold = _bonusThreshold;
109         euroThreshold = _euroThreshold;
110         
111         soldTokensWithoutBonus = 0;
112         
113         setTimeRC( _startRC, _endRC );
114     }
115     
116     modifier onlyIcoContract() {
117         require(msg.sender == contractOwner);
118         _;
119     }
120     
121     function setTimeRC(uint256 _startRC, uint256 _endRC ) internal {
122         if( _startRC == 0 ) {
123             startRC = icoContract.startTime();
124         } else {
125             startRC = _startRC;
126         }
127         if( _endRC == 0 ) {
128             endRC = icoContract.endTime();
129         } else {
130             endRC = _endRC;
131         }
132     }
133     
134     function updateTime(uint256 _newStart, uint256 _newEnd) public onlyIcoContract {
135         if ( _newStart != 0 ) startRC = _newStart;
136         if ( _newEnd != 0 ) endRC = _newEnd;
137     }
138 
139     function () public payable {
140         require( now > startRC );
141         if( now < endRC ) {
142             uint256 tokenAmount = icoContract.buy.value(msg.value)(msg.sender);
143             balanceUser[msg.sender] = balanceUser[msg.sender].add(tokenAmount);
144             soldTokensWithoutBonus = soldTokensWithoutBonus.add(tokenAmount);
145         } else { //claim premium bonus logic
146             require( balanceUser[msg.sender] > 0 );
147             uint256 bonusApplied = 0;
148             for (uint i = 0; i < euroThreshold.length; i++) {
149                 if ( icoContract.euroRaised(soldTokensWithoutBonus).div(1000) > euroThreshold[i] ) {
150                     bonusApplied = bonusThreshold[i];
151                 }
152             }    
153             require( bonusApplied > 0 );
154             
155             uint256 addTokenAmount = balanceUser[msg.sender].mul( bonusApplied ).div(10**2);
156             balanceUser[msg.sender] = 0; 
157             
158             icoContract.claimPremium(msg.sender, addTokenAmount);
159             if( msg.value > 0 ) msg.sender.transfer(msg.value); // give back eth 
160         }
161     }
162 }
163 
164 contract CoinCrowdICO is Ownable {
165     using SafeMath for uint256;
166     tokenInterface public tokenContract;
167     
168 	uint256 public decimals = 18;
169     uint256 public tokenValue;  // 1 XCC in wei
170     uint256 public constant centToken = 20; // euro cents value of 1 token 
171     
172     function euroRaised(uint256 _weiTokens) public view returns (uint256) { // convertion of sold token in euro raised in wei
173         return _weiTokens.mul(centToken).div(100).div(10**decimals);
174     }
175     
176     uint256 public endTime;  // seconds from 1970-01-01T00:00:00Z
177     uint256 public startTime;  // seconds from 1970-01-01T00:00:00Z
178     uint256 internal constant weekInSeconds = 604800; // seconds in a week
179     
180     uint256 public totalSoldTokensWithBonus; // total wei of XCC distribuited from this ICO
181     uint256 public totalSoldTokensWithoutBonus; // total wei of XCC distribuited from this ICO without bonus
182 	function euroRaisedICO() public view returns(uint256 euro) {
183         return euroRaised(totalSoldTokensWithoutBonus);
184     }
185 	
186     uint256 public remainingTokens; // total wei of XCC remaining (without bonuses)
187 
188     mapping(address => address) public ambassadorAddressOf; // ambassadorContract => ambassadorAddress
189 
190 
191     function CoinCrowdICO(address _tokenAddress, uint256 _tokenValue, uint256 _startTime) public {
192         tokenContract = tokenInterface(_tokenAddress);
193         tokenValue = _tokenValue;
194         startICO(_startTime); 
195         totalSoldTokensWithBonus = 0;
196         totalSoldTokensWithoutBonus = 0;
197         remainingTokens = 24500000  * 10 ** decimals; // 24.500.000 * 0.20€ = 4.900.000€ CAPPED
198     }
199 
200     address public updater;  // account in charge of updating the token value
201     event UpdateValue(uint256 newValue);
202 
203     function updateValue(uint256 newValue) public {
204         require(msg.sender == updater || msg.sender == owner);
205         tokenValue = newValue;
206         UpdateValue(newValue);
207     }
208 
209     function updateUpdater(address newUpdater) public onlyOwner {
210         updater = newUpdater;
211     }
212 
213     function updateTime(uint256 _newStart, uint256 _newEnd) public onlyOwner {
214         if ( _newStart != 0 ) startTime = _newStart;
215         if ( _newEnd != 0 ) endTime = _newEnd;
216     }
217     
218     function updateTimeRC(address _rcContract, uint256 _newStart, uint256 _newEnd) public onlyOwner {
219         Ambassador(_rcContract).updateTime( _newStart, _newEnd);
220     }
221     
222     function startICO(uint256 _startTime) public onlyOwner {
223         if(_startTime == 0 ) {
224             startTime = now;
225         } else {
226             startTime = _startTime;
227         }
228         endTime = startTime + 12*weekInSeconds;
229     }
230     
231     event Buy(address buyer, uint256 value, address indexed ambassador);
232 
233     function buy(address _buyer) public payable returns(uint256) {
234         require(now < endTime); // check if ended
235         require( remainingTokens > 0 ); // Check if there are any remaining tokens excluding bonuses
236         
237         require( tokenContract.balanceOf(this) > remainingTokens); // should have enough balance
238         
239         uint256 oneXCC = 10 ** decimals;
240         uint256 tokenAmount = msg.value.mul(oneXCC).div(tokenValue);
241         
242         
243         uint256 bonusRate; // decimals of bonus 20% = 2000
244         address currentAmbassador = address(0);
245         if ( ambassadorAddressOf[msg.sender] != address(0) ) { // if is an authorized ambassadorContract
246             currentAmbassador = msg.sender;
247             bonusRate = 0; // Ambassador Comunity should claim own bonus at the end of RC 
248             
249         } else { // if is directly called to CoinCrowdICO contract
250             require(now > startTime); // check if started for public user
251             
252             if( now > startTime + weekInSeconds*0  ) { bonusRate = 2000; }
253             if( now > startTime + weekInSeconds*1  ) { bonusRate = 1833; }
254             if( now > startTime + weekInSeconds*2  ) { bonusRate = 1667; }
255             if( now > startTime + weekInSeconds*3  ) { bonusRate = 1500; }
256             if( now > startTime + weekInSeconds*4  ) { bonusRate = 1333; }
257             if( now > startTime + weekInSeconds*5  ) { bonusRate = 1167; }
258             if( now > startTime + weekInSeconds*6  ) { bonusRate = 1000; }
259             if( now > startTime + weekInSeconds*7  ) { bonusRate = 833; }
260             if( now > startTime + weekInSeconds*8  ) { bonusRate = 667; }
261             if( now > startTime + weekInSeconds*9  ) { bonusRate = 500; }
262             if( now > startTime + weekInSeconds*10 ) { bonusRate = 333; }
263             if( now > startTime + weekInSeconds*11 ) { bonusRate = 167; }
264             if( now > startTime + weekInSeconds*12 ) { bonusRate = 0; }
265         }
266         
267         if ( remainingTokens < tokenAmount ) {
268             uint256 refund = (tokenAmount - remainingTokens).mul(tokenValue).div(oneXCC);
269             tokenAmount = remainingTokens;
270             owner.transfer(msg.value-refund);
271 			remainingTokens = 0; // set remaining token to 0
272              _buyer.transfer(refund);
273         } else {
274 			remainingTokens = remainingTokens.sub(tokenAmount); // update remaining token without bonus
275             owner.transfer(msg.value);
276         }
277         
278         uint256 tokenAmountWithBonus = tokenAmount.add(tokenAmount.mul( bonusRate ).div(10**4)); //add token bonus
279         
280         tokenContract.transfer(_buyer, tokenAmountWithBonus);
281         Buy(_buyer, tokenAmountWithBonus, currentAmbassador);
282         
283         totalSoldTokensWithBonus += tokenAmountWithBonus; 
284 		totalSoldTokensWithoutBonus += tokenAmount;
285 		
286         return tokenAmount; // retun tokenAmount without bonuses for easier calculations
287     }
288 
289     event NewAmbassador(address ambassador, address contr);
290     
291     function addMeByRC(address _ambassadorAddr) public {
292         require(tx.origin == owner);
293         
294         ambassadorAddressOf[ msg.sender ]  = _ambassadorAddr;
295         
296         NewAmbassador(_ambassadorAddr, msg.sender);
297     }
298 
299     function withdraw(address to, uint256 value) public onlyOwner {
300         to.transfer(value);
301     }
302     
303     function updateTokenContract(address _tokenContract) public onlyOwner {
304         tokenContract = tokenInterface(_tokenContract);
305     }
306 
307     function withdrawTokens(address to, uint256 value) public onlyOwner returns (bool) {
308         return tokenContract.transfer(to, value);
309     }
310     
311     function claimPremium(address _buyer, uint256 _amount) public returns(bool) {
312         require( ambassadorAddressOf[msg.sender] != address(0) ); // Check if is an authorized _ambassadorContract
313         return tokenContract.transfer(_buyer, _amount);
314     }
315 
316     function () public payable {
317         buy(msg.sender);
318     }
319 }