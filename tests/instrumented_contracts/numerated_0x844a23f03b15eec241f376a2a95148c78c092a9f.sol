1 pragma solidity >=0.4.22 <0.6.0;
2 
3 
4 //-----------------------------------------------------------------------------
5 /// @title Ownable
6 /// @dev The Ownable contract has an owner address, and provides basic 
7 ///  authorization control functions, this simplifies the implementation of
8 ///  "user permissions".
9 //-----------------------------------------------------------------------------
10 contract Ownable {
11     //-------------------------------------------------------------------------
12     /// @dev Emits when owner address changes by any mechanism.
13     //-------------------------------------------------------------------------
14     event OwnershipTransfer (address previousOwner, address newOwner);
15     
16     // Wallet address that can sucessfully execute onlyOwner functions
17     address owner;
18     
19     //-------------------------------------------------------------------------
20     /// @dev Sets the owner of the contract to the sender account.
21     //-------------------------------------------------------------------------
22     constructor() public {
23         owner = msg.sender;
24     }
25 
26     //-------------------------------------------------------------------------
27     /// @dev Throws if called by any account other than `owner`.
28     //-------------------------------------------------------------------------
29     modifier onlyOwner() {
30         require (msg.sender == owner);
31         _;
32     }
33 
34     //-------------------------------------------------------------------------
35     /// @notice Transfer control of the contract to a newOwner.
36     /// @dev Throws if `_newOwner` is zero address.
37     /// @param _newOwner The address to transfer ownership to.
38     //-------------------------------------------------------------------------
39     function transferOwnership(address _newOwner) public onlyOwner {
40         // for safety, new owner parameter must not be 0
41         require (_newOwner != address(0));
42         // define local variable for old owner
43         address oldOwner = owner;
44         // set owner to new owner
45         owner = _newOwner;
46         // emit ownership transfer event
47         emit OwnershipTransfer(oldOwner, _newOwner);
48     }
49 }
50 
51 
52 //-----------------------------------------------------------------------------
53 ///@title VIP-180 interface
54 //-----------------------------------------------------------------------------
55 interface VIP180 {
56     function transfer (
57         address to, 
58         uint tokens
59     ) external returns (bool success);
60 
61     function transferFrom (
62         address from, 
63         address to, 
64         uint tokens
65     ) external returns (bool success);
66 }
67 
68 
69 interface LockedTokenManager {    
70     function lockFrom(
71         address _tokenHolder, 
72         address _tokenAddress, 
73         uint _tokens, 
74         uint _numberOfMonths
75     ) external returns(bool);
76     
77     function transferFromAndLock(
78         address _from,
79         address _to,
80         address _tokenAddress,
81         uint _tokens,
82         uint _numberOfMonths
83     ) external returns (bool);
84 }
85 
86 
87 interface LinkDependency {
88     function onLink(uint _oldUid, uint _newUid) external;
89 }
90 
91 
92 interface AacInterface {
93     function ownerOf(uint _tokenId) external returns(address);
94     function getApproved(uint256 _tokenId) external view returns (address);
95     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
96     function checkExists(uint _tokenId) external view returns(bool);
97     
98     function mint() external;
99     function mintAndSend(address payable _to) external;
100     function link(bytes7 _newUid, uint _aacId, bytes calldata _data) external;
101     function linkExternalNft(uint _aacUid, address _externalAddress, uint _externalId) external;
102 }
103 
104 
105 contract SegmentedTransfer is Ownable {
106     uint public percentageBurned = 50;
107     uint public percentageLocked = 0;
108     uint public percentageTransferredThenLocked = 0;
109     uint public lockMonths = 24;
110     // Lock contract to interface with
111     LockedTokenManager public lockContract;
112 
113     //-------------------------------------------------------------------------
114     /// @dev Throws if parameter is zero
115     //-------------------------------------------------------------------------
116     modifier notZero(uint _param) {
117         require(_param != 0);
118         _;
119     }
120     
121     function setLockContract(address _lockAddress) external onlyOwner {
122         lockContract = LockedTokenManager(_lockAddress);
123     }
124     
125     //-------------------------------------------------------------------------
126     /// @notice Set percentages of tokens to burn, lock, transferLock.
127     /// @dev Throws if the sender is not the contract owner. Throws if sum of
128     ///  new amounts is greater than 100.
129     /// @param _burned The new percentage to burn.
130     /// @param _locked The new percentage to lock.
131     /// @param _transferLocked The new percentage to transfer then lock.
132     //-------------------------------------------------------------------------
133     function setPercentages(uint _burned, uint _locked, uint _transferLocked, uint _lockMonths) 
134         external 
135         onlyOwner
136     {
137         require (_burned + _locked + _transferLocked <= 100);
138         percentageBurned = _burned;
139         percentageLocked = _locked;
140         percentageTransferredThenLocked = _transferLocked;
141         lockMonths = _lockMonths;
142     }
143     
144     //-------------------------------------------------------------------------
145     /// @notice (1)Burn (2)Lock (3)TransferThenLock (4)Transfer
146     //-------------------------------------------------------------------------
147     function segmentedTransfer(
148         address _tokenContractAddress, 
149         uint _totalTokens
150     ) internal {
151         uint tokensLeft = _totalTokens;
152         uint amount;
153         // burn
154         if (percentageBurned > 0) {
155             amount = _totalTokens * percentageBurned / 100;
156             VIP180(_tokenContractAddress).transferFrom(msg.sender, address(0), amount);
157             tokensLeft -= amount;
158         }
159         // Lock
160         if (percentageLocked > 0) {
161             amount = _totalTokens * percentageLocked / 100;
162             lockContract.lockFrom(msg.sender, _tokenContractAddress, lockMonths, amount);
163             tokensLeft -= amount;
164         }
165         // Transfer Then Lock
166         if (percentageTransferredThenLocked > 0) {
167             amount = _totalTokens * percentageTransferredThenLocked / 100;
168             lockContract.transferFromAndLock(msg.sender, address(this), _tokenContractAddress, lockMonths, amount);
169             tokensLeft -= amount;
170         }
171         // Transfer
172         if (tokensLeft > 0) {
173             VIP180(_tokenContractAddress).transferFrom(msg.sender, owner, tokensLeft);
174         }
175     }   
176 }
177 
178 
179 contract AacCreation is SegmentedTransfer {
180     
181     // EHrTs needed to mint one AAC
182     uint public priceToMint;
183     
184     // UID value is 7 bytes. Max value is 2**56 - 1
185     uint constant UID_MAX = 0xFFFFFFFFFFFFFF;
186     
187     // EHrT Contract address.
188     address public ehrtContractAddress;
189     
190     LinkDependency public coloredEhrtContract;
191     LinkDependency public externalTokensContract;
192     
193     AacInterface public aacContract;
194     
195     
196     
197     // Whitelist of addresses allowed to link AACs to RFID tags
198     mapping (address => bool) public allowedToLink;
199     
200     
201     //-------------------------------------------------------------------------
202     /// @dev Throws if called by any account other than token owner, approved
203     ///  address, or authorized operator.
204     //-------------------------------------------------------------------------
205     modifier canOperate(uint _uid) {
206         // sender must be owner of AAC #uid, or sender must be the
207         //  approved address of AAC #uid, or an authorized operator for
208         //  AAC owner
209         address owner = aacContract.ownerOf(_uid);
210         require (
211             msg.sender == owner ||
212             msg.sender == aacContract.getApproved(_uid) ||
213             aacContract.isApprovedForAll(owner, msg.sender),
214             "Not authorized to operate for this AAC"
215         );
216         _;
217     }
218     
219     //-------------------------------------------------------------------------
220     /// @notice Update AAC contract with new contract address.
221     /// @param _newAddress Updated contract address.
222     //-------------------------------------------------------------------------
223     function updateAacContract(address _newAddress) external onlyOwner {
224         aacContract = AacInterface(_newAddress);
225     }
226 
227     //-------------------------------------------------------------------------
228     /// @notice Update EHrT address variable with new contract address.
229     /// @dev Throws if `_newAddress` is the zero address.
230     /// @param _newAddress Updated contract address.
231     //-------------------------------------------------------------------------
232     function updateEhrtContractAddress(address _newAddress) external onlyOwner {
233         ehrtContractAddress = _newAddress;
234     }
235     
236     //-------------------------------------------------------------------------
237     /// @notice Update Colored EHrT contract with new contract address.
238     /// @dev Throws if `_newAddress` is the zero address.
239     /// @param _newAddress Updated contract address.
240     //-------------------------------------------------------------------------
241     function updateColoredEhrtContractAddress(address _newAddress) external onlyOwner {
242         coloredEhrtContract = LinkDependency(_newAddress);
243     }
244     
245     //-------------------------------------------------------------------------
246     /// @notice Update Colored EHrT contract with new contract address.
247     /// @dev Throws if `_newAddress` is the zero address.
248     /// @param _newAddress Updated contract address.
249     //-------------------------------------------------------------------------
250     function updateExternalTokensContractAddress(address _newAddress) external onlyOwner {
251         externalTokensContract = LinkDependency(_newAddress);
252     }
253 
254     //-------------------------------------------------------------------------
255     /// @notice Change the number of EHrT needed to mint a new AAC
256     /// @dev Throws if `_newPrice` is zero.
257     /// @param _newPrice The new price to mint (in pWei)
258     //-------------------------------------------------------------------------
259     function changeAacPrice(uint _newPrice) external onlyOwner {
260         priceToMint = _newPrice;
261     }
262 
263     //-------------------------------------------------------------------------
264     /// @notice Allow or ban an address from linking AACs
265     /// @dev Throws if sender is not contract owner
266     /// @param _linker The address to whitelist
267     //-------------------------------------------------------------------------
268     function whitelistLinker(address _linker, bool _isAllowed) external onlyOwner {
269         allowedToLink[_linker] = _isAllowed;
270     }
271     
272     //-------------------------------------------------------------------------
273     /// @notice Transfer EHrTs to mint a new empty AAC for yourself.
274     /// @dev Sender must have approved this contract address as an authorized
275     ///  spender with at least "priceToMint" EHrTs. Throws if the sender has
276     ///  insufficient balance. Throws if sender has not granted this contract's
277     ///  address sufficient allowance.
278     //-------------------------------------------------------------------------
279     function mint() external {
280         segmentedTransfer(ehrtContractAddress, priceToMint);
281 
282         aacContract.mintAndSend(msg.sender);
283     }
284 
285     //-------------------------------------------------------------------------
286     /// @notice Transfer EHrTs to mint a new empty AAC for '_to'.
287     /// @dev Sender must have approved this contract address as an authorized
288     ///  spender with at least "priceToMint" tokens. Throws if the sender has
289     ///  insufficient balance. Throws if sender has not granted this contract's
290     ///  address sufficient allowance.
291     /// @param _to The address to deduct EHrTs from and send new AAC to.
292     //-------------------------------------------------------------------------
293     function mintAndSend(address payable _to) external {
294         segmentedTransfer(ehrtContractAddress, priceToMint);
295         
296         aacContract.mintAndSend(_to);
297     }
298 
299     //-------------------------------------------------------------------------
300     /// @notice Change AAC #`_aacId` to AAC #`_newUid`. Writes any
301     ///  data passed through '_data' into the AAC's public data.
302     /// @dev Throws if AAC #`_aacId` does not exist. Throws if sender is
303     ///  not approved to operate for AAC. Throws if '_aacId' is smaller
304     ///  than 8 bytes. Throws if '_newUid' is bigger than 7 bytes. Throws if 
305     ///  '_newUid' is zero. Throws if '_newUid' is already taken.
306     /// @param _newUid The UID of the RFID chip to link to the AAC
307     /// @param _aacId The UID of the empty AAC to link
308     /// @param _data A byte string of data to attach to the AAC
309     //-------------------------------------------------------------------------
310     function link(
311         bytes7 _newUid, 
312         uint _currentUid, 
313         bytes calldata _data
314     ) external canOperate(_currentUid) {
315         require (allowedToLink[msg.sender]);
316         //Aac storage aac = aacArray[uidToAacIndex[_aacId]];
317         // _aacId must be an empty AAC
318         require (_currentUid > UID_MAX);
319         // _newUid field cannot be empty or greater than 7 bytes
320         require (_newUid > 0 && uint56(_newUid) < UID_MAX);
321         // an AAC with the new UID must not currently exist
322         require (aacContract.checkExists(_currentUid) == false);
323         
324         aacContract.link(_newUid, _currentUid, _data);
325         
326         coloredEhrtContract.onLink(_currentUid, uint(uint56(_newUid)));
327         externalTokensContract.onLink(_currentUid, uint(uint56(_newUid)));
328     }
329 }