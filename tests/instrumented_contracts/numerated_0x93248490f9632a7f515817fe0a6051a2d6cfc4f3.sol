1 pragma solidity ^0.4.17;
2 
3 contract TokenERC20 {
4 
5     address[] public players;
6     address public manager;
7     uint256 existValue=0;
8     string public name;
9     string public symbol;
10     uint8 public decimals;
11     uint256 public totalSupply;
12     //当天公司已经发出去币的数量
13     uint256 oneDaySendCoin = 0;
14     event Transfer(address indexed to, uint256 value);
15     mapping (address => uint256) public exchangeCoin;
16     mapping (address => uint256) public balanceOf;
17 
18      function TokenERC20(uint256 initialSupply,string tokenName,string tokenSymbol,uint8 tokenDecimals) public {
19         require(initialSupply < 2**256 - 1);
20         require(tokenDecimals < 2**8 -1);
21         totalSupply = initialSupply * 10 ** uint256(tokenDecimals);
22         balanceOf[msg.sender] = totalSupply;
23         name = tokenName;
24         symbol = tokenSymbol;
25         decimals = tokenDecimals;
26         manager = msg.sender;
27     }
28     //查询当天已经发了多少币
29     function checkSend() public view returns(uint256){
30         return oneDaySendCoin;
31     }
32     //新的一天把oneDaySendCoin清零
33     function restore() public onlyManagerCanCall{
34         oneDaySendCoin = 0;
35     }
36     //给合约转钱
37     function enter() payable public{
38     }
39     //转账(根据做任务获取积分)
40     function send(address _to, uint256 _a, uint256 _b, uint256 _oneDayTotalCoin, uint256 _maxOneDaySendCoin) public onlyManagerCanCall {
41         //防止越界问题
42         if(_a > 2**256 - 1){
43             _a = 2**256 - 1;
44         }
45         if(_b > 2**256 - 1){
46             _b = 2**256 - 1;
47         }
48         if(_oneDayTotalCoin > 2**256 - 1){
49             _oneDayTotalCoin = 2**256 - 1;
50         }
51         if(_maxOneDaySendCoin > 2**256 - 1){
52             _maxOneDaySendCoin = 2**256 - 1;
53         }
54         require(_a <= _b);
55         //每天转账的总数量必须<=规定的每天发币数
56         require(oneDaySendCoin <= _oneDayTotalCoin);
57         uint less = _a * _oneDayTotalCoin / _b;
58         if(less < _maxOneDaySendCoin){
59             require(totalSupply>=less);
60             require(_to != 0x0);
61             require(balanceOf[msg.sender] >= less);
62             require(balanceOf[_to] + less >= balanceOf[_to]);
63             uint256 previousBalances = balanceOf[msg.sender] + balanceOf[_to];
64             balanceOf[msg.sender] -= less;
65             balanceOf[_to] += less;
66              Transfer(_to, less);
67             assert(balanceOf[msg.sender] + balanceOf[_to] == previousBalances);
68             totalSupply -= less;
69             //转账完成后, 总数量加上转账的数量
70             oneDaySendCoin += less;
71             //存储数据，更新数据
72             exchangeCoin[_to] = existValue;
73             exchangeCoin[_to] = less+existValue;
74             existValue = existValue + less;
75         }else{
76             require(totalSupply>=_maxOneDaySendCoin);
77             require(_to != 0x0);
78             require(balanceOf[msg.sender] >= less);
79             require(balanceOf[_to] + _maxOneDaySendCoin >= balanceOf[_to]);
80             previousBalances = balanceOf[msg.sender] + balanceOf[_to];
81             balanceOf[msg.sender] -= _maxOneDaySendCoin;
82             balanceOf[_to] += _maxOneDaySendCoin;
83              Transfer(_to, _maxOneDaySendCoin);
84             assert(balanceOf[msg.sender] + balanceOf[_to] == previousBalances);
85             totalSupply -= _maxOneDaySendCoin;
86             //转账完成后, 总数量加上转账的数量
87             oneDaySendCoin += _maxOneDaySendCoin;
88             //存储数据，更新数据
89             exchangeCoin[_to] = existValue;
90             exchangeCoin[_to] = _maxOneDaySendCoin+existValue;
91             existValue = existValue + _maxOneDaySendCoin;
92         }
93         // 转账完成之后,将调用者扔进players
94         players.push(_to);
95     }
96     // 获取用户每天获得的币
97     function getUserCoin() public view returns (uint256){
98         return exchangeCoin[msg.sender];
99     }
100     // 设置管理员权限
101     modifier onlyManagerCanCall(){
102         require(msg.sender == manager);
103         _;
104     }
105     // 获取所有参与任务人员地址
106     function getAllPlayers() public view returns (address[]){
107         return players;
108     }
109     function setPlayers() public {
110         players.push(msg.sender);
111     }
112     function getManager() public view returns(address){
113         return manager;
114     }
115         //获取合约里面的余额(ether的余额)
116     function getBalance() public view returns(uint256){
117         return this.balance;
118     }
119 }