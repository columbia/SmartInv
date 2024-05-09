1 pragma solidity 0.4.21;
2 
3 contract CrowdsaleProxyTarget {
4     function isActive() public returns(bool);
5     function initialize(address _owner, address _token, address _familyOwner, address _personalOwner) public;
6     address public token;
7 }
8 
9 /**
10  * The CrowdsaleProxy contract which uses crowdsale implementation deployed at
11  * target address. This constuction helps to make Crowdsale code upgradable.
12  */
13 contract CrowdsaleProxy {
14     bytes32 constant TARGET_POSITION = keccak256("CrowdsaleProxy.target");
15     bytes32 constant OWNER_POSITION = keccak256("CrowdsaleProxy.owner");
16 
17     event Upgraded(address indexed target);
18 
19     modifier _onlyProxyOwner() {
20         require(msg.sender == ___proxyOwner());
21         _;
22     }
23 
24     function CrowdsaleProxy(address _target) public {
25         require(_target != 0x0);
26         bytes32 position = OWNER_POSITION;
27         assembly { sstore(position, caller) }
28         ___setTarget(_target);
29     }
30 
31     function ___initialize(address _token, address _familyOwner, address _personalOwner) public {
32         CrowdsaleProxyTarget(this).initialize(msg.sender, _token, _familyOwner, _personalOwner);
33     }
34 
35     function () public payable {
36         address _target = ___proxyTarget();
37         assembly {
38             let ptr := mload(0x40)
39             calldatacopy(ptr, 0, calldatasize)
40             let success := delegatecall(sub(gas, 10000), _target, ptr, calldatasize, 0, 0)
41             let retSz := returndatasize
42             returndatacopy(ptr, 0, retSz)
43 
44             switch success
45             case 0 { revert(ptr, retSz) }
46             default { return(ptr, retSz) }
47         }
48     }
49 
50     function ___coinAddress() external view returns (address) {
51         return CrowdsaleProxyTarget(this).token();
52     }
53 
54     function ___isActive() internal returns (bool res) {
55         res = CrowdsaleProxyTarget(this).isActive();
56     }
57 
58     function ___proxyOwner() public view returns (address owner) {
59         bytes32 position = OWNER_POSITION;
60         assembly {
61             owner := sload(position)
62         }
63     }
64 
65     function ___setProxyOwner(address newOwner) _onlyProxyOwner public {
66         bytes32 position = OWNER_POSITION;
67         assembly {
68             sstore(position, newOwner)
69         }
70     }
71 
72     function ___proxyTarget() public view returns (address target) {
73         bytes32 position = TARGET_POSITION;
74         assembly {
75             target := sload(position)
76         }
77     }
78 
79     function ___setTarget(address target) internal {
80         bytes32 position = TARGET_POSITION;
81         assembly {
82             sstore(position, target)
83         }
84     }
85 
86     function ___upgradeTo(address newTarget) public _onlyProxyOwner {
87         require(!___isActive());
88         require(___proxyTarget() != newTarget);
89         ___setTarget(newTarget);
90         emit Upgraded(___proxyTarget());
91     }
92 
93     function ___upgradeToAndCall(address newTarget, bytes data) payable public _onlyProxyOwner {
94         ___upgradeTo(newTarget);
95         require(address(this).call.value(msg.value)(data));
96     }
97 }