1 pragma solidity ^0.4.20;
2 
3 //standart library for uint
4 library SafeMath { 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0 || b == 0){
7         return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15     assert(b <= a);
16     return a - b;
17   }
18 
19   function add(uint256 a, uint256 b) internal pure returns (uint256) {
20     uint256 c = a + b;
21     assert(c >= a);
22     return c;
23   }
24 
25   function pow(uint256 a, uint256 b) internal pure returns (uint256){ //power function
26     if (b == 0){
27       return 1;
28     }
29     uint256 c = a**b;
30     assert (c >= a);
31     return c;
32   }
33 }
34 
35 //standart contract to identify owner
36 contract Ownable {
37 
38   address public owner;
39 
40   address public newOwner;
41 
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47   function Ownable() public {
48     owner = msg.sender;
49   }
50 
51   function transferOwnership(address _newOwner) public onlyOwner {
52     require(_newOwner != address(0));
53     newOwner = _newOwner;
54   }
55 
56   function acceptOwnership() public {
57     if (msg.sender == newOwner) {
58       owner = newOwner;
59     }
60   }
61 }
62 
63 contract CAIDToken is Ownable { //ERC - 20 token contract
64   using SafeMath for uint;
65   // Triggered when tokens are transferred.
66   event Transfer(address indexed _from, address indexed _to, uint256 _value);
67 
68   // Triggered whenever approve(address _spender, uint256 _value) is called.
69   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
70 
71   string public constant symbol = "CAID";
72   string public constant name = "ClearAid"; //CHANGE IT
73   uint8 public constant decimals = 8;
74   uint256 _totalSupply = 100000000*(uint(10).pow(decimals));
75 
76   // Balances for each account
77   mapping(address => uint256) balances;
78 
79   // Owner of account approves the transfer of an amount to another account
80   mapping(address => mapping (address => uint256)) allowed;
81 
82   function totalSupply() public view returns (uint256) { //standart ERC-20 function
83     return _totalSupply;
84   }
85 
86   function balanceOf(address _address) public view returns (uint256 balance) {//standart ERC-20 function
87     return balances[_address];
88   }
89   
90   bool public locked = true;
91   function changeLockTransfer (bool _request) public onlyOwner {
92     locked = _request;
93   }
94   
95   //standart ERC-20 function
96   function transfer(address _to, uint256 _amount) public returns (bool success) {
97     require(this != _to);
98     require(!locked);
99     balances[msg.sender] = balances[msg.sender].sub(_amount);
100     balances[_to] = balances[_to].add(_amount);
101     emit Transfer(msg.sender,_to,_amount);
102     return true;
103   }
104 
105   //standart ERC-20 function
106   function transferFrom(address _from, address _to, uint256 _amount) public returns(bool success){
107     require(this != _to);
108     require(!locked);
109     balances[_from] = balances[_from].sub(_amount);
110     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
111     balances[_to] = balances[_to].add(_amount);
112     emit Transfer(_from,_to,_amount);
113     return true;
114   }
115   //standart ERC-20 function
116   function approve(address _spender, uint256 _amount)public returns (bool success) { 
117     allowed[msg.sender][_spender] = _amount;
118     emit Approval(msg.sender, _spender, _amount);
119     return true;
120   }
121 
122   //standart ERC-20 function
123   function allowance(address _owner, address _spender)public constant returns (uint256 remaining) {
124     return allowed[_owner][_spender];
125   }
126 
127   //Constructor
128   function CAIDToken() public {
129     owner = msg.sender;
130     balances[this] = _totalSupply;
131   }
132 
133   address public crowdsaleContract;
134 
135   function setCrowdsaleContract (address _address) public{
136     require(crowdsaleContract == address(0));
137 
138     crowdsaleContract = _address;
139   }
140 
141   function endICO () public {
142     require(msg.sender == crowdsaleContract);
143 
144     emit Transfer(this,0,balances[this]);
145     
146     _totalSupply = _totalSupply.sub(balances[this]);
147     balances[this] = 0;
148   }
149 
150     
151   function sendCrowdsaleTokens (address _address, uint _value) public {
152     require(msg.sender == crowdsaleContract);
153 
154     balances[this] = balances[this].sub(_value);
155     balances[_address] = balances[_address].add(_value);
156         
157     emit Transfer(this,_address,_value);    
158   }
159 }