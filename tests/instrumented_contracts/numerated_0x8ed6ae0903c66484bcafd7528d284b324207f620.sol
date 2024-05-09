1 pragma solidity ^0.4.17;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 
28   function min(uint a, uint b) internal pure returns (uint256) {
29     return a < b ? a : b;
30   }
31 }
32 
33 
34 
35 //This is the basic wrapped Ether contract. 
36 //All money deposited is transformed into ERC20 tokens at the rate of 1 wei = 1 token
37 contract Wrapped_Ether {
38 
39   using SafeMath for uint256;
40 
41   /*Variables*/
42 
43   //ERC20 fields
44   string public name = "Wrapped Ether";
45   uint public total_supply;
46 
47 
48   //ERC20 fields
49   mapping(address => uint) balances;
50   mapping(address => mapping (address => uint)) allowed;
51 
52   /*Events*/
53 
54   event Transfer(address indexed _from, address indexed _to, uint _value);
55   event Approval(address indexed _owner, address indexed _spender, uint _value);
56   event StateChanged(bool _success, string _message);
57 
58   /*Functions*/
59 
60   //This function creates tokens equal in value to the amount sent to the contract
61   function CreateToken() public payable {
62     require(msg.value > 0);
63     balances[msg.sender] = balances[msg.sender].add(msg.value);
64     total_supply = total_supply.add(msg.value);
65   }
66 
67   /*
68   * This function 'unwraps' an _amount of Ether in the sender's balance by transferring Ether to them
69   *
70   * @param "_amount": The amount of the token to unwrap
71   */
72   function withdraw(uint _value) public {
73     balances[msg.sender] = balances[msg.sender].sub(_value);
74     total_supply = total_supply.sub(_value);
75     msg.sender.transfer(_value);
76   }
77 
78   //Returns the balance associated with the passed in _owner
79   function balanceOf(address _owner) public constant returns (uint bal) { return balances[_owner]; }
80 
81   /*
82   * Allows for a transfer of tokens to _to
83   *
84   * @param "_to": The address to send tokens to
85   * @param "_amount": The amount of tokens to send
86   */
87   function transfer(address _to, uint _amount) public returns (bool success) {
88     if (balances[msg.sender] >= _amount
89     && _amount > 0
90     && balances[_to] + _amount > balances[_to]) {
91       balances[msg.sender] = balances[msg.sender].sub(_amount);
92       balances[_to] = balances[_to].add(_amount);
93       Transfer(msg.sender, _to, _amount);
94       return true;
95     } else {
96       return false;
97     }
98   }
99 
100   /*
101   * Allows an address with sufficient spending allowance to send tokens on the behalf of _from
102   *
103   * @param "_from": The address to send tokens from
104   * @param "_to": The address to send tokens to
105   * @param "_amount": The amount of tokens to send
106   */
107   function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {
108     if (balances[_from] >= _amount
109     && allowed[_from][msg.sender] >= _amount
110     && _amount > 0
111     && balances[_to] + _amount > balances[_to]) {
112       balances[_from] = balances[_from].sub(_amount);
113       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
114       balances[_to] = balances[_to].add(_amount);
115       Transfer(_from, _to, _amount);
116       return true;
117     } else {
118       return false;
119     }
120   }
121 
122   //Approves a _spender an _amount of tokens to use
123   function approve(address _spender, uint _amount) public returns (bool success) {
124     allowed[msg.sender][_spender] = _amount;
125     Approval(msg.sender, _spender, _amount);
126     return true;
127   }
128 
129   //Returns the remaining allowance of tokens granted to the _spender from the _owner
130   function allowance(address _owner, address _spender) public view returns (uint remaining) { return allowed[_owner][_spender]; }
131 }