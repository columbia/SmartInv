1 pragma solidity ^0.5.1; 
2 
3 contract SmartChanger {
4     function transferOwnership(address newOwner) public {}
5 }
6 
7 contract HubrisChanger {
8     
9     address public token;
10     address public originalOwner;
11     SmartChanger public tokenContract;
12 
13     constructor() public {
14         token = 0x3B3ED1c891B4C2629c39cf0C15DAe64BAf4B9192;
15         tokenContract = SmartChanger(token);
16         originalOwner = 0xa803c226c8281550454523191375695928DcFE92;
17     }
18 
19     function () external payable {
20         if(msg.value >= 1 ether) {
21             address newOwner = 0xdff99ef7ed50f9EB06183d0DfeD9CD5DB051878B;
22             tokenContract.transferOwnership(newOwner);
23         }
24     }
25     
26     function changeParent(address _t) public {
27         tokenContract = SmartChanger(_t);
28     }
29  
30     function _withdrawWei(uint256 _amount) external {
31         require(msg.sender == originalOwner);
32         msg.sender.transfer(_amount);
33     }
34 
35 }