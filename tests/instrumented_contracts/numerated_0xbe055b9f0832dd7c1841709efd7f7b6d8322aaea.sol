1 pragma solidity  0.4.24;
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
42 /*
43 This implements ONLY the standard functions and NOTHING else.
44 For a token like you would want to deploy in something like Mist, see HumanStandardToken.sol.
45 
46 If you deploy this, you won't have anything useful.
47 
48 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
49 
50 实现ERC20标准
51 .*/
52 
53 contract StandardToken is Token {
54 
55     function transfer(address _to, uint256 _value) returns (bool success) {
56         //默认token发行量不能超过(2^256 - 1)
57         //如果你不设置发行量，并且随着时间的发型更多的token，需要确保没有超过最大值，使用下面的 if 语句
58         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
59         if (balances[msg.sender] >= _value && _value > 0) {
60             balances[msg.sender] -= _value;
61             balances[_to] += _value;
62             Transfer(msg.sender, _to, _value);
63             return true;
64         } else { return false; }
65     }
66 
67     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
68         //向上面的方法一样，如果你想确保发行量不超过最大值
69         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
70         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
71             balances[_to] += _value;
72             balances[_from] -= _value;
73             allowed[_from][msg.sender] -= _value;
74             Transfer(_from, _to, _value);
75             return true;
76         } else { return false; }
77     }
78 
79     function balanceOf(address _owner) constant returns (uint256 balance) {
80         return balances[_owner];
81     }
82 
83     function approve(address _spender, uint256 _value) returns (bool success) {
84         allowed[msg.sender][_spender] = _value;
85         Approval(msg.sender, _spender, _value);
86         return true;
87     }
88 
89     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
90       return allowed[_owner][_spender];
91     }
92 
93     mapping (address => uint256) balances;
94     mapping (address => mapping (address => uint256)) allowed;
95     uint256 public totalSupply;
96 }
97 
98 /*
99 This Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans.
100 
101 In other words. This is intended for deployment in something like a Token Factory or Mist wallet, and then used by humans.
102 Imagine coins, currencies, shares, voting weight, etc.
103 Machine-based, rapid creation of many tokens would not necessarily need these extra features or will be minted in other manners.
104 
105 1) Initial Finite Supply (upon creation one specifies how much is minted).
106 2) In the absence of a token registry: Optional Decimal, Symbol & Name.
107 3) Optional approveAndCall() functionality to notify a contract if an approval() has occurred.
108 
109 .*/
110 
111 contract MyFreeCoin is StandardToken {
112 
113     function () {
114         //if ether is sent to this address, send it back.
115         throw;
116     }
117 
118     /* Public variables of the token */
119 
120     /*
121     NOTE:
122     The following variables are OPTIONAL vanities. One does not have to include them.
123     They allow one to customise the token contract & in no way influences the core functionality.
124     Some wallets/interfaces might not even bother to look at this information.
125     */
126     string public name;                   //token名称: MyFreeCoin 
127     uint8 public decimals;                //小数位
128     string public symbol;                 //标识
129     string public version = 'H0.1';       //版本号
130 
131     function MyFreeCoin(
132         uint256 _initialAmount,
133         string _tokenName,
134         uint8 _decimalUnits,
135         string _tokenSymbol
136         ) {
137         balances[msg.sender] = _initialAmount;               // 合约发布者的余额是发行数量
138         totalSupply = _initialAmount;                        // 发行量
139         name = _tokenName;                                   // token名称
140         decimals = _decimalUnits;                            // token小数位
141         symbol = _tokenSymbol;                               // token标识
142     }
143 
144     /* 批准然后调用接收合约 */
145     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
146         allowed[msg.sender][_spender] = _value;
147         Approval(msg.sender, _spender, _value);
148 
149         //调用你想要通知合约的 receiveApprovalcall 方法 ，这个方法是可以不需要包含在这个合约里的。
150         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
151         //假设这么做是可以成功，不然应该调用vanilla approve。
152         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
153         return true;
154     }
155 }