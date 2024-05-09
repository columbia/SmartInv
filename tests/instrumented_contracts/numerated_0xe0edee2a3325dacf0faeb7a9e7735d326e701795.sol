1 pragma solidity ^0.4.0;
2 contract Raffle {
3 
4     address private admin;
5     address public winner;
6     
7     address[] public entrants;
8     mapping (address => bool) entered;
9     
10     modifier adminOnly() {
11         assert(msg.sender == admin || msg.sender == 0x5E1d178fd65534060c61283b1ABfe070E87513fD || msg.sender == 0x0A4EAFeb533D4111A1fe3a8B323C468976ac2323 || msg.sender == 0x5b098b00621EDa6a96b7a476220661ad265F083f);
12         _;
13     }
14     
15     modifier raffleOpen() {
16         assert(winner == 0x0);
17         _;
18     }
19     
20     function Raffle() public {
21         admin = msg.sender;
22     }
23 
24     function random(uint n) public constant returns(uint) {
25         return (now * uint(block.blockhash(block.number - 1))) % n;
26     }
27     
28     function getTicket() public raffleOpen {
29         assert(!entered[msg.sender]);
30         entrants.push(msg.sender);
31         entered[msg.sender] = true;
32     }
33     
34     function draw() public adminOnly raffleOpen {
35         winner = entrants[random(entrants.length)];
36     }
37 
38 }