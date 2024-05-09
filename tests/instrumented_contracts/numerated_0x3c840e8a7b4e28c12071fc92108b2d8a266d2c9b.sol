1 pragma solidity 0.5.7;
2 
3 interface IHumanityRegistry {
4     function isHuman(address who) external view returns (bool);
5 }
6 
7 
8 // What is the name of the virtual reality world in Neal Stephenson's 1992 novel Snow Crash?
9 contract Question {
10 
11     IHumanityRegistry public registry;
12     bytes32 public answerHash = 0x3f071a4c8c4762d45888fda3b7ff73f3d32dac78fd7b374266dec429dfabdfa8;
13 
14     constructor(IHumanityRegistry _registry) public payable {
15         registry = _registry;
16     }
17 
18     function answer(string memory response) public {
19         require(registry.isHuman(msg.sender), "Question::answer: Only humans can answer");
20 
21         if (keccak256(abi.encode(response)) == answerHash) {
22             selfdestruct(msg.sender);
23         } else {
24             revert("Question::answer: Incorrect response");
25         }
26     }
27 
28 }