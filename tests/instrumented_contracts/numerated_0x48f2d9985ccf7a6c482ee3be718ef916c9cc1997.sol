1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) onlyOwner public {
37     require(newOwner != address(0));
38     OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 /**
45  * @title Stoppable
46  * @dev Base contract which allows children to implement a permanent stop mechanism.
47  */
48 contract Stoppable is Ownable {
49   event Stop();  
50 
51   bool public stopped = false;
52 
53   /**
54    * @dev Modifier to make a function callable only when the contract is not stopped.
55    */
56   modifier whenNotStopped() {
57     require(!stopped);
58     _;
59   }
60 
61   /**
62    * @dev Modifier to make a function callable only when the contract is stopped.
63    */
64   modifier whenStopped() {
65     require(stopped);
66     _;
67   }
68 
69   /**
70    * @dev called by the owner to pause, triggers stopped state
71    */
72   function stop() onlyOwner whenNotStopped public {
73     stopped = true;
74     Stop();
75   }
76 }
77 
78 contract SpaceRegistry is Stoppable {
79     
80     event Add();
81     uint constant START_INDEX = 1;
82     Space[] spaces;
83     mapping(uint => uint) spaceMap;
84     mapping(uint => uint[]) userSpaceLookup;
85     
86     struct Space {
87         uint id;
88         uint userId;
89         bytes userHash;
90         uint bottomLeft;
91         uint topLeft;
92         uint topRight;
93         uint bottomRight;
94         string txType;
95         string txId;
96         uint txTime;
97         uint created;
98     }
99 
100     function SpaceRegistry() {
101         spaces.length = START_INDEX;
102     }
103 
104     function addSpace(
105         uint id, uint userId, bytes userHash, uint bottomLeft, uint topLeft, 
106         uint topRight, uint bottomRight, string txType, string txId, uint txTime) 
107         onlyOwner whenNotStopped {
108 
109         require(id > 0);
110         require(spaceMap[id] == 0);
111         require(userId > 0);
112         require(userHash.length > 0);
113         require(bottomLeft > 0);
114         require(topLeft > 0);
115         require(topRight > 0);
116         require(bottomRight > 0);
117         require(bytes(txType).length > 0);
118         require(bytes(txId).length > 0);
119         require(txTime > 0);
120         
121         var space = Space({
122             id: id,
123             userId: userId,
124             userHash: userHash,
125             bottomLeft: bottomLeft,
126             topLeft: topLeft,
127             topRight: topRight,
128             bottomRight: bottomRight,
129             txType: txType,
130             txId: txId,
131             txTime: txTime,
132             created: block.timestamp
133         });
134 
135         var _index = spaces.push(space) - 1;
136         assert(_index >= START_INDEX);
137         spaceMap[id] = _index;
138         userSpaceLookup[userId].push(id);
139         Add();
140     }
141 
142     function getSpaceByIndex(uint index) external constant returns(
143         uint id,
144         uint userId,
145         bytes userHash,
146         uint bottomLeft,
147         uint topLeft,
148         uint topRight, 
149         uint bottomRight,
150         string txType,
151         string txId, 
152         uint txTime,
153         uint created) {
154 
155         var _index = index + START_INDEX;
156         require(spaces.length > _index);
157         var space = spaces[_index];
158         id = space.id;
159         userId = space.userId;
160         userHash = space.userHash;
161         bottomLeft = space.bottomLeft;
162         topLeft = space.topLeft;
163         topRight = space.topRight;
164         bottomRight = space.bottomRight;
165         txType = space.txType;
166         txId = space.txId;
167         txTime = space.txTime;
168         created = space.created;
169     }    
170 
171     function getSpaceById(uint _id) external constant returns(
172         uint id,
173         uint userId,
174         bytes userHash,
175         uint bottomLeft,
176         uint topLeft,
177         uint topRight, 
178         uint bottomRight,
179         string txType,
180         string txId,
181         uint txTime,
182         uint created) {
183 
184         require(_id > 0);
185         id = _id;
186         var index = spaceMap[id];
187         var space = spaces[index];
188         userId = space.userId;
189         userHash = space.userHash;
190         bottomLeft = space.bottomLeft;
191         topLeft = space.topLeft;
192         topRight = space.topRight;
193         bottomRight = space.bottomRight;
194         txType = space.txType;
195         txId = space.txId;
196         txTime = space.txTime;
197         created = space.created;
198     }
199 
200     function getUserSpaceIds(uint userId) external constant returns(uint[]) {
201         require(userId > 0);
202         return userSpaceLookup[userId]; 
203     }
204 
205     function getUserId(uint id) external constant returns(uint) {
206         require(id > 0);
207         var index = spaceMap[id];
208         require(index > 0);
209         var space = spaces[index];
210         return space.userId; 
211     }
212 
213     function exists(uint id) external constant returns(bool) {
214         require(id > 0);
215         return spaceMap[id] != 0;
216     }
217     
218     function spaceCount() constant returns (uint) {
219         return spaces.length - START_INDEX;
220     }   
221 }