1 //SPDX-License-Identifier: BSD-3-Clause
2 
3 pragma solidity ^0.6.12;
4 pragma experimental ABIEncoderV2;
5 
6 import "@boringcrypto/boring-solidity/contracts/BoringOwnable.sol";
7 
8 // Modified from https://etherscan.io/address/0x6d903f6003cca6255d85cca4d3b5e5146dc33925#code and https://github.com/boringcrypto/dictator-dao/blob/main/contracts/DictatorDAO.sol#L225
9 contract MinimalTimeLock is BoringOwnable {    
10     event QueueTransaction(bytes32 indexed txHash, address indexed target, uint256 value, bytes data, uint256 eta);
11     event CancelTransaction(bytes32 indexed txHash, address indexed target, uint256 value, bytes data);
12     event ExecuteTransaction(bytes32 indexed txHash, address indexed target, uint256 value, bytes data);
13 
14     uint256 public constant GRACE_PERIOD = 14 days;
15     uint256 public constant DELAY = 2 days;
16     mapping(bytes32 => uint256) public queuedTransactions;
17 
18     function queueTransaction(
19         address target,
20         uint256 value,
21         bytes memory data
22     ) public onlyOwner returns (bytes32) {
23 
24         bytes32 txHash = keccak256(abi.encode(target, value, data));
25         uint256 eta = block.timestamp + DELAY;
26         queuedTransactions[txHash] = eta;
27 
28         emit QueueTransaction(txHash, target, value, data, eta);
29         return txHash;
30     }
31 
32     function cancelTransaction(
33         address target,
34         uint256 value,
35         bytes memory data
36     ) public onlyOwner {
37 
38         bytes32 txHash = keccak256(abi.encode(target, value, data));
39         queuedTransactions[txHash] = 0;
40 
41         emit CancelTransaction(txHash, target, value, data);
42     }
43 
44     function executeTransaction(
45         address target,
46         uint256 value,
47         bytes memory data
48     ) public onlyOwner payable returns (bytes memory) {
49 
50         bytes32 txHash = keccak256(abi.encode(target, value, data));
51         uint256 eta = queuedTransactions[txHash];
52         require(block.timestamp >= eta, "Too early");
53         require(block.timestamp <= eta + GRACE_PERIOD, "Tx stale");
54 
55         queuedTransactions[txHash] = 0;
56 
57         // solium-disable-next-line security/no-call-value
58         (bool success, bytes memory returnData) = target.call{value: value}(data);
59         require(success, "Tx reverted :(");
60 
61         emit ExecuteTransaction(txHash, target, value, data);
62 
63         return returnData;
64     }
65 }