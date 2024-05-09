1 pragma solidity ^0.4.17;
2 
3 contract Brothel {
4     address public manager;
5     address public coOwner;
6     mapping(address => bool) public hasAids;
7     Ho[8] public hoes;
8     
9     struct Ho {
10         address pimp;
11         uint buyPrice;
12         uint rentPrice;
13         uint aidsChance;
14     }
15     
16     function Brothel(address coown) public {
17         manager = msg.sender;
18         coOwner = coown;
19         
20         uint basePrice = 0.002 ether;
21         uint size = hoes.length;
22         uint baseAidsChance = 7;
23         
24         for (uint i = 0; i<size; i++) {
25             Ho hoe = hoes[i];
26             hoe.pimp = manager;
27             hoe.buyPrice = basePrice*(i+1);
28             hoe.rentPrice = hoe.buyPrice/10;
29             hoe.aidsChance = baseAidsChance + (i*4);
30         }
31     }
32     
33     function withdraw() public restricted {
34         uint leBron = address(this).balance*23/100;
35         coOwner.transfer(leBron);
36         manager.transfer(address(this).balance);
37     }
38     
39     function buyHo(uint index) public payable{
40         Ho hoe = hoes[index];
41         address currentPimp = hoe.pimp;
42         uint currentPrice = hoe.buyPrice;
43         require(msg.value >= currentPrice);
44         
45         currentPimp.transfer(msg.value*93/100);
46         hoe.pimp = msg.sender;
47         hoe.buyPrice = msg.value*160/100;
48     }
49     
50     function rentHo(uint index) public payable {
51         Ho hoe = hoes[index];
52         address currentPimp = hoe.pimp;
53         uint currentRent = hoe.rentPrice;
54         require(msg.value >= currentRent);
55         
56         currentPimp.transfer(msg.value*93/100);
57         if (block.timestamp%hoe.aidsChance == 0) {
58             hasAids[msg.sender] = true;
59         }
60     }
61     
62     function setRentPrice(uint index, uint newPrice) public {
63         require(msg.sender == hoes[index].pimp);
64         hoes[index].rentPrice = newPrice;
65     }
66 
67     function sendMoney() public payable restricted {
68     }
69     
70     function balance() public view returns(uint) {
71         return address(this).balance;
72     }
73     
74     modifier restricted() {
75         require(msg.sender == manager);
76         _;
77     }
78 }