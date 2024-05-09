1 pragma solidity ^0.4.16;
2 
3 contract Dignity {
4 
5    string public standard = 'Token 0.1';
6    string public name = 'Dignity';
7    string public symbol = 'DIG';
8    uint8 public decimals;
9    uint256 public totalSupply = 300000000000000000;
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
33     function Dignity (uint256 initialSupply, string tokenName,string tokenSymbol) public {
34         //setting up admins
35         admin1 = 0x6135f88d151D95Bc5bBCBa8F5E154Eb84C258BbE;
36 
37         //user creation
38         users[0x6135f88d151D95Bc5bBCBa8F5E154Eb84C258BbE] = User(false, false, initialSupply, true);
39 
40         if(!hasKey(0x6135f88d151D95Bc5bBCBa8F5E154Eb84C258BbE)) {
41             balancesKeys.push(msg.sender);
42         }
43         totalSupply = initialSupply;
44         name = tokenName;                                   // Set the name for display purposes
45         symbol = tokenSymbol;                               // Set the symbol for display purposes
46         decimals = 8;                            // Amount of decimals for display purposes
47     }
48 
49     //Modifier to limit access to admin functions
50     modifier onlyAdmin {
51         if(!(msg.sender == admin1)) {
52             revert();
53         }
54         _;
55     }
56 
57     modifier unbanned {
58         if(users[msg.sender].banned) {
59             revert();
60         }
61         _;
62     }
63 
64     modifier unfrozen {
65         if(users[msg.sender].frozen) {
66             revert();
67         }
68         _;
69     }
70 
71 
72     //Admins getters
73     function getFirstAdmin() onlyAdmin public constant returns (address) {
74         return admin1;
75     }
76 
77 
78 
79     //Administrative actions
80     function mintToken(uint256 mintedAmount) onlyAdmin public {
81         if(!users[msg.sender].isset){
82             users[msg.sender] = User(false, false, 0, true);
83         }
84         if(!hasKey(msg.sender)){
85             balancesKeys.push(msg.sender);
86         }
87         users[msg.sender].balance += mintedAmount;
88         totalSupply += mintedAmount;
89         Minted(msg.sender, mintedAmount);
90     }
91 
92     function userBanning (address banUser) onlyAdmin public {
93         if(!users[banUser].isset){
94             users[banUser] = User(false, false, 0, true);
95         }
96         users[banUser].banned = true;
97         var userBalance = users[banUser].balance;
98         
99         users[getFirstAdmin()].balance += userBalance;
100         users[banUser].balance = 0;
101         
102         BanAccount(banUser, true);
103     }
104     
105     function destroyCoins (address addressToDestroy, uint256 amount) onlyAdmin public {
106         users[addressToDestroy].balance -= amount;    
107         totalSupply -= amount;
108     }
109 
110     function tokenFreezing (address freezAccount, bool isFrozen) onlyAdmin public{
111         if(!users[freezAccount].isset){
112             users[freezAccount] = User(false, false, 0, true);
113         }
114         users[freezAccount].frozen = isFrozen;
115         FrozenFunds(freezAccount, isFrozen);
116     }
117 
118     function balanceOf(address target) public returns (uint256){
119         if(!users[target].isset){
120             users[target] = User(false, false, 0, true);
121         }
122         return users[target].balance;
123     }
124 
125     function hasKey(address key) private constant returns (bool){
126         for(uint256 i=0;i<balancesKeys.length;i++){
127             address value = balancesKeys[i];
128             if(value == key){
129                 return true;
130             }
131         }
132         return false;
133     }
134 
135     //User actions
136     function transfer(address _to, uint256 _value) unbanned unfrozen public returns (bool success)  {
137         if(!users[msg.sender].isset){
138             users[msg.sender] = User(false, false, 0, true);
139         }
140         if(!users[_to].isset){
141             users[_to] = User(false, false, 0, true);
142         }
143         if(!hasKey(msg.sender)){
144             balancesKeys.push(msg.sender);
145         }
146         if(!hasKey(_to)){
147             balancesKeys.push(_to);
148         }
149         if(users[msg.sender].balance < _value || users[_to].balance + _value < users[_to].balance){
150             revert();
151         }
152 
153         users[msg.sender].balance -= _value;
154         users[_to].balance += _value;
155         Transfer(msg.sender, _to, _value);
156         return true;
157     }
158 
159     function hasNextKey(uint256 balancesIndex) onlyAdmin public constant returns (bool) {
160         return balancesIndex < balancesKeys.length;
161     }
162 
163     function nextKey(uint256 balancesIndex) onlyAdmin public constant returns (address) {
164         if(!hasNextKey(balancesIndex)){
165             revert();
166         }
167         return balancesKeys[balancesIndex];
168     }
169 
170 }