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
15 contract ValidationNodeLock {
16   address public owner;
17   address public tokenAddress;
18   bool public allFundsCanBeUnlocked = false;
19   uint public lastLockingTime;
20   // 30_000 evt tokens minimal investment
21   uint public nodePrice = 30000 * 10**18;
22 
23   uint public lockedUntil;
24   mapping(address => mapping(string => uint)) lockingData;
25 
26   event Withdrawn(address indexed withdrawer, uint indexed withdrawnAmount);
27   event FundsLocked(
28     address indexed user,
29     uint indexed lockedAmount,
30     uint indexed validationNodes
31   );
32   event AllFundsCanBeUnlocked(
33     uint indexed triggeredTimestamp,
34     bool indexed canAllFundsBeUnlocked
35   );
36 
37   modifier onlyOwner() {
38     require(msg.sender == owner);
39     _;
40   }
41 
42   modifier lastLockingTimeIsInTheFuture(uint _lastLockingTime) {
43     require(now < _lastLockingTime);
44     _;
45   }
46 
47   modifier onlyOnceLockingPeriodIsOver() {
48     require(now >= lockedUntil || allFundsCanBeUnlocked);
49     _;
50   }
51 
52   modifier checkUsersTokenBalance(uint _fundsToTransfer) {
53     require(
54       _fundsToTransfer <= VerityToken(tokenAddress).balanceOf(msg.sender)
55     );
56     _;
57   }
58 
59   modifier checkValidLockingTime() {
60     require(now <= lastLockingTime);
61     _;
62   }
63 
64   modifier checkValidLockingArguments(uint _tokens, uint _nodes) {
65     require(_tokens >= nodePrice && _nodes >= 1);
66     _;
67   }
68 
69   modifier checkValidLockingAmount(uint _tokens, uint _nodes) {
70     require(_tokens == (_nodes * nodePrice));
71     _;
72   }
73 
74   modifier lockedUntilIsInTheFuture(uint _lockedUntil) {
75     require(now < _lockedUntil);
76     _;
77   }
78 
79   modifier lastLockingTimeIsBeforeLockedUntil(
80     uint _lastLockingTime,
81     uint _lockedUntil
82   )
83   {
84     require(_lastLockingTime < _lockedUntil);
85     _;
86   }
87 
88   modifier checkLockIsNotTerminated() {
89     require(allFundsCanBeUnlocked == false);
90     _;
91   }
92 
93   constructor(address _tokenAddress, uint _lastLockingTime, uint _lockedUntil)
94     public
95     lastLockingTimeIsInTheFuture(_lastLockingTime)
96     lockedUntilIsInTheFuture(_lockedUntil)
97     lastLockingTimeIsBeforeLockedUntil(_lastLockingTime, _lockedUntil)
98   {
99     owner = msg.sender;
100     tokenAddress = _tokenAddress;
101     lastLockingTime = _lastLockingTime;
102     lockedUntil = _lockedUntil;
103   }
104 
105   function lockFunds(uint _tokens, uint _nodes)
106     public
107     checkValidLockingTime()
108     checkLockIsNotTerminated()
109     checkUsersTokenBalance(_tokens)
110     checkValidLockingArguments(_tokens, _nodes)
111     checkValidLockingAmount(_tokens, _nodes)
112   {
113     require(
114       VerityToken(tokenAddress).transferFrom(msg.sender, address(this), _tokens)
115     );
116 
117     lockingData[msg.sender]["amount"] += _tokens;
118     lockingData[msg.sender]["nodes"] += _nodes;
119 
120     emit FundsLocked(
121       msg.sender,
122       _tokens,
123       _nodes
124     );
125   }
126 
127   function withdrawFunds()
128     public
129     onlyOnceLockingPeriodIsOver()
130   {
131     uint amountToBeTransferred = lockingData[msg.sender]["amount"];
132     lockingData[msg.sender]["amount"] = 0;
133     VerityToken(tokenAddress).transfer(msg.sender, amountToBeTransferred);
134 
135     emit Withdrawn(
136       msg.sender,
137       amountToBeTransferred
138     );
139   }
140 
141   function terminateTokenLock() public onlyOwner() {
142     allFundsCanBeUnlocked = true;
143 
144     emit AllFundsCanBeUnlocked(
145       now,
146       allFundsCanBeUnlocked
147     );
148   }
149 
150   function getUserData(address _user) public view returns (uint[2]) {
151     return [lockingData[_user]["amount"], lockingData[_user]["nodes"]];
152   }
153 }