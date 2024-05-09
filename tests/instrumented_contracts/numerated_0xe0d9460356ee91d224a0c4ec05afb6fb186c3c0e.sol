1 pragma solidity ^0.4.15;
2 //*************** SafeMath
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure  returns (uint256) {
6       uint256 c = a * b;
7       assert(a == 0 || c / a == b);
8       return c;
9   }
10 
11   function div(uint256 a, uint256 b) internal pure  returns (uint256) {
12       assert(b > 0);
13       uint256 c = a / b;
14       return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure  returns (uint256) {
18       assert(b <= a);
19       return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure  returns (uint256) {
23       uint256 c = a + b;
24       assert(c >= a);
25       return c;
26   }
27 }
28 
29 //*************** Ownable
30 
31 contract Ownable {
32   address public owner;
33 
34   function Ownable() public {
35       owner = msg.sender;
36   }
37 
38   modifier onlyOwner() {
39       require(msg.sender == owner);
40       _;
41   }
42 
43   function transferOwnership(address newOwner)public onlyOwner {
44       if (newOwner != address(0)) {
45         owner = newOwner;
46       }
47   }
48 
49 }
50 
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
68 //*************Chain Token
69 
70 contract ChainToken is ERC20,Ownable {
71 	using SafeMath for uint256;
72 
73 	// Token Info.
74 	string public name;
75 	string public symbol;
76 
77 	uint8 public constant decimals = 18;
78 	
79 	
80 
81 	address[] private walletArr;
82 	uint walletIdx = 0;
83 
84 	mapping (address => uint256) public balanceOf;
85 	mapping (address => mapping (address => uint256)) allowed;
86 
87 	event TokenPurchase(address indexed purchaser, uint256 value,uint256 amount);
88 	event FundTransfer(address fundWallet, uint256 amount);
89 
90 	function ChainToken( 
91 	
92 		
93 		
94 	) public {  		
95 
96 	
97 	
98 	totalSupply = 6000000000*(10**18);	
99 	balanceOf[msg.sender] = totalSupply;
100 	name = "Time Exchange Coin";
101 	symbol = "TEC";
102 	
103 	walletArr.push(0x0AD8869081579E72eb4E0B90394079e448E4dF49);
104 	}
105 
106 
107 	function balanceOf(address _who)public constant returns (uint256 balance) {
108 	    return balanceOf[_who];
109 	}
110 
111 
112 	function _transferFrom(address _from, address _to, uint256 _value)  internal {
113 	    require(_to != 0x0);
114 	    require(balanceOf[_from] >= _value);
115 	    require(balanceOf[_to] + _value >= balanceOf[_to]);
116 
117 	    balanceOf[_from] = balanceOf[_from].sub(_value);
118 	    balanceOf[_to] = balanceOf[_to].add(_value);
119 
120 	    Transfer(_from, _to, _value);
121 	}
122 
123 
124 	function transfer(address _to, uint256 _value) public returns (bool){	    
125 	    _transferFrom(msg.sender,_to,_value);
126 	    return true;
127 	}
128 
129 	function push(address _buyer, uint256 _amount) public onlyOwner {
130 	    uint256 val=_amount*(10**18);
131 	    _transferFrom(msg.sender,_buyer,val);
132 	    PreICOTokenPushed(_buyer, val);
133 	}
134 
135 	function ()public payable {
136 	    _tokenPurchase( msg.value);
137 	}
138 
139 	function _tokenPurchase( uint256 _value) internal {
140 	   
141 	    require(_value >= 0.1 ether);
142 
143 	    address wallet = walletArr[walletIdx];
144 	    walletIdx = (walletIdx+1) % walletArr.length;
145 
146 	    wallet.transfer(msg.value);
147 	    FundTransfer(wallet, msg.value);
148 	}
149 
150 	
151 
152 	function supply()  internal constant  returns (uint256) {
153 	    return balanceOf[owner];
154 	}
155 
156 	function getCurrentTimestamp() internal view returns (uint256){
157 	    return now;
158 	}
159 
160 	
161 
162 	function allowance(address _owner, address _spender)public constant returns (uint256 remaining) {
163 	    return allowed[_owner][_spender];
164 	}
165 
166 	function approve(address _spender, uint256 _value)public returns (bool) {
167 	    require((_value == 0) || (allowed[msg.sender][_spender] == 0));
168 
169 	    allowed[msg.sender][_spender] = _value;
170 	    Approval(msg.sender, _spender, _value);
171 	    return true;
172 	}
173 	
174 	function transferFrom(address _from, address _to, uint256 _value)public returns (bool) {
175 	    var _allowance = allowed[_from][msg.sender];
176 
177 	    require (_value <= _allowance);
178 		
179 	     _transferFrom(_from,_to,_value);
180 
181 	    allowed[_from][msg.sender] = _allowance.sub(_value);
182 	    Transfer(_from, _to, _value);
183 	    return true;
184 	  }
185 	
186 }