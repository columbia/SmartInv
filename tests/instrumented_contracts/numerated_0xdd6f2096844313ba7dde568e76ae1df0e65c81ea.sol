1 pragma solidity >=0.5.1 <0.6.0;
2 
3 contract crossword_reward {
4     bytes32 solution_hash;
5     
6     // Contract constructor
7     constructor () public {
8         solution_hash = 0x2d64478620cf2836ecf1a6ef9ec90e5a540899939c5e411ae44656ddadc6081e;
9     }
10     
11     // Claim the reward
12     function claim(bytes20 solution, bytes32 salt) public {
13         require(keccak256(abi.encodePacked(solution, salt)) == solution_hash, "Mauvaise solution ou mauvais sel.");
14         msg.sender.transfer(address(this).balance);
15     }
16     
17     // Accept any incoming amount
18     function () external payable {}
19 }