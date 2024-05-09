1 pragma solidity ^0.4.20;
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
30 //*************** Ownable *************** 
31 
32 contract Ownable {
33   address public owner;
34   address public admin;
35 
36   function Ownable() public {
37       owner = msg.sender;
38   }
39 
40   modifier onlyOwner() {
41       require(msg.sender == owner);
42       _;
43   }
44 
45   modifier onlyOwnerAdmin() {
46       require(msg.sender == owner || msg.sender == admin);
47       _;
48   }
49 
50   function transferOwnership(address newOwner)public onlyOwner {
51       if (newOwner != address(0)) {
52         owner = newOwner;
53       }
54   }
55   function setAdmin(address _admin)public onlyOwner {
56       admin = _admin;
57   }
58 
59 }
60 
61 //************* ERC20 *************** 
62 
63 contract ERC20 {
64   
65   function balanceOf(address who)public constant returns (uint256);
66   function transfer(address to, uint256 value)public returns (bool);
67   function transferFrom(address from, address to, uint256 value)public returns (bool);
68   function allowance(address owner, address spender)public constant returns (uint256);
69   function approve(address spender, uint256 value)public returns (bool);
70 
71   event Transfer(address indexed from, address indexed to, uint256 value);
72   event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 contract UtradeToken is ERC20,Ownable {
76 	using SafeMath for uint256;
77 
78 	// Token Info.
79 	string public name;
80 	string public symbol;
81 	uint256 public totalSupply;
82 	uint256 public constant decimals = 8;
83 
84 
85 	mapping (address => uint256) public balanceOf;
86 	mapping (address => mapping (address => uint256)) allowed;
87 
88 	event FundTransfer(address fundWallet, uint256 amount);
89 	event Logs(string);
90 
91 	constructor( ) public {  		
92 		name="UTP FOUNDATION";
93 		symbol="UTP";
94 		totalSupply = 1000000000*(10**decimals);
95 		balanceOf[msg.sender] = totalSupply;	
96 	}
97 
98 	function balanceOf(address _who)public constant returns (uint256 balance) {
99 	    return balanceOf[_who];
100 	}
101 
102 	function _transferFrom(address _from, address _to, uint256 _value)  internal {
103 		require(_from != 0x0);
104 	    require(_to != 0x0);
105 	    require(balanceOf[_from] >= _value);
106 	    require(balanceOf[_to] + _value >= balanceOf[_to]);
107 
108 	    uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
109 
110 	    balanceOf[_from] = balanceOf[_from].sub(_value);
111 	    balanceOf[_to] = balanceOf[_to].add(_value);
112 
113 	    emit Transfer(_from, _to, _value);
114 
115 	    assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
116 	}
117 	
118 	function transfer(address _to, uint256 _value) public returns (bool){	    
119 	    _transferFrom(msg.sender,_to,_value);
120 	    return true;
121 	}
122 	function transferLog(address _to, uint256 _value,string logs) public returns (bool){
123 		_transferFrom(msg.sender,_to,_value);
124 		emit Logs(logs);
125 	    return true;
126 	}
127 	
128 	function ()public {
129 	}
130 
131 
132 	function allowance(address _owner, address _spender)public constant returns (uint256 remaining) {
133 	    return allowed[_owner][_spender];
134 	}
135 
136 	function approve(address _spender, uint256 _value)public returns (bool) {
137 	    allowed[msg.sender][_spender] = _value;
138 	    emit Approval(msg.sender, _spender, _value);
139 	    return true;
140 	}
141 	
142 	function transferFrom(address _from, address _to, uint256 _value)public returns (bool) {
143 	    require(_from != 0x0);
144 	    require(_to != 0x0);
145 	    require(_value > 0);
146 	    require (allowed[_from][msg.sender] >= _value);
147 	    require(balanceOf[_from] >= _value);
148 	    require(balanceOf[_to] + _value >= balanceOf[_to]);
149 
150         balanceOf[_from] = balanceOf[_from].sub(_value);
151         balanceOf[_to] = balanceOf[_to].add(_value);
152         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); 
153 	     
154         emit Transfer(_from, _to, _value);
155         return true;
156     }
157 
158     function mintToken(address _target, uint256 _mintedAmount) onlyOwner public {
159         require(_target != 0x0);
160         require(_mintedAmount > 0);
161         require(totalSupply + _mintedAmount > totalSupply);
162         require(balanceOf[_target] + _mintedAmount > balanceOf[_target]);
163         balanceOf[_target] = balanceOf[_target].add(_mintedAmount);
164         totalSupply = totalSupply.add(_mintedAmount);
165         emit Transfer(0, this, _mintedAmount);
166         emit Transfer(this, _target, _mintedAmount);
167     }
168 
169     function transferA2B(address _from ,address _to) onlyOwnerAdmin public {	 
170     	require(_from != 0x0);
171 	    require(_to != 0x0);  	  
172     	require(balanceOf[_from] > 0); 
173     	//require(balanceOf[_to] == 0); 
174 	    _transferFrom(_from,_to,balanceOf[_from]);	   
175 	}
176 }