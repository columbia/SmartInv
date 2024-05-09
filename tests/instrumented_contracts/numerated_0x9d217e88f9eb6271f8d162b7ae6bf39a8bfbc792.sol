1 pragma solidity ^0.4.19;
2 
3 contract Token {
4 
5     /// @return total amount of tokens
6     /// @return 返回token的发行量
7     function totalSupply() constant returns (uint256 supply) {}
8 
9     /// @param _owner The address from which the balance will be retrieved
10     /// @return The balance
11     /// @param _owner 查询以太坊地址token余额
12     /// @return The balance 返回余额
13     function balanceOf(address _owner) constant returns (uint256 balance) {}
14 
15     /// @notice send `_value` token to `_to` from `msg.sender`
16     /// @param _to The address of the recipient
17     /// @param _value The amount of token to be transferred
18     /// @return Whether the transfer was successful or not
19     /// @notice msg.sender（交易发送者）发送 _value（一定数量）的 token 到 _to（接受者）  
20     /// @param _to 接收者的地址
21     /// @param _value 发送token的数量
22     /// @return 是否成功
23     function transfer(address _to, uint256 _value) returns (bool success) {}
24 
25     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
26     /// @param _from The address of the sender
27     /// @param _to The address of the recipient
28     /// @param _value The amount of token to be transferred
29     /// @return Whether the transfer was successful or not
30     /// @notice 发送者 发送 _value（一定数量）的 token 到 _to（接受者）  
31     /// @param _from 发送者的地址
32     /// @param _to 接收者的地址
33     /// @param _value 发送的数量
34     /// @return 是否成功
35     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
36 
37     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
38     /// @param _spender The address of the account able to transfer the tokens
39     /// @param _value The amount of wei to be approved for transfer
40     /// @return Whether the approval was successful or not
41     /// @notice 发行方 批准 一个地址发送一定数量的token
42     /// @param _spender 需要发送token的地址
43     /// @param _value 发送token的数量
44     /// @return 是否成功
45     function approve(address _spender, uint256 _value) returns (bool success) {}
46 
47     /// @param _owner The address of the account owning tokens
48     /// @param _spender The address of the account able to transfer the tokens
49     /// @return Amount of remaining tokens allowed to spent
50     /// @param _owner 拥有token的地址
51     /// @param _spender 可以发送token的地址
52     /// @return 还允许发送的token的数量
53     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
54 
55     /// 发送Token事件
56     event Transfer(address indexed _from, address indexed _to, uint256 _value);
57     /// 批准事件
58     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
59 }
60 contract StandardToken is Token {
61 
62     function transfer(address _to, uint256 _value) returns (bool success) {
63         //Default assumes totalSupply can't be over max (2^256 - 1).
64         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
65         //Replace the if with this one instead.
66         //默认token发行量不能超过(2^256 - 1)
67         //如果你不设置发行量，并且随着时间的发型更多的token，需要确保没有超过最大值，使用下面的 if 语句
68         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
69         if (balances[msg.sender] >= _value && _value > 0) {
70             balances[msg.sender] -= _value;
71             balances[_to] += _value;
72             Transfer(msg.sender, _to, _value);
73             return true;
74         } else { return false; }
75     }
76 
77     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
78         //same as above. Replace this line with the following if you want to protect against wrapping uints.
79         //向上面的方法一样，如果你想确保发行量不超过最大值
80         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
81         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
82             balances[_to] += _value;
83             balances[_from] -= _value;
84             allowed[_from][msg.sender] -= _value;
85             Transfer(_from, _to, _value);
86             return true;
87         } else { return false; }
88     }
89 
90     function balanceOf(address _owner) constant returns (uint256 balance) {
91         return balances[_owner];
92     }
93 
94     function approve(address _spender, uint256 _value) returns (bool success) {
95         allowed[msg.sender][_spender] = _value;
96         Approval(msg.sender, _spender, _value);
97         return true;
98     }
99 
100     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
101       return allowed[_owner][_spender];
102     }
103 
104     mapping (address => uint256) balances;
105     mapping (address => mapping (address => uint256)) allowed;
106     uint256 public totalSupply;
107 }
108 
109 contract CoinExchangeToken is StandardToken {
110 
111     function () {
112         //if ether is sent to this address, send it back.
113         throw;
114     }
115 
116     /* Public variables of the token */
117 
118     /*
119     NOTE:
120     The following variables are OPTIONAL vanities. One does not have to include them.
121     They allow one to customise the token contract & in no way influences the core functionality.
122     Some wallets/interfaces might not even bother to look at this information.
123     */
124     string public name;                   //fancy name: eg Simon Bucks
125     uint8 public decimals;                //小数位How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
126     string public symbol;                 //An identifier: eg SBX
127     string public version = 'H0.1';       //版本号human 0.1 standard. Just an arbitrary versioning scheme.
128 
129     function CoinExchangeToken(
130         uint256 _initialAmount,
131         string _tokenName,
132         uint8 _decimalUnits,
133         string _tokenSymbol
134         ) {
135         balances[msg.sender] = _initialAmount;               // 把合约的发布者的余额设置为发行量的数量,Give the creator all initial tokens
136         totalSupply = _initialAmount;                        // 发行量Update total supply
137         name = _tokenName;                                   // token名称Set the name for display purposes
138         decimals = _decimalUnits;                            // token小数位Amount of decimals for display purposes
139         symbol = _tokenSymbol;                               // token标识Set the symbol for display purposes
140     }
141 
142     /* Approves and then calls the receiving contract */
143     /* 批准然后调用接收合约 */
144     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
145         allowed[msg.sender][_spender] = _value;
146         Approval(msg.sender, _spender, _value);
147 
148         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
149         //调用你想要通知合约的 receiveApprovalcall 方法 ，这个方法是可以不需要包含在这个合约里的。
150         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
151         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
152         //假设这么做是可以成功，不然应该调用vanilla approve。
153         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
154         return true;
155     }
156 }