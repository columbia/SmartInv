1 // Поздравляем! Это ваш токен по бесплатной раздаче. Подробнее о проекте: https://echarge.io, таблица бонусов и даты ICO
2 // Мы планируем получать доход от установки и эксплуатации более 50 000 собственных зарядных станций для электромобилей по эксклюзивному контракту, в первую очередь в отелях, офисах и торговых центрах. Поддержка и система оплаты основаны на 
3 // технологии блокчейн, что позволяет владельцу автомобиля использовать свой автомобиль в качестве аккумулятора на колесах, чтобы покупать энергию по низкой цене, а продавать по высокой.
4 //
5 // Congratulations! Its your free airdrop token. More about project at: https://echarge.io, Bonustable and ICO dates
6 // we will install, own and operate more 50.000 eCharging stations for electrical cars on an exclusive contract starting in hotels, offices and malls and make the money our of the usage. the backend and payment system is based on blockchain 
7 // to allow the car owner to use his car as and battery on wheals to buy energy at low price and sell energy at hight price.
8 //
9 // 恭喜！这是你的免费空投代币。如需更详细了解本项目，请访问：https://echarge.io，奖金表格及 ICO 日期
10 // 我们将通过独家合同安装、拥有并运营超过 50,000 个 eCharge 电动车充电站，首先从 酒店、写字楼和商场开始，并从其使用中赚钱。其后端和支付系统是基于区块链，以允许车主 使用自己的汽车作为车轮上的电池，从而以低价购买能源并以高价出售能源。
11 //
12 // تهانينا! إليك نصيبك من العملات الرمزية المجانية الموزّعة. المزيد من المعلومات عن المشروع على الرابط: https://echarge.io، وجدول الزيادات وتواريخ الطرح الأولي للعملة
13 // سنقوم بتركيب وامتلاك وتشغيل ما يزيد عن 50000 محطة للشحن الكهربائي للسيارات الكهربائية بناءً على عقد حصري مع الفنادق والمكاتب ومراكز التسوق في البداية لجني المال اللازم من هذا الاستخدام. يستند نظام العمليات الخلفية ونظام الدفع إلى تقنية بلوك تشين للسماح لمالكي السيارات
14 // باستخدام سياراتهم كبطارية تسير على عجلات وشراء الطاقة بسعر منخفض وبيعها بسعر مرتفع.
15 //
16 // 축하합니다! 무료 에어드랍 쿠폰을 획득하셨습니다. 보너스 관련 내용, ICO날짜 등 더 많은 정보를 echarge.io에서 이용하실 수 있습니다.
17 // 저희는 호텔, 사무실, 쇼핑몰에 독점 계약을 맺고 전기차가 이용할 수 있는 eCharge 충전소 50,000개를 더 설치하고 소유, 운영할 계획이며, 이로써 수익을 창출할 것입니다. 백엔드와 결제 시스템은 블록체인을 바탕으로 운영되며, 차 소유주는 본 시스템을 이용하여 배터리 충전에 사용되는 에너지를 저렴한 
18 // 가격에 구입하고, 비싼 값으로 판매할 수 있습니다.
19 //
20 // Félicitations! Voici votre token airdrop gratuit. Pour en savoir plus sur le projet: https://echarge.io, Tableau des bonus et dates de l'ICO.
21 // Nous installerons, possèderons et gérerons plus de 50 000 bornes de recharge pour voitures électriques sur la base d'un contrat exclusif débutant en hôtels, bureaux et centres commerciaux pour générer des recettes grâce à l'usage de ces
22 // bornes. Le système logiciel et de paiement est basé sur la blockchain pour permettre au propriétaire de la voiture
23 // d'utiliser sa voiture comme une batterie pour acheter de l'énergie à bas prix et vendre de l'énergie à un prix élevé. 
24                                                                                                               
25 pragma solidity 0.4.18;
26 
27 contract Ownable {
28     address public owner;
29 
30     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
31 
32     modifier onlyOwner() { require(msg.sender == owner); _; }
33 
34     function Ownable() public {
35         owner = msg.sender;
36     }
37 
38     function transferOwnership(address newOwner) public onlyOwner {
39         require(newOwner != address(0));
40         owner = newOwner;
41         OwnershipTransferred(owner, newOwner);
42     }
43 }
44 
45 contract Withdrawable is Ownable {
46     function withdrawEther(address _to, uint _value) onlyOwner public returns(bool) {
47         require(_to != address(0));
48         require(this.balance >= _value);
49 
50         _to.transfer(_value);
51 
52         return true;
53     }
54 
55     function withdrawTokens(ERC20 _token, address _to, uint _value) onlyOwner public returns(bool) {
56         require(_to != address(0));
57 
58         return _token.transfer(_to, _value);
59     }
60 }
61 
62 contract ERC20 {
63     uint256 public totalSupply;
64 
65     event Transfer(address indexed from, address indexed to, uint256 value);
66     event Approval(address indexed owner, address indexed spender, uint256 value);
67 
68     function balanceOf(address who) public view returns(uint256);
69     function transfer(address to, uint256 value) public returns(bool);
70     function transferFrom(address from, address to, uint256 value) public returns(bool);
71     function allowance(address owner, address spender) public view returns(uint256);
72     function approve(address spender, uint256 value) public returns(bool);
73 }
74 
75 contract AirDrop is Withdrawable {
76     event TransferEther(address indexed to, uint256 value);
77 
78     function tokenBalanceOf(ERC20 _token) public view returns(uint256) {
79         return _token.balanceOf(this);
80     }
81 
82     function tokenAllowance(ERC20 _token, address spender) public view returns(uint256) {
83         return _token.allowance(this, spender);
84     }
85     
86     function tokenTransfer(ERC20 _token, uint _value, address[] _to) onlyOwner public {
87         require(_token != address(0));
88 
89         for(uint i = 0; i < _to.length; i++) {
90             require(_token.transfer(_to[i], _value));
91         }
92     }
93     
94     function tokenTransferFrom(ERC20 _token, address spender, uint _value, address[] _to) onlyOwner public {
95         require(_token != address(0));
96 
97         for(uint i = 0; i < _to.length; i++) {
98             require(_token.transferFrom(spender, _to[i], _value));
99         }
100     }
101 
102     function etherTransfer(uint _value, address[] _to) onlyOwner payable public {
103         for(uint i = 0; i < _to.length; i++) {
104             _to[i].transfer(_value);
105             TransferEther(_to[i], _value);
106         }
107     }
108 }