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
38 contract TokenERC20 {
39 	
40     using SafeMath for uint256;
41     
42     string public constant name       = "Bean fun";
43     string public constant symbol     = "BFUN";
44     uint32 public constant decimals   = 18;
45     uint256 public totalSupply;
46     
47     mapping(address => uint256) balances;
48 	mapping(address => mapping (address => uint256)) internal allowed;
49 
50 	event Transfer(address indexed from, address indexed to, uint256 value);
51     event Approval(address indexed owner, address indexed spender, uint256 value);
52 
53 	
54 	function TokenERC20(
55         uint256 initialSupply 
56     ) public payable{
57         totalSupply = initialSupply * 10 ** uint256(decimals);   
58         balances[msg.sender] = totalSupply;         
59     }
60 	
61     function totalSupply() public view returns (uint256) {
62 		return totalSupply;
63 	}	
64 	
65 	function transfer(address _to, uint256 _value) public returns (bool) {
66 		require(_to != address(0));
67 		require(_value <= balances[msg.sender]);
68 		balances[msg.sender] = balances[msg.sender].sub(_value);
69 		balances[_to] = balances[_to].add(_value);
70 		emit Transfer(msg.sender, _to, _value);
71 		return true;
72 	}
73 	
74 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
75 		require(_to != address(0));
76 		require(_value <= balances[_from]);
77 		require(_value <= allowed[_from][msg.sender]);	
78 		balances[_from] = balances[_from].sub(_value);
79 		balances[_to] = balances[_to].add(_value);
80 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
81 		emit Transfer(_from, _to, _value);
82 		return true;
83 	}
84 
85 
86     function approve(address _spender, uint256 _value) public returns (bool) {
87 		allowed[msg.sender][_spender] = _value;
88 		emit Approval(msg.sender, _spender, _value);
89 		return true;
90 	}
91 
92     function allowance(address _owner, address _spender) public view returns (uint256) {
93 		return allowed[_owner][_spender];
94 	}
95 
96 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
97 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
98 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
99 		return true;
100 	}
101 
102 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
103 		uint oldValue = allowed[msg.sender][_spender];
104 		if (_subtractedValue > oldValue) {
105 			allowed[msg.sender][_spender] = 0;
106 		} else {
107 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
108 		}
109 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
110 		return true;
111 	} 
112 	
113     function balanceOf(address _owner) public view returns (uint256 balance) {
114         return balances[_owner];
115     }
116  
117 }