1 pragma solidity ^0.4.25;
2 
3 
4 contract ArceonMoneyNetwork {
5     using SafeMath for uint256;
6     address public owner;
7     address parentUser;
8     address[] users;
9    
10     mapping(address => bool) usersExist;
11     mapping(address => address) users2users;
12     mapping(address => uint256) balances;
13     mapping(address => uint256) balancesTotal;
14     
15     uint256 nextUserId = 0;
16     uint256 cyles = 5;
17     
18   constructor() public {owner = msg.sender; }
19   
20    modifier onlyOwner {if (msg.sender == owner) _;}
21     
22     
23     
24     
25     event Register(address indexed user, address indexed parentUser);
26     event BalanceUp(address indexed user, uint256 amount);
27     event ReferalBonus(address indexed user, uint256 amount);
28     event TransferMyMoney(address user, uint256 amount);
29     
30     
31     
32     function bytesToAddress(bytes bys) private pure returns (address addr) {
33         assembly {
34             addr := mload(add(bys, 20))
35         }
36     }
37     
38     
39     function () payable public{
40 	    parentUser = bytesToAddress(msg.data);
41 	    if (msg.value==0){ transferMyMoney(); return;}
42         require(msg.value == 50 finney);
43         require(msg.sender != address(0));
44         require(parentUser != address(0));
45         require(!usersExist[msg.sender]);
46         _register(msg.sender, msg.value);
47     }
48     
49     
50     function _register(address user, uint256 amount) internal {
51         
52         
53          
54         if (users.length > 0) {
55             require(parentUser!=user);
56             require(usersExist[parentUser]); 
57         }
58         
59        if (users.length ==0) {users2users[parentUser]=parentUser;} 
60        
61        
62         users.push(user);
63         usersExist[user]=true;
64         users2users[user]=parentUser;
65         
66         
67         emit Register(user, parentUser);
68         
69         uint256 referalBonus = amount.div(2);
70         
71         if (cyles==0) {referalBonus = amount;} //we exclude a money wave
72         
73         balances[parentUser] = balances[parentUser].add(referalBonus.div(2));
74         balancesTotal[parentUser] = balancesTotal[parentUser].add(referalBonus.div(2));
75         
76         emit ReferalBonus(parentUser, referalBonus.div(2));
77         
78         balances[users2users[parentUser]] = balances[users2users[parentUser]].add(referalBonus.div(2));
79         balancesTotal[users2users[parentUser]] = balancesTotal[users2users[parentUser]].add(referalBonus.div(2));
80         
81         emit ReferalBonus(users2users[parentUser], referalBonus.div(2));
82         
83         uint256 length = users.length;
84         uint256 existLastIndex = length.sub(1);
85         
86         //we exclude a money wave
87         if (cyles!=0){ 
88             
89         for (uint i = 1; i <= cyles; i++) {
90             nextUserId = nextUserId.add(1);
91 			
92             if(nextUserId > existLastIndex){ nextUserId = 0;}
93             
94             balances[users[nextUserId]] = balances[users[nextUserId]].add(referalBonus.div(cyles));
95             balancesTotal[users[nextUserId]] = balancesTotal[users[nextUserId]].add(referalBonus.div(cyles));
96             
97             emit BalanceUp(users[nextUserId], referalBonus.div(cyles));
98         }
99       
100         }  //we exclude a money wave
101     
102     }
103     
104     function transferMyMoney() public {
105         require(balances[msg.sender]>0);
106         msg.sender.transfer(balances[msg.sender]);
107         emit TransferMyMoney(msg.sender, balances[msg.sender]);
108 		balances[msg.sender]=0;
109     }
110     
111     
112     
113     
114       function ViewRealBalance(address input) public view returns (uint256 balanceReal) {  
115        balanceReal= balances[input];
116        balanceReal=balanceReal.div(1000000000000);
117           return balanceReal;
118     }
119     
120    
121     function ViewTotalBalance(address input)   public view returns (uint256 balanceTotal) {
122       balanceTotal=balancesTotal [input];
123       balanceTotal=balanceTotal.div(1000000000000);
124           return balanceTotal;
125    }
126    
127     
128    function viewBlockchainArceonMoneyNetwork(uint256 id) public view  returns (address userAddress) {
129         return users[id];
130     } 
131     
132     
133     function  CirclePoints() public view returns (uint256 CirclePoint) {
134         CirclePoint = nextUserId;
135         
136         return  CirclePoint;
137     }
138     
139     function  NumberUser() public view returns (uint256 numberOfUser) {
140         
141         numberOfUser = users.length;
142         
143         return numberOfUser;
144     } 
145     
146     function  LenCyless() public view returns (uint256 LenCyles) {
147         
148         LenCyles = cyles;
149         
150         return LenCyles;
151     } 
152     
153     
154     
155     function newCyles(uint256 _newCyles) external onlyOwner {
156       
157        cyles = _newCyles;
158     }
159     
160 }    
161     
162    library SafeMath {
163        
164     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
165         c = a + b;
166         require(c >= a);
167     }
168 
169     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
170         require(b <= a);
171         c = a - b;
172     }
173 
174     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
175         c = a * b;
176         require(a == 0 || c / a == b);
177     }
178     
179     function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
180         require(b > 0);
181         c = a / b;
182     }
183     
184 }