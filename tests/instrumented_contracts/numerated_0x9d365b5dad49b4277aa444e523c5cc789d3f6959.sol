1 pragma solidity ^0.4.18;
2 
3 contract TheCoinBBToken {
4     //币名字
5     string public name;
6     //token 标志
7     string public symbol;
8     ////token 小数位数
9     uint public decimals;
10 
11     //转账事件通知
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 
14     // 创建一个数组存放所有用户的余额
15     mapping(address => uint256) public balanceOf;
16 
17 
18     /* Constructor */
19     function TheCoinBBToken(uint256 initialSupply,string tokenName, string tokenSymbol, uint8 decimalUnits) public {
20         //初始发币金额(总额要去除小数位数设置的长度)
21         balanceOf[msg.sender] = initialSupply;
22         name = tokenName;                                 
23         symbol = tokenSymbol;                               
24         decimals = decimalUnits; 
25     }
26 
27     //转账操作
28     function transfer(address _to,uint256 _value) public {
29         //检查转账是否满足条件 1.转出账户余额是否充足 2.转出金额是否大于0 并且是否超出限制
30         require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);
31         balanceOf[msg.sender] -= _value;
32         balanceOf[_to] += _value;
33         //转账通知
34         Transfer(msg.sender, _to, _value);
35     }
36 
37 }