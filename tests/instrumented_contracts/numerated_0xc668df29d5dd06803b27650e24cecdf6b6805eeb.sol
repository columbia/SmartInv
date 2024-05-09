1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4     /**
5     * @dev Multiplies two numbers, throws on overflow.
6     */
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         if (a == 0) {
9             return 0;
10         }
11         uint256 c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15 
16     /**
17     * @dev Integer division of two numbers, truncating the quotient.
18     */
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         // assert(b > 0); // Solidity automatically throws when dividing by 0
21         uint256 c = a / b;
22         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23         return c;
24     }
25 
26     /**
27     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
28     */
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         assert(b <= a);
31         return a - b;
32     }
33 
34     /**
35     * @dev Adds two numbers, throws on overflow.
36     */
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         assert(c >= a && c >= b);
40         return c;
41     }
42 }
43 
44 
45 contract UPEXCoin {
46     using SafeMath for uint256;
47 
48     // Public variables of the token
49     string public name;
50     string public symbol;
51     uint8 public decimals;
52 
53     mapping (address => mapping (address => uint256)) internal allowed;
54     mapping(address => uint256) balances;
55 
56     uint256 totalSupply_;
57 
58     event Transfer(address indexed from, address indexed to, uint256 value);
59     event Approval(address indexed owner, address indexed spender, uint256 value);
60     event Burn(address indexed burner, uint256 value);
61 
62     function UPEXCoin() public {
63         decimals = 18;
64         totalSupply_ = 100 * 100000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
65         balances[msg.sender] = totalSupply_;                // Give the creator all initial tokens
66         name = "Upex Coin";                                   // Set the name for display purposes
67         symbol = "UPEX";                               // Set the symbol for display purposes
68     }
69 
70     /**
71     * @dev total number of tokens in existence
72     */
73     function totalSupply() public view returns (uint256) {
74         return totalSupply_;
75     }
76 
77     /**
78     * @dev transfer token for a specified address
79     * @param _to The address to transfer to.
80     * @param _value The amount to be transferred.
81     */
82     function transfer(address _to, uint256 _value) public returns (bool) {
83         require(_to != address(0));
84         require(_value > 0);
85         require(_value <= balances[msg.sender]);
86 
87         // SafeMath.sub will throw if there is not enough balance.
88         balances[msg.sender] = balances[msg.sender].sub(_value);
89         balances[_to] = balances[_to].add(_value);
90         emit Transfer(msg.sender, _to, _value);
91         return true;
92     }
93 
94     /**
95     * @dev Gets the balance of the specified address.
96     * @param _owner The address to query the the balance of.
97     * @return An uint256 representing the amount owned by the passed address.
98     */
99     function balanceOf(address _owner) public view returns (uint256 balance) {
100         return balances[_owner];
101     }
102 
103     /**
104      * @dev Transfer tokens from one address to another
105      * @param _from address The address which you want to send tokens from
106      * @param _to address The address which you want to transfer to
107      * @param _value uint256 the amount of tokens to be transferred
108      */
109     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
110         require(_to != address(0));
111         require(_value > 0);
112         require(_value <= balances[_from]);
113         require(_value <= allowed[_from][msg.sender]);
114 
115         balances[_from] = balances[_from].sub(_value);
116         balances[_to] = balances[_to].add(_value);
117         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
118         emit Transfer(_from, _to, _value);
119         return true;
120     }
121 
122     /**
123      * @dev Burns a specific amount of tokens.
124      * @param _value The amount of token to be burned.
125      */
126     function burn(uint256 _value) public {
127         require(_value <= balances[msg.sender]);
128         // no need to require value <= totalSupply, since that would imply the
129         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
130 
131         address burner = msg.sender;
132         balances[burner] = balances[burner].sub(_value);
133         totalSupply_ = totalSupply_.sub(_value);
134         emit Burn(burner, _value);
135         emit Transfer(burner, address(0), _value);
136     }
137 
138     /**
139      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
140      *
141      * Beware that changing an allowance with this method brings the risk that someone may use both the old
142      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
143      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
144      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145      * @param _spender The address which will spend the funds.
146      * @param _value The amount of tokens to be spent.
147      */
148     function approve(address _spender, uint256 _value) public returns (bool) {
149         allowed[msg.sender][_spender] = _value;
150         emit Approval(msg.sender, _spender, _value);
151         return true;
152     }
153 
154     /**
155      * @dev Function to check the amount of tokens that an owner allowed to a spender.
156      * @param _owner address The address which owns the funds.
157      * @param _spender address The address which will spend the funds.
158      * @return A uint256 specifying the amount of tokens still available for the spender.
159      */
160     function allowance(address _owner, address _spender) public view returns (uint256) {
161         return allowed[_owner][_spender];
162     }
163 }