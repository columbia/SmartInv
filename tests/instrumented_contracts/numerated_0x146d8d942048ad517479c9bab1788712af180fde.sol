1 pragma solidity ^0.4.24;
2 
3 contract DMIBLog {
4     event MIBLog(bytes4 indexed sig, address indexed sender, uint _value) anonymous;
5 
6     modifier mlog {
7         emit MIBLog(msg.sig, msg.sender, msg.value);
8         _;
9     }
10 }
11 
12 contract Ownable {
13     address public owner;
14 
15     event OwnerLog(address indexed previousOwner, address indexed newOwner, bytes4 sig);
16 
17     constructor() public { 
18         owner = msg.sender; 
19     }
20 
21     modifier onlyOwner {
22         require(msg.sender == owner);
23         _;
24     }
25 
26     function transferOwnership(address newOwner) onlyOwner  public {
27         require(newOwner != address(0));
28         emit OwnerLog(owner, newOwner, msg.sig);
29         owner = newOwner;
30     }
31 }
32 
33 contract MIBStop is Ownable, DMIBLog {
34 
35     bool public stopped;
36 
37     modifier stoppable {
38         require (!stopped);
39         _;
40     }
41     function stop() onlyOwner mlog public {
42         stopped = true;
43     }
44     function start() onlyOwner mlog public {
45         stopped = false;
46     }
47 }
48 
49 library SafeMath {
50     
51     /**
52      * @dev Multiplies two numbers, throws on overflow.
53     */
54     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
55         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
56         // benefit is lost if 'b' is also tested.
57         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
58         if (a == 0) {
59           return 0;
60         }
61 
62         c = a * b;
63         assert(c / a == b);
64         return c;
65     }
66 
67     /**
68      * @dev Integer division of two numbers, truncating the quotient.
69     */
70     function div(uint256 a, uint256 b) internal pure returns (uint256) {
71         // assert(b > 0); // Solidity automatically throws when dividing by 0
72         // uint256 c = a / b;
73         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74         return a / b;
75     }
76 
77     /**
78      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
79     */
80     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81         assert(b <= a);
82         return a - b;
83     }
84 
85     /**
86      * @dev Adds two numbers, throws on overflow.
87     */
88     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
89         c = a + b;
90         assert(c >= a);
91         return c;
92     }
93 }
94 
95 contract ERC20Basic {
96     function totalSupply() public view returns (uint256);
97     function balanceOf(address who) public view returns (uint256);
98     function transfer(address to, uint256 value) public returns (bool);
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 }
101 
102 contract ERC20 is ERC20Basic {
103     function allowance(address owner, address spender) public view returns (uint256);
104     function approve(address spender, uint256 value) public returns (bool);
105     function transferFrom(address from, address to, uint256 value) public returns (bool);
106 
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 contract MIBToken is ERC20, MIBStop {
111     uint256 public _totalsupply;
112     string public constant name = "Mobile Integrated Blockchain";
113     string public constant symbol = "MIB";
114     uint public constant decimals = 18;
115     using SafeMath for uint256;
116 
117     /* Actual balances of token holders */
118     mapping(address => uint256) public balances;
119     
120     mapping (address => mapping (address => uint256)) public allowed;    
121 
122     event Burn(address indexed from, uint256 value);  
123 
124     constructor (uint256 _totsupply) public {
125 		_totalsupply = _totsupply.mul(1e18);
126         balances[msg.sender] = _totalsupply;
127     }
128 
129     function totalSupply() public view returns (uint256) {
130         return _totalsupply;
131     }
132     
133     function balanceOf(address who) public view returns (uint256) {
134         return balances[who];
135     }
136 
137     function transfer(address to, uint256 value) stoppable public returns (bool) {
138         require(to != address(0));
139 
140         balances[to] = balances[to].add(value);
141         balances[msg.sender] = balances[msg.sender].sub(value);
142         
143         emit Transfer(msg.sender, to, value);
144 
145         return true;
146     }
147     
148     function transferFrom(address from, address to, uint256 value) stoppable public returns (bool) {
149         require(to != address(0));
150 
151         balances[from] = balances[from].sub(value);
152         balances[to] = balances[to].add(value);
153         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
154         emit Transfer(from, to, value);
155         return true;
156     }
157       
158     function safeApprove(address _spender, uint256 _currentValue, uint256 _newValue)
159     public returns (bool success) {
160         if (allowance(msg.sender, _spender) == _currentValue)
161           return approve(_spender, _newValue);
162         else return false;
163     }
164     
165     function approve(address spender, uint256 value) stoppable public returns (bool success) {
166         allowed[msg.sender][spender] = value;
167         emit Approval(msg.sender, spender, value);
168         return true;
169     }
170   
171     function allowance(address owner, address spender) public view returns (uint256) {
172         return allowed[owner][spender];
173     }
174     
175     function burn(uint256 value) public {
176         balances[msg.sender] = balances[msg.sender].sub(value);
177         _totalsupply = _totalsupply.sub(value);
178         emit Burn(msg.sender, value);
179     }
180     
181     function burnFrom(address who, uint256 value) public onlyOwner payable returns (bool success) {
182         
183         balances[who] = balances[who].sub(value);
184         balances[msg.sender] = balances[msg.sender].add(value);
185 
186         emit Burn(who, value);
187         return true;
188     }
189 }