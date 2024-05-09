1 pragma solidity ^0.4.4;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal constant returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal constant returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 /**
35  * @title ERC20Basic
36  * @dev Simpler version of ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/179
38  */
39 contract ERC20Basic {
40     uint256 public totalSupply;
41     function balanceOf(address who) constant returns (uint256);
42     function transfer(address to, uint256 value) returns (bool);
43     event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 /**
47  * @title ERC20 interface
48  * @dev see https://github.com/ethereum/EIPs/issues/20
49  */
50 contract ERC20 is ERC20Basic {
51     function allowance(address owner, address spender) constant returns (uint256);
52     function transferFrom(address from, address to, uint256 value) returns (bool);
53     function approve(address spender, uint256 value) returns (bool);
54     event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 /**
58  * @title Basic token
59  * @dev Basic version of StandardToken, with no allowances.
60  */
61 contract BasicToken is ERC20Basic {
62     using SafeMath for uint256;
63 
64     mapping(address => uint256) balances;
65 
66     /**
67     * @dev transfer token for a specified address
68     * @param _to The address to transfer to.
69     * @param _value The amount to be transferred.
70     */
71     function transfer(address _to, uint256 _value) returns (bool) {
72         balances[msg.sender] = balances[msg.sender].sub(_value);
73         balances[_to] = balances[_to].add(_value);
74         Transfer(msg.sender, _to, _value);
75         return true;
76     }
77 
78     /**
79     * @dev Gets the balance of the specified address.
80     * @param _owner The address to query the the balance of.
81     * @return An uint256 representing the amount owned by the passed address.
82     */
83     function balanceOf(address _owner) constant returns (uint256 balance) {
84         return balances[_owner];
85     }
86 
87 }
88 
89 /**
90  * @title Standard ERC20 token
91  *
92  * @dev Implementation of the basic standard token.
93  * @dev https://github.com/ethereum/EIPs/issues/20
94  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
95  */
96 contract StandardToken is ERC20, BasicToken {
97 
98     mapping (address => mapping (address => uint256)) allowed;
99 
100 
101     /**
102      * @dev Transfer tokens from one address to another
103      * @param _from address The address which you want to send tokens from
104      * @param _to address The address which you want to transfer to
105      * @param _value uint256 the amout of tokens to be transfered
106      */
107     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
108         var _allowance = allowed[_from][msg.sender];
109 
110         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
111         // require (_value <= _allowance);
112 
113         balances[_to] = balances[_to].add(_value);
114         balances[_from] = balances[_from].sub(_value);
115         allowed[_from][msg.sender] = _allowance.sub(_value);
116         Transfer(_from, _to, _value);
117         return true;
118     }
119 
120     /**
121      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
122      * @param _spender The address which will spend the funds.
123      * @param _value The amount of tokens to be spent.
124      */
125     function approve(address _spender, uint256 _value) returns (bool) {
126 
127         // To change the approve amount you first have to reduce the addresses`
128         //  allowance to zero by calling `approve(_spender, 0)` if it is not
129         //  already 0 to mitigate the race condition described here:
130         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
131         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
132 
133         allowed[msg.sender][_spender] = _value;
134         Approval(msg.sender, _spender, _value);
135         return true;
136     }
137 
138     /**
139      * @dev Function to check the amount of tokens that an owner allowed to a spender.
140      * @param _owner address The address which owns the funds.
141      * @param _spender address The address which will spend the funds.
142      * @return A uint256 specifing the amount of tokens still avaible for the spender.
143      */
144     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
145         return allowed[_owner][_spender];
146     }
147 
148 }
149 
150 /**
151  * @title WIT is Standard ERC20 token
152  */
153 contract WIT is StandardToken {
154 
155     string public name = 'WIT';
156     string public symbol = 'WIT';
157     uint public decimals = 4;
158     uint public INITIAL_SUPPLY = 2000000000000;
159 
160     /* This notifies clients about the amount Destroy */
161     event Destroy(address indexed from, uint256 value);
162 
163     function WIT() {
164         totalSupply = INITIAL_SUPPLY;
165         balances[msg.sender] = INITIAL_SUPPLY;
166     }
167 
168     function destroy(uint256 _value) returns (bool) {
169 
170         balances[msg.sender] = balances[msg.sender].sub(_value);
171         totalSupply = totalSupply.sub(_value);
172         Destroy(msg.sender, _value);
173         return true;
174     }
175 
176 }