1 /*
2 Implements EIP20 token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
3 .*/
4 
5 
6 pragma solidity ^0.4.21;
7 
8 // Abstract contract for the full ERC 20 Token standard
9 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
10 pragma solidity ^0.4.21;
11 
12 
13 contract MarianaTokenInterface {
14     /* This is a slight change to the ERC20 base standard.
15     function totalSupply() constant returns (uint256 supply);
16     is replaced with:
17     uint256 public totalSupply;
18     This automatically creates a getter function for the totalSupply.
19     This is moved to the base contract since public getter functions are not
20     currently recognised as an implementation of the matching abstract
21     function by the compiler.
22     */
23     /// total amount of tokens
24     uint256 public totalSupply;
25 
26     /// @param _owner The address from which the balance will be retrieved
27     /// @return The balance
28     function balanceOf(address _owner) public view returns (uint256 balance);
29 
30     /// @notice send `_value` token to `_to` from `msg.sender`
31     /// @param _to The address of the recipient
32     /// @param _value The amount of token to be transferred
33     /// @return Whether the transfer was successful or not
34     function transfer(address _to, uint256 _value) public returns (bool success);
35 
36     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
37     /// @param _from The address of the sender
38     /// @param _to The address of the recipient
39     /// @param _value The amount of token to be transferred
40     /// @return Whether the transfer was successful or not
41     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
42 
43     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
44     /// @param _spender The address of the account able to transfer the tokens
45     /// @param _value The amount of tokens to be approved for transfer
46     /// @return Whether the approval was successful or not
47     function approve(address _spender, uint256 _value) public returns (bool success);
48 
49     /// @param _owner The address of the account owning tokens
50     /// @param _spender The address of the account able to transfer the tokens
51     /// @return Amount of remaining tokens allowed to spent
52     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
53 
54     // solhint-disable-next-line no-simple-event-func-name
55     event Transfer(address indexed _from, address indexed _to, uint256 _value);
56     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
57 }
58 
59 
60 contract MarianaToken is MarianaTokenInterface {
61 
62     uint256 constant private MAX_UINT256 = 2**256 - 1;
63     // 建立映射 地址对应了 uint' 便是他的余额
64     mapping (address => uint256) public balances;
65     // 存储对账号的控制
66     mapping (address => mapping (address => uint256)) public allowed;
67     /*
68     NOTE:
69     The following variables are OPTIONAL vanities. One does not have to include them.
70     They allow one to customise the token contract & in no way influences the core functionality.
71     Some wallets/interfaces might not even bother to look at this information.
72     */
73     string public name;                   //fancy name: eg Simon Bucks
74     uint8 public decimals;                //How many decimals to show.
75     string public symbol;                 //An identifier: eg SBX
76 
77     function MarianaToken (
78         uint256 _initialAmount,
79         string _tokenName,
80         uint8 _decimalUnits,
81         string _tokenSymbol
82     ) public {
83         //msg.sender是合约方法调用方的地址
84         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
85         totalSupply = _initialAmount;                        // Update total supply
86         name = _tokenName;                                   // Set the name for display purposes
87         decimals = _decimalUnits;                            // Amount of decimals for display purposes
88         symbol = _tokenSymbol;                               // Set the symbol for display purposes
89     }
90 
91     /**
92     *  代币交易转移
93     * 从创建交易者账号发送`_value`个代币到 `_to`账号
94     *
95     * @param _to 接收者地址
96     * @param _value 转移数额
97     */
98     function transfer(address _to, uint256 _value) public returns (bool success) {
99         // 不是零地址
100         require(_to != 0x0);
101         require(balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]);
102         balances[msg.sender] -= _value;
103         balances[_to] += _value;
104         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
105         return true;
106     }
107 
108     /**
109     * 账号之间代币交易转移
110     * @param _from 发送者地址
111     * @param _to 接收者地址
112     * @param _value 转移数额
113      */
114     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
115         uint256 allowance = allowed[_from][msg.sender];
116         //避免溢出的异常
117         require(balances[_from] >= _value && allowance >= _value && balances[_to] + _value >= balances[_to]);
118         // 不是零地址,因为0x0地址代表销毁
119         require(_to != 0x0);
120         balances[_to] += _value;
121         balances[_from] -= _value;
122         //默认totalSupply 不会超过最大值 (2^256 - 1).
123         //消息发送者可以从账户_from中转出的数量减少_value
124         if (allowance < MAX_UINT256) {
125             allowed[_from][msg.sender] -= _value;
126         }
127         //这句则只是把赠送代币的记录存下来
128         emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
129         return true;
130     }
131 
132     //返回地址是_owner的账户的账户余额
133     function balanceOf(address _owner) public view returns (uint256 balance) {
134         return balances[_owner];
135     }
136 
137     //允许_spender多次取回您的帐户，最高达_value金额。 如果再次调用此函数，它将以_value覆盖当前的余量。
138     function approve(address _spender, uint256 _value) public returns (bool success) {
139         allowed[msg.sender][_spender] = _value;
140         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
141         return true;
142     }
143 
144     //返回_spender仍然被允许从_owner提取的金额;allowance(A, B)可以查看B账户还能够调用A账户多少个token
145     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
146         return allowed[_owner][_spender];
147     }
148 }