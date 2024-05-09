1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  */
6 library SafeMath {
7 
8     /**
9     * @dev Multiplies two numbers, throws on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12         if (a == 0) {
13             return 0;
14         }
15         c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19 
20     /**
21     * @dev Integer division of two numbers, truncating the quotient.
22     */
23     function div(uint256 a, uint256 b) internal pure returns (uint256) {
24         // assert(b > 0); // Solidity automatically throws when dividing by 0
25         // uint256 c = a / b;
26         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27         return a / b;
28     }
29 
30     /**
31     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32     */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     /**
39     * @dev Adds two numbers, throws on overflow.
40     */
41     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42         c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 }
47 
48 contract ERC20Basic {
49     uint256 public totalSupply;
50     function balanceOf(address who) public constant returns (uint256);
51     function transfer(address to, uint256 value) public returns (bool);
52     event Transfer(address indexed from, address indexed to, uint256 value);
53 }
54 
55 contract ERC20 is ERC20Basic {
56     function allowance(address owner, address spender) public constant returns (uint256);
57     function transferFrom(address from, address to, uint256 value) public returns (bool);
58     function approve(address spender, uint256 value) public returns (bool);
59     event Approval(address indexed owner, address indexed spender, uint256 value);
60 }
61 
62 contract IOD is ERC20 {
63 
64     using SafeMath for uint256;
65     address public owner;
66 
67     mapping (address => uint256) balances;
68     mapping (address => mapping (address => uint256)) allowed;
69 
70     string public constant name = "IOD Token";
71     string public constant symbol = "IOD";
72     string public version  = "v.0.1";
73     uint public constant decimals = 8;
74 
75     uint256 public maxSupply = 13000000000e8;
76     uint256 public constant minContrib = 1 ether / 100;
77     uint256 public IODPerEther = 15000000e8;
78 
79     event Transfer(address indexed _from, address indexed _to, uint256 _value);
80     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
81     event Burn(address indexed burner, uint256 value);
82     constructor () public {
83         totalSupply = maxSupply;
84         balances[msg.sender] = maxSupply;
85         owner = msg.sender;
86     }
87     modifier onlyOwner() {
88         require(msg.sender == owner);
89         _;
90     }
91 
92     function () public payable {
93         buyIOD();
94      }
95 
96     function dividend(uint256 _amount) internal view returns (uint256){
97         if(_amount >= IODPerEther.div(2) && _amount < IODPerEther){ return ((20*_amount).div(100)).add(_amount);}
98         else if(_amount >= IODPerEther && _amount < IODPerEther.mul(5)){return ((40*_amount).div(100)).add(_amount);}
99         else if(_amount >= IODPerEther.mul(5)){return ((70*_amount).div(100)).add(_amount);}
100         return _amount;
101     }
102 
103     function buyIOD() payable public {
104         address investor = msg.sender;
105         uint256 tokenAmt =  IODPerEther.mul(msg.value) / 1 ether;
106         require(msg.value >= minContrib && msg.value > 0);
107         tokenAmt = dividend(tokenAmt);
108         require(balances[owner] >= tokenAmt);
109         balances[owner] -= tokenAmt;
110         balances[investor] += tokenAmt;
111         emit Transfer(this, investor, tokenAmt);
112     }
113 
114     function balanceOf(address _owner) constant public returns (uint256) {
115         return balances[_owner];
116     }
117 
118     modifier onlyPayloadSize(uint size) {
119         assert(msg.data.length >= size + 4);
120         _;
121     }
122 
123     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
124         require(_to != address(0));
125         require(_amount <= balances[msg.sender]);
126         balances[msg.sender] = balances[msg.sender].sub(_amount);
127         balances[_to] = balances[_to].add(_amount);
128         emit Transfer(msg.sender, _to, _amount);
129         return true;
130     }
131     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
132         require(_to != address(0));
133         require(_amount <= balances[_from]);
134         require(_amount <= allowed[_from][msg.sender]);
135         balances[_from] = balances[_from].sub(_amount);
136         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
137         balances[_to] = balances[_to].add(_amount);
138         emit Transfer(_from, _to, _amount);
139         return true;
140     }
141 
142     function approve(address _spender, uint256 _value) public returns (bool success) {
143         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
144         allowed[msg.sender][_spender] = _value;
145         emit Approval(msg.sender, _spender, _value);
146         return true;
147     }
148 
149     function allowance(address _owner, address _spender) constant public returns (uint256) {
150         return allowed[_owner][_spender];
151     }
152 
153     function transferOwnership(address _newOwner) onlyOwner public {
154         if (_newOwner != address(0)) {
155             owner = _newOwner;
156         }
157     }
158 
159     function withdrawFund() onlyOwner public {
160         address thisCont = this;
161         uint256 ethBal = thisCont.balance;
162         owner.transfer(ethBal);
163     }
164 
165     function burn(uint256 _value) onlyOwner public {
166         require(_value <= balances[msg.sender]);
167         address burner = msg.sender;
168         balances[burner] = balances[burner].sub(_value);
169         totalSupply = totalSupply.sub(_value);
170         emit Burn(burner, _value);
171     }
172 
173 }