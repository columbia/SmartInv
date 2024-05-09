1 pragma solidity 0.5.3;
2 pragma experimental ABIEncoderV2;
3 
4 contract TransactionBatcher {
5     function batchSend(address[] memory targets, uint[] memory values, bytes[] memory datas) public payable {
6         for (uint i = 0; i < targets.length; i++)
7             targets[i].call.value(values[i])(datas[i]);
8     }
9 }