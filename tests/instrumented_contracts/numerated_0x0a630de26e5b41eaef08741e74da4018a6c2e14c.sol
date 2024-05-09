1 pragma solidity ^0.4.10;
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
17     uint public registerDuration;
18     uint public endRegisterTime;
19     uint public gameNumber;
20     uint public numPlayers;
21     mapping(uint => mapping(uint => address)) public players;
22     mapping(uint => mapping(address => bool)) public registered;
23     event StartedGame(address initiator, uint regTimeEnd, uint amountSent, uint gameNumber);
24     event RegisteredPlayer(address player, uint gameNumber);
25     event FoundWinner(address player, uint gameNumber);
26     
27     // constructor sets default registration duration to 5min
28     function dgame() {
29         registerDuration = 600;
30     }
31     
32     // fallback function is used for entire game logic
33     function() payable {
34         // status idle: start new game and transition to status ongoing
35         if (endRegisterTime == 0) {
36             endRegisterTime = now + registerDuration;
37             if (msg.value == 0)
38                 throw;  // prevent a new game to be started with empty pot
39             StartedGame(msg.sender, endRegisterTime, msg.value, gameNumber);
40         } else if (now > endRegisterTime && numPlayers > 0) {
41             // status completed: find winner and transition to status idle
42             uint winner = uint(block.blockhash(block.number - 1)) % numPlayers; // find index of winner (take blockhash as source of entropy -> exploitable!)
43             uint currentGamenumber = gameNumber;
44             FoundWinner(players[currentGamenumber][winner], currentGamenumber);
45             endRegisterTime = 0;
46             numPlayers = 0;
47             gameNumber++;
48 
49             // pay winner all Ether that we have
50             // ignore if winner rejects prize
51             // in that case Ether will be added to prize of the next game
52             players[currentGamenumber][winner].send(this.balance);
53         } else {
54             // status ongoing: register player
55             if (registered[gameNumber][msg.sender])
56                 throw;  // prevent same player to register twice with same address
57             registered[gameNumber][msg.sender] = true;
58             players[gameNumber][numPlayers] = (msg.sender);
59             numPlayers++;
60             RegisteredPlayer(msg.sender, gameNumber);
61         }
62     }
63 }