1 pragma solidity ^0.4.11;
2 
3 
4 contract CarTaxiCrowdsale {
5     function soldTokensOnPreIco() constant returns (uint256);
6     function soldTokensOnIco() constant returns (uint256);
7 }
8 
9 contract CarTaxiToken {
10     function balanceOf(address owner) constant returns (uint256 balance);
11     function getOwnerCount() constant returns (uint256 value);
12 }
13 
14 contract CarTaxiBonus {
15 
16     CarTaxiCrowdsale public carTaxiCrowdsale;
17     CarTaxiToken public carTaxiToken;
18 
19 
20     address public owner;
21     address public carTaxiCrowdsaleAddress = 0x77CeFf4173a56cd22b6184Fa59c668B364aE55B8;
22     address public carTaxiTokenAddress = 0x662aBcAd0b7f345AB7FfB1b1fbb9Df7894f18e66;
23 
24     uint constant BASE = 1000000000000000000;
25     uint public totalTokens;
26     uint public totalBonuses;
27     uint public iteration = 0;
28     
29     bool init = false;
30 
31     //mapping (address => bool) private contributors;
32 
33 
34     modifier onlyOwner() {
35         require(msg.sender == owner);
36         _;
37     }
38 
39     function setOwner(address _owner) public onlyOwner{
40         require(_owner != 0x0);
41         owner = _owner;
42     }
43 
44     function CarTaxiBonus() {
45         owner = msg.sender;
46         carTaxiCrowdsale = CarTaxiCrowdsale(carTaxiCrowdsaleAddress);
47         carTaxiToken = CarTaxiToken(carTaxiTokenAddress);
48     }
49 
50     function sendValue(address addr, uint256 val) public onlyOwner{
51         addr.transfer(val);
52     }
53 
54     function setTotalTokens(uint256 _totalTokens) public onlyOwner{
55         totalTokens = _totalTokens;
56     }
57 
58     function setTotalBonuses(uint256 _totalBonuses) public onlyOwner{
59         totalBonuses = _totalBonuses;
60     }
61 
62     function sendAuto(address addr) public onlyOwner{
63 
64         uint256 addrTokens = carTaxiToken.balanceOf(addr);
65 
66         require(addrTokens > 0);
67         require(totalTokens > 0);
68 
69         uint256 pie = addrTokens * totalBonuses / totalTokens;
70 
71         addr.transfer(pie);
72         
73     }
74 
75     function withdrawEther() public onlyOwner {
76         require(this.balance > 0);
77         owner.transfer(this.balance);
78     }
79     
80     function () payable { }
81   
82 }