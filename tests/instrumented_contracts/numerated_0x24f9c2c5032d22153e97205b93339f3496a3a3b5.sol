1 pragma solidity ^0.4.18;
2 
3 contract Redeem {
4 
5   struct Item {
6     address owner;
7     uint price;
8     uint nextPrice;
9     string slogan;
10   }
11 
12   address admin;
13   uint[] cuts = [50,40,30,30,20];
14   uint[] priceUps = [2105,1406,1288,1206,1173];
15   uint[] priceMilestones = [20,500,2000,5000];
16   uint[] startPrice = [7,7,7,13,13,13,13,13,17,17];
17   bool running = true;
18 
19   mapping (uint => Item) items;
20   uint[] itemIndices;
21   function soldItems() view public returns (uint[]) { return itemIndices; }
22 
23   event OnSold(uint indexed _iItem, address indexed _oldOwner, address indexed _newOwner, uint _oldPrice, uint _newPrice, string _newSlogan);
24   
25   modifier onlyAdmin() {
26     require(msg.sender == admin);
27     _;
28   }
29   modifier enabled() {
30     require(running);
31     _;
32   }
33 
34   function Redeem() public {
35     admin = msg.sender;
36   }
37 
38   function itemAt(uint _idx) view public returns (uint iItem, address owner, uint price, uint nextPrice, string slogan) {
39     Item memory item = items[_idx];
40     if (item.price > 0) {
41       return (_idx, item.owner, item.price, item.nextPrice, item.slogan);
42     } else {
43       uint p = startPrice[_idx % startPrice.length];
44       return (_idx, item.owner, p, nextPriceOf(p), "");
45     }
46   }
47 
48   function buy(uint _idx, string _slogan) enabled payable public {
49     Item storage item = items[_idx];
50     if (item.price == 0) {
51       item.price = startPrice[_idx % startPrice.length];
52       item.nextPrice = nextPriceOf(item.price);
53       itemIndices.push(_idx);
54     }
55     require(item.price > 0);
56     uint curWei = item.price * 1e15;
57     require(curWei <= msg.value);
58     address oldOwner = item.owner;
59     uint oldPrice = item.price;
60     if (item.owner != 0x0) {
61       require(item.owner != msg.sender);
62       item.owner.transfer(curWei * (1000 - cutOf(item.price)) / 1000);
63     }
64     msg.sender.transfer(msg.value - curWei);
65     item.owner = msg.sender;
66     item.slogan = _slogan;
67     item.price = item.nextPrice;
68     item.nextPrice = nextPriceOf(item.price);
69     OnSold(_idx, oldOwner, item.owner, oldPrice, item.price, item.slogan);
70   }
71 
72   function nextPriceOf(uint _price) view internal returns (uint) {
73     for (uint i = 0; i<priceUps.length; ++i) {
74       if (i >= priceMilestones.length || _price < priceMilestones[i])
75         return _price * priceUps[i] / 1000;
76     }
77     require(false); //should not happen
78     return 0;
79   }
80   
81   function cutOf(uint _price) view internal returns (uint) {
82     for (uint i = 0; i<cuts.length; ++i) {
83       if (i >= priceMilestones.length || _price < priceMilestones[i])
84         return cuts[i];
85     }
86     require(false); //should not happen
87     return 0;
88   }
89   
90   function contractInfo() view public returns (bool, address, uint256, uint[], uint[], uint[], uint[]) {
91     return (running, admin, this.balance, startPrice, priceMilestones, cuts, priceUps);
92   }
93 
94   function enable(bool b) onlyAdmin public {
95     running = b;
96   }
97 
98   function changeParameters(uint[] _startPrice, uint[] _priceMilestones, uint[] _priceUps, uint[] _cuts) onlyAdmin public {
99     require(_startPrice.length > 0);
100     require(_priceUps.length == _priceMilestones.length + 1);
101     require(_priceUps.length == _cuts.length);
102     for (uint i = 0; i<_priceUps.length; ++i) {
103       require(_cuts[i] <= 1000);
104       require(_priceUps[i] > 1000 + _cuts[i]);
105       if (i < _priceMilestones.length-1) {
106         require(_priceMilestones[i] < _priceMilestones[i+1]);
107       }
108     }
109     startPrice = _startPrice;
110     priceMilestones = _priceMilestones;
111     priceUps = _priceUps;
112     cuts = _cuts;
113   }
114 
115   function withdrawAll() onlyAdmin public { msg.sender.transfer(this.balance); }
116   function withdraw(uint _amount) onlyAdmin public { msg.sender.transfer(_amount); }
117   function changeAdmin(address _newAdmin) onlyAdmin public { admin = _newAdmin; }
118 }