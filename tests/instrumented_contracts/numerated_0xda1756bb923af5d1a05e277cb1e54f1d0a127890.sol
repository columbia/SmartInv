1 pragma solidity ^0.4.24;
2 
3 /**
4  * ENS Resolver interface.
5  */
6 contract ENSResolver {
7     function addr(bytes32 _node) public view returns (address);
8     function setAddr(bytes32 _node, address _addr) public;
9     function name(bytes32 _node) public view returns (string);
10     function setName(bytes32 _node, string _name) public;
11 }
12 
13 /**
14  * @title Owned
15  * @dev Basic contract to define an owner.
16  * @author Julien Niset - <julien@argent.xyz>
17  */
18 contract Owned {
19 
20     // The owner
21     address public owner;
22 
23     event OwnerChanged(address indexed _newOwner);
24 
25     /**
26      * @dev Throws if the sender is not the owner.
27      */
28     modifier onlyOwner {
29         require(msg.sender == owner, "Must be owner");
30         _;
31     }
32 
33     constructor() public {
34         owner = msg.sender;
35     }
36 
37     /**
38      * @dev Lets the owner transfer ownership of the contract to a new owner.
39      * @param _newOwner The new owner.
40      */
41     function changeOwner(address _newOwner) external onlyOwner {
42         require(_newOwner != address(0), "Address must not be null");
43         owner = _newOwner;
44         emit OwnerChanged(_newOwner);
45     }
46 }
47 
48 /**
49  * @title Managed
50  * @dev Basic contract that defines a set of managers. Only the owner can add/remove managers.
51  * @author Julien Niset - <julien@argent.xyz>
52  */
53 contract Managed is Owned {
54 
55     // The managers
56     mapping (address => bool) public managers;
57 
58     /**
59      * @dev Throws if the sender is not a manager.
60      */
61     modifier onlyManager {
62         require(managers[msg.sender] == true, "M: Must be manager");
63         _;
64     }
65 
66     event ManagerAdded(address indexed _manager);
67     event ManagerRevoked(address indexed _manager);
68 
69     /**
70     * @dev Adds a manager. 
71     * @param _manager The address of the manager.
72     */
73     function addManager(address _manager) external onlyOwner {
74         require(_manager != address(0), "M: Address must not be null");
75         if(managers[_manager] == false) {
76             managers[_manager] = true;
77             emit ManagerAdded(_manager);
78         }        
79     }
80 
81     /**
82     * @dev Revokes a manager.
83     * @param _manager The address of the manager.
84     */
85     function revokeManager(address _manager) external onlyOwner {
86         require(managers[_manager] == true, "M: Target must be an existing manager");
87         delete managers[_manager];
88         emit ManagerRevoked(_manager);
89     }
90 }
91 
92 /**
93  * @title ArgentENSResolver
94  * @dev Basic implementation of a Resolver.
95  * The contract defines a manager role who is the only role that can add a new name
96  * to the list of resolved names. 
97  * @author Julien Niset - <julien@argent.xyz>
98  */
99 contract ArgentENSResolver is Owned, Managed, ENSResolver {
100 
101     bytes4 constant SUPPORT_INTERFACE_ID = 0x01ffc9a7;
102     bytes4 constant ADDR_INTERFACE_ID = 0x3b3b57de;
103     bytes4 constant NAME_INTERFACE_ID = 0x691f3431;
104 
105     // mapping between namehash and resolved records
106     mapping (bytes32 => Record) records;
107 
108     struct Record {
109         address addr;
110         string name;
111     }
112 
113     // *************** Events *************************** //
114 
115     event AddrChanged(bytes32 indexed _node, address _addr);
116     event NameChanged(bytes32 indexed _node, string _name);
117 
118     // *************** Public Functions ********************* //
119 
120     /**
121      * @dev Lets the manager set the address associated with an ENS node.
122      * @param _node The node to update.
123      * @param _addr The address to set.
124      */
125     function setAddr(bytes32 _node, address _addr) public onlyManager {
126         records[_node].addr = _addr;
127         emit AddrChanged(_node, _addr);
128     }
129 
130     /**
131      * @dev Lets the manager set the name associated with an ENS node.
132      * @param _node The node to update.
133      * @param _name The name to set.
134      */
135     function setName(bytes32 _node, string _name) public onlyManager {
136         records[_node].name = _name;
137         emit NameChanged(_node, _name);
138     }
139 
140     /**
141      * @dev Gets the address associated to an ENS node.
142      * @param _node The target node.
143      * @return the address of the target node.
144      */
145     function addr(bytes32 _node) public view returns (address) {
146         return records[_node].addr;
147     }
148 
149     /**
150      * @dev Gets the name associated to an ENS node.
151      * @param _node The target ENS node.
152      * @return the name of the target ENS node.
153      */
154     function name(bytes32 _node) public view returns (string) {
155         return records[_node].name;
156     }
157 
158     /**
159      * @dev Returns true if the resolver implements the interface specified by the provided hash.
160      * @param _interfaceID The ID of the interface to check for.
161      * @return True if the contract implements the requested interface.
162      */
163     function supportsInterface(bytes4 _interfaceID) public view returns (bool) {
164         return _interfaceID == SUPPORT_INTERFACE_ID || _interfaceID == ADDR_INTERFACE_ID || _interfaceID == NAME_INTERFACE_ID;
165     }
166 }