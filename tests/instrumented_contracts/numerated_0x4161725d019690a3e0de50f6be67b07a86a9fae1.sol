1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 /**
34  * @title ERC20 interface
35  * @dev see https://github.com/ethereum/EIPs/issues/20
36  */
37 contract ERC20 {
38     uint256 public totalSupply;
39 
40     function balanceOf(address who) public view returns (uint256);
41 
42     function transfer(address to, uint256 value) public returns (bool);
43 
44     function allowance(address owner, address spender)
45         public
46         view
47         returns (uint256);
48 
49     function transferFrom(
50         address from,
51         address to,
52         uint256 value
53     ) public returns (bool);
54 
55     function approve(address spender, uint256 value) public returns (bool);
56 
57     event Transfer(address indexed from, address indexed to, uint256 value);
58     event Approval(
59         address indexed owner,
60         address indexed spender,
61         uint256 value
62     );
63 }
64 
65 /**
66  * @title Standard ERC20 token
67  *
68  * @dev Implementation of the basic standard token.
69  * @dev https://github.com/ethereum/EIPs/issues/20
70  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
71  */
72 contract StandardToken is ERC20 {
73     using SafeMath for uint256;
74 
75     mapping(address => uint256) balances;
76     mapping(address => mapping(address => uint256)) allowed;
77 
78     /**
79      * @dev Gets the balance of the specified address.
80      * @param _owner The address to query the the balance of.
81      * @return An uint256 representing the amount owned by the passed address.
82      */
83     function balanceOf(address _owner) public view returns (uint256 balance) {
84         return balances[_owner];
85     }
86 
87     /**
88      * @dev transfer token for a specified address
89      * @param _to The address to transfer to.
90      * @param _value The amount to be transferred.
91      */
92     function transfer(address _to, uint256 _value) public returns (bool) {
93         require(_to != address(0));
94 
95         // SafeMath.sub will throw if there is not enough balance.
96         balances[msg.sender] = balances[msg.sender].sub(_value);
97         balances[_to] = balances[_to].add(_value);
98         Transfer(msg.sender, _to, _value);
99         return true;
100     }
101 
102     /**
103      * @dev Transfer tokens from one address to another
104      * @param _from address The address which you want to send tokens from
105      * @param _to address The address which you want to transfer to
106      * @param _value uint256 the amount of tokens to be transferred
107      */
108     function transferFrom(
109         address _from,
110         address _to,
111         uint256 _value
112     ) public returns (bool) {
113         var _allowance = allowed[_from][msg.sender];
114         require(_to != address(0));
115         require(_value <= _allowance);
116         balances[_from] = balances[_from].sub(_value);
117         balances[_to] = balances[_to].add(_value);
118         allowed[_from][msg.sender] = _allowance.sub(_value);
119         Transfer(_from, _to, _value);
120         return true;
121     }
122 
123     /**
124      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
125      * @param _spender The address which will spend the funds.
126      * @param _value The amount of tokens to be spent.
127      */
128     function approve(address _spender, uint256 _value) public returns (bool) {
129         // To change the approve amount you first have to reduce the addresses`
130         //  allowance to zero by calling `approve(_spender, 0)` if it is not
131         //  already 0 to mitigate the race condition described here:
132         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
134         allowed[msg.sender][_spender] = _value;
135         Approval(msg.sender, _spender, _value);
136         return true;
137     }
138 
139     /**
140      * @dev Function to check the amount of tokens that an owner allowed to a spender.
141      * @param _owner address The address which owns the funds.
142      * @param _spender address The address which will spend the funds.
143      * @return A uint256 specifying the amount of tokens still available for the spender.
144      */
145     function allowance(address _owner, address _spender)
146         public
147         view
148         returns (uint256 remaining)
149     {
150         return allowed[_owner][_spender];
151     }
152 }
153 
154 contract TPToken is StandardToken {
155     string public constant name = "TokenPocket Token";
156     string public constant symbol = "TPT";
157     uint8 public constant decimals = 4;
158 
159     function TPToken() public {
160         totalSupply = 59000000000000;
161         balances[msg.sender] = totalSupply;
162     }
163 }