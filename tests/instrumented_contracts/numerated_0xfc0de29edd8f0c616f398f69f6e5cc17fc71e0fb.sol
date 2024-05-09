1 pragma solidity ^0.4.11;
2 
3 contract ZweiGehenReinEinerKommtRaus {
4 
5 	address public player1 = address(0);
6 	
7 	event NewPlayer(address token, uint amount);
8 	event Winner(address token, uint amount);
9 
10 	function Bet() public payable {
11 		address player = msg.sender;
12 		require(msg.value == 1 szabo );
13 		NewPlayer(player, msg.value);
14 		
15 		if( player1==address(0) ){
16 			// this is player1
17 			player1 = player;
18 		}else{
19 			// this is player2, finish the game
20 			// roll the dice
21 			uint random = now;
22 			address winner = player1;
23 			if( random/2*2 == random ){
24 				// even - player2 wins
25 				winner = player;
26 			}
27 			
28 			// clear round
29             player1=address(0);
30 
31             // the winner takes it all
32             uint amount = this.balance;
33 			winner.transfer(amount);
34 			Winner(winner, amount);
35 		}
36 	}
37 }