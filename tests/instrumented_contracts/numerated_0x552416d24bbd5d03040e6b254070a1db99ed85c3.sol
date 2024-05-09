1 pragma solidity ^0.4.23;
2 
3 contract ERC20Basic {
4   
5   
6   function totalSupply() public view returns (uint256);
7   function balanceOf(address who) public view returns (uint256);
8   function transfer(address to, uint256 value) public returns (bool);
9   event Transfer(address indexed from, address indexed to, uint256 value);
10 }
11 
12 contract ERC20 is ERC20Basic {
13   
14     
15   function allowance(address owner, address spender)
16     public view returns (uint256);
17 
18   function transferFrom(address from, address to, uint256 value)
19     public returns (bool);
20 
21   function approve(address spender, uint256 value) public returns (bool);
22   event Approval(
23     address indexed owner,
24     address indexed spender,
25     uint256 value
26   );
27 }
28 
29 
30 /**
31  * @title SafeERC20
32  * @dev 围绕ERC20操作发生故障的包装程序.
33  * 可以在合约中通过这样使用这个库 `using SafeERC20 for ERC20;` 来使用安全的操作`token.safeTransfer(...)`
34  */
35 library SafeERC20 {
36   
37   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
38     require(token.transfer(to, value));
39   }
40 
41   function safeTransferFrom(
42     ERC20 token,
43     address from,
44     address to,
45     uint256 value
46   )
47     internal
48   {
49     require(token.transferFrom(from, to, value));
50   }
51 
52   function safeApprove(ERC20 token, address spender, uint256 value) internal {
53     require(token.approve(spender, value));
54   }
55 }
56 
57 /**
58  * @title TokenTimelock 锁定期释放token
59  * @dev TokenTimelock 是一个令token持有人合同，将允许一个受益人在给定的发布时间之后提取token
60  */
61 contract TokenTimelock {
62   //这里用到了上面的SafeERC20
63   using SafeERC20 for ERC20Basic;
64 
65   // ERC20 basic token contract being held
66   ERC20Basic public token;
67   address public owner;
68   
69   // token 释放受益人组  
70   mapping (address => uint256) public beneficiary;
71   address[] beneficial;
72   // token可以被释放的时间戳
73   uint256 public releaseTime;
74   // 对token，受益人address和释放时间初始化
75   constructor(
76     ERC20Basic _token,
77     uint256 _releaseTime
78   )
79     public
80   {
81     require(_releaseTime > block.timestamp);
82     token = _token;
83     owner = msg.sender;
84     releaseTime = _releaseTime;
85   }
86   
87   function pushInvestor(address Ins,uint256 count) public  {
88       require (msg.sender == owner);
89       require (block.timestamp < releaseTime);
90       beneficial.push(Ins);
91       beneficiary[Ins] = count;
92   }
93   function chkBalance() public view returns (uint) {
94          return token.balanceOf(this);
95       
96   }
97   /**
98    * @notice 将时间限制内的token转移给受益人.
99    */
100   function release() public {
101     require(block.timestamp >= releaseTime);
102     
103     for (uint i=0;i<beneficial.length;i++ ){
104         uint256 amount = token.balanceOf(this);
105         require(amount > 0);
106         uint256 count = beneficiary[beneficial[i]];
107         if (amount>=count){
108              beneficiary[beneficial[i]] = 0;
109              token.safeTransfer(beneficial[i], count);
110         }
111     }
112   }
113   /**
114    * @notice owner可以退回合约内的token.
115    */
116   function revoke() public {
117       require (msg.sender == owner);
118       uint256 amount = token.balanceOf(this);
119       require(amount > 0);
120       token.safeTransfer(owner, amount);
121   }
122 }