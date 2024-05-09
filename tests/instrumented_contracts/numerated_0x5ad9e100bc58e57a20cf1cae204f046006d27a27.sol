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
139 	event Track(address indexed buyer, bytes trackID, uint256 value, uint256 soldTokensWithoutBonus );
140 	
141     function () public payable {
142         require( now > startRC );
143         if( now < endRC ) {
144             uint256 tokenAmount = icoContract.buy.value(msg.value)(msg.sender);
145             balanceUser[msg.sender] = balanceUser[msg.sender].add(tokenAmount);
146             soldTokensWithoutBonus = soldTokensWithoutBonus.add(tokenAmount);
147 			Track( msg.sender, msg.data, msg.value, tokenAmount );
148         } else { //claim premium bonus logic
149             require( balanceUser[msg.sender] > 0 );
150             uint256 bonusApplied = 0;
151             for (uint i = 0; i < euroThreshold.length; i++) {
152                 if ( icoContract.euroRaised(soldTokensWithoutBonus).div(1000) > euroThreshold[i] ) {
153                     bonusApplied = bonusThreshold[i];
154                 }
155             }    
156             require( bonusApplied > 0 );
157             
158             uint256 addTokenAmount = balanceUser[msg.sender].mul( bonusApplied ).div(10**2);
159             balanceUser[msg.sender] = 0; 
160             
161             icoContract.claimPremium(msg.sender, addTokenAmount);
162             if( msg.value > 0 ) msg.sender.transfer(msg.value); // give back eth 
163         }
164     }
165 }
166 
167 contract CoinCrowdICO is Ownable {
168     using SafeMath for uint256;
169     tokenInterface public tokenContract;
170     
171 	uint256 public decimals = 18;
172     uint256 public tokenValue;  // 1 XCC in wei
173     uint256 public constant centToken = 20; // euro cents value of 1 token 
174     
175     function euroRaised(uint256 _weiTokens) public view returns (uint256) { // convertion of sold token in euro raised in wei
176         return _weiTokens.mul(centToken).div(100).div(10**decimals);
177     }
178     
179     uint256 public endTime;  // seconds from 1970-01-01T00:00:00Z
180     uint256 public startTime;  // seconds from 1970-01-01T00:00:00Z
181     uint256 internal constant weekInSeconds = 604800; // seconds in a week
182     
183     uint256 public totalSoldTokensWithBonus; // total wei of XCC distribuited from this ICO
184     uint256 public totalSoldTokensWithoutBonus; // total wei of XCC distribuited from this ICO without bonus
185 	function euroRaisedICO() public view returns(uint256 euro) {
186         return euroRaised(totalSoldTokensWithoutBonus);
187     }
188 	
189     uint256 public remainingTokens; // total wei of XCC remaining (without bonuses)
190 
191     mapping(address => address) public ambassadorAddressOf; // ambassadorContract => ambassadorAddress
192 
193 
194     function CoinCrowdICO(address _tokenAddress, uint256 _tokenValue, uint256 _startTime) public {
195         tokenContract = tokenInterface(_tokenAddress);
196         tokenValue = _tokenValue;
197         startICO(_startTime); 
198         totalSoldTokensWithBonus = 0;
199         totalSoldTokensWithoutBonus = 0;
200         remainingTokens = 24500000  * 10 ** decimals; // 24.500.000 * 0.20€ = 4.900.000€ CAPPED
201     }
202 
203     address public updater;  // account in charge of updating the token value
204     event UpdateValue(uint256 newValue);
205 
206     function updateValue(uint256 newValue) public {
207         require(msg.sender == updater || msg.sender == owner);
208         tokenValue = newValue;
209         UpdateValue(newValue);
210     }
211 
212     function updateUpdater(address newUpdater) public onlyOwner {
213         updater = newUpdater;
214     }
215 
216     function updateTime(uint256 _newStart, uint256 _newEnd) public onlyOwner {
217         if ( _newStart != 0 ) startTime = _newStart;
218         if ( _newEnd != 0 ) endTime = _newEnd;
219     }
220     
221     function updateTimeRC(address _rcContract, uint256 _newStart, uint256 _newEnd) public onlyOwner {
222         Ambassador(_rcContract).updateTime( _newStart, _newEnd);
223     }
224     
225     function startICO(uint256 _startTime) public onlyOwner {
226         if(_startTime == 0 ) {
227             startTime = now;
228         } else {
229             startTime = _startTime;
230         }
231         endTime = startTime + 12*weekInSeconds;
232     }
233     
234     event Buy(address buyer, uint256 value, address indexed ambassador);
235 
236     function buy(address _buyer) public payable returns(uint256) {
237         require(now < endTime); // check if ended
238         require( remainingTokens > 0 ); // Check if there are any remaining tokens excluding bonuses
239         
240         require( tokenContract.balanceOf(this) > remainingTokens); // should have enough balance
241         
242         uint256 oneXCC = 10 ** decimals;
243         uint256 tokenAmount = msg.value.mul(oneXCC).div(tokenValue);
244         
245         
246         uint256 bonusRate; // decimals of bonus 20% = 2000
247         address currentAmbassador = address(0);
248         if ( ambassadorAddressOf[msg.sender] != address(0) ) { // if is an authorized ambassadorContract
249             currentAmbassador = msg.sender;
250             bonusRate = 0; // Ambassador Comunity should claim own bonus at the end of RC 
251             
252         } else { // if is directly called to CoinCrowdICO contract
253             require(now > startTime); // check if started for public user
254             
255             if( now > startTime + weekInSeconds*0  ) { bonusRate = 2000; }
256             if( now > startTime + weekInSeconds*1  ) { bonusRate = 1833; }
257             if( now > startTime + weekInSeconds*2  ) { bonusRate = 1667; }
258             if( now > startTime + weekInSeconds*3  ) { bonusRate = 1500; }
259             if( now > startTime + weekInSeconds*4  ) { bonusRate = 1333; }
260             if( now > startTime + weekInSeconds*5  ) { bonusRate = 1167; }
261             if( now > startTime + weekInSeconds*6  ) { bonusRate = 1000; }
262             if( now > startTime + weekInSeconds*7  ) { bonusRate = 833; }
263             if( now > startTime + weekInSeconds*8  ) { bonusRate = 667; }
264             if( now > startTime + weekInSeconds*9  ) { bonusRate = 500; }
265             if( now > startTime + weekInSeconds*10 ) { bonusRate = 333; }
266             if( now > startTime + weekInSeconds*11 ) { bonusRate = 167; }
267             if( now > startTime + weekInSeconds*12 ) { bonusRate = 0; }
268         }
269         
270         if ( remainingTokens < tokenAmount ) {
271             uint256 refund = (tokenAmount - remainingTokens).mul(tokenValue).div(oneXCC);
272             tokenAmount = remainingTokens;
273             owner.transfer(msg.value-refund);
274 			remainingTokens = 0; // set remaining token to 0
275              _buyer.transfer(refund);
276         } else {
277 			remainingTokens = remainingTokens.sub(tokenAmount); // update remaining token without bonus
278             owner.transfer(msg.value);
279         }
280         
281         uint256 tokenAmountWithBonus = tokenAmount.add(tokenAmount.mul( bonusRate ).div(10**4)); //add token bonus
282         
283         tokenContract.transfer(_buyer, tokenAmountWithBonus);
284         Buy(_buyer, tokenAmountWithBonus, currentAmbassador);
285         
286         totalSoldTokensWithBonus += tokenAmountWithBonus; 
287 		totalSoldTokensWithoutBonus += tokenAmount;
288 		
289         return tokenAmount; // retun tokenAmount without bonuses for easier calculations
290     }
291 
292     event NewAmbassador(address ambassador, address contr);
293     
294     function addMeByRC(address _ambassadorAddr) public {
295         require(tx.origin == owner);
296         
297         ambassadorAddressOf[ msg.sender ]  = _ambassadorAddr;
298         
299         NewAmbassador(_ambassadorAddr, msg.sender);
300     }
301 
302     function withdraw(address to, uint256 value) public onlyOwner {
303         to.transfer(value);
304     }
305     
306     function updateTokenContract(address _tokenContract) public onlyOwner {
307         tokenContract = tokenInterface(_tokenContract);
308     }
309 
310     function withdrawTokens(address to, uint256 value) public onlyOwner returns (bool) {
311         return tokenContract.transfer(to, value);
312     }
313     
314     function claimPremium(address _buyer, uint256 _amount) public returns(bool) {
315         require( ambassadorAddressOf[msg.sender] != address(0) ); // Check if is an authorized _ambassadorContract
316         return tokenContract.transfer(_buyer, _amount);
317     }
318 
319     function () public payable {
320         buy(msg.sender);
321     }
322 }