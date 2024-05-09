1 pragma solidity 0.4.21;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 
33 contract ROBOToken {
34     uint256 public totalSupply;
35     function balanceOf(address who) public view returns (uint256);
36     function transfer(address to, uint256 value) public returns (bool);
37     event Transfer(address indexed from, address indexed to, uint256 value);
38     function allowance(address owner, address spender) public view returns (uint256);
39     function transferFrom(address from, address to, uint256 value) public returns (bool);
40     function approve(address spender, uint256 value) public returns (bool);
41     event Approval(address indexed owner, address indexed spender, uint256 value);
42 }
43 
44 
45 contract FoundersContract {
46     using SafeMath for uint256;
47     ROBOToken public token;
48 
49     uint64 public freezOne = 1538352000;
50     uint64 public freezTwo = 1554076800;
51 
52     mapping(address => uint256) public balances_freez_one;
53     mapping(address => uint256) public balances_freez_two;
54 
55     address muhtov = 0x0134111c40D59E8476FfabB7D0B2ED6F86513E6e; //13 680 000
56     address scherbakov = 0x7B8E11cFE4E7aFec83276002dD246a71a4bD51EC;// 13 680 000
57     address sattarova = 0xFDA80FA2b42063F5c2Aa14C5da18cBBDfC2f72F8;//720 000
58 
59     address roma_kiev = 0x5edc1959772b3C63310f475E04a72CdA1733D6A4;//Рома Киев	5%	1 800 000
60     address iliya = 0x45F8da4a6f465345DdaF003094C2B9D11254B15D;//Ильяс Казань	3%	1 080 000
61     address oleg =0x5f77b7F905913431957E800BfbDF5a9DB1B911C7;//Олег Калининград	5%	1 800 000
62     address fund =0x0Ecff5AA3F6bEcA65e0c39660b8A410c62d18F05;//ФОНД	1%	360 000
63     address mihail =0xb19f59271B64A2f8240b62Dbd6EEDFF38f6778DD;//Михаил	5%	1 800 000
64     address reserv1 =0x8a51B8Bc84272E375D2d46A8b29B1E245F2a9248;//Резерв1	1%	360 000
65     address reserv2 =0x3B820FDabc92d338E3625BbA2F81366df1C417d6;//Резерв2	1%	360 000
66     address reserv3 =0xb3B142e2Edccfb844c83CCcc872cFd8A13505240;//Резерв3	1%	360 000
67 
68 
69     address kostya = 0xC4Eb8BfFBAA3BC5dF11bdFD2e3800ed88EE0e5c7;//Костя	14%	500 000
70     address igor = 0xCd25FF018807bd8082E27AD7E12A28964c17159D;//Игорь	6%	200 000
71     address dasha =0x05D6b898701961452298D09B87f072239D836Cf4;//Даша	4%	150 000
72     address alexey =0x6BC2ee50CD8491745fD45Fb3a8E400BEdb2e02df;//Алексей	4%	150 000
73     address emp1 =0x8bfDedbB38ee8e6354BeffdAC26F0c64bBAB4F1d;//emp1	4%	150 000
74     address emp2 =0x4BCce99dD86DC640DCd76510aC7E68be67b44dD9;//emp2	4%	150 000
75     address emp3 =0x28C6d5D60A57046778be226c1Fea9def8B7bC067;//emp3	4%	150 000
76     address emp4 =0x00D56900f9D2d559A89fAEfe2CfbB464B1368dEe;//emp4	4%	150 000
77     address emp5 =0x241B9F4eeC66bE554378b1C9fF93FD4aaC0bD31c;//emp5	6%	200 000
78     address emp6 =0x536917d509117ccC26171E21CC51335d0b8022CE;//emp6	6%	200 000
79     address emp7 =0xf818199304A658B770eEcb85F2ad891D1B582beB;//emp7	6%	200 000
80     address emp8 =0x88Aec59d98b2dBEde71F96a5C8044D5b619955C0;//emp8	6%	200 000
81     address emp9 =0x35b3bDb3aC3c1c834fb5e9798a6cB9Db97caF370;//emp9	6%	200 000
82     address emp10 =0x9CA083D10fC4944F22654829Ac2E9702Ecce204F;//emp10	6%	200 000
83     address emp11 =0xBfD84a9641849B07271919AD2ad5F2453F4BF06c;//emp11	6%	200 000
84     address emp12 =0x7Ff40441F748229A004bc15e70Fccf3c82A51874;//emp12	3%	100 000
85     address emp13 =0xE7B45875d2380113eC3F76E7B7a44549C368E523;//emp13	3%	100 000
86     address emp14 =0xB46C56C97664152F77B26c5D0b8B5f1CB642A84E;//emp14	3%	100 000
87     address emp15 =0x897a133c4f01aEf11c58fd9Ec0c7932552a39C9f;//emp15	3%	100 000
88     address emp16 =0xd9537D3cf1a2624FA309c0AA65ac9eaAE350ef1D;//emp16	3%	100 000
89     address emp17 =0x4E4c22151f47D2C236Ac9Ec5D4fC2B46c58b34dE;//emp17	3%	100 000
90 
91 
92 
93     function FoundersContract(address _token) public {
94         token = ROBOToken(_token);
95 
96         balances_freez_one[muhtov] = 6840000 * 1 ether; //13680000
97         balances_freez_one[scherbakov] = 6840000 * 1 ether;// 13680000
98         balances_freez_one[sattarova] = 320000 * 1 ether;//720000
99 
100         balances_freez_one[roma_kiev] = 900000 * 1 ether;//Рома Киев	5%	1800000
101         balances_freez_one[iliya] = 540000 * 1 ether;//Ильяс Казань	3%	1080000
102         balances_freez_one[oleg] = 900000 * 1 ether;//Олег Калининград	5%	1800000
103         balances_freez_one[fund] = 180000 * 1 ether;//ФОНД	1%	360000
104         balances_freez_one[mihail] =900000 * 1 ether; //Михаил	5%	1800000
105         balances_freez_one[reserv1] =180000 * 1 ether;//Резерв1	1%	360000
106         balances_freez_one[reserv2] =180000 * 1 ether;//Резерв2	1%	360000
107         balances_freez_one[reserv3] =180000 * 1 ether;//Резерв3	1%	360000
108 
109 
110         balances_freez_one[kostya] =  250000 * 1 ether;//500000
111         balances_freez_one[igor] = 100000 * 1 ether;//Игорь	6%	200000
112         balances_freez_one[dasha] = 75000 * 1 ether;//Даша	4%	150000
113         balances_freez_one[alexey] = 75000 * 1 ether;//Алексей	4%	150000
114         balances_freez_one[emp1] = 75000 * 1 ether;//emp1	4%	150000
115         balances_freez_one[emp2] = 75000 * 1 ether;//emp2	4%	150000
116         balances_freez_one[emp3] = 75000 * 1 ether;//emp3	4%	150000
117         balances_freez_one[emp4] = 75000 * 1 ether;//emp4	4%	150000
118         balances_freez_one[emp5] = 100000 * 1 ether;//emp5	6%	200000
119         balances_freez_one[emp6] = 100000 * 1 ether;//emp6	6%	200000
120         balances_freez_one[emp7] = 100000 * 1 ether;//emp7	6%	200000
121         balances_freez_one[emp8] = 100000 * 1 ether;//emp8	6%	200000
122         balances_freez_one[emp9] = 100000 * 1 ether;//emp9	6%	200000
123         balances_freez_one[emp10] = 100000 * 1 ether;//emp10	6%	200000
124         balances_freez_one[emp11] = 100000 * 1 ether;//emp11	6%	200000
125         balances_freez_one[emp12] = 50000 * 1 ether;//emp12	3%	100000
126         balances_freez_one[emp13] = 50000 * 1 ether;//emp13	3%	100000
127         balances_freez_one[emp14] = 50000 * 1 ether;//emp14	3%	100000
128         balances_freez_one[emp15] = 50000 * 1 ether;//emp15	3%	100000
129         balances_freez_one[emp16] = 50000 * 1 ether;//emp16	3%	100000
130         balances_freez_one[emp17] = 50000 * 1 ether; //emp17	3%	100000
131 
132 
133         balances_freez_two[muhtov] = balances_freez_one[muhtov];
134         balances_freez_two[scherbakov] = balances_freez_one[scherbakov];
135         balances_freez_two[sattarova] = balances_freez_one[sattarova];
136 
137         balances_freez_two[roma_kiev] = balances_freez_one[roma_kiev];
138         balances_freez_two[iliya] = balances_freez_one[iliya];
139         balances_freez_two[oleg] = balances_freez_one[oleg];
140         balances_freez_two[fund] = balances_freez_one[fund];
141         balances_freez_two[mihail] = balances_freez_one[mihail];
142         balances_freez_two[reserv1] = balances_freez_one[reserv1];
143         balances_freez_two[reserv2] = balances_freez_one[reserv2];
144         balances_freez_two[reserv3] = balances_freez_one[reserv3];
145 
146 
147         balances_freez_two[kostya] = balances_freez_one[kostya];
148         balances_freez_two[igor] = balances_freez_one[igor];
149         balances_freez_two[dasha] = balances_freez_one[dasha];
150         balances_freez_two[alexey] = balances_freez_one[alexey];
151         balances_freez_two[emp1] = balances_freez_one[emp1];
152         balances_freez_two[emp2] = balances_freez_one[emp2];
153         balances_freez_two[emp3] = balances_freez_one[emp3];
154         balances_freez_two[emp4] = balances_freez_one[emp4];
155         balances_freez_two[emp5] = balances_freez_one[emp5];
156         balances_freez_two[emp6] = balances_freez_one[emp6];
157         balances_freez_two[emp7] = balances_freez_one[emp7];
158         balances_freez_two[emp8] = balances_freez_one[emp8];
159         balances_freez_two[emp9] = balances_freez_one[emp9];
160         balances_freez_two[emp10] = balances_freez_one[emp10];
161         balances_freez_two[emp11] = balances_freez_one[emp11];
162         balances_freez_two[emp12] = balances_freez_one[emp12];
163         balances_freez_two[emp13] = balances_freez_one[emp13];
164         balances_freez_two[emp14] = balances_freez_one[emp14];
165         balances_freez_two[emp15] = balances_freez_one[emp15];
166         balances_freez_two[emp16] = balances_freez_one[emp16];
167         balances_freez_two[emp17] = balances_freez_one[emp17];
168 
169     }
170 
171 
172     function getFirstTokens() public {
173         require(freezOne <= uint64(now));
174         token.transfer(msg.sender, balances_freez_one[msg.sender]);
175     }
176 
177 
178     function getSecondTokens() public {
179         require(freezTwo <= uint64(now));
180         token.transfer(msg.sender, balances_freez_two[msg.sender]);
181     }
182 }