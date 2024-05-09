1 pragma solidity ^0.4.18;
2 
3   // ----------------------------------------------------------------------------------------------
4   // Sample fixed supply token contract
5   // Enjoy. (c) BokkyPooBah 2017. The MIT Licence.
6   // ----------------------------------------------------------------------------------------------
7 
8    // ERC Token Standard #20 Interface
9   // https://github.com/ethereum/EIPs/issues/20
10   contract ERC20Interface {
11       // 获取总的支持量
12       function totalSupply() constant public returns (uint256 _totalSupply);
13 
14       // 获取其他地址的余额
15       function balanceOf(address _owner) constant public returns (uint256 balance);
16 
17       // 向其他地址发送token
18       function transfer(address _to, uint256 _value) public returns (bool success);
19 
20       // 从一个地址想另一个地址发送余额
21       function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
22 
23       //允许_spender从你的账户转出_value的余额，调用多次会覆盖可用量。某些DEX功能需要此功能
24       function approve(address _spender, uint256 _value) public returns (bool success);
25 
26       // 返回_spender仍然允许从_owner退出的余额数量
27       function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
28 
29       // token转移完成后出发
30       event Transfer(address indexed _from, address indexed _to, uint256 _value);
31 
32       // approve(address _spender, uint256 _value)调用后触发
33       event Approval(address indexed _owner, address indexed _spender, uint256 _value);
34   }
35 
36    //继承接口后的实例
37    contract HDCToken is ERC20Interface {
38       string public constant symbol = "HDCT"; //单位
39       string public constant name = "Health Data Chain Token"; //名称
40       uint8 public constant decimals = 18; //小数点后的位数
41       uint256 _totalSupply = 10000000000000000000000000000; //发行总量
42 
43       // 智能合约的所有者
44       address public owner;
45 
46       // 每个账户的余额
47       mapping(address => uint256) balances;
48 
49       // 帐户的所有者批准将金额转入另一个帐户。从上面的说明我们可以得知allowed[被转移的账户][转移钱的账户]
50       mapping(address => mapping (address => uint256)) allowed;
51 
52       // 只能通过智能合约的所有者才能调用的方法
53       modifier onlyOwner() {
54           require (msg.sender != owner);
55           _;
56       }
57 
58 	  bool public paused = false;
59 
60       /**
61        * @dev Modifier to make a function callable only when the contract is not paused.
62        */
63       modifier whenNotPaused() {
64         require(!paused);
65         _;
66       }
67     
68       /**
69        * @dev Modifier to make a function callable only when the contract is paused.
70        */
71       modifier whenPaused() {
72         require(paused);
73         _;
74       }
75     
76       /**
77        * @dev called by the owner to pause, triggers stopped state
78        */
79       function pause() onlyOwner whenNotPaused public {
80         paused = true;
81       }
82     
83       /**
84        * @dev called by the owner to unpause, returns to normal state
85        */
86       function unpause() onlyOwner whenPaused public {
87         paused = false;
88       }
89   
90       // 构造函数
91       constructor () public {
92           owner = msg.sender;
93           balances[owner] = _totalSupply;
94       }
95 
96       function  totalSupply() public constant returns (uint256 totalSupplyRet) {
97           totalSupplyRet = _totalSupply;
98       }
99 
100       // 特定账户的余额
101       function balanceOf(address _owner) public constant returns (uint256 balance) {
102           return balances[_owner];
103       }
104 
105       // 转移余额到其他账户
106       function transfer(address _to, uint256 _amount) public whenNotPaused returns (bool success) {
107           require(_to != address(0x0) );
108 
109           require (balances[msg.sender] >= _amount 
110               && _amount > 0
111               && balances[_to] + _amount > balances[_to]); 
112               
113             balances[msg.sender] -= _amount;
114             balances[_to] += _amount;
115             emit Transfer(msg.sender, _to, _amount);
116             return true;
117       }
118 
119       //从一个账户转移到另一个账户，前提是需要有允许转移的余额
120       function transferFrom(
121           address _from,
122           address _to,
123           uint256 _amount
124       ) public whenNotPaused returns (bool success) {
125           require(_to != address(0x0) );
126           
127           require (balances[_from] >= _amount
128               && allowed[_from][msg.sender] >= _amount
129               && _amount > 0
130               && balances[_to] + _amount > balances[_to]);
131               
132             balances[_from] -= _amount;
133             allowed[_from][msg.sender] -= _amount;
134             balances[_to] += _amount;
135             emit Transfer(_from, _to, _amount);
136             return true;
137       }
138 
139       //允许账户从当前用户转移余额到那个账户，多次调用会覆盖
140       function approve(address _spender, uint256 _amount) public whenNotPaused returns (bool success) {
141           allowed[msg.sender][_spender] = _amount;
142           emit Approval(msg.sender, _spender, _amount);
143           return true;
144       }
145 
146       //返回被允许转移的余额数量
147       function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
148           return allowed[_owner][_spender];
149       }
150   }