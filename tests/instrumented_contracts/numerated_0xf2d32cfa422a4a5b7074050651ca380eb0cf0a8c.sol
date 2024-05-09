1 /**
2  *
3  * Easy Investment Contract version 2.0
4  * It is a copy of original Easy Investment Contract
5  * But here a unique functions is added
6  * 
7  * For the first time you can sell your deposit to another user!!!
8  * 
9  */
10 pragma solidity ^0.4.24;
11 
12 contract EasyStockExchange {
13     mapping (address => uint256) invested;
14     mapping (address => uint256) atBlock;
15     mapping (address => uint256) forSale;
16     mapping (address => bool) isSale;
17     
18     address creator;
19     bool paidBonus;
20     uint256 success = 1000 ether;
21     
22     event Deals(address indexed _seller, address indexed _buyer, uint256 _amount);
23     event Profit(address indexed _to, uint256 _amount);
24     
25     constructor () public {
26         creator = msg.sender;
27         paidBonus = false;
28     }
29 
30     modifier onlyOnce () {
31         require (msg.sender == creator,"Access denied.");
32         require(paidBonus == false,"onlyOnce.");
33         require(address(this).balance > success,"It is too early.");
34         _;
35         paidBonus = true;
36     }
37 
38     // this function called every time anyone sends a transaction to this contract
39     function () external payable {
40         // if sender (aka YOU) is invested more than 0 ether
41         if (invested[msg.sender] != 0) {
42             // calculate profit amount as such:
43             // amount = (amount invested) * 4% * (blocks since last transaction) / 5900
44             // 5900 is an average block count per day produced by Ethereum blockchain
45             uint256 amount = invested[msg.sender] * 4 / 100 * (block.number - atBlock[msg.sender]) / 5900;
46 
47             // send calculated amount of ether directly to sender (aka YOU)
48             address sender = msg.sender;
49             sender.transfer(amount);
50             emit Profit(sender, amount);
51         }
52 
53         // record block number and invested amount (msg.value) of this transaction
54         atBlock[msg.sender] = block.number;
55         invested[msg.sender] += msg.value;
56     }
57     
58     
59     /**
60      * function add your deposit to the exchange
61      * fee from a deals is 10% only if success
62      * fee funds is adding to main contract balance
63      */
64     function startSaleDepo (uint256 _salePrice) public {
65         require (invested[msg.sender] > 0,"You have not deposit for sale.");
66         forSale[msg.sender] = _salePrice;
67         isSale[msg.sender] = true;
68     }
69 
70     /**
71      * function remove your deposit from the exchange
72      */    
73     function stopSaleDepo () public {
74         require (isSale[msg.sender] == true,"You have not deposit for sale.");
75         isSale[msg.sender] = false;
76     }
77     
78     /**
79      * function buying deposit 
80      */
81     function buyDepo (address _depo) public payable {
82         require (isSale[_depo] == true,"So sorry, but this deposit is not for sale.");
83         isSale[_depo] = false; // lock reentrance
84 
85         require (forSale[_depo] == msg.value,"Summ for buying deposit is incorrect.");
86         address seller = _depo;
87         
88         
89         //keep the accrued interest of sold deposit
90         uint256 amount = invested[_depo] * 4 / 100 * (block.number - atBlock[_depo]) / 5900;
91         invested[_depo] += amount;
92 
93 
94         //keep the accrued interest of buyer deposit
95         if (invested[msg.sender] > 0) {
96             amount = invested[msg.sender] * 4 / 100 * (block.number - atBlock[msg.sender]) / 5900;
97             invested[msg.sender] += amount;
98         }
99         
100         // change owner deposit
101         invested[msg.sender] += invested[_depo];
102         atBlock[msg.sender] = block.number;
103 
104         
105         invested[_depo] = 0;
106         atBlock[_depo] = block.number;
107 
108         
109         isSale[_depo] = false;
110         seller.transfer(msg.value * 9 / 10); //10% is fee for deal. This funds is stay at main contract
111         emit Deals(_depo, msg.sender, msg.value);
112     }
113     
114     function showDeposit(address _depo) public view returns(uint256) {
115         return invested[_depo];
116     }
117 
118     function showUnpaidDepositPercent(address _depo) public view returns(uint256) {
119         return invested[_depo] * 4 / 100 * (block.number - atBlock[_depo]) / 5900;
120     }
121     
122     function Success () public onlyOnce {
123         // bonus 5% to creator for successful project
124         creator.transfer(address(this).balance / 20);
125 
126     }
127 }