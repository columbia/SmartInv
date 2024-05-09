1 pragma solidity 0.4.18;
2 /**
3  * 一个简单的代币合约。
4  */
5  contract FAMELINK{
6 
7      string public name; //代币名称
8      string public symbol; //代币符号比如'$'
9      uint8 public decimals = 18;  //代币单位，展示的小数点后面多少个0,和以太币一样后面是是18个0
10      uint256 public totalSupply; //代币总量
11      /* This creates an array with all balances */
12      mapping (address => uint256) public balanceOf;
13 
14      event Transfer(address indexed from, address indexed to, uint256 value);  //转帐通知事件
15 
16 
17      /* 初始化合约，并且把初始的所有代币都给这合约的创建者
18       * @param _owned 合约的管理者
19       * @param tokenName 代币名称
20       * @param tokenSymbol 代币符号
21       */
22      function FAMELINK(uint256 initialSupply,address _owned, string tokenName, string tokenSymbol) public{
23           totalSupply = initialSupply * 10 ** uint256(decimals);  // 用小数位来初始化总量
24          //合约的管理者获得的代币总量
25          balanceOf[_owned] = totalSupply;
26          name = tokenName;
27          symbol = tokenSymbol;
28 
29      }
30      
31 
32      /**
33       * 转帐，具体可以根据自己的需求来实现
34       * @param  _to address 接受代币的地址
35       * @param  _value uint256 接受代币的数量
36       */
37      function transfer(address _to, uint256 _value) public{
38        //从发送者减掉发送额
39        balanceOf[msg.sender] -= _value;
40 
41        //给接收者加上相同的量
42        balanceOf[_to] += _value;
43 
44        //通知任何监听该交易的客户端
45        Transfer(msg.sender, _to, _value);
46      }
47 
48 
49   }