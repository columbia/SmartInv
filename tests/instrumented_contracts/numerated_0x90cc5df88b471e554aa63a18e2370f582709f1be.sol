1 pragma solidity ^0.4.24;
2 
3 /**
4  * title SafeMath
5  * @dev Math operations with safety checks that throw on error
6 */
7 
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 /**
52  * @title ERC20 interface
53  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
54  */
55 
56 interface ERC20 {
57 
58     //Returns the account balance of another account with address _owner.
59     function balanceOf(address _owner) external constant returns (uint256 balance);
60 
61     //Transfers _value amount of tokens to address _to, and MUST fire the Transfer event.
62     //The function SHOULD throw if the _from account balance does not have enough tokens to spend.
63     //
64     //Note Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event.
65     function transfer(address _to, uint256 _value) external returns (bool success);
66 
67     //Transfers _value amount of tokens from address _from to address _to, and MUST fire the Transfer event.
68     //
69     //The transferFrom method is used for a withdraw workflow, allowing contracts to transfer tokens on your behalf.
70     //This can be used for example to allow a contract to transfer tokens on your behalf and/or to charge
71     //fees in sub-currencies. The function SHOULD throw unless the _from account has deliberately authorized
72     //the sender of the message via some mechanism.
73     //
74     //Note Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event.
75     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
76 
77     //Allows _spender to withdraw from your account multiple times, up to the _value amount.
78     //If this function is called again it overwrites the current allowance with _value.
79     //
80     //NOTE: To prevent attack vectors like the one described here and discussed here, clients SHOULD make
81     //sure to create user interfaces in such a way that they set the allowance first to 0 before setting it
82     //to another value for the same spender. THOUGH The contract itself shouldn't enforce it, to allow
83     //backwards compatibility with contracts deployed before
84     function approve(address _spender, uint256 _value) external returns (bool success);
85 
86     //Returns the amount which _spender is still allowed to withdraw from _owner.
87     function allowance(address _owner, address _spender) external returns (uint256 remaining);
88 
89     //MUST trigger when tokens are transferred, including zero value transfers.
90     //
91     //A token contract which creates new tokens SHOULD trigger a Transfer event with the _from
92     //address set to 0x0 when tokens are created.
93     event Transfer(address indexed _from, address indexed _to, uint256 _value);
94 
95     //MUST trigger on any successful call to approve(address _spender, uint256 _value).
96     event Approval(address indexed _owner, address indexed _spender, uint256  _value);
97 }
98 
99 
100 contract POMZ is ERC20 {
101 
102     //use libraries section
103 	using SafeMath for uint256;
104 
105     //token characteristics section
106     uint public constant decimals = 8;
107     uint256 public totalSupply = 5000000000 * 10 ** decimals;
108     string public constant name = "POMZ";
109     string public constant symbol = "POMZ";
110 
111     //storage section
112     mapping (address => uint256) balances;
113     mapping (address => mapping (address => uint256)) allowed;
114 
115     //all token to creator
116 	constructor() public {
117 		balances[msg.sender] = totalSupply;
118 	}
119 
120     //Returns the account balance of another account with address _owner.
121     function balanceOf(address _owner) public view returns (uint256) {
122 	    return balances[_owner];
123     }
124 
125     //Transfers _value amount of tokens to address _to, and MUST fire the Transfer event.
126     //The function SHOULD throw if the _from account balance does not have enough tokens to spend.
127     function transfer(address _to, uint256 _value) public returns (bool success) {
128         require(_to != address(0));
129         require(balances[msg.sender] >= _value);
130         require(balances[_to] + _value >= balances[_to]);
131 
132         uint256 previousBalances = balances[_to];
133         balances[msg.sender] = balances[msg.sender].sub(_value);
134         balances[_to] = balances[_to].add(_value);
135         emit Transfer(msg.sender, _to, _value);
136         assert(balances[_to].sub(_value) == previousBalances);
137         return true;
138     }
139 
140     //Transfers _value amount of tokens from address _from to address _to, and MUST fire the Transfer event.
141     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
142         require(_to != address(0));
143         require(balances[_from] >= _value);
144         require(allowed[_from][msg.sender] >= _value);
145         require(balances[_to] + _value >= balances[_to]);
146 
147         uint256 previousBalances = balances[_to];
148 	    balances[_from] = balances[_from].sub(_value);
149 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
150 		balances[_to] = balances[_to].add(_value);
151         emit Transfer(_from, _to, _value);
152 		assert(balances[_to].sub(_value) == previousBalances);
153         return true;
154     }
155 
156     //Allows _spender to withdraw from your account multiple times, up to the _value amount.
157     //If this function is called again it overwrites the current allowance with _value.
158     function approve(address _spender, uint256 _value) public returns (bool success) {
159         require(balances[msg.sender] >= _value);
160         
161         allowed[msg.sender][_spender] = _value;
162         emit Approval(msg.sender, _spender, _value);
163         return true;
164     }
165 
166     //Returns the amount which _spender is still allowed to withdraw from _owner.
167     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
168         return allowed[_owner][_spender];
169     }
170 
171     // If ether is sent to this address, send it back.
172 	function () public {
173         revert();
174     }
175 
176 }