1 pragma solidity ^0.4.21;
2 
3 contract KKToken {
4   
5   //地址 -> 余额 的映射
6   mapping (address => uint256) balances;
7   //地址 -> 允许代币转移的地址及数量 的映射
8   mapping (address => mapping (address => uint256)) allowed;
9   
10   //这4个状态变量会自动创建对应public函数
11   string public name = " Kunkun Token";
12   string public symbol = "KKT";
13   uint8 public decimals = 18;  //建议的默认值
14   uint256 public totalSupply;
15 
16   uint256 public initialSupply = 100000000;
17 
18   //如果ETH被发送到这个合约，会被发送回去
19   function (){
20     throw;
21   }
22 
23   //构造函数，只在合约创建时执行一次
24   function KKToken(){
25     //实际总供应量 = 代币数量*10^精度
26     totalSupply = initialSupply * (10 ** uint256(decimals));
27     //把所有代币分配给合约创建者
28     balances[msg.sender] = totalSupply;
29   }
30 
31   //查询某账户（_owner）的余额
32   function balanceOf(address _owner) view returns (uint256 balance){
33     return balances[_owner];
34   }
35 
36   //向某个地址（_to）发送（_value）个代币
37   //发送者调用
38   function transfer(address _to, uint256 _value) returns (bool success){
39     //检查发送者是否有足够的代币
40     if (balances[msg.sender] >= _value && _value > 0) {
41       balances[msg.sender] -= _value;
42       balances[_to] += _value;
43       Transfer(msg.sender, _to, _value);
44       return true;
45     } else { 
46       return false; 
47     }
48   }
49 
50   //从某个地址（_from）向某个地址（_to）发送（_value）个代币
51   //接收者调用
52   function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
53     //检查发送者是否有足够的代币
54     //检查接收者是否发送者的允许发送范围内，且发送数量也在对应的允许范围内
55     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
56       balances[_to] += _value;
57       balances[_from] -= _value;
58       allowed[_from][msg.sender] -= _value;
59       Transfer(_from, _to, _value);
60       return true;
61     } else { 
62       return false; 
63     }
64   }
65 
66   //允许某个地址（_spender）从你的账户转移（_value）个代币
67   function approve(address _spender, uint256 _value) returns (bool success){
68     allowed[msg.sender][_spender] = _value;
69     Approval(msg.sender, _spender, _value);
70     return true;
71   }
72 
73   //获取（_owner）允许某个地址（_spender）还可以转移多少代币
74   function allowance(address _owner, address _spender) view returns (uint256 remaining){
75     return allowed[_owner][_spender];
76   }
77 
78   //transfer 被调用时的通知事件
79   event Transfer(address indexed _from, address indexed _to, uint256 _value);
80 
81   //approve 被调用时的通知事件
82   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
83   
84 }