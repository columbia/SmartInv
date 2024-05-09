1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 //创建一个owned合约
6 contract owned {
7 
8 				//定义一个变量"owner"，这个变量的类型是address，这是用于存储代币的管理者。
9 				//owned()类似于C++中的构造函数，功能是给owner赋值。
10         address public owner;
11 
12         function owned() {
13             owner = msg.sender;
14         }
15 
16 				//定义一个modifier(修改标志)，可以理解为函数的附属条件。
17 				//这个条件的内容是假设发送者不是owner（管理者），就跳出。起到一个身份鉴别的作用。
18         modifier onlyOwner {
19             require(msg.sender == owner);
20             _;
21         }
22 
23         //实现所有权转移
24         //定义一个transferOwnership函数，这个函数是用于转移管理者的身份。
25         //注意，transferOwnership后面跟着"onlyOwner"。所以这个函数的前提是，执行人必须是owner。
26         function transferOwnership(address newOwner) onlyOwner {
27             owner = newOwner;
28         }
29 }
30 
31 //创建一个ERC20代币
32 contract TokenERC20 is owned {
33     string public name;
34     string public symbol;
35     uint8 public decimals = 18;  // 18 是建议的默认值
36     uint256 public totalSupply;
37 
38     mapping (address => uint256) public balanceOf;  // 
39     mapping (address => mapping (address => uint256)) public allowance;
40 
41     event Transfer(address indexed from, address indexed to, uint256 value);
42 
43     event Burn(address indexed from, uint256 value);
44 
45     function TokenERC20(
46     		uint256 initialSupply, 
47     		string tokenName, 
48     		string tokenSymbol,
49     		//在TokenERC20中添加了地址变量centralMinter，这个变量是有输入位置的。
50     		address centralMinter
51     		) public {
52         totalSupply = initialSupply * 10 ** uint256(decimals);
53         balanceOf[msg.sender] = totalSupply;
54         name = tokenName;
55         symbol = tokenSymbol;
56         //if从句，只要输入地址不为0，拥有者就是发送者，所以这里输入什么都没关系。这个if从句，目前没看到有什么用处。
57         if(centralMinter != 0 ) owner = centralMinter;
58     }
59     
60     //代币增发
61     //代码解释:
62 		//第2句代码给指定目标增加代币数量；
63 		//第3句代码给代币总量增加相应的数目；
64 		//第4句和第5句代码的意义只是提醒客户端发生了这样的交易。
65 		function mintToken(address target, uint256 mintedAmount) onlyOwner {
66         balanceOf[target] += mintedAmount;
67         totalSupply += mintedAmount;
68         Transfer(0, owner, mintedAmount);
69         Transfer(owner, target, mintedAmount);
70 		}
71 
72     function _transfer(address _from, address _to, uint _value) internal {
73         require(_to != 0x0);
74         require(balanceOf[_from] >= _value);
75         require(balanceOf[_to] + _value > balanceOf[_to]);
76         uint previousBalances = balanceOf[_from] + balanceOf[_to];
77         balanceOf[_from] -= _value;
78         balanceOf[_to] += _value;
79         Transfer(_from, _to, _value);
80         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
81     }
82 
83     function transfer(address _to, uint256 _value) public {
84         _transfer(msg.sender, _to, _value);
85     }
86 
87     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
88         require(_value <= allowance[_from][msg.sender]);     // Check allowance
89         allowance[_from][msg.sender] -= _value;
90         _transfer(_from, _to, _value);
91         return true;
92     }
93 
94     function approve(address _spender, uint256 _value) public
95         returns (bool success) {
96         allowance[msg.sender][_spender] = _value;
97         return true;
98     }
99 
100     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
101         tokenRecipient spender = tokenRecipient(_spender);
102         if (approve(_spender, _value)) {
103             spender.receiveApproval(msg.sender, _value, this, _extraData);
104             return true;
105         }
106     }
107 
108     function burn(uint256 _value) public returns (bool success) {
109         require(balanceOf[msg.sender] >= _value);
110         balanceOf[msg.sender] -= _value;
111         totalSupply -= _value;
112         Burn(msg.sender, _value);
113         return true;
114     }
115 
116     function burnFrom(address _from, uint256 _value) public returns (bool success) {
117         require(balanceOf[_from] >= _value);
118         require(_value <= allowance[_from][msg.sender]);
119         balanceOf[_from] -= _value;
120         allowance[_from][msg.sender] -= _value;
121         totalSupply -= _value;
122         Burn(_from, _value);
123         return true;
124     }
125 }