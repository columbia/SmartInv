1 pragma solidity ^0.4.16;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a / b;
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 contract owned {
32     address public owner;
33     mapping (address => bool) public owners;
34     
35     constructor() public {
36         owner = msg.sender;
37         owners[msg.sender] = true;
38     }
39     
40     modifier zeus {
41         require(msg.sender == owner);
42         _;
43     }
44 
45     modifier athena {
46         require(owners[msg.sender] == true);
47         _;
48     }
49 
50     function addOwner(address _newOwner) zeus public {
51         owners[_newOwner] = true;
52     }
53     
54     function removeOwner(address _oldOwner) zeus public {
55         owners[_oldOwner] = false;
56     }
57     
58     function transferOwnership(address newOwner) public zeus {
59         owner = newOwner;
60         owners[newOwner] = true;
61         owners[owner] = false;
62     }
63 }
64 
65 contract ContractConn {
66     function transfer(address _to, uint _value) public;
67 }
68 
69 contract FB is owned{
70     
71     using SafeMath for uint256;
72     
73     string public name;
74     string public symbol;
75     uint8 public decimals = 18;  
76     uint256 public totalSupply;
77 
78     uint256 private constant DAY30 = 2592000;
79     mapping (address => uint256) public balanceOf;
80     mapping (address => mapping (address => uint256)) public allowance;
81     mapping (address => uint256) private lockType;
82     mapping (address => uint256) private freezeTotal;
83     mapping (address => uint256) private freezeBalance;
84     mapping (address => uint256) private startReleaseTime;
85     mapping (address => uint256) private endLockTime;
86     
87     event Transfer(address indexed from, address indexed to, uint256 value);
88     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
89     
90     constructor() public {
91         totalSupply = 1000000000 * 10 ** uint256(decimals);  
92         balanceOf[msg.sender] = totalSupply;                
93         name = "Five Blessings";                                   
94         symbol = "FB";                               
95     }
96 
97     
98     function _transfer(address _from, address _to, uint _value) internal {
99         require(balanceOf[_from] >= _value);
100         require(balanceOf[_to].add(_value) > balanceOf[_to]);
101 		if(freezeBalance[_from] > 0){
102 			if(now >= endLockTime[_from]){
103 				delete freezeBalance[_from];
104 			}else if(now >= startReleaseTime[_from]){
105 				uint256 locks;
106 				if(lockType[_from] == 1){
107 					locks = (now - startReleaseTime[_from]) / DAY30 * 1;
108 					freezeBalance[_from] = freezeTotal[_from] * (12 - locks) / 12;
109 				}else if(lockType[_from] == 2){
110 					locks = (now - startReleaseTime[_from]) / DAY30 * 20;
111 					freezeBalance[_from] = freezeTotal[_from] * (100 - locks) / 100;
112 				}
113 			}
114 			require(_value <= balanceOf[_from] - freezeBalance[_from]);
115 		}
116         balanceOf[_from] = balanceOf[_from].sub(_value);
117         balanceOf[_to] = balanceOf[_to].add(_value);
118         emit Transfer(_from, _to, _value);
119     }
120 
121     function transfer(address _to, uint256 _value) public returns (bool){
122         _transfer(msg.sender, _to, _value);
123         return true;
124     }
125 
126     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
127         require(_value <= allowance[_from][msg.sender]);     
128         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
129         _transfer(_from, _to, _value);
130         return true;
131     }
132 
133     function approve(address _spender, uint256 _value) public returns (bool) {
134         require(balanceOf[msg.sender] >= _value);
135         allowance[msg.sender][_spender] = _value;
136         emit Approval(msg.sender,_spender,_value);
137         return true;
138     }
139     
140     function lock (uint256 _type, address _to, uint256 _value) public athena {
141         require(lockType[_to] == 0, "Each address can only be locked once and only accepts one lock mode.");
142         lockType[_to] = _type;
143         freezeTotal[_to] = _value;
144         startReleaseTime[_to] = DAY30 * 11 + now;
145         if (_type == 1) {
146             freezeBalance[_to] = freezeTotal[_to].mul(12).div(12);
147             endLockTime[_to] =  DAY30 * 12 + startReleaseTime[_to];
148         } else if (_type == 2) {
149             freezeBalance[_to] = freezeTotal[_to].mul(100).div(100);
150             endLockTime[_to] =  DAY30 * 5 + startReleaseTime[_to];
151         }
152         _transfer(msg.sender, _to, _value);
153     }
154     
155     function extract(address _tokenAddr,address _to,uint256 _value) public athena{
156        ContractConn conn = ContractConn(_tokenAddr);
157        conn.transfer(_to,_value);
158     }
159   
160     function extractEth(uint256 _value) athena public{
161        msg.sender.transfer(_value);
162     }
163  
164 }