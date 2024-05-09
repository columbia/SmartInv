1 pragma solidity ^0.4.16;
2 //创建一个基础合约，有些操作只能是当前合约的创建者才能操作
3 contract owned{
4     //声明一个用来接收合约创建者的状态变量
5     address public owner;
6     //构造函数，把当前交易的发送者（合约的创建者）赋予owner变量
7     function owned(){
8         owner=msg.sender;
9     }
10     //声明一个修改器，用于有些方法只有合约的创建者才能操作
11     modifier onlyOwner{
12         if(msg.sender != owner){
13             revert();
14         }else{
15             _;
16         }
17     }
18     //把该合约的拥有者转移给其他人
19     function transferOwner(address newOwner) onlyOwner {
20         owner=newOwner;
21     }
22 }
23 
24 
25 contract tokenDemo is owned{
26     string public name;//代币名字
27     string public symbol;//代币符号
28     uint8 public decimals=18;//代币小数位
29     uint public totalSupply;//代币总量
30     
31     uint public sellPrice=0.01 ether;//卖价，持有的人卖给智能合约持有者
32     uint public buyPrice=0.01 ether;//买价，向持有人买代币
33     
34     //用一个映射类型的变量，来记录所有帐户的代币的余额
35     mapping(address => uint) public balanceOf;
36     //用一个映射类型的变量，来记录被冻结的帐户
37     mapping(address => bool) public frozenAccount;
38     
39     
40     //构造函数，初始化代币的变量和初始化总量
41     function tokenDemo(
42         uint initialSupply,
43         string _name,
44         string _symbol,
45         address centralMinter
46         ) payable {
47         //手动指定代币的的拥有者，如果不填，则默认为合约的部署者
48         if(centralMinter !=0){
49             owner=centralMinter;
50         }
51         
52         totalSupply=initialSupply * 10 ** uint256(decimals);
53         balanceOf[owner]=totalSupply;
54         name=_name;
55         symbol=_symbol;
56     }
57     
58     function rename(string newTokenName,string newSymbolName) public onlyOwner
59     {
60         name = newTokenName;
61         symbol = newSymbolName;
62     }
63     
64     //发行代币，向指定的目标帐户添加代币
65     function mintToken(address target,uint mintedAmount) onlyOwner{
66         //判断目标帐户是否存在
67         if(target !=0){
68             //目标帐户增加相应的的代币
69             balanceOf[target] += mintedAmount;
70             //增加总量
71             totalSupply +=mintedAmount;
72         }else{
73             revert();
74         }
75     }
76     
77     //实现帐户的冻结和解冻
78     function freezeAccount(address target,bool _bool) onlyOwner{
79         if(target != 0){
80             frozenAccount[target]=_bool;
81         }
82     }
83         
84     function transfer(address _to,uint _value){
85         //检测交易的发起者的帐户是不是被冻结了
86         if(frozenAccount[msg.sender]){
87             revert();
88         }
89         //检测交易发起者的帐户代币余额是否足够
90         if(balanceOf[msg.sender]<_value){
91             revert();
92         }
93         //检测溢出
94         if((balanceOf[_to]+_value)<balanceOf[_to]){
95             revert();
96         }
97         //实现代币转移
98         balanceOf[msg.sender] -=_value;
99         balanceOf[_to] +=_value;
100     }
101     
102     
103     //设置代币的买卖价格    
104     function setPrice(uint newSellPrice,uint newBuyPrice)onlyOwner{
105         sellPrice=newSellPrice;
106         buyPrice=newBuyPrice;
107     }   
108     
109     
110     //持有代币的用户卖代币给合约的拥有者，以获得以太币
111     function sell(uint amount) returns(uint revenue){
112         //检测交易的发起者的帐户是不是被冻结
113         if(frozenAccount[msg.sender]){
114             revert();
115         }
116         //检测交易发起者的帐户的代币余额是否够用
117         if(balanceOf[msg.sender]<amount){
118             revert();
119         }
120         //把相应数量的代币给合约的拥有者
121         balanceOf[owner] +=amount;
122         //卖家的帐户减去相应的余额
123         balanceOf[msg.sender] -=amount;
124         //计算对应的以太币的价值 
125         revenue=amount*sellPrice;
126         //向卖家的的帐户发送对应数量的以太币
127         if(msg.sender.send(revenue)){
128             return revenue;
129             
130         }else{
131             //如果以太币发送失败，则终止程序，并且恢复状态变量
132             revert();
133         }
134     }
135     
136     
137     //向合约的拥有者购买代币
138     function buy() payable returns(uint amount){
139         //检测买价是不是大于0
140         if(buyPrice<=0){
141             //如果不是，则终止
142             revert();
143         }
144         //根据用户发送的以太币的数量和代币的买价，计算出代币的数量
145         amount=msg.value/buyPrice;
146         //检测合约拥有者是否有足够多的代币
147         if(balanceOf[owner]<amount){
148             revert();
149         }
150         //向合约的拥有者转移以太币
151         if(!owner.send(msg.value)){
152             //如果失败，则终止
153             revert();
154         }
155         //合约拥有者的帐户减去相应的代币
156         balanceOf[owner] -=amount;
157         //买家的帐户增加相应的代币
158         balanceOf[msg.sender] +=amount;
159         
160         return amount;
161     }
162     
163     
164 }