1 /*
2  *  The Yomi Token contract complies with the ERC20 standard (see https://github.com/ethereum/EIPs/issues/20).
3  *  All tokens not being sold during the crowdsale but the reserved token for tournaments future financing are burned.
4  *  Author: Plan B.
5  */
6 pragma solidity ^0.4.24;
7 
8 library SafeMath {
9     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
10         assert(b <= a);
11         return a - b;
12     }
13 
14     function add(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a + b;
16         assert(c >= a && c >= b);
17         return c;
18     }
19 }
20 
21 contract Owned {
22     address public ownerAddr;
23     event TransferOwnership(address indexed previousOwner, address indexed newOwner);
24     
25     constructor() public {
26         ownerAddr = msg.sender;
27     }
28     
29     modifier onlyOwner {
30         require(msg.sender == ownerAddr);
31         _;
32     }
33     
34     function transferOwnership(address _newOwner) onlyOwner public {
35         require(_newOwner != 0x0);
36         ownerAddr = _newOwner;
37         emit TransferOwnership(ownerAddr, _newOwner);
38     }
39 }
40 
41 contract ERC20 {
42     // Base function
43     function totalSupply() public view returns (uint256 _totalSupply);
44     function balanceOf(address _owner) public view returns (uint256 balance);
45     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
46     function transfer(address _to, uint256 _value) public returns (bool success);
47     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
48     function approve(address _spender, uint256 _value) public returns (bool success);
49     
50     // Public event on the blockchain that will notify clients
51     event Transfer(address indexed _from, address indexed _to, uint256 _value);
52     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
53 }
54 
55 contract YomiToken is Owned, ERC20{
56     using SafeMath for uint256;
57     
58     // Public variables of the token
59     string constant public name = "YOMI Token";
60     string constant public symbol = "YOMI";
61     uint8 constant public decimals = 18;
62     uint256 total_supply = 1000000000e18; // Total supply of 1 billion Yomi Tokens
63     uint256 constant public teamReserve = 100000000e18; //10%
64     uint256 constant public foundationReserve = 200000000e18; //20%
65     uint256 constant public startTime = 1533110400; // Good time:2018-08-01 08:00:00  GMT
66     uint256 public lockReleaseDate6Month; // 6 month = 182 days
67     uint256 public lockReleaseDate1Year; // 1 year = 365 days
68     address public teamAddr;
69     address public foundationAddr;
70     
71     // Array
72     mapping (address => uint256) balances;
73     mapping (address => mapping (address => uint256)) allowed;
74     mapping (address => bool) public frozenAccounts;
75     
76     // This generates a public event on the blockchain that will notify clients
77     event FrozenFunds(address _target, bool _freeze);
78     
79     /**
80      * Constrctor function
81      * Initializes contract with initial supply tokens to the creator of the contract
82      */
83     constructor(address _teamAddr, address _foundationAddr) public {
84         teamAddr = _teamAddr;
85         foundationAddr = _foundationAddr;
86         lockReleaseDate6Month = startTime + 182 days;
87         lockReleaseDate1Year = startTime + 365 days;
88         balances[ownerAddr] = total_supply; // Give the creator all initial tokens
89     }
90     
91     /**
92      * `freeze? Prevent | Allow` `_target` from sending & receiving tokens
93      * @param _freeze either to freeze it or not
94      */
95     function freezeAccount(address _target, bool _freeze) onlyOwner public {
96         frozenAccounts[_target] = _freeze;
97         emit FrozenFunds(_target, _freeze);
98     }
99     
100     /**
101      * Get the total supply
102      */
103     function totalSupply() public view returns (uint256 _totalSupply) {
104         _totalSupply = total_supply;
105     }
106     
107     /**
108      * What is the balance of a particular account?
109      */
110     function balanceOf(address _owner) public view returns (uint256 balance) {
111         return balances[_owner];
112     }
113     
114     /**
115      * Returns the amount which _spender is still allowed to withdraw from _owner
116      */
117     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
118         return allowed[_owner][_spender];
119     }
120     
121     /**
122      * Internal transfer,only can be called by this contract
123      */
124     function _transfer(address _from, address _to, uint256 _value) internal {
125         require(_to != 0x0);
126         
127         // Lock tokens of team
128         if (_from == teamAddr && now < lockReleaseDate6Month) {
129             require(balances[_from].sub(_value) >= teamReserve);
130         }
131         // Lock tokens of foundation        
132         if (_from == foundationAddr && now < lockReleaseDate1Year) {
133             require(balances[_from].sub(_value) >= foundationReserve);
134         }
135         
136         // Check if the sender has enough
137         require(balances[_from] >= _value); 
138         // Check for overflows
139         require(balances[_to] + _value > balances[_to]); 
140         //Check if account is frozen
141         require(!frozenAccounts[_from]);
142         require(!frozenAccounts[_to]);
143         
144         // Save this for an assertion in the future
145         uint256 previousBalances = balances[_from].add(balances[_to]);
146         // Subtract from the sender
147         balances[_from] = balances[_from].sub(_value);
148         // Add the same to the recipient
149         balances[_to] = balances[_to].add(_value);
150         emit Transfer(_from, _to, _value);
151         // Asserts are used to use static analysis to find bugs in your code. They should never fail
152         assert(balances[_from] + balances[_to] == previousBalances);
153     }
154     
155     /**
156      * Transfer tokens
157      * Send `_value` tokens to `_to` from your account.
158      */
159     function transfer(address _to, uint256 _value) public returns (bool success) {
160         _transfer(msg.sender, _to, _value);
161         return true;
162     }
163     
164     /**
165      * Transfer tokens from other address
166      * Send `_value` tokens to `_to` on behalf of `_from`.
167      */
168     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
169         // Check allowance
170         require(_value <= allowed[_from][msg.sender]);
171         allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_value);
172         _transfer(_from, _to, _value);
173         return true;
174     }
175     
176     /**
177      * Set allowance for other address
178      * Allows `_spender` to spend no more than `_value` tokens on your behalf.
179      */
180     function approve(address _spender, uint256 _value) public returns (bool success) {
181         require(_spender != 0x0);
182         allowed[msg.sender][_spender] = _value;
183         emit Approval(msg.sender, _spender, _value);
184         return true;
185     }
186 }