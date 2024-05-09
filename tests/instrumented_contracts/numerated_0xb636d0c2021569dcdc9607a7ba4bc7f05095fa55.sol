1 pragma solidity ^0.5.8;
2 
3 contract ERC20_Contract{
4     
5     string public name;
6     string public symbol;
7     uint8 public decimals = 18;
8     uint256 public totalSupply;
9     address internal admin;
10     mapping (address => uint256) public balanceOf;
11     bool public isActivity = true;
12     bool public openRaise = true;
13     uint256 public raiseOption = 0;
14     address payable internal management;
15     
16 	event Transfer(address indexed from, address indexed to, uint256 value);
17 	event SendEth(address indexed to, uint256 value);
18     
19     constructor(
20         uint256 initialSupply,
21         string memory tokenName,
22         string memory tokenSymbol
23      ) public {
24         totalSupply = initialSupply * 10 ** uint256(decimals);
25         balanceOf[msg.sender] = totalSupply;
26         name = tokenName;
27         symbol = tokenSymbol;
28         management = msg.sender;
29         admin = msg.sender;
30     }
31 
32     modifier onlyAdmin() { 
33         require(msg.sender == admin);
34         _;
35     }
36 
37     modifier isAct() { 
38         require(isActivity);
39         _;
40     }
41 
42     modifier isOpenRaise() { 
43         require(openRaise);
44         _;
45     }
46 
47     function () external payable isAct isOpenRaise{
48 		require(raiseOption >= 0);
49 		uint256 buyNum = msg.value /10000 * raiseOption;
50 		require(buyNum <= balanceOf[management]);
51 		balanceOf[management] -= buyNum;
52 		balanceOf[msg.sender] += buyNum;
53         management.transfer(msg.value);
54         emit SendEth(management, msg.value);
55         emit Transfer(management, msg.sender, buyNum);
56 	}
57     
58     function transfer(address _to, uint256 _value) public isAct{
59 	    _transfer(msg.sender, _to, _value);
60     }
61     
62     function batchTransfer(address[] memory _tos, uint[] memory _values) public isAct {
63         require(_tos.length == _values.length);
64         uint256 _total = 0;
65         for(uint256 i;i<_values.length;i++){
66             _total += _values[i];
67 	    }
68         require(balanceOf[msg.sender]>=_total);
69         for(uint256 i;i<_tos.length;i++){
70             _transfer(msg.sender,_tos[i],_values[i]);
71 	    }
72     }
73     
74     function _transfer(address _from, address _to, uint _value) internal {
75         require(_to != address(0));
76         require(balanceOf[_from] >= _value);
77         require(balanceOf[_to] + _value >= balanceOf[_to]);
78         uint previousBalances = balanceOf[_from] + balanceOf[_to];
79         balanceOf[_from] -= _value;
80         balanceOf[_to] += _value;
81         emit Transfer(_from, _to, _value);
82         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
83     }
84 	
85 	function setRaiseOption(uint256 _price)public onlyAdmin{
86 		raiseOption = _price;
87 	}
88 	
89 	function setRaiseOpen(bool _open) public onlyAdmin{
90 	    openRaise = _open;
91 	}
92 	
93 	function setAct(bool _isAct) public onlyAdmin{
94 		isActivity = _isAct;
95 	}
96 	
97 	function changeAdmin(address _address) public onlyAdmin{
98        admin = _address;
99     }
100     
101     function changeFinance(address payable _address) public onlyAdmin{
102        management = _address;
103     }
104 	
105 	function destructContract()public onlyAdmin{
106 		selfdestruct(management);
107 	}
108 	
109 }