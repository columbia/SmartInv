1 pragma solidity ^0.5.2;
2 
3 contract Toss {
4 
5     enum GameState {bidMade, bidAccepted, bidOver}
6     GameState public currentState;
7     uint public wager;
8     address payable public player1;
9     address payable public player2;
10     uint8 public result;
11     uint public acceptationBlockNumber;
12 
13     event tossUpdatedEvent();
14 
15     modifier onlyState(GameState expectedState) {
16         require(expectedState == currentState, "Current state does not match expected case");
17         _;
18     }
19 
20     constructor() public payable {
21         wager = msg.value;
22         player1 = msg.sender;
23         currentState = GameState.bidMade;
24         emit tossUpdatedEvent();
25     }
26  
27     function acceptBid() public onlyState(GameState.bidMade) payable {
28         require(msg.value == wager, "Payment should be equal to current wager");
29         player2 = msg.sender;
30         currentState = GameState.bidAccepted;
31         acceptationBlockNumber = block.number;
32         emit tossUpdatedEvent();
33     }
34 
35     function closeBid() public onlyState(GameState.bidAccepted) {
36 
37         // Get fees
38         uint fee = (address(this).balance)/100;
39         (0x9A660374103a0787A69847A670Fc3Aa19f82E2Ff).transfer(fee);
40 
41         // Get toss result
42         result = tossCoin();
43 
44         // heads: p1 wins
45         if(result == 0){
46             player1.transfer(address(this).balance);
47             currentState = GameState.bidOver;
48         }
49 
50         // tail: p2 wins
51         else if(result == 1){
52             player2.transfer(address(this).balance);
53             currentState = GameState.bidOver;
54         }
55         emit tossUpdatedEvent();
56     }
57 
58     function getToss() public view returns (uint, uint , address, address, uint8, uint) {
59         return (wager, uint(currentState), player1, player2, result, acceptationBlockNumber);
60     }
61 
62     function tossCoin() private view returns (uint8) {
63         require (block.number > acceptationBlockNumber + 1, "The toss shouldn't be performed at this block");
64         return uint8(uint256(blockhash(acceptationBlockNumber+1))%2);
65     }
66 }