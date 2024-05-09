1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract TokenERC20 {
6     // 本token的公共变量
7     string public name;
8     string public symbol;
9     uint8 public decimals = 18;
10     // 18位小数点，尽量不修改
11     uint256 public totalSupply;
12 
13     // 余额数组
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance; //2维数组限额
16 
17     //Token转移事件 This generates a public event on the blockchain that will notify clients
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     // 蒸发某个账户的token This notifies clients about the amount burnt
21     event Burn(address indexed from, uint256 value);
22 
23     /**
24      * Constructor function
25      *
26      * 初始化 合约 Initializes contract with initial supply tokens to the creator of the contract
27      */
28     function TokenERC20(
29         uint256 initialSupply,
30         string tokenName,
31         string tokenSymbol
32     ) public {
33         totalSupply = initialSupply * 10 ** uint256(decimals);  // 小数变整数 乘18个0   Update total supply with the decimal amount
34         balanceOf[msg.sender] = totalSupply;                // 初始token数量 Give the creator all initial tokens
35         name = tokenName;                                   // 设置token名称  Set the name for display purposes
36         symbol = tokenSymbol;                               // 设置token符号 Set the symbol for display purposes
37     }
38 
39     /**
40      * 赠送货币 Internal transfer, only can be called by this contract
41  	付款地址，收款地址，数量
42      */
43     function _transfer(address _from, address _to, uint _value) internal {
44         // 确定收款地址存在  Prevent transfer to 0x0 address. Use burn() instead
45         require(_to != 0x0);
46         // 检查付款地址是否有足够的余额 Check if the sender has enough
47         require(balanceOf[_from] >= _value);
48         //检查收款地址收到的金额是否是负数  Check for overflows
49         require(balanceOf[_to] + _value >= balanceOf[_to]);
50         //收款地址和付款地址的总额  Save this for an assertion in the future
51         uint previousBalances = balanceOf[_from] + balanceOf[_to];
52         // 付款地址中的余额-付款金额  Subtract from the sender
53         balanceOf[_from] -= _value;
54         // 收款地址中的余额+付款金额 Add the same to the recipient
55         balanceOf[_to] += _value;
56         emit Transfer(_from, _to, _value);
57         // 判断付款行为后两个账户的总额是否发生变化   Asserts are used to use static analysis to find bugs in your code. They should never fail
58         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
59     }
60 
61     /**
62      * Transfer tokens
63      *从当前账户向其他账户发送token
64      * Send `_value` tokens to `_to` from your account
65      *
66      * @param _to The address of the recipient
67      * @param _value the amount to send
68      */
69     function transfer(address _to, uint256 _value) public {
70         _transfer(msg.sender, _to, _value);
71     }
72 
73     /**
74      * Transfer tokens from other address
75      *
76      * Send `_value` tokens to `_to` on behalf of `_from`
77      *
78      * @param _from The address of the sender
79      * @param _to The address of the recipient
80      * @param _value the amount to send
81      */
82     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
83         require(_value <= allowance[_from][msg.sender]);     // 检查限额 Check allowance
84         allowance[_from][msg.sender] -= _value;  //减少相应的限额
85         _transfer(_from, _to, _value);  //调用调用交易，完成交易
86         return true;
87     }
88 
89     /**
90      * 设置账户限额  Set allowance for other address
91      *
92      * Allows `_spender` to spend no more than `_value` tokens on your behalf
93      *
94      * @param _spender The address authorized to spend
95      * @param _value the max amount they can spend
96      */
97     function approve(address _spender, uint256 _value) public
98         returns (bool success) {
99         allowance[msg.sender][_spender] = _value;
100         return true;
101     }
102 
103     /**
104      * 设置其他账户限额 Set allowance for other address and notify
105      *
106      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
107      *
108      * @param _spender The address authorized to spend
109      * @param _value the max amount they can spend
110      * @param _extraData some extra information to send to the approved contract
111      */
112     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
113         public
114         returns (bool success) {
115         tokenRecipient spender = tokenRecipient(_spender);
116         if (approve(_spender, _value)) {
117             spender.receiveApproval(msg.sender, _value, this, _extraData);
118             return true;
119         }
120     }
121 
122     /**
123      * Destroy tokens
124      *蒸发自己的token
125      * Remove `_value` tokens from the system irreversibly
126      *
127      * @param _value the amount of money to burn
128      */
129     function burn(uint256 _value) public returns (bool success) {
130         require(balanceOf[msg.sender] >= _value);   //判断使用者的余额是否充足 Check if the sender has enough
131         balanceOf[msg.sender] -= _value;            //减掉token Subtract from the sender
132         totalSupply -= _value;                      //减掉总taoken数 Updates totalSupply
133         emit Burn(msg.sender, _value);              //触发Burn事件
134         return true;
135     }
136 
137     /**
138      * Destroy tokens from other account
139      *蒸发别人的token
140      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
141      *
142      * @param _from the address of the sender
143      * @param _value the amount of money to burn
144      */
145     function burnFrom(address _from, uint256 _value) public returns (bool success) {
146         require(balanceOf[_from] >= _value);                // 检查别人的余额是否充足  Check if the targeted balance is enough
147         require(_value <= allowance[_from][msg.sender]);    // 检查限额是否充足 Check allowance
148         balanceOf[_from] -= _value;                         // 蒸发token Subtract from the targeted balance
149         allowance[_from][msg.sender] -= _value;             // 去除限额 Subtract from the sender's allowance
150         totalSupply -= _value;                              // 减掉总taoken数Update totalSupply
151         emit Burn(_from, _value);			    //触发Burn事件
152         return true;
153     }
154 }
155 
156 contract owned {
157     address public owner;
158 
159     function owned() public {
160         owner = msg.sender;
161     }
162 
163     modifier onlyOwner {
164         require(msg.sender == owner);
165         _;
166     }
167 
168     function transferOwnership(address newOwner) onlyOwner public {
169         owner = newOwner;
170     }
171 }
172 
173 
174  contract mcs is owned, TokenERC20{
175 
176     bool public freeze=true;
177 
178     function mcs() TokenERC20(600000000, "Magicstonelink", "MCS") public {}
179 
180     function _transfer(address _from, address _to, uint _value) internal {
181         require (freeze);
182         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
183         require (balanceOf[_from] >= _value);               // Check if the sender has enough
184         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
185 	    uint previousBalances = balanceOf[_from] + balanceOf[_to];
186         // 付款地址中的余额-付款金额  Subtract from the sender
187         balanceOf[_from] -= _value;                         // Subtract from the sender
188         balanceOf[_to] += _value;                           // Add the same to the recipient
189         emit Transfer(_from, _to, _value);
190         // 判断付款行为后两个账户的总额是否发生变化   Asserts are used to use static analysis to find bugs in your code. They should never fail
191         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
192     }
193 
194     function setfreeze(bool state) onlyOwner public{
195         freeze=state;
196     }
197  }