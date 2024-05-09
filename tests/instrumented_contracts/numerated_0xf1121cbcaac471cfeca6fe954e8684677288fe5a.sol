1 pragma solidity ^0.4.22;
2 
3 contract GiftBox {
4 	address public owner;
5 	uint256 public gift;
6 	uint16[7] public gifts;
7 	mapping(address=>address) public friends;
8 	event GiftSent(address indexed gifter);
9 	modifier onlyOwner() {
10       if (msg.sender!=owner) revert();
11       _;
12     }
13     
14     constructor() public{
15         owner = msg.sender;
16         gifts = [49,7,7,7,7,7,7];
17         gift = 100000000000000000;
18     }
19     
20     function transferOwnership(address newOwner) public onlyOwner {
21         owner = newOwner;
22     }
23     
24     function changeGift(uint256 newGift) public onlyOwner {
25         if (newGift>0) gift = newGift;
26         else revert();
27     }
28     
29     function changeFriend(address payer, address newFriend) public onlyOwner {
30         if (payer!=address(0) && newFriend!=address(0)) friends[payer] = newFriend;
31         else revert();
32     }
33     
34     function transferGift(address from, address to) payable public onlyOwner {
35         if (from==address(0) || to==address(0) || from==to) revert();
36         friends[from] = to;
37         payOut(to);
38         emit GiftSent(from);
39     }
40     
41     function sendGift(address friend) payable public {
42         if (msg.value<gift || friend==address(0) || friend==msg.sender || (friend!=owner && friends[friend]==address(0))) revert();
43         friends[msg.sender] = friend;
44         payOut(friend);
45         emit GiftSent(msg.sender);
46     }
47     
48     function payOut(address payee) private{
49         uint256 pay;
50         uint256 paid = 0;
51         for (uint i=0;i<7;i++) {
52             pay = gift*gifts[i]/100;
53             if (pay>0 && payee!=address(0)) {
54                 payee.transfer(pay);
55                 paid+=pay;
56             }
57             payee = friends[payee];
58             if (payee==address(0)) break;
59         }
60         if (gift-paid>0) owner.transfer(gift-paid);
61     }
62     
63     function () payable public {
64         if (msg.value<gift) revert();
65         friends[msg.sender] = owner;
66     }
67 }