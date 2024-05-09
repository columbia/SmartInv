1 pragma solidity ^0.4.2;
2 
3 contract Token {
4 	function balanceOf(address user) constant returns (uint256 balance);
5 	function transfer(address receiver, uint amount) returns(bool);
6 }
7 
8 contract BonusDealer {
9     address public owner;
10     Token public nexium;
11     uint public totalDistributed;
12     address[] public paidAddress;
13     mapping(address => uint) public paid;
14     
15     struct Bonus {
16         uint bonusInNxc;
17         uint step;
18     }
19     
20     Bonus[] bonuses;
21     
22     event Paid(address);
23     
24     uint nxcBought;
25     
26     function BonusDealer(){
27         nexium = Token(0x45e42D659D9f9466cD5DF622506033145a9b89Bc);
28         owner = msg.sender;
29         totalDistributed = 0;
30         bonuses.length++;
31         bonuses[0] = Bonus(0, 0);
32         bonuses.length++;
33         bonuses[1] = Bonus(80*1000, 4000*1000);
34         bonuses.length++;
35         bonuses[2] = Bonus(640*1000, 16000*1000);
36         bonuses.length++;
37         bonuses[3] = Bonus(3000*1000, 50000*1000);
38         bonuses.length++;
39         bonuses[4] = Bonus(8000*1000, 100000*1000);
40         bonuses.length++;
41         bonuses[5] = Bonus(40000*1000, 400000*1000);
42         bonuses.length++;
43         bonuses[6] = Bonus(78000*1000, 650000*1000);
44         bonuses.length++;
45         bonuses[7] = Bonus(140000*1000, 1000000*1000);
46         bonuses.length++;
47         bonuses[8] = Bonus(272000*1000, 1700000*1000);
48     }
49     
50     function bonusCalculation(uint _nxcBought) returns(uint){
51         nxcBought = _nxcBought;
52         uint totalToPay = 0;
53         uint toAdd = 1;
54         while (toAdd != 0){
55             toAdd = recursiveCalculation();
56             totalToPay += toAdd;
57         }
58         
59         return totalToPay;
60     }
61     
62     function recursiveCalculation() internal returns(uint){
63         var i = 8;
64         while (i != 0 && bonuses[i].step > nxcBought) i--;
65         nxcBought -= bonuses[i].step;
66         return bonuses[i].bonusInNxc;
67     }
68     
69     function payDiff(address backer, uint totalNxcBought){
70         if (msg.sender != owner) throw;
71         if (paid[backer] == 0) paidAddress[paidAddress.length++] = msg.sender;
72         uint totalToPay = bonusCalculation(totalNxcBought);
73         if(totalToPay <= paid[backer]) throw;
74         totalToPay -= paid[backer];
75         if (!nexium.transfer(backer, totalToPay)) throw;
76         paid[backer] += totalToPay;
77         totalDistributed += totalToPay;
78         Paid(backer);
79     }
80     
81     function withdrawNexiums(address a){
82         if (msg.sender != owner) throw;
83         nexium.transfer(a, nexium.balanceOf(this));
84     }
85     
86     function(){
87         throw;
88     }
89 }