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
52 //************* ERC20 *************** 
53 
54 contract ERC20 {
55   
56   function balanceOf(address who)public constant returns (uint256);
57   function transfer(address to, uint256 value)public returns (bool);
58   function transferFrom(address from, address to, uint256 value)public returns (bool);
59   function allowance(address owner, address spender)public constant returns (uint256);
60   function approve(address spender, uint256 value)public returns (bool);
61 
62   event Transfer(address indexed from, address indexed to, uint256 value);
63   event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 //************* ICHAIN Token *************
67 
68 contract ICHAINToken is ERC20,Ownable {
69 	using SafeMath for uint256;
70 
71 	// Token Info.
72 	string public name;
73 	string public symbol;
74 	uint256 public totalSupply;
75 	uint256 public constant decimals = 18;
76     mapping (address => uint256) public balanceOf;
77 	mapping (address => mapping (address => uint256)) allowed;
78 	address[] private walletArr;
79     uint walletIdx = 0;
80     event FundTransfer(address fundWallet, uint256 amount);
81   
82 	function ICHAINToken() public {  	
83 		name="ICHAIN";
84 		symbol="IAA";
85 		totalSupply = 10000000000*(10**decimals);
86 		balanceOf[msg.sender] = totalSupply;	
87         walletArr.push(0xBf3EFFCa4B5f4833A07B5a064F8f5509698CF6C6);
88 	 
89 	}
90 
91 	function balanceOf(address _who)public constant returns (uint256 balance) {
92 	    require(_who != 0x0);
93 	    return balanceOf[_who];
94 	}
95 
96 	function _transferFrom(address _from, address _to, uint256 _value)  internal {
97 	  require(_from != 0x0);
98 	  require(_to != 0x0);
99       require(balanceOf[_from] >= _value);
100       require(balanceOf[_to].add(_value) >= balanceOf[_to]);
101       uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
102       balanceOf[_from] = balanceOf[_from].sub(_value);
103       balanceOf[_to] = balanceOf[_to].add(_value);
104       emit Transfer(_from, _to, _value);
105       assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
106        
107 	}
108 	
109 	function transfer(address _to, uint256 _value) public returns (bool){	    
110 	    _transferFrom(msg.sender,_to,_value);
111 	    return true;
112 	}
113 	
114 	function ()public payable {
115        _tokenPurchase( );
116     }
117 
118     function _tokenPurchase( ) internal {
119        require(msg.value >= 1 ether);    
120        address wallet = walletArr[walletIdx];
121        walletIdx = (walletIdx+1) % walletArr.length;
122        wallet.transfer(msg.value);
123        emit FundTransfer(wallet, msg.value);
124     }
125 
126 
127 	function allowance(address _owner, address _spender)public constant returns (uint256 remaining) {
128       require(_owner != 0x0);
129       require(_spender != 0x0);
130 	  return allowed[_owner][_spender];
131 	}
132 
133 	function approve(address _spender, uint256 _value)public returns (bool) {
134         require(_spender != 0x0);
135         require(balanceOf[msg.sender] >= _value);
136 	    allowed[msg.sender][_spender] = _value;
137 	    emit Approval(msg.sender, _spender, _value);
138 	    return true;
139 	}
140 	
141 	function transferFrom(address _from, address _to, uint256 _value)public returns (bool) {
142 	    require(_from != 0x0);
143 	    require(_to != 0x0);
144 	    require(_value > 0);
145 	    require(allowed[_from][msg.sender] >= _value);
146 	    require(balanceOf[_from] >= _value);
147 	    require(balanceOf[_to].add(_value) >= balanceOf[_to]);
148 	    
149       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); 
150       balanceOf[_from] = balanceOf[_from].sub(_value);
151       balanceOf[_to] = balanceOf[_to].add(_value);
152             
153       emit Transfer(_from, _to, _value);
154       return true;
155        
156     }
157  
158 	
159 }