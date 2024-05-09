1 pragma solidity ^0.4.25;
2 
3 
4 //  Logistics (OSS) is the world's first endogenous value digital passport. Based on block chain and intelligent contract network technology, it is designed for the logistics chain project application scenario construction.
5 //  Logistics (OSS)是全球首个内生价值数字通证，基于区块链和智能合约的网络技术基础之上，针对物流链项目应用场景建设而设计的数字通证.
6 
7 
8 
9 
10 library SafeMath {
11 
12  
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14    
15     if (a == 0) {
16       return 0;
17     }
18 
19     uint256 c = a * b;
20     require(c / a == b);
21 
22     return c;
23   }
24 
25   
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     require(b > 0);
28     uint256 c = a / b;
29     
30     return c;
31   }
32 
33  
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     require(b <= a);
36     uint256 c = a - b;
37 
38     return c;
39   }
40 
41   
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     require(c >= a);
45 
46     return c;
47   }
48 
49   
50   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
51     require(b != 0);
52     return a % b;
53   }
54 }
55 
56 
57 contract Logisticserc20 {
58     mapping(address => uint256) public balances;
59     mapping(address => mapping (address => uint256)) public allowed;
60     using SafeMath for uint256;
61     address public owner;
62     string public name;
63     string public symbol;
64     uint8 public decimals;
65     uint256 public totalSupply;
66 
67     uint256 private constant MAX_UINT256 = 2**256 -1 ;
68 
69     event Transfer(address indexed from, address indexed to, uint tokens);
70     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
71     
72     bool lock = false;
73 
74     constructor(
75         uint256 _initialAmount,
76         string _tokenName,
77         uint8 _decimalUnits,
78         string _tokenSymbol
79     ) public {
80         owner = msg.sender;
81         balances[msg.sender] = _initialAmount;
82         totalSupply = _initialAmount;
83         name = _tokenName;
84         decimals = _decimalUnits;
85         symbol = _tokenSymbol;
86         
87     }
88 	
89 	
90 	modifier onlyOwner {
91         require(msg.sender == owner);
92         _;
93     }
94 
95     modifier isLock {
96         require(!lock);
97         _;
98     }
99     
100     function setLock(bool _lock) onlyOwner public{
101         lock = _lock;
102     }
103 
104     function transferOwnership(address newOwner) onlyOwner public {
105         if (newOwner != address(0)) {
106             owner = newOwner;
107         }
108     }
109 	
110 	
111 
112     function transfer(
113         address _to,
114         uint256 _value
115     ) public returns (bool) {
116         require(balances[msg.sender] >= _value);
117         require(msg.sender == _to || balances[_to] <= MAX_UINT256 - _value);
118         balances[msg.sender] -= _value;
119         balances[_to] += _value;
120         emit Transfer(msg.sender, _to, _value);
121         return true;
122     }
123 
124     function transferFrom(
125         address _from,
126         address _to,
127         uint256 _value
128     ) public returns (bool) {
129         uint256 allowance = allowed[_from][msg.sender];
130         require(balances[_from] >= _value);
131         require(_from == _to || balances[_to] <= MAX_UINT256 -_value);
132         require(allowance >= _value);
133         balances[_from] -= _value;
134         balances[_to] += _value;
135         if (allowance < MAX_UINT256) {
136             allowed[_from][msg.sender] -= _value;
137         }
138         emit Transfer(_from, _to, _value);
139         return true;
140     }
141 
142     function balanceOf(
143         address _owner
144     ) public view returns (uint256) {
145         return balances[_owner];
146     }
147 
148     function approve(
149         address _spender,
150         uint256 _value
151     ) public returns (bool) {
152         allowed[msg.sender][_spender] = _value;
153         emit Approval(msg.sender, _spender, _value);
154         return true;
155     }
156 
157     function allowance(
158         address _owner,
159         address _spender
160     ) public view returns (uint256) {
161         return allowed[_owner][_spender];
162     }
163 }