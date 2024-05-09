1 pragma solidity ^0.4.5;
2 
3 /*
4  * This is an example gambling contract that works without any ABI interface.
5  * The entire game logic is invoked by calling the fallback function which
6  * is triggered, e.g. upon receiving a transaction at the contract address
7  * without any data sent along. The contract is attackable in a number of ways:
8  * - as soon as someone paid in Ether and starts the game, register with a
9  *   large number of addresses to spam the player list and most likely win.
10  * - blockhash as source of entropy is attackable by miners
11  * - probably further exploits
12  * This only serves as a minimalistic example of how to gamble on Ethereum
13  * Author: S.C. Buergel for Validity Labs AG
14  */
15 
16 contract dgame {
17   uint registerDuration;
18   uint endRegisterTime;
19   address[] players;
20   string debug;
21 
22   // constructor sets default registration duration to 180s
23   function dgame() {
24     registerDuration = 180;
25   }
26 
27   // fallback function is used to register players and pay winner
28   function () payable {
29     if (players.length == 0)
30       endRegisterTime = now + registerDuration;
31     if (now > endRegisterTime && players.length > 0) {
32       // find index of winner (take blockhash as source of entropy -> exploitable!)
33       uint winner = uint(block.blockhash(block.number - 1)) % players.length;
34       
35       // pay winner all Ether that we have
36       // ignore if winner rejects prize
37       // in that case Ether will be added to prize of the next game
38       players[winner].send(this.balance);
39       
40       // delete all players to allow for a next game
41       delete players;
42     }
43     else
44       players.push(msg.sender);
45   }
46   
47 }