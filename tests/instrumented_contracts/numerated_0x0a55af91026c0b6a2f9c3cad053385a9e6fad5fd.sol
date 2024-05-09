1 pragma solidity ^0.5.0;
2 
3 contract Proxy {
4     address public owner;
5     address public target;
6 
7     event ProxyTargetSet(address target);
8     event ProxyOwnerChanged(address owner);
9 
10     constructor() public {
11         owner = msg.sender;
12     }
13 
14     /**
15    * @dev Throws if called by any account other than the owner.
16    */
17     modifier onlyOwner() {
18         require(msg.sender == owner);
19         _;
20     }
21 
22     function setTarget(address _target) public onlyOwner {
23         target = _target;
24         emit ProxyTargetSet(_target);
25     }
26 
27     function setOwner(address _owner) public onlyOwner {
28         owner = _owner;
29         emit ProxyOwnerChanged(_owner);
30     }
31 
32     function() external payable {
33         address _impl = target;
34         require(_impl != address(0));
35 
36         assembly {
37             let ptr := mload(0x40)
38             calldatacopy(ptr, 0, calldatasize)
39             let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
40             let size := returndatasize
41             returndatacopy(ptr, 0, size)
42 
43             switch result
44                 case 0 {
45                     revert(ptr, size)
46                 }
47                 default {
48                     return(ptr, size)
49                 }
50         }
51     }
52 }