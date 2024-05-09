1 /*
2 ****************************
3 ****************************
4 Swiftlance token contract
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
70 contract Swiftlance is ERC20 {
71     
72     using SafeMath for uint256;
73     address public owner;
74 
75     mapping (address => uint256) balances;
76     mapping (address => mapping (address => uint256)) allowed;    
77 
78     string public constant name = "Swiftlance token";
79     string public constant symbol = "SWL";
80     uint public constant decimals = 8;
81     
82     uint256 public maxSupply = 8000000000e8;
83     uint256 public constant minContrib = 1 ether / 100;
84     uint256 public SWLPerEther = 20000000e8;
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
100         buySWL();
101      }
102     
103     function dividend(uint256 _amount) internal view returns (uint256){
104         if(_amount >= SWLPerEther.div(2) && _amount < SWLPerEther){ return ((20*_amount).div(100)).add(_amount);}
105         else if(_amount >= SWLPerEther && _amount < SWLPerEther.mul(5)){return ((40*_amount).div(100)).add(_amount);}
106         else if(_amount >= SWLPerEther.mul(5)){return ((70*_amount).div(100)).add(_amount);}
107         return _amount;
108     }
109     
110     function buySWL() payable public {
111         address investor = msg.sender;
112         uint256 tokenAmt =  SWLPerEther.mul(msg.value) / 1 ether;
113         require(msg.value >= minContrib && msg.value > 0);
114         tokenAmt = dividend(tokenAmt);
115         require(balances[owner] >= tokenAmt);
116         balances[owner] -= tokenAmt;
117         balances[investor] += tokenAmt;
118         emit Transfer(this, investor, tokenAmt);   
119     }
120 
121     function balanceOf(address _owner) constant public returns (uint256) {
122         return balances[_owner];
123     }
124 
125     //mitigates the ERC20 short address attack
126     //suggested by izqui9 @ http://bit.ly/2NMMCNv
127     modifier onlyPayloadSize(uint size) {
128         assert(msg.data.length >= size + 4);
129         _;
130     }
131     
132     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
133         require(_to != address(0));
134         require(_amount <= balances[msg.sender]);
135         balances[msg.sender] = balances[msg.sender].sub(_amount);
136         balances[_to] = balances[_to].add(_amount);
137         emit Transfer(msg.sender, _to, _amount);
138         return true;
139     }
140     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
141         require(_to != address(0));
142         require(_amount <= balances[_from]);
143         require(_amount <= allowed[_from][msg.sender]);
144         balances[_from] = balances[_from].sub(_amount);
145         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
146         balances[_to] = balances[_to].add(_amount);
147         emit Transfer(_from, _to, _amount);
148         return true;
149     }
150     
151     function approve(address _spender, uint256 _value) public returns (bool success) {
152         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
153         allowed[msg.sender][_spender] = _value;
154         emit Approval(msg.sender, _spender, _value);
155         return true;
156     }
157     
158     function allowance(address _owner, address _spender) constant public returns (uint256) {
159         return allowed[_owner][_spender];
160     }
161     
162     function transferOwnership(address _newOwner) onlyOwner public {
163         if (_newOwner != address(0)) {
164             owner = _newOwner;
165         }
166     }
167     
168     function withdrawFund() onlyOwner public {
169         address thisCont = this;
170         uint256 ethBal = thisCont.balance;
171         owner.transfer(ethBal);
172     }
173     
174     function burn(uint256 _value) onlyOwner public {
175         require(_value <= balances[msg.sender]);
176         address burner = msg.sender;
177         balances[burner] = balances[burner].sub(_value);
178         totalSupply = totalSupply.sub(_value);
179         emit Burn(burner, _value);
180     }
181     
182 }