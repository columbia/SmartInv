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
77 contract StrikersBaseInterface {
78 
79   struct Card {
80     uint32 mintTime;
81     uint8 checklistId;
82     uint16 serialNumber;
83   }
84 
85   Card[] public cards;
86 }
87 
88 contract StrikersMetadataIPFS is Ownable {
89 
90   string public ipfsGateway;
91   StrikersBaseInterface public strikersBaseContract;
92 
93   mapping(uint256 => string) internal starredCardURIs;
94   mapping(uint8 => string) internal checklistIdURIs;
95 
96   constructor(string _ipfsGateway, address _strikersBaseAddress) public {
97     ipfsGateway = _ipfsGateway;
98     strikersBaseContract = StrikersBaseInterface(_strikersBaseAddress);
99     setupStarredCardURIs();
100   }
101 
102   function setupStarredCardURIs() internal {
103     // ONE STAR HAZARD
104     starredCardURIs[1778] = "Qmd5DBGsaeScxxqrB7Xmi3abK24zqx4DnwY6CQRGBZSdqb";
105     starredCardURIs[8151] = "Qmd5DBGsaeScxxqrB7Xmi3abK24zqx4DnwY6CQRGBZSdqb";
106 
107     // ONE STAR MBAPPE
108     starredCardURIs[882] = "QmPzwhKZyhdie48xT6nFcW8CMkD9kz56NxbVM7RZsoMJEc";
109     starredCardURIs[2552] = "QmPzwhKZyhdie48xT6nFcW8CMkD9kz56NxbVM7RZsoMJEc";
110     starredCardURIs[3043] = "QmPzwhKZyhdie48xT6nFcW8CMkD9kz56NxbVM7RZsoMJEc";
111     starredCardURIs[4019] = "QmPzwhKZyhdie48xT6nFcW8CMkD9kz56NxbVM7RZsoMJEc";
112     starredCardURIs[4460] = "QmPzwhKZyhdie48xT6nFcW8CMkD9kz56NxbVM7RZsoMJEc";
113     starredCardURIs[5303] = "QmPzwhKZyhdie48xT6nFcW8CMkD9kz56NxbVM7RZsoMJEc";
114     starredCardURIs[7109] = "QmPzwhKZyhdie48xT6nFcW8CMkD9kz56NxbVM7RZsoMJEc";
115     starredCardURIs[8494] = "QmPzwhKZyhdie48xT6nFcW8CMkD9kz56NxbVM7RZsoMJEc";
116 
117     // ONE STAR GRIEZMANN
118     starredCardURIs[3448] = "Qmafj7ShBgibLoS8yrYBBD7KphwPZPCRq5jRtr6opz8NvV";
119     starredCardURIs[4455] = "Qmafj7ShBgibLoS8yrYBBD7KphwPZPCRq5jRtr6opz8NvV";
120     starredCardURIs[7366] = "Qmafj7ShBgibLoS8yrYBBD7KphwPZPCRq5jRtr6opz8NvV";
121     starredCardURIs[7619] = "Qmafj7ShBgibLoS8yrYBBD7KphwPZPCRq5jRtr6opz8NvV";
122 
123     // ONE STAR POGBA
124     starredCardURIs[5233] = "QmUXetpbGfBy2JuLowT9dtrcdQJ9GgcixgyddXWXo9EjD5";
125     starredCardURIs[8089] = "QmUXetpbGfBy2JuLowT9dtrcdQJ9GgcixgyddXWXo9EjD5";
126 
127     // ONE STAR COURTOIS
128     starredCardURIs[3224] = "QmfADUDxupVBQPbNR5yo5cRFKBHGQmSpMXnxtYTkTTZFfw";
129 
130     // ONE STAR LLORIS
131     starredCardURIs[7357] = "QmQvjcGXq2Kb2q2quXgrk6y7zr68cXQwre54vfiTNRM5xu";
132     starredCardURIs[7407] = "QmQvjcGXq2Kb2q2quXgrk6y7zr68cXQwre54vfiTNRM5xu";
133     starredCardURIs[7697] = "QmQvjcGXq2Kb2q2quXgrk6y7zr68cXQwre54vfiTNRM5xu";
134 
135     // ONE STAR ALLI
136     starredCardURIs[736] = "QmawJzdsP9EaxVxcQMkaHhKNPgesigiLdFvokUzh9ZzqF7";
137     starredCardURIs[5487] = "QmawJzdsP9EaxVxcQMkaHhKNPgesigiLdFvokUzh9ZzqF7";
138     starredCardURIs[7421] = "QmawJzdsP9EaxVxcQMkaHhKNPgesigiLdFvokUzh9ZzqF7";
139 
140     // ONE STAR VARANE
141     starredCardURIs[2867] = "QmdFxtcfi8qwww4NniFbMJuU7tTR4EDj79uLseVSZpSohJ";
142     starredCardURIs[6252] = "QmdFxtcfi8qwww4NniFbMJuU7tTR4EDj79uLseVSZpSohJ";
143 
144     // ONE STAR MANDZUKIC
145     starredCardURIs[6250] = "QmTYT3im5aVjCX8jVBDer8YJedD4Z5KEnJtbVPr32eEN3e";
146 
147     // TWO STAR MANDZUKIC
148     starredCardURIs[7794] = "Qmb89ETw9b1MRqRySxU8DxuQFBptiF1uN7wgkesWMwxAgF";
149   }
150 
151   function updateIpfsGateway(string _ipfsGateway) external onlyOwner {
152     ipfsGateway = _ipfsGateway;
153   }
154 
155   function updateStarredCardURI(uint256 _tokenId, string _uri) external onlyOwner {
156     starredCardURIs[_tokenId] = _uri;
157   }
158 
159   function checklistIdURI(uint8 _checklistId, string _uri) external onlyOwner {
160     checklistIdURIs[_checklistId] = _uri;
161   }
162 
163   function tokenURI(uint256 _tokenId) external view returns (string) {
164     string memory starredCardURI = starredCardURIs[_tokenId];
165     if (bytes(starredCardURI).length > 0) {
166       return strConcat(ipfsGateway, starredCardURI);
167     }
168 
169     uint8 checklistId;
170     (,checklistId,) = strikersBaseContract.cards(_tokenId);
171     return strConcat(ipfsGateway, checklistIdURIs[checklistId]);
172   }
173 
174   function strConcat(string _a, string _b) internal pure returns (string) {
175     bytes memory _ba = bytes(_a);
176     bytes memory _bb = bytes(_b);
177     string memory ab = new string(_ba.length + _bb.length);
178     bytes memory bab = bytes(ab);
179     uint k = 0;
180     for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
181     for (i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
182     return string(bab);
183   }
184 }