1 pragma solidity ^0.5.1;
2 
3 contract CareerOnToken {
4     event Transfer(address indexed _from, address indexed _to, uint256 _value);
5     event Approval(address indexed a_owner, address indexed _spender, uint256 _value);
6     event OwnerChange(address indexed _old,address indexed _new,uint256 _coin_change);
7     
8     uint256 public totalSupply;  
9     string public name;                   //名称，例如"My test token"
10     uint8 public decimals;               //返回token使用的小数点后几位。比如如果设置为3，就是支持0.001表示.
11     string public symbol;               //token简称,like MTT
12     address public owner;
13     
14     mapping (address => uint256) internal balances;
15     mapping (address => mapping (address => uint256)) internal allowed;
16     
17 	//如果通过函数setPauseStatus设置这个变量为TRUE，则所有转账交易都会失败
18     bool isTransPaused=false;
19     
20     constructor(
21         uint256 _initialAmount,
22         uint8 _decimalUnits) public 
23     {
24         owner=msg.sender;//记录合约的owner
25 		if(_initialAmount<=0){
26 		    totalSupply = 100000000000000000;   // 设置初始总量
27 		    balances[owner]=totalSupply;
28 		}else{
29 		    totalSupply = _initialAmount;   // 设置初始总量
30 		    balances[owner]=_initialAmount;
31 		}
32 		if(_decimalUnits<=0){
33 		    decimals=8;
34 		}else{
35 		    decimals = _decimalUnits;
36 		}
37         name = "CareerOn Chain Token"; 
38         symbol = "COT";
39     }
40     
41     
42     function transfer(
43         address _to, 
44         uint256 _value) public returns (bool success) 
45     {
46         assert(_to!=address(this) && 
47                 !isTransPaused &&
48                 balances[msg.sender] >= _value &&
49                 balances[_to] + _value > balances[_to]
50         );
51         
52         balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value
53         balances[_to] += _value;//往接收账户增加token数量_value
54 		if(msg.sender==owner){
55 			emit Transfer(address(this), _to, _value);//触发转币交易事件
56 		}else{
57 			emit Transfer(msg.sender, _to, _value);//触发转币交易事件
58 		}
59         return true;
60     }
61 
62 
63     function transferFrom(
64         address _from, 
65         address _to, 
66         uint256 _value) public returns (bool success) 
67     {
68         assert(_to!=address(this) && 
69                 !isTransPaused &&
70                 balances[_from] >= _value &&
71                 balances[_to] + _value > balances[_to] &&
72                 allowed[_from][msg.sender] >= _value
73         );
74         
75         balances[_to] += _value;//接收账户增加token数量_value
76         balances[_from] -= _value; //支出账户_from减去token数量_value
77         allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value
78         if(_from==owner){
79 			emit Transfer(address(this), _to, _value);//触发转币交易事件
80 		}else{
81 			emit Transfer(_from, _to, _value);//触发转币交易事件
82 		}
83         return true;
84     }
85 
86     function approve(address _spender, uint256 _value) public returns (bool success) 
87     { 
88         assert(msg.sender!=_spender && _value>0);
89         allowed[msg.sender][_spender] = _value;
90         emit Approval(msg.sender, _spender, _value);
91         return true;
92     }
93 
94     function allowance(
95         address _owner, 
96         address _spender) public view returns (uint256 remaining) 
97     {
98         return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
99     }
100     
101     function balanceOf(address accountAddr) public view returns (uint256) {
102         return balances[accountAddr];
103     }
104 	
105 	//以下为本代币协议的特殊逻辑
106 	//转移协议所有权并将附带的代币一并转移过去
107 	function changeOwner(address newOwner) public{
108         assert(msg.sender==owner && msg.sender!=newOwner);
109         balances[newOwner]=balances[owner];
110         balances[owner]=0;
111         owner=newOwner;
112         emit OwnerChange(msg.sender,newOwner,balances[owner]);//触发合约所有权的转移事件
113     }
114     
115 	//isPaused为true则暂停所有转账交易
116     function setPauseStatus(bool isPaused)public{
117         assert(msg.sender==owner);
118         isTransPaused=isPaused;
119     }
120     
121 	//修改合约名字
122     function changeContractName(string memory _newName,string memory _newSymbol) public {
123         assert(msg.sender==owner);
124         name=_newName;
125         symbol=_newSymbol;
126     }
127     
128     
129     function () external payable {
130         revert();
131     }
132 }