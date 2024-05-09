1 /*
2 
3 
4 
5 
6 
7 ███████╗████████╗██╗░░██╗███████╗██████╗░██╗░░██╗██╗███╗░░██╗░██████╗░░░░░█████╗░██╗░░░░░██╗░░░██╗██████╗░
8 ██╔════╝╚══██╔══╝██║░░██║██╔════╝██╔══██╗██║░██╔╝██║████╗░██║██╔════╝░░░░██╔══██╗██║░░░░░██║░░░██║██╔══██╗
9 █████╗░░░░░██║░░░███████║█████╗░░██████╔╝█████═╝░██║██╔██╗██║██║░░██╗░░░░██║░░╚═╝██║░░░░░██║░░░██║██████╦╝
10 ██╔══╝░░░░░██║░░░██╔══██║██╔══╝░░██╔══██╗██╔═██╗░██║██║╚████║██║░░╚██╗░░░██║░░██╗██║░░░░░██║░░░██║██╔══██╗
11 ███████╗░░░██║░░░██║░░██║███████╗██║░░██║██║░╚██╗██║██║░╚███║╚██████╔╝██╗╚█████╔╝███████╗╚██████╔╝██████╦╝
12 ╚══════╝░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚═╝░░╚═╝╚═╝░░╚═╝╚═╝╚═╝░░╚══╝░╚═════╝░╚═╝░╚════╝░╚══════╝░╚═════╝░╚═════╝░
13 
14 ███████████████████████▀██████████████████████████████████████████████████████████████████
15 █▄─█─▄█▄─▄█▄─▀█▄─▄█─▄▄▄▄███─▄▄─█▄─▄▄─████▀▄─██▄─▄███▄─▄█████▄─▄▄▀██▀▄─██▄─▄▄─█▄─▄▄─█─▄▄▄▄█
16 ██─▄▀███─███─█▄▀─██─██▄─███─██─██─▄██████─▀─███─██▀██─██▀████─██─██─▀─███─▄▄▄██─▄▄▄█▄▄▄▄─█
17 ▀▄▄▀▄▄▀▄▄▄▀▄▄▄▀▀▄▄▀▄▄▄▄▄▀▀▀▄▄▄▄▀▄▄▄▀▀▀▀▀▄▄▀▄▄▀▄▄▄▄▄▀▄▄▄▄▄▀▀▀▄▄▄▄▀▀▄▄▀▄▄▀▄▄▄▀▀▀▄▄▄▀▀▀▄▄▄▄▄▀
18 
19 𝑨𝒖𝒕𝒐𝒑𝒐𝒐𝒍 | 𝑴𝒂𝒕𝒓𝒊𝒙 | 𝑮𝒂𝒎𝒊𝒏𝒈 | 𝑴𝒂𝒓𝒌𝒆𝒕𝒑𝒍𝒂𝒄𝒆 | 𝑳𝒐𝒕𝒕𝒆𝒓𝒚 | 𝑱𝒂𝒄𝒌𝒑𝒐𝒕
20 This product is protected under license.  Any unauthorized copy, modification, or use without
21 express written consent from the creators is prohibited.
22 
23 
24                                                                 ▓▓                                                               
25                                                               ▓▓▓▓                                                               
26                             ██▓▓▓▓                            ██▓▓▓▓                              ████                           
27                             ████▓▓                            ██░░▓▓                            ████▓▓                           
28                             ████▓▓▓▓                        ████░░▓▓▓▓                          ██░░▓▓                           
29                             ██░░░░▓▓▓▓                      ██▒▒░░░░▓▓                        ██▒▒░░▓▓                           
30                             ██▒▒▒▒░░▓▓▓▓                  ████▒▒▒▒░░▓▓▓▓                    ████▒▒░░▓▓                           
31                           ██▒▒▒▒▒▒░░░░▓▓▓▓              ████▒▒▒▒▒▒░░░░▓▓▓▓              ██████▒▒▒▒░░▓▓                           
32                           ██▒▒▒▒▒▒▒▒░░░░▓▓▓▓▓▓      ▓▓▓▓██▓▓▒▒▒▒▒▒▒▒░░░░▓▓▓▓▓▓      ▓▓▓▓██▓▓▓▓▓▓▒▒░░▓▓▓▓                      ▓▓ 
33 ▓▓▒▒                    ▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒░░░░▓▓▒▒    ████▓▓▒▒▒▒▒▒▒▒▒▒▒▒░░░░▓▓▓▓    ▓▓██▓▓▓▓▓▓▒▒▓▓▒▒░░░░▓▓▒▒                  ▓▓▓▓▓▓
34 ▓▓▓▓▒▒▓▓▒▒              ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░▓▓▓▓    ░░██▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░▓▓▓▓    ░░██▓▓▒▒▒▒▒▒▒▒▒▒▒▒░░░░▓▓▓▓            ▓▓▓▓▓▓▓▓░░
35   ████▒▒▓▓▓▓▓▓▓▓      ████▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░▓▓▓▓        ██▓▓▒▒▒▒▒▒▒▒▒▒▒▒░░▓▓▓▓          ██▒▒▒▒▒▒▓▓▒▒▒▒▒▒░░░░▓▓      ████████░░▓▓▓▓ 
36     ██▒▒▒▒░░░░▓▓▓▓▓▓  ██████▒▒▒▒▒▒▒▒▒▒▒▒░░▓▓            ████▒▒▒▒▒▒▒▒░░░░▓▓            ██▒▒▒▒▒▒▒▒▒▒▒▒░░░░▓▓▓▓  ██████▒▒▒▒░░░░▓▓   
37     ██▒▒▒▒░░░░░░▓▓▓▓      ██▓▓▒▒▒▒▒▒▒▒░░░░▓▓              ██▒▒▒▒▒▒▒▒░░▓▓▓▓            ████▒▒▒▒▒▒▒▒░░░░▓▓▓▓      ██▒▒▒▒▒▒░░▓▓▓▓   
38     ████▒▒▒▒░░░░▓▓          ██▒▒▒▒▒▒▒▒░░▓▓▓▓              ██▒▒▒▒▒▒▒▒░░▓▓                ██▒▒▒▒▒▒░░░░▓▓▓▓        ██▒▒▒▒░░░░▓▓     
39     ░░██▓▓▒▒▒▒░░▓▓          ████▒▒▒▒▒▒░░▓▓░░              ██▒▒▒▒▒▒▒▒░░▓▓              ▓▓██▒▒▒▒▒▒░░▓▓▓▓          ██▒▒▒▒░░▓▓▓▓     
40       ░░██▒▒▒▒░░▓▓          ░░██▒▒▒▒▒▒░░▓▓▒▒              ██▒▒▒▒▒▒▒▒░░▓▓              ██▓▓▒▒▒▒▒▒░░▓▓░░          ██▒▒▒▒░░▓▓░░     
41         ██▓▓▒▒▒▒▓▓            ██▓▓▒▒▒▒▒▒▒▒▓▓▒▒            ██▒▒▒▒▒▒▒▒░░▓▓            ▓▓██▒▒▒▒▒▒▒▒░░▓▓            ██▒▒░░▓▓▓▓       
42         ░░██▓▓▒▒▓▓▒▒          ░░██▒▒▒▒▒▒▒▒▒▒▓▓▒▒        ▓▓██▒▒▒▒▒▒▒▒░░▓▓▓▓          ██▓▓▓▓▒▒▒▒▒▒░░▓▓            ██▒▒░░▓▓░░       
43             ██▒▒▒▒▓▓▓▓        ██▒▒▒▒▒▒▒▒▒▒▒▒░░▓▓▓▓      ██▒▒▒▒▒▒▒▒▒▒░░░░▓▓        ████▒▒▒▒▒▒▒▒▒▒░░▓▓          ████░░▓▓▓▓         
44             ████▒▒▒▒▓▓        ██▒▒▒▒▒▒▒▒▒▒▒▒░░░░▓▓▓▓██████▒▒▒▒▒▒▒▒▒▒▒▒░░▓▓▓▓▓▓██████▒▒▒▒▒▒▒▒▒▒▒▒░░▓▓        ██▒▒░░░░▓▓           
45               ██▒▒▒▒▓▓▓▓▓▓▓▓██▒▒▒▒▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▒▒▒▒▒▒▒▒▒▒░░▒▒░░▓▓██▒▒▓▓▓▓▓▓▒▒▒▒▓▓▒▒░░▓▓▓▓▓▓▓▓▓▓██▒▒░░▓▓▓▓           
46               ████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▒▒▓▓▒▒▓▓▒▒▒▒▒▒▒▒▓▓▒▒▓▓▒▒▓▓▓▓▓▓▒▒▒▒▒▒░░░░▒▒▒▒▒▒▓▓▓▓▓▓▒▒▓▓▒▒░░░░░░░░▓▓██▓▓░░░░▓▓░░           
47                 ██▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▒▒▓▓▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▓▓▓▓▒▒▒▒▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░▓▓               
48                   ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▓▓▒▒▒▒▒▒▒▒▒▒░░▓▓▓▓               
49                   ████▒▒▒▒▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒░░▓▓                 
50                     ▓▓▓▓▓▓▓▓▒▒░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓                 
51                   ▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░▒▒▒▒▒▒░░░░░░░░░░▒▒▒▒▓▓                 
52                   ▓▓▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██████████████████████████████████████████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒░░░░▒▒▓▓▓▓               
53                   ▓▓▒▒▓▓▓▓▓▓████████████████████████████████████████████████████████████████████████▓▓▓▓▓▓▓▓▓▓▓▓░░               
54                   ▓▓▓▓▓▓██████████████████▓▓▓▓▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▓▓▓▓████████████████████                     
55                       ████████▒▒▓▓▒▒▒▒▒▒▒▒▒▒▒▒▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░██████████                     
56                         ▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░▓▓▓▓                     
57                         ▓▓▒▒▒▒▒▒▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▓▓▓▓░░▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓░░▓▓▒▒▒▒▒▒▒▒▓▓▓▓▓▓▒▒▒▒▒▒░░░░▓▓                       
58                         ▓▓▒▒▒▒▒▒▓▓▓▓░░▓▓▒▒▒▒▒▒▒▒▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▓▓▓▓░░▓▓▒▒▒▒░░░░▓▓                       
59                         ▓▓▒▒▓▓▒▒▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▒▒▒▒▒▒░░▓▓▓▓                       
60                         ▓▓▓▓▒▒▒▒▒▒▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▒▒▒▒▒▒░░▓▓░░                       
61                         ░░▓▓▒▒▒▒▒▒▓▓▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▓▓▒▒▒▒▒▒▒▒░░▓▓                         
62                           ▓▓▓▓▓▓▓▓▓▓▓▓▓▓██████████████████████████████████████████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░▓▓                         
63                           ▓▓▓▓████████████▓▓▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██████████████▓▓▓▓▓▓                         
64                         ████████▓▓▓▓▓▓▒▒▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▒▒░░░░░░░░░░░░░░░░██████████                       
65                       ████▓▓▓▓▓▓▓▓▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒░░░░░░░░░░░░░░████                     
66                       ██▓▓▓▓▓▓▓▓▓▓▓▓▓▓████████████████████████████████████████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░▒▒██                     
67                       ██▓▓▓▓████████████                                        ████████████████████▓▓▓▓░░██                     
68                       ░░████░░░░░░▒▒░░░░                                        ░░░░  ░░░░░░░░░░░░░░████▓▓░░                     
69 
70 */
71 pragma solidity 0.5.11;
72 
73 
74 contract EtherKingToken {
75 address public ownerWalletERC;
76     string public constant name = "EtherKing";
77     string public constant symbol = "ETK";
78     uint8 public constant decimals = 18; 
79 
80 
81 
82 
83     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
84     event Transfer(address indexed from, address indexed to, uint tokens);
85 event TransferFromContract(address indexed from, address indexed to, uint tokens,uint status);
86 
87     mapping(address => uint256) balances;
88 
89     mapping(address => mapping (address => uint256)) allowed;
90    
91     uint256 totalSupply_=100000000000000000000000000000;
92 
93     using SafeMath for uint256;
94 
95 
96    constructor() public { 
97 ownerWalletERC=msg.sender;
98 balances[ownerWalletERC] = totalSupply_;
99     } 
100 
101     function totalSupply() public view returns (uint256) {
102 return totalSupply_;
103     }
104    
105     function balanceOf(address tokenOwner) public view returns (uint) {
106         return balances[tokenOwner];
107     }
108    
109     function balanceOfOwner() public view returns (uint) {
110         return balances[ownerWalletERC];
111     }
112 
113     function transfer(address receiver, uint numTokens) public returns (bool) {
114         require(numTokens <= balances[msg.sender]);
115         balances[msg.sender] = balances[msg.sender].sub(numTokens);
116         balances[receiver] = balances[receiver].add(numTokens);
117         emit Transfer(msg.sender, receiver, numTokens);
118         return true;
119     }
120    
121     function transferFromOwner(address receiver, uint numTokens,uint status) internal returns (bool) {
122         numTokens=numTokens*1000000000000000000;
123         if(numTokens <= balances[ownerWalletERC]){
124         balances[ownerWalletERC] = balances[ownerWalletERC].sub(numTokens);
125         balances[receiver] = balances[receiver].add(numTokens);
126         emit TransferFromContract(ownerWalletERC, receiver, numTokens,status);
127         }
128         return true;
129     }
130 
131     function approve(address delegate, uint numTokens) public returns (bool) {
132         allowed[msg.sender][delegate] = numTokens;
133         emit Approval(msg.sender, delegate, numTokens);
134         return true;
135     }
136 
137     function allowance(address owner, address delegate) public view returns (uint) {
138         return allowed[owner][delegate];
139     }
140 
141     function transferFrom(address owner, address buyer, uint numTokens) internal returns (bool) {
142         require(numTokens <= balances[owner]);   
143         require(numTokens <= allowed[owner][msg.sender]);
144    
145         balances[owner] = balances[owner].sub(numTokens);
146         allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
147         balances[buyer] = balances[buyer].add(numTokens);
148         emit Transfer(owner, buyer, numTokens);
149         return true;
150     }
151 }
152 
153 library SafeMath {
154     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
155       assert(b <= a);
156       return a - b;
157     }
158    
159     function add(uint256 a, uint256 b) internal pure returns (uint256) {
160       uint256 c = a + b;
161       assert(c >= a);
162       return c;
163     }
164 }
165 
166 contract EtherKing is EtherKingToken{
167      address public ownerWallet;
168       uint public currUserID = 0;
169       uint public pool1currUserID = 0;
170       uint public pool2currUserID = 0;
171       uint public pool3currUserID = 0;
172        uint public jackpotcurrUserID = 0;
173    
174         uint public pool1activeUserID = 0;
175       uint public pool2activeUserID = 0;
176       uint public pool3activeUserID = 0;
177     
178      
179      
180       uint public unlimited_level_price=0;
181     
182       struct UserStruct {
183         bool isExist;
184         uint id;
185         uint referrerID;
186        uint referredUsers;
187         mapping(uint => uint) levelExpired;
188         uint referredUserspool3;
189         uint referredUserspool1;
190     }
191    
192  
193    
194      struct PoolUserStruct {
195         bool isExist;
196         uint id;
197        uint payment_received;
198        bool lucky_draw;
199        address user;
200     }
201     struct UserRegStruct{
202         bool isExist;
203         uint userid;
204         uint nooftime;
205         uint payment_received;
206         uint poolid;
207     }
208     mapping (address => UserStruct) public users;
209      mapping (uint => address) public userList;
210     
211      mapping (uint => PoolUserStruct) public pool1users;
212     mapping (address => UserRegStruct) public pool1userList;
213    
214      mapping (uint => PoolUserStruct) public pool2users;
215      mapping (address => UserRegStruct) public pool2userList;
216     
217      mapping (uint => PoolUserStruct) public pool3users;
218      mapping (address => UserRegStruct) public pool3userList;
219     
220   mapping (uint => address) public jackoptuserList;
221  
222  
223  
224  
225      uint counter =0;
226 
227   uint pool_payment_amount=0.02 ether;
228  
229       event getMoneyForPoolLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
230       event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
231      event regPoolEntry(address indexed _user,uint _level,   uint _time,uint poolid);
232   
233     
234     event getPoolPayment(address indexed _user,address indexed _receiver, uint _level, uint _time);
235     event luckydraw(uint id,address indexed _receiver, uint _level, uint _time);
236    event regJackpotPool(uint id,address indexed _user,uint _time);
237     UserStruct[] public requests;
238     
239       constructor()EtherKingToken() public {
240           ownerWallet = msg.sender;
241 
242   
243   
244         UserStruct memory userStruct;
245         UserRegStruct memory pooluserreg;
246        
247         currUserID++;
248 
249         userStruct = UserStruct({
250             isExist: true,
251             id: currUserID,
252             referrerID: 0,
253             referredUsers:0,
254            referredUserspool3:0,
255            referredUserspool1:0
256         });
257        
258         users[ownerWallet] = userStruct;
259        userList[currUserID] = ownerWallet;
260       
261       
262          PoolUserStruct memory pooluserStruct;
263 
264         pool1currUserID++;
265 
266         pooluserStruct = PoolUserStruct({
267             isExist:true,
268             id:pool1currUserID,
269             payment_received:0,
270             lucky_draw:false,
271             user:msg.sender
272         });
273     pool1activeUserID=pool1currUserID;
274        pool1users[pool1currUserID] = pooluserStruct;
275       
276       pooluserreg = UserRegStruct({
277             isExist: true,
278             userid: currUserID,
279             payment_received:0,
280            nooftime:1,
281            poolid:pool1currUserID
282           
283         });
284        
285    
286      pool1userList[msg.sender]=pooluserreg;
287      
288        
289         pool2currUserID++;
290         pooluserStruct = PoolUserStruct({
291             isExist:true,
292             id:pool2currUserID,
293             payment_received:0,
294             lucky_draw:false,
295             user:msg.sender
296         });
297     pool2activeUserID=pool2currUserID;
298        pool2users[pool2currUserID] = pooluserStruct;
299       
300 
301        
302     pooluserreg = UserRegStruct({
303             isExist: true,
304             userid: currUserID,
305            nooftime:1,
306            poolid:pool2currUserID,
307            payment_received:0
308         });
309        
310      pool2userList[msg.sender]=pooluserreg;
311       
312       
313         pool3currUserID++;
314         pooluserStruct = PoolUserStruct({
315             isExist:true,
316             id:pool3currUserID,
317             payment_received:0,
318             lucky_draw:false,
319             user:msg.sender
320         });
321     pool3activeUserID=pool3currUserID;
322        pool3users[pool3currUserID] = pooluserStruct;
323      
324        pooluserreg = UserRegStruct({
325             isExist: true,
326             userid: currUserID,
327            nooftime:1,
328            poolid:pool3currUserID,
329            payment_received:0
330         });
331        
332      pool3userList[msg.sender]=pooluserreg;
333       
334       }
335      
336     
337      
338      
339     
340         function regUser(uint _referrerID) public {
341       
342       require(!users[msg.sender].isExist, "User Exists");
343       require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referral ID');
344       
345       
346       if(!users[msg.sender].isExist)
347       {
348         UserStruct memory userStruct;
349         currUserID++;
350 
351         userStruct = UserStruct({
352             isExist: true,
353             id: currUserID,
354             referrerID: _referrerID,
355             referredUsers:0,
356             referredUserspool3:0,
357             referredUserspool1:0
358         });
359  
360    
361        users[msg.sender] = userStruct;
362        userList[currUserID]=msg.sender;
363       
364         users[userList[users[msg.sender].referrerID]].referredUsers=users[userList[users[msg.sender].referrerID]].referredUsers+1;
365        
366         transferFromOwner(msg.sender,1000,1);
367          payReferral(msg.sender);
368          emit regLevelEvent(msg.sender, userList[_referrerID], now);
369       }
370     }
371   
372   
373      function payReferral( address _user) internal {
374         address referer;
375         referer = userList[users[_user].referrerID];
376         transferFromOwner(referer,1000,2);
377      }
378   
379   
380   
381    function payPoolReferral(uint _level, address _user) internal {
382         address referer;
383       
384         referer = userList[users[_user].referrerID];
385       
386          bool sent = false;
387             if(_level==1)
388             {
389                 pool_payment_amount=0.04 ether;
390             }
391             else if(_level==2)
392             {
393                 pool_payment_amount=0.1 ether;
394             }
395             else
396             {
397                 pool_payment_amount=0.2 ether;
398             }
399             sent = address(uint160(referer)).send(pool_payment_amount);
400 
401             if (sent) {
402                 emit getMoneyForPoolLevelEvent(referer, msg.sender, _level, now);
403                 if(_level==1)
404                 {
405                     transferFromOwner(referer,4000,3);
406                 }
407                 else if(_level==2)
408                 {
409                     transferFromOwner(referer,10000,4);
410                 }
411                 else
412                 {
413                     transferFromOwner(referer,20000,5);
414                 }
415            
416             }
417            
418            
419             if(_level==1)
420             {
421                 pool_payment_amount=0.034 ether;
422             }
423             else if(_level==2)
424             {
425                 pool_payment_amount=0.085 ether;
426             }
427             else
428             {
429                 pool_payment_amount=0.17 ether;
430             }
431            
432            
433              if (address(uint160(ownerWallet)).send(pool_payment_amount))
434          {
435              emit getMoneyForPoolLevelEvent(referer, ownerWallet, _level, now);
436          }
437       
438      
439      }
440   
441   
442        function buyPool1() public payable {
443       require(users[msg.sender].isExist, "User Not Registered");
444         require(msg.value == 0.2 ether, 'Incorrect Value');
445    
446         PoolUserStruct memory userStruct;
447         UserRegStruct memory userregStruct;
448         pool1currUserID++;
449         userStruct = PoolUserStruct({
450             isExist:true,
451             id:pool1currUserID,
452             payment_received:0,
453             lucky_draw:false,
454             user:msg.sender
455         });
456        pool1users[pool1currUserID] = userStruct;
457 
458       
459         if(pool1userList[msg.sender].isExist){
460             pool1userList[msg.sender].nooftime=pool1userList[msg.sender].nooftime+1;
461         }
462         else{
463         userregStruct=UserRegStruct({
464             isExist:true,
465             userid:users[msg.sender].id,
466             nooftime:1,
467             poolid:pool1currUserID,
468             payment_received:0
469         });
470         pool1userList[msg.sender]=userregStruct;
471         users[userList[users[msg.sender].referrerID]].referredUserspool1=users[userList[users[msg.sender].referrerID]].referredUserspool1+1;
472         }
473       
474        transferFromOwner(msg.sender,20000,6);
475       
476       
477       payPoolReferral(1,msg.sender);
478       uint pool1activeUserID_local=pool1activeUserID;
479       uint temp_i=6;
480       for (uint i=0; i<6; i++) {
481           if((pool1activeUserID_local+i)>pool1currUserID){
482               temp_i=i;
483               break;
484           }
485          uint pool1Currentuser=pool1users[pool1activeUserID_local+i].id;
486         
487       bool sent = false;
488       sent = address(uint160(pool1users[pool1Currentuser].user)).send(0.02 ether);
489 
490             if (sent) {
491                 pool1users[pool1Currentuser].payment_received+=1;
492                  pool1userList[pool1users[pool1Currentuser].user].payment_received+=1;
493                 if(pool1users[pool1Currentuser].payment_received>=14)
494                 {
495                     pool1activeUserID+=1;
496                 }
497                 emit getPoolPayment(msg.sender,pool1users[pool1Currentuser].user, 1, now);
498                 transferFromOwner(pool1users[pool1Currentuser].user,2000,9);
499             }
500       
501       }
502       if(temp_i<6)
503       {
504       bool s= address(uint160(ownerWallet)).send(0.02 ether * (6-temp_i)); 
505       if(s){}
506       }
507       emit regPoolEntry(msg.sender, 1, now,pool1currUserID);
508       counter=0;
509         if(((pool1currUserID-1)%5)==0 && pool1currUserID>=7){
510      luckydrawPool1();
511         }
512     }
513    
514    
515       function buyPool2() public payable {
516       require(pool1userList[msg.sender].isExist, "Need to buy Pool 1");   
517         require(msg.value == 0.5 ether, 'Incorrect Value');
518        
519       
520         PoolUserStruct memory userStruct;
521         UserRegStruct memory userregStruct;
522        
523         pool2currUserID++;
524         userStruct = PoolUserStruct({
525             isExist:true,
526             id:pool2currUserID,
527             payment_received:0,
528             lucky_draw:false,
529             user:msg.sender
530         });
531        pool2users[pool2currUserID] = userStruct;
532       
533          if(pool2userList[msg.sender].isExist){
534             pool2userList[msg.sender].nooftime=pool2userList[msg.sender].nooftime+1;
535         }
536         else{
537             userregStruct=UserRegStruct({
538                 isExist:true,
539                 userid:users[msg.sender].id,
540                 nooftime:1,
541                 poolid:pool2currUserID,
542                 payment_received:0
543             });
544             pool2userList[msg.sender]=userregStruct;
545         }
546       
547       
548        transferFromOwner(msg.sender,50000,7);
549        payPoolReferral(2,msg.sender);
550        uint pool2activeUserID_local=pool2activeUserID;
551        uint temp_i=3;
552        for (uint i=0; i<3; i++) {
553            if((pool2activeUserID_local+i)>pool2currUserID){
554                 temp_i=i;
555                break;
556            }
557          uint pool2Currentuser=pool2users[pool2activeUserID_local+i].id;
558         
559        bool sent = false;
560        sent = address(uint160(pool2users[pool2Currentuser].user)).send(0.1 ether);
561 
562             if (sent) {
563                 pool2users[pool2Currentuser].payment_received+=1;
564                  pool2userList[pool2users[pool2Currentuser].user].payment_received+=1;
565                 if(pool2users[pool2Currentuser].payment_received>=9)
566                 {
567                     pool2activeUserID+=1;
568                 }
569                 emit getPoolPayment(msg.sender,pool2users[pool2Currentuser].user, 2, now);
570                 transferFromOwner(pool2users[pool2Currentuser].user,10000,10);
571             }
572       
573        }
574        if(temp_i<3)
575        {
576        bool s= address(uint160(ownerWallet)).send(0.1 ether * (3-temp_i)); 
577        if(s){}
578        }
579        emit regPoolEntry(msg.sender, 2, now,pool2currUserID);
580        counter=0;
581         if(((pool2currUserID-1)%5)==0 && pool2currUserID>=7){
582      luckydrawPool2();
583         }
584       
585     }
586    
587     /*
588     Autopool3 users who have one direct referral at autopool3 are eligible for Jackpot.Jackpot fund will be reserved at 'Jackpot reserved wallet'.
589     Eligible user ETH wallet list will be fetched from this contract and Jackpot Smart contract will choose 'Random User' from eligible users. 
590     */
591      function buyPool3() public payable {
592          require(pool2userList[msg.sender].isExist, "Need to buy Pool 1 and 2");  
593      
594         require(msg.value == 1 ether, 'Incorrect Value');
595       
596         PoolUserStruct memory userStruct;
597         UserRegStruct memory userregStruct;
598        
599         pool3currUserID++;
600         userStruct = PoolUserStruct({
601             isExist:true,
602             id:pool3currUserID,
603             payment_received:0,
604             lucky_draw:false,
605             user:msg.sender
606         });
607        pool3users[pool3currUserID] = userStruct;
608       
609          if(pool3userList[msg.sender].isExist){
610             pool3userList[msg.sender].nooftime=pool3userList[msg.sender].nooftime+1;
611         }
612         else{
613             userregStruct=UserRegStruct({
614                 isExist:true,
615                 userid:users[msg.sender].id,
616                 nooftime:1,
617                 poolid:pool3currUserID,
618                 payment_received:0
619             });
620             pool3userList[msg.sender]=userregStruct;
621         }
622        
623        
624       
625         users[userList[users[msg.sender].referrerID]].referredUserspool3=users[userList[users[msg.sender].referrerID]].referredUserspool3+1;
626        
627         if(users[userList[users[msg.sender].referrerID]].referredUserspool3==1 && pool3users[users[msg.sender].referrerID].isExist)
628         {
629             jackpotcurrUserID++;
630             jackoptuserList[jackpotcurrUserID]=userList[users[msg.sender].referrerID];
631            
632              emit regJackpotPool(users[msg.sender].referrerID,userList[users[msg.sender].referrerID], now);
633         }
634        
635         if(users[msg.sender].referredUserspool3==1)
636         {
637             jackpotcurrUserID++;
638             jackoptuserList[jackpotcurrUserID]=userList[users[msg.sender].id];
639            emit regJackpotPool(users[msg.sender].id,userList[users[msg.sender].id], now);
640         }
641         transferFromOwner(msg.sender,100000,8);
642        payPoolReferral(3,msg.sender);
643        uint pool3activeUserID_local=pool3activeUserID;
644        uint temp_i=3;
645        for (uint i=0; i<3; i++) {
646            if((pool3activeUserID_local+i)>pool3currUserID){
647                temp_i=i;
648                break;
649            }
650          uint pool3Currentuser=pool3users[pool3activeUserID_local+i].id;
651         
652        bool sent = false;
653        sent = address(uint160(pool3users[pool3Currentuser].user)).send(0.2 ether);
654 
655             if (sent) {
656                 pool3users[pool3Currentuser].payment_received+=1;
657                 pool3userList[pool3users[pool3Currentuser].user].payment_received+=1;
658                
659                 if(pool3users[pool3Currentuser].payment_received>=10)
660                 {
661                     pool3activeUserID+=1;
662                 }
663                 emit getPoolPayment(msg.sender,pool3users[pool3Currentuser].user, 3, now);
664                 transferFromOwner(pool3users[pool3Currentuser].user,20000,11);
665             }
666      
667        }
668        if(temp_i<3)
669        {
670        bool s= address(uint160(ownerWallet)).send(0.2 ether * (3-temp_i)); 
671        if(s){}
672        }
673        emit regPoolEntry(msg.sender, 3, now,pool3currUserID);
674        counter=0;
675         if(((pool3currUserID-1)%5)==0 && pool3currUserID>=7){
676      luckydrawPool3();
677         }
678     
679     }
680   
681    
682     function luckydrawPool1() private
683     {
684         uint lower=pool1activeUserID+6;
685         if(pool1currUserID >= 110)
686         {
687             lower=pool1currUserID-100;
688         }
689         uint num = (block.timestamp % ((pool1currUserID) - lower + 1)) + lower;
690         uint pool1Currentuser=pool1users[num].id;  
691         if(pool1users[pool1Currentuser].payment_received==0 && pool1users[pool1Currentuser].lucky_draw==false){
692             bool sent = false;
693             sent = address(uint160(pool1users[pool1Currentuser].user)).send(0.03 ether);
694 
695             if (sent) {
696                 pool1users[pool1Currentuser].lucky_draw=true;
697                emit luckydraw(num,pool1users[pool1Currentuser].user,1,now);
698                transferFromOwner(pool1users[pool1Currentuser].user,3000,12);
699             }
700          }
701          else
702          {
703              counter++;
704              if(counter<=(pool1currUserID- lower)){
705              luckydrawPool1();   
706              }
707             
708          }
709    
710        
711     }
712    
713    
714      function luckydrawPool2() private
715     {
716         uint lower=pool2activeUserID+6;
717         if(pool2currUserID >= 110)
718         {
719             lower=pool2currUserID-100;
720         }
721         uint num = (block.timestamp % ((pool2currUserID) - lower + 1)) + lower;
722          uint pool2Currentuser=pool2users[num].id; 
723         if(pool2users[pool2Currentuser].payment_received==0 && pool2users[pool2Currentuser].lucky_draw==false){
724             bool sent = false;
725             sent = address(uint160(pool2users[pool2Currentuser].user)).send(0.075 ether);
726 
727             if (sent) {
728                 pool2users[pool2Currentuser].lucky_draw=true;
729                emit luckydraw(num,pool2users[pool2Currentuser].user,2,now);
730                transferFromOwner(pool2users[pool2Currentuser].user,7500,12);
731             }
732          }
733          else
734          {
735              counter++;
736              if(counter<=(pool2currUserID- lower)){
737              luckydrawPool2();   
738              }
739             
740          }
741    
742        
743     }
744    
745    
746     function luckydrawPool3() private
747     {
748         uint lower=pool3activeUserID+6;
749         if(pool3currUserID >= 110)
750         {
751             lower=pool3currUserID-100;
752         }
753         uint num = (block.timestamp % ((pool3currUserID) - lower + 1)) + lower;
754         uint pool3Currentuser=pool3users[num].id;  
755         if(pool3users[pool3Currentuser].payment_received==0 && pool3users[pool3Currentuser].lucky_draw==false){
756             bool sent = false;
757             sent = address(uint160(pool3users[pool3Currentuser].user)).send(0.15 ether);
758 
759             if (sent) {
760                 pool3users[pool3Currentuser].lucky_draw=true;
761                emit luckydraw(num,pool3users[pool3Currentuser].user,3,now);
762                transferFromOwner(pool3users[pool3Currentuser].user,15000,12);
763             }
764          }
765          else
766          {
767              counter++;
768              if(counter<=(pool3currUserID- lower)){
769              luckydrawPool3();   
770              }
771             
772          }
773    
774        
775     }
776    
777    
778    
779    
780     function getEthBalance() public view returns(uint) {
781     return address(this).balance;
782     }
783    
784     function viewUserReferral(address _user) public view returns(address) {
785         return userList[users[_user].referrerID];
786     }
787    
788     function checkUserExist(address _user) public view returns(bool) {
789         return users[_user].isExist;
790     }
791    
792     function checkUserPool1Exist(address _user) public view returns(bool) {
793         return pool1userList[_user].isExist;
794     }
795    
796      function checkUserPool2Exist(address _user) public view returns(bool) {
797         return pool2userList[_user].isExist;
798     }
799      function checkUserPool3Exist(address _user) public view returns(bool) {
800         return pool2userList[_user].isExist;
801     }
802    
803      function getCurrentJackpotId() public view returns(uint) {
804         return jackpotcurrUserID;
805     }
806    
807      function getPool3currId() public view returns(uint) {
808         return pool3currUserID;
809     }
810    
811     function getCurrentJackpotUser(uint id) public view returns(address) {
812         return jackoptuserList[id];
813     }
814    
815     function sendBalance() private
816     {
817         if(getEthBalance()>0){
818          if (!address(uint160(ownerWallet)).send(getEthBalance()))
819          {
820             
821          }
822         }
823     }
824   
825     function sendPendingBalance(uint amount) public
826     {
827          require(msg.sender==ownerWallet, "You are not authorized"); 
828         if(msg.sender==ownerWallet){
829         if(amount>0 && amount<=getEthBalance()){
830          if (!address(uint160(ownerWallet)).send(amount))
831          {
832             
833          }
834         }
835         }
836     }
837 }