1 pragma solidity 0.4.23;
2 
3 /*
4  * Ownable
5  *
6  * Base contract with an owner.
7  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
8  */
9 contract Ownable {
10   address public owner;
11 
12   function Ownable() public {
13     owner = msg.sender;
14   }
15 
16   modifier onlyOwner() {
17     require(msg.sender == owner);
18 
19     _;
20   }
21 
22   function transferOwnership(address newOwner) onlyOwner public {
23     if (newOwner != address(0)) {
24       owner = newOwner;
25     }
26   }
27 
28 }
29 
30 contract Proxied is Ownable {
31     address public target;
32     mapping (address => bool) public initialized;
33 
34     event EventUpgrade(address indexed newTarget, address indexed oldTarget, address indexed admin);
35     event EventInitialized(address indexed target);
36 
37     function upgradeTo(address _target) public;
38 }
39 
40 contract Proxy is Proxied {
41     /*
42      * @notice Constructor sets the target and emmits an event with the first target
43      * @param _target - The target Upgradeable contracts address
44      */
45     constructor(address _target) public {
46         upgradeTo(_target);
47     }
48 
49     /*
50      * @notice Upgrades the contract to a different target that has a changed logic. Can only be called by owner
51      * @dev See https://github.com/jackandtheblockstalk/upgradeable-proxy for what can and cannot be done in Upgradeable
52      * contracts
53      * @param _target - The target Upgradeable contracts address
54      */
55     function upgradeTo(address _target) public onlyOwner {
56         assert(target != _target);
57 
58         address oldTarget = target;
59         target = _target;
60 
61         emit EventUpgrade(_target, oldTarget, msg.sender);
62     }
63 
64     /*
65      * @notice Performs an upgrade and then executes a transaction. Intended use to upgrade and initialize atomically
66      */
67     function upgradeTo(address _target, bytes _data) public onlyOwner {
68         upgradeTo(_target);
69         assert(target.delegatecall(_data));
70     }
71 
72     /*
73      * @notice Fallback function that will execute code from the target contract to process a function call.
74      * @dev Will use the delegatecall opcode to retain the current state of the Proxy contract and use the logic
75      * from the target contract to process it.
76      */
77     function () payable public {
78         bytes memory data = msg.data;
79         address impl = target;
80 
81         assembly {
82             let result := delegatecall(gas, impl, add(data, 0x20), mload(data), 0, 0)
83             let size := returndatasize
84 
85             let ptr := mload(0x40)
86             returndatacopy(ptr, 0, size)
87 
88             switch result
89             case 0 { revert(ptr, size) }
90             default { return(ptr, size) }
91         }
92     }
93 }