1 pragma solidity ^0.4.24;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    */
40   function renounceOwnership() public onlyOwner {
41     emit OwnershipRenounced(owner);
42     owner = address(0);
43   }
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param _newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address _newOwner) public onlyOwner {
50     _transferOwnership(_newOwner);
51   }
52 
53   /**
54    * @dev Transfers control of the contract to a newOwner.
55    * @param _newOwner The address to transfer ownership to.
56    */
57   function _transferOwnership(address _newOwner) internal {
58     require(_newOwner != address(0));
59     emit OwnershipTransferred(owner, _newOwner);
60     owner = _newOwner;
61   }
62 }
63 
64 // File: contracts/MTEpisodeManager.sol
65 
66 contract IMTArtefact {
67     uint public typesCount;
68 }
69 
70 contract TVToken {
71     function transfer(address _to, uint256 _value) public returns (bool);
72     function safeTransfer(address _to, uint256 _value, bytes _data) public;
73 }
74 
75 contract MTEpisodeManager is Ownable {
76     address public manager;
77     address public MTArtefactAddress;
78     uint[] public restTypes;
79     uint constant public artifactInEpisode = 5;
80     uint public restTypesLength;
81 
82     uint[] public comicsCollection;
83     uint public comicsCollectionBonus;
84     mapping(uint => Collection) public collections;
85 
86     struct Collection {
87         uint episodeNumber;
88         uint[] artefactsTypes;
89         uint comicsArtefactType;
90         uint bonusRewardType;
91         bool isFinal;
92         bool isDefined;
93     }
94 
95     modifier onlyOwnerOrManager() {
96         require(msg.sender == owner || manager == msg.sender);
97         _;
98     }
99 
100     event EpisodeStart(
101         uint number,
102         uint bonusType,
103         uint comicsArtefactType,
104         bool isFinal,
105         uint[] episodeArtefactTypes
106     );
107 
108     constructor(
109         address _manager,
110         address _MTArtefactAddress
111     ) public {
112         manager = _manager;
113         MTArtefactAddress = _MTArtefactAddress;
114         restTypesLength =  IMTArtefact(MTArtefactAddress).typesCount();
115         for (uint i = 0; i < restTypesLength; i++) {
116             restTypes.push(i + 1);
117         }
118     }
119 
120     function episodeStart(
121         uint number,
122         uint bonusType,
123         uint comicsArtefactType,
124         bool isFinal
125     ) public onlyOwnerOrManager {
126         collections[number] = Collection(
127             number,
128             new uint[](artifactInEpisode),
129             comicsArtefactType,
130             bonusType,
131             isFinal,
132             true
133         );
134         for (uint i = 0; i < artifactInEpisode; i++) {
135             uint randomTypeId = restTypes[getRandom(restTypesLength, i)];
136             collections[number].artefactsTypes[i] = randomTypeId;
137             removeRestType(randomTypeId);
138         }
139         emit EpisodeStart(number, bonusType, comicsArtefactType, isFinal, collections[number].artefactsTypes);
140     }
141 
142     function getArtefactOfCollectionByIndex(uint episodeNumber, uint index) public view returns(uint) {
143         return collections[episodeNumber].artefactsTypes[index];
144     }
145 
146     function removeRestType(uint typeId) internal {
147         for (uint i = 0; i < restTypesLength; i++) {
148             if (restTypes[i] == typeId) {
149                 restTypes[i] = restTypes[restTypesLength - 1];
150                 restTypesLength--;
151                 return;
152             }
153         }
154     }
155 
156     function setManager(address _manager) public onlyOwner {
157         manager = _manager;
158     }
159 
160     function getRandom(uint max, uint mix) internal view returns (uint random) {
161         random = bytesToUint(keccak256(abi.encodePacked(blockhash(block.number - 1), mix))) % max;
162     }
163 
164     function changeMTArtefactAddress(address newAddress) public onlyOwnerOrManager {
165         MTArtefactAddress = newAddress;
166     }
167 
168     function setComicsCollection(uint[] comicsArtefactIds, uint bonusTypeId) public onlyOwnerOrManager {
169         comicsCollection = comicsArtefactIds;
170         comicsCollectionBonus = bonusTypeId;
171     }
172 
173     function getComicsCollectionLength() public view returns(uint) {
174         return comicsCollection.length;
175     }
176 
177     function getComicsCollectionArtefactByIndex(uint index) public view returns(uint) {
178         return comicsCollection[index];
179     }
180 
181     function getCollectionBonusType(uint episodeNumber) public view returns(uint bonusType) {
182         bonusType = collections[episodeNumber].bonusRewardType;
183     }
184 
185     function isFinal(uint episodeNumber) public view returns(bool) {
186         return collections[episodeNumber].isFinal;
187     }
188 
189     function bytesToUint(bytes32 b) internal pure returns (uint number){
190         for (uint i = 0; i < b.length; i++) {
191             number = number + uint(b[i]) * (2 ** (8 * (b.length - (i + 1))));
192         }
193     }
194 }