1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) pure internal returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 }
10 
11 contract token {
12   mapping (address => uint256) public balanceOf;
13   function transfer(address _to, uint256 _value) external;
14 }
15 
16 contract ICOCrowdsale {
17   using SafeMath for uint256;
18   token public tokenReward;
19   mapping(address => uint256) public balanceOf;
20 
21   uint public beginTime;
22   uint public endTime;
23 
24   address public owner;
25 
26   event Transfer(address indexed _from, uint256 _value);
27 
28   constructor (
29     address ICOReward,
30     uint _beginTime,
31     uint _endTime
32   ) payable public {
33     tokenReward = token(ICOReward);
34     beginTime = _beginTime;
35     endTime = _endTime;
36 
37     owner = msg.sender;
38   }
39 
40   function () payable public{
41     uint amount = msg.value;
42 
43     require(amount % 10 ** 17 == 0);
44     require(now >= beginTime && now <= endTime);
45     tokenReward.transfer(msg.sender, amount.mul(1000));
46 
47     emit Transfer(msg.sender, amount);
48   }
49 
50   function setBeginTime(uint _beginTime) onlyOwner public {
51     beginTime = _beginTime;
52   }
53 
54   function setEndTime(uint _endTime) onlyOwner public {
55     endTime = _endTime;
56   }
57 
58   modifier onlyOwner {
59     require(msg.sender == owner);
60     _;
61   }
62 
63   function WithdrawalETH(uint _value) onlyOwner public {
64     if (_value == 0)
65       owner.transfer(address(this).balance);
66     else
67       owner.transfer(_value * 1 ether);
68   }
69 
70   function WithdrawalToken(uint _value) onlyOwner public {
71     if (_value == 0) {
72       tokenReward.transfer(owner, tokenReward.balanceOf(address(this)));
73     } else {
74       tokenReward.transfer(owner, _value * 1 ether);
75     }
76   }
77 }