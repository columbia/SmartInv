1 pragma solidity ^0.4.24;
2 
3 contract MultiEthSender {
4     
5     event Send(uint256 _amount, address indexed _receiver);
6     
7     constructor() payable public {
8         
9     }
10     
11     function multiSendEth(uint256 amount, address[] list) public payable returns (bool) {
12         uint balanceBeforeTransfer = address(this).balance;
13         
14         for(uint i=0;i<list.length;i++){
15             list[i].transfer(amount);
16             emit Send(amount, list[i]);
17         }
18         assert(address(this).balance == balanceBeforeTransfer - amount*list.length);
19         return true;
20     }
21     
22     function getBalance() constant public returns(uint){
23         return address(this).balance;
24     }
25     
26     function() public payable{
27         
28     }
29     
30 }