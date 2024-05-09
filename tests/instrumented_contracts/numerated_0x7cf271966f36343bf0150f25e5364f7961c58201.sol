1 pragma solidity ^0.4.15;
2 
3 contract Base {
4     
5     modifier only(address allowed) {
6         require(msg.sender == allowed);
7         _;
8     }
9 
10     // *************************************************
11     // *          reentrancy handling                  *
12     // *************************************************
13 
14     uint private bitlocks = 0;
15     modifier noReentrancy(uint m) {
16         var _locks = bitlocks;
17         require(_locks & m <= 0);
18         bitlocks |= m;
19         _;
20         bitlocks = _locks;
21     }
22 
23     modifier noAnyReentrancy {
24         var _locks = bitlocks;
25         require(_locks <= 0);
26         bitlocks = uint(-1);
27         _;
28         bitlocks = _locks;
29     }
30 
31     modifier reentrant { _; }
32 }
33 
34 contract Owned {
35     address public owner;
36     address public newOwner;
37     
38     modifier onlyOwner() {
39         require(msg.sender == owner);
40         _;
41     }
42 
43     function Owned() public {
44         owner = msg.sender;
45     }
46 
47     function transferOwnership(address _newOwner) onlyOwner public {
48         newOwner = _newOwner;
49     }
50 
51     function acceptOwnership() onlyOwner public {
52         OwnershipTransferred(owner, newOwner);
53         owner = newOwner;
54     }
55 
56     event OwnershipTransferred(address indexed _from, address indexed _to);
57 }
58 
59 library SafeMath {
60     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
61         uint256 c = a * b;
62         assert(a == 0 || c / a == b);
63         return c;
64     }
65 
66     function div(uint256 a, uint256 b) internal constant returns (uint256) {
67         // assert(b > 0); // Solidity automatically throws when dividing by 0
68         uint256 c = a / b;
69         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70         return c;
71     }
72 
73     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
74         assert(b <= a);
75         return a - b;
76     }
77 
78     function add(uint256 a, uint256 b) internal constant returns (uint256) {
79         uint256 c = a + b;
80         assert(c >= a);
81         return c;
82     }
83 }
84 
85 contract ERC20 {
86     uint256 public totalSupply;
87   
88     function balanceOf(address who) public constant returns (uint256);
89     function transfer(address to, uint256 value) public returns (bool);
90     function allowance(address owner, address spender) public constant returns (uint256);
91     function transferFrom(address from, address to, uint256 value) public returns (bool);
92     function approve(address spender, uint256 value) public returns (bool);
93   
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 }
97 
98 contract StandartToken is ERC20 {
99     using SafeMath for uint256;
100 
101     mapping(address => uint256) balances;
102     mapping (address => mapping (address => uint256)) allowed;
103     
104     bool public isStarted = false;
105     
106     modifier isStartedOnly() {
107         require(isStarted);
108         _;
109     }
110 
111     function transfer(address _to, uint256 _value) isStartedOnly public returns (bool) {
112         require(_to != address(0));
113         require(_value <= balances[msg.sender]);
114 
115         // SafeMath.sub will throw if there is not enough balance.
116         balances[msg.sender] = balances[msg.sender].sub(_value);
117         balances[_to] = balances[_to].add(_value);
118         Transfer(msg.sender, _to, _value);
119         return true;
120     }
121 
122     function balanceOf(address _owner) public constant returns (uint256 balance) {
123         return balances[_owner];
124     }
125   
126     function transferFrom(address _from, address _to, uint256 _value) isStartedOnly public returns (bool) {
127         require(_to != address(0));
128         require(_value <= balances[_from]);
129         require(_value <= allowed[_from][msg.sender]);
130 
131         balances[_from] = balances[_from].sub(_value);
132         balances[_to] = balances[_to].add(_value);
133         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
134         Transfer(_from, _to, _value);
135         return true;
136     }
137 
138     function approve(address _spender, uint256 _value) isStartedOnly public returns (bool) {
139         allowed[msg.sender][_spender] = _value;
140         Approval(msg.sender, _spender, _value);
141         return true;
142     }
143 
144     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
145         return allowed[_owner][_spender];
146     }
147 
148     function increaseApproval (address _spender, uint _addedValue) isStartedOnly public returns (bool success) {
149         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
150         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
151         return true;
152     }
153 
154     function decreaseApproval (address _spender, uint _subtractedValue) isStartedOnly public returns (bool success) {
155         uint oldValue = allowed[msg.sender][_spender];
156         if (_subtractedValue > oldValue) {
157             allowed[msg.sender][_spender] = 0;
158         } else {
159             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
160         }
161         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162         return true;
163     }
164 }
165 
166 //Contract belongs to Aridika Corporation OU
167 //Nominal (initial) cost of one token = 1$
168 
169 contract Token is Owned, StandartToken {
170     string public name = "CRYPTODEPOZIT";
171     string public symbol = "DEPO";
172     uint public decimals = 0;
173     address public constant company = 0xC01aed0F75f117d1f47f9146E41C9A6E0870350e;
174     
175     function Token() public {
176         mint(msg.sender, 10 ** 9);
177         mint(company, 10 * 10 ** 6);
178         start();
179     }
180 
181     function () public {
182         revert();
183     }
184 
185     function mint(address _to, uint256 _amount)
186         internal
187         returns (bool)
188     {
189         totalSupply = totalSupply.add(_amount);
190         balances[_to] = balances[_to].add(_amount);
191         return true;
192     }
193 
194     function start()
195         internal
196         returns (bool)
197     {
198         isStarted = true;
199         return true;
200     }
201 }