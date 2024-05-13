1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 
4 // ============ Internal Imports ============
5 import {EventAccountant} from "./EventAccountant.sol";
6 // ============ External Imports ============
7 import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
8 import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
9 import {ERC721Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
10 import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
11 
12 contract NFTAccountant is
13     EventAccountant,
14     ERC721Upgradeable,
15     OwnableUpgradeable
16 {
17     /// No asset had 2**96 stolen, so we can pack nicely here :)
18     struct Record {
19         address asset;
20         uint96 amount;
21         address originalUser;
22         uint96 recovered;
23     }
24 
25     /// @notice next NFT ID
26     uint256 public nextID;
27     /// @notice maps NFT ID to NFT details
28     mapping(uint256 => Record) public records;
29     /// @notice token address => amount minted
30     mapping(address => uint256) public totalMinted;
31 
32     // ============ Upgrade Gap ============
33 
34     // gap for upgrade safety
35     uint256[47] private __GAP;
36 
37     /**
38      * @notice emitted when tokens would have been transferred, but the asset
39      *         was in the affected assets list
40      * @param id The token ID of the NFT minted
41      * @param asset The address of the affected token contract
42      * @param recipient The intended recipient of the tokens; the recipient in the
43      *                  transfer message
44      * @param amount The amount of tokens that would have been received
45      */
46     event ProcessFailure(
47         uint256 indexed id,
48         address indexed asset,
49         address indexed recipient,
50         uint256 amount
51     );
52 
53     /// ============ Constructor ============
54     constructor(address _bridgeRouter) EventAccountant(_bridgeRouter) {}
55 
56     function initialize() public initializer {
57         __EventAccountant_init();
58         __ERC721_init("Nomad NFT", "noNFT");
59         _setBaseURI("https://nft.nomad.xyz/");
60         __Ownable_init();
61     }
62 
63     /**
64      * @notice Records information to state and logs a ProcessFailure event
65      * @param _asset  The asset
66      * @param _user   The recipient
67      * @param _amount The amount
68      */
69     function _record(
70         address _asset,
71         address _user,
72         uint256 _amount
73     ) internal override {
74         // mint the NFT
75         uint256 _id = nextID;
76         nextID = _id + 1;
77         _safeMint(_user, _id);
78         records[_id].asset = _asset;
79         records[_id].amount = uint96(_amount);
80         records[_id].originalUser = _user;
81         // setting recovered is skipped, as it starts at 0
82         // increment totalMinted
83         totalMinted[_asset] += _amount;
84         // ensure we mint at most the totalAffected amount
85         // note: this also implicitly ensures that _asset is one of the affected assets
86         require(totalMinted[_asset] <= totalAffected[_asset], "overmint");
87         // emit event
88         emit ProcessFailure(_id, _asset, _user, _amount);
89     }
90 
91     /**
92      * @notice Override to disable transfers
93      */
94     function transferFrom(
95         address, /*from*/
96         address, /*to*/
97         uint256 /*tokenId*/
98     ) public virtual override {
99         _noTransfers();
100     }
101 
102     /**
103      * @notice Override to disable transfers
104      */
105     function safeTransferFrom(
106         address, /*from*/
107         address, /*to*/
108         uint256 /*tokenId*/
109     ) public virtual override {
110         _noTransfers();
111     }
112 
113     /**
114      * @notice Override to disable transfers
115      */
116     function safeTransferFrom(
117         address, /*from*/
118         address, /*to*/
119         uint256, /*tokenId*/
120         bytes memory /*data*/
121     ) public virtual override {
122         _noTransfers();
123     }
124 
125     /**
126      * @notice Revert with the same error message on any attempted transfers
127      */
128     function _noTransfers() internal pure {
129         revert("no transfers");
130     }
131 }
132 
133 /// @title NFTRecoveryAccountant
134 abstract contract NFTRecoveryAccountant is NFTAccountant {
135     using SafeERC20 for IERC20;
136 
137     /// @notice the address that receives funds
138     /// that should not have been transferred to the contract
139     address public immutable fundsRecipient;
140 
141     /// @notice token address => total amount collected
142     mapping(address => uint256) public totalCollected;
143     /// @notice token address => total amount recovered to users
144     mapping(address => uint256) public totalRecovered;
145 
146     // ============ Upgrade Gap ============
147 
148     // gap for upgrade safety
149     uint256[48] private __GAP;
150 
151     /**
152      * @notice A recovery event.
153      * @param id The tokenId recovering funds
154      * @param asset The asset being transferred
155      * @param recipient The user receiving the asset
156      * @param amount The amount transferred to the user
157      */
158     event Recovery(
159         uint256 indexed id,
160         address indexed asset,
161         address indexed recipient,
162         uint256 amount
163     );
164 
165     /// ============ Constructor ============
166     constructor(address _bridgeRouter, address _fundsRecipient)
167         NFTAccountant(_bridgeRouter)
168     {
169         fundsRecipient = _fundsRecipient;
170     }
171 
172     /**
173      * @notice Return all pertinent state information for an asset in a single RPC call for convenience
174      * @return _totalAffected total amount of tokens affected
175      * @return _totalMinted total amount minted in NFTs from unbridging this
176      *         asset
177      * @return _totalCollected lifetime total amount of this asset that has
178      *         passed through the account
179      * @return _totalRecovered total amount of this asset recovered by users
180      */
181     function assetInfo(address _asset)
182         external
183         view
184         returns (
185             uint256 _totalAffected,
186             uint256 _totalMinted,
187             uint256 _totalCollected,
188             uint256 _totalRecovered
189         )
190     {
191         _totalAffected = totalAffected[_asset];
192         _totalMinted = totalMinted[_asset];
193         _totalCollected = totalCollected[_asset];
194         _totalRecovered = totalRecovered[_asset];
195     }
196 
197     /**
198      * @notice Remove funds that should not have been transferred to this contract
199      */
200     function remove(address _asset, uint256 _amount) external onlyOwner {
201         IERC20(_asset).safeTransfer(fundsRecipient, _amount);
202         require(
203             IERC20(_asset).balanceOf(address(this)) >=
204                 totalCollected[_asset] - totalRecovered[_asset],
205             "!remove amount"
206         );
207     }
208 
209     /**
210      * @notice Collect funds to be recovered by users
211      * @param _handler address handling tokens
212      * @param _asset token to make available to recover
213      * @param _amount amount to make available to recover
214      * @dev Prior to the contract owner calling this method,
215      * the _handler must Approve this contract to spend _amount
216      */
217     function collect(
218         address _handler,
219         address _asset,
220         uint256 _amount
221     ) external onlyOwner {
222         // transfer tokens from holder to this contract
223         IERC20(_asset).safeTransferFrom(_handler, address(this), _amount);
224         // increment totalCollected
225         totalCollected[_asset] += _amount;
226     }
227 
228     /**
229      * @notice The current total amount of funds that can be recovered by a
230      *         tokenId
231      */
232     function recoverable(uint256 _id) public view returns (uint256) {
233         require(_exists(_id), "recoverable: nonexistent token");
234         Record memory _rec = records[_id];
235         return _recoverable(_rec);
236     }
237 
238     /**
239      * @notice Recover the available funds
240      */
241     function _recover(uint256 _id) internal {
242         address _user = ownerOf(_id);
243         require(_user == msg.sender, "only NFT holder can recover");
244         // calculate the amount to be recovered
245         Record memory _rec = records[_id];
246         uint256 _amount = _recoverable(_rec);
247         require(_amount != 0, "currently fully recovered");
248         // increment the asset's totalRecovered and the NFT's recovered field
249         address _asset = _rec.asset;
250         totalRecovered[_asset] += _amount;
251         records[_id].recovered += uint96(_amount);
252         // emit event
253         emit Recovery(_id, _asset, _user, _amount);
254         // transfer the asset to user
255         IERC20(_asset).safeTransfer(_user, _amount);
256     }
257 
258     /**
259      * @notice The current total amount of funds recoverable for a tokenId
260      */
261     function _recoverable(Record memory _rec) internal view returns (uint256) {
262         uint256 _totalRecoverable = (totalCollected[_rec.asset] *
263             uint256(_rec.amount)) / totalAffected[_rec.asset];
264         // ensure subtraction does not underflow
265         if (_totalRecoverable < uint256(_rec.recovered)) return 0;
266         // return total recoverable amount minus amount already recovered
267         return _totalRecoverable - uint256(_rec.recovered);
268     }
269 }
270 
271 /// @title AllowListRecoveryAccountant
272 contract AllowListNFTRecoveryAccountant is NFTRecoveryAccountant {
273     /// @notice Maps address to allowed status
274     mapping(address => bool) public allowList;
275 
276     // ============ Upgrade Gap ============
277 
278     // gap for upgrade safety
279     uint256[49] private __GAP;
280 
281     constructor(address _bridgeRouter, address _fundsRecipient)
282         NFTRecoveryAccountant(_bridgeRouter, _fundsRecipient)
283     {}
284 
285     /**
286      * @notice Requires that `msg.sender` is on the allowList
287      */
288     modifier onlyAllowed() {
289         require(allowList[msg.sender], "not allowed");
290         _;
291     }
292 
293     /**
294      * @notice Recover available funds for the NFT
295      */
296     function recover(uint256 _id) external onlyAllowed {
297         _recover(_id);
298     }
299 
300     /**
301      * @notice Adds addresses to the allow list
302      * @param _who A list of addresses to allow
303      */
304     function allow(address[] calldata _who) external onlyOwner {
305         for (uint256 i = 0; i < _who.length; i++) {
306             allowList[_who[i]] = true;
307         }
308     }
309 
310     /**
311      * @notice Removes addresses from the allow list
312      * @param _who A list of addresses to disallow
313      */
314     function disallow(address[] calldata _who) external onlyOwner {
315         for (uint256 i = 0; i < _who.length; i++) {
316             allowList[_who[i]] = false;
317         }
318     }
319 
320     /**
321      * @notice Return all pertinent state information for a tokenId in a single
322      *         RPC call for convenience
323      * @return _holder address of the current token holder
324      * @return _isAllowed TRUE if the current token holder is set on the
325      *         allowlist & can therefore call recovery
326      * @return _uri the tokenURI for the NFT
327      * @return _asset address of the ERC20 asset for this NFT
328      * @return _originalAmount amount of the bridge transfer which minted this
329      *         NFT
330      * @return _originalUser original recipient of the NFT
331      * @return _recovered total amount recovered thus far from this NFT
332      * @return _recoverable current amount recoverable for this NFT
333      */
334     function info(uint256 _id)
335         external
336         view
337         returns (
338             address _holder,
339             bool _isAllowed,
340             string memory _uri,
341             address _asset,
342             uint256 _originalAmount,
343             address _originalUser,
344             uint256 _recovered,
345             uint256 _recoverable
346         )
347     {
348         _holder = ownerOf(_id);
349         _isAllowed = allowList[_holder];
350         _uri = tokenURI(_id);
351         Record memory _rec = records[_id];
352         _asset = _rec.asset;
353         _originalAmount = uint256(_rec.amount);
354         _originalUser = _rec.originalUser;
355         _recovered = uint256(_rec.recovered);
356         _recoverable = recoverable(_id);
357     }
358 }
