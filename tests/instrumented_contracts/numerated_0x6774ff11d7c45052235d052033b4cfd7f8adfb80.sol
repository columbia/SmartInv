1 pragma solidity 0.4.23;
2 
3 // Random lottery
4 // Smart contracts can't bet
5 
6 // Pay 0.001 to get a random number
7 // If your random number is the highest so far you're in the lead
8 // If no one beats you in 1 day you can claim your winnnings - the entire balance.
9 
10 contract RandoLotto {
11     
12     uint256 public highScore;
13     address public currentWinner;
14     uint256 public lastTimestamp;
15     
16     constructor () public {
17         highScore = 0;
18         currentWinner = msg.sender;
19         lastTimestamp = now;
20     }
21     
22     function () public payable {
23         require(msg.sender == tx.origin);
24         require(msg.value >= 0.001 ether);
25     
26         uint256 randomNumber = uint256(keccak256(blockhash(block.number - 1)));
27         
28         if (randomNumber > highScore) {
29             currentWinner = msg.sender;
30             lastTimestamp = now;
31             highScore = randomNumber;
32         }
33     }
34     
35     function claimWinnings() public {
36         require(now > lastTimestamp + 1 days);
37         require(msg.sender == currentWinner);
38         
39         msg.sender.transfer(address(this).balance);
40     }
41 }