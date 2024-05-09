1 contract Token {
2     /* This is a slight change to the ERC20 base standard.
3     function totalSupply() constant returns (uint256 supply);
4     is replaced with:
5     uint256 public totalSupply;
6     This automatically creates a getter function for the totalSupply.
7     This is moved to the base contract since public getter functions are not
8     currently recognised as an implementation of the matching abstract
9     function by the compiler.
10     */
11     /// total amount of tokens
12     uint256 public totalSupply;
13 
14     /// @param _owner The address from which the balance will be retrieved
15     /// @return The balance
16     function balanceOf(address _owner) constant returns (uint256 balance);
17 
18     /// @notice send `_value` token to `_to` from `msg.sender`
19     /// @param _to The address of the recipient
20     /// @param _value The amount of token to be transferred
21     /// @return Whether the transfer was successful or not
22     function transfer(address _to, uint256 _value) returns (bool success);
23 
24     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
25     /// @param _from The address of the sender
26     /// @param _to The address of the recipient
27     /// @param _value The amount of token to be transferred
28     /// @return Whether the transfer was successful or not
29     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
30 
31     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @param _value The amount of tokens to be approved for transfer
34     /// @return Whether the approval was successful or not
35     function approve(address _spender, uint256 _value) returns (bool success);
36 
37     /// @param _owner The address of the account owning tokens
38     /// @param _spender The address of the account able to transfer the tokens
39     /// @return Amount of remaining tokens allowed to spent
40     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
41 
42     event Transfer(address indexed _from, address indexed _to, uint256 _value);
43     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
44 }
45 
46 contract StandardToken is Token {
47     function transfer(address _to, uint256 _value) returns (bool success) {
48         //默认totalSupply 不会超过最大值 (2^256 - 1).
49         //如果随着时间的推移将会有新的token生成，则可以用下面这句避免溢出的异常
50         //require(balances[msg.sender] >= _value && balances[_to] + _value >balances[_to]);
51         require(balances[msg.sender] >= _value);
52         balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value
53         balances[_to] += _value;//往接收账户增加token数量_value
54         Transfer(msg.sender, _to, _value);//触发转币交易事件
55         return true;
56     }
57     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
58         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
59         require(balances[_from] >= _value && allowed[_from][msg.sender] >=  _value);
60         balances[_to] += _value;//接收账户增加token数量_value
61         balances[_from] -= _value; //支出账户_from减去token数量_value
62         allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value
63         Transfer(_from, _to, _value);//触发转币交易事件
64         return true;
65     }
66     //查询余额
67     function balanceOf(address _owner) constant returns (uint256 balance) {
68         return balances[_owner];
69     }
70     //授权账户_spender可以从消息发送者账户转出数量为_value的token
71     function approve(address _spender, uint256 _value) returns (bool success)   
72     {
73         allowed[msg.sender][_spender] = _value;
74         Approval(msg.sender, _spender, _value);
75         return true;
76     }
77     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
78       return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
79     }
80 
81     mapping (address => uint256) balances;
82     mapping (address => mapping (address => uint256)) allowed;
83 }
84 contract HumanStandardToken is StandardToken {
85     /* Public variables of the token */
86     string public name;                   //名称: eg Simon Bucks
87     uint8 public decimals;                //最多的小数位数How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
88     string public symbol;                 //token简称: eg SBX
89     string public version = 'H0.1';       //版本
90 
91     function HumanStandardToken(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) {
92         balances[msg.sender] = _initialAmount; // 初始token数量给予消息发送者
93         totalSupply = _initialAmount;         // 设置初始总量
94         name = _tokenName;                   // token名称
95         decimals = _decimalUnits;           // 小数位数
96         symbol = _tokenSymbol;             // token简称
97     }
98     /* 同意转出并调用接收合约（根据自己需求实现） */
99     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
100         allowed[msg.sender][_spender] = _value;
101         Approval(msg.sender, _spender, _value);
102         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
103         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
104         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
105         
106         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
107         return true;
108     }
109 }