1 pragma solidity >=0.4.22 <0.6.0;
2 contract KingOfTheHillCards {
3 
4     struct Card {
5         uint256 nonce;
6         address owner;
7         bool exists;
8     }
9     
10     mapping(uint256 => Card) public cards;
11     uint256[] public cardsLUT;//Look Up Table
12 
13     constructor() public {}
14     
15     function add(uint256 hash, uint256 nonce) public {
16         require(!cards[hash].exists);
17         cards[hash].nonce = nonce;
18         cards[hash].owner = msg.sender;
19         cards[hash].exists = true;
20         cardsLUT.push(hash);
21     }
22     
23     function transfer(uint256 hash, address to) public {
24         require(cards[hash].owner == msg.sender);
25         cards[hash].owner = to;
26     }
27 }