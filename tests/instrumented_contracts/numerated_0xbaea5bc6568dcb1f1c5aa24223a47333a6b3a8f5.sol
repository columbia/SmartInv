1 pragma solidity ^0.5.5;
2 
3 /*
4     This contract is open source under the MIT license
5     Ethfinex Inc - 2019
6 
7 /*
8 
9 /**
10  * @title SafeMath
11  * @dev Unsigned math operations with safety checks that revert on error.
12  */
13 library SafeMath {
14     /**
15      * @dev Multiplies two unsigned integers, reverts on overflow.
16      */
17     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
19         // benefit is lost if 'b' is also tested.
20         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
21         if (a == 0) {
22             return 0;
23         }
24 
25         uint256 c = a * b;
26         require(c / a == b);
27 
28         return c;
29     }
30 
31     /**
32      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
33      */
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         // Solidity only automatically asserts when dividing by 0
36         require(b > 0);
37         uint256 c = a / b;
38         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39 
40         return c;
41     }
42 
43     /**
44      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         require(b <= a);
48         uint256 c = a - b;
49 
50         return c;
51     }
52 
53     /**
54      * @dev Adds two unsigned integers, reverts on overflow.
55      */
56     function add(uint256 a, uint256 b) internal pure returns (uint256) {
57         uint256 c = a + b;
58         require(c >= a);
59 
60         return c;
61     }
62 
63     /**
64      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
65      * reverts when dividing by zero.
66      */
67     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
68         require(b != 0);
69         return a % b;
70     }
71 }
72 
73 /**
74  * @title Ownable
75  * @dev The Ownable contract has an owner address, and provides basic authorization control
76  * functions, this simplifies the implementation of "user permissions".
77  */
78 contract Ownable {
79     address private _owner;
80 
81     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83     /**
84      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
85      * account.
86      */
87     constructor () internal {
88         _owner = msg.sender;
89         emit OwnershipTransferred(address(0), _owner);
90     }
91 
92     /**
93      * @return the address of the owner.
94      */
95     function owner() public view returns (address) {
96         return _owner;
97     }
98 
99     /**
100      * @dev Throws if called by any account other than the owner.
101      */
102     modifier onlyOwner() {
103         require(isOwner());
104         _;
105     }
106 
107     /**
108      * @return true if `msg.sender` is the owner of the contract.
109      */
110     function isOwner() public view returns (bool) {
111         return msg.sender == _owner;
112     }
113 
114     /**
115      * @dev Allows the current owner to relinquish control of the contract.
116      * It will not be possible to call the functions with the `onlyOwner`
117      * modifier anymore.
118      * @notice Renouncing ownership will leave the contract without an owner,
119      * thereby removing any functionality that is only available to the owner.
120      */
121     function renounceOwnership() public onlyOwner {
122         emit OwnershipTransferred(_owner, address(0));
123         _owner = address(0);
124     }
125 
126     /**
127      * @dev Allows the current owner to transfer control of the contract to a newOwner.
128      * @param newOwner The address to transfer ownership to.
129      */
130     function transferOwnership(address newOwner) public onlyOwner {
131         _transferOwnership(newOwner);
132     }
133 
134     /**
135      * @dev Transfers control of the contract to a newOwner.
136      * @param newOwner The address to transfer ownership to.
137      */
138     function _transferOwnership(address newOwner) internal {
139         require(newOwner != address(0));
140         emit OwnershipTransferred(_owner, newOwner);
141         _owner = newOwner;
142     }
143 }
144 
145 
146 interface Token {
147 
148     function transfer(address _to, uint _value) external returns (bool);
149     function transferFrom(address _from, address _to, uint _value) external returns (bool);
150     function approve(address _spender, uint _value) external returns (bool);
151     function balanceOf(address _owner) external view returns (uint);
152     function allowance(address _owner, address _spender) external view returns (uint);
153 
154     event Transfer(address indexed _from, address indexed _to, uint _value); // solhint-disable-line
155     event Approval(address indexed _owner, address indexed _spender, uint _value);
156 }
157 
158 interface TokenNoReturn {
159 
160     function transfer(address _to, uint _value) external;
161     function transferFrom(address _from, address _to, uint _value) external;
162     function balanceOf(address _owner) external view returns (uint);
163 }
164 
165 contract TrustlessOTC is Ownable {
166     using SafeMath for uint256;
167 
168     mapping(address => uint256) public balanceTracker;
169     mapping(address => uint256) public feeTracker;
170     mapping(address => uint[]) public tradeTracker;
171 
172     mapping(address => bool) public noERC20Return;
173 
174     event OfferCreated(uint indexed tradeID);
175     event OfferCancelled(uint indexed tradeID);
176     event OfferTaken(uint indexed tradeID);
177 
178     uint256 public feeBasisPoints;
179 
180     constructor (uint256 _feeBasisPoints) public {
181       feeBasisPoints = _feeBasisPoints;
182       noERC20Return[0xdAC17F958D2ee523a2206206994597C13D831ec7] = true;
183       noERC20Return[0xB97048628DB6B661D4C2aA833e95Dbe1A905B280] = true;
184       noERC20Return[0x4470BB87d77b963A013DB939BE332f927f2b992e] = true;
185       noERC20Return[0xd26114cd6EE289AccF82350c8d8487fedB8A0C07] = true;
186       noERC20Return[0xB8c77482e45F1F44dE1745F52C74426C631bDD52] = true;
187       noERC20Return[0xF433089366899D83a9f26A773D59ec7eCF30355e] = true;
188       noERC20Return[0xe3818504c1B32bF1557b16C238B2E01Fd3149C17] = true;
189       noERC20Return[0x81c9151de0C8bafCd325a57E3dB5a5dF1CEBf79c] = true;
190     }
191 
192     struct TradeOffer {
193         address tokenFrom;
194         address tokenTo;
195         uint256 amountFrom;
196         uint256 amountTo;
197         address payable creator;
198         address optionalTaker;
199         bool active;
200         bool completed;
201         uint tradeID;
202     }
203 
204     TradeOffer[] public offers;
205 
206     function initiateTrade(
207         address _tokenFrom,
208         address _tokenTo,
209         uint256 _amountFrom,
210         uint256 _amountTo,
211         address _optionalTaker
212         ) public payable returns (uint newTradeID) {
213             if (_tokenFrom == address(0)) {
214                 require(msg.value == _amountFrom);
215             } else {
216                 require(msg.value == 0);
217                 if(noERC20Return[_tokenFrom]) {
218                   TokenNoReturn(_tokenFrom).transferFrom(msg.sender, address(this), _amountFrom);
219                 } else {
220                   Token(_tokenFrom).transferFrom(msg.sender, address(this), _amountFrom);
221                 }
222             }
223             newTradeID = offers.length;
224             offers.length++;
225             TradeOffer storage o = offers[newTradeID];
226             balanceTracker[_tokenFrom] = balanceTracker[_tokenFrom].add(_amountFrom);
227             o.tokenFrom = _tokenFrom;
228             o.tokenTo = _tokenTo;
229             o.amountFrom = _amountFrom;
230             o.amountTo = _amountTo;
231             o.creator = msg.sender;
232             o.optionalTaker = _optionalTaker;
233             o.active = true;
234             o.tradeID = newTradeID;
235             tradeTracker[msg.sender].push(newTradeID);
236             emit OfferCreated(newTradeID);
237     }
238 
239     function cancelTrade(uint tradeID) public returns (bool) {
240         TradeOffer storage o = offers[tradeID];
241         require(msg.sender == o.creator);
242         if (o.tokenFrom == address(0)) {
243           msg.sender.transfer(o.amountFrom);
244         } else {
245           if(noERC20Return[o.tokenFrom]) {
246             TokenNoReturn(o.tokenFrom).transfer(o.creator, o.amountFrom);
247           } else {
248             Token(o.tokenFrom).transfer(o.creator, o.amountFrom);
249           }
250         }
251         balanceTracker[o.tokenFrom] -= o.amountFrom;
252         o.active = false;
253         emit OfferCancelled(tradeID);
254         return true;
255     }
256 
257     function take(uint tradeID) public payable returns (bool) {
258         TradeOffer storage o = offers[tradeID];
259         require(o.optionalTaker == msg.sender || o.optionalTaker == address(0));
260         require(o.active == true);
261         o.active = false;
262         balanceTracker[o.tokenFrom] = balanceTracker[o.tokenFrom].sub(o.amountFrom);
263         uint256 fee = o.amountFrom.mul(feeBasisPoints).div(10000);
264         feeTracker[o.tokenFrom] = feeTracker[o.tokenFrom].add(fee);
265         tradeTracker[msg.sender].push(tradeID);
266 
267         if (o.tokenFrom == address(0)) {
268             msg.sender.transfer(o.amountFrom.sub(fee));
269         } else {
270           if(noERC20Return[o.tokenFrom]) {
271             TokenNoReturn(o.tokenFrom).transfer(msg.sender, o.amountFrom.sub(fee));
272           } else {
273             Token(o.tokenFrom).transfer(msg.sender, o.amountFrom.sub(fee));
274           }
275         }
276 
277         if (o.tokenTo == address(0)) {
278             require(msg.value == o.amountTo);
279             o.creator.transfer(msg.value);
280         } else {
281             require(msg.value == 0);
282             if(noERC20Return[o.tokenTo]) {
283               TokenNoReturn(o.tokenTo).transferFrom(msg.sender, o.creator, o.amountTo);
284             } else {
285               Token(o.tokenTo).transferFrom(msg.sender, o.creator, o.amountTo);
286             }
287         }
288         o.completed = true;
289         emit OfferTaken(tradeID);
290         return true;
291     }
292 
293     function getOfferDetails(uint tradeID) external view returns (
294         address _tokenFrom,
295         address _tokenTo,
296         uint256 _amountFrom,
297         uint256 _amountTo,
298         address _creator,
299         uint256 _fee,
300         bool _active,
301         bool _completed
302     ) {
303         TradeOffer storage o = offers[tradeID];
304         _tokenFrom = o.tokenFrom;
305         _tokenTo = o.tokenTo;
306         _amountFrom = o.amountFrom;
307         _amountTo = o.amountTo;
308         _creator = o.creator;
309         _fee = o.amountFrom.mul(feeBasisPoints).div(10000);
310         _active = o.active;
311         _completed = o.completed;
312     }
313 
314     function getUserTrades(address user) external view returns (uint[] memory){
315       return tradeTracker[user];
316     }
317 
318     function reclaimToken(Token _token) external onlyOwner {
319         uint256 balance = _token.balanceOf(address(this));
320         uint256 excess = balance.sub(balanceTracker[address(_token)]);
321         require(excess > 0);
322         if (address(_token) == address(0)) {
323             msg.sender.transfer(excess);
324         } else {
325             _token.transfer(owner(), excess);
326         }
327     }
328 
329     function reclaimTokenNoReturn(TokenNoReturn _token) external onlyOwner {
330         uint256 balance = _token.balanceOf(address(this));
331         uint256 excess = balance.sub(balanceTracker[address(_token)]);
332         require(excess > 0);
333         if (address(_token) == address(0)) {
334             msg.sender.transfer(excess);
335         } else {
336             _token.transfer(owner(), excess);
337         }
338     }
339 
340     function claimFees(Token _token) external onlyOwner {
341         uint256 feesToClaim = feeTracker[address(_token)];
342         feeTracker[address(_token)] = 0;
343         require(feesToClaim > 0);
344         if (address(_token) == address(0)) {
345             msg.sender.transfer(feesToClaim);
346         } else {
347             _token.transfer(owner(), feesToClaim);
348         }
349     }
350 
351 }