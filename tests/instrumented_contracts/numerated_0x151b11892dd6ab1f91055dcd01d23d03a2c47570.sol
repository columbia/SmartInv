1 pragma solidity ^0.4.18;
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
19   function Ownable() public {
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
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 }
41 
42 contract ServiceLocator is Ownable {
43 
44     struct Registry {
45         // address to resolve 
46         address addr;
47         // last updated time
48         uint256 updated;
49         // time to live for this record
50         uint32 ttl; 
51     }
52 
53     mapping (bytes32 => Registry) registry;
54     mapping (address => string) ptr;
55 
56     // EVENTS
57     event Set(string namespace, address registryAddr, uint32 ttl);
58     event Remove(string namespace);
59 
60     /**
61      * @dev Gets the address for a provided namespace 
62      *  in the service locator. 
63      * @param _namespace - namespace string for the record.
64      * @return address for the stored record
65      */
66     function get(string _namespace) constant public returns (address) {
67         Registry storage r = registry[keccak256(_namespace)];
68         
69         if (r.ttl > 0 && r.updated + r.ttl < now) {
70             return address(0);
71         }
72         return r.addr;
73     }
74 
75     /**
76      * @dev Gets the namespace for a provided address 
77      *  in the service locator. 
78      * @param _addr - address for the record.
79      * @return namespace for the stored record
80      */
81     function getNamespace(address _addr) constant public returns (string) {
82         string storage ns = ptr[_addr];
83 
84         Registry storage r = registry[keccak256(ns)];
85         if (r.ttl > 0 && r.updated + r.ttl < now) {
86             return "";
87         }
88         return ns;
89     }
90 
91     /**
92      * @dev Sets or Updates service locator registry
93      * @param _namespace - namespace string for the record.
94      * @param _addr - address of the contract to be stored.
95      * @param _ttl - How long in seconds will the record be valid. (0 means no ttl).
96      */
97     function set(string _namespace, address _addr, uint32 _ttl) onlyOwner public {
98         require(isContract(_addr));
99 
100         registry[keccak256(_namespace)] = Registry({
101             addr: _addr,
102             updated: now,
103             ttl: _ttl
104         });
105 
106         // saves reverse record. 
107         ptr[_addr] = _namespace;
108         
109         Set(_namespace, _addr, _ttl);
110     }
111 
112     /**
113      * @dev Removes a service locator registry
114      * @param _namespace - namespace string for the record.
115      */
116     function remove(string _namespace) onlyOwner public {
117         bytes32 h = keccak256(_namespace);
118 
119         delete ptr[ registry[h].addr ];
120         delete registry[ h ];
121         
122         Remove(_namespace);
123     }
124 
125     /**
126      * @dev Checks if the provided address is a contract.
127      * @param _addr - ethereum address
128      * @return bool true if provided address is a contract.
129      */
130     function isContract(address _addr) private view returns (bool) {
131         uint32 size;
132         assembly {
133             size := extcodesize(_addr)
134         }
135         return (size > 0);
136     }
137 }