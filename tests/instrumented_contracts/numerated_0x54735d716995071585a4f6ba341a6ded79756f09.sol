1 pragma solidity ^0.4.21;
2 
3 // ownership contract
4 contract Owned {
5     address public owner;
6 
7     event TransferOwnership(address oldaddr, address newaddr);
8 
9     modifier onlyOwner() { if (msg.sender != owner) return; _; }
10 
11     function Owned() public {
12         owner = msg.sender;
13     }
14     
15     function transferOwnership(address _new) onlyOwner public {
16         address oldaddr = owner;
17         owner = _new;
18         emit TransferOwnership(oldaddr, owner);
19     }
20 }
21 
22 // erc20
23 contract ERC20Interface {
24 	uint256 public totalSupply;
25 	function balanceOf(address _owner) public constant returns (uint256 balance);
26 	function transfer(address _to, uint256 _value) public returns (bool success);
27 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
28 	function approve(address _spender, uint256 _value) public returns (bool success);
29 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
30 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
31 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
32 }
33 
34 contract FLUX is ERC20Interface, Owned {
35 	string public constant symbol = "FLX";
36 	string public constant name = "FLUX";
37 	uint8 public constant decimals = 18;
38 	uint256 public constant totalSupply = 1000000000000000000000000000;
39 
40 	bool public stopped;
41 
42 	mapping (address => int8) public blackList;
43 
44 	mapping (address => uint256) public balances;
45 	mapping (address => mapping (address => uint256)) public allowed;
46 
47 
48     event Blacklisted(address indexed target);
49     event DeleteFromBlacklist(address indexed target);
50     event RejectedPaymentToBlacklistedAddr(address indexed from, address indexed to, uint256 value);
51     event RejectedPaymentFromBlacklistedAddr(address indexed from, address indexed to, uint256 value);
52 
53 
54 	modifier notStopped {
55         require(!stopped);
56         _;
57     }
58 
59 // constructor
60 	function FLUX() public {
61 		balances[msg.sender] = totalSupply;
62 	}
63 	
64 // function made for airdrop
65 	function airdrop(address[] _to, uint256[] _value) onlyOwner notStopped public {
66 	    for(uint256 i = 0; i < _to.length; i++){
67 	        if(balances[_to[i]] > 0){
68 	            continue;
69 	        }
70 	        transfer(_to[i], _value[i]);
71 	    }
72 	}
73 
74 // blacklist management
75     function blacklisting(address _addr) onlyOwner public {
76         blackList[_addr] = 1;
77         emit Blacklisted(_addr);
78     }
79     function deleteFromBlacklist(address _addr) onlyOwner public {
80         blackList[_addr] = -1;
81         emit DeleteFromBlacklist(_addr);
82     }
83 
84 // stop the contract
85 	function stop() onlyOwner {
86         stopped = true;
87     }
88     function start() onlyOwner {
89         stopped = false;
90     }
91 	
92 // ERC20 functions
93 	function balanceOf(address _owner) public constant returns (uint256 balance){
94 		return balances[_owner];
95 	}
96 	function transfer(address _to, uint256 _value) notStopped public returns (bool success){
97 		require(balances[msg.sender] >= _value);
98 
99 		if(blackList[msg.sender] > 0){
100 			emit RejectedPaymentFromBlacklistedAddr(msg.sender, _to, _value);
101 			return false;
102 		}
103 		if(blackList[_to] > 0){
104 			emit RejectedPaymentToBlacklistedAddr(msg.sender, _to, _value);
105 			return false;
106 		}
107 
108 		balances[msg.sender] -= _value;
109 		balances[_to] += _value;
110 		emit Transfer(msg.sender, _to, _value);
111 		return true;
112 	}
113 	function transferFrom(address _from, address _to, uint256 _value) notStopped public returns (bool success){
114 		require(balances[_from] >= _value
115 			&& allowed[_from][msg.sender] >= _value);
116 
117 		if(blackList[_from] > 0){
118 			emit RejectedPaymentFromBlacklistedAddr(_from, _to, _value);
119 			return false;
120 		}
121 		if(blackList[_to] > 0){
122 			emit RejectedPaymentToBlacklistedAddr(_from, _to, _value);
123 			return false;
124 		}
125 
126 		balances[_from] -= _value;
127 		allowed[_from][msg.sender] -= _value;
128 		balances[_to] += _value;
129 		emit Transfer(_from, _to, _value);
130 		return true;
131 	}
132 	function approve(address _spender, uint256 _value) notStopped public returns (bool success){
133 		allowed[msg.sender][_spender] = _value;
134 		emit Approval(msg.sender, _spender, _value);
135 		return true;
136 	}
137 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining){
138 		return allowed[_owner][_spender];
139 	}
140 }