1 pragma solidity ^0.5.8;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://eips.ethereum.org/EIPS/eip-20
6  */
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 library IterableMap {
26     
27     struct IMap {
28         mapping(address => uint256) mapToData;
29         mapping(address => uint256) mapToIndex; // start with index 1
30         address[] indexes;
31     }
32     
33     function insert(IMap storage self, address _address, uint256 _value) internal returns (bool replaced) {
34       
35         require(_address != address(0));
36         
37         if(self.mapToIndex[_address] == 0){
38             
39             // add new
40             self.indexes.push(_address);
41             self.mapToIndex[_address] = self.indexes.length;
42             self.mapToData[_address] = _value;
43             return false;
44         }
45         
46         // replace
47         self.mapToData[_address] = _value;
48         return true;
49     }
50     
51     function remove(IMap storage self, address _address) internal returns (bool success) {
52        
53         require(_address != address(0));
54         
55         // not existing
56         if(self.mapToIndex[_address] == 0){
57             return false;   
58         }
59         
60         uint256 deleteIndex = self.mapToIndex[_address];
61         if(deleteIndex <= 0 || deleteIndex > self.indexes.length){
62             return false;
63         }
64        
65          // if index to be deleted is not the last index, swap position.
66         if (deleteIndex < self.indexes.length) {
67             // swap 
68             self.indexes[deleteIndex-1] = self.indexes[self.indexes.length-1];
69             self.mapToIndex[self.indexes[deleteIndex-1]] = deleteIndex;
70         }
71         self.indexes.length -= 1;
72         delete self.mapToData[_address];
73         delete self.mapToIndex[_address];
74        
75         return true;
76     }
77   
78     function contains(IMap storage self, address _address) internal view returns (bool exists) {
79         return self.mapToIndex[_address] > 0;
80     }
81       
82     function size(IMap storage self) internal view returns (uint256) {
83         return self.indexes.length;
84     }
85   
86     function get(IMap storage self, address _address) internal view returns (uint256) {
87         return self.mapToData[_address];
88     }
89 
90     // start with index 0
91     function getKey(IMap storage self, uint256 _index) internal view returns (address) {
92         
93         if(_index < self.indexes.length){
94             return self.indexes[_index];
95         }
96         return address(0);
97     }
98 }
99 
100 /**
101  * @title SafeMath
102  * @dev Unsigned math operations with safety checks that revert on error.
103  */
104 library SafeMath {
105     /**
106      * @dev Multiplies two unsigned integers, reverts on overflow.
107      */
108     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
109         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
110         // benefit is lost if 'b' is also tested.
111         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
112         if (a == 0) {
113             return 0;
114         }
115 
116         uint256 c = a * b;
117         require(c / a == b);
118 
119         return c;
120     }
121 
122     /**
123      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
124      */
125     function div(uint256 a, uint256 b) internal pure returns (uint256) {
126         // Solidity only automatically asserts when dividing by 0
127         require(b > 0);
128         uint256 c = a / b;
129         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
130 
131         return c;
132     }
133 
134     /**
135      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
136      */
137     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
138         require(b <= a);
139         uint256 c = a - b;
140 
141         return c;
142     }
143 
144     /**
145      * @dev Adds two unsigned integers, reverts on overflow.
146      */
147     function add(uint256 a, uint256 b) internal pure returns (uint256) {
148         uint256 c = a + b;
149         require(c >= a);
150 
151         return c;
152     }
153 
154     /**
155      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
156      * reverts when dividing by zero.
157      */
158     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
159         require(b != 0);
160         return a % b;
161     }
162 }
163 
164 /**
165  * @title Ownable
166  * @dev The Ownable contract has an owner address, and provides basic authorization control
167  * functions, this simplifies the implementation of "user permissions".
168  */
169 contract Ownable {
170     address public owner;
171 
172     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
173 
174     /**
175      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
176      * account.
177      */
178     constructor() public {
179         owner = msg.sender;
180     }
181     /**
182      * @dev Throws if called by any account other than the owner.
183      */
184     modifier onlyOwner() {
185         require(msg.sender == owner);
186         _;
187     }
188 
189     /**
190      * @dev Allows the current owner to transfer control of the contract to a newOwner.
191      * @param newOwner The address to transfer ownership to.
192      */
193     function transferOwnership(address newOwner) public onlyOwner {
194         require(newOwner != address(0));
195         emit OwnershipTransferred(owner, newOwner);
196         owner = newOwner;
197     }
198 }
199 
200 contract ZmineVoteKeep is Ownable {
201   
202     // Use itmap for all functions on the struct
203     using IterableMap for IterableMap.IMap;
204     using SafeMath for uint256;
205     
206     // ERC20 basic token contract being held
207     IERC20 public token;
208   
209     // map address => vote
210     IterableMap.IMap voteRecordMap;
211     // map address => token available for reclaim
212     IterableMap.IMap reclaimTokenMap;
213     
214     // time to start vote period
215     uint256 public timestampStartVote;
216     // time to end vote period
217     uint256 public timestampEndVote;
218     // time to enable reclaim token process
219     uint256 public timestampReleaseToken;
220     
221     // cumulative count for total vote
222     uint256 _totalVote;
223     
224     constructor(IERC20 _token) public {
225 
226         token = _token;
227         
228         // (Mainnet) May 22, 2019 GMT (epoch time 1558483200)
229         // (Kovan) from now
230         timestampStartVote = 1558483200; 
231         
232         // (Mainnet) May 28, 2019 GMT (epoch time 1559001600)
233         // (Kovan) period for 10 years
234         timestampEndVote = 1559001600; 
235         
236         // (Mainnet) May 30, 2019 GMT (epoch time 1559174400)
237         // (Kovan) from now
238         timestampReleaseToken = 1559174400; 
239     }
240     
241     /**
242      * modifier
243      */
244      
245     // during the votable period?
246     modifier onlyVotable() {
247         require(isVotable());
248         _;
249     }
250     
251     // during the reclaimable period?
252     modifier onlyReclaimable() {
253         require(isReclaimable());
254         _;
255     }
256   
257     /**
258      * public methods
259      */
260      
261     function isVotable() public view returns (bool){
262         return (timestampStartVote <= block.timestamp && block.timestamp <= timestampEndVote);
263     }
264     
265     function isReclaimable() public view returns (bool){
266         return (block.timestamp >= timestampReleaseToken);
267     }
268     
269     function countVoteUser() public view returns (uint256){
270         return voteRecordMap.size();
271     }
272     
273     function countVoteScore() public view returns (uint256){
274         return _totalVote;
275     }
276     
277     function getVoteByAddress(address _address) public view returns (uint256){
278         return voteRecordMap.get(_address);
279     }
280     
281     // vote by transfer token into this contract as collateral
282     // This process require approval from sender, to allow contract transfer token on the sender behalf.
283     function voteKeep(uint256 amount) public onlyVotable {
284 
285         require(token.balanceOf(msg.sender) >= amount);
286         
287         // transfer token on the sender behalf.
288         token.transferFrom(msg.sender, address(this), amount);
289         
290         // calculate cumulative vote
291         uint256 newAmount = voteRecordMap.get(msg.sender).add(amount);
292         
293         // save to map
294         reclaimTokenMap.insert(msg.sender, newAmount);
295         voteRecordMap.insert(msg.sender, newAmount);
296         
297         // cumulative count total vote
298         _totalVote = _totalVote.add(amount);
299     }
300     
301     // Take the token back to the sender after reclaimable period has come.
302     function reclaimToken() public onlyReclaimable {
303       
304         uint256 amount = reclaimTokenMap.get(msg.sender);
305         require(amount > 0);
306         require(token.balanceOf(address(this)) >= amount);
307           
308         // transfer token back to sender
309         token.transfer(msg.sender, amount);
310         
311         // remove from map
312         reclaimTokenMap.remove(msg.sender);
313     }
314     
315     /**
316      * admin methods
317      */
318      
319     function adminCountReclaimableUser() public view onlyOwner returns (uint256){
320         return reclaimTokenMap.size();
321     }
322     
323     function adminCheckReclaimableAddress(uint256 index) public view onlyOwner returns (address){
324         
325         require(index >= 0); 
326         
327         if(reclaimTokenMap.size() > index){
328             return reclaimTokenMap.getKey(index);
329         }else{
330             return address(0);
331         }
332     }
333     
334     function adminCheckReclaimableToken(uint256 index) public view onlyOwner returns (uint256){
335     
336         require(index >= 0); 
337     
338         if(reclaimTokenMap.size() > index){
339             return reclaimTokenMap.get(reclaimTokenMap.getKey(index));
340         }else{
341             return 0;
342         }
343     }
344     
345     function adminCheckVoteAddress(uint256 index) public view onlyOwner returns (address){
346         
347         require(index >= 0); 
348         
349         if(voteRecordMap.size() > index){
350             return voteRecordMap.getKey(index);
351         }else{
352             return address(0);
353         }
354     }
355     
356     function adminCheckVoteToken(uint256 index) public view onlyOwner returns (uint256){
357     
358         require(index >= 0); 
359     
360         if(voteRecordMap.size() > index){
361             return voteRecordMap.get(voteRecordMap.getKey(index));
362         }else{
363             return 0;
364         }
365     }
366     
367     // perform reclaim token by admin 
368     function adminReclaimToken(address _address) public onlyOwner {
369       
370         uint256 amount = reclaimTokenMap.get(_address);
371         require(amount > 0);
372         require(token.balanceOf(address(this)) >= amount);
373           
374         token.transfer(_address, amount);
375         
376         // remove from map
377         reclaimTokenMap.remove(_address);
378     }
379     
380     // Prevent deposit tokens by accident to a contract with the transfer function? 
381     // The transaction will succeed but this will not be recognized by the contract.
382     // After reclaim process was ended, admin will able to transfer the remain tokens to himself. 
383     // And return the remain tokens to senders by manual process.
384     function adminSweepMistakeTransferToken() public onlyOwner {
385         
386         require(reclaimTokenMap.size() == 0);
387         require(token.balanceOf(address(this)) > 0);
388         token.transfer(owner, token.balanceOf(address(this)));
389     }
390 }