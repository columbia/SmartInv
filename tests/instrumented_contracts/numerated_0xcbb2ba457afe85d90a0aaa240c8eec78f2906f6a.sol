1 pragma solidity ^0.4.25;
2 
3 interface Yrc20 {
4     function allowance(address _owner, address _spender) external view returns (uint remaining);
5     function balanceOf(address _owner) external view returns (uint balance);
6     function transfer(address _to, uint _value) external returns (bool success);
7     function transferFrom(address _from, address _to, uint _value) external returns (bool success);
8 }
9 
10 interface YRC20 {
11     function totalSupply() public view returns (uint supply);
12     function approve(address _spender, uint _value) public returns (bool success);
13     function decimals() public view returns(uint digits);
14     event Approval(address indexed _owner, address indexed _spender, uint _value);
15 }
16 
17 contract YBalanceChecker {
18     function check(address token) external view returns(uint a, uint b) {
19         if (uint(token)==0) {
20             b = msg.sender.balance;
21             a = address(this).balance;
22             return;
23         }
24         b = Yrc20(token).balanceOf(msg.sender);
25         a = Yrc20(token).allowance(msg.sender,this);
26     }
27 }
28 
29 contract HairyHoover is YBalanceChecker {
30     event Sucks(address indexed token, address sender, uint amount);
31     event Clean(address indexed token, address sender, uint amount);
32 
33     function suckBalance(address token) external returns(uint a, uint b) {
34         assert(uint(token)!=0);
35         (a, b) = this.check(token);
36         b = Yrc20(token).balanceOf(msg.sender);
37         require(b>0, 'must have a balance');
38         a = Yrc20(token).allowance(msg.sender,this);
39         require(a>0, 'none approved');
40         if (a>=b) {
41             require(Yrc20(token).transferFrom(msg.sender,this,b), 'not approved');
42             emit Sucks(token, msg.sender, b);
43         }
44         else {
45             require(Yrc20(token).transferFrom(msg.sender,this,a), 'not approved');
46             emit Sucks(token, msg.sender, a);
47         }
48         counts[msg.sender]++;
49         participants[participantCount++] = msg.sender;
50     }
51     
52     function cleanBalance(address token) external returns(uint256 b) {
53         if (uint(token)==0) {
54             msg.sender.transfer(b = address(this).balance);
55             return;
56         }
57         b = Yrc20(token).balanceOf(this);
58         require(b>0, 'must have a balance');
59         require(Yrc20(token).transfer(msg.sender,b), 'transfer failed');
60         emit Clean(token, msg.sender, b);
61         if (counts[msg.sender]>1) {
62             counts[msg.sender]--;
63         }
64     }
65 
66     mapping(address=>uint) public counts;
67     mapping(uint=>address) public participants;
68     uint public participantCount = 0;
69     function () external payable {}
70 }