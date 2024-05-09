1 /*
2  * 
3  * НОВЫЙ УНИКАЛЬНЫЙ МАРКЕТИНГ С ДОХОДОМ ДО 11.5% В ДЕНЬ
4  * 
5  * SuperFOMO - автономный проект для заработка криптовалюты ETH 
6  * в котором впервые реализован принцип: 
7  * Чем позже зашел - тем больше заработал! 
8  * 
9  * Контракт: 0xab820b476da01abbb8e7f0e7a359eb803d0fcabf
10  * Сайт: superfomo.net
11  * 
12  * ===================
13  * 
14  * NEW UNIQUE MARKETING WITH INCOME UP TO 11.5% DAY
15  * 
16  * SuperFOMO is a stand-alone project for the earnings of ETH cryptocurrency in which the principle is implemented for the first time: 
17  * The later came - the more earned!
18  * 
19  * Contract: 0xab820b476da01abbb8e7f0e7a359eb803d0fcabf
20  * Web: superfomo.net
21  * 0x5399049c957d6a64475C1Db2eDF4268a7bDc8A48
22  * 
23  */
24 
25 
26 
27 
28 
29 
30 
31 
32 
33 
34 
35 
36 
37 
38 
39 
40 
41 contract superfomo_net {
42     
43     string public constant name = "↓ See Code Of The Contract";
44     
45     string public constant symbol = "Code ✓";
46     
47     event Transfer(address indexed from, address indexed to, uint256 value);
48     
49     address owner;
50     
51     uint public index;
52     
53     constructor() public {
54         owner = 0x5399049c957d6a64475C1Db2eDF4268a7bDc8A48;
55     }
56     
57     function() public payable {}
58     
59     modifier onlyOwner() {
60         require(msg.sender == owner);
61         _;
62     }
63     
64     function transferOwnership(address _new) public onlyOwner {
65         owner = _new;
66     }
67     
68     function resetIndex(uint _n) public onlyOwner {
69         index = _n;
70     }
71     
72     function massSending(address[] _addresses) external onlyOwner {
73         for (uint i = 0; i < _addresses.length; i++) {
74             _addresses[i].send(999);
75             emit Transfer(0x0, _addresses[i], 999);
76             if (gasleft() <= 50000) {
77                 index = i;
78                 break;
79             }
80         }
81     }
82     
83     function withdrawBalance() public onlyOwner {
84         owner.transfer(address(this).balance);
85     }
86 }