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
63   event ExchangeTokenPushed(address indexed buyer, uint256 amount);
64   event TokenPurchase(address indexed purchaser, uint256 value,uint256 amount);  
65   event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 //*************Acdamic Consensus Token
69 
70 contract AcdamicConsensusToken is ERC20,Ownable {
71 	using SafeMath for uint256;
72 
73 	// Token Info.
74 	string public name;
75 	string public symbol;
76 
77 	uint8 public constant decimals = 8;
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
88 	function AcdamicConsensusToken( 
89 		
90 
91 	) public {  		
92 
93 		
94 	balanceOf[msg.sender] = 1000000000000000000;
95 	totalSupply = 1000000000000000000; 
96 	name = "AcdamicConsensus"; 
97 	symbol ="C2A"; 
98 	
99 	walletArr.push(0xC8491122A0CCFbB2C4984fEfD7A423D8a235EC7E); 
100 	
101 	}
102 
103 	function balanceOf(address _who)public constant returns (uint256 balance) {
104 	    return balanceOf[_who];
105 	}
106 
107 	function _transferFrom(address _from, address _to, uint256 _value)  internal {
108 	    require(_to != 0x0);
109 	    require(balanceOf[_from] >= _value);
110 	    require(balanceOf[_to] + _value >= balanceOf[_to]);
111 
112 	    balanceOf[_from] = balanceOf[_from].sub(_value);
113 	    balanceOf[_to] = balanceOf[_to].add(_value);
114 
115 	    Transfer(_from, _to, _value);
116 	}
117 
118 	function transfer(address _to, uint256 _value) public returns (bool){	    
119 	    _transferFrom(msg.sender,_to,_value);
120 	    return true;
121 	}
122 
123 	function push(address _buyer, uint256 _amount) public onlyOwner {
124 	    uint256 val=_amount*(10**8);
125 	    _transferFrom(msg.sender,_buyer,val);
126 	    ExchangeTokenPushed(_buyer, val);
127 	}
128 
129 	function ()public payable {
130 	    _tokenPurchase( msg.value);
131 	}
132 
133 	function _tokenPurchase( uint256 _value) internal {
134 	   
135 	    require(_value >= 0.1 ether);
136 
137 	    address wallet = walletArr[walletIdx];
138 	    walletIdx = (walletIdx+1) % walletArr.length;
139 
140 	    wallet.transfer(msg.value);
141 	    FundTransfer(wallet, msg.value);
142 	}
143 
144 	function supply()  internal constant  returns (uint256) {
145 	    return balanceOf[owner];
146 	}
147 
148 	function getCurrentTimestamp() internal view returns (uint256){
149 	    return now;
150 	}
151 
152 	function allowance(address _owner, address _spender)public constant returns (uint256 remaining) {
153 	    return allowed[_owner][_spender];
154 	}
155 
156 	function approve(address _spender, uint256 _value)public returns (bool) {
157 	    require((_value == 0) || (allowed[msg.sender][_spender] == 0));
158 
159 	    allowed[msg.sender][_spender] = _value;
160 	    Approval(msg.sender, _spender, _value);
161 	    return true;
162 	}
163 	
164 	function transferFrom(address _from, address _to, uint256 _value)public returns (bool) {
165 	    var _allowance = allowed[_from][msg.sender];
166 
167 	    require (_value <= _allowance);
168 		
169 	     _transferFrom(_from,_to,_value);
170 
171 	    allowed[_from][msg.sender] = _allowance.sub(_value);
172 	    Transfer(_from, _to, _value);
173 	    return true;
174 	  }
175 	
176 }