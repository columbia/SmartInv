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
38 contract pharmatrix {
39 	
40     using SafeMath for uint256;
41     
42     string public constant name       = "PHT";
43     string public constant symbol     = "PHT";
44     uint32 public constant decimals   = 0;
45     uint256 public totalSupply;
46  
47 
48     mapping(address => uint256) balances;
49 	mapping(address => mapping (address => uint256)) internal allowed;
50 
51 	event Transfer(address indexed from, address indexed to, uint256 value);
52     event Approval(address indexed owner, address indexed spender, uint256 value);
53 
54 	
55 	function pharmatrix(
56         uint256 initialSupply
57     ) public {
58         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
59         balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
60         emit Transfer(this,msg.sender,totalSupply);
61     }
62 	
63     function totalSupply() public view returns (uint256) {
64 		return totalSupply;
65 	}	
66 	
67 	function transfer(address _to, uint256 _value) public returns (bool) {
68 		require(_to != address(0));
69 		require(_value <= balances[msg.sender]);
70  
71 		balances[msg.sender] = balances[msg.sender].sub(_value);
72 		balances[_to] = balances[_to].add(_value);
73 		emit Transfer(msg.sender, _to, _value);
74 		return true;
75 	}
76 	
77 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
78 		require(_to != address(0));
79 		require(_value <= balances[_from]);
80 		require(_value <= allowed[_from][msg.sender]);	
81 		balances[_from] = balances[_from].sub(_value);
82 		balances[_to] = balances[_to].add(_value);
83 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
84 		emit Transfer(_from, _to, _value);
85 		return true;
86 	}
87 
88 
89     function approve(address _spender, uint256 _value) public returns (bool) {
90 		allowed[msg.sender][_spender] = _value;
91 		emit Approval(msg.sender, _spender, _value);
92 		return true;
93 	}
94 
95     function allowance(address _owner, address _spender) public view returns (uint256) {
96 		return allowed[_owner][_spender];
97 	}
98 
99 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
100 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
101 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
102 		return true;
103 	}
104 
105 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
106 		uint oldValue = allowed[msg.sender][_spender];
107 		if (_subtractedValue > oldValue) {
108 			allowed[msg.sender][_spender] = 0;
109 		} else {
110 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
111 		}
112 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
113 		return true;
114 	}
115 	
116 	function getBalance(address _a) internal constant returns(uint256) {
117  
118             return balances[_a];
119  
120     }
121     
122     function balanceOf(address _owner) public view returns (uint256 balance) {
123         return getBalance( _owner );
124     }
125  
126 }