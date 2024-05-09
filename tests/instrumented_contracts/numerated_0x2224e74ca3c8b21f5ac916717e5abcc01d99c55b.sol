1 pragma solidity ^0.4.24;
2 
3 /**
4 * @title Ownable
5 * @dev The Ownable contract has an owner address, and provides basic authorization control
6 * functions, this simplifies the implementation of "user permissions".
7 */
8 contract Ownable {
9     address public owner;
10 
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15     /**
16     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17     * account.
18     */
19     constructor() public {
20         owner = msg.sender;
21     }
22 
23     /**
24     * @dev Throws if called by any account other than the owner.
25     */
26     modifier onlyOwner() {
27         require(msg.sender == owner);
28         _;
29     }
30 
31     /**
32     * @dev Allows the current owner to transfer control of the contract to a newOwner.
33     * @param newOwner The address to transfer ownership to.
34     */
35     function transferOwnership(address newOwner) public onlyOwner {
36         require(newOwner != address(0));
37         emit OwnershipTransferred(owner, newOwner);
38         owner = newOwner;
39     }
40 
41 }
42 
43 /**
44  * @title SafeMath
45  * @dev Math operations with safety checks that throw on error
46  */
47 library SafeMath {
48 
49   /**
50   * @dev Multiplies two numbers, throws on overflow.
51   */
52   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53     if (a == 0) {
54       return 0;
55     }
56     uint256 c = a * b;
57     assert(c / a == b);
58     return c;
59   }
60 
61   /**
62   * @dev Integer division of two numbers, truncating the quotient.
63   */
64   function div(uint256 a, uint256 b) internal pure returns (uint256) {
65     // assert(b > 0); // Solidity automatically throws when dividing by 0
66     uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68     return c;
69   }
70 
71   /**
72   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
73   */
74   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75     assert(b <= a);
76     return a - b;
77   }
78 
79   /**
80   * @dev Adds two numbers, throws on overflow.
81   */
82   function add(uint256 a, uint256 b) internal pure returns (uint256) {
83     uint256 c = a + b;
84     assert(c >= a);
85     return c;
86   }
87 }
88 
89 interface tokenRecipient {
90     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
91 }
92 
93 contract Gamblr is Ownable {
94     using SafeMath for uint256;
95 
96     string public name = "Gamblr";
97     uint8 public decimals = 3;
98     string public symbol = "GMBL";
99     uint public totalSupply = 10000000000;
100 
101     mapping (address => uint256) public balances;
102     mapping (address => mapping (address => uint256)) public allowed;
103 
104     function Gamblr() public {
105         balances[msg.sender] = 3000000000;
106         balances[this] = 7000000000;
107     }
108 
109     function transfer(address _to, uint256 _amount) public returns (bool success) {
110         doTransfer(msg.sender, _to, _amount);
111         return true;
112     }
113 
114     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
115         require(allowed[_from][msg.sender] >= _amount);
116         allowed[_from][msg.sender] -= _amount;
117         doTransfer(_from, _to, _amount);
118         return true;
119     }
120 
121     function doTransfer(address _from, address _to, uint _amount) internal {
122         require((_to != 0) && (_to != address(this)));
123         require(_amount <= balances[_from]);
124         balances[_from] = balances[_from].sub(_amount);
125         balances[_to] = balances[_to].add(_amount);
126         emit Transfer(_from, _to, _amount);
127     }
128 
129     function balanceOf(address _owner) public constant returns (uint256 balance) {
130         return balances[_owner];
131     }
132 
133     function approve(address _spender, uint256 _amount) public returns (bool success) {
134         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
135 
136         allowed[msg.sender][_spender] = _amount;
137         emit Approval(msg.sender, _spender, _amount);
138         return true;
139     }
140 
141     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
142         tokenRecipient spender = tokenRecipient(_spender);
143         if (approve(_spender, _value)) {
144             spender.receiveApproval(msg.sender, _value, this, _extraData);
145             return true;
146         }
147     }
148 
149     function burn(uint256 _value) public onlyOwner {
150         require(balances[msg.sender] >= _value);
151         balances[msg.sender] = balances[msg.sender].sub(_value);
152         totalSupply = totalSupply.sub(_value);
153     }
154 
155     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
156         return allowed[_owner][_spender];
157     }
158 
159     function totalSupply() public constant returns (uint) {
160         return totalSupply;
161     }
162     
163     event Transfer(
164         address indexed _from,
165         address indexed _to,
166         uint256 _amount
167         );
168 
169     event Approval(
170         address indexed _owner,
171         address indexed _spender,
172         uint256 _amount
173         );
174 
175     event Burn(
176         address indexed _burner,
177         uint256 _amount
178         );
179         
180     mapping(address => bool) public joined;
181         
182     function receiveTokens() public returns(bool){
183         require(balanceOf(this) > 0);
184         require(!joined[msg.sender]);
185         if (balanceOf(this) > 1000000) {
186             doTransfer(this, msg.sender, 1000000);
187             joined[msg.sender] = true;
188             return joined[msg.sender];
189         }
190         doTransfer(this, msg.sender, balanceOf(this));
191         joined[msg.sender] = true;
192         return joined[msg.sender];
193     }    
194         
195 }