1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Standard ERC20 token
5  *
6  * @dev Implementation of the basic standard token.
7  * @dev https://github.com/ethereum/EIPs/issues/20
8  */
9 contract StandardToken {
10 
11     mapping (address => mapping (address => uint256)) internal allowed;
12     mapping(address => uint256) balances;
13     uint256 totalSupply_;
14 
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Approval(address indexed owner, address indexed spender, uint256 value);
17 
18     /**
19     * @dev total number of tokens in existence
20     */
21     function totalSupply() public view returns (uint256) {
22         return totalSupply_;
23     }
24 
25     /**
26     * @dev transfer token for a specified address
27     * @param _to The address to transfer to.
28     * @param _value The amount to be transferred.
29     */
30     function transfer(address _to, uint256 _value) public returns (bool) {
31         require(_to != address(0));
32         require(_value <= balances[msg.sender]);
33 
34         // SafeMath.sub will throw if there is not enough balance.
35         balances[msg.sender] -= _value;
36         balances[_to] += _value;
37         Transfer(msg.sender, _to, _value);
38         return true;
39     }
40 
41     /**
42     * @dev Gets the balance of the specified address.
43     * @param _owner The address to query the the balance of.
44     * @return An uint256 representing the amount owned by the passed address.
45     */
46     function balanceOf(address _owner) public view returns (uint256 balance) {
47         return balances[_owner];
48     }
49 
50     /**
51     * @dev Transfer tokens from one address to another
52     * @param _from address The address which you want to send tokens from
53     * @param _to address The address which you want to transfer to
54     * @param _value uint256 the amount of tokens to be transferred
55     */
56     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
57         require(_to != address(0));
58         require(_value <= balances[_from]);
59         require(_value <= allowed[_from][msg.sender]);
60 
61         balances[_from] -= _value;
62         balances[_to] += _value;
63         allowed[_from][msg.sender] -= _value;
64         Transfer(_from, _to, _value);
65         return true;
66     }
67 
68     /**
69     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
70     *
71     * Beware that changing an allowance with this method brings the risk that someone may use both the old
72     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
73     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
74     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75     * @param _spender The address which will spend the funds.
76     * @param _value The amount of tokens to be spent.
77     */
78     function approve(address _spender, uint256 _value) public returns (bool) {
79         allowed[msg.sender][_spender] = _value;
80         Approval(msg.sender, _spender, _value);
81         return true;
82     }
83 
84     /**
85     * @dev Function to check the amount of tokens that an owner allowed to a spender.
86     * @param _owner address The address which owns the funds.
87     * @param _spender address The address which will spend the funds.
88     * @return A uint256 specifying the amount of tokens still available for the spender.
89     */
90     function allowance(address _owner, address _spender) public view returns (uint256) {
91         return allowed[_owner][_spender];
92     }
93 
94     /**
95     * @dev Increase the amount of tokens that an owner allowed to a spender.
96     *
97     * approve should be called when allowed[_spender] == 0. To increment
98     * allowed value is better to use this function to avoid 2 calls (and wait until
99     * the first transaction is mined)
100     * From MonolithDAO Token.sol
101     * @param _spender The address which will spend the funds.
102     * @param _addedValue The amount of tokens to increase the allowance by.
103     */
104     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
105         allowed[msg.sender][_spender] += _addedValue;
106         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
107         return true;
108     }
109 
110     /**
111     * @dev Decrease the amount of tokens that an owner allowed to a spender.
112     *
113     * approve should be called when allowed[_spender] == 0. To decrement
114     * allowed value is better to use this function to avoid 2 calls (and wait until
115     * the first transaction is mined)
116     * From MonolithDAO Token.sol
117     * @param _spender The address which will spend the funds.
118     * @param _subtractedValue The amount of tokens to decrease the allowance by.
119     */
120     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
121         uint oldValue = allowed[msg.sender][_spender];
122         if (_subtractedValue > oldValue) {
123             allowed[msg.sender][_spender] = 0;
124         } else {
125             allowed[msg.sender][_spender] = oldValue - _subtractedValue;
126         }
127         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
128         return true;
129     }
130 
131 }
132 
133 /**
134  * @title TiValue token
135  *
136  * For more information about TiValue, please visit http://t.top
137  * @author Yangyu - <yangyu@pulsar>
138  */
139 contract TiValueToken is StandardToken {
140     string public constant NAME = "TiValue";
141     string public constant SYMBOL = "TV";
142     uint public constant DECIMALS = 5;
143     uint256 public constant INITIAL_SUPPLY = 21000000000000;
144 
145     function TiValueToken() public {
146         totalSupply_ = INITIAL_SUPPLY;
147         balances[msg.sender] = INITIAL_SUPPLY;
148     }
149 }