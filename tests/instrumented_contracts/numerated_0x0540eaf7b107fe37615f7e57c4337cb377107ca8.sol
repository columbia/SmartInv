1 pragma solidity ^0.5.0;
2 
3 
4 interface IERC20 {
5     /**
6      * @dev Returns the amount of tokens in existence.
7      */
8     function totalSupply() external view returns (uint256);
9 
10     /**
11      * @dev Returns the amount of tokens owned by `account`.
12      */
13     function balanceOf(address account) external view returns (uint256);
14 
15     /**
16      * @dev Moves `amount` tokens from the caller's account to `recipient`.
17      *
18      * Returns a boolean value indicating whether the operation succeeded.
19      *
20      * Emits a {Transfer} event.
21      */
22     function transfer(address recipient, uint256 amount) external returns (bool);
23 
24     /**
25      * @dev Returns the remaining number of tokens that `spender` will be
26      * allowed to spend on behalf of `owner` through {transferFrom}. This is
27      * zero by default.
28      *
29      * This value changes when {approve} or {transferFrom} are called.
30      */
31     function allowance(address owner, address spender) external view returns (uint256);
32 
33     /**
34      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * IMPORTANT: Beware that changing an allowance with this method brings the risk
39      * that someone may use both the old and the new allowance by unfortunate
40      * transaction ordering. One possible solution to mitigate this race
41      * condition is to first reduce the spender's allowance to 0 and set the
42      * desired value afterwards:
43      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
44      *
45      * Emits an {Approval} event.
46      */
47     function approve(address spender, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Moves `amount` tokens from `sender` to `recipient` using the
51      * allowance mechanism. `amount` is then deducted from the caller's
52      * allowance.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * Emits a {Transfer} event.
57      */
58     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Emitted when `value` tokens are moved from one account (`from`) to
62      * another (`to`).
63      *
64      * Note that `value` may be zero.
65      */
66     event Transfer(address indexed from, address indexed to, uint256 value);
67 
68     /**
69      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
70      * a call to {approve}. `value` is the new allowance.
71      */
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 contract Context {
76     // Empty internal constructor, to prevent people from mistakenly deploying
77     // an instance of this contract, which should be used via inheritance.
78     constructor () internal { }
79     // solhint-disable-previous-line no-empty-blocks
80 
81     function _msgSender() internal view returns (address payable) {
82         return msg.sender;
83     }
84 
85     function _msgData() internal view returns (bytes memory) {
86         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
87         return msg.data;
88     }
89 }
90 
91 contract Ownable is Context {
92     address private _owner;
93 
94     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
95 
96     /**
97      * @dev Initializes the contract setting the deployer as the initial owner.
98      */
99     constructor () internal {
100         address msgSender = _msgSender();
101         _owner = msgSender;
102         emit OwnershipTransferred(address(0), msgSender);
103     }
104 
105     /**
106      * @dev Returns the address of the current owner.
107      */
108     function owner() public view returns (address) {
109         return _owner;
110     }
111 
112     /**
113      * @dev Throws if called by any account other than the owner.
114      */
115     modifier onlyOwner() {
116         require(isOwner(), "Ownable: caller is not the owner");
117         _;
118     }
119 
120     /**
121      * @dev Returns true if the caller is the current owner.
122      */
123     function isOwner() public view returns (bool) {
124         return _msgSender() == _owner;
125     }
126 
127     /**
128      * @dev Leaves the contract without owner. It will not be possible to call
129      * `onlyOwner` functions anymore. Can only be called by the current owner.
130      *
131      * NOTE: Renouncing ownership will leave the contract without an owner,
132      * thereby removing any functionality that is only available to the owner.
133      */
134     function renounceOwnership() public onlyOwner {
135         emit OwnershipTransferred(_owner, address(0));
136         _owner = address(0);
137     }
138 
139     /**
140      * @dev Transfers ownership of the contract to a new account (`newOwner`).
141      * Can only be called by the current owner.
142      */
143     function transferOwnership(address newOwner) public onlyOwner {
144         _transferOwnership(newOwner);
145     }
146 
147     /**
148      * @dev Transfers ownership of the contract to a new account (`newOwner`).
149      */
150     function _transferOwnership(address newOwner) internal {
151         require(newOwner != address(0), "Ownable: new owner is the zero address");
152         emit OwnershipTransferred(_owner, newOwner);
153         _owner = newOwner;
154     }
155 }
156 
157 contract MerkleAirdrop is Ownable {
158 
159     struct Airdrop {
160       bytes32 root;
161       string dataURI;
162       bool paused;
163       mapping(address => bool) awarded;
164     }
165 
166     /// Events
167     event Start(uint id);
168     event PauseChange(uint id, bool paused);
169     event Award(uint id, address recipient, uint amount);
170 
171     /// State
172     mapping(uint => Airdrop) public airdrops;
173     IERC20 public token;
174     address public approver;
175     uint public airdropsCount;
176 
177     // Errors
178     string private constant ERROR_AWARDED = "AWARDED";
179     string private constant ERROR_INVALID = "INVALID";
180     string private constant ERROR_PAUSED = "PAUSED";
181 
182     function setToken(address _token, address _approver) public onlyOwner {
183         token = IERC20(_token);
184         approver = _approver;
185     }
186 
187     /**
188      * @notice Start a new airdrop `_root` / `_dataURI`
189      * @param _root New airdrop merkle root
190      * @param _dataURI Data URI for airdrop data
191      */
192     function start(bytes32 _root, string memory _dataURI) public onlyOwner {
193         uint id = ++airdropsCount;    // start at 1
194         airdrops[id] = Airdrop(_root, _dataURI, false);
195         emit Start(id);
196     }
197 
198     /**
199      * @notice Pause or resume an airdrop `_id` / `_paused`
200      * @param _id The airdrop to change status
201      * @param _paused Pause to resume
202      */
203     function setPause(uint _id, bool _paused) public onlyOwner {
204         require(_id <= airdropsCount, ERROR_INVALID);
205         airdrops[_id].paused = _paused;
206         emit PauseChange(_id, _paused);
207     }
208 
209     /**
210      * @notice Award from airdrop
211      * @param _id Airdrop id
212      * @param _recipient Airdrop recipient
213      * @param _amount The token amount
214      * @param _proof Merkle proof to correspond to data supplied
215      */
216     function award(uint _id, address _recipient, uint256 _amount, bytes32[] memory _proof) public {
217         require( _id <= airdropsCount, ERROR_INVALID );
218 
219         Airdrop storage airdrop = airdrops[_id];
220         require( !airdrop.paused, ERROR_PAUSED );
221 
222         bytes32 hash = keccak256(abi.encodePacked(_recipient, _amount));
223         require( validate(airdrop.root, _proof, hash), ERROR_INVALID );
224 
225         require( !airdrops[_id].awarded[_recipient], ERROR_AWARDED );
226 
227         airdrops[_id].awarded[_recipient] = true;
228 
229         token.transferFrom(approver, _recipient, _amount);
230 
231         emit Award(_id, _recipient, _amount);
232     }
233 
234     /**
235      * @notice Award from airdrop
236      * @param _ids Airdrop ids
237      * @param _recipient Recepient of award
238      * @param _amounts The amounts
239      * @param _proofs Merkle proofs
240      * @param _proofLengths Merkle proof lengths
241      */
242     function awardFromMany(uint[] memory _ids, address _recipient, uint[] memory _amounts, bytes memory _proofs, uint[] memory _proofLengths) public {
243         uint totalAmount;
244 
245         uint marker = 32;
246 
247         for (uint i = 0; i < _ids.length; i++) {
248             uint id = _ids[i];
249             require( id <= airdropsCount, ERROR_INVALID );
250             require( !airdrops[id].paused, ERROR_PAUSED );
251 
252             bytes32[] memory proof = extractProof(_proofs, marker, _proofLengths[i]);
253             marker += _proofLengths[i]*32;
254 
255             bytes32 hash = keccak256(abi.encodePacked(_recipient, _amounts[i]));
256             require( validate(airdrops[id].root, proof, hash), ERROR_INVALID );
257 
258             require( !airdrops[id].awarded[_recipient], ERROR_AWARDED );
259 
260             airdrops[id].awarded[_recipient] = true;
261 
262             totalAmount += _amounts[i];
263 
264             emit Award(id, _recipient, _amounts[i]);
265         }
266 
267         token.transferFrom(approver, _recipient, totalAmount);
268     }
269 
270     function extractProof(bytes memory _proofs, uint _marker, uint proofLength) public pure returns (bytes32[] memory proof) {
271 
272         proof = new bytes32[](proofLength);
273 
274         bytes32 el;
275 
276         for (uint j = 0; j < proofLength; j++) {
277             assembly {
278                 el := mload(add(_proofs, _marker))
279             }
280             proof[j] = el;
281             _marker += 32;
282         }
283 
284     }
285 
286     function validate(bytes32 root, bytes32[] memory proof, bytes32 hash) public pure returns (bool) {
287 
288         for (uint i = 0; i < proof.length; i++) {
289             if (hash < proof[i]) {
290                 hash = keccak256(abi.encodePacked(hash, proof[i]));
291             } else {
292                 hash = keccak256(abi.encodePacked(proof[i], hash));
293             }
294         }
295 
296         return hash == root;
297     }
298 
299     /**
300      * @notice Check if recipient:`_recipient` awarded from airdrop:`_id`
301      * @param _id Airdrop id
302      * @param _recipient Recipient to check
303      */
304     function awarded(uint _id, address _recipient) public view returns(bool) {
305         return airdrops[_id].awarded[_recipient];
306     }
307 }