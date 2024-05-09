1 pragma solidity ^0.4.24;
2 
3 contract HashChain {
4     event Iteration(
5         address indexed sender,
6         uint256 counter,
7         bytes32 hash,
8         string message
9     );
10     uint256 counter;
11     bytes32 hash;
12     
13     constructor(string _msg) public {
14         hash = keccak256(
15             abi.encodePacked(counter, msg.sender, _msg)
16         );
17     }
18     
19     function iterate(string _msg) public returns (uint256, bytes32) {
20         counter = ++counter;
21         hash = keccak256(
22             abi.encodePacked(hash, counter, msg.sender, _msg)
23         );
24         emit Iteration(msg.sender, counter, hash, _msg);
25         return (counter, hash);
26     }
27     
28     function getCounter() public view returns (uint256) {
29         return counter;
30     }
31     
32     function getHash() public view returns (bytes32) {
33         return hash;
34     }
35     
36     function getState() public view returns (uint256, bytes32) {
37         return (getCounter(), getHash());
38     }
39 }