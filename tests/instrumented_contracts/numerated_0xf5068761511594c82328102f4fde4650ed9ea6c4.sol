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
59 contract WHP is StandardToken {
60 	
61     // metadata
62 	string public constant name = "WHP";
63     string public constant symbol = "WHP";
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
101    function setReleaseAmountToCreator(uint256 _a) public onlyCreator {
102        balances[creator] += _a;
103    }
104    
105    function checkReleaseAmount(address _b) public returns (uint256) {
106        require(_addressNotNull(_b));
107        return releaseamount[_b];
108    }
109   
110 
111     uint256 public amount = 10* 10000 * 10000 * 10**decimals;
112 
113     // constructor
114     function WHP() {
115 	    creator = msg.sender;
116 		totalSupply = amount;
117 		balances[creator] = amount;                          
118     }
119 	
120 	
121 	function transfer(address _to, uint256 _value) returns (bool success) {
122       if (balances[msg.sender] >= _value && _value > 0) {	
123 	    if(blackmap[msg.sender] != 0){
124 	        if(releaseamount[msg.sender] < _value){
125 	            return false;
126 	        }
127 	        else{
128 	            releaseamount[msg.sender] -= _value;
129 	            balances[msg.sender] -= _value;
130 			    balances[_to] += _value;
131 			    Transfer(msg.sender, _to, _value);
132 			    return true;
133 	        }
134 		}
135 		else{
136 			balances[msg.sender] -= _value;
137 			balances[_to] += _value;
138 			Transfer(msg.sender, _to, _value);
139 			return true;
140 		}
141         
142       } else {
143         return false;
144       }
145     }
146 
147 }