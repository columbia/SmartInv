1 pragma solidity ^0.4.18;
2 
3 contract MyOwned {
4     address public owner;
5     function MyOwned() public { owner = msg.sender; }
6     modifier onlyOwner { require(msg.sender == owner); _;}
7     function exOwner(address newOwner) onlyOwner public { owner = newOwner;}
8 }
9 
10 interface token {
11     function transfer(address receiver, uint amount) public;
12 }
13 
14 contract MTCOsale is MyOwned {
15     uint public startDate;
16     uint public stopDate;
17     uint public saleSupply;
18     uint public fundingGoal;
19     uint public amountRaised;
20     token public tokenReward;
21     address public beneficiary;
22     mapping(address => uint256) public balanceOf;
23     event TakeBackToken(uint amount);
24     event FundTransfer(address sender, uint amount, bool isSuccessful);
25 
26     function MTCOsale (
27         uint _startDate,
28         uint _stopDate,
29         uint _saleSupply,
30         uint _fundingGoal,
31         address _beneficiary,
32         address _tokenReward
33     ) public {
34         startDate = _startDate;
35         stopDate = _stopDate;
36         saleSupply = _saleSupply;
37         fundingGoal = _fundingGoal;
38         beneficiary = _beneficiary;
39         tokenReward = token(_tokenReward);
40     }
41     
42     function getCurrentTimestamp() internal constant returns (uint256) {
43         return now;    
44     }
45 
46     function saleActive() public constant returns (bool) {
47         return (now >= startDate && now <= stopDate);
48     }
49 
50     function () public payable {
51         require(saleActive());
52         require(msg.value >= 0.1 ether);
53         require(balanceOf[msg.sender] <= 0);
54         uint amount = msg.value;
55         amountRaised += amount/10000000000000000;
56         tokenReward.transfer(msg.sender, 5000000000);
57         beneficiary.transfer(msg.value);
58         FundTransfer(msg.sender, amount, true);        
59     }
60 
61     function saleEnd(uint restAmount) public onlyOwner {
62         require(!saleActive());
63         require(now > stopDate );
64         uint weiRest = restAmount*100000000;       
65         tokenReward.transfer(beneficiary, weiRest);
66         TakeBackToken(restAmount);
67     }
68 }