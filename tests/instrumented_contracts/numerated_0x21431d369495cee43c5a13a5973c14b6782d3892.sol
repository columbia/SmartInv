1 pragma solidity ^0.4.19;
2 
3 library SafeMath { //standard library for uint
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0 || b == 0){
6         return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14     assert(b <= a);
15     return a - b;
16   }
17 
18   function add(uint256 a, uint256 b) internal pure returns (uint256) {
19     uint256 c = a + b;
20     assert(c >= a);
21     return c;
22   }
23 
24   function pow(uint256 a, uint256 b) internal pure returns (uint256){ //power function
25     if (b == 0){
26       return 1;
27     }
28     uint256 c = a**b;
29     assert (c >= a);
30     return c;
31   }
32 }
33 
34 contract Ownable { //standard contract to identify owner
35 
36   address public owner;
37 
38   address public newOwner;
39 
40   modifier onlyOwner() {
41     require(msg.sender == owner);
42     _;
43   }
44 
45   function Ownable() public {
46     owner = msg.sender;
47   }
48 
49   function transferOwnership(address _newOwner) public onlyOwner {
50     require(_newOwner != address(0));
51     newOwner = _newOwner;
52   }
53 
54   function acceptOwnership() public {
55     if (msg.sender == newOwner) {
56       owner = newOwner;
57     }
58   }
59 }
60 
61 contract BineuroToken is Ownable { //ERC - 20 token contract
62   using SafeMath for uint;
63   // Triggered when tokens are transferred.
64   event Transfer(address indexed _from, address indexed _to, uint256 _value);
65 
66   // Triggered whenever approve(address _spender, uint256 _value) is called.
67   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
68 
69   string public constant symbol = "BNR";
70   string public constant name = "BiNeuro";
71   uint8 public constant decimals = 3;
72   uint256 _totalSupply = (uint256)(850000000).mul((uint256)(10).pow(decimals));
73 
74   function getOwner()public view returns(address) {
75     return owner;
76   }
77 
78   // Balances for each account
79   mapping(address => uint256) balances;
80 
81   // Owner of account approves the transfer of an amount to another account
82   mapping(address => mapping (address => uint256)) allowed;
83 
84   function totalSupply() public view returns (uint256) { //standard ERC-20 function
85     return _totalSupply;
86   }
87 
88   function balanceOf(address _address) public view returns (uint256 balance) {//standard ERC-20 function
89     return balances[_address];
90   }
91 
92   //standard ERC-20 function
93   function transfer(address _to, uint256 _amount) public returns (bool success) {
94     require(this != _to);
95     balances[msg.sender] = balances[msg.sender].sub(_amount);
96     balances[_to] = balances[_to].add(_amount);
97     emit Transfer(msg.sender,_to,_amount);
98     return true;
99   }
100   
101   address public crowdsaleContract;
102 
103   //connect to crowdsaleContract, can be use once
104   function setCrowdsaleContract (address _address) public{
105     require(crowdsaleContract == address(0));
106     crowdsaleContract = _address;
107   }
108 
109   function transferFrom(address _from, address _to, uint256 _amount) public returns(bool success){
110     balances[_from] = balances[_from].sub(_amount);
111     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
112     balances[_to] = balances[_to].add(_amount);
113     emit Transfer(_from,_to,_amount);
114     return true;
115   }
116 
117   //standard ERC-20 function
118   function approve(address _spender, uint256 _amount)public returns (bool success) { 
119     allowed[msg.sender][_spender] = _amount;
120     emit Approval(msg.sender, _spender, _amount);
121     return true;
122   }
123 
124   //standard ERC-20 function
125   function allowance(address _owner, address _spender)public constant returns (uint256 remaining) {
126     return allowed[_owner][_spender];
127   }
128 
129   //Constructor
130   function BineuroToken() public {
131     owner = 0xCe390a89734B2222Ff01c9ac4fD370581DeD82E0;
132     // owner = msg.sender;
133     
134     balances[this] = _totalSupply;
135   }
136 
137   uint public crowdsaleBalance = 52845528455;
138 
139   function sendCrowdsaleTokens(address _address, uint256 _value)  public {
140     require(msg.sender == crowdsaleContract);
141     crowdsaleBalance = crowdsaleBalance.sub(_value);
142     balances[this] = balances[this].sub(_value);
143     balances[_address] = balances[_address].add(_value);
144     emit Transfer(this,_address,_value);
145   }
146 
147   function burnTokens(address _address1, address _address2, address _address3, uint _tokensSold) public {
148     require(msg.sender == crowdsaleContract);
149 
150     balances[this] = balances[this].sub(_tokensSold.mul((uint)(23))/100);
151     balances[_address1] = balances[_address1].add(_tokensSold.mul((uint)(75))/1000);
152     balances[_address2] = balances[_address2].add(_tokensSold.mul((uint)(75))/1000);
153     balances[_address3] = balances[_address2].add(_tokensSold.mul((uint)(8))/100);
154 
155     emit Transfer(this,_address1,_tokensSold.mul((uint)(75))/1000);
156     emit Transfer(this,_address2,_tokensSold.mul((uint)(75))/1000);
157     emit Transfer(this,_address3,_tokensSold.mul((uint)(8))/100);
158 
159     _totalSupply = _totalSupply.sub(balances[this]);
160     emit Transfer(this,0,balances[this]);
161 
162     balances[this] = 0;
163   }
164 }