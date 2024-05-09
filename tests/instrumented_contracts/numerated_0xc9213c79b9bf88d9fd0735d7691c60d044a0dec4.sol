1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.12;
4 
5 interface callableNFT {
6     function transferFrom(address from, address to, uint256 tokenID) external;
7     function safeTransferFrom(address from, address to, uint256 tokenID) external;
8     function ownerOf(uint256 tokenId) external view returns (address);
9 }
10 
11 contract BMCMissionToMars {
12 
13     event OwnerUpdated(address indexed user, address indexed newOwner);
14 
15     callableNFT public og;
16     callableNFT public ultra;
17     callableNFT public droid;
18     callableNFT public alpha;
19     callableNFT public beta;
20     callableNFT public gamma;
21 
22     struct units {
23       uint256[] stakedOGs;
24       uint256[] stakedULTRAs;
25       uint256[] stakedDROIDs;
26       uint256[] stakedALPHAs;
27       uint256[] stakedBETAs;
28       uint256[] stakedGAMMAs;
29     }
30 
31     struct tokenData {
32         uint64 timestamp;
33         address realOwner;
34     }
35 
36     address public owner;
37     bool public depositPaused;
38     uint256 private locked = 1;
39     
40     mapping(address => units) private _staker;
41     mapping(address => mapping(uint256 => tokenData)) private _tokenData;
42 
43     constructor(address _og, address _ultra, address _droid) {
44         og = callableNFT(_og);
45         ultra = callableNFT(_ultra);
46         droid = callableNFT(_droid);
47 
48         owner = _msgSender();
49         emit OwnerUpdated(address(0), owner);
50         pauseDeposits(true);
51 
52     }
53 
54     modifier onlyOwner() {
55         require(_msgSender() == owner, "Non Owner");
56         _;
57     }
58 
59     modifier nonReentrant() {
60         require(locked == 1, "No Reentry");
61         locked = 2;
62         _;
63         locked = 1;
64     }
65 
66     function _msgSender() internal view returns (address) {
67         return msg.sender;
68     }
69 
70     function multiDeposit(address[] memory _contractAddresses, uint256 [][] memory tokenIDs) public nonReentrant {
71         require(!depositPaused, "Deposits Paused");
72         uint256 iterations = tokenIDs.length;
73         require(_contractAddresses.length == iterations && iterations > 0 && iterations < 7, "Invalid Parameters");
74 
75         for (uint256 i; i < iterations; ) {
76             _deposit(_contractAddresses[i], tokenIDs[i]);
77 
78             unchecked {
79                 ++i;
80             }
81         }
82 
83     }
84 
85     function multiWithdraw(address[] memory _contractAddresses, uint256 [][] memory tokenIDs) public nonReentrant {
86         uint256 iterations = tokenIDs.length;
87         require(_contractAddresses.length == iterations && iterations > 0 && iterations < 7, "Invalid Parameters");
88  
89         for (uint256 i; i < iterations; ) {
90             _withdraw(_contractAddresses[i], tokenIDs[i]);
91 
92             unchecked {
93                 ++i;
94             }
95         }
96 
97     }
98 
99     function _deposit(address _contractAddress, uint256[] memory tokenIds) internal {
100       require(isValidContract(_contractAddress), "Unknown contract");
101 
102       uint256 tokens = tokenIds.length;
103       require(tokens > 0, "No Tokens Passed");
104 
105       units storage currentAddress = _staker[_msgSender()];
106       callableNFT depositAddress = callableNFT(_contractAddress);
107       uint256 currentToken;
108 
109       for (uint256 i; i < tokens; ) {
110         currentToken = tokenIds[i++];
111 
112         require(depositAddress.ownerOf(currentToken) == _msgSender(), "Not the owner");
113         depositAddress.safeTransferFrom(_msgSender(), address(this), currentToken);
114         _tokenData[_contractAddress][currentToken].realOwner = _msgSender();
115         _tokenData[_contractAddress][currentToken].timestamp = uint64(block.timestamp);
116 
117         if (depositAddress == og) {
118             currentAddress.stakedOGs.push(currentToken);
119             continue;
120         }
121         if (depositAddress == ultra) { 
122             currentAddress.stakedULTRAs.push(currentToken);
123             continue;
124         }
125         if (depositAddress == droid) { 
126             currentAddress.stakedDROIDs.push(currentToken);
127             continue;
128         }
129         if (depositAddress == alpha) { 
130             currentAddress.stakedALPHAs.push(currentToken);
131             continue;
132         }
133         if (depositAddress == beta) { 
134             currentAddress.stakedBETAs.push(currentToken);
135             continue;
136         }
137         if (depositAddress == gamma) { 
138             currentAddress.stakedGAMMAs.push(currentToken);
139         }
140 
141       }
142 
143     }
144 
145     function _withdraw(address _contractAddress, uint256[] memory tokenIds) internal {
146       require(isValidContract(_contractAddress), "Unknown contract");
147       uint256 tokens = tokenIds.length;
148       require(tokens > 0, "No Tokens Passed");
149 
150       units storage currentAddress = _staker[_msgSender()];
151       callableNFT withdrawAddress = callableNFT(_contractAddress);
152       uint256 currentToken;
153 
154       for (uint256 i; i < tokens; ) {
155         currentToken = tokenIds[i++];  
156         require(withdrawAddress.ownerOf(currentToken) == address(this), "Contract Not Owner");//Ownership is checked in _OrganizeArrayEntries
157         delete _tokenData[_contractAddress][currentToken];
158 
159         if (withdrawAddress == og){
160           currentAddress.stakedOGs = _OrganizeArrayEntries(currentAddress.stakedOGs, currentToken);
161           currentAddress.stakedOGs.pop();
162           withdrawAddress.safeTransferFrom(address(this), _msgSender(), currentToken);
163           continue;
164         }
165         if (withdrawAddress == ultra){
166           currentAddress.stakedULTRAs = _OrganizeArrayEntries(currentAddress.stakedULTRAs, currentToken);
167           currentAddress.stakedULTRAs.pop();
168           withdrawAddress.safeTransferFrom(address(this), _msgSender(), currentToken);
169           continue;
170         }
171         if (withdrawAddress == droid){
172           currentAddress.stakedDROIDs = _OrganizeArrayEntries(currentAddress.stakedDROIDs, currentToken);
173           currentAddress.stakedDROIDs.pop();
174           withdrawAddress.safeTransferFrom(address(this), _msgSender(), currentToken);
175           continue;
176         }
177         if (withdrawAddress == alpha){
178           currentAddress.stakedALPHAs = _OrganizeArrayEntries(currentAddress.stakedALPHAs, currentToken);
179           currentAddress.stakedALPHAs.pop();
180           withdrawAddress.safeTransferFrom(address(this), _msgSender(), currentToken);
181           continue;
182         }
183         if (withdrawAddress == beta){
184           currentAddress.stakedBETAs = _OrganizeArrayEntries(currentAddress.stakedBETAs, currentToken);
185           currentAddress.stakedBETAs.pop();
186           withdrawAddress.safeTransferFrom(address(this), _msgSender(), currentToken);
187           continue;
188         }
189         if (withdrawAddress == gamma){
190           currentAddress.stakedGAMMAs = _OrganizeArrayEntries(currentAddress.stakedGAMMAs, currentToken);
191           currentAddress.stakedGAMMAs.pop();
192           withdrawAddress.safeTransferFrom(address(this), _msgSender(), currentToken);
193         }
194 
195       }
196 
197     }
198 
199     function isValidContract(address _contract) public view returns (bool) {
200         if (_contract == address (0)) return false;
201         callableNFT _callableContract = callableNFT(_contract);
202         
203         if (_callableContract == og || 
204             _callableContract == ultra ||
205             _callableContract == droid ||
206             _callableContract == alpha ||
207             _callableContract == beta ||
208             _callableContract == gamma) return true;
209 
210         return false;
211     }
212 
213     function _OrganizeArrayEntries(uint256[] memory _list, uint256 tokenId) internal pure returns (uint256[] memory) {
214       uint256 arrayIndex;
215       uint256 arrayLength = _list.length;
216       uint256 lastArrayIndex = arrayLength - 1;
217 
218       unchecked {
219       for(uint256 i; i < arrayLength; ) {
220         if (_list[i++] == tokenId) {
221           arrayIndex = i;
222           break;
223         }
224       }
225       
226       }//cannot overflow because array entries only added on successful deposit of token
227 
228       require(arrayIndex != 0, "Caller Not Token Owner");
229       unchecked {
230           arrayIndex--;
231       }//cannot underflow by prior logic
232       
233       if (arrayIndex != lastArrayIndex) {
234         _list[arrayIndex] = _list[lastArrayIndex];
235         _list[lastArrayIndex] = tokenId;
236       }
237 
238       return _list;
239     }
240 
241     function ownerOf(address _contractAddress, uint256 tokenId) public view returns (address) {
242       return _tokenData[_contractAddress][tokenId].realOwner;
243     }
244 
245     function timestampOf(address _contractAddress, uint256 tokenId) public view returns (uint256) {
246       return _tokenData[_contractAddress][tokenId].timestamp;
247     }
248 
249     function getStakedOGs(address _address) public view returns (uint256[] memory){
250       return _staker[_address].stakedOGs;
251     }
252 
253     function getStakedULTRAs(address _address) public view returns (uint256[] memory){
254       return _staker[_address].stakedULTRAs;
255     }
256 
257     function getStakedDROIDs(address _address) public view returns (uint256[] memory){
258       return _staker[_address].stakedDROIDs;
259     }
260 
261     function getStakedALPHAs(address _address) public view returns (uint256[] memory){
262       return _staker[_address].stakedALPHAs;
263     }
264 
265     function getStakedBETAs(address _address) public view returns (uint256[] memory){
266       return _staker[_address].stakedBETAs;
267     }
268 
269     function getStakedGAMMAs(address _address) public view returns (uint256[] memory){
270       return _staker[_address].stakedGAMMAs;
271     }
272 
273     function setOGContract(address _newAddress) public onlyOwner {
274       og = callableNFT(_newAddress);
275     }
276 
277     function setULTRAContract(address _newAddress) public onlyOwner {
278       ultra = callableNFT(_newAddress);
279     }
280 
281     function setDROIDContract(address _newAddress) public onlyOwner {
282       droid = callableNFT(_newAddress);
283     }
284 
285     function setALPHAContract(address _newAddress) public onlyOwner {
286       alpha = callableNFT(_newAddress);
287     }
288 
289     function setBETAContract(address _newAddress) public onlyOwner {
290       beta = callableNFT(_newAddress);
291     }
292 
293     function setGAMMAContract(address _newAddress) public onlyOwner {
294       gamma = callableNFT(_newAddress);
295     }
296 
297     function pauseDeposits(bool _state) public onlyOwner {
298       depositPaused = _state;
299     }
300 
301     /**
302     * @dev Allows BMC team to emergency eject NFTs if theres an issue.
303     */
304     function emergencyWithdraw(address _contractAddress, uint256[] memory tokenIds) public onlyOwner {
305       pauseDeposits(true);
306       uint256 tokens = tokenIds.length;//save mLOADs
307       callableNFT withdrawAddress = callableNFT(_contractAddress);
308       uint256 currentToken;
309     
310       for (uint256 i; i < tokens; ) {
311         currentToken = tokenIds[i++];
312         address receiver = _tokenData[_contractAddress][currentToken].realOwner;
313         if (receiver != address(0) && withdrawAddress.ownerOf(currentToken) == address(this)) {
314           withdrawAddress.transferFrom(address(this), receiver, currentToken);
315           delete _tokenData[_contractAddress][currentToken];
316           
317         }
318 
319       }
320 
321     }
322 
323     /**
324     * @dev Needed for safeTransferFrom interface
325     */
326     function onERC721Received(address, address, uint256, bytes calldata) external pure returns(bytes4){
327       return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
328     }
329 
330 }