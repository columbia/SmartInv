1 pragma solidity ^0.4.13; 
2 
3 contract owned {
4     address public owner;
5     function owned() {
6         owner = msg.sender;
7     }
8     modifier onlyOwner {
9         require(msg.sender == owner);
10         _;
11     }
12     /* 管理者的权限可以转移 */
13     function transferOwnership(address newOwner) onlyOwner {
14         owner = newOwner;
15     }
16   }
17 contract tokenRecipient {
18      function receiveApproval(address from, uint256 value, address token, bytes extraData); 
19 }
20 contract token {
21     /*Public variables of the token */
22     string public name; string public symbol; uint8 public decimals; uint256 public totalSupply;
23     /* This creates an array with all balances */
24     mapping (address => uint256) public balanceOf;
25     mapping (address => mapping (address => uint256)) public allowance;
26     /* This generates a public event on the blockchain that will notify clients */
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     /* This notifies clients about the amount burnt */
29     event Burn(address indexed from, uint256 value);
30     /* Initializes contract with initial supply tokens to the creator of the contract */
31     function token() {
32     balanceOf[msg.sender] = 10000000000000000; // 给创建者所有初始令牌
33     totalSupply = 10000000000000000; // 更新总量
34     name = "BBC"; // 设置显示的名称
35     symbol =  "฿"; // 为显示设置符号
36     decimals = 8; // 显示的小数量
37     }
38     /* Internal transfer, only can be called by this contract */
39     function _transfer(address _from, address _to, uint _value) internal {
40         require (_to != 0x0); // 防止转移到0x0地址. Use burn() instead
41         require (balanceOf[_from] > _value); // 检测余额是否足够
42         require (balanceOf[_to] + _value > balanceOf[_to]); // 检查溢出
43         balanceOf[_from] -= _value; // 从发件人中减去
44         balanceOf[_to] += _value; // 给收件人添加
45         Transfer(_from, _to, _value);
46     }
47     /// @notice Send `_value` tokens to `_to` from your account
48     /// @param _to The address of the recipient
49     /// @param _value the amount to send
50     function transfer(address _to, uint256 _value) {
51         _transfer(msg.sender, _to, _value);
52     }
53     /// @notice Send `_value` tokens to `_to` in behalf of `_from`
54     /// @param _from The address of the sender
55     /// @param _to The address of the recipient
56     /// @param _value the amount to send
57     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
58         require (_value < allowance[_from][msg.sender]); // 检测手续费
59         allowance[_from][msg.sender] -= _value;
60         _transfer(_from, _to, _value);
61         return true;
62     }
63     ///让另一个合同，为你花一些令牌
64     function approve(address _spender, uint256 _value)
65         returns (bool success) {
66         allowance[msg.sender][_spender] = _value;
67         return true;
68     }
69     ///批准并在一个TX中传递批准的合同
70     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
71         returns (bool success) {
72         tokenRecipient spender = tokenRecipient(_spender);
73         if (approve(_spender, _value)) {
74         spender.receiveApproval(msg.sender, _value, this, _extraData);
75         return true;
76         }
77     }
78     /// @notice Remove `_value` tokens from the system irreversibly
79     /// @param _value the amount of money to burn
80     function burn(uint256 _value) returns (bool success) {
81         require (balanceOf[msg.sender] > _value); // Check if the sender has enough
82         balanceOf[msg.sender] -= _value; // Subtract from the sender
83         totalSupply -= _value; // Updates totalSupply
84         Burn(msg.sender, _value);
85         return true;
86     }
87 
88     function burnFrom(address _from, uint256 _value) returns (bool success) {
89         require(balanceOf[_from] >= _value); // Check if the targeted balance is enough
90         require(_value <= allowance[_from][msg.sender]); // Check allowance
91         balanceOf[_from] -= _value; // Subtract from the targeted balance
92         allowance[_from][msg.sender] -= _value; // Subtract from the sender's allowance
93         totalSupply -= _value; // Update totalSupply
94         Burn(_from, _value);
95         return true;
96       }
97    }
98 
99 contract MyAdvancedToken is owned, token {
100     mapping (address => bool) public frozenAccount;
101     /* This generates a public event on the blockchain that will notify clients */
102     event FrozenFunds(address target, bool frozen);
103     /* 初始化合约 */
104     function MyAdvancedToken() token () {}
105     /* 代币转移 */
106     function _transfer(address _from, address _to, uint _value) internal {
107         require (_to != 0x0); // 防止转移到0x0地址
108         // 发送方和接收方应该不同
109         require(msg.sender != _to);
110         require (balanceOf[_from] > _value); // Check if the sender has enough
111         require (balanceOf[_to] + _value > balanceOf[_to]); // 检查溢出    
112         require(!frozenAccount[_from]); // Check if sender is frozen
113         require(!frozenAccount[_to]); // Check if recipient is frozen
114         balanceOf[_from] -= _value; // Subtract from the sender
115         balanceOf[_to] += _value; // Add the same to the recipient
116         Transfer(_from, _to, _value);
117     }
118     /* 冻结账户 */
119     function freezeAccount(address target, bool freeze) onlyOwner {
120         frozenAccount[target] = freeze;
121         FrozenFunds(target, freeze);
122     }
123     }