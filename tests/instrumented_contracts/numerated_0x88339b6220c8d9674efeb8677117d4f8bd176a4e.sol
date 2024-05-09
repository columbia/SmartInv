1 pragma solidity 0.4.24;
2 
3 contract Cryptopixel {
4 
5     // Name of token
6     string constant public name = "CryptoPixel";
7     // Symbol of Cryptopixel token
8   	string constant public symbol = "CPX";
9 
10 
11     using SafeMath for uint256;
12 
13     /////////////////////////
14     // Variables
15     /////////////////////////
16     // Total number of stored artworks
17     uint256 public totalSupply;
18     // Group of artwork - 52 is limit
19     address[limitChrt] internal artworkGroup;
20     // Number of total artworks
21     uint constant private limitChrt = 52;
22     // This is address of artwork creator
23     address constant private creatorAddr = 0x174B3C5f95c9F27Da6758C8Ca941b8FFbD01d330;
24 
25     
26     // Basic references
27     mapping(uint => address) internal tokenIdToOwner;
28     mapping(address => uint[]) internal listOfOwnerTokens;
29     mapping(uint => string) internal referencedMetadata;
30     
31     // Events
32     event Minted(address indexed _to, uint256 indexed _tokenId);
33 
34     // Modifier
35     modifier onlyNonexistentToken(uint _tokenId) {
36         require(tokenIdToOwner[_tokenId] == address(0));
37         _;
38     }
39 
40 
41     /////////////////////////
42     // Viewer Functions
43     /////////////////////////
44     // Get and returns the address currently marked as the owner of _tokenID. 
45     function ownerOf(uint256 _tokenId) public view returns (address _owner)
46     {
47         return tokenIdToOwner[_tokenId];
48     }
49     
50     // Get and return the total supply of token held by this contract. 
51     function totalSupply() public view returns (uint256 _totalSupply)
52     {
53         return totalSupply;
54     }
55     
56     //Get and return the balance of token held by _owner. 
57     function balanceOf(address _owner) public view returns (uint _balance)
58     {
59         return listOfOwnerTokens[_owner].length;
60     }
61 
62     // Get and returns a metadata of _tokenId
63     function tokenMetadata(uint _tokenId) public view returns (string _metadata)
64     {
65         return referencedMetadata[_tokenId];
66     }
67     
68     // Retrive artworkGroup
69     function getArtworkGroup() public view returns (address[limitChrt]) {
70         return artworkGroup;
71     }
72     
73     
74     /////////////////////////
75     // Update Functions
76     /////////////////////////
77     /**
78      * @dev Public function to mint a new token with metadata
79      * @dev Reverts if the given token ID already exists
80      * @param _owner The address that will own the minted token
81      * @param _tokenId uint256 ID of the token to be minted by the msg.sender(creator)
82      * @param _metadata string of meta data, IPFS hash
83      */
84     function mintWithMetadata(address _owner, uint256 _tokenId, string _metadata) public onlyNonexistentToken (_tokenId)
85     {
86         require(totalSupply < limitChrt);
87         require(creatorAddr == _owner);
88         
89         _setTokenOwner(_tokenId, _owner);
90         _addTokenToOwnersList(_owner, _tokenId);
91         _insertTokenMetadata(_tokenId, _metadata);
92 
93         artworkGroup[_tokenId] = _owner;
94         totalSupply = totalSupply.add(1);
95         emit Minted(_owner, _tokenId);
96     }
97 
98     /**
99      * @dev Public function to add created token id in group
100      * @param _owner The address that will own the minted token
101      * @param _tokenId uint256 ID of the token to be minted by the msg.sender(creator)
102      * @return _tokenId uint256 ID of the token 
103      */
104     function group(address _owner, uint _tokenId) public returns (uint) {
105         require(_tokenId >= 0 && _tokenId <= limitChrt);
106         artworkGroup[_tokenId] = _owner;    
107         return _tokenId;
108     }
109 
110     
111     /////////////////////////
112     // Internal, helper functions
113     /////////////////////////
114     function _setTokenOwner(uint _tokenId, address _owner) internal
115     {
116         tokenIdToOwner[_tokenId] = _owner;
117     }
118 
119     function _addTokenToOwnersList(address _owner, uint _tokenId) internal
120     {
121         listOfOwnerTokens[_owner].push(_tokenId);
122     }
123 
124     function _insertTokenMetadata(uint _tokenId, string _metadata) internal
125     {
126         referencedMetadata[_tokenId] = _metadata;
127     }
128     
129 }
130 
131 /**
132  * @title SafeMath
133  * @dev Math operations with safety checks that throw on error
134  */
135 library SafeMath {
136 
137   /**
138   * @dev Multiplies two numbers, throws on overflow.
139   */
140   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
141     if (a == 0) {
142       return 0;
143     }
144     c = a * b;
145     assert(c / a == b);
146     return c;
147   }
148 
149   /**
150   * @dev Integer division of two numbers, truncating the quotient.
151   */
152   function div(uint256 a, uint256 b) internal pure returns (uint256) {
153     // assert(b > 0); // Solidity automatically throws when dividing by 0
154     // uint256 c = a / b;
155     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
156     return a / b;
157   }
158 
159   /**
160   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
161   */
162   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
163     assert(b <= a);
164     return a - b;
165   }
166 
167   /**
168   * @dev Adds two numbers, throws on overflow.
169   */
170   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
171     c = a + b;
172     assert(c >= a);
173     return c;
174   }
175 }