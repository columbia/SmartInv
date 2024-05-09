1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         // uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return a / b;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43         c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 /**
49  * @title KVANTOR ERC20 token
50  *
51  * @dev Implementation of the basic standard token.
52  * @dev https://github.com/ethereum/EIPs/issues/20
53  */
54 contract KvantorToken {
55     using SafeMath for uint256;
56 
57     string public name = "KVANTOR";
58     string public symbol = "KVT";
59     uint public decimals = 8;
60 
61     address public owner;
62 
63     mapping (address => mapping (address => uint256)) internal allowed;
64     uint256 internal totalSupply_;
65     mapping(address => uint256) internal balances;
66 
67     event Approval(address indexed owner, address indexed spender, uint256 value);
68     event Transfer(address indexed from, address indexed to, uint256 value);
69 
70     function KvantorToken() public {
71         totalSupply_ = 10000000000000000;
72         balances[msg.sender] = totalSupply_;
73         owner = msg.sender;
74     }
75 
76     /**
77     * @dev total number of tokens in existence
78     */
79     function totalSupply() public view returns (uint256) {
80         return totalSupply_;
81     }
82 
83     /**
84     * @dev Gets the balance of the specified address.
85     * @param _owner The address to query the the balance of.
86     * @return An uint256 representing the amount owned by the passed address.
87     */
88     function balanceOf(address _owner) public view returns (uint256) {
89         return balances[_owner];
90     }
91 
92           /**
93     * @dev Check is certain transer allowed
94     * main rule is "all transfers is prohibited till 27.09.2018 00:00:00 UTC+3
95     * The only exceptional rule -"KVANTOR smartcontract creator's account is allowed to transfer token to buyers' account at anytime"
96     */
97     function isTransferAllowed(address sender) public constant returns (bool) {
98         if(sender == owner)
99         return true;
100         // 27.09.2018 00:00:00 UTC+3 = 1537995600 timestamp
101         if(now > 1537995599)
102           return true;
103         else
104         return false;
105     }
106 
107     /**
108     * @dev transfer token for a specified address
109     * @param _to The address to transfer to.
110     * @param _value The amount to be transferred.
111     */
112     function transfer(address _to, uint256 _value) public returns (bool) {
113         require(_to != address(0));
114         require(_value <= balances[msg.sender]);
115         require(isTransferAllowed(msg.sender));
116 
117         balances[msg.sender] = balances[msg.sender].sub(_value);
118         balances[_to] = balances[_to].add(_value);
119         emit Transfer(msg.sender, _to, _value);
120         return true;
121     }
122 
123     /**
124      * @dev Transfer tokens from one address to another
125      * @param _from address The address which you want to send tokens from
126      * @param _to address The address which you want to transfer to
127      * @param _value uint256 the amount of tokens to be transferred
128      */
129     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
130         require(_to != address(0));
131         require(_value <= balances[_from]);
132         require(_value <= allowed[_from][msg.sender]);
133         require(_to != address(0));
134         require(isTransferAllowed(_from));
135 
136         balances[_from] = balances[_from].sub(_value);
137         balances[_to] = balances[_to].add(_value);
138         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
139         emit Transfer(_from, _to, _value);
140         return true;
141     }
142 
143 
144 
145 
146     /**
147      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
148      *
149      * Beware that changing an allowance with this method brings the risk that someone may use both the old
150      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
151      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
152      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153      * @param _spender The address which will spend the funds.
154      * @param _value The amount of tokens to be spent.
155      */
156     function approve(address _spender, uint256 _value) public returns (bool) {
157         allowed[msg.sender][_spender] = _value;
158         emit Approval(msg.sender, _spender, _value);
159         return true;
160     }
161 
162     /**
163      * @dev Function to check the amount of tokens that an owner allowed to a spender.
164      * @param _owner address The address which owns the funds.
165      * @param _spender address The address which will spend the funds.
166      * @return A uint256 specifying the amount of tokens still available for the spender.
167      */
168     function allowance(address _owner, address _spender) public view returns (uint256) {
169         return allowed[_owner][_spender];
170     }
171 
172     /**
173      * @dev Increase the amount of tokens that an owner allowed to a spender.
174      *
175      * approve should be called when allowed[_spender] == 0. To increment
176      * allowed value is better to use this function to avoid 2 calls (and wait until
177      * the first transaction is mined)
178      * @param _spender The address which will spend the funds.
179      * @param _addedValue The amount of tokens to increase the allowance by.
180      */
181     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
182         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
183         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
184         return true;
185     }
186 
187     /**
188      * @dev Decrease the amount of tokens that an owner allowed to a spender.
189      *
190      * approve should be called when allowed[_spender] == 0. To decrement
191      * allowed value is better to use this function to avoid 2 calls (and wait until
192      * the first transaction is mined)
193      * @param _spender The address which will spend the funds.
194      * @param _subtractedValue The amount of tokens to decrease the allowance by.
195      */
196     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
197         uint oldValue = allowed[msg.sender][_spender];
198         if (_subtractedValue > oldValue) {
199             allowed[msg.sender][_spender] = 0;
200         } else {
201             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
202         }
203         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
204         return true;
205     }
206 
207 }