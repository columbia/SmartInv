1 pragma solidity >=0.4.22 <0.6.0;
2 
3 /*
4 * EthCC Playing Cards
5 * Well done, Yes! there was a smart contract address hidden in the game. 
6 * The good news is that you can leave your nickname to say "I was there". 
7 * The bad news is that there is nothing to gain except the pleasure of participating :)
8 */
9 
10 contract EthCCPlayingCards {
11 
12     mapping (address => bool) public addressFound;
13 
14     event LogAddressFound(address indexed whoAddress, bytes32 whoName);
15 
16     function addressFoundBy(bytes32 name) public {
17         addressFound[msg.sender] = true;
18         emit LogAddressFound(msg.sender, name);
19     }
20 }