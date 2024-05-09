1 /*
2 ****************************
3 ****************************
4 BETVIBE token contract
5 ****************************
6 ****************************
7 */
8 
9 pragma solidity ^0.4.24;
10 
11 /**
12  * @title SafeMath
13  */
14 library SafeMath {
15 
16     /**
17     * @dev Multiplies two numbers, throws on overflow.
18     */
19     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
20         if (a == 0) {
21             return 0;
22         }
23         c = a * b;
24         assert(c / a == b);
25         return c;
26     }
27 
28     /**
29     * @dev Integer division of two numbers, truncating the quotient.
30     */
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         // assert(b > 0); // Solidity automatically throws when dividing by 0
33         // uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35         return a / b;
36     }
37 
38     /**
39     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40     */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         assert(b <= a);
43         return a - b;
44     }
45 
46     /**
47     * @dev Adds two numbers, throws on overflow.
48     */
49     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
50         c = a + b;
51         assert(c >= a);
52         return c;
53     }
54 }
55 
56 contract ERC20Basic {
57     uint256 public totalSupply;
58     function balanceOf(address who) public constant returns (uint256);
59     function transfer(address to, uint256 value) public returns (bool);
60     event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 contract ERC20 is ERC20Basic {
64     function allowance(address owner, address spender) public constant returns (uint256);
65     function transferFrom(address from, address to, uint256 value) public returns (bool);
66     function approve(address spender, uint256 value) public returns (bool);
67     event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 contract BETVIBE is ERC20 {
71     
72     using SafeMath for uint256;
73     address public owner;
74 
75     mapping (address => uint256) balances;
76     mapping (address => mapping (address => uint256)) allowed;    
77 
78     string public constant name = "BETVIBE TOKEN";
79     string public constant symbol = "VIBET";
80     uint public constant decimals = 8;
81     
82     uint256 public maxSupply = 12000000000e8;
83     uint256 public constant minContrib = 1 ether / 100;
84     uint256 public VIBETPerEther = 20000000e8;
85 
86     event Transfer(address indexed _from, address indexed _to, uint256 _value);
87     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
88     event Burn(address indexed burner, uint256 value);
89     constructor () public {
90         totalSupply = maxSupply;
91         balances[msg.sender] = maxSupply;
92         owner = msg.sender;
93     }
94     modifier onlyOwner() {
95         require(msg.sender == owner);
96         _;
97     }
98 
99     function () public payable {
100         buyVIBET();
101      }
102     
103     function buyVIBET() payable public {
104         address investor = msg.sender;
105         uint256 tokenAmt =  VIBETPerEther.mul(msg.value) / 1 ether;
106         require(msg.value >= minContrib && msg.value > 0);
107         require(balances[owner] >= tokenAmt);
108         balances[owner] -= tokenAmt;
109         balances[investor] += tokenAmt;
110         owner.transfer(msg.value);
111         emit Transfer(this, investor, tokenAmt);   
112     }
113 
114     function balanceOf(address _owner) constant public returns (uint256) {
115         return balances[_owner];
116     }
117 
118     //mitigates the ERC20 short address attack
119     //suggested by izqui9 @ http://bit.ly/2NMMCNv
120     modifier onlyPayloadSize(uint size) {
121         assert(msg.data.length >= size + 4);
122         _;
123     }
124     
125     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
126         require(_to != address(0));
127         require(_amount <= balances[msg.sender]);
128         balances[msg.sender] = balances[msg.sender].sub(_amount);
129         balances[_to] = balances[_to].add(_amount);
130         emit Transfer(msg.sender, _to, _amount);
131         return true;
132     }
133     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
134         require(_to != address(0));
135         require(_amount <= balances[_from]);
136         require(_amount <= allowed[_from][msg.sender]);
137         balances[_from] = balances[_from].sub(_amount);
138         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
139         balances[_to] = balances[_to].add(_amount);
140         emit Transfer(_from, _to, _amount);
141         return true;
142     }
143     
144     function approve(address _spender, uint256 _value) public returns (bool success) {
145         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
146         allowed[msg.sender][_spender] = _value;
147         emit Approval(msg.sender, _spender, _value);
148         return true;
149     }
150     
151     function allowance(address _owner, address _spender) constant public returns (uint256) {
152         return allowed[_owner][_spender];
153     }
154     
155     function transferOwnership(address _newOwner) onlyOwner public {
156         if (_newOwner != address(0)) {
157             owner = _newOwner;
158         }
159     }
160     
161     function burn(uint256 _value) onlyOwner public {
162         require(_value <= balances[msg.sender]);
163         address burner = msg.sender;
164         balances[burner] = balances[burner].sub(_value);
165         totalSupply = totalSupply.sub(_value);
166         emit Burn(burner, _value);
167     }
168     
169 }