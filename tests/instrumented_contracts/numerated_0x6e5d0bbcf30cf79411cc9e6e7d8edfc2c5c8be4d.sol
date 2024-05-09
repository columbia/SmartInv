1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6     if (a == 0) {
7       return 0;
8     }
9     c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     return a / b;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
24     c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 
31 contract ERC20Basic {
32   function totalSupply() public view returns (uint256);
33   function balanceOf(address who) public view returns (uint256);
34   function transfer(address to, uint256 value) public returns (bool);
35   event Transfer(address indexed from, address indexed to, uint256 value);
36 }
37 
38 contract ERC20 is ERC20Basic {
39   function allowance(address owner, address spender) public view returns (uint256);
40   function transferFrom(address from, address to, uint256 value) public returns (bool);
41   function approve(address spender, uint256 value) public returns (bool);
42   event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 contract BasicToken is ERC20Basic {
46   using SafeMath for uint256;
47 
48   mapping(address => uint256) balances;
49 
50   uint256 totalSupply_;
51 
52   function totalSupply() public view returns (uint256) {
53     return totalSupply_;
54   }
55 
56   function transfer(address _to, uint256 _value) public returns (bool) {
57 	require(_to != address(0));
58     require(_value <= balances[msg.sender]);
59 
60     balances[msg.sender] = balances[msg.sender].sub(_value);
61     balances[_to] = balances[_to].add(_value);
62     emit Transfer(msg.sender, _to, _value);
63     return true;
64   }
65 
66   function balanceOf(address _owner) public view returns (uint256) {
67     return balances[_owner];
68   }
69 }
70 
71 contract StandardToken is ERC20, BasicToken {
72 
73   mapping (address => mapping (address => uint256)) internal allowed;
74   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
75     require(_to != address(0));
76     require(_value <= balances[_from]);
77     require(_value <= allowed[_from][msg.sender]);
78 
79     balances[_from] = balances[_from].sub(_value);
80     balances[_to] = balances[_to].add(_value);
81     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
82     emit Transfer(_from, _to, _value);
83     return true;
84   }
85 
86   function approve(address _spender, uint256 _value) public returns (bool) {
87     allowed[msg.sender][_spender] = _value;
88     emit Approval(msg.sender, _spender, _value);
89     return true;
90   }
91 
92   function allowance(address _owner, address _spender) public view returns (uint256) {
93     return allowed[_owner][_spender];
94   }
95 
96   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
97     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
98     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
99     return true;
100   }
101 
102   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
103     uint oldValue = allowed[msg.sender][_spender];
104     if (_subtractedValue > oldValue) {
105       allowed[msg.sender][_spender] = 0;
106     } else {
107       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
108     }
109     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
110     return true;
111   }
112 }
113 
114 contract EBCBToken is StandardToken {
115     string public name = 'EBCBToken';
116 	string public symbol = 'EBCB';
117 	uint8 public decimals = 2;
118 	uint public INITIAL_SUPPLY = 100000000;
119 	address public ceoAddress;
120 	address public cooAddress = 0xD22adC4115e896485aB9C755Cd2972f297Aa24B8;
121 	uint256 public sellPrice = 0.0002 ether;
122     uint256 public buyPrice = 0.0002 ether;
123 	
124 	function EBCBToken() public {
125 	    totalSupply_ = INITIAL_SUPPLY;
126 	    balances[msg.sender] = INITIAL_SUPPLY.sub(2000000);
127 	    balances[cooAddress] = 2000000;
128 	    ceoAddress = msg.sender;
129 	}
130 	
131 	modifier onlyCEOorCOO() {
132         require(msg.sender == ceoAddress || msg.sender == cooAddress);
133         _;
134     }
135 
136     function mintToken(uint256 mintedAmount) public onlyCEOorCOO {
137        totalSupply_ = totalSupply_.add(mintedAmount);
138        balances[msg.sender] = balances[msg.sender].add(mintedAmount);
139     }
140 
141     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) public onlyCEOorCOO {
142         sellPrice = newSellPrice;
143         buyPrice = newBuyPrice;
144     }
145 
146     function getBonusPool() public view returns (uint256) {
147         return this.balance;
148     }
149 	
150     function buy() payable public returns (uint amount){
151         amount = msg.value.div(buyPrice);
152         require(balances[ceoAddress] >= amount);
153         balances[msg.sender] = balances[msg.sender].add(amount);
154         balances[ceoAddress] = balances[ceoAddress].sub(amount);
155         Transfer(ceoAddress, msg.sender, amount);
156         return amount;
157     }
158 	
159     function sell(uint amount) public returns (uint revenue){
160         require(balances[msg.sender] >= amount);
161         balances[ceoAddress] = balances[ceoAddress].add(amount);
162         balances[msg.sender] = balances[msg.sender].sub(amount);
163         revenue = amount.mul(sellPrice);
164         msg.sender.transfer(revenue);
165         Transfer(msg.sender, ceoAddress, amount);
166         return revenue;
167     }
168 	
169 	function batchTransfer(address[] _tos, uint256 _value) public {
170 	  for(uint i = 0; i < _tos.length; i++) {
171         transfer( _tos[i], _value);
172       }
173 	}
174 }