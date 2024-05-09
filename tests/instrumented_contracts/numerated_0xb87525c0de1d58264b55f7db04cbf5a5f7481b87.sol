1 pragma solidity >= 0.4.24 < 0.6.0;
2 
3 
4 /**
5  * @title Cat Coin for bbulddong
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
32  * @title CatCoin implementation
33  * @author Willy Lee
34  */
35 contract CatCoin is IERC20 {
36     //using SafeMath for uint256;   //  unnecessary lib
37 
38     string public name = "뻘쭘이코인";
39     string public symbol = "BBOL";
40     uint8 public decimals = 18;
41     
42     uint256 totalCoins;
43     mapping(address => uint256) balances;
44 
45     // Admin Address
46     address public owner;
47     
48     // keep reserved coins in vault for each purpose
49     enum VaultEnum {mining, mkt, op, team, presale}
50     string[] VaultName = ["mining", "mkt", "op", "team", "presale"];
51     mapping(string => uint256) vault;
52 
53     modifier isOwner {
54         require(owner == msg.sender);
55         _;
56     }
57     
58     event BurnCoin(uint256 amount);
59 
60     constructor() public {
61         uint256 discardCoins;    //  burning amount at initial time
62 
63         owner = msg.sender;
64 
65         setVaultBalance(VaultEnum.mining,   10000000000);   //  10 B
66         setVaultBalance(VaultEnum.mkt,      1000000000);    //  1 B
67         setVaultBalance(VaultEnum.op,       2000000000);    //  2 B
68         setVaultBalance(VaultEnum.team,     3000000000);    //  3 B, time lock to 2019-12-17
69         setVaultBalance(VaultEnum.presale,  3000000000);    //  3 B
70 
71         discardCoins = convertToWei(1000000000);            //  1 B
72 
73         // total must be 20 B
74         totalCoins = 
75             getVaultBalance(VaultEnum.mining) +
76             getVaultBalance(VaultEnum.mkt) +
77             getVaultBalance(VaultEnum.op) +
78             getVaultBalance(VaultEnum.team) +
79             getVaultBalance(VaultEnum.presale) +
80             discardCoins;
81             
82         require(totalCoins == convertToWei(20000000000));
83         
84         totalCoins -= getVaultBalance(VaultEnum.team);    // exclude locked coins from total supply
85         balances[owner] = totalCoins;
86 
87         emit Transfer(address(0), owner, balances[owner]);
88         burnCoin(discardCoins);
89     }
90     
91     /** @dev transfer mining coins to Megabit Exchanges address
92      */
93     function transferForMining(address to) external isOwner {
94         withdrawCoins(VaultName[uint256(VaultEnum.mining)], to);
95     }
96     
97     /** @dev withdraw coins for marketing budget to specified address
98      */
99     function withdrawForMkt(address to) external isOwner {
100         withdrawCoins(VaultName[uint256(VaultEnum.mkt)], to);
101     }
102     
103     /** @dev withdraw coins for maintenance cost to specified address
104      */
105     function withdrawForOp(address to) external isOwner {
106         withdrawCoins(VaultName[uint256(VaultEnum.op)], to);
107     }
108 
109     /** @dev withdraw coins for Megabit team to specified address after locked date
110      */
111     function withdrawForTeam(address to) external isOwner {
112         uint256 balance = getVaultBalance(VaultEnum.team);
113         require(balance > 0);
114         require(now >= 1576594800);     // lock to 2019-12-17
115         //require(now >= 1544761320);     // test date for dev
116         
117         balances[owner] += balance;
118         totalCoins += balance;
119         withdrawCoins(VaultName[uint256(VaultEnum.team)], to);
120     }
121 
122     /** @dev transfer sold(pre-sale) coins to specified address
123      */
124     function transferSoldCoins(address to, uint256 amount) external isOwner {
125         require(balances[owner] >= amount);
126         require(getVaultBalance(VaultEnum.presale) >= amount);
127         
128         balances[owner] -= amount;
129         balances[to] += amount;
130         setVaultBalance(VaultEnum.presale, getVaultBalance(VaultEnum.presale) - amount);
131 
132         emit Transfer(owner, to, amount);
133     }
134 
135     /** @dev implementation of withdrawal
136      *  @dev it is available once for each vault
137      */
138     function withdrawCoins(string vaultName, address to) private returns (uint256) {
139         uint256 balance = vault[vaultName];
140         
141         require(balance > 0);
142         require(balances[owner] >= balance);
143         require(owner != to);
144 
145         balances[owner] -= balance;
146         balances[to] += balance;
147         vault[vaultName] = 0;
148         
149         emit Transfer(owner, to, balance);
150         return balance;
151     }
152     
153     function burnCoin(uint256 amount) public isOwner {
154         require(balances[msg.sender] >= amount);
155         require(totalCoins >= amount);
156 
157         balances[msg.sender] -= amount;
158         totalCoins -= amount;
159 
160         emit BurnCoin(amount);
161     }
162 
163     function totalSupply() public constant returns (uint) {
164         return totalCoins;
165     }
166 
167     function balanceOf(address who) public view returns (uint256) {
168         return balances[who];
169     }
170     
171     function transfer(address to, uint256 value) public returns (bool success) {
172         require(msg.sender != to);
173         require(value > 0);
174         
175         require( balances[msg.sender] >= value );
176         require( balances[to] + value >= balances[to] );    // prevent overflow
177 
178         balances[msg.sender] -= value;
179         balances[to] += value;
180 
181         emit Transfer(msg.sender, to, value);
182         return true;
183     }
184     
185     /** @dev private functions for manage vault
186      */
187     function setVaultBalance(VaultEnum vaultNum, uint256 amount) private {
188         vault[VaultName[uint256(vaultNum)]] = convertToWei(amount);
189     }
190     
191     function getVaultBalance(VaultEnum vaultNum) private constant returns (uint256) {
192         return vault[VaultName[uint256(vaultNum)]];
193     }
194     
195     function convertToWei(uint256 value) private constant returns (uint256) {
196         return value * (10 ** uint256(decimals));
197     }
198 }