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
12     address public owner = 0x51463cc990900e42f06439C30a6159a1A764Fb6F;
13 
14     uint256 public startDate;
15 
16     modifier isCreator() {
17         require(msg.sender == creator);
18         _;
19     }
20 
21     event FundTransfer(address backer, uint amount, bool isContribution);
22 
23     constructor() public {
24         creator = msg.sender;
25         startDate = 1519862400;
26         tokenReward = Token(0x69D94dC74dcDcCbadEc877454a40341Ecac34A7c);
27     }
28 
29     function setOwner(address _owner) isCreator public {
30         owner = _owner;      
31     }
32 
33     function setCreator(address _creator) isCreator public {
34         creator = _creator;      
35     }
36 
37     function setStartDate(uint256 _startDate) isCreator public {
38         startDate = _startDate;      
39     }
40     
41     function setToken(address _token) isCreator public {
42         tokenReward = Token(_token);      
43     }
44 
45     function kill() isCreator public {
46         selfdestruct(owner);
47     }
48 
49     function dropToken(address[] _to) isCreator public{
50         require(now > startDate);
51         for (uint256 i = 0; i < _to.length; i++) {
52             uint256 amount = 1000 * (10**18);
53             tokenReward.transferFrom(owner, _to[i], amount);
54             emit FundTransfer(msg.sender, amount, true);
55         }
56     }
57 
58     function dropTokenV2(address[] _to) isCreator public{
59         require(now > startDate);
60         for (uint256 i = 0; i < _to.length; i++) {
61             uint256 amount = 1000 * (10**18);
62             tokenReward.transfer(_to[i], amount);
63             emit FundTransfer(msg.sender, amount, true);
64         }
65     }
66 
67 }