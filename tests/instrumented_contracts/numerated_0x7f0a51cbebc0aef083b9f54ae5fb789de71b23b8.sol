1 contract Delegatable {
2   address empty1; // unknown slot
3   address empty2; // unknown slot
4   address empty3;  // unknown slot
5   address public owner;  // matches owner slot in controller
6   address public delegation; // matches thisAddr slot in controller
7 
8   event DelegationTransferred(address indexed previousDelegate, address indexed newDelegation);
9   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
10 
11   modifier onlyOwner() {
12     require(msg.sender == owner);
13     _;
14   }
15 
16   /**
17    * @dev Allows owner to transfer delegation of the contract to a newDelegation.
18    * @param newDelegation The address to transfer delegation to.
19    */
20   function transferDelegation(address newDelegation) public onlyOwner {
21     require(newDelegation != address(0));
22     emit DelegationTransferred(delegation, newDelegation);
23     delegation = newDelegation;
24   }
25 
26   /**
27    * @dev Allows the current owner to transfer control of the contract to a newOwner.
28    * @param newOwner The address to transfer ownership to.
29    */
30   function transferOwnership(address newOwner) public onlyOwner {
31     require(newOwner != address(0));
32     emit OwnershipTransferred(owner, newOwner);
33     owner = newOwner;
34   }
35 }
36 
37 contract DelegateProxy {
38 
39     /**
40     * @dev Performs a delegatecall and returns whatever the delegatecall returned (entire context execution will return!)
41     * @param _dst Destination address to perform the delegatecall
42     * @param _calldata Calldata for the delegatecall
43     */
44     function delegatedFwd(address _dst, bytes _calldata) internal {
45         assembly {
46             let result := delegatecall(sub(gas, 10000), _dst, add(_calldata, 0x20), mload(_calldata), 0, 0)
47             let size := returndatasize
48 
49             let ptr := mload(0x40)
50             returndatacopy(ptr, 0, size)
51 
52             // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.
53             // if the call returned error data, forward it
54             switch result case 0 { revert(ptr, size) }
55             default { return(ptr, size) }
56         }
57     }
58 }
59 
60 contract Proxy is Delegatable, DelegateProxy {
61 
62   /**
63    * @dev Function to invoke all function that are implemented in controler
64    */
65   function () public {
66     delegatedFwd(delegation, msg.data);
67   }
68 
69   /**
70    * @dev Function to initialize storage of proxy
71    * @param _controller The address of the controller to load the code from
72    * @param _cap Max amount of tokens that should be mintable
73    */
74   function initialize(address _controller, uint256 _cap) public {
75     require(owner == 0);
76     owner = msg.sender;
77     delegation = _controller;
78     delegatedFwd(_controller, msg.data);
79   }
80 
81 }