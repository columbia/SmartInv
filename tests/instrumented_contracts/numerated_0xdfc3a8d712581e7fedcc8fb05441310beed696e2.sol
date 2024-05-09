1 pragma solidity ^0.4.4;
2  
3 contract Token {
4  
5     /// @return 返回token的发行量
6     function totalSupply() constant returns (uint256 supply) {}
7  
8     /// @param _owner 查询以太坊地址token余额
9     /// @return The balance 返回余额
10     function balanceOf(address _owner) constant returns (uint256 balance) {}
11  
12     /// @notice msg.sender（交易发送者）发送 _value（一定数量）的 token 到 _to（接受者）  
13     /// @param _to 接收者的地址
14     /// @param _value 发送token的数量
15     /// @return 是否成功
16     function transfer(address _to, uint256 _value) returns (bool success) {}
17  
18     /// @notice 发送者 发送 _value（一定数量）的 token 到 _to（接受者）  
19     /// @param _from 发送者的地址
20     /// @param _to 接收者的地址
21     /// @param _value 发送的数量
22     /// @return 是否成功
23     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
24  
25     /// @notice 发行方 批准 一个地址发送一定数量的token
26     /// @param _spender 需要发送token的地址
27     /// @param _value 发送token的数量
28     /// @return 是否成功
29     function approve(address _spender, uint256 _value) returns (bool success) {}
30  
31     /// @param _owner 拥有token的地址
32     /// @param _spender 可以发送token的地址
33     /// @return 还允许发送的token的数量
34     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
35  
36     /// 发送Token事件
37     event Transfer(address indexed _from, address indexed _to, uint256 _value);
38     /// 批准事件
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 }
41 contract StandardToken is Token {
42  
43     function transfer(address _to, uint256 _value) returns (bool success) {
44         //默认token发行量不能超过(2^256 - 1)
45         //如果你不设置发行量，并且随着时间的发型更多的token，需要确保没有超过最大值，使用下面的 if 语句
46         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
47         if (balances[msg.sender] >= _value && _value > 0) {
48             balances[msg.sender] -= _value;
49             balances[_to] += _value;
50             Transfer(msg.sender, _to, _value);
51             return true;
52         } else { return false; }
53     }
54  
55     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
56         //向上面的方法一样，如果你想确保发行量不超过最大值
57         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
58         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
59             balances[_to] += _value;
60             balances[_from] -= _value;
61             allowed[_from][msg.sender] -= _value;
62             Transfer(_from, _to, _value);
63             return true;
64         } else { return false; }
65     }
66  
67     function balanceOf(address _owner) constant returns (uint256 balance) {
68         return balances[_owner];
69     }
70  
71     function approve(address _spender, uint256 _value) returns (bool success) {
72         allowed[msg.sender][_spender] = _value;
73         Approval(msg.sender, _spender, _value);
74         return true;
75     }
76  
77     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
78       return allowed[_owner][_spender];
79     }
80  
81     mapping (address => uint256) balances;
82     mapping (address => mapping (address => uint256)) allowed;
83     uint256 public totalSupply;
84 }
85 contract DaShaBi is StandardToken {
86  
87     function () {
88         //if ether is sent to this address, send it back.
89         throw;
90     }
91  
92     /* Public variables of the token */
93  
94     /*
95     NOTE:
96     The following variables are OPTIONAL vanities. One does not have to include them.
97     They allow one to customise the token contract & in no way influences the core functionality.
98     Some wallets/interfaces might not even bother to look at this information.
99     */
100     string public name;                   //token名称: MyFreeCoin 
101     uint8 public decimals;                //小数位
102     string public symbol;                 //标识
103     string public version = 'H0.1';       //版本号
104  
105     function DaShaBi(
106         uint256 _initialAmount,
107         string _tokenName,
108         uint8 _decimalUnits,
109         string _tokenSymbol
110         ) {
111         balances[msg.sender] = _initialAmount;               // 合约发布者的余额是发行数量
112         totalSupply = _initialAmount;                        // 发行量
113         name = _tokenName;                                   // token名称
114         decimals = _decimalUnits;                            // token小数位
115         symbol = _tokenSymbol;                               // token标识
116     }
117  
118     /* 批准然后调用接收合约 */
119     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
120         allowed[msg.sender][_spender] = _value;
121         Approval(msg.sender, _spender, _value);
122  
123         //调用你想要通知合约的 receiveApprovalcall 方法 ，这个方法是可以不需要包含在这个合约里的。
124         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
125         //假设这么做是可以成功，不然应该调用vanilla approve。
126         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
127         return true;
128     }
129 }