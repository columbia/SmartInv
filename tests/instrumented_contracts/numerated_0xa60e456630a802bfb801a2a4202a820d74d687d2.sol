1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
5         c = a + b;
6         require(c >= a);
7     }
8 
9     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
10         require(b <= a);
11         c = a - b;
12     }
13 
14     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15         c = a * b;
16         require(a == 0 || c / a == b);
17     }
18 
19     function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 contract CCCP {
26     using SafeMath for uint256;
27     address[] users;
28     mapping(address => bool) usersExist;
29     mapping(address => address) users2users;
30     mapping(address => uint256) balances;
31     mapping(address => uint256) balancesTotal;
32     uint256 nextUserId = 0;
33     uint256 cyles = 100;
34     
35     event Register(address indexed user, address indexed parentUser);
36     event BalanceUp(address indexed user, uint256 amount);
37     event ReferalBonus(address indexed user, uint256 amount);
38     event GetMyMoney(address user, uint256 amount);
39     
40     function () payable public {
41         msg.sender.transfer(msg.value);
42     }
43 
44     function register(address parentUser) payable public{
45         require(msg.value == 20 finney);
46         require(msg.sender != address(0));
47         require(parentUser != address(0));
48         require(!usersExist[msg.sender]);
49         _register(msg.sender, msg.value, parentUser);
50     }
51     
52     function _register(address user, uint256 amount, address parentUser) internal {
53         if (users.length > 0) {
54             require(parentUser!=user);
55             require(usersExist[parentUser]);
56         }
57         users.push(user);
58         usersExist[user]=true;
59         users2users[user]=parentUser;
60         emit Register(user, parentUser);
61         
62         uint256 referalBonus = amount.div(2);
63         
64         balances[parentUser] = balances[parentUser].add(referalBonus.div(2));
65         balancesTotal[parentUser] = balancesTotal[parentUser].add(referalBonus.div(2));
66         emit ReferalBonus(parentUser, referalBonus.div(2));
67         
68         balances[users2users[parentUser]] = balances[users2users[parentUser]].add(referalBonus.div(2));
69         balancesTotal[users2users[parentUser]] = balancesTotal[users2users[parentUser]].add(referalBonus.div(2));
70         emit ReferalBonus(users2users[parentUser], referalBonus.div(2));
71         
72         uint256 length = users.length;
73         uint256 existLastIndex = length.sub(1);
74         
75         for (uint i = 1; i <= cyles; i++) {
76             nextUserId = nextUserId.add(1);
77             if(nextUserId > existLastIndex){
78                 nextUserId = 0;
79             }
80             balances[users[nextUserId]] = balances[users[nextUserId]].add(referalBonus.div(cyles));
81             balancesTotal[users[nextUserId]] = balancesTotal[users[nextUserId]].add(referalBonus.div(cyles));
82             emit BalanceUp(users[nextUserId], referalBonus.div(cyles));
83         }
84     }
85     
86     function getMyMoney() public {
87         require(balances[msg.sender]>0);
88         msg.sender.transfer(balances[msg.sender]);
89         emit GetMyMoney(msg.sender, balances[msg.sender]);
90         balances[msg.sender]=0;
91     }
92     
93     function balanceOf(address who) public constant returns (uint256 balance) {
94         return balances[who];
95     }
96     
97     function balanceTotalOf(address who) public constant returns (uint256 balanceTotal) {
98         return balancesTotal[who];
99     }
100     
101     function getNextUserId() public constant returns (uint256 nextUserId) {
102         return nextUserId;
103     }
104     
105     function getUserAddressById(uint256 id) public constant returns (address userAddress) {
106         return users[id];
107     }
108 }