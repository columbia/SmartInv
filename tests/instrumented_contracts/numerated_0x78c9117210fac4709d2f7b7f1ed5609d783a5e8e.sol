1 pragma solidity ^0.4.11;
2 
3 library safeMath {
4   function mul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9   function div(uint a, uint b) internal returns (uint) {
10     assert(b > 0);
11     uint c = a / b;
12     assert(a == b * c + a % b);
13     return c;
14   }
15   function sub(uint a, uint b) internal returns (uint) {
16     assert(b <= a);
17     return a - b;
18   }
19   function add(uint a, uint b) internal returns (uint) {
20     uint c = a + b;
21     assert(c >= a);
22     return c;
23   }
24   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
25     return a >= b ? a : b;
26   }
27   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
28     return a < b ? a : b;
29   }
30   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
31     return a >= b ? a : b;
32   }
33   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
34     return a < b ? a : b;
35   }
36   function assert(bool assertion) internal {
37     if (!assertion) {
38       throw;
39     }
40   }
41 }
42 
43 contract ERC20 {
44     function totalSupply() constant returns (uint supply);
45     function balanceOf(address who) constant returns (uint value);
46     function allowance(address owner, address spender) constant returns (uint _allowance);
47 
48     function transfer(address to, uint value) returns (bool ok);
49     function transferFrom(address from, address to, uint value) returns (bool ok);
50     function approve(address spender, uint value) returns (bool ok);
51 
52     event Transfer(address indexed from, address indexed to, uint value);
53     event Approval(address indexed owner, address indexed spender, uint value);
54 }
55 
56 contract PlayCoin is ERC20{
57 	uint initialSupply = 100000000000;
58 	string public constant name = "PlayCoin";
59 	string public constant symbol = "PLC";
60 	uint freeCoinsPerUser = 100;
61 	address ownerAddress;
62 
63 	mapping (address => uint256) balances;
64 	mapping (address => mapping (address => uint256)) allowed;
65 	mapping (address => bool) authorizedContracts;
66 	mapping (address => bool) recievedFreeCoins;
67 	
68 	modifier onlyOwner {
69 	    if (msg.sender == ownerAddress) {
70 	        _;
71 	    }
72 	}
73 	
74 	function authorizeContract (address authorizedAddress) onlyOwner {
75 	    authorizedContracts[authorizedAddress] = true;
76 	}
77 	
78 	function unAuthorizeContract (address authorizedAddress) onlyOwner {
79 	    authorizedContracts[authorizedAddress] = false;
80 	}
81 
82 	function setFreeCoins(uint number) onlyOwner {
83 	    freeCoinsPerUser = number;
84 	}
85 
86 	function totalSupply() constant returns (uint256) {
87 		return initialSupply;
88     }
89 
90 	function balanceOf(address _owner) constant returns (uint256 balance) {
91 		return balances[_owner];
92     }
93  
94     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
95         return allowed[_owner][_spender];
96     }
97 
98     function authorizedTransfer(address from, address to, uint value) {
99         if (authorizedContracts[msg.sender] == true && balances[from]>= value) {
100             balances[from] -= value;
101             balances[to] += value;
102             Transfer (from, to, value);
103         }
104     }
105 
106     function transfer(address _to, uint256 _value) returns (bool success) {
107         if (balances[msg.sender] >= _value && _value > 0) {
108             balances[msg.sender] -= _value;
109             balances[_to] += _value;
110             Transfer(msg.sender, _to, _value);
111             return true;
112         } else {
113             return false;
114         }
115     }
116 
117     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
118         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
119             balances[_to] += _value;
120             balances[_from] -= _value;
121             allowed[_from][msg.sender] -= _value;
122             Transfer(_from, _to, _value);
123             return true;
124         } else {
125             return false;
126         }
127     }
128 
129     function approve(address _spender, uint256 _value) returns (bool success) {
130         allowed[msg.sender][_spender] = _value;
131         Approval(msg.sender, _spender, _value);
132         return true;
133     }
134 
135     function PlayCoin() {
136         ownerAddress = msg.sender;
137         balances[ownerAddress] = initialSupply;
138     }
139 
140 	function () payable {
141 	    uint valueToPass = safeMath.div(msg.value,10**13);
142 	    if (balances[ownerAddress] >= valueToPass && valueToPass > 0) {
143 	        balances[msg.sender] = safeMath.add(balances[msg.sender],valueToPass);
144 	        balances[ownerAddress] = safeMath.sub(balances[ownerAddress],valueToPass);
145 	        Transfer(ownerAddress, msg.sender, valueToPass);
146 	    } 
147 	}
148 
149 	function withdraw(uint amount) onlyOwner {
150         ownerAddress.send(amount);
151 	}
152 
153 	function getFreeCoins() {
154 	    if (recievedFreeCoins[msg.sender] == false) {
155 	        recievedFreeCoins[msg.sender] = true;
156             balances[msg.sender] = safeMath.add(balances[msg.sender],freeCoinsPerUser);
157             balances[ownerAddress] = safeMath.sub(balances[ownerAddress],freeCoinsPerUser);
158             Transfer(ownerAddress, msg.sender, freeCoinsPerUser);
159 	    }
160 	}
161 }