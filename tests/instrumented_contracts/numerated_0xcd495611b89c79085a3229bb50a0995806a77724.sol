1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17           return 0;
18         }
19         
20         c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24     
25     /**
26     * @dev Integer division of two numbers, truncating the quotient.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return a / b;
33     }
34     
35     /**
36     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;   
41     }
42     
43     /**
44     * @dev Adds two numbers, throws on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47         c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 contract ERC20 {
54     
55     function balanceOf(address who) public view returns (uint256);
56     
57     function transfer(address to, uint256 value) public returns (bool);
58     
59     function allowance(address owner, address spender) public view returns (uint256);
60     
61     function transferFrom(address from, address to, uint256 value) public returns (bool);
62     
63     function approve(address spender, uint256 value) public returns (bool);
64     
65     event Approval(address indexed owner,address indexed spender,uint256 value);
66     
67     event Transfer(address indexed from, address indexed to, uint256 value);
68 }
69 
70 contract ColorCoin is ERC20 {
71     
72     using SafeMath for uint256;
73 
74     mapping (address => mapping (address => uint256)) private allowed;
75     
76     mapping(address => uint256) private balances;
77     
78     mapping(address => bool) private lockedAddresses;
79     
80     address private admin;
81     
82     address private founder;
83     
84     bool public isTransferable = false;
85     
86     string public name;
87     
88     string public symbol;
89     
90     uint256 public totalSupply;
91     
92     uint8 public decimals;
93     
94     constructor(address _founder, address _admin) public {
95         name = "Color Coin";
96         symbol = "COL";
97         totalSupply = 500000000000000000000000000;
98         decimals = 18;
99         admin = _admin;
100         founder = _founder;
101         balances[founder] = totalSupply;
102         emit Transfer(0x0, founder, totalSupply);
103     }
104     
105     modifier onlyAdmin {
106         require(admin == msg.sender);
107         _;
108     }
109     
110     modifier onlyFounder {
111         require(founder == msg.sender);
112         _;
113     }
114     
115     modifier transferable {
116         require(isTransferable);
117         _;
118     }
119     
120     modifier notLocked {
121         require(!lockedAddresses[msg.sender]);
122         _;
123     }
124     
125     function balanceOf(address _owner) public view returns (uint256) {
126         return balances[_owner];
127     }
128     
129     function transfer(address _to, uint256 _value) transferable notLocked public returns (bool) {
130         require(_to != address(0));
131         require(_value <= balances[msg.sender]);
132         
133         balances[msg.sender] = balances[msg.sender].sub(_value);
134         balances[_to] = balances[_to].add(_value);
135         emit Transfer(msg.sender, _to, _value);
136         return true;
137     }
138     
139     function transferFrom(address _from, address _to, uint256 _value) transferable public returns (bool) {
140         require(!lockedAddresses[_from]);
141         require(_to != address(0));
142         require(_value <= balances[_from]);
143         require(_value <= allowed[_from][msg.sender]);
144         
145         balances[_from] = balances[_from].sub(_value);
146         balances[_to] = balances[_to].add(_value);
147         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
148         emit Transfer(_from, _to, _value);
149         return true;
150     }
151     
152     function approve(address _spender, uint256 _value) transferable notLocked public returns (bool) {
153         allowed[msg.sender][_spender] = _value;
154         emit Approval(msg.sender, _spender, _value);
155         return true;
156     }
157     
158     function allowance(address _owner, address _spender) public view returns (uint256) {
159         return allowed[_owner][_spender];
160     }
161     
162     function distribute(address _to, uint256 _value) onlyFounder public returns (bool) {
163         require(_to != address(0));
164         require(_value <= balances[msg.sender]);
165         
166         balances[msg.sender] = balances[msg.sender].sub(_value);
167         balances[_to] = balances[_to].add(_value);
168         emit Transfer(msg.sender, _to, _value);
169         return true;
170     }
171     
172     function claimToken(address tokenContract, address _to, uint256 _value) onlyAdmin public returns (bool) {
173         require(tokenContract != address(0));
174         require(_to != address(0));
175         require(_value > 0);
176         
177         ERC20 token = ERC20(tokenContract);
178 
179         return token.transfer(_to, _value);
180     }
181     
182     function lock(address who) onlyAdmin public {
183         
184         lockedAddresses[who] = true;
185     }
186     
187     function unlock(address who) onlyAdmin public {
188         
189         lockedAddresses[who] = false;
190     }
191     
192     function isLocked(address who) public view returns(bool) {
193         
194         return lockedAddresses[who];
195     }
196 
197     function enableTransfer() onlyAdmin public {
198         
199         isTransferable = true;
200     }
201     
202     function disableTransfer() onlyAdmin public {
203         
204         isTransferable = false;
205     }
206 }