1 pragma solidity ^0.5.3;
2 
3 // File: contracts/utility/Ownable.sol
4 
5 contract Ownable {
6     address private _owner;
7 
8     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9 
10     /**
11      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12      * account.
13      */
14     constructor () internal {
15         _owner = msg.sender;
16         emit OwnershipTransferred(address(0), _owner);
17     }
18 
19     /**
20      * @return the address of the owner.
21      */
22     function owner() public view returns (address) {
23         return _owner;
24     }
25 
26     /**
27      * @dev Throws if called by any account other than the owner.
28      */
29     modifier onlyOwner() {
30         require(isOwner());
31         _;
32     }
33 
34     /**
35      * @return true if `msg.sender` is the owner of the contract.
36      */
37     function isOwner() public view returns (bool) {
38         return msg.sender == _owner;
39     }
40 
41     /**
42      * @dev Allows the current owner to transfer control of the contract to a newOwner.
43      * @param newOwner The address to transfer ownership to.
44      */
45     function transferOwnership(address newOwner) public onlyOwner {
46         _transferOwnership(newOwner);
47     }
48 
49     /**
50      * @dev Transfers control of the contract to a newOwner.
51      * @param newOwner The address to transfer ownership to.
52      */
53     function _transferOwnership(address newOwner) internal {
54         require(newOwner != address(0));
55         emit OwnershipTransferred(_owner, newOwner);
56         _owner = newOwner;
57     }
58 }
59 
60 // File: contracts/utility/Approvable.sol
61 
62 contract Approvable is Ownable {
63     mapping(address => bool) private _approvedAddress;
64 
65 
66     modifier onlyApproved() {
67         require(isApproved());
68         _;
69     }
70 
71     function isApproved() public view returns(bool) {
72         return _approvedAddress[msg.sender] || isOwner();
73     }
74 
75     function approveAddress(address _address) public onlyOwner {
76         _approvedAddress[_address] = true;
77     }
78 
79     function revokeApproval(address _address) public onlyOwner {
80         _approvedAddress[_address] = false;
81     }
82 }
83 
84 // File: contracts/utility/StoringCreationMeta.sol
85 
86 contract StoringCreationMeta {
87     uint public creationBlock;
88     uint public creationTime;
89 
90     constructor() internal {
91         creationBlock = block.number;
92         creationTime = block.timestamp;
93     }
94 }
95 
96 // File: contracts/NodeRegistry.sol
97 
98 contract NodeRegistry is StoringCreationMeta, Approvable {
99     mapping(address => string) public nodeIp;
100     mapping(address => string) public nodeWs;
101 
102     mapping(address => uint) public nodeCountLimit;
103 
104     struct NodeList {
105         address[] items;
106         mapping(address => uint) position;
107     }
108     mapping(address => NodeList) userNodes;
109     NodeList availableNodes;
110 
111     modifier onlyRegisteredNode() {
112         require(
113             availableNodes.position[msg.sender] > 0,
114             "Node not registered."
115         );
116         _;
117     }
118 
119     function registerNodes(address[] memory _nodeAddresses) public {
120         NodeList storage _nodes = userNodes[msg.sender];
121 
122         require(
123             nodeCountLimit[msg.sender] >=
124             _nodes.items.length + _nodeAddresses.length,
125             "Over the limit."
126         );
127 
128         for(uint i = 0; i < _nodeAddresses.length; i++) {
129             // If it doesn't exist already
130             if(_nodes.position[_nodeAddresses[i]] == 0) {
131                 registerNode(_nodeAddresses[i]);
132             }
133         }
134     }
135 
136     function deregisterNodes(address[] memory _nodeAddresses) public {
137         for(uint i = 0; i < _nodeAddresses.length; i++) {
138             deregisterNode(_nodeAddresses[i]);
139         }
140     }
141 
142     function deregisterNode(address _nodeAddress) private {
143         NodeList storage _nodes = userNodes[msg.sender];
144 
145         if(_nodes.position[_nodeAddress] == 0) {
146             revert("Node not registered.");
147         }
148 
149         removeFromList(_nodes, _nodeAddress);
150         removeFromList(availableNodes, _nodeAddress);
151 
152         delete nodeIp[_nodeAddress];
153         delete nodeWs[_nodeAddress];
154     }
155 
156     function removeFromList(NodeList storage _nodes, address _item) private {
157         uint nIndex = _nodes.position[_item] - 1;
158         uint lastIndex = _nodes.items.length - 1;
159         address lastItem = _nodes.items[lastIndex];
160 
161         _nodes.items[nIndex] = lastItem;
162         _nodes.position[lastItem] = nIndex + 1;
163         _nodes.position[_item] = 0;
164 
165         _nodes.items.pop();
166     }
167 
168     function registerNode(address _nodeAddress) private {
169         NodeList storage _nodes = userNodes[msg.sender];
170 
171         if(availableNodes.position[_nodeAddress] != 0) {
172             revert("Node already registered by another user.");
173         }
174 
175         // Save to user nodes
176         _nodes.items.push(_nodeAddress);
177         _nodes.position[_nodeAddress] = _nodes.items.length;
178 
179         // Save to global nodes
180         availableNodes.items.push(_nodeAddress);
181         availableNodes.position[_nodeAddress] = availableNodes.items.length;
182     }
183 
184     function getAvailableNodes() public view returns(address[] memory) {
185         return availableNodes.items;
186     }
187 
188     function getUserNodes(address _user) public view returns(address[] memory) {
189         return userNodes[_user].items;
190     }
191 
192     function setNodeLimits(address[] memory _users, uint[] memory _limits) public onlyApproved {
193         require(_users.length == _limits.length, "Length mismatch.");
194 
195         for(uint i = 0; i < _users.length; ++i) {
196             _setNodeLimit(_users[i], _limits[i]);
197         }
198     }
199 
200     function _setNodeLimit(address _user, uint _limit) private {
201         nodeCountLimit[_user] = _limit;
202 
203         _pruneUserNodes(_user, _limit);
204     }
205 
206     function _pruneUserNodes(address _user, uint _limit) private view {
207         if (_limit >= nodeCountLimit[_user]) {
208             return;
209         }
210     }
211 
212     function registerNodeIp(string memory _ip) public onlyRegisteredNode {
213         nodeIp[msg.sender] = _ip;
214     }
215 
216     function registerNodeWs(string memory _ws) public onlyRegisteredNode {
217         nodeWs[msg.sender] = _ws;
218     }
219 
220     function registerNodeIpAndWs(string memory _ip, string memory _ws) public onlyRegisteredNode {
221         nodeIp[msg.sender] = _ip;
222         nodeWs[msg.sender] = _ws;
223     }
224 
225     function getNodeIpAndWs(address _node) public view returns(string memory, string memory) {
226         return (nodeIp[_node], nodeWs[_node]);
227     }
228 }