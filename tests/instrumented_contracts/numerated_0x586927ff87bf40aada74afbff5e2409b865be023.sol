1 pragma solidity ^0.4.23;
2 
3 contract HashBet {
4     
5     constructor() public {}
6     
7     event Result(uint256 hashVal, uint16 result);
8     mapping( address => Bet ) bets;
9     
10     struct Bet {
11         uint value;
12         uint height;
13     }
14     
15     function() payable public {} // Sorry not sorry
16     
17     function makeBet() payable public {
18         require( bets[msg.sender].height == 0 && msg.value > 10000 );
19         Bet newBet = bets[msg.sender];
20         newBet.value = msg.value;
21         newBet.height = block.number;
22     }
23     
24     function resolveBet() public {
25         Bet bet = bets[msg.sender];
26         uint dist = block.number - bet.height;
27         require( dist < 255 && dist > 3 );
28         bytes32 h1 = block.blockhash(bet.height);
29         bytes32 h2 = block.blockhash(bet.height+3);
30         uint256 hashVal = uint256( keccak256(h1,h2) );
31         uint256 FACTOR = 115792089237316195423570985008687907853269984665640564039457584007913129640; // ceil(2^256 / 1000)
32         uint16 result = uint16((hashVal / FACTOR)) % 1000;
33         bet.height = 0;
34         if( result <= 495 ) { //49.5% chance of winning???
35             msg.sender.transfer(address(this).balance);
36         }
37         
38         emit Result(hashVal, result);
39     }
40 }