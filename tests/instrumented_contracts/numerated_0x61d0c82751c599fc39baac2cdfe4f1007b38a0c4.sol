1 pragma solidity ^0.4.24;
2 
3 contract ETHCOOLAdvertisements {
4 
5     using SafeMath for uint;
6 
7     struct Advertisement {
8         address user;
9         string text;
10         string link;
11         uint expiry;
12     }
13 
14     address public owner;
15     uint public display_rate;
16     uint public owner_share;
17 
18     ETHCOOLMain main_contract;
19     Advertisement[] public advertisements;
20     
21     constructor() public {
22         owner = msg.sender;
23     }
24 
25     function publicGetStatus() view public returns (uint) {
26         return (advertisements.length);
27     }
28 
29     function publicGetAdvertisement(uint index) view public returns (address, string, string, uint) {
30         return (advertisements[index].user, advertisements[index].text, advertisements[index].link, advertisements[index].expiry);
31     }
32 
33     function ownerConfig(address main, uint rate, uint share) public {
34         if (msg.sender == owner) {
35             display_rate = rate;
36             owner_share = share;
37             main_contract = ETHCOOLMain(main);
38         }
39     }
40 
41     function userCreate(string text, string link) public payable {
42         if (msg.value > 0) {
43             uint expiry = now.add(msg.value.div(display_rate));
44             Advertisement memory ad = Advertisement(msg.sender, text, link, expiry);
45             advertisements.push(ad);
46         }
47     }
48 
49     function userTransfer() public {
50         if (address(this).balance > 0) {
51             main_contract.contractBoost.value(address(this).balance)(owner_share);
52         }
53     }
54 }
55 
56 contract ETHCOOLMain {
57     function contractBoost(uint share) public payable {}
58 }
59 
60 library SafeMath {
61 
62     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
63         if (a == 0) {
64             return 0;
65         }
66         c = a * b;
67         assert(c / a == b);
68         return c;
69     }
70 
71     function div(uint256 a, uint256 b) internal pure returns (uint256) {
72         return a / b;
73     }
74 
75     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76         assert(b <= a);
77         return a - b;
78     }
79 
80     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
81         c = a + b;
82         assert(c >= a);
83         return c;
84     }
85 }