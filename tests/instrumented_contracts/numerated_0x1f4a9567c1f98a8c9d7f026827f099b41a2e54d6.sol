1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5         if (a == 0) {
6             return 0;
7         }
8         c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         assert(b != 0);
15         return a / b;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
24         c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 contract Ownable {
31 	address public owner;
32 	address public authorizedCaller;
33 
34 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36 	constructor() public {
37 		owner = msg.sender;
38 		authorizedCaller = msg.sender;
39 	}
40 	modifier onlyOwner() {
41 		require(msg.sender == owner);
42 		_;
43 	}
44 	modifier onlyAuthorized() {
45 		require(msg.sender == owner || msg.sender == authorizedCaller);
46 		_;
47 	}
48 	function transferAuthorizedCaller(address _newAuthorizedCaller) public onlyOwner {
49 		require(_newAuthorizedCaller != address(0));
50 		authorizedCaller = _newAuthorizedCaller;
51 	}
52 	function transferOwnership(address _newOwner) public onlyOwner {
53 		require(_newOwner != address(0));
54 		emit OwnershipTransferred(owner, _newOwner);
55 		owner = _newOwner;
56 	}
57 }
58 
59 contract ERC20 {
60     function balanceOf(address _tokenOwner) public view returns (uint);
61     function transfer(address _to, uint _amount) public returns (bool);
62     function transferFrom(address _from, address _to, uint _amount) public returns (bool);
63     function allowance(address _tokenOwner, address _spender) public view returns (uint);
64     function approve(address _spender, uint _amount) public returns (bool);
65 
66     event Transfer(address indexed from, address indexed to, uint tokens);
67     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
68 }
69 
70 contract DreamcatcherToken is ERC20, Ownable {
71     using SafeMath for uint256;
72 
73     uint256 public constant totalSupply = 2500000000000;
74     string public constant name = "DREAMCATCHER";
75     string public constant symbol = "DRC";
76     uint8 public constant decimals = 6;
77 
78     bool public isPayable = false;
79     bool public halted = false;
80 
81     mapping(address => uint256) internal balances;
82     mapping(address => mapping(address => uint256)) internal allowed;
83     mapping(address => bool) internal locked;
84 
85     constructor() public {
86         balances[msg.sender] = totalSupply;
87 	}
88 
89 	modifier checkHalted() {
90 	    require(halted == false);
91 	    _;
92 	}
93 
94 	function () public payable {
95 	    if(isPayable == false || halted == true) {
96 	        revert();
97 	    }
98     }
99 
100     function sendEther(address _receiver, uint256 _amount) external payable onlyAuthorized returns(bool) {
101         if (isPayable == false) {
102 	        revert();
103 	    }
104 
105         return _receiver.call.value(_amount)();
106     }
107 
108     function setIsPayable(bool _isPayable) external onlyAuthorized {
109         isPayable = _isPayable;
110     }
111 
112     function setHalted(bool _halted) external onlyOwner {
113         halted = _halted;
114     }
115 
116     function setLock(address _addr, bool _lock) external onlyAuthorized {
117         locked[_addr] = _lock;
118     }
119 
120     function balanceOf(address _tokenOwner) public view returns (uint) {
121         return balances[_tokenOwner];
122     }
123 
124     function transfer(address _to, uint _amount) public checkHalted returns (bool) {
125         if(msg.sender != owner) {
126             require(locked[msg.sender] == false && locked[_to] == false);
127         }
128         balances[msg.sender] = balances[msg.sender].sub(_amount);
129         balances[_to] = balances[_to].add(_amount);
130         emit Transfer(msg.sender, _to, _amount);
131         return true;
132     }
133 
134     function transferFrom(address _from, address _to, uint _amount) public checkHalted returns (bool) {
135         if(msg.sender != owner) {
136             require(locked[msg.sender] == false && locked[_from] == false && locked[_to] == false);
137         }
138         require(_amount <= balances[_from]);
139         if(_from != msg.sender) {
140             require(_amount <= allowed[_from][msg.sender]);
141             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
142         }
143         balances[_from] = balances[_from].sub(_amount);
144         balances[_to] = balances[_to].add(_amount);
145         emit Transfer(_from, _to, _amount);
146         return true;
147     }
148 
149     function allowance(address _tokenOwner, address _spender) public view returns (uint) {
150         return allowed[_tokenOwner][_spender];
151     }
152 
153     function approve(address _spender, uint _amount) public checkHalted returns (bool) {
154         require(locked[_spender] == false && locked[msg.sender] == false);
155 
156         allowed[msg.sender][_spender] = _amount;
157         emit Approval(msg.sender, _spender, _amount);
158         return true;
159     }
160 }