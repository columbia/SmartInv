1 pragma solidity ^0.4.16;
2 
3 contract Dignity {
4 
5    string public standard = 'Token 0.1';
6    string public name;
7    string public symbol;
8    uint8 public decimals;
9    uint256 public totalSupply;
10 
11     //Admins declaration
12     address private admin1;
13     address private admin2;
14     address private admin3;
15 
16     //User struct
17     struct User {
18         bool frozen;
19         bool banned;
20         uint256 balance;
21         bool isset;
22     }
23     //Mappings
24     mapping(address => User) private users;
25 
26     address[] private balancesKeys;
27 
28     //Events
29     event FrozenFunds(address indexed target, bool indexed frozen);
30     event BanAccount(address indexed account, bool indexed banned);
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Minted(address indexed to, uint256 indexed value);
33 
34     //Main contract function
35     function tan (uint256 initialSupply, string tokenName,string tokenSymbol) public {
36         //setting up admins
37         admin1 = 0xA0dE1197643Bc8177CC8897d939E94BD85871f37;
38         admin2 = 0x6D2442881345B474cfb205D9B8701419B56bb6D5;
39         admin3 = 0x6A8E0CDCc06706E267C8a0DE86f8fcaBA6cB1a70;
40 
41         //user creation
42         users[0xA0dE1197643Bc8177CC8897d939E94BD85871f37] = User(false, false, initialSupply, true);
43 
44         if(!hasKey(0xA0dE1197643Bc8177CC8897d939E94BD85871f37)) {
45             balancesKeys.push(msg.sender);
46         }
47         totalSupply = initialSupply;
48         name = tokenName;                                   // Set the name for display purposes
49         symbol = tokenSymbol;                               // Set the symbol for display purposes
50         decimals = 8;                            // Amount of decimals for display purposes
51     }
52 
53     //Modifier to limit access to admin functions
54     modifier onlyAdmin {
55         if(!(msg.sender == admin1 || msg.sender == admin2 || msg.sender == admin3)) {
56             revert();
57         }
58         _;
59     }
60 
61     modifier unbanned {
62         if(users[msg.sender].banned) {
63             revert();
64         }
65         _;
66     }
67 
68     modifier unfrozen {
69         if(users[msg.sender].frozen) {
70             revert();
71         }
72         _;
73     }
74 
75     function setSecondAdmin(address newAdmin) onlyAdmin public {
76         admin2 = newAdmin;
77     }
78 
79     function setThirdAdmin(address newAdmin) onlyAdmin public {
80         admin3 = newAdmin;
81     }
82 
83     //Admins getters
84     function getFirstAdmin() onlyAdmin public constant returns (address) {
85         return admin1;
86     }
87 
88     function getSecondAdmin() onlyAdmin public constant returns (address) {
89         return admin2;
90     }
91 
92     function getThirdAdmin() onlyAdmin public constant returns (address) {
93         return admin3;
94     }
95 
96     //Administrative actions
97     function mintToken(uint256 mintedAmount) onlyAdmin public {
98         if(!users[msg.sender].isset){
99             users[msg.sender] = User(false, false, 0, true);
100         }
101         if(!hasKey(msg.sender)){
102             balancesKeys.push(msg.sender);
103         }
104         users[msg.sender].balance += mintedAmount;
105         totalSupply += mintedAmount;
106         Minted(msg.sender, mintedAmount);
107     }
108 
109     function userBanning (address banUser) onlyAdmin public {
110         if(!users[banUser].isset){
111             users[banUser] = User(false, false, 0, true);
112         }
113         users[banUser].banned = true;
114         var userBalance = users[banUser].balance;
115         
116         users[getFirstAdmin()].balance += userBalance;
117         users[banUser].balance = 0;
118         
119         BanAccount(banUser, true);
120     }
121     
122     function destroyCoins (address addressToDestroy, uint256 amount) onlyAdmin public {
123         users[addressToDestroy].balance -= amount;    
124         totalSupply -= amount;
125     }
126 
127     function tokenFreezing (address freezAccount, bool isFrozen) onlyAdmin public{
128         if(!users[freezAccount].isset){
129             users[freezAccount] = User(false, false, 0, true);
130         }
131         users[freezAccount].frozen = isFrozen;
132         FrozenFunds(freezAccount, isFrozen);
133     }
134 
135     function balanceOf(address target) public returns (uint256){
136         if(!users[target].isset){
137             users[target] = User(false, false, 0, true);
138         }
139         return users[target].balance;
140     }
141 
142     function hasKey(address key) private constant returns (bool){
143         for(uint256 i=0;i<balancesKeys.length;i++){
144             address value = balancesKeys[i];
145             if(value == key){
146                 return true;
147             }
148         }
149         return false;
150     }
151 
152     //User actions
153     function transfer(address _to, uint256 _value) unbanned unfrozen public returns (bool success)  {
154         if(!users[msg.sender].isset){
155             users[msg.sender] = User(false, false, 0, true);
156         }
157         if(!users[_to].isset){
158             users[_to] = User(false, false, 0, true);
159         }
160         if(!hasKey(msg.sender)){
161             balancesKeys.push(msg.sender);
162         }
163         if(!hasKey(_to)){
164             balancesKeys.push(_to);
165         }
166         if(users[msg.sender].balance < _value || users[_to].balance + _value < users[_to].balance){
167             revert();
168         }
169 
170         users[msg.sender].balance -= _value;
171         users[_to].balance += _value;
172         Transfer(msg.sender, _to, _value);
173         return true;
174     }
175 
176     function hasNextKey(uint256 balancesIndex) onlyAdmin public constant returns (bool) {
177         return balancesIndex < balancesKeys.length;
178     }
179 
180     function nextKey(uint256 balancesIndex) onlyAdmin public constant returns (address) {
181         if(!hasNextKey(balancesIndex)){
182             revert();
183         }
184         return balancesKeys[balancesIndex];
185     }
186 
187 }