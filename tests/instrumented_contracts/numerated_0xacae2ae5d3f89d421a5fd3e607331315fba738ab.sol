1 pragma solidity ^0.4.23;
2 contract Token{
3     // token总量，默认会为public变量生成一个getter函数接口，名称为totalSupply().
4     uint256 public totalSupply;
5 
6     /// 获取账户_owner拥有token的数量 
7     function balanceOf(address _owner) constant public returns (uint256 balance);
8 
9     //从消息发送者账户中往_to账户转数量为_value的token
10     function transfer(address _to, uint256 _value) public returns (bool success);
11 
12     //从账户_from中往账户_to转数量为_value的token，与approve方法配合使用
13     function transferFrom(address _from, address _to, uint256 _value) public returns   
14     (bool success);
15 
16     //消息发送账户设置账户_spender能从发送账户中转出数量为_value的token
17     function approve(address _spender, uint256 _value) public returns (bool success);
18 
19     //获取账户_spender可以从账户_owner中转出token的数量 
20     function allowance(address _owner, address _spender) constant public returns 
21     (uint256 remaining);
22 
23     //发生转账时必须要触发的事件 
24     event Transfer(address indexed _from, address indexed _to, uint256 _value);
25 
26     //当函数approve(address _spender, uint256 _value)成功执行时必须触发的事件
27     event Approval(address indexed _owner, address indexed _spender, uint256 
28     _value);
29 }
30 
31 library SafeMath {
32     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33         if (a == 0) {
34             return 0;
35         }
36         uint256 c = a * b;
37         assert(c / a == b);
38         return c;
39     }
40     function div(uint256 a, uint256 b) internal pure returns (uint256) {
41         // assert(b > 0); // Solidity automatically throws when dividing by 0
42         uint256 c = a / b;
43         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44         return c;
45     }
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         assert(b <= a);
48         return a - b;
49     }
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         assert(c >= a);
53         return c;
54     }
55 }
56 
57 contract StandardToken is Token {
58     using SafeMath for uint256;
59     function transfer(address _to, uint256 _value) public returns (bool success) {
60         require(_to != address(0));
61         require(balances[msg.sender] >= _value);
62         balances[msg.sender] = balances[msg.sender].sub(_value);//从消息发送者账户中减去token数量_value
63         balances[_to] = balances[_to].add(_value);//往接收账户增加token数量_value
64         emit Transfer(msg.sender, _to, _value);//触发转币交易事件
65         return true;
66     }
67 
68 
69     function transferFrom(address _from, address _to, uint256 _value) public returns 
70     (bool success) {
71         require(_to != address(0));
72         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
73         balances[_to] = balances[_to].add(_value);//接收账户增加token数量_value
74         balances[_from] = balances[_from].sub(_value); //支出账户_from减去token数量_value
75         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);//消息发送者可以从账户_from中转出的数量减少_value
76         emit Transfer(_from, _to, _value);//触发转币交易事件
77         return true;
78     }
79     function balanceOf(address _owner) constant public returns (uint256 balance) {
80         return balances[_owner];
81     }
82 
83 
84     function approve(address _spender, uint256 _value) public returns (bool success)   
85     {
86         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
87         allowed[msg.sender][_spender] = _value;
88         emit Approval(msg.sender, _spender, _value);
89         return true;
90     }
91 
92 
93     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
94         return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
95     }
96     mapping (address => uint256) balances;
97     mapping (address => mapping (address => uint256)) allowed;
98 }
99 
100 contract NiMingToken is StandardToken { 
101 
102     /* Public variables of the token */
103     string public name;                   //名称: eg Simon Bucks
104     uint8 public decimals;               //最多的小数位数，How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
105     string public symbol;               //token简称: eg SBX
106     string public version = 'H0.1';    //版本
107 
108     constructor(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public {
109         balances[msg.sender] = _initialAmount; // 初始token数量给予消息发送者
110         totalSupply = _initialAmount;         // 设置初始总量
111         name = _tokenName;                   // token名称
112         decimals = _decimalUnits;           // 小数位数
113         symbol = _tokenSymbol;             // token简称
114     }
115 
116     /* Approves and then calls the receiving contract */
117     
118     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
119         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
120         allowed[msg.sender][_spender] = _value;
121         emit Approval(msg.sender, _spender, _value);
122         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
123         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
124         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
125         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
126         return true;
127     }
128 
129 }