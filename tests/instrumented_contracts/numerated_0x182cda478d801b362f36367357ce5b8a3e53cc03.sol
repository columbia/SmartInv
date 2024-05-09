1 pragma solidity ^0.4.16;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8     uint256 public totalSupply;
9     function balanceOf(address who) public constant returns (uint256);
10     function transfer(address to, uint256 value) public returns (bool);
11     event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 /**
14  * @title SafeMath
15  * @dev Math operations with safety checks that throw on error
16  */
17 library SafeMath {
18     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19         uint256 c = a * b;
20         assert(a == 0 || c / a == b);
21         return c;
22     }
23     function div(uint256 a, uint256 b) internal pure returns (uint256) {
24         // assert(b > 0); // Solidity automatically throws when dividing by 0
25         uint256 c = a / b;
26         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27         return c;
28     }
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         assert(b <= a);
31         return a - b;
32     }
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         assert(c >= a);
36         return c;
37     }
38 }
39 /**
40  * @title Basic token
41  * @dev Basic version of StandardToken, with no allowances.
42  */
43 contract BasicToken is ERC20Basic {
44     using SafeMath for uint256;
45     mapping(address => uint256) balances;
46   /**
47   * @dev transfer token for a specified address
48   * @param _to The address to transfer to.
49   * @param _value The amount to be transferred.
50   */
51     function transfer(address _to, uint256 _value) public returns (bool) {
52         require(_to != address(0));
53         require(_value <= balances[msg.sender]);
54     // SafeMath.sub will throw if there is not enough balance.
55         balances[msg.sender] = balances[msg.sender].sub(_value);
56         balances[_to] = balances[_to].add(_value);
57         Transfer(msg.sender, _to, _value);
58         return true;
59     }
60   /**
61   * @dev Gets the balance of the specified address.
62   * @param _owner The address to query the the balance of.
63   * @return An uint256 representing the amount owned by the passed address.
64   */
65     function balanceOf(address _owner) public constant returns (uint256 balance) {
66         return balances[_owner];
67     }
68 }
69 /**
70  * @title ERC20 interface
71  * @dev see https://github.com/ethereum/EIPs/issues/20
72  */
73 contract ERC20 is ERC20Basic {
74     function allowance(address owner, address spender) public constant returns (uint256);
75     function transferFrom(address from, address to, uint256 value) public returns (bool);
76     function approve(address spender, uint256 value) public returns (bool);
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 /**
80  * @title Standard ERC20 token
81  *
82  * @dev Implementation of the basic standard token.
83  * @dev https://github.com/ethereum/EIPs/issues/20
84  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
85  */
86 contract StandardToken is ERC20, BasicToken {
87     mapping (address => mapping (address => uint256)) internal allowed;
88   /**
89    * @dev Transfer tokens from one address to another
90    * @param _from address The address which you want to send tokens from
91    * @param _to address The address which you want to transfer to
92    * @param _value uint256 the amount of tokens to be transferred
93    */
94     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
95         require(_to != address(0));
96         require(_value <= balances[_from]);
97         require(_value <= allowed[_from][msg.sender]);
98         balances[_from] = balances[_from].sub(_value);
99         balances[_to] = balances[_to].add(_value);
100         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
101         Transfer(_from, _to, _value);
102         return true;
103     }
104   /**
105    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
106    *
107    * Beware that changing an allowance with this method brings the risk that someone may use both the old
108    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
109    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
110    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
111    * @param _spender The address which will spend the funds.
112    * @param _value The amount of tokens to be spent.
113    */
114     function approve(address _spender, uint256 _value) public returns (bool) {
115         allowed[msg.sender][_spender] = _value;
116         Approval(msg.sender, _spender, _value);
117         return true;
118     }
119   /**
120    * @dev Function to check the amount of tokens that an owner allowed to a spender.
121    * @param _owner address The address which owns the funds.
122    * @param _spender address The address which will spend the funds.
123    * @return A uint256 specifying the amount of tokens still available for the spender.
124    */
125     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
126         return allowed[_owner][_spender];
127     }
128   /**
129    * approve should be called when allowed[_spender] == 0. To increment
130    * allowed value is better to use this function to avoid 2 calls (and wait until
131    * the first transaction is mined)
132    * From MonolithDAO Token.sol
133    */
134     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
135         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
136         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
137         return true;
138     }
139     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
140         uint oldValue = allowed[msg.sender][_spender];
141         if (_subtractedValue > oldValue) {
142             allowed[msg.sender][_spender] = 0;
143         } else {
144             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
145         }
146         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
147         return true;
148     }
149 }
150 /**
151  * @title Atrix
152  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
153  * Note they can later distribute these tokens as they wish using `transfer` and other
154  * `StandardToken` functions.
155  */
156 contract Atrix is StandardToken {
157     string public constant name = "Atrix";
158     string public constant symbol = "ATRIX";
159     uint8 public constant decimals = 18;
160     uint256 public constant INITIAL_SUPPLY = 45000000 * (10 ** uint256(decimals));
161   /**
162    * @dev Constructor that gives msg.sender all of existing tokens.
163    */
164     function Atrix() {
165         totalSupply = INITIAL_SUPPLY;
166         balances[msg.sender] = INITIAL_SUPPLY;
167     }
168 }