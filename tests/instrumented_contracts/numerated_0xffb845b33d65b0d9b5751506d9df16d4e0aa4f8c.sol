1 pragma solidity ^0.4.19;
2 
3 /*
4 This is the pre-sale contract for MyEtherCity's lands. You can join our pre-sale on https://myethercity.github.io/city/ 
5 Game Name: MyEtherCity
6 Game Link: https://myethercity.github.io/city/
7 */
8 
9 contract MyEtherCity {
10 
11     address ceoAddress = 0xe0cc9ED08CD2c79f66453d90DD0132cBB56C7607;
12     address cfoAddress = 0x105110518dD14Dc57447E71C83AbBc73b44fBF28;
13     
14     modifier onlyCeo() {
15         require (msg.sender == ceoAddress);
16         _;
17     }
18 
19     uint256 curPriceLand = 1000000000000000;
20     uint256 stepPriceLand = 2000000000000000;
21     
22     // How many lands an addres own
23     mapping (address => uint) public addressLandsCount;
24     
25     struct Land {
26         address ownerAddress;
27         uint256 pricePaid;
28         uint256 curPrice;
29         bool isForSale;
30     }
31     Land[] lands;
32 
33     /*
34     This function allows players to purchase lands during our pre-sale.
35     The price of lands is raised by 0.002 eth after each successful purchase.
36     */
37     function purchaseLand() public payable {
38         // We verify that the amount paid is the right amount
39         require(msg.value == curPriceLand);
40         
41         // We verify that we don't create more than 300 lands
42         require(lands.length < 300);
43         
44         // We create the land
45         lands.push(Land(msg.sender, msg.value, 0, false));
46         addressLandsCount[msg.sender]++;
47         
48         // We increase the price of the lands
49         curPriceLand = curPriceLand + stepPriceLand;
50         
51         // We transfer the amount paid to the cfo
52         cfoAddress.transfer(msg.value);
53     }
54     
55     
56     // These functions will return the details of a piece of land
57     function getLand(uint _landId) public view returns (
58         address ownerAddress,
59         uint256 pricePaid,
60         uint256 curPrice,
61         bool isForSale
62     ) {
63         Land storage _land = lands[_landId];
64 
65         ownerAddress = _land.ownerAddress;
66         pricePaid = _land.pricePaid;
67         curPrice = _land.curPrice;
68         isForSale = _land.isForSale;
69     }
70     
71     // Get all the lands owned by a specific address
72     function getSenderLands(address _senderAddress) public view returns(uint[]) {
73         uint[] memory result = new uint[](addressLandsCount[_senderAddress]);
74         uint counter = 0;
75         for (uint i = 0; i < lands.length; i++) {
76           if (lands[i].ownerAddress == _senderAddress) {
77             result[counter] = i;
78             counter++;
79           }
80         }
81         return result;
82     }
83     
84     // This function will return the data about the pre-sale (how many lands purchased, current price)
85     function getPreSaleData() public view returns(uint, uint256) {
86         return(lands.length, curPriceLand);
87     } 
88 }