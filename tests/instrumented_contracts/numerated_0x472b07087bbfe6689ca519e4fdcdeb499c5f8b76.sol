1 pragma solidity ^0.4.16;
2 
3 contract Ownable {
4     
5     address public owner;
6     
7     function Ownable() public { 
8         owner = msg.sender;
9     }
10  
11     modifier onlyOwner() { 
12         require(msg.sender == owner);
13         _;
14     }
15  
16     function transferOwnership(address _owner) public onlyOwner { 
17         owner = _owner;
18     }
19     
20 }
21 
22 contract RobotCoin is Ownable{
23     
24   modifier onlySaleAgent() { 
25     require(msg.sender == saleAgent);
26     _;
27   }
28     
29   modifier onlyMasters() { 
30     require(msg.sender == saleAgent || msg.sender == owner);
31     _;
32   }
33 
34   string public name; 
35   string public symbol; 
36   uint8 public decimals; 
37      
38   uint256 private tokenTotalSupply;
39   address private tokenHolder;
40   bool public usersCanTransfer;
41   
42   address public saleAgent; 
43   
44   mapping (address => uint256) private  balances;
45   mapping (address => mapping (address => uint256)) private allowed; 
46   
47   event Transfer(address indexed _from, address indexed _to, uint256 _value);  
48   event Approval(address indexed _owner, address indexed _spender, uint256 _value); 
49 
50   function RobotCoin () public {
51     name = "RobotCoin"; 
52     symbol = "RBC"; 
53     decimals = 3; 
54     
55     tokenHolder = owner;
56         
57     tokenTotalSupply = 500000000000; 
58     balances[this] = 250000000000;
59     balances[tokenHolder] = 250000000000;
60     
61     usersCanTransfer = true;
62   }
63 
64   function totalSupply() public constant returns (uint256 _totalSupply){ 
65     return tokenTotalSupply;
66     }
67    
68   function setTransferAbility(bool _usersCanTransfer) public onlyMasters{
69     usersCanTransfer = _usersCanTransfer;
70   }
71   
72   function setSaleAgent(address newSaleAgnet) public onlyMasters{ 
73     saleAgent = newSaleAgnet;
74   }
75   
76   function balanceOf(address _owner) public constant returns (uint balance) { 
77     return balances[_owner];
78   }
79 
80   function allowance(address _owner, address _spender) public constant returns (uint256 remaining){ 
81     return allowed[_owner][_spender];
82   }
83   
84   function approve(address _spender, uint256 _value) public returns (bool success){  
85     allowed[msg.sender][_spender] += _value;
86     Approval(msg.sender, _spender, _value);
87     return true;
88   }
89   
90   function _transfer(address _from, address _to, uint256 _value) internal returns (bool){ 
91     require (_to != 0x0); 
92     require(balances[_from] >= _value); 
93     require(balances[_to] + _value >= balances[_to]); 
94 
95     balances[_from] -= _value; 
96     balances[_to] += _value;
97 
98     Transfer(_from, _to, _value);
99     return true;
100   }
101 
102   function transfer(address _to, uint256 _value) public returns (bool success) { 
103     require(usersCanTransfer || (msg.sender == owner));
104     return _transfer(msg.sender, _to, _value);
105   }
106 
107   function serviceTransfer(address _to, uint256 _value) public onlySaleAgent returns (bool success) { 
108     return _transfer(this, _to, _value);
109   }
110 
111   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {   
112     require(usersCanTransfer);
113     require(_value <= allowed[_from][_to]);
114     allowed[_from][_to] -= _value;  
115     return _transfer(_from, _to, _value); 
116   }
117   
118   function transferEther(uint256 etherAmmount) public onlyOwner{ 
119     require(this.balance >= etherAmmount); 
120     owner.transfer(etherAmmount); 
121   }
122 }