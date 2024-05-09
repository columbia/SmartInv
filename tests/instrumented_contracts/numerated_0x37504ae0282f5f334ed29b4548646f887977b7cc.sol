1 pragma solidity ^0.4.2;
2 
3 contract EtherRock {
4     
5     struct Rock {
6         address owner;
7         bool currentlyForSale;
8         uint price;
9         uint timesSold;
10     }
11     
12     mapping (uint => Rock) public rocks;
13     
14     mapping (address => uint[]) public rockOwners;
15 
16     uint public latestNewRockForSale;
17     
18     address owner;
19     
20     modifier onlyOwner {
21         require(msg.sender == owner);
22         _;
23     }
24     
25     function EtherRock() {
26         rocks[0].price = 10**15;
27         rocks[0].currentlyForSale = true;
28         owner = msg.sender;
29     }
30     
31     function getRockInfo (uint rockNumber) returns (address, bool, uint, uint) {
32         return (rocks[rockNumber].owner, rocks[rockNumber].currentlyForSale, rocks[rockNumber].price, rocks[rockNumber].timesSold);
33     }
34     
35     function rockOwningHistory (address _address) returns (uint[]) {
36         return rockOwners[_address];
37     }
38     
39     function buyRock (uint rockNumber) payable {
40         require(rocks[rockNumber].currentlyForSale = true);
41         require(msg.value == rocks[rockNumber].price);
42         rocks[rockNumber].currentlyForSale = false;
43         rocks[rockNumber].timesSold++;
44         if (rockNumber != latestNewRockForSale) {
45             rocks[rockNumber].owner.transfer(rocks[rockNumber].price);
46         }
47         rocks[rockNumber].owner = msg.sender;
48         rockOwners[msg.sender].push(rockNumber);
49         if (rockNumber == latestNewRockForSale) {
50             if (rockNumber != 99) {
51                 latestNewRockForSale++;
52                 rocks[latestNewRockForSale].price = 10**15 + (latestNewRockForSale**2 * 10**15);
53                 rocks[latestNewRockForSale].currentlyForSale = true;
54             }
55         }
56     }
57     
58     function sellRock (uint rockNumber, uint price) {
59         require(msg.sender == rocks[rockNumber].owner);
60         require(price > 0);
61         rocks[rockNumber].price = price;
62         rocks[rockNumber].currentlyForSale = true;
63     }
64     
65     function dontSellRock (uint rockNumber) {
66         require(msg.sender == rocks[rockNumber].owner);
67         rocks[rockNumber].currentlyForSale = false;
68     }
69     
70     function giftRock (uint rockNumber, address receiver) {
71         require(msg.sender == rocks[rockNumber].owner);
72         rocks[rockNumber].owner = receiver;
73         rockOwners[receiver].push(rockNumber);
74     }
75     
76     function() payable {
77         
78     }
79     
80     function withdraw() onlyOwner {
81         owner.transfer(this.balance);
82     }
83     
84 }