1 pragma solidity 0.4.24;
2 
3 contract Delegatable {
4     address public empty1; // unknown slot
5     address public empty2; // unknown slot
6     address public empty3;  // unknown slot
7     address public owner;  // matches owner slot in controller
8     address public delegation; // matches thisAddr slot in controller
9 
10     event DelegationTransferred(address indexed previousDelegate, address indexed newDelegation);
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     modifier onlyOwner() {
14         require(msg.sender == owner, "Sender is not the owner");
15         _;
16     }
17 
18     constructor() public {}
19 
20     /**
21     * @dev Allows owner to transfer delegation of the contract to a newDelegation.
22     * @param _newDelegation The address to transfer delegation to.
23     */
24     function transferDelegation(address _newDelegation) public onlyOwner {
25         require(_newDelegation != address(0), "Trying to transfer to address 0");
26         emit DelegationTransferred(delegation, _newDelegation);
27         delegation = _newDelegation;
28     }
29 
30     /**
31     * @dev Allows the current owner to transfer control of the contract to a newOwner.
32     * @param _newOwner The address to transfer ownership to.
33     */
34     function transferOwnership(address _newOwner) public onlyOwner {
35         require(_newOwner != address(0), "Trying to transfer to address 0");
36         emit OwnershipTransferred(owner, _newOwner);
37         owner = _newOwner;
38     }
39 }
40 
41 contract DelegateProxy {
42 
43     constructor() public {}
44 
45     /**
46     * @dev Performs a delegatecall and returns whatever is returned (entire context execution will return!)
47     * @param _dst Destination address to perform the delegatecall
48     * @param _calldata Calldata for the delegatecall
49     */
50     function delegatedFwd(address _dst, bytes _calldata) internal {
51         assembly {
52             let result := delegatecall(sub(gas, 10000), _dst, add(_calldata, 0x20), mload(_calldata), 0, 0)
53             let size := returndatasize
54 
55             let ptr := mload(0x40)
56             returndatacopy(ptr, 0, size)
57 
58             // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.
59             // if the call returned error data, forward it
60             switch result case 0 { revert(ptr, size) }
61             default { return(ptr, size) }
62         }
63     }
64 }
65 
66 contract Proxy is Delegatable, DelegateProxy {
67 
68     constructor() public {}
69 
70     /**
71     * @dev Function to invoke all function that are implemented in controler
72     */
73     function () public {
74         require(delegation != address(0), "Delegation is address 0, not initialized");
75         delegatedFwd(delegation, msg.data);
76     }
77 
78     /**
79     * @dev Function to initialize storage of proxy
80     * @param _controller The address of the controller to load the code from
81     */
82     function initialize(address _controller, uint256) public {
83         require(owner == 0, "Already initialized");
84         owner = msg.sender;
85         delegation = _controller;
86         delegatedFwd(_controller, msg.data);
87     }
88 }