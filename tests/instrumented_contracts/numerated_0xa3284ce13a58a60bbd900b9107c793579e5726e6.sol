1 pragma solidity ^0.4.24;
2 
3 contract VerityToken {
4     function totalSupply() public constant returns (uint);
5     function balanceOf(address tokenOwner) public constant returns (uint balance);
6     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
7     function transfer(address to, uint tokens) public returns (bool success);
8     function approve(address spender, uint tokens) public returns (bool success);
9     function transferFrom(address from, address to, uint tokens) public returns (bool success);
10 
11     event Transfer(address indexed from, address indexed to, uint tokens);
12     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
13 }
14 
15 contract MasterDataProviderLock {
16   address public owner;
17   address public tokenAddress;
18   bool public allFundsCanBeUnlocked = false;
19   uint public lastLockingTime;
20 
21   // amount => lockedUntil
22   mapping(uint => uint) public validLockingAmountToPeriod;
23   mapping(address => mapping(string => uint)) lockingData;
24 
25   event Withdrawn(address indexed withdrawer, uint indexed withdrawnAmount);
26   event FundsLocked(
27     address indexed user,
28     uint indexed lockedAmount,
29     uint indexed lockedUntil
30   );
31   event AllFundsCanBeUnlocked(
32     uint indexed triggeredTimestamp,
33     bool indexed canAllFundsBeUnlocked
34   );
35 
36   modifier onlyOwner() {
37     require(msg.sender == owner);
38     _;
39   }
40 
41   modifier onlyOnceLockingPeriodIsOver(address _user) {
42     require(
43       (now >= lockingData[_user]["lockedUntil"] || allFundsCanBeUnlocked)
44     );
45     _;
46   }
47 
48   modifier checkValidLockingAmount(uint _funds) {
49     require(validLockingAmountToPeriod[_funds] != 0);
50     _;
51   }
52 
53   modifier checkUsersTokenBalance(uint _fundsToTransfer) {
54     require(
55       _fundsToTransfer <= VerityToken(tokenAddress).balanceOf(msg.sender)
56     );
57     _;
58   }
59 
60   modifier onlyOncePerUser(address _user) {
61     require(
62       lockingData[_user]["amount"] == 0 &&
63         lockingData[_user]["lockedUntil"] == 0
64     );
65     _;
66   }
67 
68   modifier checkValidLockingTime() {
69     require(now <= lastLockingTime);
70     _;
71   }
72 
73   modifier lastLockingTimeIsInTheFuture(uint _lastLockingTime) {
74     require(now < _lastLockingTime);
75     _;
76   }
77 
78   modifier checkLockIsNotTerminated() {
79     require(allFundsCanBeUnlocked == false);
80     _;
81   }
82 
83   constructor(
84     address _tokenAddress,
85     uint _lastLockingTime,
86     uint[3] _lockingAmounts,
87     uint[3] _lockingPeriods
88   )
89     public
90     lastLockingTimeIsInTheFuture(_lastLockingTime)
91   {
92     owner = msg.sender;
93     tokenAddress = _tokenAddress;
94     lastLockingTime = _lastLockingTime;
95 
96     // expects "ether" format. Number is converted to wei:  num * 10**18
97     setValidLockingAmountToPeriod(_lockingAmounts, _lockingPeriods);
98   }
99 
100   function lockFunds(uint _tokens)
101     public
102     checkValidLockingTime()
103     checkLockIsNotTerminated()
104     checkUsersTokenBalance(_tokens)
105     checkValidLockingAmount(_tokens)
106     onlyOncePerUser(msg.sender)
107   {
108     require(
109       VerityToken(tokenAddress).transferFrom(msg.sender, address(this), _tokens)
110     );
111 
112     lockingData[msg.sender]["amount"] = _tokens;
113     lockingData[msg.sender]["lockedUntil"] = validLockingAmountToPeriod[_tokens];
114 
115     emit FundsLocked(
116       msg.sender,
117       _tokens,
118       validLockingAmountToPeriod[_tokens]
119     );
120   }
121 
122   function withdrawFunds()
123     public
124     onlyOnceLockingPeriodIsOver(msg.sender)
125   {
126     uint amountToBeTransferred = lockingData[msg.sender]["amount"];
127     lockingData[msg.sender]["amount"] = 0;
128     VerityToken(tokenAddress).transfer(msg.sender, amountToBeTransferred);
129 
130     emit Withdrawn(
131       msg.sender,
132       amountToBeTransferred
133     );
134   }
135 
136   function terminateTokenLock() public onlyOwner() {
137     allFundsCanBeUnlocked = true;
138 
139     emit AllFundsCanBeUnlocked(
140       now,
141       allFundsCanBeUnlocked
142     );
143   }
144 
145   function getUserData(address _user) public view returns (uint[2]) {
146     return [lockingData[_user]["amount"], lockingData[_user]["lockedUntil"]];
147   }
148 
149   function setValidLockingAmountToPeriod(
150     uint[3] _lockingAmounts,
151     uint[3] _lockingPeriods
152   )
153   private
154   {
155     validLockingAmountToPeriod[_lockingAmounts[0] * 10 ** 18] = _lockingPeriods[0];
156     validLockingAmountToPeriod[_lockingAmounts[1] * 10 ** 18] = _lockingPeriods[1];
157     validLockingAmountToPeriod[_lockingAmounts[2] * 10 ** 18] = _lockingPeriods[2];
158   }
159 }