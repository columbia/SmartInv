1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract Ownable {
34   address public owner;
35   address public tech;
36   
37   constructor() public {
38     owner = msg.sender;
39   }
40 
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45   
46   modifier onlyTech() {
47     require(msg.sender == owner);
48     _;
49   }
50   
51   function transferOwnership(address newOwner) public onlyOwner {
52     require(newOwner != address(0));
53     owner = newOwner;
54   }
55   
56   function transferTech(address newTech) public onlyOwner {
57     require(newTech != address(0));
58     tech = newTech;
59   }
60 }
61 
62 contract ERC20Basic {
63   function totalSupply() public view returns (uint256);
64   function balanceOf(address who) public view returns (uint256);
65   function transfer(address to, uint tokens) public returns (bool success);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 contract IceRockPay is ERC20Basic, Ownable {
70   event Payout(address indexed from, address indexed to, uint256 value);
71   using SafeMath for uint256;
72   mapping(address => uint256) balances;
73   string public name = "Rock2Pay";
74   string public symbol = "Rock2Pay";
75   uint256 totalSupply_;
76   uint8 public constant decimals = 18;
77   enum States {
78     Sale,
79     Stop
80   }
81   States public state;        
82   
83   constructor() public {
84     totalSupply_ = 0;
85     state = States.Sale;
86   }
87 
88   modifier requireState(States _requiredState) {
89     require(state == _requiredState);
90     _;
91   }
92   
93   function requestPayout(uint256 _amount, address _address)
94   onlyTech
95   public
96   {
97     _address.transfer(_amount);
98   }
99   
100   function changeState(States _newState)
101   onlyTech
102   public
103   {
104     state = _newState;
105   }
106   
107   function decreaseTokens(address _address, uint256 _amount) 
108   onlyTech
109   public {
110     balances[_address] = balances[_address].sub(_amount);
111     totalSupply_ = totalSupply_.sub(_amount);
112   }
113   
114   function decreaseTokensMulti(address[] _address, uint256[] _amount) 
115   onlyTech
116   public {
117       for(uint i = 0; i < _address.length; i++){
118         balances[_address[i]] = balances[_address[i]].sub(_amount[i]);
119         totalSupply_ = totalSupply_.sub(_amount[i]);
120       }
121   }
122   
123   function totalSupply() public view returns (uint256) {
124     return totalSupply_;
125   }
126 
127   function balanceOf(address _owner) public view returns (uint256 balance) {
128     return balances[_owner];
129   }
130 
131   function addTokens(address _address, uint256 _amount) 
132   onlyTech
133   public {
134     totalSupply_ = totalSupply_.add(_amount);
135     balances[_address] = balances[_address].add(_amount);
136     emit Transfer(msg.sender, _address, _amount);
137   }
138   
139   function addTokensMulti(address[] _address, uint256[] _amount) 
140   onlyTech
141   public {
142       for(uint i = 0; i < _address.length; i++){
143         totalSupply_ = totalSupply_.add(_amount[i]);
144         balances[_address[i]] = balances[_address[i]].add(_amount[i]);
145         emit Transfer(msg.sender, _address[i], _amount[i]);
146       }
147   }
148   
149   function transfer(address to, uint tokens) public returns (bool success) {
150     balances[msg.sender] = balances[msg.sender].sub(tokens);
151     if (to == owner) {
152         totalSupply_ = totalSupply_.sub(tokens);
153         msg.sender.transfer(tokens);
154         emit Payout(msg.sender, to, tokens);
155     } else {
156         balances[to] = balances[to].add(tokens);
157     }
158     emit Transfer(msg.sender, to, tokens);
159   }
160   
161   function() payable
162   public
163   {
164     
165   }
166 
167 }