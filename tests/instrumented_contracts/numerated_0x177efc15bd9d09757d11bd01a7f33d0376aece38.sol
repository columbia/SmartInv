1 pragma solidity ^0.4.24;
2 contract Token {
3 
4     /// @return 返回token的发行量
5     function totalSupply() constant returns (uint256 supply) {}
6 
7     /// @param _owner 查询以太坊地址token余额
8     /// @return The balance 返回余额
9     function balanceOf(address _owner) constant returns (uint256 balance) {}
10 
11     /// @notice msg.sender（交易发送者）发送 _value（一定数量）的 token 到 _to（接受者）  
12     /// @param _to 接收者的地址
13     /// @param _value 发送token的数量
14     /// @return 是否成功
15     function transfer(address _to, uint256 _value) returns (bool success) {}
16 
17     /// @notice 发送者 发送 _value（一定数量）的 token 到 _to（接受者）  
18     /// @param _from 发送者的地址
19     /// @param _to 接收者的地址
20     /// @param _value 发送的数量
21     /// @return 是否成功
22     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
23 
24     /// @notice 发行方 批准 一个地址发送一定数量的token
25     /// @param _spender 需要发送token的地址
26     /// @param _value 发送token的数量
27     /// @return 是否成功
28     function approve(address _spender, uint256 _value) returns (bool success) {}
29 
30     /// @param _owner 拥有token的地址
31     /// @param _spender 可以发送token的地址
32     /// @return 还允许发送的token的数量
33     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
34 
35     /// 发送Token事件
36     event Transfer(address indexed _from, address indexed _to, uint256 _value);
37     /// 批准事件
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 }
40 contract StandardToken is Token {
41 
42     function transfer(address _to, uint256 _value) returns (bool success) {
43         //默认token发行量不能超过(2^256 - 1)
44         //如果你不设置发行量，并且随着时间的发型更多的token，需要确保没有超过最大值，使用下面的 if 语句
45         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
46         if (balances[msg.sender] >= _value && _value > 0) {
47             balances[msg.sender] -= _value;
48             balances[_to] += _value;
49             Transfer(msg.sender, _to, _value);
50             return true;
51         } else { return false; }
52     }
53 
54     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
55         //向上面的方法一样，如果你想确保发行量不超过最大值
56         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
57         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
58             balances[_to] += _value;
59             balances[_from] -= _value;
60             allowed[_from][msg.sender] -= _value;
61             Transfer(_from, _to, _value);
62             return true;
63         } else { return false; }
64     }
65 
66     function balanceOf(address _owner) constant returns (uint256 balance) {
67         return balances[_owner];
68     }
69 
70     function approve(address _spender, uint256 _value) returns (bool success) {
71         allowed[msg.sender][_spender] = _value;
72         Approval(msg.sender, _spender, _value);
73         return true;
74     }
75 
76     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
77       return allowed[_owner][_spender];
78     }
79 
80     mapping (address => uint256) balances;
81     mapping (address => mapping (address => uint256)) allowed;
82     uint256 public totalSupply;
83 }
84 contract MNToken is StandardToken {
85 
86     function () {
87         //if ether is sent to this address, send it back.
88         throw;
89     }
90 
91     /* Public variables of the token */
92 
93     /*
94     NOTE:
95     The following variables are OPTIONAL vanities. One does not have to include them.
96     They allow one to customise the token contract & in no way influences the core functionality.
97     Some wallets/interfaces might not even bother to look at this information.
98     */
99     string public name;                   //token名称: MyFreeCoin 
100     uint8 public decimals;                //小数位
101     string public symbol;                 //标识
102     string public version = 'H0.1';       //版本号
103 
104     function MNToken(
105         uint256 _initialAmount,
106         string _tokenName,
107         uint8 _decimalUnits,
108         string _tokenSymbol
109         ) {
110         balances[msg.sender] = _initialAmount;               // 合约发布者的余额是发行数量
111         totalSupply = _initialAmount;                        // 发行量
112         name = _tokenName;                                   // token名称
113         decimals = _decimalUnits;                            // token小数位
114         symbol = _tokenSymbol;                               // token标识
115     }
116 
117     /* 批准然后调用接收合约 */
118     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
119         allowed[msg.sender][_spender] = _value;
120         Approval(msg.sender, _spender, _value);
121 
122         //调用你想要通知合约的 receiveApprovalcall 方法 ，这个方法是可以不需要包含在这个合约里的。
123         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
124         //假设这么做是可以成功，不然应该调用vanilla approve。
125         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
126         return true;
127     }
128 }