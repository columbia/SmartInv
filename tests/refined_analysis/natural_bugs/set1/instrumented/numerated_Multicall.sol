1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.1;
3 
4 contract Multicall {
5     struct Call {
6         address target;
7         bytes callData;
8     }
9     struct Result {
10         bool success;
11         bytes returnData;
12     }
13 
14     function tryAggregate(bool requireSuccess, Call[] memory calls) public returns (Result[] memory returnData) {
15         returnData = new Result[](calls.length);
16         for(uint256 i = 0; i < calls.length; i++) {
17             (bool success, bytes memory ret) = calls[i].target.call(calls[i].callData);
18 
19             if (requireSuccess) {
20                 require(success, "Multicall aggregate: call failed");
21             }
22 
23             returnData[i] = Result(success, ret);
24         }
25     }
26 }