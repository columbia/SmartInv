1 pragma solidity 0.4.25;
2 
3 interface IERC20 {
4     function balanceOf(address who) external view returns (uint256);
5     function transfer(address to, uint256 value) external returns (bool);
6 }
7 
8 contract LotteryTicket {
9     address owner;
10     string public constant name = "LotteryTicket";
11     string public constant symbol = "✓";
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     constructor() public {
14         owner = msg.sender;
15     }
16     function emitEvent(address addr) public {
17         require(msg.sender == owner);
18         emit Transfer(msg.sender, addr, 1);
19     }
20 }
21 
22 contract WinnerTicket {
23     address owner;
24     string public constant name = "WinnerTicket";
25     string public constant symbol = "✓";
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     constructor() public {
28         owner = msg.sender;
29     }
30     function emitEvent(address addr) public {
31         require(msg.sender == owner);
32         emit Transfer(msg.sender, addr, 1);
33     }
34 }
35 
36 contract Ownable {
37     address public owner;
38     event OwnershipRenounced(address indexed previousOwner);
39     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40     constructor() public {
41         owner = msg.sender;
42     }
43     modifier onlyOwner() {
44         require(msg.sender == owner);
45         _;
46     }
47     function renounceOwnership() public onlyOwner {
48         emit OwnershipRenounced(owner);
49         owner = address(0);
50     }
51     function transferOwnership(address newOwner) public onlyOwner {
52         require(newOwner != address(0));
53         emit OwnershipTransferred(owner, newOwner);
54         owner = newOwner;
55     }
56 }
57 
58 contract Storage {
59     address game;
60 
61     mapping (address => uint256) public amount;
62     mapping (uint256 => address[]) public level;
63     uint256 public count;
64     uint256 public maximum;
65 
66     constructor() public {
67         game = msg.sender;
68     }
69 
70     function purchase(address addr) public {
71         require(msg.sender == game);
72 
73         amount[addr]++;
74         if (amount[addr] > 1) {
75             level[amount[addr]].push(addr);
76             if (amount[addr] > 2) {
77                 for (uint256 i = 0; i < level[amount[addr] - 1].length; i++) {
78                     if (level[amount[addr] - 1][i] == addr) {
79                         delete level[amount[addr] - 1][i];
80                         break;
81                     }
82                 }
83             } else if (amount[addr] == 2) {
84                 count++;
85             }
86             if (amount[addr] > maximum) {
87                 maximum = amount[addr];
88             }
89         }
90 
91     }
92 
93     function draw(uint256 goldenWinners) public view returns(address[] addresses) {
94 
95         addresses = new address[](goldenWinners);
96         uint256 winnersCount;
97 
98         for (uint256 i = maximum; i >= 2; i--) {
99             for (uint256 j = 0; j < level[i].length; j++) {
100                 if (level[i][j] != address(0)) {
101                     addresses[winnersCount] = level[i][j];
102                     winnersCount++;
103                     if (winnersCount == goldenWinners) {
104                         return;
105                     }
106                 }
107             }
108         }
109 
110     }
111 
112 }
113 
114 contract RefStorage is Ownable {
115 
116     IERC20 public token;
117 
118     mapping (address => bool) public contracts;
119 
120     uint256 public prize = 0.00005 ether;
121     uint256 public interval = 100;
122 
123     mapping (address => Player) public players;
124     struct Player {
125         uint256 tickets;
126         uint256 checkpoint;
127         address referrer;
128     }
129 
130     event ReferrerAdded(address player, address referrer);
131     event BonusSent(address recipient, uint256 amount);
132 
133     modifier restricted() {
134         require(contracts[msg.sender]);
135         _;
136     }
137 
138     constructor() public {
139         token = IERC20(address(0x9f9EFDd09e915C1950C5CA7252fa5c4F65AB049B));
140     }
141 
142     function changeContracts(address contractAddr) public onlyOwner {
143         contracts[contractAddr] = true;
144     }
145 
146     function changePrize(uint256 newPrize) public onlyOwner {
147         prize = newPrize;
148     }
149 
150     function changeInterval(uint256 newInterval) public onlyOwner {
151         interval = newInterval;
152     }
153 
154     function newTicket() external restricted {
155         players[tx.origin].tickets++;
156         if (players[tx.origin].referrer != address(0) && (players[tx.origin].tickets - players[tx.origin].checkpoint) % interval == 0) {
157             if (token.balanceOf(address(this)) >= prize * 2) {
158                 token.transfer(tx.origin, prize);
159                 emit BonusSent(tx.origin, prize);
160                 token.transfer(players[tx.origin].referrer, prize);
161                 emit BonusSent(players[tx.origin].referrer, prize);
162             }
163         }
164     }
165 
166     function addReferrer(address referrer) external restricted {
167         if (players[tx.origin].referrer == address(0) && players[referrer].tickets >= interval && referrer != tx.origin) {
168             players[tx.origin].referrer = referrer;
169             players[tx.origin].checkpoint = players[tx.origin].tickets;
170 
171             emit ReferrerAdded(tx.origin, referrer);
172         }
173     }
174 
175     function sendBonus(address winner) external restricted {
176         if (token.balanceOf(address(this)) >= prize) {
177             token.transfer(winner, prize);
178 
179             emit BonusSent(winner, prize);
180         }
181     }
182 
183     function withdrawERC20(address ERC20Token, address recipient) external onlyOwner {
184         uint256 amount = IERC20(ERC20Token).balanceOf(address(this));
185         IERC20(ERC20Token).transfer(recipient, amount);
186     }
187 
188     function ticketsOf(address player) public view returns(uint256) {
189         return players[player].tickets;
190     }
191 
192     function referrerOf(address player) public view returns(address) {
193         return players[player].referrer;
194     }
195 }