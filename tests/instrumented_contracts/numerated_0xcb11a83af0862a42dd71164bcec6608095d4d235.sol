1 pragma solidity ^0.4.24;
2 
3 contract EGCSnakesAndLadders {
4 
5     using SafeMath for uint;
6 
7     struct User {
8         uint position;
9         uint points;
10         uint rolls;
11         mapping (uint => uint) history;
12     }
13 
14     address public owner;
15     uint public total_points;
16     mapping (address => User) public users;
17 
18     uint private seed;
19     mapping (uint => uint) private ups;
20     mapping (uint => uint) private downs;
21     mapping (uint => uint) private coins;
22     
23     constructor() public {
24         owner = msg.sender;
25         total_points = 0;
26         seed = 1;
27 
28         ups[11] = 17;
29         ups[25] = 20;
30         ups[36] = 7;
31         ups[42] = 20;
32         ups[53] = 20;
33         ups[76] = 7;
34         ups[87] = 5;
35 
36         downs[13] = 7;
37         downs[23] = 7;
38         downs[39] = 20;
39         downs[58] = 17;
40         downs[67] = 20;
41         downs[74] = 20;
42         downs[91] = 20;
43         downs[98] = 20;
44         
45         coins[15] = 10;
46         coins[38] = 10;
47         coins[49] = 10;
48         coins[55] = 10;
49         coins[79] = 10;
50         coins[85] = 10;
51         coins[97] = 10;
52     }
53 
54     function publicGetExchangeRate() view public returns (uint) {
55         return calcExchangeRate();
56     }
57 
58     function publicGetUserInfo(address user) view public returns (uint[4]) {
59         return [
60             users[user].position,
61             users[user].points,
62             users[user].rolls,
63             users[user].points.mul(calcExchangeRate())
64         ];
65     }
66 
67     function publicGetUserHistory(address user, uint start) view public returns (uint[10]) {
68         return [
69             users[user].history[start],
70             users[user].history[start.add(1)],
71             users[user].history[start.add(2)],
72             users[user].history[start.add(3)],
73             users[user].history[start.add(4)],
74             users[user].history[start.add(5)],
75             users[user].history[start.add(6)],
76             users[user].history[start.add(7)],
77             users[user].history[start.add(8)],
78             users[user].history[start.add(9)]
79         ];
80     }
81 
82     function userPlay() public payable {
83         require(msg.value == 20 finney);
84 
85         uint random = calcRandomNumber();
86 
87         uint bonus = users[msg.sender].position.div(100);
88         bonus = (bonus < 3) ? (bonus.add(1)) : 3;
89 
90         uint points = users[msg.sender].points.add(bonus);
91         uint position = users[msg.sender].position.add(random);
92         uint total = total_points.sub(users[msg.sender].points);
93 
94         uint position_ups = ups[position % 100];
95         uint position_downs = downs[position % 100];
96         uint position_coins = coins[position % 100];
97 
98         points = points.add(random);
99 
100         if (position_ups > 0) {
101             position = position.add(position_ups);
102             points = points.add(position_ups);
103         }
104         
105         if (position_downs > 0) {
106             position = position.sub(position_downs);
107             points = points.sub(position_downs);
108         }
109 
110         if (position_coins > 0) {
111             points = points.add(position_coins);
112         }
113 
114         total = total.add(1);
115 
116         seed = random.mul(uint(blockhash(block.number - 1)) % 20);
117         users[owner].points = users[owner].points.add(1);
118         total_points = total.add(points);
119 
120         users[msg.sender].position = position;
121         users[msg.sender].points = points;
122         users[msg.sender].rolls = users[msg.sender].rolls.add(1);
123         users[msg.sender].history[users[msg.sender].rolls] = random;
124     }
125 
126     function userWithdraw() public {
127         uint amount = users[msg.sender].points.mul(calcExchangeRate());
128         require(amount > 0);
129 
130         total_points = total_points.sub(users[msg.sender].points);
131         users[msg.sender].position = 0;
132         users[msg.sender].points = 0;
133         users[msg.sender].rolls = 0;
134 
135         msg.sender.transfer(amount);
136     }
137 
138     function calcExchangeRate() view private returns (uint) {
139         return address(this).balance.div(total_points);
140     }
141 
142     function calcRandomNumber() view private returns (uint) {
143         return (uint(blockhash(block.number - seed)) ^ uint(msg.sender)) % 6 + 1;
144     }
145 }
146 
147 library SafeMath {
148 
149     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
150         if (a == 0) {
151             return 0;
152         }
153         c = a * b;
154         assert(c / a == b);
155         return c;
156     }
157 
158     function div(uint256 a, uint256 b) internal pure returns (uint256) {
159         return a / b;
160     }
161 
162     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
163         assert(b <= a);
164         return a - b;
165     }
166 
167     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
168         c = a + b;
169         assert(c >= a);
170         return c;
171     }
172 }