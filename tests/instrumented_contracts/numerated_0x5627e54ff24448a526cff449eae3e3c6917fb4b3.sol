1 pragma solidity ^0.4.24;
2 
3 
4 
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
11     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
12     // benefit is lost if 'b' is also tested.
13     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
14     if (a == 0) {
15       return 0;
16     }
17 
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57   address public owner;
58 
59 
60   event OwnershipRenounced(address indexed previousOwner);
61   event OwnershipTransferred(
62     address indexed previousOwner,
63     address indexed newOwner
64   );
65 
66 
67   /**
68    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
69    * account.
70    */
71   constructor() public {
72     owner = msg.sender;
73   }
74 
75   /**
76    * @dev Throws if called by any account other than the owner.
77    */
78   modifier onlyOwner() {
79     require(msg.sender == owner);
80     _;
81   }
82 
83   /**
84    * @dev Allows the current owner to relinquish control of the contract.
85    * @notice Renouncing to ownership will leave the contract without an owner.
86    * It will not be possible to call the functions with the `onlyOwner`
87    * modifier anymore.
88    */
89   function renounceOwnership() public onlyOwner {
90     emit OwnershipRenounced(owner);
91     owner = address(0);
92   }
93 
94   /**
95    * @dev Allows the current owner to transfer control of the contract to a newOwner.
96    * @param _newOwner The address to transfer ownership to.
97    */
98   function transferOwnership(address _newOwner) public onlyOwner {
99     _transferOwnership(_newOwner);
100   }
101 
102   /**
103    * @dev Transfers control of the contract to a newOwner.
104    * @param _newOwner The address to transfer ownership to.
105    */
106   function _transferOwnership(address _newOwner) internal {
107     require(_newOwner != address(0));
108     emit OwnershipTransferred(owner, _newOwner);
109     owner = _newOwner;
110   }
111 }
112 
113 contract iHOME is Ownable {
114   using SafeMath for uint256;
115 
116   event Transfer(address indexed from,address indexed to,uint256 _tokenId);
117   event Approval(address indexed owner,address indexed approved,uint256 _tokenId);
118 
119 
120 
121   string public constant symbol = "iHOME";
122   string public constant name = "iHOME Credits";
123   uint8 public decimals = 18;
124 
125   uint256 public totalSupply = 1000000000000 * 10 ** uint256(decimals);
126 
127 
128   mapping(address => uint256) balances;
129   mapping(address => mapping (address => uint256)) allowed;
130 
131 
132 
133 
134 
135   function balanceOf(address _owner) public constant returns (uint256 balance) {
136     return balances[_owner];
137   }
138 
139 
140   constructor() public {
141     balances[msg.sender] = totalSupply;
142   }
143 
144 
145   function approve(address _spender, uint256 _amount) public returns (bool success) {
146     allowed[msg.sender][_spender] = _amount;
147     emit   Approval(msg.sender, _spender, _amount);
148     return true;
149   }
150 
151   function allowance(address _owner, address _spender ) public view returns (uint256) {
152     return allowed[_owner][_spender];
153   }
154 
155 
156   function transfer(address _to, uint256 _value) public returns (bool) {
157     require(_value <= balances[msg.sender]);
158     require(_to != address(0));
159 
160     balances[msg.sender] = balances[msg.sender].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     emit Transfer(msg.sender, _to, _value);
163     return true;
164   }
165 
166   function transferFrom(address _from, address _to, uint256 _value) public returns (bool)
167   {
168     require(_value <= balances[_from]);
169     require(_value <= allowed[_from][msg.sender]);
170     require(_to != address(0));
171 
172     balances[_from] = balances[_from].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
175     emit Transfer(_from, _to, _value);
176     return true;
177   }
178 
179   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
180     allowed[msg.sender][_spender] = (
181       allowed[msg.sender][_spender].add(_addedValue));
182       emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
183       return true;
184     }
185 
186     function decreaseApproval(address _spender,uint256 _subtractedValue) public returns (bool)
187     {
188       uint256 oldValue = allowed[msg.sender][_spender];
189       if (_subtractedValue >= oldValue) {
190         allowed[msg.sender][_spender] = 0;
191         } else {
192           allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
193         }
194         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195         return true;
196       }
197 
198     }