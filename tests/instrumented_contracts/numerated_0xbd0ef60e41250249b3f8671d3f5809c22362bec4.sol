1 pragma solidity ^0.4.2;
2 
3 contract Migrations {
4   address public owner;
5   uint public last_completed_migration;
6 
7   modifier restricted() {
8     if (msg.sender == owner) _;
9   }
10 
11   function Migrations() public {
12     owner = msg.sender;
13   }
14 
15   function setCompleted(uint completed) public restricted {
16     last_completed_migration = completed;
17   }
18 
19   function upgrade(address new_address) public restricted {
20     Migrations upgraded = Migrations(new_address);
21     upgraded.setCompleted(last_completed_migration);
22   }
23 }
24 
25 pragma solidity ^0.4.18;
26 
27 contract HelloChicken {
28 
29   event Transfer(address indexed from, address indexed to, uint256 value);
30 
31   string public constant name = "Chicken";
32   string public constant symbol = "CHK";
33 
34   uint256 totalSupply_;
35   uint256 dailyLimit_;
36 
37   mapping(address => uint256) balances_;
38   mapping(address => uint256) lastDay_;
39   mapping(address => uint256) spentToday_;
40 
41   function Chicken() public {
42     totalSupply_ = 0;
43     dailyLimit_ = 5;
44   }
45 
46   function underLimit(uint256 _value) internal returns (bool) {
47     if (today() > lastDay_[msg.sender]) {
48       spentToday_[msg.sender] = 0;
49       lastDay_[msg.sender] = today();
50     }
51     if (spentToday_[msg.sender] + _value >= spentToday_[msg.sender] && spentToday_[msg.sender] + _value <= dailyLimit_) {
52       spentToday_[msg.sender] += _value;
53       return true;
54     }
55     return false;
56   }
57 
58   function today() private view returns (uint256) {
59     return now / 1 days;
60   }
61 
62   modifier limitedDaily(uint256 _value) {
63     require(underLimit(_value));
64     _;
65   }
66 
67   function totalSupply() public view returns (uint256) {
68     return totalSupply_;
69   }
70 
71   function transfer(address _to, uint256 _value) public limitedDaily(_value) returns (bool) {
72     require(_to != address(0));
73     require(_to != msg.sender);
74 
75     totalSupply_ += _value;
76     balances_[_to] += _value;
77     Transfer(msg.sender, _to, _value);
78     return true;
79   }
80 
81   function balanceOf(address _owner) public view returns (uint256 balance) {
82     return balances_[_owner];
83   }
84 }