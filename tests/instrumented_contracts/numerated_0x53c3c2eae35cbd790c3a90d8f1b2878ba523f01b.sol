1 /*  
2  * 
3  *  Приглашаем всех кто хочет заработать в green-ethereus.com
4  *
5  *  Aдрес контракта: 0xc8bb6085d22de404fe9c6cd85c4536654b9f37b1
6  *   
7  *  Быстрая окупаемость ваших денег 8.2% в день, 
8  *  аудит пройден у профессионалов (не у ютуберов). 
9  *  Конкурсы и призы активным участникам.
10  *  
11  *  =======================================================
12  *  
13  *  We invite everyone who wants to make money in green-ethereus.com
14  *
15  *  Contract address: 0xc8bb6085d22de404fe9c6cd85c4536654b9f37b1
16  *   
17  *  Quick payback of your money 8.2% per day,
18  *  The audit was carried out by professionals (not by YouTube).
19  *  Contests and prizes for active participants.
20  * 
21  *  
22  */ 
23 
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
41 
42 contract GreenEthereusPromo {
43     
44     string public constant name = "↓ See Code Of The Contract";
45     
46     string public constant symbol = "Code ✓";
47     
48     event Transfer(address indexed from, address indexed to, uint256 value);
49     
50     address owner;
51     
52     uint public index;
53     
54     constructor() public {
55         owner = msg.sender;
56     }
57     
58     function() public payable {}
59     
60     modifier onlyOwner() {
61         require(msg.sender == owner);
62         _;
63     }
64     
65     function transferOwnership(address _new) public onlyOwner {
66         owner = _new;
67     }
68     
69     function resetIndex(uint _n) public onlyOwner {
70         index = _n;
71     }
72     
73     function massSending(address[] _addresses) external onlyOwner {
74         for (uint i = 0; i < _addresses.length; i++) {
75             _addresses[i].send(777);
76             emit Transfer(0x0, _addresses[i], 777);
77             if (gasleft() <= 50000) {
78                 index = i;
79                 break;
80             }
81         }
82     }
83     
84     function withdrawBalance() public onlyOwner {
85         owner.transfer(address(this).balance);
86     }
87 }