1 pragma solidity ^0.4.25;
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
70 contract NexyToken is ERC20 {
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
84     bool public isTransferable = true;
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
95         name = "Nexy Token";
96         symbol = "NXY";
97         totalSupply = 10000000000000000000000000000;
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
110     modifier transferable {
111         require(isTransferable);
112         _;
113     }
114     
115     modifier notLocked {
116         require(!lockedAddresses[msg.sender]);
117         _;
118     }
119     
120     function balanceOf(address _owner) public view returns (uint256) {
121         return balances[_owner];
122     }
123     
124     function transfer(address _to, uint256 _value) transferable notLocked public returns (bool) {
125         require(_value <= balances[msg.sender]);
126         
127         balances[msg.sender] = balances[msg.sender].sub(_value);
128         balances[_to] = balances[_to].add(_value);
129         emit Transfer(msg.sender, _to, _value);
130         return true;
131     }
132     
133     function transferFrom(address _from, address _to, uint256 _value) transferable public returns (bool) {
134         require(!lockedAddresses[_from]);
135         require(_value <= balances[_from]);
136         require(_value <= allowed[_from][msg.sender]);
137         
138         balances[_from] = balances[_from].sub(_value);
139         balances[_to] = balances[_to].add(_value);
140         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
141         emit Transfer(_from, _to, _value);
142         return true;
143     }
144     
145     function approve(address _spender, uint256 _value) transferable notLocked public returns (bool) {
146         allowed[msg.sender][_spender] = _value;
147         emit Approval(msg.sender, _spender, _value);
148         return true;
149     }
150     
151     function allowance(address _owner, address _spender) public view returns (uint256) {
152         return allowed[_owner][_spender];
153     }
154 
155     function claimToken(address tokenContract, address _to, uint256 _value) onlyAdmin public returns (bool) {
156         require(tokenContract != address(0));
157         require(_to != address(0));
158         require(_value > 0);
159         
160         ERC20 token = ERC20(tokenContract);
161 
162         return token.transfer(_to, _value);
163     }
164     
165     function lock(address who) onlyAdmin public {
166         
167         lockedAddresses[who] = true;
168     }
169     
170     function unlock(address who) onlyAdmin public {
171         
172         lockedAddresses[who] = false;
173     }
174     
175     function isLocked(address who) public view returns(bool) {
176         
177         return lockedAddresses[who];
178     }
179 
180     function enableTransfer() onlyAdmin public {
181         
182         isTransferable = true;
183     }
184     
185     function disableTransfer() onlyAdmin public {
186         
187         isTransferable = false;
188     }
189 }