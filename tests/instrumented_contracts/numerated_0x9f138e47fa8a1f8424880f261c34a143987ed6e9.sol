1 pragma solidity ^0.4.16;
2 
3 interface Token {
4     function transferFrom(address _from, address _to, uint256 _value) external;
5     function transfer(address _to, uint256 _value) external;
6 }
7 
8 contract AirdropiRide {
9     
10     Token public tokenReward;
11     address public creator;
12     address public owner = 0xf33fd617449471031ad6E00f1EbaA9f993f91939;
13 
14     uint256 public startDate;
15     uint256 public amount;
16 
17     modifier isCreator() {
18         require(msg.sender == creator);
19         _;
20     }
21 
22     event FundTransfer(address backer, uint amount, bool isContribution);
23 
24     constructor() public {
25         creator = msg.sender;
26         startDate = 1519862400;
27         tokenReward = Token(0x69D94dC74dcDcCbadEc877454a40341Ecac34A7c);
28         amount = 500 * (10**18);
29     }
30 
31     function setOwner(address _owner) isCreator public {
32         owner = _owner;      
33     }
34 
35     function setCreator(address _creator) isCreator public {
36         creator = _creator;      
37     }
38 
39     function setStartDate(uint256 _startDate) isCreator public {
40         startDate = _startDate;      
41     }
42     
43     function setAmount(uint256 _amount) isCreator public {
44         amount = _amount;      
45     }
46     
47     function setToken(address _token) isCreator public {
48         tokenReward = Token(_token);      
49     }
50 
51     function kill() isCreator public {
52         selfdestruct(owner);
53     }
54 
55     function dropToken(address[] _to) isCreator public{
56         require(now > startDate);
57         for (uint256 i = 0; i < _to.length; i++) {
58             tokenReward.transferFrom(owner, _to[i], amount);
59             emit FundTransfer(msg.sender, amount, true);
60         }
61     }
62 
63     function dropTokenV2(address[] _to) isCreator public{
64         require(now > startDate);
65         for (uint256 i = 0; i < _to.length; i++) {
66             tokenReward.transfer(_to[i], amount);
67             emit FundTransfer(msg.sender, amount, true);
68         }
69     }
70 
71 }