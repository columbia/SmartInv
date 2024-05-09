1 pragma solidity ^0.4.23;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
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
64 // File: contracts/Adminable.sol
65 
66 /**
67  * @title Adminable
68  * @dev The adminable contract has an admin address, and provides basic authorization control
69  * functions, this simplifies the implementation of "user permissions".
70  */
71 contract Adminable is Ownable {
72     address public admin;
73 
74     event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
75 
76     /**
77      * @dev The Mintable constructor sets the original `minter` of the contract to the sender
78      * account.
79      */
80     constructor() public {
81         admin = msg.sender;
82     }
83 
84     /**
85      * @dev Throws if called by any account other than the admin.
86      */
87     modifier onlyAdmin() {
88         require(msg.sender == admin, "Only admin is allowed to execute this method.");
89         _;
90     }
91 
92     /**
93      * @dev Allows the current owner to transfer control of the admin to newAdmin
94      */
95     function transferAdmin(address newAdmin) public onlyOwner {
96         require(newAdmin != address(0));
97         emit AdminTransferred(admin, newAdmin);
98         admin = newAdmin;
99     }
100 }
101 
102 // File: contracts/EpicsLimitedEdition.sol
103 
104 contract EpicsLimitedEdition is Ownable, Adminable {
105     event LimitedEditionRunCreated(uint256 runId);
106     event UUIDAdded(uint256 runId, string uuid);
107 
108     struct LimitedEditionRun {
109         string name;
110         uint32 cardCount;
111         string created;
112     }
113 
114     LimitedEditionRun[] runs;
115     mapping (string => uint256) internal uuidToRunId;
116     mapping (string => uint256) internal nameToRunId;
117     mapping (uint256 => string[]) internal runToUuids;
118     mapping (string => bool) internal uuidExists;
119     mapping (string => bool) internal runExists;
120 
121 
122     function createRun(string name, uint32 cardCount, string created) public onlyAdmin {
123         require(runExists[name] == false, "Limited edition run with that name already exists.");
124         LimitedEditionRun memory _run = LimitedEditionRun({name: name, cardCount: cardCount, created: created});
125         uint256 _runId = runs.push(_run) - 1;
126         runToUuids[_runId] = new string[](0);
127         nameToRunId[name] = _runId;
128         runExists[name] = true;
129         emit LimitedEditionRunCreated(_runId);
130     }
131 
132     function getRun(uint256 runId) public view returns (string name, uint32 cardCount, string created) {
133         require(runId < runs.length, "Run ID does not exist.");
134         LimitedEditionRun memory run = runs[runId];
135         name = run.name;
136         cardCount = run.cardCount;
137         created = run.created;
138     }
139 
140     function getRunIdForName(string name) public view returns (uint256 runId) {
141         require(runExists[name] == true, "Run with that name does not exist.");
142         return nameToRunId[name];
143     }
144 
145     function getRunIdForUUID(string uuid) public view returns (uint256 runId) {
146         require(uuidExists[uuid] == true, "UUID is not added to any run.");
147         return uuidToRunId[uuid];
148     }
149 
150     function getRunUUIDAtIndex(uint256 runId, uint256 index) public view returns (string uuid) {
151         require(runId < runs.length, "Run ID does not exist.");
152         require(index < runToUuids[runId].length, "That UUID index is out of range.");
153         uuid = runToUuids[runId][index];
154     }
155 
156     function getTotalRuns() public constant returns (uint256 totalRuns) {
157         return runs.length;
158     }
159 
160     function add1UUID(uint256 runId, string uuid) public onlyAdmin {
161         require(runId < runs.length, "Run ID does not exist.");
162         require(uuidExists[uuid] == false, "UUID already added.");
163         runToUuids[runId].push(uuid);
164         uuidToRunId[uuid] = runId;
165         uuidExists[uuid] = true;
166         emit UUIDAdded(runId, uuid);
167     }
168 
169     function add5UUIDs(uint256 runId, string uuid1, string uuid2, string uuid3, string uuid4, string uuid5) public onlyAdmin {
170         add1UUID(runId, uuid1);
171         add1UUID(runId, uuid2);
172         add1UUID(runId, uuid3);
173         add1UUID(runId, uuid4);
174         add1UUID(runId, uuid5);
175     }
176 
177     function add10UUIDs(uint256 runId, string uuid1, string uuid2, string uuid3, string uuid4, string uuid5,
178                         string uuid6, string uuid7, string uuid8, string uuid9, string uuid10) public onlyAdmin {
179         add1UUID(runId, uuid1);
180         add1UUID(runId, uuid2);
181         add1UUID(runId, uuid3);
182         add1UUID(runId, uuid4);
183         add1UUID(runId, uuid5);
184         add1UUID(runId, uuid6);
185         add1UUID(runId, uuid7);
186         add1UUID(runId, uuid8);
187         add1UUID(runId, uuid9);
188         add1UUID(runId, uuid10);
189     }
190 }