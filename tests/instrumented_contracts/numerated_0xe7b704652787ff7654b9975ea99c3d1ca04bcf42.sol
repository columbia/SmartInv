1 /**
2  * @title Ownable
3  * @dev The Ownable contract has an owner address, and provides basic authorization control
4  * functions, this simplifies the implementation of "user permissions".
5  */
6 contract Ownable {
7   address public owner;
8 
9 
10   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
11 
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() public {
18     owner = msg.sender;
19   }
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29   /**
30    * @dev Allows the current owner to transfer control of the contract to a newOwner.
31    * @param newOwner The address to transfer ownership to.
32    */
33   function transferOwnership(address newOwner) public onlyOwner {
34     require(newOwner != address(0));
35     OwnershipTransferred(owner, newOwner);
36     owner = newOwner;
37   }
38 
39 }
40 
41 
42 /**
43  * @title Claimable
44  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
45  * This allows the new owner to accept the transfer.
46  */
47 contract Claimable is Ownable {
48   address public pendingOwner;
49 
50   /**
51    * @dev Modifier throws if called by any account other than the pendingOwner.
52    */
53   modifier onlyPendingOwner() {
54     require(msg.sender == pendingOwner);
55     _;
56   }
57 
58   /**
59    * @dev Allows the current owner to set the pendingOwner address.
60    * @param newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address newOwner) onlyOwner public {
63     pendingOwner = newOwner;
64   }
65 
66   /**
67    * @dev Allows the pendingOwner address to finalize the transfer.
68    */
69   function claimOwnership() onlyPendingOwner public {
70     OwnershipTransferred(owner, pendingOwner);
71     owner = pendingOwner;
72     pendingOwner = address(0);
73   }
74 }
75 
76 
77 /**
78  * @title AccessMint
79  * @dev Adds grant/revoke functions to the contract.
80  */
81 contract AccessMint is Claimable {
82 
83   // Access for minting new tokens.
84   mapping(address => bool) private mintAccess;
85 
86   // Modifier for accessibility to define new hero types.
87   modifier onlyAccessMint {
88     require(msg.sender == owner || mintAccess[msg.sender] == true);
89     _;
90   }
91 
92   // @dev Grant acess to mint heroes.
93   function grantAccessMint(address _address)
94     onlyOwner
95     public
96   {
97     mintAccess[_address] = true;
98   }
99 
100   // @dev Revoke acess to mint heroes.
101   function revokeAccessMint(address _address)
102     onlyOwner
103     public
104   {
105     mintAccess[_address] = false;
106   }
107 
108 }
109 
110 
111 /**
112  * @title AccessDeploy
113  * @dev Adds grant/revoke functions to the contract.
114  */
115 contract AccessDeploy is Claimable {
116 
117   // Access for deploying heroes.
118   mapping(address => bool) private deployAccess;
119 
120   // Modifier for accessibility to deploy a hero on a location.
121   modifier onlyAccessDeploy {
122     require(msg.sender == owner || deployAccess[msg.sender] == true);
123     _;
124   }
125 
126   // @dev Grant acess to deploy heroes.
127   function grantAccessDeploy(address _address)
128     onlyOwner
129     public
130   {
131     deployAccess[_address] = true;
132   }
133 
134   // @dev Revoke acess to deploy heroes.
135   function revokeAccessDeploy(address _address)
136     onlyOwner
137     public
138   {
139     deployAccess[_address] = false;
140   }
141 
142 }
143 
144 
145 /**
146  * @title CryptoSagaDungeonProgress
147  * @dev Storage contract for progress of dungeons.
148  */
149 contract CryptoSagaDungeonProgress is Claimable, AccessDeploy {
150 
151   // The progress of the player in dungeons.
152   mapping(address => uint32[25]) public addressToProgress;
153 
154   // @dev Get progress.
155   function getProgressOfAddressAndId(address _address, uint32 _id)
156     external view
157     returns (uint32)
158   {
159     var _progressList = addressToProgress[_address];
160     return _progressList[_id];
161   }
162 
163   // @dev Increment progress.
164   function incrementProgressOfAddressAndId(address _address, uint32 _id)
165     onlyAccessDeploy
166     public
167   {
168     var _progressList = addressToProgress[_address];
169     _progressList[_id]++;
170     addressToProgress[_address] = _progressList;
171   }
172 }