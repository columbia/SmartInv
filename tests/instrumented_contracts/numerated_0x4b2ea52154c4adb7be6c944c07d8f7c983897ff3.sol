1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }  // token的 接受者 这里声明接口, 将会在我们的ABI里
4 
5 contract TokenERC20 {
6 /*********Token的属性说明************/
7     string public name;
8     string public symbol;
9     uint8 public decimals;  // 18 是建议的默认值
10     uint256 public totalSupply; // 发行量
11 
12     // 建立映射 地址对应了 uint' 便是他的余额
13     mapping (address => uint256) public balanceOf;   
14         // 地址对应余额
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     event Burn(address indexed from, uint256 value);
19 
20     // 这里是构造函数, 实例创建时候执行
21     function TokenERC20(uint256 initialSupply, string tokenName,uint8 initialDecimals, string tokenSymbol) public {
22         totalSupply = initialSupply;  // 这里确定了总发行量
23 
24         balanceOf[msg.sender] = totalSupply;    // 这里就比较重要, 这里相当于实现了, 把token 全部给合约的Creator
25 
26         name = tokenName;
27         symbol = tokenSymbol;
28         decimals = initialDecimals;
29     }
30 
31     // token的发送函数
32     function _transfer(address _from, address _to, uint _value) internal {
33 
34         require(_to != 0x0);    // 不是零地址
35         require(balanceOf[_from] >= _value);        // 有足够的余额来发送
36         require(balanceOf[_to] + _value > balanceOf[_to]);  // 这里也有意思, 不能发送负数的值(hhhh)
37 
38         uint previousBalances = balanceOf[_from] + balanceOf[_to];  // 这个是为了校验, 避免过程出错, 总量不变对吧?
39         balanceOf[_from] -= _value; //发钱 不多说
40         balanceOf[_to] += _value;
41         Transfer(_from, _to, _value);   // 这里触发了转账的事件 , 见上event
42         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);  // 判断总额是否一致, 避免过程出错
43     }
44 
45     function transfer(address _to, uint256 _value) public {
46         _transfer(msg.sender, _to, _value); // 这里已经储存了 合约创建者的信息, 这个函数是只能被合约创建者使用
47     }
48 
49     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
50         require(_value <= allowance[_from][msg.sender]);     // 这句很重要, 地址对应的合约地址(也就是token余额)
51         allowance[_from][msg.sender] -= _value;
52         _transfer(_from, _to, _value);
53         return true;
54     }
55 
56     function approve(address _spender, uint256 _value) public
57         returns (bool success) {
58         allowance[msg.sender][_spender] = _value;   // 这里是可花费总量
59         return true;
60     }
61 
62     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
63         tokenRecipient spender = tokenRecipient(_spender);
64         if (approve(_spender, _value)) {
65             spender.receiveApproval(msg.sender, _value, this, _extraData);
66             return true;
67         }
68     }
69     // 正如其名, 这个是烧币(SB)的.. ,用于后面把多token 烧掉
70     function burn(uint256 _value) public returns (bool success) {
71         require(balanceOf[msg.sender] >= _value);   // 必须要有这么多
72         balanceOf[msg.sender] -= _value;
73         totalSupply -= _value;
74         Burn(msg.sender, _value);
75         return true;
76     }
77     // 这个是用户销币
78     function burnFrom(address _from, uint256 _value) public returns (bool success) {
79         require(balanceOf[_from] >= _value);        // 一样要有这么多
80         require(_value <= allowance[_from][msg.sender]);    // 
81         balanceOf[_from] -= _value;
82         allowance[_from][msg.sender] -= _value;
83         totalSupply -= _value;
84         Burn(_from, _value);
85         return true;
86     }
87 }