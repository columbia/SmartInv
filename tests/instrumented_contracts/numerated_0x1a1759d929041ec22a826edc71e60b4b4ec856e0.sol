1 pragma solidity ^0.4.18;
2 
3 contract HelloChicken {
4 
5   event Transfer(address indexed from, address indexed to, uint256 value);
6 
7   string public constant name = "Chicken";
8   string public constant symbol = "CHK";
9 
10   uint256 totalSupply_;
11   uint256 dailyLimit_;
12 
13   mapping(address => uint256) balances_;
14   mapping(address => uint256) lastDay_;
15   mapping(address => uint256) spentToday_;
16 
17   function Chicken() public {
18     totalSupply_ = 0;
19     dailyLimit_ = 5;
20   }
21 
22   function underLimit(uint256 _value) internal returns (bool) {
23     if (today() > lastDay_[msg.sender]) {
24       spentToday_[msg.sender] = 0;
25       lastDay_[msg.sender] = today();
26     }
27     if (spentToday_[msg.sender] + _value >= spentToday_[msg.sender] && spentToday_[msg.sender] + _value <= dailyLimit_) {
28       spentToday_[msg.sender] += _value;
29       return true;
30     }
31     return false;
32   }
33 
34   function today() private view returns (uint256) {
35     return now / 1 days;
36   }
37 
38   modifier limitedDaily(uint256 _value) {
39     require(underLimit(_value));
40     _;
41   }
42 
43   function totalSupply() public view returns (uint256) {
44     return totalSupply_;
45   }
46 
47   function transfer(address _to, uint256 _value) public limitedDaily(_value) returns (bool) {
48     require(_to != address(0));
49     require(_to != msg.sender);
50 
51     totalSupply_ += _value;
52     balances_[_to] += _value;
53     Transfer(msg.sender, _to, _value);
54     return true;
55   }
56 
57   function balanceOf(address _owner) public view returns (uint256 balance) {
58     return balances_[_owner];
59   }
60 }