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
41 
42 pragma solidity ^0.4.4;
43 contract StandardToken is Token {
44  
45     function transfer(address _to, uint256 _value) returns (bool success) {
46         //默认token发行量不能超过(2^256 - 1)
47         //如果你不设置发行量，并且随着时间的发型更多的token，需要确保没有超过最大值，使用下面的 if 语句
48         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
49         if (balances[msg.sender] >= _value && _value > 0) {
50             balances[msg.sender] -= _value;
51             balances[_to] += _value;
52             Transfer(msg.sender, _to, _value);
53             return true;
54         } else { return false; }
55     }
56  
57     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
58         //向上面的方法一样，如果你想确保发行量不超过最大值
59         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
60         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
61             balances[_to] += _value;
62             balances[_from] -= _value;
63             allowed[_from][msg.sender] -= _value;
64             Transfer(_from, _to, _value);
65             return true;
66         } else { return false; }
67     }
68  
69     function balanceOf(address _owner) constant returns (uint256 balance) {
70         return balances[_owner];
71     }
72  
73     function approve(address _spender, uint256 _value) returns (bool success) {
74         allowed[msg.sender][_spender] = _value;
75         Approval(msg.sender, _spender, _value);
76         return true;
77     }
78  
79     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
80       return allowed[_owner][_spender];
81     }
82  
83     mapping (address => uint256) balances;
84     mapping (address => mapping (address => uint256)) allowed;
85     uint256 public totalSupply;
86 }
87 
88 
89 pragma solidity ^0.4.4;
90 contract BtcThumb is StandardToken {
91  
92     function () {
93         //if ether is sent to this address, send it back.
94         throw;
95     }
96  
97     /* Public variables of the token */
98  
99     /*
100     NOTE:
101     The following variables are OPTIONAL vanities. One does not have to include them.
102     They allow one to customise the token contract & in no way influences the core functionality.
103     Some wallets/interfaces might not even bother to look at this information.
104     */
105     string public name;                   //token名称: BtcThumb 
106     uint8 public decimals;                //小数位
107     string public symbol;                 //标识
108     string public version = 'H0.1';       //版本号
109  
110     function BtcThumb(
111         uint256 _initialAmount,
112         string _tokenName,
113         uint8 _decimalUnits,
114         string _tokenSymbol
115         ) {
116         balances[msg.sender] = _initialAmount;               // 合约发布者的余额是发行数量
117         totalSupply = _initialAmount;                        // 发行量
118         name = _tokenName;                                   // token名称
119         decimals = _decimalUnits;                            // token小数位
120         symbol = _tokenSymbol;                               // token标识
121     }
122  
123     /* 批准然后调用接收合约 */
124     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
125         allowed[msg.sender][_spender] = _value;
126         Approval(msg.sender, _spender, _value);
127  
128         //调用你想要通知合约的 receiveApprovalcall 方法 ，这个方法是可以不需要包含在这个合约里的。
129         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
130         //假设这么做是可以成功，不然应该调用vanilla approve。
131         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
132         return true;
133     }
134 }