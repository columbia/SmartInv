1 pragma solidity ^0.4.21;
2 
3 contract Proxy{
4   address public owner;
5   address public target;
6   event ProxyTargetSet(address target);
7   event ProxyOwnerChanged(address _owner);
8 
9   constructor () public{
10     owner = msg.sender;
11   }
12 
13   /**
14    * @dev Throws if called by any account other than the owner.
15    */
16   modifier onlyOwner() {
17     require(msg.sender == owner);
18     _;
19   }
20 
21   function setTarget(address _target) public onlyOwner {
22     target = _target;
23     emit ProxyTargetSet(_target);
24   }
25 
26   function setOwner(address _owner) public onlyOwner {
27     owner = _owner;
28     emit ProxyOwnerChanged(_owner);
29   }
30 
31   function () payable public {
32     address _impl = target;
33     require(_impl != address(0));
34 
35     assembly {
36       let ptr := mload(0x40)
37       calldatacopy(ptr, 0, calldatasize)
38       let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
39       let size := returndatasize
40       returndatacopy(ptr, 0, size)
41 
42       switch result
43       case 0 { revert(ptr, size) }
44       default { return(ptr, size) }
45     }
46   }
47 }