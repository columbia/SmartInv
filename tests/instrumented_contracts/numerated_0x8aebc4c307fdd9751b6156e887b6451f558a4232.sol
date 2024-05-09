1 /**
2  *Submitted for verification at Etherscan.io on 2019-05-07
3 */
4 
5 pragma solidity >= 0.5.0 < 0.6.0;
6 
7 
8 /**
9  * @title VONN token 
10  * @author J Kwon
11  */
12 
13 
14 /**
15  * @title ERC20 Standard Interface
16  */
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19     function balanceOf(address who) external view returns (uint256);
20     function transfer(address to, uint256 value) external returns (bool);
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 }
23 
24 
25 /**
26  * @title Token implementation
27  */
28 contract VONNI is IERC20 {
29     string public name = "VONNICON";
30     string public symbol = "VONNI";
31     uint8 public decimals = 18;
32     
33     uint256 partnerAmount;
34     uint256 marketingAmount;
35     uint256 pomAmount;
36     uint256 companyAmount;
37     uint256 kmjAmount;
38     uint256 kdhAmount;
39     uint256 saleAmount;
40 
41     
42     uint256 _totalSupply;
43     mapping(address => uint256) balances;
44 
45     address public owner;
46     address public partner;
47     address public marketing;
48     address public pom;
49     address public company;
50     address public kmj;
51     address public kdh;
52     address public sale;
53 
54     address public marker1;
55     address public marker2;
56     address public marker3;
57     address public marker4;
58     address public marker5;
59     address public marker6;
60 
61     IERC20 private _marker1;
62     IERC20 private _marker2;
63     IERC20 private _marker3;
64     IERC20 private _marker4;
65     IERC20 private _marker5;
66     IERC20 private _marker6;
67 
68     modifier isOwner {
69         require(owner == msg.sender);
70         _;
71     }
72     
73     constructor() public {
74         owner   = msg.sender;
75         partner = 0x0182bBbd17792B612a90682486FCfc6230D0C87a;
76         marketing = 0xE818EBEc8C8174049748277b8d0Dc266b1A9962A;
77         pom = 0x423325e29C8311217994B938f76fDe0040326B2A;
78         company = 0xfec56eFB1a87BB15da444fDaFFB384572aeceE17;
79         kmj = 0xC350493EC241f801901d1E74372B386c3e6E5703;
80         kdh = 0x7fACD833AD981Fbbfbe93b071E8c491A47cBC8Fa;
81         sale = 0xeab7Af104c4156Adb800E1Cd3ca35d358c6145b3;
82         
83         marker1 = 0xf54343AB797C9647a2643a037E16E8eF32b9Eb87;
84         marker2 = 0x31514548CbEAD19EEdc7977AC3cc52b8aF1a6FE2;
85         marker3 = 0xa4f5947Ee4EDD96dc8EAf2d9E6149B66E6558C14;
86         marker4 = 0x4908730237360Df173b0a870b7208B08EC26Bd13;
87         marker5 = 0x65b87739bac3987DBA6e7b04cD8ECeaB94b7Ea3d;
88         marker6 = 0x423B9EDD4b9D82bAc47A76efB5381EEDa4068581;
89         
90         partnerAmount   = toWei( 250000000);
91         marketingAmount = toWei( 500000000);
92         pomAmount       = toWei(1500000000);
93         companyAmount   = toWei(1150000000);
94         kmjAmount       = toWei( 100000000);
95         kdhAmount       = toWei( 250000000);
96         saleAmount      = toWei(1250000000);
97         _totalSupply    = toWei(5000000000);  //5,000,000,000
98         
99         
100          _marker1 = IERC20(marker1);
101          _marker2 = IERC20(marker2);
102          _marker3 = IERC20(marker3);
103          _marker4 = IERC20(marker4);
104          _marker5 = IERC20(marker5);
105          _marker6 = IERC20(marker6);
106 
107 
108 
109         require(_totalSupply == partnerAmount + marketingAmount + pomAmount + companyAmount + kmjAmount + kdhAmount + saleAmount );
110         
111         balances[owner] = _totalSupply;
112         emit Transfer(address(0), owner, balances[owner]);
113         
114         transfer(partner, partnerAmount);
115         transfer(marketing, marketingAmount);
116         transfer(pom, pomAmount);
117         transfer(company, companyAmount);
118         transfer(kmj, kmjAmount);
119         transfer(kdh, kdhAmount);
120         transfer(sale, saleAmount);
121 
122 
123         require(balances[owner] == 0);
124     }
125     
126     function totalSupply() public view returns (uint) {
127         return _totalSupply;
128     }
129 
130     function balanceOf(address who) public view returns (uint256) {
131         return balances[who];
132     }
133     
134     function transfer(address to, uint256 value) public returns (bool success) {
135         /* marker가 있으면 전송을 하지 않는다 */
136 
137         uint256 basis_timestamp1 = now - 1577836800 + 2592000;// 1577836800 <= 기준일: 2020-01-01
138         uint256 basis_timestamp2 = now - 1580515200 + 2592000;// 1577836800 <= 기준일: 2020-02-01
139         uint256 basis_timestamp3 = now - 1583020800 + 2592000;// 1577836800 <= 기준일: 2020-03-01
140         uint256 basis_timestamp4 = now - 1585699200 + 2592000;// 1577836800 <= 기준일: 2020-04-01
141         uint256 basis_timestamp5 = now - 1588291200 + 2592000;// 1577836800 <= 기준일: 2020-05-01
142         uint256 basis_timestamp6 = now - 1590969600 + 2592000;// 1577836800 <= 기준일: 2020-05-01
143 
144         if ( _marker1.balanceOf(msg.sender) > 0 && now < 1577836800 + 86400 * 30 * 20) {
145             uint256 past_month = basis_timestamp1 / (2592000);
146             uint256 allowance = (_marker1.balanceOf(msg.sender)) - ((_marker1.balanceOf(msg.sender)) * past_month / 20);
147             
148             require( balances[msg.sender] - value >= allowance );
149         }
150 
151 
152         if ( _marker2.balanceOf(msg.sender) > 0 && now < 1580515200 + 86400 * 30 * 20) {
153             uint256 past_month = basis_timestamp2 / (2592000);
154             uint256 allowance = (_marker2.balanceOf(msg.sender)) - ((_marker2.balanceOf(msg.sender)) * past_month / 20);
155             
156             require( balances[msg.sender] - value >= allowance );
157         }
158 
159 
160         if ( (_marker3.balanceOf(msg.sender)) > 0 && now < 1583020800 + 86400 * 30 * 20) {
161             uint256 past_month = basis_timestamp3 / (2592000);
162             uint256 allowance = (_marker3.balanceOf(msg.sender)) - ((_marker3.balanceOf(msg.sender)) * past_month / 20);
163             
164             require( balances[msg.sender] - value >= allowance );
165         }
166 
167 
168         if ( (_marker4.balanceOf(msg.sender)) > 0 && now < 1585699200 + 86400 * 30 * 20) {
169             uint256 past_month = basis_timestamp4 / (2592000);
170             uint256 allowance = (_marker4.balanceOf(msg.sender)) - ((_marker4.balanceOf(msg.sender)) * past_month / 20);
171             
172             require( balances[msg.sender] - value >= allowance );
173         }
174 
175         if ( (_marker5.balanceOf(msg.sender)) > 0 && now < 1588291200 + 86400 * 30 * 20) {
176             uint256 past_month = basis_timestamp5 / (2592000);
177             uint256 allowance = (_marker5.balanceOf(msg.sender)) - ((_marker5.balanceOf(msg.sender)) * past_month / 20);
178             
179             require( balances[msg.sender] - value >= allowance );
180         }
181 
182         if ( (_marker6.balanceOf(msg.sender)) > 0 && now < 1590969600 + 86400 * 30 * 20) {
183             uint256 past_month = basis_timestamp6 / (2592000);
184             uint256 allowance = (_marker6.balanceOf(msg.sender)) - ((_marker6.balanceOf(msg.sender)) * past_month / 20);
185             
186             require( balances[msg.sender] - value >= allowance );
187         }
188 
189 
190 
191         require(msg.sender != to);
192         require(value > 0);
193         
194         require( balances[msg.sender] >= value );
195         require( balances[to] + value >= balances[to] );
196 
197         if (to == address(0) || to == address(0x1) || to == address(0xdead)) {
198              _totalSupply -= value;
199         }
200 
201         balances[msg.sender] -= value;
202         balances[to] += value;
203 
204         emit Transfer(msg.sender, to, value);
205         return true;
206     }
207     
208     function burnCoins(uint256 value) public {
209         require(balances[msg.sender] >= value);
210         require(_totalSupply >= value);
211         
212         balances[msg.sender] -= value;
213         _totalSupply -= value;
214 
215         emit Transfer(msg.sender, address(0), value);
216     }
217 
218 
219     /** @dev private function
220      */
221 
222     function toWei(uint256 value) private view returns (uint256) {
223         return value * (10 ** uint256(decimals));
224     }
225 }