1 pragma solidity 0.5.4;
2 
3 contract Ownable {
4     address private _owner;
5 
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8     /**
9      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
10      * account.
11      */
12     constructor () internal {
13         _owner = msg.sender;
14         emit OwnershipTransferred(address(0), _owner);
15     }
16 
17     /**
18      * @return the address of the owner.
19      */
20     function owner() public view returns (address) {
21         return _owner;
22     }
23 
24     /**
25      * @dev Throws if called by any account other than the owner.
26      */
27     modifier onlyOwner() {
28         require(isOwner());
29         _;
30     }
31 
32     /**
33      * @return true if `msg.sender` is the owner of the contract.
34      */
35     function isOwner() public view returns (bool) {
36         return msg.sender == _owner;
37     }
38 
39     /**
40      * @dev Allows the current owner to relinquish control of the contract.
41      * @notice Renouncing to ownership will leave the contract without an owner.
42      * It will not be possible to call the functions with the `onlyOwner`
43      * modifier anymore.
44      */
45     function renounceOwnership() public onlyOwner {
46         emit OwnershipTransferred(_owner, address(0));
47         _owner = address(0);
48     }
49 
50     /**
51      * @dev Allows the current owner to transfer control of the contract to a newOwner.
52      * @param newOwner The address to transfer ownership to.
53      */
54     function transferOwnership(address newOwner) public onlyOwner {
55         _transferOwnership(newOwner);
56     }
57 
58     /**
59      * @dev Transfers control of the contract to a newOwner.
60      * @param newOwner The address to transfer ownership to.
61      */
62     function _transferOwnership(address newOwner) internal {
63         require(newOwner != address(0));
64         emit OwnershipTransferred(_owner, newOwner);
65         _owner = newOwner;
66     }
67 }
68 
69 contract pDNADistributedRegistryInterface {
70   function getProperty(string memory _eGrid) public view returns (address property);
71   function owner() public view returns (address);
72 }
73 
74 contract CuratorsInterface {
75   function checkRole(address _operator, string memory _permission) public view;
76 }
77 
78 contract pDNA {
79   address public constant CURATORS_ADDRESS = 0x75375B37845792256F274875b345F35597d1C053;  // 0x0f5Ea0A652E851678Ebf77B69484bFcD31F9459B;
80   CuratorsInterface public curators = CuratorsInterface(CURATORS_ADDRESS);
81 
82   address public constant PDNA_DISTRIBUTED_REGISTRY_ADDRESS = 0xf8D03aE98997B7d58A69Db3B98a77AE6819Ff39b;  // 0xEC8bE1A5630364292E56D01129E8ee8A9578d7D8;
83   pDNADistributedRegistryInterface public registry = pDNADistributedRegistryInterface(PDNA_DISTRIBUTED_REGISTRY_ADDRESS);
84 
85   string public name;
86   string public symbol;
87 
88   mapping(string => bytes32) private files;
89 
90   event FilePut(address indexed curator, bytes32 indexed hash, string name);
91   event FileRemoved(address indexed curator, bytes32 indexed hash, string name);
92 
93   modifier isValid() {
94     require(registry.getProperty(name) == address(this), "invalid pDNA");
95     _;
96   }
97 
98   constructor(string memory _eGrid, string memory _grundstuck) public {
99     name = _eGrid;
100     symbol = _grundstuck;
101   }
102 
103   function elea() public view returns (address) {
104     return registry.owner();
105   }
106 
107   function getFile(string memory _name) public view returns (bytes32) {
108     return files[_name];
109   }
110 
111   function removeFile(string memory _name) public isValid {
112     curators.checkRole(msg.sender, "authorized");
113 
114     bytes32 hash = files[_name];
115     require(hash != bytes32(0));
116 
117     files[_name] = bytes32(0);
118 
119     emit FileRemoved(msg.sender, hash, _name);
120   }
121 
122   function putFile(bytes32 _hash, string memory _name) public isValid {
123     curators.checkRole(msg.sender, "authorized");
124 
125     files[_name] = _hash;
126 
127     emit FilePut(msg.sender, _hash, _name);
128   }
129 }