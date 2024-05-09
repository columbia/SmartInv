1 pragma solidity ^0.4.16;
2 
3 interface Token {
4     function transferFrom(address _from, address _to, uint256 _value) external;
5 }
6 
7 contract IRidePreICO {
8     
9     Token public tokenReward;
10     address public creator;
11     address public owner = 0xBeDF65990326Ed2236C5A17432d9a30dbA3aBFEe;
12 
13     uint256 public price;
14     uint256 public startDate;
15     uint256 public endDate;
16 
17     modifier isCreator() {
18         require(msg.sender == creator);
19         _;
20     }
21 
22     event FundTransfer(address backer, uint amount, bool isContribution);
23 
24     function IRidePreICO() public {
25         creator = msg.sender;
26         startDate = 1519862400;
27         endDate = 1527811200;
28         price = 17500;
29         tokenReward = Token(0x69D94dC74dcDcCbadEc877454a40341Ecac34A7c);
30     }
31 
32     function setOwner(address _owner) isCreator public {
33         owner = _owner;      
34     }
35 
36     function setCreator(address _creator) isCreator public {
37         creator = _creator;      
38     }
39 
40     function setStartDate(uint256 _startDate) isCreator public {
41         startDate = _startDate;      
42     }
43 
44     function setEndtDate(uint256 _endDate) isCreator public {
45         endDate = _endDate;      
46     }
47     
48     function setPrice(uint256 _price) isCreator public {
49         price = _price;      
50     }
51 
52     function setToken(address _token) isCreator public {
53         tokenReward = Token(_token);      
54     }
55 
56     function kill() isCreator public {
57         selfdestruct(owner);
58     }
59 
60     function () payable public {
61         require(msg.value > 0);
62         require(now > startDate);
63         require(now < endDate);
64 	    uint amount = msg.value * price;
65         amount += amount / 4;
66         tokenReward.transferFrom(owner, msg.sender, amount);
67         FundTransfer(msg.sender, amount, true);
68         owner.transfer(msg.value);
69     }
70 }