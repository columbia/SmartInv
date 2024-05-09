1 pragma solidity 0.4.24;
2 
3 // File: contracts/FreeDnaCardRepositoryInterface.sol
4 
5 interface FreeDnaCardRepositoryInterface {
6     function airdrop(address to, uint256 animalId) external;
7 
8     function giveaway(
9         address to,
10         uint256 animalId,
11         uint8 effectiveness
12     )
13     external;
14 }
15 
16 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipRenounced(address indexed previousOwner);
28   event OwnershipTransferred(
29     address indexed previousOwner,
30     address indexed newOwner
31   );
32 
33 
34   /**
35    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36    * account.
37    */
38   constructor() public {
39     owner = msg.sender;
40   }
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50   /**
51    * @dev Allows the current owner to relinquish control of the contract.
52    * @notice Renouncing to ownership will leave the contract without an owner.
53    * It will not be possible to call the functions with the `onlyOwner`
54    * modifier anymore.
55    */
56   function renounceOwnership() public onlyOwner {
57     emit OwnershipRenounced(owner);
58     owner = address(0);
59   }
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param _newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address _newOwner) public onlyOwner {
66     _transferOwnership(_newOwner);
67   }
68 
69   /**
70    * @dev Transfers control of the contract to a newOwner.
71    * @param _newOwner The address to transfer ownership to.
72    */
73   function _transferOwnership(address _newOwner) internal {
74     require(_newOwner != address(0));
75     emit OwnershipTransferred(owner, _newOwner);
76     owner = _newOwner;
77   }
78 }
79 
80 // File: contracts/Restricted.sol
81 
82 contract Restricted is Ownable {
83     mapping(address => bool) private addressIsAdmin;
84     bool private isActive = true;
85 
86     modifier onlyAdmin() {
87         require(addressIsAdmin[msg.sender] || msg.sender == owner);
88         _;
89     }
90 
91     modifier contractIsActive() {
92         require(isActive);
93         _;
94     }
95 
96     function addAdmin(address adminAddress) public onlyOwner {
97         addressIsAdmin[adminAddress] = true;
98     }
99 
100     function removeAdmin(address adminAddress) public onlyOwner {
101         addressIsAdmin[adminAddress] = false;
102     }
103 
104     function pauseContract() public onlyOwner {
105         isActive = false;
106     }
107 
108     function activateContract() public onlyOwner {
109         isActive = true;
110     }
111 }
112 
113 // File: contracts/GameData.sol
114 
115 contract GameData {
116     struct Country {       
117         bytes2 isoCode;
118         uint8 animalsCount;
119         uint256[3] animalIds;
120     }
121 
122     struct Animal {
123         bool isSold;
124         uint256 currentValue;
125         uint8 rarity; // 0-4, rarity = stat range, higher rarity = better stats
126 
127         bytes32 name;         
128         uint256 countryId; // country of origin
129 
130     }
131 
132     struct Dna {
133         uint256 animalId; 
134         uint8 effectiveness; //  1 - 100, 100 = same stats as a wild card
135     }    
136 }
137 
138 // File: contracts/FreeDnaCardRepository.sol
139 
140 contract FreeDnaCardRepository is FreeDnaCardRepositoryInterface, GameData, Restricted {
141     event NewAirdrop(
142         address to,
143         uint256 animalId
144     );
145 
146     event NewGiveway(
147         address to,
148         uint256 animalId,
149         uint8 effectiveness
150     );
151 
152     uint8 private constant AIRDROP_EFFECTIVENESS = 10;
153 
154     uint256 private pendingGivewayCardCount;
155     uint256 private airdropEndTimestamp;
156 
157     mapping (address => uint256[]) private addressDnaIds;
158     mapping (address => bool) public addressIsDonator;
159 
160     Dna[] public dnas;
161 
162     constructor(
163         uint256 _pendingGivewayCardCount,
164         uint256 _airdropEndTimestamp
165     ) public {
166         pendingGivewayCardCount = _pendingGivewayCardCount;
167         airdropEndTimestamp = _airdropEndTimestamp;
168     }
169 
170     function addDonator(address donatorAddress) external onlyAdmin {
171         addressIsDonator[donatorAddress] = true;
172     }
173 
174     function deleteDonator(address donatorAddress) external onlyAdmin {
175         delete addressIsDonator[donatorAddress];
176     }
177 
178     function airdrop(address to, uint256 animalId) external contractIsActive {
179         require(now <= airdropEndTimestamp, "airdrop ended");
180         donateDna(to, animalId, AIRDROP_EFFECTIVENESS);
181         emit NewAirdrop(to, animalId);
182     }
183 
184     function giveaway(
185         address to,
186         uint256 animalId,
187         uint8 effectiveness
188     )
189     external
190     contractIsActive
191     {
192         require(pendingGivewayCardCount > 0);
193 
194         donateDna(to, animalId, effectiveness);
195         pendingGivewayCardCount--;
196         emit NewGiveway(to, animalId, effectiveness);
197     }
198 
199     function getAddressDnaIds(address owner) external view returns(uint256[])
200     {
201         return addressDnaIds[owner];
202     }
203 
204     function donateDna(
205         address to,
206         uint256 animalId,
207         uint8 effectiveness
208     )
209     private
210     contractIsActive
211     {
212         require(addressIsDonator[msg.sender], "donator not registered");
213 
214         uint256 id = dnas.length; // id is assigned before push
215         Dna memory dna = Dna(animalId, effectiveness);
216 
217         // Donate the card
218         dnas.push(dna);
219         addressDnaIds[to].push(id);
220     }
221 }