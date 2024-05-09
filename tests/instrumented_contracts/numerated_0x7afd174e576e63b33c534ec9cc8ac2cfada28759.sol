1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two numbers, throws on overflow.
10      **/
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
21      * @dev Integer division of two numbers, truncating the quotient.
22      **/
23     function div(uint256 a, uint256 b) internal pure returns (uint256) {
24         // assert(b > 0); // Solidity automatically throws when dividing by 0
25         // uint256 c = a / b;
26         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27         return a / b;
28     }
29     
30     /**
31      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32      **/
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37     
38     /**
39      * @dev Adds two numbers, throws on overflow.
40      **/
41     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42         c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 }
47 
48 contract Ownable {
49     address public owner;
50     
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52     
53     /**
54     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
55     * account.
56     */
57     
58     constructor() public {
59         owner = msg.sender;
60     }
61     
62     /**
63     * @dev Throws if called by any account other than the owner.
64     */
65     modifier onlyOwner() {
66         require(msg.sender == owner);
67         _;
68     }
69 
70 }
71 
72 contract FreedomCoin is Ownable {
73     
74     using SafeMath for uint256;
75 
76     string public constant symbol = "FDC";
77     string public constant name = "Freedom Coin";
78     uint8 public constant decimals = 18;
79     uint256 public totalSupply = 100000000000000000000000000;
80     uint256 public rate = 5000000000000000000;
81     
82     mapping(address => uint256) balances;
83     mapping(address => mapping (address => uint256)) allowed;
84     
85     event Transfer(address indexed _from, address indexed _to, uint256 _value);
86 
87     constructor() public{
88       balances[owner] = totalSupply;
89     }
90     
91     function () public payable {
92         create(msg.sender);
93     }
94 
95     function create(address beneficiary) public payable {
96         require(beneficiary != address(0));
97         
98         uint256 weiAmount = msg.value; // Calculate tokens to sell
99         uint256 tokens = weiAmount.mul(10**18).div(rate);
100 
101         require(tokens <= balances[owner]);
102         
103         if(weiAmount > 0){
104             balances[beneficiary] += tokens;
105             balances[owner] -= tokens;
106         }
107     }
108     
109     function back_giving(uint256 tokens) public {
110         uint256 amount = tokens.mul(rate).div(10**18);
111         //require(tokens >= balances[msg.sender]);
112         balances[owner] += tokens;
113         balances[msg.sender] -= tokens;
114         (msg.sender).transfer(amount);
115     }
116 
117     function balanceOf(address _owner) public constant returns (uint256 balance) {
118         return balances[_owner];
119     }
120     
121     function balanceMaxSupply() public constant returns (uint256 balance) {
122         return balances[owner];
123     }
124     
125     function balanceEth(address _owner) public constant returns (uint256 balance) {
126         return _owner.balance;
127     }
128     
129     function collect(uint256 amount) onlyOwner public{
130         msg.sender.transfer(amount);
131     }
132 
133     function transfer(address _to, uint256 _amount) public returns (bool success) {
134         require(_to != address(0));
135         if (balances[msg.sender] >= _amount && _amount > 0) {
136             balances[msg.sender] -= _amount;
137             balances[_to] += _amount;
138             emit Transfer(msg.sender, _to, _amount);
139             return true;
140         } else {
141             return false;
142         }
143     }
144 
145     /**
146     * @dev Allows the current owner to transfer control of the contract to a newOwner.
147     * @param newOwner The address to transfer ownership to.
148     */
149     function transferOwnership(address newOwner) onlyOwner public {
150         require(newOwner != address(0));
151         balances[newOwner] = balances[owner];
152         balances[owner] = 0;
153         owner = newOwner;
154         emit OwnershipTransferred(owner, newOwner);
155     }
156 
157 }