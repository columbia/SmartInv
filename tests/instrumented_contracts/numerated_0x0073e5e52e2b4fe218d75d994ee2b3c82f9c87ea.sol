1 pragma solidity ^0.4.21;
2 
3 contract Proxy{
4   address public owner;
5   address public target;
6   event ProxyTargetSet(address target);
7   constructor () public{
8     owner = msg.sender;
9     }
10 
11   /**
12    * @dev Throws if called by any account other than the owner.
13    */
14   modifier onlyOwner() {
15     require(msg.sender == owner);
16     _;
17   }
18 
19   function setTarget(address _target) public onlyOwner {
20     target = _target;
21     emit ProxyTargetSet(_target);
22   }
23 
24   function () payable public {
25     address _impl = target;
26     require(_impl != address(0));
27 
28     assembly {
29       let ptr := mload(0x40)
30       calldatacopy(ptr, 0, calldatasize)
31       let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
32       let size := returndatasize
33       returndatacopy(ptr, 0, size)
34 
35       switch result
36       case 0 { revert(ptr, size) }
37       default { return(ptr, size) }
38     }
39   }
40 }