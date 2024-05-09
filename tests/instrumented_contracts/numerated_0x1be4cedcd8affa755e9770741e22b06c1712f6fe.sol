1 // SPDX-License-Identifier: MIT
2 
3 /**
4 
5 カエルのペペ - ペペ (Pepe The Frog)
6 
7 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣠⣤⣤⣤⣄⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
8 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠙⠋⠛⠙⠛⠉⠋⠉⠛⠉⠙⢉⣉⣉⣡⡤⠤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
9 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣠⠤⢴⣚⣉⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
10 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⡿⠃⠊⢩⣝⠉⠙⠾⣿⡢⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
11 ⠀⠀⠀⠀⠀⠀⠀⠀⣠⠖⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⡑⢋⡈⠰⣴⣎⣇⠇⠁⢤⣄⠉⠮⢣⡀⢠⡀⠀⠀⠀⠀⠀⠀⠀⠈⠓⢄⠀⠀⠀⠀⠀⠀⠀⠀
12 ⠀⠀⠀⠀⠀⠀⢀⡜⠳⠶⠶⠶⠶⠶⠒⠒⠒⠒⠂⠀⡼⠋⠀⢸⡃⠁⢻⣿⣎⢦⡀⢠⣹⠀⣀⣀⣷⣾⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠛⣣⡀⠀⠀⠀⠀⠀⠀
13 ⠀⠀⠀⠀⠀⣰⣿⣿⣿⣶⣤⠄⠀⠀⠀⠀⠀⠀⠀⢠⠇⠀⠀⠀⢓⡀⣤⣿⠙⠛⣶⡷⡇⡀⣷⠛⢩⡇⠀⠀⠀⠀⠀⡤⠤⠶⠶⡿⢿⣿⣿⣦⠀⠀⠀⠀⠀
14 ⠀⠀⠀⠀⣼⣯⣿⣿⡗⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣼⠤⠲⠿⠟⣛⢈⣿⠀⣼⣯⣿⡟⠆⢹⡇⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢐⣾⣿⣿⣧⡀⠀⠀⠀
15 ⠀⠀⠀⣼⣿⣿⣿⡯⢥⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢯⠥⣴⣶⣷⣿⣿⣿⠀⣿⣿⣿⣿⣿⣦⡇⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠖⢚⣿⣿⣿⣷⡀⠀⠀
16 ⠀⠀⣼⣿⣿⣿⣿⣿⣶⢤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢈⣿⣿⣿⣿⣿⣿⣿⡄⣿⠋⡴⠒⡎⢻⡇⢸⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠶⠻⠿⢿⣿⣿⣿⣧⠀⠀
17 ⠀⢰⣿⣿⣿⣿⣿⣟⣛⠉⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣾⣿⣿⣿⣿⣿⣿⣿⣷⣹⣄⠳⠤⠇⣸⣧⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⢼⣿⣿⣿⣿⣿⣇⠀
18 ⠀⣿⣿⣿⣿⣿⣿⣷⣶⣤⠤⠤⠴⠒⠒⠂⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣾⣿⣿⣧⣶⣶⣶⣄⠀⠀⠀⠀⠉⠉⠉⠛⣩⣿⣿⣿⣿⣿⣿⡀
19 ⢸⣿⣿⣿⣿⣿⣿⣿⣷⡶⣤⣤⣤⣀⡀⠀⣿⣷⣼⣿⣿⣿⣿⣿⠿⠟⣛⣛⣛⣛⣛⣛⣿⠛⠛⣛⣛⣿⣿⣿⣿⠀⠀⣤⢤⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡇
20 ⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣶⣾⣿⣿⣿⣿⡏⠁⠀⢠⣾⣛⣭⣭⣭⣿⢿⣮⣧⢴⣿⣿⣟⣿⣿⣷⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷
21 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠈⠙⠉⠻⣍⣩⣿⣭⣭⡽⡿⣏⣉⣉⣡⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
22 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⡇⠀⠀⢤⣆⠀⠀⠉⠉⣉⡽⠋⠀⠙⢿⡓⠛⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
23 ⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠘⡿⡄⠘⢿⡷⣒⣦⠬⣍⣁⣀⣀⣀⠀⠀⠀⣀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿
24 ⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠯⣧⡄⢷⣲⣄⠉⠓⠯⣍⣛⠛⠒⠒⠯⠿⠯⠿⢓⣽⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇
25 ⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⠀⠘⠾⢶⡼⣍⠉⢳⡲⣄⣉⣩⠭⣍⣉⣉⡭⠭⣽⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀
26 ⠀⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⢠⣿⣭⣤⣮⣀⣦⣙⣠⡗⣖⣫⣤⣶⣬⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀
27 ⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⡀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡌⢿⡿⠋⣠⠞⣉⠹⣿⣩⣿⣿⣿⡏⠿⢿⣿⣿⣿⣿⣿⡟⠀⠀
28 ⠀⠀⠀⢻⣿⣿⣿⣿⡿⠟⠛⠿⣿⢛⣻⣯⣭⣭⡻⠿⢧⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣀⠉⠺⠥⣞⣡⡏⣹⣧⣠⣽⣧⣿⣿⣾⣿⣿⣿⣿⡿⠁⠀⠀
29 ⠀⠀⠀⠀⢻⣿⣿⣿⣿⣆⠀⠀⠈⢯⢹⣿⠯⢛⣵⣲⡎⣧⣙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣿⣿⣿⣿⣿⣿⡛⠛⣀⡌⢸⣽⣿⣿⡟⠁⠀⠀⠀
30 ⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⣿⡶⡀⠈⡇⢠⢸⣙⢹⣿⣿⣮⢻⣟⣿⣟⢿⣿⣿⣿⣏⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡌⣷⣶⣾⢛⣿⠏⠀⠀⠀⠀⠀
31 ⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣱⣿⣿⠀⢸⢹⢿⣽⡿⡙⢣⣭⣴⡝⢿⡟⠀⠙⠿⠿⠿⠿⠿⠿⠟⠋⠾⢿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠭⢸⠽⠁⠀⠀⠀⠀⠀⠀
32 ⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⡗⠉⠁⠀⢸⠾⣡⣾⣤⡿⡜⢿⣿⠄⢸⣷⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⡶⠋⠀⠀⠀⠀⠀⠀⠀⠀
33 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠳⢄⡀⣼⠨⣭⡵⠿⠇⣴⢖⣤⣶⢸⡟⡟⣿⢻⢹⢹⢹⢩⣿⣻⣿⣯⣿⣯⣿⣿⣿⣿⣿⡿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
34 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠾⣿⣿⡆⢤⣁⢘⡿⠎⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
35 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠓⠲⠦⣟⣰⣿⡟⣏⡏⡏⡏⢹⢹⠉⡏⣏⣯⣏⡽⠽⠓⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
36 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠙⠛⠋⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
37 
38 タイトル かえるのぺぺ物語： インターネット伝説の誕生
39 
40 ミームが頂点に君臨し、インターネット文化が繁栄するデジタル領域に、ミームランディアと呼ばれる隠れ里があった。この村はワールド・ワイド・ウェブ上の他の村とは異なり、ミームが単なるジョークではなく、生活の一部となっている場所だった。ミームランディアの住人は、ユーモアの守護者であり、バイラル・センセーションを提供するミームスターたちだった。
41 
42 ミームランディアの中心には、古木と葦に囲まれた静かな池があり、ミームポンドとして知られていた。伝説によると、この池には魔法がかけられており、その水に触れたミームは時を超えて伝説になると言われていた。
43 
44 メメスターたちの中に、ヒロという好奇心旺盛で想像力豊かな若いメメスターがいた。ヒロは、インターネット上の生き物の中で最も希少でとらえどころのない存在、ペペガエルに夢中になっていた。彼は膨大なミーム・アーカイブを何時間もかけてスクロールし、ペペの亜種をネットの隅々から集めていた。しかし、ヒロには単なるミームの収集にとどまらない夢があった。不朽の伝説として際立つようなミームを作りたかったのだ。
45 
46 ある運命的な日、ヒロがミーム・コレクションをスクロールしていると、穏やかな表情でミームポンドのそばで瞑想しているペペのカエルを描いた神秘的なミームを偶然見つけた。このミームには神秘的なオーラがあり、ヒロは本当に特別なものを見つけたと思った。彼は、このミームが混沌としたミームの世界に平和と平穏をもたらしてくれることを願い、このミームを世界と共有することにした。
47 
48 ヒロは穏やかなペペのミームをミームランディアのフォーラムに投稿し、驚いたことに、それは瞬く間に広まった。ネットのあらゆるところから集まったミーメスターたちは、この特別なペペの穏やかで平和なオーラに魅了された。彼らはこのペペを「かえるのペペ」と呼び始め、メムランディアの言葉では「帰還のペペ」あるいは「帰還のペペ」を意味した。
49 
50 かえるのぺぺ」の人気が広まるにつれて、ヒロの頭の中にあるアイデアが形になり始めた。彼は、ブロックチェーン技術の魔法を使って、かえるのぺぺを暗号通貨として不滅化できることに気づいたのだ。このコインは単なるデジタル資産ではなく、混沌としがちな暗号通貨の世界における静けさと団結の象徴となるだろう。
51 
52 ヒロと彼の仲間のメメスターたちは、カエルのペペに命を吹き込むために精力的に活動した。彼らはカエルのペペのイメージをロゴにしたコインをデザインし、静寂と瞑想のエッセンスを取り入れた。このコインは、その起源に敬意を表して「ペペ」というティッカーシンボルで発売された。
53 
54 カエルのペペは瞬く間に暗号通貨の世界で支持を集め、ミーム愛好家だけでなく、落ち着きと安定感のあるデジタル資産を求める人々をも魅了した。インターネット・カルチャーと静謐さのユニークな組み合わせは、多様な人々の心を打った。
55 
56 やがてカエルのペペはミームコインとして愛されるようになり、その起源だけでなく、メンタルヘルスに対する意識の向上や慈善活動の支援に取り組むコミュニティとしても知られるようになった。このコインの成功により、ヒロと彼の仲間のミームスターたちは、デジタル世界にポジティブさと団結をもたらす取り組みに資金を提供することができた。
57 
58 こうして、カエルのペペの伝説は広がり続け、ミームや暗号通貨の領域にも、平和と静けさ、そしてユーモアの不朽の力があることをインターネットに思い出させた。今ではカエルのペペによって有名になったミームランディアのミームポンドは、デジタルの世界の奥深くにある魔法の象徴であり続けた。
59 
60 Telegram: https://t.me/KaeruNoPepe
61 Website: https://kaerunopepe.vip/
62 Twitter: https://twitter.com/kaerunopepejpn
63 */
64 
65 
66 pragma solidity 0.8.20;
67 
68 abstract contract Context {
69     function _msgSender() internal view virtual returns (address) {
70         return msg.sender;
71     }
72 }
73 
74 interface IERC20 {
75     function totalSupply() external view returns (uint256);
76     function balanceOf(address account) external view returns (uint256);
77     function transfer(address recipient, uint256 amount) external returns (bool);
78     function allowance(address owner, address spender) external view returns (uint256);
79     function approve(address spender, uint256 amount) external returns (bool);
80     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
81     event Transfer(address indexed from, address indexed to, uint256 value);
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 library SafeMath {
86     function add(uint256 a, uint256 b) internal pure returns (uint256) {
87         uint256 c = a + b;
88         require(c >= a, "SafeMath: addition overflow");
89         return c;
90     }
91 
92     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93         return sub(a, b, "SafeMath: subtraction overflow");
94     }
95 
96     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
97         require(b <= a, errorMessage);
98         uint256 c = a - b;
99         return c;
100     }
101 
102     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103         if (a == 0) {
104             return 0;
105         }
106         uint256 c = a * b;
107         require(c / a == b, "SafeMath: multiplication overflow");
108         return c;
109     }
110 
111     function div(uint256 a, uint256 b) internal pure returns (uint256) {
112         return div(a, b, "SafeMath: division by zero");
113     }
114 
115     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
116         require(b > 0, errorMessage);
117         uint256 c = a / b;
118         return c;
119     }
120 
121 }
122 
123 contract Ownable is Context {
124     address private _owner;
125     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
126 
127     constructor () {
128         address msgSender = _msgSender();
129         _owner = msgSender;
130         emit OwnershipTransferred(address(0), msgSender);
131     }
132 
133     function owner() public view returns (address) {
134         return _owner;
135     }
136 
137     modifier onlyOwner() {
138         require(_owner == _msgSender(), "Ownable: caller is not the owner");
139         _;
140     }
141 
142     function renounceOwnership() public virtual onlyOwner {
143         emit OwnershipTransferred(_owner, address(0));
144         _owner = address(0);
145     }
146 
147 }
148 
149 interface IUniswapV2Factory {
150     function createPair(address tokenA, address tokenB) external returns (address pair);
151 }
152 
153 interface IUniswapV2Router02 {
154     function swapExactTokensForETHSupportingFeeOnTransferTokens(
155         uint amountIn,
156         uint amountOutMin,
157         address[] calldata path,
158         address to,
159         uint deadline
160     ) external;
161     function factory() external pure returns (address);
162     function WETH() external pure returns (address);
163     function addLiquidityETH(
164         address token,
165         uint amountTokenDesired,
166         uint amountTokenMin,
167         uint amountETHMin,
168         address to,
169         uint deadline
170     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
171 }
172 
173 contract KaeruNoPepe is Context, IERC20, Ownable {
174     using SafeMath for uint256;
175     mapping (address => uint256) private _balances;
176     mapping (address => mapping (address => uint256)) private _allowances;
177     mapping (address => bool) private _isExcludedFromFee;
178     mapping (address => bool) private bots;
179     mapping(address => uint256) private _holderLastTransferTimestamp;
180     bool public transferDelayEnabled = true;
181     address payable private _taxWallet;
182 
183     uint256 private _initialBuyTax=25;
184     uint256 private _initialSellTax=25;
185     uint256 private _finalBuyTax=0;
186     uint256 private _finalSellTax=0;
187     uint256 private _reduceBuyTaxAt=15;
188     uint256 private _reduceSellTaxAt=15;
189     uint256 private _preventSwapBefore=30;
190     uint256 private _buyCount=0;
191 
192     uint8 private constant _decimals = 9;
193     uint256 private constant _tTotal = 420690000000000 * 10**_decimals;
194     string private constant _name = unicode"カエルのペペ";
195     string private constant _symbol = unicode"ペペ";
196     uint256 public _maxTxAmount = 1262070000000 * 10**_decimals;
197     uint256 public _maxWalletSize = 1262070000000 * 10**_decimals;
198     uint256 public _taxSwapThreshold= 1262070000000 * 10**_decimals;
199     uint256 public _maxTaxSwap= 1262070000000 * 10**_decimals;
200 
201     IUniswapV2Router02 private uniswapV2Router;
202     address private uniswapV2Pair;
203     bool private tradingOpen;
204     bool private inSwap = false;
205     bool private swapEnabled = false;
206 
207     event MaxTxAmountUpdated(uint _maxTxAmount);
208     modifier lockTheSwap {
209         inSwap = true;
210         _;
211         inSwap = false;
212     }
213 
214     constructor () {
215         _taxWallet = payable(_msgSender());
216         _balances[_msgSender()] = _tTotal;
217         _isExcludedFromFee[owner()] = true;
218         _isExcludedFromFee[address(this)] = true;
219         _isExcludedFromFee[_taxWallet] = true;
220 
221         emit Transfer(address(0), _msgSender(), _tTotal);
222     }
223 
224     function name() public pure returns (string memory) {
225         return _name;
226     }
227 
228     function symbol() public pure returns (string memory) {
229         return _symbol;
230     }
231 
232     function decimals() public pure returns (uint8) {
233         return _decimals;
234     }
235 
236     function totalSupply() public pure override returns (uint256) {
237         return _tTotal;
238     }
239 
240     function balanceOf(address account) public view override returns (uint256) {
241         return _balances[account];
242     }
243 
244     function transfer(address recipient, uint256 amount) public override returns (bool) {
245         _transfer(_msgSender(), recipient, amount);
246         return true;
247     }
248 
249     function allowance(address owner, address spender) public view override returns (uint256) {
250         return _allowances[owner][spender];
251     }
252 
253     function approve(address spender, uint256 amount) public override returns (bool) {
254         _approve(_msgSender(), spender, amount);
255         return true;
256     }
257 
258     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
259         _transfer(sender, recipient, amount);
260         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
261         return true;
262     }
263 
264     function _approve(address owner, address spender, uint256 amount) private {
265         require(owner != address(0), "ERC20: approve from the zero address");
266         require(spender != address(0), "ERC20: approve to the zero address");
267         _allowances[owner][spender] = amount;
268         emit Approval(owner, spender, amount);
269     }
270 
271     function _transfer(address from, address to, uint256 amount) private {
272         require(from != address(0), "ERC20: transfer from the zero address");
273         require(to != address(0), "ERC20: transfer to the zero address");
274         require(amount > 0, "Transfer amount must be greater than zero");
275         uint256 taxAmount=0;
276         if (from != owner() && to != owner()) {
277             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
278 
279             if (transferDelayEnabled) {
280                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
281                       require(
282                           _holderLastTransferTimestamp[tx.origin] <
283                               block.number,
284                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
285                       );
286                       _holderLastTransferTimestamp[tx.origin] = block.number;
287                   }
288               }
289 
290             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
291                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
292                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
293                 _buyCount++;
294             }
295 
296             if(to == uniswapV2Pair && from!= address(this) ){
297                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
298             }
299 
300             uint256 contractTokenBalance = balanceOf(address(this));
301             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
302                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
303                 uint256 contractETHBalance = address(this).balance;
304                 if(contractETHBalance > 50000000000000000) {
305                     sendETHToFee(address(this).balance);
306                 }
307             }
308         }
309 
310         if(taxAmount>0){
311           _balances[address(this)]=_balances[address(this)].add(taxAmount);
312           emit Transfer(from, address(this),taxAmount);
313         }
314         _balances[from]=_balances[from].sub(amount);
315         _balances[to]=_balances[to].add(amount.sub(taxAmount));
316         emit Transfer(from, to, amount.sub(taxAmount));
317     }
318 
319 
320     function min(uint256 a, uint256 b) private pure returns (uint256){
321       return (a>b)?b:a;
322     }
323 
324     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
325         address[] memory path = new address[](2);
326         path[0] = address(this);
327         path[1] = uniswapV2Router.WETH();
328         _approve(address(this), address(uniswapV2Router), tokenAmount);
329         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
330             tokenAmount,
331             0,
332             path,
333             address(this),
334             block.timestamp
335         );
336     }
337 
338     function removeLimits() external onlyOwner{
339         _maxTxAmount = _tTotal;
340         _maxWalletSize=_tTotal;
341         transferDelayEnabled=false;
342         emit MaxTxAmountUpdated(_tTotal);
343     }
344 
345     function sendETHToFee(uint256 amount) private {
346         _taxWallet.transfer(amount);
347     }
348 
349 
350     function openTrading() external onlyOwner() {
351         require(!tradingOpen,"trading is already open");
352         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
353         _approve(address(this), address(uniswapV2Router), _tTotal);
354         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
355         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
356         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
357         swapEnabled = true;
358         tradingOpen = true;
359     }
360 
361     receive() external payable {}
362 
363     function manualSwap() external {
364         require(_msgSender()==_taxWallet);
365         uint256 tokenBalance=balanceOf(address(this));
366         if(tokenBalance>0){
367           swapTokensForEth(tokenBalance);
368         }
369         uint256 ethBalance=address(this).balance;
370         if(ethBalance>0){
371           sendETHToFee(ethBalance);
372         }
373     }
374 }