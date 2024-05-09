1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (_a == 0) {
13       return 0;
14     }
15 
16     c = _a * _b;
17     assert(c / _a == _b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
25     // assert(_b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = _a / _b;
27     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
28     return _a / _b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
35     assert(_b <= _a);
36     return _a - _b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
43     c = _a + _b;
44     assert(c >= _a);
45     return c;
46   }
47 }
48 /**
49  * ERC 20 token
50  *
51  * https://github.com/ethereum/EIPs/issues/20
52  */
53 contract MD  {
54     using SafeMath for uint256;
55 
56     string public constant name = "MD Token";
57     string public constant symbol = "MD";
58 
59     uint public constant decimals = 18;
60 
61     // Total supply is 3.5 billion
62     uint256 _totalSupply = 3500000000 * 10**decimals;
63 
64     mapping(address => uint256) balances; //list of balance of each address
65     mapping(address => mapping (address => uint256)) allowed;
66 
67     address public owner;
68 
69     modifier ownerOnly {
70       require(
71             msg.sender == owner,
72             "Sender not authorized."
73         );
74         _;
75     }
76 
77     function totalSupply() public view returns (uint256 supply) {
78         return _totalSupply;
79     }
80 
81     function balanceOf(address _owner) public view returns (uint256 balance) {
82         return balances[_owner];
83     }
84 
85     function approve(address _spender, uint256 _value) public returns (bool success) {
86         allowed[msg.sender][_spender] = _value;
87         emit Approval(msg.sender, _spender, _value);
88         return true;
89     }
90 
91     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
92       return allowed[_owner][_spender];
93     }
94 
95     event Transfer(address indexed _from, address indexed _to, uint256 _value);
96     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
97 
98     //constructor
99     constructor(address _owner) public{
100         owner = _owner;
101         balances[owner] = _totalSupply;
102         emit Transfer(0x0, _owner, _totalSupply);
103     }
104 
105     /**
106      * ERC 20 Standard Token interface transfer function
107      *
108      * Prevent transfers until lock period is over.
109      */
110     function transfer(address _to, uint256 _value) public returns (bool success) {
111         //Default assumes totalSupply can't be over max (2^256 - 1).
112         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
113         //Replace the if with this one instead.
114         if (balances[msg.sender] >= _value && balances[_to].add(_value) > balances[_to]) {
115             balances[msg.sender] = balances[msg.sender].sub(_value);
116             balances[_to] = balances[_to].add(_value);
117             emit Transfer(msg.sender, _to, _value);
118             return true;
119         } else {
120             return false;
121         }
122     }
123 
124     /**
125      * ERC 20 Standard Token interface transfer function
126      *
127      * Prevent transfers until freeze period is over.
128      */
129     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
130         //same as above. Replace this line with the following if you want to protect against wrapping uints.
131         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to].add(_value) > balances[_to]) {
132             balances[_to] = _value.add(balances[_to]);
133             balances[_from] = balances[_from].sub(_value);
134             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
135             emit Transfer(_from, _to, _value);
136             return true;
137         } else {
138             return false;
139         }
140     }
141 
142     /**
143      * Change owner address (where ICO ETH is being forwarded).
144      */
145     function changeOwner(address _newowner) public ownerOnly returns (bool success) {
146         owner = _newowner;
147         return true;
148     }
149 
150     // only owner can kill
151     function kill() public ownerOnly {
152         selfdestruct(owner);
153     }
154 }