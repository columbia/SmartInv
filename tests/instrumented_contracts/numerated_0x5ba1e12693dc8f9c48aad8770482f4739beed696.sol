1 /**
2  *Submitted for verification at Etherscan.io on 2021-03-23
3 */
4 
5 pragma solidity >=0.5.0;
6 pragma experimental ABIEncoderV2;
7 
8 /// @title Multicall2 - Aggregate results from multiple read-only function calls
9 /// @author Michael Elliot <mike@makerdao.com>
10 /// @author Joshua Levine <joshua@makerdao.com>
11 /// @author Nick Johnson <arachnid@notdot.net>
12 
13 contract Multicall2 {
14     struct Call {
15         address target;
16         bytes callData;
17     }
18     struct Result {
19         bool success;
20         bytes returnData;
21     }
22 
23     function aggregate(Call[] memory calls) public returns (uint256 blockNumber, bytes[] memory returnData) {
24         blockNumber = block.number;
25         returnData = new bytes[](calls.length);
26         for(uint256 i = 0; i < calls.length; i++) {
27             (bool success, bytes memory ret) = calls[i].target.call(calls[i].callData);
28             require(success, "Multicall aggregate: call failed");
29             returnData[i] = ret;
30         }
31     }
32     function blockAndAggregate(Call[] memory calls) public returns (uint256 blockNumber, bytes32 blockHash, Result[] memory returnData) {
33         (blockNumber, blockHash, returnData) = tryBlockAndAggregate(true, calls);
34     }
35     function getBlockHash(uint256 blockNumber) public view returns (bytes32 blockHash) {
36         blockHash = blockhash(blockNumber);
37     }
38     function getBlockNumber() public view returns (uint256 blockNumber) {
39         blockNumber = block.number;
40     }
41     function getCurrentBlockCoinbase() public view returns (address coinbase) {
42         coinbase = block.coinbase;
43     }
44     function getCurrentBlockDifficulty() public view returns (uint256 difficulty) {
45         difficulty = block.difficulty;
46     }
47     function getCurrentBlockGasLimit() public view returns (uint256 gaslimit) {
48         gaslimit = block.gaslimit;
49     }
50     function getCurrentBlockTimestamp() public view returns (uint256 timestamp) {
51         timestamp = block.timestamp;
52     }
53     function getEthBalance(address addr) public view returns (uint256 balance) {
54         balance = addr.balance;
55     }
56     function getLastBlockHash() public view returns (bytes32 blockHash) {
57         blockHash = blockhash(block.number - 1);
58     }
59     function tryAggregate(bool requireSuccess, Call[] memory calls) public returns (Result[] memory returnData) {
60         returnData = new Result[](calls.length);
61         for(uint256 i = 0; i < calls.length; i++) {
62             (bool success, bytes memory ret) = calls[i].target.call(calls[i].callData);
63 
64             if (requireSuccess) {
65                 require(success, "Multicall2 aggregate: call failed");
66             }
67 
68             returnData[i] = Result(success, ret);
69         }
70     }
71     function tryBlockAndAggregate(bool requireSuccess, Call[] memory calls) public returns (uint256 blockNumber, bytes32 blockHash, Result[] memory returnData) {
72         blockNumber = block.number;
73         blockHash = blockhash(block.number);
74         returnData = tryAggregate(requireSuccess, calls);
75     }
76 }