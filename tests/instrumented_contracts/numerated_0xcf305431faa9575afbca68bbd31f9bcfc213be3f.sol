1 // SPDX-License-Identifier: MIT
2 
3 // https://minethereum.tech/
4 // https://twitter.com/Minethereumtech
5 // https://t.me/minethereum
6 
7 
8 library SafeMath {
9   
10     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
11         unchecked {
12             uint256 c = a + b;
13             if (c < a) return (false, 0);
14             return (true, c);
15         }
16     }
17 
18    
19     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
20         unchecked {
21             if (b > a) return (false, 0);
22             return (true, a - b);
23         }
24     }
25 
26   
27     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
28         unchecked {
29            
30             if (a == 0) return (true, 0);
31             uint256 c = a * b;
32             if (c / a != b) return (false, 0);
33             return (true, c);
34         }
35     }
36 
37    
38     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
39         unchecked {
40             if (b == 0) return (false, 0);
41             return (true, a / b);
42         }
43     }
44 
45    
46     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
47         unchecked {
48             if (b == 0) return (false, 0);
49             return (true, a % b);
50         }
51     }
52 
53    
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         return a + b;
56     }
57 
58  
59     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60         return a - b;
61     }
62 
63    
64     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65         return a * b;
66     }
67 
68   
69     function div(uint256 a, uint256 b) internal pure returns (uint256) {
70         return a / b;
71     }
72 
73    
74     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
75         return a % b;
76     }
77 
78    
79     function sub(
80         uint256 a,
81         uint256 b,
82         string memory errorMessage
83     ) internal pure returns (uint256) {
84         unchecked {
85             require(b <= a, errorMessage);
86             return a - b;
87         }
88     }
89 
90    
91     function div(
92         uint256 a,
93         uint256 b,
94         string memory errorMessage
95     ) internal pure returns (uint256) {
96         unchecked {
97             require(b > 0, errorMessage);
98             return a / b;
99         }
100     }
101 
102    
103     function mod(
104         uint256 a,
105         uint256 b,
106         string memory errorMessage
107     ) internal pure returns (uint256) {
108         unchecked {
109             require(b > 0, errorMessage);
110             return a % b;
111         }
112     }
113 }
114 
115 pragma solidity 0.8.17;
116 
117 
118 abstract contract Context {
119     function _msgSender() internal view virtual returns (address) {
120         return msg.sender;
121     }
122 
123     function _msgData() internal view virtual returns (bytes calldata) {
124         return msg.data;
125     }
126 }
127 
128 contract Ownable is Context {
129     address private _owner;
130 
131     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
132 
133    
134     constructor () {
135       address msgSender = _msgSender();
136       _owner = msgSender;
137       emit OwnershipTransferred(address(0), msgSender);
138     }
139 
140    
141     function owner() public view returns (address) {
142       return _owner;
143     }
144 
145     
146     modifier onlyOwner() {
147       require(_owner == _msgSender(), "Ownable: caller is not the owner");
148       _;
149     }
150 
151     function renounceOwnership() public onlyOwner {
152       emit OwnershipTransferred(_owner, address(0));
153       _owner = address(0);
154     }
155 
156     function transferOwnership(address newOwner) public onlyOwner {
157       _transferOwnership(newOwner);
158     }
159 
160     function _transferOwnership(address newOwner) internal {
161       require(newOwner != address(0), "Ownable: new owner is the zero address");
162       emit OwnershipTransferred(_owner, newOwner);
163       _owner = newOwner;
164     }
165 }
166 
167 contract minethereum is Context, Ownable {
168     using SafeMath for uint256;
169 
170     uint256 private EGGS_TO_HATCH_1MINERS = 1080000;
171     uint256 private PSN = 10000;
172     uint256 private PSNH = 5000;
173     uint256 private devFeeVal = 4;
174     bool private initialized = false;
175     address payable private recAdd;
176     mapping (address => uint256) private hatcheryMiners;
177     mapping (address => uint256) private claimedEggs;
178     mapping (address => uint256) private lastHatch;
179     mapping (address => address) private referrals;
180     uint256 private marketEggs;
181     
182     constructor() {
183         recAdd = payable(msg.sender);
184     }
185     
186     function hatchEggs(address ref) public {
187         require(initialized);
188         
189         if(ref == msg.sender) {
190             ref = address(0);
191         }
192         
193         if(referrals[msg.sender] == address(0) && referrals[msg.sender] != msg.sender) {
194             referrals[msg.sender] = ref;
195         }
196         
197         uint256 eggsUsed = getMyEggs(msg.sender);
198         uint256 newMiners = SafeMath.div(eggsUsed,EGGS_TO_HATCH_1MINERS);
199         hatcheryMiners[msg.sender] = SafeMath.add(hatcheryMiners[msg.sender],newMiners);
200         claimedEggs[msg.sender] = 0;
201         lastHatch[msg.sender] = block.timestamp;
202         
203         
204         claimedEggs[referrals[msg.sender]] = SafeMath.add(claimedEggs[referrals[msg.sender]],SafeMath.div(eggsUsed,8));
205         
206         
207         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,5));
208     }
209     
210     function sellEggs() public {
211         require(initialized);
212         uint256 hasEggs = getMyEggs(msg.sender);
213         uint256 eggValue = calculateEggSell(hasEggs);
214         uint256 fee = devFee(eggValue);
215         claimedEggs[msg.sender] = 0;
216         lastHatch[msg.sender] = block.timestamp;
217         marketEggs = SafeMath.add(marketEggs,hasEggs);
218         recAdd.transfer(fee);
219         payable (msg.sender).transfer(SafeMath.sub(eggValue,fee));
220     }
221     
222     function beanRewards(address adr) public view returns(uint256) {
223         uint256 hasEggs = getMyEggs(adr);
224         uint256 eggValue = calculateEggSell(hasEggs);
225         return eggValue;
226     }
227     
228     function buyEggs(address ref) public payable {
229         require(initialized);
230         uint256 eggsBought = calculateEggBuy(msg.value,SafeMath.sub(address(this).balance,msg.value));
231         eggsBought = SafeMath.sub(eggsBought,devFee(eggsBought));
232         uint256 fee = devFee(msg.value);
233         recAdd.transfer(fee);
234         claimedEggs[msg.sender] = SafeMath.add(claimedEggs[msg.sender],eggsBought);
235         hatchEggs(ref);
236     }
237     
238     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) private view returns(uint256) {
239         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
240     }
241     
242     function calculateEggSell(uint256 eggs) public view returns(uint256) {
243         return calculateTrade(eggs,marketEggs,address(this).balance);
244     }
245     
246     function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256) {
247         return calculateTrade(eth,contractBalance,marketEggs);
248     }
249     
250     function calculateEggBuySimple(uint256 eth) public view returns(uint256) {
251         return calculateEggBuy(eth,address(this).balance);
252     }
253     
254     function devFee(uint256 amount) private view returns(uint256) {
255         return SafeMath.div(SafeMath.mul(amount,devFeeVal),100);
256     }
257     
258     function seedMarket() public payable onlyOwner {
259         require(marketEggs == 0);
260         initialized = true;
261         marketEggs = 108000000000;
262     }
263     
264     function getBalance() public view returns(uint256) {
265         return address(this).balance;
266     }
267     
268     function getMyMiners(address adr) public view returns(uint256) {
269         return hatcheryMiners[adr];
270     }
271     
272     function getMyEggs(address adr) public view returns(uint256) {
273         return SafeMath.add(claimedEggs[adr],getEggsSinceLastHatch(adr));
274     }
275     
276     function getEggsSinceLastHatch(address adr) public view returns(uint256) {
277         uint256 secondsPassed=min(EGGS_TO_HATCH_1MINERS,SafeMath.sub(block.timestamp,lastHatch[adr]));
278         return SafeMath.mul(secondsPassed,hatcheryMiners[adr]);
279     }
280     
281     function min(uint256 a, uint256 b) private pure returns (uint256) {
282         return a < b ? a : b;
283     }
284 }