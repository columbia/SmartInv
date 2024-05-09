1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipRenounced(address indexed previousOwner);
63   event OwnershipTransferred(
64     address indexed previousOwner,
65     address indexed newOwner
66   );
67 
68 
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71    * account.
72    */
73   constructor() public {
74     owner = msg.sender;
75   }
76 
77   /**
78    * @dev Throws if called by any account other than the owner.
79    */
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to relinquish control of the contract.
87    */
88   function renounceOwnership() public onlyOwner {
89     emit OwnershipRenounced(owner);
90     owner = address(0);
91   }
92 
93   /**
94    * @dev Allows the current owner to transfer control of the contract to a newOwner.
95    * @param _newOwner The address to transfer ownership to.
96    */
97   function transferOwnership(address _newOwner) public onlyOwner {
98     _transferOwnership(_newOwner);
99   }
100 
101   /**
102    * @dev Transfers control of the contract to a newOwner.
103    * @param _newOwner The address to transfer ownership to.
104    */
105   function _transferOwnership(address _newOwner) internal {
106     require(_newOwner != address(0));
107     emit OwnershipTransferred(owner, _newOwner);
108     owner = _newOwner;
109   }
110 }
111 
112 contract Extendable is Ownable {
113     struct ProviderItem {
114         uint start;
115         uint end;
116         address providerAddress;
117     }
118 
119     uint public currentId = 10000;
120     uint16 public currentVersion = 0;
121     mapping (uint => ProviderItem) internal providers;
122 
123     function upgradeProvider(address _address) 
124         public onlyOwner returns (bool) 
125     {
126         require(_address != 0x0);
127         require(providers[currentVersion].providerAddress != _address);
128 
129         // first time
130         if (providers[currentVersion].providerAddress == 0x0) {
131             providers[currentVersion].start = currentId;
132             providers[currentVersion].end = 10 ** 18;
133             providers[currentVersion].providerAddress = _address;
134             return true;            
135         }
136 
137         providers[currentVersion].end = currentId - 1;
138 
139         ProviderItem memory newProvider = ProviderItem({
140             start: currentId,
141             end: 10**18,
142             providerAddress: _address
143         });
144 
145         providers[++currentVersion] = newProvider;
146 
147         return true;
148     }
149 
150     function getProviderDetails(uint _version) public view returns (uint _start, uint _end, address _address) 
151     {
152         ProviderItem memory provider = providers[_version];
153         return (provider.start, provider.end, provider.providerAddress);
154     }
155 
156     function getProviderById(uint _id) public view returns (address) {
157         for (uint i = currentVersion; i >= 0; i--) {
158             ProviderItem memory item = providers[i];
159             if (item.start <= _id && item.end >= _id) {
160                 return item.providerAddress;
161             }
162         }
163 
164         return getCurrentProvider();
165     }
166 
167     function getCurrentProvider() public view returns(address) {
168         return providers[currentVersion].providerAddress;
169     }   
170 
171     function getAllProviders() public view returns (address[] memory addresses) {
172         addresses = new address[](currentVersion + 1);
173         for (uint i=0; i <= currentVersion; i++) {
174             addresses[i] = providers[i].providerAddress;
175         }
176 
177         return addresses;
178     }
179 
180     function resetCurrentIdTo(uint _newId) public onlyOwner returns (bool success) {
181         currentId = _newId;
182         return true;
183     }
184 }
185 
186 interface Provider {
187     function isBrickOwner(uint _brickId, address _address) external view returns (bool success);
188     function addBrick(uint _brickId, string _title, string _url, uint _expired, string _description, bytes32[] _tags, uint _value)
189         external returns (bool success);
190     function changeBrick(
191         uint _brickId,
192         string _title,
193         string _url,
194         string _description,
195         bytes32[] _tags,
196         uint _value) external returns (bool success);
197     function accept(uint _brickId, address[] _builderAddresses, uint[] percentages, uint _additionalValue) external returns (uint total);
198     function cancel(uint _brickId) external returns (uint value);
199     function startWork(uint _brickId, bytes32 _builderId, bytes32 _nickName, address _builderAddress) external returns(bool success);
200     function getBrickIds() external view returns(uint[]);
201     function getBrickSize() external view returns(uint);
202     function getBrick(uint _brickId) external view returns(
203         string title,
204         string url, 
205         address owner,
206         uint value,
207         uint32 dateCreated,
208         uint32 dateCompleted, 
209         uint32 expired,
210         uint status
211     );
212 
213     function getBrickDetail(uint _brickId) external view returns(
214         bytes32[] tags, 
215         string description, 
216         uint32 builders, 
217         address[] winners
218     );
219 
220     function getBrickBuilders(uint _brickId) external view returns (
221         address[] addresses,
222         uint[] dates,
223         bytes32[] keys,
224         bytes32[] names
225     );
226 
227     function filterBrick(
228         uint _brickId, 
229         bytes32[] _tags, 
230         uint _status, 
231         uint _started,
232         uint _expired
233         ) external view returns (
234       bool
235     );
236 
237 
238     function participated( 
239         uint _brickId,
240         address _builder
241         ) external view returns (
242         bool
243     ); 
244 }
245 
246 // solhint-disable-next-line compiler-fixed, compiler-gt-0_4
247 
248 
249 
250 
251 
252 
253 
254 contract WeBuildWorld is Extendable {
255     using SafeMath for uint256;
256 
257     string public constant VERSION = "0.1";
258     uint public constant DENOMINATOR = 10000;
259     enum AddressRole { Owner, Builder }
260 
261 
262     modifier onlyBrickOwner(uint _brickId) {
263         require(getProvider(_brickId).isBrickOwner(_brickId, msg.sender));
264         _;
265     }
266 
267     event BrickAdded (uint _brickId);
268     event BrickUpdated (uint _brickId);
269     event BrickCancelled (uint _brickId);
270     event WorkStarted (uint _brickId, address _builderAddress);
271     event WorkAccepted (uint _brickId, address[] _winners);
272  
273     function () public payable {
274         revert();
275     }
276 
277     function getBrickIdsByOwner(address _owner) public view returns(uint[] brickIds) {
278         return _getBrickIdsByAddress(_owner, AddressRole.Owner);
279     }
280 
281     function getBrickIdsByBuilder(address _builder) public view returns(uint[] brickIds) {
282         return _getBrickIdsByAddress(_builder, AddressRole.Builder);
283     }
284  
285     function _getBrickIdsByAddress(
286         address _address,
287         AddressRole role
288       ) 
289         private view returns(uint[] brickIds) { 
290         address[] memory providers = getAllProviders();
291         uint[] memory temp; 
292         uint total = 0;
293         uint index = 0; 
294 
295         for (uint i = providers.length; i > 0; i--) {
296             Provider provider = Provider(providers[i-1]);
297             total = total + provider.getBrickSize();  
298         }
299 
300         brickIds = new uint[](total);  
301     
302         for(i = 0; i < providers.length; i++){
303             temp = provider.getBrickIds();
304             for (uint j = 0; j < temp.length; j++) {
305                 bool cond = true;
306                 if(role == AddressRole.Owner){
307                     cond = provider.isBrickOwner(temp[j], _address);
308                 }else{
309                     cond = provider.participated(temp[j], _address);
310                 } 
311                 if(cond){
312                     brickIds[index] = temp[j]; 
313                     index++;
314                 }
315             }
316         }
317 
318         return brickIds;
319     }
320 
321     function getBrickIds(
322         uint _skip,
323         uint _take,
324         bytes32[] _tags, 
325         uint _status, 
326         uint _started, 
327         uint _expired
328         ) 
329         public view returns(uint[] brickIds) {
330 
331         address[] memory providers = getAllProviders();
332         uint[] memory temp;
333 
334         brickIds = new uint[](_take);
335         uint counter = 0; 
336         uint taken = 0;
337 
338         for (uint i = providers.length; i > 0; i--) {
339             if (taken >= _take) {
340                 break;
341             }
342 
343             Provider provider = Provider(providers[i-1]);
344             temp = provider.getBrickIds();
345             
346             for (uint j = 0; j < temp.length; j++) { 
347                 if (taken >= _take) {
348                     break;
349                 }
350                 
351                 bool exist = provider.filterBrick(temp[j], _tags, _status, _started, _expired);
352                 if(exist){
353                     if (counter >= _skip) { 
354                         brickIds[taken] = temp[j];                     
355                         taken++;
356                     }
357                     counter++;
358                 }
359             }
360         }
361 
362         return brickIds;
363     }
364 
365     function addBrick(string _title, string _url, uint _expired, string _description, bytes32[] _tags) 
366         public payable
367         returns (uint id)
368     {
369         id = getId();
370         require(getProvider(id).addBrick(id, _title, _url, _expired, _description, _tags, msg.value));
371         emit BrickAdded(id);
372     }
373 
374     function changeBrick(uint _brickId, string _title, string _url, string _description, bytes32[] _tags) 
375         public onlyBrickOwner(_brickId) payable
376         returns (bool success) 
377     {
378         success = getProvider(_brickId).changeBrick(_brickId, _title, _url, _description, _tags, msg.value);
379         emit BrickUpdated(_brickId);
380 
381         return success;
382     }
383 
384     // msg.value is tip.
385     function accept(uint _brickId, address[] _winners, uint[] _weights) 
386         public onlyBrickOwner(_brickId) 
387         payable
388         returns (bool success) 
389     {
390         uint total = getProvider(_brickId).accept(_brickId, _winners, _weights, msg.value);
391         require(total > 0);
392         for (uint i=0; i < _winners.length; i++) {
393             _winners[i].transfer(total.mul(_weights[i]).div(DENOMINATOR));    
394         }     
395 
396         emit WorkAccepted(_brickId, _winners);
397         return true;   
398     }
399 
400     function cancel(uint _brickId) 
401         public onlyBrickOwner(_brickId) 
402         returns (bool success) 
403     {
404         uint value = getProvider(_brickId).cancel(_brickId);
405         require(value > 0);
406 
407         msg.sender.transfer(value);  
408         emit BrickCancelled(_brickId);
409         return true;      
410     }    
411 
412     function startWork(uint _brickId, bytes32 _builderId, bytes32 _nickName) 
413         public returns(bool success)
414     {
415         success = getProvider(_brickId).startWork(_brickId, _builderId, _nickName, msg.sender);    
416         emit WorkStarted(_brickId, msg.sender);
417     }
418 
419     function getBrick(uint _brickId) public view returns (
420         string title,
421         string url,
422         address owner,
423         uint value,
424         uint dateCreated,
425         uint dateCompleted,
426         uint expired,
427         uint status
428     ) {
429         return getProvider(_brickId).getBrick(_brickId);
430     }
431 
432     function getBrickDetail(uint _brickId) public view returns (
433         bytes32[] tags,
434         string description,
435         uint32 builders,
436         address[] winners        
437     ) {
438         return getProvider(_brickId).getBrickDetail(_brickId);
439     }
440 
441     function getBrickBuilders(uint _brickId) public view returns (
442         address[] addresses,
443         uint[] dates,
444         bytes32[] keys,
445         bytes32[] names
446     )
447     {
448         return getProvider(_brickId).getBrickBuilders(_brickId);
449     }
450 
451     function getProvider(uint _brickId) private view returns (Provider) {
452         return Provider(getProviderById(_brickId));
453     }
454 
455     function getId() private returns (uint) {
456         return currentId++;
457     }      
458 }