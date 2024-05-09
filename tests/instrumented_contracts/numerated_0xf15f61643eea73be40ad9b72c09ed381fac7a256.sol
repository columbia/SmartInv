1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address public owner;
11 
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16     /**
17      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18      * account.
19      */
20     function Ownable() public {
21         owner = msg.sender;
22     }
23 
24 
25     /**
26      * @dev Throws if called by any account other than the owner.
27      */
28     modifier onlyOwner() {
29         require(msg.sender == owner);
30         _;
31     }
32 
33 
34     /**
35      * @dev Allows the current owner to transfer control of the contract to a newOwner.
36      * @param newOwner The address to transfer ownership to.
37      */
38     function transferOwnership(address newOwner) public onlyOwner {
39         require(newOwner != address(0));
40         OwnershipTransferred(owner, newOwner);
41         owner = newOwner;
42     }
43 
44 }
45 
46 
47 
48 
49 contract FishbankBoosters is Ownable {
50 
51     struct Booster {
52         address owner;
53         uint32 duration;
54         uint8 boosterType;
55         uint24 raiseValue;
56         uint8 strength;
57         uint32 amount;
58     }
59 
60     Booster[] public boosters;
61     bool public implementsERC721 = true;
62     string public name = "Fishbank Boosters";
63     string public symbol = "FISHB";
64     mapping(uint256 => address) public approved;
65     mapping(address => uint256) public balances;
66     address public fishbank;
67     address public chests;
68     address public auction;
69 
70     modifier onlyBoosterOwner(uint256 _tokenId) {
71         require(boosters[_tokenId].owner == msg.sender);
72         _;
73     }
74 
75     modifier onlyChest() {
76         require(chests == msg.sender);
77         _;
78     }
79 
80     function FishbankBoosters() public {
81         //nothing yet
82     }
83 
84     //mints the boosters can only be called by owner. could be a smart contract
85     function mintBooster(address _owner, uint32 _duration, uint8 _type, uint8 _strength, uint32 _amount, uint24 _raiseValue) onlyChest public {
86         boosters.length ++;
87 
88         Booster storage tempBooster = boosters[boosters.length - 1];
89 
90         tempBooster.owner = _owner;
91         tempBooster.duration = _duration;
92         tempBooster.boosterType = _type;
93         tempBooster.strength = _strength;
94         tempBooster.amount = _amount;
95         tempBooster.raiseValue = _raiseValue;
96 
97         Transfer(address(0), _owner, boosters.length - 1);
98     }
99 
100     function setFishbank(address _fishbank) onlyOwner public {
101         fishbank = _fishbank;
102     }
103 
104     function setChests(address _chests) onlyOwner public {
105         if (chests != address(0)) {
106             revert();
107         }
108         chests = _chests;
109     }
110 
111     function setAuction(address _auction) onlyOwner public {
112         auction = _auction;
113     }
114 
115     function getBoosterType(uint256 _tokenId) view public returns (uint8 boosterType) {
116         boosterType = boosters[_tokenId].boosterType;
117     }
118 
119     function getBoosterAmount(uint256 _tokenId) view public returns (uint32 boosterAmount) {
120         boosterAmount = boosters[_tokenId].amount;
121     }
122 
123     function getBoosterDuration(uint256 _tokenId) view public returns (uint32) {
124         if (boosters[_tokenId].boosterType == 4 || boosters[_tokenId].boosterType == 2) {
125             return boosters[_tokenId].duration + boosters[_tokenId].raiseValue * 60;
126         }
127         return boosters[_tokenId].duration;
128     }
129 
130     function getBoosterStrength(uint256 _tokenId) view public returns (uint8 strength) {
131         strength = boosters[_tokenId].strength;
132     }
133 
134     function getBoosterRaiseValue(uint256 _tokenId) view public returns (uint24 raiseValue) {
135         raiseValue = boosters[_tokenId].raiseValue;
136     }
137 
138     //ERC721 functionality
139     //could split this to a different contract but doesn't make it easier to read
140     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
141     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
142 
143     function totalSupply() public view returns (uint256 total) {
144         total = boosters.length;
145     }
146 
147     function balanceOf(address _owner) public view returns (uint256 balance){
148         balance = balances[_owner];
149     }
150 
151     function ownerOf(uint256 _tokenId) public view returns (address owner){
152         owner = boosters[_tokenId].owner;
153     }
154 
155     function _transfer(address _from, address _to, uint256 _tokenId) internal {
156         require(boosters[_tokenId].owner == _from);
157         //can only transfer if previous owner equals from
158         boosters[_tokenId].owner = _to;
159         approved[_tokenId] = address(0);
160         //reset approved of fish on every transfer
161         balances[_from] -= 1;
162         //underflow can only happen on 0x
163         balances[_to] += 1;
164         //overflows only with very very large amounts of fish
165         Transfer(_from, _to, _tokenId);
166     }
167 
168     function transfer(address _to, uint256 _tokenId) public
169     onlyBoosterOwner(_tokenId) //check if msg.sender is the owner of this fish
170     returns (bool)
171     {
172         _transfer(msg.sender, _to, _tokenId);
173         //after master modifier invoke internal transfer
174         return true;
175     }
176 
177     function approve(address _to, uint256 _tokenId) public
178     onlyBoosterOwner(_tokenId)
179     {
180         approved[_tokenId] = _to;
181         Approval(msg.sender, _to, _tokenId);
182     }
183 
184     function transferFrom(address _from, address _to, uint256 _tokenId) public returns (bool) {
185         require(approved[_tokenId] == msg.sender || msg.sender == fishbank || msg.sender == auction);
186         //require msg.sender to be approved for this token or to be the fishbank contract
187         _transfer(_from, _to, _tokenId);
188         //handles event, balances and approval reset
189         return true;
190     }
191 
192 
193     function takeOwnership(uint256 _tokenId) public {
194         require(approved[_tokenId] == msg.sender);
195         _transfer(ownerOf(_tokenId), msg.sender, _tokenId);
196     }
197 
198 
199 }