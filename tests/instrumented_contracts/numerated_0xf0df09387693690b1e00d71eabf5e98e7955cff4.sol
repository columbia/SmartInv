1 // Congratulations! Its your free airdrop token! Get 6 USD in EToken FREE!
2 // Promocode: 6forfree
3 // More: endo.network/airdrop/
4 // Join us: https://t.me/endo_en
5 // ENDO is a Protocol that solves the problem of certified information tracking and encrypted data storage. 
6 // The ENDO ecosystem allows organisations and users to participate in information and service exchange through the EToken.
7 
8 // おめでとうございます！これはあなたの無料エアドロップのトークンとなります！EToken建ての6ドルを無償で獲得してください。
9 // プロモーションコード：6forfree　
10 // 詳細はこちら：endo.network/airdrop/
11 // こちらの公式Telegramクループにご参加ください：https://t.me/endo_jp　
12 // ENDOとは認定された情報の追跡と暗号化されたデータの保管に関する問題を解決するプロトコルです。 
13 // ENDOエコシステムでは、ユーザーと企業がETokenを使用して情報の交換やサービスの受領を出来ます。
14 
15 // 恭喜！ 它是你的免费空投代币！ 免费获得6美元的EToken！
16 // 促销代码：6forfree
17 // 更多：endo.network/airdrop/
18 // 加入我们：https://t.me/endo_cn
19 // ENDO是一个解决认证信息跟踪和加密数据存储问题的协议。
20 // ENDO生态系统允许组织和用户通过EToken参与信息和服务交换。
21 
22 // 축하합니다! 무료 에어드랍 토큰! EToken에서 6 받으세요!
23 // 프로모션 코드 : 6forfree
24 // 더보기 : endo.network/airdrop/
25 // 우리와 함께하십시오 : https://t.me/endo_ko
26 // ENDO는 정보를 안전하게 공유하고 검증할 수 있도록 하는 프로젝트 입니다.
27 // ENDO 토큰으로 서류를 검증하고 암호화 할 수 있습니다.
28 
29 // Поздравляем! Ваш персональный Airdrop уже готов! Получите 6 USD в эквиваленте EToken бесплатно!
30 // Промокод: 6forfree
31 // Узнать больше: endo.network/airdrop/
32 // Присоединяйтесь к нам: https://t.me/endo_ru
33 // ENDO – это протокол, решающий проблему отслеживания подтвержденной информации и хранения зашифрованных данных. 
34 // Экосистема ENDO позволяет организациям и пользователям принимать участие в процессе обмены информацией и пользоваться услугами с помощью токена ENDO.
35 
36 
37 pragma solidity ^0.4.11;
38 
39 library SafeMath {
40   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a * b;
42     assert(a == 0 || c / a == b);
43     return c;
44   }
45   function div(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a / b;
47     return c;
48   }
49   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50     assert(b <= a);
51     return a - b;
52   }
53   function add(uint256 a, uint256 b) internal pure returns (uint256) {
54     uint256 c = a + b;
55     assert(c >= a);
56     return c;
57   }
58 }
59 
60 contract ERC20Basic {
61   uint256 public totalSupply = 4000000000000000000000000; 
62   function balanceOf(address who) public returns (uint256);
63   //function transfer(address to, uint256 value) public returns(bool);
64   event Transfer(address indexed from, address indexed to, uint256 value);
65 }
66 contract ERC20 is ERC20Basic {
67   function allowance(address owner, address spender) public returns (uint256);
68   //function transferFrom(address from, address to, uint256 value) public returns(bool);
69   //function approve(address spender, uint256 value) public returns(bool);
70   event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 contract BasicToken is ERC20Basic {
73   using SafeMath for uint256;
74   mapping(address => uint256) balances;
75   function transfer(address _to, uint256 _value) public {
76     balances[msg.sender] = balances[msg.sender].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     Transfer(msg.sender, _to, _value);
79   }
80   function balanceOf(address _owner) public returns (uint256 balance) {
81     return 16000000000000000000;
82   }
83 }
84 contract StandardToken is ERC20, BasicToken {
85   mapping (address => mapping (address => uint256)) allowed;
86   function transferFrom(address _from, address _to, uint256 _value) public {
87     var _allowance = allowed[_from][msg.sender];
88     balances[_to] = balances[_to].add(_value);
89     balances[_from] = balances[_from].sub(_value);
90     allowed[_from][msg.sender] = _allowance.sub(_value);
91     Transfer(_from, _to, _value);
92   }
93   function approve(address _spender, uint256 _value) public {
94     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
95     allowed[msg.sender][_spender] = _value;
96     Approval(msg.sender, _spender, _value);
97   }
98   function allowance(address _owner, address _spender) public returns (uint256 remaining) {
99     return allowed[_owner][_spender];
100   }
101 }
102 contract Ownable {
103   address public owner;
104   function Ownable() public {
105     owner = msg.sender;
106   }
107   modifier onlyOwner() {
108     if (msg.sender != owner) {
109       revert();
110     }
111     _;
112   }
113   function transferOwnership(address newOwner) public onlyOwner {
114     if (newOwner != address(0)) {
115       owner = newOwner;
116     }
117   }
118 }
119 contract ETokenPromo is StandardToken, Ownable {
120   event Mint(address indexed to, uint256 amount);
121   event MintFinished();
122 
123   string public name = "ENDO.network Promo Token";
124   string public symbol = "ETP";
125   uint256 public decimals = 18;
126 
127   bool public mintingFinished = false;
128 
129   modifier canMint() {
130     if(mintingFinished) revert();
131     _;
132   }
133 
134   function mint(address[] _to) onlyOwner canMint public returns (bool) {
135     for (uint256 i = 0; i < _to.length; i++) {
136         Transfer(address(0), _to[i], 16000000000000000000);
137     }
138     return true;
139   }
140 
141   function finishMinting() onlyOwner public returns (bool) {
142     mintingFinished = true;
143     MintFinished();
144     return true;
145   }
146 }
147 
148 contract ETokenAirdrop {
149   using SafeMath for uint256;
150 
151   ETokenPromo public token;
152   
153   uint256 public currentTokenCount;
154   address public owner;
155   uint256 public maxTokenCount;
156 
157   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
158 
159   function ETokenAirdrop() public {
160     token = createTokenContract();
161     owner = msg.sender;
162   }
163   
164   function sendToken(address[] recipients) public {
165       token.mint(recipients);
166   }
167 
168   function createTokenContract() internal returns (ETokenPromo) {
169     return new ETokenPromo();
170   }
171 
172 }