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
41 /*
42 This implements ONLY the standard functions and NOTHING else.
43 For a token like you would want to deploy in something like Mist, see HumanStandardToken.sol.
44 
45 If you deploy this, you won't have anything useful.
46 
47 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
48 
49 实现ERC20标准
50 .*/
51 
52 pragma solidity ^0.4.4;
53 
54 contract StandardToken is Token {
55 
56     function transfer(address _to, uint256 _value) returns (bool success) {
57         //默认token发行量不能超过(2^256 - 1)
58         //如果你不设置发行量，并且随着时间的发型更多的token，需要确保没有超过最大值，使用下面的 if 语句
59         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
60         if (balances[msg.sender] >= _value && _value > 0) {
61             balances[msg.sender] -= _value;
62             balances[_to] += _value;
63             Transfer(msg.sender, _to, _value);
64             return true;
65         } else { return false; }
66     }
67 
68     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
69         //向上面的方法一样，如果你想确保发行量不超过最大值
70         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
71         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
72             balances[_to] += _value;
73             balances[_from] -= _value;
74             allowed[_from][msg.sender] -= _value;
75             Transfer(_from, _to, _value);
76             return true;
77         } else { return false; }
78     }
79 
80     function balanceOf(address _owner) constant returns (uint256 balance) {
81         return balances[_owner];
82     }
83 
84     function approve(address _spender, uint256 _value) returns (bool success) {
85         allowed[msg.sender][_spender] = _value;
86         Approval(msg.sender, _spender, _value);
87         return true;
88     }
89 
90     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
91       return allowed[_owner][_spender];
92     }
93 
94     mapping (address => uint256) balances;
95     mapping (address => mapping (address => uint256)) allowed;
96     uint256 public totalSupply;
97 }
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
110 pragma solidity ^0.4.4;
111 
112 contract NathalieToken is StandardToken {
113 
114     function () {
115         //if ether is sent to this address, send it back.
116         throw;
117     }
118 
119     /* Public variables of the token */
120 
121     /*
122     NOTE:
123     The following variables are OPTIONAL vanities. One does not have to include them.
124     They allow one to customise the token contract & in no way influences the core functionality.
125     Some wallets/interfaces might not even bother to look at this information.
126     */
127     string public name;                   //token名称: MyFreeCoin 
128     uint8 public decimals;                //小数位
129     string public symbol;                 //标识
130     string public version = 'H0.1';       //版本号
131 
132     function NathalieToken(
133         uint256 _initialAmount,
134         string _tokenName,
135         uint8 _decimalUnits,
136         string _tokenSymbol
137         ) {
138         balances[msg.sender] = _initialAmount;               // 合约发布者的余额是发行数量
139         totalSupply = _initialAmount;                        // 发行量
140         name = _tokenName;                                   // token名称
141         decimals = _decimalUnits;                            // token小数位
142         symbol = _tokenSymbol;                               // token标识
143     }
144 
145     /* 批准然后调用接收合约 */
146     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
147         allowed[msg.sender][_spender] = _value;
148         Approval(msg.sender, _spender, _value);
149 
150         //调用你想要通知合约的 receiveApprovalcall 方法 ，这个方法是可以不需要包含在这个合约里的。
151         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
152         //假设这么做是可以成功，不然应该调用vanilla approve。
153         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
154         return true;
155     }
156 }