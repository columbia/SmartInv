1 pragma solidity ^0.4.18;
2 
3 contract SendGift {
4 	address public owner;
5 	mapping(address=>address) public friends;
6 	mapping(address=>uint256) public received;
7 	mapping(address=>uint256) public sent;
8 	event Gift(address indexed _sender);
9 	modifier onlyOwner() {
10       if (msg.sender!=owner) revert();
11       _;
12     }
13     
14     function SendGift() public {
15     	owner = msg.sender;
16     }
17     
18     
19     function sendGift(address friend) payable public returns (bool ok){
20         if (msg.value==0 || friend==address(0) || friend==msg.sender || (friend!=owner && friends[friend]==address(0))) revert();
21         friends[msg.sender] = friend;
22         payOut();
23         return true;
24     }
25     
26     function payOut() private{
27         uint256 gift;
28         address payee1 = friends[msg.sender];
29         if (payee1==address(0)) payee1 = owner;
30         if (received[payee1]>sent[payee1]*2) {
31             gift = msg.value*49/100;
32             address payee2 = friends[payee1];
33             if (payee2==address(0)) payee2 = owner;
34             payee2.transfer(gift);
35             sent[payee1]+=gift;
36             received[payee2]+=gift;
37         }
38         else gift = msg.value*99/100;
39         payee1.transfer(gift);
40         sent[msg.sender]+=msg.value;
41         received[payee1]+=gift;
42         owner.transfer(this.balance);
43         Gift(msg.sender);
44     }
45     
46     function () payable public {
47         revert();
48     }
49 }