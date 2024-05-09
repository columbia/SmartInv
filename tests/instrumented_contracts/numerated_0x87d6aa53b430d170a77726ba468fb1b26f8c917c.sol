1 pragma solidity 0.4.24;
2 
3 /*
4 * SafeMath to avoid data overwrite
5 */
6 library SafeMath {
7     function mul(uint a, uint b) internal pure returns (uint) {
8         uint c = a * b;
9         require(a == 0 || c / a == b);
10         return c;
11     }
12 
13     function div(uint a, uint b) internal pure returns (uint) {
14         require(b > 0);
15         uint c = a / b;
16         require(a == b * c + a % b);
17         return c;
18     }
19 
20     function sub(uint a, uint b) internal pure returns (uint) {
21         require(b <= a);
22         return a - b;
23     }
24 
25     function add(uint a, uint b) internal pure returns (uint) {
26         uint c = a + b;
27         require(c>=a && c>=b);
28         return c;
29     }
30 }
31 
32 /*
33  * 
34  * find in https://github.com/ethereum/EIPs/issues/20
35  */
36 contract ERC20 {
37     function balanceOf(address _owner) view public returns (uint256 balance);
38     function transfer(address _to, uint256 _value) public returns (bool success);
39     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
40     function approve(address _spender, uint256 _value) public returns (bool success);
41     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
42     event Transfer(address indexed _from, address indexed _to, uint256 _value);
43     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
44 }
45 
46 contract Ownable {
47     address public owner;
48 
49     constructor () public {
50         owner = msg.sender;
51     }
52 
53     modifier onlyOwner() {
54         if (msg.sender != owner) {
55             revert();
56         }
57         _;
58     }
59 
60     modifier validAddress {
61         assert(0x0 != msg.sender);
62         _;
63     }
64 
65     function transferOwnership(address newOwner) onlyOwner validAddress public {
66         if (newOwner != address(0)) {
67             owner = newOwner;
68         }
69     }
70 }
71 
72 contract Lockable is Ownable {
73     bool public lockStatus = false;
74     
75     event Lock(address);    
76     event UnLock(address);
77     
78     modifier unLocked() {
79         assert(!lockStatus);
80         _;
81     }
82 
83     modifier inLocked() {
84         assert(lockStatus);
85         _;
86     }
87     
88     function lock() onlyOwner unLocked public returns (bool) {
89         lockStatus = true;
90         emit Lock(msg.sender);
91         return true;
92     }
93 
94     function unlock() onlyOwner inLocked public returns (bool) {
95         lockStatus = false;
96         emit UnLock(msg.sender);
97         return true;
98     }
99 
100 }
101 
102 /* 
103  * @title Standard ERC20 token
104  * @dev Implemantation of the basic standart token.
105  * @dev https://github.com/ethereum/EIPs/issues/20
106  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
107  */
108 contract StandardToken is ERC20, Lockable {
109     using SafeMath for uint;
110     string public name;
111     string public symbol;
112     uint8 public decimals;
113     uint256 public totalSupply;
114     mapping (address => uint256) public balanceOf;
115     mapping (address => mapping (address => uint256)) public allowance;
116 
117     function balanceOf(address _owner) view public returns (uint256 balance){
118         require(address(0) != _owner);
119         return balanceOf[_owner];
120     }
121     
122     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
123         require(address(0) != _owner);
124         require(address(0) != _spender);
125         return allowance[_owner][_spender];
126     }
127 
128     function transfer(address _to, uint256 _value) unLocked public returns (bool success) {
129         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
130         balanceOf[_to] = balanceOf[_to].add(_value);
131         emit Transfer(msg.sender, _to, _value);
132         return true;
133     }
134 
135     function transferFrom(address _from, address _to, uint256 _value) unLocked public returns (bool success) {
136         balanceOf[_to] = balanceOf[_to].add(_value);
137         balanceOf[_from] = balanceOf[_from].sub(_value);
138         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
139         emit Transfer(_from, _to, _value);
140         return true;
141     }
142     
143     function approve(address _spender, uint256 _value) public returns (bool success) {
144         require(address(0) != _spender);
145         allowance[msg.sender][_spender] = _value;
146         emit Approval(msg.sender, _spender, _value);
147         return true;
148     }
149 
150 }
151 
152 contract TokenTemp is StandardToken {
153     constructor (uint256 _supply, string _name, string _symbol, uint8 _decimals) public {
154         totalSupply = _supply * 10 ** uint256(_decimals); 
155         name = _name;
156         symbol = _symbol;
157         decimals = _decimals;
158         balanceOf[msg.sender] = totalSupply;
159     }
160 }