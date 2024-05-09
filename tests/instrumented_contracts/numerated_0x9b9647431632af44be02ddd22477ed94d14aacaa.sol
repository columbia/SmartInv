1 pragma solidity ^0.4.21;
2 
3 // smart contract for KOK coin 
4 
5 // ownership contract
6 contract Owned {
7     address public owner;
8 
9     event TransferOwnership(address oldaddr, address newaddr);
10 
11     modifier onlyOwner() { if (msg.sender != owner) return; _; }
12 
13     function Owned() public {
14         owner = msg.sender;
15     }
16     
17     function transferOwnership(address _new) onlyOwner public {
18         address oldaddr = owner;
19         owner = _new;
20         emit TransferOwnership(oldaddr, owner);
21     }
22 }
23 
24 // erc20
25 contract ERC20Interface {
26 	uint256 public totalSupply;
27 	function balanceOf(address _owner) public constant returns (uint256 balance);
28 	function transfer(address _to, uint256 _value) public returns (bool success);
29 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
30 	function approve(address _spender, uint256 _value) public returns (bool success);
31 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
32 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
33 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
34 }
35 
36 contract KOKContract is ERC20Interface, Owned {
37 	string public constant symbol = "KOK";
38 	string public constant name = "KOK Coin";
39 	uint8 public constant decimals = 18;
40 	uint256 public constant totalSupply = 5000000000000000000000000000;
41 
42 	bool public stopped;
43 
44 	mapping (address => int8) public blackList;
45 
46 	mapping (address => uint256) public balances;
47 	mapping (address => mapping (address => uint256)) public allowed;
48 
49 
50     event Blacklisted(address indexed target);
51     event DeleteFromBlacklist(address indexed target);
52     event RejectedPaymentToBlacklistedAddr(address indexed from, address indexed to, uint256 value);
53     event RejectedPaymentFromBlacklistedAddr(address indexed from, address indexed to, uint256 value);
54 
55 
56 	modifier notStopped {
57         require(!stopped);
58         _;
59     }
60 
61 // constructor
62 	function KOKContract() public {
63 		balances[msg.sender] = totalSupply;
64 	}
65 	
66 // function made for airdrop
67 	function airdrop(address[] _to, uint256[] _value) onlyOwner notStopped public {
68 	    for(uint256 i = 0; i < _to.length; i++){
69 	        if(balances[_to[i]] > 0){
70 	            continue;
71 	        }
72 	        transfer(_to[i], _value[i]);
73 	    }
74 	}
75 
76 // blacklist management
77     function blacklisting(address _addr) onlyOwner public {
78         blackList[_addr] = 1;
79         emit Blacklisted(_addr);
80     }
81     function deleteFromBlacklist(address _addr) onlyOwner public {
82         blackList[_addr] = -1;
83         emit DeleteFromBlacklist(_addr);
84     }
85 
86 // stop the contract
87 	function stop() onlyOwner {
88         stopped = true;
89     }
90     function start() onlyOwner {
91         stopped = false;
92     }
93 	
94 // ERC20 functions
95 	function balanceOf(address _owner) public constant returns (uint256 balance){
96 		return balances[_owner];
97 	}
98 	function transfer(address _to, uint256 _value) notStopped public returns (bool success){
99 		require(balances[msg.sender] >= _value);
100 
101 		if(blackList[msg.sender] > 0){
102 			emit RejectedPaymentFromBlacklistedAddr(msg.sender, _to, _value);
103 			return false;
104 		}
105 		if(blackList[_to] > 0){
106 			emit RejectedPaymentToBlacklistedAddr(msg.sender, _to, _value);
107 			return false;
108 		}
109 
110 		balances[msg.sender] -= _value;
111 		balances[_to] += _value;
112 		emit Transfer(msg.sender, _to, _value);
113 		return true;
114 	}
115 	function transferFrom(address _from, address _to, uint256 _value) notStopped public returns (bool success){
116 		require(balances[_from] >= _value
117 			&& allowed[_from][msg.sender] >= _value);
118 
119 		if(blackList[_from] > 0){
120 			emit RejectedPaymentFromBlacklistedAddr(_from, _to, _value);
121 			return false;
122 		}
123 		if(blackList[_to] > 0){
124 			emit RejectedPaymentToBlacklistedAddr(_from, _to, _value);
125 			return false;
126 		}
127 
128 		balances[_from] -= _value;
129 		allowed[_from][msg.sender] -= _value;
130 		balances[_to] += _value;
131 		emit Transfer(_from, _to, _value);
132 		return true;
133 	}
134 	function approve(address _spender, uint256 _value) notStopped public returns (bool success){
135 		allowed[msg.sender][_spender] = _value;
136 		emit Approval(msg.sender, _spender, _value);
137 		return true;
138 	}
139 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining){
140 		return allowed[_owner][_spender];
141 	}
142 }