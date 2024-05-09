1 pragma solidity ^0.4.15;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal constant returns (uint256) {
11         // assert(b > 0); // Solidity automatically throws when dividing by 0
12         uint256 c = a / b;
13         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal constant returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract ERC20 {
30     uint256 public totalSupply;
31 
32     function balanceOf(address who) public constant returns (uint256);
33     function transfer(address to, uint256 value) public returns (bool);
34     function allowance(address owner, address spender) public constant returns (uint256);
35     function transferFrom(address from, address to, uint256 value) public returns (bool);
36     function approve(address spender, uint256 value) public returns (bool);
37 
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39     event Transfer(address indexed from, address indexed to, uint256 value);
40 }
41 
42 contract StandartToken is ERC20 {
43     using SafeMath for uint256;
44 
45     mapping(address => uint256) balances;
46     mapping (address => mapping (address => uint256)) allowed;
47 
48     bool public isStarted = false;
49 
50     modifier isStartedOnly() {
51         require(isStarted);
52         _;
53     }
54 
55     function transfer(address _to, uint256 _value) public returns (bool) {
56         require(_to != address(0));
57         require(_value <= balances[msg.sender]);
58 
59         // SafeMath.sub will throw if there is not enough balance.
60         balances[msg.sender] = balances[msg.sender].sub(_value);
61         balances[_to] = balances[_to].add(_value);
62         Transfer(msg.sender, _to, _value);
63         return true;
64     }
65 
66     function balanceOf(address _owner) public constant returns (uint256 balance) {
67         return balances[_owner];
68     }
69 
70     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
71         require(_to != address(0));
72         require(_value <= balances[_from]);
73         require(_value <= allowed[_from][msg.sender]);
74 
75         balances[_from] = balances[_from].sub(_value);
76         balances[_to] = balances[_to].add(_value);
77         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
78         Transfer(_from, _to, _value);
79         return true;
80     }
81 
82     function approve(address _spender, uint256 _value) public returns (bool) {
83         allowed[msg.sender][_spender] = _value;
84         Approval(msg.sender, _spender, _value);
85         return true;
86     }
87 
88     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
89         return allowed[_owner][_spender];
90     }
91 
92     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
93         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
94         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
95         return true;
96     }
97 
98     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
99         uint oldValue = allowed[msg.sender][_spender];
100         if (_subtractedValue > oldValue) {
101             allowed[msg.sender][_spender] = 0;
102         } else {
103             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
104         }
105         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
106         return true;
107     }
108 }
109 
110 contract Owned {
111     address public owner;
112     address public newOwner;
113     
114     modifier onlyOwner() {
115         require(msg.sender == owner);
116         _;
117     }
118 
119     function Owned() public {
120         owner = msg.sender;
121     }
122 
123     function transferOwnership(address _newOwner) onlyOwner public {
124         newOwner = _newOwner;
125     }
126 
127     function acceptOwnership() onlyOwner public {
128         OwnershipTransferred(owner, newOwner);
129         owner = newOwner;
130     }
131 
132     event OwnershipTransferred(address indexed _from, address indexed _to);
133 }
134 
135 
136 contract Token is Owned, StandartToken {
137     string public name = "NEEO";
138     string public symbol = "NEEO";
139     uint public decimals = 18;
140 
141     address public crowdsaleMinter;
142 
143     event Mint(address indexed to, uint256 amount);
144 
145     modifier canMint() {
146         require(!isStarted);
147         _;
148     }
149 
150     modifier onlyCrowdsaleMinter(){
151         require(msg.sender == crowdsaleMinter);
152         _;
153     }
154 
155     function () public {
156         revert();
157     }
158 
159     function setCrowdsaleMinter(address _crowdsaleMinter)
160         public
161         onlyOwner
162         canMint
163     {
164         crowdsaleMinter = _crowdsaleMinter;
165     }
166 
167     function mint(address _to, uint256 _amount)
168         onlyCrowdsaleMinter
169         canMint
170         public
171         returns (bool)
172     {
173         totalSupply = totalSupply.add(_amount);
174         balances[_to] = balances[_to].add(_amount);
175         Mint(_to, _amount);
176         return true;
177     }
178 
179     function start()
180         onlyCrowdsaleMinter
181         canMint
182         public
183         returns (bool)
184     {
185         isStarted = true;
186         return true;
187     }
188 }