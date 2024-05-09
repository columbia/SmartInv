1 pragma solidity ^0.4.20;
2 library SafeMath { //standard library for uint
3   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
4     if (a == 0 || b == 0){
5         return 0;
6     }
7     uint256 c = a * b;
8     assert(c / a == b);
9     return c;
10   }
11   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12     assert(b <= a);
13     return a - b;
14   }
15   function add(uint256 a, uint256 b) internal pure returns (uint256) {
16     uint256 c = a + b;
17     assert(c >= a);
18     return c;
19   }
20   function pow(uint256 a, uint256 b) internal pure returns (uint256){ //power function
21     if (b == 0){
22       return 1;
23     }
24     uint256 c = a**b;
25     assert (c >= a);
26     return c;
27   }
28 }
29 
30 contract HeliosToken { //ERC - 20 token contract
31   using SafeMath for uint;
32 
33   // Triggered when tokens are transferred.
34   event Transfer(address indexed _from, address indexed _to, uint256 _value);
35 
36   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37 
38 
39   string public constant symbol = "HLC";
40   string public constant name = "Helios";
41 
42   uint8 public constant decimals = 2;
43   uint256 _totalSupply = uint(5000000).mul(uint(10).pow(decimals));
44 
45   function HeliosToken () public {
46     balances[address(this)] = _totalSupply;
47   }
48   
49   mapping(address => uint256) balances;
50 
51   // Owner of account approves the transfer of an amount to another account
52   mapping(address => mapping (address => uint256)) allowed;
53 
54   function totalSupply() public view returns (uint256) { //standart ERC-20 function
55     return _totalSupply;
56   }
57 
58   function balanceOf(address _address) public view returns (uint256 balance) {//standart ERC-20 function
59     return balances[_address];
60   }
61 
62   //standart ERC-20 function
63   function transfer(address _to, uint256 _amount) public returns (bool success) {
64     require(address(this) != _to && _to != address(0));
65     balances[msg.sender] = balances[msg.sender].sub(_amount);
66     balances[_to] = balances[_to].add(_amount);
67     emit Transfer(msg.sender,_to,_amount);
68     return true;
69   }
70   
71   address public crowdsaleContract;
72 
73   //connect to crowdsaleContract, can be use once
74   function setCrowdsaleContract (address _address) public{
75     require(crowdsaleContract == address(0));
76     crowdsaleContract = _address;
77   }
78 
79   uint public crowdsaleTokens = uint(4126213).mul(uint(10).pow(decimals)); //_totalSupply - distributing
80 
81   function sendCrowdsaleTokens (address _address, uint _value) public {
82     require (msg.sender == crowdsaleContract);
83     crowdsaleTokens = crowdsaleTokens.sub(_value);
84     balances[address(this)] = balances[address(this)].sub(_value);
85     balances[_address] = balances[_address].add(_value);
86     emit Transfer(address(this),_address,_value); 
87   }
88 
89   function transferFrom(address _from, address _to, uint256 _amount) public returns(bool success){
90     require(address(this) != _to && _to != address(0));
91     balances[_from] = balances[_from].sub(_amount);
92     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
93     balances[_to] = balances[_to].add(_amount);
94     emit Transfer(_from,_to,_amount);
95     return true;
96   }
97 
98   //standart ERC-20 function
99   function approve(address _spender, uint256 _amount)public returns (bool success) { 
100     allowed[msg.sender][_spender] = _amount;
101     emit Approval(msg.sender, _spender, _amount);
102     return true;
103   }
104 
105   //standart ERC-20 function
106   function allowance(address _owner, address _spender)public constant returns (uint256 remaining) {
107     return allowed[_owner][_spender];
108   }
109 
110   address public teamAddress = 0x1367eC0f6f5DEFda7B0f1b7AD234900E23Ee62CF;
111   uint public teamDistribute = uint(500000).mul(uint(10).pow(decimals));
112   address public reserveAddress = 0xD598350D4D55f72dAb1286Ed0A3a3b7F1A7A54Ce;
113   uint public reserveDistribute = uint(250000).mul(uint(10).pow(decimals));
114   address public bountyAddress = 0xcBfA29FBe59C83A1130b4957bD41847a2837782E;
115 
116   function endIco() public {  
117     require (msg.sender == crowdsaleContract);
118     require (balances[address(this)] != 0);
119     
120     uint tokensSold = _totalSupply.sub(crowdsaleTokens);
121 
122     balances[teamAddress] = balances[teamAddress].add(teamDistribute);
123     balances[reserveAddress] = balances[reserveAddress].add(reserveDistribute);
124     balances[bountyAddress] = balances[bountyAddress].add(tokensSold*3/100);
125 
126     emit Transfer(address(this), teamAddress, teamDistribute);
127     emit Transfer(address(this), reserveAddress, reserveDistribute);
128     emit Transfer(address(this), bountyAddress, tokensSold*3/100);
129 
130     uint buffer = tokensSold*3/100 + teamDistribute + reserveDistribute;
131 
132     emit Transfer(address(this), 0, balances[address(this)].sub(buffer));
133     balances[address(this)] = 0;
134   }
135 }