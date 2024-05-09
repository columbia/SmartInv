1 pragma solidity ^0.4.22;
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
14   /**
15   * @dev Integer division of two numbers, truncating the quotient.
16   */
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     // uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return a / b;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
31     c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 
38 contract TokenERC20 {
39 	
40     using SafeMath for uint256;
41     
42     string public constant name       = "泰拳链MTC(Thai)";
43     string public constant symbol     = "泰拳链MTC";
44     uint32 public constant decimals   = 18;
45     uint256 public totalSupply;
46 
47     mapping(address => uint256) balances;
48 	mapping(address => mapping (address => uint256)) internal allowed;
49 	mapping(address => bool) public frozenAccount;
50 
51 	event Transfer(address indexed from, address indexed to, uint256 value);
52     event Approval(address indexed owner, address indexed spender, uint256 value); 
53 
54 	
55 	constructor(
56         uint256 initialSupply,
57         address add_ad
58     ) public {
59         totalSupply = initialSupply * 10 ** uint256(decimals);  
60         balances[add_ad] = totalSupply;                
61         emit Transfer(this, add_ad, totalSupply);
62     }
63 	
64     function totalSupply() public view returns (uint256) {
65 		return totalSupply;
66 	}	
67 	
68 	function transfer(address _to, uint256 _value) public returns (bool) {
69 		require(_to != address(0));
70 		require(_value <= balances[msg.sender]);
71 		if(!frozenAccount[msg.sender]){
72 		    balances[msg.sender] = balances[msg.sender].sub(_value);
73 		    balances[_to] = balances[_to].add(_value);
74 		    emit Transfer(msg.sender, _to, _value);
75 		    return true;
76 		} else{
77 		    return false;
78 		}
79 		
80 	}
81 	
82 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
83 		require(_to != address(0));
84 		require(_value <= balances[_from]);
85 		require(_value <= allowed[_from][msg.sender]);
86 		if(!frozenAccount[_from]){
87 		    balances[_from] = balances[_from].sub(_value);
88 		    balances[_to] = balances[_to].add(_value);
89 		    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
90 		    emit Transfer(_from, _to, _value);
91 		    return true;
92 		}else{
93 		    return false;
94 		}
95 		
96 	}
97 
98 
99     function approve(address _spender, uint256 _value) public returns (bool) {
100 		allowed[msg.sender][_spender] = _value;
101 		emit Approval(msg.sender, _spender, _value);
102 		return true;
103 	}
104 
105     function allowance(address _owner, address _spender) public view returns (uint256) {
106 		return allowed[_owner][_spender];
107 	}
108 
109 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
110 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
111 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
112 		return true;
113 	}
114 
115 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
116 		uint oldValue = allowed[msg.sender][_spender];
117 		if (_subtractedValue > oldValue) {
118 			allowed[msg.sender][_spender] = 0;
119 		} else {
120 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
121 		}
122 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
123 		return true;
124 	}
125 	
126  
127     function balanceOf(address _owner) public view returns (uint256 balance) {
128         return balances[_owner];
129     }
130 
131 
132 }