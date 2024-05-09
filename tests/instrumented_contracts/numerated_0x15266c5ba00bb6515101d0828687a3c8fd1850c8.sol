1 contract LindaDB {
2 
3   struct Identity {
4     uint entityData;
5     bytes32 gender;
6     bytes32 firstName;
7     bytes32 lastName;
8     bytes32 nationality;
9     bytes32 imageUrl;
10     bytes32 socialUrl;
11     bytes32 homeplace;
12     uint256 birthdate;
13     bool isEntity;
14   }
15 
16   mapping(address => Identity) public IdentityStructs;
17   mapping(address => address) public IdentityToDad;
18   mapping(address => address) public IdentityToMom;
19   mapping(address => address) public testimonies;
20   
21   event NewIdentity(uint id);  
22   
23   address[] public identityList;
24 
25   function isEntity(address entityAddress) public constant returns(bool isIndeed) {
26       return IdentityStructs[entityAddress].isEntity;
27   }
28   
29   function getMom(address identityAddress) public constant returns(address isIndeed) {
30       return IdentityToMom[identityAddress];
31   }
32   
33   function getDad(address identityAddress) public constant returns(address isIndeed) {
34       return IdentityToDad[identityAddress];
35   }
36 
37   function getEntityCount() public constant returns(uint entityCount) {
38     return identityList.length;
39   }
40 
41   function newIdentityL1(
42       address entityAddress, 
43       bytes32 gender,
44       bytes32 firstName,
45       bytes32 lastName,
46       bytes32 nationality, 
47       uint256 birthdate )
48     public returns(uint rowNumber) {
49         
50     if(isEntity(entityAddress)) throw;
51 
52     IdentityStructs[entityAddress].gender = gender;
53     IdentityStructs[entityAddress].firstName = firstName;
54     IdentityStructs[entityAddress].lastName = lastName;
55     IdentityStructs[entityAddress].nationality = nationality;
56     IdentityStructs[entityAddress].birthdate = birthdate;
57     
58     IdentityStructs[entityAddress].isEntity = true;
59     NewIdentity(rowNumber);
60     return identityList.push(entityAddress) - 1;
61   }
62 
63   function updateIdentityImageURL(
64     address entityAddress,
65     bytes32 imageUrl)
66     public returns(bool success) {
67         
68     if(!isEntity(entityAddress)) throw;
69     IdentityStructs[entityAddress].imageUrl = imageUrl;
70     return true;
71   }
72   
73   function updateIdentitySocialURL(
74     address entityAddress,
75     bytes32 socialUrl)
76     public returns(bool success) {
77         
78     if(!isEntity(entityAddress)) throw;
79     IdentityStructs[entityAddress].socialUrl = socialUrl;
80     return true;
81   }
82   
83   function addMomRelation(
84       address momAddress
85       )
86     public returns(bool success) {
87         require(getMom(msg.sender) == 0x0000000000000000000000000000000000000000);
88         IdentityToMom[msg.sender] = momAddress;
89         return true;
90     }
91     
92   function addDadRelation(
93       address dadAddress
94       )
95     public returns(bool success) {
96         require(getDad(msg.sender) == 0x0000000000000000000000000000000000000000);
97         IdentityToDad[msg.sender] = dadAddress;
98         return true;
99     }
100     
101   function addTestimony(
102       address testimonyAddress
103       )
104     public returns(bool success) { 
105         testimonies[msg.sender] = testimonyAddress;
106         return true;
107     }
108 
109 }