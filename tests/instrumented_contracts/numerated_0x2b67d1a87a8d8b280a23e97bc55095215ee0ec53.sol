1 contract Delegatable {
2     address public empty1; // unknown slot
3     address public empty2; // unknown slot
4     address public empty3;  // unknown slot
5     address public owner;  // matches owner slot in controller
6     address public delegation; // matches thisAddr slot in controller
7 
8     event DelegationTransferred(address indexed previousDelegate, address indexed newDelegation);
9     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
10 
11     modifier onlyOwner() {
12         require(msg.sender == owner, "Sender is not the owner");
13         _;
14     }
15 
16     constructor() public {}
17 
18     /**
19     * @dev Allows owner to transfer delegation of the contract to a newDelegation.
20     * @param _newDelegation The address to transfer delegation to.
21     */
22     function transferDelegation(address _newDelegation) public onlyOwner {
23         require(_newDelegation != address(0), "Trying to transfer to address 0");
24         emit DelegationTransferred(delegation, _newDelegation);
25         delegation = _newDelegation;
26     }
27 
28     /**
29     * @dev Allows the current owner to transfer control of the contract to a newOwner.
30     * @param _newOwner The address to transfer ownership to.
31     */
32     function transferOwnership(address _newOwner) public onlyOwner {
33         require(_newOwner != address(0), "Trying to transfer to address 0");
34         emit OwnershipTransferred(owner, _newOwner);
35         owner = _newOwner;
36     }
37 }
38 
39 
40 contract DelegateProxy {
41 
42     constructor() public {}
43 
44     /**
45     * @dev Performs a delegatecall and returns whatever is returned (entire context execution will return!)
46     * @param _dst Destination address to perform the delegatecall
47     * @param _calldata Calldata for the delegatecall
48     */
49     function delegatedFwd(address _dst, bytes _calldata) internal {
50         assembly {
51             let result := delegatecall(sub(gas, 10000), _dst, add(_calldata, 0x20), mload(_calldata), 0, 0)
52             let size := returndatasize
53 
54             let ptr := mload(0x40)
55             returndatacopy(ptr, 0, size)
56 
57             // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.
58             // if the call returned error data, forward it
59             switch result case 0 { revert(ptr, size) }
60             default { return(ptr, size) }
61         }
62     }
63 }
64 
65 contract Proxy is Delegatable, DelegateProxy {
66 
67     constructor() public {}
68 
69     /**
70     * @dev Function to invoke all function that are implemented in controler
71     */
72     function () public {
73         require(delegation != address(0), "Delegation is address 0, not initialized");
74         delegatedFwd(delegation, msg.data);
75     }
76 
77     /**
78     * @dev Function to initialize storage of proxy
79     * @param _controller The address of the controller to load the code from
80     */
81     function initialize(address _controller, uint256) public {
82         require(owner == 0, "Already initialized");
83         owner = msg.sender;
84         delegation = _controller;
85         delegatedFwd(_controller, msg.data);
86     }
87 }