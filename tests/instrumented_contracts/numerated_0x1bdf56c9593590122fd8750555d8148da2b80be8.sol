1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57   address public owner;
58 
59 
60   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62 
63   /**
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67   function Ownable() public {
68     owner = msg.sender;
69   }
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74   modifier onlyOwner() {
75     require(msg.sender == owner);
76     _;
77   }
78 
79   /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param newOwner The address to transfer ownership to.
82    */
83   function transferOwnership(address newOwner) public onlyOwner {
84     require(newOwner != address(0));
85     OwnershipTransferred(owner, newOwner);
86     owner = newOwner;
87   }
88 
89 }
90 
91 
92 
93 /**
94  * @title ERC20Basic
95  * @dev Simpler version of ERC20 interface
96  * @dev see https://github.com/ethereum/EIPs/issues/179
97  */
98 contract ERC20Basic {
99   function totalSupply() public view returns (uint256);
100   function balanceOf(address who) public view returns (uint256);
101   function transfer(address to, uint256 value) public returns (bool);
102   event Transfer(address indexed from, address indexed to, uint256 value);
103 }
104 
105 /**
106  * @title ERC20 interface
107  * @dev see https://github.com/ethereum/EIPs/issues/20
108  */
109 contract ERC20 is ERC20Basic {
110   function allowance(address owner, address spender) public view returns (uint256);
111   function transferFrom(address from, address to, uint256 value) public returns (bool);
112   function approve(address spender, uint256 value) public returns (bool);
113   event Approval(address indexed owner, address indexed spender, uint256 value);
114 }
115 
116 
117 
118 
119 
120 
121 /**
122  * @title ERC20 FSN Token Generation and Voluntary Participants Program
123  * @dev see https://github.com/FusionFoundation/TokenSale
124  */
125 contract ShareTokenSale is Ownable {
126 
127     using SafeMath for uint256;
128 
129     ERC20 public token;
130     address public receiverAddr;
131     uint256 public totalSaleAmount;
132     uint256 public totalWannaBuyAmount; 
133     uint256 public startTime;
134     uint256 public endTime;
135     uint256 public userWithdrawalStartTime;
136     uint256 public clearStartTime;
137     uint256 public withdrawn;
138     uint256 public proportion = 1 ether;
139     mapping(uint256 => uint256) public globalAmounts;    
140 
141 
142     struct Stage {
143         uint256 rate;
144         uint256 duration;
145         uint256 startTime;       
146     }
147     Stage[] public stages;    
148 
149 
150     struct PurchaserInfo {
151         bool withdrew;
152         bool recorded;
153         mapping(uint256 => uint256) amounts;
154     }
155     mapping(address => PurchaserInfo) public purchaserMapping;
156     address[] public purchaserList;
157 
158     modifier onlyOpenTime {
159         require(isStarted());
160         require(!isEnded());
161         _;
162     }
163 
164     modifier onlyAutoWithdrawalTime {
165          require(isEnded());
166         _;
167     }
168 
169     modifier onlyUserWithdrawalTime {
170         require(isUserWithdrawalTime());
171         _;
172     }
173 
174     modifier purchasersAllWithdrawn {
175         require(withdrawn==purchaserList.length);
176         _;
177     }
178 
179     modifier onlyClearTime {
180         require(isClearTime());
181         _;
182     }
183 
184     function ShareTokenSale(address _receiverAddr, address _tokenAddr, uint256 _totalSaleAmount, uint256 _startTime) public {
185         require(_receiverAddr != address(0));
186         require(_tokenAddr != address(0));
187         require(_totalSaleAmount > 0);
188         require(_startTime > 0);
189         receiverAddr = _receiverAddr;
190         token = ERC20(_tokenAddr);
191         totalSaleAmount = _totalSaleAmount;       
192         startTime = _startTime;        
193     }
194 
195     function isStarted() public view returns(bool) {
196         return 0 < startTime && startTime <= now && endTime != 0;
197     }   
198 
199     function isEnded() public view returns(bool) {
200         return now > endTime;
201     }
202 
203     function isUserWithdrawalTime() public view returns(bool) {
204         return now > userWithdrawalStartTime;
205     }
206 
207     function isClearTime() public view returns(bool) {
208         return now > clearStartTime;
209     }
210     
211     function startSale(uint256[] rates, uint256[] durations, uint256 userWithdrawalDelaySec, uint256 clearDelaySec) public onlyOwner {
212         require(endTime == 0);
213         require(durations.length == rates.length);
214         delete stages;
215         endTime = startTime;
216         for (uint256 i = 0; i < durations.length; i++) {
217             uint256 rate = rates[i];
218             uint256 duration = durations[i];            
219             stages.push(Stage({rate: rate, duration: duration, startTime:endTime}));
220             endTime = endTime.add(duration);
221         }
222         userWithdrawalStartTime = endTime.add(userWithdrawalDelaySec);
223         clearStartTime = endTime.add(clearDelaySec);
224     }
225     
226     function getCurrentStage() public onlyOpenTime view returns(uint256) {
227         for (uint256 i = stages.length - 1; i >= 0; i--) {
228             if (now >= stages[i].startTime) {
229                 return i;
230             }
231         }
232         revert();
233     }
234 
235     function getPurchaserCount() public view returns(uint256) {
236         return purchaserList.length;
237     }
238 
239 
240     function _calcProportion() internal {
241         if (totalWannaBuyAmount == 0 || totalSaleAmount >= totalWannaBuyAmount) {
242             proportion = 1 ether;
243             return;
244         }
245         proportion = totalSaleAmount.mul(1 ether).div(totalWannaBuyAmount);        
246     }
247 
248     function getSaleInfo(address purchaser) public view returns (uint256, uint256, uint256) {
249         PurchaserInfo storage pi = purchaserMapping[purchaser];
250         uint256 sendEther = 0;
251         uint256 usedEther = 0;
252         uint256 getToken = 0;        
253         for (uint256 i = 0; i < stages.length; i++) {
254             sendEther = sendEther.add(pi.amounts[i]);
255             uint256 stageUsedEther = pi.amounts[i].mul(proportion).div(1 ether);
256             uint256 stageGetToken = stageUsedEther.mul(stages[i].rate);
257             if (stageGetToken > 0) {         
258                 getToken = getToken.add(stageGetToken);
259                 usedEther = usedEther.add(stageUsedEther);
260             }
261         }        
262         return (sendEther, usedEther, getToken);
263     }
264     
265     function () payable public {        
266         buy();
267     }
268     
269     function buy() payable public onlyOpenTime {
270         require(msg.value >= 0.1 ether);
271         uint256 stageIndex = getCurrentStage();
272         uint256 amount = msg.value;
273         PurchaserInfo storage pi = purchaserMapping[msg.sender];
274         if (!pi.recorded) {
275             pi.recorded = true;
276             purchaserList.push(msg.sender);
277         }
278         pi.amounts[stageIndex] = pi.amounts[stageIndex].add(amount);
279         globalAmounts[stageIndex] = globalAmounts[stageIndex].add(amount);
280         totalWannaBuyAmount = totalWannaBuyAmount.add(amount.mul(stages[stageIndex].rate));
281         _calcProportion();
282     }
283     
284     function _withdrawal(address purchaser) internal {
285         require(purchaser != 0x0);
286         PurchaserInfo storage pi = purchaserMapping[purchaser];        
287         if (pi.withdrew) {
288             return;
289         }
290         pi.withdrew = true;
291         withdrawn = withdrawn.add(1);
292         var (sendEther, usedEther, getToken) = getSaleInfo(purchaser);
293         if (usedEther > 0 && getToken > 0) {
294             receiverAddr.transfer(usedEther);
295             token.transfer(purchaser, getToken);
296             if (sendEther.sub(usedEther) > 0) {                
297                 purchaser.transfer(sendEther.sub(usedEther));   
298             }           
299         } else {
300             purchaser.transfer(sendEther);
301         }
302         return;
303     }
304     
305     function withdrawal() payable public onlyUserWithdrawalTime {
306         _withdrawal(msg.sender);
307     }
308     
309     function withdrawalFor(uint256 index, uint256 stop) payable public onlyAutoWithdrawalTime onlyOwner {
310         for (; index < stop; index++) {
311             _withdrawal(purchaserList[index]);
312         }
313     }
314     
315     function clear(uint256 tokenAmount, uint256 etherAmount) payable public purchasersAllWithdrawn onlyClearTime onlyOwner {
316         if (tokenAmount > 0) {
317             token.transfer(receiverAddr, tokenAmount);
318         }
319         if (etherAmount > 0) {
320             receiverAddr.transfer(etherAmount);
321         }        
322     }
323 }