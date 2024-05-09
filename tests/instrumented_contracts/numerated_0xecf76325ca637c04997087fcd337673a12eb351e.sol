1 pragma solidity ^0.4.24;
2 
3 contract ERC20 {
4     uint public totalSupply;
5     function balanceOf(address who) public constant returns (uint);
6 
7     function allowance(address owner, address spender) public constant returns (uint);
8 
9     function transfer(address to, uint value) public returns (bool ok);
10 
11     function transferFrom(address from, address to, uint value) public returns (bool ok);
12 
13     function approve(address spender, uint value) public returns (bool ok);
14 
15     function mintToken(address to, uint256 value) public returns (uint256);
16 
17     function changeTransfer(bool allowed) public;
18 }
19 
20 contract SaleCandle {
21     address public creator;
22 
23     uint256 private totalMinted;
24 
25     ERC20 public Candle;
26     uint256 public candleCost;
27 
28     uint256 public minCost;
29     uint256 public maxCost;
30 
31     address public FOG;//25%
32     address public SUN;//25%
33     address public GOD;//40%
34     address public APP;//10%
35 
36     event Contribution(address from, uint256 amount);
37 
38     constructor() public {
39         creator = msg.sender;
40         totalMinted = 0;
41     }
42 
43     function changeCreator(address _creator) external {
44         require(msg.sender == creator);
45         creator = _creator;
46     }
47 
48     function changeParams(address _candle, uint256 _candleCost, address _fog, address _sun, address _god, address _app) external {
49         require(msg.sender == creator);
50 
51         Candle = ERC20(_candle);
52         candleCost = _candleCost;
53 
54         minCost=fromPercentage(_candleCost, 97);
55         maxCost=fromPercentage(_candleCost, 103);
56 
57         FOG = _fog;
58         SUN = _sun;
59         GOD = _god;
60         APP = _app;
61     }
62 
63     function getTotalMinted() public constant returns (uint256) {
64         require(msg.sender == creator);
65         return totalMinted;
66     }
67 
68     function() public payable {
69         require(msg.value > 0);
70         require(msg.value >= minCost);
71 
72         uint256 forProcess = 0;
73         uint256 forReturn = 0;
74         if(msg.value>maxCost){
75             forProcess = maxCost;
76             forReturn = msg.value - maxCost;
77         }else{
78             forProcess = msg.value;
79         }
80 
81         totalMinted += 1;
82 
83         uint256 forFog = fromPercentage(forProcess, 25);
84         uint256 forSun = fromPercentage(forProcess, 25);
85         uint256 forGod = fromPercentage(forProcess, 40);
86         uint256 forApp = forProcess - (forFog+forSun+forGod);
87 
88         APP.transfer(forApp);
89         GOD.transfer(forGod);
90         SUN.transfer(forSun);
91         FOG.transfer(forFog);
92 
93         if(forReturn>0){
94             msg.sender.transfer(forReturn);
95         }
96 
97         Candle.mintToken(msg.sender, 1);
98         emit Contribution(msg.sender, 1);
99     }
100 
101     function fromPercentage(uint256 value, uint256 percentage) internal returns (uint256) {
102         return (value * percentage) / 100;
103     }
104 }