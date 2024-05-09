1 pragma solidity 0.5.8;
2 
3 interface RouterInterface {
4     function getPrototype() external view returns(address);
5     function updateVersion(address _newPrototype) external returns(bool);
6 }
7 
8 contract Resolver {
9     address internal constant PLACEHOLDER = 0x72C27736aEc97394fb499ed069772F53C5ef47b4;
10 
11     function () external payable {
12         address prototype = RouterInterface(PLACEHOLDER).getPrototype();
13         assembly {
14             let calldatastart := 0
15             calldatacopy(calldatastart, 0, calldatasize)
16             let res := delegatecall(gas, prototype, calldatastart, calldatasize, 0, 0)
17             let returndatastart := 0
18             returndatacopy(returndatastart, 0, returndatasize)
19             switch res case 0 { revert(returndatastart, returndatasize) }
20                 default { return(returndatastart, returndatasize) }
21         }
22     }
23 }