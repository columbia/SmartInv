1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 interface IERC20 {
30     function totalSupply() constant returns (uint256 totalSupply);
31     function balanceOf(address _owner) constant returns (uint256 balance);
32     function transfer(address _to, uint256 _value) returns (bool success);
33     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
34     function approve(address _spender, uint256 _value) returns (bool success);
35     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
36     
37     event Transfer(address indexed _from, address indexed _to, uint256 _value);
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 }
40 
41 
42 
43 contract MyToken is IERC20 {
44     using SafeMath for uint256;
45 
46     string public symbol = 'KCFOB';
47     string public name = 'KC19700 OP TOKEN';
48 
49     uint8 public constant decimals = 18;
50     uint256 public constant tokensPerEther = 3500;
51 
52     uint256 public _totalSupply = 10000000000000000000000000;
53     uint256 public _maxSupply = 38000000000000000000000000;
54 
55     uint256 public totalContribution = 0;
56 
57     bool public purchasingAllowed = true;
58 
59     address public owner;
60 
61     modifier onlyOwner {
62         require(msg.sender == owner);
63         _;
64     }
65 
66     mapping(address => uint256) balances;
67     mapping (address => mapping (address => uint256)) public allowed;
68 
69 
70     function MyToken() {
71         owner = msg.sender;
72         balances[msg.sender] = _totalSupply;
73     }
74 
75 
76     function totalSupply() constant returns (uint256 totalSupply) {
77         return _totalSupply;
78     }
79     /*
80      * get some stats
81      *
82      */
83     function getStats() public constant returns (uint256, uint256,  bool) {
84         return (totalContribution, _totalSupply, purchasingAllowed);
85     }
86 
87     function getStats2() public constant returns (bool) {
88         return (purchasingAllowed);
89     }
90 
91 
92     /*
93      * somehow unnecessery 
94      */
95     function withdraw() onlyOwner {
96         owner.transfer(this.balance);
97     }
98 
99 
100     function () payable {
101         require(
102             msg.value > 0
103             && purchasingAllowed
104             && _totalSupply < _maxSupply 
105         );
106         /*  everything is in wei */
107         uint256 baseTokens  = msg.value.mul(tokensPerEther);
108 
109         /* send tokens to buyer. Buyer gets baseTokens */
110         balances[msg.sender] = balances[msg.sender].add(baseTokens);
111 
112         /* send eth to owner */
113         owner.transfer(msg.value);
114         
115         totalContribution = totalContribution.add(msg.value);
116         _totalSupply      = _totalSupply.add(baseTokens);
117 
118         Transfer(address(this), msg.sender, baseTokens);
119     }
120 
121     function enablePurchasing() public onlyOwner {
122         purchasingAllowed = true;
123     }
124 
125     function disablePurchasing() public onlyOwner {
126         purchasingAllowed = false;
127     }
128 
129 
130     function balanceOf(address _owner) constant returns (uint256 balance) {
131         return balances[_owner];
132     }
133 
134     function transfer(address _to, uint256 _value) returns (bool success) {
135         require(
136             (balances[msg.sender] >= _value)
137             && (_value > 0)
138             && (_to != address(0))
139             && (balances[_to].add(_value) >= balances[_to])
140             && (msg.data.length >= (2 * 32) + 4)
141         );
142 
143         balances[msg.sender] = balances[msg.sender].sub(_value);
144         balances[_to] = balances[_to].add(_value);
145         Transfer(msg.sender, _to, _value);
146         return true;
147     }
148 
149     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
150         require(
151             (allowed[_from][msg.sender] >= _value) // Check allowance
152             && (balances[_from] >= _value) // Check if the sender has enough
153             && (_value > 0) // Don't allow 0value transfer
154             && (_to != address(0)) // Prevent transfer to 0x0 address
155             && (balances[_to].add(_value) >= balances[_to]) // Check for overflows
156             && (msg.data.length >= (2 * 32) + 4) //mitigates the ERC20 short address attack
157             //most of these things are not necesary
158         );
159         balances[_from] = balances[_from].sub(_value);
160         balances[_to] = balances[_to].add(_value);
161         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
162         Transfer(_from, _to, _value);
163         return true;
164     }
165 
166     function approve(address _spender, uint256 _value) returns (bool success) {
167         /* To change the approve amount you first have to reduce the addresses`
168          * allowance to zero by calling `approve(_spender, 0)` if it is not
169          * already 0 to mitigate the race condition described here:
170          * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729 */
171         require(
172             (_value == 0) 
173             || (allowed[msg.sender][_spender] == 0)
174         );
175         allowed[msg.sender][_spender] = _value;
176         Approval(msg.sender, _spender, _value);
177         return true;
178     }
179 
180 
181     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
182         return allowed[_owner][_spender];
183     }
184 
185     /*
186      * events
187      */
188     event Transfer(address indexed _from, address indexed _to, uint256 _value);
189     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
190 
191 }