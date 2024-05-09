1 pragma solidity ^0.4.24;
2 contract BeatProfitMembership{
3     address owner= 0x6A3CACAbaA5958A0cA73bd3908445d81852F3A7E;
4     uint256 [] priceOfPeriod = [10000000000000000, 30000000000000000,300000000000000000,2000000000000000000, 5000000000000000000];
5     uint256 [] TimeInSec = [3600, 86400,2592000,31536000];
6     
7     mapping (address => uint256) public DueTime;
8     mapping (address => bool) public Premium;
9 
10     constructor() public {
11         DueTime[owner] = 4689878400;
12         DueTime[0x491cFe3e5eF0C093971DaDdaBce7747EA69A991E] = 4689878400;
13         DueTime[0x2ECc452E01f748183d697be4cb1db0531cc8F38F] = 4689878400;
14         DueTime[0x353507473A89184e28E8F13e156Dc8055fD62A2C] = 4689878400;
15         
16         Premium[0x491cFe3e5eF0C093971DaDdaBce7747EA69A991E] = true;
17         Premium[0x2ECc452E01f748183d697be4cb1db0531cc8F38F] = true;
18         Premium[0x353507473A89184e28E8F13e156Dc8055fD62A2C] = true;
19     }
20 
21     function extendMembership(uint256 _type) public payable{
22     // Type:[0]:hour, [1]:day, [2]:month, [3]:year, [4]:premium
23     
24         require(msg.value >= priceOfPeriod[_type], "Payment Amount Wrong.");
25         if(_type==4){
26             // Premium Membership
27             Premium[msg.sender] = true;
28             DueTime[msg.sender] = 4689878400;
29         }
30         else if(DueTime[msg.sender]>now){
31             DueTime[msg.sender] += mul(div(msg.value, priceOfPeriod[_type]), TimeInSec[_type]);
32         }
33         else{
34             DueTime[msg.sender] = now + mul(div(msg.value, priceOfPeriod[_type]), TimeInSec[_type]);
35         }
36         
37         owner.transfer(msg.value);
38     }
39 
40     function setPrice(uint256 [] new_prices) public{
41         require(msg.sender == owner, "Only Available to BeatProfit Core Team");
42         priceOfPeriod[0] = new_prices[0];
43         priceOfPeriod[1] = new_prices[1];
44         priceOfPeriod[2] = new_prices[2];
45         priceOfPeriod[3] = new_prices[3];
46         priceOfPeriod[4] = new_prices[4];
47     }
48 
49     function setMemberShip(address user, uint256 _timestamp) public {
50         require(msg.sender==owner);
51         DueTime[user]=_timestamp;
52     }
53 
54   //   Safe Math Functions
55     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
56         if (a == 0) {
57             return 0;
58         }
59         c = a * b;
60         assert(c / a == b);
61         return c;
62     }
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
64     function sub(uint256 a, uint256 b) internal pure returns (uint256) {assert(b <= a); return a - b;}
65     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
66         c = a + b;
67         assert(c >= a);
68         return c;
69     }
70 }