1 pragma solidity ^0.4.18;
2 
3 
4 contract DelegateProxy {
5 
6     /**
7     * @dev Performs a delegatecall and returns whatever the delegatecall returned (entire context execution will return!)
8     * @param _dst Destination address to perform the delegatecall
9     * @param _calldata Calldata for the delegatecall
10     */
11     function delegatedFwd(address _dst, bytes _calldata) internal {
12         assembly {
13             let result := delegatecall(sub(gas, 10000), _dst, add(_calldata, 0x20), mload(_calldata), 0, 0)
14             let size := returndatasize
15 
16             let ptr := mload(0x40)
17             returndatacopy(ptr, 0, size)
18 
19             // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.
20             // if the call returned error data, forward it
21             switch result case 0 { revert(ptr, size) }
22             default { return(ptr, size) }
23         }
24     }
25 }
26 
27 contract Delegatable {
28   address empty1; // unknown slot
29   address empty2; // unknown slot
30   address empty3;  // unknown slot
31   address public owner;  // matches owner slot in controller
32   address public delegation; // matches thisAddr slot in controller
33 
34   event DelegationTransferred(address indexed previousDelegate, address indexed newDelegation);
35   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37   modifier onlyOwner() {
38     require(msg.sender == owner);
39     _;
40   }
41 
42   /**
43    * @dev Allows owner to transfer delegation of the contract to a newDelegation.
44    * @param newDelegation The address to transfer delegation to.
45    */
46   function transferDelegation(address newDelegation) public onlyOwner {
47     require(newDelegation != address(0));
48     DelegationTransferred(delegation, newDelegation);
49     delegation = newDelegation;
50   }
51 
52   /**
53    * @dev Allows the current owner to transfer control of the contract to a newOwner.
54    * @param newOwner The address to transfer ownership to.
55    */
56   function transferOwnership(address newOwner) public onlyOwner {
57     require(newOwner != address(0));
58     OwnershipTransferred(owner, newOwner);
59     owner = newOwner;
60   }
61 
62 }
63 
64 /**
65  * @title Parsec
66  * Basic proxy implementation to controller
67  */
68 contract Parsec is Delegatable, DelegateProxy {
69 
70   /**
71    * @dev Function to invoke all function that are implemented in controler
72    */
73   function () public {
74     delegatedFwd(delegation, msg.data);
75   }
76 
77   /**
78    * @dev Function to initialize storage of proxy
79    * @param _controller The address of the controller to load the code from
80    * @param _cap Max amount of tokens that should be mintable
81    */
82   function initialize(address _controller, uint256 _cap) public {
83     require(owner == 0);
84     owner = msg.sender;
85     delegation = _controller;
86     delegatedFwd(_controller, msg.data);
87   }
88 
89 }