1 pragma solidity ^0.5.0;
2 //import 'openzeppelin-solidity/contracts/token/ERC20/ERC20.sol';
3 
4 
5 contract zeroXWrapper {
6     
7     event forwarderCall (bool success);
8 
9     function zeroXSwap (address to, address forwarder, bytes memory args) public payable{
10     	(bool success, bytes memory returnData) = forwarder.call.value(msg.value)(args);
11     	emit forwarderCall(success);
12     }
13 
14     function () external payable {
15         
16     }
17 
18 }