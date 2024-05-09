1 pragma solidity ^0.4.16;
2 
3 contract TargetHit {
4     string public name = "Target Hit";      //  token name
5     string public symbol = "TGH";           //  token symbol
6     string public version = "1";
7     uint256 public decimals = 8;            //  token digit
8 
9     mapping (address => uint256) public balanceOf;
10     mapping (address => mapping (address => uint256)) public allowance;
11 
12     uint256 public totalSupply = 33333333300000000;
13 
14     bool public stopped = true;
15 
16     uint256 public price = 30000300003000;
17     //000 000 000 000 000 000
18 
19     address owner = 0x98E030f942F79AE61010BcBC414e7e7b945DcA33;
20     address devteam = 0xc878b604C35dd3fb5cdDA1Ff1a019568e2A0d1c5;
21 
22     modifier isOwner {
23         assert(owner == msg.sender);
24         _;
25     }
26 
27     modifier isRunning {
28         assert (!stopped);
29         _;
30     }
31 
32     modifier validAddress {
33         assert(0x0 != msg.sender);
34         _;
35     }
36 
37     constructor () public {
38         uint256 Supply = totalSupply * 33 / 100;
39         balanceOf[devteam] = Supply;
40         emit Transfer(0x0, devteam, Supply);
41         Supply = totalSupply - Supply;
42         balanceOf[owner] = Supply;
43         emit Transfer(0x0, owner, Supply);
44     }
45 
46     function changeOwner(address _newaddress) isOwner public {
47         owner = _newaddress;
48     }
49 
50     function setPrices(uint256 newPrice) isOwner public {
51         price = newPrice;
52     }
53 
54     function buy() public payable returns (uint amount){
55         require(stopped == false);
56         amount = msg.value / price;                    // calculates the amount
57         require(balanceOf[owner] >= amount);               // checks if it has enough to sell
58         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
59         balanceOf[owner] -= amount;                        // subtracts amount from seller's balance
60         owner.transfer(msg.value);
61         emit Transfer(owner, msg.sender, amount);               // execute an event reflecting the change
62         return amount;                                    // ends function and returns
63     }
64 
65 
66     function GetPrice() public view returns (uint256) {
67       return price;
68     }
69 
70     function deployTokens (uint256[] _amounts, address[] _recipient) public isOwner {
71         for(uint i = 0; i< _recipient.length; i++)
72         {
73             if (_amounts[i] > 0) {
74               if (transferfromOwner(_recipient[i], _amounts[i])){
75                 totalSupply = totalSupply - _amounts[i];
76               }
77             }
78         }
79     }
80 
81     function transferfromOwner(address _to, uint256 _value) private returns (bool success) {
82         require(balanceOf[owner] >= _value);
83         require(balanceOf[_to] + _value >= balanceOf[_to]);
84         balanceOf[owner] -= _value;
85         balanceOf[_to] += _value;
86         emit Transfer(owner, _to, _value);
87         return true;
88     }
89 
90     function transfer(address _to, uint256 _value) public returns (bool success) {
91         require(balanceOf[msg.sender] >= _value);
92         require(balanceOf[_to] + _value >= balanceOf[_to]);
93         balanceOf[msg.sender] -= _value;
94         balanceOf[_to] += _value;
95         emit Transfer(msg.sender, _to, _value);
96         return true;
97     }
98 
99 
100     function approve(address _spender, uint256 _value) public returns (bool success) {
101         require(_value == 0 || allowance[msg.sender][_spender] == 0);
102         allowance[msg.sender][_spender] = _value;
103         emit Approval(msg.sender, _spender, _value);
104         return true;
105     }
106 
107     function stop() public isOwner {
108         stopped = true;
109     }
110 
111     function start() public isOwner {
112         stopped = false;
113     }
114 
115     event Transfer(address indexed _from, address indexed _to, uint256 _value);
116     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
117 }