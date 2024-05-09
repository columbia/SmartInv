1 pragma solidity ^0.4.24;
2 
3 //Slightly modified SafeMath library - includes a min function
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     uint256 c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function div(uint256 a, uint256 b) internal pure returns (uint256) {
12     // assert(b > 0); // Solidity automatically throws when dividing by 0
13     uint256 c = a / b;
14     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 
29   function min(uint a, uint b) internal pure returns (uint256) {
30     return a < b ? a : b;
31   }
32 }
33 
34 
35 
36 /**
37 *This is the basic wrapped Ether contract. 
38 *All money deposited is transformed into ERC20 tokens at the rate of 1 wei = 1 token
39 */
40 contract Wrapped_Ether {
41 
42     using SafeMath for uint256;
43 
44     /*Variables*/
45 
46     //ERC20 fields
47     string public name = "Wrapped Ether";
48     uint public total_supply;
49     mapping(address => uint) internal balances;
50     mapping(address => mapping (address => uint)) internal allowed;
51 
52     /*Events*/
53     event Transfer(address indexed _from, address indexed _to, uint _value);
54     event Approval(address indexed _owner, address indexed _spender, uint _value);
55     event StateChanged(bool _success, string _message);
56 
57     /*Functions*/
58     /**
59     *@dev This function creates tokens equal in value to the amount sent to the contract
60     */
61     function createToken() public payable {
62         require(msg.value > 0);
63         balances[msg.sender] = balances[msg.sender].add(msg.value);
64         total_supply = total_supply.add(msg.value);
65     }
66 
67     /**
68     *@dev This function 'unwraps' an _amount of Ether in the sender's balance by transferring 
69     *Ether to them
70     *@param _value The amount of the token to unwrap
71     */
72     function withdraw(uint _value) public {
73         balances[msg.sender] = balances[msg.sender].sub(_value);
74         total_supply = total_supply.sub(_value);
75         msg.sender.transfer(_value);
76     }
77 
78     /**
79     *@param _owner is the owner address used to look up the balance
80     *@return Returns the balance associated with the passed in _owner
81     */
82     function balanceOf(address _owner) public constant returns (uint bal) { 
83         return balances[_owner]; 
84     }
85 
86     /**
87     *@dev Allows for a transfer of tokens to _to
88     *@param _to The address to send tokens to
89     *@param _amount The amount of tokens to send
90     */
91     function transfer(address _to, uint _amount) public returns (bool) {
92         if (balances[msg.sender] >= _amount
93         && _amount > 0
94         && balances[_to] + _amount > balances[_to]) {
95             balances[msg.sender] = balances[msg.sender] - _amount;
96             balances[_to] = balances[_to] + _amount;
97             emit Transfer(msg.sender, _to, _amount);
98             return true;
99         } else {
100             return false;
101         }
102     }
103 
104     /**
105     *@dev Allows an address with sufficient spending allowance to send tokens on the behalf of _from
106     *@param _from The address to send tokens from
107     *@param _to The address to send tokens to
108     *@param _amount The amount of tokens to send
109     */
110     function transferFrom(address _from, address _to, uint _amount) public returns (bool) {
111         if (balances[_from] >= _amount
112         && allowed[_from][msg.sender] >= _amount
113         && _amount > 0
114         && balances[_to] + _amount > balances[_to]) {
115             balances[_from] = balances[_from] - _amount;
116             allowed[_from][msg.sender] = allowed[_from][msg.sender] - _amount;
117             balances[_to] = balances[_to] + _amount;
118             emit Transfer(_from, _to, _amount);
119             return true;
120         } else {
121             return false;
122         }
123     }
124 
125     /**
126     *@dev This function approves a _spender an _amount of tokens to use
127     *@param _spender address
128     *@param _amount amount the spender is being approved for
129     *@return true if spender appproved successfully
130     */
131     function approve(address _spender, uint _amount) public returns (bool) {
132         allowed[msg.sender][_spender] = _amount;
133         emit Approval(msg.sender, _spender, _amount);
134         return true;
135     }
136 
137     /**
138     *@param _owner address
139     *@param _spender address
140     *@return Returns the remaining allowance of tokens granted to the _spender from the _owner
141     */
142     function allowance(address _owner, address _spender) public view returns (uint) {
143        return allowed[_owner][_spender]; }
144 
145     /**
146     *@dev Getter for the total_supply of wrapped ether
147     *@return total supply
148     */
149     function totalSupply() public constant returns (uint) {
150        return total_supply;
151     }
152 }