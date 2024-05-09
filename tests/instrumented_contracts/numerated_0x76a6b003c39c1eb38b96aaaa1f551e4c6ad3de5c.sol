1 pragma solidity ^0.5.8;
2 
3 contract ERC20_Coin{
4     
5     string public name;//名称
6     string public symbol;//缩写
7     uint8 public decimals = 18;//精确的小数位数
8     uint256 public totalSupply;//总发行量
9     address internal admin;//管理员
10     mapping (address => uint256) public balanceOf;//客户群体
11     bool public isAct = true;//合约活动标记
12     bool public openRaise = false;//开启募集资金功能
13     uint256 public raisePrice = 0;//募集兑换比例
14     address payable internal finance;//财务管理
15     
16     //转账通知
17 	event Transfer(address indexed from, address indexed to, uint256 value);
18 	//以太转出通知
19 	event SendEth(address indexed to, uint256 value);
20     
21     constructor(
22         uint256 initialSupply,//发行量
23         string memory tokenName,//名称
24         string memory tokenSymbol//缩写
25      ) public {
26         totalSupply = initialSupply * 10 ** uint256(decimals);
27         balanceOf[msg.sender] = totalSupply;
28         name = tokenName;
29         symbol = tokenSymbol;
30         finance = msg.sender;
31         admin = msg.sender;
32     }
33 
34     // 只有管理员能调用的
35     modifier onlyAdmin() { 
36         require(msg.sender == admin);
37         _;
38     }
39 
40     // 判断合约是否暂停服务
41     modifier isActivity() { 
42         require(isAct);
43         _;
44     }
45 
46     // 是否处于募集资金状态
47     modifier isOpenRaise() { 
48         require(openRaise);
49         _;
50     }
51 
52     //只有在活动中并且开启了募集标记才会接收ETH
53     function () external payable isActivity isOpenRaise{
54 		require(raisePrice >= 0);
55 		uint256 buyNum = msg.value /10000 * raisePrice;
56 		require(buyNum <= balanceOf[finance]);
57 		balanceOf[finance] -= buyNum;
58 		balanceOf[msg.sender] += buyNum;
59         finance.transfer(msg.value);
60         emit SendEth(finance, msg.value);
61         emit Transfer(finance, msg.sender, buyNum);
62 	}
63     
64     //普通的转账功能，只判断活动状态
65     //可以在各种第三方钱包调用，如：imtoken、MetaMask
66     function transfer(address _to, uint256 _value) public isActivity{
67 	    _transfer(msg.sender, _to, _value);
68     }
69     
70     //出纳转账，批量操作
71     function transferList(address[] memory _tos, uint[] memory _values) public isActivity {
72         require(_tos.length == _values.length);
73         uint256 _total = 0;
74         for(uint256 i;i<_values.length;i++){
75             _total += _values[i];
76 	    }
77         require(balanceOf[msg.sender]>=_total);
78         for(uint256 i;i<_tos.length;i++){
79             _transfer(msg.sender,_tos[i],_values[i]);
80 	    }
81     }
82     
83     //内部转账封装
84     function _transfer(address _from, address _to, uint _value) internal {
85         require(_to != address(0));
86         require(balanceOf[_from] >= _value);
87         require(balanceOf[_to] + _value >= balanceOf[_to]);
88         uint previousBalances = balanceOf[_from] + balanceOf[_to];
89         balanceOf[_from] -= _value;
90         balanceOf[_to] += _value;
91         emit Transfer(_from, _to, _value);
92         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
93     }
94 	
95     //设置募集资金的兑换比例
96 	function setRaisePrice(uint256 _price)public onlyAdmin{
97 		raisePrice = _price;
98 	}
99 	
100     //开启募集通道，做预留，默认都是关闭的
101 	function setOpenRaise(bool _open) public onlyAdmin{
102 	    openRaise = _open;
103 	}
104 	
105     //设置活动状态，处理应急状况
106 	function setActivity(bool _isAct) public onlyAdmin{
107 		isAct = _isAct;
108 	}
109 	
110     //转让管理员权限
111 	function setAdmin(address _address) public onlyAdmin{
112        admin = _address;
113     }
114     
115     //设置资金管理员
116     function setMagage(address payable _address) public onlyAdmin{
117        finance = _address;
118     }
119 	
120     //销毁合约
121 	function killYourself()public onlyAdmin{
122 		selfdestruct(finance);
123 	}
124 	
125 }