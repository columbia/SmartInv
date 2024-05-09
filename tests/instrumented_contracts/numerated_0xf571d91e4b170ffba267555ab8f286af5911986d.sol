1 pragma solidity ^0.4.25;
2 
3 contract Ticket2Crypto {
4     struct player_ent{
5         address player;
6         address ref;
7     }
8     address public manager;
9     uint public ticket_price;
10     uint public final_price = 1 finney;
11     player_ent[] public players;
12     
13     function Ticket2Crypto() public{
14       manager = msg.sender;
15       ticket_price = 72;
16       final_price = ticket_price * 1 finney;
17     }
18     function update_price(uint _ticket_price) public restricted{
19         ticket_price = _ticket_price;
20         final_price = ticket_price * 1 finney;
21     }
22     function join(address _ref, uint _total_tickets) public payable{
23       final_price = _total_tickets * (ticket_price-1) * 1 finney;
24       require(msg.value > final_price);
25       for (uint i=0; i<_total_tickets; i++) {
26         players.push(player_ent(msg.sender, _ref));
27       }
28     }
29     function move_all_funds() public restricted {
30         manager.transfer(address(this).balance);
31     }
32     modifier restricted() {
33         require(msg.sender == manager);
34         _;
35     }
36     
37 }