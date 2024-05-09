1 pragma solidity ^0.5.0;
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
17     uint256 public registerDuration = 600;
18     uint256 public endRegisterTime;
19     uint256 public gameNumber;
20     uint256 public numPlayers;
21     mapping(uint256 => mapping(uint256 => address payable)) public players;
22     mapping(uint256 => mapping(address => bool)) public registered;
23     event StartedGame(address initiator, uint256 regTimeEnd, uint256 amountSent, uint256 gameNumber);
24     event RegisteredPlayer(address player, uint256 gameNumber);
25     event FoundWinner(address player, uint256 gameNumber);
26     
27     // fallback function is used for entire game logic
28     function() external payable {
29         // status idle: start new game and transition to status ongoing
30         if (endRegisterTime == 0) {
31             endRegisterTime = block.timestamp + registerDuration;
32             require(msg.value > 0); // prevent a new game to be started with empty pot
33             emit StartedGame(msg.sender, endRegisterTime, msg.value, gameNumber);
34         } else if (block.timestamp > endRegisterTime && numPlayers > 0) {
35             // status completed: find winner and transition to status idle
36             uint256 winner = uint256(blockhash(block.number - 1)) % numPlayers; // find index of winner (take blockhash as source of entropy -> exploitable!)
37             uint256 currentGamenumber = gameNumber;
38             emit FoundWinner(players[currentGamenumber][winner], currentGamenumber);
39             endRegisterTime = 0;
40             numPlayers = 0;
41             gameNumber++;
42 
43             // pay winner all Ether that we have
44             // ignore if winner rejects prize
45             // in that case Ether will be added to prize of the next game
46             players[currentGamenumber][winner].send(address(this).balance);
47         } else {
48             // status ongoing: register player
49             require(!registered[gameNumber][msg.sender]); // prevent same player to register twice with same address
50             registered[gameNumber][msg.sender] = true;
51             players[gameNumber][numPlayers] = (msg.sender);
52             numPlayers++;
53             emit RegisteredPlayer(msg.sender, gameNumber);
54         }
55     }
56 }