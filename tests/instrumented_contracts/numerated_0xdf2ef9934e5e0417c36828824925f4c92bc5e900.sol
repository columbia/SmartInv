1 pragma solidity ^0.4.25;
2 //ERC20标准,一种以太坊代币的标准
3 contract ERC20Interface {
4   string public name;           //返回string类型的ERC20代币的名字
5   string public symbol;         //返回string类型的ERC20代币的符号，也就是代币的简称，例如：SNT。
6   uint8 public  decimals;       //支持几位小数点后几位。如果设置为3。也就是支持0.001表示
7   uint public totalSupply;      //发行代币的总量  
8   //调用transfer函数将自己的token转账给_to地址，_value为转账个数
9   function transfer(address _to, uint256 _value) returns (bool success);
10   //与下面approve函数搭配使用，approve批准之后，调用transferFrom函数来转移token。
11   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
12   //批准_spender账户从自己的账户转移_value个token。可以分多次转移。
13   function approve(address _spender, uint256 _value) returns (bool success);
14   //返回_spender还能提取token的个数。
15   function allowance(address _owner, address _spender) view returns (uint256 remaining);
16   event Transfer(address indexed _from, address indexed _to, uint256 _value);
17   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
18 }
19 contract ERC20 is ERC20Interface{
20     mapping(address => uint256) public balanceOf;//余额 
21     mapping(address =>mapping(address => uint256)) allowed;
22     constructor(string _name,string _symbol,uint8 _decimals,uint _totalSupply) public{
23          name = _name;                          //返回string类型的ERC20代币的名字
24          symbol = _symbol;                      //返回string类型的ERC20代币的符号，也就是代币的简称，例如：SNT。
25          decimals = _decimals;                   //支持几位小数点后几位。如果设置为3。也就是支持0.001表示
26          totalSupply = _totalSupply * 10 ** uint256(decimals);            //发行代币的总量  
27          balanceOf[msg.sender]=_totalSupply;
28     }
29    //调用transfer函数将自己的token转账给_to地址，_value为转账个数
30   function transfer(address _to, uint256 _value) public returns (bool success){
31       require(_to!=address(0));//检测目标帐号不等于空帐号 
32       require(balanceOf[msg.sender] >= _value);
33       require(balanceOf[_to] + _value >=balanceOf[_to]);
34       balanceOf[msg.sender]-=_value;
35       balanceOf[_to]+=_value;
36       emit Transfer(msg.sender,_to,_value);//触发事件
37       return true;
38   }
39   //与下面approve函数搭配使用，approve批准之后，调用transferFrom函数来转移token。
40   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
41       require(_to!=address(0));
42       require(balanceOf[_from]>=_value);
43       require(balanceOf[_to]+_value>balanceOf[_to]);
44       require(allowed[_from][msg.sender]>_value);
45       balanceOf[_from]-=_value;
46       balanceOf[_to]+=_value;
47       allowed[_from][msg.sender]-=_value;
48       emit Transfer(_from,_to,_value);
49       return true;
50   }
51   //批准_spender账户从自己的账户转移_value个token。可以分多次转移。
52   function approve(address _spender, uint256 _value) public returns (bool success){
53       allowed[msg.sender][_spender] = _value;
54       emit Approval(msg.sender,_spender,_value);
55       return true;
56   }
57   //返回_spender还能提取token的个数。
58   function allowance(address _owner, address _spender) public view returns (uint256 remaining){
59       return allowed[_owner][_spender];
60   }
61   event Transfer(address indexed _from, address indexed _to, uint256 _value);
62   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
63 }
64 //实现一个代币的管理者
65 contract owned{
66     address public owner;
67     constructor() public{
68         owner=msg.sender;
69     }
70     modifier onlyOwner{
71         require(msg.sender==owner);
72         _;
73     }
74     function transferOwnerShip(address newOwner) public onlyOwner{
75         owner=newOwner;
76     }
77 }
78 //高级代币继承自前两个合约
79 contract CAR is ERC20,owned {
80     mapping(address => bool) public frozenAccount;//声明冻结或者解冻的帐号 
81     event AddSupply(uint256 amount);//声明增发事件 
82     event FrozenFunds(address target,bool freeze);//声明冻结或者解冻事件
83     event Burn(address account,uint256 values);
84     /**"Test FQ","TFQC",18,1000 */
85     constructor(string _name,string _symbol,uint8 _decimals,uint _totalSupply) ERC20 ( _name,_symbol, _decimals,_totalSupply) public{
86     }
87     //代币增发函数 
88     function mine(address target,uint256 amount) public onlyOwner{
89         totalSupply+=amount;
90         balanceOf[target]+=amount;
91         emit AddSupply(amount);//触发事件
92         emit Transfer(0,target,amount);
93     }
94     //冻结函数
95     function freezeAccount(address target,bool freeze) public onlyOwner{
96         frozenAccount[target]=freeze;
97         emit FrozenFunds(target,freeze);
98     }
99        //调用transfer函数将自己的token转账给_to地址，_value为转账个数
100   function transfer(address _to, uint256 _value) public returns (bool success){
101       require(!frozenAccount[msg.sender]);//判断账户是否冻结 
102       require(_to!=address(0));//检测目标帐号不等于空帐号 
103       require(balanceOf[msg.sender] >= _value);
104       require(balanceOf[_to] + _value >=balanceOf[_to]);
105       balanceOf[msg.sender]-=_value;
106       balanceOf[_to]+=_value;
107       emit Transfer(msg.sender,_to,_value);//触发事件
108       return true;
109   }
110   //调用transferFrom函数来转移token。
111   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
112       require(!frozenAccount[msg.sender]);//判断账户是否冻结 
113       require(_to!=address(0));
114       require(balanceOf[_from]>=_value);
115       require(balanceOf[_to]+_value>balanceOf[_to]);
116       require(allowed[_from][msg.sender]>_value);
117       balanceOf[_from]-=_value;
118       balanceOf[_to]+=_value;
119       allowed[_from][msg.sender]-=_value;
120       emit Transfer(_from,_to,_value);
121       return true;
122   }
123   //销毁函数 
124   function burn(uint256 values) public returns(bool success){
125       require(balanceOf[msg.sender]>=values);
126       totalSupply-=values;
127       balanceOf[msg.sender]-=values;
128       emit Burn(msg.sender,values);
129       return true;
130   }
131 }