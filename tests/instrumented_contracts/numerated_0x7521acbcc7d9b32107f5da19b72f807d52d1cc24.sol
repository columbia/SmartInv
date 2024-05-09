1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns(uint256) {
15         uint256 c = a / b;
16         return c;
17     }
18 
19     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
20         assert(b <= a);
21         return a - b;
22     }
23 
24     function add(uint256 a, uint256 b) internal pure returns(uint256) {
25         uint256 c = a + b;
26         assert(c >= a);
27         return c;
28     }
29 }
30 
31 /**
32  * @title ERC20 interface
33  * @dev see https://github.com/ethereum/EIPs/issues/20
34  */
35 contract ERC20 {
36     uint256 public totalSupply;
37 
38     function balanceOf(address who) public view returns(uint256);
39 
40     function transfer(address to, uint256 value) public returns(bool);
41 
42     function allowance(address owner, address spender) public view returns(uint256);
43 
44     function transferFrom(address from, address to, uint256 value) public returns(bool);
45 
46     function approve(address spender, uint256 value) public returns(bool);
47 
48     event Transfer(address indexed from, address indexed to, uint256 value);
49     event Approval(address indexed owner, address indexed spender, uint256 value);
50 }
51 
52 /**
53  * @title Standard ERC20 token
54  *
55  * @dev Implementation of the basic standard token.
56  */
57 contract StandardToken is ERC20 {
58     using SafeMath
59     for uint256;
60 
61     mapping(address => uint256) balances;
62     mapping(address => mapping(address => uint256)) allowed;
63 
64 
65     /**
66      * @dev Gets the balance of the specified address.
67      * @param _owner The address to query the the balance of.
68      * @return An uint256 representing the amount owned by the passed address.
69      */
70     function balanceOf(address _owner) public view returns(uint256 balance) {
71         return balances[_owner];
72     }
73 
74     /**
75      * @dev transfer token for a specified address
76      * @param _to The address to transfer to.
77      * @param _value The amount to be transferred.
78      */
79     function transfer(address _to, uint256 _value) public returns(bool) {
80         require(_to != address(0));
81 
82         // SafeMath.sub will throw if there is not enough balance.
83         balances[msg.sender] = balances[msg.sender].sub(_value);
84         balances[_to] = balances[_to].add(_value);
85         emit Transfer(msg.sender, _to, _value);
86         return true;
87     }
88 
89     /**
90      * @dev Transfer tokens from one address to another
91      * @param _from address The address which you want to send tokens from
92      * @param _to address The address which you want to transfer to
93      * @param _value uint256 the amount of tokens to be transferred
94      */
95     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
96         require(_value <= balances[_from]);
97         require(_value <= allowed[_from][msg.sender]);
98         require(_to != address(0));
99 
100         balances[_from] = balances[_from].sub(_value);
101         balances[_to] = balances[_to].add(_value);
102         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
103         emit Transfer(_from, _to, _value);
104         return true;
105     }
106 
107     /**
108      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
109      * @param _spender The address which will spend the funds.
110      * @param _value The amount of tokens to be spent.
111      */
112     function approve(address _spender, uint256 _value) public returns(bool) {
113         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
114         allowed[msg.sender][_spender] = _value;
115         emit Approval(msg.sender, _spender, _value);
116         return true;
117     }
118 
119     /**
120      * @dev Function to check the amount of tokens that an owner allowed to a spender.
121      * @param _owner address The address which owns the funds.
122      * @param _spender address The address which will spend the funds.
123      * @return A uint256 specifying the amount of tokens still available for the spender.
124      */
125     function allowance(address _owner, address _spender) public view returns(uint256 remaining) {
126         return allowed[_owner][_spender];
127     }
128 }
129 
130 contract ICWToken is StandardToken {
131     string public constant name = "Intelligent Car Washing Token";
132     string public constant symbol = "ICWT";
133     uint8 public constant decimals = 18;
134     uint256 public constant INITIAL_SUPPLY = 20000000000 * (10 ** uint256(decimals));
135 
136     // contributors address
137     address public contributorsAddress = 0x42cd691a49e8FF418528Fe906553B002846dE3cf;
138     // company address
139     address public companyAddress = 0xf9C722e5c7c3313BBcD80e9A78e055391f75C732;
140     // market Address 
141     address public marketAddress = 0xbd2F5D1975ccE83dfbf2B5743B1F8409CF211f90;
142     // ICO Address 
143     address public icoAddress = 0xe26E3a77cA40b3e04C64E29f6c076Eec25a66E76;
144 
145     // the share of contributors
146     uint8 public constant CONTRIBUTORS_SHARE = 30;
147     // the share of company
148     uint8 public constant COMPANY_SHARE = 20;
149     // the share of market
150     uint8 public constant MARKET_SHARE = 30;
151     // the share of ICO
152     uint8 public constant ICO_SHARE = 20;
153     /**
154      * Constructor that gives four address all existing tokens.
155      */
156     constructor() public {
157         totalSupply = INITIAL_SUPPLY;
158         uint256 valueContributorsAddress = INITIAL_SUPPLY.mul(CONTRIBUTORS_SHARE).div(100);
159         balances[contributorsAddress] = valueContributorsAddress;
160         emit Transfer(address(0), contributorsAddress, valueContributorsAddress);
161 
162         uint256 valueCompanyAddress = INITIAL_SUPPLY.mul(COMPANY_SHARE).div(100);
163         balances[companyAddress] = valueCompanyAddress;
164         emit Transfer(address(0), companyAddress, valueCompanyAddress);
165 
166         uint256 valueMarketAddress = INITIAL_SUPPLY.mul(MARKET_SHARE).div(100);
167         balances[marketAddress] = valueMarketAddress;
168         emit Transfer(address(0), marketAddress, valueMarketAddress);
169 
170         uint256 valueIcoAddress = INITIAL_SUPPLY.mul(ICO_SHARE).div(100);
171         balances[icoAddress] = valueIcoAddress;
172         emit Transfer(address(0), icoAddress, valueIcoAddress);
173 
174     }
175 }