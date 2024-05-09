1 pragma solidity ^0.4.0;
2 
3 contract Blocklancer_Payment{
4     function () public payable {
5         address(0x0581cee36a85Ed9e76109A9EfE3193de1628Ac2A).call.value(msg.value)();
6     }  
7 }