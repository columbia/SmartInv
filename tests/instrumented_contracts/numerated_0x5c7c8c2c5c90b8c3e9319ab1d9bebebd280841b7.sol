1 pragma solidity ^ 0.4.21;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner {
16         if (newOwner != address(0)) {
17             owner = newOwner;
18         }
19     }
20 }
21 
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 library SafeMath {
28     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
29         uint256 c = a * b;
30         assert(a == 0 || c / a == b);
31         return c;
32     }
33 
34     function div(uint256 a, uint256 b) internal pure returns(uint256) {
35         // assert(b > 0); // Solidity automatically throws when dividing by 0
36         uint256 c = a / b;
37         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38         return c;
39     }
40 
41     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
42         assert(b <= a);
43         return a - b;
44     }
45 
46     function add(uint256 a, uint256 b) internal pure returns(uint256) {
47         uint256 c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 
52 }
53 
54 
55 contract HomeLoansToken is owned {
56     using SafeMath
57     for uint256;
58 
59     string public name;
60     string public symbol;
61     uint public decimals;
62     uint256 public totalSupply;
63   
64 
65     /// @dev Fix for the ERC20 short address attack http://vessenes.com/the-erc20-short-address-attack-explained/
66     /// @param size payload size
67     modifier onlyPayloadSize(uint size) {
68         require(msg.data.length >= size + 4);
69         _;
70     }
71 
72     /* This creates an array with all balances */
73     mapping(address => uint256) public balanceOf;
74     mapping(address => mapping(address => uint256)) public allowed;
75 
76     /* This generates a public event on the blockchain that will notify clients */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78     event Approval(address indexed owner, address indexed spender, uint value);
79 
80 
81 
82     function HomeLoansToken(
83         uint256 initialSupply,
84         string tokenName,
85         uint decimalUnits,
86         string tokenSymbol
87     ) {
88         owner = msg.sender;
89         totalSupply = initialSupply.mul(10 ** decimalUnits);
90         balanceOf[msg.sender] = totalSupply; // Give the creator half initial tokens
91         name = tokenName; // Set the name for display purposes
92         symbol = tokenSymbol; // Set the symbol for display purposes
93         decimals = decimalUnits; // Amount of decimals for display purposes
94     }
95 
96 
97     /// @dev Tranfer tokens to address
98     /// @param _to dest address
99     /// @param _value tokens amount
100     /// @return transfer result
101     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns(bool success) {
102         require(_to != address(0));
103         require(_value <= balanceOf[msg.sender]);
104 
105         // SafeMath.sub will throw if there is not enough balance.
106         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
107         balanceOf[_to] = balanceOf[_to].add(_value);
108         Transfer(msg.sender, _to, _value);
109         return true;
110     }
111 
112 
113     /// @dev Tranfer tokens from one address to other
114     /// @param _from source address
115     /// @param _to dest address
116     /// @param _value tokens amount
117     /// @return transfer result
118     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(2 * 32) returns(bool success) {
119         require(_to != address(0));
120         require(_value <= balanceOf[_from]);
121         require(_value <= allowed[_from][msg.sender]);
122         balanceOf[_from] = balanceOf[_from].sub(_value);
123         balanceOf[_to] = balanceOf[_to].add(_value);
124         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
125         Transfer(_from, _to, _value);
126         return true;
127     }
128 
129     /// @dev Destroy Tokens
130     ///@param destroyAmount Count Token
131     function destroyToken(uint256 destroyAmount) onlyOwner {
132         destroyAmount = destroyAmount.mul(10 ** decimals);
133         balanceOf[owner] = balanceOf[owner].sub(destroyAmount);
134         totalSupply = totalSupply.sub(destroyAmount);
135 
136     }
137 
138     /// @dev Approve transfer
139     /// @param _spender holder address
140     /// @param _value tokens amount
141     /// @return result
142     function approve(address _spender, uint _value) returns(bool success) {
143         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
144 
145         allowed[msg.sender][_spender] = _value;
146         Approval(msg.sender, _spender, _value);
147         return true;
148     }
149 
150     /// @dev Token allowance
151     /// @param _owner holder address
152     /// @param _spender spender address
153     /// @return remain amount
154     function allowance(address _owner, address _spender) constant returns(uint remaining) {
155         return allowed[_owner][_spender];
156     }
157 
158     /// @dev Withdraw all owner
159     function withdraw() onlyOwner {
160         msg.sender.transfer(this.balance);
161     }
162 }