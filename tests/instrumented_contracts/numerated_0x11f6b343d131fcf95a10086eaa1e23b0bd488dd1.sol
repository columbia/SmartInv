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
56  * @dev https://github.com/ethereum/EIPs/issues/20
57  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
58  */
59 contract StandardToken is ERC20 {
60     using SafeMath
61     for uint256;
62 
63     mapping(address => uint256) balances;
64     mapping(address => mapping(address => uint256)) allowed;
65 
66 
67     /**
68      * @dev Gets the balance of the specified address.
69      * @param _owner The address to query the the balance of.
70      * @return An uint256 representing the amount owned by the passed address.
71      */
72     function balanceOf(address _owner) public view returns(uint256 balance) {
73         return balances[_owner];
74     }
75 
76     /**
77      * @dev transfer token for a specified address
78      * @param _to The address to transfer to.
79      * @param _value The amount to be transferred.
80      */
81     function transfer(address _to, uint256 _value) public returns(bool) {
82         require(_to != address(0));
83 
84         // SafeMath.sub will throw if there is not enough balance.
85         balances[msg.sender] = balances[msg.sender].sub(_value);
86         balances[_to] = balances[_to].add(_value);
87         emit Transfer(msg.sender, _to, _value);
88         return true;
89     }
90 
91     /**
92      * @dev Transfer tokens from one address to another
93      * @param _from address The address which you want to send tokens from
94      * @param _to address The address which you want to transfer to
95      * @param _value uint256 the amount of tokens to be transferred
96      */
97     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
98         require(_value <= balances[_from]);
99         require(_value <= allowed[_from][msg.sender]);
100         require(_to != address(0));
101 
102         balances[_from] = balances[_from].sub(_value);
103         balances[_to] = balances[_to].add(_value);
104         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
105         emit Transfer(_from, _to, _value);
106         return true;
107     }
108 
109     /**
110      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
111      * @param _spender The address which will spend the funds.
112      * @param _value The amount of tokens to be spent.
113      */
114     function approve(address _spender, uint256 _value) public returns(bool) {
115         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
116         allowed[msg.sender][_spender] = _value;
117         emit Approval(msg.sender, _spender, _value);
118         return true;
119     }
120 
121     /**
122      * @dev Function to check the amount of tokens that an owner allowed to a spender.
123      * @param _owner address The address which owns the funds.
124      * @param _spender address The address which will spend the funds.
125      * @return A uint256 specifying the amount of tokens still available for the spender.
126      */
127     function allowance(address _owner, address _spender) public view returns(uint256 remaining) {
128         return allowed[_owner][_spender];
129     }
130 }
131 
132 contract PPCToken is StandardToken {
133     string public constant name = "PurpleChain";
134     string public constant symbol = "PPC";
135     uint8 public constant decimals = 18;
136     uint256 public constant INITIAL_SUPPLY = 20000000000 * (10 ** uint256(decimals));
137     // market Address 
138     address public marketAddress = 0x3172f12a77402BB52001A766E1d09b573967De61;
139     /**
140      * Constructor that gives three address all existing tokens.
141      */
142     constructor() public {
143         totalSupply = INITIAL_SUPPLY;
144         balances[marketAddress] = totalSupply;
145         emit Transfer(address(0), marketAddress, totalSupply);
146     }
147 }