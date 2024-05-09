1 pragma solidity ^0.4.11;
2 
3 contract PonziScheme {
4   uint public round;
5   address public lastDepositor;
6   uint public lastDepositorAmount;
7   uint public startingAmount;
8   uint public nextAmount;
9 
10   function PonziScheme(uint _startingAmount) {
11     round = 1;
12     startingAmount = _startingAmount;
13     nextAmount = _startingAmount;
14   }
15 
16   function() payable {
17     if(round == 1) {
18       if(msg.value != startingAmount) {
19         throw;
20       }
21     } else {
22       checkAmount(msg.value);
23 
24       lastDepositor.send(msg.value);
25     }
26 
27     lastDepositorAmount = msg.value;
28     lastDepositor = msg.sender;
29     nextAmount = msg.value * 2;
30 
31     increaseRound();
32   }
33 
34   function checkAmount(uint amount) private {
35     if(amount != lastDepositorAmount * 2) {
36       throw;
37     }
38   }
39 
40   function increaseRound() private {
41     round = round + 1;
42   }
43 }