1 pragma solidity ^0.4.21;
2 
3 
4 library SafeMath {
5 
6   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
7     if (a == 0) {
8       return 0;
9     }
10     c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   /**
16   * @dev Integer division of two numbers, truncating the quotient.
17   */
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     // uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return a / b;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
32     c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37  
38 
39 contract TokenERC20   {
40 	
41     using SafeMath for uint256;
42     
43     string public constant name       = "AVATRS";
44     string public constant symbol     = "NAVS";
45     uint32 public constant decimals   = 18;
46     uint256 public totalSupply;
47     address public admin              = 0x9Ef4a2CaA82D396d7B8c244DE57212E0fE332C73;
48  
49     mapping(address => uint256) balances;
50 	mapping(address => mapping (address => uint256)) internal allowed;
51  
52 	event Transfer(address indexed from, address indexed to, uint256 value);
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54 	event Burn(address indexed burner, uint256 value);   
55 	
56 	function TokenERC20(
57         uint256 initialSupply
58     ) public {
59         totalSupply = initialSupply * 10 ** uint256(decimals);   
60         balances[admin] = totalSupply; 
61         emit Transfer(this,admin,totalSupply);
62     }
63 	
64     function totalSupply() public view returns (uint256) {
65 		return totalSupply;
66 	}	
67 	
68 	function transfer(address _to, uint256 _value) public returns (bool) {
69 		require(_to != address(0));
70  
71 		require(_value <= balances[msg.sender]);
72 
73 		balances[msg.sender] = balances[msg.sender].sub(_value);
74 		balances[_to] = balances[_to].add(_value);
75 		emit Transfer(msg.sender, _to, _value);
76 		return true;
77 	}
78 	
79 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
80 		require(_to != address(0));
81 		require(_value <= balances[_from]);
82 		require(_value <= allowed[_from][msg.sender]);	
83 		balances[_from] = balances[_from].sub(_value);
84 		balances[_to] = balances[_to].add(_value);
85 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
86 		emit Transfer(_from, _to, _value);
87 		return true;
88 	}
89 
90 
91     function approve(address _spender, uint256 _value) public returns (bool) {
92 		allowed[msg.sender][_spender] = _value;
93 		emit Approval(msg.sender, _spender, _value);
94 		return true;
95 	}
96 
97     function allowance(address _owner, address _spender) public view returns (uint256) {
98 		return allowed[_owner][_spender];
99 	}
100 
101 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
102 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
103 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
104 		return true;
105 	}
106 
107 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
108 		uint oldValue = allowed[msg.sender][_spender];
109 		if (_subtractedValue > oldValue) {
110 			allowed[msg.sender][_spender] = 0;
111 		} else {
112 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
113 		}
114 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
115 		return true;
116 	}
117 	
118 	function getBalance(address _a) internal constant returns(uint256) {
119  
120             return balances[_a];
121  
122     }
123     
124     function balanceOf(address _owner) public view returns (uint256 balance) {
125         return getBalance( _owner );
126     }
127 	
128  
129 }