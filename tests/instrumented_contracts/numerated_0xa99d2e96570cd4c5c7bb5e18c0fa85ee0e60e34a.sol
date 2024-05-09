1 pragma solidity ^0.4.23;
2 
3 contract Owned {
4     address public owner;
5     constructor() public {
6         owner = msg.sender;
7     }
8 
9     modifier onlyOwner {
10         require(msg.sender == owner);
11         _;
12     }
13 
14     function transferOwnership(address newOwner) onlyOwner public {
15         owner = newOwner;
16     }
17 }
18 
19 contract LghTransferTool is Owned {
20     
21     function batchTransfer256(address tokenAddress,address _from,address[] _tos, uint256[] _value) onlyOwner public returns (bool){
22         require(_tos.length > 0);
23         bytes4 id=bytes4(keccak256("transferFrom(address,address,uint256)"));
24         for(uint i=0;i<_tos.length;i++){
25             if(!tokenAddress.call(id,_from,_tos[i],_value[i])){
26                 break;
27             }
28         }
29         return true;
30     }
31     
32 }