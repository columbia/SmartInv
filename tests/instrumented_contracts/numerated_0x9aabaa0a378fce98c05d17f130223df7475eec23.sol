1 pragma solidity ^0.4.18;
2 
3 contract Quicketh {
4    // Bet 0.001 ETH.
5    // Get a 10% change to win 0.008
6    address public owner;                            // Who's the boss?
7    uint public players;                             // How many are playing?
8    address[] public playedWallets;                  // These can win
9    address[] public winners;                        // These have won
10    uint playPrice = 0.001 * 1000000000000000000;    // 0.001 ETH
11    uint public rounds;                              // How long have we been going?
12 
13    event WinnerWinnerChickenDinner(address winner, uint amount);
14    event AnotherPlayer(address player);
15 
16 
17    function Quicketh() public payable{
18        owner = msg.sender;
19        players = 0;
20        rounds = 0;
21    }
22    function play()  payable public{
23        require (msg.value == playPrice);
24        playedWallets.push(msg.sender);
25        players += 1;
26        AnotherPlayer(msg.sender);
27        if (players > 9){
28            uint random_number = uint(block.blockhash(block.number-1))%10 + 1;    // Get random winner
29            winners.push(playedWallets[random_number]);                           // Add to winner list
30            playedWallets[random_number].transfer(8*playPrice);                   // Send price to winner
31            WinnerWinnerChickenDinner(playedWallets[random_number], 8*playPrice); // Notify the world
32            owner.transfer(this.balance);                                         // Let's get the profits :)
33            rounds += 1;                                                          // See how long we've been going
34            players = 0;                                                          // reset players
35            delete playedWallets;                                                 // get rid of the player addresses
36        }
37    }
38 }