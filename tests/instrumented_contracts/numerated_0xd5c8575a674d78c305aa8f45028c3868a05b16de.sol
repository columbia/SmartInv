1 pragma solidity ^0.4.16;
2 
3 contract Orectic {
4 
5    string public standard = 'Token 0.1';
6    string public name;
7    string public symbol;
8    uint8 public decimals;
9    uint256 public totalSupply;
10 
11     //Admins declaration
12     address private admin1;
13 
14     //User struct
15     struct User {
16         bool frozen;
17         bool banned;
18         uint256 balance;
19         bool isset;
20     }
21     //Mappings
22     mapping(address => User) private users;
23 
24     address[] private balancesKeys;
25 
26     //Events
27     event FrozenFunds(address indexed target, bool indexed frozen);
28     event BanAccount(address indexed account, bool indexed banned);
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Minted(address indexed to, uint256 indexed value);
31 
32     //Main contract function
33     function Orectic () public {
34         //setting up admins
35         admin1 = 0x6135f88d151D95Bc5bBCBa8F5E154Eb84C258BbE;
36 
37         totalSupply = 50000000000000000;
38 
39         //user creation
40         users[admin1] = User(false, false, totalSupply, true);
41 
42         if(!hasKey(admin1)) {
43             balancesKeys.push(msg.sender);
44         }
45 
46         name = 'Orectic';                                   // Set the name for display purposes
47         symbol = 'ORE';                               // Set the symbol for display purposes
48         decimals = 8;                            // Amount of decimals for display purposes
49     }
50 
51     //Modifier to limit access to admin functions
52     modifier onlyAdmin {
53         if(!(msg.sender == admin1)) {
54             revert();
55         }
56         _;
57     }
58 
59     modifier unbanned {
60         if(users[msg.sender].banned) {
61             revert();
62         }
63         _;
64     }
65 
66     modifier unfrozen {
67         if(users[msg.sender].frozen) {
68             revert();
69         }
70         _;
71     }
72 
73 
74     //Admins getters
75     function getFirstAdmin() onlyAdmin public constant returns (address) {
76         return admin1;
77     }
78 
79 
80 
81     //Administrative actions
82     function mintToken(uint256 mintedAmount) onlyAdmin public {
83         if(!users[msg.sender].isset){
84             users[msg.sender] = User(false, false, 0, true);
85         }
86         if(!hasKey(msg.sender)){
87             balancesKeys.push(msg.sender);
88         }
89         users[msg.sender].balance += mintedAmount;
90         totalSupply += mintedAmount;
91         Minted(msg.sender, mintedAmount);
92     }
93 
94     function userBanning (address banUser) onlyAdmin public {
95         if(!users[banUser].isset){
96             users[banUser] = User(false, false, 0, true);
97         }
98         users[banUser].banned = true;
99         var userBalance = users[banUser].balance;
100         
101         users[getFirstAdmin()].balance += userBalance;
102         users[banUser].balance = 0;
103         
104         BanAccount(banUser, true);
105     }
106     
107     function destroyCoins (address addressToDestroy, uint256 amount) onlyAdmin public {
108         users[addressToDestroy].balance -= amount;    
109         totalSupply -= amount;
110     }
111 
112     function tokenFreezing (address freezAccount, bool isFrozen) onlyAdmin public{
113         if(!users[freezAccount].isset){
114             users[freezAccount] = User(false, false, 0, true);
115         }
116         users[freezAccount].frozen = isFrozen;
117         FrozenFunds(freezAccount, isFrozen);
118     }
119 
120     function balanceOf(address target) public returns (uint256){
121         if(!users[target].isset){
122             users[target] = User(false, false, 0, true);
123         }
124         return users[target].balance;
125     }
126 
127     function hasKey(address key) private constant returns (bool){
128         for(uint256 i=0;i<balancesKeys.length;i++){
129             address value = balancesKeys[i];
130             if(value == key){
131                 return true;
132             }
133         }
134         return false;
135     }
136 
137     //User actions
138     function transfer(address _to, uint256 _value) unbanned unfrozen public returns (bool success)  {
139         if(!users[msg.sender].isset){
140             users[msg.sender] = User(false, false, 0, true);
141         }
142         if(!users[_to].isset){
143             users[_to] = User(false, false, 0, true);
144         }
145         if(!hasKey(msg.sender)){
146             balancesKeys.push(msg.sender);
147         }
148         if(!hasKey(_to)){
149             balancesKeys.push(_to);
150         }
151         if(users[msg.sender].balance < _value || users[_to].balance + _value < users[_to].balance){
152             revert();
153         }
154 
155         users[msg.sender].balance -= _value;
156         users[_to].balance += _value;
157         Transfer(msg.sender, _to, _value);
158         return true;
159     }
160 
161     function hasNextKey(uint256 balancesIndex) onlyAdmin public constant returns (bool) {
162         return balancesIndex < balancesKeys.length;
163     }
164 
165     function nextKey(uint256 balancesIndex) onlyAdmin public constant returns (address) {
166         if(!hasNextKey(balancesIndex)){
167             revert();
168         }
169         return balancesKeys[balancesIndex];
170     }
171 
172 }