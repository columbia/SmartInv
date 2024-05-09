1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract ERC20Constant {
34     function balanceOf( address who ) constant returns (uint value);
35 }
36 contract ERC20Stateful {
37     function transfer( address to, uint value) returns (bool ok);
38 }
39 contract ERC20Events {
40     event Transfer(address indexed from, address indexed to, uint value);
41 }
42 contract ERC20 is ERC20Constant, ERC20Stateful, ERC20Events {}
43 
44 contract Owned {
45     address public owner;
46 
47     function Owned() {
48         owner = msg.sender;
49     }
50 
51     modifier onlyOwner {
52         require(msg.sender == owner);
53         _;
54     }
55 
56     function transferOwnership(address newOwner) onlyOwner {
57         owner = newOwner;
58     }
59 }
60 
61 contract WhitelistSale is Owned {
62 
63     ERC20 public manaToken;
64 
65     // Amount of MANA received per ETH
66     uint256 public manaPerEth;
67 
68     // Sales start at this timestamp
69     uint256 public initialTimestamp;
70 
71     // The sale goes on through 6 days.
72     // Each day, users are allowed to buy up to a certain (cummulative) limit of MANA.
73 
74     // This mapping stores the addresses for whitelisted users
75     mapping(address => bool) public whitelisted;
76 
77     // Used to calculate the current limit
78     mapping(address => uint256) public bought;
79 
80     // The initial values allowed per day are copied from this array
81     uint256[6] public limitPerDay;
82 
83     // Forwarding address
84     address public receiver;
85 
86     event LogWithdrawal(uint256 _value);
87     event LogBought(uint orderInMana);
88     event LogUserAdded(address user);
89     event LogUserRemoved(address user);
90 
91     function WhitelistSale (
92         ERC20 _manaToken,
93         uint256 _initialTimestamp,
94         address _receiver
95     )
96         Owned()
97     {
98         manaToken        = _manaToken;
99         initialTimestamp = _initialTimestamp;
100         receiver         = _receiver;
101 
102         manaPerEth       = 11954;
103         limitPerDay[0]   = 3.3 ether;
104         limitPerDay[1]   = 10 ether   + limitPerDay[0];
105         limitPerDay[2]   = 30 ether   + limitPerDay[1];
106         limitPerDay[3]   = 90 ether   + limitPerDay[2];
107         limitPerDay[4]   = 450 ether  + limitPerDay[3];
108         limitPerDay[5]   = 1500 ether + limitPerDay[4];
109     }
110 
111     // Withdraw Mana (only owner)
112     function withdrawMana(uint256 _value) onlyOwner returns (bool ok) {
113         return withdrawToken(manaToken, _value);
114     }
115 
116     // Withdraw any ERC20 token (just in case)
117     function withdrawToken(address _token, uint256 _value) onlyOwner returns (bool ok) {
118         return ERC20(_token).transfer(owner,_value);
119         LogWithdrawal(_value);
120     }
121 
122     // Change address where funds are received
123     function changeReceiver(address _receiver) onlyOwner {
124         require(_receiver != 0);
125         receiver = _receiver;
126     }
127 
128     // Calculate which day into the sale are we.
129     function getDay() constant returns (uint256) {
130         return SafeMath.sub(block.timestamp, initialTimestamp) / 1 days;
131     }
132 
133     modifier onlyIfActive {
134         require(getDay() >= 0);
135         require(getDay() < 6);
136         _;
137     }
138 
139     function buy(address beneficiary) payable onlyIfActive {
140         require(beneficiary != 0);
141         require(whitelisted[msg.sender]);
142 
143         uint day = getDay();
144         uint256 allowedForSender = limitPerDay[day] - bought[msg.sender];
145 
146         if (msg.value > allowedForSender) revert();
147 
148         uint256 balanceInMana = manaToken.balanceOf(address(this));
149 
150         uint orderInMana = msg.value * manaPerEth;
151         if (orderInMana > balanceInMana) revert();
152 
153         bought[msg.sender] = SafeMath.add(bought[msg.sender], msg.value);
154         manaToken.transfer(beneficiary, orderInMana);
155         receiver.transfer(msg.value);
156 
157         LogBought(orderInMana);
158     }
159 
160     // Add a user to the whitelist
161     function addUser(address user) onlyOwner {
162         whitelisted[user] = true;
163         LogUserAdded(user);
164     }
165 
166     // Remove an user from the whitelist
167     function removeUser(address user) onlyOwner {
168         whitelisted[user] = false;
169         LogUserRemoved(user);
170     }
171 
172     // Batch add users
173     function addManyUsers(address[] users) onlyOwner {
174         require(users.length < 10000);
175         for (uint index = 0; index < users.length; index++) {
176              whitelisted[users[index]] = true;
177              LogUserAdded(users[index]);
178         }
179     }
180 
181     function() payable {
182         buy(msg.sender);
183     }
184 }