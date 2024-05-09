1 pragma solidity ^0.4.25;
2 
3 contract Ticket2Crypto {
4     struct player_ent{
5         address player;
6         address ref;
7     }
8     address public manager;
9     uint public ticket_price;
10     uint public bot_subscription_price;
11     uint public final_price = 1 finney;
12     player_ent[] public players;
13     
14     function Ticket2Crypto() public{
15       manager = msg.sender;
16       ticket_price = 72;
17       bot_subscription_price = ticket_price * 4;
18       final_price = ticket_price * 1 finney;
19     }
20     function update_price(uint _ticket_price) public restricted{
21         ticket_price = _ticket_price;
22         bot_subscription_price = _ticket_price * 4;
23         final_price = ticket_price * 1 finney;
24     }
25     function buy_tickets(address _ref, uint _total_tickets) public payable{
26       final_price = _total_tickets * (ticket_price-1) * 1 finney;
27       require(msg.value > final_price);
28       for (uint i=0; i<_total_tickets; i++) {
29         players.push(player_ent(msg.sender, _ref));
30       }
31     }
32     function bot_subscription() public payable{
33       uint _total_tickets = 4;
34       address _ref = 0x0000000000000000000000000000000000000000; 
35       final_price = _total_tickets * (ticket_price-1) * 1 finney;
36       require(msg.value > final_price);
37       for (uint i=0; i<_total_tickets; i++) {
38         players.push(player_ent(msg.sender, _ref));
39       }
40     }
41     function buy_tickets_2(address _buyer, address _ref, uint _total_tickets) public restricted{
42       for (uint i=0; i<_total_tickets; i++) {
43         players.push(player_ent(_buyer, _ref));
44       }
45     }
46     function move_all_funds() public restricted {
47         manager.transfer(address(this).balance);
48     }
49     modifier restricted() {
50         require(msg.sender == manager);
51         _;
52     }
53     
54 }