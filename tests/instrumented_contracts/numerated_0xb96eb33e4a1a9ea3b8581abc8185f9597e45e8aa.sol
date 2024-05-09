1 pragma solidity ^0.4.19;
2 
3 //*************** SafeMath ***************
4 
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal pure  returns (uint256) {
7       uint256 c = a * b;
8       assert(a == 0 || c / a == b);
9       return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal pure  returns (uint256) {
13       assert(b > 0);
14       uint256 c = a / b;
15       return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure  returns (uint256) {
19       assert(b <= a);
20       return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure  returns (uint256) {
24       uint256 c = a + b;
25       assert(c >= a);
26       return c;
27   }
28 }
29 
30 //*************** Ownable
31 
32 contract Ownable {
33   address public owner;
34 
35   function Ownable() public {
36       owner = msg.sender;
37   }
38 
39   modifier onlyOwner() {
40       require(msg.sender == owner);
41       _;
42   }
43 
44   function transferOwnership(address newOwner)public onlyOwner {
45       if (newOwner != address(0)) {
46         owner = newOwner;
47       }
48   }
49 
50 }
51 
52 //************* ERC20
53 
54 contract ERC20 {
55   uint256 public totalSupply;
56   function balanceOf(address who)public constant returns (uint256);
57   function transfer(address to, uint256 value)public returns (bool);
58   function transferFrom(address from, address to, uint256 value)public returns (bool);
59   function allowance(address owner, address spender)public constant returns (uint256);
60   function approve(address spender, uint256 value)public returns (bool);
61 
62   event Transfer(address indexed from, address indexed to, uint256 value);
63   event PreICOTokenPushed(address indexed buyer, uint256 amount);
64   event TokenPurchase(address indexed purchaser, uint256 value,uint256 amount);  
65   event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 //*************HeroChain Token
69 
70 contract HeroChainToken is ERC20,Ownable {
71 	using SafeMath for uint256;
72 
73 	// Token Info.
74 	string public name;
75 	string public symbol;
76 
77 	uint8 public constant decimals = 18;
78 
79 	address[] private walletArr;
80 	uint walletIdx = 0;
81 
82 	mapping (address => uint256) public balanceOf;
83 	mapping (address => mapping (address => uint256)) allowed;
84 
85 	event TokenPurchase(address indexed purchaser, uint256 value,uint256 amount);
86 	event FundTransfer(address fundWallet, uint256 amount);
87 
88 	function HeroChainToken( 
89 		uint256 _totalSupply, 
90 		string _name, 
91 		string _symbol,  
92 		address _wallet1
93 
94 	) public {  		
95 
96 	require(_wallet1 != 0x0);
97 		
98 	balanceOf[msg.sender] = _totalSupply;
99 	totalSupply = _totalSupply;
100 	name = _name;
101 	symbol = _symbol;
102 	
103 	walletArr.push(_wallet1);
104 	
105 	}
106 
107 	function balanceOf(address _who)public constant returns (uint256 balance) {
108 	    return balanceOf[_who];
109 	}
110 
111 	function _transferFrom(address _from, address _to, uint256 _value)  internal {
112 	    require(_to != 0x0);
113 	    require(balanceOf[_from] >= _value);
114 	    require(balanceOf[_to] + _value >= balanceOf[_to]);
115 
116 	    balanceOf[_from] = balanceOf[_from].sub(_value);
117 	    balanceOf[_to] = balanceOf[_to].add(_value);
118 
119 	    Transfer(_from, _to, _value);
120 	}
121 
122 	function transfer(address _to, uint256 _value) public returns (bool){	    
123 	    _transferFrom(msg.sender,_to,_value);
124 	    return true;
125 	}
126 
127 	function push(address _buyer, uint256 _amount) public onlyOwner {
128 	    uint256 val=_amount*(10**18);
129 	    _transferFrom(msg.sender,_buyer,val);
130 	    PreICOTokenPushed(_buyer, val);
131 	}
132 
133 	function ()public payable {
134 	    _tokenPurchase( msg.value);
135 	}
136 
137 	function _tokenPurchase( uint256 _value) internal {
138 	   
139 	    require(_value >= 0.1 ether);
140 
141 	    address wallet = walletArr[walletIdx];
142 	    walletIdx = (walletIdx+1) % walletArr.length;
143 
144 	    wallet.transfer(msg.value);
145 	    FundTransfer(wallet, msg.value);
146 	}
147 
148 	function supply()  internal constant  returns (uint256) {
149 	    return balanceOf[owner];
150 	}
151 
152 	function getCurrentTimestamp() internal view returns (uint256){
153 	    return now;
154 	}
155 
156 	function allowance(address _owner, address _spender)public constant returns (uint256 remaining) {
157 	    return allowed[_owner][_spender];
158 	}
159 
160 	function approve(address _spender, uint256 _value)public returns (bool) {
161 	    require((_value == 0) || (allowed[msg.sender][_spender] == 0));
162 
163 	    allowed[msg.sender][_spender] = _value;
164 	    Approval(msg.sender, _spender, _value);
165 	    return true;
166 	}
167 	
168 	function transferFrom(address _from, address _to, uint256 _value)public returns (bool) {
169 	    var _allowance = allowed[_from][msg.sender];
170 
171 	    require (_value <= _allowance);
172 		
173 	     _transferFrom(_from,_to,_value);
174 
175 	    allowed[_from][msg.sender] = _allowance.sub(_value);
176 	    Transfer(_from, _to, _value);
177 	    return true;
178 	  }
179 	
180 }