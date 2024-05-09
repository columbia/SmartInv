1 // Поздравляем! Это ваш токен по бесплатной раздаче. Подробнее о проекте: https://echarge.io, таблица бонусов и даты ICO
2 // Мы планируем получать доход от установки и эксплуатации более 50 000 собственных зарядных станций для электромобилей по эксклюзивному контракту, в первую очередь в отелях, офисах и торговых центрах. Поддержка и система оплаты основаны на 
3 // технологии блокчейн, что позволяет владельцу автомобиля использовать свой автомобиль в качестве аккумулятора на колесах, чтобы покупать энергию по низкой цене, а продавать по высокой.
4 //
5 // 恭喜！这是你的免费空投代币。如需更详细了解本项目，请访问：https://echarge.io，奖金表格及 ICO 日期
6 // 我们将通过独家合同安装、拥有并运营超过 50,000 个 eCharge 电动车充电站，首先从 酒店、写字楼和商场开始，并从其使用中赚钱。其后端和支付系统是基于区块链，以允许车主 使用自己的汽车作为车轮上的电池，从而以低价购买能源并以高价出售能源。
7 //
8 // تهانينا! إليك نصيبك من العملات الرمزية المجانية الموزّعة. المزيد من المعلومات عن المشروع على الرابط: https://echarge.io، وجدول الزيادات وتواريخ الطرح الأولي للعملة
9 // سنقوم بتركيب وامتلاك وتشغيل ما يزيد عن 50000 محطة للشحن الكهربائي للسيارات الكهربائية بناءً على عقد حصري مع الفنادق والمكاتب ومراكز التسوق في البداية لجني المال اللازم من هذا الاستخدام. يستند نظام العمليات الخلفية ونظام الدفع إلى تقنية بلوك تشين للسماح لمالكي السيارات
10 // باستخدام سياراتهم كبطارية تسير على عجلات وشراء الطاقة بسعر منخفض وبيعها بسعر مرتفع.
11 //
12 // 축하합니다! 무료 에어드랍 쿠폰을 획득하셨습니다. 보너스 관련 내용, ICO날짜 등 더 많은 정보를 echarge.io에서 이용하실 수 있습니다.
13 // 저희는 호텔, 사무실, 쇼핑몰에 독점 계약을 맺고 전기차가 이용할 수 있는 eCharge 충전소 50,000개를 더 설치하고 소유, 운영할 계획이며, 이로써 수익을 창출할 것입니다. 백엔드와 결제 시스템은 블록체인을 바탕으로 운영되며, 차 소유주는 본 시스템을 이용하여 배터리 충전에 사용되는 에너지를 저렴한 
14 // 가격에 구입하고, 비싼 값으로 판매할 수 있습니다.
15 //
16 // Félicitations! Voici votre token airdrop gratuit. Pour en savoir plus sur le projet: https://echarge.io, Tableau des bonus et dates de l'ICO.
17 // Nous installerons, possèderons et gérerons plus de 50 000 bornes de recharge pour voitures électriques sur la base d'un contrat exclusif débutant en hôtels, bureaux et centres commerciaux pour générer des recettes grâce à l'usage de ces
18 // bornes. Le système logiciel et de paiement est basé sur la blockchain pour permettre au propriétaire de la voiture
19 // d'utiliser sa voiture comme une batterie pour acheter de l'énergie à bas prix et vendre de l'énergie à un prix élevé. 
20 //
21 // ¡Felicidades! Estos son sus tokens gratuitos recibidos por Airdrop. Para más información acerca del proyecto visite: https://echarge.io, Tabla de Bonos y Fechas de los ICO
22 // Adquiriremos, instalaremos y operaremos más de 50 000 estaciones de carga para coches eléctricos, firmaremos contratos exclusivos con hoteles, oficinas y centros comerciales, para así obtener ingresos por el consumo. 
23 // El sistema de soporte y pago está basado en la cadena de bloques, lo que permitirá a los dueños de coches eléctricos utilizar su vehículo como una batería sobre ruedas, con la cual podrán adquirir energía a precios módicos y venderla
24 // a precios altos. 
25                                                                                                               
26 pragma solidity 0.4.18;
27 
28 contract Ownable {
29     address public owner;
30 
31     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32 
33     modifier onlyOwner() { require(msg.sender == owner); _; }
34 
35     function Ownable() public {
36         owner = msg.sender;
37     }
38 
39     function transferOwnership(address newOwner) public onlyOwner {
40         require(newOwner != address(0));
41         owner = newOwner;
42         OwnershipTransferred(owner, newOwner);
43     }
44 }
45 
46 contract Withdrawable is Ownable {
47     function withdrawEther(address _to, uint _value) onlyOwner public returns(bool) {
48         require(_to != address(0));
49         require(this.balance >= _value);
50 
51         _to.transfer(_value);
52 
53         return true;
54     }
55 
56     function withdrawTokens(ERC20 _token, address _to, uint _value) onlyOwner public returns(bool) {
57         require(_to != address(0));
58 
59         return _token.transfer(_to, _value);
60     }
61 }
62 
63 contract ERC20 {
64     uint256 public totalSupply;
65 
66     event Transfer(address indexed from, address indexed to, uint256 value);
67     event Approval(address indexed owner, address indexed spender, uint256 value);
68 
69     function balanceOf(address who) public view returns(uint256);
70     function transfer(address to, uint256 value) public returns(bool);
71     function transferFrom(address from, address to, uint256 value) public returns(bool);
72     function allowance(address owner, address spender) public view returns(uint256);
73     function approve(address spender, uint256 value) public returns(bool);
74 }
75 
76 contract AirDrop is Withdrawable {
77     event TransferEther(address indexed to, uint256 value);
78 
79     function tokenBalanceOf(ERC20 _token) public view returns(uint256) {
80         return _token.balanceOf(this);
81     }
82 
83     function tokenAllowance(ERC20 _token, address spender) public view returns(uint256) {
84         return _token.allowance(this, spender);
85     }
86     
87     function tokenTransfer(ERC20 _token, uint _value, address[] _to) onlyOwner public {
88         require(_token != address(0));
89 
90         for(uint i = 0; i < _to.length; i++) {
91             require(_token.transfer(_to[i], _value));
92         }
93     }
94     
95     function tokenTransferFrom(ERC20 _token, address spender, uint _value, address[] _to) onlyOwner public {
96         require(_token != address(0));
97 
98         for(uint i = 0; i < _to.length; i++) {
99             require(_token.transferFrom(spender, _to[i], _value));
100         }
101     }
102 
103     function etherTransfer(uint _value, address[] _to) onlyOwner payable public {
104         for(uint i = 0; i < _to.length; i++) {
105             _to[i].transfer(_value);
106             TransferEther(_to[i], _value);
107         }
108     }
109 }