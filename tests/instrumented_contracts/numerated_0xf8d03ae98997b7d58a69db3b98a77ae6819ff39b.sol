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
69 contract pDNADistributedRegistry is Ownable {
70   mapping(string => address) private registry;
71 
72   event Profiled(string eGrid, address indexed property);
73   event Unprofiled(string eGrid, address indexed property);
74 
75   /**
76    * this function's abi should never change and always maintain backwards compatibility
77    */
78   function getProperty(string memory _eGrid) public view returns (address property) {
79     property = registry[_eGrid];
80   }
81 
82   function profileProperty(string memory _eGrid, address _property) public onlyOwner {
83     require(bytes(_eGrid).length > 0, "eGrid must be non-empty string");
84     require(_property != address(0), "property address must be non-null");
85     require(registry[_eGrid] == address(0), "property must not already exist in land registry");
86 
87     registry[_eGrid] = _property;
88     emit Profiled(_eGrid, _property);
89   }
90 
91   function unprofileProperty(string memory _eGrid) public onlyOwner {
92     address property = getProperty(_eGrid);
93     require(property != address(0), "property must exist in land registry");
94 
95     registry[_eGrid] = address(0);
96     emit Unprofiled(_eGrid, property);
97   }
98 }