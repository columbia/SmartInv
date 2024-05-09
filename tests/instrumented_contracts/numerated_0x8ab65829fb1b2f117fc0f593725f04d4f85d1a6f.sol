1 pragma solidity 0.4.19;
2 
3 
4 contract InterfaceDeusETH {
5     bool public gameOver;
6     bool public gameOverByUser;
7     function getHolder(uint256 _id) public returns (address);
8     function changeHolder(uint256 _id, address _newholder) public returns (bool);
9 }
10 
11 
12 contract StockExchange {
13     bool public started = false;
14 
15     //7200 - 120 minutes
16     uint256 public stopTimeLength = 7200;
17     uint256 public stopTime = 0;
18 
19     //max token supply
20     uint256 public cap = 50;
21 
22     address public owner;
23 
24     // address of tokens
25     address public deusETH;
26 
27     mapping(uint256 => uint256) public priceList;
28     mapping(uint256 => address) public holderList;
29 
30     InterfaceDeusETH private lottery = InterfaceDeusETH(0x0);
31 
32     event TokenSale(uint256 indexed id, uint256 price);
33     event TokenBack(uint256 indexed id);
34     event TokenSold(uint256 indexed id, uint256 price);
35 
36     modifier onlyOwner() {
37         require(msg.sender == owner);
38         _;
39     }
40 
41     function StockExchange() public {
42         owner = msg.sender;
43     }
44 
45     function setLottery(address _lottery) public onlyOwner {
46         require(!started);
47         lottery = InterfaceDeusETH(_lottery);
48         deusETH = _lottery;
49         started = true;
50     }
51 
52     function sale(uint256 _id, uint256 _price) public returns (bool) {
53         require(started);
54         require(_id > 0 && _id <= cap);
55         require(!lottery.gameOver());
56         require(!lottery.gameOverByUser());
57         require(now > stopTime);
58         require(lottery.getHolder(_id) == msg.sender);
59 
60         priceList[_id] = _price;
61         holderList[_id] = msg.sender;
62 
63         assert(lottery.changeHolder(_id, this));
64         TokenSale(_id, _price);
65         return true;
66     }
67 
68     function getBackToken(uint256 _id) public returns (bool) {
69         require(started);
70         require(_id > 0 && _id <= cap);
71         require(!lottery.gameOver());
72         require(!lottery.gameOverByUser());
73         require(now > stopTime);
74         require(holderList[_id] == msg.sender);
75 
76         holderList[_id] = 0x0;
77         priceList[_id] = 0;
78         assert(lottery.changeHolder(_id, msg.sender));
79         TokenBack(_id);
80         return true;
81     }
82 
83     function buy(uint256 _id) public payable returns (bool) {
84         require(started);
85         require(_id > 0 && _id <= cap);
86         require(!lottery.gameOver());
87         require(!lottery.gameOverByUser());
88         require(now > stopTime);
89 
90         require(priceList[_id] == msg.value);
91         address oldHolder = holderList[_id];
92         holderList[_id] = 0x0;
93         priceList[_id] = 0;
94 
95         assert(lottery.changeHolder(_id, msg.sender));
96 
97         oldHolder.transfer(msg.value);
98         TokenSold(_id, msg.value);
99         return true;
100     }
101 
102     function pause() public onlyOwner {
103         stopTime = now + stopTimeLength;
104     }
105 
106     function getTokenPrice(uint _id) public view returns(uint256) {
107         return priceList[_id];
108     }
109 }