1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
3 pragma solidity ^0.4.21;
4 
5 
6 contract MarianaKeyInterface {
7     /* This is a slight change to the ERC20 base standard.
8     function totalSupply() constant returns (uint256 supply);
9     is replaced with:
10     uint256 public totalSupply;
11     This automatically creates a getter function for the totalSupply.
12     This is moved to the base contract since public getter functions are not
13     currently recognised as an implementation of the matching abstract
14     function by the compiler.
15     */
16     /// total amount of tokens
17     uint256 public totalSupply;
18 
19     /// @param _owner The address from which the balance will be retrieved
20     /// @return The balance
21     function balanceOf(address _owner) public view returns (uint256 balance);
22 
23     /// @notice send `_value` token to `_to` from `msg.sender`
24     /// @param _to The address of the recipient
25     /// @param _value The amount of token to be transferred
26     /// @return Whether the transfer was successful or not
27     function transfer(address _to, uint256 _value) public returns (bool success);
28 
29     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
30     /// @param _from The address of the sender
31     /// @param _to The address of the recipient
32     /// @param _value The amount of token to be transferred
33     /// @return Whether the transfer was successful or not
34     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
35 
36     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @param _value The amount of tokens to be approved for transfer
39     /// @return Whether the approval was successful or not
40     function approve(address _spender, uint256 _value) public returns (bool success);
41 
42     /// @param _owner The address of the account owning tokens
43     /// @param _spender The address of the account able to transfer the tokens
44     /// @return Amount of remaining tokens allowed to spent
45     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
46 
47     // solhint-disable-next-line no-simple-event-func-name
48     event Transfer(address indexed _from, address indexed _to, uint256 _value);
49     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
50 }
51 contract MarianaKey is MarianaKeyInterface {
52 
53     uint256 constant private MAX_UINT256 = 2**256 - 1;
54     // 建立映射 地址对应了 uint' 便是他的余额
55     mapping (address => uint256) public balances;
56     // 存储对账号的控制
57     mapping (address => mapping (address => uint256)) public allowed;
58     /*
59     NOTE:
60     The following variables are OPTIONAL vanities. One does not have to include them.
61     They allow one to customise the token contract & in no way influences the core functionality.
62     Some wallets/interfaces might not even bother to look at this information.
63     */
64     string public name;                   //fancy name: eg Simon Bucks
65     uint8 public decimals;                //How many decimals to show.
66     string public symbol;                 //An identifier: eg SBX
67 
68     function MarianaKey (
69         uint256 _initialAmount,
70         string _tokenName,
71         uint8 _decimalUnits,
72         string _tokenSymbol
73     ) public {
74         //msg.sender是合约方法调用方的地址
75         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
76         totalSupply = _initialAmount;                        // Update total supply
77         name = _tokenName;                                   // Set the name for display purposes
78         decimals = _decimalUnits;                            // Amount of decimals for display purposes
79         symbol = _tokenSymbol;                               // Set the symbol for display purposes
80     }
81 
82     /**
83     *  代币交易转移
84     * 从创建交易者账号发送`_value`个代币到 `_to`账号
85     *
86     * @param _to 接收者地址
87     * @param _value 转移数额
88     */
89     function transfer(address _to, uint256 _value) public returns (bool success) {
90         // 不是零地址
91         require(_to != 0x0);
92         require(balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]);
93         balances[msg.sender] -= _value;
94         balances[_to] += _value;
95         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
96         return true;
97     }
98 
99     /**
100     * 账号之间代币交易转移
101     * @param _from 发送者地址
102     * @param _to 接收者地址
103     * @param _value 转移数额
104      */
105     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
106         uint256 allowance = allowed[_from][msg.sender];
107         //避免溢出的异常
108         require(balances[_from] >= _value && allowance >= _value && balances[_to] + _value >= balances[_to]);
109         // 不是零地址,因为0x0地址代表销毁
110         require(_to != 0x0);
111         balances[_to] += _value;
112         balances[_from] -= _value;
113         //默认totalSupply 不会超过最大值 (2^256 - 1).
114         //消息发送者可以从账户_from中转出的数量减少_value
115         if (allowance < MAX_UINT256) {
116             allowed[_from][msg.sender] -= _value;
117         }
118         //这句则只是把赠送代币的记录存下来
119         emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
120         return true;
121     }
122 
123     //返回地址是_owner的账户的账户余额
124     function balanceOf(address _owner) public view returns (uint256 balance) {
125         return balances[_owner];
126     }
127 
128     //允许_spender多次取回您的帐户，最高达_value金额。 如果再次调用此函数，它将以_value覆盖当前的余量。
129     function approve(address _spender, uint256 _value) public returns (bool success) {
130         allowed[msg.sender][_spender] = _value;
131         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
132         return true;
133     }
134 
135     //返回_spender仍然被允许从_owner提取的金额;allowance(A, B)可以查看B账户还能够调用A账户多少个token
136     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
137         return allowed[_owner][_spender];
138     }
139 }