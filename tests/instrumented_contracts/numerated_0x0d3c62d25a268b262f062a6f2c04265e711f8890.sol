1 pragma solidity 0.4.25;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address private _owner;
10 
11   event OwnershipTransferred(
12     address indexed previousOwner,
13     address indexed newOwner
14   );
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor() internal {
21     _owner = msg.sender;
22     emit OwnershipTransferred(address(0), _owner);
23   }
24 
25   /**
26    * @return the address of the owner.
27    */
28   function owner() public view returns(address) {
29     return _owner;
30   }
31 
32   /**
33    * @dev Throws if called by any account other than the owner.
34    */
35   modifier onlyOwner() {
36     require(isOwner());
37     _;
38   }
39 
40   /**
41    * @return true if `msg.sender` is the owner of the contract.
42    */
43   function isOwner() public view returns(bool) {
44     return msg.sender == _owner;
45   }
46 
47   /**
48    * @dev Allows the current owner to relinquish control of the contract.
49    * @notice Renouncing to ownership will leave the contract without an owner.
50    * It will not be possible to call the functions with the `onlyOwner`
51    * modifier anymore.
52    */
53   function renounceOwnership() public onlyOwner {
54     emit OwnershipTransferred(_owner, address(0));
55     _owner = address(0);
56   }
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address newOwner) public onlyOwner {
63     _transferOwnership(newOwner);
64   }
65 
66   /**
67    * @dev Transfers control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function _transferOwnership(address newOwner) internal {
71     require(newOwner != address(0));
72     emit OwnershipTransferred(_owner, newOwner);
73     _owner = newOwner;
74   }
75 }
76 
77 /// @dev We need to be able to check a card's checklist ID, so use this interface instead of importing everything.
78 contract StrikersBaseInterface {
79 
80   struct Card {
81     uint32 mintTime;
82     uint8 checklistId;
83     uint16 serialNumber;
84   }
85 
86   Card[] public cards;
87 }
88 
89 /// @title An optional contract that allows us to associate metadata to our cards.
90 /// @author The CryptoStrikers Team
91 contract StrikersMetadataIPFS is Ownable {
92 
93   /// @dev The base url for an IPFS gateway
94   ///   ex: https://ipfs.infura.io/ipfs/
95   string public ipfsGateway;
96 
97   /// @dev A reference to the main CryptoStrikers contract
98   StrikersBaseInterface public strikersBaseContract;
99 
100   /// @dev Cards with stars have special metadata, which we access here using the relevant token id.
101   mapping(uint256 => string) internal starredCardURIs;
102 
103   /// @dev For the rest of the cards, we get their checklist id and access this mapping.
104   mapping(uint8 => string) internal checklistIdURIs;
105 
106   constructor(string _ipfsGateway, address _strikersBaseAddress) public {
107     ipfsGateway = _ipfsGateway;
108     strikersBaseContract = StrikersBaseInterface(_strikersBaseAddress);
109     setupURIs();
110   }
111 
112   /// @dev This isn't super expensive so just do it in the constructor.
113   function setupURIs() internal {
114     // ONE STAR HAZARD
115     starredCardURIs[1778] = "QmYr929yRFHUWqadAW6djKXaXjv9hzjxJyhgfNiTyQWw3a";
116     starredCardURIs[8151] = "QmYr929yRFHUWqadAW6djKXaXjv9hzjxJyhgfNiTyQWw3a";
117 
118     // ONE STAR MBAPPE
119     starredCardURIs[882] = "QmPvDZykYBw9iMBfHcSdLMruWirKUfcwsXfZ5mZwEFnG7X";
120     starredCardURIs[2552] = "QmPvDZykYBw9iMBfHcSdLMruWirKUfcwsXfZ5mZwEFnG7X";
121     starredCardURIs[3043] = "QmPvDZykYBw9iMBfHcSdLMruWirKUfcwsXfZ5mZwEFnG7X";
122     starredCardURIs[4019] = "QmPvDZykYBw9iMBfHcSdLMruWirKUfcwsXfZ5mZwEFnG7X";
123     starredCardURIs[4460] = "QmPvDZykYBw9iMBfHcSdLMruWirKUfcwsXfZ5mZwEFnG7X";
124     starredCardURIs[5303] = "QmPvDZykYBw9iMBfHcSdLMruWirKUfcwsXfZ5mZwEFnG7X";
125     starredCardURIs[7109] = "QmPvDZykYBw9iMBfHcSdLMruWirKUfcwsXfZ5mZwEFnG7X";
126     starredCardURIs[8494] = "QmPvDZykYBw9iMBfHcSdLMruWirKUfcwsXfZ5mZwEFnG7X";
127 
128     // ONE STAR GRIEZMANN
129     starredCardURIs[3448] = "QmXZmq6xs5MaoSZ6UPJ5MLKDeLK5rTWuwhjYvaeZJdMS77";
130     starredCardURIs[4455] = "QmXZmq6xs5MaoSZ6UPJ5MLKDeLK5rTWuwhjYvaeZJdMS77";
131     starredCardURIs[7366] = "QmXZmq6xs5MaoSZ6UPJ5MLKDeLK5rTWuwhjYvaeZJdMS77";
132     starredCardURIs[7619] = "QmXZmq6xs5MaoSZ6UPJ5MLKDeLK5rTWuwhjYvaeZJdMS77";
133 
134     // ONE STAR POGBA
135     starredCardURIs[5233] = "QmVDfxWGjLSomrcQz7JB2iZmsfNFpyVPQzJvkCbJc19iWu";
136     starredCardURIs[8089] = "QmVDfxWGjLSomrcQz7JB2iZmsfNFpyVPQzJvkCbJc19iWu";
137 
138     // ONE STAR COURTOIS
139     starredCardURIs[3224] = "QmXCJ53VF2nZdj1xpYaBo8BJyjdoo1ggVmCjt1cAWhd4ou";
140 
141     // ONE STAR LLORIS
142     starredCardURIs[7357] = "QmP5wADxxZJVrzkKj5e8S7HAtAGg6L1DHMAUp7tGCgiGxE";
143     starredCardURIs[7407] = "QmP5wADxxZJVrzkKj5e8S7HAtAGg6L1DHMAUp7tGCgiGxE";
144     starredCardURIs[7697] = "QmP5wADxxZJVrzkKj5e8S7HAtAGg6L1DHMAUp7tGCgiGxE";
145 
146     // ONE STAR ALLI
147     starredCardURIs[736] = "Qmc7w3D5C9xEp3LPTwGxwC3xUnAsQH22KDSdhLi5Bj7nYr";
148     starredCardURIs[5487] = "Qmc7w3D5C9xEp3LPTwGxwC3xUnAsQH22KDSdhLi5Bj7nYr";
149     starredCardURIs[7421] = "Qmc7w3D5C9xEp3LPTwGxwC3xUnAsQH22KDSdhLi5Bj7nYr";
150 
151     // ONE STAR VARANE
152     starredCardURIs[2867] = "QmecZq2xjqRPQfUQbGs2N4dp7NX1ftutVcp6vRK9FUMV4C";
153     starredCardURIs[6252] = "QmecZq2xjqRPQfUQbGs2N4dp7NX1ftutVcp6vRK9FUMV4C";
154 
155     // ONE STAR MANDZUKIC
156     starredCardURIs[6250] = "QmTyyYRJQhqVHAVCgvpMJgp5d67QDuLnkDZ24EnZBD2heF";
157 
158     // TWO STAR MANDZUKIC
159     starredCardURIs[7794] = "QmZFHQhcWenea4GwHsK2chF5x1rxyFDvnz3QhyPqLSRKc4";
160   }
161 
162   function updateIpfsGateway(string _ipfsGateway) external onlyOwner {
163     ipfsGateway = _ipfsGateway;
164   }
165 
166   function updateStarredCardURI(uint256 _tokenId, string _uri) external onlyOwner {
167     starredCardURIs[_tokenId] = _uri;
168   }
169 
170   function updateChecklistIdURI(uint8 _checklistId, string _uri) external onlyOwner {
171     checklistIdURIs[_checklistId] = _uri;
172   }
173 
174   /// @dev Returns the IPFS URL for a given token Id.
175   ///   ex: https://ipfs.infura.io/ipfs/QmP5wADxxZJVrzkKj5e8S7HAtAGg6L1DHMAUp7tGCgiGxE
176   ///   That URI points to a JSON blob conforming to OpenSea's spec.
177   ///   see: https://docs.opensea.io/docs/2-adding-metadata
178   function tokenURI(uint256 _tokenId) external view returns (string) {
179     string memory starredCardURI = starredCardURIs[_tokenId];
180     if (bytes(starredCardURI).length > 0) {
181       return strConcat(ipfsGateway, starredCardURI);
182     }
183 
184     uint8 checklistId;
185     (,checklistId,) = strikersBaseContract.cards(_tokenId);
186     return strConcat(ipfsGateway, checklistIdURIs[checklistId]);
187   }
188 
189   // String helper below was taken from Oraclize.
190   // https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.4.sol
191 
192   function strConcat(string _a, string _b) internal pure returns (string) {
193     bytes memory _ba = bytes(_a);
194     bytes memory _bb = bytes(_b);
195     string memory ab = new string(_ba.length + _bb.length);
196     bytes memory bab = bytes(ab);
197     uint k = 0;
198     for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
199     for (i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
200     return string(bab);
201   }
202 }