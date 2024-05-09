1 pragma solidity ^0.4.17;
2 
3 // source : https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
4 contract ERC20Interface {
5   function transfer(address to, uint tokens) public returns (bool success);
6   event Transfer(address indexed from, address indexed to, uint tokens);
7 }
8 
9 contract WeaponTokenize {
10     /*  State variables */
11     address public owner;
12     uint[] weaponList;
13     address[] authorizedOwners;
14 
15     /* mappings */
16     mapping (uint => string) gameDataOf;
17     mapping (uint => string) publicDataOf;
18     mapping (uint => string) ownerDataOf;
19     mapping (uint => address) ownerOf;
20     
21     mapping (address => bool) isAuthorizedOwner;
22     
23 
24 
25     /* Events */
26     event WeaponAdded(uint indexed weaponId, string gameData, string publicData, string ownerData);
27     event WeaponUpdated(uint indexed weaponId, string gameData, string publicData, string ownerData);
28     event OwnershipTransferred(address indexed _oldOwner, address indexed _newOwner);
29     event WeaponOwnerUpdated (uint indexed  _weaponId, address indexed  _oldOwner, address indexed  _newOwner);
30     event AuthorizedOwnerAdded(address indexed _addeduthorizedOwner);
31     event AuthorizedOwnerRemoved(address indexed _removedAuthorizedOwner);  
32     
33     /* Modifiers */    
34     modifier onlyOwnerOfContract() { 
35       require(msg.sender == owner);
36       _; 
37     }
38 
39     modifier onlyAuthorizedOwner() { 
40      require(isAuthorizedOwner[msg.sender]);
41      _;
42     }
43     
44      
45     /*  constructor */
46     function WeaponTokenize () public {
47       owner = msg.sender;
48       isAuthorizedOwner[msg.sender] =  true;
49       authorizedOwners.push(msg.sender);
50 
51     }
52 
53     //////////////////////////////////////////
54     // OWNER SPECIFIC FUNCTIONS
55     //////////////////////////////////////////
56 
57     /* Add authrized owners */
58     function addAuthorizedOwners (address _newAuthorizedUser) public onlyOwnerOfContract returns(bool res) {
59       require(!isAuthorizedOwner[_newAuthorizedUser]);
60       isAuthorizedOwner[_newAuthorizedUser] =  true;
61       authorizedOwners.push(_newAuthorizedUser);
62       emit AuthorizedOwnerAdded(_newAuthorizedUser);
63       return true;
64     }
65     
66     /*  Remove authorized users */
67     function removeAuthorizeduser(address _authorizedUser) public onlyOwnerOfContract returns(bool res){
68         require(isAuthorizedOwner[_authorizedUser]);
69         delete(isAuthorizedOwner[_authorizedUser]);
70         for(uint i=0; i< authorizedOwners.length;i++){
71           if(authorizedOwners[i] == _authorizedUser){
72             delete authorizedOwners[i];
73             break;
74           }
75         }
76         emit AuthorizedOwnerRemoved(_authorizedUser);
77         return true;
78     }
79 
80     /* Change ownership */
81     function transferOwnership (address _newOwner) public onlyOwnerOfContract returns(bool res) {
82       owner = _newOwner;
83       emit OwnershipTransferred(msg.sender, _newOwner);
84       return true;
85     }
86 
87 
88     // ------------------------------------------------------------------------
89     // Owner can transfer out any accidentally sent ERC20 tokens
90     // ------------------------------------------------------------------------
91     function transferAnyERC20Token(address _tokenAddress, uint _value) public onlyOwnerOfContract returns (bool success) {
92         return ERC20Interface(_tokenAddress).transfer(owner, _value);
93     }
94     
95     
96 
97     //////////////////////////////////////////
98     // AUTHORIZEED USERS FUNCTIONALITY
99     //////////////////////////////////////////
100 
101     /* Add weapon */
102     function addWeapon (uint _id, string _gameData, string _publicData, string _ownerData, address _ownerAddrress) public onlyAuthorizedOwner returns(bool res) {
103       gameDataOf[_id] = _gameData;
104       publicDataOf[_id] = _publicData;
105       ownerDataOf[_id] = _ownerData;
106       ownerOf[_id] =  _ownerAddrress;
107       weaponList.push(_id);
108       emit WeaponAdded(_id, _gameData, _publicData, _ownerData);
109       return true;
110     }
111 
112     /* update all weapon details */
113     function updateWeapon (uint _id, string _gameData, string _publicData, string _ownerData) public onlyAuthorizedOwner returns(bool res) {
114       gameDataOf[_id] = _gameData;
115       publicDataOf[_id] = _publicData;
116       ownerDataOf[_id] = _ownerData;
117       //emit WeaponAdded(_id, _gameData, _publicData, _ownerData);
118       return true;
119     }
120 
121     /*  update game proprietary data */
122     function updateGameProprietaryData (uint _id, string _gameData) public onlyAuthorizedOwner returns(bool res) {
123       gameDataOf[_id] = _gameData;
124       emit WeaponUpdated(_id, _gameData, "", "");
125       return true;
126     }
127 
128     /* update public data */
129     function updatePublicData (uint _id,  string _publicData) public onlyAuthorizedOwner returns(bool res) {
130       publicDataOf[_id] = _publicData;
131       emit WeaponUpdated(_id, "", _publicData, "");
132       return true;
133     }
134 
135     /* update owner proprietary data */
136     function updateOwnerProprietaryData (uint _id, string _ownerData) public onlyAuthorizedOwner returns(bool res) {
137       ownerDataOf[_id] = _ownerData;
138       emit WeaponUpdated(_id, "", "", _ownerData);
139       return true;
140     }
141 
142     /* change owner of weapon */
143     function updateOwnerOfWeapon (uint _id, address _newOwner) public onlyAuthorizedOwner returns(bool res) {
144       address oldOwner = ownerOf[_id];
145       ownerOf[_id] =  _newOwner;
146       emit WeaponOwnerUpdated(_id, oldOwner, _newOwner);
147       return true;
148     }
149     
150 
151     //////////////////////////////////////////
152     // PUBLICLY ACCESSIBLE METHODS (CONSTANT)
153     //////////////////////////////////////////
154 
155     /* Get Weapon Data */
156     function getGameProprietaryData (uint _id) public view returns(string _gameData) {
157       return gameDataOf[_id];
158     }
159 
160     function getPublicData (uint _id) public view returns(string _pubicData) {
161       return publicDataOf[_id];
162     }
163 
164     function getOwnerProprietaryData (uint _id) public view returns(string _ownerData) {
165       return ownerDataOf[_id] ;
166     }
167 
168     function getAllWeaponData (uint _id) public view returns(string _gameData,string _pubicData,string _ownerData ) {
169       return (gameDataOf[_id], publicDataOf[_id], ownerDataOf[_id]);
170     }
171 
172     function getOwnerOf (uint _weaponId) public view returns(address _owner) {
173       return ownerOf[_weaponId];
174     }
175 
176     function getWeaponList () public view returns(uint[] tokenizedWeapons) {
177       return weaponList;
178     }
179 
180     function getAuthorizedOwners () public view returns(address[] authorizedUsers) {
181       return authorizedOwners;
182     }
183     
184 
185     // ------------------------------------------------------------------------
186     // Prevents contract from accepting ETH
187     // ------------------------------------------------------------------------
188     function () public payable {
189       revert();
190     }
191 
192 }