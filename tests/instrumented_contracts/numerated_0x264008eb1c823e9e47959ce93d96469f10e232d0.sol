1 pragma solidity ^0.4.16;
2 
3 interface Token {
4     function transferFrom(address _from, address _to, uint256 _value) external;
5 }
6 
7 contract IRideFoundersAdvisors {
8     
9     Token public tokenReward;
10     address public creator;
11     address public owner = 0xBeDF65990326Ed2236C5A17432d9a30dbA3aBFEe;
12 
13     uint256 public price;
14     uint256 public startDate;
15 
16     modifier isCreator() {
17         require(msg.sender == creator);
18         _;
19     }
20 
21     event FundTransfer(address backer, uint amount, bool isContribution);
22 
23     function IRideFoundersAdvisors() public {
24         creator = msg.sender;
25         startDate = 1519862400;
26         price = 17500;
27         tokenReward = Token(0x69D94dC74dcDcCbadEc877454a40341Ecac34A7c);
28     }
29 
30     function setOwner(address _owner) isCreator public {
31         owner = _owner;      
32     }
33 
34     function setCreator(address _creator) isCreator public {
35         creator = _creator;      
36     }
37 
38     function setStartDate(uint256 _startDate) isCreator public {
39         startDate = _startDate;      
40     }
41     
42     function setPrice(uint256 _price) isCreator public {
43         price = _price;      
44     }
45 
46     function setToken(address _token) isCreator public {
47         tokenReward = Token(_token);      
48     }
49 
50     function kill() isCreator public {
51         selfdestruct(owner);
52     }
53 
54     function () payable public {
55         require(msg.value > 0);
56         require(now > startDate);
57 	    uint amount = msg.value * price;
58         tokenReward.transferFrom(owner, msg.sender, amount);
59         FundTransfer(msg.sender, amount, true);
60         owner.transfer(msg.value);
61     }
62 }