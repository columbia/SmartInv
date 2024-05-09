1 pragma solidity ^0.4.18;
2 
3 contract HelloChicken {
4 
5   event Transfer(address indexed from, address indexed to, uint256 value);
6 
7   string public constant name = "Chicken";
8   string public constant symbol = "CHK";
9   uint256 public constant decimals = 0;
10 
11   uint256 totalSupply_;
12 
13   mapping(address => uint256) balances_;
14   mapping(address => uint256) lastDay_;
15   mapping(address => uint256) spentToday_;
16 
17   function Chicken() public {
18     totalSupply_ = 0;
19   }
20 
21   function underLimit(uint256 _value) internal returns (bool) {
22     if (today() > lastDay_[msg.sender]) {
23       spentToday_[msg.sender] = 0;
24       lastDay_[msg.sender] = today();
25     }
26     if (spentToday_[msg.sender] + _value >= spentToday_[msg.sender] && spentToday_[msg.sender] + _value <= 5) {
27       spentToday_[msg.sender] += _value;
28       return true;
29     }
30     return false;
31   }
32 
33   function today() private view returns (uint256) {
34     return now / 1 days;
35   }
36 
37   modifier limitedDaily(uint256 _value) {
38     require(underLimit(_value));
39     _;
40   }
41 
42   function totalSupply() public view returns (uint256) {
43     return totalSupply_;
44   }
45 
46   function transfer(address _to, uint256 _value) public limitedDaily(_value) returns (bool) {
47     require(_to != address(0));
48     require(_to != msg.sender);
49 
50     totalSupply_ += _value;
51     balances_[_to] += _value;
52     Transfer(msg.sender, _to, _value);
53     return true;
54   }
55 
56   function balanceOf(address _owner) public view returns (uint256 balance) {
57     return balances_[_owner];
58   }
59 }