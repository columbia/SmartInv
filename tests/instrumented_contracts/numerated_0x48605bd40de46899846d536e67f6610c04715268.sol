1 pragma solidity >= 0.4.24 < 0.6.0;
2 
3 
4 /**
5  * @title Mega Coin for Megabit trading-mining
6  * @author Willy Lee
7  * See the manuals.
8  */
9 
10 
11 /**
12  * @title ERC20 Standard Interface
13  * @dev https://github.com/ethereum/EIPs/issues/20
14  * removed functions : transferFrom, approve, allowance
15  * removed events : Approval
16  * Some functions are restricted.
17  */
18 interface IERC20 {
19     function totalSupply() external view returns (uint256);
20     function balanceOf(address who) external view returns (uint256);
21     function transfer(address to, uint256 value) external returns (bool);
22     //function transferFrom(address from, address to, uint256 value) external returns (bool);
23     //function approve(address spender, uint256 value) external returns (bool);
24     //function allowance(address owner, address spender) external view returns (uint256);
25 
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     //event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 
31 /**
32  * @title MegaCoin implementation
33  * @author Willy Lee
34  */
35 contract MegaCoin is IERC20 {
36     //using SafeMath for uint256;   //  unnecessary lib
37 
38     string public name = "MEGA";
39     string public symbol = "MEGA";
40     uint8 public decimals = 18;
41     
42     uint256 _totalSupply;
43     mapping(address => uint256) balances;
44 
45     // Admin Address
46     address public owner;
47     address public team;
48     
49     // keep reserved coins in vault for each purpose
50     enum VaultEnum {mining, mkt, op, team, presale}
51     string[] VaultName = ["mining", "mkt", "op", "team", "presale"];
52     mapping(string => uint256) vault;
53 
54     modifier isOwner {
55         require(owner == msg.sender);
56         _;
57     }
58     
59     constructor() public {
60         uint256 discardCoins;    //  burning amount at initial time
61 
62         owner = msg.sender;
63         team = 0xB20a2214E60fa99911eb597faa1216DAc006fc29;
64         require(owner != team);
65 
66         setVaultBalanceInDecimal(VaultEnum.mining,   10000000000);   //  10 B
67         setVaultBalanceInDecimal(VaultEnum.mkt,      1000000000);    //  1 B
68         setVaultBalanceInDecimal(VaultEnum.op,       2000000000);    //  2 B
69         setVaultBalanceInDecimal(VaultEnum.team,     3000000000);    //  3 B, time lock to 2019-12-22
70         setVaultBalanceInDecimal(VaultEnum.presale,  2999645274);    //  2,999,645,274
71 
72         discardCoins = convertToWei(1000354726);            //  1,000,354,726
73 
74         // total must be 20 B
75         _totalSupply = 
76             getVaultBalance(VaultEnum.mining) +
77             getVaultBalance(VaultEnum.mkt) +
78             getVaultBalance(VaultEnum.op) +
79             getVaultBalance(VaultEnum.team) +
80             getVaultBalance(VaultEnum.presale) +
81             discardCoins;
82             
83         require(_totalSupply == convertToWei(20000000000));
84         
85         _totalSupply -= discardCoins;   // delete unnecessary coins;
86         balances[owner] = _totalSupply;
87 
88         emit Transfer(address(0), owner, balances[owner]);
89     }
90     
91     /** @dev transfer mining coins to Megabit Exchanges address
92      */
93     function transferForMining(address to) external isOwner {
94         require(to != owner);
95         withdrawCoins(VaultName[uint256(VaultEnum.mining)], to);
96     }
97     
98     /** @dev withdraw coins for marketing budget to specified address
99      */
100     function withdrawForMkt(address to) external isOwner {
101         require(to != owner);
102         withdrawCoins(VaultName[uint256(VaultEnum.mkt)], to);
103     }
104     
105     /** @dev withdraw coins for maintenance cost to specified address
106      */
107     function withdrawForOp(address to) external isOwner {
108         require(to != owner);
109         withdrawCoins(VaultName[uint256(VaultEnum.op)], to);
110     }
111 
112     /** @dev withdraw coins for Megabit team to reserved address after locked date
113      */
114     function withdrawTeamFunds() external isOwner {
115         uint256 balance = getVaultBalance(VaultEnum.team);
116         require(balance > 0);
117 
118         withdrawCoins(VaultName[uint256(VaultEnum.team)], team);
119     }
120 
121     /** @dev transfer sold(pre-sale) coins to specified address
122      */
123     function transferPresaleCoins(address to, uint256 amount) external isOwner {
124         require(to != owner);
125         require(balances[owner] >= amount);
126         require(getVaultBalance(VaultEnum.presale) >= amount);
127         
128         balances[owner] -= amount;
129         balances[to] += amount;
130         vault[VaultName[uint256(VaultEnum.presale)]] -= amount;
131 
132         emit Transfer(owner, to, amount);
133     }
134 
135     function totalSupply() public constant returns (uint) {
136         return _totalSupply;
137     }
138 
139     function balanceOf(address who) public view returns (uint256) {
140         return balances[who];
141     }
142     
143     function transfer(address to, uint256 value) public returns (bool success) {
144         require(msg.sender != to);
145         require(msg.sender != owner);   // owner is not free to transfer
146         require(to != owner);
147         require(value > 0);
148         
149         require( balances[msg.sender] >= value );
150         require( balances[to] + value >= balances[to] );    // prevent overflow
151 
152         if(msg.sender == team) {
153             require(now >= 1576940400);     // lock to 2019-12-22
154         }
155         balances[msg.sender] -= value;
156         balances[to] += value;
157 
158         emit Transfer(msg.sender, to, value);
159         return true;
160     }
161     
162     // burn holder's own coins 
163     function burnCoins(uint256 value) public {
164         require(msg.sender != owner);   // owner can't burn any coin
165         require(balances[msg.sender] >= value);
166         require(_totalSupply >= value);
167         
168         balances[msg.sender] -= value;
169         _totalSupply -= value;
170 
171         emit Transfer(msg.sender, address(0), value);
172     }
173 
174     function vaultBalance(string vaultName) public view returns (uint256) {
175         return vault[vaultName];
176     }
177     
178     // for check numbers
179     function getStat() public isOwner view returns (uint256 vaultTotal) {
180 
181         uint256 totalVault =
182             getVaultBalance(VaultEnum.mining) +
183             getVaultBalance(VaultEnum.mkt) +
184             getVaultBalance(VaultEnum.op) +
185             getVaultBalance(VaultEnum.team) +
186             getVaultBalance(VaultEnum.presale);
187 
188         return totalVault;
189     }
190         
191     /** @dev implementation of withdrawal
192      *  @dev it is available once for each vault
193      */
194     function withdrawCoins(string vaultName, address to) private returns (uint256) {
195         uint256 balance = vault[vaultName];
196         
197         require(balance > 0);
198         require(balances[owner] >= balance);
199         require(owner != to);
200 
201         balances[owner] -= balance;
202         balances[to] += balance;
203         vault[vaultName] = 0;
204         
205         emit Transfer(owner, to, balance);
206         return balance;
207     }
208     
209     /** @dev private functions for manage vault
210      */
211     function setVaultBalanceInDecimal(VaultEnum vaultNum, uint256 amount) private {
212         vault[VaultName[uint256(vaultNum)]] = convertToWei(amount);
213     }
214     
215     function getVaultBalance(VaultEnum vaultNum) private constant returns (uint256) {
216         return vault[VaultName[uint256(vaultNum)]];
217     }
218     
219     function convertToWei(uint256 value) private constant returns (uint256) {
220         return value * (10 ** uint256(decimals));
221     }
222 }