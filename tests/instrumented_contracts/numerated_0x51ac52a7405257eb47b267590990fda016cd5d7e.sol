1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address private _owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     constructor () internal {
18         _owner = msg.sender;
19         emit OwnershipTransferred(address(0), _owner);
20     }
21 
22     /**
23      * @return the address of the owner.
24      */
25     function owner() public view returns (address) {
26         return _owner;
27     }
28 
29     /**
30      * @dev Throws if called by any account other than the owner.
31      */
32     modifier onlyOwner() {
33         require(isOwner());
34         _;
35     }
36 
37     /**
38      * @return true if `msg.sender` is the owner of the contract.
39      */
40     function isOwner() public view returns (bool) {
41         return msg.sender == _owner;
42     }
43 
44     /**
45      * @dev Allows the current owner to relinquish control of the contract.
46      * @notice Renouncing to ownership will leave the contract without an owner.
47      * It will not be possible to call the functions with the `onlyOwner`
48      * modifier anymore.
49      */
50     function renounceOwnership() public onlyOwner {
51         emit OwnershipTransferred(_owner, address(0));
52         _owner = address(0);
53     }
54 
55     /**
56      * @dev Allows the current owner to transfer control of the contract to a newOwner.
57      * @param newOwner The address to transfer ownership to.
58      */
59     function transferOwnership(address newOwner) public onlyOwner {
60         _transferOwnership(newOwner);
61     }
62 
63     /**
64      * @dev Transfers control of the contract to a newOwner.
65      * @param newOwner The address to transfer ownership to.
66      */
67     function _transferOwnership(address newOwner) internal {
68         require(newOwner != address(0));
69         emit OwnershipTransferred(_owner, newOwner);
70         _owner = newOwner;
71     }
72 }
73 
74 contract NodeList is Ownable {
75   event NodeListed(address publicKey, uint256 epoch, uint256 position);
76 
77   struct Details {
78     string declaredIp;
79     uint256 position;
80     uint256 pubKx;
81     uint256 pubKy;
82     string nodePort;
83   }
84 
85   mapping (uint256 => mapping (address => bool)) whitelist;
86 
87   mapping (address => mapping (uint256 => Details)) public addressToNodeDetailsLog; //mapping of address => epoch => nodeDetailsLog
88   mapping (uint256 => address[]) public nodeList; // mapping of epoch => list of nodes in epoch
89   uint256 latestEpoch = 0; //count of number of epochs
90 
91   constructor() public {
92   }
93 
94   //views nodes in the epoch, now requires specified epochs
95   function viewNodes(uint256 epoch) external view  returns (address[], uint256[]) {
96     uint256[] memory positions = new uint256[](nodeList[epoch].length);
97     for (uint256 i = 0; i < nodeList[epoch].length; i++) {
98       positions[i] = addressToNodeDetailsLog[nodeList[epoch][i]][epoch].position;
99     }
100     return (nodeList[epoch], positions);
101   }
102 
103   function viewNodeListCount(uint256 epoch) external view returns (uint256) {
104     return nodeList[epoch].length;
105   }
106 
107   function viewLatestEpoch() external view returns (uint256) {
108     return latestEpoch;
109   }
110 
111   function viewNodeDetails(uint256 epoch, address node) external view  returns (string declaredIp, uint256 position, string nodePort) {
112     declaredIp = addressToNodeDetailsLog[node][epoch].declaredIp;
113     position = addressToNodeDetailsLog[node][epoch].position;
114     nodePort = addressToNodeDetailsLog[node][epoch].nodePort;
115   }
116 
117   function viewWhitelist(uint256 epoch, address nodeAddress) public view returns (bool) {
118     return whitelist[epoch][nodeAddress];
119   }
120 
121   modifier whitelisted(uint256 epoch) {
122     require(whitelist[epoch][msg.sender]);
123     _;
124   }
125 
126   function updateWhitelist(uint256 epoch, address nodeAddress, bool allowed) public onlyOwner {
127     whitelist[epoch][nodeAddress] = allowed;
128   }
129 
130   function listNode(uint256 epoch, string declaredIp, uint256 pubKx, uint256 pubKy, string nodePort) external whitelisted(epoch) {
131     nodeList[epoch].push(msg.sender); 
132     addressToNodeDetailsLog[msg.sender][epoch] = Details({
133       declaredIp: declaredIp,
134       position: nodeList[epoch].length, //so that Position (or node index) starts from 1
135       pubKx: pubKx,
136       pubKy: pubKy,
137       nodePort: nodePort
138       });
139     //for now latest epoch is simply the highest epoch registered TODO: only we should be able to call this function
140     if (latestEpoch < epoch) {
141       latestEpoch = epoch;
142     }
143     emit NodeListed(msg.sender, epoch, nodeList[epoch].length);
144   }
145 }