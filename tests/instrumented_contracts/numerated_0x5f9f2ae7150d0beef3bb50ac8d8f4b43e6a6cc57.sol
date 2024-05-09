1 pragma solidity ^0.4.18;
2 
3 contract Token {
4     uint256 public totalSupply;
5     function balanceOf(address _owner) constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8     function approve(address _spender, uint256 _value) returns (bool success);
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 
15 /*  ERC 20 token */
16 contract StandardToken is Token {
17 
18     function transfer(address _to, uint256 _value) returns (bool success) {
19       if (balances[msg.sender] >= _value && _value > 0) {		
20         balances[msg.sender] -= _value;
21         balances[_to] += _value;
22         Transfer(msg.sender, _to, _value);
23         return true;
24       } else {
25         return false;
26       }
27     }
28 
29     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
30       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
31         balances[_to] += _value;
32         balances[_from] -= _value;
33         allowed[_from][msg.sender] -= _value;
34         Transfer(_from, _to, _value);
35         return true;
36       } else {
37         return false;
38       }
39     }
40 
41     function balanceOf(address _owner) constant returns (uint256 balance) {
42         return balances[_owner];
43     }
44 
45     function approve(address _spender, uint256 _value) returns (bool success) {
46         allowed[msg.sender][_spender] = _value;
47         Approval(msg.sender, _spender, _value);
48         return true;
49     }
50 
51     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
52       return allowed[_owner][_spender];
53     }
54 
55     mapping (address => uint256) balances;
56     mapping (address => mapping (address => uint256)) allowed;
57 }
58 
59 contract NABC is StandardToken {
60 	
61     // metadata
62 	string public constant name = "NABC";
63     string public constant symbol = "NABC";
64     uint256 public constant decimals = 18;
65     string public version = "1.0";
66 	
67     address private creator;     
68 	mapping (address => uint256) private blackmap;
69 	mapping (address => uint256) private releaseamount;
70 
71     modifier onlyCreator() {
72     require(msg.sender == creator);
73     _;
74    }
75    
76    function _addressNotNull(address _to) private pure returns (bool) {
77     return _to != address(0);
78    }
79    
80    function addBlackAccount(address _b) public onlyCreator {
81     require(_addressNotNull(_b));
82     blackmap[_b] = 1;
83    }
84    
85    function clearBlackAccount(address _b) public onlyCreator {
86     require(_addressNotNull(_b));
87     blackmap[_b] = 0;
88    }
89    
90    function checkBlackAccount(address _b) public returns (uint256) {
91        require(_addressNotNull(_b));
92        return blackmap[_b];
93    }
94    
95    function setReleaseAmount(address _b, uint256 _a) public onlyCreator {
96        require(_addressNotNull(_b));
97        require(balances[_b] >= _a);
98        releaseamount[_b] = _a;
99    }
100    
101    function checkReleaseAmount(address _b) public returns (uint256) {
102        require(_addressNotNull(_b));
103        return releaseamount[_b];
104    }
105   
106     address account1 = 0xA1eA1e293839e2005a8E47f772B758DaBC0515FB;  //70%
107 	address account2 = 0xD285bB3f0d0A6271d535Bd37798A452892466De0;  //30%
108 	
109     uint256 public amount1 = 34* 10000 * 10000 * 10**decimals;
110 	uint256 public amount2 = 14* 10000 * 10000 * 10**decimals;
111 	
112 
113     // constructor
114     function NABC() {
115 	    creator = msg.sender;
116 		totalSupply = amount1 + amount2;
117 		balances[account1] = amount1;                          
118 		balances[account2] = amount2;
119                 balances[msg.sender] = 2 * 10000 * 10000 * 10**decimals;
120     }
121 	
122 	
123 	function transfer(address _to, uint256 _value) returns (bool success) {
124       if (balances[msg.sender] >= _value && _value > 0) {	
125 	    if(blackmap[msg.sender] != 0){
126 	        if(releaseamount[msg.sender] < _value){
127 	            return false;
128 	        }
129 	        else{
130 	            releaseamount[msg.sender] -= _value;
131 	            balances[msg.sender] -= _value;
132 			    balances[_to] += _value;
133 			    Transfer(msg.sender, _to, _value);
134 			    return true;
135 	        }
136 		}
137 		else{
138 			balances[msg.sender] -= _value;
139 			balances[_to] += _value;
140 			Transfer(msg.sender, _to, _value);
141 			return true;
142 		}
143         
144       } else {
145         return false;
146       }
147     }
148 
149 }