1 pragma solidity ^0.4.18;
2 
3 // File: contracts/library/Ownable.sol
4 
5 /*
6  * Ownable
7  *
8  * Base contract with an owner.
9  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
10  */
11 contract Ownable {
12   address public owner;
13 
14   function Ownable() public {
15     owner = msg.sender;
16   }
17 
18   modifier onlyOwner() {
19     require(msg.sender == owner);
20 
21     _;
22   }
23 
24   function transferOwnership(address newOwner) onlyOwner public {
25     if (newOwner != address(0)) {
26       owner = newOwner;
27     }
28   }
29 
30 }
31 
32 // File: contracts/library/upgradeable/Proxied.sol
33 
34 contract Proxied is Ownable {
35     address public target;
36     mapping (address => bool) public initialized;
37 
38     event EventUpgrade(address indexed newTarget, address indexed oldTarget, address indexed admin);
39     event EventInitialized(address indexed target);
40 
41     function upgradeTo(address _target) public;
42 }
43 
44 // File: contracts/library/upgradeable/Proxy.sol
45 
46 contract Proxy is Proxied {
47     /*
48      * @notice Constructor sets the target and emmits an event with the first target
49      * @param _target - The target Upgradeable contracts address
50      */
51     constructor(address _target) public {
52         upgradeTo(_target);
53     }
54 
55     /*
56      * @notice Upgrades the contract to a different target that has a changed logic. Can only be called by owner
57      * @dev See https://github.com/jackandtheblockstalk/upgradeable-proxy for what can and cannot be done in Upgradeable
58      * contracts
59      * @param _target - The target Upgradeable contracts address
60      */
61     function upgradeTo(address _target) public onlyOwner {
62         assert(target != _target);
63 
64         address oldTarget = target;
65         target = _target;
66 
67         emit EventUpgrade(_target, oldTarget, msg.sender);
68     }
69 
70     /*
71      * @notice Performs an upgrade and then executes a transaction. Intended use to upgrade and initialize atomically
72      */
73     function upgradeTo(address _target, bytes _data) public onlyOwner {
74         upgradeTo(_target);
75         assert(target.delegatecall(_data));
76     }
77 
78     /*
79      * @notice Fallback function that will execute code from the target contract to process a function call.
80      * @dev Will use the delegatecall opcode to retain the current state of the Proxy contract and use the logic
81      * from the target contract to process it.
82      */
83     function () payable public {
84         bytes memory data = msg.data;
85         address impl = target;
86 
87         assembly {
88             let result := delegatecall(gas, impl, add(data, 0x20), mload(data), 0, 0)
89             let size := returndatasize
90 
91             let ptr := mload(0x40)
92             returndatacopy(ptr, 0, size)
93 
94             switch result
95             case 0 { revert(ptr, size) }
96             default { return(ptr, size) }
97         }
98     }
99 }